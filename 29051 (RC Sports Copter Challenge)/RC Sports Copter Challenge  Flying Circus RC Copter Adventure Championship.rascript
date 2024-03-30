// R/C Sports Copter Challenge | Flying Circus RC Copter Adventure Championship
// #ID = 29051

NULL = 0
True = 1
False = 0
FRAMES_PER_SECOND = 50

G_INFO = dword(0x269048)
GameStatus = word(G_INFO + 0x0)

EGameStatus_Flight = 1
EGameStatus_PreGoal = 5
EGameStatus_Goal = 6
EGameStatus_TryAgain = 9

OverlayID = word(G_INFO + 0xA)
StageTime = dword(G_INFO + 0x4C)
Energy = dword(G_INFO + 0x54)
Upright = float(G_INFO + 0x5C)

// RICH PRESENCE START

StageLookup = {
    0x4: "Stage 1",
    0x5: "Stage 2",
    0x6: "Stage 3",
    0x7: "Stage 4",
    0x8: "Stage 5",
    0x9: "Stage 6",
}

rich_presence_conditional_display(
    OverlayID >= 4 && OverlayID <= 9,
    "Flying through {0} | 🚁 {1} | 🕒 {2}",
    rich_presence_lookup("Stage", OverlayID, StageLookup),
    "Unknown Heli", // TODO
    rich_presence_value("Time", StageTime * (100.0 / FRAMES_PER_SECOND), "MILLISECS")
)
rich_presence_display("Playing R/C Sports Copter Challenge")

// RICH PRESENCE END

// LEADERBOARDS START

// probably don't need active leaderboards since time and score are shown in-game anyways
WANT_ACTIVE_LEADERBOARD = False

StageNames = {
    0x4: "Stage 1",
    0x5: "Stage 2",
    0x6: "Stage 3",
    0x7: "Stage 4",
    0x8: "Stage 5",
    0x9: "Stage 6",
}

function IsStage(stage)
{
    // For Adventure Stages, they can either be signified by an overlay ID of
    // 0x4, 0x5, 0x6, 0x7, 0x8, 0x9 (challenge) or
    // 0x14, 0x15, 0x16, 0x17, 0x18, 0x19 (adventure)
    // Since coincidentally the adventure stages are 16 indices ahead, we can mask that bit out when checking
    return OverlayID & 0xFFEF == stage
}

function StageOver()
{
    return GameStatus == EGameStatus_Goal && prev(GameStatus) == EGameStatus_PreGoal
}

function StageReset(stage)
{
    return !IsStage(stage) ||
           GameStatus == EGameStatus_TryAgain ||
           StageTime == 0.0 &&
           prev(StageTime) != 0.0
}

function StageLeaderboardStart(overlay_id)
{
    if (WANT_ACTIVE_LEADERBOARD == True)
    {
        return IsStage(overlay_id) &&
               GameStatus == EGameStatus_Flight &&
               prev(StageTime) == 0 &&
               StageTime != 0
    }
    
    return StageLeaderboardSubmit(overlay_id)
}

function StageLeaderboardCancel(overlay_id)
{
    if (WANT_ACTIVE_LEADERBOARD == True)
    {
       return !StageReset(overlay_id)
    }
    
    return always_false()
}

function StageLeaderboardSubmit(overlay_id)
{
    return IsStage(overlay_id) && StageOver()
}

function StageLeaderboardTimeValue(overlay_id)
{
    return StageTime * (100.0 / FRAMES_PER_SECOND)
}

for stage in StageNames
{
    leaderboard(
        title=format("{0} - Time Attack", StageNames[stage]),
        description=format(
            "Play through {0} in Adventure or Challenge Mode and reach the goal as fast as possible!",
            StageNames[stage]
        ),
        start=StageLeaderboardStart(stage),
        cancel=StageLeaderboardCancel(stage),
        submit=StageLeaderboardSubmit(stage),
        value=StageLeaderboardTimeValue(stage),
        format="MILLISECS",
        lower_is_better=true
    )
}

// LEADERBOARDS END

// ACHIEVEMENTS START

StageTitles = {
    // TODO
    0x4: "Complete Stage 1",
    0x5: "Complete Stage 2",
    0x6: "Complete Stage 3",
    0x7: "Complete Stage 4",
    0x8: "Complete Stage 5",
    0x9: "Complete Stage 6",
}

StagePoints = {
    0x4: 5,
    0x5: 10,
    0x6: 10,
    0x7: 10,
    0x8: 10,
    0x9: 10
}

function StageOverTrigger(overlay_id)
{
    return IsStage(overlay_id) && StageOver()
}

for stage in StageNames
{
    achievement(
        title=StageTitles[stage],
        description=format("Complete {0}.", StageNames[stage]),
        points=StagePoints[stage],
        trigger=StageOverTrigger(stage)
    )
}

StageEcoTitles = {
    // TODO
    0x4: "Stage 1 - Eco",
    0x5: "Stage 2 - Eco",
    0x6: "Stage 3 - Eco",
    0x7: "Stage 4 - Eco",
    0x8: "Stage 5 - Eco",
    0x9: "Stage 6 - Eco",
}

StageEcoPoints = {
    0x4: 3,
    0x5: 10,
    0x6: 10,
    0x7: 25,
    0x8: 10,
    0x9: 10,
}

function StageEcoTrigger(stage)
{
    start = once(
        prev(StageTime) == 0 &&
        StageTime != 0 &&
        IsStage(stage) &&
        Energy <= 20000
    )
    reset = never(
        StageReset(stage) ||
        Energy > prev(Energy)
    )
    complete = trigger_when(StageOver())
    return start && reset && complete
}

for stage in StageNames
{
    achievement(
        title=StageEcoTitles[stage],
        description=format("Complete {0} with any RC helicopter with 200 Energy rating or less without recharging.", StageNames[stage]),
        points=StageEcoPoints[stage],
        trigger=StageEcoTrigger(stage)
    )
}

// Super special inverted flight

INVERTED_GRACE_PERIOD = 15

function Stage1InversionTrigger()
{
    // TODO: Probably should put check in start if the heli has safety bar,
    // since this is impossible with it anyways so we shouldn't show the icon
    start = once(
        prev(StageTime) == 0 &&
        StageTime != 0 &&
        IsStage(0x4)
    )
    reset = never(
        StageReset(0x4) ||
        tally(INVERTED_GRACE_PERIOD * FRAMES_PER_SECOND,
            Upright >= 0.0 &&
            StageTime != prev(StageTime)
        )
    )
    complete = trigger_when(StageOver())
    return start && reset && complete
}

achievement(
    title="Take Off the Safety Bar",
    description=format(
        "Complete Stage 1 with solely inverted flight. An allowance of {0} seconds is given for non-inverted flight.",
        INVERTED_GRACE_PERIOD
    ),
    points=10,
    trigger=Stage1InversionTrigger()
)

// ACHIEVEMENTS END