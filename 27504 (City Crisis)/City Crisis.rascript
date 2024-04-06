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

function ord(char)
{
    table = {
        "A": 0x41,
        "B": 0x42,
        "C": 0x43,
        "D": 0x44,
        "E": 0x45,
        "S": 0x53
    }
    
    return table[char]
}

GameMode = {
    US: dword(0x3BA800),
    EU: dword(0xFFFFFF),
    JP: dword(0xFFFFFF),
}
DemoMode = {
    US: dword(0x3BA878),
    EU: dword(0xFFFFFF),
    JP: dword(0xFFFFFF),
}
MissionID = {
    US: dword(0x3BA900),
    EU: dword(0xFFFFFF),
    JP: dword(0xFFFFFF),
}
HelicopterID = {
    US: dword(0x3BA954),
    EU: dword(0xFFFFFF),
    JP: dword(0xFFFFFF),
}
ScoreMenuBitset = {
    US: byte(0x599DA4),
    EU: byte(0xFFFFFF),
    JP: byte(0xFFFFFF),
}
ScoreMenuScore = {
    US: dword(0x59AAC4),
    EU: dword(0xFFFFFF),
    JP: dword(0xFFFFFF),
}
ScoreMenuRank = {
    US: byte(0x5A2042),
    EU: byte(0xFFFFFF),
    JP: byte(0xFFFFFF),
}
MissionTimeLeft = {
    US: dword(0x3BA890),
    EU: dword(0xFFFFFF),
    JP: dword(0xFFFFFF),
}
MissionTimeLimit = {
    US: dword(0x3BA8A0),
    EU: dword(0xFFFFFF),
    JP: dword(0xFFFFFF),
}

EGameMode_Game = 0x13

function IsInGame(region)
{
    return GameMode[region] == EGameMode_Game && DemoMode[region] == 0
}

function IsOnResult(region)
{
    return ScoreMenuBitset[region] & 1 == 1   
}

function MissionOver(region)
{
    return IsOnResult(region) &&
           prev(ScoreMenuRank[region]) == 0 &&
           ScoreMenuRank[region] != 0
}

function GotSRank(region)
{
    return MissionOver(region) && ScoreMenuRank == ord("S")
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

// LEADERBOARDS START

function GetMissionScore(region)
{
    return ScoreMenuScore[region]
}

function GetMissionCentiseconds(region)
{
    return (MissionTimeLimit[region] - MissionTimeLeft[region]) / 10
}

DefaultLeaderboardStart = (mission) => 
  any_of(Regions, region => 
     IsRegion(region) && 
     MissionID[region] == mission && 
     MissionOver(region)
)
DefaultLeaderboardCancel = (mission) => always_false()
DefaultLeaderboardSubmit = (mission) => always_true()
DefaultLeaderboardScoreValue = (mission) => max_of(
  measured(GetMissionScore(US), when=IsRegion(US)),
  measured(GetMissionScore(EU), when=IsRegion(EU)),
  measured(GetMissionScore(JP), when=IsRegion(JP))
)
DefaultLeaderboardTimeValue = (mission) => max_of(
  measured(GetMissionCentiseconds(US), when=IsRegion(US)),
  measured(GetMissionCentiseconds(EU), when=IsRegion(EU)),
  measured(GetMissionCentiseconds(JP), when=IsRegion(JP))
)

MainMissionNames = {
    0x1: "Fire In The Building",
    0x2: "Hijacked Bus",
    0x3: "Burning School Building",
    0x4: "Fire At Night",
    0x5: "Accident Flight",
    0x6: "Run Away Sports Car",
    0x7: "Disaster Flight",
}

TimeTrialNames = {
    0x8: "Day Time Trial",
    0x9: "Night Time Trial",
    0xA: "Disaster Time Trial",
}

LeaderboardIDs = {
    0x1: [94232, 94238],
    0x2: [94233, 94239],
    0x3: [94234, 94240],
    0x4: [94235, 94241],
    0x5: [94236, 94242],
    0x6: [94237, 94243],
    0x7: [94244, 94245],
    0x8: 94246,
    0x9: 94247,
    0xA: 94248,
}

// Main Missions

for mission in MainMissionNames
{
    leaderboard(
        id=LeaderboardIDs[mission][0],
        title=format("{0} - Point Attack", MainMissionNames[mission]),
        description=format("Complete {0} with the highest score!", MainMissionNames[mission]),
        start=DefaultLeaderboardStart(mission),
        cancel=DefaultLeaderboardCancel(mission),
        submit=DefaultLeaderboardSubmit(mission),
        value=DefaultLeaderboardScoreValue(mission)
    )
    leaderboard(
        id=LeaderboardIDs[mission][1],
        title=format("{0} - Time Attack", MainMissionNames[mission]),
        description=format("Complete {0} in the fastest time!", MainMissionNames[mission]),
        start=DefaultLeaderboardStart(mission),
        cancel=DefaultLeaderboardCancel(mission),
        submit=DefaultLeaderboardSubmit(mission),
        value=DefaultLeaderboardTimeValue(mission),
        format="CENTISECS",
        lower_is_better=true
    )
}

// Time Trials

for mission in TimeTrialNames
{
    leaderboard(
        id=LeaderboardIDs[mission],
        title=format("{0} - Time Attack", TimeTrialNames[mission]),
        description=format("Complete {0} in the fastest time!", TimeTrialNames[mission]),
        start=DefaultLeaderboardStart(mission),
        cancel=DefaultLeaderboardCancel(mission),
        submit=DefaultLeaderboardSubmit(mission),
        value=DefaultLeaderboardTimeValue(mission),
        format="CENTISECS",
        lower_is_better=true
    )
}

// LEADERBOARDS END

