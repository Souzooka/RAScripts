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
EGameStatus_Load = 0xB

OverlayID = word(G_INFO + 0xA)
StageTime = dword(G_INFO + 0x4C)
InitialEnergy = dword(G_INFO + 0x38)
InitialDefense = dword(G_INFO + 0x3C)
Energy = dword(G_INFO + 0x54)
Defense = dword(G_INFO + 0x58)
Upright = float(G_INFO + 0x5C)
HelicopterType = word(G_INFO + 0x6A)

BodyPart = word(0x26972C)
MotorPart = word(0x269730)
RotorPart = word(0x269734)
BatteryPart = word(0x269738)
OptionalPart = word(0x26973C)

function IsStage(stage)
{
    // For Adventure Stages, they can either be signified by an overlay ID of
    // 0x4, 0x5, 0x6, 0x7, 0x8, 0x9 (challenge) or
    // 0x14, 0x15, 0x16, 0x17, 0x18, 0x19 (adventure)
    // Since coincidentally the adventure stages are 16 indices ahead, we can mask that bit out when checking
    return OverlayID & 0xFFEF == stage
}

function IsAnyAdventureStage()
{
    return (OverlayID & 0xFFEF) >= 0x4 && (OverlayID & 0xFFEF) <= 0x9
}

function StageOver()
{
    return GameStatus == EGameStatus_Goal && prev(GameStatus) == EGameStatus_PreGoal
}

function StageStart(stage)
{
    return IsStage(stage) &&
           StageTime != 0.0 &&
           prev(StageTime) == 0.0
}

function StageReset(stage)
{
    return !IsStage(stage) ||
           GameStatus == EGameStatus_TryAgain ||
           StageTime == 0.0 &&
           prev(StageTime) != 0.0
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

// Store-bought helicopters
for heli in HeliLookups
{
    rich_presence_conditional_display(
        IsAnyAdventureStage() && GameStatus != EGameStatus_Load && HelicopterType == heli,
        "Flying through {0} | 🕒 {1} | 🚁 {2} | {3} | {4} | {5} | {6} | {7}",
        rich_presence_lookup("Stage", OverlayID, StageLookup),
        rich_presence_value("Time", StageTime / (50.0 / 100.0), "MILLISECS"),
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
    rich_presence_value("Time", StageTime / (50.0 / 100.0), "MILLISECS"),
    rich_presence_lookup("Helicopter", HelicopterType, HelicopterLookup)
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

function StageLeaderboardStart(overlay_id)
{
    if (WANT_ACTIVE_LEADERBOARD == True)
    {
        return StageStart(overlay_id)
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
    achievement(
        title=StageEcoTitles[stage],
        description=format("Complete {0} with any RC helicopter with 200 Energy rating or less without recharging.", StageNames[stage]),
        points=StageEcoPoints[stage],
        trigger=StageEcoTrigger(stage)
    )
}

// Stage 1 - Super special inverted flight

INVERTED_GRACE_PERIOD = 15

function Stage1InversionTrigger()
{
    // TODO: Probably should put check in start if the heli has safety bar,
    // since this is impossible with it anyways so we shouldn't show the icon
    start = once(StageStart(0x4))
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
    title="Take Off the Safety Bar",
    description=format(
        "Complete Stage 1 with solely inverted flight. An allowance of {0} seconds is given for non-inverted flight.",
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
    title="Castle Dungeons Toughen Up a Guy",
    description="Complete Stage 2 without receiving any damage to your helicopter. Use of a Safety Bar is disallowed.",
    points=25,
    trigger=Stage2NoDamageTrigger()
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

// ACHIEVEMENTS END