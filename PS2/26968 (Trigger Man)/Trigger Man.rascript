// Trigger Man
// #ID = 26968

NULL = 0

function IsRegion(region)
{
    return true
}

function if_else(cond, v1, v2)
{
    if cond == true
        return v1
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
            val = accessor(addr)
        else
            val = dword(addr)
    }
    
    return val
}

function Human(addr)
{
    obj = {
        "m_health_max": float(addr + 0x34),
        "m_health": float(addr + 0x3C),
    }
    
    return obj
}

g_scene_id = dword(0x277940)
g_next_scene_id = dword(0x277944)
level_id = g_scene_id / 100
next_level_id = g_next_scene_id / 100
p_player = dword(0x277ea8)
g_player = Human(p_player)

g_difficulty = ptr(dword(0x2786c4), [0x4], dword)
DIFFICULTY_NORMAL = 1
DIFFICULTY_DEADLY = 2

rp_difficulty_lookup = {
    DIFFICULTY_NORMAL: "Normal",
    DIFFICULTY_DEADLY: "Deadly",
}

rich_presence_conditional_display(
    next_level_id > 0 && p_player != NULL,
    "In mission {0} | {1} | {2}% health",
    rich_presence_value("VALUE", next_level_id),
    rich_presence_lookup("DIFFICULTY", g_difficulty, rp_difficulty_lookup),
    rich_presence_value("VALUE", 100 * (g_player["m_health"] / g_player["m_health_max"]))
)
rich_presence_display("In main menu")
