// The Incredibles
// #ID = 20854

US = 0
REGIONS = [US]

function IsRegion(region)
{
    return true
}

function AntiCheat(region)
{
    // TODO
    return disable_when(always_false(), until=always_true())
}

function LevelComplete(region)
{
    return prev(g_stats_shown[region]) == 0xFFFFFFFF && g_stats_shown[region] <= 7
}

function CLevelStat(addr)
{
    obj = {
        "m_name": addr + 0x0,
        "m_value": float(addr + 0x80),
    }
    
    return obj
}

function GetLevelStat(region, name)
{
    // pairs of [value accessor, condition when that value accessor is valid] because the toolkit is the toolkit
    result = []
    
    for i in range(0, length(g_level_stats[region]) - 1)
    {
        stat = g_level_stats[region][i]
        acc = stat[m_value]
        cond = g_level_stats_length > i && ascii_string_equals(stat[m_name], name, length(name) + 1)
        array_push(result, [acc, cond])
    }
    
    return result
}

function StatToMaxOf(stat) => max_of(array_map(stat, v => measured(v[0], when=v[1])))
function StatToNever(stat, rule) => never(any_of(stat, v => rule(v[0]) && v[1]))

g_level_stats = {
    US: array_map(range(0, 0x10-1), i => CLevelStat(0x6CF090 + i * 0x84)),
}

g_level_stats_length = {
    US: dword(0x631C30),
}

g_stats_shown = {
    US: dword(0x630ABC),
}

g_level_id = {
    US: dword(0x631C54),
}

MISSION_PARAMS = [
    {
        "id": 275544,
        "title": "Bank Heist",
        "name": "Bank Heist",
        "type": "progression",
        "points": 3,
        "level": 1,
    },
    {
        "id": 275545,
        "title": "Skyline Stretch",
        "name": "Skyline Stretch",
        "type": "progression",
        "points": 3,
        "level": 2,
    },
    {
        "id": 275546,
        "title": "Buddy Pine & Bomb Voyage",
        "name": "Buddy Pine & Bomb Voyage",
        "type": "progression",
        "points": 4,
        "level": 3,
    },
    {
        "id": 275547,
        "title": "Apartment Inferno",
        "name": "Apartment Inferno",
        "type": "progression",
        "points": 4,
        "level": 4,
    },
    {
        "id": 275548,
        "title": "Late for School",
        "name": "Late for School",
        "type": "progression",
        "points": 5,
        "level": 5,
    },
    {
        "id": 275549,
        "title": "Beach Landing",
        "name": "Beach Landing",
        "type": "progression",
        "points": 5,
        "level": 6,
    },
    {
        "id": 275550,
        "title": "Nomanisan Island",
        "name": "Nomanisan Island",
        "type": "progression",
        "points": 5,
        "level": 7,
    },
    {
        "id": 275551,
        "title": "Volcanic Eruption",
        "name": "Volcanic Eruption",
        "type": "progression",
        "points": 5,
        "level": 8,
    },
    {
        "id": 275552,
        "title": "Robot Arena",
        "name": "Robot Arena",
        "type": "progression",
        "points": 5,
        "level": 9,
    },
    {
        "id": 275553,
        "title": "Great Falls",
        "name": "Great Falls",
        "type": "progression",
        "points": 5,
        "level": 10,
    },
    {
        "id": 275554,
        "title": "Syndrome's Base",
        "name": "Syndrome's Base",
        "type": "progression",
        "points": 5,
        "level": 11,
    },
    {
        "id": 275555,
        "title": "Finding Mr. Incredible",
        "name": "Finding Mr. Incredible",
        "type": "progression",
        "points": 5,
        "level": 12,
    },
    {
        "id": 275556,
        "title": "100 Mile Dash",
        "name": "100 Mile Dash",
        "type": "progression",
        "points": 5,
        "level": 13,
    },
    {
        "id": 275557,
        "title": "Violet's Crossing",
        "name": "Violet's Crossing",
        "type": "progression",
        "points": 5,
        "level": 14,
    },
    {
        "id": 275558,
        "title": "Incredi-Ball",
        "name": "Incredi-Ball",
        "type": "progression",
        "points": 5,
        "level": 15,
    },
    {
        "id": 275559,
        "title": "Secret Lava Labs",
        "name": "Secret Lava Labs",
        "type": "progression",
        "points": 5,
        "level": 16,
    },
    {
        "id": 275560,
        "title": "Rocket Silo",
        "name": "Rocket Silo",
        "type": "progression",
        "points": 5,
        "level": 17,
    },
    {
        "id": 275561,
        "title": "Save the World",
        "name": "Save the World",
        "type": "win_condition",
        "points": 10,
        "level": 18,
    },
]

for params in MISSION_PARAMS
{
    achievement(
        id=params["id"],
        title=params["title"],
        description=format("Finish the mission \"{0}\".", params["name"]),
        type=params["type"],
        points=params["points"],
        trigger=any_of(REGIONS, region =>
            IsRegion(region) &&
            AntiCheat(region) &&
            g_level_id[region] == params["level"] &&
            LevelComplete(region)
        )
    )
}


achievement(
    title = "Faster than a Helicopter", points = 5,
    description = "Beat Bank Heist in 4:50 or less.",
    id = 275542, badge = "305180", published = "12/28/2022 7:19:22 PM", modified = "5/3/2024 10:10:43 AM",
    trigger = always_true()
)

achievement(
    title = "Faster than a Helicopter II", points = 5,
    description = "Beat Skyline Stretch in 4:20 or less.",
    id = 275543, badge = "305181", published = "12/28/2022 7:54:23 PM", modified = "5/3/2024 10:10:43 AM",
    trigger = always_true()
)

achievement(
    title = "Careful With the Heights!", points = 5,
    description = "Beat Buddy Pine & Bomb Voyage with 0 Damage Received.",
    id = 275530, badge = "304994", published = "12/28/2022 10:45:35 AM", modified = "5/3/2024 10:10:43 AM",
    trigger =always_true()
)

achievement(
    title = "Not My Fault!", points = 5,
    description = "Beat Apartment Inferno without punching anyone.",
    id = 275589, badge = "304998", published = "12/28/2022 9:41:25 PM", modified = "5/3/2024 10:10:44 AM",
    trigger =always_true()
)

achievement(
    title = "The Dash Inflation Incident I", points = 25,
    description = "Beat Late for School using both SASSMODE and EINSTEINIUM secrets activated right from the start.",
    id = 275518, badge = "304990", published = "12/28/2022 6:09:28 AM", modified = "5/3/2024 10:10:44 AM",
    trigger = always_true()
)

achievement(
    title = "I'm the King of Cellulite", points = 3,
    description = "Reach the first Beach Landing checkpoint without losing 35 or more calories.",
    id = 275216, badge = "304977", published = "12/27/2022 2:13:36 AM", modified = "5/3/2024 10:10:27 AM",
    trigger = always_true()
)

achievement(
    title = "My Zippers Bust, My Buckles Break", points = 5,
    description = "Reach the second Beach Landing checkpoint without losing 200 or more calories.",
    id = 275179, badge = "304974", published = "12/26/2022 11:41:14 PM", modified = "5/3/2024 10:10:27 AM",
    trigger = always_true()
)

achievement(
    title = "The Pavement Cracks When I Fall Down", points = 10,
    description = "Reach the last Beach Landing checkpoint without losing 300 or more calories.",
    id = 275180, badge = "304973", published = "12/26/2022 11:41:14 PM", modified = "5/3/2024 10:10:28 AM",
    trigger = always_true()
)

achievement(
    title = "I've Got More Chins Than Chinatown", points = 3,
    description = "Reach the first Nomanisan Island checkpoint without losing 50 or more calories.",
    id = 275214, badge = "304975", published = "12/27/2022 2:13:35 AM", modified = "5/3/2024 10:10:28 AM",
    trigger = always_true()
)

achievement(
    title = "I've Never Seen My Toes", points = 3,
    description = "Reach the second Nomanisan Island checkpoint without losing 80 or more calories.",
    id = 275215, badge = "304976", published = "12/27/2022 2:13:35 AM", modified = "5/3/2024 10:10:29 AM",
    trigger = always_true()
)

achievement(
    title = "When I'm Going to the Movies, I Take Up Seven Rows", points = 10,
    description = "Reach the last Nomanisan Island checkpoint without losing 105 or more calories.",
    id = 275217, badge = "304980", published = "12/27/2022 2:13:36 AM", modified = "5/3/2024 10:10:29 AM",
    trigger = always_true()
)

achievement(
    title = "He's a Fat Boy But He's Moving Like Beyonce", points = 25,
    description = "Finish Volcanic Eruption without losing 75 or more calories.",
    id = 275218, badge = "304981", published = "12/27/2022 2:13:36 AM", modified = "5/3/2024 10:10:29 AM",
    trigger = always_true()
)

achievement(
    title = "Robot Expert", points = 10,
    description = "Beat Robot Arena in 5:00 or less.",
    id = 275598, badge = "305179", published = "12/28/2022 11:16:25 PM", modified = "5/3/2024 10:10:30 AM",
    trigger = always_true()
)

achievement(
    title = "You Upgraded? I Also Did!", points = 5,
    description = "Beat Great Falls with 0 Damage Received.",
    id = 275599, badge = "305002", published = "12/28/2022 11:39:22 PM", modified = "5/3/2024 10:10:30 AM",
    trigger = always_true()
)

achievement(
    title = "Stealth", points = 5,
    description = "Reach the first checkpoint in Syndrome's Base without taking damage.",
    id = 275740, badge = "305153", published = "12/29/2022 12:48:55 AM", modified = "5/3/2024 10:10:30 AM",
    trigger = always_true()
)

achievement(
    title = "Unpowered", points = 5,
    description = "Beat Finding Mr. Incredible without letting your Incredi-Power go full.",
    id = 275741, badge = "305152", published = "12/29/2022 1:37:50 AM", modified = "5/3/2024 10:10:31 AM",
    trigger = always_true()
)

achievement(
    title = "The Dash Inflation Incident II", points = 25,
    description = "Beat 100 Mile Dash using both SASSMODE and EINSTEINIUM secrets activated right from the start.",
    id = 275519, badge = "304991", published = "12/28/2022 6:12:37 AM", modified = "5/3/2024 10:10:31 AM",
    trigger = always_true()
)

achievement(
    title = "I Got to Stay Hidden", points = 5,
    description = "Beat Violet's Crossing in 3:45 or less.",
    id = 275781, badge = "305177", published = "12/29/2022 3:10:29 AM", modified = "5/3/2024 10:10:31 AM",
    trigger = always_true()
)

achievement(
    title = "Ballin'", points = 5,
    description = "Beat Incredi-Ball in 4:50 or less.",
    id = 275794, badge = "305178", published = "12/29/2022 3:45:18 AM", modified = "5/3/2024 10:10:32 AM",
    trigger = always_true()
)

achievement(
    title = "Mission 51", points = 5,
    description = "Beat Secret Lava Labs without letting your Incredi-Power go full.",
    id = 275795, badge = "305182", published = "12/29/2022 3:52:13 AM", modified = "5/3/2024 10:10:32 AM",
    trigger = always_true()
)

achievement(
    title = "É Um Siloda Bino", points = 5,
    description = "Beat Rocket Silo using SASSMODE secret activated right from the start.",
    id = 275796, badge = "305183", published = "12/29/2022 5:21:05 AM", modified = "5/3/2024 10:10:32 AM",
    trigger = always_true()
)

achievement(
    title = "Quick End", points = 10, type="win_condition",
    description = "Beat Save the World in 7:00 or less.",
    id = 275797, badge = "305185", published = "12/29/2022 5:32:25 AM", modified = "5/3/2024 10:10:33 AM",
    trigger = always_true()
)

achievement(
    title = "Showtime!", points = 2,
    description = "Reach the best combo rating.",
    id = 275314, badge = "305150", published = "12/27/2022 7:16:07 PM", modified = "5/3/2024 10:10:33 AM",
    trigger = always_true()
)

achievement(
    title = "OOOOOOOOOOOOOO", points = 1,
    description = "Use the EMODE secret.",
    id = 275444, badge = "304989", published = "12/28/2022 2:52:16 AM", modified = "5/3/2024 10:10:33 AM",
    trigger = always_true()
)

achievement(
    title = "Damn Frozone, You Said It Was Coffee...", points = 1,
    description = "Use the DISCORULES secret during the Apartment Inferno mission.",
    id = 275526, badge = "305186", published = "12/28/2022 6:36:24 AM", modified = "5/3/2024 10:10:34 AM",
    trigger = always_true()
)

achievement(
    title = "Unstoppable Force", points = 1,
    description = "Use the ATHLETESFOOT secret during the Incredi-Ball mission and make a trail of fire.",
    id = 275424, badge = "305187", published = "12/27/2022 11:34:21 PM", modified = "5/3/2024 10:10:34 AM",
    trigger = always_true()
)

achievement(
    title = "Half-Invisible", points = 1,
    description = "Use the DEEVOLVE secret during the Violet's Crossing mission.",
    id = 275527, badge = "305188", published = "12/28/2022 6:55:40 AM", modified = "5/3/2024 10:10:34 AM",
    trigger = always_true()
)

achievement(
    title = "Tribute", points = 1,
    description = "Use the GAZERBEAM secret in Great Falls.",
    id = 275600, badge = "305001", published = "12/28/2022 11:39:23 PM", modified = "5/3/2024 10:10:35 AM",
    trigger = always_true()
)

achievement(
    title = "Manic for More!", points = 2,
    description = "Collect all the bonuses in any of the missions.",
    id = 275562, badge = "304939", published = "12/28/2022 8:20:25 PM", modified = "5/3/2024 10:10:35 AM",
    trigger = always_true()
)

achievement(
    title = "Number One Fran!", points = 25,
    description = "Collect all the bonuses in the story game!",
    id = 275563, badge = "304940", published = "12/28/2022 8:20:26 PM", modified = "5/3/2024 10:10:35 AM",
    trigger = always_true()
)

achievement(
    title = "Incredible!", points = 10,
    description = "Collect all Mr. Incredible Battle Mode Bonuses.",
    id = 275564, badge = "304942", published = "12/28/2022 8:30:50 PM", modified = "5/3/2024 10:10:44 AM",
    trigger = always_true()
)

achievement(
    title = "Flexible!", points = 10,
    description = "Collect all Elastigirl Battle Mode Bonuses.",
    id = 275565, badge = "304943", published = "12/28/2022 8:30:50 PM", modified = "5/3/2024 10:10:45 AM",
    trigger = always_true()
)

achievement(
    title = "No Sense Lettin' All This Go to Waste", points = 3,
    description = "Lose 10,000 calories as fat Mr. Incredible.",
    id = 274766, badge = "304970", published = "12/24/2022 6:32:04 PM", modified = "5/3/2024 10:10:45 AM",
    trigger = always_true()
)

achievement(
    title = "Jumper", points = 1,
    description = "Watch the video: \"Jumper\".",
    id = 275281, badge = "304983", published = "12/27/2022 4:32:08 PM", modified = "5/3/2024 10:10:36 AM",
    trigger = always_true()
)

achievement(
    title = "Welcome Back", points = 1,
    description = "Watch the video: \"Welcome Back\".",
    id = 275282, badge = "304984", published = "12/27/2022 4:40:33 PM", modified = "5/3/2024 10:10:36 AM",
    trigger = always_true()
)

achievement(
    title = "Are We There Yet?", points = 1,
    description = "Watch the video: \"Are We There Yet?\".",
    id = 275283, badge = "304985", published = "12/27/2022 4:40:33 PM", modified = "5/3/2024 10:10:37 AM",
    trigger = always_true()
)

leaderboard(
    id = 53258, title = "Bank Heist - Best Time",
    description = "Your personal best time in this mission.",
    start  = always_true(),
    cancel = always_true(),
    submit = always_true(),
    value  = 0,
    format = "SECS", lower_is_better = true
)

leaderboard(
    id = 53259, title = "Skyline Stretch - Best Time",
    description = "Your personal best time in this mission.",
    start  = always_true(),
    cancel = always_true(),
    submit = always_true(),
    value  = 0,
    format = "SECS", lower_is_better = true
)

leaderboard(
    id = 53260, title = "Buddy Pine & Bomb Voyage - Best Time",
    description = "Your personal best time in this mission.",
    start  = always_true(),
    cancel = always_true(),
    submit = always_true(),
    value  = 0,
    format = "SECS", lower_is_better = true
)

leaderboard(
    id = 53261, title = "Apartment Inferno - Best Time",
    description = "Your personal best time in this mission.",
    start  = always_true(),
    cancel = always_true(),
    submit = always_true(),
    value  = 0,
    format = "SECS", lower_is_better = true
)

leaderboard(
    id = 53262, title = "Late for School - Best Time",
    description = "Your personal best time in this mission.",
    start  = always_true(),
    cancel = always_true(),
    submit = always_true(),
    value  = 0,
    format = "SECS", lower_is_better = true
)

leaderboard(
    id = 53263, title = "Beach Landing - Best Time",
    description = "Your personal best time in this mission.",
    start  = always_true(),
    cancel = always_true(),
    submit = always_true(),
    value  = 0,
    format = "SECS", lower_is_better = true
)

leaderboard(
    id = 53264, title = "Nomanisan Island - Best Time",
    description = "Your personal best time in this mission.",
    start  = always_true(),
    cancel = always_true(),
    submit = always_true(),
    value  = 0,
    format = "SECS", lower_is_better = true
)

leaderboard(
    id = 53265, title = "Volcanic Eruption - Best Time",
    description = "Your personal best time in this mission.",
    start  = always_true(),
    cancel = always_true(),
    submit = always_true(),
    value  = 0,
    format = "SECS", lower_is_better = true
)

leaderboard(
    id = 53266, title = "Robot Arena - Best Time",
    description = "Your personal best time in this mission.",
    start  = always_true(),
    cancel = always_true(),
    submit = always_true(),
    value  = 0,
    format = "SECS", lower_is_better = true
)

leaderboard(
    id = 53267, title = "Great Falls - Best Time",
    description = "Your personal best time in this mission.",
    start  = always_true(),
    cancel = always_true(),
    submit = always_true(),
    value  = 0,
    format = "SECS", lower_is_better = true
)

leaderboard(
    id = 53268, title = "Syndrome's Base - Best Time",
    description = "Your personal best time in this mission.",
    start  = always_true(),
    cancel = always_true(),
    submit = always_true(),
    value  = 0,
    format = "SECS", lower_is_better = true
)

leaderboard(
    id = 53269, title = "Finding Mr. Incredible - Best Time",
    description = "Your personal best time in this mission.",
    start  = always_true(),
    cancel = always_true(),
    submit = always_true(),
    value  = 0,
    format = "SECS", lower_is_better = true
)

leaderboard(
    id = 53270, title = "100 Mile Dash - Best Time",
    description = "Your personal best time in this mission.",
    start  = always_true(),
    cancel = always_true(),
    submit = always_true(),
    value  = 0,
    format = "SECS", lower_is_better = true
)

leaderboard(
    id = 53271, title = "Violet's Crossing - Best Time",
    description = "Your personal best time in this mission.",
    start  = always_true(),
    cancel = always_true(),
    submit = always_true(),
    value  = 0,
    format = "SECS", lower_is_better = true
)

leaderboard(
    id = 53272, title = "Incredi-Ball - Best Time",
    description = "Your personal best time in this mission.",
    start  = always_true(),
    cancel = always_true(),
    submit = always_true(),
    value  = 0,
    format = "SECS", lower_is_better = true
)

leaderboard(
    id = 53273, title = "Secret Lava Labs - Best Time",
    description = "Your personal best time in this mission.",
    start  = always_true(),
    cancel = always_true(),
    submit = always_true(),
    value  = 0,
    format = "SECS", lower_is_better = true
)

leaderboard(
    id = 53274, title = "Rocket Silo - Best Time",
    description = "Your personal best time in this mission.",
    start  = always_true(),
    cancel = always_true(),
    submit = always_true(),
    value  = 0,
    format = "SECS", lower_is_better = true
)

leaderboard(
    id = 53275, title = "Save the World - Best Time",
    description = "Your personal best time in this mission.",
    start  = always_true(),
    cancel = always_true(),
    submit = always_true(),
    value  = 0,
    format = "SECS", lower_is_better = true
)

leaderboard(
    id = 53276, title = "Battle Mode - Best Time",
    description = "Your personal best time in this mission.",
    start  = always_true(),
    cancel = always_true(),
    submit = always_true(),
    value  = 0,
    format = "SECS", lower_is_better = true
)

