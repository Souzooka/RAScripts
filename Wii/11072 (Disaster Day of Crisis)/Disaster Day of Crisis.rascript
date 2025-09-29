// Disaster: Day of Crisis
// #ID = 11072

// Pointer mask for custom memory map
RA_MASK = 0x1FFFFFFF

NULL = 0

function if_else(cond, a, b)
{
    if cond
        return a
    return b
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

function InGame()
{
    // Tentative
    return p_player != NULL
}

function SaveScreenActive(now=false)
{
    val = ptr(dword_be(0x6E0850), [0x4C], byte)
    if now
        return prev(val) == 0 && val == 1
    return val == 1
}

function StageComplete(id, now=false)
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
    
    cond = prior(g_checkpoint) == last_checkpoint[id] && g_stage_result["m_screen_active"] == 1
    if now
        cond = cond && prev(g_stage_result["m_screen_active"]) == 0
    return cond
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

p_player = ptr(dword_be(0x6E10DC), [0x10, 0x14C], dword_be)
g_player = Player(p_player)
g_stage_result = StageResult()

p_weapon_stats = 0x616A64
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
WEAPON_JUNK = 26 // shouldn't be used a weapon but is real
WEAPON_MAX = WEAPON_JUNK
g_weapons = {}
for id in range(0, WEAPON_MAX)
    g_weapons[id] = WeaponStats(id)

g_checkpoint = dword_be(0x5EB588)
level_id = 0x5EB590
level_id_next = 0x5EB5D0
level_id_prior = 0x5EB610
STAGE_MAX = 23

achievement(
    title="Test achievement",
    description="Test",
    points=0,
    trigger=prev(g_player["m_life_max"]) < g_player["m_life_max"]
)

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

achievement(
    id=0,
    title="We Can't Save Everyone",
    description="Complete the prologue",
    points=2,
    trigger=StageComplete(0, now=true)
)

achievement(
    id=0,
    title="One Hell of a Man",
    description="Fully upgrade all of Raymond Bryce's skills",
    points=10,
    trigger=MaxSkillsTrigger()
)


for stage in range(1, STAGE_MAX)
{
    stage_str = format("{0}", if_else(stage < 10, "0" + stage, stage))
    
    achievement(
        id=0,
        title=format("Stage {0} - Staminas Campaign", stage_str),
        description=format("Find all Staminas Campaign Signs in Stage {0} and complete the stage.", stage_str),
        points=1,
        trigger=
            StageComplete(stage) &&
            prev(g_stage_result["m_staminas_screen"]) == 0 &&
            g_stage_result["m_staminas_screen"] == 1 &&
            g_stage_result["m_staminas_signs_collected"] == g_stage_result["m_staminas_signs_on_stage"]
    )
}
