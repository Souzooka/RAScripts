// R/C Sports Copter Challenge | Flying Circus RC Copter Adventure Championship
// #ID = 29051

NULL = 0
True = 1
False = 0
FRAMES_PER_SECOND = 50

function ResolvePointer(base, offsets, accessor=dword)
{
    val = base
    
    for i in range(0, length(offsets) - 1)
    {
        addr = val + offsets[i]
        if (i == length(offsets) - 1)
        {
            val = accessor(addr)
        }
        else
        {
            val = dword(addr)
        }
    }
    
    return val
}

function TimeToFrames(minutes, seconds)
{
    return (minutes * 60 * FRAMES_PER_SECOND) + (seconds * FRAMES_PER_SECOND)
}

G_INFO = dword(0x269048)
GameStatus = word(G_INFO + 0x0)

EGameStatus_Flight = 1
EGameStatus_PreGoal = 5
EGameStatus_Goal = 6
EGameStatus_TryAgain = 9
EGameStatus_Load = 0xB

OverlayID = word(G_INFO + 0xA)
StageTime = dword(G_INFO + 0x4C)
InitialEnergy = dword(G_INFO + 0x38)
InitialDefense = dword(G_INFO + 0x3C)
FinalScore = dword(G_INFO + 0x48)
CurrentScore = dword(G_INFO + 0x50)
Energy = dword(G_INFO + 0x54)
Defense = dword(G_INFO + 0x58)
Upright = float(G_INFO + 0x5C)
HelicopterType = word(G_INFO + 0x6A)

HeliXYZ = [
    ResolvePointer(G_INFO, [0x4A8, 0x10, 0x20], float),
    ResolvePointer(G_INFO, [0x4A8, 0x10, 0x24], float),
    ResolvePointer(G_INFO, [0x4A8, 0x10, 0x28], float),
]

BodyPart = word(0x26972C)
MotorPart = word(0x269730)
RotorPart = word(0x269734)
BatteryPart = word(0x269738)
OptionalPart = word(0x26973C)

Stage1EventFunc = dword(dword(0x26A238) + 0x4)
S1_mouse_help_success = 0x995350
Stage2MouseHelpFlag = word(0x9DD624)
Stage3BillboardBreakFlag = word(0x9D5474)
Stage4TemplePuzzleSteps = word(0x9D07C4)
Stage6EventFunc = dword(dword(0x26B014) + 0x4)
S5_mouse_help_success = 0x9BBB60
Stage6OctopusHits = word(0x9D47C8)
Stage6Combo = word(dword(0x26AF94) + 0x11362)

L_INFO = dword(0x2698B0)
LicenseTime = dword(L_INFO + 0x10)
LicenseTimeLimit = dword(L_INFO + 0x18)
LicenseCurrentPoints = dword(L_INFO + 0x5C)
LicenseID = dword(0x2698C0)
LicenseDifficulty = dword(0x2698C4)

CATCH = 0
CARRY = 1
CRASH = 2
SPOON_RACE = 3
// 4 is unused
HOOP = 5
HOVERING = 6
LANDING = 7

function IsStage(stage)
{
    // For Adventure Stages, they can either be signified by an overlay ID of
    // 0x4, 0x5, 0x6, 0x7, 0x8, 0x9 (challenge) or
    // 0x14, 0x15, 0x16, 0x17, 0x18, 0x19 (adventure)
    // Since coincidentally the adventure stages are 16 indices ahead, we can mask that bit out when checking
    // NOTE: we can't mask out that bit because of issue #456 lmao
    return OverlayID & 0xF == stage
    //return OverlayID & 0xFFEF == stage
}

function IsAdventure()
{
    return OverlayID >= 0x14 && OverlayID <= 0x19
}

function IsChallenge()
{
    return OverlayID >= 0x4 && OverlayID <= 0x9
}

function IsAnyAdventureStage()
{
    return OverlayID & 0xF >= 0x4 && OverlayID & 0xF <= 0x9
}

function StageOver()
{
    // return GameStatus == EGameStatus_Goal && prev(GameStatus) == EGameStatus_PreGoal
    // This'll allow us to get the score for score attack -- when finishing an adventure stage,
    // there is a flat "Goal Bonus" given, so it should be impossible to get a score of 0.
    // NOTE: FinalScore is a running total when in Adventure Mode
    return GameStatus == EGameStatus_Goal && prev(FinalScore) != FinalScore
}

function StageStart(stage)
{
    return IsStage(stage) &&
           StageTime != 0 &&
           prev(StageTime) == 0
}

function StageReset(stage)
{
    return !IsStage(stage) ||
           GameStatus == EGameStatus_TryAgain ||
           StageTime == 0 &&
           prev(StageTime) != 0
}

function IsAnyLicense()
{
    return L_INFO != NULL
}

function IsLicense(license)
{
    return L_INFO != NULL && LicenseID == license
}

function LicenseStart(license)
{
    return IsLicense(license) &&
           LicenseTime != 0 &&
           prev(LicenseTime) == 0
}

function LicenseReset(license)
{
    return !IsLicense(license) ||
           GameStatus == EGameStatus_TryAgain ||
           LicenseTime == 0 &&
           prev(LicenseTime) != 0
}

function GetLicenseScore(license)
{
    checks = {
        CATCH: dword(0x269F18),
        CARRY: dword(0x269F9C),
        CRASH: dword(0x26A100),
        SPOON_RACE: dword(0x26A0D0),
        HOOP: dword(0x26A178),
        HOVERING: dword(0x269F68),
        LANDING: dword(0x269F40),
    }
    scores = {
        CATCH: [dword(checks[CATCH] + 0xB74), word(dword(0x269F1C) + 0xE)], // Total Score, Caught Items
        CARRY: [dword(checks[CARRY] + 0xB74), word(dword(0x269FA0) + 0xF4)], // Total Score, Carried Items
        CRASH: [dword(checks[CRASH] + 0xB74), word(dword(0x26A104) + 0xC)], // Total Score, Walls
        SPOON_RACE: [LicenseTime],
        HOOP: [dword(checks[HOOP] + 0xB74)],
        HOVERING: [dword(checks[HOVERING] + 0xB74)],
        LANDING: [dword(checks[LANDING] + 0xB74)],
    }
    
    score_screen = checks[license]
    points = dword(score_screen + 0xB74)
    state = word(score_screen + 0x6D0)
    
    cond = score_screen != NULL && 
           prev(score_screen) != NULL &&
           state == 0x1E &&
           prev(state) != 0x1E
           
    return [scores[license], cond]
}

function IsSpecialMachine()
{
    return HelicopterType >= 0xA
}


// RICH PRESENCE START

StageLookup = {
    0x4: "Stage 1",
    0x5: "Stage 2",
    0x6: "Stage 3",
    0x7: "Stage 4",
    0x8: "Stage 5",
    0x9: "Stage 6",
}

HelicopterLookup = {
    0x1: "EP Concept SR",
    0x2: "EP Concept Jet Ranger",
    0x3: "EPC Schweizer 300C",
    0x4: "Nexus 30S Type S-R",
    0x5: "Concept 32 VR",
    0x6: "Nexus 46",
    0x7: "Concept 60 SR II",
    0x8: "Caliber 60",
    0x9: "Caliber Swift 60",
    0xA: "UFO",
    0xB: "RAT",
    0xC: "MANTA",
    0xD: "VTOL",
    0xE: "EPC BLACK",
    0xF: "Caliber 90 Flying Circus",
}

BODY = 0
ROTOR = 1
MOTOR = 2
BATTERY = 3

HeliLookups = {
    0x1: {
        BODY: {
            0: "EPCSR-A",
            1: "EPCSR-B",
            2: "EPCSR-C",
        },
        ROTOR: {
            0: "EPR-α",
            1: "EPR-β",
            2: "EPR-γ",
        },
        MOTOR: {
            0: "EPM-α",
            1: "EPM-β",
            2: "EPM-γ",
        },
        BATTERY: {
            0: "BTTRY-α",
            1: "BTTRY-β",
            2: "BTTRY-γ",
        }
    },
    0x2: {
        BODY: {
            0: "EPCJR-A",
            1: "EPCJR-B",
            2: "EPCJR-C",
        },
        ROTOR: {
            0: "EPR-α",
            1: "EPR-β",
            2: "EPR-γ",
        },
        MOTOR: {
            0: "EPM-α",
            1: "EPM-β",
            2: "EPM-γ",
        },
        BATTERY: {
            0: "BTTRY-α",
            1: "BTTRY-β",
            2: "BTTRY-γ",
        }
    },
    0x3: {
        BODY: {
            0: "EPSWS-A",
            1: "EPSWS-B",
            2: "EPSWS-C",
        },
        ROTOR: {
            0: "EPR-α",
            1: "EPR-β",
            2: "EPR-γ",
        },
        MOTOR: {
            0: "EPM-α",
            1: "EPM-β",
            2: "EPM-γ",
        },
        BATTERY: {
            0: "BTTRY-α",
            1: "BTTRY-β",
            2: "BTTRY-γ",
        }
    },
    0x4: {
        BODY: {
            0: "NX30S-A",
            1: "NX30S-B",
            2: "NX30S-C",
        },
        ROTOR: {
            0: "30R-α",
            1: "30R-β",
            2: "30R-γ",
        },
        MOTOR: {
            0: "30EGN-α",
            1: "30EGN-β",
            2: "30EGN-γ",
        },
        BATTERY: {
            0: "30GTK-α",
            1: "30GTK-β",
            2: "30GTK-γ",
        }
    },
    0x5: {
        BODY: {
            0: "C32VA-A",
            1: "C32VA-B",
            2: "C32VA-C",
        },
        ROTOR: {
            0: "30R-α",
            1: "30R-β",
            2: "30R-γ",
        },
        MOTOR: {
            0: "30EGN-α",
            1: "30EGN-β",
            2: "30EGN-γ",
        },
        BATTERY: {
            0: "30GTK-α",
            1: "30GTK-β",
            2: "30GTK-γ",
        }
    },
    0x6: {
        BODY: {
            0: "NXF46-A",
            1: "NXF46-B",
            2: "NXF46-C",
        },
        ROTOR: {
            0: "30R-α",
            1: "30R-β",
            2: "30R-γ",
        },
        MOTOR: {
            0: "30EGN-α",
            1: "30EGN-β",
            2: "30EGN-γ",
        },
        BATTERY: {
            0: "30GTK-α",
            1: "30GTK-β",
            2: "30GTK-γ",
        }
    },
    0x7: {
        BODY: {
            0: "60SR2-A",
            1: "60SR2-B",
            2: "60SR3-C",
        },
        ROTOR: {
            0: "60R-α",
            1: "60R-β",
            2: "60R-γ",
        },
        MOTOR: {
            0: "60EGN-α",
            1: "60EGN-β",
            2: "60EGN-γ",
        },
        BATTERY: {
            0: "60GTK-α",
            1: "60GTK-β",
            2: "60GTK-γ",
        }
    },
    0x8: {
        BODY: {
            0: "CLR60-A",
            1: "CLR60-B",
            2: "CLR60-C",
        },
        ROTOR: {
            0: "60R-α",
            1: "60R-β",
            2: "60R-γ",
        },
        MOTOR: {
            0: "60EGN-α",
            1: "60EGN-β",
            2: "60EGN-γ",
        },
        BATTERY: {
            0: "60GTK-α",
            1: "60GTK-β",
            2: "60GTK-γ",
        }
    },
    0x9: {
        BODY: {
            0: "C60SW-A",
            1: "C60SW-B",
            2: "C60SW-C",
        },
        ROTOR: {
            0: "60R-α",
            1: "60R-β",
            2: "60R-γ",
        },
        MOTOR: {
            0: "60EGN-α",
            1: "60EGN-β",
            2: "60EGN-γ",
        },
        BATTERY: {
            0: "60GTK-α",
            1: "60GTK-β",
            2: "60GTK-γ",
        }
    },
}

OptionalPartLookup = {
    0: "No Optional Parts",
    1: "Safety Bar",
}

LicenseLookup = {
    0: "Catching Items in the Catch License",
    1: "Carrying Items in the Carry License",
    2: "Crashing through walls in the Crash License",
    3: "Precariously racing around a track in the Spoon Race License",
    4: "NONE",
    5: "Flying through hoops in the Hoop License",
    6: "Hovering over lights in the Hovering License",
    7: "Landing on targets in the Landing License",
}

LicenseDifficultyLookup = {
    0: "Beginner",
    1: "Intermediate",
    2: "Advanced",
}

// Adventure/Challenge
// Store-bought helicopters
for heli in HeliLookups
{
    rich_presence_conditional_display(
        IsAnyAdventureStage() && GameStatus != EGameStatus_Load && HelicopterType == heli,
        "Flying through {0} | 🕒 {1} | 🚁 {2} | {3} | {4} | {5} | {6} | {7}",
        rich_presence_lookup("Stage", OverlayID, StageLookup),
        rich_presence_value("Time", StageTime / (FRAMES_PER_SECOND / 100.0), "MILLISECS"),
        rich_presence_lookup("Helicopter", heli, HelicopterLookup),
        rich_presence_lookup(format("Body{0}", heli), BodyPart, HeliLookups[heli][BODY]),
        rich_presence_lookup(format("Rotor{0}", heli), RotorPart, HeliLookups[heli][ROTOR]),
        rich_presence_lookup(format("Motor{0}", heli), MotorPart, HeliLookups[heli][MOTOR]),
        rich_presence_lookup(format("Battery{0}", heli), BatteryPart, HeliLookups[heli][BATTERY]),
        rich_presence_lookup("Optional", OptionalPart, OptionalPartLookup)
    )
}
// Special (non-customizable) helicopters
rich_presence_conditional_display(
    IsAnyAdventureStage() && GameStatus != EGameStatus_Load,
    "Flying through {0} | 🕒 {1} | 🚁 {2}",
    rich_presence_lookup("Stage", OverlayID, StageLookup),
    rich_presence_value("Time", StageTime / (FRAMES_PER_SECOND / 100.0), "MILLISECS"),
    rich_presence_lookup("Helicopter", HelicopterType, HelicopterLookup)
)
// License
// Store-bought helicopters
for heli in HeliLookups
{
    rich_presence_conditional_display(
        IsAnyLicense() && GameStatus != EGameStatus_Load && HelicopterType == heli,
        "{0} ({1}) | 🚁 {2} | {3} | {4} | {5} | {6} | {7}",
        rich_presence_lookup("License", LicenseID, LicenseLookup),
        rich_presence_lookup("Difficulty", LicenseDifficulty, LicenseDifficultyLookup),
        rich_presence_lookup("Helicopter", heli, HelicopterLookup),
        rich_presence_lookup(format("Body{0}", heli), BodyPart, HeliLookups[heli][BODY]),
        rich_presence_lookup(format("Rotor{0}", heli), RotorPart, HeliLookups[heli][ROTOR]),
        rich_presence_lookup(format("Motor{0}", heli), MotorPart, HeliLookups[heli][MOTOR]),
        rich_presence_lookup(format("Battery{0}", heli), BatteryPart, HeliLookups[heli][BATTERY]),
        rich_presence_lookup("Optional", OptionalPart, OptionalPartLookup)
    )
}
// Special (non-customizable) helicopters
rich_presence_conditional_display(
    IsAnyLicense() && GameStatus != EGameStatus_Load,
    "{0} ({1}) | 🚁 {2}",
    rich_presence_lookup("License", LicenseID, LicenseLookup),
    rich_presence_lookup("Difficulty", LicenseDifficulty, LicenseDifficultyLookup),
    rich_presence_lookup("Helicopter", HelicopterType, HelicopterLookup)
)
rich_presence_display("Playing R/C Sports Copter Challenge")

// RICH PRESENCE END

// LEADERBOARDS START

// probably don't need active leaderboards since time and score are shown in-game anyways
WANT_REALTIME_LEADERBOARD = False

// Adventure/Challenge Mode

StageNames = {
    0x4: "Stage 1",
    0x5: "Stage 2",
    0x6: "Stage 3",
    0x7: "Stage 4",
    0x8: "Stage 5",
    0x9: "Stage 6",
}

function StageLeaderboardStart(overlay_id, include_adventure=true)
{
    if (WANT_REALTIME_LEADERBOARD == True)
    {
        mode_cond = always_true()
        if include_adventure == false
        {
            mode_cond = IsChallenge()
        }
    
        return StageStart(overlay_id) && mode_cond
    }
    
    return StageLeaderboardSubmit(overlay_id, include_adventure)
}

function StageLeaderboardCancel(overlay_id)
{
    if (WANT_REALTIME_LEADERBOARD == True)
    {
       return StageReset(overlay_id)
    }
    
    return always_false()
}

function StageLeaderboardSubmit(overlay_id, include_adventure=true)
{
    mode_cond = always_true()
    if include_adventure == false
    {
        mode_cond = IsChallenge()
    }

    return IsStage(overlay_id) && StageOver() && mode_cond
}

function StageLeaderboardTimeValue(overlay_id)
{
    return StageTime * (100.0 / FRAMES_PER_SECOND)
}

function StageLeaderboardScoreValue(overlay_id)
{
    return max_of(
        measured(FinalScore),
        measured(CurrentScore)
    )
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
    leaderboard(
        title=format("{0} - Point Attack", StageNames[stage]),
        // you keep a running score in Adventure Mode -- wow that's really fair for the rankings devs
        description=format(
            "Play through {0} in Challenge Mode and obtain as many points as possible!",
            StageNames[stage]
        ),
        start=StageLeaderboardStart(stage, include_adventure=false),
        cancel=StageLeaderboardCancel(stage),
        submit=StageLeaderboardSubmit(stage, include_adventure=false),
        value=StageLeaderboardScoreValue(stage),
        format="VALUE"
    )
}

// License Mode

LicenseNames = {
    CATCH: "Catch",
    CARRY: "Carry",
    CRASH: "Crash",
    SPOON_RACE: "Spoon Race",
    HOOP: "Hoop",
    HOVERING: "Hovering",
    LANDING: "Landing",
}

function LeaderboardLicenseStart(license, difficulty)
{
    _ = GetLicenseScore(license)
    submit = _[1] && LicenseDifficulty == difficulty
    return submit
}

function LeaderboardLicenseCancel(license)
{
    return always_false()
}

function LeaderboardLicenseSubmit(license)
{
    return always_true()
}

function LeaderboardDefaultLicenseValue(license)
{
    _ = GetLicenseScore(license)
    return _[0][0]
}

function LeaderboardSpoonRaceValue(license=0)
{
    _ = GetLicenseScore(SPOON_RACE)
    time = _[0][0]
    
    return time / (FRAMES_PER_SECOND / 100.0)
}

for license in LicenseNames
{
    // Leaderboard config
    value = LeaderboardDefaultLicenseValue
    format = "VALUE"
    lower_is_better = false
    name = "Point Attack"
    goal = "obtain as many points as possible"
    if (license == SPOON_RACE)
    {
        value = LeaderboardSpoonRaceValue
        format = "MILLISECS"
        lower_is_better = true
        name = "Time Attack"
        goal = "reach the finish line as fast as possible"
    }
    
    _ = GetLicenseScore(license)
    submit = _[1]
    
    for difficulty in range(0, 3 - 1)
    {
        leaderboard(
            title=format("{0} {1} - {2}", LicenseNames[license], LicenseDifficultyLookup[difficulty], name),
            description=format("Play {0} License on the {1} Difficulty and {2}!", LicenseNames[license], LicenseDifficultyLookup[difficulty], goal),
            start=LeaderboardLicenseStart(license, difficulty),
            cancel=LeaderboardLicenseCancel(license),
            submit=LeaderboardLicenseSubmit(license),
            value=value(license),
            format=format,
            lower_is_better=lower_is_better
        )
    }
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
    0x9: "You Are the King of Topflyer!",
}

StagePoints = {
    0x4: 5,
    0x5: 10,
    0x6: 10,
    0x7: 10,
    0x8: 10,
    0x9: 25,
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
        StageStart(stage) &&
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
    //achievement(
    //    title=StageEcoTitles[stage],
    //    description=format("Complete {0} with any RC helicopter with 200 Energy rating or less without recharging.", StageNames[stage]),
    //    points=StageEcoPoints[stage],
    //    trigger=StageEcoTrigger(stage)
    //)
}

// Stage 1 - Super special inverted flight

INVERTED_GRACE_PERIOD = 15

function Stage1InversionTrigger()
{
    start = once(StageStart(0x4) && OptionalPart == 0)
    reset = never(
        StageReset(0x4) ||
        tally(INVERTED_GRACE_PERIOD * FRAMES_PER_SECOND,
            Upright >= 0.0 &&
            StageTime != prev(StageTime) // Prevents hits ticking up during pause
        )
    )
    complete = trigger_when(StageOver())
    return start && reset && complete
}

achievement(
    title="Confused Conductor",
    description=format(
        "Complete Stage 1 with solely inverted flight. An allowance of {0} seconds is given for non-inverted flight." +
        " You'll need to remove your helicopter's Safety Bar to achieve inverted flight!",
        INVERTED_GRACE_PERIOD
    ),
    points=10,
    trigger=Stage1InversionTrigger()
)

// Stage 2 - No Damage

function Stage2NoDamageTrigger()
{
    start = once(StageStart(0x5) && OptionalPart == 0)
    reset = never(
        StageReset(0x5) ||
        Defense < InitialDefense
    )
    complete = trigger_when(StageOver())
    return start && reset && complete
}

achievement(
    title="Damageless Dungeon Diver",
    description="Complete Stage 2 without receiving any damage to your helicopter. Use of a Safety Bar is disallowed.",
    points=25,
    trigger=Stage2NoDamageTrigger()
)

// Stage 3 - Speedrun

function Stage3SpeedrunTrigger()
{
    start = once(StageStart(0x6))
    reset = never(
        StageReset(0x6) ||
        StageTime >= TimeToFrames(3, 20)
    )
    complete = trigger_when(StageOver())
    return start && reset && complete
}

achievement(
    title="Skyline Speeder",
    description="Complete Stage 3 in under 3 minutes and 20 seconds.",
    points=25,
    trigger=Stage3SpeedrunTrigger()
)

// Stage 4 - No Upgrades

function Stage4NoUpgradesTrigger()
{
    start = once(
        StageStart(0x7) &&
        HelicopterType == 1 &&
        BodyPart == 0 &&
        RotorPart == 0 &&
        MotorPart == 0 &&
        BatteryPart == 0
    )
    cancel = never(
        StageReset(0x7)
    )
    complete = trigger_when(StageOver())
    return start && cancel && complete
}

achievement(
    title="Frugal Flier",
    description="Complete Stage 4 using the starting helicopter and parts: " + 
    "EP Concept SR, EPCSR-A, EPR-α, EPM-α, BTTRY-α. The Safety Bar can be removed.",
    points=10,
    trigger=Stage4NoUpgradesTrigger()
)

// Stage 5 - Inversion 2

INVERTED_GRACE_PERIOD2 = 35

function Stage5InversionTrigger()
{
    start = once(StageStart(0x8) && OptionalPart == 0)
    reset = never(
        StageReset(0x8) ||
        tally(INVERTED_GRACE_PERIOD2 * FRAMES_PER_SECOND,
            Upright >= 0.0 &&
            StageTime != prev(StageTime) // Prevents hits ticking up during pause
        )
    )
    complete = trigger_when(StageOver())
    return start && reset && complete
}

achievement(
    title="Confused Conductor II",
    description=format(
        "Complete Stage 5 with solely inverted flight. An allowance of {0} seconds is given for non-inverted flight.",
        INVERTED_GRACE_PERIOD2
    ),
    points=25,
    trigger=Stage5InversionTrigger()
)

// Stage 6 - Combo

function Stage6ComboTrigger()
{
    // NOTE: Combo is offset by 1
    return IsStage(0x9) &&
           prev(Stage6Combo) == 21 - 1 &&
           Stage6Combo == 22 - 1
}

achievement(
    title="Ace Acrobat",
    description="Obtain a 22 Combo in Stage 6.",
    points=5,
    trigger=Stage6ComboTrigger()
)

// Stage 1/5 -- Save drowning mouse

function Stage5MouseSaviorTrigger()
{
    return any_of([0x4, 0x8], stage => IsStage(stage)) &&
           prev(Stage1EventFunc) != S1_mouse_help_success &&
           Stage1EventFunc == S1_mouse_help_success
}

achievement(
    title="Stage 5 Mouse Savior",
    description="Save the drowning mouse in Stage 1 or 5.",
    points=2,
    trigger=Stage5MouseSaviorTrigger()
)

// Stage 2 -- Help mouse get back home

function Stage2MouseSaviorTrigger()
{
    return IsStage(0x5) &&
           prev(Stage2MouseHelpFlag) < 2 &&
           Stage2MouseHelpFlag == 2
}

achievement(
    title="Stage 2 Mouse Savior",
    description="Help the mouse across the moat in Stage 2.",
    points=2,
    trigger=Stage2MouseSaviorTrigger()
)

// Stage 2 -- Moat Secret Passage

_ = v => v
function HeliInBox(box, pred=_)
{
    box_cond = always_true()
    for i in range(0, 3 - 1)
    {
        box_min_x = box[0][i]
        box_max_x = box[1][i]
        heli_x = pred(HeliXYZ[i])
        
        box_cond = box_cond && (box_min_x <= heli_x && heli_x <= box_max_x)
    }
    
    return box_cond
}

function Stage2SecretPassageTrigger()
{
    box = [
        [-181.0, -16.0, 120.0],
        [-177.0, -10.0, 125.0],
    ]
    
    return IsStage(0x5) &&
           !HeliInBox(box, prev) &&
           HeliInBox(box)
}

achievement(
    title="What's Down There?",
    description="Discover a secret passage to the castle dungeon in Stage 2.",
    points=5,
    trigger=Stage2SecretPassageTrigger()
)

// Stage 3 -- Discover billboard shortcut

function Stage3BillboardBreakTrigger()
{
    return IsStage(0x6) &&
           prev(Stage3BillboardBreakFlag) < 2 &&
           Stage3BillboardBreakFlag == 2
}

achievement(
    title="Come On",
    description="Bust through a billboard and discover a shortcut in Stage 3.",
    points=3,
    trigger=Stage3BillboardBreakTrigger()
)

// Stage 4 -- Solve Temple Puzzle

function Stage4TemplePuzzleTrigger()
{
    return IsStage(0x7) &&
           prev(Stage4TemplePuzzleSteps) == 3 &&
           Stage4TemplePuzzleSteps == 4
}

achievement(
    title="Stage 4 Temple Puzzle",
    description="Solve the puzzle inside the temple in Stage 4.",
    points=4,
    trigger=Stage4TemplePuzzleTrigger()
)

// Stage 6 -- Save drowning mouse

function Stage6MouseSaviorTrigger()
{
    return IsStage(0x9) &&
           prev(Stage6EventFunc) != S5_mouse_help_success &&
           Stage6EventFunc == S5_mouse_help_success
}

achievement(
    title="Stage 6 Mouse Savior",
    description="Save the drowning mouse in Stage 6.",
    points=2,
    trigger=Stage6MouseSaviorTrigger()
)

// Stage 6 -- Kill Octopus

function Stage6OctopusDeadTrigger()
{
    return IsStage(0x9) &&
           prev(Stage6OctopusHits) != 3 &&
           Stage6OctopusHits == 3
}

achievement(
    title="Stage 6 Octopus Killer",
    description="Defeat the Octopus in Stage 6",
    points=3,
    trigger=Stage6OctopusDeadTrigger()
)

// Licenses

function AchievementLicenseScore(license)
{
    _ = GetLicenseScore(license)
    
    pred0 = v => v[0]
    pred1 = v => v[1]
    
    transform = {
        CATCH: pred1,
        CARRY: pred1,
        CRASH: pred1,
        SPOON_RACE: pred0,
        HOOP: pred0,
        HOVERING: pred0,
        LANDING: pred0,
    }
    
    fn = transform[license]
    return fn(_[0])
}

LicenseScores = {
    CATCH: [10, 15, 25],
    CARRY: [3, 5, 15],
    CRASH: [30, 50, 85],
    SPOON_RACE: [[1, 30], [1, 0], [0, 40]],
    HOOP: [2000, 4000, 10000],
    HOVERING: [1000, 1500, 4500],
    LANDING: [1500, 3000, 5500],
}

LicenseIDs = {
    CATCH: [
        
    ],
    CARRY: [
        
    ],
    CRASH: [
        
    ],
    SPOON_RACE: [
        
    ],
    HOOP: [
        
    ],
    HOVERING: [
        
    ],
    LANDING: [
        
    ],
}

LicenseTitles = {
    // TODO
    CATCH: [
        "Catch Beginner",
        "Catch Intermediate",
        "Catch Advanced",
    ],
    CARRY: [
        "Carry Beginner",
        "Carry Intermediate",
        "Carry Advanced",
    ],
    CRASH: [
        "Crash Beginner",
        "Crash Intermediate",
        "Crash Advanced",
    ],
    SPOON_RACE: [
        "Spoon Race Beginner",
        "Spoon Race Intermediate",
        "Spoon Race Advanced",
    ],
    HOOP: [
        "Hoop Beginner",
        "Hoop Intermediate",
        "Hoop Advanced",
    ],
    HOVERING: [
        "Hovering Beginner",
        "Hovering Intermediate",
        "Hovering Advanced",
    ],
    LANDING: [
        "Landing Beginner",
        "Landing Intermediate",
        "Landing Advanced",
    ],
}

LicenseDescriptions = {
    CATCH: "Complete the Catch License on {0} difficulty and catch at least {1} items.",
    CARRY: "Complete the Carry License on {0} difficulty and carry at least {1} items.",
    CRASH: "Complete the Crash License on {0} difficulty and crash through at least {1} walls.",
    SPOON_RACE: [
        "Complete the Spoon Race License on {0} difficulty in under {1} minutes and {2} seconds.",
        "Complete the Spoon Race License on {0} difficulty in under {1} minute.",
        "Complete the Spoon Race License on {0} difficulty in under {1} seconds.",
    ],
    HOOP: "Complete the Hoop License on {0} difficulty and obtain at least {1} points.",
    HOVERING: "Complete the Hovering License on {0} difficulty and obtain at least {1} points.",
    LANDING: "Complete the Landing License on {0} difficulty and obtain at least {1} points.",
}

LicensePoints = {
    CATCH: [3, 4, 10],
    CARRY: [3, 4, 10],
    CRASH: [3, 4, 10],
    SPOON_RACE: [3, 4, 10],
    HOOP: [3, 4, 10],
    HOVERING: [3, 4, 10],
    LANDING: [3, 4, 10],
}

for license in LicenseNames
{
    for difficulty in range(0, 3 - 1)
    {
        score = AchievementLicenseScore(license)
        target = LicenseScores[license][difficulty]
        if license == SPOON_RACE
        {
            minutes = target[0]
            seconds = target[1]
            if minutes != 0 && seconds == 0
            {
                description = format(LicenseDescriptions[license][1], LicenseDifficultyLookup[difficulty], minutes)
            }
            else if minutes != 0
            {
                description = format(LicenseDescriptions[license][0], LicenseDifficultyLookup[difficulty], minutes, seconds)
            }
            else
            {
                description = format(LicenseDescriptions[license][2], LicenseDifficultyLookup[difficulty], seconds)
            }
            target = TimeToFrames(minutes, seconds)
            score_cond = score < target
        }
        else
        {
            description = format(LicenseDescriptions[license], LicenseDifficultyLookup[difficulty], target)
            score_cond = score >= target
        }
        
        _ = GetLicenseScore(license)
        trigger_cond = _[1]
        
        achievement(
            title=LicenseTitles[license][difficulty],
            description=description,
            points=LicensePoints[license][difficulty],
            trigger=LicenseDifficulty == difficulty && trigger_cond && score_cond
        )
    }
}

// ACHIEVEMENTS END
