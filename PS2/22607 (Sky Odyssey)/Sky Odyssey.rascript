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

function TimeToFrames(minutes=0, seconds=0, frames=0)
{
    return minutes * (60 * FRAMES_PER_SECOND) + (seconds * FRAMES_PER_SECOND) + frames
}

function TimeToCentiseconds(minutes=0, seconds=0, frames=0)
{
    return FramesToCentiseconds(TimeToFrames(minutes, seconds, frames))
}

// Game variables

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
    10: "Blow Away",
    11: "The Great Divide",
    12: "The Valley of Fire",
    13: "A Tight Squeeze",
    14: "The Great Falls",
    15: "Maximus",
    16: "Mid-air Rendezvous",
    17: "Stormy Seas",
    18: "A Storm before the Calm",
}
Name2Mission = dict_invert(Missions)
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
PLANE_PULSEJET = 2
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
           g_mission_clear_state[region] != 0 &&
           prev(g_mission_clear_substate[region]) != 0xFF &&
           g_mission_clear_substate[region] == 0xFF
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
    15: [115501, 115513],
    16: [115502, 115503],
    17: [115514, 115504],
    18: [115515, 115505],
}

function LeaderboardSubmit(region, mission)
{
    return IsRegion(region) &&
           g_current_mission[region] == mission &&
           MissionEnd(region)
}

for mission in Missions
{
    assert(dict_in(leaderboard_ids, mission), format("Define mission {0} IDs in leaderboard_ids", mission))
    
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
