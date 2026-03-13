// Donald Duck: Goin' Quackers
// #ID = 2873

function if_else(cond, a, b)
{
    if cond == true return a
    return b
}

function dictionary_get(dict, key, default=false)
{
    if dictionary_contains_key(dict, key) return dict[key]
    return default
}

function array_iextend(a, b)
{
    for v in b array_push(a, v)
}

function CStageProgression(addr)
{
    obj = {
        "m_energy_ball_stage": byte(addr + 0x0),
        "m_energy_ball": byte(addr + 0x1),
        "m_items": array_map(range(0, 3-1), i => byte(addr + 0x2 + i)),
        "m_trial_complete_flag": bit0(addr + 0x5) ^ 1, // we aren't expected to spend an hour on a trial, so we can use this as a quick trick for math
        "m_trial_tbyte": tbyte(addr + 0x5),
        "m_trial_hours": byte(addr + 0x5),
        "m_trial_minutes": byte(addr + 0x6),
        "m_trial_seconds": byte(addr + 0x7),
    }
    
    return obj
}

function CGameProgression(addr)
{
    obj = {
        "m_magic": dword(addr + 0x8),
        "m_lives": word(addr + 0x20),
        "m_stars": word(addr + 0x22),
        "m_stages": array_map(range(0, 16-1), i => CStageProgression(addr + 0x24 + i * 8)),
        // Bear's Path
        // Main Street
        // Under Hand'ed
        // Head Alley
        // Bernadette's Peak
        // Beagle Boy's Tower
        // Magica's Devilish Dome
        // Ceremonial Room
        "m_bosses": array_map(range(0, 8-1), i => byte(addr + 0xA5 + i * 2)),
    }
    
    return obj
}

LEVEL_WORLD_MAP = "world map"
LEVEL_FOREST_EDGE = 0
LEVEL_THE_GORGE = 1
LEVEL_DANGEROUS_CLIFF = 2
LEVEL_HUEYS_TRACK = 3
LEVEL_FIRST_AVENUE = 4
LEVEL_THE_ROOFS = 5
LEVEL_URBAN_HIGH_RISES = 6
LEVEL_DEWEYS_ROOFTOPS = 7
LEVEL_HAUNTED_HALL = 8
LEVEL_EARIE_ALLEY = 9
LEVEL_GHOSTLY_PATH = 10
LEVEL_LOUIES_CREEPY_CORRIDOR = 11
LEVEL_TEMPLES_ENTRANCE = 12
LEVEL_ARTIFACT_WAY = 13
LEVEL_ANCIENT_FATE = 14
LEVEL_THE_NEPHEWS_MURKY_WAY = 15
LEVEL_BEARS_PATH = 0x100
LEVEL_MAIN_STREET = 0x101
LEVEL_UNDER_HANDED = 0x102
LEVEL_HEAD_ALLEY = 0x103
LEVEL_BERNADETTES_PEAK = 0x104
LEVEL_BEAGLE_BOYS_TOWER = 0x105
LEVEL_MAGICAS_DEVILISH_DOME = 0x106
LEVEL_CEREMONIAL_ROOM = 0x107

state_addrs = {
    LEVEL_WORLD_MAP: 0xa0924,
    LEVEL_FOREST_EDGE: 0xa7ef8,
    LEVEL_THE_GORGE: 0xa027c,
    LEVEL_DANGEROUS_CLIFF: 0x9f5d4,
    LEVEL_HUEYS_TRACK: 0xa01d8,
    LEVEL_FIRST_AVENUE: 0xa4284,
    LEVEL_THE_ROOFS: 0xa35f0,
    LEVEL_URBAN_HIGH_RISES: 0xa1890,
    LEVEL_DEWEYS_ROOFTOPS: 0xa091c,
    LEVEL_HAUNTED_HALL: 0xa2a18,
    LEVEL_EARIE_ALLEY: 0xa177c,
    LEVEL_GHOSTLY_PATH: 0xa3570,
    LEVEL_LOUIES_CREEPY_CORRIDOR: 0xa3138,
    LEVEL_TEMPLES_ENTRANCE: 0xa2f88,
    LEVEL_ARTIFACT_WAY: 0xa2368,
    LEVEL_ANCIENT_FATE: 0xa3aa0,
    LEVEL_THE_NEPHEWS_MURKY_WAY: 0xa1c00,
    LEVEL_BEARS_PATH: 0x9d588,
    LEVEL_MAIN_STREET: 0xa12a8,
    LEVEL_UNDER_HANDED: 0x9e084,
    LEVEL_HEAD_ALLEY: 0x9bbbc,
    LEVEL_BERNADETTES_PEAK: 0x9ac20,
    LEVEL_BEAGLE_BOYS_TOWER: 0x994e4,
    LEVEL_MAGICAS_DEVILISH_DOME: 0x9b8b0,
    LEVEL_CEREMONIAL_ROOM: 0xa1148,
}

game_states = {}
for level in state_addrs game_states[level] = CGameProgression(state_addrs[level])

function level_to_boss(level)
{
    return level - 0x100
}

function in_level(level)
{
    game_state = game_states[level]
    
    // Check if the overlay's position for game state's time trials
    // match up with the universal object. Since the time trial data isn't affected while in level
    // (at least, until the very end), this data is expected to be the same.
    // Due to length limitations, we can only check 7 stages for 112%, unfortunately. We should make sure to check
    // both the beginning and end of the list to prevent some conflicts with overlapping overlays, at the least.
    TO_CHECK = [0, 1, 14, 15, 5, 8, 11]
    cond = always_true()
    for i in TO_CHECK
    {
        universal_stage_state = CStageProgression(0x1ffb2c + i * 8)
        stage_state = game_state["m_stages"][i]
    
        cond = cond && prev(stage_state["m_trial_tbyte"]) == prev(universal_stage_state["m_trial_tbyte"])
        if i != level
        {
            cond = cond && stage_state["m_trial_tbyte"] == universal_stage_state["m_trial_tbyte"]
        }
    }


    return cond && game_states[level]["m_lives"] != 0
}

// Misc.

achievement(
    id=106178,
    title="Tutorial TV",
    description="Use one of the Tutorial TVs in Forest Edge.",
    points=1,
    trigger=
        in_level(LEVEL_FOREST_EDGE) &&
        prev(byte(0x1507C4)) == 0 &&
        byte(0x1507C4) >= 1
)

achievement(
    id=106179,
    title="Quack Attack!",
    description="Defeat your first enemy in Forest Edge.",
    points=1,
    trigger=
        in_level(LEVEL_FOREST_EDGE) &&
        prev(byte(0x135B36)) == 0 &&
        byte(0x135B36) == 1
)

achievement(
    id=106180,
    title="Shake Things Up!",
    description="Drink your first milkshake in Forest Edge.",
    points=1,
    trigger=
        in_level(LEVEL_FOREST_EDGE) &&
        prev(byte(0x15405E)) == 0 &&
        byte(0x15405E) == 1
)

achievement(
    id=106241,
    title="Can't Pluck This Duck",
    description="Have 20 or more lives at once.",
    points=10,
    trigger=
        any_of(
            game_states, level => 
                in_level(level) &&
                prev(game_states[level]["m_lives"]) == 19 &&
                game_states[level]["m_lives"] == 20
        )
)

// 100%

COMPLETION_PARAMS = [
    {
        "id": 106195,
        "levels": [LEVEL_FOREST_EDGE, LEVEL_THE_GORGE, LEVEL_DANGEROUS_CLIFF, LEVEL_HUEYS_TRACK],
        "bosses": [LEVEL_BEARS_PATH, LEVEL_BERNADETTES_PEAK],
        "title": "Tourist Trap",
        "description": "Obtain 100% completion of every stage in Duckie Mountain.",
        "points": 10,
    },
    {
        "id": 106210,
        "levels": [LEVEL_FIRST_AVENUE, LEVEL_THE_ROOFS, LEVEL_URBAN_HIGH_RISES, LEVEL_DEWEYS_ROOFTOPS],
        "bosses": [LEVEL_MAIN_STREET, LEVEL_BEAGLE_BOYS_TOWER],
        "title": "Snooze Cruise",
        "description": "Obtain 100% completion of every stage in Duckberg.",
        "points": 10,
    },
    {
        "id": 106225,
        "levels": [LEVEL_HAUNTED_HALL, LEVEL_EARIE_ALLEY, LEVEL_GHOSTLY_PATH, LEVEL_LOUIES_CREEPY_CORRIDOR],
        "bosses": [LEVEL_UNDER_HANDED, LEVEL_MAGICAS_DEVILISH_DOME],
        "title": "Penguin Suit",
        "description": "Obtain 100% completion of every stage in Magica De Spell's Manor.",
        "points": 10,
    },
    {
        "id": 106240,
        "levels": [LEVEL_TEMPLES_ENTRANCE, LEVEL_ARTIFACT_WAY, LEVEL_ANCIENT_FATE, LEVEL_THE_NEPHEWS_MURKY_WAY],
        "bosses": [LEVEL_HEAD_ALLEY, LEVEL_CEREMONIAL_ROOM],
        "title": "Now All You Need's a Whip",
        "description": "Obtain 100% completion of every stage in Merlock's Temple.",
        "points": 10,
    },
    {
        "id": 106242,
        "levels": [LEVEL_FOREST_EDGE, LEVEL_THE_GORGE, LEVEL_DANGEROUS_CLIFF, LEVEL_HUEYS_TRACK,
                   LEVEL_FIRST_AVENUE, LEVEL_THE_ROOFS, LEVEL_URBAN_HIGH_RISES, LEVEL_DEWEYS_ROOFTOPS,
                   LEVEL_HAUNTED_HALL, LEVEL_EARIE_ALLEY, LEVEL_GHOSTLY_PATH, LEVEL_LOUIES_CREEPY_CORRIDOR,
                   LEVEL_TEMPLES_ENTRANCE, LEVEL_ARTIFACT_WAY, LEVEL_ANCIENT_FATE, LEVEL_THE_NEPHEWS_MURKY_WAY],
        "bosses": [LEVEL_BEARS_PATH, LEVEL_BERNADETTES_PEAK,
                   LEVEL_MAIN_STREET, LEVEL_BEAGLE_BOYS_TOWER,
                   LEVEL_UNDER_HANDED, LEVEL_MAGICAS_DEVILISH_DOME,
                   LEVEL_HEAD_ALLEY, LEVEL_CEREMONIAL_ROOM],
        "title": "Goin' Quackers",
        "description": "Obtain 112% completion.",
        "points": 25,
    },
]

for params in COMPLETION_PARAMS
{
    // Number of objectives to check for
    // 1 goal + 3 items + 1 trial per level
    // 1 goal per boss
    expected_count = length(params["levels"]) * 5 + length(params["bosses"])
    
    // Check each area's state
    check_areas = array_map(state_addrs, k=>k)
    // note: we might not want to check world map but might as well just keep it in for now if it doesn't cause issues
    
    conds = []
    
    for check_area in check_areas
    {
        // Accumulate the completed level objectives
        level_objectives = 0
        prev_level_objectives = 0
        for level in params["levels"]
        {
            stage_state = game_states[check_area]["m_stages"][level]
            
            // Energy ball
            level_objectives = level_objectives + stage_state["m_energy_ball"]
            prev_level_objectives = prev_level_objectives + prev(stage_state["m_energy_ball"])
            
            // Items
            level_objectives = level_objectives + sum_of(stage_state["m_items"], v=>v)
            prev_level_objectives = prev_level_objectives + sum_of(stage_state["m_items"], prev)
            
            // Time trial
            level_objectives = level_objectives + stage_state["m_trial_complete_flag"]
            prev_level_objectives = prev_level_objectives + prev(stage_state["m_trial_complete_flag"])
        }
        
        for boss in params["bosses"]
        {
            level_objectives = level_objectives + game_states[check_area]["m_bosses"][level_to_boss(boss)]
            prev_level_objectives = prev_level_objectives + prev(game_states[check_area]["m_bosses"][level_to_boss(boss)])
        }
        
        array_push(
            conds, 
            prev_level_objectives == expected_count - 1 &&
            measured(level_objectives == expected_count, when=in_level(check_area), format="percent")
        )
    }
    
    achievement(
        id=params["id"],
        title=params["title"],
        description=params["description"],
        points=params["points"],
        trigger=any_of(conds, v=>v)
    )
}

// Bosses

BOSS_PARAMS = [
    {
        "level": LEVEL_BEARS_PATH,
        "id": 106193,
        "title": "Poking the Bear",
        "description": "Complete Bears' Path.",
        "type": "",
        "points": 5,
    },
    {
        "level": LEVEL_BERNADETTES_PEAK,
        "id": 106194,
        "title": "Duck Duck Bird",
        "description": "Defeat Bernadette the Bird.",
        "type": "progression",
        "points": 5,
    },
    {
        "level": LEVEL_MAIN_STREET,
        "id": 106208,
        "title": "Escape from the Street",
        "description": "Complete Main Street.",
        "type": "",
        "points": 5,
    },
    {
        "level": LEVEL_BEAGLE_BOYS_TOWER,
        "id": 106209,
        "title": "Construction Cruise",
        "description": "Defeat the Beagle Boy.",
        "type": "progression",
        "points": 5,
    },
    {
        "level": LEVEL_UNDER_HANDED,
        "id": 106223,
        "title": "It's No Master Hand",
        "description": "Complete Under 'Hand'ed.",
        "type": "",
        "points": 5,
    },
    {
        "level": LEVEL_MAGICAS_DEVILISH_DOME,
        "id": 106224,
        "title": "Let Me Spell This Out",
        "description": "Defeat Magica De Spell.",
        "type": "progression",
        "points": 5,
    },
    {
        "level": LEVEL_HEAD_ALLEY,
        "id": 106238,
        "title": "He's on a Roll!",
        "description": "Complete Head Alley.",
        "type": "",
        "points": 5,
    },
    {
        "level": LEVEL_CEREMONIAL_ROOM,
        "id": 106239,
        "title": "Save the Girl",
        "description": "Defeat Merlock the Wizard.",
        "type": "win_condition",
        "points": 5,
    },
]

for params in BOSS_PARAMS
{
    level = params["level"]
    completion_flag = game_states[level]["m_bosses"][level_to_boss(level)]
    
    BOSS_HP_LOOKUP = {
        LEVEL_BERNADETTES_PEAK: byte(0xf4524),
        LEVEL_BEAGLE_BOYS_TOWER: byte(0xeea38),
        LEVEL_MAGICAS_DEVILISH_DOME: byte(0xee9bc),
        LEVEL_CEREMONIAL_ROOM: byte(0xead90),
    }
    
    boss_hp = dictionary_get(BOSS_HP_LOOKUP, level, false)
    
    trigger = always_true()
    if dictionary_contains_key(BOSS_HP_LOOKUP, level)
        trigger = prev(boss_hp) == 1 && boss_hp == 0 // allows replaying bosses
    else
        trigger = prev(completion_flag) == 0 && completion_flag == 1

    achievement(
        id=params["id"],
        title=params["title"],
        description=params["description"],
        type=params["type"],
        points=params["points"],
        trigger=
            in_level(params["level"]) &&
            trigger
    )
}

// Levels

LEVEL_PARAMS = [
    {
        "level": LEVEL_FOREST_EDGE,
        "level_name": "Forest Edge",
        "goal_id": 106182,
        "item_id": 106181,
        "time_id": 106183,
        "lb_id": 157455,
        "goal_name": "If a Ball Falls in the Forest...",
        "item_name": "Silly Old Bears",
        "time_name": "Duck Trails",
        "goal_points": 2,
        "item_points": 3,
        "time_points": 5,
        "toy_name": "Huey's teddy bears",
    },
    {
        "level": LEVEL_THE_GORGE,
        "level_name": "The Gorge",
        "goal_id": 106184,
        "item_id": 106185,
        "time_id": 106186,
        "lb_id": 157456,
        "goal_name": "Second Spark",
        "item_name": "Bear-ly Made It",
        "time_name": "Don't Gorge Yourself",
        "goal_points": 2,
        "item_points": 3,
        "time_points": 5,
        "toy_name": "Huey's teddy bears",
    },
    {
        "level": LEVEL_HUEYS_TRACK,
        "level_name": "Huey's Track",
        "goal_id": 106187,
        "item_id": 106188,
        "time_id": 106189,
        "lb_id": 157458,
        "goal_name": "Hand It Over Huey!",
        "item_name": "Tracked Them Down",
        "time_name": "Quack and Field",
        "goal_points": 2,
        "item_points": 3,
        "time_points": 5,
        "toy_name": "Huey's teddy bears",
    },
    {
        "level": LEVEL_DANGEROUS_CLIFF,
        "level_name": "Dangerous Cliff",
        "goal_id": 106190,
        "item_id": 106191,
        "time_id": 106192,
        "lb_id": 157457,
        "goal_name": "Let's Get Dangerous",
        "item_name": "I Can't Bear This Anymore",
        "time_name": "A Dip Into Danger",
        "goal_points": 2,
        "item_points": 3,
        "time_points": 5,
        "toy_name": "Huey's teddy bears",
    },
    {
        "level": LEVEL_FIRST_AVENUE,
        "level_name": "First Avenue",
        "goal_id": 106196,
        "item_id": 106197,
        "time_id": 106198,
        "lb_id": 157459,
        "goal_name": "Balling in the Street",
        "item_name": "Later Skater",
        "time_name": "Over the Speed Limit",
        "goal_points": 2,
        "item_points": 3,
        "time_points": 5,
        "toy_name": "Dewey's roller skates",
    },
    {
        "level": LEVEL_THE_ROOFS,
        "level_name": "The Roofs",
        "goal_id": 106199,
        "item_id": 106200,
        "time_id": 106201,
        "lb_id": 157460,
        "goal_name": "Lightning Rod",
        "item_name": "Rolling on The Roofs",
        "time_name": "Raise the Rooftops",
        "goal_points": 2,
        "item_points": 3,
        "time_points": 5,
        "toy_name": "Dewey's roller skates",
    },
    {
        "level": LEVEL_DEWEYS_ROOFTOPS,
        "level_name": "Dewey's Rooftops",
        "goal_id": 106202,
        "item_id": 106203,
        "time_id": 106204,
        "lb_id": 157461,
        "goal_name": "Drop It Dewey!",
        "item_name": "But Why Three Skates?",
        "time_name": "Rooftop Run",
        "goal_points": 2,
        "item_points": 3,
        "time_points": 5,
        "toy_name": "Dewey's roller skates",
    },
    {
        "level": LEVEL_URBAN_HIGH_RISES,
        "level_name": "Urban High-Rises",
        "goal_id": 106205,
        "item_id": 106206,
        "time_id": 106207,
        "lb_id": 157462,
        "goal_name": "A Spark in the Sky",
        "item_name": "A Real Pro Skater",
        "time_name": "He Rises to the Occasion",
        "goal_points": 2,
        "item_points": 3,
        "time_points": 5,
        "toy_name": "Dewey's roller skates",
    },
    {
        "level": LEVEL_HAUNTED_HALL,
        "level_name": "Haunted Hall",
        "goal_id": 106211,
        "item_id": 106212,
        "time_id": 106213,
        "lb_id": 157463,
        "goal_name": "Hall Monitor",
        "item_name": "Set Phasers to Stun",
        "time_name": "Not Your Usual Haunt",
        "goal_points": 2,
        "item_points": 3,
        "time_points": 5,
        "toy_name": "Louie's ray guns",
    },
    {
        "level": LEVEL_EARIE_ALLEY,
        "level_name": "Earie Alley",
        "goal_id": 106214,
        "item_id": 106215,
        "time_id": 106216,
        "lb_id": 157464,
        "goal_name": "Keep the Ball Rolling!",
        "item_name": "Straight Shot",
        "time_name": "Peaks and Alleys",
        "goal_points": 2,
        "item_points": 3,
        "time_points": 5,
        "toy_name": "Louie's ray guns",
    },
    {
        "level": LEVEL_LOUIES_CREEPY_CORRIDOR,
        "level_name": "Louie's Creepy Corridor",
        "goal_id": 106217,
        "item_id": 106218,
        "time_id": 106219,
        "lb_id": 157465,
        "goal_name": "Leave It Louie!",
        "item_name": "Run and Gun",
        "time_name": "No More Corridor",
        "goal_points": 2,
        "item_points": 3,
        "time_points": 5,
        "toy_name": "Louie's ray guns",
    },
    {
        "level": LEVEL_GHOSTLY_PATH,
        "level_name": "Ghostly Path",
        "goal_id": 106220,
        "item_id": 106221,
        "time_id": 106222,
        "lb_id": 157466,
        "goal_name": "Signs of Life",
        "item_name": "Blaster Master",
        "time_name": "Gone and Ghosted",
        "goal_points": 2,
        "item_points": 3,
        "time_points": 5,
        "toy_name": "Louie's ray guns",
    },
    {
        "level": LEVEL_TEMPLES_ENTRANCE,
        "level_name": "Temple's Entrance",
        "goal_id": 106226,
        "item_id": 106227,
        "time_id": 106228,
        "lb_id": 157467,
        "goal_name": "Wak like an Egyptian",
        "item_name": "No Fly Zone",
        "time_name": "Temple Run",
        "goal_points": 2,
        "item_points": 3,
        "time_points": 5,
        "toy_name": "the triplets' toy airplanes",
    },
    {
        "level": LEVEL_ARTIFACT_WAY,
        "level_name": "Artifact Way",
        "goal_id": 106229,
        "item_id": 106230,
        "time_id": 106231,
        "lb_id": 157468,
        "goal_name": "Go with the Lava Flow",
        "item_name": "Bit of a Bumpy Flight",
        "time_name": "No Respect for the Ruins",
        "goal_points": 2,
        "item_points": 3,
        "time_points": 5,
        "toy_name": "the triplets' toy airplanes",
    },
    {
        "level": LEVEL_THE_NEPHEWS_MURKY_WAY,
        "level_name": "The Nephews' Murky Way",
        "goal_id": 106232,
        "item_id": 106233,
        "time_id": 106234,
        "lb_id": 157469,
        "goal_name": "Triple Trouble",
        "item_name": "Stop Toying with Me!",
        "time_name": "Playing with Fire",
        "goal_points": 2,
        "item_points": 3,
        "time_points": 5,
        "toy_name": "the triplets' toy airplanes",
    },
    {
        "level": LEVEL_ANCIENT_FATE,
        "level_name": "Ancient Fate",
        "goal_id": 106235,
        "item_id": 106236,
        "time_id": 106237,
        "lb_id": 157470,
        "goal_name": "The Ball's in your Court",
        "item_name": "Last Call for This Flight",
        "time_name": "Faster than Fate",
        "goal_points": 2,
        "item_points": 3,
        "time_points": 5,
        "toy_name": "the triplets' toy airplanes",
    },
]

for params in LEVEL_PARAMS
{
    level = params["level"]
    game_state = game_states[level]
    stage_state = game_state["m_stages"][level]

    // Goal
    achievement(
        id=params["goal_id"],
        title=params["goal_name"],
        description=format("Collect {0}'s energy ball.", params["level_name"]),
        points=params["goal_points"],
        trigger=
            in_level(level) &&
            prev(stage_state["m_energy_ball_stage"]) == 0 &&
            stage_state["m_energy_ball_stage"] == 1
    )
    
    // Items
    achievement(
        id=params["item_id"],
        title=params["item_name"],
        description=format("Collect all of {0} in {1}.", params["toy_name"], params["level_name"]),
        points=params["item_points"],
        trigger=
            in_level(level) &&
            sum_of(stage_state["m_items"], prev) == length(stage_state["m_items"]) - 1 &&
            sum_of(stage_state["m_items"], v=>v) == length(stage_state["m_items"])
    )
    
    // Time Trials
    achievement(
        id=params["time_id"],
        title=params["time_name"],
        description=format("Set a new record time in {0}.", params["level_name"]),
        points=params["time_points"],
        trigger=
            in_level(level) &&
            __ornext(
                stage_state["m_trial_hours"] < prev(stage_state["m_trial_hours"]) ||
                stage_state["m_trial_minutes"] < prev(stage_state["m_trial_minutes"]) ||
                stage_state["m_trial_seconds"] < prev(stage_state["m_trial_seconds"])
            )
    )
}

// LBs

for params in LEVEL_PARAMS
{
    level = params["level"]
    stage_state = game_states[level]["m_stages"][level]
    start = in_level(level) &&
            __ornext(
                stage_state["m_trial_hours"] < prev(stage_state["m_trial_hours"]) ||
                stage_state["m_trial_minutes"] < prev(stage_state["m_trial_minutes"]) ||
                stage_state["m_trial_seconds"] < prev(stage_state["m_trial_seconds"])
            )
    cancel = always_false()
    submit = always_true()
    value = stage_state["m_trial_hours"] * 3600 +
            stage_state["m_trial_minutes"] * 60 +
            stage_state["m_trial_seconds"]
            
    leaderboard(
        id=params["lb_id"],
        title=format("{0} - Time Trial", params["level_name"]),
        description=format("Complete the time trial in {0} in the fastest time!", params["level_name"]),
        format="SECS",
        lower_is_better=true,
        start=start,
        cancel=cancel,
        submit=submit,
        value=value
    )
}

// Rich Presence

rp_strings = {
    LEVEL_WORLD_MAP: "Donald Duck is in Gyro Gearloose's Lab",
    LEVEL_FOREST_EDGE:  "Donald Duck is in \"Forest Edge\"",
    LEVEL_THE_GORGE: "Donald Duck is in \"The Gorge\"",
    LEVEL_DANGEROUS_CLIFF: "Donald Duck is in \"Dangerous Cliff\"",
    LEVEL_HUEYS_TRACK: "Donald Duck is in \"Huey's Track\"",
    LEVEL_FIRST_AVENUE: "Donald Duck is in \"First Avenue\"",
    LEVEL_THE_ROOFS: "Donald Duck is in \"The Roofs\"",
    LEVEL_URBAN_HIGH_RISES: "Donald Duck is in \"Urban High-Rises\"",
    LEVEL_DEWEYS_ROOFTOPS: "Donald Duck is in \"Dewey's Rooftops\"",
    LEVEL_HAUNTED_HALL: "Donald Duck is in \"Haunted Hall\"",
    LEVEL_EARIE_ALLEY: "Donald Duck is in \"Earie Alley\"",
    LEVEL_GHOSTLY_PATH: "Donald Duck is in \"Ghostly Path\"",
    LEVEL_LOUIES_CREEPY_CORRIDOR: "Donald Duck is in \"Louie's Creepy Corridor\"",
    LEVEL_TEMPLES_ENTRANCE: "Donald Duck is in \"Temple's Entrance\"",
    LEVEL_ARTIFACT_WAY: "Donald Duck is in \"Artifact Way\"",
    LEVEL_ANCIENT_FATE: "Donald Duck is in \"Ancient Fate\"",
    LEVEL_THE_NEPHEWS_MURKY_WAY: "Donald Duck is in \"The Nephews' Murky Way\"",
    LEVEL_BEARS_PATH: "Donald Duck is being chased in \"Bears' Path\"",
    LEVEL_MAIN_STREET: "Donald Duck is being chased in \"Main Street\"",
    LEVEL_UNDER_HANDED: "Donald Duck is being chased in \"Under 'Hand'ed\"",
    LEVEL_HEAD_ALLEY: "Donald Duck is being chased in \"Head Alley\"",
    LEVEL_BERNADETTES_PEAK: "Donald Duck is fighting Bernadette the Bird in \"Bernadette's Peak\"",
    LEVEL_BEAGLE_BOYS_TOWER: "Donald Duck is fighting the Beagle Boy in \"Beagle Boy's Tower\"",
    LEVEL_MAGICAS_DEVILISH_DOME: "Donald Duck is fighting Magica De Spell in \"Magica's Devilsh Dome\"",
    LEVEL_CEREMONIAL_ROOM: "Donald Duck is fighting Merlock the Wizard in \"Ceremonial Room\"",
}

for level in rp_strings
{
    rich_presence_conditional_display(
        in_level(level),
        rp_strings[level]
    )
}
rich_presence_display("🦆Donald Duck is going to save Daisy!🦆")