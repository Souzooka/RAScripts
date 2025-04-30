// Jet de Go! 2: Let's Go By Airliner
// #ID = 33526

////////////////////////
// UTILTY FUNCTIONS   //
////////////////////////

NULL = 0

function if_else(cond, v1, v2)
{
    if cond return v1
    return v2
}

////////////////////////
// GAME FUNCTIONS     //
////////////////////////

function InGame()
{
    // Tentative
    return dword(0x27C37C) != NULL
}

function GetCheckpoint(index)
{
    return dword(g_checkpoints + (index * 4))
}

function IsScenario(scenario)
{
    cond = always_true()
    cond = cond && scenario["index"] == g_scenario_index
    cond = cond && scenario["type"] == g_scenario_type
    cond = cond && scenario["origin"] == g_trip_origin
    cond = cond && scenario["destination"] == g_trip_destination
    return cond
}

function HashScenario(index, type, origin, destination)
{
    return (index * 0x1) +
           (type * 0x100) +
           (origin * 0x10000) +
           (destination * 0x1000000)
}

function IsPreparingForTakeoff()
{
    return g_previous_checkpoint_index == 0 && IsTaxi()
}

function IsTakingOff()
{
    return g_previous_checkpoint_index == 0 && 
           IsTaxi(speed_limit=false) &&
           g_plane_speed > TAXI_SPEED_LIMIT
}

function IsLanding()
{
    return GetCheckpoint(g_next_checkpoint_index) == -1 &&
           IsTaxi(speed_limit=false) &&
           g_plane_speed > TAXI_SPEED_LIMIT
}

function IsLanded()
{
    return GetCheckpoint(g_next_checkpoint_index) == -1 && IsTaxi()
}

function IsTaxi(speed_limit=true)
{
    return (!speed_limit || g_plane_speed <= TAXI_SPEED_LIMIT) &&
           TAXI_HEIGHT_MIN_LIMIT <= g_relative_plane_altitude && g_relative_plane_altitude <= TAXI_HEIGHT_MAX_LIMIT &&
           TAXI_PITCH_MIN_LIMIT <= g_plane_pitch && g_plane_pitch <= TAXI_PITCH_MAX_LIMIT
}

////////////////////////
// USER VARIABLES     //
////////////////////////

ScenarioInfo = [
    {
        "index": 0,
        "type": 2,
        "origin": 0,
        "destination": 2,
        "name": "Tokyo International Airport SCENARIO-1",
    },
    {
        "index": 1,
        "type": 2,
        "origin": 1,
        "destination": 2,
        "name": "Tokyo International Airport SCENARIO-2",
    },
    {
        "index": 2,
        "type": 2,
        "origin": 6,
        "destination": 2,
        "name": "Tokyo International Airport SCENARIO-3",
    },
    {
        "index": 3,
        "type": 2,
        "origin": 5,
        "destination": 2,
        "name": "Tokyo International Airport SCENARIO-4",
    },
    {
        "index": 4,
        "type": 2,
        "origin": 5,
        "destination": 2,
        "name": "Tokyo International Airport SCENARIO-5",
    },
    {
        "index": 0,
        "type": 1,
        "origin": 3,
        "destination": 0,
        "name": "Nagoya Airport SCENARIO-1",
    },
    {
        "index": 1,
        "type": 2,
        "origin": 0,
        "destination": 3,
        "name": "Nagoya Airport SCENARIO-2",
    },
    {
        "index": 2,
        "type": 2,
        "origin": 8,
        "destination": 3,
        "name": "Nagoya Airport SCENARIO-3",
    },
    {
        "index": 3,
        "type": 2,
        "origin": 7,
        "destination": 3,
        "name": "Nagoya Airport SCENARIO-4",
    },
    {
        "index": 0,
        "type": 2,
        "origin": 2,
        "destination": 6,
        "name": "Kansai International Airport SCENARIO-1",
    },
    {
        "index": 1,
        "type": 2,
        "origin": 2,
        "destination": 6,
        "name": "Kansai International Airport SCENARIO-2",
    },
    {
        "index": 2,
        "type": 2,
        "origin": 7,
        "destination": 6,
        "name": "Kansai International Airport SCENARIO-3",
    },
    {
        "index": 3,
        "type": 2,
        "origin": 0,
        "destination": 6,
        "name": "Kansai International Airport SCENARIO-4",
    },
    {
        "index": 4,
        "type": 3,
        "origin": 2,
        "destination": 6,
        "name": "Kansai International Airport SCENARIO-5",
    },
    {
        "index": 0,
        "type": 0,
        "origin": 4,
        "destination": 0,
        "name": "Osaka International Airport SCENARIO-1",
    },
    {
        "index": 1,
        "type": 2,
        "origin": 2,
        "destination": 4,
        "name": "Osaka International Airport SCENARIO-2",
    },
    {
        "index": 2,
        "type": 2,
        "origin": 7,
        "destination": 4,
        "name": "Osaka International Airport SCENARIO-3",
    },
    {
        "index": 3,
        "type": 2,
        "origin": 7,
        "destination": 4,
        "name": "Osaka International Airport SCENARIO-4",
    },
    {
        "index": 0,
        "type": 2,
        "origin": 2,
        "destination": 5,
        "name": "Hiroshima Airport SCENARIO-1",
    },
    {
        "index": 1,
        "type": 2,
        "origin": 2,
        "destination": 5,
        "name": "Hiroshima Airport SCENARIO-2",
    },
    {
        "index": 2,
        "type": 2,
        "origin": 2,
        "destination": 5,
        "name": "Hiroshima Airport SCENARIO-3",
    },
    {
        "index": 3,
        "type": 1,
        "origin": 5,
        "destination": 2,
        "name": "Hiroshima Airport SCENARIO-4",
    },
    {
        "index": 0,
        "type": 0,
        "origin": 7,
        "destination": 8,
        "name": "Fukuoka Airport SCENARIO-1",
    },
    {
        "index": 1,
        "type": 2,
        "origin": 3,
        "destination": 7,
        "name": "Fukuoka Airport SCENARIO-2",
    },
    {
        "index": 2,
        "type": 2,
        "origin": 8,
        "destination": 7,
        "name": "Fukuoka Airport SCENARIO-3",
    },
    {
        "index": 3,
        "type": 2,
        "origin": 8,
        "destination": 7,
        "name": "Fukuoka Airport SCENARIO-4",
    },
    {
        "index": 0,
        "type": 1,
        "origin": 8,
        "destination": 4,
        "name": "Naha Airport SCENARIO-1",
    },
    {
        "index": 1,
        "type": 2,
        "origin": 4,
        "destination": 8,
        "name": "Naha Airport SCENARIO-2",
    },
    {
        "index": 2,
        "type": 2,
        "origin": 6,
        "destination": 8,
        "name": "Naha Airport SCENARIO-3",
    },
    {
        "index": 3,
        "type": 3,
        "origin": 4,
        "destination": 8,
        "name": "Naha Airport SCENARIO-4",
    },
    {
        "index": 0,
        "type": 1,
        "origin": 0,
        "destination": 6,
        "name": "Sapporo Airport SCENARIO-1",
    },
    {
        "index": 1,
        "type": 2,
        "origin": 2,
        "destination": 0,
        "name": "Sapporo Airport SCENARIO-2",
    },
    {
        "index": 2,
        "type": 2,
        "origin": 6,
        "destination": 0,
        "name": "Sapporo Airport SCENARIO-3",
    },
    {
        "index": 3,
        "type": 2,
        "origin": 2,
        "destination": 0,
        "name": "Sapporo Airport SCENARIO-4",
    },
    {
        "index": 0,
        "type": 2,
        "origin": 2,
        "destination": 1,
        "name": "Komatsu Airport SCENARIO-1",
    },
    {
        "index": 1,
        "type": 2,
        "origin": 2,
        "destination": 1,
        "name": "Komatsu Airport SCENARIO-2",
    },
    {
        "index": 2,
        "type": 2,
        "origin": 8,
        "destination": 1,
        "name": "Komatsu Airport SCENARIO-3",
    },
    {
        "index": 3,
        "type": 2,
        "origin": 8,
        "destination": 1,
        "name": "Komatsu Airport SCENARIO-4",
    },
]

MODE_SCENARIO = 0
MODE_PILOT = 1
MODE_FREE = 2
MODE_LESSON = 3
MODE_OPTION = 4
MODE_PREMIUM = 5

TAXI_SPEED_LIMIT = 8.0 // Actually about 7.72
TAXI_HEIGHT_MIN_LIMIT = -2.0 // Plane should be at height = 0.0 but just in case
TAXI_HEIGHT_MAX_LIMIT = 2.0
TAXI_PITCH_MIN_LIMIT = -2.0 // This should probably be 0.0
TAXI_PITCH_MAX_LIMIT = 2.0

////////////////////////
// GAME VARIABLES     //
////////////////////////

g_plane_speed = float(0x36E770) // doesn't exactly match instruments
g_plane_pitch = float(0x36F334)
g_plane_position = {
    "X": float(0x36F438),
    "Y": float(0x36F430),
    "Z": float(0x36F440),
}
g_relative_plane_altitude = float(0x0036F2F4) // doesn't exactly match instruments

g_scenario_index = byte(0x360012)
g_scenario_type = byte(0x360038)
g_game_mode = byte(0x360179)
g_checkpoints = 0x36EFF0
g_next_checkpoint_index = dword(0x36f1a0)
g_previous_checkpoint_index = dword(0x36f1a8)
g_trip_origin = word(0x36000E)
g_trip_destination = word(0x360018)

////////////////////////
// RICH PRESENCE      //
////////////////////////

// In-Game

CheckpointLookup = {
    0x0: "ACORN",
    0x1: "ADDAN",
    0x2: "AIKOH",
    0x3: "AWAJI",
    0x4: "AKANE",
    0x5: "AKASI",
    0x6: "AMAMI",
    0x7: "ALISA",
    0x8: "ANOXA",
    0x9: "ARITA",
    0xA: "ASAHI",
    0xB: "ASUKA",
    0xC: "ATATA",
    0xD: "AKITA",
    0xE: "AVION",
    0xF: "BAMBO",
    0x10: "BASHO",
    0x11: "BASIN",
    0x12: "BECKY",
    0x13: "BENNY",
    0x14: "BINGO",
    0x15: "BIWWA",
    0x16: "BIZEN",
    0x17: "BOMAP",
    0x18: "BOSOH",
    0x19: "BUDOH",
    0x1A: "CANAL",
    0x1B: "CANDY",
    0x1C: "CANNA",
    0x1D: "CARPS",
    0x1E: "CELLO",
    0x1F: "CHAMP",
    0x20: "CHITOSE",
    0x21: "CHERY",
    0x22: "CLOVE",
    0x23: "OTSU",
    0x24: "DEMPA",
    0x25 : "ZAMA",
    0x26: "DONAN",
    0x27: "DONKY",
    0x28: "EDDIE",
    0x29: "EISAR",
    0x2A: "EMILY",
    0x2B: "EVERT",
    0x2C: "YAIZU",
    0x2D: "FLUTE",
    0x2E: "GOBOH",
    0x2F: "GOBIN",
    0x30: "DAIGO",
    0x31: "GOKYO",
    0x32: "GOYAH",
    0x33: "GRACE",
    0x34: "NIIGATA",
    0x35: "GUJYO",
    0x36: "GUPTI",
    0x37: "GURAR",
    0x38: "HACHA",
    0x39: "HAKBI",
    0x3A: "HAWKS",
    0x3B: "HIKNE",
    0x3C: "HIME",
    0x3D: "HIROS",
    0x3E: "KAGOSHIMA",
    0x3F: "HONDA",
    0x40: "HOTAL",
    0x41: "HANAMAKI",
    0x42: "HIUCHI",
    0x43: "HAKODATE",
    0x44: "HYOGO",
    0x45: "IBURI",
    0x46: "IGOSO",
    0x47: "IKI",
    0x48: "IKOMA",
    0x49: "ISA-U",
    0x4A: "ITIKO",
    0x4B: "KUGA",
    0x4C: "IWAI",
    0x4D: "IZUMI",
    0x4E: "IZUMO",
    0x4F: "JAKAL",
    0x50: "JANET",
    0x51: "JACK",
    0x52: "MIHO",
    0x53: "JONAN",
    0x54: "KAEDE",
    0x55: "KANOH",
    0x56: "KARIN",
    0x57: "NAGOYA",
    0x58: "KUSHIMOTO",
    0x59: "KILLY",
    0x5A: "KINEN",
    0x5B: "KISEI",
    0x5C: "KITAN",
    0x5D: "KOMATSU",
    0x5E: "KING",
    0x5F: "KOITO",
    0x60: "KOSHIKI",
    0x61: "KOTBE",
    0x62: "KOUNO",
    0x63: "KAN'ON",
    0x64: "KOCHI",
    0x65: "KROBE",
    0x66: "KROMA",
    0x67: "KAGAWA",
    0x68: "KITAME-V",
    0x69: "KOHTOH",
    0x6A: "KISARAZU",
    0x6B: "LAKAN",
    0x6C: "LARCH",
    0x6D: "HAMAMATSU",
    0x6E: "LILAC",
    0x6F: "MADOG",
    0x70: "MAIKO",
    0x71: "MAKRA",
    0x72: "MANEP",
    0x73: "MAYAH",
    0x74: "MATSUMOTO",
    0x75: "MEKAX",
    0x76: "MESSE",
    0x77: "MICKY",
    0x78: "MIDOH",
    0x79: "MIKNI",
    0x7A: "MIKRA",
    0x7B: "MINOU",
    0x7C: "MIURA",
    0x7D: "MUKAWA",
    0x7E: "MIKASA",
    0x7F: "MOCOS",
    0x80: "MATSUYAMA",
    0x81: "AOMORI",
    0x82: "MUCRY",
    0x83: "MUGIE",
    0x84: "TOHOKU",
    0x85: "MIYAZAKI",
    0x86: "NAGANUMA",
    0x87: "NAKTU",
    0x88: "NAMMY",
    0x89: "NANSO",
    0x8A: "NASEL",
    0x8B: "NAVER",
    0x8C: "SADO",
    0x8D: "NIIJIMA",
    0x8E: "NYUDO",
    0x8F: "NASU",
    0x90: "OBAKU",
    0x91: "OBITU",
    0x92: "OBOKE",
    0x93: "OCEAN",
    0x94: "OHDAI",
    0x95: "OHMAR",
    0x96: "OHNNO",
    0x97: "ONJUKU",
    0x98: "OKAYAMA",
    0x99: "OKINO",
    0x9A: "OLIVE",
    0x9B: "OMONO",
    0x9C: "ERABU",
    0x9D: "ONDO",
    0x9E: "OTAKI",
    0x9F: "OTOME",
    0xA0: "OWASE",
    0xA1: "OSAKA",
    0xA2: "PANCY",
    0xA3: "PEACH",
    0xA4: "PEONY",
    0xA5: "PERRY",
    0xA6: "POMAS",
    0xA7: "TATEYAMA",
    0xA8: "QUEEN",
    0xA9: "ROKKO",
    0xAA: "RUSAR",
    0xAB: "RYOMA",
    0xAC: "RYUOH",
    0xAD: "SABAN",
    0xAE: "SAEKI",
    0xAF: "SAIJYO",
    0xB0: "SAKAK",
    0xB1: "SAKIT",
    0xB2: "SANDA",
    0xB3: "SAYOH",
    0xB4: "SAZMA",
    0xB5: "SEPIA",
    0xB6: "SAGARA-V",
    0xB7: "SASHIKI",
    0xB8: "SHONO",
    0xB9: "SINJO",
    0xBA: "SIRAO",
    0xBB: "SHINODA",
    0xBC: "MORIYA",
    0xBD: "SOGAR",
    0xBE: "SOUJA",
    0xBF: "SPENS",
    0xC0: "SUSAKI",
    0xC1: "SHODO",
    0xC2: "STORK",
    0xC3: "SHIMIZU",
    0xC4: "SUKMO",
    0xC5: "SUZUKA",
    0xC6: "OITA",
    0xC7: "TAE60",
    0xC8: "TAPOP",
    0xC9: "TAPPI",
    0xCA: "TEKKO",
    0xCB: "TENPA",
    0xCC: "TAKACHIHO",
    0xCD: "CHINEN",
    0xCE: "TANEGASHIMA",
    0xCF: "TOKUNOSHIMA",
    0xD0: "AMI",
    0xD1: "TOBBY",
    0xD2: "TOJYO",
    0xD3: "TOMAS",
    0xD4: "TOTTORI",
    0xD5: "TOKUSHIMA",
    0xD6: "TSURU",
    0xD7: "TOYOTA",
    0xD8: "TURKY",
    0xD9: "TAKAMATSU",
    0xDA: "VIOLA",
    0xDB: "WASYU",
    0xDC: "WESTN",
    0xDD: "OSHIMA",
    0xDE: "KOWA",
    0xDF: "YAMAT",
    0xE0: "YARII",
    0xE1: "YHUKI",
    0xE2: "YUKI",
    0xE3: "MIYAZU",
    0xE4: "YODOH",
    0xE5: "YOKOH",
    0xE6: "SPK01R",
    0xE7: "SPK01L",
    0xE8: "SPK19R",
    0xE9: "SPK19L",
    0xEA: "KMQ06",
    0xEB: "KMQ24",
    0xEC: "HND34R",
    0xED: "HND34L",
    0xEE: "HND16R",
    0xEF: "HND16L",
    0xF0: "HND22",
    0xF1: "HND04",
    0xF2: "NGO34",
    0xF3: "NG016",
    0xF4: "KIX06",
    0xF5: "KIX24",
    0xF6: "ITM32R",
    0xF7: "ITM14R",
    0xF8: "HIJ10",
    0xF9: "HIJ28",
    0xFA: "FUK16",
    0xFB: "FUK34",
    0xFC: "OKA18",
    0xFD: "OKA36",
    0xFE: "SHI17",
    0xFF: "SHI35",
    0x100: "ITM32L",
    0x101: "ITM14L",
    0x102: "ARIKA",
    0x103: "SHINE",
    0x104: "SHIGI",
    0x105: "TOMO",
    0x106: "KYOTO",
    0x107: "KAKOH",
    0x108: "OKINAWA",
    0x109: "OASIS",
    0x10A: "YATSU",
    0x10B: "KASAI",
    0x10C: "DREAM",
    0x10D: "TAURA",
    0x10E: "YOKOSUKA",
    0x10F: "URAGA",
    0x110: "FUKUI",
    0x111: "SAGARA",
    0x112: "NAGRA",
    0x113: "KWANA",
    0x114: "HANDA",
    0x115: "TOZAN",
    0x116: "OMOGO",
    0x117: "KOLTY",
    0x118: "MACKY",
    0x119: "MIYAKOJIMA",
    0x11A: "DIANA",
    0x11B: "IWAMI",
    0x11C: "BASIL",
    0x11D: "BAYOU",
    0x11E: "NARAH",
    0x11F: "JULIA",
    0x120: "LINDA",
    0x121: "KUMEJIMA",
    0x122: "KERAM",
    0x123: "KANSAI",
    0x124: "SAKYU",
    0x125: "WASYU",
    0x126: "BINGO",
    0x127: "BASIL",
    0x128: "KOWA",
    0x129: "KISARAZU",
    0x12A: "HONDA",
    0xFFFFFFFF: "Landing",
}

AirportShortLookup = {
    0x0: "Sapporo",
    0x1: "Komatsu",
    0x2: "Tokyo",
    0x3: "Nagoya",
    0x4: "Osaka",
    0x5: "Hiroshima",
    0x6: "Kansai",
    0x7: "Fukuoka",
    0x8: "Naha",
    0x9: "Shimojishima",
}

AirportLongLookup = {
    0x0: "Sapporo Airport",
    0x1: "Komatsu Airport",
    0x2: "Tokyo International Airport",
    0x3: "Nagoya Airport",
    0x4: "Osaka International Airport",
    0x5: "Hiroshima Airport",
    0x6: "Kansai International Airport",
    0x7: "Fukuoka Airport",
    0x8: "Naha Airport",
    0x9: "Shimojishima Airport",
}

rp_checkpoint_previous = rich_presence_lookup("CHECKPOINT", GetCheckpoint(g_previous_checkpoint_index), CheckpointLookup)
rp_checkpoint_next = rich_presence_lookup("CHECKPOINT", GetCheckpoint(g_next_checkpoint_index), CheckpointLookup)
rp_origin_airport_short = rich_presence_lookup("AIRPORT_SHORT", g_trip_origin, AirportShortLookup)
rp_destination_airport_short = rich_presence_lookup("AIRPORT_SHORT", g_trip_destination, AirportShortLookup)
rp_origin_airport_long = rich_presence_lookup("AIRPORT_LONG", g_trip_origin, AirportLongLookup)
rp_destination_airport_long = rich_presence_lookup("AIRPORT_LONG", g_trip_destination, AirportLongLookup)

// Scenario Mode

// Populate Scenario Hashes
ScenarioLookup = {}
for obj in ScenarioInfo
{
    index = obj["index"]
    type = obj["type"]
    origin = obj["origin"]
    destination = obj["destination"]
    hash = HashScenario(index, type, origin, destination)
    assert(!dictionary_contains_key(ScenarioLookup, hash), "Scenario hash collision")
    ScenarioLookup[hash] = obj["name"]
}

// Now use a lookup for the remaining scenarios
runtime_hash = HashScenario(
    g_scenario_index,
    g_scenario_type,
    g_trip_origin,
    g_trip_destination
)
rp_scenario = rich_presence_lookup("SCENARIO", runtime_hash, ScenarioLookup, "Loading Scenario")
rich_presence_conditional_display(
    InGame() && g_game_mode == MODE_SCENARIO,
    "Scenario Mode | {0} | Current leg: {1} -> {2}",
    rp_scenario,
    rp_checkpoint_previous,
    rp_checkpoint_next
)

// Pilot Mode

// Preparing for takeoff
rich_presence_conditional_display(
    InGame() && g_game_mode == MODE_PILOT && IsPreparingForTakeoff(),
    "Pilot Mode | Flight: {0} -> {1} | Preparing for takeoff from {2}",
    rp_origin_airport_short,
    rp_destination_airport_short,
    rp_origin_airport_long
)

// Taking off
rich_presence_conditional_display(
    InGame() && g_game_mode == MODE_PILOT && IsTakingOff(),
    "Pilot Mode | Flight: {0} -> {1} | Taking off from {2} via runway {3}",
    rp_origin_airport_short,
    rp_destination_airport_short,
    rp_origin_airport_long,
    rp_checkpoint_previous
)

// Landing
rich_presence_conditional_display(
    InGame() && g_game_mode == MODE_PILOT && IsLanding(),
    "Pilot Mode | Flight: {0} -> {1} | Touched down at {2}",
    rp_origin_airport_short,
    rp_destination_airport_short,
    rp_destination_airport_long
)

// Landed
rich_presence_conditional_display(
    InGame() && g_game_mode == MODE_PILOT && IsLanded(),
    "Pilot Mode | Flight: {0} -> {1} | Landed at {2}. Welcome to {3}!",
    rp_origin_airport_short,
    rp_destination_airport_short,
    rp_destination_airport_long,
    rp_destination_airport_short
)

// Flight
rich_presence_conditional_display(
    InGame() && g_game_mode == MODE_PILOT,
    "Pilot Mode | Flight: {0} -> {1} | Current leg: {2} -> {3}",
    rp_origin_airport_short,
    rp_destination_airport_short,
    rp_checkpoint_previous,
    rp_checkpoint_next
)

// Lesson Mode

rich_presence_conditional_display(
    InGame() && g_game_mode == MODE_LESSON,
    "Lesson Mode | Current leg: {0} -> {1}",
    rp_checkpoint_previous,
    rp_checkpoint_next
)

// Menus
rich_presence_display("In menu")

