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

function LevelComplete(level_id, first_half=false)
{
    acc = bit4(0x905ff)
    cond = always_true()
    
    // Mission #13 is cut into two halves, and we actually want to
    // consider only the second half
    if level_id == FINAL_LEVEL && !first_half
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
OPTIONAL_LEVELS = [3, 4, 5, 6, 7, 8, 9, 10]
LEVEL_SHORT_TEST_COURSE = 15
LEVEL_LONG_TEST_COURSE = 16

g_game_mode = byte(0x42526)
GAME_MODE_RUNABOUT = 0x0
GAME_MODE_ROUTE_CHECK = 0x1
GAME_MODE_TEST_RUN = 0x2
GAME_MODE_TIME_TRIAL = 0x3

g_total_amount = dword(0x86a80)

g_remaining_time = dword(0x8f5b8)
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
g_lap_counter = dword(0x13c984)

LEVEL_PARAMS = [
    {
        "level_id": 0,
        "ach_id_progression": 633237,
        "ach_id_pacifist": 633250,
        "ach_id_damage": 633251,
        "ach_id_time_trial": 633252,
        "ach_title_progression": "Transport the Dragon's Fang",
        "ach_title_pacifist": "Beach Day",
        "ach_title_damage": "Party Crasher",
        "ach_title_time_trial": "Wave Racer",
        "ach_points_progression": 5,
        "ach_points_pacifist": 5,
        "ach_points_damage": 10,
        "ach_points_time_trial": 5,
        "ach_damage_amount": 1000000, // Easy=600k, Hard=1mil
        "ach_time_trial_time": Time2Ticks(minutes=1, seconds=6),
        "lb_id": 170095,
        "lb_id_pacifist": 170118,
        "lb_id_damage": 170199,
    },
    {
        "level_id": 1,
        "ach_id_progression": 633238,
        "ach_id_pacifist": 633254,
        "ach_id_damage": 633255,
        "ach_id_time_trial": 633256,
        "ach_title_progression": "Reclaim the Sacred Cup",
        "ach_title_pacifist": "Clean Rally",
        "ach_title_damage": "Mud Slinger",
        "ach_title_time_trial": "Made My Flight",
        "ach_points_progression": 5,
        "ach_points_pacifist": 5,
        "ach_points_damage": 10,
        "ach_points_time_trial": 10,
        "ach_damage_amount": 750000, // Hard=750k
        "ach_time_trial_time": Time2Ticks(minutes=1, seconds=28),
        "lb_id": 170119,
        "lb_id_pacifist": 170120,
        "lb_id_damage": 170200,
    },
    {
        "level_id": 2,
        "ach_id_progression": 633239,
        "ach_id_pacifist": 633257,
        "ach_id_damage": 633258,
        "ach_id_time_trial": 633259,
        "ach_title_progression": "Transfer the Sacred Cup",
        "ach_title_pacifist": "Laser Limbo",
        "ach_title_damage": "Blinded by the Lights",
        "ach_title_time_trial": "Mall Madness",
        "ach_points_progression": 5,
        "ach_points_pacifist": 5,
        "ach_points_damage": 5,
        "ach_points_time_trial": 10,
        "ach_damage_amount": 1000000,
        "ach_time_trial_time": Time2Ticks(minutes=1, seconds=55),
        "lb_id": 170121,
        "lb_id_pacifist": 170122,
        "lb_id_damage": 170201,
    },
    {
        "level_id": 3,
        "ach_id_progression": 633240,
        "ach_id_pacifist": 633261,
        "ach_id_damage": 633262,
        "ach_id_time_trial": 633263,
        "ach_title_progression": "Recover the Crystal Skull",
        "ach_title_pacifist": "Is This Really Pacifism?",
        "ach_title_damage": "Casino Crackdown",
        "ach_title_time_trial": "Shopping Spree",
        "ach_points_progression": 5,
        "ach_points_pacifist": 5,
        "ach_points_damage": 10,
        "ach_points_time_trial": 10,
        "ach_damage_amount": 750000,
        "ach_time_trial_time": Time2Ticks(minutes=1, seconds=16),
        "lb_id": 170123,
        "lb_id_pacifist": 170124,
        "lb_id_damage": 170202,
    },
    {
        "level_id": 4,
        "ach_id_progression": 633241,
        "ach_id_pacifist": 633264,
        "ach_id_damage": 633265,
        "ach_id_time_trial": 633266,
        "ach_title_progression": "Transfer Crystal Skull",
        "ach_title_pacifist": "Lovely Night for a Drive",
        "ach_title_damage": "Mutually-Assured Destruction",
        "ach_title_time_trial": "Overnight Shipping",
        "ach_points_progression": 5,
        "ach_points_pacifist": 5,
        "ach_points_damage": 10,
        "ach_points_time_trial": 10,
        "ach_damage_amount": 1000000,
        "ach_time_trial_time": Time2Ticks(minutes=1, seconds=16),
        "lb_id": 170125,
        "lb_id_pacifist": 170126,
        "lb_id_damage": 170203,
    },
    {
        "level_id": 5,
        "ach_id_progression": 633242,
        "ach_id_pacifist": 633267,
        "ach_id_damage": 633268,
        "ach_id_time_trial": 633269,
        "ach_title_progression": "Reveal the Mystery of Sanju",
        "ach_title_pacifist": "We Need to Pay for That",
        "ach_title_damage": "The Jewels Are Mine",
        "ach_title_time_trial": "No Time for Consumerism",
        "ach_points_progression": 5,
        "ach_points_pacifist": 5,
        "ach_points_damage": 10,
        "ach_points_time_trial": 10,
        "ach_damage_amount": 3500000,
        "ach_time_trial_time": Time2Ticks(minutes=1, seconds=42),
        "lb_id": 170127,
        "lb_id_pacifist": 170128,
        "lb_id_damage": 170204,
    },
    {
        "level_id": 6,
        "ach_id_progression": 633243,
        "ach_id_pacifist": 633270,
        "ach_id_damage": 633271,
        "ach_id_time_trial": 633272,
        "ach_title_progression": "Research Computer Network",
        "ach_title_pacifist": "Hackerman",
        "ach_title_damage": "Brute Force Access",
        "ach_title_time_trial": "I Don't Use Dial-Up",
        "ach_points_progression": 5,
        "ach_points_pacifist": 5,
        "ach_points_damage": 5,
        "ach_points_time_trial": 5,
        "ach_damage_amount": 600000,
        "ach_time_trial_time": Time2Ticks(minutes=2, seconds=22),
        "lb_id": 170129,
        "lb_id_pacifist": 170130,
        "lb_id_damage": 170205,
    },
    {
        "level_id": 7,
        "ach_id_progression": 633244,
        "ach_id_pacifist": 633273,
        "ach_id_damage": 633274,
        "ach_id_time_trial": 633275,
        "ach_title_progression": "Destroy Shrines",
        "ach_title_pacifist": "But Just the Shrines",
        "ach_title_damage": "And Everything Else",
        "ach_title_time_trial": "Whichever Is Fastest",
        "ach_points_progression": 5,
        "ach_points_pacifist": 5,
        "ach_points_damage": 10,
        "ach_points_time_trial": 10,
        "ach_damage_amount": 900000,
        "ach_time_trial_time": Time2Ticks(minutes=2, seconds=14),
        "lb_id": 170131,
        "lb_id_pacifist": 170132,
        "lb_id_damage": 170206,
    },
    {
        "level_id": 8,
        "ach_id_progression": 633245,
        "ach_id_pacifist": 633277,
        "ach_id_damage": 633278,
        "ach_id_time_trial": 633279,
        "ach_title_progression": "Deliver the Microfilm",
        "ach_title_pacifist": "Handle with Care",
        "ach_title_damage": "Delays Expected",
        "ach_title_time_trial": "Faster Than Ground Shipping",
        "ach_points_progression": 5,
        "ach_points_pacifist": 5,
        "ach_points_damage": 10,
        "ach_points_time_trial": 10,
        "ach_damage_amount": 1150000,
        "ach_time_trial_time": Time2Ticks(minutes=1, seconds=28),
        "lb_id": 170133,
        "lb_id_pacifist": 170134,
        "lb_id_damage": 170207,
    },
    {
        "level_id": 9,
        "ach_id_progression": 633246,
        "ach_id_pacifist": 633280,
        "ach_id_damage": 633281,
        "ach_id_time_trial": 633282,
        "ach_title_progression": "Investigate Ruins",
        "ach_title_pacifist": "Like a Museum",
        "ach_title_damage": "Like a Flood",
        "ach_title_time_trial": "Like a Tourist",
        "ach_points_progression": 5,
        "ach_points_pacifist": 5,
        "ach_points_damage": 10,
        "ach_points_time_trial": 10,
        "ach_damage_amount": 3200000,
        "ach_damage_time": Time2Ticks(minutes=3, seconds=0),
        "ach_time_trial_time": Time2Ticks(minutes=2, seconds=46),
        "lb_id": 170135,
        "lb_id_pacifist": 170136,
        "lb_id_damage": 170211,
    },
    {
        "level_id": 10,
        "ach_id_progression": 633247,
        "ach_id_pacifist": 633283,
        "ach_id_damage": 633284,
        "ach_id_time_trial": 633285,
        "ach_title_progression": "Recapture the Microfilm",
        "ach_title_pacifist": "Cat Tail",
        "ach_title_damage": "Elephant Tail",
        "ach_title_time_trial": "Cheetah Tail",
        "ach_points_progression": 5,
        "ach_points_pacifist": 5,
        "ach_points_damage": 10,
        "ach_points_time_trial": 5,
        "ach_damage_amount": 1000000,
        "ach_time_trial_time": Time2Ticks(minutes=3, seconds=4),
        "lb_id": 170137,
        "lb_id_pacifist": 170138,
        "lb_id_damage": 170208,
    },
    {
        "level_id": 11,
        "ach_id_progression": 633248,
        "ach_id_pacifist": 633286,
        "ach_id_damage": 633287,
        "ach_id_time_trial": 633288,
        "ach_title_progression": "Neutralize an Urgent Threat",
        "ach_title_pacifist": "Mostly Harmless",
        "ach_title_damage": "An Urgent Threat",
        "ach_title_time_trial": "Neutral One Way or the Other",
        "ach_points_progression": 5,
        "ach_points_pacifist": 5,
        "ach_points_damage": 5,
        "ach_points_time_trial": 10,
        "ach_damage_amount": 1000000,
        "ach_time_trial_time": Time2Ticks(minutes=2, seconds=35),
        "lb_id": 170139,
        "lb_id_pacifist": 170140,
        "lb_id_damage": 170209,
    },
    {
        "level_id": 12,
        "ach_id_progression": 633249,
        "ach_id_pacifist": 633289,
        "ach_id_damage": 633290,
        "ach_id_time_trial": 633291,
        "ach_title_progression": "Destroy the Foundation Building",
        "ach_title_pacifist": "Property Damage Is Violence",
        "ach_title_damage": "Everything's Computer",
        "ach_title_time_trial": "Four Minute Police Response",
        "ach_points_progression": 10,
        "ach_points_pacifist": 25,
        "ach_points_damage": 10,
        "ach_points_time_trial": 10,
        "ach_damage_amount": 2000000,
        "ach_time_trial_time": Time2Ticks(minutes=4, seconds=0),
        "lb_id": 170141,
        "lb_id_pacifist": 170142,
        "lb_id_damage": 170210,
    },
    {
        "level_id": LEVEL_SHORT_TEST_COURSE,
        "ach_id_time_trial": 633293,
        "ach_title_time_trial": "Actually a Racing Game",
        "ach_points_time_trial": 10,
        "ach_time_trial_time": Time2Ticks(minutes=0, seconds=58),
        "lb_id": 170160,
    },
    {
        "level_id": LEVEL_LONG_TEST_COURSE,
        "ach_id_time_trial": 633294,
        "ach_title_time_trial": "Actually a Rally Game",
        "ach_points_time_trial": 10,
        "ach_time_trial_time": Time2Ticks(minutes=1, seconds=37),
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
}

for params in LEVEL_PARAMS
{   
    // Damage achievements
    if dict_in(params, "ach_id_damage")
    {
        time_check = always_true()
        if dict_in(params, "ach_damage_time")
            time_check = GetIGT() <= params["ach_damage_time"]
    
        achievement(
            id=params["ach_id_damage"],
            title=dict_get(params, "ach_title_damage", format("{0} - Damage", LevelID2DisplayID(params["level_id"]))),
            description=
                format(
                    "Complete {0} with at least ${1} in damage{2}{3}", 
                    LevelID2DisplayID(params["level_id"]),
                    format_number(params["ach_damage_amount"]),
                    if_else(params["level_id"] == FINAL_LEVEL, " and escape with Lisa", ""),
                    if_else(dict_in(params, "ach_damage_time"), format(" in under {0}", format_ticks(dict_get(params, "ach_damage_time", -1))), "")
                ),
            points=params["ach_points_damage"],
            trigger=
                AntiBios() &&
                InGame() &&
                g_game_mode == GAME_MODE_RUNABOUT &&
                time_check &&
                g_total_amount >= params["ach_damage_amount"] &&
                LevelComplete(params["level_id"])
        )    
    }
}

for params in LEVEL_PARAMS
{   
    // Time trial achievements
    if dict_in(params, "ach_id_time_trial")
    {
        time = GetIGT()
        complete_check = LevelComplete(params["level_id"])
        is_test_course = params["level_id"] == LEVEL_SHORT_TEST_COURSE || params["level_id"] == LEVEL_LONG_TEST_COURSE
        if is_test_course
        {
            time = g_last_lap_time
            complete_check = 
                g_current_level == params["level_id"] && 
                g_lap_counter >= 2 &&
                g_lap_counter > prev(g_lap_counter)
        }
    
        achievement(
            id=params["ach_id_time_trial"],
            title=dict_get(params, "ach_title_time_trial", format("{0} - Time Trial", LevelID2DisplayID(params["level_id"]))),
            description=
                format(
                    "Complete{0} {1} in under {2}{3}", 
                    if_else(is_test_course, " a lap of", ""),
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
}

for params in LEVEL_PARAMS
{   
    // Specialty achievements
    if params["level_id"] == 0
    {
        car1_surface = word(0x125730)
        SAND = 0x28
        
        achievement(
            id=633253,
            title="I Hate Sand",
            description="Complete Mission #01 using the 1500 without driving on the beach",
            points=10,
            trigger=
                AntiBios() &&
                InGame() &&
                g_game_mode == GAME_MODE_RUNABOUT &&
                g_current_level == 0 &&
                g_current_car_id == 0 &&
                once(g_total_time > 0 && prev(g_total_time) == 0) &&
                never(car1_surface == SAND || g_total_time == 0 || !InGame()) &&
                trigger_when(LevelComplete(0))
        )
    }
    if params["level_id"] == 2
    {
        doors = [word(0x12b7d6), word(0x12b80e), word(0x12b846), word(0x12b87e)]
        car2_height = dword(0x125dc0)
        
        achievement(
            id=633260,
            title="Mission Possible",
            description="Complete Mission #03 without triggering any security lasers",
            points=2,
            trigger=
                AntiBios() &&
                InGame() &&
                g_current_level == 2 &&
                g_car_index == 1 &&
                (
                    once((car2_height > 0x11000 && prev(car2_height) <= 0x11000) && car2_height < 0x80000000) && 
                    never(!InGame() || g_total_time == 0 || car2_height > 0x3A000 && car2_height < 0x80000000)
                ) &&
                all_of(doors, door => door == 0) &&
                trigger_when(LevelComplete(2))
        )
    }
    if params["level_id"] == 6
    {
        achievement(
            id=633300,
            title="Courier Chaos",
            description="Complete Mission #07 after having swapped to the Scooter mid-mission",
            points=2,
            trigger=
                AntiBios() &&
                InGame() &&
                g_current_level == 6 &&
                g_car_index == 1 &&
                LevelComplete(6)
        )
    }
    if params["level_id"] == 7
    {
        car1_x = dword(0x125484)
        car1_z = dword(0x12548C)
        stands = [
            bit1(0x12927b), bit1(0x1292b3), bit1(0x1292eb), bit1(0x129323),
            bit1(0x12935b), bit1(0x12aafb), bit1(0x12ab33), bit1(0x12ab6b),
            bit1(0x12aba3), bit1(0x12abdb), bit1(0x12ac13), bit1(0x12ac4b),
            bit1(0x12ac83), bit1(0x12acbb), bit1(0x12acf3), bit1(0x12ad2b),
        ]
    
        achievement(
            id=633276,
            title="Standabout",
            description="Complete Mission #08 after smashing all 16 food stands and shooting galleries",
            points=5,
            trigger=
                AntiBios() &&
                InGame() &&
                g_current_level == 7 &&
                g_game_mode == GAME_MODE_RUNABOUT &&
                (
                    (
                        once(
                            (car1_x > 0x11C000 && car1_x < 0x80000000) &&
                            (car1_z < 0x11C000 && prev(car1_z) >= 0x11C000)
                        ) &&
                        never(!InGame() || g_total_time == 0 || g_remaining_time == 0) &&
                        trigger_when(always_false())
                    ) ||
                    (
                        measured(
                            sum_of(stands, v=>v) == 16,
                            when=InGame() && g_current_level == 7 && g_total_time != 0
                        ) &&
                        LevelComplete(7)
                    )
                )
        )
    }
    if params["level_id"] == FINAL_LEVEL
    {
        // fake progression achievement
        achievement(
            id=633292,
            title="The End Is Never",
            description="Complete Mission #13",
            points=0,
            trigger=
                AntiBios() &&
                InGame() &&
                LevelComplete(FINAL_LEVEL, first_half=true)
        )
    }
}

for params in LEVEL_PARAMS
{   
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
}
 
for params in LEVEL_PARAMS
{      
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

for params in LEVEL_PARAMS
{       
    // Damage leaderboards
    if dict_in(params, "lb_id_damage")
    {
        time_check = always_true()
        if dict_in(params, "ach_damage_time")
            time_check = GetIGT() <= params["ach_damage_time"]
    
        leaderboard(
            id=params["lb_id_damage"],
            title=format("{0} - Highest Amount", LevelID2DisplayID(params["level_id"])),
            description=
                format(
                    "Complete {0}{1} with the highest amount in damages{2}!",
                    LevelID2DisplayID(params["level_id"]),
                    if_else(params["level_id"] == FINAL_LEVEL, " and escape with Lisa", ""),
                    if_else(dict_in(params, "ach_damage_time"), format(" in under {0}", format_ticks(dict_get(params, "ach_damage_time", -1))), "")
                ),
            format="VALUE",
            start=
                AntiBios() &&
                InGame() &&
                g_game_mode == GAME_MODE_RUNABOUT &&
                time_check &&
                // Just to prevent leaderboard popup spam with pacifist time trial lb
                g_total_amount != 0 &&
                LevelComplete(params["level_id"]),
            cancel=always_false(),
            submit=always_true(),
            value=g_total_amount
        )
    }
}

// Item achievements
NOT_ITEMS = [5, 7, 8, 9, 10, 11, 12, 13, 27, 28, 29]

ITEM_PARAMS = [
    {
        "id": 633295,
        "title": "Walk to the Store",
        "amount": 10,
        "points": 10,
    },
    {
        "id": 633296,
        "title": "Jog, Don't Walk",
        "amount": 20,
        "points": 10,
    },
    {
        "id": 633297,
        "title": "Run, Don't Jog",
        "amount": 30,
        "points": 10,
    },
    {
        "id": 633298,
        "title": "Drive, Don't Run",
        "amount": 40,
        "points": 10,
    },
    {
        "id": 633299,
        "title": "Runabout, Don't Drive",
        "amount": 47,
        "points": 25,
    },
]

g_items = 0x42218
items = []
for i in range(0, 0x3A-1)
{
    if !any_of(NOT_ITEMS, v => v == i)
    {
        array_push(items, byte(g_items+i))
    }
}
assert(length(items) == 47, format("items length {0}", length(items)))
for params in ITEM_PARAMS
{
    achievement(
        id=params["id"],
        title=params["title"],
        description=format(
            "Collect{0} {1} items",
            if_else(params["amount"] == 47, " all", ""),
            params["amount"]
        ),
        points=params["points"],
        trigger=
            AntiBios() &&
            InGame() &&
            sum_of(items, prev) < params["amount"] &&
            measured(sum_of(items, v => v) >= params["amount"], when=AntiBios())
    )
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
