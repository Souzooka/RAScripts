// Fire Heroes | Hard Luck
// #ID = 27514

NULL = 0
True = 1
False = 0

RegionByte = byte(0x100000) // TODO
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

function IsInGame(region)
{
    // Checks a pointer which is consistently NULL while not in-game/while in loading screens
    base = dword(0x00430EB0)
    
    return !IsNULL(base) &&
           !IsNULL(ResolvePointer(base, [0xC, 0x2C, 0x40]))
}

function AreaID(region)
{
    // Returns the index for the current area
    base = dword(0x00430EB0)

    return ResolvePointer(base, [0xC, 0x2C, 0x40, 0x10, 0x0], word)
}

function EpisodeID(region)
{
    // Returns the index for the current episode
    return word(0x1F9D856)
}

function IsPrologue(region)
{
    // Returns if we're in the prologue episode
    return EpisodeID(region) == 0
}

function IsFinalEpisode(region)
{
    // Returns if this is one of the finale episodes (and as such does not have the building burn-down timer)
    return any_of([8, 9], episode => EpisodeID(region) == episode)
}

function IsNormalEpisode(region)
{
    // Returns if this is an episode with the building burn-down timer
    return !IsPrologue(region) && !IsFinalEpisode(region)
}

function InGameCountdownMinutes(region)
{
    // Returns how many minutes until the building burns down
    base = dword(0x00430EB0)
    
    return ResolvePointer(base, [0xC, 0x108, 0xC4], float) / 60
}

function HalfHoursToMidnight(region)
{
    // Returns how many half-hours until the building burns down, for RP purposes
    return InGameCountdownMinutes(region) / 30
}

function CampaignID(region)
{
    // Returns campaign character ID
    return byte(0x1F9D840)
}

function CharacterID(region)
{
    base = dword(0x00430EB0)
    
    return ResolvePointer(base, [0xC, 0x38, 0x380])
}

DOUGLAS = 0
MAX = 1
SCOTT = 2

function Difficulty(region)
{
    // Float that we compare like an integer -- this is the only known affected var by difficulty that I know of at this time.
    return dword(0x1F9D834)
}

EASY = 0x3F000000 // 0.5f
NORMAL = 0x3F800000 // 1.0f
HARD = 0x40000000 // 2.0f

function EnergyLevel(region, character=-1)
{
    // Returns a character's Energy level (refer to status screen)
    // Value returned is 0-based (so 2 stars would return a value of 1, for example)
    if (character == -1)
    {
        character = CharacterID(region)
    }
    
    return byte(0x01f9d88c + character)
}

function AttackLevel(region, character=-1)
{
    // Returns a character's Attack level (refer to status screen)
    // Value returned is 0-based (so 2 stars would return a value of 1, for example)
    if (character == -1)
    {
        character = CharacterID(region)
    }
    
    return byte(0x01f9d898 + character)
}

function SpeedLevel(region, character=-1)
{
    // Returns a character's Speed level (refer to status screen)
    // Value returned is 0-based (so 2 stars would return a value of 1, for example)
    if (character == -1)
    {
        character = CharacterID(region)
    }
    
    return byte(0x01f9d8a4 + character)
}

function CurrentHP(region)
{
    base = dword(0x432B74)
    
    return ResolvePointer(base, [0xC8], float)
}

// RICH PRESENCE START

TitleLookup = {
    EU: "Fire Heroes",
    JP: "Hard Luck",
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
    0x0: "UNKNOWN AREA 0x0",
    0x1: "B2 Boiler Room",
    0x2: "B2 Hallway",
    0x3: "B1 Parking",
    0x4: "1F - 2F Entrance",
    0x5: "1F Goods Room A",
    0x6: "1F Goods Room B",
    0x7: "B1 - 1F Hallway",
    0x8: "UNKNOWN AREA 0x8",
    0x9: "3F - 4F Emergency Stairs",
    0xA: "3F Shop Under Construction B",
    0xB: "3F Shop Under Construction A",
    0xC: "3F Shop Hallway",
    0xD: "UNKNOWN AREA 0xD",
    0xE: "UNKNOWN AREA 0xE",
    0xF: "UNKNOWN AREA 0xF",
    0x10: "UNKNOWN AREA 0x10",
    0x11: "4F Shop Hallway",
    0x12: "UNKNOWN AREA 0x12",
    0x13: "5F Boutique",
    0x14: "5F - 6F Emergency Stairs",
    0x15: "5F Shop Hallway",
    0x16: "5F Sports Shop",
    0x17: "UNKNOWN AREA 0x17",
    0x18: "UNKNOWN AREA 0x18",
    0x19: "6F Monorail Platform",
    0x1A: "6F Station Lobby",
    0x1B: "7F - 8F Emergency Stairs",
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
    0x2C: "UNKNOWN AREA 0x2C",
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
    0x47: "UNKNOWN AREA 0x47",
    0x48: "17F Examining Room A",
    0x49: "17F Examining Room B",
    0x4A: "17F Operating Room",
    0x4B: "17F Large Examining Room",
    0x4C: "17F Hospital Hallway",
    0x4D: "18F Freight Elevator Hallway",
    0x4E: "UNKNOWN AREA 0x4E",
    0x4F: "18F - 19F Emergency Stairs",
    0x50: "18F Italian Restaurant 1F",
    0x51: "18F Restaurant Hallway",
    0x52: "19F Base",
    0x53: "19F Freight Elevator Hallway",
    0x54: "UNKNOWN AREA 0x54",
    0x55: "19F Italian Restaurant 2F",
    0x56: "19F Restaurant Hallway",
    0x57: "20F Emergency Stairs",
    0x58: "20F Guestroom Hallway",
    0x59: "20F Laundry Room",
    0x5A: "20F Security Room",
    0x5B: "20F Storage Room",
    0x5C: "UNKNOWN AREA 0x5C",
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
    0x69: "UNKNOWN AREA 0x69",
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
    0x89: "UNKNOWN AREA 0x89",
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
    0x9A: "UNKNOWN AREA 0x9A",
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
        rich_presence_lookup("CHARACTER", CharacterID(region), CharacterLookup),
        rich_presence_lookup("AREA", AreaID(region), AreaLookup),
        rich_presence_lookup("PROLOGUE", CampaignID(region), PrologueLookup),
        rich_presence_lookup("DIFFICULTY", Difficulty(region), DifficultyLookup),
        rich_presence_value("CURRENT_HP", CurrentHP(region)),
        rich_presence_value("MAX_HP", 100 + (EnergyLevel(region) * 25))
    )
    rich_presence_conditional_display(
        IsRegion(region) && IsInGame(region) && IsNormalEpisode(region),
        "{0} | {1} is in {2} | {3} | {4} difficulty | {5}/{6} HP | {7} {8} until the building burns down!",
        rich_presence_lookup("TITLE", region, TitleLookup),
        rich_presence_lookup("CHARACTER", CharacterID(region), CharacterLookup),
        rich_presence_lookup("AREA", AreaID(region), AreaLookup),
        rich_presence_lookup("EPISODE", EpisodeID(region), EpisodeLookup),
        rich_presence_lookup("DIFFICULTY", Difficulty(region), DifficultyLookup),
        rich_presence_value("CURRENT_HP", CurrentHP(region)),
        rich_presence_value("MAX_HP", 100 + (EnergyLevel(region) * 25)),
        rich_presence_lookup("HALFHOURS", HalfHoursToMidnight(region), HalfHoursLookup),
        rich_presence_value("COUNTDOWN", InGameCountdownMinutes(region), format="MINUTES")
    )
    rich_presence_conditional_display(
        IsRegion(region) && IsInGame(region) && IsFinalEpisode(region),
        "{0} | {1} is in {2} | {3} | {4} difficulty | {5}/{6} HP | 🕛 The building is coming down at any moment!",
        rich_presence_lookup("TITLE", region, TitleLookup),
        rich_presence_lookup("CHARACTER", CharacterID(region), CharacterLookup),
        rich_presence_lookup("AREA", AreaID(region), AreaLookup),
        rich_presence_lookup("EPISODE", EpisodeID(region), EpisodeLookup),
        rich_presence_lookup("DIFFICULTY", Difficulty(region), DifficultyLookup),
        rich_presence_value("CURRENT_HP", CurrentHP(region)),
        rich_presence_value("MAX_HP", 100 + (EnergyLevel(region) * 25))
    )
    rich_presence_display(
        "{0} | In a menu or loading screen",
        rich_presence_lookup("TITLE", RegionByte, TitleLookup)
    )
}

// RICH PRESENCE END
