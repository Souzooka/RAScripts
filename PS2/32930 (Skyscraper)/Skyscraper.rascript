// Skyscraper
// #ID = 32930

NULL = 0

function if_else(cond, v1, v2)
{
    if cond == true
    {
        return v1
    }
    return v2
}

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

SIZEOF_CWEAPON = 0x348
function cWeapon(addr)
{
    obj = {
        "id": dword(addr + 0x188),
        "ammo": dword(addr + 0x23C),
        "ammo_max": dword(addr + 0x240),
    }
    
    return obj
}

g_save_file_index = dword(0x37340c)
g_stage_id = dword(0x3733f8 + (g_save_file_index * 0x878) + 0x1C)
g_in_game = dword(0x358bd0) != NULL
g_health = ptr(dword(0x358bd0), [0x1E4, 0x0, 0x120, 0x58], dword)
g_illness_timer = float(0x302b54)
g_pill_timer = float(0x302b50)
g_player_weapon = cWeapon(ptr(dword(0x358bd0), [0x498, 0x58], dword))

STAGE_FLOOR20 = 0
STAGE_FLOOR21 = 1
STAGE_FLOORB1 = 2
STAGE_GROUND = 3
STAGE_FLOOR24 = 4
STAGE_FLOOR25 = 5
STAGE_FLOOR27 = 6
STAGE_FLOOR28 = 7
STAGE_FLOOR29 = 8
STAGE_FLOOR40 = 9
STAGE_FLOOR26 = 10
STAGE_FLOOR41 = 11
STAGE_FLOOR43 = 12
STAGE_FLOOR44 = 13
STAGE_FLOOR39 = 14
STAGE_FLOOR45 = 15
STAGE_FLOOR48 = 16
STAGE_FLOOR50 = 17
STAGE_ROOF = 18
STAGE_FLOOR55 = 19

// https://www.mobygames.com/game/93438/skyscraper/cover/group-229496/cover-590612/
PLAYER_NAME = "Christopher Wilson"

stage_lookup = {
    STAGE_FLOOR20: "Floor 20, Server 7,",
    STAGE_FLOOR21: "Floor 21, Maintenance Management,",
    STAGE_FLOORB1: "Floor B1, Basement Garage,",
    STAGE_GROUND: "Ground Floor, Lobby,",
    STAGE_FLOOR24: "Floor 24, Enzyme Lab,",
    STAGE_FLOOR25: "Floor 25, Reaction Lab,",
    STAGE_FLOOR27: "Floor 27, Observation Lab,",
    STAGE_FLOOR28: "Floor 28, Cafeteria,",
    STAGE_FLOOR29: "Floor 29, Security,",
    STAGE_FLOOR40: "Floor 40, Leisure Suite,",
    STAGE_FLOOR26: "Floor 26, Hazard Lab,",
    STAGE_FLOOR41: "Floor 41, Middle Lobby,",
    STAGE_FLOOR43: "Floor 43, Outsource Management,",
    STAGE_FLOOR44: "Floor 44, Quality Testing,",
    STAGE_FLOOR39: "Floor 39, Client Apartments,",
    STAGE_FLOOR45: "Floor 45, Marketing Consultancy,",
    STAGE_FLOOR48: "Floor 48, Management Lounges,",
    STAGE_FLOOR50: "Floor 50, Accounting and Personnel,",
    STAGE_ROOF: "roof",
    STAGE_FLOOR55: "Floor 55, Penthouse Office,"
}

preposition_before_lookup = {
    STAGE_GROUND: " the",
    STAGE_ROOF: " the",
}

preposition_after_lookup = {
    STAGE_ROOF: "of",
}

weapon_lookup = {
    // UNUSED
    0x0: "Unarmed",
    0x1: "Knife",
    0x2: "PPK",
    0x3: "P226",
    0x4: "MP5",
    0x5: "Nova",
    0x6: "AK47",
    0x7: "FNFAL",
    0x8: "G3",
    0x9: "AR15",
    0xA: "M16",
    0xB: "SA80",
    0xC: "FNMAG",
    0xD: "L42A1",
    0xE: "L96A1",
    0xF: "L2A2",
    0x10: "FlashBang",
    0x11: "RPG7",
    0x12: "GREMLIN",
    0x13: "STINGER",
    0x14: "Art25Pdr",
    // Skyscraper Weapons (guess you gotta come up with the names yourself)
    0x15: "PistolA",
    0x16: "PistolB",
    0x17: "PistolC",
    0x18: "PistolD",
    0x19: "MagnumA",
    0x1A: "MagnumB",
    0x1F: "SMGA",
    0x20: "SMGB",
    0x21: "SMGC",
    0x29: "ARA",
    0x2A: "ARB",
    0x2B: "LaserA",
    0x2C: "CakeGun",
    0x33: "ChemicalFlaskA",
    0x34: "ChemicalFlaskB",
    0x35: "ChemicalFlaskC",
    0x36: "ChemicalFlaskD",
    0x3D: "ShotgunA"
}

rp_preposition_before = rich_presence_lookup("PREPOSITION_BEFORE", g_stage_id, preposition_before_lookup, "")
rp_stage =              rich_presence_lookup("STAGE", g_stage_id, stage_lookup, "UNKNOWN STAGE")
rp_preposition_after =  rich_presence_lookup("PREPOSITION_AFTER", g_stage_id, preposition_after_lookup, "in")
rp_weapon_name =        rich_presence_lookup("WEAPON_NAME", g_player_weapon["id"], weapon_lookup, "UNKNOWN WEAPON")
rp_ammo =               rich_presence_value("AMMO", g_player_weapon["ammo"])
rp_ammo_max =           rich_presence_value("AMMO_MAX", g_player_weapon["ammo_max"])
rp_health =             rich_presence_value("HEALTH", g_health)
// NOTE: RATools seems to be bugged here and is outputting garbage for the ILLNESS value. Use this instead:
// @ILLNESS(fF00302b54*~0xT00302b57)
// This is to prevent illness from displaying as "-0.0" when it falls below 0, as it will fall right below 0 then pause there
// This inverts the sign bit (bit 31 of a float) which is 0 when positive and 1 when negative, then
// multiplies the original float value to create a faux absolute value
rp_illness =            rich_presence_value("ILLNESS", g_illness_timer * (~bit(31, 0x302b54)), "FLOAT1")
rp_pill =               rich_presence_value("PILL", g_pill_timer, "FLOAT1")

rich_presence_conditional_display(
    g_in_game,
    "{0} is on{1} {2} {3} Tigra Corpa Chemical Research | Weapon: {4} | {5}/{6} Ammo | {7} Health | {8}/{9} Illness/Pill Timer",
    PLAYER_NAME,
    rp_preposition_before,
    rp_stage,
    rp_preposition_after,
    rp_weapon_name,
    rp_ammo,
    rp_ammo_max,
    rp_health,
    rp_illness,
    rp_pill
)
rich_presence_display("{0} is in the main menu or loading screen", PLAYER_NAME)
