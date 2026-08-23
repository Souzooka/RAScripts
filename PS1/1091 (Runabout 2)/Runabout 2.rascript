// Runabout 2
// #ID = 1091

GAME_FRAMERATE = 30.0
IGT_FRAMERATE = 300.0
LB_FRAMERATE = 60.0

function if_else(cond, a, b)
{
    if cond
        return a
    return b
}

function AntiBios()
{
    return ascii_string_equals(0x101e9, "RUN2")
}

function InGame()
{
    // Tentative, also is true for the demo mode
    return g_overlay_id == OVERLAY_GAME_IN
}

function LevelComplete(level_id)
{
    acc = bit4(0x905ff)
    cond = always_true()
    
    // Mission #13 is cut into two halves, and we actually want to
    // consider only the second half
    if level_id == FINAL_LEVEL
    {
        level_id = FINAL_LEVEL + 1
        cond = cond && g_cutscene_id == 0x15
    }

    return
        cond &&
        g_current_level == level_id &&
        acc > prev(acc)
}

function IGT2Centisecs()
{
    ticks = g_total_time - g_total_time_interp
    frames = ticks / (IGT_FRAMERATE / LB_FRAMERATE)
    centis = frames * (100.0 / LB_FRAMERATE)

    return centis
}

function LevelID2DisplayID(level_id)
{
    return format("#{0}{1}", if_else(level_id + 1 >= 10, "", "0"), level_id + 1)
}

FINAL_LEVEL = 12

g_current_level = byte(0x42518)

g_game_mode = byte(0x42526)
GAME_MODE_RUNABOUT = 0x0

g_total_amount = dword(0x86a80)

g_total_time = dword(0x8f5bc)
g_total_time_interp = dword(0x11C858)

g_cutscene_id = dword(0x8F5C4)

g_overlay_id = dword(0x9bf50)
OVERLAY_GAME_IN = 0x4
OVERLAY_GAME_OUT = 0x5

LEVEL_PARAMS = [
    {
        "level_id": 0,
        "lb_id": 170095,
        "lb_id_pacifist": 170118,
    },
    {
        "level_id": 1,
        "lb_id": 170119,
        "lb_id_pacifist": 170120,
    },
    {
        "level_id": 2,
        "lb_id": 170121,
        "lb_id_pacifist": 170122,
    },
    {
        "level_id": 3,
        "lb_id": 170123,
        "lb_id_pacifist": 170124,
    },
    {
        "level_id": 4,
        "lb_id": 170125,
        "lb_id_pacifist": 170126,
    },
    {
        "level_id": 5,
        "lb_id": 170127,
        "lb_id_pacifist": 170128,
    },
    {
        "level_id": 6,
        "lb_id": 170129,
        "lb_id_pacifist": 170130,
    },
    {
        "level_id": 7,
        "lb_id": 170131,
        "lb_id_pacifist": 170132,
    },
    {
        "level_id": 8,
        "lb_id": 170133,
        "lb_id_pacifist": 170134,
    },
    {
        "level_id": 9,
        "lb_id": 170135,
        "lb_id_pacifist": 170136,
    },
    {
        "level_id": 10,
        "lb_id": 170137,
        "lb_id_pacifist": 170138,
    },
    {
        "level_id": 11,
        "lb_id": 170139,
        "lb_id_pacifist": 170140,
    },
    {
        "level_id": 12,
        "lb_id": 170141,
        "lb_id_pacifist": 170142,
    },
]

for params in LEVEL_PARAMS
{
    leaderboard(
        id=params["lb_id"],
        title=format("Mission {0} - Fastest Time", LevelID2DisplayID(params["level_id"])),
        description=
            format(
                "Complete Mission {0}{1} in the fastest time!", 
                LevelID2DisplayID(params["level_id"]),
                if_else(params["level_id"] == FINAL_LEVEL, " and escape with Lisa", "")
            ),
        format="CENTISECS",
        lower_is_better=true,
        start=
            AntiBios() &&
            InGame() &&
            LevelComplete(params["level_id"]),
        cancel=always_false(),
        submit=always_true(),
        value=IGT2Centisecs()
    )
    
     leaderboard(
        id=params["lb_id_pacifist"],
        title=format("Mission {0} - Fastest Time (Pacifist)", LevelID2DisplayID(params["level_id"])),
        description=
            format(
                "Complete Mission {0}{1} in the fastest time with $0 in damages!", 
                LevelID2DisplayID(params["level_id"]),
                if_else(params["level_id"] == FINAL_LEVEL, " and escape with Lisa", "")
            ),
        format="CENTISECS",
        lower_is_better=true,
        start=
            AntiBios() &&
            InGame() &&
            g_game_mode == GAME_MODE_RUNABOUT &&
            g_total_amount == 0 &&
            LevelComplete(params["level_id"]),
        cancel=always_false(),
        submit=always_true(),
        value=IGT2Centisecs()
    )
}