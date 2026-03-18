// Trigger Man
// #ID = 26968

NULL = 0

function IsRegion(region)
{
    return true
}

function if_else(cond, v1, v2)
{
    if cond == true
        return v1
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
            val = accessor(addr)
        else
            val = dword(addr)
    }
    
    return val
}

function AntiCheat()
{
    // there's 8 but only the first 2 can be edited without a cheat device
    NUM_CHEATS = 2
    return all_of(array_map(range(0, NUM_CHEATS-1), i => bit0(0x25181c + i * 0x20)), cheat => cheat == 0)
}

function MissionComplete(mission)
{
    return
        AntiCheat() &&
        level_id == mission &&
        prev(g_mission_complete) == 1 &&
        g_mission_complete == 0
}

function Human(addr)
{
    obj = {
        "m_health_max": float(addr + 0x34),
        "m_health": float(addr + 0x3C),
    }
    
    return obj
}

g_scene_id = dword(0x277940)
g_next_scene_id = dword(0x277944)
level_id = g_scene_id / 100
next_level_id = g_next_scene_id / 100
p_player = dword(0x277ea8)
g_player = Human(p_player)
g_mission_complete = dword(0x27795c)

g_difficulty = ptr(dword(0x2786c4), [0x4], dword)
DIFFICULTY_NORMAL = 1
DIFFICULTY_DEADLY = 2

MISSION_PARAMS = [
    {
        "mission": 1,
        "normal_id": 0,
        "hard_id": 0,
        "normal_title": "Mission 1",
        "hard_title": "Mission 1 - Deadly",
        "type": "progression",
        "normal_points": 5,
        "hard_points": 5,
    },
    {
        "mission": 2,
        "normal_id": 0,
        "hard_id": 0,
        "normal_title": "Mission 2",
        "hard_title": "Mission 2 - Deadly",
        "type": "progression",
        "normal_points": 5,
        "hard_points": 5,
    },
    {
        "mission": 3,
        "normal_id": 0,
        "hard_id": 0,
        "normal_title": "Mission 3",
        "hard_title": "Mission 3 - Deadly",
        "type": "progression",
        "normal_points": 5,
        "hard_points": 5,
    },
    {
        "mission": 4,
        "normal_id": 0,
        "hard_id": 0,
        "normal_title": "Mission 4",
        "hard_title": "Mission 4 - Deadly",
        "type": "progression",
        "normal_points": 5,
        "hard_points": 5,
    },
    {
        "mission": 5,
        "normal_id": 0,
        "hard_id": 0,
        "normal_title": "Mission 5",
        "hard_title": "Mission 5 - Deadly",
        "type": "progression",
        "normal_points": 5,
        "hard_points": 5,
    },
    {
        "mission": 6,
        "normal_id": 0,
        "hard_id": 0,
        "normal_title": "Mission 6",
        "hard_title": "Mission 6 - Deadly",
        "type": "progression",
        "normal_points": 5,
        "hard_points": 5,
    },
    {
        "mission": 7,
        "normal_id": 0,
        "hard_id": 0,
        "normal_title": "Mission 7",
        "hard_title": "Mission 7 - Deadly",
        "type": "progression",
        "normal_points": 5,
        "hard_points": 5,
    },
    {
        "mission": 8,
        "normal_id": 0,
        "hard_id": 0,
        "normal_title": "Mission 8",
        "hard_title": "Mission 8 - Deadly",
        "type": "progression",
        "normal_points": 5,
        "hard_points": 5,
    },
    {
        "mission": 9,
        "normal_id": 0,
        "hard_id": 0,
        "normal_title": "Mission 9",
        "hard_title": "Mission 9 - Deadly",
        "type": "win_condition",
        "normal_points": 5,
        "hard_points": 5,
    },
]

for params in MISSION_PARAMS
{
    achievement(
        id=params["normal_id"],
        title=params["normal_title"],
        description=format("Complete mission {0}.", params["mission"]),
        type=params["type"],
        points=params["normal_points"],
        trigger=
            MissionComplete(params["mission"])
    )
}
for params in MISSION_PARAMS
{
    achievement(
        id=params["hard_id"],
        title=params["hard_title"],
        description=format("Complete mission {0} on Deadly.", params["mission"]),
        points=params["hard_points"],
        trigger=
            MissionComplete(params["mission"]) &&
            g_difficulty == DIFFICULTY_DEADLY
    )
}

rp_difficulty_lookup = {
    DIFFICULTY_NORMAL: "Normal",
    DIFFICULTY_DEADLY: "Deadly",
}

rich_presence_conditional_display(
    next_level_id > 0 && p_player != NULL,
    "In mission {0} | {1} | {2}% health",
    rich_presence_value("VALUE", next_level_id),
    rich_presence_lookup("DIFFICULTY", g_difficulty, rp_difficulty_lookup),
    rich_presence_value("VALUE", 100 * (g_player["m_health"] / g_player["m_health_max"]))
)
rich_presence_display("In main menu")
