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

MISSION_TOWERS = 0
MISSION_FALLS = 1
MISSION_SOS = 2
MISSION_MINE = 3
MISSION_BEGIN = 4
MISSION_LOW_ROAD = 5
MISSION_LABYRINTH = 6
MISSION_DESERT_EXPRESS = 7
MISSION_RELIEF = 8
MISSION_FOREST = 9
MISSION_BLOWN = 10
MISSION_GREAT_DIVIDE = 11
MISSION_FIRE_VALLEY = 12
MISSION_TIGHT_SQUEEZE = 13
MISSION_GREAT_FALLS = 14
MISSION_MAXIMUS = 15
MISSION_RENDEZVOUS = 16
MISSION_SEAS = 17
MISSION_STORM = 18
Missions = {
    MISSION_TOWERS: "Towers of Terror",
    MISSION_FALLS: "Over the Falls",
    MISSION_SOS: "S.O.S.",
    MISSION_MINE: "Heart of the Mine",
    MISSION_BEGIN: "The Adventure Begins",
    MISSION_LOW_ROAD: "Take the Low Road",
    MISSION_LABYRINTH: "The Labyrinth",
    MISSION_DESERT_EXPRESS: "The Desert Express",
    MISSION_RELIEF: "Relief from Above",
    MISSION_FOREST: "The Ancient Forest",
    MISSION_BLOWN: "Blown Away",
    MISSION_GREAT_DIVIDE: "The Great Divide",
    MISSION_FIRE_VALLEY: "The Valley of Fire",
    MISSION_TIGHT_SQUEEZE: "A Tight Squeeze",
    MISSION_GREAT_FALLS: "The Great Falls",
    MISSION_MAXIMUS: "Maximus",
    MISSION_RENDEZVOUS: "Mid-air Rendezvous",
    MISSION_SEAS: "Stormy Seas",
    MISSION_STORM: "A Storm before the Calm",
    19: "A Storm before the Calm",
    20: "A Storm before the Calm",
    21: "Relief from Above",
}
Name2Mission = dict_invert_lossless(Missions)
FinalMissions = [MISSION_GREAT_FALLS, MISSION_FIRE_VALLEY, MISSION_TIGHT_SQUEEZE]
OptionalMissions = [MISSION_MINE, MISSION_SOS, MISSION_RELIEF]
// NOTE: Use g_adventure_mission for Adventure Mode logic!!
// g_current_mission is fine for other modes; refer to code note for reasoning
g_current_mission = {
    US: dword(0x282EA4),
    EU: dword(NO_ADDR),
    JP: dword(NO_ADDR),
}

g_rank_circle = {
    US: dword(0x283360),
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

TARGET_FINAL_STAGE = 8
g_target_times = {
    US: array_map(range(0, TARGET_FINAL_STAGE), i => dword(0x383990 + i * 8)),
    EU: array_map(range(0, TARGET_FINAL_STAGE), i => dword(NO_ADDR + i * 8)),
    JP: array_map(range(0, TARGET_FINAL_STAGE), i => dword(NO_ADDR + i * 8)),  
}
g_target_scores = {
    US: array_map(range(0, TARGET_FINAL_STAGE), i => float(0x383AB0 + i * 4)),
    EU: array_map(range(0, TARGET_FINAL_STAGE), i => float(NO_ADDR + i * 4)),
    JP: array_map(range(0, TARGET_FINAL_STAGE), i => float(NO_ADDR + i * 4)),
}
g_target_airstrip = {
    US: dword(0x551600),
    EU: dword(NO_ADDR),
    JP: dword(NO_ADDR),
}
g_target_time = {
    US: dword(0x551604),
    EU: dword(NO_ADDR),
    JP: dword(NO_ADDR),
}


// Game functions

function InLevel(region)
{
    return g_in_game[region] != 0
}

function IsMission(region, mission, allow_checkpoint=true)
{
    correct_mission = __ornext(
        list_in(Name2Mission[Missions[mission]], g_adventure_mission[region])
    )
    
    if !allow_checkpoint && any_of(FinalMissions, m => m == mission)
    {
        // Don't count final mission leaderboards if the player retried in the final segment, which would mean only 10 checkpoint rings are tracked
        correct_mission = correct_mission && g_num_checkpoint_rings[region] != 10
    }
    
    return correct_mission
}

function MissionEnd(region)
{
    return InLevel(region) &&
           g_game_mode[region] == MODE_ADVENTURE &&
           g_mission_clear_state[region] != 0 &&
           prev(g_mission_clear_substate[region]) != 0xFF &&
           g_mission_clear_substate[region] == 0xFF
}

function TargetEnd(region)
{
    return g_game_mode[region] == MODE_TARGET &&
           g_target_airstrip[region] != 0xFFFFFFFF &&
           prev(g_target_scores[region][0]) != 0.0 &&
           g_target_scores[region][0] == 0.0
}

function CanvasEnd(region)
{
    return InLevel(region) &&
           g_game_mode[region] == MODE_SKY_CANVAS &&
           g_sky_canvas_results_timer[region] > 1 &&
           prev(g_sky_canvas_results_timer[region]) == 1
}

// Achievements

// Adventure

AdventureClearParams = {
    MISSION_TOWERS: {
        "id": 463369,
        "title": "",
        "points": 5,
    },
    MISSION_FALLS: {
        "id": 463370,
        "title": "",
        "points": 10,
    },
    MISSION_SOS: {
        "id": 463371,
        "title": "",
        "points": 5,
    },
    MISSION_MINE: {
        "id": 463372,
        "title": "",
        "points": 5,
    },
    MISSION_BEGIN: {
        "id": 463373,
        "title": "",
        "points": 5,
    },
    MISSION_LOW_ROAD: {
        "id": 463374,
        "title": "",
        "points": 5,
    },
    MISSION_LABYRINTH: {
        "id": 463375,
        "title": "",
        "points": 5,
    },
    MISSION_DESERT_EXPRESS: {
        "id": 463376,
        "title": "",
        "points": 5,
    },
    MISSION_RELIEF: {
        "id": 463377,
        "title": "",
        "points": 5,
    },
    MISSION_FOREST: {
        "id": 463378,
        "title": "",
        "points": 5,
    },
    MISSION_BLOWN: {
        "id": 463379,
        "title": "",
        "points": 5,
    },
    MISSION_GREAT_DIVIDE: {
        "id": 463380,
        "title": "",
        "points": 5,
    },
    MISSION_FIRE_VALLEY: {
        "id": 463381,
        "title": "",
        "points": 10,
    },
    MISSION_TIGHT_SQUEEZE: {
        "id": 463382,
        "title": "",
        "points": 10,
    },
    MISSION_GREAT_FALLS: {
        "id": 463383,
        "title": "",
        "points": 10,
    },
    MISSION_RENDEZVOUS: {
        "id": 463384,
        "title": "",
        "points": 5,
    },
    MISSION_SEAS: {
        "id": 463395,
        "title": "",
        "points": 5,
    },
    MISSION_STORM: {
        "id": 463385,
        "title": "",
        "points": 5,
    },
}

AdventurePerfectParams = {
    MISSION_TOWERS: {
        "id": 463396,
        "title": "",
        "points": 10,
    },
    MISSION_FALLS: {
        "id": 463386,
        "title": "",
        "points": 10,
    },
    MISSION_SOS: {
        "id": 463397,
        "title": "",
        "points": 10,
    },
    MISSION_MINE: {
        "id": 463387,
        "title": "",
        "points": 10,
    },
    MISSION_BEGIN: {
        "id": 463398,
        "title": "",
        "points": 10,
    },
    MISSION_LOW_ROAD: {
        "id": 463399,
        "title": "",
        "points": 10,
    },
    MISSION_LABYRINTH: {
        "id": 463388,
        "title": "",
        "points": 10,
    },
    MISSION_DESERT_EXPRESS: {
        "id": 463389,
        "title": "",
        "points": 10,
    },
    MISSION_RELIEF: {
        "id": 463400,
        "title": "",
        "points": 10,
    },
    MISSION_FOREST: {
        "id": 463390,
        "title": "",
        "points": 10,
    },
    MISSION_BLOWN: {
        "id": 463401,
        "title": "",
        "points": 10,
    },
    MISSION_GREAT_DIVIDE: {
        "id": 463391,
        "title": "",
        "points": 10,
    },
    MISSION_FIRE_VALLEY: {
        "id": 463402,
        "title": "",
        "points": 25,
    },
    MISSION_TIGHT_SQUEEZE: {
        "id": 463392,
        "title": "",
        "points": 25,
    },
    MISSION_GREAT_FALLS: {
        "id": 463403,
        "title": "",
        "points": 25,
    },
    MISSION_RENDEZVOUS: {
        "id": 463393,
        "title": "",
        "points": 10,
    },
    MISSION_SEAS: {
        "id": 463404,
        "title": "",
        "points": 10,
    },
    MISSION_STORM: {
        "id": 463394,
        "title": "",
        "points": 10,
    },
}

for mission in AdventureClearParams
{
    params = AdventureClearParams[mission]
    
    id = params["id"]
    title = if_else(params["title"] == "", format("Adventure Mode - {0}", Missions[mission]), params["title"])
    description = format("In Adventure Mode, complete the mission \"{0}.\"", Missions[mission])
    points = params["points"]
    type = if_else(list_in(OptionalMissions, mission), "missable", "progression")
    type = if_else(list_in(FinalMissions, mission), "win_condition", type)
    
    achievement(
        id=id,
        title=title,
        description=description,
        points=points,
        type=type,
        trigger=any_of(Regions, region =>
            IsRegion(region) &&
            IsMission(region, mission, allow_checkpoint=true) &&
            MissionEnd(region)
        )
    )
}

for mission in AdventurePerfectParams
{
    params = AdventurePerfectParams[mission]
    
    id = params["id"]
    title = if_else(params["title"] == "", format("Adventure Mode - {0} - Perfect", Missions[mission]), params["title"])
    description = format(
        "In Adventure Mode, complete the mission \"{0}\" and achieve a circled A+ rank.{1}{2}",
        Missions[mission],
        if_else(mission == MISSION_BEGIN, " This can be achieved by scoring 25,000 points within the goal time, with at least 5,000 acrobatic points.", ""),
        if_else(list_in(FinalMissions, mission), " This achievement is voided if the attempt is retried after reaching Maximus.", "")
    )
    points = params["points"]
    
    achievement(
        id=id,
        title=title,
        description=description,
        points=points,
        trigger=any_of(Regions, region =>
            IsRegion(region) &&
            IsMission(region, mission, allow_checkpoint=false) &&
            MissionEnd(region) &&
            g_mission_rank[region] == RANK_AP &&
            g_rank_circle[region] != 0
        )
    )
}

// TODO: Shinden(-Kai)

// Target Mode
// Not too much to do here
achievement(
    id=559678,
    title="Target Mode - A+",
    description="Complete Target Mode and achieve a final grade of A+ by attaining an average technical score of 80% or better.",
    points=10,
    trigger=any_of(Regions, region =>
        IsRegion(region) &&
        TargetEnd(region) &&
        sum_of(g_target_scores[region], prev) >= (80.0 * 5)
    )
)

// NOTE: Beat Target Mode <= 10min for Stealth Jet (US)
// 11min for EU...
// 15min for JP...
achievement(
    id=559679,
    title="Target Mode - Quick",
    description="Complete Target Mode with a total time of 10 minutes or less.",
    points=10,
    trigger=any_of(Regions, region =>
        IsRegion(region) &&
        TargetEnd(region) &&
        sum_of(g_target_times[region], prev) <= 36000
    )
)

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
    MISSION_TOWERS: [115478, 115479],
    MISSION_FALLS: [115480, 115481],
    MISSION_SOS: [115482, 115483],
    MISSION_MINE: [115484, 115485],
    MISSION_BEGIN: [115486, 115487],
    MISSION_LOW_ROAD: [115488, 115489],
    MISSION_LABYRINTH: [115490, 115491],
    MISSION_DESERT_EXPRESS: [115492, 115493],
    MISSION_RELIEF: [115506, 115494],
    MISSION_FOREST: [115507, 115495],
    MISSION_BLOWN: [115496, 115508],
    MISSION_GREAT_DIVIDE: [115497, 115509],
    MISSION_FIRE_VALLEY: [115498, 115510],
    MISSION_TIGHT_SQUEEZE: [115499, 115511],
    MISSION_GREAT_FALLS: [115500, 115512],
    //MISSION_MAXIMUS: [115501, 115513],
    MISSION_RENDEZVOUS: [115502, 115503],
    MISSION_SEAS: [115514, 115504],
    MISSION_STORM: [115515, 115505],
}

function LeaderboardSubmit(region, mission)
{
    return IsRegion(region) &&
           IsMission(region, mission, allow_checkpoint=false) &&
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

// Target Mode
values = []
for region in Regions
{
    array_push(values, 
        measured(
            sum_of(g_target_times[region], prev), 
            when=IsRegion(region) && g_target_airstrip[region] != 0xFFFFFFFF)
    )
    array_push(values,
        measured(
            sum_of(g_target_times[region], v => v) + g_target_time[region],
            when=IsRegion(region) && g_target_airstrip[region] == 0xFFFFFFFF
        )
    )
}
//leaderboard(
//    id=0,
//    title="Target Mode - Time Attack",
//    description="Complete Target Mode in the fastest time!",
//    format="FRAMES",
//    lower_is_better=true,
//    start=any_of(Regions, region =>
//        IsRegion(region) &&
//        g_game_mode[region] == MODE_TARGET &&
//        g_current_mission[region] == 0 &&
//        g_target_times[region][0] == 0.0 &&
//        !prev(InLevel(region)) &&
//        InLevel(region)
//    ),
//    cancel=any_of(Regions, region =>
//        IsRegion(region) &&
//        g_target_times[region][0] == 0.0 &&
//        !InLevel(region) &&
//        g_current_mission[region] != TARGET_FINAL_STAGE &&
//        g_target_airstrip[region] == 0xFFFFFFFF
//    ),
//    submit=any_of(Regions, region =>
//        IsRegion(region) &&
//        TargetEnd(region)
//    ),
//    value=max_of(values)
//)

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
    // Target Mode
    rich_presence_conditional_display(
        IsRegion(region) && g_game_mode[region] == MODE_TARGET && InLevel(region),
        "{0} Target Mode | {1}",
        rp_region,
        rp_plane
    )
}

rich_presence_display("Playing Sky Odyssey")

