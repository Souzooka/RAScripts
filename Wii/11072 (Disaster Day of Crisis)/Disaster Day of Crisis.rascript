// Disaster: Day of Crisis
// #ID = 11072

// Pointer mask for custom memory map
RA_MASK = 0x1FFFFFFF

NULL = 0

function force_alt_group()
{
    return bit0(0x0) == prev(bit0(0x0))
}

function force_core_pause()
{
    // Emits no code but forces RATools to emit Pause Ifs for conditions with no hits
    // (We need this for alt measured()s where we have states where the data may be invalid)
    return measured(bit0(0x0) >= 0) 
}

function visual_gameflags_measured(actual_cond, measured_cond)
{
    return
        // Core Group
        (actual_cond && force_core_pause() && unless(FlagsInvalid())) &&
        // Alt Groups
        (force_alt_group() || measured_cond)
}

function if_else(cond, a, b)
{
    if cond
        return a
    return b
}

function array_extend(a, b)
{
    result = []
    for v in a
        array_push(result, v)
    for v in b
        array_push(result, v)
    return result
}

addr = (v) => v // Dummy accessor for ptr for if the pointed-to address is desired
function ptr(base, offsets, accessor=dword_be)
{
    val = base
    val = val & RA_MASK
    
    for i in range(0, length(offsets) - 1)
    {
        addr = val + offsets[i]
        if (i == length(offsets) - 1)
        {
            val = accessor(addr)
            if accessor == double32_be
                // Get most significant bits for a double
                val = accessor(addr + 4)
        }
        else
        {
            val = dword_be(addr)
            val = val & RA_MASK
        }
    }
    
    return val
}

function FlagsInvalid()
{
    // Returns circumstances in which game flags may be considered invalid
    // (and thus cause weird measured popups)
    return
        InTitle() ||
        prev(InTitle()) || // Prevents achievements from popping when selecting "Continue" in title menu
        InSpecial() ||
        IntermissionMenu()["m_load_active"] == 1 ||
        PauseMenu()["m_load_active"] == 1 ||
        // Prevents achievements from popping on boot -> intro FMV transition
        // For whatever reason this function at 0x801233F8 just overwrites game flags with random junk.
        ptr(dword_be(0x6E035C), [0x0, 0x10], dword_be) == 0x801233F8
}

function InTitle()
{
    return ptr(dword_be(0x6E07F0), [0x1C], byte) == 1 || ptr(dword_be(0x6E07F4), [0x50], byte) == 1
}

function InSpecial()
{
    return ptr(dword_be(0x6E07F8), [0xD8], byte) == 1 || ptr(dword_be(0x6E07F8), [0xA78], byte) == 1
}

function SaveScreenActive(now=false)
{
    val = ptr(dword_be(0x6E0850), [0x4C], byte)
    if now
        return prev(val) == 0 && val == 1
    return val == 1
}

function StageComplete(id=-1, now=false)
{
    // prologue
    if id == 0
        return prior(g_checkpoint) == 8 && SaveScreenActive(now)

    // There doesn't seem to be a good stage indicator, so we'll just use the last checkpoint value
    // (checkpoint is zeroed when the stage results info appears)
    last_checkpoint = {
        1: 0x1C,
        2: 0x40,
        3: 0x61,
        4: 0x7D,
        5: 0x8A,
        6: 0x92,
        7: 0x4C,
        8: 0x74,
        9: 0xA1,
        10: 0xC4,
        11: 0xAA,
        12: 0xDB,
        13: 0xEA,
        14: 0xFA,
        15: 0x103,
        16: 0x114,
        17: 0x11E,
        18: 0x157,
        19: 0x14E,
        20: 0x168,
        21: 0x17F,
        22: 0x193,
        23: 0x1A8,
    }
    
    cond = g_stage_result["m_screen_active"] == 1
    if now
        cond = cond && prev(g_stage_result["m_screen_active"]) == 0
    if id != -1
        cond = cond && prior(g_checkpoint) == last_checkpoint[id]
    return cond
}

function RangeComplete(now=false)
{
    cond = g_range_result["m_active"] == 1
    if now
        cond = cond && prev(g_range_result["m_active"]) == 0
    return cond
}

function HasTitle(title)
{
    return __ornext(any_of(g_stage_result["m_titles"], v => title == v))
}

function TitleEarned(title, mech_ray_allowed=true)
{
    cond =
        __ornext(any_of(g_stage_result["m_titles"], v => title == v)) &&
        g_stage_result["m_screen_active"] == 1 &&
        g_stage_result["m_current_screen"] == 1 &&
        prev(g_stage_result["m_screen_transition"]) == 1 &&
        g_stage_result["m_screen_transition"] == 0
        
        
    if !mech_ray_allowed
        cond = cond && g_costume != COSTUME_MECH_RAY
     
    return cond
}

function GameComplete()
{
    return
        StageComplete(now=true) &&
        ascii_string_equals(g_level_id, "result_total")
}

function GetGameFlag(flag)
{
    flags = dword_be(0x6E0DA4) & RA_MASK
    flags = flags + flag / 8
    return bit(flag % 8, flags)
}

function GetTitleUnlocked(title_id)
{
    return GetGameFlag(title_id + 3290)
}

function GetSignCollected(sign_id)
{
    return GetGameFlag(sign_id + 3490)
}

function GetCostumeUnlocked(costume_unlock_id)
{
    return GetGameFlag(costume_unlock_id + 3820)
}

function RescueCount()
{
    flags = dword_be(0x6E0DA4) & RA_MASK
    return sum_of(range(0, 8-1), i => bitcount(flags + 0x15E + i))
}

// Object constructors
function Player(addr)
{
    obj = {
        "m_life": float_be(addr + 0x2A70),
        "m_life_max": float_be(addr + 0x2A74),
        "m_sprint": float_be(addr + 0x2A88),
        "m_sprint_max": float_be(addr + 0x2A9C),
        "m_stamina": float_be(addr + 0x2A98),
        "m_stamina_max": float_be(addr + 0x2A9C),
    }
    
    return obj
}

function WeaponStats(id)
{
    addr = p_weapon_stats + (id * 0x24)
    obj = {
        "m_id": dword_be(addr + 0x0),
        "m_power": dword_be(addr + 0x4),
        "m_magazine": dword_be(addr + 0x8),
        "m_reloading": dword_be(addr + 0xC),
        "m_aiming": dword_be(addr + 0x10),
        "m_accuracy": dword_be(addr + 0x14),
        "m_mag_ammo": dword_be(addr + 0x1C),
        "m_owned": byte(addr + 0x20),
    }
    
    return obj
}

function StageResult()
{
    addr = dword_be(0x6E07E8) & RA_MASK
    
    obj = {
        "m_n_titles": dword_be(addr + 0x0),
        "m_titles": array_map(range(0, 30 - 1), i => dword_be(addr + 0x8 + (i * 4))),
        "m_current_screen": dword_be(addr + 0x210),
        "m_battle_time": dword_be(addr + 0x218) * 60 + dword_be(addr + 0x21C),
        "m_battle_time_minutes": dword_be(addr + 0x218),
        "m_battle_time_seconds": dword_be(addr + 0x21C),
        "m_enemy_kill_ratio": float_be(addr + 0x220),
        "m_shooting_accuracy": float_be(addr + 0x224),
        "m_battle_points": dword_be(addr + 0x228),
        "m_clever_shots": dword_be(addr + 0x230),
        "m_head_shots": dword_be(addr + 0x234),
        "m_max_combo": dword_be(addr + 0x238),
        "m_damage_received": dword_be(addr + 0x23C),
        "m_unrescued_casualties": dword_be(addr + 0x240),
        "m_overall_rating": dword_be(addr + 0x294),
        "m_screen_transition": byte(addr + 0x2AA),
        "m_screen_active": byte(addr + 0x2AB),
        "m_staminas_screen": byte(addr + 0x340),
        "m_staminas_signs_collected": dword_be(addr + 0x424),
        "m_staminas_signs_on_stage": dword_be(addr + 0x428),
        "m_staminas_complete_bonus": dword_be(addr + 0x42C),
    }
    
    return obj
}

function ShootingRangeResult()
{
    addr = dword_be(0x6E0864) & RA_MASK
    
    obj = {
        "m_active": byte(addr + 0x5),
        "m_name": addr + 0x34,
        "m_clear_time_cs": dword_be(addr + 0xB4),
        "m_clear_time_m": dword_be(addr + 0xB8),
        "m_clear_time_s": dword_be(addr + 0xBC),
        "m_enemies_defeated": dword_be(addr + 0xC0),
        "m_max_enemies": dword_be(addr + 0xC4),
        "m_subtotal_bp": dword_be(addr + 0xC8),
        "m_accuracy": dword_be(addr + 0xCC),
        "m_time_bonus_bp": dword_be(addr + 0xD4),
        "m_clear_bonus_bp": dword_be(addr + 0xD8),
        "m_accuracy_bonus_bp": dword_be(addr + 0xDC),
        "m_total_bp": dword_be(addr + 0xE4),
        "m_spent_bp": dword_be(addr + 0xEC),
        "m_remaining_bp": dword_be(addr + 0xF0),
    }
    
    return obj
}

function IntermissionMenu()
{
    addr = dword_be(0x6E07E4) & RA_MASK
    
    obj = {
        "m_load_active": byte(addr + 0x2118)
    }
    
    return obj
}

function PauseMenu()
{
    addr = dword_be(0x6E07E0) & RA_MASK
    
    obj = {
        "m_load_active": byte(addr + 0x5D0)
    }
    
    return obj
}

function GetCheckpointState(checkpoint_id)
{
    SIZEOF_CHECKPOINTSTATE = 0x1424
    checkpoint_id = checkpoint_id - 1
    checkpoint_state = (dword_be(0x6E1334) & RA_MASK) + (checkpoint_id * SIZEOF_CHECKPOINTSTATE)
    
    obj = {
        "m_damage_received": float_be(checkpoint_state + 0x350)
    }
    
    return obj
}

p_player = ptr(dword_be(0x6E10DC), [0x10, 0x14C], dword_be)
g_player = Player(p_player)
g_costume = dword_be(0x616b04)

COSTUME_SAMURAI = 7
COSTUME_MECH_RAY = 8

g_difficulty = dword_be(0x629190)
DIFFICULTY_NORMAL = 0
DIFFICULTY_HARD = 1
DIFFICULTY_DISASTER = 2

g_stage_result = StageResult()
g_range_result = ShootingRangeResult()

COMBAT_STAGES = [1, 2, 3, 5, 7, 8, 10, 13, 14, 17, 18, 19, 21, 22]
STAMINAS_STAGES = [1, 2, 3, 4, 6, 7, 8, 9, 10, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22]

p_weapon_stats = 0x616608
WEAPON_NONE = 0
WEAPON_HANDGUN1 = 1
WEAPON_HANDGUN2 = 2
WEAPON_HANDGUN3 = 3
WEAPON_HANDGUNL = 4
WEAPON_HANDGUNH = 5
WEAPON_SHOTGUN1 = 6
WEAPON_SHOTGUN2 = 7
WEAPON_SHOTGUN3 = 8
WEAPON_RIFLE1 = 9
WEAPON_RIFLE2 = 10
WEAPON_RIFLE3 = 11
WEAPON_BAZOOKA1 = 12
WEAPON_BAZOOKA2 = 13
WEAPON_BOWGUN1 = 14
WEAPON_BOWGUN2 = 15
WEAPON_BOWGUN3 = 16
WEAPON_PULSE = 17
WEAPON_SPARK = 18
WEAPON_GATLING = 19
WEAPON_IMMOLATOR = 20
WEAPON_TWISTER = 21
WEAPON_DEEP_IMPACT = 22
WEAPON_VOLCANO = 23
WEAPON_IMPULSE_GUN = 24 // not a real weapon
WEAPON_HOSE = 25 // not a real weapon
WEAPON_JUNK = 26 // shouldn't be used as a weapon but is real
WEAPON_MAX = WEAPON_JUNK
g_weapons = {}
for id in range(0, WEAPON_MAX)
    if id != WEAPON_NONE && id != WEAPON_HOSE && id != WEAPON_IMPULSE_GUN
        g_weapons[id] = WeaponStats(id)

g_checkpoint = dword_be(0x5EB588)
g_level_id = 0x5EB590
g_level_id_next = 0x5EB5D0
g_level_id_prior = 0x5EB610
STAGE_MAX = 23
SHOOTING_RANGE_PREFIX = "ext"
SHOOTING_RANGE_BEGINNER = "ext01_00"
SHOOTING_RANGE_INTERMEDIATE = "ext02_00"
SHOOTING_RANGE_ADVANCED = "ext03_00"
SHOOTING_RANGE_JUNK = "ext04_00"
SHOOTING_RANGE_BOW = "ext05_00"
SHOOTING_RANGE_ROCKET = "ext06_00"
SHOOTING_RANGE_PULSE = "ext07_00"
SHOOTING_RANGE_GATLING = "ext08_00"
SHOOTING_RANGE_SPACE = "ext09_00"


// Rescue Lisa from Lahar in <25 secs
COSTUME_UNLOCK_FROG = 0
// Collect all Staminas signs
COSTUME_UNLOCK_BARBARIAN = 1
// Rescue all victims
COSTUME_UNLOCK_RESCUER = 2
// Unlock all 100 titles
COSTUME_UNLOCK_SAMURAI = 3
// Complete Real Disaster diff.
COSTUME_UNLOCK_MECH_RAY = 4
// Jump across the lava and smack a barrel after Iris lava floe segment
COSTUME_UNLOCK_VOLCANO_SHIRT = 5
//
COSTUME_UNLOCK_EARTHQUAKE_SHIRT = 6
//
COSTUME_UNLOCK_HURRICANE_SHIRT = 7
// Complete the game
COSTUME_UNLOCK_TSUNAMI_SHIRT = 8
//
COSTUME_UNLOCK_FIRE_SHIRT = 9
// On ferry in last stage, if you go up the stairs back to where elevator came from it is in a barrel
COSTUME_UNLOCK_HEAVY_RAIN_SHIRT = 10
T_SHIRT_UNLOCKS = range(COSTUME_UNLOCK_VOLCANO_SHIRT, COSTUME_UNLOCK_HEAVY_RAIN_SHIRT)


function MaxSkillsTrigger()
{
    // Raymond's skills (Increments even if upgrades are not finalized)
    skills = array_map(range(0, 5 - 1), i => byte(0x616afc + i))
    
    // Value for outstanding cost for skill upgrades before implementing
    p_fee = dword_be(0x6E07E4)
    fee = ptr(p_fee, [0x1C48])
    
    return
        all_of(skills, v => v == 5) &&
        p_fee != NULL &&
        prev(fee) > 0 &&
        fee == 0
}

PROGRESSION_PARAMS = [
    {
        "id": 562374,
        "stage": 0,
        "title": "We Can't Save Everyone",
        "description": "Complete the prologue.",
        "points": 2,
    },
    {
        "id": 562375,
        "stage": 1,
        "title": "Big Earthquake",
        "description": "Complete Stage 01.",
        "points": 4,
    },
    {
        "id": 562376,
        "stage": 2,
        "title": "Collapsing Road",
        "description": "Complete Stage 02.",
        "points": 4,
    },
    {
        "id": 562377,
        "stage": 3,
        "title": "Darkness and Fire",
        "description": "Complete Stage 03.",
        "points": 5,
    },
    {
        "id": 562378,
        "stage": 4,
        "title": "Firestorm",
        "description": "Complete Stage 04.",
        "points": 3,
    },
    {
        "id": 562379,
        "stage": 5,
        "title": "Duel on the Bridge",
        "description": "Complete Stage 05.",
        "points": 5,
    },
    {
        "id": 562380,
        "stage": 6,
        "title": "Tsunami Attack",
        "description": "Complete Stage 06.",
        "points": 5,
    },
    {
        "id": 562381,
        "stage": 7,
        "title": "Death from Above",
        "description": "Complete Stage 07.",
        "points": 5,
    },
    {
        "id": 562382,
        "stage": 8,
        "title": "Streets Swallowed by the Waves",
        "description": "Complete Stage 08.",
        "points": 5,
    },
    {
        "id": 562383,
        "stage": 9,
        "title": "To the Enemy Base",
        "description": "Complete Stage 09.",
        "points": 3,
    },
    {
        "id": 562384,
        "stage": 10,
        "title": "Mt. Rosalia Eruption",
        "description": "Complete Stage 10.",
        "points": 10,
    },
    {
        "id": 562385,
        "stage": 11,
        "title": "Volcanic Chase",
        "description": "Complete Stage 11.",
        "points": 3,
    },
    {
        "id": 562386,
        "stage": 12,
        "title": "Ash and a Girl",
        "description": "Complete Stage 12.",
        "points": 3,
    },
    {
        "id": 562387,
        "stage": 13,
        "title": "The Ashen Forest",
        "description": "Complete Stage 13.",
        "points": 4,
    },
    {
        "id": 562388,
        "stage": 14,
        "title": "Path of the Lava",
        "description": "Complete Stage 14.",
        "points": 5,
    },
    {
        "id": 562389,
        "stage": 15,
        "title": "Lahar",
        "description": "Complete Stage 15.",
        "points": 2,
    },
    {
        "id": 562390,
        "stage": 16,
        "title": "Skydiving",
        "description": "Complete Stage 16.",
        "points": 2,
    },
    {
        "id": 562391,
        "stage": 17,
        "title": "Heavy Rain",
        "description": "Complete Stage 17.",
        "points": 5,
    },
    {
        "id": 562392,
        "stage": 18,
        "title": "Mud and Mercenaries",
        "description": "Complete Stage 18.",
        "points": 10,
    },
    {
        "id": 562393,
        "stage": 19,
        "title": "Rain Returns",
        "description": "Complete Stage 19.",
        "points": 5,
    },
    {
        "id": 562394,
        "stage": 20,
        "title": "Hurricane Chase",
        "description": "Complete Stage 20.",
        "points": 5,
    },
    {
        "id": 562395,
        "stage": 21,
        "title": "Windstorm Battle",
        "description": "Complete Stage 21.",
        "points": 5,
    },
    {
        "id": 562396,
        "stage": 22,
        "title": "Final Battle",
        "description": "Complete Stage 22.",
        "points": 10,
    },
]

for params in PROGRESSION_PARAMS
{
    achievement(
        id=params["id"],
        title=params["title"],
        description=params["description"],
        type="progression",
        points=params["points"],
        trigger=StageComplete(params["stage"], now=true)
    )
}

achievement(
    id=0,
    title="Day of Crisis",
    description="Complete the game on Normal or higher difficulty.",
    type="win_condition",
    points=25,
    trigger=GameComplete()
)

achievement(
    id=0,
    title="One Hell of a Day",
    description="Complete the game on Hard or higher difficulty.",
    points=25,
    trigger=GameComplete() && g_difficulty >= DIFFICULTY_HARD
)

achievement(
    id=0,
    title="Ray of Hope",
    description="Complete the game on Real Disaster difficulty.",
    points=25,
    trigger=GameComplete() && g_difficulty == DIFFICULTY_DISASTER
)

function MinCompletionTrigger()
{
    DEFAULT_WEAPONS = [WEAPON_HANDGUN1, WEAPON_RIFLE1, WEAPON_SHOTGUN1]
    cond = always_true()
    
    // All of Raymond's skills are at one
    cond =
        cond &&
        all_of(array_map(range(0, 5 - 1), i => byte(0x616AFC + i)), v => v == 1)

    // Check no other weapons are owned
    for weapon_id in g_weapons
    {
        if !any_of(DEFAULT_WEAPONS, id => weapon_id == id)
        {
            cond = cond && g_weapons[weapon_id]["m_owned"] == 0
        }
    }
    
    // Handgun upgrades
    cond =
        cond &&
        // Accuracy already maxed out
        g_weapons[WEAPON_HANDGUN1]["m_power"] == 0 &&
        g_weapons[WEAPON_HANDGUN1]["m_magazine"] == 0 &&
        g_weapons[WEAPON_HANDGUN1]["m_reloading"] == 0 &&
        g_weapons[WEAPON_HANDGUN1]["m_aiming"] == 0
        
    // Shotgun upgrades
    cond =
        cond &&
        g_weapons[WEAPON_SHOTGUN1]["m_accuracy"] == 0 &&
        g_weapons[WEAPON_SHOTGUN1]["m_power"] == 0 &&
        g_weapons[WEAPON_SHOTGUN1]["m_magazine"] == 0 &&
        g_weapons[WEAPON_SHOTGUN1]["m_reloading"] == 0 &&
        g_weapons[WEAPON_SHOTGUN1]["m_aiming"] == 0

    // Rifle upgrades
    cond =
        cond &&
        g_weapons[WEAPON_RIFLE1]["m_accuracy"] == 0 &&
        g_weapons[WEAPON_RIFLE1]["m_power"] == 0 &&
        g_weapons[WEAPON_RIFLE1]["m_magazine"] == 0 &&
        g_weapons[WEAPON_RIFLE1]["m_reloading"] == 0 &&
        g_weapons[WEAPON_RIFLE1]["m_aiming"] == 0        

    return cond
}

achievement(
    id=0,
    title="Law Abiding Rescuer",
    description="Complete the game on Hard or higher difficulty. Do not upgrade Ray's skills. Do not upgrade your weapons or obtain additional weapons. Increasing max LIFE is OK.",
    points=50,
    trigger=
        GameComplete() && 
        g_difficulty >= DIFFICULTY_HARD &&
        MinCompletionTrigger()
)

function DamagelessFallback(stage, before_damage, after_damage)
{
    // Fallback in case player received this title previously w/ Mech Ray costume
    return
        StageComplete(stage) &&
        g_costume != COSTUME_MECH_RAY &&
        before_damage == after_damage &&
        g_stage_result["m_current_screen"] > 0 &&
        g_stage_result["m_screen_transition"] == 0 &&
        prev(g_stage_result["m_screen_transition"]) == 1
}

function GetCheckpointDamage(stage, checkpoint)
{
    checkpoint = checkpoint - 1
    offset = 0x2F4 + (0x5C * stage) + (0x1424 * checkpoint)
    
    return ptr(dword_be(0x6E1334), [offset], float_be)
}

achievement(
    id=562401,
    title="Gordon Killer",
    description="In Stage 01, defeat Gordon without taking damage and earn this title. Use of the Mechanical Ray costume is prohibited for all damageless achievements.",
    points=2,
    trigger=TitleEarned(7, mech_ray_allowed=false) || 
        DamagelessFallback(1, GetCheckpointDamage(1, 4), GetCheckpointDamage(1, 5))
)

achievement(
    id=0,
    title="Armoured Vehicle Killer",
    description="In Stage 03, defeat the armoured vehicles without taking damage and earn this title.",
    points=5,
    trigger=TitleEarned(8, mech_ray_allowed=false) || 
        DamagelessFallback(3, GetCheckpointDamage(3, 8), GetCheckpointDamage(3, 9))
)

achievement(
    id=0,
    title="Gordon Killer Returns",
    description="In Stage 05, defeat Gordon without taking damage and earn this title.",
    points=5,
    trigger=TitleEarned(9, mech_ray_allowed=false) || 
        DamagelessFallback(5, GetCheckpointDamage(5, 2), g_stage_result["m_damage_received"])
)

achievement(
    id=0,
    title="Chopper Killer",
    description="In Stage 07, defeat the chopper without taking damage and earn this title.",
    points=5,
    trigger=TitleEarned(10, mech_ray_allowed=false) || 
        DamagelessFallback(7, GetCheckpointDamage(7, 2), GetCheckpointDamage(7, 3))
)

achievement(
    id=0,
    title="Gregory Killer",
    description="In Stage 08, defeat Gregory without taking damage and earn this title.",
    points=5,
    trigger=TitleEarned(11, mech_ray_allowed=false) || 
        DamagelessFallback(8, GetCheckpointDamage(8, 4), g_stage_result["m_damage_received"])
)

achievement(
    id=0,
    title="Evans Killer",
    description="In Stage 10, defeat Evans without taking damage and earn this title.",
    points=10,
    trigger=TitleEarned(12, mech_ray_allowed=false) || 
        DamagelessFallback(10, GetCheckpointDamage(10, 10), GetCheckpointDamage(10, 12))
)

achievement(
    id=0,
    title="Bear Killer",
    description="In Stage 13, defeat the bear without taking damage and earn this title.",
    points=3,
    trigger=TitleEarned(13, mech_ray_allowed=false) || 
        (
            DamagelessFallback(13, GetCheckpointDamage(13, 4), GetCheckpointDamage(13, 5)) &&
            DamagelessFallback(13, GetCheckpointDamage(13, 6), GetCheckpointDamage(13, 7)) &&
            DamagelessFallback(13, GetCheckpointDamage(13, 8), GetCheckpointDamage(13, 9))
        )
)

achievement(
    id=0,
    title="Chopper Killer Returns",
    description="In Stage 14, defeat the chopper without taking damage and earn this title.",
    points=5,
    trigger=TitleEarned(14, mech_ray_allowed=false) || 
        DamagelessFallback(14, GetCheckpointDamage(14, 2), GetCheckpointDamage(14, 3))
)

achievement(
    id=0,
    title="Willful Rescuer",
    description="Rescue Iris from the Campbell River in 25 seconds or less and earn this title.",
    points=5,
    trigger=TitleEarned(69)
)

achievement(
    id=0,
    title="Banks Killer",
    description="In Stage 18, defeat Banks without taking damage and earn this title.",
    points=10,
    trigger=TitleEarned(15, mech_ray_allowed=false) || 
        DamagelessFallback(18, GetCheckpointDamage(18, 12), g_stage_result["m_damage_received"])
)

achievement(
    id=0,
    title="SURGE Killer",
    description="In Stage 21, defeat the SURGE force on the Seaside Highway without taking damage and earn this title.",
    points=10,
    trigger=TitleEarned(16, mech_ray_allowed=false) || 
        DamagelessFallback(21, GetCheckpointDamage(21, 8), g_stage_result["m_damage_received"])
)

achievement(
    id=0,
    title="XA19 Killer",
    description="In Stage 22, defeat the XA19 without taking damage and earn this title.",
    points=10,
    trigger=TitleEarned(17, mech_ray_allowed=false) || 
        DamagelessFallback(22, GetCheckpointDamage(22, 7), GetCheckpointState(8)["m_damage_received"])
)

achievement(
    id=0,
    title="Best Rescuer",
    description="Rescue each possible person within the game.",
    points=10,
    trigger=visual_gameflags_measured(TitleEarned(6), measured(RescueCount() == 45))
)

achievement(
    id=0,
    title="Day of Fashion",
    description="Obtain all of the T-Shirt costumes.",
    points=10,
    trigger=
        measured(sum_of(T_SHIRT_UNLOCKS, GetCostumeUnlocked) == length(T_SHIRT_UNLOCKS)) &&
        sum_of(T_SHIRT_UNLOCKS, v => prev(GetCostumeUnlocked(v))) == length(T_SHIRT_UNLOCKS) - 1 &&
        unless(FlagsInvalid())
)

achievement(
    id=0,
    title="One Man's Junk",
    description="Score at least 1,800 BP on the Junk Shooting Range.",
    points=5,
    trigger=
        ascii_string_equals(g_level_id, SHOOTING_RANGE_JUNK) &&
        RangeComplete(now=true) &&
        g_range_result["m_total_bp"] >= 1800
)

achievement(
    id=0,
    title="Compound Problems",
    description="Score at least 2,000 BP on the Bow Gun Shooting Range.",
    points=5,
    trigger=
        ascii_string_equals(g_level_id, SHOOTING_RANGE_BOW) &&
        RangeComplete(now=true) &&
        g_range_result["m_total_bp"] >= 2000
)

achievement(
    id=0,
    title="Crowd Control",
    description="Score at least 4,000 BP on the Rocket Launcher Shooting Range.",
    points=5,
    trigger=
        ascii_string_equals(g_level_id, SHOOTING_RANGE_ROCKET) &&
        RangeComplete(now=true) &&
        g_range_result["m_total_bp"] >= 4000
)

achievement(
    id=0,
    title="Thinking with High Energy Pellets",
    description="Score at least 6,000 BP on the Pulse Gun Shooting Range.",
    points=5,
    trigger=
        ascii_string_equals(g_level_id, SHOOTING_RANGE_PULSE) &&
        RangeComplete(now=true) &&
        g_range_result["m_total_bp"] >= 6000
)

achievement(
    id=0,
    title="Who Touched Sasha?",
    description="Score at least 14,000 BP on the Gatling Gun Shooting Range.",
    points=5,
    trigger=
        ascii_string_equals(g_level_id, SHOOTING_RANGE_GATLING) &&
        RangeComplete(now=true) &&
        g_range_result["m_total_bp"] >= 14000
)

achievement(
    id=0,
    title="Not Corrupted by Capitalism",
    description="Destroy the comet heading toward earth in Space.",
    points=5,
    trigger=
        ascii_string_equals(g_level_id, SHOOTING_RANGE_SPACE) &&
        RangeComplete(now=true) &&
        g_range_result["m_clear_bonus_bp"] > 0
)

achievement(
    id=0,
    title="Leave a Mark",
    description="In Stage 08, shoot 10 grenades before defeating Gregory in order to unlock the Deep Impact weapon.",
    points=5,
    trigger=
        StageComplete() &&
        prev(g_weapons[WEAPON_DEEP_IMPACT]["m_owned"]) == 0 &&
        g_weapons[WEAPON_DEEP_IMPACT]["m_owned"] == 1
)

achievement(
    id=0,
    title="Fiery Temper",
    description="In Stage 10, shoot 10 knives before defeating Major Evans in the first battle in order to unlock the Immolator weapon.",
    points=5,
    trigger=
        StageComplete() &&
        prev(g_weapons[WEAPON_IMMOLATOR]["m_owned"]) == 0 &&
        g_weapons[WEAPON_IMMOLATOR]["m_owned"] == 1
)

achievement(
    id=0,
    title="Primed to Explode",
    description="In Stage 14, shoot 10 missiles before defeating the helicopter in order to unlock the Volcano weapon.",
    points=5,
    trigger=
        StageComplete() &&
        prev(g_weapons[WEAPON_VOLCANO]["m_owned"]) == 0 &&
        g_weapons[WEAPON_VOLCANO]["m_owned"] == 1
)


TITLE_PARAMS = [
    {
        "id": 0,
        "count": 25,
        "points": 5,
        "title": "Part-Time Volunteer",
    },
    {
        "id": 0,
        "count": 50,
        "points": 10,
        "title": "Rescuer",
    },
    {
        "id": 0,
        "count": 75,
        "points": 10,
        "title": "Miracle Worker",
    },
    {
        "id": 0,
        "count": 100,
        "points": 50,
        "title": "Savior",
    }
]

TITLE_SUM = sum_of(range(1, 100), GetTitleUnlocked)
PREV_TITLE_SUM = sum_of(range(1, 100), v => prev(GetTitleUnlocked(v)))

for params in TITLE_PARAMS
{
    achievement(
        id=params["id"],
        title=params["title"],
        description=format("Collect {0}{1} titles.", if_else(params["count"] == 100, "all ", ""), params["count"]),
        points=params["points"],
        trigger=
            measured(TITLE_SUM >= params["count"]) &&
            PREV_TITLE_SUM < params["count"] &&
            unless(FlagsInvalid())
    )
}

COMBAT_STAGES = [1, 2, 3, 5, 7, 8, 10, 13, 14, 17, 18, 19, 20, 21, 22]

STAMINAS_PARAMS = [
    {
        "id": 0,
        "stage": 1,
        "title": "Wiki Wiki Wonderful",
        "points": 3,
        // Used for measured, not needed for the actual unlock
        "signs": range(1, 10),
    },
    {
        "id": 0,
        "stage": 2,
        "title": "Working Hard, Huh",
        "points": 5,
        "signs": range(11, 30),
    },
    {
        "id": 0,
        "stage": 3,
        "title": "Slam Some Staminas",
        "points": 5,
        "signs": range(31, 50),
    },
    {
        "id": 0,
        "stage": 4,
        "title": "Bring the Heat",
        "points": 3,
        "signs": range(51, 60),
    },
    {
        "id": 0,
        "stage": 6,
        "title": "Superb Sniper",
        "points": 3,
        "signs": range(61, 71),
    },
    {
        "id": 0,
        "stage": 7,
        "title": "Running from the Helicopter",
        "points": 4,
        "signs": range(72, 81),
    },
    {
        "id": 0,
        "stage": 8,
        "title": "Plunge into the Torrent",
        "points": 4,
        "signs": range(82, 92),
    },
    {
        "id": 0,
        "stage": 9,
        "title": "A Drink in the Park",
        "points": 3,
        "signs": range(97, 106),
    },
    {
        "id": 0,
        "stage": 10,
        "title": "The SURGE Boys Are Collecting Them Too",
        "points": 5,
        "signs": range(107, 129),
    },
    {
        "id": 0,
        "stage": 12,
        "title": "It's Time to Get Down",
        "points": 3,
        "signs": range(130, 139),
    },
    {
        "id": 0,
        "stage": 13,
        "title": "Keep the Lady Waitin'",
        "points": 4,
        "signs": range(140, 150),
    },
    {
        "id": 0,
        "stage": 14,
        "title": "Chill Out",
        "points": 4,
        "signs": range(151, 161),
    },
    {
        "id": 0,
        "stage": 15,
        "title": "A Bear Is Coming",
        "points": 2,
        "signs": range(162, 164),
    },
    {
        "id": 0,
        "stage": 16,
        "title": "In-Flight Refreshment",
        "points": 1,
        "signs": range(165, 166),
    },
    {
        "id": 0,
        "stage": 17,
        "title": "Hard Working Fella",
        "points": 4,
        "signs": range(167, 179),
    },
    {
        "id": 0,
        "stage": 18,
        "title": "Don't Catch a Cold",
        "points": 4,
        "signs": range(180, 190),
    },
    {
        "id": 0,
        "stage": 19,
        "title": "Lisa or the Signs",
        "points": 4,
        "signs": range(191, 206),
    },
    {
        "id": 0,
        "stage": 20,
        "title": "Ends of the Earth",
        "points": 4,
        "signs": range(207, 217),
    },
    {
        "id": 0,
        "stage": 21,
        "title": "Windstorm's a Piece of Cake",
        "points": 4,
        "signs": range(218, 228),
    },
    {
        "id": 0,
        "stage": 22,
        "title": "Great Job Finding It. How Marvellous.",
        "points": 3,
        "signs": range(229, 237),
    }
]

for params in STAMINAS_PARAMS
{
    stage = params["stage"]
    stage_str = format("{0}", if_else(stage < 10, "0" + stage, stage))
    
    obtained_signs = sum_of(
        array_map(
            params["signs"], GetSignCollected
        ),
        v => v
    )
    
    base_cond = 
            // Stage is done and stage results screen is active
            StageComplete(stage) &&
            // We're on the Staminas bonus screen
            prev(g_stage_result["m_staminas_screen"]) == 0 &&
            g_stage_result["m_staminas_screen"] == 1 &&
            // Got all the signs
            g_stage_result["m_staminas_signs_collected"] == g_stage_result["m_staminas_signs_on_stage"] &&
            // Make sure this unlock is only awarded on first-time completion
            g_stage_result["m_staminas_complete_bonus"] != 0
    
    
    measured_cond = measured(obtained_signs == length(params["signs"]))
    
    achievement(
        id=params["id"],
        title=params["title"],
        description=format("Collect all the Staminas campaign signs in Stage {0} and complete the stage.", stage_str),
        points=params["points"],
        trigger=visual_gameflags_measured(base_cond, measured_cond)
    )
}

// Leaderboards

rp_range = {
    SHOOTING_RANGE_BEGINNER: "Beginner",
    SHOOTING_RANGE_INTERMEDIATE: "Intermediate",
    SHOOTING_RANGE_ADVANCED: "Advanced",
    SHOOTING_RANGE_JUNK: "Junk",
    SHOOTING_RANGE_BOW: "Bow Gun",
    SHOOTING_RANGE_ROCKET: "Rocket Launcher",
    SHOOTING_RANGE_PULSE: "Pulse Gun",
    SHOOTING_RANGE_GATLING: "Gatling Gun",
}

LB_ID = 141548
for range in rp_range
{
    leaderboard(
        id=LB_ID,
        title=format("High Score - {0} Shooting Range", rp_range[range]),
        description="Earn the most BP!",
        start=
            ascii_string_equals(g_level_id, range) &&
            RangeComplete(now=true),
        cancel=g_range_result["m_total_bp"] == 0,
        submit=always_true(),
        value=g_range_result["m_total_bp"]
    )
    LB_ID = LB_ID + 1
}

// Rich Presence


// (checkpoint ID is 0 until we get in game)
rp_time_fallback = {
    "agu01_00": "Prologue", // prologue
    "blu02_00": "Stage 01", // stage 01
    "blu04_00": "Stage 02", // stage 02
    "blu07_00": "Stage 03", // stage 03
    "blu10_00": "Stage 04", // stage 04
    "blu11_00": "Stage 05", // stage 05
    "blu11_02": "Stage 06", // stage 06
    "blu06_01": "Stage 07", // stage 07
    "blu09_00": "Stage 08", // stage 08
    "blu12_00": "Stage 09", // stage 09
    "ros03_00": "Stage 10", // stage 10
    "ros01_01": "Stage 11", // stage 11
    "ros06_00": "Stage 12", // stage 12
    "ros08_00": "Stage 13", // stage 13
    "ros09_00": "Stage 14", // stage 14
    "ros10_00": "Stage 15", // stage 15
    "air01_00": "Stage 16", // stage 16
    "rai01_00": "Stage 17", // stage 17
    "rai02_00": "Stage 18", // stage 18
    "rai04_00": "Stage 19", // stage 19
    "por01_00": "Stage 20", // stage 20
    "por03_00": "Stage 21", // stage 21
    "por05_00": "Stage 22", // stage 22
    "fer02_01": "Stage 23", // stage 23
}
rp_activity_fallback = {
    "agu01_00": "Ray and Steve are rescuing survivors on Mt. Aguilas", // prologue
    "blu02_00": "Ray is in the Blue Ridge City FBI office", // stage 01
    "blu04_00": "Ray is fleeing the SURGE headquarters in Blue Ridge City", // stage 02
    "blu07_00": "Ray is entering the subway of Blue Ridge City", // stage 03
    "blu10_00": "Ray is arriving at West Park, Blue Ridge City", // stage 04
    "blu11_00": "Ray is pursuing SURGE in Blue Ridge City", // stage 05
    "blu11_02": "Ray is interrogating Gordon on the Big Bridge in Blue Ridge City", // stage 06
    "blu06_01": "Ray is staring down a SURGE helicopter in Jackson St, Blue Ridge City", // stage 07
    "blu09_00": "Ray is fleeing a tsunami and SURGE helicopter in South Side, Blue Ridge City", // stage 08
    "blu12_00": "Ray is washed up at Highland Park in Blue Ridge City", // stage 09
    "ros03_00": "Ray has arrived at the Old Geothermal Power Plant on Mt. Rosalia", // stage 10
    "ros01_01": "Ray is witnessing a volcanic eruption from the Old Geothermal Power Plant on Mt. Rosalia", // stage 011
    "ros06_00": "Ray is suffering the aftermath of the volcanic eruption at Mt. Rosalia", // stage 12
    "ros08_00": "Ray and Iris are arriving at the forest on Mt. Rosalia", // stage 13
    "ros09_00": "Ray and Iris are arriving at the timber yard on Mt. Rosalia", // stage 14
    "ros10_00": "Ray and Iris are arriving at Campbell River on Mt. Rosalia", // stage 15
    "air01_00": "Ray is getting briefed on a USAF transport plane", // stage 16
    "rai01_00": "Ray is touching down in Bainesville", // stage 17
    "rai02_00": "Ray is entering the Southern Quarter of Bainesville", // stage 18
    "rai04_00": "Ray is arriving at the church in Bainesville", // stage 19
    "por01_00": "Ray is pursuing a SURGE car in the Seafront Area of Port Alex", // stage 20
    "por03_00": "Ray is arriving at the North River Area of Port Alex", // stage 21
    "por05_00": "Ray is arriving at a Ferry Terminal in Port Alex", // stage 22
    "fer02_01": "Ray is below deck on the ferry, heading to disarm the nuke", // stage 23
}
rp_time = {
    // Prologue
    0x1: "Prologue",
    0x2: "Prologue",
    0x3: "Prologue",
    0x8: "Prologue",
    // Stage 1
    0x12: "Stage 01",
    0x13: "Stage 01",
    0x14: "Stage 01",
    0x15: "Stage 01",
    0x17: "Stage 01",
    0x18: "Stage 01",
    0x19: "Stage 01",
    0x1A: "Stage 01",
    0x1B: "Stage 01",
    0x1C: "Stage 01",
    // Stage 2
    0x2A: "Stage 02",
    0x30: "Stage 02",
    0x31: "Stage 02",
    0x32: "Stage 02",
    0x33: "Stage 02",
    0x34: "Stage 02",
    0x3C: "Stage 02",
    0x3D: "Stage 02",
    0x3E: "Stage 02",
    0x3F: "Stage 02",
    0x40: "Stage 02",
    // Stage 3
    0x50: "Stage 03",
    0x51: "Stage 03",
    0x52: "Stage 03",
    0x53: "Stage 03",
    0x54: "Stage 03",
    0x55: "Stage 03",
    0x56: "Stage 03",
    0x60: "Stage 03",
    0x61: "Stage 03",
    // Stage 4
    0x7A: "Stage 04",
    0x7B: "Stage 04",
    0x7C: "Stage 04",
    0x7D: "Stage 04",
    // Stage 5
    0x87: "Stage 05",
    0x89: "Stage 05",
    0x8A: "Stage 05",
    // Stage 6
    0x88: "Stage 06",
    0x8F: "Stage 06",
    0x90: "Stage 06",
    0x91: "Stage 06",
    0x92: "Stage 06",
    // Stage 7
    0x46: "Stage 07",
    0x47: "Stage 07",
    0x48: "Stage 07",
    0x4C: "Stage 07",
    // Stage 8
    0x6A: "Stage 08",
    0x6B: "Stage 08",
    0x6C: "Stage 08",
    0x73: "Stage 08",
    0x74: "Stage 08",
    // Stage 9
    0x98: "Stage 09",
    0xA1: "Stage 09",
    // Stage 10 - lots of "time dilation" in this stage
    0xB1: "Stage 10",
    0xB2: "Stage 10",
    0xB3: "Stage 10",
    0xBC: "Stage 10",
    0xBD: "Stage 10",
    0xBE: "Stage 10",
    0xBF: "Stage 10",
    0xC0: "Stage 10",
    0xC1: "Stage 10",
    0xC2: "Stage 10",
    0xC3: "Stage 10",
    0xC4: "Stage 10",
    // Stage 11
    0xA2: "Stage 11",
    0xAA: "Stage 11",
    // Stage 12
    0xCB: "Stage 12",
    0xCC: "Stage 12",
    0xDB: "Stage 12",
    // Stage 13
    0xE2: "Stage 13",
    0xE3: "Stage 13",
    0xE4: "Stage 13",
    0xE5: "Stage 13",
    0xE6: "Stage 13",
    0xE7: "Stage 13",
    0xE8: "Stage 13",
    0xE9: "Stage 13",
    0xEA: "Stage 13",
    // Stage 14
    0xF3: "Stage 14",
    0xF4: "Stage 14",
    0xF5: "Stage 14",
    0xF6: "Stage 14",
    0xF9: "Stage 14",
    0xFA: "Stage 14",
    // Stage 15
    0x102: "Stage 15",
    0x103: "Stage 15",
    // Stage 16
    0x10B: "Stage 16",
    0x10C: "Stage 16",
    0x114: "Stage 16",
    // Stage 17
    0x119: "Stage 17",
    0x11A: "Stage 17",
    0x11B: "Stage 17",
    0x11C: "Stage 17",
    0x11D: "Stage 17",
    0x11E: "Stage 17",
    // Stage 18
    0x126: "Stage 18",
    0x127: "Stage 18",
    0x128: "Stage 18",
    0x129: "Stage 18",
    0x12B: "Stage 18",
    0x12C: "Stage 18",
    0x12D: "Stage 18",
    0x12E: "Stage 18",
    0x12F: "Stage 18",
    0x137: "Stage 18",
    0x138: "Stage 18",
    0x157: "Stage 18",
    // Stage 19
    0x140: "Stage 19",
    0x141: "Stage 19",
    0x149: "Stage 19",
    0x14A: "Stage 19",
    0x14B: "Stage 19",
    0x14C: "Stage 19",
    0x14D: "Stage 19",
    0x14E: "Stage 19",
    // Stage 20
    0x15E: "Stage 20",
    0x165: "Stage 20",
    0x166: "Stage 20",
    0x167: "Stage 20",
    0x168: "Stage 20",
    // Stage 21
    0x16F: "Stage 21",
    0x170: "Stage 21",
    0x171: "Stage 21",
    0x172: "Stage 21",
    0x173: "Stage 21",
    0x174: "Stage 21",
    0x175: "Stage 21",
    0x17E: "Stage 21",
    0x17F: "Stage 21",
    // Stage 22
    0x187: "Stage 22",
    0x188: "Stage 22",
    0x18E: "Stage 22",
    0x18F: "Stage 22",
    0x190: "Stage 22",
    0x191: "Stage 22",
    0x192: "Stage 22",
    0x193: "Stage 22",
    // Stage 23
    0x1A3: "Stage 23",
    0x1A4: "Stage 23",
    0x1A5: "Stage 23",
    0x1A6: "Stage 23",
    0x1A7: "Stage 23",
    0x1A8: "Stage 23",
}
rp_activity = {
    // Prologue
    0x1: "Ray has been separated from Steve on Mt. Aguilas",
    0x2: "Ray has been separated from Steve on Mt. Aguilas",
    0x3: "Ray has been separated from Steve on Mt. Aguilas",
    0x8: "Ray and Steve are trying to survive the eruption on Mt. Aguilas",
    // Stage 1
    0x12: "Ray is joining the Special Response Team in a raid on the SURGE headquarters in Blue Ridge City",
    0x13: "Ray is engaging SURGE members in a gunfight in the SURGE headquarters in Blue Ridge City",
    0x14: "Ray is joining the Special Response Team in a raid on the SURGE headquarters in Blue Ridge City",
    0x15: "Ray is fighting Gordon inside the SURGE headquarters in Blue Ridge City",
    0x17: "Ray is trying to survive an earthquake inside the SURGE headquarters in Blue Ridge City",
    0x18: "Ray is engaging SURGE members in a gunfight in the SURGE headquarters in Blue Ridge City",
    0x19: "Ray is trying to survive an earthquake inside the SURGE headquarters in Blue Ridge City",
    0x1A: "Ray is trying to survive an earthquake inside the SURGE headquarters in Blue Ridge City",
    0x1B: "Ray is trying to survive an earthquake inside the SURGE headquarters in Blue Ridge City",
    0x1C: "Ray is engaging SURGE members in a gunfight in the SURGE headquarters in Blue Ridge City",
    // Stage 2
    0x2A: "Ray is fleeing from pursuing SURGE members in Blue Ridge City",
    0x30: "Ray is making his way through Silvia St. in Blue Ridge City",
    0x31: "Ray is fighting SURGE members on Silvia St. in Blue Ridge City",
    0x32: "Ray is making his way through Silvia St. in Blue Ridge City",
    0x33: "Ray is fighting SURGE members on Silvia St. in Blue Ridge City",
    0x34: "Ray is making his way through Silvia St. in Blue Ridge City",
    0x3C: "Ray is fighting SURGE members on Jackson St. in Blue Ridge City",
    0x3D: "Ray is making his way through Jackson St. in Blue Ridge City",
    0x3E: "Ray is fighting SURGE members on Jackson St. in Blue Ridge City",
    0x3F: "Ray is making his way through Jackson St. in Blue Ridge City",
    0x40: "Ray is fighting SURGE members on Jackson St. in Blue Ridge City",
    // Stage 3
    0x50: "Ray is entering the subway of Blue Ridge City",
    0x51: "Ray is fighting SURGE members in the subway in Blue Ridge City",
    0x52: "Ray is making his way through the subway in Blue Ridge City",
    0x53: "Ray is fighting SURGE members in the subway in Blue Ridge City",
    0x54: "Ray is making his way through the subway in Blue Ridge City",
    0x55: "Ray is fighting SURGE members in the subway in Blue Ridge City",
    0x56: "Ray is making his way through the subway in Blue Ridge City",
    0x60: "Ray is fighting a pair of armoured cars on Bradley St. in Blue Ridge City",
    0x61: "Ray is desparately trying to escape a growing fire on Bradley St. in Blue Ridge City",
    // Stage 4
    0x7A: "Ray is at West Park in Blue Ridge City",
    0x7B: "Ray is gathering survivors to help push debris to escape a firestorm at West Park in Blue Ridge City",
    0x7C: "Ray is gathering survivors to help push debris to escape a firestorm at West Park in Blue Ridge City",
    0x7D: "Ray and other survivors are attempting to push debris to escape a firestorm at West Park in Blue Ridge City",
    // Stage 5
    0x87: "Ray is pursuing SURGE on Big Bridge in Blue Ridge City",
    0x89: "Ray is fighting Gordon on Big Bridge in Blue Ridge City",
    0x8A: "Ray is fighting Gordon on Big Bridge in Blue Ridge City",
    // Stage 6
    0x88: "Ray is fleeing an approaching tsunami on Big Bridge in Blue Ridge City",
    0x8F: "Ray is making his way through Bradley St. in Blue Ridge City",
    0x90: "Ray is extinguishing fires in the subway in Blue Ridge City",
    0x91: "Ray is making his way through the subway in Blue Ridge City",
    0x92: "Ray is escaping rising waters in the subway in Blue Ridge City",
    // Stage 7
    0x46: "Ray is fleeing a pursuing SURGE attack helicopter in Jackson St in Blue Ridge City",
    0x47: "Ray is fighting a SURGE attack helicopter in Jackson St in Blue Ridge City",
    0x48: "Ray is making his way through Jackson St. in Blue Ridge City",
    0x4C: "Ray is running from the approaching tsunami in Silvia St. in Blue Ridge City",
    // Stage 8
    0x6A: "Ray is underwater in Blue Ridge City's flooded South Side",
    0x6B: "Ray is precariously making his way through Blue Ridge City's flooded South Side",
    0x6C: "Ray is attempting an urgent rescue in Blue Ridge City's flooded South Side",
    0x73: "Ray is fighting Gregory in Blue Ridge City's flooded South Side",
    0x74: "Ray is fighting Gregory in Blue Ridge City's flooded South Side",
    // Stage 9
    0x98: "Ray is wandering around Highland Park in Blue Ridge City",
    0xA1: "Ray is driving to the SURGE headquarters on Mt. Rosalia",
    // Stage 10
    0xB1: "Ray is outside the SURGE headquarters on Mt. Rosalia",
    0xB2: "Ray is fighting SURGE members outside the SURGE headquarters on Mt. Rosalia",
    0xB3: "Ray is outside the SURGE headquarters on Mt. Rosalia",
    0xBC: "Ray is fighting SURGE members inside the SURGE headquarters on Mt. Rosalia",
    0xBD: "Ray is making his way through the SURGE headquarters on Mt. Rosalia",
    0xBE: "Ray is fighting SURGE members inside the SURGE headquarters on Mt. Rosalia",
    0xBF: "Ray is making his way through the SURGE headquarters on Mt. Rosalia",
    0xC0: "Ray is fighting SURGE members inside the SURGE headquarters on Mt. Rosalia",
    0xC1: "Ray is making his way through the SURGE headquarters on Mt. Rosalia",
    0xC2: "Ray is fighting Evans inside the SURGE headquarters on Mt. Rosalia",
    0xC3: "Ray is fighting Evans inside the SURGE headquarters on Mt. Rosalia",
    0xC4: "Ray is fleeing the flowing lava inside the SURGE headquarters on Mt. Rosalia",
    // Stage 11
    0xA2: "Ray is driving down the mountain road on Mt. Rosalia, fleeing the pyroclastic flow",
    0xAA: "Ray is driving on a highway running along Mt. Rosalia, fleeing the pyroclastic flow",
    // Stage 12
    0xCB: "Ray is desparately trying to walk away from the volcanic fallout on Mt. Rosalia",
    0xCC: "Ray is recovering in Iris's house on Mt. Rosalia",
    0xDB: "Ray and Iris are fleeing Iris's house on Mt. Rosalia",
    // Stage 13
    0xE2: "Ray and Iris's car has broken down in a forest on Mt. Rosalia",
    0xE3: "Ray is carrying Iris across the pyroclastic flow on Mt. Rosalia",
    0xE4: "Ray is scouting for a way out of the forest on Mt. Rosalia",
    0xE5: "Ray is fighting a wild bear in the forest on Mt. Rosalia",
    0xE6: "Ray is scouting for a way out of the forest on Mt. Rosalia",
    0xE7: "Ray is fighting a wild bear in the forest on Mt. Rosalia",
    0xE8: "Ray is scouting for a way out of the forest on Mt. Rosalia",
    0xE9: "Ray is fighting a wild bear in the forest on Mt. Rosalia",
    0xEA: "Ray is searching for Iris in the forest on Mt. Rosalia",
    // Stage 14
    0xF3: "Ray and Iris are making their way past a raised railroad track on Mt. Rosalia",
    0xF4: "Ray is fighting a SURGE attack helicopter on Mt. Rosalia",
    0xF5: "Ray and Iris are making their way past a raised railroad track on Mt. Rosalia",
    0xF6: "Ray and Iris are trying to find a way through the Timber Yard on Mt. Rosalia",
    0xF9: "Ray and Iris have gotten separated on Mt. Rosalia and Ray must save her from encroaching lava",
    0xFA: "Ray and Iris have gotten separated on Mt. Rosalia and Ray must save her from encroaching lava",
    // Stage 15
    0x102: "Ray and Iris are walking along the Campbell River on Mt. Rosalia",
    0x103: "Ray is trying to rescue Iris from a lahar on the Campbell River on Mt. Rosalia",
    // Stage 16
    0x10B: "Ray is on a USAF Transport Plane above Bainesville",
    0x10C: "Ray is on a USAF Transport Plane above Bainesville",
    0x114: "Ray is skydiving into Bainesville",
    // Stage 17
    0x119: "Ray is fighting SURGE members in Bainesville's Northern Quarter",
    0x11A: "Ray is making his way through Bainesville's Northern Quarter",
    0x11B: "Ray is fighting SURGE members in Bainesville's Northern Quarter",
    0x11C: "Ray is making his way through Bainesville's Northern Quarter",
    0x11D: "Ray is fighting SURGE members in Bainesville's Northern Quarter",
    0x11E: "Ray is making his way through Bainesville's Northern Quarter",
    // Stage 18
    0x126: "Ray is making his way through Bainesville's Southern Quarter",
    0x127: "Ray is making his way through Bainesville's Southern Quarter",
    0x128: "Ray is fighting SURGE members in Bainesville's Southern Quarter",
    0x129: "Ray is making his way through Bainesville's Southern Quarter",
    0x12B: "Ray is making his way through Bainesville's Southern Quarter",
    0x12C: "Ray is fighting SURGE members in Bainesville's Southern Quarter",
    0x12D: "Ray is making his way through Bainesville's Southern Quarter",
    0x12E: "Ray is fighting SURGE members in Bainesville's Southern Quarter",
    0x12F: "Ray is making his way through Bainesville's Southern Quarter",
    0x137: "Ray is fighting SURGE members in Bainesville's Northern Quarter",
    0x138: "Ray is making his way through Bainesville's Northern Quarter",
    0x157: "Ray is fighting Banks in Bainesville's Southern Quarter",
    // Stage 19
    0x140: "Ray is arriving at the church in Bainesville",
    0x141: "Ray is locked in the church's basement in Bainesville",
    0x149: "Ray is fighting SURGE members inside the church in Bainesville",
    0x14A: "Ray is searching for Lisa inside the church in Bainesville",
    0x14B: "Ray is fighting SURGE members inside the church in Bainesville",
    0x14C: "Ray is searching for Lisa inside the church in Bainesville",
    0x14D: "Ray is searching for the key to free Lisa inside the church in Bainesville",
    0x14E: "Ray is rescuing Lisa inside the church in Bainesville",
    // Stage 20
    0x15E: "Ray is pursuing a SURGE vehicle in the Seafront Area of Port Alex",
    0x165: "Ray is making his way through the South River Area of Port Alex",
    0x166: "Ray is fighting SURGE members in the South River Area of Port Alex",
    0x167: "Ray is making his way through the South River Area of Port Alex",
    0x168: "Ray is making his way through the South River Area of Port Alex",
    // Stage 21
    0x16F: "Ray is making his way through the North River Area of Port Alex",
    0x170: "Ray is making his way through the North River Area of Port Alex",
    0x171: "Ray is making his way through the North River Area of Port Alex",
    0x172: "Ray is fighting SURGE members in the North River Area of Port Alex",
    0x173: "Ray is making his way through the North River Area of Port Alex",
    0x174: "Ray is fighting SURGE members in the North River Area of Port Alex",
    0x175: "Ray is making his way through the North River Area of Port Alex",
    0x17E: "Ray is fighting SURGE members on the Seaside Highway of Port Alex",
    0x17F: "Ray is fighting SURGE members on the Seaside Highway of Port Alex",
    // Stage 22
    0x187: "Ray is making his way through a Ferry Terminal in Port Alex",
    0x188: "Ray is fighting SURGE members in a Ferry Terminal in Port Alex",
    0x18E: "Ray is in the cargo hold of the ferry",
    0x18F: "Ray is fighting SURGE members inside the ferry",
    0x190: "Ray is making his way up to the deck of the ferry",
    0x191: "Ray is fighting Evans on the deck of the ferry",
    0x192: "Ray is fighting Evans in the XA19 on the deck of the ferry",
    0x193: "Ray is fist-fighting Evans on the deck of the ferry",
    // Stage 23
    0x1A3: "Ray is below deck on the ferry, heading to disarm the nuke",
    0x1A4: "Ray is in the cargo deck of the ferry, searching for the nuke",
    0x1A5: "Ray is in the cargo deck of the ferry, disarming the nuke",
    0x1A6: "Ray is in the cargo deck of the ferry, disarming the nuke",
    0x1A7: "Ray is in the cargo deck of the ferry, heading up to escape the sinking ship",
    0x1A8: "Ray is below deck of the ferry, desperately trying to make it above deck before the ship sinks",
}

rich_presence_conditional_display(
    InTitle(),
    "In the title screen"
)
rich_presence_conditional_display(
    InSpecial(),
    "In the special menu"
)
rich_presence_conditional_display(
    dword_be(g_level_id) == 0,
    "Preparing to have one hell of a day"
)
rich_presence_conditional_display(
    ascii_string_equals(g_level_id, "result") || SaveScreenActive(),
    "Ray is in an intermission"
)
rich_presence_conditional_display(
    ascii_string_equals(g_level_id, "gameover"),
    "Ray is having one hell of a day"
)
rich_presence_conditional_display(
    ascii_string_equals(g_level_id, SHOOTING_RANGE_SPACE),
    "Raymond Bryce is where a first responder has never gone before"
)
rich_presence_conditional_display(
    ascii_string_equals(g_level_id, SHOOTING_RANGE_PREFIX),
    "Ray is shooting targets in the {0} Shooting Range",
    rich_presence_ascii_string_lookup("SHOOTING_RANGE", g_level_id, rp_range, "Unknown")
)
rich_presence_conditional_display(
    StageComplete(),
    "{0} | {1}",
    rich_presence_lookup("TIME", prior(g_checkpoint), rp_time, "Unknown Time"),
    rich_presence_lookup("ACTIVITY", prior(g_checkpoint), rp_activity, "Unknown Activity")
)
rich_presence_conditional_display(
    g_checkpoint == 0,
    "{0} | {1}",
    rich_presence_ascii_string_lookup("TIME_FALLBACK", g_level_id, rp_time_fallback, "Unknown Time"),
    rich_presence_ascii_string_lookup("ACTIVITY_FALLBACK", g_level_id, rp_activity_fallback, "Unknown Activity")
)
rich_presence_conditional_display(
    g_checkpoint != 0,
    "{0} | {1}",
    rich_presence_lookup("TIME", g_checkpoint, rp_time, "Unknown Time"),
    rich_presence_lookup("ACTIVITY", g_checkpoint, rp_activity, "Unknown Activity")
)

rich_presence_display("You can't save everyone")