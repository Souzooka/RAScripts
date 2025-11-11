// Crazy Frog Racer
// #ID = 21869

NUM_RACERS = 6
g_cup_scores = array_map(range(0, NUM_RACERS - 1), i => dword(0x5164AC + i * 0x44))
g_stage = dword(0x5013E8)
g_race_standing = dword(0x515E88)
g_cup = dword(0x4D0988)
g_difficulty = dword(0x4D09B8)
g_game_mode = dword(0x52AA20)
g_character = dword(0x52AA28)
g_main_player_drive_mode = dword(0x51649C)

CUP_BABY = 0
CUP_FUNNY = 1
CUP_CRAZY = 2
CUP_SPECIAL = 3

CHARACTER_ANNOYING_THING = 1
CHARACTER_JACK = 2
CHARACTER_DRONE = 3
CHARACTER_MICHEL = 4
CHARACTER_MATILDA = 5
CHARACTER_ELLIE = 6
CHARACTER_FLASH = 7
CHARACTER_GRIM = 8
CHARACTER_BOBO = 9

CHARACTER_TO_NAME = {
    CHARACTER_ANNOYING_THING: "The Annoying Thing",
    CHARACTER_JACK: "Jack",
    CHARACTER_DRONE: "Drone",
    CHARACTER_MICHEL: "Michel",
    CHARACTER_MATILDA: "Matilda",
    CHARACTER_ELLIE: "Ellie",
    CHARACTER_FLASH: "Flash",
    CHARACTER_GRIM: "Grim",
    CHARACTER_BOBO: "Bobo",
}

CUP_TO_NAME = {
    CUP_BABY: "Baby",
    CUP_FUNNY: "Funny",
    CUP_CRAZY: "Crazy",
    CUP_SPECIAL: "Special",
}

CUP_PARAMS = {
    CUP_BABY: {
        "n_races": 4,
        "last_stage": 0x4,
    },
    CUP_FUNNY: {
        "n_races": 4,
        "last_stage": 0x8,
    },
    CUP_CRAZY: {
        "n_races": 4,
        "last_stage": 0xC,
    },
    CUP_SPECIAL: {
        "n_races": 12,
        "last_stage": 0xC,
    },
}

function IsChampionship()
{
    return g_game_mode == 0x201
}

function WonCup(cup, difficulty=0, perfect=false)
{
    params = CUP_PARAMS[cup]
    
    score_cond = always_true()
    if (perfect)
    {
        // Can get up to 10 points per race
        max_score = params["n_races"] * 10
        score_cond = g_cup_scores[0] == max_score
    }
    
    difficulty_cond = g_difficulty >= difficulty
    
    return
        // Is championship
        IsChampionship() &&
        // Is correct cup
        g_cup == cup &&
        // Correct difficulty
        difficulty_cond &&
        // We've finished the race
        g_main_player_drive_mode == 3 &&
        // I've finally done it! I win, I win, I win the race!
        g_race_standing == 0 &&
        // Optional score condition
        score_cond &&
        // We went back to main menu
        prev(g_stage) == params["last_stage"] &&
        g_stage == 16
}

function WonAnyCup()
{
    return any_of(range(CUP_BABY, CUP_SPECIAL), WonCup)
}

CHARACTER_PARAMS = [
    {
        "id": 272430,
        "character": CHARACTER_ANNOYING_THING,
    },
    {
        "id": 272443,
        "character": CHARACTER_JACK,
    },
    {
        "id": 272444,
        "character": CHARACTER_DRONE,
    },
    {
        "id": 272445,
        "character": CHARACTER_MICHEL,
    },
    {
        "id": 272446,
        "character": CHARACTER_MATILDA,
    },
    {
        "id": 272447,
        "character": CHARACTER_ELLIE,
    },
    {
        "id": 272448,
        "character": CHARACTER_FLASH,
    },
    {
        "id": 272449,
        "character": CHARACTER_GRIM,
    },
    {
        "id": 272450,
        "character": CHARACTER_BOBO,
    },
]

for params in CHARACTER_PARAMS
{
    name = CHARACTER_TO_NAME[params["character"]]
    achievement(
        id=params["id"],
        title=name,
        description=format("Win any Cup as {0} (1P).", name),
        type="progression",
        points=3,
        trigger=
            g_character == params["character"] &&
            WonAnyCup()
    )
}

CUP_ACHIEVEMENT_PARAMS = [
    {
        "cup": CUP_BABY,
        "points": 5,
        "id0": 272342,
        "id1": 272343,
        "title0": "First Steps",
        "title1": "Child Prodigy",
    },
    {
        "cup": CUP_FUNNY,
        "points": 5,
        "id0": 272345,
        "id1": 272346,
        "title0": "Not So Funny Anymore",
        "title1": "Last Laugh",
    },
    {
        "cup": CUP_CRAZY,
        "points": 5,
        "id0": 272348,
        "id1": 272349,
        "title0": "Technically Crazy",
        "title1": "Ding Ding!",
    },
    {
        "cup": CUP_SPECIAL,
        "points": 10,
        "id0": 272351,
        "id1": 272352,
        "title0": "My Specialty",
        "title1": "The Perfect Run",
    },
]

for params in CUP_ACHIEVEMENT_PARAMS
{
    cup = params["cup"]
    points = params["points"]
    name = CUP_TO_NAME[params["cup"]]
    
    achievement(
        id=params["id0"],
        title=params["title0"],
        description=format("Win the {0} Cup (Hard)", name),
        points=points,
        trigger=WonCup(cup, difficulty=2)
    )
    
    achievement(
        id=params["id1"],
        title=params["title1"],
        description=format("Win the {0} Cup with a perfect score! (Any Difficulty)", name),
        points=points,
        trigger=WonCup(cup, perfect=true)
    )
}

