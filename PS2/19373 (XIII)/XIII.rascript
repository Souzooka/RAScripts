// XIII
// #ID = 19373
// #MinimumVersion = 1.3

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

ASCII = {
    " ": 0x20,
    "-": 0x2D,
    ".": 0x2E,
    "0": 0x30,
    "1": 0x31,
    "2": 0x32,
    "3": 0x33,
    "4": 0x34,
    "5": 0x35,
    "6": 0x36,
    "7": 0x37,
    "8": 0x38,
    "9": 0x39,
    "_": 0x5F,
    "A": 0x41,
    "B": 0x42,
    "C": 0x43,
    "D": 0x44,
    "E": 0x45,
    "F": 0x46,
    "G": 0x47,
    "H": 0x48,
    "I": 0x49,
    "J": 0x4A,
    "K": 0x4B,
    "L": 0x4C,
    "M": 0x4D,
    "N": 0x4E,
    "O": 0x4F,
    "P": 0x50,
    "Q": 0x51,
    "R": 0x52,
    "S": 0x53,
    "T": 0x54,
    "U": 0x55,
    "V": 0x56,
    "W": 0x57,
    "X": 0x58,
    "Y": 0x59,
    "Z": 0x5A,
    "a": 0x61,
    "b": 0x62,
    "c": 0x63,
    "d": 0x64,
    "e": 0x65,
    "f": 0x66,
    "g": 0x67,
    "h": 0x68,
    "i": 0x69,
    "j": 0x6a,
    "k": 0x6b,
    "l": 0x6c,
    "m": 0x6d,
    "n": 0x6e,
    "o": 0x6f,
    "p": 0x70,
    "q": 0x71,
    "r": 0x72,
    "s": 0x73,
    "t": 0x74,
    "u": 0x75,
    "v": 0x76,
    "w": 0x77,
    "x": 0x78,
    "y": 0x79,
    "z": 0x7A,
}

function assert(cond, msg="No Assertion Message")
{
    if !cond
    {
        l = {}
        return l[msg]
    }
}

function HashConstantString(s, len=0x7FFFFFFF, _result=0)
{
    if (length(s) < len)
    {
        len = length(s)
    }
    
    result = _result
    if len == 3
    {
        tmp = 0
        tmp = tmp + (ASCII[substring(s, 0, 1)] * 0x1)
        tmp = tmp + (ASCII[substring(s, 1, 1)] * 0x100)
        tmp = tmp + (ASCII[substring(s, 2, 1)] * 0x10000)
        result = result + tmp
        return result
    }
    if len == 2
    {
        tmp = 0
        tmp = tmp + (ASCII[substring(s, 0, 1)] * 0x1)
        tmp = tmp + (ASCII[substring(s, 1, 1)] * 0x100)
        result = result + tmp
        return result
    }
    if len == 1
    {
        tmp = 0
        tmp = tmp + (ASCII[substring(s, 0, 1)] * 0x1)
        result = result + tmp
        return result
    }
    if len == 0
    {
        return result
    }
    
    tmp = 0
    tmp = tmp + (ASCII[substring(s, 0, 1)] * 0x1)
    tmp = tmp + (ASCII[substring(s, 1, 1)] * 0x100)
    tmp = tmp + (ASCII[substring(s, 2, 1)] * 0x10000)
    tmp = tmp + (ASCII[substring(s, 3, 1)] * 0x1000000)
    result = result + tmp
    return HashConstantString(substring(s, 4), len - 4, result)
}

function HashRuntimeString(s, len=8, _result=0)
{   
    result = _result
    if len == 3
    {
        result = result + tbyte(s)
        return result
    }
    if len == 2
    {
        result = result + word(s)
        return result
    }
    if len == 1
    {
        result = result + byte(s)
        return result
    }
    if len == 0
    {
        return result
    }
    
    result = result + dword(s)
    return HashRuntimeString(s + 4, len - 4, result)
}

function lower(s)
{
    trans = {
        "A": "a",
        "B": "b",
        "C": "c",
        "D": "d",
        "E": "e",
        "F": "f",
        "G": "g",
        "H": "h",
        "I": "i",
        "J": "j",
        "K": "k",
        "L": "l",
        "M": "m",
        "N": "n",
        "O": "o",
        "P": "p",
        "Q": "q",
        "R": "r",
        "S": "s",
        "T": "t",
        "U": "u",
        "V": "v",
        "W": "w",
        "X": "x",
        "Y": "y",
        "Z": "z",
    }
    
    new_string = ""
    for i in range(0, length(s) - 1)
    {
        char = substring(s, i, 1)
        if any_of(trans, k => k == char)
        {
            char = trans[char]
        }
        new_string = new_string + char
    }
    return new_string
}

g_map_name = 0x454C50
g_difficulty = ptr(0x437af8, [0x30, 0x7C, 0x440, 0x1F0], byte)

HASH_LENGTH = 8
Missions = {
    "entry -ll -rebootiop": "in the main menu",
    "Mapmenu.unr -ll":      "in the main menu",
    "Plage00.unr -ll":      "washed up on Brighton Beach",
    "Plage01.unr -ll":      "on Brighton Beach",
    "Banque01.unr -ll":     "in Winslow Bank",
    "Amos01.unr -ll":       "in the FBI Offices",
    "Toits01.unr -ll":      "on the rooftops above the FBI Offices",
    "Hual01a.unr -ll":      "outside Emerald Base",
    "Hual01b.unr -ll":      "inside Emerald Base perimeter",
    "Hual02.unr -ll":       "inside Emerald Base",
    "Hual04a.unr -ll":      "securing escape from Emerald Base",
    "Hual04c.unr -ll":      "attempting escape from Emerald Base",
    "Kello01a.unr -ll":     "looking for Kim's cabin",
    "kello01b.unr -ll":     "at Kim's cabin",
    "PRock01a.unr -ll":     "at Plain Rock Penitentiary",
    "PRock03.unr -ll":      "at Plain Rock Penitentiary",
    "PRock04a.unr -ll":     "escaping from Plain Rock Penitentiary",
    "PRock04b.unr -ll":     "escaping from Plain Rock Penitentiary",
    "SPADS01.unr -ll":      "infiltrating the SPADS camp",
    "Spads02a.unr -ll":     "infiltrating the SPADS camp",
    "Spads02b.unr -ll":     "sabotaging the SPADS camp",
    "Base01.unr -ll":       "inside the SPADS base",
    "SMarin01.unr -ll":     "onboard a submarine",
    "SMarin02.unr -ll":     "onboard a submarine",
    "USA01.unr -ll":        "in naval docking site Resolute AFMD-10",
    "USA02.unr -ll":        "fighting through dock 33",
    "palace01.unr -ll":     "assaulting the conspirators' meeting with the FBI",
    "sanc01.unr -ll":       "at Senator Willard's estate",
    "sanc02a.unr -ll":      "treading the elite's sacred ground",
    "sanc02b.unr -ll":      "treading the elite's sacred ground",
    "sanc03.unr -ll":       "fleeing Senator Willard's estate via the cliffside",
    "SSH101a.unr -ll":      "attempting to infiltrate a secret government base in Maryland",
    "SSH101b.unr -ll":      "safeguarding the president in a secret government base",
    "SSH101c.unr -11":      "putting a stop to Operation Total Red",
    "SSH102b.unr -11":      "stopping the self-destruct sequence in a secret government base",
    "Bateau01.unr -ll":     "on Senator Sheridan's boat, the Lady Bee",
    "mapcredits.unr -ll":   "watching the credits",
}

MissionsLookup = {}
for key in Missions
{
    normal_hash = HashConstantString(key, HASH_LENGTH)
    lower_hash = HashConstantString(lower(key), HASH_LENGTH)
    assert(!any_of(MissionsLookup, key => key == normal_hash), "Map name hash collision")
    assert(!any_of(MissionsLookup, key => key == lower_hash), "Map name hash collision")

    MissionsLookup[normal_hash] = Missions[key]
    // map names seem to load in lowercase for a frame or 2 for some reason when first changing
    MissionsLookup[lower_hash] = Missions[key]
}
MissionsLookup[0] = "booting the game" // why are you just sat paused on boot anyways
DifficultyLookup = {
    0x0: "Arcade",
    0x1: "Normal",
    0x2: "Realistic"
}

rich_presence_display(
    "XIII is {0} | {1} difficulty",
    rich_presence_lookup("MISSION", HashRuntimeString(g_map_name, HASH_LENGTH), MissionsLookup, "in UNKNOWN MISSION"),
    rich_presence_lookup("DIFFICULTY", g_difficulty, DifficultyLookup, "UNKNOWN")
)