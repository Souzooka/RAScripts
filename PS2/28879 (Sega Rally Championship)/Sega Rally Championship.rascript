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

function assert(cond)
{
    if cond == false
    {
        // This won't compile, causing an error to appear if evaluated
        return (byte(0) + byte(1)) * (byte(2) + byte(3))
    }
    
    return true
}

FRAMES_PER_SECOND = 60.0
function FramesToCentiseconds(val)
{
    return val * (100.0 / FRAMES_PER_SECOND)
}

function TimeToCentiseconds(minutes=0, seconds=0, frames=0)
{
    return FramesToCentiseconds(minutes * (60 * FRAMES_PER_SECOND) + (seconds * FRAMES_PER_SECOND) + frames)
}

function array_index(arr, val)
{
    i = 0
    for item in arr
    {
        if (item == val)
        {
            return i
        }
        i = i + 1
    }
    
    // didn't find the value :(
    return assert(false)
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
STAGE_MOUNTAIN = 2
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
function InGame(championship=false, practice=false)
{
    // Both championship and practice are false by default to prevent generic functions like RaceOver()
    // from introducing them into achievement logic, but at some point the logic should pass true to at least
    // one of the arguments
    sub_states = []
    if championship
    {
        array_push(sub_states, 2)
        array_push(sub_states, 3)
    }
    if practice
    {
        array_push(sub_states, 4)
        array_push(sub_states, 5)
    }

    return MainGameState == 3 &&
           any_of([5, 7], state => SecondaryGameState == state) &&
           if_else(length(sub_states) > 0, any_of(sub_states, state => QuadraryGameState == state), always_true())
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
    return InGame(championship=true, practice=false)
}

function InPractice()
{
    return InGame(championship=false, practice=true)
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

function GetTotalTime()
{
    return FramesToCentiseconds(dword(0x30fd60))
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
    STAGE_MOUNTAIN: "Mountain",
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

// LEADERBOARDS

// Lap times
LapLeaderboards = {
    STAGE_DESERT: {
        "id": 102672,
        "name": "Desert",
    },
    STAGE_FOREST: {
        "id": 102673,
        "name": "Forest",
    },
    STAGE_MOUNTAIN: {
        "id": 102674,
        "name": "Mountain",
    },
    STAGE_LAKESIDE: {
        "id": 102675,
        "name": "Lakeside",
    },
}

for stage in LapLeaderboards
{
    params = LapLeaderboards[stage]
    leaderboard(
        id=params["id"],
        title=format("{0} - Best Lap", params["name"]),
        description=format("Achieve the fastest lap time in the {0} stage!", params["name"]),
        // NOTE: Completing the event does not increment the lap counter (we'll also have to grab
        // the delta lap count in value to account for both scenarios)
        start=Stage == stage && 
              InGame(championship=true, practice=true) &&
              (RaceOver(this_frame=true) || Laps > prev(Laps)),
        cancel=always_false(),
        submit=always_true(),
        value=GetLapTime(prev(Laps)),
        format="CENTISECS",
        lower_is_better=true
    )
}

// Championship (Normal / Longest)

ChampionshipLeaderboards = [
    {
        "id": 102676,
        "lengths": [LENGTH_SHORT, LENGTH_NORMAL, LENGTH_LONG],
        "title": "Championship Mode (1 Lap Stages) - Fastest Time",
        "description": "Complete the Championship Mode on any Length but Longest in the fastest time!"
    },
    {
        "id": 102677,
        "lengths": [LENGTH_LONGEST],
        "title": "Championship Mode (5 Lap Stages) - Fastest Time",
        "description": "Complete the Championship Mode on the Longest Length in the fastest time!"
    }
]

for params in ChampionshipLeaderboards
{
    lengths = params["lengths"]
    leaderboard(
        id=params["id"],
        title=params["title"],
        description=params["description"],
        start=InChampionship() &&
              Stage == STAGE_MOUNTAIN &&
              any_of(lengths, length => RoundLength == length) &&
              RaceOver(this_frame=true),
        cancel=always_false(),
        submit=always_true(),
        value=GetTotalTime(),
        format="CENTISECS",
        lower_is_better=true
    )
}

// ACHIEVEMENTS

function ChampionshipRaceOverTrigger(stage, difficulty, longest=false, extra_cond=always_true())
{
    // Get a list of the valid difficulties (i.e. difficulty or harder difficulty) for an achievement
    difficulties = [DIFFICULTY_VERYEASY, DIFFICULTY_EASY, DIFFICULTY_NORMAL, DIFFICULTY_HARD, DIFFICULTY_VERYHARD]
    difficulty_idx = array_index(difficulties, difficulty)
    valid_difficulties = []
    for i in range(difficulty_idx, length(difficulties) - 1)
    {
        array_push(valid_difficulties, difficulties[i])
    }
    
           // Correct game mode
    return InChampionship() &&
           // Correct stage
           Stage == stage &&
           // Is correct difficulty or harder
           if_else(difficulty != DIFFICULTY_VERYEASY, any_of(valid_difficulties, difficulty => Difficulty == difficulty), always_true()) &&
           // Is longest length, if we want it
           if_else(longest, RoundLength == LENGTH_LONGEST, always_true()) &&
           // Extra spice
           extra_cond &&
           // The race ended
           RaceOver(this_frame=true)
}

// Complete stage 3 and 4 on normal or higher
// I don't know how you'd complete stage 3 without being 1st (on regular round length) but I'll include that
// condition just so I have something to use for the badge
achievement(
    id=429808,
    title="Lap Leader",
    description="In Championship Mode, complete the Mountain stage on Normal or higher difficulty in 1st place.",
    points=10,
    type="progression",
    trigger=ChampionshipRaceOverTrigger(STAGE_MOUNTAIN, DIFFICULTY_NORMAL, extra_cond=RacePosition==1)
)
achievement(
    id=429809,
    title="Sega Rally Champion",
    description="In Championship Mode, complete the Lakeside stage on Normal or higher difficulty.",
    points=25,
    type="win_condition",
    trigger=ChampionshipRaceOverTrigger(STAGE_LAKESIDE, DIFFICULTY_NORMAL)
)

// Manual Transmission Championship
achievement(
    id=429816,
    title="Top Gear",
    description="In Championship Mode, complete the Lakeside stage on Normal or higher difficulty with a Manual Transmission car.",
    points=10,
    trigger=ChampionshipRaceOverTrigger(STAGE_LAKESIDE, DIFFICULTY_NORMAL, extra_cond=Transmission == TRANSMISSION_MANUAL)
)

// Longest :)
achievement(
    id=429810,
    title="The Neverending Rally",
    description="In Championship Mode, complete the Mountain stage with round length set to Longest and achieve a total time under 17 minutes and 30 seconds " +
                "[The length can be altered by pressing Select while in the attract mode].",
    points=25,
    trigger=ChampionshipRaceOverTrigger(STAGE_MOUNTAIN, DIFFICULTY_VERYEASY, longest=true, extra_cond=GetTotalTime() < TimeToCentiseconds(minutes=17, seconds=30))
)

// Very hard
FORMAT_STR = "In Championship Mode, complete the {0} stage on the Very Hard difficulty{1}."
achievement(
    id=429811,
    title="Desert Land",
    description=format(FORMAT_STR, "Desert", " [The difficulty can be altered by pressing Select while in the attract mode]"),
    points=5,
    trigger=ChampionshipRaceOverTrigger(STAGE_DESERT, DIFFICULTY_VERYHARD)
)
achievement(
    id=429812,
    title="Conditioned Reflex",
    description=format(FORMAT_STR, "Forest", ""),
    points=10,
    trigger=ChampionshipRaceOverTrigger(STAGE_FOREST, DIFFICULTY_VERYHARD)
)
achievement(
    id=429813,
    title="Getting Muddy",
    description=format(FORMAT_STR, "Mountain", ""),
    points=25,
    trigger=ChampionshipRaceOverTrigger(STAGE_MOUNTAIN, DIFFICULTY_VERYHARD)
)
achievement(
    id=429814,
    title="My Dear Friend Rally",
    description=format(FORMAT_STR, "Lakeside", ""),
    points=50,
    trigger=ChampionshipRaceOverTrigger(STAGE_LAKESIDE, DIFFICULTY_VERYHARD)
)

// Practice mode
achievement(
    id=429815,
    title="Ignition",
    description="In Practice Mode, complete any stage.",
    points=2,
    trigger=InPractice() &&
            RaceOver(this_frame=true)
)
