// City Crisis
// #ID = 27504

NULL = 0
True = 1
False = 0

FRAMES_PER_SECOND_NTSC = 30.0
FRAMES_PER_SECOND_PAL = 25.0

RegionByte = byte(0x236F4A)
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
    EU: dword(0x3C4180),
    JP: dword(0x3A8D00),
}
DemoMode = {
    US: dword(0x3BA878),
    EU: dword(0x3C41F8),
    JP: dword(0x3A8D74),
}
MissionID = {
    US: dword(0x3BA900),
    EU: dword(0x3C4280),
    JP: dword(0x3A8DF8),
}
HelicopterID = {
    US: dword(0x3BA954),
    EU: dword(0x3C42D4),
    JP: dword(0x3A8E4C),
}
ScoreMenuBitset = {
    US: byte(0x599DA4),
    EU: byte(0x57F164),
    JP: byte(0x586C24),
}
ScoreMenuScore = {
    US: dword(0x59AAC4),
    EU: dword(0x57FE84),
    JP: dword(0x587924),
}
ScoreMenuRank = {
    US: byte(0x5A2042),
    EU: byte(0x587402),
    JP: byte(0x58EEA2),
}
MissionTimeFrames = {
    US: dword(0x3BA8A8),
    EU: dword(0x3C4228),
    JP: dword(0x3A8DA0),
}
TimeTrialTime = {
    US: dword(0x3BA898),
    EU: dword(0x3C4218),
    JP: dword(0x3A8D90),
}

EGameMode_Game = {
    US: 0x13,
    EU: 0x13,
    JP: 0x12,
}

function IsInGame(region)
{
    return GameMode[region] == EGameMode_Game[region] && DemoMode[region] == 0
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
    return MissionOver(region) && ScoreMenuRank[region] == ord("S")
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
    0x7: "👨‍🚒 Rescuing the entire city in Disaster Rescue",
    0xF: "🏁 Racing through the city in Day Time Trial",
    0x10: "🏁 Racing through the city in Night Time Trial",
    0x11: "🏁 Racing through the city in Disaster Time Trial",
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
    divisor = FRAMES_PER_SECOND_NTSC
    if region == EU
    {
        divisor = FRAMES_PER_SECOND_PAL
    }

    return MissionTimeFrames[region] * (1 / divisor) * 100.0
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
    0x7: "Disaster Rescue",
}

TimeTrialNames = {
    0xF: "Day City Course",
    0x10: "Night City Course",
    0x11: "Disaster City Course",
}

LeaderboardIDs = {
    0x1: [94232, 94238],
    0x2: [94233, 94239],
    0x3: [94234, 94240],
    0x4: [94235, 94241],
    0x5: [94236, 94242],
    0x6: [94237, 94243],
    0x7: [94244, 94245],
    0xF: 94246,
    0x10: 94247,
    0x11: 94248,
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
    if mission != 0x7 // seems to be an autoscroller anyways so no point in checking time
    {
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
}

// Time Trials

function TimeTrialValue(mission)
{
    return max_of(
      measured(TimeTrialTime[US] / 10, when=IsRegion(US)),
      measured(TimeTrialTime[EU] / 10, when=IsRegion(EU)),
      measured(TimeTrialTime[JP] / 10, when=IsRegion(JP))
    )
}

for mission in TimeTrialNames
{
    leaderboard(
        id=LeaderboardIDs[mission],
        title=format("{0} - Time Attack", TimeTrialNames[mission]),
        description=format("Complete {0} in the fastest time!", TimeTrialNames[mission]),
        start=DefaultLeaderboardStart(mission),
        cancel=DefaultLeaderboardCancel(mission),
        submit=DefaultLeaderboardSubmit(mission),
        value=TimeTrialValue(mission),
        format="CENTISECS",
        lower_is_better=true
    )
}

// LEADERBOARDS END

// ACHIEVEMENTS START

MissionIDs = {
    0x1: [416102, 416103], // "Fire In The Building",
    0x2: [416104, 416105], // "Hijacked Bus",
    0x3: [416106, 416107], // "Burning School Building",
    0x4: [416108, 416109], // "Fire At Night",
    0x5: [416110, 416111], // "Accident Flight",
    0x6: [416112, 416113], // "Run Away Sports Car",
    0x7: [416114, 416115], // "Disaster Rescue",
    0xF: 416116,      // "Day Time Trial"
    0x10: 416117,      // "Night Time Trial"
    0x11: 416118,      // "Disaster Time Trial"
}
MissionPoints = {
    0x1: [5, 5],
    0x2: [5, 5],
    0x3: [5, 5],
    0x4: [5, 5],
    0x5: [5, 5],
    0x6: [5, 5],
    0x7: [5, 5],
    0xF: 10,
    0x10: 10,
    0x11: 10,
}
MissionTitles = {
    0x1: ["Somebody Call 911", "Fire Gonna Bring This Roof to Floor"],
    0x2: ["I Saw This in a Movie", "The Bus That Couldn't Slow Down"],
    0x3: ["We Need to Cook", "The Science of Change"],
    0x4: ["Sleep All Day", "Party All Night"],
    0x5: ["Flames Make It Go Faster", "Through the Fire and Flames"],
    0x6: ["Outrun", "Hot Pursuit"],
    0x7: ["Disaster Report", "Air Ranger"],
    0xF: "Fire Whirl",
    0x10: "Northern Light",
    0x11: "Sonic Boom",
}
// Requirements for S rank pulled from the game data; these are just to give hints in the description.
// NOTE: While PAL seems to give you more time for mission 1 for some reason, these appear to be the same in PAL.
// Same scores in JP
MissionScoreRequirements = {
    0x1: 500000,
    0x2: 600000,
    0x3: 620000,
    0x4: 500000,
    0x5: 320000,
    0x6: 600000,
    0x7: 700000,
    0xF: 85,
    0x10: 105,
    0x11: 75,
}

function MissionTrigger(region, mission, s_rank=False)
{
    cond = MissionOver(region) && MissionID[region] == mission
    if s_rank == True
    {
        cond = cond && GotSRank(region)
    }
    
    return cond
}

// Main Missions

for mission in MainMissionNames
{
    achievement(
        id=MissionIDs[mission][0],
        title=MissionTitles[mission][0],
        description=format("Complete {0}.", MainMissionNames[mission]),
        points=MissionPoints[mission][0],
        trigger=any_of(Regions, region => MissionTrigger(region, mission))
    )
    achievement(
        id=MissionIDs[mission][1],
        title=MissionTitles[mission][1],
        description=format("Obtain an S rank in {0} by achieving a score of {1} points or more.", MainMissionNames[mission], MissionScoreRequirements[mission]),
        points=MissionPoints[mission][1],
        trigger=any_of(Regions, region => MissionTrigger(region, mission, s_rank=True))
    )
}

// Time Trials

for mission in TimeTrialNames
{
    achievement(
        id=MissionIDs[mission],
        title=MissionTitles[mission],
        description=format("Obtain an S rank in {0} by achieving a time under {1} seconds.", TimeTrialNames[mission], MissionScoreRequirements[mission]),
        points=MissionPoints[mission],
        trigger=any_of(Regions, region => MissionTrigger(region, mission, s_rank=True))
    )
}

// ACHIEVEMENTS END

