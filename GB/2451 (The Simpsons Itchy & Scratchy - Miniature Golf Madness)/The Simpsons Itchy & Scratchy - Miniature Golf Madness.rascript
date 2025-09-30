// The Simpsons: Itchy & Scratchy - Miniature Golf Madness
// #ID = 2461

DEV_CHEAT = false
ALT_GROUP_OPTIMIZATION_BUG = 1 // Needs manual fix for collection achievements if 1

function if_else(cond, a, b)
{
    if cond
        return a
    return b
}

g_hole = byte(0xd5cb)
g_current_score = byte(0xDC86)
g_scores = array_map(range(0, 8), i => byte(0xD5CD + i))
g_continues = byte(0xD5CC)
g_cheats = {
    "invuln": byte(0xD5BC),
    "level_select": byte(0xD5BB),
}

function AntiCheat(allowed_cheats=[])
{
    if DEV_CHEAT
        return true
    
    cond = always_true()
    for cheat in g_cheats
    {
        if !any_of(allowed_cheats, c => c == cheat)
        {
            cond = cond && g_cheats[cheat] == 0
        }
    }
    
    return cond
}

function AntiBios()
{
    return never(!(g_hole <= 8))
}

function InGame(now=false)
{
    if now
        return byte(0xdce7) > prev(byte(0xdce7))
    return byte(0xdce7) == 1
}

hole_params = [
    {
        "id": 72015,
        "par_id": 72042,
        "leaderboard_id": 5037,
        "title": "Grim Furry Tales",
        "par_title": "Loremaster",
        "points": 5,
        "hole": 0,
        "par": 0x16,
        "record": 0x18,
    },
    {
        "id": 72016,
        "par_id": 72043,
        "leaderboard_id": 5038,
        "title": "Malice in Krustyland",
        "par_title": "Krustmaster",
        "points": 5,
        "hole": 1,
        "par": 0x15,
        "record": 0x16,
    },
    {
        "id": 72017,
        "par_id": 72044,
        "leaderboard_id": 5039,
        "title": "Rest in Pieces",
        "par_title": "Grim Keeper",
        "points": 5,
        "hole": 2,
        "par": 0x9,
        "record": 0x13,
    },
    {
        "id": 72018,
        "par_id": 72045,
        "leaderboard_id": 5040,
        "title": "Pirates of the Scratchibbean",
        "par_title": "Bart Pigeon",
        "points": 5,
        "hole": 3,
        "par": 0x25,
        "record": 0x26,
    },
    {
        "id": 72019,
        "par_id": 72046,
        "leaderboard_id": 5041,
        "title": "I Scream of Genie",
        "par_title": "Aladdin",
        "points": 5,
        "hole": 4,
        "par": 0x22,
        "record": 0x24,
    },
    {
        "id": 72020,
        "par_id": 72047,
        "leaderboard_id": 5043,
        "title": "Chop-A-Long Scratchidy",
        "par_title": "Quickdraw",
        "points": 5,
        "hole": 5,
        "par": 0x24,
        "record": 0x27,
    },
    {
        "id": 72021,
        "par_id": 72048,
        "leaderboard_id": 5042,
        "title": "Patty Meltdown",
        "par_title": "Nuketown",
        "points": 5,
        "hole": 6,
        "par": 0x23,
        "record": 0x26,
    },
    {
        "id": 72022,
        "par_id": 72049,
        "leaderboard_id": 5044,
        "title": "20,000 Mice Under the Sea",
        "par_title": "Waterbreathing",
        "points": 5,
        "hole": 7,
        "par": 0x25,
        "record": 0x29,
    },
    {
        "id": 72023,
        "par_id": 72050,
        "leaderboard_id": 5046,
        "title": "9 1/2 Shrieks",
        "par_title": "No Fear",
        "points": 10,
        "hole": 8,
        "par": 0x28,
        "record": 0x32,
    },
]

for params in hole_params
{
    // Complete
    achievement(
        id=params["id"],
        title=params["title"],
        description=format("Complete Hole {0}", params["hole"] + 1),
        points=params["points"],
        type=if_else(params["hole"] == 8, "win_condition", "progression"),
        trigger=
            AntiCheat() &&
            AntiBios() &&
            g_scores[params["hole"]] > prev(g_scores[params["hole"]])
    )
    
    // Under par
    achievement(
        id=params["par_id"],
        title=params["par_title"],
        description=format("Beat Hole {0} at or below par (level select allowed)", params["hole"] + 1),
        points=10,
        trigger=
            AntiCheat(allowed_cheats=["level_select"]) &&
            AntiBios() &&
            once(InGame(now=true)) &&
            never(!InGame()) &&
            g_hole == params["hole"] &&
            trigger_when(g_scores[params["hole"]] > prev(g_scores[params["hole"]])) &&
            g_current_score < params["par"]
    )
    
    // Leaderboard
    leaderboard(
        id=params["leaderboard_id"],
        title=format("Hole {0}", params["hole"] + 1),
        description=format("Lowest score for hole {0}", params["hole"] + 1),
        lower_is_better=true,
        start=
            AntiCheat(allowed_cheats=["level_select"]) &&
            AntiBios() &&
            InGame(now=true) &&
            g_hole == params["hole"],
        cancel=
            !InGame() ||
            g_hole != params["hole"],
        submit=
            g_scores[params["hole"]] > prev(g_scores[params["hole"]]),
        value=
            bcd(g_current_score)
    )
}

// Jack Nicklaus
achievement(
    id=72053,
    title="Jack Nicklaus",
    description="Beat the game without using a continue",
    points=25,
    trigger=
        AntiCheat() &&
        AntiBios() &&
        g_continues == 2 &&
        g_scores[length(g_scores) - 1] > prev(g_scores[length(g_scores) - 1])
)

// Tiger Woods
conds = array_map(range(0, length(g_scores) - 1), hole =>
    once(g_scores[hole] > 0 && g_scores[hole] <= hole_params[hole]["record"])
)
achievement(
    id=72054,
    title="Tiger Woods",
    description="Beat the game with each of your scores at or below the default records",
    points=50,
    trigger=
        AntiCheat() &&
        AntiBios() &&
        never(g_scores[0] == 0) && // just checks if the game was reset via completion
        measured(tally(length(conds), conds)) &&
        g_scores[length(g_scores) - 1] > prev(g_scores[length(g_scores) - 1])
)

// Collectible achievements
// These are kind of done in a funky/hacky way. There seems to be a collection of bitflags at around ~0xCF00 which record
// if items were actually picked up, but they're also set to on when the item spawns as well, which would make measureds difficult
// (Also detecting the exact time one is picked up in general difficult)
// I'll just leave these as is for now with the bios check

achievement(
    title = "Collector", points = 5,
    description = "Pick up all of the items in stage 1 and complete the level (minus the erasers, level select allowed)",
    id = 72024, badge = "77249", published = "2/16/2019 7:38:37 PM", modified = "10/18/2019 1:37:01 AM",
    trigger = AntiBios() && AntiCheat(allowed_cheats=["level_select"]) &&
              byte(0x00D5CB) == 0 && once(byte(0x00DCC9) == 192) && once(byte(0x00DCE9) == 6) &&
              once(byte(0x00DCED) == 6) && byte(0x00D5BC) == 0 && never(prev(byte(0x00D5CB)) != byte(0x00D5CB)) &&
              never(byte(0x00DC87) == 222) && prev(byte(0x00D5CD)) != byte(0x00D5CD) &&
              ((repeated(3, prev(byte(0x00D5CA)) < byte(0x00D5CA)) && byte(0x00DC86) <= 22) ||
               (repeated(2, prev(byte(0x00D5CA)) < byte(0x00D5CA)) && byte(0x00DC86) > 22 + ALT_GROUP_OPTIMIZATION_BUG))
)

achievement(
    title = "Gatherer", points = 5,
    description = "Pick up all of the items in stage 2 and complete the level (minus the erasers, level select allowed)",
    id = 72025, badge = "77248", published = "2/16/2019 7:38:44 PM", modified = "10/18/2019 1:37:01 AM",
    trigger = AntiBios() && AntiCheat(allowed_cheats=["level_select"]) &&
              byte(0x00D5CB) == 1 && once(byte(0x00DCE9) == 6) && once(byte(0x00DCED) == 6) && once(byte(0x00DCEB) == 6) &&
              never(prev(byte(0x00D5CB)) != byte(0x00D5CB)) &&
              never(prev(byte(0x00D5CC)) != byte(0x00D5CC)) && prev(byte(0x00D5CE)) != byte(0x00D5CE) &&
              ((repeated(3, prev(byte(0x00D5CA)) < byte(0x00D5CA)) && byte(0x00DC86) <= 21) ||
               (repeated(2, prev(byte(0x00D5CA)) < byte(0x00D5CA)) && byte(0x00DC86) > 21 + ALT_GROUP_OPTIMIZATION_BUG))
)

achievement(
    title = "Hobbyist", points = 5,
    description = "Pick up all of the items in stage 3 and complete the level (minus the erasers, level select allowed)",
    id = 72026, badge = "77273", published = "2/16/2019 7:38:48 PM", modified = "10/18/2019 1:37:01 AM",
    trigger = AntiBios() && AntiCheat(allowed_cheats=["level_select"]) &&
              byte(0x00D5CB) == 2 && once(byte(0x00DCEA) == 6) && once(byte(0x00DCE8) == 6) &&
              never(prev(byte(0x00D5CB)) != byte(0x00D5CB)) && never(prev(byte(0x00D5CC)) != byte(0x00D5CC)) &&
              prev(byte(0x00D5CF)) != byte(0x00D5CF) &&
              ((repeated(3, prev(byte(0x00D5CA)) < byte(0x00D5CA)) && byte(0x00DC86) <= 9) ||
               (repeated(2, prev(byte(0x00D5CA)) < byte(0x00D5CA)) && byte(0x00DC86) > 9 + ALT_GROUP_OPTIMIZATION_BUG))
)

achievement(
    title = "Accumulator", points = 5,
    description = "Pick up all of the items in stage 4 and complete the level (minus the erasers, level select allowed)",
    id = 72027, badge = "77277", published = "2/16/2019 7:39:01 PM", modified = "2/18/2019 2:47:38 AM",
    trigger = AntiBios() && AntiCheat(allowed_cheats=["level_select"]) &&
              byte(0x00D5CB) == 3 && once(byte(0x00DCED) == 6) && once(byte(0x00DCEB) == 6) &&
              never(prev(byte(0x00D5CB)) != byte(0x00D5CB)) && never(prev(byte(0x00D5CC)) != byte(0x00D5CC)) &&
              prev(byte(0x00D5D0)) != byte(0x00D5D0) &&
              ((repeated(3, prev(byte(0x00D5CA)) < byte(0x00D5CA)) && byte(0x00DC86) <= 37) ||
               (repeated(2, prev(byte(0x00D5CA)) < byte(0x00D5CA)) && byte(0x00DC86) > 37 + ALT_GROUP_OPTIMIZATION_BUG))
)

achievement(
    title = "Enumerator", points = 5,
    description = "Pick up all of the items in stage 5 and complete the level (minus the erasers, level select allowed)",
    id = 72028, badge = "77275", published = "2/16/2019 7:39:07 PM", modified = "10/18/2019 1:37:01 AM",
    trigger = AntiBios() && AntiCheat(allowed_cheats=["level_select"]) &&
              byte(0x00D5CB) == 4 && once(byte(0x00DCEA) == 6) && once(byte(0x00DCEC) == 6) &&
              never(prev(byte(0x00D5CB)) != byte(0x00D5CB)) && never(prev(byte(0x00D5CC)) != byte(0x00D5CC)) &&
              prev(byte(0x00D5D1)) != byte(0x00D5D1) &&
              ((repeated(3, prev(byte(0x00D5CA)) < byte(0x00D5CA)) && byte(0x00DC86) <= 34) ||
               (repeated(2, prev(byte(0x00D5CA)) < byte(0x00D5CA)) && byte(0x00DC86) > 34 + ALT_GROUP_OPTIMIZATION_BUG))
)

achievement(
    title = "Compiler", points = 5,
    description = "Pick up all of the items in stage 6 and complete the level (minus the erasers, level select allowed)",
    id = 72029, badge = "77278", published = "2/16/2019 7:39:13 PM", modified = "2/18/2019 2:47:42 AM",
    trigger = AntiBios() && AntiCheat(allowed_cheats=["level_select"]) &&
              byte(0x00D5CB) == 5 && once(byte(0x00DCE8) == 6) && once(byte(0x00DCEB) == 6) &&
              never(prev(byte(0x00D5CB)) != byte(0x00D5CB)) && never(prev(byte(0x00D5CC)) != byte(0x00D5CC)) &&
              prev(byte(0x00D5D2)) != byte(0x00D5D2) &&
              ((repeated(3, prev(byte(0x00D5CA)) < byte(0x00D5CA)) && byte(0x00DC86) <= 36) ||
               (repeated(2, prev(byte(0x00D5CA)) < byte(0x00D5CA)) && byte(0x00DC86) > 36 + ALT_GROUP_OPTIMIZATION_BUG))
)

achievement(
    title = "Pack Rat", points = 5,
    description = "Pick up all of the items in stage 7 and complete the level (minus the erasers, level select allowed)",
    id = 72030, badge = "77279", published = "2/16/2019 7:39:20 PM", modified = "10/18/2019 1:37:01 AM",
    trigger = AntiBios() && AntiCheat(allowed_cheats=["level_select"]) &&
              byte(0x00D5CB) == 6 && once(byte(0x00DCEC) == 6) && once(byte(0x00DCEE) == 6) &&
              never(prev(byte(0x00D5CB)) != byte(0x00D5CB)) && never(prev(byte(0x00D5CC)) != byte(0x00D5CC)) &&
              prev(byte(0x00D5D3)) != byte(0x00D5D3) &&
              ((repeated(2, prev(byte(0x00D5CA)) < byte(0x00D5CA)) && byte(0x00DC86) <= 35) ||
               (once(prev(byte(0x00D5CA)) < byte(0x00D5CA)) && byte(0x00DC86) > 35 + ALT_GROUP_OPTIMIZATION_BUG))
)

achievement(
    title = "Connoisseur", points = 5,
    description = "Pick up all of the items in stage 8 and complete the level (minus the erasers, level select allowed)",
    id = 72031, badge = "77281", published = "2/16/2019 7:39:25 PM", modified = "2/18/2019 2:47:47 AM",
    trigger = AntiBios() && AntiCheat(allowed_cheats=["level_select"]) &&
              byte(0x00D5CB) == 7 && once(byte(0x00DCEA) == 6) && once(byte(0x00DCE8) == 6) &&
              never(prev(byte(0x00D5CB)) != byte(0x00D5CB)) && never(prev(byte(0x00D5CC)) != byte(0x00D5CC)) &&
              prev(byte(0x00D5D4)) != byte(0x00D5D4) &&
              ((repeated(2, prev(byte(0x00D5CA)) < byte(0x00D5CA)) && byte(0x00DC86) <= 37) ||
               (once(prev(byte(0x00D5CA)) < byte(0x00D5CA)) && byte(0x00DC86) > 37 + ALT_GROUP_OPTIMIZATION_BUG))
)

achievement(
    title = "Hoarder", points = 5,
    description = "Pick up all of the items in stage 9 and complete the level (minus the erasers, level select allowed)",
    id = 72032, badge = "77280", published = "2/16/2019 7:39:30 PM", modified = "2/18/2019 2:47:49 AM",
    trigger = AntiBios() && AntiCheat(allowed_cheats=["level_select"]) &&
              byte(0x00D5CB) == 8 && once(byte(0x00DCEC) == 6) && once(byte(0x00DCEE) == 6) && once(byte(0x00DCED) == 6) &&
              never(prev(byte(0x00D5CB)) != byte(0x00D5CB)) &&
              never(prev(byte(0x00D5CC)) != byte(0x00D5CC)) && prev(byte(0x00D5D5)) != byte(0x00D5D5) &&
              ((repeated(2, prev(byte(0x00D5CA)) < byte(0x00D5CA)) && byte(0x00DC86) <= 40) ||
               (once(prev(byte(0x00D5CA)) < byte(0x00D5CA)) && byte(0x00DC86) > 40 + ALT_GROUP_OPTIMIZATION_BUG))
)

achievement(
    title = "Scratch Out", points = 10,
    description = "Lower your score 3 times in one level (any hole except hole 1)",
    id = 72051, badge = "77229", published = "2/16/2019 7:41:22 PM", modified = "1/2/2021 12:06:33 AM",
    trigger = AntiBios() && AntiCheat() &&
              never(prev(byte(0x00D5CB)) < byte(0x00D5CB)) && repeated(3, prev(byte(0x00DC86)) > byte(0x00DC86)) &&
              never(byte(0x00DC87) != 0) && never(prev(byte(0x00D5CC)) != byte(0x00D5CC)) &&
              byte(0x00D5CB) > 0
)

achievement(
    title = "Mini Me", points = 5,
    description = "Gain an extra life",
    id = 72033, badge = "77061", published = "2/16/2019 7:39:40 PM", modified = "1/2/2021 12:06:31 AM",
    trigger = AntiBios() && AntiCheat() &&
              once(prev(byte(0x00D5CA)) < byte(0x00D5CA)) &&
              never((prev(byte(0x00D5CA)) + 9) == byte(0x00D5CA))
)

achievement(
    title = "It's-a Me, Scratchy!", points = 5,
    description = "Pick up a Hammer",
    id = 72034, badge = "77063", published = "2/16/2019 7:39:48 PM", modified = "1/2/2021 12:06:30 AM",
    trigger = AntiBios() && AntiCheat() &&
              byte(0x00DCC9) == 192 && prev(byte(0x00DCC9)) != byte(0x00DCC9)
)

achievement(
    title = "Down Under", points = 5,
    description = "Collect a Boomerang",
    id = 72035, badge = "77242", published = "2/16/2019 7:40:00 PM", modified = "1/2/2021 12:06:28 AM",
    trigger = AntiBios() && AntiCheat() &&
              prev(byte(0x00DCEA)) < byte(0x00DCEA)
)

achievement(
    title = "Wonder Bat", points = 10,
    description = "Pick up every Bat in the game (No continues)",
    id = 72036, badge = "77065", published = "2/16/2019 7:40:06 PM", modified = "1/2/2021 12:06:27 AM",
    trigger = AntiBios() && AntiCheat() &&
              repeated(3, prev(byte(0x00DCE9)) < byte(0x00DCE9)) &&
              never(prev(byte(0x00D5CC)) != byte(0x00D5CC)) &&
              never(prev(byte(0x00D5CB)) > byte(0x00D5CB))
)

achievement(
    title = "Ultimate", points = 10,
    description = "Pick up every Frisbee in the game (No continues)",
    id = 72037, badge = "77066", published = "2/16/2019 7:40:10 PM", modified = "1/2/2021 12:06:24 AM",
    trigger = AntiBios() && AntiCheat() &&
              repeated(4, prev(byte(0x00DCED)) < byte(0x00DCED)) &&
              never(prev(byte(0x00D5CC)) != byte(0x00D5CC)) &&
              never(prev(byte(0x00D5CB)) > byte(0x00D5CB))
)

achievement(
    title = "Freedom Ball", points = 10,
    description = "Collect all Bombs in the game (No continues)",
    id = 72038, badge = "77241", published = "2/16/2019 7:40:14 PM", modified = "1/2/2021 12:06:23 AM",
    trigger = AntiBios() && AntiCheat() &&
              repeated(3, prev(byte(0x00DCEB)) < byte(0x00DCEB)) && never(prev(byte(0x00D5CC)) != byte(0x00D5CC)) &&
              never(prev(byte(0x00D5CB)) > byte(0x00D5CB))
)

achievement(
    title = "Fire In The Hole", points = 10,
    description = "Collect all Grenades in the game (No continues)",
    id = 72039, badge = "77245", published = "2/16/2019 7:40:18 PM", modified = "1/2/2021 12:06:22 AM",
    trigger = AntiBios() && AntiCheat() &&
              repeated(3, prev(byte(0x00DCE8)) < byte(0x00DCE8)) &&
              never(prev(byte(0x00D5CC)) != byte(0x00D5CC)) &&
              never(prev(byte(0x00D5CB)) > byte(0x00D5CB))
)

achievement(
    title = "Bart-Beard", points = 10,
    description = "Collect all Swords in the game (No continues)",
    id = 72040, badge = "77246", published = "2/16/2019 7:40:23 PM", modified = "1/2/2021 12:06:20 AM",
    trigger = AntiBios() && AntiCheat() &&
              repeated(3, prev(byte(0x00DCEC)) < byte(0x00DCEC)) &&
              never(prev(byte(0x00D5CC)) != byte(0x00D5CC)) &&
              never(prev(byte(0x00D5CB)) > byte(0x00D5CB))
)

achievement(
    title = "Laser Tag", points = 10,
    description = "Collect all Lasers in the game (No continues)",
    id = 72041, badge = "77247", published = "2/16/2019 7:40:28 PM", modified = "1/2/2021 12:06:19 AM",
    trigger = AntiBios() && AntiCheat() &&
              repeated(2, prev(byte(0x00DCEE)) < byte(0x00DCEE)) &&
              never(prev(byte(0x00D5CC)) != byte(0x00D5CC)) &&
              never(prev(byte(0x00D5CB)) > byte(0x00D5CB))
)

