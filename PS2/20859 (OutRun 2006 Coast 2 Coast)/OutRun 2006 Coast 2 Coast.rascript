// OutRun 2006: Coast 2 Coast
// #ID = 20859

NULL = 0
True = 1
False = 0
NO_ADDR = 0xFFFF0 // always 0x0 when read

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

function assert(cond, msg="No Assertion Message")
{
    if cond == false
    {
        l = {}
        return l[msg]
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

// GAME VARIABLES

inRace = {
    US: dword(0x359a4c),
    EU: dword(NO_ADDR),
    JP: dword(NO_ADDR),
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
    EU: dword(NO_ADDR),
    JP: dword(NO_ADDR),
}

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
    EU: byte(NO_ADDR),
    JP: byte(NO_ADDR),
}

// Transmission type
TRANS_AUTO = 0x0
TRANS_MANUAL = 0x1
transmission = {
    US: byte(0x369BEA),
    EU: byte(NO_ADDR),
    JP: byte(NO_ADDR),
}

// The type of active event
EVENT_TIME_ATTACK = 0
EVENT_OUTRUN = 1
EVENT_HEART_ATTACK = 2
EVENT_GIRLFRIEND = 5
EVENT_FLAGMAN = 6
eventType = {
    US: dword(0x443F08),
    EU: dword(NO_ADDR),
    JP: dword(NO_ADDR),
}

EVENT_SUB_NORMAL_SP = 0x0
EVENT_SUB_NORMAL = 0x1
EVENT_SUB_CONTINUOUS_SP = 0x2
EVENT_SUB_CONTINUOUS = 0x3
eventSubType = {
    US: dword(0x443F0C),
    EU: dword(NO_ADDR),
    JP: dword(NO_ADDR),
}

STATE_ARCADE_MODE = 0x0A
STATE_DRIVING = 0x10
STATE_GOAL = 0x13
STATE_MENU = 0x20
STATE_CONGRATULATIONS = 0x24
gameState = {
    US: dword(0x443F10),
    EU: dword(NO_ADDR),
    JP: dword(NO_ADDR),
}

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
    EU: dword(NO_ADDR),
    JP: dword(NO_ADDR),
}

flagmanRanks = {
    US: 0x00589245,
    EU: NO_ADDR,
    JP: NO_ADDR,
}

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
function AAARating(list)
{
    if (length(list) == 1) return list[0] == 0x06 && prev(list[0]) != 0x06
    return measured(tally_of(list, length(list), (x) => once(x == 0x06 && never(x != 0x06)))) &&
        __ornext(any_of(list, (x) => prev(x) != 0x06))
}

function FlagmanAddresses(region, event, count)
{
    return array_map(range(0, count-1), 
        (i) => byte(flagmanRanks[region] + 5 * (event-1) + i))
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
    SKY_PALM: "🌴 Palm Beach",
    SKY_LAKE: "🚣 Deep Lake",
    SKY_INDU: "🏭 Industrial Complex",
    SKY_ALPI: "🏔️ Alpine",
    SKY_SNOW: "🏔️ Snow Mountain",
    SKY_CLOU: "☁️ Cloudy Highland",
    SKY_CAST: "🏰 Castle Wall",
    SKY_GHOS: "👻 Ghost Forest",
    SKY_FORE: "🌲 Coniferous Forest",
    SKY_DESE: "🏜️ Desert",
    SKY_TULI: "🌷 Tulip Garden",
    SKY_METR: "🌁 Metropolis",
    SKY_RUIN: "🧭 Ancient Ruins",
    SKY_CAPE: "🛣️ Cape Way",
    SKY_IMPE: "🏛️ Imperial Avenue",
    SKY_GRAN: "🌄 Canyon",
    SKY_SEQU: "🌲 Big Forest",
    SKY_SANF: "🌉 Bay Area",
    SKY_NEWY: "🏙️ Skyscrapers",
    SKY_MACH: "🏺 Lost City",
    SKY_YOSE: "🏞️ National Park",
    SKY_MAYA: "🏛️ Legend",
    SKY_NIAG: "🏞️ Water Falls",
    SKY_ALAS: "❄️ Ice Scape",
    SKY_AMAZ: "🦁 Jungle",
    SKY_BEAC: "🏖️ Sunny Beach",
    SKY_LASV: "🌆 Casino Town",
    SKY_PRIN: "🌸 Floral Village",
    SKY_FLOR: "🌌 Milky Way",
    SKY_EAST: "🗿 Giant Statues",
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
    rp_track = rich_presence_lookup("TRACK", currSky[region], track_lookup, "Unknown Zone")
    rp_trans = rich_presence_lookup("TRANS", transmission[region], trans_lookup, "??")
    rp_car = rich_presence_lookup("CAR", car[region], car_lookup, "Unknown Car")
    rp_event = rich_presence_lookup("EVENT", eventType[region], event_lookup, "Unknown Event")
    rp_event_sub = rich_presence_lookup("EVENT_SUB", eventSubType[region], event_sub_lookup, "")

    rich_presence_conditional_display(
        IsRegion(region) && UsedENTIRETY(region),
        "{0} ⚠️ Clarissa would not approve of cheating!",
        rp_region
    )
    rich_presence_conditional_display(
        IsRegion(region) && IsInGame(region),
        "{0} OutRunning | {1}{2} | {3} ({4}) | {5}",
        rp_region,
        rp_event,
        rp_event_sub,
        rp_car,
        rp_trans,
        rp_track
    )
    rich_presence_conditional_display(
        IsRegion(region),
        "{0} In menu or loading screen",
        rp_region
    )
}

rich_presence_display("Playing OutRun 2006: Coast 2 Coast")

// ACHIEVEMENTS

challenge_description = {
    "race": "Race the Rivals!",
    "girlfriend": "Don't lose your Girlfriend!",
    "slipstream": "Test your Slipstream!",
    "knockout": "Avoid the Knockout!",
    "drift": "Test your Drift!",
}

// Flagman Mode

flagman_levels = [
    {
        "group": 1,
        "name": "NOVICE",
        "first": 1,
        
        "id": 0,
        "screens": [CONGRATS_FLAG1,],
        "title": "Flagman is Impressed",
    },
    {
        "group": 2,
        "name": "INTERMEDIATE",
        "first": 6,
        
        "id": 0,
        "screens": [CONGRATS_FLAG2,],
        "title": "Flagman is Amazed",
    },
    {
        "group": 3,
        "name": "PROFESSIONAL",
        "first": 15,
        
        "id": 0,
        "screens": [CONGRATS_FLAG3,],
        "title": "Flagman is Thrilled",
    },
    {
        "group": 4,
        "name": "OUTRUN",
        "first": 26,

        "id": 0,
        "screens": [CONGRATS_FLAG4, CONGRATS_CLEAR, CONGRATS_PERFECT,],
        "title": "Flagman Got Chills",
    },
]

flagman_events = [
    {
        "id": 0,
        "event": 1,
        "count": 3,
        "type": "race",
    },
    {
        "id": 0,
        "event": 2,
        "count": 2,
        "type": "race",
    },
    {
        "id": 0,
        "event": 3,
        "count": 1,
        "type": "drift",
    },
    {
        "id": 0,
        "event": 4,
        "count": 2,
        "type": "race",
    },
    {
        "id": 0,
        "event": 5,
        "count": 1,
        "type": "race",
    },
    {
        "id": 0,
        "event": 6,
        "count": 1,
        "type": "girlfriend",
    },
    {
        "id": 0,
        "event": 7,
        "count": 3,
        "type": "race",
    },
    {
        "id": 0,
        "event": 8,
        "count": 2,
        "type": "race",
    },
    {
        "id": 0,
        "event": 9,
        "count": 1,
        "type": "slipstream",
    },
    {
        "id": 0,
        "event": 10,
        "count": 2,
        "type": "race",
    },
    {
        "id": 0,
        "event": 11,
        "count": 3,
        "type": "race",
    },
    {
        "id": 0,
        "event": 12,
        "count": 1,
        "type": "knockout",
    },
    {
        "id": 0,
        "event": 13,
        "count": 2,
        "type": "race",
    },
    {
        "id": 0,
        "event": 14,
        "count": 2,
        "type": "race",
    },
    {
        "id": 0,
        "event": 15,
        "count": 2,
        "type": "drift",
    },
    {
        "id": 0,
        "event": 16,
        "count": 4,
        "type": "race",
    },
    {
        "id": 0,
        "event": 17,
        "count": 2,
        "type": "race",
    },
    {
        "id": 0,
        "event": 18,
        "count": 2,
        "type": "slipstream",
    },
    {
        "id": 0,
        "event": 19,
        "count": 3,
        "type": "race",
    },
    {
        "id": 0,
        "event": 20,
        "count": 2,
        "type": "race",
    },
    {
        "id": 0,
        "event": 21,
        "count": 1,
        "type": "knockout",
    },
    {
        "id": 0,
        "event": 22,
        "count": 4,
        "type": "race",
    },
    {
        "id": 0,
        "event": 23,
        "count": 3,
        "type": "race",
    },
    {
        "id": 0,
        "event": 24,
        "count": 1,
        "type": "girlfriend",
    },
    {
        "id": 0,
        "event": 25,
        "count": 5,
        "type": "race",
    },
    {
        "id": 0,
        "event": 26,
        "count": 5,
        "type": "race",
    },
    {
        "id": 0,
        "event": 27,
        "count": 2,
        "type": "slipstream",
    },
    {
        "id": 0,
        "event": 28,
        "count": 2,
        "type": "race",
    },
    {
        "id": 0,
        "event": 29,
        "count": 5,
        "type": "race",
    },
    {
        "id": 0,
        "event": 30,
        "count": 2,
        "type": "drift",
    },
    {
        "id": 0,
        "event": 31,
        "count": 3,
        "type": "race",
    },
    {
        "id": 0,
        "event": 32,
        "count": 5,
        "type": "race",
    },
    {
        "id": 0,
        "event": 33,
        "count": 1,
        "type": "knockout",
    },
    {
        "id": 0,
        "event": 34,
        "count": 2,
        "type": "race",
    },
    {
        "id": 0,
        "event": 35,
        "count": 3,
        "type": "race",
    },
    {
        "id": 0,
        "event": 36,
        "count": 1,
        "type": "girlfriend",
    },
    {
        "id": 0,
        "event": 37,
        "count": 2,
        "type": "race",
    },
    {
        "id": 0,
        "event": 38,
        "count": 2,
        "type": "race",
    },
    {
        "id": 0,
        "event": 39,
        "count": 2,
        "type": "drift",
    },
    {
        "id": 0,
        "event": 40,
        "count": 2,
        "type": "race",
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
            challenge_description[event["type"]], fgroup, event["event"], fgroupname),
        points=event["count"],
        trigger=any_of(Regions, region => 
            IsRegion(region) &&
            eventType[region] == EVENT_FLAGMAN &&
            gameState[region] != STATE_MENU &&
            // AverageRatingIsBetter(FlagmanAddresses(region, event["event"], event["count"]), target_rank) &&
            // __ornext(!AverageRatingIsBetter(array_map(FlagmanAddresses(region, event["event"], event["count"]), (x) => prev(x)), target_rank))
            AAARating(FlagmanAddresses(region, event["event"], event["count"]))
        )
    )
}

for flevel in flagman_levels
{
    achievement(
        id=flevel["id"],
        title=flevel["title"],
        description=format("Complete all {0} events in Flagman {1} with an average rating of A or higher",
            flevel["name"], flevel["group"]),
        points=10,
        trigger=any_of(Regions, region => 
            IsRegion(region) &&
            prev(gameState[region]) != STATE_CONGRATULATIONS &&
            gameState[region] == STATE_CONGRATULATIONS &&
            any_of(flevel["screens"], (x) => congratsType[region] == x)
        )
    )
}

// Girlfriend Mode

// OutRun Mode

outrun_params = [
    {
        "id": 0,
        "title": "OutRun2SP OutRun Continuous",
        "points": 25,
        "mode": EVENT_SUB_CONTINUOUS_SP,
    },
    {
        "id": 0,
        "title": "OutRun2 OutRun Continuous",
        "points": 25,
        "mode": EVENT_SUB_CONTINUOUS,
    },
    {
        "id": 0,
        "title": "OutRun2SP Goal A",
        "points": 10,
        "mode": EVENT_SUB_NORMAL_SP,
        "goal": "A",
        "zone": SKY_EAST,
    },
    {
        "id": 0,
        "title": "OutRun2SP Goal B",
        "points": 10,
        "mode": EVENT_SUB_NORMAL_SP,
        "goal": "B",
        "zone": SKY_MAYA,
    },
    {
        "id": 0,
        "title": "OutRun2SP Goal C",
        "points": 10,
        "mode": EVENT_SUB_NORMAL_SP,
        "goal": "C",
        "zone": SKY_PRIN,
    },
    {
        "id": 0,
        "title": "OutRun2SP Goal D",
        "points": 10,
        "mode": EVENT_SUB_NORMAL_SP,
        "goal": "D",
        "zone": SKY_FLOR,
    },
    {
        "id": 0,
        "title": "OutRun2SP Goal E",
        "points": 10,
        "mode": EVENT_SUB_NORMAL_SP,
        "goal": "E",
        "zone": SKY_NEWY,
    },
    {
        "id": 0,
        "title": "OutRun2 Goal A",
        "points": 10,
        "mode": EVENT_SUB_NORMAL,
        "goal": "A",
        "zone": SKY_TULI,
    },
    {
        "id": 0,
        "title": "OutRun2 Goal B",
        "points": 10,
        "mode": EVENT_SUB_NORMAL,
        "goal": "B",
        "zone": SKY_METR,
    },
    {
        "id": 0,
        "title": "OutRun2 Goal C",
        "points": 10,
        "mode": EVENT_SUB_NORMAL,
        "goal": "C",
        "zone": SKY_RUIN,
    },
    {
        "id": 0,
        "title": "OutRun2 Goal D",
        "points": 10,
        "mode": EVENT_SUB_NORMAL,
        "goal": "D",
        "zone": SKY_IMPE,
    },
    {
        "id": 0,
        "title": "OutRun2 Goal E",
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
        description = format("Reach the goal in 15 continuous course OutRun Mode for {0}.", name)
    }
    else
    {
        zone_check = any_of(Regions, region => IsRegion(region) && currSky[region] == params["zone"])
        description = format("Reach Goal {0} in OutRun Mode for {1}.", params["goal"], name)
    }
    
    achievement(
        id=params["id"],
        title=params["title"],
        description=description,
        points=params["points"],
        trigger=any_of(Regions, region => 
            IsRegion(region) &&
            eventType[region] == EVENT_OUTRUN &&
            eventSubType[region] == params["mode"] &&
            zone_check &&
            HitGoal(region)
        )
    )
}

//