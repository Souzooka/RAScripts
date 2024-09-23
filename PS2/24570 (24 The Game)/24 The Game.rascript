// 24: The Game
// #ID = 24570
// #MinimumVersion = 1.3

NULL = 0

InGame = () => dword(0x5f97fc) != NULL
g_mission_text = 0x68e8a4

function _str2int(s)
{
    // Converts a length 4 string to a 32-bit integer matching its representation in memory

    // ASCII codes from https://www.asciitable.com/
    lookup = {
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
    
    result = 0
    result = result + (lookup[substring(s, 0, 1)] * 0x1)
    result = result + (lookup[substring(s, 1, 1)] * 0x100)
    result = result + (lookup[substring(s, 2, 1)] * 0x10000)
    result = result + (lookup[substring(s, 3, 1)] * 0x1000000)
    return result
}

// The index in the actual mission string text we want to try matching from
_MISSION_STRING_OFFSET = 8
function CreateMissionMatch(s)
{
    return _str2int(substring(s, _MISSION_STRING_OFFSET, 4))
}

function GetMissionMatch(addr)
{
    return dword(addr + _MISSION_STRING_OFFSET)
}

// Thanks to https://gamefaqs.gamespot.com/ps2/927204-24-the-game/faqs/44588 for providing mission names
CMM = CreateMissionMatch
Missions = {
    CMM("shoot_001_ship"):          "Mission 1 - Storming the Ship",
    CMM("gadget_002_bomb"):         "Mission 2 - Ricin Wired to Blow",
    CMM("shoot_006_dcbase"):        "Mission 3 - Chase Found Out",
    CMM("drive_007_trailbob"):      "Mission 4 - Following Daniels",
    CMM("shoot_008_snapshot"):      "Mission 5 - Daniels Takedown",
    CMM("inter_009_bob"):           "Mission 6 - Interrogating Daniels",
    CMM("gadget_010_findsnipes"):   "Mission 7 - Sniper Search",
    CMM("snipe_011_snapshot"):      "Mission 8 - Taking Out The Enemy",
    CMM("gadget_013_pda"):          "Mission 9 - PDA Data Discovered",
    CMM("shoot_017_koreashop"):     "Mission 10 - Ho Shin's Shop",
    CMM("drive_019_tosnake"):       "Mission 11 - To Lee Jin Yu's Apartment",
    CMM("shoot_020_apartment"):     "Mission 12 - Tony's Unexpected Find",
    CMM("drive_030_toctu"):         "Mission 13 - Bringing in Lee Jin Yu",
    CMM("shoot_036_subway2"):       "Mission 14 - Stopping the Metro Attack",
    CMM("shoot_038_ctu"):           "Mission 15 - M3",
    CMM("shoot_039_ctu"):           "Mission 16 - Kim Goes Back In",
    CMM("shoot_043_ctu"):           "Mission 17 - To The Roof",
    CMM("drive_045a_fromctu"):      "Mission 18 - Chase Undercover",
    CMM("gadget_046_reboot"):       "Mission 19 - Reboot",
    CMM("drive_053_tocia"):         "Mission 20 - To The Agency",
    CMM("shoot_054_cia"):           "Mission 21 - Through the Agency",
    CMM("drive_056_fromcia"):       "Mission 22 - Jack is Chased",
    CMM("shoot_057_madsenbase"):    "Mission 23 - Madsen Attacked",
    CMM("shoot_060_techlab"):       "Mission 24 - Chase Infiltrates the Tech Lab",
    CMM("inter_061_donna"):         "Mission 25 - Questioning Donna",
    CMM("shoot_064_drugden"):       "Mission 26 - Going After Del Toro",
    CMM("drive_068_tomadsen"):      "Mission 27 - Jack Tracks Kim to Madsen's Base",
    CMM("shoot_069_madsenbase"):    "Mission 28 - Jack Heads Into Madsen's Base",
    CMM("shoot_071_madsenbase"):    "Mission 29 - Escape from Madsen's Base",
    CMM("drive_072_frommadsen"):    "Mission 30 - Jack and Kim Escape",
    CMM("gadget_074_scrambler"):    "Mission 31 - Disabling the Data Scrambler",
    CMM("gadget_075_bombs"):        "Mission 32 - Locating the Bombs",
    CMM("shoot_077_bombsite1"):     "Mission 33 - Tony Leads a Team to the Bomb",
    CMM("gadget_078_bomb"):         "Mission 34 - Bomb Defusal",
    CMM("shoot_080_bombsite2_a"):   "Mission 35 - Jack Leads a Team to the Bomb",
    //CMM("shoot_080_bombsite2_b"): "Mission 36 - Attack at the Bomb Site",
    CMM("drive_082_tosubway3"):     "Mission 37 - After the Earthquake",
    CMM("shoot_083b_subway3"):      "Mission 38 - Madsen Has Kate",
    CMM("drive_084_chasemadsen"):   "Mission 39 - Going After Madsen",
    CMM("shoot_087_city"):          "Mission 40 - The Search for Radford",
    CMM("inter_088_jody"):          "Mission 41 - Hostage Situation",
    CMM("shoot_091a_jinyubase"):    "Mission 42 - Accessing the Computer Labs",
    CMM("shoot_091b_jinyubase"):    "Mission 43 - Finding the CTU Data Drive",
    CMM("shoot_091c_jinyubase"):    "Mission 44 - Escaping Joseph Sin Chung's Base",
    CMM("shoot_093a_jinyubase"):    "Mission 45 - Looking for Kate",
    CMM("shoot_093b_jinyubase"):    "Mission 46 - Protect Chase",
    CMM("shoot_095_roadside"):      "Mission 47 - Chase Ambushed",
    CMM("shoot_096_pier"):          "Mission 48 - The Informant",
    CMM("shoot_098_govoffice"):     "Mission 49 - Searching Radford's Office",
    CMM("gadget_116_hackdod"):      "Mission 50 - DOD System Hack",
    CMM("shoot_118_military"):      "Mission 51 - Armored Truck Pursuit",
    CMM("shoot_121_military"):      "Mission 52 - Fort Lesker's Control Room",
    CMM("shoot_122_getcode"):       "Mission 53 - Cracking The Codes",
    CMM("shoot_123_military"):      "Mission 54 - Escape From Fort Lesker",
    CMM("shoot_125a_docks"):        "Mission 55 - Raiding The Docks",
    CMM("shoot_125b_docks"):        "Mission 56 - Jack Vs. Madsen",
    CMM("shoot_128_maxboat_a"):     "Mission 57 - Taking The Ship",
    //CMM("shoot_128_maxboat_b"):   "Mission 58 - The Final Showdown",
    CMM("shoot_modelviewer"):       "Model Viewer",
}

rp_mission_lookup = rich_presence_lookup("MISSION", GetMissionMatch(g_mission_text), Missions, "Unknown Mission")

// Two mission string edgecases where we can't fit them into a 32-bit lookup
rich_presence_conditional_display(
    InGame() && ascii_string_equals(g_mission_text, "shoot_080_bombsite2_b"),
    "In Mission 36 - Attack at the Bomb Site"
)
rich_presence_conditional_display(
    InGame() && ascii_string_equals(g_mission_text, "shoot_128_maxboat_b"),
    "In Mission 58 - The Final Showdown"
)

rich_presence_conditional_display(
    InGame(),
    "In {0}",
    rp_mission_lookup
)
rich_presence_display("Watching 24 or in a menu")