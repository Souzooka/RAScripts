// Smashing Drive
// #ID = 12920

// MISC. SCRIPT HELPERS

mirror = v => v

NULL = 0
True = 1
False = 0

function if_else(cond, v1, v2)
{
    if cond == true
    {
        return v1
    }
    return v2
}

// GAME VARIABLES

CurrentProcess = dword(0x6A04)
PROCESS_TRACKS = 0x8032A34
PROCESS_GOTONEXT = 0x8032A60
PROCESS_GAMEOVER = 0x8032A8C
PROCESS_INSERTNAME = 0x80329DC
PROCESS_CREDITS = 0x8032928

in_game_processes = [PROCESS_TRACKS, PROCESS_GOTONEXT]

ProcessSubstate = byte(0x87F8)

Route = byte(0x87FA)
Track = byte(0x87FB)
Level = word_be(0x87FA) // little cheeky trick to put the route first in a 16-bit value

DemoMode = byte(0x8801)
GameScore = dword(0x87DC)
// Fixed point value with 8-bit decimal portion
RideTime = tbyte(0x8831) + (byte(0x8830) / 256.0)

// RICH PRESENCE START

RouteLookup = {
    1: "Early Bird",
    2: "Rush Hour",
    3: "Night Owl",
    4: "Dusk and Wired",
    5: "the Bonus Route in Early Bird",
    6: "the Bonus Route in Rush Hour",
    7: "the Bonus Route in Night Owl",
}

LevelLookup = {
    0x0100: "To Brooklyn",
    0x0101: "To Wall Street",
    0x0102: "To Little Italy",
    0x0200: "To Brooklyn Navy Yard",
    0x0201: "To The Music City Hall",
    0x0202: "To West Central Park",
    0x0300: "To Sea & Air Museum",
    0x0301: "To 5th Ave-34 St.",
    0x0302: "To Times Square",
    0x0400: "To The Statue of Liberty",
}

rich_presence_conditional_display(
    any_of(in_game_processes, process => process == CurrentProcess) && Route < 5,
    "Delivering a passenger {0} in the {1} Route.",
    rich_presence_lookup("LEVEL", Level, LevelLookup),
    rich_presence_lookup("ROUTE", Route, RouteLookup)
)
rich_presence_conditional_display(
    any_of(in_game_processes, process => process == CurrentProcess),
    "Driving {0}.",
    rich_presence_lookup("ROUTE", Route, RouteLookup)
)
rich_presence_display("Playing Smashing Drive")

// LEADERBOARD START

LeaderboardLevels = {
    0x0100: "Early Bird - To Brooklyn",
    0x0101: "Early Bird - To Wall Street",
    0x0102: "Early Bird - To Little Italy",
    0x0200: "Rush Hour - To Brooklyn Navy Yard",
    0x0201: "Rush Hour - To The Music City Hall",
    0x0202: "Rush Hour - To West Central Park",
    0x0300: "Night Owl - To Sea & Air Museum",
    0x0301: "Night Owl - To 5th Ave-34 St.",
    0x0302: "Night Owl - To Times Square",
    0x0400: "Dusk & Wired - To The Statue of Liberty",
    0x0500: "Early Bird - Bonus Route",
    0x0600: "Rush Hour - Bonus Route",
    0x0700: "Night Owl - Bonus Route",
}

LeaderboardIDs = {
    0x0100: 102267,
    0x0101: 102268,
    0x0102: 102269,
    0x0200: 102270,
    0x0201: 102271,
    0x0202: 102272,
    0x0300: 102273,
    0x0301: 102274,
    0x0302: 102275,
    0x0400: 102276,
    0x0500: 102277,
    0x0600: 102278,
    0x0700: 102279,
}

ScoreLeaderboardStart = () => CurrentProcess == PROCESS_INSERTNAME && prev(CurrentProcess) == PROCESS_GAMEOVER
ScoreLeaderboardCancel = () => always_false()
ScoreLeaderboardSubmit = () => always_true()
ScoreLeaderboardValue = () => GameScore

TimeLeaderboardStart = (level) => level == Level && 
                                  CurrentProcess == PROCESS_TRACKS &&
                                  ProcessSubstate == 6 &&
                                  prev(ProcessSubstate) != 6
TimeLeaderboardCancel = () => always_false()
TimeLeaderboardSubmit = () => always_true()
TimeLeaderboardValue = () => RideTime * 100.0 // Convert to centisecs

// The game increments the level to 0x401 at the end of the liberty statue stage
LibertyLeaderboardStart = () => Level == 0x401 && prev(Level) == 0x400

// If you play Dusk & Wired again, your score is that of your last playthrough + the score you gained on that level, wtf
// that kind of makes this invalid sadly
//leaderboard(
//    id=102266,
//    title="Score Attack",
//    description="Complete the game with the highest score!",
//    start=ScoreLeaderboardStart(),
//    cancel=ScoreLeaderboardCancel(),
//    submit=ScoreLeaderboardSubmit(),
//    value=ScoreLeaderboardValue()
//)

for level in LeaderboardLevels
{
    leaderboard(
        id=LeaderboardIDs[level],
        title=format("{0} - Time Attack", LeaderboardLevels[level]),
        description=format("Complete the stage \"{0}\" in the fastest time!", LeaderboardLevels[level]),
        start=if_else(level == 0x0400, LibertyLeaderboardStart(), TimeLeaderboardStart(level)),
        cancel=TimeLeaderboardCancel(),
        submit=TimeLeaderboardSubmit(),
        value=TimeLeaderboardValue(),
        format="CENTISECS",
        lower_is_better=true
    )
}

// ACHIEVEMENTS START

Achievements = {
    0x0102: {
        "id": 428607,
        "title": "Up & Running",
        "description": "Complete the \"Early Bird\" Route.",
        "points": 5,
        "type": "progression",
    },
    0x0500: {
        "id": 428611,
        "title": "Keep the Change",
        "description": "Earn a high enough score to unlock, then complete, the bonus route for the \"Early Bird\" Route.",
        "points": 5,
        "type": "",
    },
    0x0202: {
        "id": 428608,
        "title": "Stay On the Sidewalk, Grandpa",
        "description": "Complete the \"Rush Hour\" Route.",
        "points": 5,
        "type": "progression",
    },
    0x0600: {
        "id": 428612,
        "title": "Loosen Up Your Diapers",
        "description": "Earn a high enough score to unlock, then complete, the bonus route for the \"Rush Hour\" Route.",
        "points": 5,
        "type": "",
    },
    0x302: {
        "id": 428609,
        "title": "The Other Car's Your Enemy",
        "description": "Complete the \"Night Owl\" Route.",
        "points": 5,
        "type": "progression",
    },
    0x700: {
        "id": 428613,
        "title": "Step Aboard the Yellow Sun",
        "description": "Earn a high enough score to unlock, then complete, the bonus route for the \"Night Owl\" Route.",
        "points": 5,
        "type": "",
    },
    0x400: {
        "id": 428610,
        "title": "Let's Smash This Town",
        "description": "Complete the ride in the \"Dusk & Wired\" Route.",
        "points": 5,
        "type": "win_condition",
    },
}

for level in Achievements
{
    params = Achievements[level]
    
    achievement(
        id=params["id"],
        title=params["title"],
        description=params["description"],
        points=params["points"],
        type=params["type"],
        trigger=if_else(level == 0x0400, LibertyLeaderboardStart(), TimeLeaderboardStart(level))
    )
}
