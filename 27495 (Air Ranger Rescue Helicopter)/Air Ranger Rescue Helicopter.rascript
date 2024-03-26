// Air Ranger: Rescue Helicopter
// #ID = 27495

NULL = 0
True = 1
False = 0

REGION_EU = 0
REGION_JP = 1
EU = REGION_EU
JP = REGION_JP
Regions = [EU, JP]

function GetRegion()
{
    return EU
}

function IsRegion(region)
{
    return region == GetRegion()
}

function GetRealAddress(eu_address, jp_address)
{
    return eu_address
}

GameState = byte(GetRealAddress(0x237738, 0))
CurrentMission = word(GetRealAddress(0x237760, 0))

EGameState_Game = 0xF

// RICH PRESENCE START

TitleLookup = {
    EU: "Air Ranger: Rescue Helicopter",
    JP: "レスキューヘリエアレンジャー",
}

MissionLookup = {
    0: "BK-117-B | Airlifting a severely injured traffic accident victim in San Fernando City",
    1: "CH-47J | Transporting a crashed tanker off a bridge in San Fernando City",
    2: "BK-117-B | Rescuing victims of a shipwreck off White Coast",
    3: "OH-6D | Undergoing search and rescue of survivors adrift in sea off White Coast",
    4: "CH-47J | Recovering a truck carrying a load of timber which fell off a cliff in the Missoula Mountains",
    5: "OH-6D | Undergoing search and rescue of two geologists stranded in a steep ravine in the Missoula Mountains",
    6: "OH-6D | Rescuing two train operators stuck on a runaway freight train in Hickory Canyon",
    7: "BK-117-B | Extinguishing a fire that has engulfed a factory in Hickory Canyon",
}

rich_presence_conditional_display(
    GameState == EGameState_Game,
    "{0} | {1}",
    rich_presence_lookup("Title", GetRegion(), TitleLookup),
    rich_presence_lookup("Mission", CurrentMission, MissionLookup)
)
rich_presence_display(
    "{0} | Not inside a mission",
    rich_presence_lookup("Title", GetRegion(), TitleLookup)
)


// RICH PRESENCE END
