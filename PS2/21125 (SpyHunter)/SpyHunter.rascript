// SpyHunter
// #ID = 21125

NULL = 0
True = 1
False = 0

RegionByte = byte(0x101072) // Constant code byte, 0 == US, 1 == EU
REGION_US = 0
REGION_EU = 1
US = 0
EU = 1
Regions = [US, EU]

function IsRegion(region)
{
    return RegionByte == region
}

Game = {
    US: dword(0x356258),
    EU: dword(0x35A4FC),
}
Level = {
    US: dword(0x35625C),
    EU: dword(0x35A500),
}
Cheats = {
    US: 0x3564D8,
    EU: 0x35A780,
}
Player = {
    US: dword(Level[US] + 0x12304),
    EU: dword(Level[EU] + 0x12304),
}
Health = {
    US: float(Player[US] + 0x38),
    EU: float(Player[EU] + 0x38),
}
CurrentLevel = {
    US: dword(Game[US] + 0xB24),
    EU: dword(Game[EU] + 0xB24),
}
LevelComplete = {
    US: dword(Player[US] + 0xCA8),
    EU: dword(Player[EU] + 0xCB8),
}
LevelCompleteTime = {
    US: float(Player[US] + 0xCDC),
    EU: float(Player[EU] + 0xCEC),
}
LevelCompleteState = { // 1 = success, 2 or 3 = dead/out of time
    US: dword(Player[US] + 0xCAC),
    EU: dword(Player[EU] + 0xCBC),
}

LCS_SUCCESS = 1
LCS_DEAD = 2
LCS_OUT_OF_TIME = 3

// There's a bug preventing pushing to arrays if they're dictionary values :(
tempUS = []
tempEU = []
for i in range(0, 10 - 1)
{
    array_push(tempUS, dword(Player[US] + 0xCB0 + i * 4))
    array_push(tempEU, dword(Player[EU] + 0xCC0 + i * 4))
}
LevelObjectives = {
    US: tempUS,
    EU: tempEU,
}

LevelNames = {
    1: "Test Track License",
    2: "Dragon Strike",
    3: "Route Canal",
    4: "Swamp Venom",
    5: "Double Vision",
    6: "Columbian Extract",
    7: "IES Testing Facility",
    8: "Escort Service",
    9: "German Blitz",
    10: "Terrorist Lock Down",
    11: "French Kiss",
    12: "Locked Keys",
    13: "Venetian Blind",
    14: "Eye of the Storm",
}

LevelLocationNames = {
    1: "Texas, USA",
    2: "Frankfurt, Germany",
    3: "Venice, Italy",
    4: "Florida Keys, USA",
    5: "the French Riveria",
    6: "the Panama Canal",
    7: "Texas, USA",
    8: "Dover, England",
    9: "Frankfurt, Germany",
    10: "the Panama Canal",
    11: "Monte Carlo, France",
    12: "Florida Keys, USA",
    13: "Venice, Italy",
    14: "Petra, Jordan"
}

LevelNumObjectives = {
    1: 7,
    2: 4,
    3: 4,
    4: 4,
    5: 4,
    6: 4,
    7: 7,
    8: 4,
    9: 5,
    10: 4,
    11: 6,
    12: 4,
    13: 4,
    14: 4,
}

LevelCheatTimes = {
    1: 221,
    2: 216,
    3: 161,
    4: 226,
    5: 206,
    6: 226,
    7: 191,
    8: 186,
    9: 226,
    10: 196,
    11: 191,
    12: 211,
    13: 136,
    14: 311,
}

function SecondsToMinutes(seconds)
{
    return [seconds / 60, seconds % 60]
}

function IsSinglePlayer(region)
{
    OFFSET_NUM_PLAYERS = 0x34
    return dword(Game[region] + OFFSET_NUM_PLAYERS) == 1
}

function IsInLevel(region, level=-1)
{
    if (level == -1)
    {
        return Level[region] != NULL
    }
    return Level[region] != NULL && CurrentLevel[region] == level
}

function LevelComplete(region, level)
{
    return IsInLevel(region, level) &&
           LevelComplete[region] == True &&
           prev(LevelComplete[region]) == False && 
           LevelCompleteState[region] == LCS_SUCCESS && // We haven't died/run out of time
           LevelObjectives[region][0] == True // We completed the first objective
}

function AllLevelObjectives(region, level)
{
    num_objectives = LevelNumObjectives[level]
    
    condition = always_true()
    for i in range(0, num_objectives - 1)
    {
        condition = condition && LevelObjectives[region][i] == True
    }
    return condition
}

CHEAT_FMV0 = 0
CHEAT_FMV1 = 1
CHEAT_FMV2 = 2
CHEAT_FMV3 = 3
CHEAT_FMV4 = 4
CHEAT_UNKNOWN = 5
CHEAT_HUD_COLOR = 6
CHEAT_NIGHT_VISION = 7
CHEAT_EXTRA_CAMERAS = 8
CHEAT_INVERSION_CAMERA = 9
CHEAT_FISHEYE_VIEW = 10
CHEAT_CAMERA_FLIP = 11
CHEAT_CAMERA_ROLL = 12
CHEAT_TINY_SPY = 13
CHEAT_HOVER_SPY = 14
CHEAT_GOD_MODE = 15

function AntiCheat(region)
{
    banned_cheats = [
        CHEAT_NIGHT_VISION,
        CHEAT_EXTRA_CAMERAS,
        CHEAT_INVERSION_CAMERA,
        CHEAT_FISHEYE_VIEW,
        CHEAT_CAMERA_FLIP,
        CHEAT_CAMERA_ROLL,
        CHEAT_TINY_SPY,
        CHEAT_HOVER_SPY,
        CHEAT_GOD_MODE,
    ]
    
    // Map the provided cheats to a dword read of the correct address
    banned_cheats = array_map(
        banned_cheats,
        i => dword(Cheats[region] + i * 4)
    )
    
    return IsSinglePlayer(region) && none_of(banned_cheats, cheat => cheat != False)
}

// LEADERBOARDS START

function CreateLeaderboardStart(region, level)
{
    return AntiCheat(region) &&
           LevelComplete(region, level) &&
           AllLevelObjectives(region, level)
}

function CreateLeaderboardCancel(region, level)
{
    return always_false()
}

function CreateLeaderboardSubmit(region, level)
{
    return always_true()
}

function CreateLeaderboardValue(level)
{
    return max_of(
        measured(LevelCompleteTime[US] * 100.0, when=IsRegion(US)),
        measured(LevelCompleteTime[EU] * 100.0, when=IsRegion(EU))
    )
}

LEADERBOARD_ID_START = 92139

for level in LevelNames
{
    leaderboard(
        id=LEADERBOARD_ID_START+level-1,
        title=format(
            "{0} - Best Time",
            LevelNames[level]
        ),
        description=format(
            "Finish the mission \"{0}\" while having all objectives completed within the fastest time!",
            LevelNames[level]
        ),
        start=any_of(Regions, region => IsRegion(region) && CreateLeaderboardStart(region, level)),
        cancel=any_of(Regions, region => IsRegion(region) && CreateLeaderboardCancel(region, level)),
        submit=any_of(Regions, region => IsRegion(region) && CreateLeaderboardSubmit(region, level)),
        value=CreateLeaderboardValue(level),
        format="MILLISECS",
        lower_is_better=true
    )
}

// LEADERBOARDS END

// ACHIEVEMENTS START

function PartialLevelTrigger(region, level)
{
    return AntiCheat(region) &&
           LevelComplete(region, level)
}

function FullLevelTrigger(region, level)
{
    time_limit = LevelCheatTimes[level]
    
    return PartialLevelTrigger(region, level) &&
           AllLevelObjectives(region, level) &&
           LevelCompleteTime[region] < time_limit
}

PARTIAL_ACHIEVEMENT_ID_START = 408813
FULL_ACHIEVEMENT_ID_START = 408827

for level in LevelNames
{
    partial_points = 5
    full_points = 10
    if (level == 14)
    {
        // Give more points for the last level
        partial_points = 10
        full_points = 25
    }
    
    // Partial level completion
    achievement(
        id=PARTIAL_ACHIEVEMENT_ID_START+level-1,
        title=format("{0}", LevelNames[level]),
        description=format("Complete the mission \"{0}\".", LevelNames[level]),
        points=partial_points,
        trigger=any_of(Regions, region => IsRegion(region) && PartialLevelTrigger(region, level))
    )
    
    // Full level completion (+ dev-set time to unlock a cheat)
    temp = SecondsToMinutes(LevelCheatTimes[level])
    minutes = temp[0]
    seconds = temp[1]
    achievement(
        id=FULL_ACHIEVEMENT_ID_START+level-1,
        title=format("{0} - Super Spy", LevelNames[level]),
        description=format(
            "Complete the mission \"{0}\" with all objectives completed " +
            "in under {1} minutes and {2} seconds.",
            LevelNames[level],
            minutes,
            seconds
        ),
        points=full_points,
        trigger=any_of(Regions, region => IsRegion(region) && FullLevelTrigger(region, level))
    )
}

// ACHIEVEMENTS END

// RICH PRESENCE START

RegionLookup = {
    REGION_US: "ᵘˢ",
    REGION_EU: "ᵉᵘ",
}

for region in Regions
{
    rich_presence_conditional_display(
        IsRegion(region) && !IsInLevel(region),
        "{0} In the opening menu or loading screen.",
        rich_presence_lookup("Region", region, RegionLookup)
    )
    rich_presence_conditional_display(
        IsRegion(region) && IsInLevel(region),
        "{0} Undergoing mission \"{1}\" in {2}.",
        rich_presence_lookup("Region", region, RegionLookup),
        rich_presence_lookup("LevelName", CurrentLevel[region], LevelNames),
        rich_presence_lookup("LocationName", CurrentLevel[region], LevelLocationNames)
    )
}
rich_presence_display("Playing SpyHunter")

// RICH PRESENCE END
