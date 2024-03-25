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
EGameState_AttackModeResult = 0xA

function GetGameState(acc=ACC_MIRROR)
{
    accessor = GetAccessor(acc)

    // Adds 1 to the game state if this is the JP version, to align with the values above.
    return accessor(CurrGameState) + RegionByte
}

LastWalkMenu = dword(GetRealAddress(0x20C0FC, 0x2073BC))

EWalkMenu_Advice = 0
EWalkMenu_Status = 1
EWalkMenu_Develop = 2
EWalkMenu_Custom = 3
EWalkMenu_System = 4

WalkStateData = dword(GetRealAddress(0x20C28C, 0x20754C))
DriveStateData = dword(GetRealAddress(0x401270, 0x3F44E0))

ComboCount = dword(DriveStateData + 0x9C)
KillCount = dword(GetRealAddress(0x20BCE0, 0x206FA0))
Survivors = []
for i in range(0, 5)
{
    array_push(Survivors, dword(GetRealAddress(0x20BC00 + i * 4, 0x206EC0 + i * 4)))
}

ESurvivor_MaleCitizen = 0
ESurvivor_FemaleCitizen = 1
ESurvivor_Soldier = 2
ESurvivor_PoliceOfficer = 3
ESurvivor_Mechanic = 4
ESurvivor_Politician = 5

AreaID = dword(GetRealAddress(0x20BF24, 0x2071E4))

function GetVehicleParts()
{
    vehicle = dword(GetRealAddress(0x20BD00, 0x206FC0))
    parts = [vehicle]
    offsets = [
        0x390, // Engine
        0x38C, // Tire
        0x3A4, // Bumper
        0x39C, // Lights
    ]
    
    for offset in offsets
    {
        part = dword(DriveStateData + 0x4)
        part = dword(part + offset)
        part = dword(part + 0x2E0)
        array_push(parts, part)
    }
    
    return parts
}
_parts = GetVehicleParts()
VehicleType = _parts[0]
EngineType = _parts[1]
TireType = _parts[2]
BumperType = _parts[3]
LightType = _parts[4]

EPartCategory_Vehicle = 0
EPartCategory_Engine = 1
EPartCategory_Tire = 2
EPartCategory_Bumper = 3
EPartCategory_Light = 4

AttackMode = dword(GetRealAddress(0x20BF20, 0x2071E0))
AttackScore = dword(GetRealAddress(0x40129C, 0x3F450C))

EAttackMode_Zombie = 0
EAttackMode_Survivor = 1
EAttackMode_Endless = 2

function GetNumSurvivors(acc=ACC_MIRROR)
{
    accessor = GetAccessor(acc)
    return sum_of(Survivors, accessor)
}

function _IsWalkLoad()
{
    // This value is 4 when in the load menu in the hospital basement.
    SystemMenuState = dword(WalkStateData + 0x474)
    return LastWalkMenu == EWalkMenu_System && SystemMenuState == 4
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
AreaLookup = {
    0: "Central Town",
    1: "East Building",
    2: "West Forest",
    3: "South Desert",
    4: "North Field"
}
VehicleLookup = {
    0: "🚑 S",
    1: "🚑 M",
    2: "🚑 L",
    3: "🚓",
    4: "Tank" // No Emoji :(
}
EngineLookup = {
    -1: "Normal Engine",
    0: "Normal Engine",
    1: "Rocket Engine",
    2: "Tank Engine",
    3: "Guard Engine",
    4: "Big-Bang Engine",
}
TireLookup = {
    -1: "Normal Tyres",
    0: "Normal Tyres",
    1: "Bare-Bones Tyres",
    2: "Highway Tyres",
    3: "Grip Tyres",
    4: "Scream Tyres",
}
BumperLookup = {
    -1: "Normal Bumper",
    0: "Normal Bumper",
    1: "Broad Bumper",
    2: "Protection Bumper",
    3: "Wing Bumper",
    4: "Evil-Killing Bumper",
}
LightLookup = {
    -1: "Normal Lights",
    0: "Normal Lights",
    1: "Home Lights",
    2: "Industrial Lights",
    3: "Medical Lights",
    4: "Exploration Lights",
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
    "{0} | Walking around the basement of the Sunlight Medical Center | {1} rescued",
    rich_presence_lookup("Title", RegionByte, TitleLookup),
    rich_presence_value("Survivors", GetNumSurvivors())
)
// TODO: Very basic -- add stats like chosen car, area, and parts
rich_presence_conditional_display(
    GetGameState() == EGameState_Drive,
    "{0} | Driving around {1} and seeking out survivors | {2} | {3} | {4} | {5} | {6} | {7} rescued",
    rich_presence_lookup("Title", RegionByte, TitleLookup),
    rich_presence_lookup("Area", AreaID, AreaLookup),
    rich_presence_lookup("Vehicle", VehicleType, VehicleLookup),
    rich_presence_lookup("Engine", EngineType, EngineLookup),
    rich_presence_lookup("Tire", TireType, TireLookup),
    rich_presence_lookup("Bumper", BumperType, BumperLookup),
    rich_presence_lookup("Lights", LightType, LightLookup),
    rich_presence_value("Survivors", GetNumSurvivors())
)
rich_presence_conditional_display(
    GetGameState() == EGameState_AttackModeResult,
    "{0} | Looking at Attack Mode high scores",
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
    return DriveStateData != NULL && 
           ComboCount >= 100 &&
           prev(ComboCount) < 100
}

function ComboCancel()
{
    // 999 is the highest legitimate value!
    return DriveStateData == NULL || ComboCount > 999
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

function AttackStart(attack_mode)
{
    return GetGameState() == EGameState_Drive &&
           GetGameState(ACC_PREV) != EGameState_Drive &&
           AttackMode == attack_mode
}

function AttackCancel(attack_mode)
{
    return GetGameState() == EGameState_Title
}

function AttackSubmit(attack_mode)
{
    return GetGameState() == EGameState_AttackModeResult &&
           GetGameState(ACC_PREV) != EGameState_AttackModeResult
}

function AttackValue(attack_mode)
{
    return AttackScore
}

leaderboard(
    id=92489,
    title="Zombie Attack - Most Zombie Kills",
    description="Kill the most zombies within the time limit in Zombie Attack!",
    start=AttackStart(EAttackMode_Zombie),
    cancel=AttackCancel(EAttackMode_Zombie),
    submit=AttackSubmit(EAttackMode_Zombie),
    value=AttackValue(EAttackMode_Zombie)
)

leaderboard(
    id=92490,
    title="Survivor Attack - Most Survivors Rescued",
    description="Rescue the most survivors within the time limit in Survivor Attack!",
    start=AttackStart(EAttackMode_Survivor),
    cancel=AttackCancel(EAttackMode_Survivor),
    submit=AttackSubmit(EAttackMode_Survivor),
    value=AttackValue(EAttackMode_Survivor)
)

leaderboard(
    id=92491,
    title="Endless Attack - Most Points",
    description="Obtain the most points in Endless Attack!",
    start=AttackStart(EAttackMode_Endless),
    cancel=AttackCancel(EAttackMode_Endless),
    submit=AttackSubmit(EAttackMode_Endless),
    value=AttackValue(EAttackMode_Endless)
)

// LEADERBOARDS END

// ACHIEVEMENTS START

function ComboTrigger(start, end)
{
    return DriveStateData != NULL &&
           ComboCount >= start &&
           trigger_when(ComboCount >= end && prev(ComboCount) < end)
}

achievement(
    id=411027,
    title="Good!! Zombie Killer!",
    description="Obtain a combo kill count of 5.",
    points=1,
    trigger=ComboTrigger(1, 5)
)

achievement(
    id=411028,
    title="Great!! Zombie Hunter!",
    description="Obtain a combo kill count of 10.",
    points=2,
    trigger=ComboTrigger(5, 10)
)

achievement(
    id=411029,
    title="Excellent!! Zombie Assassin!",
    description="Obtain a combo kill count of 20.",
    points=3,
    trigger=ComboTrigger(10, 20)
)

achievement(
    id=411030,
    title="Fantastic!! Zombie Genocider!",
    description="Obtain a combo kill count of 50.",
    points=5,
    trigger=ComboTrigger(20, 50)
)

achievement(
    id=411031,
    title="It's Crazy!! Zombie's Demise!",
    description="Obtain a combo kill count of 100.",
    points=10,
    trigger=ComboTrigger(50, 100)
)

achievement(
    id=411032,
    title="Zombie Decimator",
    description="Kill 535.94 zombies.",
    points=5,
    trigger=LoadProtection() && 
            prev(KillCount) < 536 && 
            KillCount >= 536
)

achievement(
    id=411033,
    title="A Light in the Darkness",
    description="Locate and rescue your first survivor.",
    points=1,
    trigger=LoadProtection() &&
            GetNumSurvivors(ACC_PREV) == 0 &&
            GetNumSurvivors() > 0
)

// RESEARCH LEVELS:
// 0 Mechanics = 0
// 1 = 1
// 3 = 2
// 6 = 3
// 10 = 4
// 15 = 5
// 20 = 6
// 25 = 7
// 30 = 8
// 50 = 9 (INFO: Obtaining this instantly completes research on all parts)
// 100 = 10 (INFO: Obtaining this instantly complets research on all cars (except Tank))

// REQUIRED RESEARCH LEVELS:
// Ambulance S = DEFAULT
// Ambulance M = 2
// Ambulance L = 5
// Police Car = 8
// Tank = 0 (??? - Only possible outside of main campaign??)

// Normal Engine = DEFAULT
// Rocket Engine = 2
// Tank Engine = 3
// Guard Engine = 5
// Big-Bang Engine = 7

// Normal Tyres = DEFAULT
// Bare-Bones Tyres = 1
// Highway Tyres = 2
// Grip Tyres = 4
// Scream Tyres = 5

// Normal Bumper = DEFAULT
// Broad Bumper = 1
// Protection Bumper = 2
// Wing Bumper = 4
// Evil-Killing Bumper = 7

// Normal Lights = DEFAULT
// Home Lights = 2
// Industrial Lights = 3
// Medical Lights = 4
// Exploration Lights = 5

function ResearchDone(part_category, part_index)
{
    PartsArray = GetRealAddress(0x20BD12, 0x206FD2)
    part = byte(PartsArray + part_category * 5 + part_index)

    return LoadProtection() &&
           part == True &&
           prev(part) == False
}

function CountPartsResearch(acc=ACC_MIRROR)
{
    accessor = GetAccessor(acc)
    // Starting at 0x20BD17 to skip over cars
    PartsArray = GetRealAddress(0x20BD17, 0x206FD7)
    
    sum = 0
    for i in range(0, 20 - 1)
    {
        sum = sum + accessor(byte(PartsArray + i))
    }
    
    return sum
}

achievement(
    id=411034,
    title="Kyuukyuusha UP!",
    description="Research the Ambulance M.",
    points=5,
    trigger=ResearchDone(EPartCategory_Vehicle, 1)
)

achievement(
    id=411035,
    title="Health at Any Size",
    description="Research the Ambulance L.",
    points=5,
    trigger=ResearchDone(EPartCategory_Vehicle, 2)
)

achievement(
    id=411036,
    title="Code Blue",
    description="Research the Police Car.",
    points=10,
    trigger=ResearchDone(EPartCategory_Vehicle, 3)
)

function AttackScoreTrigger(mode, score)
{
    //TankUnlocked = dword(GetRealAddress(0x20BB74, 0x206E34))
    // Use the attack mode + score to not lock people out of this one
    
    return GetGameState() == EGameState_AttackModeResult &&
           GetGameState(ACC_PREV) != EGameState_AttackModeResult &&
           AttackMode == mode &&
           AttackScore >= score
}

achievement(
    id=411037,
    title="Tanks for Playing",
    description="Obtain the Tank by obtaining at least 1000 points in Endless Attack.",
    points=10,
    trigger=AttackScoreTrigger(EAttackMode_Endless, 1000)
)

achievement(
    id=411043,
    title="Monster Masher",
    description="Kill at least 100 zombies in Zombie Attack.",
    points=5,
    trigger=AttackScoreTrigger(EAttackMode_Zombie, 100)
)

achievement(
    id=411046,
    title="Survivor Savior",
    description="Rescue at least 10 survivors in Survivor Attack.",
    points=5,
    trigger=AttackScoreTrigger(EAttackMode_Survivor, 10)
)

// Rescuing 50 mechanics causes all parts to be instantly researched when talking to the mechanic
// hence the dual-condition here
achievement(
    id=411038,
    title="Mechanically Inclined",
    description="Develop all vehicle parts or rescue 50 mechanics.",
    points=25,
    trigger=LoadProtection() &&
           ((CountPartsResearch() == 20 && CountPartsResearch(ACC_PREV) != 20) || 
            (Survivors[ESurvivor_Mechanic] >= 50 && prev(Survivors[ESurvivor_Mechanic]) < 50))
)

// Bosses

function BossTrigger(boss_id)
{
    CutsceneID = dword(GetRealAddress(0x206C08, 0x2048B4))
    boss_end_cutscene_start = 0xE
    return GetGameState() == EGameState_Cutscene &&
           GetGameState(ACC_PREV) != EGameState_Cutscene &&
           CutsceneID == boss_end_cutscene_start + boss_id
}

BossAchievementTitles = [
    "A Worm Feeling",
    "Battle of Attrition",
    "Worth a Thousand Worms",
    "What a Tough Bastard",
    "Army of Two",
    "Rapid Evolution",
]

BossAchievementDescriptions = [
    "Defeat the Mutant Caterpillar guarding East Building.",
    "Defeat the Veteran Zombie guarding West Forest.",
    "Defeat the Mutant Caterpillar guarding South Desert.",
    "Defeat the Mutant Butterfly guarding North Field.",
    "Defeat the Veteran Zombies attacking the hospital.",
    "Defeat the origin of the zombie virus. Thank you for playing!",
]

BossAchievementPoints = [
    10,
    10,
    10,
    10,
    10,
    25,
]

BossAchievementIDs = [
    411039,
    411040,
    411041,
    411044,
    411042,
    411045,
]

for i in range(0, length(BossAchievementTitles) - 1)
{
    title = BossAchievementTitles[i]
    description = BossAchievementDescriptions[i]
    points = BossAchievementPoints[i]
    id = BossAchievementIDs[i]
    
    achievement(
        id=id,
        title=title,
        description=description,
        points=points,
        trigger=BossTrigger(i)
    )
}

// ACHIEVEMENTS END

