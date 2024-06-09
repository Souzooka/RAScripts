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

// Where RALLY2.exe memory *could* exist in memory due to CPU timing differences.
PROCESS_STARTS = [PROCESS_START, 0xA99000, 0xA9A000, 0xA9B000, 0xA9C000]

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
// See RACESTATE2 enum
RaceState2      = (addr) => byte(0xd7a911 - PROCESS_START + addr)
// Total time for current event, in millseconds
EventTime       = (addr) => dword(0xd7a914 - PROCESS_START + addr)
// Range [0, 0x10], see TRACK enum below
TrackID         = (addr) => dword(0xd7a920 - PROCESS_START + addr)
// Target number of laps (correct for Arcade/10YC, 3=3Lap, -1=Free Run in time trial)
TargetLaps      = (addr) => dword(0xd7a970 - PROCESS_START + addr)
// Range [0, 0x16], see CAR enum below
CarID           = (addr) => dword(0xd7a9e0 - PROCESS_START + addr)
// Same as CarID, only set during Car Settings
TuningCarID     = (addr) => dword(0xc8763c - PROCESS_START + addr)

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

// How many years unlocked for 10YC mode (0-based)
YearsUnlocked   = (addr) => dword(0xd7a928 - PROCESS_START + addr)
// Current year in 10YC mode
CurrentYear     = (addr) => dword(0xd7a92c - PROCESS_START + addr)
// Current race leg (0-indexed) [0-3]
CurrentLeg      = (addr) => dword(0xd7a930 - PROCESS_START + addr)
// Current gear
CarPointer      = (addr) => dword(0xd760e8 - PROCESS_START + addr)
CurrentGear     = (addr) => ptr(CarPointer(addr), [0x010, 0x02C], dword, process_start=addr)
// Bitset of unlocked cars (24-bit; indexed by car ID)
CarsUnlocked    = (addr) => 0xd7a934 - PROCESS_START + addr
// Current progress through the current lap -- max progress varies by track, Desert SS1's max progress is about 360
LapProgressPtr  = (addr) => dword(0xd88c30 - PROCESS_START + addr) // NULL when not in a race (or demo, or replay), so good to check
LapProgress     = (addr) => ptr(LapProgressPtr(addr), [0x8, 0x10], dword, process_start=addr)
// The player's current position in the event, 0-based
RacePosition    = (addr) => ptr(LapProgressPtr(addr), [0x20], dword, process_start=addr)
// Array of arcade (and 10year) stage times
StageTimes      = (addr) => 0xd88c7C - PROCESS_START + addr
// Graphics mode, see GRAPHICS enum below
GraphicsMode    = (addr) => dword(0xd88ce0 - PROCESS_START + addr)
// Arcade Difficulty (0=Easy, 1=Normal, 2=Hard)
ArcDifficulty   = (addr) => dword(0xd88fc8 - PROCESS_START + addr)

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

RACESTATE2_RACEFAIL = 0x6
RACESTATE2_RACESUCCESS = 0xA

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
// These cars can change to these consistent values, for whatever reason
CAR_STRATOS2 = 0x17
CAR_037_RALLY2 = 0x19

TRANSMISSION_AT4 = 0x0
TRANSMISSION_MT4 = 0x1
TRANSMISSION_AT5 = 0x2
TRANSMISSION_MT5 = 0x3
TRANSMISSION_AT6 = 0x4
TRANSMISSION_MT6 = 0x5
TRANSMISSION_AT7 = 0x6
TRANSMISSION_MT7 = 0x7

function IsAT(addr)
{
    return Transmission(addr) & 2 == 0
}
function IsMT(addr)
{
    return Transmission(addr) & 2 == 1
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

GRAPHICS_NORMAL = 0
GRAPHICS_60FPS = 0x00000001
GRAPHICS_30FPS = 0x80000000

DIFF_EASY = 0
DIFF_NORMAL = 1
DIFF_HARD = 2

// GAME FUNCTIONS

function AntiCheat(addr)
{
    // Doesn't seem to be a working cheat to unlock all 10year tracks on NA
    // No internal measure for 10years completed (cars unlocked indicate the year is "completed")
    // but if there is a code, we could perhaps make sure the top record for the year 10 course isn't default
    // If year 10 isn't unlocked, but we have the Lancia 037 Rally, then someone cheated.
    return !(YearsUnlocked(addr) < 9 && bit(CAR_037_RALLY, CarsUnlocked(addr)) == 1)
}

function InRace(addr)
{
    // Not completely ideal since this isn't NULL when in the demo mode (or replays?) but probably good enough for now
    return LapProgressPtr(addr) != NULL
}

function RaceOver(addr)
{
    return InRace(addr) && RaceState2(addr) == RACESTATE2_RACESUCCESS && prev(RaceState2(addr)) != RACESTATE2_RACESUCCESS
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
    TRACK_ISLESS1: "Isle SS1",
    TRACK_ISLESS2: "Isle SS2",
    TRACK_ISLESS3: "Isle SS3",
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
    CAR_DELTA_HF: "Lancia Delta HF Integrale",
    CAR_037_RALLY: "Lancia 037 Rally",
    CAR_DELTA_16V: "Lancia Delta Integrale 16v",
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

// these values inexplicably change when racing
CarLookup[CAR_STRATOS2] = CarLookup[CAR_STRATOS]
CarLookup[CAR_037_RALLY2] = CarLookup[CAR_037_RALLY]

OrdinalSuffixLookup = {
    1: "st",
    2: "nd",
    3: "rd",
    4: "th",
}

function MakeOrdinal(n)
{
    ordinal = "th"
    if (n < 4) ordinal = OrdinalSuffixLookup[n]
    return format("{0}{1}", n, ordinal)
}

TransmissionLookup = {
    0: "AT",
    1: "MT",
}

DifficultyLookup = {
    DIFF_EASY: "Easy",
    DIFF_NORMAL: "Normal",
    DIFF_HARD: "Hard",
}

for s in PROCESS_STARTS
{
    rp_car_name = rich_presence_lookup("Car", CarID(s), CarLookup, fallback=CarLookup[CAR_COROLLA_WRC])
    rp_track_name = rich_presence_lookup("Track", TrackID(s), TrackLookup, fallback=TrackLookup[TRACK_RIVERIA])
    rp_trans_rights = rich_presence_lookup("Transmission", Transmission(s) & 1, TransmissionLookup, fallback=TransmissionLookup[0])

    rp_race_position = rich_presence_value("_Number", RacePosition(s)+1, "VALUE")
    rp_race_position_suffix = rich_presence_lookup("Suffix", RacePosition(s)+1, OrdinalSuffixLookup, fallback="th")
    rp_num_rivals = rich_presence_lookup("RivalCount", TrackID(s), { TRACK_SUPERSS: "2" }, fallback="16")
    rp_time_remaining = rich_presence_value("_Number", RemainingTime(s)/60, "VALUE")

    rp_arc_difficulty = rich_presence_lookup("Difficulty", ArcDifficulty(s), DifficultyLookup, fallback=DifficultyLookup[DIFF_NORMAL])
    rp_10yc_year = rich_presence_value("_Number", CurrentYear(s)+1, "VALUE")
    rp_tuning_car_name = rich_presence_lookup("Car", TuningCarID(s), CarLookup, fallback=CarLookup[CAR_COROLLA_WRC])

    rich_presence_conditional_display(ProcessStartsAt(s) && !AntiCheat(s),
        "⚠️ Cheated to unlock all cars"
    )
    rich_presence_conditional_display(ProcessStartsAt(s) && InRace(s) && GameMode(s) == GAMEMODE_ARCADE,
        "🕹️ Arcade ({7}) | 🚩 {0} ({6}s left) | 🚗 {1} ({2}) | {3}{4}/{5}",
        rp_track_name, rp_car_name, rp_trans_rights,
        rp_race_position, rp_race_position_suffix, rp_num_rivals,
        rp_time_remaining,
        rp_arc_difficulty
    )

    rich_presence_conditional_display(ProcessStartsAt(s) && InRace(s) && GameMode(s) == GAMEMODE_ARCADE_PRACTICE,
        "🕹️ Arcade ({3}) | 🚩 Practicing {0} | 🚗 {1} ({2})",
        rp_track_name, rp_car_name, rp_trans_rights,
        rp_arc_difficulty
    )

    rich_presence_conditional_display(ProcessStartsAt(s) && InRace(s) && GameMode(s) == GAMEMODE_10YEAR && CurrentYear(s) >= 10,
        "🏆 10 Year Championship | 🗓️ Special Stage | 🚩 {0} ({6}s left) | 🚗 {1} ({2}) | {3}{4}/{5}",
        rp_track_name, rp_car_name, rp_trans_rights,
        rp_race_position, rp_race_position_suffix, rp_num_rivals,
        rp_time_remaining
    )

    rich_presence_conditional_display(ProcessStartsAt(s) && InRace(s) && GameMode(s) == GAMEMODE_10YEAR,
        "🏆 10 Year Championship | 🗓️ Year {7} | 🚩 {0} ({6}s left) | 🚗 {1} ({2}) | {3}{4}/{5}",
        rp_track_name, rp_car_name, rp_trans_rights,
        rp_race_position, rp_race_position_suffix, rp_num_rivals,
        rp_time_remaining,
        rp_10yc_year
    )

    rich_presence_conditional_display(ProcessStartsAt(s) && InRace(s) && GameMode(s) == GAMEMODE_TIME_ATTACK,
        "⏱️ Time Attack | 🚩 Grinding {0} | 🚗 {1} ({2})",
        rp_track_name, rp_car_name, rp_trans_rights
    )

    rich_presence_conditional_display(ProcessStartsAt(s) && InRace(s) && GameMode(s) == GAMEMODE_2PBATTLE,
        "👥 2P Battle | 🚩 {0}",
        rp_track_name
    )

    rich_presence_conditional_display(ProcessStartsAt(s) && GameMode(s) == GAMEMODE_RECORDS,
        "📋 Viewing Records"
    )

    rich_presence_conditional_display(ProcessStartsAt(s) && InRace(s) && GameMode(s) == GAMEMODE_CAR_PROFILES,
        "📖 Car Profile | 🚗 Learning about {0}",
        rp_car_name
    )

    rich_presence_conditional_display(ProcessStartsAt(s) && !InRace(s) && GameMode(s) == GAMEMODE_CAR_SETTINGS,
        "🛠️ Tuning up the 🚗 {0}",
        rp_tuning_car_name
    )

    rich_presence_conditional_display(ProcessStartsAt(s) && InRace(s) && GameMode(s) == GAMEMODE_CAR_SETTINGS,
        "🔰 Test driving the 🚗 {0}",
        rp_tuning_car_name
    )
}

// remember Souzooka, the dumb Blomby Car meme was actually *your* idea
rich_presence_conditional_display(
    any_of(PROCESS_STARTS, ProcessStartsAt),
    "Preparing for this Infernal Raid"
)

// GAME MEMORY DEBUG

function hex(num)
{
    int2hex = {
        0: "0",
        1: "1",
        2: "2",
        3: "3",
        4: "4",
        5: "5",
        6: "6",
        7: "7",
        8: "8",
        9: "9",
        10: "A",
        11: "B",
        12: "C",
        13: "D",
        14: "E",
        15: "F",
    }
    
    str = ""
    for i in range(0, 5)
    {
        str = format("{0}{1}", int2hex[num % 16], str)
        num = num / 16
    }
    
    return "0x" + str
}

// Try an extensive search of pages around where we expect game memory to start to see if we can just get a guessed start to print out in RP, if the set is broken
SEARCH_RANGE = 300
for i in range(SEARCH_RANGE * -1, SEARCH_RANGE) // NOTE: -SEARCH_RANGE causes syntax error, make GitHub issue later
{
    start = PROCESS_START + (i * 0x1000)
    rich_presence_conditional_display(
        ProcessStartsAt(start),
        format("⚠️ RALLY2.EXE={0} -- Add to RAScript!!", hex(start))
    )
}

// Game memory isn't where we expect it to be -- and it's not any where around where it was??? WHERE IS IT!? :(
rich_presence_display(
    "⚠️⚠️⚠️ TRIPLE CAUTION! You're breaking the car, Samir!"
)

// ACHIEVEMENTS

// 10Year Championship

TenYCAchievementID = 435707
TenYCAchievements = [
    {"name": "Tommi Makinen", "pts": 5},
    {"name": "Juha Kankkunen", "pts": 5},
    {"name": "Walter Rohrl", "pts": 5},
    {"name": "Marcus Gronholm", "pts": 5},
    {"name": "Richard Burns", "pts": 5},
    {"name": "Miki Biasion", "pts": 10},
    {"name": "Petter Solberg", "pts": 10},
    {"name": "Sebastien Loeb", "pts": 25},
    {"name": "Carlos Sainz", "pts": 25},
    {"name": "Sebastien Ogier", "pts": 25},
]

for i in range(0, length(TenYCAchievements)-1)
{
    a = TenYCAchievements[i]
    achievement(
        id=TenYCAchievementID+i,
        title=a["name"],
        description=format("Finish 1st during the {0} Year in 10 Year Championship", MakeOrdinal(i+1)),
        points=a["pts"],
        type="progression",
        trigger=any_of(PROCESS_STARTS, s => (
                ProcessStartsAt(s) &&
                // Anti-cheat
                AntiCheat(s) &&
                // Correct mode
                GameMode(s) == GAMEMODE_10YEAR &&
                // Correct year
                CurrentYear(s) == i &&
                // End of the race
                CurrentLeg(s) == 3 &&
                // Race is over
                RaceOver(s) &&
                // Finished in first place
                RacePosition(s) == 0
            )
        )
    )
}

achievement(
    id=435717,
    title="Searchin' For My Dreams",
    description="Finish 1st in the Special Stage after 10 Year Championship",
    points=10,
    type="win_condition",
    trigger=any_of(PROCESS_STARTS, s => (
            ProcessStartsAt(s) &&
            // Anti-cheat
            AntiCheat(s) &&
            // Correct mode
            GameMode(s) == GAMEMODE_10YEAR &&
            // Correct track
            TrackID(s) == TRACK_SUPERSS &&
            // Race is over
            RaceOver(s) &&
            // Finished in first place
            RacePosition(s) == 0
        )
    )
)

// Arcade

ArcadeStageID = 435505

ArcadeStageAchievements = [
    {
        "name": "Soul on Desert",
        "track_name": "Desert",
        "track_id": TRACK_DESERTSS1,
        "points": 2,
    },
    {
        "name": "Euro Fight",
        "track_name": "Mountain",
        "track_id": TRACK_MOUNTAINSS2,
        "points": 3,
    },
    {
        "name": "Slippin'",
        "track_name": "Snowy",
        "track_id": TRACK_SNOWYSS3,
        "points": 5,
    },
    {
        "name": "Night Groovin'",
        "track_name": "Riveria",
        "track_id": TRACK_RIVERIA,
        "points": 10,
    },
]

for i in range(0, length(ArcadeStageAchievements) - 1)
{
    params = ArcadeStageAchievements[i]    
    id = ArcadeStageID + i
    
    achievement(
        id=id,
        title=params["name"],
        description=format("Clear the {0} stage on Arcade mode on Normal difficulty or higher", params["track_name"]),
        points=params["points"],
        trigger=any_of(PROCESS_STARTS, s => (
                ProcessStartsAt(s) &&
                // Anti-cheat
                AntiCheat(s) &&
                // Correct difficulty
                ArcDifficulty(s) >= DIFF_NORMAL &&
                // Correct mode
                GameMode(s) == GAMEMODE_ARCADE &&
                // Correct track
                TrackID(s) == params["track_id"] &&
                // Race is over
                RaceOver(s)
            )
        ),
        type="progression"
    )
}

achievement(
    id=435509,
    title="Drive Me Mad",
    description="Clear the Riveria Stage on Arcade mode on Hard difficulty",
    points=10,
    trigger=any_of(PROCESS_STARTS, s => (
            ProcessStartsAt(s) &&
            // Anti-cheat
            AntiCheat(s) &&
            // Correct difficulty
            ArcDifficulty(s) >= DIFF_HARD &&
            // Correct mode
            GameMode(s) == GAMEMODE_ARCADE &&
            // Correct track
            TrackID(s) == TRACK_RIVERIA &&
            // Race is over
            RaceOver(s)
        )
    )
)

achievement(
    id=435510,
    title="Go Go! Sega Rally",
    description="Finish the rally in 1st place on Arcade mode on any difficulty",
    points=25,
    trigger=any_of(PROCESS_STARTS, s => (
            ProcessStartsAt(s) &&
            // Anti-cheat
            AntiCheat(s) &&
            // Correct mode
            GameMode(s) == GAMEMODE_ARCADE &&
            // Correct track
            TrackID(s) == TRACK_RIVERIA &&
            // 1st place
            RacePosition(s) == 0 &&
            // Race is over
            RaceOver(s)
        )
    )
)

// TIME TRIALS

function Time2MS(minutes, seconds, millisecs)
{
    return (minutes * (60 * 1000)) +
           (seconds * 1000) +
           millisecs
}

TimeAttackAchievements = [
    {
        "name": "Ignition '98",
        "points": 10,
        "track_id": TRACK_DESERTSS1,
        "car_ids": [CAR_CELICA_ST_205], // Have to use a list since some cars change IDs :(
        "time": Time2MS(2, 47, 0),
    },
    {
        "name": "Deja Vu",
        "points": 10,
        "track_id": TRACK_DESERTSS2,
        "car_ids": [CAR_CELICA_ST_185_94],
        "time": Time2MS(2, 36, 0),
    },
    {
        "name": "Estrada Nova",
        "points": 10,
        "track_id": TRACK_DESERTSS3,
        "car_ids": [CAR_IMPREZA_555],
        "time": Time2MS(3, 52, 0),
    },
    {
        "name": "Route 246",
        "points": 10,
        "track_id": TRACK_MOUNTAINSS1,
        "car_ids": [CAR_SEICENTO],
        "time": Time2MS(2, 56, 0),
    },
    {
        "name": "Power Games",
        "points": 10,
        "track_id": TRACK_MOUNTAINSS2,
        "car_ids": [CAR_DELTA_HF],
        "time": Time2MS(3, 16, 0),
    },
    {
        "name": "End Road of Monaco",
        "points": 10,
        "track_id": TRACK_MOUNTAINSS3,
        "car_ids": [CAR_131_ABARTH_RALLY],
        "time": Time2MS(3, 34, 0),
    },
    {
        "name": "Put Up a Sign",
        "points": 10,
        "track_id": TRACK_SNOWYSS1,
        "car_ids": [CAR_PEUGEOT_206],
        "time": Time2MS(1, 59, 0),
    },
    {
        "name": "Boosted",
        "points": 10,
        "track_id": TRACK_SNOWYSS2,
        "car_ids": [CAR_LANCER_EVO_III],
        "time": Time2MS(2, 35, 0),
    },
    {
        "name": "Verges on the Edge",
        "points": 10,
        "track_id": TRACK_SNOWYSS3,
        "car_ids": [CAR_COROLLA_WRC],
        "time": Time2MS(3, 12, 0),
    },
    {
        "name": "MNF",
        "points": 10,
        "track_id": TRACK_RIVERIA,
        "car_ids": [CAR_STRATOS, CAR_STRATOS2],
        "time": Time2MS(1, 46, 0),
    },
    {
        "name": "Insert Jungle",
        "points": 10,
        "track_id": TRACK_MUDDYSS1,
        "car_ids": [CAR_IMPREZA_WRC],
        "time": Time2MS(2, 47, 0),
    },
    {
        "name": "Around a Letter",
        "points": 10,
        "track_id": TRACK_MUDDYSS2,
        "car_ids": [CAR_LANCER_EVO_IV],
        "time": Time2MS(3, 34, 0),
    },
    {
        "name": "Rumble Along",
        "points": 10,
        "track_id": TRACK_MUDDYSS3,
        "car_ids": [CAR_DELTA_16V],
        "time": Time2MS(4, 33, 0),
    },
    {
        "name": "Evolution",
        "points": 10,
        "track_id": TRACK_ISLESS1,
        "car_ids": [CAR_LANCER_EVOLUTION],
        "time": Time2MS(2, 32, 0),
    },
    {
        "name": "Temptation of Speed",
        "points": 10,
        "track_id": TRACK_ISLESS2,
        "car_ids": [CAR_MAXI_MEGANE],
        "time": Time2MS(3, 32, 0),
    },
    {
        "name": "King of Island",
        "points": 10,
        "track_id": TRACK_ISLESS3,
        "car_ids": [CAR_306_MAXI],
        "time": Time2MS(3, 16, 0),
    },
    {
        "name": "Until You See the Dawn",
        "points": 10,
        "track_id": TRACK_SUPERSS,
        "car_ids": [CAR_037_RALLY, CAR_037_RALLY2],
        "time": Time2MS(2, 38, 0),
    },
]

function MakeTimeString(ms)
{
    // If all times have 0 ms, just ignore it in the time string
    ALL_ZERO_MS = !any_of(TimeAttackAchievements, a => a["time"] % 1000 != 0)

    minutes = ms / (60 * 1000)
    seconds = (ms % (60 * 1000)) / 1000
    millisecs = ms % 1000
    
    if ALL_ZERO_MS
    {
        return format(
            "{0} minute{1} and {2} second{3}",
            minutes,
            if_else(minutes != 1, "s", ""),
            seconds,
            if_else(seconds != 1, "s", "")
        )    
    }
    
    return format(
        "{0}:{1}{2}.{3}{4}{5}",
        // minutes
        minutes,
        // seconds + zero pad
        if_else(seconds < 10, "0", ""),
        seconds,
        // millisecs + zero pad
        if_else(millisecs < 100, "0", ""),
        if_else(millisecs < 10, "0", ""),
        millisecs
    )
}

TimeAttackID = 435964

for i in range(0, length(TimeAttackAchievements) - 1)
{
    params = TimeAttackAchievements[i]
    title = params["name"]
    track = params["track_id"]
    cars = params["car_ids"]
    time = params["time"]
    points = params["points"]
    achievement(
        id=TimeAttackID+i,
        title=title,
        description=format(
            "In Time Attack, complete a 3 Laps run of {0} driving the {1} in less than {2}",
            TrackLookup[track],
            CarLookup[cars[0]],
            MakeTimeString(time)
        ),
        points=points,
        trigger=any_of(PROCESS_STARTS, s => (
            ProcessStartsAt(s) &&
            // Time Attack mode
            InRace(s) && GameMode(s) == GAMEMODE_TIME_ATTACK && TargetLaps(s) == 3 &&
            // Correct track
            TrackID(s) == track &&
            // Correct car
            any_of(cars, car => CarID(s) == car) &&
            // Under par time
            EventTime(s) < time &&
            // Trigger for race completion
            trigger_when(RaceOver(s))
        ))
    )
}

// BONUS

achievement(
    id=435718,
    title="A Woman's Touch",
    description="Complete a stage with the Female co-driver",
    points=1,
    trigger=any_of(PROCESS_STARTS, s => (
            ProcessStartsAt(s) && InRace(s) &&
            // Correct navigator
            Navigator(s) == NAVIGATOR_FEMALE &&
            // Trigger for race completion
            trigger_when(RaceOver(s))
        )
    )
)

achievement(
    id=435719,
    title="Take it for a Spin",
    description="Adjust the tuning on any car and then take it for a spin around the track in test drive mode",
    points=2,
    trigger=any_of(PROCESS_STARTS, s => (
            ProcessStartsAt(s) &&
            // test drive mode
            InRace(s) && GameMode(s) == GAMEMODE_CAR_SETTINGS &&
            // some modification has been made to the car
            (
                Tires(s) != 0 ||
                GearRatio(s) != 0 ||
                FrontSuspension(s) != 0 ||
                RearSuspension(s) != 0 ||
                Steering(s) != 0 ||
                Brakes(s) != 0
            ) &&
            // trigger when once around the track
            trigger_when(prev(CurrentLap(s)) == 0 && CurrentLap(s) == 1)
        )
    )
)

achievement(
    id=435720,
    title="Powered by Windows CE",
    description="Input either the 30fps or \"60fps\" cheat code to get better in-game performance (Warning: will not make you a better driver)",
    points=1,
    trigger=any_of(PROCESS_STARTS, s => (
            ProcessStartsAt(s) &&
            // change graphics mode
            GraphicsMode(s) != GRAPHICS_NORMAL
        )
    )
)

CONES_SCORE_THRESHOLD = 18000
achievement(
    id=435721,
    title="Reckless Endangerment",
    description="Earn 18,000 or more points in the cones minigame on Riviera in Arcade mode",
    points=5,
    trigger=any_of(PROCESS_STARTS, s => (
            ProcessStartsAt(s) &&
            // Correct mode
            (GameMode(s) == GAMEMODE_ARCADE || GameMode(s) == GAMEMODE_ARCADE_PRACTICE) &&
            // Correct stage
            TrackID(s) == TRACK_RIVERIA &&
            // Minigame is active
            ConesTime(s) > 0 &&
            // Score less than threshold
            prev(ConesScore(s)) < CONES_SCORE_THRESHOLD &&
            // Trigger on a score over threshold
            trigger_when(ConesScore(s) >= CONES_SCORE_THRESHOLD)
        )
    )
)

achievement(
    id=435722,
    title="The Todd Rogers Special",
    description="Start a race in 2nd gear",
    points=1,
    trigger=any_of(PROCESS_STARTS, s => (
            ProcessStartsAt(s) && InRace(s) &&
            // Countdown ends
            prev(RaceState(s)) == RACESTATE_COUNTDOWN && RaceState(s) == RACESTATE_RACING &&
            // 2nd gear
            CurrentGear(s) == 2
        )
    )
)

// LEADERBOARDS

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
                // Anti-cheat
                AntiCheat(s) &&
                // New fastest lap
                ((FastestLap(s) < prev(FastestLap(s))) || ALWAYS_SUBMIT) &&
                // Correct mode
                GameMode(s) == GAMEMODE_TIME_ATTACK &&
                // Correct track
                TrackID(s) == track &&
                // Lap counter increments or race is over
                (
                    RaceOver(s) ||
                    (CurrentLap(s) > prev(CurrentLap(s)))
                )
            )
        ),
        cancel=always_false(),
        submit=always_true(),
        // NOTE: Unfortunately for the last lap, the game doesn't seems to store the value too early into the lap times array so there's a very small discrepancy
        // of about .25 in that case. Fortunately, we can also prevent the discrepancy in the leaderboards by only submitting when the player obtains a new fastest lap.
        value=max_of(array_map(PROCESS_STARTS, (s) => measured(FLAP_Value(s), when=ProcessStartsAt(s)))),
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
                // Anti-cheat
                AntiCheat(s) &&
                // Correct mode
                GameMode(s) == GAMEMODE_TIME_ATTACK &&
                // Correct track
                TrackID(s) == track &&
                // Race is over
                RaceOver(s)
            )
        ),
        cancel=always_false(),
        submit=always_true(),
        value=max_of(array_map(PROCESS_STARTS, (s) => measured(EventTime(s) / 10, when=ProcessStartsAt(s)))),
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
                // Anti-cheat
                AntiCheat(s) &&
                // Correct mode
                GameMode(s) == GAMEMODE_ARCADE &&
                // Correct track
                TrackID(s) == track &&
                // Race is over
                RaceOver(s)
            )
        ),
        cancel=always_false(),
        submit=always_true(),
        value=max_of(array_map(PROCESS_STARTS, (s) => measured(GetStageTime(s, i), when=ProcessStartsAt(s)))),
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
            // Anti-cheat
            AntiCheat(s) &&
            // Correct mode
            GameMode(s) == GAMEMODE_ARCADE &&
            // End of the race
            CurrentLeg(s) == 3 &&
            // Race is over
            RaceOver(s)
        )
    ),
    cancel=always_false(),
    submit=always_true(),
    value=max_of(array_map(PROCESS_STARTS, (s) => measured(EventTime(s) / 10, when=ProcessStartsAt(s)))),
    format="CENTISECS",
    lower_is_better=true
)

TenYCLeaderboardID = 104069

for i in range(0, 10 - 1)
{
    leaderboard(
        id=TenYCLeaderboardID + i,
        title=format("{0} Year - Ten Year Championship Record", MakeOrdinal(i+1)),
        description=format("In Ten Year Championship, complete the {0} Year as fast as possible!", MakeOrdinal(i+1)),
        start=any_of(PROCESS_STARTS, s => (
                ProcessStartsAt(s) &&
                // Anti-cheat
                AntiCheat(s) &&
                // Correct mode
                GameMode(s) == GAMEMODE_10YEAR &&
                // Correct year
                CurrentYear(s) == i &&
                // End of the race
                CurrentLeg(s) == 3 &&
                // Race is over
                RaceOver(s)
            )
        ),
        cancel=always_false(),
        submit=always_true(),
        value=max_of(array_map(PROCESS_STARTS, (s) => measured(EventTime(s) / 10, when=ProcessStartsAt(s)))),
        format="CENTISECS",
        lower_is_better=true
    )
}

leaderboard(
    id=104068,
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

    value=max_of(array_map(PROCESS_STARTS, (s) => measured(ConesScore(s) + ConesTime(s), when=ProcessStartsAt(s)))),
    format="SCORE",
    lower_is_better=false
)