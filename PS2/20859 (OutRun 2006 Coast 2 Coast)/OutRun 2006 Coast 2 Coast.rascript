// OutRun 2006: Coast 2 Coast
// #ID = 20859

NULL = 0
True = 1
False = 0
NO_ADDR = 0xDEADBEEF // always 0x0 when read

RegionByte = byte(0x133a03)
US = 0
EU = 1
JP = 2
Regions = [US, EU, JP]

function IsRegion(region)
{
    return region == RegionByte
}

function if_else(cond, v1, v2)
{
    if cond == true
    {
        return v1
    }
    return v2
}


function dict_get(dict, key, default=false)
{
    if !dictionary_contains_key(dict, key)
    {
        return default
    }
    return dict[key]
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

function MillisToTimestamp(x) => format("{0}'{1}\"{2}", 
	x / (60 * 1000),
	substring(format("0{0}", (x / 1000) % 60), -2, 2),
	substring(format("00{0}", x), -3, 3)
)

function TimeToMillis(minutes=0, seconds=0, ms=0)
{
   return minutes * 60 * 1000 +
        seconds * 1000 +
        ms
}

// 60.2 frames in a second...
IGT_DIVISOR = 60.2

// GAME VARIABLES

inRace = {
    US: dword(0x359a4c),
    EU: dword(0x3590CC),
    JP: dword(0x34CD1C),
}

SKY_PALM = 0x71
SKY_LAKE = 0x72
SKY_INDU = 0x73
SKY_ALPI = 0x74
SKY_SNOW = 0x75
SKY_CLOU = 0x76
SKY_CAST = 0x77
SKY_GHOS = 0x78
SKY_FORE = 0x79
SKY_DESE = 0x7A
SKY_TULI = 0x7B
SKY_METR = 0x7C
SKY_RUIN = 0x7D
SKY_CAPE = 0x7E
SKY_IMPE = 0x7F
SKY_GRAN = 0x10D
SKY_SEQU = 0x10E
SKY_SANF = 0x10F
SKY_NEWY = 0x110
SKY_MACH = 0x111
SKY_YOSE = 0x112
SKY_MAYA = 0x113
SKY_NIAG = 0x114
SKY_ALAS = 0x115
SKY_AMAZ = 0x116
SKY_BEAC = 0x117
SKY_LASV = 0x118
SKY_PRIN = 0x119
SKY_FLOR = 0x11A
SKY_EAST = 0x11B
// The filename idx for the currently-used sky, used for zone detection
currSky = {
    US: dword(0x549B74),
    EU: dword(0x549174),
    JP: dword(0x51F674),
}
// The filename idx for the sky for the first stage in an event, used for reverse tracks
firstSky = {
    US: ptr(dword(0x35A868), [0x14, 0x44], dword),
    EU: ptr(dword(0x359EE8), [0x14, 0x44], dword),
    JP: ptr(dword(0x34DB48), [0x14, 0x44], dword),
}

// Rank (for Heart Attack)
RANK_E = 1
RANK_D = 2
RANK_C = 3
RANK_B = 4
RANK_A = 5
RANK_AA = 6
RANK_AAA = 7

// The currently-selected car
CAR_F50 = 0
CAR_DINO = 1
CAR_288GTO = 2
CAR_512BB = 3
CAR_365GTS = 4
CAR_ENZO = 5
CAR_TESTA = 6
CAR_SPIDER = 7
CAR_F40 = 8
CAR_250GTO = 9
car = {
    US: byte(0x369BE8),
    EU: byte(0x369268),
    JP: byte(0x35D028),
}

// Transmission type
TRANS_AUTO = 0x0
TRANS_MANUAL = 0x1
transmission = {
    US: byte(0x369BEA),
    EU: byte(0x36926A),
    JP: byte(0x35D02A),
}

// The type of active event
EVENT_NONE = 0xFFFFFFFF
EVENT_TIME_ATTACK = 0
EVENT_OUTRUN = 1
EVENT_HEART_ATTACK = 2
EVENT_GIRLFRIEND = 5
EVENT_FLAGMAN = 6
EVENT_TIME_ATTACK_1PLAYER = 7
eventType = {
    US: dword(0x443F08),
    EU: dword(0x443508),
    JP: dword(0x434108),
}

EVENT_SUB_NORMAL_SP = 0x0
EVENT_SUB_NORMAL = 0x1
EVENT_SUB_CONTINUOUS_SP = 0x2
EVENT_SUB_CONTINUOUS = 0x3
eventSubType = {
    US: dword(0x443F0C),
    EU: dword(0x44350C),
    JP: dword(0x43410C),
}

STATE_ARCADE_MODE = 0x0A
STATE_DRIVING = 0x10
STATE_GOAL = 0x13
STATE_TIMEUP = 0x14
STATE_MENU = 0x20
STATE_CONGRATULATIONS = 0x24
gameState = {
    US: dword(0x443F10),
    EU: dword(0x443510),
    JP: dword(0x434110),
}

// For Time Attack this is 1 for stage-only runs, 15 for goal runs
numStagesLoaded = {
    US: dword(0x35A870),
    EU: dword(0x359EF0),
    JP: dword(0x34DB50),
}

timeDifficulty = {
    US: dword(0x589148),
    EU: dword(0x588748),
    JP: dword(0x55ec58),
}
DIFFICULTY_VERY_HARD = 4

CONGRATS_NONE = -1
CONGRATS_FLAG1 = 0 // Flagman 2 unlocked (impressed)
CONGRATS_FLAG2 = 1 // Flagman 3 unlocked (amazed)
CONGRATS_FLAG3 = 2 // Flagman 4 unlocked (thrilled)
CONGRATS_FLAG4 = 3 // Flagman complete (got chills)
CONGRATS_GIRL1 = 4 // Clarissa is thrilled; Jennifer is available
CONGRATS_GIRL2 = 5 // Jennifer loves your technique; Holly is available
CONGRATS_GIRL3 = 6 // Holly likes your thinking
CONGRATS_CLEAR = 7 // You have cleared Coast 2 Coast
CONGRATS_PERFECT = 8 // Perfect! (All events perfected)
congratsType = {
    US: dword(0x35D244),
    EU: dword(0x35C8C4),
    JP: dword(0x3505EC),
}

flagmanRanks = {
    US: 0x589245,
    EU: 0x588845,
    JP: 0x55ED55,
}

girlfriendRanks = {
    US: 0x5893d6,
    EU: 0x5889D6,
    JP: 0x55EEE6,
}

eventDistance = {
    US: ptr(dword(0x557B08), [0x260], word),
    EU: ptr(dword(0x557108), [0x260], word),
    JP: ptr(dword(0x52D618), [0x260], word),
}

// 60.2 (lol) frames a second
eventTime = {
    US: dword(0x5C6948),
    EU: dword(0x5C5F48),
    JP: dword(0x5A2510),
}

stageRankInfo = {
    US: 0x589F78,
    EU: 0x589578,
    JP: 0x55FA88,
}

// fixed5, divide by 10000 for actual heart count
heartAttackHearts = {
    US: dword(0x58AF30),
    EU: dword(0x58A530),
    JP: dword(0x560A40),
}

// for PAL use only
video_mode = ptr(dword(0x3590B0), [0x70], v => v)

// GAME FUNCTIONS

function IsInGame(region)
{
    // NOTE: inRace is 1 when choosing car/mode/music for arcade mode
    return inRace[region] == True && gameState[region] != STATE_ARCADE_MODE
}

function HitGoal(region)
{
    return prev(gameState[region]) != STATE_GOAL && gameState[region] == STATE_GOAL
}

function HeartAttackRank(region, continuous=false)
{
    num_stages = if_else(continuous, 15, 5)
    
    SIZEOF_INFO = 0x44
    
    result = 0
    for i in range(0, num_stages - 1)
    {
        info = stageRankInfo[region] + (SIZEOF_INFO * i)
        num_events = byte(info + 0x40)
        total_rank = dword(info + 0x1C)
        
        result = result + (total_rank / num_events)
    }
    
    return result / num_stages
}

EVENT_RATINGS = ["E", "D", "C", "B", "A", "AA", "AAA", "-"]

// pass a list of addresses for 0-7 bytes
function AverageRatingIsBetter(list, threshold)
{
    trigger = sum_of(list, x => x) >= threshold * length(list)
    for a in list
        trigger = trigger && (a != 0x07) // all events must be completed
    return trigger
}

// pass a list of addresses for 0-7 bytes
function AAARating(region, list)
{
    if (length(list) == 1) return list[0] == 0x06 && prev(list[0]) != 0x06
    return measured(tally_of(list, length(list), (x) => once(x == 0x06 && never(x != 0x06))), when=IsRegion(region)) &&
        __ornext(any_of(list, (x) => prev(x) != 0x06))
}

function FlagmanAddresses(region, event, count)
{
    return array_map(range(0, count-1), 
        (i) => byte(flagmanRanks[region] + 5 * (event-1) + i))
}

function GirlfriendAddresses(region, offset, count)
{
    return array_map(range(0, count-1), 
        (i) => if_else(i % 2 == 0, low4, high4)(girlfriendRanks[region] + offset + i/2))
}

function UsedENTIRETY(region)
{
    return byte(flagmanRanks[region] + 4) != 0x07
}

// RICH PRESENCE

region_lookup = {
    US: "ᵘˢ",
    EU: "ᵉᵘ",
    JP: "ʲᵖ",
}

track_lookup = {
    SKY_PALM: "Palm Beach",
    SKY_LAKE: "Deep Lake",
    SKY_INDU: "Industrial Complex",
    SKY_ALPI: "Alpine",
    SKY_SNOW: "Snow Mountain",
    SKY_CLOU: "Cloudy Highland",
    SKY_CAST: "Castle Wall",
    SKY_GHOS: "Ghost Forest",
    SKY_FORE: "Coniferous Forest",
    SKY_DESE: "Desert",
    SKY_TULI: "Tulip Garden",
    SKY_METR: "Metropolis",
    SKY_RUIN: "Ancient Ruins",
    SKY_CAPE: "Cape Way",
    SKY_IMPE: "Imperial Avenue",
    SKY_GRAN: "Canyon",
    SKY_SEQU: "Big Forest",
    SKY_SANF: "Bay Area",
    SKY_NEWY: "Skyscrapers",
    SKY_MACH: "Lost City",
    SKY_YOSE: "National Park",
    SKY_MAYA: "Legend",
    SKY_NIAG: "Water Falls",
    SKY_ALAS: "Ice Scape",
    SKY_AMAZ: "Jungle",
    SKY_BEAC: "Sunny Beach",
    SKY_LASV: "Casino Town",
    SKY_PRIN: "Floral Village",
    SKY_FLOR: "Milky Way",
    SKY_EAST: "Giant Statues",
}

track_emoji = {
    SKY_PALM: "🌴",
    SKY_LAKE: "🚣",
    SKY_INDU: "🏭",
    SKY_ALPI: "🏔️",
    SKY_SNOW: "🏔️",
    SKY_CLOU: "☁️",
    SKY_CAST: "🏰",
    SKY_GHOS: "👻",
    SKY_FORE: "🌲",
    SKY_DESE: "🏜️",
    SKY_TULI: "🌷",
    SKY_METR: "🌁",
    SKY_RUIN: "🧭",
    SKY_CAPE: "🛣️",
    SKY_IMPE: "🏛️",
    SKY_GRAN: "🌄",
    SKY_SEQU: "🌲",
    SKY_SANF: "🌉",
    SKY_NEWY: "🏙️",
    SKY_MACH: "🏺",
    SKY_YOSE: "🏞️",
    SKY_MAYA: "🏛️",
    SKY_NIAG: "🏞️",
    SKY_ALAS: "❄️",
    SKY_AMAZ: "🦁",
    SKY_BEAC: "🏖️",
    SKY_LASV: "🌆",
    SKY_PRIN: "🌸",
    SKY_FLOR: "🌌",
    SKY_EAST: "🗿",
}

trans_lookup = {
    TRANS_AUTO: "AT",
    TRANS_MANUAL: "MT",
}

car_lookup = {
    CAR_F50: "F50",
    CAR_DINO: "Dino 246 GTS",
    CAR_288GTO: "288 GTO",
    CAR_512BB: "512 BB",
    CAR_365GTS: "365 GTS/4 Daytona",
    CAR_ENZO: "Enzo Ferrari",
    CAR_TESTA: "Testarossa",
    CAR_SPIDER: "360 Spider",
    CAR_F40: "F40",
    CAR_250GTO: "250 GTO",
}

event_lookup = {
    EVENT_TIME_ATTACK: "⏱️ Time Attack Mode",
    EVENT_TIME_ATTACK_1PLAYER: "⏱️ Time Attack Mode",
    EVENT_OUTRUN: "🚗 OutRun Mode",
    EVENT_HEART_ATTACK: "❤️ Heart Attack Mode",
    EVENT_GIRLFRIEND: "💋 Girlfriend Event",
    EVENT_FLAGMAN: "🎌 Flagman Event",
}

event_sub_lookup = {
    EVENT_SUB_CONTINUOUS_SP: " (15 Continuous Course)",
    EVENT_SUB_CONTINUOUS: " (15 Continuous Course)",
}

for region in Regions
{
    rp_region = rich_presence_lookup("REGION", RegionByte, region_lookup, region_lookup[US])
    rp_track_icon = rich_presence_lookup("TRACKICON", currSky[region], track_emoji, "")
    rp_track = rich_presence_lookup("TRACK", currSky[region], track_lookup, "Unknown Zone")
    rp_trans = rich_presence_lookup("TRANS", transmission[region], trans_lookup, "??")
    rp_car = rich_presence_lookup("CAR", car[region], car_lookup, "Unknown Car")
    rp_event = rich_presence_lookup("EVENT", eventType[region], event_lookup, "Unknown Event")
    rp_event_sub = rich_presence_lookup("EVENT_SUB", eventSubType[region], event_sub_lookup, "")
    rp_cheat = rich_presence_lookup("CHEAT", max_of(
        measured(1, when=IsRegion(region) && UsedENTIRETY(region)),
        measured(0)
    ), {1: "⚠️ Cheats Used | "}, "")

    rich_presence_conditional_display(
        IsRegion(region) && IsInGame(region),
        "{0}{1} OutRunning | {2}{3} | {4} ({5}) | {6} {7}",
        rp_cheat,
        rp_region,
        rp_event,
        rp_event_sub,
        rp_car,
        rp_trans,
        rp_track_icon,
        rp_track
    )
    rich_presence_conditional_display(
        IsRegion(region),
        "{0}{1} In menu or loading screen",
        rp_cheat,
        rp_region
    )
}

rich_presence_display("Playing OutRun 2006: Coast 2 Coast")

// ACHIEVEMENTS

CTYPE_RACE = "Race the Rivals!"
CTYPE_GIRLFRIEND = "Don't lose your Girlfriend!"
CTYPE_SLIPSTREAM = "Test your Slipstream!"
CTYPE_KNOCKOUT = "Avoid the Knockout!"
CTYPE_DRIFT = "Test your Drift!"

// Flagman Mode

flagman_levels = [
    {
        "group": 1,
        "name": "NOVICE",
        "first": 1,
        
        "id": 527786,
        "screens": [CONGRATS_FLAG1,],
        "title": "Flagman is Impressed",
    },
    {
        "group": 2,
        "name": "INTERMEDIATE",
        "first": 6,
        
        "id": 527787,
        "screens": [CONGRATS_FLAG2,],
        "title": "Flagman is Amazed",
    },
    {
        "group": 3,
        "name": "PROFESSIONAL",
        "first": 15,
        
        "id": 527788,
        "screens": [CONGRATS_FLAG3,],
        "title": "Flagman is Thrilled",
    },
    {
        "group": 4,
        "name": "OUTRUN",
        "first": 26,

        "id": 527789,
        "screens": [CONGRATS_FLAG4, CONGRATS_CLEAR, CONGRATS_PERFECT,],
        "title": "Flagman Got Chills",
    },
]

flagman_events = [
    {
        "id": 527746,
        "event": 1,
        "count": 3,
        "points": 3,
        "type": CTYPE_RACE,
    },
    {
        "id": 527747,
        "event": 2,
        "count": 2,
        "points": 2,
        "type": CTYPE_RACE,
    },
    {
        "id": 527748,
        "event": 3,
        "count": 1,
        "points": 2,
        "type": CTYPE_DRIFT,
    },
    {
        "id": 527749,
        "event": 4,
        "count": 2,
        "points": 2,
        "type": CTYPE_RACE,
    },
    {
        "id": 527750,
        "event": 5,
        "count": 1,
        "points": 2,
        "type": CTYPE_RACE,
    },
    {
        "id": 527751,
        "event": 6,
        "count": 1,
        "points": 1,
        "type": CTYPE_GIRLFRIEND,
    },
    {
        "id": 527752,
        "event": 7,
        "count": 3,
        "points": 3,
        "type": CTYPE_RACE,
    },
    {
        "id": 527753,
        "event": 8,
        "count": 2,
        "points": 2,
        "type": CTYPE_RACE,
    },
    {
        "id": 527754,
        "event": 9,
        "count": 1,
        "points": 2,
        "type": CTYPE_SLIPSTREAM,
    },
    {
        "id": 527755,
        "event": 10,
        "count": 2,
        "points": 4,
        "type": CTYPE_RACE,
    },
    {
        "id": 527756,
        "event": 11,
        "count": 3,
        "points": 3,
        "type": CTYPE_RACE,
    },
    {
        "id": 527757,
        "event": 12,
        "count": 1,
        "points": 2,
        "type": CTYPE_KNOCKOUT,
    },
    {
        "id": 527758,
        "event": 13,
        "count": 2,
        "points": 4,
        "type": CTYPE_RACE,
    },
    {
        "id": 527759,
        "event": 14,
        "count": 2,
        "points": 4,
        "type": CTYPE_RACE,
    },
    {
        "id": 527760,
        "event": 15,
        "count": 2,
        "points": 3,
        "type": CTYPE_DRIFT,
    },
    {
        "id": 527761,
        "event": 16,
        "count": 4,
        "points": 5,
        "type": CTYPE_RACE,
    },
    {
        "id": 527762,
        "event": 17,
        "count": 2,
        "points": 3,
        "type": CTYPE_RACE,
    },
    {
        "id": 527763,
        "event": 18,
        "count": 2,
        "points": 2,
        "type": CTYPE_SLIPSTREAM,
    },
    {
        "id": 527764,
        "event": 19,
        "count": 10,
        "points": 3,
        "type": CTYPE_RACE,
    },
    {
        "id": 527765,
        "event": 20,
        "count": 2,
        "points": 3,
        "type": CTYPE_RACE,
    },
    {
        "id": 527766,
        "event": 21,
        "count": 1,
        "points": 3,
        "type": CTYPE_KNOCKOUT,
    },
    {
        "id": 527767,
        "event": 22,
        "count": 4,
        "points": 5,
        "type": CTYPE_RACE,
    },
    {
        "id": 527768,
        "event": 23,
        "count": 3,
        "points": 5,
        "type": CTYPE_RACE,
    },
    {
        "id": 527769,
        "event": 24,
        "count": 1,
        "points": 3,
        "type": CTYPE_GIRLFRIEND,
    },
    {
        "id": 527770,
        "event": 25,
        "count": 5,
        "points": 10,
        "type": CTYPE_RACE,
    },
    {
        "id": 527771,
        "event": 26,
        "count": 5,
        "points": 10,
        "type": CTYPE_RACE,
    },
    {
        "id": 527772,
        "event": 27,
        "count": 2,
        "points": 4,
        "type": CTYPE_SLIPSTREAM,
    },
    {
        "id": 527773,
        "event": 28,
        "count": 2,
        "points": 4,
        "type": CTYPE_RACE,
    },
    {
        "id": 527774,
        "event": 29,
        "count": 5,
        "points": 10,
        "type": CTYPE_RACE,
    },
    {
        "id": 527775,
        "event": 30,
        "count": 2,
        "points": 4,
        "type": CTYPE_DRIFT,
    },
    {
        "id": 527776,
        "event": 31,
        "count": 3,
        "points": 5,
        "type": CTYPE_RACE,
    },
    {
        "id": 527777,
        "event": 32,
        "count": 5,
        "points": 10,
        "type": CTYPE_RACE,
    },
    {
        "id": 527778,
        "event": 33,
        "count": 1,
        "points": 4,
        "type": CTYPE_KNOCKOUT,
    },
    {
        "id": 527779,
        "event": 34,
        "count": 2,
        "points": 5,
        "type": CTYPE_RACE,
    },
    {
        "id": 527780,
        "event": 35,
        "count": 3,
        "points": 3,
        "type": CTYPE_RACE,
    },
    {
        "id": 527781,
        "event": 36,
        "count": 1,
        "points": 3,
        "type": CTYPE_GIRLFRIEND,
    },
    {
        "id": 527782,
        "event": 37,
        "count": 2,
        "points": 5,
        "type": CTYPE_RACE,
    },
    {
        "id": 527783,
        "event": 38,
        "count": 2,
        "points": 5,
        "type": CTYPE_RACE,
    },
    {
        "id": 527784,
        "event": 39,
        "count": 2,
        "points": 4,
        "type": CTYPE_DRIFT,
    },
    {
        "id": 527785,
        "event": 40,
        "count": 2,
        "points": 25,
        "type": CTYPE_RACE,
    },
]

for event in flagman_events
{
    fgroup = 0
    fgroupname = ""
    for x in flagman_levels
        if (event["event"] >= x["first"])
        {
            fgroup = x["group"]
            fgroupname = x["name"]
        }

    achievement(
        id=event["id"],
        title=format("Flagman's Challenge: {0} {1}", event["event"], fgroupname),
        description=format("{0} In Flagman {1}, complete all events in {2} {3} with a ranking of AAA",
            event["type"], fgroup, event["event"], fgroupname),
        points=event["points"],
        trigger=any_of(Regions, region => 
            IsRegion(region) &&
            eventType[region] == EVENT_FLAGMAN &&
            gameState[region] != STATE_MENU &&
            // AverageRatingIsBetter(FlagmanAddresses(region, event["event"], event["count"]), target_rank) &&
            // __ornext(!AverageRatingIsBetter(array_map(FlagmanAddresses(region, event["event"], event["count"]), (x) => prev(x)), target_rank))
            AAARating(region, FlagmanAddresses(region, event["event"], event["count"]))
        )
    )
}

for flevel in flagman_levels
{
    achievement(
        id=flevel["id"],
        title=flevel["title"],
        description=format("Attain an average rating of A or higher in the {0} events for Flagman {1}",
            flevel["name"], flevel["group"]),
        points=10,
        type="progression",
        trigger=any_of(Regions, region => 
            IsRegion(region) &&
            !UsedENTIRETY(region) &&
            prev(gameState[region]) != STATE_CONGRATULATIONS &&
            gameState[region] == STATE_CONGRATULATIONS &&
            any_of(flevel["screens"], (x) => congratsType[region] == x)
        )
    )
}

// Girlfriend Mode

girlfriend_levels = [
    {
        "name": "Clarissa",
        "first": 0x1e,
        "end": 0x3c,
        
        "id": 527856,
        "screens": [CONGRATS_GIRL1,],
        "title": "Clarissa is Thrilled",
    },
    {
        "name": "Jennifer",
        "first": 0,
        "end": 0x1e,
        
        "id": 527857,
        "screens": [CONGRATS_GIRL2,],
        "title": "Jennifer Loves Your Technique",
    },
    {
        "name": "Holly",
        "first": 0x3c,
        "end": 0xff,
        
        "id": 527858,
        "screens": [CONGRATS_GIRL3, CONGRATS_CLEAR, CONGRATS_PERFECT,],
        "title": "Holly Likes Your Thinking",
    },
]

girlfriend_events = [
    // CLARISSA (Outrun2SP Courses)
    {
        "id": 527811,
        "offset": 0x1e,
        "count": 1,
        "points": 1,
        "course": SKY_BEAC,
    },
    {
        "id": 527812,
        "offset": 0x2a,
        "count": 1,
        "points": 1,
        "course": SKY_SANF,
    },
    {
        "id": 527813,
        "offset": 0x30,
        "count": 1,
        "points": 1,
        "course": SKY_YOSE,
    },
    {
        "id": 527814,
        "offset": 0x22,
        "count": 2,
        "points": 2,
        "course": SKY_NIAG,
    },
    {
        "id": 527815,
        "offset": 0x20,
        "count": 2,
        "points": 2,
        "course": SKY_SEQU,
    },
    {
        "id": 527816,
        "offset": 0x28,
        "count": 2,
        "points": 2,
        "course": SKY_GRAN,
    },
    {
        "id": 527817,
        "offset": 0x2e,
        "count": 3,
        "points": 3,
        "course": SKY_MACH,
    },
    {
        "id": 527818,
        "offset": 0x24,
        "count": 3,
        "points": 3,
        "course": SKY_LASV,
    },
    {
        "id": 527819,
        "offset": 0x26,
        "count": 3,
        "points": 3,
        "course": SKY_ALAS,
    },
    {
        "id": 527820,
        "offset": 0x2c,
        "count": 3,
        "points": 3,
        "course": SKY_AMAZ,
    },
    {
        "id": 527821,
        "offset": 0x3a,
        "count": 4,
        "points": 4,
        "course": SKY_EAST,
    },
    {
        "id": 527822,
        "offset": 0x32,
        "count": 4,
        "points": 4,
        "course": SKY_MAYA,
    },
    {
        "id": 527823,
        "offset": 0x36,
        "count": 4,
        "points": 4,
        "course": SKY_PRIN,
    },
    {
        "id": 527824,
        "offset": 0x38,
        "count": 4,
        "points": 4,
        "course": SKY_FLOR,
    },
    {
        "id": 527825,
        "offset": 0x34,
        "count": 4,
        "points": 4,
        "course": SKY_NEWY,
    },
    // JENNIFER (Outrun2SP Courses)
    {
        "id": 527826,
        "offset": 0x00,
        "count": 1,
        "points": 1,
        "course": SKY_PALM,
    },
    {
        "id": 527827,
        "offset": 0x02,
        "count": 1,
        "points": 1,
        "course": SKY_LAKE,
    },
    {
        "id": 527828,
        "offset": 0x06,
        "count": 1,
        "points": 1,
        "course": SKY_ALPI,
    },
    {
        "id": 527829,
        "offset": 0x0c,
        "count": 2,
        "points": 2,
        "course": SKY_CAST,
    },
    {
        "id": 527830,
        "offset": 0x10,
        "count": 2,
        "points": 2,
        "course": SKY_FORE,
    },
    {
        "id": 527831,
        "offset": 0x12,
        "count": 2,
        "points": 2,
        "course": SKY_DESE,
    },
    {
        "id": 527832,
        "offset": 0x0a,
        "count": 3,
        "points": 3,
        "course": SKY_CLOU,
    },
    {
        "id": 527833,
        "offset": 0x04,
        "count": 3,
        "points": 3,
        "course": SKY_INDU,
    },
    {
        "id": 527834,
        "offset": 0x08,
        "count": 3,
        "points": 3,
        "course": SKY_SNOW,
    },
    {
        "id": 527835,
        "offset": 0x0e,
        "count": 3,
        "points": 3,
        "course": SKY_GHOS,
    },
    {
        "id": 527836,
        "offset": 0x14,
        "count": 4,
        "points": 4,
        "course": SKY_TULI,
    },
    {
        "id": 527837,
        "offset": 0x16,
        "count": 4,
        "points": 4,
        "course": SKY_METR,
    },
    {
        "id": 527838,
        "offset": 0x18,
        "count": 4,
        "points": 4,
        "course": SKY_RUIN,
    },
    {
        "id": 527839,
        "offset": 0x1c,
        "count": 4,
        "points": 4,
        "course": SKY_IMPE,
    },
    {
        "id": 527840,
        "offset": 0x1a,
        "count": 4,
        "points": 4,
        "course": SKY_CAPE,
    },
    // HOLLY (Mix 1 Courses)
    {
        "id": 527841,
        "offset": 0x76,
        "count": 1,
        "points": 1,
        "course": SKY_EAST,
    },
    {
        "id": 527842,
        "offset": 0x60,
        "count": 1,
        "points": 1,
        "course": SKY_LASV,
    },
    {
        "id": 527843,
        "offset": 0x52,
        "count": 1,
        "points": 1,
        "course": SKY_METR,
    },
    {
        "id": 527844,
        "offset": 0x4e,
        "count": 2,
        "points": 2,
        "course": SKY_DESE,
    },
    {
        "id": 527845,
        "offset": 0x70,
        "count": 2,
        "points": 2,
        "course": SKY_NEWY,
    },
    {
        "id": 527846,
        "offset": 0x62,
        "count": 2,
        "points": 2,
        "course": SKY_ALAS,
    },
    {
        "id": 527847,
        "offset": 0x42,
        "count": 3,
        "points": 3,
        "course": SKY_ALPI,
    },
    {
        "id": 527848,
        "offset": 0x6c,
        "count": 3,
        "points": 3,
        "course": SKY_YOSE,
    },
    {
        "id": 527849,
        "offset": 0x64,
        "count": 3,
        "points": 3,
        "course": SKY_GRAN,
    },
    {
        "id": 527850,
        "offset": 0x40,
        "count": 3,
        "points": 3,
        "course": SKY_INDU,
    },
    {
        "id": 527851,
        "offset": 0x5a,
        "count": 4,
        "points": 4,
        "course": SKY_BEAC,
    },
    {
        "id": 527852,
        "offset": 0x48,
        "count": 4,
        "points": 4,
        "course": SKY_CAST,
    },
    {
        "id": 527853,
        "offset": 0x56,
        "count": 4,
        "points": 4,
        "course": SKY_CAPE,
    },
    {
        "id": 527854,
        "offset": 0x68,
        "count": 4,
        "points": 4,
        "course": SKY_AMAZ,
    },
    {
        "id": 527855,
        "offset": 0x3c,
        "count": 4,
        "points": 4,
        "course": SKY_PALM,
    },
]

for event in girlfriend_events
{
    girlname = ""
    for x in girlfriend_levels
        if (event["offset"] >= x["first"] && event["offset"] < x["end"])
        {
            girlname = x["name"]
        }

    achievement(
        id=event["id"],
        title=format("{0}'s Challenge: {1}", girlname, track_lookup[event["course"]]),
        description=format("In {0}'s challenges, complete all events in {1} with a ranking of AAA",
            girlname, track_lookup[event["course"]]),
        points=event["points"],
        trigger=any_of(Regions, region => 
            IsRegion(region) &&
            eventType[region] == EVENT_GIRLFRIEND &&
            gameState[region] != STATE_MENU &&
            // AverageRatingIsBetter(FlagmanAddresses(region, event["event"], event["count"]), target_rank) &&
            // __ornext(!AverageRatingIsBetter(array_map(FlagmanAddresses(region, event["event"], event["count"]), (x) => prev(x)), target_rank))
            AAARating(region, GirlfriendAddresses(region, event["offset"], event["count"]))
        )
    )
}

for glevel in girlfriend_levels
{
    achievement(
        id=glevel["id"],
        title=glevel["title"],
        description=format("Complete all requests in {0}'s challenge with an average rating of A or higher",
            glevel["name"]),
        points=10,
        type="progression",
        trigger=any_of(Regions, region => 
            IsRegion(region) &&
            !UsedENTIRETY(region) &&
            prev(gameState[region]) != STATE_CONGRATULATIONS &&
            gameState[region] == STATE_CONGRATULATIONS &&
            any_of(glevel["screens"], (x) => congratsType[region] == x)
        )
    )
}

achievement(
    id=527796,
    title="Coast 2 Coast",
    description="Clear all events in Coast 2 Coast mode",
    points=25,
    type="win_condition",
    trigger=any_of(Regions, region => 
        IsRegion(region) &&
        !UsedENTIRETY(region) &&
        prev(gameState[region]) != STATE_CONGRATULATIONS &&
        gameState[region] == STATE_CONGRATULATIONS &&
        any_of([CONGRATS_CLEAR, CONGRATS_PERFECT], 
            (x) => congratsType[region] == x)
    )
)

achievement(
    id=527859,
    title="Step on Beat",
    description="Get perfect in every event in Coast 2 Coast mode",
    points=50,
    trigger=any_of(Regions, region => 
        IsRegion(region) &&
        !UsedENTIRETY(region) &&
        prev(gameState[region]) != STATE_CONGRATULATIONS &&
        gameState[region] == STATE_CONGRATULATIONS &&
        congratsType[region] == CONGRATS_PERFECT
    )
)

// OutRun Mode

outrun_params = [
    {
        "id": 527790,
        "title": "OutRun2SP OutRun Continuous",
        "event": "OutRun2SP OutRun Continuous",
        "points": 25,
        "mode": EVENT_SUB_CONTINUOUS_SP,
    },
    {
        "id": 527860,
        "title": "OutRun2 OutRun Continuous",
        "event": "OutRun2 OutRun Continuous",
        "points": 25,
        "mode": EVENT_SUB_CONTINUOUS,
    },
    {
        "id": 527791,
        "title": "OutRun2SP Goal A",
        "event": "OutRun2SP Goal A",
        "points": 10,
        "mode": EVENT_SUB_NORMAL_SP,
        "goal": "A",
        "zone": SKY_EAST,
    },
    {
        "id": 527792,
        "title": "OutRun2SP Goal B",
        "event": "OutRun2SP Goal B",
        "points": 10,
        "mode": EVENT_SUB_NORMAL_SP,
        "goal": "B",
        "zone": SKY_MAYA,
    },
    {
        "id": 527793,
        "title": "OutRun2SP Goal C",
        "event": "OutRun2SP Goal C",
        "points": 10,
        "mode": EVENT_SUB_NORMAL_SP,
        "goal": "C",
        "zone": SKY_PRIN,
    },
    {
        "id": 527794,
        "title": "OutRun2SP Goal D",
        "event": "OutRun2SP Goal D",
        "points": 10,
        "mode": EVENT_SUB_NORMAL_SP,
        "goal": "D",
        "zone": SKY_FLOR,
    },
    {
        "id": 527795,
        "title": "OutRun2SP Goal E",
        "event": "OutRun2SP Goal E",
        "points": 10,
        "mode": EVENT_SUB_NORMAL_SP,
        "goal": "E",
        "zone": SKY_NEWY,
    },
    {
        "id": 527861,
        "title": "OutRun2 Goal A",
        "event": "OutRun2 Goal A",
        "points": 10,
        "mode": EVENT_SUB_NORMAL,
        "goal": "A",
        "zone": SKY_TULI,
    },
    {
        "id": 527862,
        "title": "OutRun2 Goal B",
        "event": "OutRun2 Goal B",
        "points": 10,
        "mode": EVENT_SUB_NORMAL,
        "goal": "B",
        "zone": SKY_METR,
    },
    {
        "id": 527863,
        "title": "OutRun2 Goal C",
        "event": "OutRun2 Goal C",
        "points": 10,
        "mode": EVENT_SUB_NORMAL,
        "goal": "C",
        "zone": SKY_RUIN,
    },
    {
        "id": 527864,
        "title": "OutRun2 Goal D",
        "event": "OutRun2 Goal D",
        "points": 10,
        "mode": EVENT_SUB_NORMAL,
        "goal": "D",
        "zone": SKY_IMPE,
    },
    {
        "id": 527865,
        "title": "OutRun2 Goal E",
        "event": "OutRun2 Goal E",
        "points": 10,
        "mode": EVENT_SUB_NORMAL,
        "goal": "E",
        "zone": SKY_CAPE,
    },
]

for params in outrun_params
{
    name = "OutRun2SP"
    if (any_of([EVENT_SUB_NORMAL, EVENT_SUB_CONTINUOUS], mode => mode == params["mode"]))
    {
        name = "OutRun2"
    }
    
    if (any_of([EVENT_SUB_CONTINUOUS, EVENT_SUB_CONTINUOUS_SP], mode => mode == params["mode"]))
    {
        zone_check = always_true()
        description = format("With the \"OUTRUN2SP DIFF.\" setting set to Very Hard, reach the goal in 15 continuous course OutRun Mode for {0}", name)
    }
    else
    {
        zone_check = any_of(Regions, region => IsRegion(region) && currSky[region] == params["zone"])
        description = format("With the \"OUTRUN2SP DIFF.\" setting set to Very Hard, reach Goal {0} in OutRun Mode for {1}", params["goal"], name)
    }
    
    trigger = any_of(Regions, region => 
        IsRegion(region) &&
        eventType[region] == EVENT_OUTRUN &&
        eventSubType[region] == params["mode"] &&
        zone_check &&
        timeDifficulty[region] == DIFFICULTY_VERY_HARD &&
        HitGoal(region)
    )

    achievement(
        id=params["id"],
        title=params["title"],
        description=description,
        points=params["points"],
        trigger=trigger
    )
}

// Time Attack Achievements

time_attack_params = [
    {
        "id": 527797,
        "lbid": 134309,
        "title": "Time Attack - OutRun2SP Continuous",
        "event": "OutRun2SP Continuous",
        "goaltime": TimeToMillis(minutes=14, seconds=31, ms=785),
        "points": 50,
        "mode": EVENT_SUB_CONTINUOUS_SP,
        "zone": SKY_NEWY,
    },
    {
        "id": 527798,
        "lbid": 134310,
        "title": "Time Attack - OutRun2 Continuous",
        "event": "OutRun2 Continuous",
        "goaltime": TimeToMillis(minutes=14, seconds=19, ms=042),
        "points": 50,
        "mode": EVENT_SUB_CONTINUOUS,
        "zone": SKY_CAPE,
    },
    {
        "id": 527799,
        "lbid": 134311,
        "title": "Time Attack - OutRun2SP Goal A",
        "event": "OutRun2SP Goal A",
        "goaltime": TimeToMillis(minutes=4, seconds=55, ms=277),
        "points": 5,
        "mode": EVENT_SUB_NORMAL_SP,
        "goal": "A",
        "zone": SKY_EAST,
    },
    {
        "id": 527800,
        "lbid": 134312,
        "title": "Time Attack - OutRun2SP Goal B",
        "event": "OutRun2SP Goal B",
        "goaltime": TimeToMillis(minutes=4, seconds=56, ms=399),
        "points": 5,
        "mode": EVENT_SUB_NORMAL_SP,
        "goal": "B",
        "zone": SKY_MAYA,
    },
    {
        "id": 527801,
        "lbid": 134313,
        "title": "Time Attack - OutRun2SP Goal C",
        "event": "OutRun2SP Goal C",
        "goaltime": TimeToMillis(minutes=4, seconds=36, ms=650),
        "points": 10,
        "mode": EVENT_SUB_NORMAL_SP,
        "goal": "C",
        "zone": SKY_PRIN,
    },
    {
        "id": 527802,
        "lbid": 134314,
        "title": "Time Attack - OutRun2SP Goal D",
        "event": "OutRun2SP Goal D",
        "goaltime": TimeToMillis(minutes=4, seconds=33, ms=126),
        "points": 10,
        "mode": EVENT_SUB_NORMAL_SP,
        "goal": "D",
        "zone": SKY_FLOR,
    },
    {
        "id": 527803,
        "lbid": 134315,
        "title": "Time Attack - OutRun2SP Goal E",
        "event": "OutRun2SP Goal E",
        "goaltime": TimeToMillis(minutes=4, seconds=41, ms=300),
        "points": 10,
        "mode": EVENT_SUB_NORMAL_SP,
        "goal": "E",
        "zone": SKY_NEWY,
    },
    {
        "id": 527804,
        "lbid": 134316,
        "title": "Time Attack - OutRun2 Goal A",
        "event": "OutRun2 Goal A",
        "goaltime": TimeToMillis(minutes=4, seconds=51, ms=257),
        "points": 5,
        "mode": EVENT_SUB_NORMAL,
        "goal": "A",
        "zone": SKY_TULI,
    },
    {
        "id": 527805,
        "lbid": 134317,
        "title": "Time Attack - OutRun2 Goal B",
        "event": "OutRun2 Goal B",
        "goaltime": TimeToMillis(minutes=4, seconds=58, ms=648),
        "points": 5,
        "mode": EVENT_SUB_NORMAL,
        "goal": "B",
        "zone": SKY_METR,
    },
    {
        "id": 527806,
        "lbid": 134318,
        "title": "Time Attack - OutRun2 Goal C",
        "event": "OutRun2 Goal C",
        "goaltime": TimeToMillis(minutes=4, seconds=36, ms=998),
        "points": 10,
        "mode": EVENT_SUB_NORMAL,
        "goal": "C",
        "zone": SKY_RUIN,
    },
    {
        "id": 527807,
        "lbid": 134319,
        "title": "Time Attack - OutRun2 Goal D",
        "event": "OutRun2 Goal D",
        "goaltime": TimeToMillis(minutes=4, seconds=37, ms=044),
        "points": 10,
        "mode": EVENT_SUB_NORMAL,
        "goal": "D",
        "zone": SKY_IMPE,
    },
    {
        "id": 527808,
        "lbid": 134320,
        "title": "Time Attack - OutRun2 Goal E",
        "event": "OutRun2 Goal E",
        "goaltime": TimeToMillis(minutes=4, seconds=34, ms=700),
        "points": 10,
        "mode": EVENT_SUB_NORMAL,
        "goal": "E",
        "zone": SKY_CAPE,
    },
    {
        "id": 535729,
        "lbid": 136258,
        "title": "Time Attack - OutRun2SP Continuous (Reverse)",
        "event": "OutRun2SP Continuous (Reverse)",
        "goaltime": TimeToMillis(minutes=14, seconds=28, ms=045),
        "points": 50,
        "mode": EVENT_SUB_CONTINUOUS_SP,
        "zone": SKY_BEAC,
    },
    {
        "id": 535730,
        "lbid": 136259,
        "title": "Time Attack - OutRun2 Continuous (Reverse)",
        "event": "OutRun2 Continuous (Reverse)",
        "goaltime": TimeToMillis(minutes=14, seconds=19, ms=042),
        "points": 50,
        "mode": EVENT_SUB_CONTINUOUS_SP,
        "zone": SKY_PALM,
    },
    {
        "id": 535731,
        "lbid": 136260,
        "title": "Time Attack - OutRun2SP Goal A (Reverse)",
        "event": "OutRun2SP Goal A (Reverse)",
        "goaltime": TimeToMillis(minutes=4, seconds=43, ms=015),
        "points": 10,
        "mode": EVENT_SUB_NORMAL_SP,
        "goal": "A (Reverse)",
        "reverse": true,
        "start_zone": SKY_EAST,
        "zone": SKY_BEAC,
    },
    {
        "id": 535732,
        "lbid": 136261,
        "title": "Time Attack - OutRun2SP Goal B (Reverse)",
        "event": "OutRun2SP Goal B (Reverse)",
        "goaltime": TimeToMillis(minutes=4, seconds=41, ms=105),
        "points": 10,
        "mode": EVENT_SUB_NORMAL_SP,
        "goal": "B (Reverse)",
        "reverse": true,
        "start_zone": SKY_MAYA,
        "zone": SKY_BEAC,
    },
    {
        "id": 535733,
        "lbid": 136262,
        "title": "Time Attack - OutRun2SP Goal C (Reverse)",
        "event": "OutRun2SP Goal C (Reverse)",
        "goaltime": TimeToMillis(minutes=4, seconds=40, ms=020),
        "points": 10,
        "mode": EVENT_SUB_NORMAL_SP,
        "goal": "C (Reverse)",
        "reverse": true,
        "start_zone": SKY_PRIN,
        "zone": SKY_BEAC,
    },
    {
        "id": 535734,
        "lbid": 136263,
        "title": "Time Attack - OutRun2SP Goal D (Reverse)",
        "event": "OutRun2SP Goal D (Reverse)",
        "goaltime": TimeToMillis(minutes=4, seconds=35, ms=237),
        "points": 10,
        "mode": EVENT_SUB_NORMAL_SP,
        "goal": "D (Reverse)",
        "reverse": true,
        "start_zone": SKY_FLOR,
        "zone": SKY_BEAC,
    },
    {
        "id": 535735,
        "lbid": 136264,
        "title": "Time Attack - OutRun2SP Goal E (Reverse)",
        "event": "OutRun2SP Goal E (Reverse)",
        "goaltime": TimeToMillis(minutes=4, seconds=41, ms=689),
        "points": 10,
        "mode": EVENT_SUB_NORMAL_SP,
        "goal": "E (Reverse)",
        "reverse": true,
        "start_zone": SKY_NEWY,
        "zone": SKY_BEAC,
    },
    {
        "id": 535736,
        "lbid": 136265,
        "title": "Time Attack - OutRun2 Goal A (Reverse)",
        "event": "OutRun2 Goal A (Reverse)",
        "goaltime": TimeToMillis(minutes=4, seconds=40, ms=334),
        "points": 10,
        "mode": EVENT_SUB_NORMAL,
        "goal": "A (Reverse)",
        "reverse": true,
        "start_zone": SKY_TULI,
        "zone": SKY_PALM,
    },
    {
        "id": 535737,
        "lbid": 136266,
        "title": "Time Attack - OutRun2 Goal B (Reverse)",
        "event": "OutRun2 Goal B (Reverse)",
        "goaltime": TimeToMillis(minutes=4, seconds=34, ms=123),
        "points": 10,
        "mode": EVENT_SUB_NORMAL,
        "goal": "B (Reverse)",
        "reverse": true,
        "start_zone": SKY_METR,
        "zone": SKY_PALM,
    },
    {
        "id": 535738,
        "lbid": 136267,
        "title": "Time Attack - OutRun2 Goal C (Reverse)",
        "event": "OutRun2 Goal C (Reverse)",
        "goaltime": TimeToMillis(minutes=4, seconds=41, ms=304),
        "points": 10,
        "mode": EVENT_SUB_NORMAL,
        "goal": "C (Reverse)",
        "reverse": true,
        "start_zone": SKY_RUIN,
        "zone": SKY_PALM,
    },
    {
        "id": 535739,
        "lbid": 136268,
        "title": "Time Attack - OutRun2 Goal D (Reverse)",
        "event": "OutRun2 Goal D (Reverse)",
        "goaltime": TimeToMillis(minutes=4, seconds=38, ms=557),
        "points": 10,
        "mode": EVENT_SUB_NORMAL,
        "goal": "D (Reverse)",
        "reverse": true,
        "start_zone": SKY_IMPE,
        "zone": SKY_PALM,
    },
    {
        "id": 535740,
        "lbid": 136269,
        "title": "Time Attack - OutRun2 Goal E (Reverse)",
        "event": "OutRun2 Goal E (Reverse)",
        "goaltime": TimeToMillis(minutes=4, seconds=37, ms=863),
        "points": 10,
        "mode": EVENT_SUB_NORMAL,
        "goal": "E (Reverse)",
        "reverse": true,
        "start_zone": SKY_CAPE,
        "zone": SKY_PALM,
    },
]

for params in time_attack_params
{
    name = "OutRun2SP"
    if (any_of([EVENT_SUB_NORMAL, EVENT_SUB_CONTINUOUS], mode => mode == params["mode"]))
    {
        name = "OutRun2"
    }

    time_format = MillisToTimestamp(params["goaltime"])
    if (any_of([EVENT_SUB_CONTINUOUS, EVENT_SUB_CONTINUOUS_SP], mode => mode == params["mode"]))
    {
        target = format(
            "In the mode named \"Single Player,\" reach the goal in 15 Stage Continuous{1} in Time Attack Mode for {0}",
            name,
            if_else(dict_get(params, "reverse"), " (Reverse)", "")
        )
    }
    else
    {
        target = format("In the mode named \"Single Player,\" reach Goal {0} in Time Attack Mode for {1}", params["goal"], name)
    }
    
    reverse_check = always_true()
    if dict_get(params, "reverse") && dict_get(params, "start_zone", "None") != "None"
    {
        reverse_check = any_of(Regions, region =>
            IsRegion(region) &&
            firstSky[region] == params["start_zone"]
        )
    }
    
    trigger = any_of(Regions, region => 
        IsRegion(region) &&
        //__ornext(any_of([EVENT_TIME_ATTACK, EVENT_TIME_ATTACK_1PLAYER], e => eventType[region] == e)) &&
        eventType[region] == EVENT_TIME_ATTACK_1PLAYER &&
        numStagesLoaded[region] != 1 &&
        eventSubType[region] == params["mode"] &&
        reverse_check &&
        currSky[region] == params["zone"] &&
        (eventTime[region] - 1) <= params["goaltime"] * IGT_DIVISOR / 1000 &&
        HitGoal(region)
    )

    achievement(
        id=params["id"],
        title=params["title"],
        description=format("{0} in under {1}", target, time_format),
        points=params["points"],
        trigger=trigger
    )

    leaderboard(
        id=params["lbid"],
        title="Time Attack - " + params["event"],
        description=target + " as quickly as possible",

        start=any_of(Regions, region => 
            IsRegion(region) &&
            __ornext(any_of([EVENT_TIME_ATTACK, EVENT_TIME_ATTACK_1PLAYER], e => eventType[region] == e)) &&
            numStagesLoaded[region] != 1 &&
            eventSubType[region] == params["mode"] &&
            reverse_check &&
            currSky[region] == params["zone"] &&
            HitGoal(region)
        ),
        cancel=always_false(),
        submit=always_true(),
        
        value=max_of(array_map(Regions, region => measured((eventTime[region] - 1) / IGT_DIVISOR * 100, when=IsRegion(region)))),
        format="MILLISECS",
        lower_is_better=true
    )
}

// Heart Attack Mode Achievements

heart_attack_params = [
    {
        "id": 527868,
        "lbid": 134323,
        "title": "Heart Attack - OutRun2SP Goal A",
        "event": "OutRun2SP Goal A",
        "points": 10,
        "mode": EVENT_SUB_NORMAL_SP,
        "goal": "A",
        "zone": SKY_EAST,
    },
    {
        "id": 527869,
        "lbid": 134324,
        "title": "Heart Attack - OutRun2SP Goal B",
        "event": "OutRun2SP Goal B",
        "points": 10,
        "mode": EVENT_SUB_NORMAL_SP,
        "goal": "B",
        "zone": SKY_MAYA,
    },
    {
        "id": 527870,
        "lbid": 134325,
        "title": "Heart Attack - OutRun2SP Goal C",
        "event": "OutRun2SP Goal C",
        "points": 10,
        "mode": EVENT_SUB_NORMAL_SP,
        "goal": "C",
        "zone": SKY_PRIN,
    },
    {
        "id": 527871,
        "lbid": 134326,
        "title": "Heart Attack - OutRun2SP Goal D",
        "event": "OutRun2SP Goal D",
        "points": 10,
        "mode": EVENT_SUB_NORMAL_SP,
        "goal": "D",
        "zone": SKY_FLOR,
    },
    {
        "id": 527872,
        "lbid": 134327,
        "title": "Heart Attack - OutRun2SP Goal E",
        "event": "OutRun2SP Goal E",
        "points": 10,
        "mode": EVENT_SUB_NORMAL_SP,
        "goal": "E",
        "zone": SKY_NEWY,
    },
    {
        "id": 527873,
        "lbid": 134328,
        "title": "Heart Attack - OutRun2 Goal A",
        "event": "OutRun2 Goal A",
        "points": 10,
        "mode": EVENT_SUB_NORMAL,
        "goal": "A",
        "zone": SKY_TULI,
    },
    {
        "id": 527874,
        "lbid": 134329,
        "title": "Heart Attack - OutRun2 Goal B",
        "event": "OutRun2 Goal B",
        "points": 10,
        "mode": EVENT_SUB_NORMAL,
        "goal": "B",
        "zone": SKY_METR,
    },
    {
        "id": 527875,
        "lbid": 134330,
        "title": "Heart Attack - OutRun2 Goal C",
        "event": "OutRun2 Goal C",
        "points": 10,
        "mode": EVENT_SUB_NORMAL,
        "goal": "C",
        "zone": SKY_RUIN,
    },
    {
        "id": 527876,
        "lbid": 134331,
        "title": "Heart Attack - OutRun2 Goal D",
        "event": "OutRun2 Goal D",
        "points": 10,
        "mode": EVENT_SUB_NORMAL,
        "goal": "D",
        "zone": SKY_IMPE,
    },
    {
        "id": 527877,
        "lbid": 134332,
        "title": "Heart Attack - OutRun2 Goal E",
        "event": "OutRun2 Goal E",
        "points": 10,
        "mode": EVENT_SUB_NORMAL,
        "goal": "E",
        "zone": SKY_CAPE,
    },
]

for params in heart_attack_params
{
    name = "OutRun2SP"
    if (any_of([EVENT_SUB_NORMAL, EVENT_SUB_CONTINUOUS], mode => mode == params["mode"]))
    {
        name = "OutRun2"
    }
    
    if (any_of([EVENT_SUB_CONTINUOUS, EVENT_SUB_CONTINUOUS_SP], mode => mode == params["mode"]))
    {
        zone_check = always_true()
        target = format("in 15 continuous course Heart Attack Mode for {0}", name)
    }
    else
    {
        zone_check = any_of(Regions, region => IsRegion(region) && currSky[region] == params["zone"])
        target = format("at Goal {0} in Heart Attack Mode for {1}", params["goal"], name)
    }

    continuous = any_of([EVENT_SUB_CONTINUOUS_SP, EVENT_SUB_CONTINUOUS], e => e == params["mode"])

    achievement(
        id=params["id"],
        title=params["title"],
        description="Earn a AA ranking or better " + target,
        points=params["points"],
        trigger=any_of(Regions, region => 
            IsRegion(region) &&
            eventType[region] == EVENT_HEART_ATTACK &&
            eventSubType[region] == params["mode"] &&
            zone_check &&
            HitGoal(region) &&
            HeartAttackRank(region, continuous=continuous) >= RANK_AA
        )
    )

    leaderboard(
        id=params["lbid"],
        title="Heart Attack - " + params["event"],
        description="Earn as many hearts as possible " + target,

        start=any_of(Regions, region => 
            IsRegion(region) &&
            eventType[region] == EVENT_HEART_ATTACK &&
            eventSubType[region] == params["mode"] &&
            zone_check &&
            HitGoal(region)
        ),
        cancel=always_false(),
        submit=always_true(),

        value=max_of(array_map(Regions, region => measured(heartAttackHearts[region]/10000, when=IsRegion(region)))),
        format="SCORE",
        lower_is_better=false
    )
}

// Other Achievements

achievement(
    id=527878,
    title="Look at Him Go!",
    description="Stay at the starting line for the whole race. I didn't know the flagman had moves like that!",
    points=1,
    trigger=any_of(Regions, region => 
        IsRegion(region) &&
        eventDistance[region] == 1 &&
        prev(gameState[region]) == STATE_DRIVING &&
        gameState[region] == STATE_TIMEUP
    )
)
