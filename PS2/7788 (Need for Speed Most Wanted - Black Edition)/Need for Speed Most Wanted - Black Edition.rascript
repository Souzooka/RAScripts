// Need for Speed: Most Wanted - Black Edition
// #ID = 7788

NULL = 0
True = 1
False = 0

function if_else(cond, v1, v2)
{
    if cond == true
    {
        return v1
    }
    return v2
}

addr = (v) => v // Dummy accessor for ptr for if the pointed-to address is desired
RA_MASK = 0xFFFFFFFF
PTR_DEREF = p => dword(p) // & RA_MASK
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
            val = PTR_DEREF(addr)
        }
    }
    
    return val
}

function dict_keys(dict)
{
    return array_map(dict, k => k)
}

function dict_values(dict)
{
    return array_map(dict, k => dict[k])
}

function array_extend(a, b)
{
    lst = []
    for v in a array_push(lst, v)
    for v in b array_push(lst, v)
    return lst
}

function array_iextend(a, b)
{
    for v in b array_push(a, v)
    return a
}

// Tollbooth race hashes
TOLLBOOTHS = {
    14: {
        5: 0x2132B6F5,
    },
    13: {
        4: 0xAE16FBE6,
        5: 0x15624C7B,
    },
    12: {
        2: 0x10E106FE,
        3: 0x3FF5E490,
    },
    11: {
        4: 0x4896FCC2,
        5: 0x0A08A7F2,
    },
    10: {
        3: 0x9864F043,
        4: 0x005278D2,
    },
    9: {
        3: 0x5E0DF864,
        6: 0x41F9E6A0,
    },
    8: {
        6: 0xD59AFE63,
        7: 0x1A0E3129,
    },
    7: {
        2: 0x7F638D2A,
        4: 0x6FB59384,
        9: 0xA563F357,
    },
    6: {
        2: 0xEE9BB415,
        5: 0x298547F8,
        11: 0xF8047919,
    },
    5: {
        6: 0x62C6D013,
        9: 0x69A4F824,
        10: 0xF63B2D20,
    },
    4: {
        1: 0x1941EFEE,
        10: 0xEA1C6749,
        11: 0x42492D10,
    },
    3: {
        4: 0xBBDC28F0,
        9: 0x1A65891A,
        10: 0x4BD4E765,
    },
    2: {
        3: 0x04FD1281,
        4: 0x2511EB63,
        5: 0xFE88D117,
    },
    1: {
        6: 0x8D9B3655,
        7: 0xC61343DE,
        11: 0x4486EB92,
    },
}

MODE_CAREER = 1
g_mode = byte(0x56f574)
g_player_count = dword(0x53C6F0)
g_in_game = dword(0x575D10)
g_event_id1 = ptr(dword(0x570DFC), [0x1C40, 0x0, 0x0], dword) // Valid when event is started from overworld, not safehouse?
g_event_id2 = ptr(dword(0x56D88C), [0x0, 0x0], dword) // Valid when event is launched from the blacklist menu
g_total_event_time = ptr(dword(0x575D44), [0x1C3C], float)
g_overlay_ptr = dword(0x5325f0)
g_overlay_type = dword(0x532610)
g_car_id = ptr(dword(0x5A0488), [0x40, 0x0], dword)
in_event = ptr(dword(0x570DFC), [0x1C40], dword) != NULL

function get_event_time()
{
    f0 = float(0x5B2E70)
    f1 = ptr(dword(0x570DFC), [0x1C48], float)
    f2 = ptr(dword(0x570DFC), [0x1C4C], float)
    
    return (f0 - f1) + f2
}

LAST_4 = []
for i in [1, 2, 3, 4]
{
    array_iextend(LAST_4, dict_values(TOLLBOOTHS[i]))
}

achievement(
    id=338015,
    title="One Last Ride",
    description="Complete any Tollbooth event from one of the final 4 Blacklist members in a starter car with no performance upgrades",
    points=10,
    trigger=
        __ornext(any_of(LAST_4, v => g_event_id1 == v || g_event_id2 == v)) &&
        __ornext(any_of([0x2F, 0x4A, 0x44, 0x3E], v => v == g_car_id)) &&
        g_mode == MODE_CAREER &&
        g_player_count == 1 &&
        g_in_game == True &&
        in_event &&
        trigger_when(g_overlay_ptr != NULL && prev(g_overlay_ptr) == NULL) &&
        g_overlay_type == 0 &&
        all_of(range(0, 8-1), i => ptr(dword(0x575DFC), [0x154, 0x118 + i * 4], dword) == 0)
)

function time(m=0,s=0,cs=0)
{
    return {
        "m": m,
        "s": s,
        "cs": cs
    }
}

function time_to_secf(time)
{
    t = time["m"] * 6000 + time["s"] * 100 + time["cs"]
    return t / 100.0
}

function time_to_string(time)
{
    t = time["m"] * 6000 + time["s"] * 100 + time["cs"]
    m = t / 6000
    s = (t % 6000) / 100
    cs = t % 100

    if m == 0
        return format("{0}.{1}{2}", s, if_else(cs < 10, "0", ""), cs)
    return format("{0}:{1}{2}.{3}{4}", m, if_else(s < 10, "0", ""), s, if_else(cs < 10, "0", ""), cs)
}

TIME_TRIAL_PARAMS = [
    {
        "id": 337911,
        "name": "Skyview & Campus",
        "event_text": "(Taz - Race #5)",
        "event_id": TOLLBOOTHS[14][5],
        "time": time(m=1,s=32),
    },
    {
        "id": 337912,
        "name": "Hwy 99 & Highlands",
        "event_text": "(Vic - Race #4)",
        "event_id": TOLLBOOTHS[13][4],
        "time": time(m=1,s=37),
    },
    {
        "id": 337913,
        "name": "Hwy 4 & Forest Green",
        "event_text": "(Vic - Race #5)",
        "event_id": TOLLBOOTHS[13][5],
        "time": time(m=2,s=14),
    },
    {
        "id": 337914,
        "name": "Hwy 99 & Route 55",
        "event_text": "(Izzy - Race #2)",
        "event_id": TOLLBOOTHS[12][2],
        "time": time(m=1,s=50),
    },
    {
        "id": 337915,
        "name": "North Bay & Chase",
        "event_text": "(Izzy - Race #3)",
        "event_id": TOLLBOOTHS[12][3],
        "time": time(m=1,s=50),
    },
    {
        "id": 337916,
        "name": "Chase & Waterfront",
        "event_text": "(Big Lou - Race #4)",
        "event_id": TOLLBOOTHS[11][4],
        "time": time(m=2,s=23),
    },
    {
        "id": 337917,
        "name": "Route 55 & North Bay",
        "event_text": "(Big Lou - Race #5)",
        "event_id": TOLLBOOTHS[11][5],
        "time": time(m=2,s=9),
    },
    {
        "id": 337918,
        "name": "Hwy 99 & Union",
        "event_text": "(Baron - Race #3)",
        "event_id": TOLLBOOTHS[10][3],
        "time": time(m=2,s=19),
    },
    {
        "id": 337919,
        "name": "Waterfront & Bristol",
        "event_text": "(Baron - Race #4)",
        "event_id": TOLLBOOTHS[10][4],
        "time": time(m=2,s=33),
    },
    {
        "id": 337920,
        "name": "Skyview & Waterfront",
        "event_text": "(Earl - Race #3)",
        "event_id": TOLLBOOTHS[9][3],
        "time": time(m=2,s=56),
    },
    {
        "id": 337921,
        "name": "Bristol & Route 55",
        "event_text": "(Earl - Race #6)",
        "event_id": TOLLBOOTHS[9][6],
        "time": time(m=2,s=47),
    },
    {
        "id": 337922,
        "name": "Union & Hwy 99",
        "event_text": "(Jewels - Race #6)",
        "event_id": TOLLBOOTHS[8][6],
        "time": time(m=2,s=14),
    },
    {
        "id": 337923,
        "name": "Waterfront & Hwy 99",
        "event_text": "(Jewels - Race #7)",
        "event_id": TOLLBOOTHS[8][7],
        "time": time(m=2,s=57),
    },
    {
        "id": 337924,
        "name": "Route 55 & Projects",
        "event_text": "(Kaze - Race #2)",
        "event_id": TOLLBOOTHS[7][2],
        "time": time(m=2,s=54),
    },
    {
        "id": 337925,
        "name": "Hwy 201 & Hwy 99",
        "event_text": "(Kaze - Race #4)",
        "event_id": TOLLBOOTHS[7][4],
        "time": time(m=2,s=43),
    },
    {
        "id": 337926,
        "name": "Beach & Skyview",
        "event_text": "(Kaze - Race #9)",
        "event_id": TOLLBOOTHS[7][9],
        "time": time(m=2,s=18),
    },
    {
        "id": 337927,
        "name": "Interchange & Tunnel",
        "event_text": "(Ming - Race #2)",
        "event_id": TOLLBOOTHS[6][2],
        "time": time(m=3,s=1),
    },
    {
        "id": 337928,
        "name": "Penitentiary",
        "event_text": "(Ming - Race #5)",
        "event_id": TOLLBOOTHS[6][5],
        "time": time(m=2,s=50),
    },
    {
        "id": 337929,
        "name": "Hwy 201 & Forest",
        "event_text": "(Ming - Race #11)",
        "event_id": TOLLBOOTHS[6][11],
        "time": time(m=2,s=42),
    },
    {
        "id": 337930,
        "name": "Stadium & Beacon",
        "event_text": "(Webster - Race #6)",
        "event_id": TOLLBOOTHS[5][6],
        "time": time(m=2,s=54),
    },
    {
        "id": 337931,
        "name": "Bay Bridge & Forest",
        "event_text": "(Webster - Race #9)",
        "event_id": TOLLBOOTHS[5][9],
        "time": time(m=3,s=8),
    },
    {
        "id": 337932,
        "name": "Skyview & Coast",
        "event_text": "(Webster - Race #10)",
        "event_id": TOLLBOOTHS[5][10],
        "time": time(m=2,s=14),
    },
    {
        "id": 337933,
        "name": "North Bay & Beacon",
        "event_text": "(JV - Race #1)",
        "event_id": TOLLBOOTHS[4][1],
        "time": time(m=3,s=26),
    },
    {
        "id": 337934,
        "name": "Beacon & Riverfront",
        "event_text": "(JV - Race #10)",
        "event_id": TOLLBOOTHS[4][10],
        "time": time(m=2,s=51),
    },
    {
        "id": 337935,
        "name": "Industrial & Omega",
        "event_text": "(JV - Race #11)",
        "event_id": TOLLBOOTHS[4][11],
        "time": time(m=2,s=57),
    },
    {
        "id": 337936,
        "name": "Petersburg Projects",
        "event_text": "(Ronnie - Race #4)",
        "event_id": TOLLBOOTHS[3][4],
        "time": time(m=3,s=34),
    },
    {
        "id": 337937,
        "name": "Petersburg & Project",
        "event_text": "(Ronnie - Race #9)",
        "event_id": TOLLBOOTHS[3][9],
        "time": time(m=3,s=35),
    },
    {
        "id": 337938,
        "name": "Wharf & North Bay",
        "event_text": "(Ronnie - Race #10)",
        "event_id": TOLLBOOTHS[3][10],
        "time": time(m=3,s=9),
    },
    {
        "id": 337939,
        "name": "Beacon & Petersburg",
        "event_text": "(Bull - Race #3)",
        "event_id": TOLLBOOTHS[2][3],
        "time": time(m=4,s=12),
    },
    {
        "id": 337940,
        "name": "Petersburg & Bond",
        "event_text": "(Bull - Race #4)",
        "event_id": TOLLBOOTHS[2][4],
        "time": time(m=4,s=27),
    },
    {
        "id": 337941,
        "name": "Bond & Beacon Bridge",
        "event_text": "(Bull - Race #5)",
        "event_id": TOLLBOOTHS[2][5],
        "time": time(m=4,s=24),
    },
    {
        "id": 337942,
        "name": "Route 55 & Chase",
        "event_text": "(Razor - Race #6)",
        "event_id": TOLLBOOTHS[1][6],
        "time": time(m=5,s=59),
    },
    {
        "id": 337943,
        "name": "Petersburg & Camdem",
        "event_text": "(Razor - Race #7)",
        "event_id": TOLLBOOTHS[1][7],
        "time": time(m=7,s=27),
    },
    {
        "id": 337944,
        "name": "Marina & Lennox",
        "event_text": "(Razor - Race #11)",
        "event_id": TOLLBOOTHS[1][11],
        "time": time(m=4,s=20),
    },
]

for params in TIME_TRIAL_PARAMS
{
    achievement(
        id=params["id"],
        title=format("Blaze's Times: {0}", params["name"]),
        description=format("Complete {0} {1} in {2} or less", params["name"], params["event_text"], time_to_string(params["time"])),
        points=5,
        trigger=
            g_mode == MODE_CAREER &&
            g_player_count == 1 &&
            g_in_game == True &&
            in_event &&
            __ornext(g_event_id1 == params["event_id"] || g_event_id2 == params["event_id"]) &&
            __ornext(get_event_time() <= time_to_secf(params["time"]) || (g_total_event_time != 0 && g_total_event_time <= time_to_secf(params["time"]))) &&
            trigger_when(g_overlay_ptr != NULL && prev(g_overlay_ptr) == NULL) &&
            g_overlay_type == 0
    )
}
