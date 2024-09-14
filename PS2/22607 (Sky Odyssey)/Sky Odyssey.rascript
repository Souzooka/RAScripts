// Sky Odyssey
// #ID = 22607

NULL = 0
True = 1
False = 0
NO_ADDR = 0x100000 // always 0x0 when read

RegionByte = byte(0x100000)
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

function list_in(list, val)
{
    return any_of(list, v => v == val)
}

function dict_copy(dict)
{
    copy = {}
    for key in dict
    {
        copy[key] = dict[key]
    }
    
    return copy
}

function dict_in(dict, key)
{
    for k in dict
    {
        if k == key
        {
            return true
        }
    }
    return false
}

function dict_get(dict, key, default=0)
{
    if dict_in(dict, key)
    {
        return dict[key]
    }
    return default
}

function dict_setdefault(dict, key, val)
{
    if dict_in(dict, key)
    {
        return 0
    }
    
    dict[key] = val
}

function dict_invert(dict)
{
    ret = {}
    for key in dict
    {
        ret[dict[key]] = key
    }
    
    return ret
}

function dict_invert_lossless(dict)
{
    ret = {}
    for key in dict
    {
        dict_setdefault(ret, dict[key], [])
        array_push(ret[dict[key]], key)
    }
    
    return ret
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
    if !cond
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

function TimeToFrames(minutes=0, seconds=0, frames=0)
{
    return minutes * (60 * FRAMES_PER_SECOND) + (seconds * FRAMES_PER_SECOND) + frames
}

function TimeToCentiseconds(minutes=0, seconds=0, frames=0)
{
    return FramesToCentiseconds(TimeToFrames(minutes, seconds, frames))
}

// Game variables

MISSION_MAXIMUS = 15
Missions = {
    0: "Towers of Terror",
    1: "Over the Falls",
    2: "S.O.S.",
    3: "Heart of the Mine",
    4: "The Adventure Begins",
    5: "Take the Low Road",
    6: "The Labyrinth",
    7: "The Desert Express",
    8: "Relief from Above",
    9: "The Ancient Forest",
    10: "Blown Away",
    11: "The Great Divide",
    12: "The Valley of Fire",
    13: "A Tight Squeeze",
    14: "The Great Falls",
    MISSION_MAXIMUS: "Maximus",
    16: "Mid-air Rendezvous",
    17: "Stormy Seas",
    18: "A Storm before the Calm",
    19: "A Storm before the Calm",
    20: "A Storm before the Calm",
    21: "Relief from Above",
}
Name2Mission = dict_invert_lossless(Missions)
// NOTE: Use g_adventure_mission for Adventure Mode logic!!
// g_current_mission is fine for other modes; refer to code note for reasoning
g_current_mission = {
    US: dword(0x282EA4),
    EU: dword(NO_ADDR),
    JP: dword(NO_ADDR),
}

g_mission_clear_state = {
    US: dword(0x283A10),
    EU: dword(NO_ADDR),
    JP: dword(NO_ADDR),
}

g_mission_clear_substate = {
    US: dword(0x283A14),
    EU: dword(NO_ADDR),
    JP: dword(NO_ADDR),
}

g_mission_time = {
    US: dword(0x283F00),
    EU: dword(NO_ADDR),
    JP: dword(NO_ADDR),
}

PLANE_BF = 0
PLANE_SWORDFISH =1
PLANE_PULSE_JET = 2
PLANE_SHINDEN = 3
PLANE_SHINDEN_KAI = 4
PLANE_STEALTH_JET = 5
PLANE_ME = 6
PLANE_F4U = 7
PLANE_AUTOGYRO = 8
PLANE_UFO_S = 9
PLANE_UFO_G = 10
g_plane_type = {
    US: dword(0x283F24),
    EU: dword(NO_ADDR),
    JP: dword(NO_ADDR),
}

MODE_ADVENTURE = 0
MODE_TARGET = 1
MODE_SKY_CANVAS = 2
MODE_TRAINING = 3
MODE_FREE_FLIGHT = 4
g_game_mode = {
    US: dword(0x283F7C),
    EU: dword(NO_ADDR),
    JP: dword(NO_ADDR),
}

g_mission_goal_time = {
    US: dword(0x283FFC),
    EU: dword(NO_ADDR),
    JP: dword(NO_ADDR),
}

g_in_game = {
    US: dword(0x28403C),
    EU: dword(NO_ADDR),
    JP: dword(NO_ADDR),
}

g_checkpoint_rings_hit = {
    US: dword(0x284124),
    EU: dword(NO_ADDR),
    JP: dword(NO_ADDR),
}

g_num_checkpoint_rings = {
    US: dword(0x284130),
    EU: dword(NO_ADDR),
    JP: dword(NO_ADDR),
}

RANK_INITIAL = 0
RANK_D = 1
RANK_C = 2
RANK_B = 3
RANK_A = 4
RANK_AP = 5 // A+
g_mission_rank = {
    US: dword(0x284140),
    EU: dword(NO_ADDR),
    JP: dword(NO_ADDR),
}

g_sky_canvas_results_timer = {
    US: dword(0x28421C),
    EU: dword(NO_ADDR),
    JP: dword(NO_ADDR),
}

g_sky_canvas_score = {
    US: float(0x284244),
    EU: float(NO_ADDR),
    JP: float(NO_ADDR),
}

g_adventure_mission = {
    US: dword(0x2D0E88),
    EU: dword(NO_ADDR),
    JP: dword(NO_ADDR),
}

g_mission_score = {
    US: dword(0x2D63E0),
    EU: dword(NO_ADDR),
    JP: dword(NO_ADDR),
}

// Game functions

function InLevel(region)
{
    return g_in_game[region] != 0
}

function MissionEnd(region)
{
    return InLevel(region) &&
           g_game_mode[region] == MODE_ADVENTURE &&
           g_mission_clear_state[region] != 0 &&
           prev(g_mission_clear_substate[region]) != 0xFF &&
           g_mission_clear_substate[region] == 0xFF
}

function CanvasEnd(region)
{
    return InLevel(region) &&
           g_game_mode[region] == MODE_SKY_CANVAS &&
           g_sky_canvas_results_timer[region] > 1 &&
           prev(g_sky_canvas_results_timer[region]) == 1
}

// Achievements

// Sky Canvas
FREE_CANVAS = 10
SkyCanvasStages = {
    0: "Line",
    1: "Triangle",
    2: "Diamond",
    3: "Infinity Symbol",
    4: "Pentagon",
    5: "Heart",
    6: "Watch",
    7: "Chain",
    8: "Face",
    9: "Word",
    FREE_CANVAS: "Free Canvas",
}
SkyCanvasStagesFull = {}
for i in range(0, 9)
{
    n = i + 1
    SkyCanvasStagesFull[i] = format("No. {0}{1}: {2}", if_else(n < 10, "0", ""), n, SkyCanvasStages[i])
}
SkyCanvasStagesFull[FREE_CANVAS] = SkyCanvasStages[FREE_CANVAS]
SkyCanvasStagePrefixes = {3: "an", FREE_CANVAS: "in"}

SkyCanvasParams = [
    {
        "id": 463017,
        "mission": 0,
        "title": "",
        "points": 1,
    },
    {
        "id": 463018,
        "mission": 1,
        "title": "",
        "points": 2,
    },
    {
        "id": 463019,
        "mission": 2,
        "title": "",
        "points": 2,
    },
    {
        "id": 463020,
        "mission": 3,
        "title": "",
        "points": 2,
    },
    {
        "id": 463021,
        "mission": 4,
        "title": "",
        "points": 3,
    },
    {
        "id": 463022,
        "mission": 5,
        "title": "",
        "points": 3,
    },
    {
        "id": 463023,
        "mission": 6,
        "title": "",
        "points": 3,
    },
    {
        "id": 463024,
        "mission": 7,
        "title": "",
        "points": 3,
    },
    {
        "id": 463025,
        "mission": 8,
        "title": "",
        "points": 4,
    },
    {
        "id": 463026,
        "mission": 9,
        "title": "",
        "points": 5,
    },
]

for params in SkyCanvasParams
{
    id = params["id"]
    mission = params["mission"]
    title = if_else(params["title"] == "", format("Sky Canvas - {0}", SkyCanvasStages[mission]), params["title"])
    points = params["points"]
    
    achievement(
        id=id,
        title=title,
        description=format("In Sky Canvas, complete {0} with a score of 90 or higher.", SkyCanvasStagesFull[mission]),
        points=points,
        trigger=any_of(Regions, region =>
            IsRegion(region) &&
            CanvasEnd(region) &&
            g_current_mission[region] == mission &&
            g_sky_canvas_score[region] >= 90.0
        )
    )
}

// Adventure leaderboards

leaderboard_ids = {
    0: [115478, 115479],
    1: [115480, 115481],
    2: [115482, 115483],
    3: [115484, 115485],
    4: [115486, 115487],
    5: [115488, 115489],
    6: [115490, 115491],
    7: [115492, 115493],
    8: [115506, 115494],
    9: [115507, 115495],
    10: [115496, 115508],
    11: [115497, 115509],
    12: [115498, 115510],
    13: [115499, 115511],
    14: [115500, 115512],
    //15: [115501, 115513],
    16: [115502, 115503],
    17: [115514, 115504],
    18: [115515, 115505],
}

function LeaderboardSubmit(region, mission)
{
    correct_mission = __ornext(
        list_in(Name2Mission[Missions[mission]], g_adventure_mission[region])
    )
    
    if any_of(["The Great Divide", "The Valley of Fire", "A Tight Squeeze"], name => list_in(Name2Mission[name], mission))
    {
        // Don't count final mission leaderboards if the player retried in the final segment, which would mean only 10 checkpoint rings are tracked
        correct_mission = correct_mission && g_num_checkpoint_rings[region] != 10
    }

    return IsRegion(region) &&
           correct_mission &&
           MissionEnd(region)
}

for mission in leaderboard_ids
{   
    // Point Attack
    leaderboard(
        id=leaderboard_ids[mission][0],
        title=format("{0} - Point Attack", Missions[mission]),
        description=format("Complete \"{0}\" under the goal time with the highest score!", Missions[mission]),
        format="VALUE",
        start=any_of(Regions, region => 
            LeaderboardSubmit(region, mission) &&
            g_mission_time[region] < g_mission_goal_time[region]
        ),
        cancel=always_false(),
        submit=always_true(),
        value=max_of(array_map(Regions, region => measured(g_mission_score[region], when=IsRegion(region))))
    )
    
    // Time Attack
    leaderboard(
        id=leaderboard_ids[mission][1],
        title=format("{0} - Time Attack", Missions[mission]),
        description=format("Complete \"{0}\" with the fastest time while collecting every checkpoint ring!", Missions[mission]),
        format="FRAMES",
        lower_is_better=true,
        start=any_of(Regions, region => 
            LeaderboardSubmit(region, mission) &&
            g_checkpoint_rings_hit[region] == g_num_checkpoint_rings[region]
        ),
        cancel=always_false(),
        submit=always_true(),
        value=max_of(array_map(Regions, region => measured(g_mission_time[region], when=IsRegion(region))))
    )
}

// Rich Presence

rp_region_lookup = {
    US: "ᵘˢ",
    EU: "ᵉᵘ",
    JP: "ʲᵖ",
}
rp_mission_lookup = dict_copy(Missions)
rp_canvas_lookup = dict_copy(SkyCanvasStages)
rp_canvas_prefix_lookup = dict_copy(SkyCanvasStagePrefixes)
rp_plane_lookup = {
    PLANE_BF: "🛩️ BF-109 Custom",
    PLANE_SWORDFISH: "🛩️ Swordfish Mk.1 Custom",
    PLANE_PULSE_JET: "🛩️ Pulse Jet \"Test Type\"",
    PLANE_SHINDEN: "🛩️ Shinden",
    PLANE_SHINDEN_KAI: "🛩️ Shinden-Kai",
    PLANE_STEALTH_JET: "🛩️ Stealth Jet",
    PLANE_ME: "🛩️ Me-262",
    PLANE_F4U: "🛩️ F4U Corsair",
    PLANE_AUTOGYRO: "🚁️ Autogyro XG-1",
    PLANE_UFO_S: "🛸 UFO \"Type Silver\"",
    PLANE_UFO_G: "🛸️ UFO \"Type Gold\"",
}

for region in Regions
{
    rp_region = rich_presence_lookup("REGION", region, rp_region_lookup)
    rp_mission_prefix = rich_presence_lookup("MISSION_PREFIX", g_current_mission[region], {MISSION_MAXIMUS: "Maximus (via "}, "")
    rp_mission = rich_presence_lookup("MISSION", g_adventure_mission[region], rp_mission_lookup, "Unknown Mission")
    rp_mission_suffix = rich_presence_lookup("MISSION_SUFFIX", g_current_mission[region], {MISSION_MAXIMUS: ")"}, "")
    rp_plane = rich_presence_lookup("PLANE", g_plane_type[region], rp_plane_lookup, "Unknown Plane")
    rp_canvas = rich_presence_lookup("CANVAS", g_current_mission[region], rp_canvas_lookup, "Unknown Shape")
    rp_canvas_prefix = rich_presence_lookup("CANVAS_PREFIX", g_current_mission[region], rp_canvas_prefix_lookup, "a")
    
    // Adventure Mode
    rich_presence_conditional_display(
        IsRegion(region) && g_game_mode[region] == MODE_ADVENTURE && InLevel(region),
        "{0} Adventure Mode | {1}{2}{3} | {4}",
        rp_region,
        rp_mission_prefix,
        rp_mission,
        rp_mission_suffix,
        rp_plane
    )
    // Sky Canvas Mode
    rich_presence_conditional_display(
        IsRegion(region) && g_game_mode[region] == MODE_SKY_CANVAS && InLevel(region),
        "{0} Sky Canvas Mode | Drawing {1} {2} | {3}",
        rp_region,
        rp_canvas_prefix,
        rp_canvas,
        rp_plane
    )
}

rich_presence_display("Playing Sky Odyssey")
