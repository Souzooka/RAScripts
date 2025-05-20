// Sly Cooper and the Thievius Raccoonus
// #ID = 3151
// #MinimumVersion = 1.3

// Script Helper Functions

NULL = 0
True = 1
False = 0

US = 0
regions = [US]
function IsRegion(region)
{
    return true
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
        "m_time_trial": bit3(addr + 0),
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

function GetLevelStats(game, world_id, level_id)
{
    // Returns the level stats for a particular world/level ID pair
    assert(0 <= level_id && level_id < NUM_LEVELS)
    world = GetWorldStats(game, world_id)
    return world["m_levels"][level_id]
}

function GetCurrentWorldStats(region)
{
    return _CWorldStats(g_p_world_stats[region])
}

function GetWorldStats(game, world_id)
{
    assert(0 <= world_id && world_id < NUM_WORLDS)
    return game["m_worlds"][world_id]
}

function GetGameStats(region)
{
    return _CGameStats(g_p_game_stats[region])
}

function KeyObtained(region, world_id, level_id, now=true)
{
    game = GetGameStats(region)
    level = GetLevelStats(game, world_id, level_id)
    key = level["m_key"]
    
    if now
    {
        return key > prev(key)
    }
    return key == True
}

function SafeObtained(region, world_id, level_id, now=true)
{
    game = GetGameStats(region)
    level = GetLevelStats(game, world_id, level_id)
    safe = level["m_safe"]
    
    if now
    {
        return safe > prev(safe)
    }
    return safe == True
}

function AllSafes(region)
{
    game = GetGameStats(region)
    cond = always_true()
    
    // Should be 19 over the 4 worlds
    total = 19
    
    // Check current (sum should equal total)
    sum = 0
    for w in range(1, NUM_WORLDS - 1)
    {
        world = GetWorldStats(region, w)
        sum = sum + world["m_safes"]
    }
    
    cond = cond && sum == total
    
    // Check previous (sum should equal total - 1)
    sum = 0
    for w in range(1, NUM_WORLDS - 1)
    {
        world = GetWorldStats(region, w)
        sum = sum + prev(world["m_safes"])
    }
    
    return cond && sum == (total - 1)
}

function SprintObtained(region, world_id, level_id, now=true)
{
    game = GetGameStats(region)
    level = GetLevelStats(game, world_id, level_id)
    sprint = level["m_sprint"]
    
    if now
    {
        return sprint > prev(safe)
    }
    return sprint == True
}

function AllSprints(region)
{
    game = GetGameStats(region)
    cond = always_true()
    
    // Should be 19 over the 4 worlds
    total = 19
    
    // Check current (sum should equal total)
    sum = 0
    for w in range(1, NUM_WORLDS - 1)
    {
        world = GetWorldStats(region, w)
        sum = sum + world["m_sprints"]
    }
    
    cond = cond && sum == total
    
    // Check previous (sum should equal total - 1)
    sum = 0
    for w in range(1, NUM_WORLDS - 1)
    {
        world = GetWorldStats(region, w)
        sum = sum + prev(world["m_sprints"])
    }
    
    return cond && sum == (total - 1)
}

function SaveProtection(region)
{
    // TODO
    return true
}

function CheatProtection(region)
{
    // TODO
    return true
}

function IsMap(region, world_id, level_id)
{
    game = GetGameStats(region)
    return game["m_world_id"] == world_id && game["m_level_id"] == level_id
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

g_p_game_stats = {
    US: dword(0x2623c0),
}

GameStats = {
    US: GetGameStats(US),
}

g_p_world_stats = {
    US: dword(0x2623c4),
}

g_p_level_stats = {
    US: dword(0x2623c8),
}

// Gets set to 1 when the player hits any checkpoint in the level for the first time
// (useful for detecting the end of the prologue, as the van is a checkpoint)
g_checkpoint_hit = {
    US: dword(0x26184c),
}

g_alarm_hit = {
    US: dword(0x2623dc),
}

// Achievement Data

// Collectibles info

collection_params = [
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
]

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

achievement(
    title = "A Rocky Start", points = 3,
    description = "Get the Key in \"A Rocky Start\"",
    id = 261394, badge = "296069", published = "10/30/2022 1:16:23 AM", modified = "11/18/2022 9:13:44 PM",
    trigger = dword(0x27DBF8) == 2 && dword(0x27DBFC) == 0 && bit1(0x27CAC8) > prev(bit1(0x27CAC8)) &&
              prev(dword(0x27C320)) == 0
)

achievement(
    title = "Boneyard Casino", points = 3,
    description = "Get the Key in \"Boneyard Casino\"",
    id = 261398, badge = "296073", published = "10/30/2022 1:16:25 AM", modified = "11/18/2022 9:13:44 PM",
    trigger = dword(0x27DBF8) == 2 && dword(0x27DBFC) == 2 && bit1(0x27CBB8) > prev(bit1(0x27CBB8)) &&
              prev(dword(0x27C320)) == 0
)

achievement(
    title = "Murray's Big Gamble", points = 3,
    description = "Get through a frustrating turret section to get the key at the end of \"Murray's Big Gamble\"",
    id = 261404, badge = "296077", published = "10/30/2022 1:16:27 AM", modified = "11/18/2022 9:13:45 PM",
    trigger = dword(0x27DBF8) == 2 && dword(0x27DBFC) == 3 && bit1(0x27CC30) > prev(bit1(0x27CC30)) &&
              prev(dword(0x27C320)) == 0
)

achievement(
    title = "At the Dog Track", points = 3,
    description = "Manage to not pull your hair out in order to get the key from \"At the Dog Track\"",
    id = 261405, badge = "296078", published = "10/30/2022 1:16:27 AM", modified = "11/18/2022 9:13:45 PM",
    trigger = dword(0x27DBF8) == 2 && dword(0x27DBFC) == 4 && bit1(0x27CCA8) > prev(bit1(0x27CCA8)) &&
              prev(dword(0x27C320)) == 0
)

achievement(
    title = "Two to Tango", points = 3,
    description = "Get the key at the end of \"Two to Tango\"",
    id = 261406, badge = "296079", published = "10/30/2022 1:16:27 AM", modified = "11/18/2022 9:13:45 PM",
    trigger = dword(0x27DBF8) == 2 && dword(0x27DBFC) == 5 && bit1(0x27CD20) > prev(bit1(0x27CD20)) &&
              prev(dword(0x27C320)) == 0
)

achievement(
    title = "Straight to the Top", points = 3,
    description = "Get the Key in \"Straight to the Top\"",
    id = 261409, badge = "296083", published = "10/30/2022 1:16:28 AM", modified = "11/18/2022 9:13:46 PM",
    trigger = dword(0x27DBF8) == 2 && dword(0x27DBFC) == 6 && bit1(0x27CD98) > prev(bit1(0x27CD98)) &&
              prev(dword(0x27C320)) == 0
)

achievement(
    title = "Back Alley Heist", points = 3,
    description = "Get the Key from \"Back Alley Heist\"",
    id = 261413, badge = "296087", published = "10/30/2022 1:16:30 AM", modified = "11/18/2022 9:13:46 PM",
    trigger = dword(0x27DBF8) == 2 && dword(0x27DBFC) == 7 && bit1(0x27CE10) > prev(bit1(0x27CE10)) &&
              prev(dword(0x27C320)) == 0
)

achievement(
    title = "The Dread Swamp Path", points = 4,
    description = "Get the key at the end of \"The Dread Swamp Path\"",
    id = 261417, badge = "296093", published = "10/30/2022 1:16:31 AM", modified = "11/18/2022 9:13:47 PM",
    trigger = dword(0x27DBF8) == 3 && dword(0x27DBFC) == 0 && bit1(0x27CF14) > prev(bit1(0x27CF14)) &&
              prev(dword(0x27C320)) == 0
)

achievement(
    title = "The Lair of the Beast", points = 4,
    description = "Get the key in \"The Lair of the Beast\"",
    id = 261421, badge = "296097", published = "10/30/2022 1:16:32 AM", modified = "11/18/2022 9:13:47 PM",
    trigger = dword(0x27DBF8) == 3 && dword(0x27DBFC) == 2 && bit1(0x27D004) > prev(bit1(0x27D004)) &&
              prev(dword(0x27C320)) == 0
)

achievement(
    title = "A Grave Undertaking", points = 4,
    description = "Get the key in \"A Grave Undertaking\"",
    id = 261427, badge = "296102", published = "10/30/2022 1:16:35 AM", modified = "11/18/2022 9:13:48 PM",
    trigger = dword(0x27DBF8) == 3 && dword(0x27DBFC) == 3 && bit1(0x27D07C) > prev(bit1(0x27D07C)) &&
              prev(dword(0x27C320)) == 0
)

achievement(
    title = "Piranha Lake", points = 4,
    description = "Get the key in \"Piranha Lake\"",
    id = 261468, badge = "296101", published = "10/30/2022 1:17:33 AM", modified = "11/18/2022 9:13:48 PM",
    trigger = dword(0x27DBF8) == 3 && dword(0x27DBFC) == 4 && bit1(0x27D0F4) > prev(bit1(0x27D0F4)) &&
              prev(dword(0x27C320)) == 0
)

achievement(
    title = "Descent into Danger", points = 4,
    description = "Get the key in \"Descent into Danger\"",
    id = 261431, badge = "296147", published = "10/30/2022 1:16:36 AM", modified = "11/18/2022 9:13:49 PM",
    trigger = dword(0x27DBF8) == 3 && dword(0x27DBFC) == 5 && bit1(0x27D16C) > prev(bit1(0x27D16C)) &&
              prev(dword(0x27C320)) == 0
)

achievement(
    title = "A Ghastly Voyage", points = 4,
    description = "Get the key in \"A Ghastly Voyage\"",
    id = 261426, badge = "296151", published = "10/30/2022 1:16:34 AM", modified = "11/18/2022 9:13:49 PM",
    trigger = dword(0x27DBF8) == 3 && dword(0x27DBFC) == 6 && bit1(0x27D1E4) > prev(bit1(0x27D1E4)) &&
              prev(dword(0x27C320)) == 0
)

achievement(
    title = "Down Home Cooking", points = 4,
    description = "Catch enough chickens to get the key in \"Down Home Cooking\"",
    id = 261425, badge = "296106", published = "10/30/2022 1:16:34 AM", modified = "11/19/2022 1:33:09 AM",
    trigger = dword(0x27DBF8) == 3 && dword(0x27DBFC) == 7 && bit1(0x27D25C) > prev(bit1(0x27D25C)) &&
              prev(dword(0x27C320)) == 0
)

achievement(
    title = "A Perilous Ascent", points = 5,
    description = "Get the key in \"A Perilous Ascent\"",
    id = 261437, badge = "296238", published = "10/30/2022 1:16:38 AM", modified = "11/18/2022 9:13:50 PM",
    trigger = dword(0x27DBF8) == 4 && dword(0x27DBFC) == 0 && bit1(0x27D360) > prev(bit1(0x27D360)) &&
              prev(dword(0x27C320)) == 0
)

achievement(
    title = "Flaming Temple of Flame", points = 5,
    description = "Get the key in \"Flaming Temple of Flame\"",
    id = 261445, badge = "296281", published = "10/30/2022 1:16:41 AM", modified = "11/18/2022 9:13:51 PM",
    trigger = dword(0x27DBF8) == 4 && dword(0x27DBFC) == 2 && bit1(0x27D450) > prev(bit1(0x27D450)) &&
              prev(dword(0x27C320)) == 0
)

achievement(
    title = "The Unseen Foe", points = 5,
    description = "Get the key in \"The Unseen Foe\"",
    id = 261448, badge = "296285", published = "10/30/2022 1:16:42 AM", modified = "11/18/2022 9:13:51 PM",
    trigger = dword(0x27DBF8) == 4 && dword(0x27DBFC) == 3 && bit1(0x27D4C8) > prev(bit1(0x27D4C8)) &&
              prev(dword(0x27C320)) == 0
)

achievement(
    title = "The King of the Hill", points = 5,
    description = "Get the key from \"The King of the Hill\"",
    id = 261442, badge = "294030", published = "10/30/2022 1:16:40 AM", modified = "11/18/2022 9:13:51 PM",
    trigger = dword(0x27DBF8) == 4 && dword(0x27DBFC) == 4 && bit1(0x27D540) > prev(bit1(0x27D540)) &&
              prev(dword(0x27C320)) == 0
)

achievement(
    title = "Rapid Fire Assault", points = 5,
    description = "Get the key in \"Rapid Fire Assault\"",
    id = 261443, badge = "296289", published = "10/30/2022 1:16:40 AM", modified = "11/18/2022 9:13:52 PM",
    trigger = dword(0x27DBF8) == 4 && dword(0x27DBFC) == 5 && bit1(0x27D5B8) > prev(bit1(0x27D5B8)) &&
              prev(dword(0x27C320)) == 0
)

achievement(
    title = "Duel by the Dragon", points = 5,
    description = "Get the key in \"Duel by the Dragon\"",
    id = 261451, badge = "296291", published = "10/30/2022 1:16:43 AM", modified = "11/18/2022 9:13:52 PM",
    trigger = dword(0x27DBF8) == 4 && dword(0x27DBFC) == 6 && bit1(0x27D630) > prev(bit1(0x27D630)) &&
              prev(dword(0x27C320)) == 0
)

achievement(
    title = "A Desperate Race", points = 5,
    description = "Get the key in \"A Desperate Race\"",
    id = 261444, badge = "296290", published = "10/30/2022 1:16:40 AM", modified = "11/18/2022 9:13:53 PM",
    trigger = dword(0x27DBF8) == 4 && dword(0x27DBFC) == 7 && bit1(0x27D6A8) > prev(bit1(0x27D6A8)) &&
              prev(dword(0x27C320)) == 0
)

achievement(
    title = "A Real Stealthy Approach", points = 10, type="missable",
    description = "Get the key at the end of A Stealthy Approach without triggering alarms, losing a life, or losing a lucky charm. (Exit level to retry)",
    id = 261371, badge = "296029", published = "10/30/2022 1:16:16 AM", modified = "11/18/2022 9:14:12 PM",
    trigger = dword(0x27DBF8) == 1 && trigger_when(bit1(0x27C67C) > prev(bit1(0x27C67C))) &&
              disable_when(dword(0x27DC00) < prev(dword(0x27DC00))) &&
              disable_when(dword(0x27DC04) < prev(dword(0x27DC04))) && disable_when(dword(0x2623DC) == 1) &&
              prev(bit1(0x27C67C)) != 1 && prev(dword(0x27C320)) == 0 &&
              (always_false() || (never(dword(0x27DBFC) != 0)))
)

achievement(
    title = "First Class Heist", points = 10, type="missable",
    description = "Get the key at the end of \"High Class Heist\" without triggering alarms, losing a life, or losing a lucky charm. (Exit level to retry)",
    id = 261383, badge = "296033", published = "10/30/2022 1:16:20 AM", modified = "11/18/2022 9:14:12 PM",
    trigger = dword(0x27DBF8) == 1 && trigger_when(bit1(0x27C76C) > prev(bit1(0x27C76C))) &&
              disable_when(dword(0x27DC00) < prev(dword(0x27DC00))) &&
              disable_when(dword(0x27DC04) < prev(dword(0x27DC04))) && disable_when(dword(0x2623DC) == 1) &&
              prev(bit1(0x27C76C)) != 1 && prev(dword(0x27C320)) == 0 &&
              (always_false() || (never(dword(0x27DBFC) != 2)))
)

achievement(
    title = "Is Is Hot In Here, Or Is It Just Me?", points = 10, type="missable",
    description = "Get the key at the end of \"Into the Machine\" without triggering alarms, losing a life, or losing a lucky charm",
    id = 261366, badge = "296046", published = "10/30/2022 1:16:14 AM", modified = "11/18/2022 9:14:13 PM",
    trigger = dword(0x27DBF8) == 1 && trigger_when(bit1(0x27C7E4) > prev(bit1(0x27C7E4))) &&
              disable_when(dword(0x27DC00) < prev(dword(0x27DC00))) &&
              disable_when(dword(0x27DC04) < prev(dword(0x27DC04))) && disable_when(dword(0x2623DC) == 1) &&
              prev(bit1(0x27C7E4)) != 1 && prev(dword(0x27C320)) == 0 &&
              (always_false() || (never(dword(0x27DBFC) != 3)))
)

achievement(
    title = "Not Bad For a Master Dart Board", points = 10, type="missable",
    description = "Get the key at the end of \"A Cunning Disguise\" without triggering alarms, losing a life, or losing a lucky charm. (Exit level to retry)",
    id = 261385, badge = "296050", published = "10/30/2022 1:16:20 AM", modified = "11/18/2022 9:14:13 PM",
    trigger = dword(0x27DBF8) == 1 && trigger_when(bit1(0x27C85C) > prev(bit1(0x27C85C))) &&
              disable_when(dword(0x27DC00) < prev(dword(0x27DC00))) &&
              disable_when(dword(0x27DC04) < prev(dword(0x27DC04))) && disable_when(dword(0x2623DC) == 1) &&
              prev(bit1(0x27C85C)) != 1 && prev(dword(0x27C320)) == 0 &&
              (always_false() || (never(dword(0x27DBFC) != 4)))
)

achievement(
    title = "The Fire is Dim, But Sly Slunk In", points = 10, type="missable",
    description = "Get the key at the end of \"The Fire Down Below\" without triggering alarms, losing a life, or losing a lucky charm. (Exit level to retry)",
    id = 261391, badge = "296061", published = "10/30/2022 1:16:22 AM", modified = "11/18/2022 9:14:13 PM",
    trigger = dword(0x27DBF8) == 1 && trigger_when(bit1(0x27C8D4) > prev(bit1(0x27C8D4))) &&
              disable_when(dword(0x27DC00) < prev(dword(0x27DC00))) &&
              disable_when(dword(0x27DC04) < prev(dword(0x27DC04))) && disable_when(dword(0x2623DC) == 1) &&
              prev(bit1(0x27C8D4)) != 1 && prev(dword(0x27C320)) == 0 &&
              (always_false() || (never(dword(0x27DBFC) != 5)))
)

achievement(
    title = "Silence the Cannons!", points = 10, type="missable",
    description = "Get the key at the end of \"The Gunboat Graveyard\" without triggering alarms, losing a life, or losing a lucky charm. (Exit level to retry)",
    id = 261392, badge = "296067", published = "10/30/2022 1:16:23 AM", modified = "11/19/2022 10:53:46 PM",
    trigger = dword(0x27DBF8) == 1 && trigger_when(bit1(0x27C9C4) > prev(bit1(0x27C9C4))) &&
              disable_when(dword(0x27DC00) < prev(dword(0x27DC00))) &&
              disable_when(dword(0x27DC04) < prev(dword(0x27DC04))) && disable_when(dword(0x2623DC) == 1) &&
              prev(bit1(0x27C9C4)) != 1 && prev(dword(0x27C320)) == 0 &&
              (always_false() || (never(dword(0x27DBFC) != 7)))
)

achievement(
    title = "No Echo Out Here!", points = 10, type="missable",
    description = "Get the Key in \"A Rocky Start\" without triggering alarms, losing a life, or losing a lucky charm. (Exit level to retry)",
    id = 261397, badge = "296072", published = "10/30/2022 1:16:24 AM", modified = "11/19/2022 1:49:45 AM",
    trigger = dword(0x27DBF8) == 2 && trigger_when(bit1(0x27CAC8) > prev(bit1(0x27CAC8))) &&
              disable_when(dword(0x27DC00) < prev(dword(0x27DC00))) &&
              disable_when(dword(0x27DC04) < prev(dword(0x27DC04))) && disable_when(dword(0x2623DC) == 1) &&
              prev(bit1(0x27CAC8)) != 1 && prev(dword(0x27C320)) == 0 &&
              (always_false() || (never(dword(0x27DBFC) != 0)))
)

achievement(
    title = "Betting From the Shadows", points = 10, type="missable",
    description = "Get the Key in \"Boneyard Casino\" without triggering alarms, losing a life, or losing a lucky charm. (Exit level to retry)",
    id = 261403, badge = "296076", published = "10/30/2022 1:16:26 AM", modified = "11/18/2022 9:14:15 PM",
    trigger = dword(0x27DBF8) == 2 && trigger_when(bit1(0x27CBB8) > prev(bit1(0x27CBB8))) &&
              disable_when(dword(0x27DC00) < prev(dword(0x27DC00))) &&
              disable_when(dword(0x27DC04) < prev(dword(0x27DC04))) && disable_when(dword(0x2623DC) == 1) &&
              prev(bit1(0x27CBB8)) != 1 && prev(dword(0x27C320)) == 0 &&
              (always_false() || (never(dword(0x27DBFC) != 2)))
)

achievement(
    title = "Stealth Promotion", points = 10, type="missable",
    description = "Get the Key in \"Straight to the Top\" without triggering alarms, losing a life, or losing a lucky charm. (Exit level to retry)",
    id = 261412, badge = "296086", published = "10/30/2022 1:16:29 AM", modified = "11/18/2022 9:14:16 PM",
    trigger = dword(0x27DBF8) == 2 && trigger_when(bit1(0x27CD98) > prev(bit1(0x27CD98))) &&
              disable_when(dword(0x27DC00) < prev(dword(0x27DC00))) &&
              disable_when(dword(0x27DC04) < prev(dword(0x27DC04))) && disable_when(dword(0x2623DC) == 1) &&
              prev(bit1(0x27CD98)) != 1 && prev(dword(0x27C320)) == 0 &&
              (always_false() || (never(dword(0x27DBFC) != 6)))
)

achievement(
    title = "Rough Date in Mesa City", points = 5, type="missable",
    description = "Get the key at the end of \"Two to Tango\" without taking damage or dying (exit level to reset)",
    id = 280203, badge = "309939", published = "1/12/2023 8:45:00 PM", modified = "5/5/2025 5:04:54 PM",
    trigger = dword(0x27DBF8) == 2 && trigger_when(bit1(0x27CD20) > prev(bit1(0x27CD20))) && prev(dword(0x27C320)) == 0 &&
              disable_when(dword(0x27DC00) < prev(dword(0x27DC00))) &&
              disable_when(dword(0x27DC04) < prev(dword(0x27DC04))) && prev(bit1(0x27D630)) != 1 &&
              (always_false() || (never(dword(0x27DBFC) != 5)))
)

achievement(
    title = "Shady Dealings", points = 10, type="missable",
    description = "Get the Key from \"Back Alley Heist\" without triggering alarms, losing a life, or losing a lucky charm. (Exit level to retry)",
    id = 261416, badge = "296091", published = "10/30/2022 1:16:31 AM", modified = "5/5/2025 3:39:24 PM",
    trigger = dword(0x27DBF8) == 2 && trigger_when(bit1(0x27CE10) > prev(bit1(0x27CE10))) &&
              disable_when(dword(0x27DC00) < prev(dword(0x27DC00))) &&
              disable_when(dword(0x27DC04) < prev(dword(0x27DC04))) && disable_when(dword(0x2623DC) == 1) &&
              prev(bit1(0x27CE10)) != 1 && prev(dword(0x27C320)) == 0 &&
              (always_false() || (never(dword(0x27DBFC) != 7)))
)

achievement(
    title = "The Only Thing They Dread is You, Raccoon", points = 10, type="missable",
    description = "Get the key at the end of \"The Dread Swamp Path\" without triggering alarms, losing a life, or losing a lucky charm. (Exit level to retry)",
    id = 261420, badge = "296096", published = "10/30/2022 1:16:32 AM", modified = "11/18/2022 9:14:17 PM",
    trigger = dword(0x27DBF8) == 3 && trigger_when(bit1(0x27CF14) > prev(bit1(0x27CF14))) &&
              disable_when(dword(0x27DC00) < prev(dword(0x27DC00))) &&
              disable_when(dword(0x27DC04) < prev(dword(0x27DC04))) && disable_when(dword(0x2623DC) == 1) &&
              prev(dword(0x27C320)) == 0 &&
              (always_false() || (never(dword(0x27DBFC) != 0)))
)

achievement(
    title = "The Beast is Blind", points = 10, type="missable",
    description = "Get the key in \"The Lair of the Beast\" without tripping alarms, losing a life, or losing a lucky charm. (Exit level to retry)",
    id = 261424, badge = "296100", published = "10/30/2022 1:16:33 AM", modified = "11/18/2022 9:14:18 PM",
    trigger = dword(0x27DBF8) == 3 && trigger_when(bit1(0x27D004) > prev(bit1(0x27D004))) &&
              disable_when(dword(0x27DC00) < prev(dword(0x27DC00))) &&
              disable_when(dword(0x27DC04) < prev(dword(0x27DC04))) && disable_when(dword(0x2623DC) == 1) &&
              prev(bit1(0x27D004)) != 1 && prev(dword(0x27C320)) == 0 &&
              (always_false() || (never(dword(0x27DBFC) != 2)))
)

achievement(
    title = "It’s Just the Wind", points = 10, type="missable",
    description = "Get the key in \"A Grave Undertaking\" without tripping alarms, losing a life, or losing a lucky charm. (Exit level to retry)",
    id = 261430, badge = "296105", published = "10/30/2022 1:16:36 AM", modified = "11/18/2022 9:14:18 PM",
    trigger = dword(0x27DBF8) == 3 && trigger_when(bit1(0x27D07C) > prev(bit1(0x27D07C))) &&
              disable_when(dword(0x27DC00) < prev(dword(0x27DC00))) &&
              disable_when(dword(0x27DC04) < prev(dword(0x27DC04))) && disable_when(dword(0x2623DC) == 1) &&
              prev(bit1(0x27D07C)) != 1 && prev(dword(0x27C320)) == 0 &&
              (always_false() || (never(dword(0x27DBFC) != 3)))
)

achievement(
    title = "Ascent into Legend", points = 10, type="missable",
    description = "Get the key in \"Descent into Danger\" without triggering alarms, losing a life, or losing a lucky charm. (Exit level to retry)",
    id = 261434, badge = "296150", published = "10/30/2022 1:16:37 AM", modified = "11/18/2022 9:14:19 PM",
    trigger = dword(0x27DBF8) == 3 && trigger_when(bit1(0x27D16C) > prev(bit1(0x27D16C))) &&
              disable_when(dword(0x27DC00) < prev(dword(0x27DC00))) &&
              disable_when(dword(0x27DC04) < prev(dword(0x27DC04))) && disable_when(dword(0x2623DC) == 1) &&
              prev(bit1(0x27D16C)) != 1 && prev(dword(0x27C320)) == 0 &&
              (always_false() || (never(dword(0x27DBFC) != 5)))
)

achievement(
    title = "Perilous? Ha!", points = 10, type="missable",
    description = "Get the key in \"A Perilous Ascent\" without triggering alarms, losing a life, or losing a lucky charm. (Exit level to retry)",
    id = 261440, badge = "296242", published = "10/30/2022 1:16:39 AM", modified = "11/18/2022 9:14:19 PM",
    trigger = dword(0x27DBF8) == 4 && trigger_when(bit1(0x27D360) > prev(bit1(0x27D360))) &&
              disable_when(dword(0x27DC00) < prev(dword(0x27DC00))) &&
              disable_when(dword(0x27DC04) < prev(dword(0x27DC04))) && disable_when(dword(0x2623DC) == 1) &&
              prev(bit1(0x27D360)) != 1 && prev(dword(0x27C320)) == 0 &&
              (always_false() || (never(dword(0x27DBFC) != 0)))
)

achievement(
    title = "No Smoke, No Fire", points = 10, type="missable",
    description = "Get the key in \"Flaming Temple of Flame\" without triggering alarms, losing a life, or losing a lucky charm. (Exit level to retry)",
    id = 261456, badge = "296284", published = "10/30/2022 1:16:45 AM", modified = "11/18/2022 9:14:20 PM",
    trigger = dword(0x27DBF8) == 4 && trigger_when(bit1(0x27D450) > prev(bit1(0x27D450))) &&
              disable_when(dword(0x27DC00) < prev(dword(0x27DC00))) &&
              disable_when(dword(0x27DC04) < prev(dword(0x27DC04))) && disable_when(dword(0x2623DC) == 1) &&
              prev(bit1(0x27D450)) != 1 && prev(dword(0x27C320)) == 0 &&
              (always_false() || (never(dword(0x27DBFC) != 2)))
)

achievement(
    title = "Practically Nonexistent Foe", points = 10, type="missable",
    description = "Get the key in \"The Unseen Foe\" without triggering alarms, losing a life, or losing a lucky charm. (Exit level to retry)",
    id = 261457, badge = "296288", published = "10/30/2022 1:16:45 AM", modified = "11/18/2022 9:14:20 PM",
    trigger = dword(0x27DBF8) == 4 && trigger_when(bit1(0x27D4C8) > prev(bit1(0x27D4C8))) &&
              disable_when(dword(0x27DC00) < prev(dword(0x27DC00))) &&
              disable_when(dword(0x27DC04) < prev(dword(0x27DC04))) && disable_when(dword(0x2623DC) == 1) &&
              prev(bit1(0x27D4C8)) != 1 && prev(dword(0x27C320)) == 0 &&
              (always_false() || (never(dword(0x27DBFC) != 3)))
)

achievement(
    title = "Someone Set Off The Fireworks Early", points = 5, type="missable",
    description = "Get the key in \"Duel by the Dragon\" without taking damage or dying (exit level to retry)",
    id = 280204, badge = "309940", published = "1/12/2023 8:45:00 PM", modified = "1/13/2023 6:58:02 PM",
    trigger = dword(0x27DBF8) == 4 && trigger_when(bit1(0x27D630) > prev(bit1(0x27D630))) && prev(dword(0x27C320)) == 0 &&
              disable_when(dword(0x27DC00) < prev(dword(0x27DC00))) &&
              disable_when(dword(0x27DC04) < prev(dword(0x27DC04))) && prev(bit1(0x27D630)) != 1 &&
              (always_false() || (never(dword(0x27DBFC) != 6)))
)

// Misc. Progression Achievements

achievement(
    title = "We're In!", points = 10,
    description = "Complete \"Burning Rubber\"",
    id = 261461, badge = "296295", published = "10/30/2022 1:16:46 AM", modified = "10/30/2022 1:16:46 AM",
    trigger = dword(0x27DBF8) == 5 && prev(dword(0x27DBFC)) == 2 && dword(0x27DBFC) == 3
)

achievement(
    title = "Nice Job, Raccoon", points = 10,
    description = "Complete \"A Temporary Truce\"",
    id = 261463, badge = "296296", published = "10/30/2022 1:16:47 AM", modified = "10/30/2022 1:16:47 AM",
    trigger = dword(0x27DBF8) == 5 && prev(dword(0x27DBFC)) == 5 && dword(0x27DBFC) == 6
)

// Safes (excluding Police HQ)

achievement(
    title = "Safe: A Stealthy Approach", points = 5,
    description = "Crack the safe in \"A Stealthy Approach\"",
    id = 261368, badge = "296027", published = "10/30/2022 1:16:15 AM", modified = "11/18/2022 9:13:53 PM",
    trigger = dword(0x27DBF8) == 1 && dword(0x27DBFC) == 0 && bit2(0x27C67C) > prev(bit2(0x27C67C)) &&
              prev(dword(0x27C320)) == 0
)

achievement(
    title = "Safe: High Class Heist", points = 5,
    description = "Crack the Safe in \"High Class Heist\"",
    id = 261378, badge = "296031", published = "10/30/2022 1:16:18 AM", modified = "11/18/2022 9:13:54 PM",
    trigger = dword(0x27DBF8) == 1 && dword(0x27DBFC) == 2 && bit2(0x27C76C) > prev(bit2(0x27C76C)) &&
              prev(dword(0x27C320)) == 0
)

achievement(
    title = "Safe: Into the Machine", points = 5,
    description = "Crack the safe in \"Into the Machine\"",
    id = 261379, badge = "296044", published = "10/30/2022 1:16:18 AM", modified = "11/18/2022 9:41:30 PM",
    trigger = bit2(0x27C7E4) > prev(bit2(0x27C7E4)) && dword(0x27DBF8) == 1 && dword(0x27DBFC) == 3 &&
              prev(dword(0x27C320)) == 0
)

achievement(
    title = "Safe: A Cunning Disguise", points = 5,
    description = "Crack the safe in \"A Cunning Disguise\"",
    id = 261380, badge = "296048", published = "10/30/2022 1:16:19 AM", modified = "11/18/2022 9:13:55 PM",
    trigger = dword(0x27DBF8) == 1 && dword(0x27DBFC) == 4 && bit2(0x27C85C) > prev(bit2(0x27C85C)) &&
              prev(dword(0x27C320)) == 0
)

achievement(
    title = "Safe: The Fire Down Below", points = 5,
    description = "Crack the safe in \"The Fire Down Below\"",
    id = 261381, badge = "296059", published = "10/30/2022 1:16:19 AM", modified = "11/18/2022 9:13:55 PM",
    trigger = dword(0x27DBF8) == 1 && dword(0x27DBFC) == 5 && bit2(0x27C8D4) > prev(bit2(0x27C8D4)) &&
              prev(dword(0x27C320)) == 0
)

achievement(
    title = "Safe: The Gunboat Graveyard", points = 5,
    description = "Crack the safe in \"The Gunboat Graveyard\"",
    id = 261382, badge = "296065", published = "10/30/2022 1:16:19 AM", modified = "11/18/2022 9:13:56 PM",
    trigger = dword(0x27DBF8) == 1 && dword(0x27DBFC) == 7 && bit2(0x27C9C4) > prev(bit2(0x27C9C4)) &&
              prev(dword(0x27C320)) == 0
)

achievement(
    title = "Safe: A Rocky Start", points = 5,
    description = "Crack the Safe in \"A Rocky Start\"",
    id = 261395, badge = "296070", published = "10/30/2022 1:16:24 AM", modified = "11/18/2022 9:13:56 PM",
    trigger = dword(0x27DBF8) == 2 && dword(0x27DBFC) == 0 && bit2(0x27CAC8) > prev(bit2(0x27CAC8)) &&
              prev(dword(0x27C320)) == 0
)

achievement(
    title = "Safe: Boneyard Casino", points = 5,
    description = "Crack the safe in \"Boneyard Casino\"",
    id = 261399, badge = "296074", published = "10/30/2022 1:16:25 AM", modified = "11/18/2022 9:13:57 PM",
    trigger = dword(0x27DBF8) == 2 && dword(0x27DBFC) == 2 && bit2(0x27CBB8) > prev(bit2(0x27CBB8)) &&
              prev(dword(0x27C320)) == 0
)

achievement(
    title = "Safe: Two to Tango", points = 5,
    description = "Crack the safe in \"Two to Tango\"",
    id = 261407, badge = "296080", published = "10/30/2022 1:16:28 AM", modified = "11/18/2022 9:13:57 PM",
    trigger = dword(0x27DBF8) == 2 && dword(0x27DBFC) == 5 && bit2(0x27CD20) > prev(bit2(0x27CD20)) &&
              prev(dword(0x27C320)) == 0
)

achievement(
    title = "Safe: Straight to the Top", points = 5,
    description = "Crack the Safe in \"Straight to the Top\"",
    id = 261410, badge = "296084", published = "10/30/2022 1:16:29 AM", modified = "11/18/2022 9:13:58 PM",
    trigger = dword(0x27DBF8) == 2 && dword(0x27DBFC) == 6 && bit2(0x27CD98) > prev(bit2(0x27CD98)) &&
              prev(dword(0x27C320)) == 0
)

achievement(
    title = "Safe: Back Alley Heist", points = 5,
    description = "Crack the Safe from \"Back Alley Heist\"",
    id = 261414, badge = "296088", published = "10/30/2022 1:16:30 AM", modified = "11/18/2022 9:13:58 PM",
    trigger = dword(0x27DBF8) == 2 && dword(0x27DBFC) == 7 && bit2(0x27CE10) > prev(bit2(0x27CE10)) &&
              prev(dword(0x27C320)) == 0
)

achievement(
    title = "Safe: The Dread Swamp Path", points = 5,
    description = "Crack the Safe in \"The Dread Swamp Path\"",
    id = 261418, badge = "296094", published = "10/30/2022 1:16:31 AM", modified = "11/18/2022 9:13:59 PM",
    trigger = dword(0x27DBF8) == 3 && dword(0x27DBFC) == 0 && bit2(0x27CF14) > prev(bit2(0x27CF14)) &&
              prev(dword(0x27C320)) == 0
)

achievement(
    title = "Safe: The Lair of the Beast", points = 5,
    description = "Crack the safe in \"The Lair of the Beast\"",
    id = 261422, badge = "296098", published = "10/30/2022 1:16:33 AM", modified = "11/18/2022 9:14:00 PM",
    trigger = dword(0x27DBF8) == 3 && dword(0x27DBFC) == 2 && bit2(0x27D004) > prev(bit2(0x27D004)) &&
              prev(dword(0x27C320)) == 0
)

achievement(
    title = "Safe: A Grave Undertaking", points = 5,
    description = "Crack the safe in \"A Grave Undertaking\"",
    id = 261428, badge = "296103", published = "10/30/2022 1:16:35 AM", modified = "1/8/2023 12:29:00 AM",
    trigger = dword(0x27DBF8) == 3 && dword(0x27DBFC) == 3 && bit2(0x27D07C) > prev(bit2(0x27D07C)) &&
              prev(dword(0x27C320)) == 0
)

achievement(
    title = "Safe: Descent into Danger", points = 5,
    description = "Crack the Safe in \"Descent into Danger\"",
    id = 261432, badge = "296148", published = "10/30/2022 1:16:36 AM", modified = "11/18/2022 9:14:01 PM",
    trigger = dword(0x27DBF8) == 3 && dword(0x27DBFC) == 5 && bit2(0x27D16C) > prev(bit2(0x27D16C)) &&
              prev(dword(0x27C320)) == 0
)

achievement(
    title = "Safe: A Perilous Ascent", points = 5,
    description = "Crack the Safe in \"A Perilous Ascent\"",
    id = 261438, badge = "296240", published = "10/30/2022 1:16:38 AM", modified = "11/18/2022 9:14:01 PM",
    trigger = dword(0x27DBF8) == 4 && dword(0x27DBFC) == 0 && bit2(0x27D360) > prev(bit2(0x27D360)) &&
              prev(dword(0x27C320)) == 0
)

achievement(
    title = "Safe: Flaming Temple of Flame", points = 5,
    description = "Crack the Safe in \"Flaming Temple of Flame\"",
    id = 261446, badge = "296282", published = "10/30/2022 1:16:41 AM", modified = "11/18/2022 9:14:02 PM",
    trigger = dword(0x27DBF8) == 4 && dword(0x27DBFC) == 2 && bit2(0x27D450) > prev(bit2(0x27D450)) &&
              prev(dword(0x27C320)) == 0
)

achievement(
    title = "Safe: The Unseen Foe", points = 5,
    description = "Crack the safe in \"The Unseen Foe\"",
    id = 261449, badge = "296286", published = "10/30/2022 1:16:42 AM", modified = "11/18/2022 9:14:02 PM",
    trigger = dword(0x27DBF8) == 4 && dword(0x27DBFC) == 3 && bit2(0x27D4C8) > prev(bit2(0x27D4C8)) &&
              prev(dword(0x27C320)) == 0
)

achievement(
    title = "Safe: Duel by the Dragon", points = 5,
    description = "Crack the safe in \"Duel by the Dragon\"",
    id = 261452, badge = "296292", published = "10/30/2022 1:16:43 AM", modified = "11/18/2022 9:14:03 PM",
    trigger = dword(0x27DBF8) == 4 && dword(0x27DBFC) == 6 && bit2(0x27D630) > prev(bit2(0x27D630)) &&
              prev(dword(0x27C320)) == 0
)

achievement(
    title = "The Book is Finally Complete", points = 25,
    description = "Get back all pages of the Thievius Racoonus",
    id = 261454, badge = "296297", published = "10/30/2022 1:16:44 AM", modified = "10/30/2022 1:16:44 AM",
    trigger = dword(0x27CAB8) == 6 && dword(0x27CF04) == 5 && dword(0x27D350) == 4 && dword(0x27D79C) == 4 &&
              ((prev(dword(0x27CAB8)) == 5) ||
               (prev(dword(0x27CF04)) == 4) ||
               (prev(dword(0x27D350)) == 3) ||
               (prev(dword(0x27D79C)) == 3))
)

// Master Thief Sprints

achievement(
    title = "A Speedy Approach", points = 5,
    description = "Complete the Master Thief Sprint in \"A Stealthy Approach\"",
    id = 261387, badge = "296028", published = "10/30/2022 1:16:21 AM", modified = "11/18/2022 9:14:03 PM",
    trigger = dword(0x27DBF8) == 1 && dword(0x27DBFC) == 0 && bit3(0x27C67C) > prev(bit3(0x27C67C)) &&
              prev(dword(0x27C320)) == 0
)

achievement(
    title = "One Percenter Jaunt", points = 5,
    description = "Complete the Master Thief Sprint for \"High Class Heist\"",
    id = 261467, badge = "296032", published = "10/30/2022 1:17:32 AM", modified = "11/18/2022 9:14:04 PM",
    trigger = dword(0x27DBF8) == 1 && dword(0x27DBFC) == 2 && bit3(0x27C76C) > prev(bit3(0x27C76C)) &&
              prev(dword(0x27C320)) == 0
)

achievement(
    title = "A Speedy Spanner Sly Spun In", points = 5,
    description = "Complete the Master Thief Sprint for \"Into the Machine\"",
    id = 261386, badge = "296045", published = "10/30/2022 1:16:21 AM", modified = "11/18/2022 9:14:05 PM",
    trigger = dword(0x27DBF8) == 1 && dword(0x27DBFC) == 3 && bit3(0x27C7E4) > prev(bit3(0x27C7E4)) &&
              prev(dword(0x27C320)) == 0
)

achievement(
    title = "A Speedy Disguise", points = 5,
    description = "Complete the Master Thief Sprint for \"A Cunning Disguise\"",
    id = 261388, badge = "296049", published = "10/30/2022 1:16:21 AM", modified = "11/18/2022 9:14:05 PM",
    trigger = dword(0x27DBF8) == 1 && dword(0x27DBFC) == 4 && bit3(0x27C85C) > prev(bit3(0x27C85C)) &&
              prev(dword(0x27C320)) == 0
)

achievement(
    title = "The Fire On Your Below", points = 5,
    description = "Complete the Master Thief Sprint for \"The Fire Down Below\"",
    id = 261389, badge = "296060", published = "10/30/2022 1:16:22 AM", modified = "11/18/2022 9:14:06 PM",
    trigger = dword(0x27DBF8) == 1 && dword(0x27DBFC) == 5 && bit3(0x27C8D4) > prev(bit3(0x27C8D4)) &&
              prev(dword(0x27C320)) == 0
)

achievement(
    title = "The Ship Has Sailed", points = 5,
    description = "Complete the Master Thief Sprint for \"The Gunboat Graveyard\"",
    id = 261390, badge = "296066", published = "10/30/2022 1:16:22 AM", modified = "11/18/2022 9:14:06 PM",
    trigger = dword(0x27DBF8) == 1 && dword(0x27DBFC) == 7 && bit3(0x27C9C4) > prev(bit3(0x27C9C4)) &&
              prev(dword(0x27C320)) == 0
)

achievement(
    title = "Jackhammer Chisel", points = 5,
    description = "Complete the Master Thief Sprint for \"A Rocky Start\"",
    id = 261396, badge = "296071", published = "10/30/2022 1:16:24 AM", modified = "11/18/2022 9:14:07 PM",
    trigger = dword(0x27DBF8) == 2 && dword(0x27DBFC) == 0 && bit3(0x27CAC8) > prev(bit3(0x27CAC8)) &&
              prev(dword(0x27C320)) == 0
)

achievement(
    title = "Bankruptcy Speedrun", points = 5,
    description = "Complete the Master Thief Sprint for \"Boneyard Casino\"",
    id = 261402, badge = "296075", published = "10/30/2022 1:16:26 AM", modified = "11/18/2022 9:14:07 PM",
    trigger = dword(0x27DBF8) == 2 && dword(0x27DBFC) == 2 && bit3(0x27CBB8) > prev(bit3(0x27CBB8)) &&
              prev(dword(0x27C320)) == 0
)

achievement(
    title = "Speed Dating", points = 5,
    description = "Complete the Master Thief Sprint for \"Two to Tango\"",
    id = 261408, badge = "296081", published = "10/30/2022 1:16:28 AM", modified = "11/18/2022 9:14:08 PM",
    trigger = dword(0x27DBF8) == 2 && dword(0x27DBFC) == 5 && bit3(0x27CD20) > prev(bit3(0x27CD20)) &&
              prev(dword(0x27C320)) == 0
)

achievement(
    title = "Stealing Upwards", points = 5,
    description = "Complete the Master Thief Sprint for \"Straight to the Top\"",
    id = 261411, badge = "296085", published = "10/30/2022 1:16:29 AM", modified = "11/18/2022 9:14:08 PM",
    trigger = dword(0x27DBF8) == 2 && dword(0x27DBFC) == 6 && bit3(0x27CD98) > prev(bit3(0x27CD98)) &&
              prev(dword(0x27C320)) == 0
)

achievement(
    title = "Quick! Before the Fuzz Comes!", points = 5,
    description = "Complete the Master Thief Sprint for \"Back Alley Heist\"",
    id = 261415, badge = "296089", published = "10/30/2022 1:16:30 AM", modified = "11/18/2022 9:14:09 PM",
    trigger = dword(0x27DBF8) == 2 && dword(0x27DBFC) == 7 && bit3(0x27CE10) > prev(bit3(0x27CE10)) &&
              prev(dword(0x27C320)) == 0
)

achievement(
    title = "The Dreaded Ghost Cooper", points = 5,
    description = "Complete the Master Thief Sprint for \"The Dread Swamp Path\"",
    id = 261419, badge = "296095", published = "10/30/2022 1:16:32 AM", modified = "11/18/2022 9:14:09 PM",
    trigger = dword(0x27DBF8) == 3 && dword(0x27DBFC) == 0 && bit3(0x27CF14) > prev(bit3(0x27CF14)) &&
              prev(dword(0x27C320)) == 0
)

achievement(
    title = "Beastly Speed", points = 5,
    description = "Complete the Master Thief Sprint for \"The Lair of the Beast\"",
    id = 261423, badge = "296099", published = "10/30/2022 1:16:33 AM", modified = "11/18/2022 9:14:09 PM",
    trigger = dword(0x27DBF8) == 3 && dword(0x27DBFC) == 2 && bit3(0x27D004) > prev(bit3(0x27D004)) &&
              prev(dword(0x27C320)) == 0
)

achievement(
    title = "Morbidly Fast", points = 5,
    description = "Complete the Master Thief Sprint for \"A Grave Undertaking\"",
    id = 261429, badge = "296104", published = "10/30/2022 1:16:35 AM", modified = "11/18/2022 9:14:10 PM",
    trigger = dword(0x27DBF8) == 3 && dword(0x27DBFC) == 3 && bit3(0x27D07C) > prev(bit3(0x27D07C)) &&
              prev(dword(0x27C320)) == 0
)

achievement(
    title = "Descent into the Danger Zone", points = 5,
    description = "Complete the Master Thief Sprint for \"Descent into Danger\"",
    id = 261433, badge = "296149", published = "10/30/2022 1:16:37 AM", modified = "11/18/2022 9:14:10 PM",
    trigger = dword(0x27DBF8) == 3 && dword(0x27DBFC) == 5 && bit3(0x27D16C) > prev(bit3(0x27D16C)) &&
              prev(dword(0x27C320)) == 0
)

achievement(
    title = "She’ll Be Running Up The Mountain When She Comes", points = 5,
    description = "Complete the Master Thief Sprint for \"A Perilous Ascent\"",
    id = 261439, badge = "296241", published = "10/30/2022 1:16:39 AM", modified = "11/18/2022 9:14:10 PM",
    trigger = dword(0x27DBF8) == 4 && dword(0x27DBFC) == 0 && bit3(0x27D360) > prev(bit3(0x27D360)) &&
              prev(dword(0x27C320)) == 0
)

achievement(
    title = "Flaming Fast", points = 5,
    description = "Complete the Master Thief Sprint for \"Flaming Temple of Flame\"",
    id = 261447, badge = "296283", published = "10/30/2022 1:16:41 AM", modified = "11/18/2022 9:14:11 PM",
    trigger = dword(0x27DBF8) == 4 && dword(0x27DBFC) == 2 && bit3(0x27D450) > prev(bit3(0x27D450)) &&
              prev(dword(0x27C320)) == 0
)

achievement(
    title = "Too Fast For the Naked Eye", points = 5,
    description = "Complete the Master Thief Sprint for \"The Unseen Foe\"",
    id = 261450, badge = "296287", published = "10/30/2022 1:16:43 AM", modified = "11/18/2022 9:14:11 PM",
    trigger = dword(0x27DBF8) == 4 && dword(0x27DBFC) == 3 && bit3(0x27D4C8) > prev(bit3(0x27D4C8)) &&
              prev(dword(0x27C320)) == 0
)

achievement(
    title = "Speed Dueling", points = 5,
    description = "Complete the Master Thief Sprint for \"Duel by the Dragon\"",
    id = 261453, badge = "296293", published = "10/30/2022 1:16:44 AM", modified = "11/18/2022 9:14:12 PM",
    trigger = dword(0x27DBF8) == 4 && dword(0x27DBFC) == 6 && bit3(0x27D630) > prev(bit3(0x27D630)) &&
              prev(dword(0x27C320)) == 0
)

achievement(
    title = "You Are Granted the Rank of Master Thief", points = 25,
    description = "Complete all Master Thief Sprints",
    id = 261455, badge = "296248", published = "10/30/2022 1:16:44 AM", modified = "10/30/2022 1:16:44 AM",
    trigger = dword(0x27CABC) == 6 && dword(0x27CF08) == 5 && dword(0x27D354) == 4 && dword(0x27D7A0) == 4 &&
              ((prev(dword(0x27CABC)) == 5) ||
               (prev(dword(0x27CF08)) == 4) ||
               (prev(dword(0x27D354)) == 3) ||
               (prev(dword(0x27D7A0)) == 3))
)

// Minigames

achievement(
    title = "Finger Lickin' Good", points = 10,
    description = "Get all 50 chickens in \"Down Home Cooking\" with 20 seconds or more to spare",
    id = 261465, badge = "289597", published = "10/30/2022 1:16:48 AM", modified = "11/20/2022 12:18:05 AM",
    trigger = dword(0x27DBF8) == 3 && dword(0x27DBFC) == 7 && prior(float(0x26E9C8)) >= 20.0 &&
              trigger_when(dword(0x26D5A8) == 50)
)

achievement(
    title = "The Burning Smell is Normal, Right?", points = 10,
    description = "Finish the level \"Burning Rubber\" before the lava slugs can collect 30 computers",
    id = 261460, badge = "296247", published = "10/30/2022 1:16:46 AM", modified = "11/18/2022 3:04:27 PM",
    trigger = trigger_when(dword(0x2726AC) == 60) && dword(0x27292C) < 30 && dword(0x27DBF8) == 5 &&
              dword(0x27DBFC) == 2
)

achievement(
    title = "Hackerman", points = 10,
    description = "Complete \"Bentley Comes Through\" without taking damage",
    id = 261462, badge = "296034", published = "10/30/2022 1:16:47 AM", modified = "10/30/2022 1:16:47 AM",
    trigger = dword(0x27DBF8) == 5 && dword(0x27DBFC) == 4 && dword(0x26E228) == 5 &&
              trigger_when(dword(0x26DFA8) == 13)
)

// Bosses (and boss challenges)

achievement(
    title = "Raleigh Sunk", points = 10, type="progression",
    description = "Defeat Raleigh in \"Eye of the Storm\"",
    id = 261374, badge = "296068", published = "10/30/2022 1:16:17 AM", modified = "11/18/2022 9:13:43 PM",
    trigger = dword(0x27DBF8) == 1 && dword(0x27DBFC) == 8 && float(0x26E4C0) == 0.0 && prev(dword(0x27C320)) == 0
)

achievement(
    title = "The Bougiest of Boss Battles", points = 10,
    description = "Defeat Raleigh in \"Eye of the Storm\" without taking damage or dying (exit level to retry)",
    id = 280205, badge = "309941", published = "1/12/2023 8:45:01 PM", modified = "1/12/2023 8:45:01 PM",
    trigger = dword(0x27DBF8) == 1 && trigger_when(float(0x26E4C0) == 0.0) &&
              disable_when(dword(0x27DC00) < prev(dword(0x27DC00))) &&
              disable_when(dword(0x27DC04) < prev(dword(0x27DC04))) &&
              (always_false() || (never(dword(0x27DBFC) != 8)))
)

achievement(
    title = "Muggshot Over Ice", points = 10, type="progression",
    description = "Defeat Muggshot in \"Last Call\"",
    id = 261393, badge = "296092", published = "10/30/2022 1:16:23 AM", modified = "11/18/2022 9:13:47 PM",
    trigger = dword(0x27DBF8) == 2 && dword(0x27DBFC) == 8 && float(0x26E4C0) == 0.0 && prev(dword(0x27C320)) == 0
)

achievement(
    title = "Straight Flush", points = 10,
    description = "Defeat Muggshot in \"Last Call\" without taking damage or dying (exit level to retry)",
    id = 280206, badge = "309942", published = "1/12/2023 8:45:01 PM", modified = "1/12/2023 8:45:01 PM",
    trigger = dword(0x27DBF8) == 2 && trigger_when(float(0x26E4C0) == 0.0) &&
              disable_when(dword(0x27DC00) < prev(dword(0x27DC00))) &&
              disable_when(dword(0x27DC04) < prev(dword(0x27DC04))) &&
              (always_false() || (never(dword(0x27DBFC) != 8)))
)

achievement(
    title = "Mz Ruby's Last Dance", points = 10, type="progression",
    description = "Defeat Mz Ruby in \"A Deadly Dance\"",
    id = 261435, badge = "296152", published = "10/30/2022 1:16:37 AM", modified = "11/18/2022 9:13:50 PM",
    trigger = dword(0x27DBF8) == 3 && dword(0x27DBFC) == 8 && float(0x26E4C0) == 0.0 && prev(dword(0x27C320)) == 0
)

achievement(
    title = "You Got Some Rhythm, Raccoon", points = 10,
    description = "Defeat Mz Ruby in \"A Deadly Dance\" without taking damage or dying (exit level to retry)",
    id = 261436, badge = "296107", published = "10/30/2022 1:16:38 AM", modified = "11/17/2022 1:23:36 AM",
    trigger = dword(0x27DBF8) == 3 && trigger_when(float(0x26E4C0) == 0.0) &&
              disable_when(dword(0x27DC00) < prev(dword(0x27DC00))) &&
              disable_when(dword(0x27DC04) < prev(dword(0x27DC04))) &&
              (always_false() || (never(dword(0x27DBFC) != 8)))
)

achievement(
    title = "Panda King Rained Out", points = 10, type="progression",
    description = "Defeat Panda King in \"Flame Fu!\"",
    id = 261441, badge = "296294", published = "10/30/2022 1:16:39 AM", modified = "11/18/2022 9:13:53 PM",
    trigger = dword(0x27DBF8) == 4 && dword(0x27DBFC) == 8 && float(0x26E4C0) == 0.0 && prev(dword(0x27C320)) == 0
)

achievement(
    title = "Clockwerk Scrapped", points = 25, type="win_condition",
    description = "Defeat Clockwerk in \"A Strange Reunion\"",
    id = 261464, badge = "296298", published = "10/30/2022 1:16:47 AM", modified = "9/27/2024 8:10:54 PM",
    trigger = repeated(3,
                  float(0x26E4C0) == 0.0 && prev(float(0x26E4C0)) <= 0.25 && prev(float(0x26E4C0)) > 0.049968 &&
                  never(dword(0x27DBF8) != 5 && dword(0x27DBFC) != 8)
              ) && never(dword(0x27DC00) < prev(dword(0x27DC00)))
)

achievement(
    title = "Those Belong in a Museum!", points = 10,
    description = "Defeat Panda King without letting him break any pots (die or exit and re-enter boss to retry)",
    id = 261459, badge = "296239", published = "10/30/2022 1:16:46 AM", modified = "11/18/2022 3:02:33 PM",
    trigger = dword(0x27DBF8) == 4 && dword(0x27DBFC) == 8 && trigger_when(float(0x26E4C0) == 0.0) &&
              bit5(0x26143D) == 0 && bit6(0x26143D) == 0 && bit7(0x26143D) == 0 && bit0(0x26143E) == 0 &&
              bit1(0x26143E) == 0 && bit2(0x26143E) == 0 && bit3(0x26143E) == 0 && bit4(0x26143E) == 0
)

achievement(
    title = "With All Fingers Intact", points = 10,
    description = "Defeat Panda King in \"Flame Fu!\" without taking damage or dying (exit level to retry)",
    id = 280207, badge = "309943", published = "1/12/2023 8:45:02 PM", modified = "1/12/2023 8:45:02 PM",
    trigger = dword(0x27DBF8) == 4 && trigger_when(float(0x26E4C0) == 0.0) &&
              disable_when(dword(0x27DC00) < prev(dword(0x27DC00))) &&
              disable_when(dword(0x27DC04) < prev(dword(0x27DC04))) &&
              (always_false() || (never(dword(0x27DBFC) != 8)))
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
