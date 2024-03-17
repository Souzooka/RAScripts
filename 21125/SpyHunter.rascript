// SpyHunter
// #ID = 21125

NULL = 0

function GetRealAddress(us_address, eu_address)
{
    return us_address
}

Game = dword(GetRealAddress(0x356258, 0))
Level = dword(GetRealAddress(0x35625C, 0))
Cheats = GetRealAddress(0x3564D8, 0)

Player = dword(Level + 0x12304)
PlayerInfo = dword(Game + 0x3C)
CurrentLevel = dword(Game + 0xB24)
LevelComplete = dword(Player + 0xCA8)
LevelCompleteTime = float(Player + 0xCDC)
LevelObjectives = []
for i in range(0, 10 - 1)
{
    array_push(LevelObjectives, dword(Player + 0xCB0 + i * 4))
}
CompletedObjectives = dword(PlayerInfo + 0x378)

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

TOTAL_OBJECTIVES = 0
for level in LevelNumObjectives
{
    // Should end up being 65
    TOTAL_OBJECTIVES = TOTAL_OBJECTIVES + LevelNumObjectives[level]
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

function IsSinglePlayer()
{
    OFFSET_NUM_PLAYERS = 0x34
    return dword(Game + OFFSET_NUM_PLAYERS) == 1
}

function IsInLevel(level=-1)
{
    if (level == -1)
    {
        return Level != NULL
    }
    return Level != NULL && CurrentLevel == level
}

function GetPlayer()
{
    OFFSET_PLAYER = 0x12304
    return dword(Level + OFFSET_PLAYER)
}

function LevelComplete(level)
{
    OFFSET_LEVEL_COMPLETE = 0xCA8
    player = GetPlayer()
    level_complete = dword(player + OFFSET_LEVEL_COMPLETE)
    
    return IsInLevel(level) &&
           level_complete == 1 &&
           prev(level_complete) == 0
}

function LevelSuccess(level)
{
    return LevelComplete(level) && LevelObjectives[0] == 1
}

function LevelFailure(level)
{
    return LevelComplete(level) && LevelObjectives[0] == 0
}

function AllLevelObjectives(level)
{
    num_objectives = LevelNumObjectives[level]
    
    condition = always_true()
    for i in range(0, num_objectives - 1)
    {
        condition = condition && LevelObjectives[i] == 1
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

function AntiCheat()
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
        i => dword(Cheats + i * 4)
    )
    
    return IsSinglePlayer() && none_of(banned_cheats, cheat => cheat != 0)
}

// LEADERBOARDS START

function CreateLeaderboardStart(level)
{
    return AntiCheat() &&
           LevelComplete(level) &&
           AllLevelObjectives(level)
}

function CreateLeaderboardCancel(level)
{
    return always_false()
}

function CreateLeaderboardSubmit(level)
{
    return always_true()
}

function CreateLeaderboardValue(level)
{
    return LevelCompleteTime * 100.0
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
        start=CreateLeaderboardStart(level),
        cancel=CreateLeaderboardCancel(level),
        submit=CreateLeaderboardSubmit(level),
        value=CreateLeaderboardValue(level),
        format="MILLISECS"
    )
}

// LEADERBOARDS END
