// Sega Rally Championship 2
// #ID = 8443

// MISC. Script helpers

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

PROCESS_START = 0xA98000 // Where RALLY2.exe memory *should* exist in memory. Thanks Windows CE, very cool!
PROCESS_START2 = 0xA99000 // Where RALLY2.exe memory *could* exist in memory due to CPU timing differences.
PROCESS_STARTS = [PROCESS_START, PROCESS_START2]

function ProcessStartsAt(addr)
{
    // Where we should expect to find the string "LAP TIME", if the RALLY2.exe process starts at the given address
    LAP_TIME = 0xd6025c - PROCESS_START + addr
    
    return ascii_string_equals(LAP_TIME, "LAP TIME", 4) // Checking only one dword is probably fine
}

addr = (v) => v // Dummy accessor for ptr for if the pointed-to address is desired
function ptr(base, offsets, accessor=dword, process_start=PROCESS_START)
{
    val = base
    
    for i in range(0, length(offsets) - 1)
    {
        addr = val + offsets[i] + process_start
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

function assert(cond, msg="No Message")
{
    if cond == false
    {
        // This won't compile, causing an error to appear if evaluated
        l = {}
        return l[msg]
    }
    
    return true
}

function _arr2String(arr)
{
    result = "["
    for i in range(0, length(arr) - 1)
    {
        result = result + arr[i]
        if i != length(arr) - 1
        {
            result = result + ","
        }
    }
    result = result + "]"
    return result
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
    return assert(false, format("array_index did not find item {0} in provided array {1}", val, _arr2String(arr)))
}

// GAME VARIABLES

// If the game is paused or not (0=not paused, 1=paused)
GamePaused      = (addr) => dword(0xc5810c - PROCESS_START + addr)
// The current lap the player is on, 0-based
CurrentLap      = (addr) => dword(0xd5f3f0 - PROCESS_START + addr)
// Array of 8(?) 32-bit values for lap times, in milliseconds
LapTimes        = (addr) => 0xd5f3f8 - PROCESS_START + addr
// Fastest lap (in Time Attack)
FastestLap      = (addr) => dword(0xd5f44c - PROCESS_START + addr)
// Car Record (in Time Attack)
CarRecord       = (addr) => dword(0xd5f450 - PROCESS_START + addr)
// Course Record (in Time Attack)
CourseRecord     = (addr) => dword(0xd5f460 - PROCESS_START + addr)
// Array of 8(?) 32-bit values for area segment times, in milliseconds, for free run Time Attack mode
AreaTimes       = (addr) => 0xd5f468 - PROCESS_START + addr
// Remaining time for the cones minigame in Riviera in arcade mode
ConesTime       = (addr) => dword(0xd5f4c0 - PROCESS_START + addr)
// Score for cones minigame (28400 max score)
ConesScore      = (addr) => dword(0xd5f4c8 - PROCESS_START + addr)
// Range [0, 0xB], see GAMEMODE enum below -- indicates current active game mode
GameMode        = (addr) => dword(0xd7a904 - PROCESS_START + addr)
// Remaining time for arcade, 10year in milliseconds; -1 in time attack
RemainingTime   = (addr) => dword(0xd7a908 - PROCESS_START + addr)
// Some sort of enumeration for race state (?) -- there's another byte at 0x....11 which may be helpful too
// See RACESTATE enum
RaceState       = (addr) => byte(0xd7a910 - PROCESS_START + addr)
// Total time for current event, in millseconds
EventTime       = (addr) => dword(0xd7a914 - PROCESS_START + addr)
// Range [0, 0x10], see TRACK enum below
TrackID         = (addr) => dword(0xd7a920 - PROCESS_START + addr)
// Range [0, 0x16], see CAR enum below
CarID           = (addr) => dword(0xd7a9e0 - PROCESS_START + addr)

// Car Tuning Values
// Range [0, 7], see TRANSMISSION enum below
Transmission    = (addr) => dword(0xd7a9e4 - PROCESS_START + addr)
// Range [0, A], see TIRE enum below
Tires           = (addr) => dword(0xd7a9f0 - PROCESS_START + addr)
// Range [0, 1], see NAVIGATOR enum below
Navigator       = (addr) => dword(0xd7a9f4 - PROCESS_START + addr)
// Range [-5 low, 5 high]
GearRatio       = (addr) => dword(0xd7a9f8 - PROCESS_START + addr)
// Range [-5 soft, 5 hard]
FrontSuspension = (addr) => dword(0xd7a9fc - PROCESS_START + addr)
// Range [-5 soft, 5 hard]
RearSuspension  = (addr) => dword(0xd7aa00 - PROCESS_START + addr)
// Range [-5 slow, 5 quick]
Steering        = (addr) => dword(0xd7aa04 - PROCESS_START + addr)
// Range [-5 soft, 5 hard]
Brakes          = (addr) => dword(0xd7aa08 - PROCESS_START + addr)

// Current progress through the current lap -- max progress varies by track, Desert SS1's max progress is about 360
LapProgressPtr  = (addr) => dword(0xd88c30 - PROCESS_START + addr) // NULL when not in a race (or demo, or replay), so good to check
LapProgress     = (addr) => ptr(LapProgressPtr(addr), [0x8, 0x10], dword, process_start=addr)
// The player's current position in the event, 0-based
RacePosition    = (addr) => ptr(LapProgressPtr(addr), [0x20], dword, process_start=addr)
// Array of arcade (and 10year) stage times
StageTimes      = (addr) => 0xd88c7C - PROCESS_START + addr

// GAME ENUMERATIONS

GAMEMODE_0 = 0x0
GAMEMODE_ARCADE = 0x1
GAMEMODE_ARCADE_PRACTICE = 0x2
GAMEMODE_TIME_ATTACK = 0x3
GAMEMODE_10YEAR = 0x4
GAMEMODE_2PBATTLE = 0x5
GAMEMODE_6 = 0x6
GAMEMODE_MCMENU = 0x7
GAMEMODE_RECORDS = 0x8
GAMEMODE_CAR_SETTINGS = 0x9
GAMEMODE_CAR_PROFILES = 0xA
GAMEMODE_OPTIONS = 0xB

RACESTATE_RACING = 0x0
RACESTATE_COUNTDOWN = 0x1
RACESTATE_LOADING = 0x9
RACESTATE_FINISHED = 0xA

TRACK_DESERTSS1 = 0x0
TRACK_DESERTSS2 = 0x4
TRACK_DESERTSS3 = 0x5
TRACK_MOUNTAINSS1 = 0x6
TRACK_MOUNTAINSS2 = 0x1
TRACK_MOUNTAINSS3 = 0x7
TRACK_SNOWYSS1 = 0x8
TRACK_SNOWYSS2 = 0x9
TRACK_SNOWYSS3 = 0x2
TRACK_RIVERIA = 0x3
TRACK_MUDDYSS1 = 0xA
TRACK_MUDDYSS2 = 0xB
TRACK_MUDDYSS3 = 0xC
TRACK_ISLESS1 = 0xD
TRACK_ISLESS2 = 0xE
TRACK_ISLESS3 = 0xF
TRACK_SUPERSS = 0x10

ALL_TRACKS = [
    TRACK_DESERTSS1,
    TRACK_DESERTSS2,
    TRACK_DESERTSS3,
    TRACK_MOUNTAINSS1,
    TRACK_MOUNTAINSS2,
    TRACK_MOUNTAINSS3,
    TRACK_SNOWYSS1,
    TRACK_SNOWYSS2,
    TRACK_SNOWYSS3,
    TRACK_RIVERIA,
    TRACK_MUDDYSS1,
    TRACK_MUDDYSS2,
    TRACK_MUDDYSS3,
    TRACK_ISLESS1,
    TRACK_ISLESS2,
    TRACK_ISLESS3,
    TRACK_SUPERSS,
]

CAR_COROLLA_WRC = 0x0
CAR_306_MAXI = 0x1
CAR_PEUGEOT_206 = 0x2
CAR_IMPREZA_WRC = 0x3
CAR_LANCER_EVOLUTION = 0x4
CAR_STRATOS = 0x5
CAR_CELICA_ST_205 = 0x6
CAR_DELTA_HF = 0x7
CAR_037_RALLY = 0x8
CAR_DELTA_16V = 0x9
CAR_131_ABARTH_RALLY = 0xA
CAR_205_TURBO_16 = 0xB
CAR_SEICENTO = 0xC
CAR_ALPINE_A110 = 0xD
CAR_MAXI_MEGANE = 0xE
CAR_CELICA_ST_185_94 = 0xF
CAR_LANCER_EVO_III = 0x10
CAR_LANCER_EVO_IV = 0x11
CAR_LANCER_EVO_V = 0x12
CAR_IMPREZA_555 = 0x13
CAR_CELICA_ST_185_92 = 0x14
CAR_STRATOS_75 = 0x15
CAR_COROLLA_WRC_TEIN = 0x16

TRANSMISSION_AT4 = 0x0
TRANSMISSION_MT4 = 0x1
TRANSMISSION_AT5 = 0x2
TRANSMISSION_MT5 = 0x3
TRANSMISSION_AT6 = 0x4
TRANSMISSION_MT6 = 0x5
TRANSMISSION_AT7 = 0x6
TRANSMISSION_MT7 = 0x7

function IsAT()
{
    return Transmission & 2 == 0
}
function IsMT()
{
    return Transmission & 2 == 1
}

TIRE_TYPE_ASPHALT = 0x0
TIRE_TYPE_GRAVEL = 0x1
TIRE_TYPE_SNOW = 0x2

TIRE_A_DRY_DAMP = 0x0
TIRE_A_DAMP_WET_1 = 0x1
TIRE_A_DAMP_WET_2 = 0x2
TIRE_A_WET = 0x3
TIRE_G_ASPHALT_DRY_DAMP = 0x4
TIRE_G_COMPACTED_GRAVEL = 0x5
TIRE_G_DRY_DAMP_WET = 0x6
TIRE_G_SOFT_WET_GRAVEL = 0x7
TIRE_S_ASPHALT_SNOWY_FROZEN = 0x8
TIRE_S_ICE = 0x9
TIRE_S_SNOW = 0xA

// NOTE: Can only be used with compile time values
function GetTireType(tire)
{
    l = {
        0: TIRE_TYPE_ASPHALT, 1: TIRE_TYPE_ASPHALT, 2: TIRE_TYPE_ASPHALT, 3: TIRE_TYPE_ASPHALT,
        4: TIRE_TYPE_GRAVEL, 5: TIRE_TYPE_GRAVEL, 6: TIRE_TYPE_GRAVEL, 7: TIRE_TYPE_GRAVEL,
        8: TIRE_TYPE_SNOW, 9: TIRE_TYPE_SNOW, 10: TIRE_TYPE_SNOW,
    }
    return l[tire]
}

// NOTE: These can be used at runtime
function IsAsphaltTire(tire)
{
    return 0 <= tire && tire <= 3
}
function IsGravelTire(tire)
{
    return 4 <= tire && tire <= 7
}
function IsSnowTire(tire)
{
    return 8 <= tire && tire <= 10
}

NAVIGATOR_MALE = 0x0
NAVIGATOR_FEMALE = 0x1

CONES_MAXSCORE = 28400

// GAME FUNCTIONS

function AntiCheat(addr)
{
    // TODO: Check if player has year 10 car without completing year 10
    // (or just a specific car if some are accessible??) to combat unlock all cars code
    return true
}

function InRace(addr)
{
    // Not completely ideal since this isn't NULL when in the demo mode (or replays?) but probably good enough for now
    return LapProgressPtr(addr) != NULL
}

function RaceOver(addr, pred=v=>v)
{
    return InRace(addr) && pred(RaceState(addr)) == RACESTATE_FINISHED
}

function GetLapTime(addr, lap)
{
    // To centiseconds
    return dword(LapTimes(addr) + 4 * lap) / 10
}

function GetStageTime(addr, stage)
{
    // To centiseconds
    return dword(StageTimes(addr) + 4 * stage) / 10
}

// RICH PRESENCE

TrackLookup = {
    TRACK_DESERTSS1: "Desert SS1",
    TRACK_DESERTSS2: "Desert SS2",
    TRACK_DESERTSS3: "Desert SS3",
    TRACK_MOUNTAINSS1: "Mountain SS1",
    TRACK_MOUNTAINSS2: "Mountain SS2",
    TRACK_MOUNTAINSS3: "Mountain SS3",
    TRACK_SNOWYSS1: "Snowy SS1",
    TRACK_SNOWYSS2: "Snowy SS2",
    TRACK_SNOWYSS3: "Snowy SS3",
    TRACK_RIVERIA: "Riviera",
    TRACK_MUDDYSS1: "Muddy SS1",
    TRACK_MUDDYSS2: "Muddy SS2",
    TRACK_MUDDYSS3: "Muddy SS3",
    TRACK_ISLESS1: "Isles SS1",
    TRACK_ISLESS2: "Isles SS2",
    TRACK_ISLESS3: "Isles SS3",
    TRACK_SUPERSS: "Super S.S.",
}

CarLookup = {
    CAR_COROLLA_WRC: "Toyota Corolla WRC",
    CAR_306_MAXI: "Peugeot 306 Maxi",
    CAR_PEUGEOT_206: "Peugeot 206 WRC",
    CAR_IMPREZA_WRC: "Subaru Impreza WRC",
    CAR_LANCER_EVOLUTION: "Mitsubishi Lancer Evolution",
    CAR_STRATOS: "Lancia Stratos",
    CAR_CELICA_ST_205: "Toyota Celica GT-Four ST 205",
    CAR_DELTA_HF: "Lancia Delta HF integrale",
    CAR_037_RALLY: "Lancia 037 Rally",
    CAR_DELTA_16V: "Lancia Delta integrale 16v",
    CAR_131_ABARTH_RALLY: "Fiat 131 Abarth Rally",
    CAR_205_TURBO_16: "Peugeot 205 Turbo 16",
    CAR_SEICENTO: "Fiat Seicento Sporting",
    CAR_ALPINE_A110: "Renault Alpine",
    CAR_MAXI_MEGANE: "Renault Maxi Megane",
    CAR_CELICA_ST_185_94: "Toyota Celica GT-Four ST 185",
    CAR_LANCER_EVO_III: "Mitsubishi Lancer Evo III",
    CAR_LANCER_EVO_IV: "Mitsubishi Lancer Evo IV",
    CAR_LANCER_EVO_V: "Mitsubishi Lancer Evo V",
    CAR_IMPREZA_555: "Subaru Impreza 555",
    CAR_CELICA_ST_185_92: "Toyota Celica GT-Four ST 185",
    CAR_STRATOS_75: "Lancia Stratos",
    CAR_COROLLA_WRC_TEIN: "Toyota Corolla WRC",
}

OrdinalSuffixLookup = {
    1: "st",
    2: "nd",
    3: "rd",
    4: "th",
}

for s in PROCESS_STARTS
{
    rp_car_name = rich_presence_lookup("Car", CarID(s), CarLookup, fallback=CarLookup[CAR_COROLLA_WRC])
    rp_track_name = rich_presence_lookup("Track", TrackID(s), TrackLookup, fallback=TrackLookup[TRACK_RIVERIA])

    rp_race_position = rich_presence_value("_Number", RacePosition(s), "VALUE")
    rp_race_position_suffix = rich_presence_lookup("Suffix", RacePosition(s), OrdinalSuffixLookup, fallback="th")
    rp_time_remaining = rich_presence_value("_Number", RemainingTime(s)/60, "VALUE")

    rich_presence_conditional_display(ProcessStartsAt(s) && InRace(s) && GameMode(s) == GAMEMODE_ARCADE,
        "Arcade | 🚩 {0} ({4}) | 🚗 {1} | {2}{3}/12",
        rp_car_name, rp_track_name,
        rp_race_position, rp_race_position_suffix,
        rp_time_remaining
    )

    rich_presence_conditional_display(ProcessStartsAt(s) && InRace(s) && GameMode(s) == GAMEMODE_ARCADE_PRACTICE,
        "Arcade (Practice) | 🚩 {0} | 🚗 {1}",
        rp_car_name, rp_track_name
    )
}

rich_presence_display("Playing Sega Rally Championship 2")

// ACHIEVEMENTS

// Test achievement -- should hopefully work regardless of CPU overclocking state
achievement(
    title="TEST",
    description="TEST",
    points=0,
    trigger=any_of(PROCESS_STARTS, start => ProcessStartsAt(start) && LapProgress(start) >= 5 && prev(LapProgress(start) < 5))
)

// LEADERBOARDS

MAX_OF_VARARGS_ARITY = 2
assert(
    length(PROCESS_STARTS) == MAX_OF_VARARGS_ARITY,
    "Hey! max_of can't accept an array for leaderboard values; if you add new potential memory locations " +
    "for game memory, please make sure to update the leaderboards' value cases appropriately! Thanks!"
)

// Should time attack leaderboards always submit, even if the player hasn't achieved a new fastest time in game?
// Yes for now for testing purposes
// TODO: Find addresses for time records in game
ALWAYS_SUBMIT = false
_EXTRA = if_else(ALWAYS_SUBMIT, "", " Submits when achieving a new best in-game time.")

function FLAP_Value(addr)
{
    if ALWAYS_SUBMIT
    {
        // NOTE: Short by about .25 seconds for the last lap
        return GetLapTime(addr, prev(CurrentLap(addr)))
    }
    
    // To centiseconds
    return FastestLap(addr) / 10
}

// TODO: Assert contiguous IDs when uploading leaderboards
LapRecordID = 103983
CourseRecordID = 104000

for i in range(0, length(ALL_TRACKS) - 1)
{
    track = ALL_TRACKS[i]
    id = LapRecordID + i

    leaderboard(
        id=id,
        title=format("{0} - Best Lap", TrackLookup[track]),
        description=format("In Time Attack, complete a lap on the {0} stage within the fastest time!{1}", TrackLookup[track], _EXTRA),
        start=any_of(PROCESS_STARTS, s => (
                ProcessStartsAt(s) &&
                // New fastest lap
                ((FastestLap(s) < prev(FastestLap(s))) || ALWAYS_SUBMIT) &&
                // Correct mode
                GameMode(s) == GAMEMODE_TIME_ATTACK &&
                // Correct track
                TrackID(s) == track &&
                // Lap counter increments or race is over
                (
                    (RaceOver(s) && !RaceOver(s, prev)) ||
                    (CurrentLap(s) > prev(CurrentLap(s)))
                )
            )
        ),
        cancel=always_false(),
        submit=always_true(),
        // NOTE: Unfortunately for the last lap, the game doesn't seems to store the value too early into the lap times array so there's a very small discrepancy
        // of about .25 in that case. Fortunately, we can also prevent the discrepancy in the leaderboards by only submitting when the player obtains a new fastest lap.
        value=max_of(
            measured(FLAP_Value(PROCESS_START), when=ProcessStartsAt(PROCESS_START)),
            measured(FLAP_Value(PROCESS_START2), when=ProcessStartsAt(PROCESS_START2))
        ),
        format="CENTISECS",
        lower_is_better=true
    )
}

for i in range(0, length(ALL_TRACKS) - 1)
{
    track = ALL_TRACKS[i]
    id = CourseRecordID + i
    
    leaderboard(
        id=id,
        title=format("{0} - Course Record", TrackLookup[track]),
        description=format("In Time Attack, complete a 3 Laps run on the {0} stage within the fastest time!{1}", TrackLookup[track], _EXTRA),
        start=any_of(PROCESS_STARTS, s => (
                ProcessStartsAt(s) &&
                // Correct mode
                GameMode(s) == GAMEMODE_TIME_ATTACK &&
                // Correct track
                TrackID(s) == track &&
                // Race is over
                RaceOver(s) && !RaceOver(s, prev) &&
                // The event timer is less than the course record
                EventTime(s) < CourseRecord(s)
            )
        ),
        cancel=always_false(),
        submit=always_true(),
        value=max_of(
            measured(EventTime(PROCESS_START) / 10, when=ProcessStartsAt(PROCESS_START)),
            measured(EventTime(PROCESS_START2) / 10, when=ProcessStartsAt(PROCESS_START2))
        ),
        format="CENTISECS",
        lower_is_better=true
    )
}

ARCADE_TRACKS = [
    {
        "name": "Desert",
        "track_id": TRACK_DESERTSS1,
    },
    {
        "name": "Mountain",
        "track_id": TRACK_MOUNTAINSS2,
    },
    {
        "name": "Snowy",
        "track_id": TRACK_SNOWYSS3,
    },
    {
        "name": "Riveria",
        "track_id": TRACK_RIVERIA,
    },
]

ArcadeLeaderboardID = 103978

for i in range(0, length(ARCADE_TRACKS) - 1)
{
    params = ARCADE_TRACKS[i]
    name = params["name"]
    track = params["track_id"]
    id = ArcadeLeaderboardID + i
    
    leaderboard(
        id=id,
        title=format("{0} - Arcade Stage Record", name),
        description=format("In Arcade, complete the {0} stage as fast as possible!", name),
        start=any_of(PROCESS_STARTS, s => (
                ProcessStartsAt(s) &&
                // Correct mode
                GameMode(s) == GAMEMODE_ARCADE &&
                // Correct track
                TrackID(s) == track &&
                // Race is over
                RaceOver(s) && !RaceOver(s, prev)
            )
        ),
        cancel=always_false(),
        submit=always_true(),
        value=max_of(
            measured(GetStageTime(PROCESS_START, i), when=ProcessStartsAt(PROCESS_START)),
            measured(GetStageTime(PROCESS_START2, i), when=ProcessStartsAt(PROCESS_START2))
        ),
        format="CENTISECS",
        lower_is_better=true
    )
}

leaderboard(
    id=103982,
    title=format("Arcade Record"),
    description="Complete the arcade mode as fast as possible!",
    start=any_of(PROCESS_STARTS, s => (
            ProcessStartsAt(s) &&
            // Correct mode
            GameMode(s) == GAMEMODE_ARCADE &&
            // Correct track
            TrackID(s) == TRACK_RIVERIA &&
            // Race is over
            RaceOver(s) && !RaceOver(s, prev)
        )
    ),
    cancel=always_false(),
    submit=always_true(),
    value=max_of(
        measured(EventTime(PROCESS_START) / 10, when=ProcessStartsAt(PROCESS_START)),
        measured(EventTime(PROCESS_START2) / 10, when=ProcessStartsAt(PROCESS_START2))
    ),
    format="CENTISECS",
    lower_is_better=true
)

leaderboard(
    title="Riviera Cones Minigame",
    description="Knock over as many cones as you can in the cones minigame in Riviera in arcade mode. Score maxout will earn bonus points for remaining time.",

    start=any_of(PROCESS_STARTS, s => (
        ProcessStartsAt(s) && TrackID(s) == TRACK_RIVERIA && 
        (
            (ConesScore(s) == CONES_MAXSCORE) ||
            (prev(ConesTime(s)) > 0 && ConesTime(s) == 0)
        )
    )),
    cancel=always_false(),
    submit=always_true(),

    value=max_of(
        measured(ConesScore(PROCESS_START) + ConesTime(PROCESS_START), when=ProcessStartsAt(PROCESS_START)),
        measured(ConesScore(PROCESS_START2) + ConesTime(PROCESS_START2), when=ProcessStartsAt(PROCESS_START2))
    ),
    format="SCORE",
    lower_is_better=false
)