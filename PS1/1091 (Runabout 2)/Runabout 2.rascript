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

function dict_in(dict, key)
{
    return any_of(dict, k => k == key)
}

function dict_get(dict, key, default=0)
{
    if dict_in(dict, key)
        return dict[key]
    return default
}

function format_number(n)
{   
    billions = n / 1000000000
    millions = n % 1000000000 / 1000000
    thousands = n % 1000000 / 1000
    ones = n % 1000
    
    COMMA = ","

    return format(
        "{0}{1}{2}{3}{4}{5}{6}{7}{8}{9}{10}{11}{12}",
        if_else(billions > 0, billions, ""),
        if_else(billions > 0, COMMA, ""),
        if_else(billions > 0 && millions < 100, "0", ""),
        if_else(billions > 0 && millions < 10, "0", ""),
        if_else(billions > 0 || millions > 0, millions, ""),
        if_else(billions > 0 || millions > 0, COMMA, ""),
        if_else((billions > 0 || millions > 0) && thousands < 100, "0", ""),
        if_else((billions > 0 || millions > 0) && thousands < 10, "0", ""),
        if_else(billions > 0 || millions > 0 || thousands > 0, thousands, ""),
        if_else(billions > 0 || millions > 0 || thousands > 0, COMMA, ""),
        if_else((billions > 0 || millions > 0 || thousands > 0) && ones < 100, "0", ""),
        if_else((billions > 0 || millions > 0 || thousands > 0) && ones < 10, "0", ""),
        ones
    )
}

function format_ticks(ticks)
{
    centisecs = (ticks / 3) % 100
    secs = (ticks / 300) % 60
    mins = (ticks / (300 * 60))
    
    return format(
        "{0}{1}:{2}{3}.{4}{5}",
        if_else(mins < 10, "0", ""),
        mins,
        if_else(secs < 10, "0", ""),
        secs,
        if_else(centisecs < 10, "0", ""),
        centisecs
    )
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

function GetIGT()
{
    return g_total_time - g_total_time_interp
}

function IGT2Centisecs(ticks)
{
    frames = ticks / (IGT_FRAMERATE / LB_FRAMERATE)
    centis = frames * (100.0 / LB_FRAMERATE)

    return centis
}

function Time2Ticks(minutes=0, seconds=0, centiseconds=0)
{
    centiseconds = centiseconds + (seconds * 100)
    centiseconds = centiseconds + (minutes * 6000)
    return centiseconds * 3
}

function LevelID2DisplayID(level_id)
{
    if level_id == FINAL_LEVEL + 1 || level_id == FINAL_LEVEL + 2
        return "Mission #13α"
    if level_id == LEVEL_SHORT_TEST_COURSE
        return "Test Course (Short)"
    if level_id == LEVEL_LONG_TEST_COURSE
        return "Test Course (Long)"

    return format("Mission #{0}{1}", if_else(level_id + 1 >= 10, "", "0"), level_id + 1)
}

g_current_level = byte(0x42518)
FINAL_LEVEL = 12
OPTIONAL_LEVELS = [3, 4, 5, 6, 10]
LEVEL_SHORT_TEST_COURSE = 15
LEVEL_LONG_TEST_COURSE = 16

g_game_mode = byte(0x42526)
GAME_MODE_RUNABOUT = 0x0
GAME_MODE_ROUTE_CHECK = 0x1
GAME_MODE_TEST_RUN = 0x2
GAME_MODE_TIME_TRIAL = 0x3

g_total_amount = dword(0x86a80)

g_total_time = dword(0x8f5bc)
g_total_time_interp = dword(0x11C858)

g_cutscene_id = dword(0x8F5C4)

g_overlay_id = dword(0x9bf50)
OVERLAY_GAME_IN = 0x4
OVERLAY_GAME_OUT = 0x5

g_car_index = byte(0x8f5c0)
g_car_ids = 0x4251c
g_current_car_id = byte(g_car_ids + g_car_index)
g_transmissions = 0x8f490
g_current_transmission = byte(g_transmissions + g_car_index)

g_last_lap_time = dword(0x13c97c)
g_lap_counter = word(0x13c984)

LEVEL_PARAMS = [
    {
        "level_id": 0,
        "ach_id_progression": 0,
        "ach_id_pacifist": 0,
        "ach_id_damage": 0,
        "ach_id_time_trial": 0,
        "ach_points_progression": 5,
        "ach_points_pacifist": 5,
        "ach_points_damage": 5,
        "ach_points_time_trial": 5,
        "ach_damage_amount": 600000,
        "ach_time_trial_time": Time2Ticks(minutes=1, seconds=4),
        "lb_id": 170095,
        "lb_id_pacifist": 170118,
    },
    {
        "level_id": 1,
        "ach_id_progression": 0,
        "ach_id_pacifist": 0,
        "ach_points_progression": 5,
        "ach_points_pacifist": 5,
        "lb_id": 170119,
        "lb_id_pacifist": 170120,
    },
    {
        "level_id": 2,
        "ach_id_progression": 0,
        "ach_id_pacifist": 0,
        "ach_points_progression": 5,
        "ach_points_pacifist": 5,
        "lb_id": 170121,
        "lb_id_pacifist": 170122,
    },
    {
        "level_id": 3,
        "ach_id_progression": 0,
        "ach_id_pacifist": 0,
        "ach_points_progression": 5,
        "ach_points_pacifist": 5,
        "lb_id": 170123,
        "lb_id_pacifist": 170124,
    },
    {
        "level_id": 4,
        "ach_id_progression": 0,
        "ach_id_pacifist": 0,
        "ach_points_progression": 5,
        "ach_points_pacifist": 5,
        "lb_id": 170125,
        "lb_id_pacifist": 170126,
    },
    {
        "level_id": 5,
        "ach_id_progression": 0,
        "ach_id_pacifist": 0,
        "ach_points_progression": 5,
        "ach_points_pacifist": 5,
        "lb_id": 170127,
        "lb_id_pacifist": 170128,
    },
    {
        "level_id": 6,
        "ach_id_progression": 0,
        "ach_id_pacifist": 0,
        "ach_points_progression": 5,
        "ach_points_pacifist": 5,
        "lb_id": 170129,
        "lb_id_pacifist": 170130,
    },
    {
        "level_id": 7,
        "ach_id_progression": 0,
        "ach_id_pacifist": 0,
        "ach_points_progression": 5,
        "ach_points_pacifist": 5,
        "lb_id": 170131,
        "lb_id_pacifist": 170132,
    },
    {
        "level_id": 8,
        "ach_id_progression": 0,
        "ach_id_pacifist": 0,
        "ach_points_progression": 5,
        "ach_points_pacifist": 5,
        "lb_id": 170133,
        "lb_id_pacifist": 170134,
    },
    {
        "level_id": 9,
        "ach_id_progression": 0,
        "ach_id_pacifist": 0,
        "ach_points_progression": 5,
        "ach_points_pacifist": 5,
        "lb_id": 170135,
        "lb_id_pacifist": 170136,
    },
    {
        "level_id": 10,
        "ach_id_progression": 0,
        "ach_id_pacifist": 0,
        "ach_points_progression": 5,
        "ach_points_pacifist": 5,
        "lb_id": 170137,
        "lb_id_pacifist": 170138,
    },
    {
        "level_id": 11,
        "ach_id_progression": 0,
        "ach_id_pacifist": 0,
        "ach_points_progression": 5,
        "ach_points_pacifist": 5,
        "lb_id": 170139,
        "lb_id_pacifist": 170140,
    },
    {
        "level_id": 12,
        "ach_id_progression": 0,
        "ach_id_pacifist": 0,
        "ach_points_progression": 5,
        "ach_points_pacifist": 5,
        "lb_id": 170141,
        "lb_id_pacifist": 170142,
    },
    {
        "level_id": 15,
        "lb_id": 170160,
    },
    {
        "level_id": 16,
        "lb_id": 170161,
    },
]

for params in LEVEL_PARAMS
{
    // Progression achievements
    if dict_in(params, "ach_id_progression")
    {
        progression_type = "progression"
        if any_of(OPTIONAL_LEVELS, id => params["level_id"] == id)
            progression_type = ""
        else if params["level_id"] == FINAL_LEVEL
            progression_type = "win_condition"
        
        achievement(
            id=params["ach_id_progression"],
            title=dict_get(params, "ach_title_progression", format("{0} - Progression", LevelID2DisplayID(params["level_id"]))),
            description=
                format(
                    "Complete {0}{1}", 
                    LevelID2DisplayID(params["level_id"]),
                    if_else(params["level_id"] == FINAL_LEVEL, " and escape with Lisa", "")
                ),
            type=progression_type,
            points=params["ach_points_progression"],
            trigger=
                AntiBios() &&
                InGame() &&
                LevelComplete(params["level_id"])
        )    
    }
}
 
for params in LEVEL_PARAMS
{   
    // Pacifist achievements
    if dict_in(params, "ach_id_pacifist")
    { 
        achievement(
            id=params["ach_id_pacifist"],
            title=dict_get(params, "ach_title_pacifist", format("{0} - Pacifist", LevelID2DisplayID(params["level_id"]))),
            description=
                format(
                    "Complete {0} with $0 in damage{1}", 
                    LevelID2DisplayID(params["level_id"]),
                    if_else(params["level_id"] == FINAL_LEVEL, " and escape with Lisa", "")
                ),
            points=params["ach_points_progression"],
            trigger=
                AntiBios() &&
                InGame() &&
                g_game_mode == GAME_MODE_RUNABOUT &&
                g_total_amount == 0 &&
                LevelComplete(params["level_id"])
        )    
    }
    
    // Damage achievements
    if dict_in(params, "ach_id_damage")
    {
        achievement(
            id=params["ach_id_damage"],
            title=dict_get(params, "ach_title_damage", format("{0} - Damage", LevelID2DisplayID(params["level_id"]))),
            description=
                format(
                    "Complete {0} with at least ${1} in damage{2}", 
                    LevelID2DisplayID(params["level_id"]),
                    format_number(params["ach_damage_amount"]),
                    if_else(params["level_id"] == FINAL_LEVEL, " and escape with Lisa", "")
                ),
            points=params["ach_points_damage"],
            trigger=
                AntiBios() &&
                InGame() &&
                g_game_mode == GAME_MODE_RUNABOUT &&
                g_total_amount >= params["ach_damage_amount"] &&
                LevelComplete(params["level_id"])
        )    
    }
    
    // Time trial achievements
    if dict_in(params, "ach_id_time_trial")
    {
        time = GetIGT()
        complete_check = LevelComplete(params["level_id"])
        if params["level_id"] == LEVEL_SHORT_TEST_COURSE || params["level_id"] == LEVEL_LONG_TEST_COURSE
        {
            time = g_last_lap_time
            complete_check = g_lap_counter > prev(g_lap_counter)
        }
    
        achievement(
            id=params["ach_id_time_trial"],
            title=dict_get(params, "ach_title_time_trial", format("{0} - Time Trial", LevelID2DisplayID(params["level_id"]))),
            description=
                format(
                    "Complete {0} in under {1}{2}", 
                    LevelID2DisplayID(params["level_id"]),
                    format_ticks(params["ach_time_trial_time"]),
                    if_else(params["level_id"] == FINAL_LEVEL, " and escape with Lisa", "")
                ),
            points=params["ach_points_time_trial"],
            trigger=
                AntiBios() &&
                InGame() &&
                time <= params["ach_time_trial_time"] &&
                complete_check
        )
    }

    // Time trial leaderboards
    if dict_in(params, "lb_id")
    {
        start_cond =
            AntiBios() &&
            InGame()
        
        if params["level_id"] == LEVEL_SHORT_TEST_COURSE || params["level_id"] == LEVEL_LONG_TEST_COURSE
        {
            start_cond =
                start_cond &&
                g_current_level == params["level_id"] &&
                g_lap_counter >= 2 &&
                g_lap_counter > prev(g_lap_counter)
            value_cond = IGT2Centisecs(g_last_lap_time)
            description =
                format(
                    "Record the fastest lap on {0}!",
                    LevelID2DisplayID(params["level_id"])
                )
        }
        else
        {
            start_cond = 
                start_cond &&
                LevelComplete(params["level_id"])
            value_cond = IGT2Centisecs(GetIGT())
            description =
                format(
                    "Complete {0}{1} in the fastest time!", 
                    LevelID2DisplayID(params["level_id"]),
                    if_else(params["level_id"] == FINAL_LEVEL, " and escape with Lisa", "")
                )
        }
    
        leaderboard(
            id=params["lb_id"],
            title=format(
                "{0} - Fastest {1}",
                LevelID2DisplayID(params["level_id"]),
                if_else(params["level_id"] < LEVEL_SHORT_TEST_COURSE, "Time", "Lap")
            ),
            description=description,
            format="CENTISECS",
            lower_is_better=true,
            start=start_cond,
            cancel=always_false(),
            submit=always_true(),
            value=value_cond
        )
    }
    
    // Time trial leaderboards (pacifist)
    if dict_in(params, "lb_id_pacifist")
    {
        leaderboard(
            id=params["lb_id_pacifist"],
            title=format("{0} - Fastest Time (Pacifist)", LevelID2DisplayID(params["level_id"])),
            description=
                format(
                    "Complete {0}{1} in the fastest time with $0 in damages!", 
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
            value=IGT2Centisecs(GetIGT())
        )
    }
}

RP_LEVEL_NAMES = {}
for i in range(0, 0x10)
    RP_LEVEL_NAMES[i] = LevelID2DisplayID(i)
    
RP_CAR_NAMES = {
    0: "1500",
    1: "A156",
    2: "REVU",
    3: "REVU II",
    4: "SCOOTER",
    5: "DELIVERY",
    6: "ROADSTER",
    7: "NSR",
    8: "BZ - VAN",
    9: "MIUR",
    10: "TRACTOR",
    11: "TRACTOR II",
    12: "FIRE ENG.",
    13: "HALLI",
    14: "HALLI II",
    15: "Y800",
    16: "Y800-GT1",
    17: "FT500",
    18: "FT500 S",
    19: "CORVY74",
    20: "CB427",
    21: "FERY250",
    22: "WRC",
    23: "N390",
    24: "N390ROAD",
    25: "RANGER",
    26: "LUNCH VAN",
    27: "MISSILE",
    28: "DRAGSTER",
    29: "G - TANK",
    30: "PANDA",
}

RP_TRANSMISSION_NAMES = {
    0: "AT",
    1: "MT",
}

RP_GAME_MODE_NAMES = {
    GAME_MODE_RUNABOUT: "Runabout",
    GAME_MODE_ROUTE_CHECK: "Route Check",
    GAME_MODE_TIME_TRIAL: "Time Trial",
    GAME_MODE_TEST_RUN: "Test Run",
}

rich_presence_conditional_display(
    g_overlay_id == OVERLAY_GAME_OUT,
    "In a menu"
)
rich_presence_conditional_display(
    g_overlay_id == OVERLAY_GAME_IN,
    "{0} | {1} ({2}) | {3}",
    rich_presence_lookup("LEVEL_NAME", g_current_level, RP_LEVEL_NAMES, "Unknown level"),
    rich_presence_lookup("CAR_NAME", g_current_car_id, RP_CAR_NAMES, "Unknown car"),
    rich_presence_lookup("TRANSMISSION", g_current_transmission, RP_TRANSMISSION_NAMES, "AT"),
    rich_presence_lookup("GAME_MODE", g_game_mode, RP_GAME_MODE_NAMES, "Unknown game mode")
    
)
rich_presence_display("Playing Runabout 2")
