// Fire Heroes | Hard Luck
// #ID = 27514

// MISC. SCRIPT HELPERS

NULL = 0
True = 1
False = 0

RegionByte = byte(0x24EE8C)
EU = 0
JP = 1
Regions = [EU, JP]

function IsRegion(region)
{
    return region == RegionByte
}

// The game initializes a lot of pointers to the value 0x16A43 specifically for some reason
// The game isn't going to point to a low region of kernel memory for game objects,
// so we can just do a <= comparison on the pointer type to shrink a null check into one condition
function IsNULL(val)
{
    return val <= 0x16A43
}

function if_else(cond, v1, v2)
{
    if cond == true
    {
        return v1
    }
    return v2
}

function ResolvePointer(base, offsets, accessor=dword)
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

// GAME VARIABLES

// Base of all game logic?
FireCore = {
    EU: dword(0x430EB0),
    JP: dword(0x42CEA8),
}
// Index for the current area
AreaID = {
    EU: ResolvePointer(FireCore[EU], [0xC, 0x2C, 0x40, 0x10, 0x0], word),
    JP: ResolvePointer(FireCore[JP], [0xC, 0x2C, 0x40, 0x10, 0x0], word),
}
// Index for the current campaign character
CampaignID = {
    EU: byte(0x1F9D840),
    JP: byte(0x1F99840),
}
// Index for the current episode
EpisodeID = {
    EU: word(0x1F9D856),
    JP: word(0x1F99856),
}
// The current active character (doesn't match the campaign ID after zapping)
CharacterID = {
    EU: ResolvePointer(FireCore[EU], [0xC, 0x38, 0x380]),
    JP: ResolvePointer(FireCore[JP], [0xC, 0x38, 0x380]),
}
// Game difficulty
Difficulty = {
    EU: ResolvePointer(FireCore[EU], [0xC, 0xE4]),
    JP: ResolvePointer(FireCore[JP], [0xC, 0xE4]),
}
// Victim Status Array (size 0x18) of 8-bit ints
// 0= Unknown?
// 1= Not Rescued
// 2= Rescued
// 3= Dead
VictimStatus = {
    EU: 0x1F9D864,
    JP: 0x1F99864,
}
// How many minutes until the building burns down
InGameCountdownMinutes = {
    EU: (ResolvePointer(FireCore[EU], [0xC, 0x108, 0xC4], float) / 60),
    JP: (ResolvePointer(FireCore[JP], [0xC, 0x108, 0xC4], float) / 60),
}
// HP Guage
SysGuage = {
    EU: dword(0x432B74),
    JP: dword(0x42EB74),
}
// Current Player HP (display value)
CurrentHP = {
    EU: ResolvePointer(SysGuage[EU], [0xC8], float),
    JP: ResolvePointer(SysGuage[JP], [0xC8], float),
}
// Array of Energy levels for the 3 characters
EnergyLevels = {
    EU: 0x1F9D88C,
    JP: 0x1F9988C,
}
// Array of Attack levels for the 3 characters
AttackLevels = {
    EU: 0x1F9D898,
    JP: 0x1F99898,
}
// Array of Speed levels for the 3 characters
SpeedLevels = {
    EU: 0x1F9D8A4,
    JP: 0x1F998A4,
}
// Array of statuses for episodes on the episode select screen
// 0= Open
// 1= Cleared
// 2= Failed
// 0xFF= Unknown
EpisodeStatus = {
    EU: 0x1F9D858,
    JP: 0x1F99858,
}
// Int representing the state of the episode result screen. Note this value persists when the screen is exited.
// 0x0= Screen never entered; initial
// 0x1= Animations finished. Waiting for X button to be pressed.
// 0x2= X button pressed; results screen fading out. Persists after leaving screen.
// 0x5= Items are animating into frame
EpisodeResultScreenState = {
    EU: dword(0x432ABC),
    JP: dword(0x42EABC),
}
// Int representing the state of the episode select screen. Note this value persists when the screen is exited.
// 0= Init/elements animating in
// 1= Elements done animating; idle
// 2= Level selected; should also be the value which persists into episodes
// 3= Exiting to Main Menu
EpisodeSelectScreenState = {
    EU: dword(0x432A88),
    JP: dword(0x42EA88),
}
// Int representing the state of the game score screen (i.e. after campaign end).
// Note this value persists after leaving the menu.
// 0= Init
// 1= Survivors Screen idle
// 2= Game Score being tallied
// 3= Save game prompt
// 4= Transition to Game Score Screen
// 5= Game Score Screen coming into view
// 6= Game Score screen tally finished; cross button prompt sliding into view (transitions from 2 IF next points goal not met; else from 8)
// 7= Score finished being tallied; wait a sec (transitions from 2 IF points goal met)
// 8= Flash after score tally (from 7)
GameResultScreenState = {
    EU: dword(0x432A88),
    JP: dword(0x42EA88),
}
// Int representing the rank in the game score screen
// 0=S
// 1=A
// 2=B
// 3=C
// 4=D
// 5=E
GameResultScreenRank = {
    EU: dword(0x432A5C),
    JP: dword(0x42EA5C),
}
// Number of times the points game in the GAME SCORE menu has been met (the goal increments by 500 each time)
// 1= Hard Mode unlocked
// 2= Character Color Type A unlocked
// 3= Character Color Type B unlocked
// 4= Ultimate Weapon Masamune appears in game
// 5= Fire-extinguisher gun with unlimited ammo appears in game
NumTimesPointsGoalMet = {
    EU: dword(0x1F9D8B8),
    JP: dword(0x1F998B8),
}

// ENUEMRATIONS

// Character ID
DOUGLAS = 0
MAX = 1
SCOTT = 2

// Difficulty
EASY = 0
NORMAL = 1
HARD = 2

// Episode Status
EPISODE_OPEN = 0
EPISODE_CLEARED = 1
EPISODE_FAILED = 2
EPISODE_UNKNOWN = 0xFF

// Victim Status
UNKNOWN = 0
NOT_RESCUED = 1 // Turns to DEAD when going to results screen, if they were a part of that episode
RESCUED = 2
DEAD = 3

// Victim ID
VICTIM_A = 0x0
VICTIM_B = 0x1
FIREMAN = 0x2
SEAN = 0x3
JACOB = 0x4
ROSE = 0x6
VICTIM_C = 0x7
AMANDA = 0x8
TABBY = 0x9 // The most important victim
DONNA = 0xA
KEVIN = 0xB
NICHOLAS = 0xC
STEVE = 0xD
SARAH = 0xE
SAMANTHA = 0xF
MORGAN = 0x10
KATE = 0x11
VINCENT = 0x12
PAUL = 0x13
YUU = 0x14

// MISC. GAME HELPERS

function IsInGame(region)
{
    // Checks a pointer which is consistently NULL while not in-game/while in loading screens
    base = FireCore[region]
    
    return !IsNULL(base) &&
           !IsNULL(ResolvePointer(base, [0xC, 0x2C, 0x40]))
}

function IsPrologue(region)
{
    // Returns if we're in the prologue episode
    return EpisodeID[region] == 0
}

function IsFinalEpisode(region)
{
    // Returns if this is one of the finale episodes (and as such does not have the building burn-down timer)
    return any_of([8, 9], episode => EpisodeID[region] == episode)
}

function IsNormalEpisode(region)
{
    // Returns if this is an episode with the building burn-down timer
    return !IsPrologue(region) && !IsFinalEpisode(region)
}

function HalfHoursToMidnight(region)
{
    // Returns how many half-hours until the building burns down, for RP purposes
    return InGameCountdownMinutes[region] / 30
}

function GetVictimStatus(region, victim)
{
    // Returns the status of a victim, given their ID
    return byte(VictimStatus[region] + victim)
}

function GetEpisodeStatus(region, episode)
{
    // Returns the status of an episode on the episode select screen
    return byte(EpisodeStatus[region] + episode)
}

function GetEnergyLevel(region, character=-1)
{
    // Returns a character's Energy level (refer to status screen)
    // Value returned is 0-based (so 2 stars would return a value of 1, for example)
    return byte(EnergyLevels[region] + if_else(character == -1, CharacterID[region], character))
}

function GetAttackLevel(region, character=-1)
{
    // Returns a character's Attack level (refer to status screen)
    // Value returned is 0-based (so 2 stars would return a value of 1, for example)
    return byte(AttackLevels[region] + if_else(character == -1, CharacterID[region], character))
}

function GetSpeedLevel(region, character=-1)
{
    // Returns a character's Speed level (refer to status screen)
    // Value returned is 0-based (so 2 stars would return a value of 1, for example)
    return byte(SpeedLevels[region] + if_else(character == -1, CharacterID[region], character))
}

// RICH PRESENCE START

TitleLookup = {
    EU: "Fire Heroes",
    JP: "Hard Luck: Return of the Heroes",
}

PrologueLookup = {
    DOUGLAS: "Prologue: \"FDSA Dispatched\"",
    MAX: "Prologue: \"Evidence of a Crime\"",
    SCOTT: "Prologue: \"The Tragedy Begins\"",
}

CharacterLookup = {
    DOUGLAS: "👨‍🚒 Douglas Brantley",
    MAX: "👮‍ Max Broderick",
    SCOTT: "🧑 Scott Winkler",
}

DifficultyLookup = {
    EASY: "Easy",
    NORMAL: "Normal",
    HARD: "Hard"
}

// Can you believe it guys?
// Christmas! Just 5 hours away!
// Christmas is in 5 hours! Woohoo!
// I am so happy about this information.
// Christmas! Just 5 hours away! Oh wow!
// Can you believe it? Christmas, just in 5 hours!
// It got here so fast! Christ-
// Emoji used in RP depending on how long is remaining until the building burns down
HalfHoursLookup = {
    10: "🕖", // For 5h until building collapse exactly; only appears for a moment
    9: "🕖", // >=4h30m
    8: "🕢", // >=4h
    7: "🕗", // >=3h30m
    6: "🕣", // >=3h
    5: "🕘", // >=2h30m
    4: "🕤", // >=2h
    3: "🕙", // >=1h30m
    2: "🕥", // >=1h
    1: "🕚", // >=30m
    0: "🕦", // >=0m
}

EpisodeLookup = {
    1: "Episode 1: \"The Ideal and the Real\"",
    2: "Episode 2: \"Hot Down Below\"",
    3: "Episode 3: \"A Young Life\"",
    4: "Episode 4: \"Greed\"",
    5: "Episode 5: \"The Scales of Life\"",
    6: "Episode 6: \"Time Bomb\"",
    7: "Episode 7: \"Crooked Love\"",
    8: "Episode 8: \"A Desperate Escape\"",
    9: "Episode 9: \"Saving a Hero\"",
}

AreaLookup = {
    0x0: "UNKNOWN AREA 0x0", // Appears to possibly just be a debug/dummy room, loaded in a debug episode?
    0x1: "B2 Boiler Room",
    0x2: "B2 Hallway", // Interesting note: Loaded in Max Episode 4
    0x3: "B1 Parking",
    0x4: "1F - 2F Entrance",
    0x5: "1F - 2F Goods Storage A",
    0x6: "1F - 2F Goods Storage B",
    0x7: "B1 - 1F Hallway",
    0x8: "UNKNOWN AREA 0x8", // NOT LOADED ??
    0x9: "3F - 4F Emergency Stairs",
    0xA: "3F Shop Under Construction B",
    0xB: "3F Shop Under Construction A",
    0xC: "3F Shop Hallway",
    0xD: "UNKNOWN AREA 0xD", // NOT LOADED ??
    0xE: "4F Bookstore",
    0xF: "4F CD Shop",
    0x10: "UNKNOWN AREA 0x10", // Loaded in Douglas/Max/Scott Episode 6
    0x11: "4F Shop Hallway",
    0x12: "UNKNOWN AREA 0x12", // NOT LOADED ??
    0x13: "5F Boutique",
    0x14: "5F - 6F Emergency Stairs",
    0x15: "5F Shop Hallway",
    0x16: "5F Sports Shop",
    0x17: "UNKNOWN AREA 0x17", // Loaded in Douglas/Max/Scott Episode 6
    0x18: "UNKNOWN AREA 0x18", // Loaded in Douglas/Max/Scott Episode 6
    0x19: "6F Monorail Platform",
    0x1A: "6F Station Lobby",
    0x1B: "7F - 8F Emergency Stairs",
    0x1C: "7F Dinosaur Mueseum",
    0x1D: "7F Pool",
    0x1E: "7F Pool Lobby",
    0x1F: "7F Museum Hallway",
    0x20: "8F Freight Elevator Hallway",
    0x21: "8F Viewing Room",
    0x22: "8F Movie Theater Lobby",
    0x23: "8F Movie Theater Hallway",
    0x24: "9F Office Room A",
    0x25: "9F Office Room C",
    0x26: "9F Office Room D",
    0x27: "9F - 10F Office Stairwell Hallway",
    0x28: "10F Office Room A",
    0x29: "9F - 10F Office Room B",
    0x2A: "10F Office Room C",
    0x2B: "10F Office Room D",
    0x2C: "UNKNOWN AREA 0x2C", // Loaded in Douglas/Max/Scott Episode 4
    0x2D: "11F Office Room B",
    0x2E: "11F Office Room C",
    0x2F: "11F Office Room D",
    0x30: "11F - 12F Office Stairwell Hallway",
    0x31: "11F - 12F Office Room A",
    0x32: "12F Office Room B",
    0x33: "12F Office Room C",
    0x34: "12F Office Room D",
    0x35: "13F Office Room A",
    0x36: "13F Office Room B",
    0x37: "13F Office Room C",
    0x38: "13F Office Room D",
    0x39: "13F - 14F Office Stairwell Hallway",
    0x3A: "14F Office Room A",
    0x3B: "14F Office Room B",
    0x3C: "14F Office Room C",
    0x3D: "14F Office Room D",
    0x3E: "15F Office Room A",
    0x3F: "15F Office Room B",
    0x40: "15F Office Room C",
    0x41: "15F Office Room D",
    0x42: "15F - 16F Office Stairwell Hallway",
    0x43: "16F Office Room A",
    0x44: "16F Office Room B",
    0x45: "16F Office Room C",
    0x46: "16F Office Room D",
    0x47: "UNKNOWN AREA 0x47", // NOT LOADED ??
    0x48: "17F Examining Room A",
    0x49: "17F Examining Room B",
    0x4A: "17F Operating Room",
    0x4B: "17F Large Examining Room",
    0x4C: "17F Hospital Hallway",
    0x4D: "18F Freight Elevator Hallway",
    0x4E: "UNKNOWN AREA 0x4E", // Loaded in Douglas/Max/Scott Episode 7
    0x4F: "18F - 19F Emergency Stairs",
    0x50: "18F Italian Restaurant 1F",
    0x51: "18F Restaurant Hallway",
    0x52: "19F Base",
    0x53: "19F Freight Elevator Hallway",
    0x54: "UNKNOWN AREA 0x54", // Loaded in Douglas/Max/Scott Episode 5
    0x55: "19F Italian Restaurant 2F",
    0x56: "19F Restaurant Hallway",
    0x57: "20F Emergency Stairs",
    0x58: "20F Guestroom Hallway",
    0x59: "20F Laundry Room",
    0x5A: "20F Security Room",
    0x5B: "20F Storage Room",
    0x5C: "UNKNOWN AREA 0x5C", // NOT LOADED ??
    0x5D: "21F Emergency Stairs",
    0x5E: "21F Guest Room 211",
    0x5F: "21F Guest Room 212",
    0x60: "21F Guest Room 213",
    0x61: "21F Guestroom Hallway",
    0x62: "22F Freight Elevator Hallway",
    0x63: "22F - 23F Emergency Stairs",
    0x64: "22F Guest Room 221",
    0x65: "22F Guest Room 222",
    0x66: "22F Guest Room 223",
    0x67: "22F Guestroom Hallway",
    0x68: "23F Freight Elevator Hallway",
    0x69: "UNKNOWN AREA 0x69", // Loaded in Douglas/Max/Scott Episode 1
    0x6A: "23F Guest Room 231",
    0x6B: "23F Guest Room 232",
    0x6C: "23F Guest Room 233",
    0x6D: "23F Guestroom Hallway",
    0x6E: "24F Guest Room 241",
    0x6F: "24F Guest Room 248",
    0x70: "24F Guestroom Hallway",
    0x71: "25F Freight Elevator Hallway",
    0x72: "25F Emergency Stairs",
    0x73: "25F Guestroom 251",
    0x74: "25F Guestroom 252",
    0x75: "25F Guestroom 253",
    0x76: "25F Guestroom 254",
    0x77: "25F Guestroom 255",
    0x78: "25F Guestroom 256",
    0x79: "25F Guestroom 257",
    0x7A: "25F Guestroom 258",
    0x7B: "25F Guestroom 259",
    0x7C: "25F Guestroom Hallway",
    0x7D: "UNKNOWN AREA 0x7D", // NOT LOADED ??
    0x7E: "26F Emergency Stairs",
    0x7F: "26F Guestroom 261",
    0x80: "26F Guestroom 262",
    0x81: "26F Guestroom 263",
    0x82: "26F Guestroom 264",
    0x83: "26F Guestroom 265",
    0x84: "26F Guestroom 266",
    0x85: "26F - 27F Guestrooms 266-276",
    0x86: "26F Guestroom 268",
    0x87: "26F Guestroom 269",
    0x88: "26F Guestroom Hallway",
    0x89: "UNKNOWN AREA 0x89", // NOT LOADED ??
    0x8A: "27F Emergency Stairs",
    0x8B: "27F Guestroom 271",
    0x8C: "27F Guestroom 272",
    0x8D: "27F Guestroom 273",
    0x8E: "27F Guestroom 274",
    0x8F: "27F Guestroom 275",
    0x90: "27F Guestroom 276",
    0x91: "27F Guestroom 277",
    0x92: "27F Guestroom 278",
    0x93: "27F Guestroom 279",
    0x94: "27F Guestroom Hallway",
    0x95: "28F Balcony",
    0x96: "28F Emergency Stairs",
    0x97: "28F Heating - Freight Elevator",
    0x98: "28F Party Hall",
    0x99: "28F Party Hall Lobby",
    0x9A: "UNKNOWN AREA 0x9A", // Loaded in Douglas/Max/Scott Episode 5, Douglas/Max/Scott Episode 9
    0x9B: "29F Panorama House",
    0x9C: "29F Storage Room - Freight Elevator",
    0x9D: "29F - 30F Emergency Stairs - Machine Room",
    0x9E: "R Tower Roof",
    0x9F: "8F - 9F Elevator Shaft",
    0xA0: "27F - 28F Elevator Shaft",
    0xA1: "25F - 26F Elevator Shaft",
}

for region in Regions
{
    rich_presence_conditional_display(
        IsRegion(region) && IsInGame(region) && IsPrologue(region),
        "{0} | {1} is in {2} | {3} | {4} difficulty | {5}/{6} HP | 🕡 Evaluating the disaster...",
        rich_presence_lookup("TITLE", region, TitleLookup),
        rich_presence_lookup("CHARACTER", CharacterID[region], CharacterLookup),
        rich_presence_lookup("AREA", AreaID[region], AreaLookup),
        rich_presence_lookup("PROLOGUE", CampaignID[region], PrologueLookup),
        rich_presence_lookup("DIFFICULTY", Difficulty[region], DifficultyLookup),
        rich_presence_value("CURRENT_HP", CurrentHP[region]),
        rich_presence_value("MAX_HP", 100 + (GetEnergyLevel(region) * 25))
    )
    rich_presence_conditional_display(
        IsRegion(region) && IsInGame(region) && IsNormalEpisode(region),
        "{0} | {1} is in {2} | {3} | {4} difficulty | {5}/{6} HP | {7} {8}m until the building burns down!",
        rich_presence_lookup("TITLE", region, TitleLookup),
        rich_presence_lookup("CHARACTER", CharacterID[region], CharacterLookup),
        rich_presence_lookup("AREA", AreaID[region], AreaLookup),
        rich_presence_lookup("EPISODE", EpisodeID[region], EpisodeLookup),
        rich_presence_lookup("DIFFICULTY", Difficulty[region], DifficultyLookup),
        rich_presence_value("CURRENT_HP", CurrentHP[region]),
        rich_presence_value("MAX_HP", 100 + (GetEnergyLevel(region) * 25)),
        // Easy Mode gives you a 7 hour limit, so we'll just have a default string here for 7 PM if the time extends past 5 hours
        rich_presence_lookup("HALFHOURS", HalfHoursToMidnight(region), HalfHoursLookup, "🕖"),
        rich_presence_value("COUNTDOWN", InGameCountdownMinutes[region], format="MINUTES")
    )
    rich_presence_conditional_display(
        IsRegion(region) && IsInGame(region) && IsFinalEpisode(region),
        "{0} | {1} is in {2} | {3} | {4} difficulty | {5}/{6} HP | 🕛 The building is coming down at any moment!",
        rich_presence_lookup("TITLE", region, TitleLookup),
        rich_presence_lookup("CHARACTER", CharacterID[region], CharacterLookup),
        rich_presence_lookup("AREA", AreaID[region], AreaLookup),
        rich_presence_lookup("EPISODE", EpisodeID[region], EpisodeLookup),
        rich_presence_lookup("DIFFICULTY", Difficulty[region], DifficultyLookup),
        rich_presence_value("CURRENT_HP", CurrentHP[region]),
        rich_presence_value("MAX_HP", 100 + (GetEnergyLevel(region) * 25))
    )
    rich_presence_display(
        "{0} | In a menu or loading screen",
        rich_presence_lookup("TITLE", RegionByte, TitleLookup)
    )
}

// RICH PRESENCE END

// Leaderboards not applicable for this game?

// ACHIEVEMENTS START

CharacterNames = {
    DOUGLAS: "Douglas Brantley",
    MAX: "Max Broderick",
    SCOTT: "Scott Winkler",
    
}
EpisodeNames = {
    0: {
        DOUGLAS: "Prologue: \"FDSA Dispatched\"",
        MAX: "Prologue: \"Evidence of a Crime\"",
        SCOTT: "Prologue: \"The Tragedy Begins\"",
    },
    1: "Episode 1: \"The Ideal and the Real\"",
    2: "Episode 2: \"Hot Down Below\"",
    3: "Episode 3: \"A Young Life\"",
    4: "Episode 4: \"Greed\"",
    5: "Episode 5: \"The Scales of Life\"",
    6: "Episode 6: \"Time Bomb\"",
    7: "Episode 7: \"Crooked Love\"",
    8: "Episode 8: \"A Desperate Escape\"",
    9: "Episode 9: \"Saving a Hero\"", 
}
// This is for just completing the episode -- not saving all survivors, if applicable
EpisodePoints = {
    DOUGLAS: {
        0: 2,
        1: 2,
        2: 2,
        3: 2,
        4: 2,
        5: 3,
        6: 2,
        7: 2,
        8: 5,
        9: 25,
    },
    MAX: {
        0: 2,
        1: 2,
        2: 2,
        3: 2,
        4: 2,
        5: 2,
        6: 3,
        7: 2,
        8: 5,
        9: 25,
    },
    SCOTT: {
        0: 2,
        1: 2,
        2: 2,
        3: 2,
        4: 2,
        5: 2,
        6: 2,
        7: 3,
        8: 5,
        9: 25,
    },
}
EpisodeTitles = {
    DOUGLAS: {
        0: "FDSA Dispatched",
        1: "Basic Training",
        2: "Won't Crack Under Pressure",
        3: "Fire Exhibit",
        4: "Money to Burn",
        5: "House Call",
        6: "The Hot-Headed Reporter",
        7: "Fire Burning in the Party Hall",
        8: "Fiery Dash",
        9: "Firefighter's Duty",
    },
    MAX: {
        0: "Evidence of a Crime",
        1: "Search & Rescue",
        2: "Parking Violation",
        3: "Community Outreach",
        4: "White-Hot Collar Crime",
        5: "Code Blue",
        6: "Pursuing the Truth",
        7: "Crowd Control",
        8: "Flatfoot Flight",
        9: "Police Officer's Duty",
    },
    SCOTT: {
        0: "The Tragedy Begins",
        1: "The Ideal and the Real",
        2: "Hot Down Below",
        3: "A Young Life",
        4: "Greed",
        5: "The Scales of Life",
        6: "Time Bomb",
        7: "Crooked Love",
        8: "A Desperate Escape",
        9: "Architect's Duty",
    },
}
EpisodeIDs = {
    DOUGLAS: {
        0: 417855,
        1: 417856,
        2: 417857,
        3: 417858,
        4: 417859,
        5: 417860,
        6: 417861,
        7: 417862,
        8: 417863,
        9: 417864,
    },
    MAX: {
        0: 417865,
        1: 417866,
        2: 417867,
        3: 417868,
        4: 417869,
        5: 417870,
        6: 417871,
        7: 417872,
        8: 417873,
        9: 417898,
    },
    SCOTT: {
        0: 417874,
        1: 417899,
        2: 417875,
        3: 417900,
        4: 417876,
        5: 417877,
        6: 417901,
        7: 417878,
        8: 417902,
        9: 417879,
    },
}

function EpisodeTrigger(region, character, episode)
{
           // Correct region
    return IsRegion(region) &&
           // Correct campaign
           CampaignID[region] == character &&
           // Correct episode
           EpisodeID[region] == episode &&
           // Listen for an episode result screen transition
           prev(EpisodeResultScreenState[region]) == 5 &&
           EpisodeResultScreenState[region] == 1
}

function EndingTrigger(region, character=-1, episode=-1)
{
    character_check = if_else(character != -1, CampaignID[region] == character, always_true())
    episode_check = if_else(episode != -1, EpisodeID[region] == episode, always_true())

           // Correct region
    return IsRegion(region) &&
           // Correct character
           character_check &&
           // Correct episode
           episode_check &&
           // Ending screen state (we've started tallying game score)
           prev(GameResultScreenState[region]) != 2 &&
           GameResultScreenState[region] == 2
}

function EndingScoreDoneTrigger(region)
{
           // Correct region
    return IsRegion(region) &&
           // Ending screen state (we've finished tallying game score)
           prev(GameResultScreenState[region]) == 2 &&
           GameResultScreenState[region] != 2
}

function Episode8Trigger(region, character)
{
    // UGHHHHHHHHHHHHHH the game does not make this easy to check
    // I've spent several hours down this rabbit hole
    // (Ending isn't stored anywhere besides a once-off "you got it at some point" bool :()
    event_time_ptr = dword(0x43285C)
    event_time = ResolvePointer(event_time_ptr, [0xAC], float)
    event_time_paused = ResolvePointer(event_time_ptr, [0x80]) == 8
    
    no_ending_6_check = (
        disable_when(
            // Correct region
            IsRegion(region) &&
            // We're on episode 8
            EpisodeID[region] == 8 &&
            // The event timer expired (you didn't reach the heli :()
            !IsNULL(event_time_ptr) &&
            // bruh they zero event_time out right *BEFORE* deallocating the pointer! Why???
            tally(2, event_time_paused && event_time == 0.0),
            
                  // Correct region
            until=IsRegion(region) &&
                  // We're so back (on episode 8!)
                  EpisodeID[region] == 8 &&
                  // You're giving us more time? How gracious, game
                  !IsNULL(event_time_ptr) &&
                  event_time > 0.0
        )
    )
    
                   // They got an ending (i.e. not 100% rescue rate or didn't reach heli)
    ending_check = EndingTrigger(region, character=character, episode=8) &&
                   // But you gotta get to the choppa my dude
                   no_ending_6_check

    episode_clear_check = (
        // This kind of relies on an assumption that the episode select state will be
        // stuck at 2 when in-game, so this may end up being too voliatile and we
        // may have to do some hit check where the player was in game and now they
        // got to the episode select without being in the title screen or something
        prev(EpisodeSelectScreenState[region]) == 2 &&
        EpisodeSelectScreenState[region] == 0 &&
        // Episode 8 should be cleared
        GetEpisodeStatus(region, 8) == EPISODE_CLEARED &&
        // Check that Episode 9 is also open as a sanity check
        GetEpisodeStatus(region, 9) == EPISODE_OPEN &&
        // Lastly, check for character match
        CampaignID[region] == character
    )

           // Correct region
    return IsRegion(region) &&
           (
               // Either we get an ending (not 100% rescue rate or we didn't escape)
               ending_check ||
               // We didn't get an ending (100% rescue rate and we made it to the chopper)
               episode_clear_check
           )
}

function Episode9Trigger(region, character)
{
    ending_check = EndingTrigger(region, character=character, episode=9)

           // Correct region
    return IsRegion(region) &&
           // Check that we entered game score screen
           ending_check
}

// Progression
for character in [DOUGLAS, MAX, SCOTT]
{
    for episode in EpisodeNames
    {   
        // Prologue, episodes 1-7 -- happy case, we just check for the episode result screen
        trigger = any_of(Regions, region => EpisodeTrigger(region, character, episode))
        // Want an ending or detect fade out (100% rescue rate) for episode 8
        trigger = if_else(
            episode == 8, 
            any_of(Regions, region => Episode8Trigger(region, character)), 
            trigger
        )
        // Want an ending for episode 9
        trigger = if_else(
            episode == 9, 
            any_of(Regions, region => Episode9Trigger(region, character)), 
            trigger
        )
        // Can fail episode 8 and you only get episode 9 with 100% rescue
        type = if_else(episode >= 8, "missable", "")
    
        achievement(
            id=EpisodeIDs[character][episode],
            title=EpisodeTitles[character][episode],
            description=format(
                "As {0}, complete {1}{2}.",
                CharacterNames[character],
                if_else(episode == 0, EpisodeNames[0][character], EpisodeNames[episode]),
                if_else(episode == 8, " without running out of time", "")
            ),
            points=EpisodePoints[character][episode],
            trigger=trigger,
            type=type
        )
    }
}

EpisodeHeroParams = {
    DOUGLAS: {
        0: {
            "id": 417903,
            "title": "The FDSA Bursts Onto the Scene!",
            "points": 5,
            "victims": [VICTIM_A, VICTIM_B, FIREMAN],
        },
        1: {
            "id": 417880,
            "title": "Rookie Under Your Wings",
            "points": 5,
            "victims": [SEAN, JACOB],
        },
        2: {
            "id": 417904,
            "title": "Red Rose",
            "points": 5,
            "victims": [FIREMAN, VICTIM_C, ROSE],
        },
        3: {
            "id": 417881,
            "title": "Cat Lover",
            "points": 5,
            "victims": [AMANDA, TABBY, DONNA, KEVIN],
        },
        4: {
            "id": 417905,
            "title": "Dragged From the Brink",
            "points": 5,
            "victims": [NICHOLAS, STEVE],
        },
        5: {
            "id": 417882,
            "title": "Life-Saving Couple",
            "points": 5,
            "victims": [SARAH, SAMANTHA],
        },
        6: {
            "id": 417883,
            "title": "Kept Your Cool",
            "points": 5,
            "victims"
            : [MORGAN, KATE, VINCENT],
        },
        7: {
            "id": 417906,
            "title": "Cooled-Off Passion",
            "points": 5,
            "victims": [YUU, PAUL],
        },
    },
    MAX: {
        1: {
            "id": 417884,
            "title": "A Show of Courage",
            "points": 5,
            "victims": [SEAN, JACOB],
        },
        2: {
            "id": 417907,
            "title": "Boiler Burn",
            "points": 5,
            "victims": [FIREMAN, VICTIM_C, ROSE],
        },
        3: {
            "id": 417885,
            "title": "Huh, I Wonder Who That Timer's For",
            "points": 5,
            "victims": [AMANDA, TABBY, DONNA, KEVIN],
        },
        4: {
            "id": 417886,
            "title": "Tossed in the Drunk Tank",
            "points": 5,
            "victims": [NICHOLAS, STEVE],
        },
        5: {
            "id": 417908,
            "title": "CPR-Certified",
            "points": 5,
            "victims": [SARAH, SAMANTHA],
        },
        6: {
            "id": 417887,
            "title": "There's No Such Thing as a Blue Rose",
            "points": 5,
            "victims": [MORGAN, KATE, VINCENT],
        },
        7: {
            "id": 417909,
            "title": "Hostage Situation",
            "points": 5,
            "victims": [YUU, PAUL],
        },
    },
    SCOTT: {
        1: {
            "id": 417888,
            "title": "Everyone Wants to Save Their Boss",
            "points": 5,
            "victims": [SEAN, JACOB],
        },
        2: {
            "id": 417889,
            "title": "You Aren't Yuu",
            "points": 5,
            "victims": [FIREMAN, VICTIM_C, ROSE],
        },
        3: {
            "id": 417910,
            "title": "Cool Cat",
            "points": 5,
            "victims": [AMANDA, TABBY, DONNA, KEVIN],
        },
        4: {
            "id": 417890,
            "title": "Money Isn't Everything",
            "points": 5,
            "victims": [NICHOLAS, STEVE],
        },
        5: {
            "id": 417911,
            "title": "Won't Put My Next Hospital on 17F",
            "points": 5,
            "victims": [SARAH, SAMANTHA],
        },
        6: {
            "id": 417891,
            "title": "Suspicious Security Savior",
            "points": 5,
            "victims": [MORGAN, KATE, VINCENT],
        },
        7: {
            "id": 417912,
            "title": "Music to Fight Fires to",
            "points": 5,
            "victims": [YUU, PAUL],
        },
    },
}

function EpisodeHeroTrigger(region, character, episode)
{
    victims = EpisodeHeroParams[character][episode]["victims"]
    
           // Correct region
    return IsRegion(region) &&
           // Normal episode completion
           EpisodeTrigger(region, character, episode) &&
           // All victims rescued in the episode
           all_of(victims, victim => GetVictimStatus(region, victim) == RESCUED)
}

// Saving every survivor in applicable episodes
for character in EpisodeHeroParams
{
    for episode in EpisodeHeroParams[character]
    {
        params = EpisodeHeroParams[character][episode]
        achievement(
            id=params["id"],
            title=params["title"],
            description=format(
                "As {0}, complete {1} while rescuing every possible victim.",
                CharacterNames[character],
                if_else(episode == 0, EpisodeNames[0][character], EpisodeNames[episode])
            ),
            points=params["points"],
            trigger=any_of(Regions, region => EpisodeHeroTrigger(region, character, episode)),
            type="missable"
        )
    }
}

// We can end the game as any character, either on episode 8 or 9
// It doesn't really adapt to RA's progression labels well at all, but
// for the sake of having an achievement act as the win condition here we are
// Also it's technically 1-statement-condition disregarding the region check but I evaluated
// its uses in code myself and it's safe
achievement(
    id=417893,
    title="Fire Protagonist",
    description="Obtain any ending with any character.",
    points=2,
    trigger=any_of(Regions, region => (
        // Correct region
        IsRegion(region) &&
        // Game Score Tally done
        EndingScoreDoneTrigger(region)
    )),
    type="win_condition"
)

// Yadayada same deal with hard
achievement(
    id=417894,
    title="Fire Hero",
    description="Obtain any ending with any character on Hard difficulty.",
    points=25,
    trigger=any_of(Regions, region => (
        // Correct region
        IsRegion(region) &&
        // Correct difficulty
        Difficulty[region] == HARD &&
        // Game Score Tally done
        EndingScoreDoneTrigger(region)
    ))
)

// Now do it again with an 'S' rank!!!
achievement(
    id=417914,
    title="Fire Saint",
    description=
        "Obtain any ending with any character on Hard difficulty and achieve an S Rank." +
        " This can be achieved by rescuing everyone," +
        " never fainting," +
        " escaping before the building burns down, " +
        " destroying 300 or more obstacles," +
        " and extinguishing 1000 or more fires.",
    points=25,
    trigger=any_of(Regions, region => (
        // Correct region
        IsRegion(region) &&
        // Correct difficulty
        Difficulty[region] == HARD &&
        // Correct rank &&
        GameResultScreenRank[region] == 0 &&
        // Game Score Tally done
        EndingScoreDoneTrigger(region)
    ))
)

// Now do it a bunch of times for TOTAL POINTS rewards...

TotalPointsTitles = {
    // Hard Mode
    1: "I've Trained For This",
    // Character Color Type A
    2: "Hot Pants",
    // Character Color Type B
    3: "Cool Outfit",
    // Ultimate Weapon "Masamune" appears in game
    4: "Extinguish With Masamune!",//"Masamune De Extinguish!", // gotta ask devcomp about this one
    // Fire-extinguisher gun with unlimited ammo will now appear in game (Impulse has unlimited ammo?)
    5: "Never Stop Extinguishing",
}
TotalPointsDescription = "Obtain {0} Total Points in the Game Score screen to unlock {1}."
TotalPointsFormatArgs = {
    1: ["500", "the Hard difficulty"],
    2: ["1000", "Character Color Type A"],
    3: ["1500", "Character Color Type B"],
    4: ["2000", "the appearance of the ultimate weapon \"Masamune\" in game"],
    5: ["2500", "the appearance of a fire-extinguisher gun with unlimited ammo in game"],
}
TotalPointsPoints = {
    1: 10,
    2: 10,
    3: 25,
    4: 25,
    5: 25,
}
TotalPointsIDs = {
    1: 417895,
    2: 417915,
    3: 417896, 
    4: 417892,
    5: 417897,
}

for i in TotalPointsTitles
{
    achievement(
        id=TotalPointsIDs[i],
        title=TotalPointsTitles[i],
        description=format(
            TotalPointsDescription,
            TotalPointsFormatArgs[i][0],
            TotalPointsFormatArgs[i][1]
        ),
        points=TotalPointsPoints[i],
        trigger=any_of(Regions, region => (
            // Correct Region
            IsRegion(region) &&
            // Make sure we're in the right state for save protection
            GameResultScreenState[region] == 7 &&
            // Hit them point goals
            prev(NumTimesPointsGoalMet[region]) == i - 1 &&
            NumTimesPointsGoalMet[region] == i
        ))
    )
}

// And lastly, the player count bait...
achievement(
    id=417913,
    title="I'm From the Government and I'm Here to Help",
    description="Rescue your first survivor.",
    points=2,
    trigger=any_of(Regions, region => (
        // Correct region
        IsRegion(region) &&
        // Should probably make sure we're in game for save protection
        IsInGame(region) &&
        // Rescue that victim
        any_of(range(VICTIM_A, YUU), i => (
            prev(GetVictimStatus(region, i)) != RESCUED &&
            GetVictimStatus(region, i) == RESCUED
        ))
    ))
)

// ACHIEVEMENTS END


