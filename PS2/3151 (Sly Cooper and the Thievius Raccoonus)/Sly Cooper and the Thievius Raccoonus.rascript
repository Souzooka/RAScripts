// Sly Cooper and the Thievius Raccoonus
// #ID = 3151
// #MinimumVersion = 1.3

// Script Helper Functions

NULL = 0
True = 1
False = 0

US = 0
JP = 1
regions = [US]
function IsRegion(region)
{
    // TODO
    return byte(0x0) == byte(0x0)
}

function if_else(cond, v1, v2)
{
    if cond == true
    {
        return v1
    }
    return v2
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

// Object Constructors

function _CLevelStats(addr)
{
    // Object constructor for the level statistics instance
    obj = {
        // Key Obtained
        "m_key": bit1(addr + 0),
        // Safe Cracked
        "m_safe": bit2(addr + 0),
        // Time Trial Complete
        "m_sprint": bit3(addr + 0),
        // IGT (in seconds)
        "m_time": float(addr + 4), 
        // Best time remaining for time trial completion (seconds)
        "m_time_trial_record": float(addr + 8),
        // Number of bottles collected in level
        "m_bottles": dword(addr + 0x64),
    }
    return obj
}

function _CWorldStats(addr)
{
    // Object constructor for the world statistics instance
    obj = {
        // Statistics for each level
        "m_levels": [],
        // Number of keys collected
        "m_keys": dword(addr + 0x438),
        // Number of safes cracked
        "m_safes": dword(addr + 0x43C),
        // Number of sprints done
        "m_sprints": dword(addr + 0x440),
        // IGT (in seconds)
        "m_time": dword(addr + 0x444),
    }
    
    for i in range(0, NUM_LEVELS - 1)
    {
        offset = 0 + (0x78 * i)
        array_push(obj["m_levels"], _CLevelStats(addr + offset))
    }
    
    return obj
}

function _CGameStats(addr)
{
    obj = {
        // IGT (in seconds)
        "m_time": float(addr + 0xC),
        // Statistics for each world
        "m_worlds": [],
        // World ID
        "m_world_id": dword(addr + 0x19D8),
        // Level ID
        "m_level_id": dword(addr + 0x19DC),
        // Player lives remaining
        "m_lives": dword(addr + 0x19E0),
        // Current lucky charm (0=None, 1=White, 2=Gold) (i.e. extra hits)
        "m_lucky_charms": dword(addr + 0x19E4),
        // Current coins (wraps back to 0 at 100)
        "m_coins": dword(addr + 0x19E8),
        // 32-bit bitset of Sly powerups?
        "m_powerups": dword(addr + 0x19F0),
    }
    
    for i in range(0, NUM_WORLDS - 1)
    {
        offset = 0x10 + (0x44C * i)
        array_push(obj["m_worlds"], _CWorldStats(addr + offset))
    }
    
    return obj
}

// Game Helper Functions

function GetCurrentLevelStats(region)
{
    // Returns the level stats for the current level
    return _CLevelStats(g_p_level_stats[region])
}

function GetLevelStats(region, world_id, level_id)
{
    // Returns the level stats for a particular world/level ID pair
    assert(0 <= level_id && level_id < NUM_LEVELS)
    world = GetWorldStats(region, world_id)
    return world["m_levels"][level_id]
}

function GetCurrentWorldStats(region)
{
    return _CWorldStats(g_p_world_stats[region])
}

function GetWorldStats(region, world_id)
{
    assert(0 <= world_id && world_id < NUM_WORLDS)
    return GameStats[region]["m_worlds"][world_id]
}

function GetGameStats(region)
{
    return _CGameStats(g_p_game_stats[region])
}

function KeyObtained(region, world_id, level_id, now=true)
{
    level = GetLevelStats(region, world_id, level_id)
    key = level["m_key"]
    
    if now
    {
        return key > prev(key)
    }
    return key == True
}

function SafeObtained(region, world_id, level_id, now=true)
{
    level = GetLevelStats(region, world_id, level_id)
    safe = level["m_safe"]
    
    if now
    {
        return safe > prev(safe)
    }
    return safe == True
}

function TallySafes(region)
{
    // Check current (sum should equal total)
    sum = 0
    for w in range(1, NUM_WORLDS - 1)
    {
        world = GetWorldStats(region, w)
        sum = sum + world["m_safes"]
    }
    
    return sum
}

function SprintObtained(region, world_id, level_id, now=true)
{
    level = GetLevelStats(region, world_id, level_id)
    sprint = level["m_sprint"]
    
    if now
    {
        return sprint > prev(sprint)
    }
    return sprint == True
}

function TallySprints(region)
{
    // Check current (sum should equal total)
    sum = 0
    for w in range(1, NUM_WORLDS - 1)
    {
        world = GetWorldStats(region, w)
        sum = sum + world["m_sprints"]
    }
    
    return sum
}

function SaveProtection(region)
{
    // TODO
    return prev(InGame(region))
}

function CheatProtection(region)
{
    // TODO
    return true
}

function IsMap(region, world_id, level_id, previous=false)
{
    game = GetGameStats(region)
    acc = if_else(previous, prev, (v) => v)
    return acc(game["m_world_id"]) == world_id && acc(game["m_level_id"]) == level_id
}

function InGame(region)
{
    switch = {
        US: dword(0x27C320),
    }
    
    return switch[region] == 0
}

// Game variables

NUM_WORLDS = 6
NUM_LEVELS = 9
TOTAL_SAFES = 19
TOTAL_SPRINTS = 19

g_p_game_stats = {
    US: dword(0x2623c0),
    JP: dword(0x262964),
}

GameStats = {
    US: GetGameStats(US),
    JP: GetGameStats(JP),
}

g_p_world_stats = {
    US: dword(0x2623c4),
    JP: dword(0x262968),
}

g_p_level_stats = {
    US: dword(0x2623c8),
    JP: dword(0x26296c),
}

// Gets set to 1 when the player hits any checkpoint in the level for the first time
// (useful for detecting the end of the prologue, as the van is a checkpoint)
g_checkpoint_hit = {
    US: dword(0x26184c),
}

g_alarm_hit = {
    US: dword(0x2623dc),
}

g_boss_health = {
    US: float(0x26e4c0),
}

// Also used for "Down Home Cooking"
g_sprint_timer = {
    US: float(0x26E9C8),
}

// For "Down Home Cooking"
g_chickens = {
    US: dword(0x26d5a8),
}

// For "Burning Rubber"
g_player_computers = {
    US: dword(0x2726ac),
}

// For "Burning Rubber"
g_enemy_computers = {
    US: dword(0x27292c),
}

// For "Bentley Comes Through"
g_bentley_packets = {
    US: dword(0x26dfa8),
}

// For "Bentley Comes Through"
g_bentley_health = {
    US: dword(0x26e228),
}

// Achievement Data

// Collectibles info

collection_params = [
    {
        "name": "Splash",
        "map": [0, 2],
    },
    {
        "name": "Paris, France",
        "map": [0, 3],
    },
    {
        "name": "The Hideout",
        "map": [0, 4],
    },
    {
        "id_key": 261370,
        "id_damageless": 261371,
        "id_safe": 261368,
        "id_sprint": 261387,
        "name": "A Stealthy Approach",
        "map": [1, 0],
        "title_damageless": "A Real Stealthy Approach",
        "title_sprint": "A Speedy Approach",
    },
    {
        "name": "Prowling the Grounds",
        "map": [1, 1],
    },
    {
        "id_key": 261466,
        "id_damageless": 261383,
        "id_safe": 261378,
        "id_sprint": 261467,
        "name": "High Class Heist",
        "map": [1, 2],
        "title_damageless": "First Class Heist",
        "title_sprint": "One Percenter Jaunt",
    },
    {
        "id_key": 261369,
        "id_damageless": 261366,
        "id_safe": 261379,
        "id_sprint": 261386,
        "name": "Into the Machine",
        "map": [1, 3],
        "title_damageless": "Is Is Hot In Here, Or Is It Just Me?",
        "title_sprint": "A Speedy Spanner Sly Spun In",
    },
    {
        "id_key": 261375,
        "id_damageless": 261385,
        "id_safe": 261380,
        "id_sprint": 261388,
        "name": "A Cunning Disguise",
        "map": [1, 4],
        "title_damageless": "Not Bad For a Master Dart Board",
        "title_sprint": "A Speedy Disguise",
    },
    {
        "id_key": 261376,
        "id_damageless": 261391,
        "id_safe": 261381,
        "id_sprint": 261389,
        "name": "The Fire Down Below",
        "map": [1, 5],
        "title_damageless": "The Fire is Dim, But Sly Slunk In",
        "title_sprint": "The Fire On Your Below",
    },
    {
        "id_key": 261373,
        "name": "Treasure in the Depths",
        "map": [1, 6],
        "title_key": "Crab.",
    },
    {
        "id_key": 261377,
        "id_damageless": 261392,
        "id_safe": 261382,
        "id_sprint": 261390,
        "name": "The Gunboat Graveyard",
        "map": [1, 7],
        "title_damageless": "Silence the Cannons!",
        "title_sprint": "The Ship Has Sailed",
    },
    {
        "id_boss": 261374,
        "id_boss_damageless": 280205,
        "boss_phases": 1,
        "name": "Eye of the Storm",
        "name_boss": "Raleigh",
        "map": [1, 8],
        "title_boss": "Raleigh Sunk",
        "title_boss_damageless": "The Bougiest of Boss Battles",
    },
    {
        "id_key": 261394,
        "id_damageless": 261397,
        "id_safe": 261395,
        "id_sprint": 261396,
        "name": "A Rocky Start",
        "map": [2, 0],
        "title_damageless": "No Echo Out Here!",
        "title_sprint": "Jackhammer Chisel",
    },
    {
        "name": "Muggshot's Turf",
        "map": [2, 1],
    },
    {
        "id_key": 261398,
        "id_damageless": 261403,
        "id_safe": 261399,
        "id_sprint": 261402,
        "name": "Boneyard Casino",
        "map": [2, 2],
        "title_damageless": "Betting From the Shadows",
        "title_sprint": "Bankruptcy Speedrun",
    },
    {
        "id_key": 261404,
        "name": "Murray's Big Gamble",
        "map": [2, 3],
        "description_key": "Get through a frustrating turret section to get the key at the end of \"Murray's Big Gamble\"",
    },
    {
        "id_key": 261405,
        "name": "At the Dog Track",
        "map": [2, 4],
        "description_key": "Manage to not pull your hair out in order to get the key from \"At the Dog Track\"",
    },
    {
        "id_key": 261406,
        "id_damageless": 280203,
        "id_safe": 261407,
        "id_sprint": 261408,
        "name": "Two to Tango",
        "map": [2, 5],
        "points_damageless": 5,
        "title_damageless": "Rough Date in Mesa City",
        "title_sprint": "Speed Dating",
    },
    {
        "id_key": 261409,
        "id_damageless": 261412,
        "id_safe": 261410,
        "id_sprint": 261411,
        "name": "Straight to the Top",
        "map": [2, 6],
        "title_damageless": "Stealth Promotion",
        "title_sprint": "Stealing Upwards",
    },
    {
        "id_key": 261413,
        "id_damageless": 261416,
        "id_safe": 261414,
        "id_sprint": 261415,
        "name": "Back Alley Heist",
        "map": [2, 7],
        "title_damageless": "Shady Dealings",
        "title_sprint": "Quick! Before the Fuzz Comes!",
    },
    {
        "id_boss": 261393,
        "id_boss_damageless": 280206,
        "boss_phases": 1,
        "name": "A Strange Reunion",
        "name_boss": "Muggshot",
        "map": [2, 8],
        "title_boss": "Muggshot Over Ice",
        "title_boss_damageless": "Straight Flush",
    },
    {
        "id_key": 261417,
        "id_damageless": 261420,
        "id_safe": 261418,
        "id_sprint": 261419,
        "name": "The Dread Swamp Path",
        "map": [3, 0],
        "title_damageless": "The Only Thing They Dread is You, Raccoon",
        "title_sprint": "The Dreaded Ghost Cooper",
    },
    {
        "name": "The Swamp's Dark Center",
        "map": [3, 1],
    },
    {
        "id_key": 261421,
        "id_damageless": 261424,
        "id_safe": 261422,
        "id_sprint": 261423,
        "name": "The Lair of the Beast",
        "map": [3, 2],
        "title_damageless": "The Beast is Blind",
        "title_sprint": "Beastly Speed",
    },
    {
        "id_key": 261427,
        "id_damageless": 261430,
        "id_safe": 261428,
        "id_sprint": 261429,
        "name": "A Grave Undertaking",
        "map": [3, 3],
        "title_damageless": "It’s Just the Wind",
        "title_sprint": "Morbidly Fast",
    },
    {
        "id_key": 261468,
        "name": "Piranha Lake",
        "map": [3, 4],
    },
    {
        "id_key": 261431,
        "id_damageless": 261434,
        "id_safe": 261432,
        "id_sprint": 261433,
        "name": "Descent into Danger",
        "map": [3, 5],
        "title_damageless": "Ascent into Legend",
        "title_sprint": "Descent into the Danger Zone",
    },
    {
        "id_key": 261426,
        "name": "A Ghastly Voyage",
        "map": [3, 6],
    },
    {
        "id_key": 261425,
        "name": "Down Home Cooking",
        "map": [3, 7],
        "description_key": "Catch enough chickens to get the key in \"Down Home Cooking\"",
    },
    {
        "id_boss": 261435,
        "id_boss_damageless": 261436,
        "boss_phases": 1,
        "name": "A Deadly Dance",
        "name_boss": "Mz Ruby",
        "map": [3, 8],
        "title_boss": "Mz Ruby's Last Dance",
        "title_boss_damageless": "You Got Some Rhythm, Raccoon",
    },
    {
        "id_key": 261437,
        "id_damageless": 261440,
        "id_safe": 261438,
        "id_sprint": 261439,
        "name": "A Perilous Ascent",
        "map": [4, 0],
        "title_damageless": "Perilous? Ha!",
        "title_sprint": "She'll Be Running Up The Mountain When She Comes",
    },
    {
        "name": "Inside the Stronghold",
        "map": [4, 1],
    },
    {
        "id_key": 261445,
        "id_damageless": 261456,
        "id_safe": 261446,
        "id_sprint": 261447,
        "name": "Flaming Temple of Flame",
        "map": [4, 2],
        "title_damageless": "No Smoke, No Fire",
        "title_sprint": "Flaming Fast",
    },
    {
        "id_key": 261448,
        "id_damageless": 261457,
        "id_safe": 261449,
        "id_sprint": 261450,
        "name": "The Unseen Foe",
        "map": [4, 3],
        "title_damageless": "Practically Nonexistent Foe",
        "title_sprint": "Too Fast For the Naked Eye",
    },
    {
        "id_key": 261442,
        "name": "The King of the Hill",
        "map": [4, 4],
    },
    {
        "id_key": 261443,
        "name": "Rapid Fire Assault",
        "map": [4, 5],
    },
    {
        "id_key": 261451,
        "id_damageless": 280204,
        "id_safe": 261452,
        "id_sprint": 261453,
        "name": "Duel by the Dragon",
        "map": [4, 6],
        "points_damageless": 5,
        "title_damageless": "Someone Set Off The Fireworks Early",
        "title_sprint": "Speed Dueling",
    },
    {
        "id_key": 261444,
        "name": "A Desperate Race",
        "map": [4, 7],
    },
    {
        "id_boss": 261441,
        "id_boss_damageless": 280207,
        "boss_phases": 1,
        "name": "Flame Fu!",
        "name_boss": "Panda King",
        "map": [4, 8],
        "title_boss": "Panda King Rained Out",
        "title_boss_damageless": "With All Fingers Intact",
    },
    {
        "name": "A Hazardous Path",
        "map": [5, 0],
    },
    {
        "name": "Burning Rubber",
        "map": [5, 2],
    },
    {
        "name": "A Daring Rescue",
        "map": [5, 3],
    },
    {
        "name": "Bentley Comes Through",
        "map": [5, 4],
    },
    {
        "name": "A Temporary Truce",
        "map": [5, 5],
    },
    {
        "name": "Sinking Peril",
        "map": [5, 6],
    },
    {
        "id_boss": 261464,
        "boss_phases": 3,
        "name": "A Strange Reunion",
        "name_boss": "Clockwerk",
        "map": [5, 8],
        "title_boss": "Clockwerk Scrapped",
    }
]

// Test data validity in case I screw up an ID
__set = {}
for param in collection_params
{
    // Assert unique achievement IDs
    suffixes = ["_key", "_damageless", "_safe", "_sprint", "_boss", "_boss_damageless"]
    for suffix in suffixes 
    {
        key = format("id{0}", suffix)
        if dictionary_contains_key(param, key)
        {
            id = param[key]
            if dictionary_contains_key(__set, id)
            {
                assert(false, format("{0} and {1} contain same ID ({2})", param["name"], __set[id], key))
            }
            __set[id] = param["name"]
        }
    }
}

// Prologue

achievement(
    id=261367,
    title="Just a Little Rendezvous",
    description="Complete the Prologue",
    points=1,
    type="progression",
    trigger=any_of(regions, region => 
        IsRegion(region) &&
        SaveProtection(region) &&
        CheatProtection(region) &&
        // Is in Police HQ
        IsMap(region, 0, 3) &&
        // Checkpoint was hit (the van is a checkpoint)
        g_checkpoint_hit[region] > prev(g_checkpoint_hit[region])
    )
)

achievement(
    id=261365,
    title="Carmelita Forgot Who Her Foe Was",
    description = "Get Sly's File at Police Headquarters without triggering the alarm",
    points=2,
    trigger=any_of(regions, region =>
        IsRegion(region) &&
        SaveProtection(region) &&
        CheatProtection(region) &&
        // In game (prevent trigger icon showing up on title)
        InGame(region) &&
        // Is in Police HQ
        IsMap(region, 0, 3) &&
        // Don't hit those alarms
        disable_when(g_alarm_hit[region] == True, until=!InGame(region)) &&
        // Get that file (crack safe in Police HQ map)
        trigger_when(SafeObtained(region, 0, 3))
    )
)

// Misc. Non-Boss Progression Achievements

achievement(
    id=261461,
    title="We're In!",
    description="Complete \"Burning Rubber\"",
    points=10,
    trigger=any_of(regions, region =>
        IsRegion(region) &&
        CheatProtection(region) &&
        // Was on Burning Rubber
        IsMap(region, 5, 2, previous=true) &&
        // Now on A Daring Rescue
        IsMap(region, 5, 3)
    )
)

achievement(
    id=261463,
    title="Nice Job, Raccoon",
    description="Complete \"A Temporary Truce\"",
    points=10,
    trigger=any_of(regions, region =>
        IsRegion(region) &&
        CheatProtection(region) &&
        // Was on A Temporary Truce
        IsMap(region, 5, 5, previous=true) &&
        // Now on Sinking Peril
        IsMap(region, 5, 6)
    )
)

// Keys (and key damageless)

// Normal key collection
for param in collection_params
{
    world = param["map"][0]
    level = param["map"][1]
    
    if (dictionary_contains_key(param, "id_key"))
    {
        id = param["id_key"]
        title = param["name"]
        if dictionary_contains_key(param, "title_key")
        {
            title = param["title_key"]
        }
        
        description = format("Get the key in \"{0}\"", param["name"])
        if dictionary_contains_key(param, "description_key")
        {
            description = param["description_key"]
        }
        
        points = world + 1
        if dictionary_contains_key(param, "points_key")
        {
            points = param["points_key"]
        }
        
        achievement(
            id=id,
            title=title,
            description=description,
            points=points,
            trigger=any_of(regions, region => 
                IsRegion(region) &&
                SaveProtection(region) &&
                CheatProtection(region) &&
                // Grab that key
                KeyObtained(region, world, level)
            )
        )
    }
}

// Damageless key collection
for param in collection_params
{
    world = param["map"][0]
    level = param["map"][1]
    
    if (dictionary_contains_key(param, "id_damageless"))
    {
        id = param["id_damageless"]
        title = param["name"]
        if dictionary_contains_key(param, "title_damageless")
        {
            title = param["title_damageless"]
        }
        
        description = format("Get the key in \"{0}\" without triggering alarms, losing a life, or losing a lucky charm. (Exit level to retry)", param["name"])
        if dictionary_contains_key(param, "description_damageless")
        {
            description = param["description_damageless"]
        }
        
        points = 10
        if dictionary_contains_key(param, "points_damageless")
        {
            points = param["points_damageless"]
        }
        
        achievement(
            id=id,
            title=title,
            description=description,
            points=points,
            type="missable",
            trigger=any_of(regions, region => 
                IsRegion(region) &&
                SaveProtection(region) &&
                CheatProtection(region) &&
                // Key not yet obtained (for trigger)
                prev(!KeyObtained(region, world, level, now=false)) &&
                // Correct map ID (for trigger)
                IsMap(region, world, level) &&
                // Don't get hit or set off those alarms :(
                disable_when(
                    GameStats[region]["m_lives"] < prev(GameStats[region]["m_lives"]) ||
                    GameStats[region]["m_lucky_charms"] < prev(GameStats[region]["m_lucky_charms"]) ||
                    g_alarm_hit[region] > prev(g_alarm_hit[region]),
                    // Reset when level is exited
                    until=!IsMap(region, world, level)
                ) &&
                // Grab that key
                trigger_when(KeyObtained(region, world, level))
            )
        )
    }
}

// Safes (excluding Police HQ)

// Safe collection
for param in collection_params
{
    world = param["map"][0]
    level = param["map"][1]
    
    if (dictionary_contains_key(param, "id_safe"))
    {
        id = param["id_safe"]
        title = format("Safe: {0}", param["name"])
        if dictionary_contains_key(param, "title_safe")
        {
            title = param["title_safe"]
        }
        
        description = format("Crack the safe in \"{0}\"", param["name"])
        if dictionary_contains_key(param, "description_safe")
        {
            description = param["description_safe"]
        }
        
        points = 5
        if dictionary_contains_key(param, "points_safe")
        {
            points = param["points_safe"]
        }
        
        achievement(
            id=id,
            title=title,
            description=description,
            points=points,
            trigger=any_of(regions, region => 
                IsRegion(region) &&
                SaveProtection(region) &&
                CheatProtection(region) &&
                // Crack that safe
                SafeObtained(region, world, level)
            )
        )
    }
}

// All Safes
achievement(
    id=261454,
    title="The Book is Finally Complete",
    description="Get back all pages of the Thievius Raccoonus",
    points=25,
    trigger=any_of(regions, region => 
        IsRegion(region) &&
        SaveProtection(region) &&
        CheatProtection(region) &&
        // Crack all those safes
        measured(TallySafes(region) == TOTAL_SAFES, when=IsRegion(region)) &&
        // Pause measured count when not in game
        disable_when(!InGame(region), until=InGame(region)) &&
        // last update should have all safes - 1
        prev(TallySafes(region)) == TOTAL_SAFES - 1
    )
)

// Master Thief Sprints

// Sprint collection
for param in collection_params
{
    world = param["map"][0]
    level = param["map"][1]
    
    if (dictionary_contains_key(param, "id_sprint"))
    {
        id = param["id_sprint"]
        title = format("Sprint: {0}", param["name"])
        if dictionary_contains_key(param, "title_sprint")
        {
            title = param["title_sprint"]
        }
        
        description = format("Complete the Master Thief Sprint in \"{0}\"", param["name"])
        if dictionary_contains_key(param, "description_sprint")
        {
            description = param["description_sprint"]
        }
        
        points = 5
        if dictionary_contains_key(param, "points_sprint")
        {
            points = param["points_sprint"]
        }
        
        achievement(
            id=id,
            title=title,
            description=description,
            points=points,
            trigger=any_of(regions, region => 
                IsRegion(region) &&
                SaveProtection(region) &&
                CheatProtection(region) &&
                // Grab that hourglass
                SprintObtained(region, world, level)
            )
        )
    }
}

// All Sprints
achievement(
    id=261455,
    title="You Are Granted the Rank of Master Thief",
    description="Complete all Master Thief Sprints",
    points=25,
    trigger=any_of(regions, region => 
        IsRegion(region) &&
        SaveProtection(region) &&
        CheatProtection(region) &&
        // Finish all those sprints
        measured(TallySprints(region) == TOTAL_SPRINTS, when=IsRegion(region)) &&
        // Pause measured count when not in game
        disable_when(!InGame(region), until=InGame(region)) &&
        // last update should have all sprints - 1
        prev(TallySprints(region)) == TOTAL_SPRINTS - 1
    )
)

// Minigames

achievement(
    id=261465,
    title="Finger Lickin' Good",
    description="Get all 50 chickens in \"Down Home Cooking\" with 20 seconds or more to spare",
    points=10,
    trigger=any_of(regions, region =>
        IsRegion(region) &&
        CheatProtection(region) &&
        // In correct level
        IsMap(region, 3, 7) &&
        // Got all the chickens
        trigger_when(g_chickens[region] == 50) &&
        // Had enough time left
        prior(g_sprint_timer[region]) >= 20.0
    )
)

achievement(
    id=261460,
    title="The Burning Smell is Normal, Right?",
    description="Finish the level \"Burning Rubber\" before the lava slugs can collect 30 computers",
    points=10,
    trigger=any_of(regions, region =>
        IsRegion(region) &&
        CheatProtection(region) &&
        // In correct level
        IsMap(region, 5, 2) &&
        // Got all the computers
        trigger_when(g_player_computers[region] == 60) &&
        // Prevented slugs from getting too many
        g_enemy_computers[region] < 30
    )
)

achievement(
    id=261462,
    title="Hackerman",
    description="Complete \"Bentley Comes Through\" without taking damage",
    points=10,
    trigger=any_of(regions, region =>
        IsRegion(region) &&
        CheatProtection(region) &&
        // In correct level
        IsMap(region, 5, 4) &&
        // Bentley's feeling fine
        g_bentley_health[region] == 5 &&
        // Got all the packets
        trigger_when(g_bentley_packets[region] == 13)
    )
)

// Bosses (and boss challenges)

function BossTrigger(region, world, level, phases=1)
{

    cond = g_boss_health[region] == 0.0 && prev(g_boss_health[region]) > 0.0

    if phases <= 1
    {
        return cond && IsMap(region, world, level)
    }
    
    return repeated(
        phases,
        cond &&
        never(GameStats[region]["m_lives"] < prev(GameStats[region]["m_lives"])) &&
        never(!IsMap(region, world, level))
    )
}

for param in collection_params
{
    if dictionary_contains_key(param, "id_boss")
    {
        world = param["map"][0]
        level = param["map"][1]
        type = if_else(world == NUM_WORLDS - 1, "win_condition", "progression")
        
        achievement(
            id=param["id_boss"],
            title=param["title_boss"],
            description=format("Defeat {0} in \"{1}\"", param["name_boss"], param["name"]),
            type=type,
            points=if_else(type == "win_condition", 25, 10),
            trigger=any_of(regions, region =>    
                IsRegion(region) &&
                SaveProtection(region) &&
                CheatProtection(region) &&
                BossTrigger(region, world, level, param["boss_phases"])
            )
        )
    }
    
    if dictionary_contains_key(param, "id_boss_damageless")
    {
        world = param["map"][0]
        level = param["map"][1]
        
        achievement(
            id=param["id_boss"],
            title=param["title_boss_damageless"],
            description=format("Defeat {0} in \"{1}\" without taking damage or dying (exit level to retry)", param["name_boss"], param["name"]),
            points=10,
            trigger=any_of(regions, region =>    
                IsRegion(region) &&
                SaveProtection(region) &&
                CheatProtection(region) &&
                trigger_when(BossTrigger(region, world, level, param["boss_phases"]))
            )
        )
    }
}

// Custom pot challenge for Panda King
pot_bits = [5, 6, 7, 8, 9, 10, 11, 12]
g_pots_offset = {
    US: 0x26143D,
}

achievement(
    id=261459,
    title="Those Belong in a Museum!",
    description="Defeat Panda King without letting him break any pots (die or exit and re-enter boss to retry)",
    points=10,
    trigger=any_of(regions, region =>
        IsRegion(region) &&
        SaveProtection(region) &&
        CheatProtection(region) &&
        trigger_when(BossTrigger(region, 4, 8)) &&
        // No pots broken
        all_of(pot_bits, pot_bit => bit(pot_bit, g_pots_offset[region]) == 0)
    )
)

achievement(
    title = "Those Belong in a Museum!", points = 10,
    description = "Defeat Panda King without letting him break any pots (die or exit and re-enter boss to retry)",
    id = 261459, badge = "296239", published = "10/30/2022 1:16:46 AM", modified = "11/18/2022 3:02:33 PM",
    trigger = dword(0x27DBF8) == 4 && dword(0x27DBFC) == 8 && trigger_when(float(0x26E4C0) == 0.0) &&
              bit5(0x26143D) == 0 && bit6(0x26143D) == 0 && bit7(0x26143D) == 0 && bit0(0x26143E) == 0 &&
              bit1(0x26143E) == 0 && bit2(0x26143E) == 0 && bit3(0x26143E) == 0 && bit4(0x26143E) == 0
)

// Misc./Easter Eggs

achievement(
    title = "BANG YOUR HEAD (Metal Health will drive you mad)", points = 1,
    description = "Have Sly and Bentley (or Murray) headbang during a radio call",
    id = 261372, badge = "296062", published = "10/30/2022 1:16:16 AM", modified = "5/7/2025 12:04:06 AM",
    trigger = never(byte(0x270B30) != 2) && repeated(100, byte(0x262CBD) <= 7) && repeated(100, byte(0x262CBD) >= 248) &&
              repeated(100, byte(0x262CF1) <= 7) && repeated(100, byte(0x262CF1) >= 248)
)

achievement(
    title = "Want One?", points = 0, type="missable",
    description = "Have Murray offer you a peanut at HQ",
    id = 261384, badge = "296299", published = "10/30/2022 1:16:20 AM", modified = "10/30/2022 1:16:20 AM",
    trigger = dword(0x27DBF8) == 0 && dword(0x27DBFC) == 4 && dword(0x109B840) == 2 && word(0xB521FC) == 2 &&
              prev(word(0xB521FC)) == 7
)

achievement(
    title = "How Did He Do That?", points = 0, type="missable",
    description = "Witness Murray's sick dance moves",
    id = 261400, badge = "296300", published = "10/30/2022 1:16:25 AM", modified = "10/30/2022 1:16:25 AM",
    trigger = dword(0x27DBF8) == 0 && dword(0x27DBFC) == 4 && dword(0x109B840) == 3 && word(0xB521FC) == 3 &&
              prev(word(0xB521FC)) == 9
)

achievement(
    title = "Hey, Can I Play?", points = 0, type="missable",
    description = "Come on Murray, at least let me pretend to be Player 2...",
    id = 261401, badge = "296301", published = "10/30/2022 1:16:26 AM", modified = "10/30/2022 1:16:26 AM",
    trigger = dword(0x27DBF8) == 0 && dword(0x27DBFC) == 4 && dword(0x109B840) == 4 && word(0xB521FC) == 1 &&
              prev(word(0xB521FC)) == 6
)

achievement(
    title = "Those Things are Defective", points = 0, type="missable",
    description = "Tell Murray to knock it off with that paddlin'",
    id = 261458, badge = "296302", published = "10/30/2022 1:16:45 AM", modified = "10/30/2022 1:16:45 AM",
    trigger = dword(0x27DBF8) == 0 && dword(0x27DBFC) == 4 && dword(0x109B840) == 5 && word(0xB521FC) == 4 &&
              prev(word(0xB521FC)) == 8
)

achievement(
    title = "Sly Cooper is The Best Anime", points = 0,
    description = "Watch \"The Tokyo Police File\"  in its entirety",
    id = 280208, badge = "309944", published = "1/12/2023 8:45:03 PM", modified = "1/12/2023 8:45:03 PM",
    trigger = repeated(6609, dword(0x2623B8) == 1 && dword(0x269A00) == 1) && never(dword(0x2623B8) == 0)
)

// Leaderboards

leaderboard(
    id = 48088, title = "Down Home Cooking: Best Time",
    description = "How fast can you catch 50 chickens?",
    start  = dword(0x27DBF8) == 3 && dword(0x27DBFC) == 7,
    cancel = dword(0x27DBFC) != 7,
    submit = dword(0x26D5A8) == 50,
    value  = measured(prior(float(0x26E9C8))),
    format = "SECS"
)

leaderboard(
    id = 52868, title = "Master Thief Sprint - A Stealthy Approach",
    description = "Complete the sprint with the most time remaining!",
    start  = dword(0x27DBF8) == 1 && dword(0x27DBFC) == 0 && prev(dword(0x26E9C0)) == 0 && dword(0x26E9C0) == 2,
    cancel = (dword(0x27DBFC) != 0 || dword(0x26E9C8) == 0 || prev(dword(0x26E9D0)) != 4294967295) &&
             dword(0x26E9D0) == 4294967295,
    submit = dword(0x26E9F0) == 1 && dword(0x262C6C) == 1 && prev(dword(0x26E9B0)) == 2 && dword(0x26E9B0) == 3,
    value  = measured(prior(float(0x26E9C8))),
    format = "SECS"
)

leaderboard(
    id = 52869, title = "Master Thief Sprint - High Class Heist",
    description = "Complete the sprint with the most time remaining!",
    start  = dword(0x27DBF8) == 1 && dword(0x27DBFC) == 2 && prev(dword(0x26E9C0)) == 0 && dword(0x26E9C0) == 2,
    cancel = (dword(0x27DBFC) != 2 || dword(0x26E9C8) == 0 || prev(dword(0x26E9D0)) != 4294967295) &&
             dword(0x26E9D0) == 4294967295,
    submit = dword(0x26E9F0) == 1 && dword(0x262C6C) == 1 && prev(dword(0x26E9B0)) == 2 && dword(0x26E9B0) == 3,
    value  = measured(prior(float(0x26E9C8))),
    format = "SECS"
)

leaderboard(
    id = 52870, title = "Master Thief Sprint - Into the Machine",
    description = "Complete the sprint with the most time remaining!",
    start  = dword(0x27DBF8) == 1 && dword(0x27DBFC) == 3 && prev(dword(0x26E9C0)) == 0 && dword(0x26E9C0) == 2,
    cancel = (dword(0x27DBFC) != 3 || dword(0x26E9C8) == 0 || prev(dword(0x26E9D0)) != 4294967295) &&
             dword(0x26E9D0) == 4294967295,
    submit = dword(0x26E9F0) == 1 && dword(0x262C6C) == 1 && prev(dword(0x26E9B0)) == 2 && dword(0x26E9B0) == 3,
    value  = measured(prior(float(0x26E9C8))),
    format = "SECS"
)

leaderboard(
    id = 52871, title = "Master Thief Sprint - A Cunning Disguise",
    description = "Complete the sprint with the most time remaining!",
    start  = dword(0x27DBF8) == 1 && dword(0x27DBFC) == 4 && prev(dword(0x26E9C0)) == 0 && dword(0x26E9C0) == 2,
    cancel = (dword(0x27DBFC) != 4 || dword(0x26E9C8) == 0 || prev(dword(0x26E9D0)) != 4294967295) &&
             dword(0x26E9D0) == 4294967295,
    submit = dword(0x26E9F0) == 1 && dword(0x262C6C) == 1 && prev(dword(0x26E9B0)) == 2 && dword(0x26E9B0) == 3,
    value  = measured(prior(float(0x26E9C8))),
    format = "SECS"
)

leaderboard(
    id = 52872, title = "Master Thief Sprint - The Fire Down Below",
    description = "Complete the sprint with the most time remaining!",
    start  = dword(0x27DBF8) == 1 && dword(0x27DBFC) == 5 && prev(dword(0x26E9C0)) == 0 && dword(0x26E9C0) == 2,
    cancel = (dword(0x27DBFC) != 5 || dword(0x26E9C8) == 0 || prev(dword(0x26E9D0)) != 4294967295) &&
             dword(0x26E9D0) == 4294967295,
    submit = dword(0x26E9F0) == 1 && dword(0x262C6C) == 1 && prev(dword(0x26E9B0)) == 2 && dword(0x26E9B0) == 3,
    value  = measured(prior(float(0x26E9C8))),
    format = "SECS"
)

leaderboard(
    id = 52873, title = "Master Thief Sprint - The Gunboat Graveyard",
    description = "Complete the sprint with the most time remaining!",
    start  = dword(0x27DBF8) == 1 && dword(0x27DBFC) == 7 && prev(dword(0x26E9C0)) == 0 && dword(0x26E9C0) == 2,
    cancel = (dword(0x27DBFC) != 7 || dword(0x26E9C8) == 0 || prev(dword(0x26E9D0)) != 4294967295) &&
             dword(0x26E9D0) == 4294967295,
    submit = dword(0x26E9F0) == 1 && dword(0x262C6C) == 1 && prev(dword(0x26E9B0)) == 2 && dword(0x26E9B0) == 3,
    value  = measured(prior(float(0x26E9C8))),
    format = "SECS"
)

leaderboard(
    id = 52874, title = "Master Thief Sprint - A Rocky Start",
    description = "Complete the sprint with the most time remaining!",
    start  = dword(0x27DBF8) == 2 && dword(0x27DBFC) == 0 && prev(dword(0x26E9C0)) == 0 && dword(0x26E9C0) == 2,
    cancel = (dword(0x27DBFC) != 0 || dword(0x26E9C8) == 0 || prev(dword(0x26E9D0)) != 4294967295) &&
             dword(0x26E9D0) == 4294967295,
    submit = dword(0x26E9F0) == 1 && dword(0x262C6C) == 1 && prev(dword(0x26E9B0)) == 2 && dword(0x26E9B0) == 3,
    value  = measured(prior(float(0x26E9C8))),
    format = "SECS"
)

leaderboard(
    id = 52875, title = "Master Thief Sprint - Boneyard Casino",
    description = "Complete the sprint with the most time remaining!",
    start  = dword(0x27DBF8) == 2 && dword(0x27DBFC) == 2 && prev(dword(0x26E9C0)) == 0 && dword(0x26E9C0) == 2,
    cancel = (dword(0x27DBFC) != 2 || dword(0x26E9C8) == 0 || prev(dword(0x26E9D0)) != 4294967295) &&
             dword(0x26E9D0) == 4294967295,
    submit = dword(0x26E9F0) == 1 && dword(0x262C6C) == 1 && prev(dword(0x26E9B0)) == 2 && dword(0x26E9B0) == 3,
    value  = measured(prior(float(0x26E9C8))),
    format = "SECS"
)

leaderboard(
    id = 52876, title = "Master Thief Sprint - Two to Tango",
    description = "Complete the sprint with the most time remaining!",
    start  = dword(0x27DBF8) == 2 && dword(0x27DBFC) == 5 && prev(dword(0x26E9B0)) != 2 && dword(0x26E9B0) == 2,
    cancel = (dword(0x27DBFC) != 5 || dword(0x26E9C8) == 0 || prev(dword(0x26E9C0)) == 2) && dword(0x26E9C0) == 0,
    submit = dword(0x26E9F0) == 0 && dword(0x14E6700) == 0 && dword(0x275F84) == 0 && dword(0x3C3B70) > 3339580513 &&
             prev(dword(0x26E9B0)) == 2 && dword(0x26E9B0) == 3,
    value  = measured(prior(float(0x26E9C8))),
    format = "SECS"
)

leaderboard(
    id = 52877, title = "Master Thief Sprint - Straight to the Top",
    description = "Complete the sprint with the most time remaining!",
    start  = dword(0x27DBF8) == 2 && dword(0x27DBFC) == 6 && prev(dword(0x26E9C0)) == 0 && dword(0x26E9C0) == 2,
    cancel = (dword(0x27DBFC) != 6 || dword(0x26E9C8) == 0 || prev(dword(0x26E9D0)) != 4294967295) &&
             dword(0x26E9D0) == 4294967295,
    submit = dword(0x26E9F0) == 1 && dword(0x262C6C) == 1 && prev(dword(0x26E9B0)) == 2 && dword(0x26E9B0) == 3,
    value  = measured(prior(float(0x26E9C8))),
    format = "SECS"
)

leaderboard(
    id = 52878, title = "Master Thief Sprint - Back Alley Heist",
    description = "Complete the sprint with the most time remaining!",
    start  = dword(0x27DBF8) == 2 && dword(0x27DBFC) == 7 && prev(dword(0x26E9C0)) == 0 && dword(0x26E9C0) == 2,
    cancel = (dword(0x27DBFC) != 7 || dword(0x26E9C8) == 0 || prev(dword(0x26E9D0)) != 4294967295) &&
             dword(0x26E9D0) == 4294967295,
    submit = dword(0x26E9F0) == 1 && dword(0x262C6C) == 1 && prev(dword(0x26E9B0)) == 2 && dword(0x26E9B0) == 3,
    value  = measured(prior(float(0x26E9C8))),
    format = "SECS"
)

leaderboard(
    id = 52879, title = "Master Thief Sprint - The Dread Swamp Path",
    description = "Complete the sprint with the most time remaining!",
    start  = dword(0x27DBF8) == 3 && dword(0x27DBFC) == 0 && prev(dword(0x26E9C0)) == 0 && dword(0x26E9C0) == 2,
    cancel = (dword(0x27DBFC) != 0 || dword(0x26E9C8) == 0 || prev(dword(0x26E9D0)) != 4294967295) &&
             dword(0x26E9D0) == 4294967295,
    submit = dword(0x26E9F0) == 1 && dword(0x262C6C) == 1 && prev(dword(0x26E9B0)) == 2 && dword(0x26E9B0) == 3,
    value  = measured(prior(float(0x26E9C8))),
    format = "SECS"
)

leaderboard(
    id = 52880, title = "Master Thief Sprint - The Lair of the Beast",
    description = "Complete the sprint with the most time remaining!",
    start  = dword(0x27DBF8) == 3 && dword(0x27DBFC) == 2 && prev(dword(0x26E9C0)) == 0 && dword(0x26E9C0) == 2,
    cancel = (dword(0x27DBFC) != 2 || dword(0x26E9C8) == 0 || prev(dword(0x26E9D0)) != 4294967295) &&
             dword(0x26E9D0) == 4294967295,
    submit = dword(0x26E9F0) == 1 && dword(0x262C6C) == 1 && prev(dword(0x26E9B0)) == 2 && dword(0x26E9B0) == 3,
    value  = measured(prior(float(0x26E9C8))),
    format = "SECS"
)

leaderboard(
    id = 52881, title = "Master Thief Sprint - A Grave Undertaking",
    description = "Complete the sprint with the most time remaining!",
    start  = dword(0x27DBF8) == 3 && dword(0x27DBFC) == 3 && prev(dword(0x26E9C0)) == 0 && dword(0x26E9C0) == 2,
    cancel = (dword(0x27DBFC) != 3 || dword(0x26E9C8) == 0 || prev(dword(0x26E9D0)) != 4294967295) &&
             dword(0x26E9D0) == 4294967295,
    submit = dword(0x26E9F0) == 1 && dword(0x262C6C) == 1 && prev(dword(0x26E9B0)) == 2 && dword(0x26E9B0) == 3,
    value  = measured(prior(float(0x26E9C8))),
    format = "SECS"
)

leaderboard(
    id = 52882, title = "Master Thief Sprint - Descent into Danger",
    description = "Complete the sprint with the most time remaining!",
    start  = dword(0x27DBF8) == 3 && dword(0x27DBFC) == 5 && prev(dword(0x26E9C0)) == 0 && dword(0x26E9C0) == 2,
    cancel = (dword(0x27DBFC) != 5 || dword(0x26E9C8) == 0 || prev(dword(0x26E9D0)) != 4294967295) &&
             dword(0x26E9D0) == 4294967295,
    submit = dword(0x26E9F0) == 1 && dword(0x262C6C) == 1 && prev(dword(0x26E9B0)) == 2 && dword(0x26E9B0) == 3,
    value  = measured(prior(float(0x26E9C8))),
    format = "SECS"
)

leaderboard(
    id = 52883, title = "Master Thief Sprint - A Perilous Ascent",
    description = "Complete the sprint with the most time remaining!",
    start  = dword(0x27DBF8) == 4 && dword(0x27DBFC) == 0 && prev(dword(0x26E9C0)) == 0 && dword(0x26E9C0) == 2,
    cancel = (dword(0x27DBFC) != 0 || dword(0x26E9C8) == 0 || prev(dword(0x26E9D0)) != 4294967295) &&
             dword(0x26E9D0) == 4294967295,
    submit = dword(0x26E9F0) == 1 && dword(0x262C6C) == 1 && prev(dword(0x26E9B0)) == 2 && dword(0x26E9B0) == 3,
    value  = measured(prior(float(0x26E9C8))),
    format = "SECS"
)

leaderboard(
    id = 52884, title = "Master Thief Sprint - Flaming Temple of Flame",
    description = "Complete the sprint with the most time remaining!",
    start  = dword(0x27DBF8) == 4 && dword(0x27DBFC) == 2 && prev(dword(0x26E9C0)) == 0 && dword(0x26E9C0) == 2,
    cancel = (dword(0x27DBFC) != 2 || dword(0x26E9C8) == 0 || prev(dword(0x26E9D0)) != 4294967295) &&
             dword(0x26E9D0) == 4294967295,
    submit = dword(0x26E9F0) == 1 && dword(0x262C6C) == 1 && prev(dword(0x26E9B0)) == 2 && dword(0x26E9B0) == 3,
    value  = measured(prior(float(0x26E9C8))),
    format = "SECS"
)

leaderboard(
    id = 52885, title = "Master Thief Sprint - The Unseen Foe",
    description = "Complete the sprint with the most time remaining!",
    start  = dword(0x27DBF8) == 4 && dword(0x27DBFC) == 3 && prev(dword(0x26E9C0)) == 0 && dword(0x26E9C0) == 2,
    cancel = (dword(0x27DBFC) != 3 || dword(0x26E9C8) == 0 || prev(dword(0x26E9D0)) != 4294967295) &&
             dword(0x26E9D0) == 4294967295,
    submit = dword(0x26E9F0) == 1 && dword(0x262C6C) == 1 && prev(dword(0x26E9B0)) == 2 && dword(0x26E9B0) == 3,
    value  = measured(prior(float(0x26E9C8))),
    format = "SECS"
)

leaderboard(
    id = 52886, title = "Master Thief Sprint - Duel by the Dragon",
    description = "Complete the sprint with the most time remaining!",
    start  = dword(0x27DBF8) == 4 && dword(0x27DBFC) == 6 && prev(dword(0x26E9C0)) == 0 && dword(0x26E9C0) == 2,
    cancel = (dword(0x27DBFC) != 6 || dword(0x26E9C8) == 0 || prev(dword(0x26E9D0)) != 4294967295) &&
             dword(0x26E9D0) == 4294967295,
    submit = dword(0x26E9F0) == 1 && dword(0x262C6C) == 1 && prev(dword(0x26E9B0)) == 2 && dword(0x26E9B0) == 3,
    value  = measured(prior(float(0x26E9C8))),
    format = "SECS"
)
