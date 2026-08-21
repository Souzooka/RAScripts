// Felony 11-79
// #ID = 5531

function AntiBios()
{
    return ascii_string_equals(0x9A648, "RUNA")
}

function LevelComplete(level_id, now=true)
{
    cond = g_level_id == level_id && g_level_state == LEVELSTATE_COMPLETE
    if (now)
    {
        cond = cond && prev(g_level_state) == LEVELSTATE_NORMAL
    }
    
    return cond
}

function IsCarUnlocked(car_id, now=false)
{
    val = dword(g_car_unlock_arr + car_id * 4)
    cond = var == 1
    if (now)
    {
        cond = cond && prev(val) == 0
    }
    
    return cond
}

function IGT2Frames()
{
    return
        g_time_minutes * (60 * 60) +
        g_time_seconds * (60) +
        g_time_frames * 2
}

g_car_unlock_arr = 0x70b84

g_level_id = dword(0x9A738)

g_game_mode = dword(0x9AD78)
GAME_MODE_NORMAL = 0x0
GAME_MODE_TIME_TRIAL = 0x1

g_level_state = dword(0x9AE18)
LEVELSTATE_NORMAL = 0x0
LEVELSTATE_COMPLETE = 0x1

CAR_RCC = 0x15

g_total_damage = dword(0x9AEF8)

// Time
g_time_minutes = word(0xA3414)
g_time_seconds = word(0xA3416)
g_time_frames = word(0xA3418)

achievement(
    title = "Jade Statue", points = 5, type="progression",
    description = "Complete level 1",
    id = 139421, badge = "155048", published = "1/22/2021 5:49:44 PM", modified = "8/28/2023 3:45:29 PM",
    trigger = byte(0x09A738) == 1 && prev(byte(0x0B2086)) == 11 && byte(0x0B2086) == 10
)

achievement(
    title = "Golden Wings", points = 5, type="progression",
    description = "Complete stage 2",
    id = 139422, badge = "155049", published = "1/22/2021 5:49:49 PM", modified = "8/28/2023 3:45:33 PM",
    trigger = byte(0x09A738) == 2 && prev(byte(0x0B2086)) == 11 && byte(0x0B2086) == 10
)

achievement(
    title = "Silver Staff", points = 10, type="win_condition",
    description = "Complete level 3",
    id = 139423, badge = "155050", published = "1/22/2021 5:49:53 PM", modified = "8/28/2023 3:45:47 PM",
    trigger = byte(0x09A738) == 3 && prev(byte(0x0B2086)) == 11 && byte(0x0B2086) == 10
)

achievement(
    title = "Down Town Speedrun", points = 10,
    description = "Beat level 1 within 4 mins",
    id = 139424, badge = "155051", published = "1/22/2021 5:49:56 PM", modified = "1/22/2021 5:49:56 PM",
    trigger = byte(0x09A738) == 1 && prev(byte(0x0B2086)) == 11 && byte(0x0B2086) == 10 && byte(0x0A3414) < 4
)

achievement(
    title = "Sea Side Speedrun", points = 10,
    description = "Beat level 2 within 4 mins",
    id = 139425, badge = "155052", published = "1/22/2021 5:50:01 PM", modified = "1/22/2021 5:50:01 PM",
    trigger = byte(0x09A738) == 2 && prev(byte(0x0B2086)) == 11 && byte(0x0B2086) == 10 && byte(0x0A3414) < 4
)

achievement(
    title = "Paris Speedrun", points = 10,
    description = "Beat level 3 within 4 mins",
    id = 139426, badge = "155053", published = "1/22/2021 5:50:05 PM", modified = "1/22/2021 5:50:05 PM",
    trigger = byte(0x09A738) == 3 && prev(byte(0x0B2086)) == 11 && byte(0x0B2086) == 10 && byte(0x0A3414) < 4
)

achievement(
    title = "Down Town Destruction", points = 10,
    description = "Complete level 1 with over $1,000,000 in damages",
    id = 139427, badge = "155054", published = "1/22/2021 5:50:09 PM", modified = "1/22/2021 5:50:09 PM",
    trigger = byte(0x09A738) == 1 && prev(byte(0x0B2086)) == 11 && byte(0x0B2086) == 10 && dword(0x09AEF8) >= 1000000
)

achievement(
    title = "Sea Side Destruction", points = 10,
    description = "Complete level 2 with over $2,500,000 in damages",
    id = 139428, badge = "155055", published = "1/22/2021 5:50:13 PM", modified = "1/22/2021 5:50:13 PM",
    trigger = byte(0x09A738) == 2 && prev(byte(0x0B2086)) == 11 && byte(0x0B2086) == 10 && dword(0x09AEF8) >= 2500000
)

achievement(
    title = "Paris Destruction", points = 10,
    description = "Complete level 3 with over $2,500,000 in damages",
    id = 139429, badge = "155056", published = "1/22/2021 5:50:17 PM", modified = "1/22/2021 5:50:17 PM",
    trigger = byte(0x09A738) == 3 && prev(byte(0x0B2086)) == 11 && byte(0x0B2086) == 10 && dword(0x09AEF8) >= 2500000
)

achievement(
    title = "Down Town Pacifist", points = 10,
    description = "Complete level 1 without causing any property damage",
    id = 139432, badge = "155059", published = "1/22/2021 5:50:29 PM", modified = "1/22/2021 5:50:29 PM",
    trigger = dword(0x09AD78) == 0 && byte(0x09A738) == 1 && prev(byte(0x0B2086)) == 11 && byte(0x0B2086) == 10 &&
              dword(0x09AEF8) == 0
)

achievement(
    title = "Sea Side Pacifist", points = 10,
    description = "Complete level 2 without causing any property damage",
    id = 139433, badge = "155060", published = "1/22/2021 5:50:32 PM", modified = "1/22/2021 5:50:32 PM",
    trigger = dword(0x09AD78) == 0 && byte(0x09A738) == 2 && prev(byte(0x0B2086)) == 11 && byte(0x0B2086) == 10 &&
              dword(0x09AEF8) == 0
)

achievement(
    title = "Paris Pacifist", points = 10,
    description = "Complete level 3 without causing any property damage",
    id = 139434, badge = "155061", published = "1/22/2021 5:50:36 PM", modified = "1/22/2021 5:50:36 PM",
    trigger = dword(0x09AD78) == 0 && byte(0x09A738) == 3 && prev(byte(0x0B2086)) == 11 && byte(0x0B2086) == 10 &&
              dword(0x09AEF8) == 0
)

achievement(
    title = "Speeding", points = 10,
    description = "Go over 111 mph on the freeway on level 2 and complete the level",
    id = 139430, badge = "155057", published = "1/22/2021 5:50:21 PM", modified = "1/22/2021 5:50:21 PM",
    trigger = byte(0x09A738) == 2 && prev(byte(0x0B2086)) == 11 && byte(0x0B2086) == 10 && word(0x0B54E0) >= 178
)

achievement(
    title = "Fire Up The Roof", points = 10,
    description = "Go over 142 mph on the freeway on level 2 and complete the level",
    id = 139431, badge = "155058", published = "1/22/2021 5:50:25 PM", modified = "1/22/2021 5:50:25 PM",
    trigger = byte(0x09A738) == 2 && prev(byte(0x0B2086)) == 11 && byte(0x0B2086) == 10 && word(0x0B54E0) >= 228
)

achievement(
    title = "Cute Toy", points = 5,
    description = "Collect the toy car in level 3 and complete the level",
    id = 139435, badge = "155062", published = "1/22/2021 5:50:40 PM", modified = "1/22/2021 5:50:40 PM",
    trigger = byte(0x09A738) == 3 && prev(byte(0x0B2086)) == 11 && byte(0x0B2086) == 10 && byte(0x1E583E) == 1
)

LEVELS = [
    {
        "id": 1,
        "name": "Down Town",
        "lb_id": 170019,
        "lb_pacifist_id": 170020,
    },
    {
        "id": 2,
        "name": "Sea Side",
        "lb_id": 170021,
        "lb_pacifist_id": 170022,
    },
    {
        "id": 3,
        "name": "Paris",
        "lb_id": 170023,
        "lb_pacifist_id": 170024,
    }
]

for params in LEVELS
{
    leaderboard(
        id=params["lb_id"],
        title=format("{0} - Fastest Time", params["name"]),
        description=format("Complete \"{0}\" within the fastest time!", params["name"]),
        format="FRAMES",
        lower_is_better=true,
        start=
            AntiBios() &&
            LevelComplete(params["id"], now=true),
        cancel=always_false(),
        submit=always_true(),
        value=IGT2Frames()
    )
    
    leaderboard(
        id=params["lb_pacifist_id"],
        title=format("{0} (Pacifist) - Fastest Time", params["name"]),
        description=format("Complete \"{0}\" within the fastest time and $0 in damages!", params["name"]),
        format="FRAMES",
        lower_is_better=true,
        start=
            AntiBios() &&
            LevelComplete(params["id"], now=true) &&
            g_game_mode == GAME_MODE_NORMAL &&
            g_total_damage == 0,
        cancel=always_false(),
        submit=always_true(),
        value=IGT2Frames()
    )
}
