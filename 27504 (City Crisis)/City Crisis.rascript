// City Crisis
// #ID = 27504

NULL = 0
True = 1
False = 0

RegionByte = byte(0x100000) // TODO
REGION_US = 0
REGION_EU = 1
REGION_JP = 2
US = REGION_US
EU = REGION_EU
JP = REGION_JP
Regions = [US, EU, JP]

function IsRegion(region)
{
    return RegionByte == region
}

GameMode = {
    US: dword(0x3BA800),
    EU: dword(0),
    JP: dword(1),
}
DemoMode = {
    US: dword(0x3BA878),
    EU: dword(0),
    JP: dword(1),
}
MissionID = {
    US: dword(0x3BA900),
    EU: dword(0),
    JP: dword(1),
}
HelicopterID = {
    US: dword(0x3BA954),
    EU: dword(0),
    JP: dword(1),
}
ScoreMenuBitset = {
    US: byte(0x599DA4),
    EU: byte(0),
    JP: byte(1),
}
ScoreMenuRank = {
    US: byte(0x5A2042),
    EU: dword(0),
    JP: dword(1),
}

EGameMode_Game = 0x13

function IsInGame(region)
{
    return GameMode[region] == EGameMode_Game && DemoMode[region] == 0
}

// RICH PRESENCE START

RegionLookup = {
    REGION_US: "ᵘˢ",
    REGION_EU: "ᵉᵘ",
    REGION_JP: "ʲᵖ",
}
MissionLookup = {
    0x1: "👨‍🚒 Putting out a Fire In The Building",
    0x2: "👮️ Chasing down a Hijacked Bus",
    0x3: "👨‍🚒 Putting out a Burning School Building",
    0x4: "👨‍🚒 Putting out a Fire At Night",
    0x5: "👨‍🚒 Putting out fires midair in Accident Flight",
    0x6: "👮 Chasing down a Run Away Sports Car",
    0x7: "👨‍🚒 Rescuing the entire city in Disaster Flight",
    0x8: "🏁 Racing through the city in Day Time Trial",
    0x9: "🏁 Racing through the city in Night Time Trial",
    0xA: "🏁 Racing through the city in Disaster Time Trial",
    0xC: "👨‍✈️ Brushing up their skills in Flight Training",
    0xD: "👨‍✈️ Brushing up their skills in Rescue Training",
    0xE: "👨‍✈️ Brushing up their skills in Fire-Fighting Training",
}
HelicopterLookup = {
    0: "Dolphin",
    1: "Gold Fish",
    2: "Lobster",
    3: "Bat",
    4: "Pork",
}

for region in Regions
{
    rich_presence_conditional_display(
        IsRegion(region) && IsInGame(region),
        "{0} {1} | 🚁 {2}",
        rich_presence_lookup("Region", region, RegionLookup),
        rich_presence_lookup("Mission", MissionID[region], MissionLookup),
        rich_presence_lookup("Helicopter", HelicopterID[region], HelicopterLookup)
    )
    rich_presence_conditional_display(
        IsRegion(region),
        "{0} In a menu",
        rich_presence_lookup("Region", region, RegionLookup)
    )
}
rich_presence_display("Playing City Crisis")

// RICH PRESENCE END