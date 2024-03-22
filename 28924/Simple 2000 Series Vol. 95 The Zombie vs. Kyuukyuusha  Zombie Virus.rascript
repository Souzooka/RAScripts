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
