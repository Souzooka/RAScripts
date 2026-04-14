// Tokyo Bus Guide 2
// #ID = 33572

NULL = 0

function if_else(cond, a, b)
{
    if cond == true
        return a
    return b
}

function min(a, b) { return if_else(a < b, a, b) }
function max(a, b) { return if_else(a > b, a, b) }

function dict_copy(dict)
{
    // shallow copy
    new_dict = {}
    for k in dict new_dict[k] = dict[k]
    
    return new_dict
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

function call_with_args(fn, args)
{
    // spread operator when
         if (length(args) == 0) fn()
    else if (length(args) == 1) fn(args[0])
    else if (length(args) == 2) fn(args[0], args[1])
    else if (length(args) == 3) fn(args[0], args[1], args[2])
    else if (length(args) == 4) fn(args[0], args[1], args[2], args[3])
    else if (length(args) == 5) fn(args[0], args[1], args[2], args[3], args[4])
    else if (length(args) == 6) fn(args[0], args[1], args[2], args[3], args[4], args[5])
    else if (length(args) == 7) fn(args[0], args[1], args[2], args[3], args[4], args[5], args[6])
    else if (length(args) == 8) fn(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7])
    else    assert(false, "call_with_args args length unsupported (length={0})", length(args))
}

function CGame(addr)
{
    obj = {
        "m_stop_index": word(addr + 0x44E),
    }
    
    return obj
}

function CGameResultMenu(addr)
{
    obj = {
        "m_medal": dword(addr + 0x60),
        "m_medal_revealed": dword(addr + 0xD8),
    }
    
    return obj
}

MODE_BOOT = 3
MODE_LOGO = 4
MODE_TITLE = 5
MODE_NEWGAME = 6
MODE_GAME = 7
MODE_GAMERESULT = 8
MODE_OPTION = 9
MODE_SAVE = 10
MODE_LOAD = 11
MODE_STAFFROLL = 12
MODE_NOWLOADING = 13
MODE_MODESELECT = 14
MODE_PRACTICE = 15
MODE_PASSENGER = 16
MODE_MAP = 17
MODE_DRIVERMODE = 18
MODE_CARSELECT = 19
MODE_COURSESELECT = 20
MODE_CHALLENGE = 21
MODE_CHALLENGETECHNIQUE = 22
MODE_NAMEENTRY = 23
MODE_RANKING = 24
MODE_SETGAME = 25
MODE_SETCONTROLLER = 26
MODE_KEYCONFIG = 28
MODE_SETTING = 29
MODE_SETSOUND = 30
MODE_2PLAYER = 31
MODE_2PLAYERPASSENGER = 33
MODE_BUSSTOP = 34

// Medal values in the GameResult state
MEDAL_NONE = -1
MEDAL_BRONZE = 2
MEDAL_SILVER = 3
MEDAL_GOLD = 4
MEDAL_PLATINUM = 5

p_game = dword(0x1EA8E0)
g_game = CGame(p_game)
g_game_mode = byte(0x2a6795)
g_course = byte(0x1d15ba0)
g_reverse_course = byte(0x1d15ba1)
g_time_of_day = byte(0x1d15ba2)
practices_completed = array_map(range(0, 12-1), i => bit(i, 0x01d65d28))

// Menus
p_temp_menu_data = dword(0x2A7D18)
g_gameresult_menu = CGameResultMenu(p_temp_menu_data)

////
// Achievements
////

// Tutorial

achievement(
    title="Stamp of Approval",
    description="Complete all practice lessons.",
    points=5,
    trigger=
        g_game_mode == MODE_GAME &&
        sum_of(practices_completed, v => prev(v)) == 11 &&
        measured(sum_of(practices_completed, v => v) == 12)
)

// Platinum medals
// No continues; <=60 violation pts; <=5 bad manner pts

function GameResultDone()
{
    menu_data = CGameResultMenu(p_temp_menu_data)

    return
        g_game_mode == MODE_GAMERESULT &&
        prev(g_gameresult_menu["m_medal_revealed"]) == 0 &&
        g_gameresult_menu["m_medal_revealed"] == 1
}

PLATINUM_PARAMS = [
    {
        "id": 0,
        "title": "Tan 96 (Midday) Platinum",
        "description": "Earn a Platinum Medal on the Tan 96 (Midday) route.",
        "points": 5,
        "course": 0,
        "reverse": 0,
        "time": 0,
    },
    {
        "id": 0,
        "title": "Tan 96 (Evening) Platinum",
        "description": "Earn a Platinum Medal on the Tan 96 (Evening) route.",
        "points": 10,
        "course": 0,
        "reverse": 0,
        "time": 1,
    },
    {
        "id": 0,
        "title": "Tan 96 (Night) Platinum",
        "description": "Earn a Platinum Medal on the Tan 96 (Night) route.",
        "points": 25,
        "course": 0,
        "reverse": 0,
        "time": 2,
    },
    {
        "id": 0,
        "title": "Haya 81 (Midday) Platinum",
        "description": "Earn a Platinum Medal on the Haya 81 (Midday) route.",
        "points": 10,
        "course": 1,
        "reverse": 0,
        "time": 0,
    },
    {
        "id": 0,
        "title": "Haya 81 (Evening) Platinum",
        "description": "Earn a Platinum Medal on the Haya 81 (Evening) route.",
        "points": 25,
        "course": 1,
        "reverse": 0,
        "time": 1,
    },
    {
        "id": 0,
        "title": "Haya 81 (Night) Platinum",
        "description": "Earn a Platinum Medal on the Haya 81 (Night) route.",
        "points": 25,
        "course": 1,
        "reverse": 0,
        "time": 2,
    },
    {
        "id": 0,
        "title": "Ue 23 (Midday) Platinum",
        "description": "Earn a Platinum Medal on the Ue 23 (Midday) route.",
        "points": 10,
        "course": 2,
        "reverse": 0,
        "time": 0,
    },
    {
        "id": 0,
        "title": "Ue 23 (Evening) Platinum",
        "description": "Earn a Platinum Medal on the Ue 23 (Evening) route.",
        "points": 25,
        "course": 2,
        "reverse": 0,
        "time": 1,
    },
    {
        "id": 0,
        "title": "Ue 23 (Night) Platinum",
        "description": "Earn a Platinum Medal on the Ue 23 (Night) route.",
        "points": 25,
        "course": 2,
        "reverse": 0,
        "time": 2,
    },
    // TODO: Figure out if reverse courses are accessible in game (and how)
    {
        "id": 0,
        "title": "Tan 96 (Midday) (Reverse) Platinum",
        "description": "Earn a Platinum Medal on the Tan 96 (Midday) (Reverse) route.",
        "points": 10,
        "course": 0,
        "reverse": 1,
        "time": 0,
    },
    {
        "id": 0,
        "title": "Tan 96 (Evening) (Reverse) Platinum",
        "description": "Earn a Platinum Medal on the Tan 96 (Evening) (Reverse) route.",
        "points": 25,
        "course": 0,
        "reverse": 1,
        "time": 1,
    },
    {
        "id": 0,
        "title": "Tan 96 (Night) (Reverse) Platinum",
        "description": "Earn a Platinum Medal on the Tan 96 (Night) (Reverse) route.",
        "points": 25,
        "course": 0,
        "reverse": 1,
        "time": 2,
    },
    {
        "id": 0,
        "title": "Haya 81 (Midday) (Reverse) Platinum",
        "description": "Earn a Platinum Medal on the Haya 81 (Midday) (Reverse) route.",
        "points": 10,
        "course": 1,
        "reverse": 1,
        "time": 0,
    },
    {
        "id": 0,
        "title": "Haya 81 (Evening) (Reverse) Platinum",
        "description": "Earn a Platinum Medal on the Haya 81 (Evening) (Reverse) route.",
        "points": 10,
        "course": 1,
        "reverse": 1,
        "time": 1,
    },
    {
        "id": 0,
        "title": "Haya 81 (Night) (Reverse) Platinum",
        "description": "Earn a Platinum Medal on the Haya 81 (Night) (Reverse) route.",
        "points": 25,
        "course": 1,
        "reverse": 1,
        "time": 2,
    },
    {
        "id": 0,
        "title": "Ue 23 (Midday) (Reverse) Platinum",
        "description": "Earn a Platinum Medal on the Ue 23 (Midday) (Reverse) route.",
        "points": 10,
        "course": 2,
        "reverse": 1,
        "time": 0,
    },
    {
        "id": 0,
        "title": "Ue 23 (Evening) (Reverse) Platinum",
        "description": "Earn a Platinum Medal on the Ue 23 (Evening) (Reverse) route.",
        "points": 25,
        "course": 2,
        "reverse": 1,
        "time": 1,
    },
    {
        "id": 0,
        "title": "Ue 23 (Night) (Reverse) Platinum",
        "description": "Earn a Platinum Medal on the Ue 23 (Night) (Reverse) route.",
        "points": 25,
        "course": 2,
        "reverse": 1,
        "time": 2,
    },
]

for params in PLATINUM_PARAMS
{
    achievement(
        id=params["id"],
        title=params["title"],
        description=params["description"],
        points=params["points"],
        trigger=
            g_course == params["course"] &&
            g_reverse_course == params["reverse"] &&
            g_time_of_day == params["time"] &&
            GameResultDone()
    )
}

////
// Rich Presence
////

boot_string = "Starting up the bus"
menu_string = "In menus"

rp_course_lookup = {
    0: "反９６",
    1: "早８１",
    2: "上２３",
}

rp_time_lookup = {
    0: "Midday",
    1: "Evening",
    2: "Night",
}

// TODO: Clean up/verify these English names
COURSE0_STOPS = 14
rp_course0_stop_lookup = {
    0: "Akabanebashi Station ({0}/{1})", // 赤羽橋駅前 - Akabanebashi Station front
    1: "Nakanohashi ({0}/{1})", // 中ノ橋 - don't think this refers to a specific bridge
    2: "Azabu Station 10 ({0}/{1})", // 麻布十番駅前
    3: "Ninohashi ({0}/{1})", // 二ノ橋
    4: "Sannohashi ({0}/{1})", // 三ノ橋
    5: "Furukawabashi ({0}/{1})", // 古川橋
    6: "Gyoranzaka Lower ({0}/{1})", // 魚籃坂下
    7: "Takanawa Block 1 ({0}/{1})", // 高輪一丁目
    8: "Sengakuji ({0}/{1})", // 泉岳寺前
    9: "Takanawa North ({0}/{1})", // 高輪北町
    10: "Shinagawa Station ({0}/{1})", // 品川駅前
    11: "Gotenyama ({0}/{1})", // 御殿山
    12: "Sony ({0}/{1})", // ソニー前
    13: "Higashigotanda Block 3 ({0}/{1})", // 東五反田三丁目
    14: "Gotanda Station ({0}/{1})", // 五反田駅
}
rp_course0_stop_lookup_reverse = {}
lookup_copy = dict_copy(rp_course0_stop_lookup)
for i in range(0, COURSE0_STOPS)
{
    rp_course0_stop_lookup_reverse[i] = lookup_copy[COURSE0_STOPS - i]
    rp_course0_stop_lookup[i] = format(rp_course0_stop_lookup[i], i, COURSE0_STOPS)
    rp_course0_stop_lookup_reverse[i] = format(rp_course0_stop_lookup_reverse[i], i, COURSE0_STOPS)
}
rp_course0_stop_lookup[COURSE0_STOPS+1] = rp_course0_stop_lookup[COURSE0_STOPS]
rp_course0_stop_lookup_reverse[COURSE0_STOPS+1] = rp_course0_stop_lookup_reverse[COURSE0_STOPS]

COURSE1_STOPS = 22
rp_course1_stop_lookup = {
    0: "Waseda University ({0}/{1})", // 早大正門 - Waseda University Main Gate
    1: "Babashitachou ({0}/{1})", // 馬場下町
    2: "Kikuichou ({0}/{1})", // 喜久井町
    3: "Wakamatsuchou ({0}/{1})", // 若松町
    4: "Wakadachou ({0}/{1})", // 河田町
    5: "Tokyo Women's Medical University ({0}/{1})", // 東京女子医大前 - In front of Tokyo Women's Medical University
    6: "Ichigayanakanochou Intersection ({0}/{1})", // 市谷仲之町交差点
    7: "Arakichou ({0}/{1})", // 荒木町
    8: "Yotsuya Block 3 ({0}/{1})", // 四谷三丁目
    9: "Yotsuya Block 4 ({0}/{1})", // 四谷四丁目
    10: "Daikyouchou in Naitoumachi ({0}/{1})", // 内藤町大京町
    11: "Yotsuya Sixth District Elementary ({0}/{1})", // 四谷第六小学校入口 - Elementary school entrance in Yotsuya 6th district
    12: "Sendagaya Station ({0}/{1})", // 千駄ヶ谷駅前 - Sendagaya Station front
    13: "Sendagaya Hachiman Shrine ({0}/{1})", // 千駄ヶ谷八幡前 - Sendagaya Hachiman Shrine front
    14: "Meiji Park ({0}/{1})", // 明治公園前 - Meiji Park front
    15: "Kasumigaoka Apartments ({0}/{1})", // 霞ヶ丘団地前 - Kasumigaoka Apartments front
    16: "Sendagaya Block 2 ({0}/{1})", // 千駄ヶ谷二丁目
    17: "Harajuku Gardens Middle School ({0}/{1})", // 原宿外苑中学校
    18: "Harajuku Station ({0}/{1})", // 原宿駅前 - Harajuku Station front
    19: "Yoyogi National Stadium ({0}/{1})", // 国立代々木競技場前 - Yoyogi National Stadium front
    20: "Shibuya District Government Office ({0}/{1})", // 渋谷区役所前 - Shibuya District Government Office
    21: "Shibuya Station West Entrance ({0}/{1})", // 渋谷駅西口
    22: "Shibuya Station East Entrance ({0}/{1})", // 渋谷駅東口
}
rp_course1_stop_lookup_reverse = {}
lookup_copy = dict_copy(rp_course1_stop_lookup)
for i in range(0, COURSE1_STOPS)
{
    rp_course1_stop_lookup_reverse[i] = lookup_copy[COURSE1_STOPS - i]
    rp_course1_stop_lookup[i] = format(rp_course1_stop_lookup[i], i, COURSE1_STOPS)
    rp_course1_stop_lookup_reverse[i] = format(rp_course1_stop_lookup_reverse[i], i, COURSE1_STOPS)
}
rp_course1_stop_lookup[COURSE1_STOPS+1] = rp_course1_stop_lookup[COURSE1_STOPS]
rp_course1_stop_lookup_reverse[COURSE1_STOPS+1] = rp_course1_stop_lookup_reverse[COURSE1_STOPS]

COURSE2_STOPS = 28
rp_course2_stop_lookup = {
    0: "Hirai Station ({0}/{1})", // 平井駅前
    1: "Hirai Elementary School ({0}/{1})", // 平井小学校前
    2: "Hirai Block 6 Kouban ({0}/{1})", // 平井六丁目交番前
    3: "Hirai Block 7 ({0}/{1})", // 平井七丁目
    4: "Hirai Block 7 North Park ({0}/{1})", // 平井七丁目北公園前
    5: "Hirai Block 7 Apartments 3 ({0}/{1})", // 平井七丁目第三アパート前
    6: "Higashisumida Block 1 ({0}/{1})", // 東墨田一丁目
    7: "Higashisumida Block 3 ({0}/{1})", // 東墨田三丁目
    8: "Higashisumida Meeting Hall ({0}/{1})", // 東墨田会館前
    9: "Higashisumida Block 2 ({0}/{1})", // 東墨田二丁目
    10: "Welfare Society Meeting Hall ({0}/{1})", // 社会福祉会館前
    11: "Yahiro Block 2 ({0}/{1})", // 八広二丁目
    12: "Nakaibori ({0}/{1})", // 中居堀
    13: "Bunka Block 3 ({0}/{1})", // 文花三丁目
    14: "Towards Jukken Bridge ({0}/{1})", // 十間橋通り
    15: "Jukken Bridge ({0}/{1})", // 十間橋
    16: "Oshiage ({0}/{1})", // 押上
    17: "Narihira Bridge ({0}/{1})", // 業平橋
    18: "Azuma Bridge Main Office ({0}/{1})", // 本所吾妻橋
    19: "Azuma Bridge Riverpia Apartments ({0}/{1})", // リバーピア吾妻橋前
    20: "Asakusa Temple Gate ({0}/{1})", // 浅草雷門
    21: "Asakusa Block 1 ({0}/{1})", // 浅草一丁目
    22: "Asakusakotobukichou ({0}/{1})", // 浅草寿町
    23: "Kikuya Bridge ({0}/{1})", // 浅草寿町
    24: "East Ueno Block 6 ({0}/{1})", // 東上野六丁目
    25: "Shitaya Corporation ({0}/{1})", // 下谷神社前
    26: "Ueno Station ({0}/{1})", // 上野駅前
    27: "Ueno Park Lower ({0}/{1})", // 上野公園山下
    28: "Ueno Matsuzakaya ({0}/{1})", // 上野松坂屋前
}
rp_course2_stop_lookup_reverse = {}
lookup_copy = dict_copy(rp_course2_stop_lookup)
for i in range(0, COURSE2_STOPS)
{
    rp_course2_stop_lookup_reverse[i] = lookup_copy[COURSE2_STOPS - i]
    rp_course2_stop_lookup[i] = format(rp_course2_stop_lookup[i], i, COURSE2_STOPS)
    rp_course2_stop_lookup_reverse[i] = format(rp_course2_stop_lookup_reverse[i], i, COURSE2_STOPS)
}
rp_course2_stop_lookup[COURSE2_STOPS+1] = rp_course2_stop_lookup[COURSE2_STOPS]
rp_course2_stop_lookup_reverse[COURSE2_STOPS+1] = rp_course2_stop_lookup_reverse[COURSE2_STOPS]

rp_stop_lookup = {}
for i in rp_course0_stop_lookup rp_stop_lookup[(0x1000 * 0) + (0x100 * 0) + i] = rp_course0_stop_lookup[i]
for i in rp_course1_stop_lookup rp_stop_lookup[(0x1000 * 0) + (0x100 * 1) + i] = rp_course1_stop_lookup[i]
for i in rp_course2_stop_lookup rp_stop_lookup[(0x1000 * 0) + (0x100 * 2) + i] = rp_course2_stop_lookup[i]
for i in rp_course0_stop_lookup_reverse rp_stop_lookup[(0x1000 * 1) + (0x100 * 0) + i] = rp_course0_stop_lookup_reverse[i]
for i in rp_course1_stop_lookup_reverse rp_stop_lookup[(0x1000 * 1) + (0x100 * 1) + i] = rp_course1_stop_lookup_reverse[i]
for i in rp_course2_stop_lookup_reverse rp_stop_lookup[(0x1000 * 1) + (0x100 * 2) + i] = rp_course2_stop_lookup_reverse[i]
bus_stop_idx = (0x1000 * g_reverse_course) + (0x100 * g_course) + g_game["m_stop_index"]

rp_format_strings = [
    [g_game_mode < MODE_BOOT, boot_string],
    [g_game_mode == MODE_BOOT, boot_string],
    [g_game_mode == MODE_LOGO, boot_string],
    [g_game_mode == MODE_TITLE, "In title screen"],
    [g_game_mode == MODE_NEWGAME, "Meeting Minkuru"],
    [g_game_mode == MODE_GAME && g_course == 3, "Learning how to drive the bus"],
    [
        g_game_mode == MODE_GAME, 
        "Driving the bus on {0} ({1}). Next stop: {2}.", 
        rich_presence_lookup("ROUTE", g_course, rp_course_lookup),
        rich_presence_lookup("TIME_OF_DAY", g_time_of_day, rp_time_lookup),
        rich_presence_lookup("BUS_STOP", bus_stop_idx + 1, rp_stop_lookup)
    ],
    [g_game_mode == MODE_GAMERESULT, "Reviewing route performance"],
    [g_game_mode == MODE_OPTION, menu_string],
    [g_game_mode == MODE_SAVE, menu_string],
    [g_game_mode == MODE_LOAD, menu_string],
    [g_game_mode == MODE_STAFFROLL, "Watching credits"],
    [g_game_mode == MODE_NOWLOADING, "In loading screen"],
    [g_game_mode == MODE_MODESELECT, menu_string],
    [g_game_mode == MODE_PRACTICE, menu_string],
    [g_game_mode == MODE_PASSENGER, "In Passenger state?"],
    [g_game_mode == MODE_MAP, "Checking the map"],
    [g_game_mode == MODE_DRIVERMODE, menu_string],
    [g_game_mode == MODE_CARSELECT, "Choosing a bus"],
    [g_game_mode == MODE_COURSESELECT, "Choosing a route"],
    [g_game_mode == MODE_CHALLENGE, menu_string],
    [g_game_mode == MODE_CHALLENGETECHNIQUE, menu_string],
    [g_game_mode == MODE_NAMEENTRY, menu_string],
    [g_game_mode == MODE_RANKING, menu_string],
    [g_game_mode == MODE_SETGAME, menu_string],
    [g_game_mode == MODE_SETCONTROLLER, menu_string],
    [g_game_mode == MODE_KEYCONFIG, menu_string],
    [g_game_mode == MODE_SETTING, menu_string],
    [g_game_mode == MODE_SETSOUND, menu_string],
    [g_game_mode == MODE_2PLAYER, "In 2-player mode"],
    [g_game_mode == MODE_2PLAYERPASSENGER, "In 2-player mode"],
    [
        g_game_mode == MODE_BUSSTOP, 
        "Driving the bus on {0} ({1}). Currently stopped at: {2}.", 
        rich_presence_lookup("ROUTE", g_course, rp_course_lookup),
        rich_presence_lookup("TIME_OF_DAY", g_time_of_day, rp_time_lookup),
        rich_presence_lookup("BUS_STOP", bus_stop_idx, rp_stop_lookup)
    ],
]

for args in rp_format_strings
    call_with_args(rich_presence_conditional_display, args)
    
rich_presence_display("Playing Tokyo Bus Guide 2")