// Disaster: Day of Crisis
// #ID = 11072

SIXTY_FOUR_BIT_SUPPORT = false
REAL_ADDRESS_SUPPORT = false
RA_MASK = 0x1FFFFFFF

NULL = 0

function if_else(cond, a, b)
{
    if cond
        return a
    return b
}

// Custom accessors (w= wii, i.e. wiibit)
function wbit(idx, addr, o=0)
{
    // Extend bit functionality to allow indices over 32 as well
    addr = addr + (idx / 8)
    idx = idx % 8
    return bit(idx, if_else(REAL_ADDRESS_SUPPORT, addr + o, (addr & RA_MASK) + o))
}
function wbit0(addr, o=0) => bit0(if_else(REAL_ADDRESS_SUPPORT, addr + o, (addr & RA_MASK) + o))
function wbit1(addr, o=0) => bit1(if_else(REAL_ADDRESS_SUPPORT, addr + o, (addr & RA_MASK) + o))
function wbit2(addr, o=0) => bit2(if_else(REAL_ADDRESS_SUPPORT, addr + o, (addr & RA_MASK) + o))
function wbit3(addr, o=0) => bit3(if_else(REAL_ADDRESS_SUPPORT, addr + o, (addr & RA_MASK) + o))
function wbit4(addr, o=0) => bit4(if_else(REAL_ADDRESS_SUPPORT, addr + o, (addr & RA_MASK) + o))
function wbit5(addr, o=0) => bit5(if_else(REAL_ADDRESS_SUPPORT, addr + o, (addr & RA_MASK) + o))
function wbit6(addr, o=0) => bit6(if_else(REAL_ADDRESS_SUPPORT, addr + o, (addr & RA_MASK) + o))
function wbit7(addr, o=0) => bit7(if_else(REAL_ADDRESS_SUPPORT, addr + o, (addr & RA_MASK) + o))
function wbitcount(addr, o=0) => bitcount(if_else(REAL_ADDRESS_SUPPORT, addr + o, (addr & RA_MASK) + o))
function wlow4(addr, o=0) => low4(if_else(REAL_ADDRESS_SUPPORT, addr + o, (addr & RA_MASK) + o))
function whigh4(addr, o=0) => high4(if_else(REAL_ADDRESS_SUPPORT, addr + o, (addr & RA_MASK) + o))
function wbyte(addr, o=0) => byte(if_else(REAL_ADDRESS_SUPPORT, addr + o, (addr & RA_MASK) + o))
function wword(addr, o=0) => word_be(if_else(REAL_ADDRESS_SUPPORT, addr + o, (addr & RA_MASK) + o))
function wtbyte(addr, o=0) => tbyte_be(if_else(REAL_ADDRESS_SUPPORT, addr + o, (addr & RA_MASK) + o))
function wdword(addr, o=0) => dword_be(if_else(REAL_ADDRESS_SUPPORT, addr + o, (addr & RA_MASK) + o))
function wqword(addr, o=0) => if_else(SIXTY_FOUR_BIT_SUPPORT, qword_be(if_else(REAL_ADDRESS_SUPPORT, addr + o, (addr & RA_MASK) + o)), assert(false))
function wfloat(addr, o=0) => float_be(if_else(REAL_ADDRESS_SUPPORT, addr + o, (addr & RA_MASK) + o))
function wdouble(addr, o=0) => 
    if_else(
        SIXTY_FOUR_BIT_SUPPORT,
        double_be(if_else(REAL_ADDRESS_SUPPORT, addr + o, (addr & RA_MASK) + o)),
        double32_be(if_else(REAL_ADDRESS_SUPPORT, addr + 4 + o, ((addr + 4) & RA_MASK)) + o)
    )
function wascii_string_equals(addr, string, length=0x7FFFFFFF, transform=a=>a, o=0) =>
    ascii_string_equals(if_else(REAL_ADDRESS_SUPPORT, addr + o, (addr & RA_MASK) + o), string, length, transform)

addr = (v) => v // Dummy accessor for ptr for if the pointed-to address is desired
function ptr(base, offsets, accessor=dword_be)
{
    val = base
    if !REAL_ADDRESS_SUPPORT
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
            if !REAL_ADDRESS_SUPPORT
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

function SaveAppeared()
{
    val = ptr(wdword(0x806E0850), [0x4C], byte)
    return prev(val) == 0 && val == 1
}

// Object constructors
function Player(addr)
{
    obj = {
        "m_life": wfloat(addr, 0x2A70),
        "m_life_max": wfloat(addr, 0x2A74),
        "m_sprint": wfloat(addr, 0x2A88),
        "m_sprint_max": wfloat(addr, 0x2A9C),
        "m_stamina": wfloat(addr, 0x2A98),
        "m_stamina_max": wfloat(addr, 0x2A9C),
    }
    
    return obj
}

function WeaponStats(id)
{
    addr = p_weapon_stats + (id * 0x24)
    obj = {
        "m_id": wdword(addr, 0x0),
        "m_power": wdword(addr, 0x4),
        "m_magazine": wdword(addr, 0x8),
        "m_reloading": wdword(addr, 0xC),
        "m_aiming": wdword(addr, 0x10),
        "m_accuracy": wdword(addr, 0x14),
        "m_mag_ammo": wdword(addr, 0x1C),
    }
    
    return obj
}

p_player = ptr(wdword(0x806E10DC), [0x10, 0x14C], dword_be)
g_player = Player(p_player)

p_weapon_stats = 0x80616A64
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
WEAPON_MINIGUN = 19
WEAPON_MAX = WEAPON_MINIGUN
g_weapons = {}
for id in range(0, WEAPON_MAX)
    g_weapons[id] = WeaponStats(id)

g_checkpoint = wdword(0x805EB588)
level_id = 0x805EB590
level_id_next = 0x805EB5D0
level_id_prior = 0x805EB610

achievement(
    title="Test achievement",
    description="Test",
    points=0,
    trigger=prev(g_player["m_life_max"]) < g_player["m_life_max"]
)

function MaxSkillsTrigger()
{
    // Raymond's skills (Increments even if upgrades are not finalized)
    skills = array_map(range(0, 5 - 1), i => wbyte(0x80616afc, i))
    
    // Value for outstanding cost for skill upgrades before implementing
    p_fee = wdword(0x806E07E4)
    fee = ptr(p_fee, [0x1C48])
    
    return
        all_of(skills, v => v == 5) &&
        p_fee != NULL &&
        prev(fee) > 0 &&
        fee == 0
}

achievement(
    id=0,
    title="One Hell of a Day",
    description="Complete the prologue",
    points=2,
    trigger=
        prev(g_checkpoint) == 0x8 &&
        SaveAppeared()
)

achievement(
    id=0,
    title="One Hell of a Man",
    description="Fully upgrade all of Raymond Bryce's skills",
    points=10,
    trigger=MaxSkillsTrigger()
)