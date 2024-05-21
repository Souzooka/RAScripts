// Sega Rally Championship
// #ID = 28879

// MISC. SCRIPT HELPERS

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

addr = (v) => v // Dummy accessor for ptr for if the pointed-to address is desired
function ptr(base, offsets, accessor=dword)
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

FRAMES_PER_SECOND = 60.0
function FramesToCentiseconds(val)
{
    return val * (100.0 / FRAMES_PER_SECOND)
}

// GAME VARIABLES


// State (ugh)
MainGameState = dword(0x30FD44)
SecondaryGameState = dword(0x30FD48)
TernaryGameState = dword(0x30FD4C)
QuadraryGameState = dword(0x30FD50)

// Fun game variables
Difficulty = byte(0x1E04FC)
DIFFICULTY_VERYEASY = 4
DIFFICULTY_EASY = 1
DIFFICULTY_NORMAL = 0
DIFFICULTY_HARD = 2
DIFFICULTY_VERYHARD = 3

RoundLength = byte(0x1E04FD)
LENGTH_SHORT = 1
LENGTH_NORMAL = 0
LENGTH_LONG = 2
LENGTH_LONGEST = 3

Transmission = dword(0x31011C)
TRANSMISSION_AUTO = 0
TRANSMISSION_MANUAL = 1

Car = dword(0x310144)
CAR_CELICA = 0
CAR_DELTA = 1

Stage = dword(0x310338)
STAGE_DESERT = 0
STAGE_FOREST = 1
STAGE_MOUNTAINS = 2
STAGE_LAKESIDE = 3

// The amount of "progress" on a lap represented internally, used for calculating the top progress bar
PROGRESS_PER_LAP = 300.0 // force calculations to float
ProgressTotal = dword(0x310138)
ProgressLap = dword(0x31013C)

// Note: 0-based (a value of 0 means you are on lap 1, for example)
Laps = dword(0x30FD70)
// Note: 1-based (a value of 1 means there are 1 laps in the event)
MaxLaps = dword(0x30FD74)

RacePosition = dword(0x311710)

// GAME FUNCTIONS

function InGame()
{
    return MainGameState == 3 &&
           any_of([5, 7], state => SecondaryGameState == state) &&
           any_of([2, 3, 4, 5], state => QuadraryGameState == state)
}

function InSelectMenu()
{
           // Game Mode Select
    return MainGameState == 3 &&
           (SecondaryGameState == 3 || 
               // Selecting Car (Championship or Practice)
               (
                   any_of([5, 7], state => SecondaryGameState == state) &&
                   QuadraryGameState == 1
               ) ||
               // Selecting Stage (Practice)
               (
                   SecondaryGameState == 7 &&
                   QuadraryGameState == 3
               )
           )
}

function InChampionship()
{
    return InGame() &&
           any_of([2, 3], state => QuadraryGameState == state)
}

function InPractice()
{
    return InGame() &&
           any_of([4, 5], state => QuadraryGameState == state)
}

function RaceOver(this_frame=true)
{
    this_frame = !this_frame
    return InGame() && 
           TernaryGameState == 9 &&
           (this_frame || prev(TernaryGameState) != 9)
}

function GetLapTime(lap)
{
    return FramesToCentiseconds(dword(0x1e0810 + lap * 4))
}

function GetTotalRaceProgress(max_laps)
{   
    // rcheevos can't handle using a memory lookup (MaxLaps) in place of max_laps here...
    return ProgressTotal / (PROGRESS_PER_LAP * max_laps) * 100.0
}

// RICH PRESENCE

CarLookup = {
    CAR_CELICA: "Celica",
    CAR_DELTA: "Delta",
}

TransmissionLookup = {
    TRANSMISSION_AUTO: "AT",
    TRANSMISSION_MANUAL: "MT",
}

StageLookup = {
    STAGE_DESERT: "Desert",
    STAGE_FOREST: "Forest",
    STAGE_MOUNTAINS: "Mountains",
    STAGE_LAKESIDE: "Lakeside",
}

DifficultyLookup = {
    DIFFICULTY_VERYEASY: "Very Easy",
    DIFFICULTY_EASY: "Easy",
    DIFFICULTY_NORMAL: "Normal",
    DIFFICULTY_HARD: "Hard",
    DIFFICULTY_VERYHARD: "Very Hard",
}

rich_presence_conditional_display(
    InSelectMenu(),
    "Selecting game mode and car"
)
rich_presence_conditional_display(
    InChampionship() && RaceOver(this_frame=false),
    "Driving the {0} ({1}) through {2} | Championship Mode | {3} Difficulty | Lap {4}/{5} (🏁 Stage Complete 🏁) | Position {6}/15",
    rich_presence_lookup("CAR", Car, CarLookup),
    rich_presence_lookup("TRANSMISSION", Transmission, TransmissionLookup),
    rich_presence_lookup("STAGE", Stage, StageLookup),
    rich_presence_lookup("DIFFICULTY", Difficulty, DifficultyLookup),
    rich_presence_value("LAPS", Laps + 1),
    rich_presence_value("MAX_LAPS", MaxLaps),
    rich_presence_value("POSITION", RacePosition)
)
rich_presence_conditional_display(
    InPractice() && RaceOver(this_frame=false),
    "Driving the {0} ({1}) through {2} | Practice Mode | {3} Difficulty | Lap {4}/{5} (🏁 Stage Complete 🏁) | Position {6}/2",
    rich_presence_lookup("CAR", Car, CarLookup),
    rich_presence_lookup("TRANSMISSION", Transmission, TransmissionLookup),
    rich_presence_lookup("STAGE", Stage, StageLookup),
    rich_presence_lookup("DIFFICULTY", Difficulty, DifficultyLookup),
    rich_presence_value("LAPS", Laps + 1),
    rich_presence_value("MAX_LAPS", MaxLaps),
    rich_presence_value("POSITION", RacePosition)
)
rich_presence_conditional_display(
    InChampionship() && any_of([2, 4], state => QuadraryGameState == state),
    "Driving the {0} ({1}) through {2} | Championship Mode | {3} Difficulty | Lap {4}/{5} (Loading Stage)",
    rich_presence_lookup("CAR", Car, CarLookup),
    rich_presence_lookup("TRANSMISSION", Transmission, TransmissionLookup),
    rich_presence_lookup("STAGE", Stage, StageLookup),
    rich_presence_lookup("DIFFICULTY", Difficulty, DifficultyLookup),
    rich_presence_value("LAPS", Laps + 1),
    rich_presence_value("MAX_LAPS", MaxLaps),
    rich_presence_value("POSITION", RacePosition)
)
rich_presence_conditional_display(
    InPractice() && any_of([2, 4], state => QuadraryGameState == state),
    "Driving the {0} ({1}) through {2} | Practice Mode | {3} Difficulty | Lap {4}/{5} (Loading Stage)",
    rich_presence_lookup("CAR", Car, CarLookup),
    rich_presence_lookup("TRANSMISSION", Transmission, TransmissionLookup),
    rich_presence_lookup("STAGE", Stage, StageLookup),
    rich_presence_lookup("DIFFICULTY", Difficulty, DifficultyLookup),
    rich_presence_value("LAPS", Laps + 1),
    rich_presence_value("MAX_LAPS", MaxLaps),
    rich_presence_value("POSITION", RacePosition)
)
for i in range(1, 5)
{
    rich_presence_conditional_display(
        InChampionship() && MaxLaps == i,
        "Driving the {0} ({1}) through {2} | Championship Mode | {3} Difficulty | Lap {4}/{5} ({6}% stage progress) | Position {7}/15",
        rich_presence_lookup("CAR", Car, CarLookup),
        rich_presence_lookup("TRANSMISSION", Transmission, TransmissionLookup),
        rich_presence_lookup("STAGE", Stage, StageLookup),
        rich_presence_lookup("DIFFICULTY", Difficulty, DifficultyLookup),
        rich_presence_value("LAPS", Laps + 1),
        rich_presence_value("MAX_LAPS", MaxLaps),
        rich_presence_value("PROGRESS", GetTotalRaceProgress(i)),
        rich_presence_value("POSITION", RacePosition)
    )
    rich_presence_conditional_display(
        InPractice() && MaxLaps == i,
        "Driving the {0} ({1}) through {2} | Practice Mode | {3} Difficulty | Lap {4}/{5} ({6}% stage progress) | Position {7}/2",
        rich_presence_lookup("CAR", Car, CarLookup),
        rich_presence_lookup("TRANSMISSION", Transmission, TransmissionLookup),
        rich_presence_lookup("STAGE", Stage, StageLookup),
        rich_presence_lookup("DIFFICULTY", Difficulty, DifficultyLookup),
        rich_presence_value("LAPS", Laps + 1),
        rich_presence_value("MAX_LAPS", MaxLaps),
        rich_presence_value("PROGRESS", GetTotalRaceProgress(i)),
        rich_presence_value("POSITION", RacePosition)
    )
}
rich_presence_display(
    "INSERT COIN(S)"
)
