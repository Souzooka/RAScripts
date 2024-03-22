// Simple 2000 Series Vol. 95: The Zombie vs. Kyuukyuusha | Zombie Virus
// #ID = 28924

NULL = 0
True = 1
False = 0

RegionByte = byte(0x1034E1)
REGION_EU = 0
REGION_JP = 1
EU = REGION_EU
JP = REGION_JP
Regions = [EU, JP]

function IsRegion(region)
{
    return RegionByte == region
}

function GetRealAddress(eu_address, jp_address)
{
    // Calculates a regional memory offset, then calculates the actual address
    // we want to use for this region based off a constant 0/1 byte that varies by region.
    jp_offset = jp_address - eu_address
    return eu_address + (jp_offset * RegionByte)
}

ACC_MIRROR = 0
ACC_PREV = 1
ACC_PRIOR = 2

_mirror = v => v
function GetAccessor(acc)
{
    table = {
        ACC_MIRROR: _mirror,
        ACC_PREV: prev,
        ACC_PRIOR: prior,
    }
    return table[acc]
}

CurrGameState = dword(GetRealAddress(0x206D18, 0x204918))

// NOTE: Subtract 1 from each of these values for JP version (and VideoModeSelect does not exist)
EGameState_VideoModeSelect = 0
EGameState_MemoryCardCheck = 1
EGameState_MPEG = 2
EGameState_Title = 4
EGameState_Load = 5
EGameState_Drive = 6
EGameState_Walk = 8
EGameState_Cutscene = 9

function GetGameState()
{
    // Adds 1 to the game state if this is the JP version, to align with the values above.
    return CurrGameState + RegionByte
}

pComboCount = GetRealAddress(0x401270, 0x3F44E0)
ComboCount = dword(dword(pComboCount) + 0x9C)
KillCount = dword(GetRealAddress(0x20BCE0, 0x206FA0))
Survivors = []
for i in range(0, 5)
{
    array_push(Survivors, dword(GetRealAddress(0x20BC00 + i * 4, 0x206EC0 + i * 4)))
}

function GetNumSurvivors(acc=ACC_MIRROR)
{
    accessor = GetAccessor(acc)
    return sum_of(Survivors, accessor)
}

function _IsWalkLoad()
{
    // Checks Walk's substate?
    // This value is 4 when in the load menu in the hospital basement.
    pointer = dword(GetRealAddress(0x20C28C, 0x20754C))
    val = dword(pointer + 0x474)
    return pointer != NULL && val == 4
}

function LoadProtection()
{
    // There's two ways you can load a save file.
    // 1. Load the save file from the title menu. Easy to check for.
    // 2. Load the save file from the NPC in the hospital basement; a bit more complicated.
    return GetGameState() > EGameState_Load &&
           (GetGameState() != EGameState_Walk || !_IsWalkLoad())
}

// RICH PRESENCE START

TitleLookup = {
    EU: "Zombie Virus",
    JP: "THE ゾンビ V.S. 救急車",
}

rich_presence_conditional_display(
    GetGameState() <= EGameState_Load,
    "{0} | In the title or loading screen",
    rich_presence_lookup("Title", RegionByte, TitleLookup)
)
rich_presence_conditional_display(
    GetGameState() == EGameState_Cutscene,
    "{0} | Watching a cutscene",
    rich_presence_lookup("Title", RegionByte, TitleLookup)
)
// TODO: Very basic -- maybe add some stats like total zombies killed or playtime?
rich_presence_conditional_display(
    GetGameState() == EGameState_Walk,
    "{0} | Walking around the basement of the Sunlight Medical Center",
    rich_presence_lookup("Title", RegionByte, TitleLookup)
)
// TODO: Very basic -- add stats like chosen car, area, and parts
rich_presence_conditional_display(
    GetGameState() == EGameState_Drive,
    "{0} | Driving around Sunlight City and seeking out survivors",
    rich_presence_lookup("Title", RegionByte, TitleLookup)
)
rich_presence_conditional_display(
    any_of(Regions, region => IsRegion(region)),
    "Playing {0}",
    rich_presence_lookup("Title", RegionByte, TitleLookup)
)
rich_presence_display("Playing Simple 2000 Series Vol. 95: The Zombie vs. Kyuukyuusha | Zombie Virus")

// RICH PRESENCE END

// LEADERBOARDS START

function ComboStart()
{
    return pComboCount != NULL && 
           ComboCount >= 100 &&
           prev(ComboCount) < 100
}

function ComboCancel()
{
    // 999 is the highest legitimate value!
    return pComboCount == NULL || ComboCount > 999
}

function ComboSubmit()
{
    return ComboCount == 0 && prev(ComboCount) != 0
}

function ComboValue()
{
    return prev(ComboCount)   
}

leaderboard(
    id=92357,
    title="Highest Kill Combo",
    description="Obtain the highest kill combo (minimum 100)!",
    start=ComboStart(),
    cancel=ComboCancel(),
    submit=ComboSubmit(),
    value=ComboValue(),
    format="VALUE"
)

// LEADERBOARDS END

// ACHIEVEMENTS START

function ComboTrigger(start, end)
{
    return pComboCount != NULL &&
           ComboCount >= start &&
           trigger_when(ComboCount >= end && prev(ComboCount) < end)
}

achievement(
    title="Good!! Zombie Killer!",
    description="Obtain a combo kill count of 5.",
    points=1,
    trigger=ComboTrigger(1, 5)
)

achievement(
    title="Great!! Zombie Hunter!",
    description="Obtain a combo kill count of 10.",
    points=2,
    trigger=ComboTrigger(5, 10)
)

achievement(
    title="Excellent!! Zombie Assassin!",
    description="Obtain a combo kill count of 20.",
    points=3,
    trigger=ComboTrigger(10, 20)
)

achievement(
    title="Fantastic!! Zombie Genocider!",
    description="Obtain a combo kill count of 50.",
    points=5,
    trigger=ComboTrigger(20, 50)
)

achievement(
    title="It's Crazy!! Zombie's Demise!",
    description="Obtain a combo kill count of 100.",
    points=10,
    trigger=ComboTrigger(50, 100)
)

achievement(
    title="Zombie Decimator",
    description="Kill 535.94 zombies.",
    points=5,
    trigger=LoadProtection() && 
            prev(KillCount) < 536 && 
            KillCount >= 536
)

achievement(
    title="A Light in the Darkness",
    description="Locate and rescue your first survivor.",
    points=1,
    trigger=LoadProtection() &&
            GetNumSurvivors(ACC_PREV) == 0 &&
            GetNumSurvivors() > 0
)

// ACHIEVEMENTS END

