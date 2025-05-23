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

function IsSplash(region)
{
    return IsMap(region, 0, 2)
}

function IsParis(region)
{
    return IsMap(region, 0, 3)
}

function IsHideout(region)
{
    return IsMap(region, 0, 4)
}

function IsApproach(region)
{
    return GameStats[region]["m_level_id"] == 0
}

function IsHub(region)
{
    return GameStats[region]["m_level_id"] == 1
}

function IsBoss(region)
{
    return GameStats[region]["m_level_id"] == 8
}

function IsTreasureGame(region)
{
    return IsMap(region, 1, 6)
}

function IsSlyTurretSegment(region)
{
    ids = [
        [2, 3],
        [4, 4],
        [5, 0],
    ]
    
    return any_of(ids, ids => IsMap(region, ids[0], ids[1]))
}

function IsCarmelitaTurretSegment(region)
{
    return IsMap(region, 5, 5)
}

function IsRace(region)
{
    ids = [
        [2, 4],
        [4, 7],
    ]
    
    return any_of(ids, ids => IsMap(region, ids[0], ids[1]))
}

function IsBurningRubber(region)
{
    return IsMap(region, 5, 2)
}

function IsBentley(region)
{
    return IsMap(region, 5, 4)
}

function IsPiranha(region)
{
    return IsMap(region, 3, 4)
}

function IsChicken(region)
{
    return IsMap(region, 3, 7)
}

function IsScooter(region)
{
    ids = [
        [3, 6],
        [4, 5],
    ]
    
    return any_of(ids, ids => IsMap(region, ids[0], ids[1]))
}

function IsRussiaSlyLevel(region)
{
    ids = [
        [5, 3],
        [5, 6],
    ]
    
    return any_of(ids, ids => IsMap(region, ids[0], ids[1]))
}

function IsNormalSlyLevel(region)
{
    ids = [
        [1, 0],
        [1, 2],
        [1, 3],
        [1, 4],
        [1, 5],
        [1, 7],
        [2, 0],
        [2, 2],
        [2, 5],
        [2, 6],
        [2, 7],
        [2, 8],
        [3, 0],
        [3, 2],
        [3, 3],
        [3, 5],
        [4, 0],
        [4, 2],
        [4, 3],
        [4, 6],
    ]
    
    return any_of(ids, ids => IsMap(region, ids[0], ids[1]))
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

g_game_paused = {
    US: dword(0x262C6C),
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

g_sprint_state = {
    US: dword(0x26E9C0),
}

g_sprint_sub_state = {
    US: dword(0x26E9B0)
}

// Also used for "Down Home Cooking"
g_sprint_timer = {
    US: float(0x26E9C8),
}

g_sprint_seconds = {
    US: dword(0x26e9d0),
}

// 1 = inactive, 0 = active
g_sprint_inactive = {
    US: dword(0x26e9f0)
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
        "id_sprint_leaderboard": 52868,
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
        "id_sprint_leaderboard": 52869,
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
        "id_sprint_leaderboard": 52870,
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
        "id_sprint_leaderboard": 52871,
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
        "id_sprint_leaderboard": 52872,
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
        "id_sprint_leaderboard": 52873,
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
        "id_sprint_leaderboard": 52874,
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
        "id_sprint_leaderboard": 52875,
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
        "id_sprint_leaderboard": 52876,
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
        "id_sprint_leaderboard": 52877,
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
        "id_sprint_leaderboard": 52878,
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
        "id_sprint_leaderboard": 52879,
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
        "id_sprint_leaderboard": 52880,
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
        "id_sprint_leaderboard": 52881,
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
        "id_sprint_leaderboard": 52882,
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
        "id_sprint_leaderboard": 52883,
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
        "id_sprint_leaderboard": 52884,
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
        "id_sprint_leaderboard": 52885,
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
        "id_sprint_leaderboard": 52886,
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
        IsParis(region) &&
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
        IsParis(region) &&
        // Don't hit those alarms
        disable_when(
            prev(g_alarm_hit[region]) == False &&
            g_alarm_hit[region] == True, 
            until=
                !InGame(region) || 
                // Allow reset if the player dies (as they'll get sent back to start anyways)
                // g_checkpoint_hit check just in case there's some hidden checkpoint somehow somewhere
                (GameStats[region]["m_lives"] < prev(GameStats[region]["m_lives"]) && g_checkpoint_hit[region] == 0)
        ) &&
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
        IsChicken(region) &&
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
        IsBurningRubber(region) &&
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
        IsBentley(region) &&
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
            id=param["id_boss_damageless"],
            title=param["title_boss_damageless"],
            description=format("Defeat {0} in \"{1}\" without taking damage or dying (exit level to retry)", param["name_boss"], param["name"]),
            points=10,
            trigger=any_of(regions, region =>    
                IsRegion(region) &&
                SaveProtection(region) &&
                CheatProtection(region) &&
                IsMap(region, world, level) &&
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
        IsMap(region, 4, 8) &&
        trigger_when(BossTrigger(region, 4, 8)) &&
        // No pots broken
        all_of(pot_bits, pot_bit => bit(pot_bit, g_pots_offset[region]) == 0)
    )
)

// Misc./Easter Eggs

// Silly dynamic addresses
g_murray_value = {
    US: dword(0xb521fc)
}

g_world_selected = {
    US: dword(0x109b840),
}

murray_params = [
    {
        "id": 261384,
        "title": "Want One?",
        "description": "Have Murray offer you a peanut at HQ",
        "world": 2,
        "transition": [7, 2]
    },
    {
        "id": 261400,
        "title": "How Did He Do That?",
        "description": "Witness Murray's sick dance moves",
        "world": 3,
        "transition": [9, 3]
    },
    {
        "id": 261401,
        "title": "Hey, Can I Play?",
        "description": "Come on Murray, at least let me pretend to be Player 2...",
        "world": 4,
        "transition": [6, 1]
    },
    {
        "id": 261458,
        "title": "Those Things are Defective",
        "description": "Tell Murray to knock it off with that paddlin'",
        "world": 5,
        "transition": [8, 4]
    },
]

// Murray
for param in murray_params
{
    achievement(
        id=param["id"],
        title=param["title"],
        description=param["description"],
        type="missable",
        points=0,
        trigger=any_of(regions, region =>
            IsRegion(region) &&
            IsHideout(region) &&
            g_world_selected[region] == param["world"] &&
            prev(g_murray_value[region]) == param["transition"][0] &&
            g_murray_value[region] == param["transition"][1]
        )
    )
}

// Headbangs
g_left_radio_window = {
    US: dword(0x270b30),
}

g_right_radio_window = {
    US: dword(0x2717a8),
}


// 0x0 (down) to 0xFF (up)
g_left_stick_y = {
    US: byte(0x262cbd),
}
g_right_stick_y = {
    US: byte(0x262cf1),
}

ACTIONS = 6 // How many times the player has to bring the stick up, and the stick down
STAY = 50 // How many frames the player has to have the stick in the up and the down positions
DEADZONE = 8 // Tolerance zone for the vertical extremes of the controller axis

UP = 0xFF - DEADZONE
DOWN = DEADZONE
WiggleUp = (region) => 
    repeated(ACTIONS, prev(g_left_stick_y[region]) < UP && g_right_stick_y[region] >= UP) &&
    repeated(ACTIONS, prev(g_left_stick_y[region]) >= UP && g_right_stick_y[region] < UP) &&
    repeated(STAY, g_left_stick_y[region] >= UP) &&
    repeated(ACTIONS, prev(g_right_stick_y[region]) < UP && g_right_stick_y[region] >= UP) &&
    repeated(ACTIONS, prev(g_right_stick_y[region]) >= UP && g_right_stick_y[region] < UP) &&
    repeated(STAY, g_right_stick_y[region] >= UP)
WiggleDown = (region) => 
    repeated(ACTIONS, prev(g_left_stick_y[region]) > DOWN && g_right_stick_y[region] <= DOWN) &&
    repeated(ACTIONS, prev(g_left_stick_y[region]) <= DOWN && g_right_stick_y[region] > DOWN) &&
    repeated(STAY, g_left_stick_y[region] <= DOWN) &&
    repeated(ACTIONS, prev(g_right_stick_y[region]) > DOWN && g_right_stick_y[region] <= DOWN) &&
    repeated(ACTIONS, prev(g_right_stick_y[region]) <= DOWN && g_right_stick_y[region] > DOWN) &&
    repeated(STAY, g_right_stick_y[region] <= DOWN)

achievement(
    id=261372,
    title="BANG YOUR HEAD (Metal Health will drive you mad)", 
    description="Have Sly and Bentley (or Murray) headbang during a radio call",
    points=1,
    trigger=any_of(regions, region =>
        IsRegion(region) &&
        // Left Radio Window should be open
        never(g_left_radio_window[region] != 2) &&
        // Right Radio Window should be open
        never(g_right_radio_window[region] != 2) &&
        // Wiggle those sticks
        WiggleUp(region) &&
        WiggleDown(region)
    )
)

// Watch that anime
g_in_movie = {
    US: dword(0x2623b8),
}

g_movie_type = {
    US: dword(0x269A00)
}

MOVIE_LENGTH = 6609

achievement(
    id=280208,
    title="Sly Cooper is The Best Anime",
    description="Watch \"The Tokyo Police File\" in its entirety",
    points=0,
    trigger=any_of(regions, region =>
        IsRegion(region) &&
        repeated(
            MOVIE_LENGTH,
            g_in_movie[region] == True &&
            never(g_in_movie[region] == False) &&
            g_movie_type[region] == 1
        )
    )
)

// Leaderboards

// Why not CENTISECS :(
LEADERBOARD_FORMAT = "SECS"
LEADERBOARD_START = (world, level) => 
    any_of(regions, region =>
        IsRegion(region) &&
        IsMap(region, world, level) &&
        // Sprint started
        prev(g_sprint_state[region]) == 0 &&
        g_sprint_state[region] == 2
    )
LEADERBOARD_CANCEL = (world, level) =>
    any_of(regions, region =>
        IsRegion(region) &&
        __ornext(
            !CheatProtection(region) ||
            __ornext(!IsMap(region, world, level)) ||
            g_sprint_timer[region] == 0.0 ||
            g_sprint_seconds[region] == -1
        )
    )
LEADERBOARD_SUBMIT = (world, level) =>
    any_of(regions, region =>
        IsRegion(region) &&
        g_sprint_inactive[region] == True &&
        g_game_paused[region] == True &&
        prev(g_sprint_sub_state[region]) == 2 &&
        g_sprint_sub_state[region] == 3
    )
LEADERBOARD_VALUE = max_of(
    // Previously was using the prior value of the sprint timer, but the time value is preserved when finishing the sprint,
    // so that doesn't seem to be necessary?
    array_map(regions, region => measured(g_sprint_timer[region], when=IsRegion(region)))
)

// Super secret hidden glitch leaderboard
leaderboard(
    id=0,
    title="You're Supposed to Steal the File, You Know",
    description="Complete the prologue in the fastest time without stealing the police file!",
    start=any_of(regions, region =>
        IsRegion(region) &&
        IsParis(region) &&
        !SafeObtained(region, 0, 3) &&
        g_checkpoint_hit[region] == True
    ),
    cancel=always_false(),
    submit=always_true(),
    value=max_of(
        array_map(regions, region =>
            measured(
                GameStats[region]["m_worlds"][0]["m_levels"][3]["m_time"], 
                when=IsRegion(region)
            )
        )
    ),
    lower_is_better=true,
    format="CENTISECS"
)

// Custom chicken leaderboard
leaderboard(
    id=48088,
    title="Down Home Cooking: Best Time",
    description="How fast can you catch 50 chickens?",
    start=any_of(regions, region =>
        IsRegion(region) &&
        CheatProtection(region) &&
        __ornext(!IsMap(region, 3, 7, previous=true)) &&
        IsMap(region, 3, 7)
    ),
    cancel=any_of(regions, region =>
        (IsRegion(region) &&
        __ornext(!IsMap(region, 3, 7))) ||
        !CheatProtection(region)
    ),
    submit=any_of(regions, region =>
        IsRegion(region) &&
        g_chickens[region] == 50
    ),
    value=LEADERBOARD_VALUE,
    format=LEADERBOARD_FORMAT
)

// Speedrun leaderboards

for param in collection_params
{
    if dictionary_contains_key(param, "id_sprint_leaderboard")
    {
        world = param["map"][0]
        level = param["map"][1]
        
        leaderboard(
            id=param["id_sprint_leaderboard"],
            title=format("Master Thief Sprint - {0}", param["name"]),
            description="Complete the sprint with the most time remaining!",
            start=LEADERBOARD_START(world, level),
            cancel=LEADERBOARD_CANCEL(world, level),
            submit=LEADERBOARD_SUBMIT(world, level),
            value=LEADERBOARD_VALUE,
            format=LEADERBOARD_FORMAT
        )
    }
}
