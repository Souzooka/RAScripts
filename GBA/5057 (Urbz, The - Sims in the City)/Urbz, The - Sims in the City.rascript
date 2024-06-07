// Urbz, The: Sims in the City
// #ID = 5057

// Hi, if you're looking at this script years down the line to fix missing text in the Rich Presence, simply change this variable to "true".
// Due to limitations in mathemetics in rcheevos, abusing the integer boundry was the only way I found that I could effectively "bitwise and"
// the result of an add source chain -- but this will likely break, of course, if rcheevos ever supports 64-bit integers.
USE_64_BIT = false

// MISC. SCRIPT HELPERS

mirror = v => v

NULL = 0
True = 1
False = 0

function if_else(cond, v1, v2)
{
    if cond == true
    {
        return v1
    }
    return v2
}

addr = (v) => v // Dummy accessor for ptr for if the pointed-to address is desired
BLOCK_WRAM = 0 // 0x2XXXXXX
BLOCK_IWRAM = 1 // 0x3XXXXXX
_tW = addr => (addr & 0xFFFFFF) + 0x8000
_tI = addr => addr & 0xFFFFFF
function ptr(base, offsets, accessor=dword, block=BLOCK_WRAM)
{
    // correct the pointer to ra's shitty custom memory map that makes no sense
    transform = if_else(block == BLOCK_WRAM, _tW, _tI)

    val = transform(base)
    
    for i in range(0, length(offsets) - 1)
    {
        addr = val + offsets[i]
        if (i == length(offsets) - 1)
        {
            val = accessor(addr)
        }
        else
        {
            val = transform(dword(addr))
        }
    }
    
    return val
}

// CLASSES

function Relationship(npc)
{
    // This structure records the relationship the player has with all non-player Urbz.
    SIZE_OF = 0x4

    // Buffer of Relationship (size 0x4) for each NPC
    addr = 0x37F4
    addr = addr + (npc * SIZE_OF)
    
    obj = {
        "status": byte(0x0 + addr), // Unsigned bitset;
                                    // 0x1 = ?
                                    // 0x2 = ?
                                    // 0x4 = Friends
                                    // 0x8 = Love
        "level": byte(0x1 + addr),  // Signed [-100, 100] relationship value
    }
    return obj
}

NUM_CHAPTERS = 7 // Only get 6 on GBA :(
NUM_MISSIONS = 6 // up to 6 missions per chapter
NUM_OBJECTIVES = 6 // up to 5 objectives per mission (first serves to indicate mission is unlocked/complete)
TOTAL_NUM_OBJECTIVES = NUM_CHAPTERS * NUM_MISSIONS * NUM_OBJECTIVES
function Objective(objective)
{
    SIZE_OF = 0x4

    addr = 0x4210 // Start of mission completion data
    addr = addr + (objective * SIZE_OF)
    
    obj = {
        "unlocked": byte(0x0 + addr), // Boolean which means the objective can be seen in the pause menu
        "complete": byte(0x1 + addr), // Boolean which means the objective was completed
    }
    return obj
}

function GoalsData()
{
    addr = 0x420C
    obj = {
        "current_chapter": dword(0x0 + addr),
        "objectives": [],
    }
    
    TOTAL_NUM_OBJECTIVES = NUM_CHAPTERS * NUM_MISSIONS * NUM_OBJECTIVES
    
    for objective in range(0, TOTAL_NUM_OBJECTIVES - 1)
    {
        array_push(obj["objectives"], Objective(objective))
    }
    return obj
}

Goals = GoalsData()

// ENUMERATIONS

// Game Modes
MODE_INGAME = 1
MODE_COPYRIGHT = 3
MODE_BOOTSPLASH = 4
MODE_TITLE = 5
MODE_SAVELOAD = 6
MODE_SOCIAL = 13
MODE_MINIGAME = 17
MODE_JOBSMENU = 21
MODE_INTRO_CUTSCENE = 23
MODE_CHARACTER_CREATE_NAME_ENTRY = 25
MODE_CHARACTER_CREATE_UNKNOWN = 26
MODE_CHARACTER_CREATE_CLOTHING = 27
NODE_CHARACTER_CREATE_CONFIRM = 28
MODE_CHARACTER_CREATE_QUIZ = 29

// NPCs
NPC_BAYOO_BOO = 0
NPC_BERKELEY_CLODD = 1
NPC_CANNONBALL_COLEMAN = 2
NPC_CRAWDAD_CLEM = 3
NPC_CRYSTAL = 4
NPC_DADDY_BIGBUCKS = 5
NPC_DARIUS = 6
NPC_DET_DAN_D_MAN = 7
NPC_DUSTY_HOGG = 8
NPC_EPHRAM_EARL = 9
NPC_EWAN_WATAHMEE = 10
NPC_GIUSEPPI_MEZZOLATO = 11
NPC_GRAMMA_HATTIE = 12
NPC_HARLAN_KING = 13
NPC_KRIS_THISTLE = 14
NPC_LILY_GATES = 15
NPC_LINCOLN_BROADSHEET = 16
NPC_LOTTIE_CASH = 17
NPC_LUTHOR_L_BIGBUCKS = 18
NPC_MAMBO_LOA = 19
NPC_MAXIMILLIAN_MOORE = 20
NPC_MISTY_WATERS = 21
NPC_OLDE_SALTY = 22
NPC_PHEOBE_TWIDDLE = 23
NPC_POLLY_NOMINAL = 24
NPC_PRITCHARD_LOCKSLEY = 25
NPC_ROXANNA_MOXIE = 26
NPC_SUE_PIRNOVA = 27
NPC_THERESA_BULLHORN = 28

// Relationship Status (bitmask)
RELATIONSHIP_FRIEND = 0x4
RELATIONSHIP_LOVE = 0x8

// Items
ITEM_GOLDEN_FIDDLE = 81
ITEM_CHICKEN = 196
ITEM_ROSEBUD = 362
ITEM_NONE = 366
// Housewarming Gifts
ITEM_GOLDEN_MOP_AWARD = 51
ITEM_VOODOO_DAN_DOLL = 52
ITEM_FLAMING_HOOP = 53
ITEM_KEY_TO_THE_CITY = 54
ITEM_LAWN_FLAMINGO = 55
ITEM_MAGIC_LAMP = 56
ITEM_COMEDY_AND_TRAGEDY_MASKS = 57
ITEM_ORANGE_PEDESTAL = 58
ITEM_PERIODIC_TABLE_OF_ELEMENTS = 59
ITEM_SAFE = 60
ITEM_BURNING_SPOKE_SIGN = 61
ITEM_VELOCIROOSTER_SKELETON = 62
ITEM_SOAP_BOX = 63
ITEM_MUSIC_STAND = 64
ITEM_MOVIESTANDEE = 65
ITEM_ANGEL_STATUE = 66
ITEM_BLIND_JUSTICE_STATUE = 67
ITEM_LOTTIE_CASH_STATUE = 68
ITEM_PYTHON_STATUE = 69
ITEM_3_CARD_MONTE_TABLE = 70
ITEM_THRONE = 71
ITEM_TRAFFIC_LIGHT = 72
ITEM_MISS_URBVERSE_TROPHY = 73
ITEM_TYPEWRITER = 74
ITEM_WALL_MOUNTED_ALLIGATOR = 75
ITEM_WALL_MOUNTED_SWORDFISH = 76
ITEM_98_ADDER_BUMPER = 77
ITEM_UNCLE_SUEDE_SHIZZLES_CANE = 78
ITEM_KHRONITON_REACTOR = 80

// Skills
SKILL_COOKING = 0
SKILL_MECHANICAL = 1
SKILL_CREATIVITY = 2
SKILL_BODY = 3
SKILL_LOGIC = 4
SKILL_CHARISMA = 5

// Houses
HOUSE_PENTHOUSE_UNFINISHED = 0
HOUSE_SMALL_BROWNSTONE = 1
HOUSE_LARGE_BROWNSTONE = 2
HOUSE_TOWNHOUSE = 3
HOUSE_FIRST_MATE_QUARTERS = 4
HOUSE_CITY_APARTMENT = 5
HOUSE_PENTHOUSE = 6

// Rep Groups
// Note that for Rep Goals, Richies and Artsies' orders are reversed because this game is bad
REP_GROUP_STREETIES = 0
REP_GROUP_NERDIES = 1
REP_GROUP_RICHIES = 2
REP_GROUP_ARTSIES = 3

// Minigames
MINIGAME_MOOGOO = 0
MINIGAME_COMIC = 1
MINIGAME_DOCTOR = 2
MINIGAME_SQUEEGEE = 3
MINIGAME_HOOPZ = 4
MINIGAME_SOUL = 5
MINIGAME_YAR = 6
MINIGAME_MOTOCROSS = 7
// non-jobs
MINIGAME_STUDY_COOKING = 0x8
MINIGAME_STUDY_CREATIVITY = 0x9
MINIGAME_STUDY_LOGIC = 0xA
MINIGAME_STUDY_MECHANICAL = 0xB
MINIGAME_SPELLING_BEE = 0xC
MINIGAME_DARTS = 0xD
MINIGAME_CUPS = 0xE
MINIGAME_DERBY = 0xF
MINIGAME_SLOTS = 0x10

// Minigame Mode
MGMODE_GAME = 5
MGMODE_GAMEOVER = 6
MGMODE_ENTER_RESULT = 7

// Areas
AREA_CIVIL_WAR_TIME_MACHINE = 5
AREA_HAYSEEDS_FARM_TIME_MACHINE = 6
AREA_PAPER_BOY_TIME_MACHINE = 8
AREA_PLANET_OF_THE_APES_TIME_MACHINE = 10
AREA_TAR_PIT_TIME_MACHINE = 14
AREA_CLUB_XIZZLE = 70

time_travel_areas = [
    AREA_CIVIL_WAR_TIME_MACHINE,
    AREA_HAYSEEDS_FARM_TIME_MACHINE,
    AREA_PAPER_BOY_TIME_MACHINE,
    AREA_PLANET_OF_THE_APES_TIME_MACHINE,
    AREA_TAR_PIT_TIME_MACHINE,
]

// GAME VARIABLES

MAX_MINIGAME_DIFFICULTY = 4
MAX_UTILITY_LEVEL = 2
NUM_UTILITIES = 4
NUM_MUSEUM_EXHIBITS = 5

// The current game mode (See Game Modes enumeration)
GameMode = dword(0x4910)
// Used for storing the last game mode in some states or during transitions
LastGameMode = dword(0x4914)
// Sticky value for the last game mode
LastGameModeSticky = dword(0x4930)
// Index of the player's owned house (See the Houses enumeration)
HouseID = byte(0x38AC)
// Base to dynamic minigame information
MinigameBase = dword(0x49C0)
// Minigame Score
MinigameScore = ptr(MinigameBase, [0x4], word)
// Minigame ID (See Minigame enumeration)
MinigameID = ptr(MinigameBase, [0xD], byte)
// Minigame Difficulty
MinigameDifficulty = ptr(MinigameBase, [0xE], byte)
// Minigame Mode (See MGMODE enum)
MinigameMode = ptr(MinigameBase, [0xF], byte)
// Current player zone (See Areas enumeration)
AreaID = dword(0x48F8)
// Total amount of piles of trash picked up
TrashPiles = byte(0x4610)
// 8-bit array of utilities owned per house
Utilities = 0x462C
// Amount of Xizzle Beads the player has currently picked up available to spend
XizzleBeads = dword(0x38B8)
// Array of 6 bytes for intro questionnaire answers
QuizAnswers = 0x2F84
// Some Moogoo Monkey vars
MoogooMonkeyCoconuts = ptr(MinigameBase, [0x13A], byte)
MoogooMonkeyPlayers = ptr(MinigameBase, [0x1C7], byte)

// Motocross Mayhem
MotocrossMayhemCentiseconds = (
    // Frames
    ptr(MinigameBase, [0xA5], byte) * (100 / 30.0) +
    // Seconds
    ptr(MinigameBase, [0xA4], byte) * 100 +
    // Minutes
    ptr(MinigameBase, [0xA3], byte) * 100 * 60
)

// Motocross bike
BikeChassis = byte(0x4648)
BikeSuspension = byte(0x4649)
BikeEngine = byte(0x464A)
BikeNitro = byte(0x464B)
BikeTires = byte(0x464C)
BikeAccessory = byte(0x464D)

// Game Time
Days = word(0x37C8)
Hours = byte(0x37CA)
Minutes = byte(0x37CB)

// NPC being talked to
ConversationNPC = dword(0x2290)

// Player characteristics
PlayerName = 0x37D0
PlayerGender = byte(0x37E0)

// Item IDs in player inventory
Inventory = []
for i in range(0, 8 - 1)
{
    array_push(Inventory, word(0x4158 + (i * 0x8)))
}

// GAME FUNCTIONS

function SaveProtection(is_minigame=false)
{
           // When loading the save file, the last game mode is set to the title
    return (LastGameMode != MODE_TITLE &&
           // Loading can also happen 1 frame after because why not
           prev(LastGameMode) != MODE_TITLE) ||
           // Main menu minigames have the last game mode as the title, but I don't think we'll ever have to check for this
           if_else(is_minigame, IsMinigame(), always_false())
}

function IsMinigame()
{
    return GameMode == MODE_MINIGAME && MinigameBase != NULL
}

function IsMinigameOver()
{
    return MinigameMode == MGMODE_GAMEOVER &&
           prev(MinigameMode) != MGMODE_GAMEOVER
}

function IsMinigamePlay(pred=mirror)
{
    return (pred(MinigameMode) == MGMODE_GAME ||
           pred(MinigameMode) == MGMODE_GAMEOVER)
}

function IsJob()
{
    return IsMinigame() && MinigameID <= MINIGAME_MOTOCROSS
}

function IsInInventory(item_id, pred=mirror)
{
    return any_of(Inventory, item => pred(item) == item_id)
}

function IsHousewarmingGift(item)
{
    return item >= ITEM_GOLDEN_MOP_AWARD &&
           item <= ITEM_KHRONITON_REACTOR
           // item != 79 // this one is not a housewarming gift? Probably not necessary to check if we check for social mode too anyways
}

function GetRelationshipLevel(npc)
{
    relationship = Relationship(npc)
    return relationship["level"]
}

function GetRelationshipStatus(npc)
{
    relationship = Relationship(npc)
    return relationship["status"]
}

function GetSkillLevel(skill)
{
    // Skills are represented as 32-bit fixed-point numbers.
    // They consist of a 24-bit decimal portion, and an 8-bit integer portion.
    // Therefore, we can just read the most significant byte to determine the skill level.
    
    // Array of the 6 skill fixed-point numbers
    Skills = 0x3868
    return byte(Skills + (skill * 4) + 3)
}

function GetReputation(rep_group)
{
    // Array of reputation levels for the 4 rep groups
    Reps = 0x38BC
    return byte(Reps + rep_group)
}

function GetObjective(chapter, mission, objective)
{
    idx = chapter * NUM_MISSIONS * NUM_OBJECTIVES
    idx = idx + mission * NUM_OBJECTIVES
    idx = idx + objective
    
    return Goals["objectives"][idx]
}

function GetCurrentChapter()
{
    return Goals["current_chapter"]
}

function IsObjectiveComplete(chapter, mission, objective)
{
    // Add +1 to objective because the first objective in a mission is used to store
    // whether the mission as a whole is complete/unlocked
    objective = GetObjective(chapter, mission, objective + 1)
    return objective["complete"]
}

function IsMissionComplete(chapter, mission)
{
    objective = GetObjective(chapter, mission, 0)
    return objective["complete"]
}

function IsChapterComplete(chapter, pred=mirror)
{
    cond = always_true()
    
    for mission in range(0, NUM_MISSIONS - 1)
    {
        cond = cond && (pred(IsMissionComplete(chapter, mission)) == 1)
    }
    
    return cond
}

function GetUtility(house, utility)
{
    return byte(Utilities + (house * NUM_UTILITIES) + utility)
}

function CheckExhibitPurchase(idx)
{
    // There are 5 bits here from 2..6 which track museum exhibit purchases
    bitset = 0x468E
    return bit(idx + 2, bitset)
}

function CheckAllExhibitsPurchased(pred=mirror)
{
    bitset = byte(0x468E)
    mask = 0x7C // bits 2..6
    return pred(bitset) & mask == mask
}

function GetJobLevel(minigame)
{
    // Array of 8-bit job levels
    return byte(0x4669 + minigame)
}

// ACHIEVEMENTS START

// NPC relationships

RelationshipAchievements = {
    NPC_BAYOO_BOO: {
        "id": 57477,
        "title": "Are You Sure You're Not a Vampire?",
        "name": "Bayou Boo",
    },
    NPC_BERKELEY_CLODD: {
        "id": 57478,
        "title": "Fraudulent Friends",
        "name": "Berkeley Clodd",
    },
    NPC_CANNONBALL_COLEMAN: {
        "id": 57479,
        "title": "Cannonball the Compadre",
        "name": "Cannonball Coleman",
    },
    NPC_CRAWDAD_CLEM: {
        "id": 57480,
        "title": "Ya'll Are Pretty Cool",
        "name": "Crawdad Clem",
    },
    NPC_CRYSTAL: {
        "id": 57481,
        "title": "Crystal Clear",
        "name": "Crystal",
    },
    NPC_DADDY_BIGBUCKS: {
        "id": 57482,
        "title": "Kissing up to Daddy",
        "name": "Daddy Bigbucks",
    },
    NPC_DARIUS: {
        "id": 57483,
        "title": "Hangin’ With the Homie",
        "name": "Darius",
    },
    NPC_DET_DAN_D_MAN: {
        "id": 57484,
        "title": "He Truly Is Da Mann",
        "name": "Det. Dan D. Mann",
    },
    NPC_DUSTY_HOGG: {
        "id": 57485,
        "title": "Hoggs 4 Lyfe",
        "name": "Dusty Hogg",
    },
    NPC_EPHRAM_EARL: {
        "id": 57486,
        "title": "The Ghost of Centuries Past",
        "name": "Ephram Earl",
    },
    NPC_EWAN_WATAHMEE: {
        "id": 57487,
        "title": "The Builder Bro",
        "name": "Ewan Watahmee",
    },
    NPC_GIUSEPPI_MEZZOLATO: {
        "id": 57488,
        "title": "A Crooked Companion",
        "name": "Giuseppi Mezzoalto",
    },
    NPC_GRAMMA_HATTIE: {
        "id": 57489,
        "title": "Gramma Knows Best",
        "name": "Gramma Hattie",
    },
    NPC_HARLAN_KING: {
        "id": 57490,
        "title": "The Real King of Miniopolis",
        "name": "Harlan King",
    },
    NPC_KRIS_THISTLE: {
        "id": 57491,
        "title": "Sweeter Than A Thistle",
        "name": "Kris Thistle",
    },
    NPC_LILY_GATES: {
        "id": 57492,
        "title": "Daddy’s Little Sidekick No More",
        "name": "Lily Gates",
    },
    NPC_LINCOLN_BROADSHEET: {
        "id": 57493,
        "title": "The Newspaper Nerd",
        "name": "Lincoln Broadsheet",
    },
    NPC_LOTTIE_CASH: {
        "id": 57494,
        "title": "Lots O' Cash",
        "name": "Lottie Cash",
    },
    NPC_LUTHOR_L_BIGBUCKS: {
        "id": 57495,
        "title": "The Other Side of the Coin",
        "name": "Luthor L. Bigbucks",
    },
    NPC_MAMBO_LOA: {
        "id": 57496,
        "title": "Paranormal Pals",
        "name": "Mambo Loa",
    },
    NPC_MAXIMILLIAN_MOORE: {
        "id": 57497,
        "title": "The Medical Master",
        "name": "Maximillian Moore",
    },
    NPC_MISTY_WATERS: {
        "id": 57498,
        "title": "Fit to Be Friends",
        "name": "Misty Waters",
    },
    NPC_OLDE_SALTY: {
        "id": 57499,
        "title": "Ye Olde Pal",
        "name": "Olde Salty",
    },
    NPC_PHEOBE_TWIDDLE: {
        "id": 57500,
        "title": "Friends With Shopping Discount Benefits",
        "name": "Phoebe Twiddle",
    },
    NPC_POLLY_NOMINAL: {
        "id": 57501,
        "title": "A Friendship in the Realm of Real Numbers",
        "name": "Polly Nomial",
    },
    NPC_PRITCHARD_LOCKSLEY: {
        "id": 57502,
        "title": "Prince Pritchard",
        "name": "Pritchard Locksley",
    },
    NPC_ROXANNA_MOXIE: {
        "id": 57503,
        "title": "Queen of the Carnival",
        "name": "Roxanna Moxie",
    },
    NPC_SUE_PIRNOVA: {
        "id": 57504,
        "title": "Superfriends",
        "name": "Sue Pirnova",
    },
    NPC_THERESA_BULLHORN: {
        "id": 57505,
        "title": "An Ally of Acting",
        "name": "Theresa Bullhorn",
    },
}

for npc in RelationshipAchievements
{
    params = RelationshipAchievements[npc]
    achievement(
        id=params["id"],
        title=params["title"],
        description=format("Max out your relationship with {0}.", params["name"]),
        points=5,
        trigger=(
            SaveProtection() &&
            // We're now max level
            GetRelationshipLevel(npc) == 100 &&
            // And we weren't last frame
            prev(GetRelationshipLevel(npc)) != 100
        )
    )
}

// Skills

SkillAchievements = {
    SKILL_COOKING: {
        "id": 57506,
        "title": "Straight Out of Hell’s Kitchen",
        "name": "Cooking",
    },
    SKILL_MECHANICAL: {
        "id": 57507,
        "title": "Tinkering to the Top",
        "name": "Mechanical",
    },
    SKILL_CREATIVITY: {
        "id": 57508,
        "title": "The Overlord of Originality",
        "name": "Creativity",
    },
    SKILL_BODY: {
        "id": 57509,
        "title": "Never Skipped Leg Day",
        "name": "Body",
    },
    SKILL_LOGIC: {
        "id": 57510,
        "title": "The Genius",
        "name": "Logic",
    },
    SKILL_CHARISMA: {
        "id": 57511,
        "title": "Maximum Charm",
        "name": "Charisma",
    },
}

for skill in SkillAchievements
{
    params = SkillAchievements[skill]
    achievement(
        id=params["id"],
        title=params["title"],
        description=format("Max out your {0} skill.", params["name"]),
        points=5,
        trigger=(
            SaveProtection() &&
            // We're currently at the max skill level!
            GetSkillLevel(skill) == 10 &&
            // And we weren't on the last frame!
            prev(GetSkillLevel(skill)) != 10
        )
    )
}

// Houses

HouseAchievements = {
    HOUSE_SMALL_BROWNSTONE: {
        "id": 57512,
        "title": "My First Home",
        "name": "Small Brownstone home",
        "points": 1,
    },
    HOUSE_LARGE_BROWNSTONE: {
        "id": 57513,
        "title": "My First Home Part 2 - Electric Boogaloo",
        "name": "Large Brownstone home",
        "points": 1,
    },
    HOUSE_TOWNHOUSE: {
        "id": 57514,
        "title": "Moving On Up",
        "name": "Townhouse",
        "points": 2,
    },
    HOUSE_FIRST_MATE_QUARTERS: {
        "id": 57515,
        "title": "Yarr, This Be A Fine Change O' Pace",
        "name": "First Mate's Quarters",
        "points": 2,
    },
    HOUSE_CITY_APARTMENT: {
        "id": 57516,
        "title": "Really Livin' the Urb Life",
        "name": "City Apartment",
        "points": 3,
    },
    HOUSE_PENTHOUSE: {
        "id": 57517,
        "title": "Atop The Lap of Luxury",
        "name": "Penthouse",
        "points": 3,
    },
}

for house in HouseAchievements
{
    params = HouseAchievements[house]
    achievement(
        id=params["id"],
        title=params["title"],
        description=format("Purchase the {0}.", params["name"]),
        points=params["points"],
        trigger=(
            SaveProtection() &&
            // Is it really this easy to own a house?
            HouseID == house &&
            // I guess we'll find out since this is the first frame of ownership
            prev(HouseID) != house
        )
    )
}

// Reputation

ReputationAchievements = {
    REP_GROUP_STREETIES: {
        "id": 57518,
        "title": "The True Homie",
        "name": "Streeties",
    },
    REP_GROUP_NERDIES: {
        "id": 57519,
        "title": "Geeking Out",
        "name": "Nerdies",
    },
    REP_GROUP_RICHIES: {
        "id": 57520,
        "title": "I Like Money, What Can I Say?",
        "name": "Richies",
    },
    REP_GROUP_ARTSIES: {
        "id": 57521,
        "title": "An Amazing Auteur",
        "name": "Artsies",
    },
}

for rep_group in ReputationAchievements
{
    params = ReputationAchievements[rep_group]
    achievement(
        id=params["id"],
        title=params["title"],
        description=format("Max out your rep with the {0}.", params["name"]),
        points=25,
        trigger=(
            SaveProtection() &&
            // Everywhere I go, I see adoring fans
            GetReputation(rep_group) == 10 &&
            // But it wasn't always like this...
            prev(GetReputation(rep_group)) != 10
        )
    )
}

// Rep Goals

RepGoalAchievements = {
    REP_GROUP_STREETIES:
    {
        "id": 57537,
        "title": "This Is My Turf Now",
        "name": "Streeties",
        "mission": 0
    },
    REP_GROUP_NERDIES:
    {
        "id": 57538,
        "title": "Hey Guys, I'm a #Nerd #LOL",
        "name": "Nerdies",
        "mission": 1
    },
    REP_GROUP_ARTSIES:
    {
        "id": 57539,
        "title": "Artsy Fartsy",
        "name": "Artsies",
        "mission": 2
    },
    REP_GROUP_RICHIES:
    {
        "id": 57540,
        "name": "Richies",
        "title": "Money Can't Buy You Happiness....Or Can It?",
        "mission": 3
    },
}

for rep_group in RepGoalAchievements
{
    params = RepGoalAchievements[rep_group]
    achievement(
        id=params["id"],
        title=params["title"],
        description=format("Complete all the {0}' rep goals.", params["name"]),
        points=10,
        trigger=(
            SaveProtection() &&
            // Goal's done guys
            IsMissionComplete(5, params["mission"]) == 1 &&
            // You're the first to know about it
            prev(IsMissionComplete(5, params["mission"])) == 0
        )
    )
}

// Progression (Chapters)

ChapterAchievements = [
    {
        "id": 57528,
        "title": "Chapter 1 Complete",
        "points": 10,
    },
    {
        "id": 57530,
        "title": "Chapter 2 Complete",
    },
    {
        "id": 57532,
        "title": "Chapter 3 Complete",
    },
    {
        "id": 57534,
        "title": "Chapter 4 Complete",
    },
    {
        "id": 57536,
        "title": "Chapter 5 Complete",
    },
]

for chapter in range(0, length(ChapterAchievements) - 1)
{
    params = ChapterAchievements[chapter]
    achievement(
        id=params["id"],
        title=params["title"],
        description=format("Complete every goal in Chapter {0}.", chapter + 1),
        points=if_else(chapter == 4, 25, 10),
        type=if_else(chapter == 4, "win_condition", "progression"),
        trigger=(
            SaveProtection() &&
            // A new chapter in my Urbin Life has begun
            IsChapterComplete(chapter) &&
            // and a previous one has just concluded
            !IsChapterComplete(chapter, prev)
        )
    )
}

// Progression (Misc. Goals)

GoalAchievements = [
    {
        "id": 57527,
        "title": "You Gotta Start Somewhere",
        "description": "Complete your very first goal! Congratulations, you did it!",
        "points": 1,
        "chapter": 0,
        "mission": 0,
    },
    {
        "id": 57529,
        "title": "At Least I Got A Cool Hoverboard?",
        "description": "Complete the \"Salesmanship\" goal in Chapter 2.",
        "points": 1,
        "chapter": 1,
        "mission": 3,
    },
    {
        "id": 57531,
        "title": "No Normies Allowed!",
        "description": "Complete the \"None Shall Pass\" goal in Chapter 3.",
        "points": 1,
        "chapter": 2,
        "mission": 2,
    },
    {
        "id": 57533,
        "title": "I Need... to Run!",
        "description": "Complete the \"Running from the Law\" goal in Chapter 4.",
        "points": 2,
        "chapter": 3,
        "mission": 3,
    },
    {
        "id": 57535,
        "title": "The Thirst For Chocolate",
        "description": "Complete the \"Interview with a Cajun Vampire\" goal in Chapter 5.",
        "points": 2,
        "chapter": 4,
        "mission": 2,
    },
]

for params in GoalAchievements
{
    chapter = params["chapter"]
    mission = params["mission"]
    
    achievement(
        id=params["id"],
        title=params["title"],
        description=params["description"],
        points=params["points"],
        type="progression",
        trigger=(
            SaveProtection() &&
            // The goal's complete!
            IsMissionComplete(chapter, mission) == 1 &&
            // And my dopamine is at its peak!
            prev(IsMissionComplete(chapter, mission)) == 0
        )
    )
}

// Minigame scores (besides Moogoo, which has a custom condition)

MinigameAchievements = {
    MINIGAME_SQUEEGEE: {
        "id": 57542,
        "title": "What a Shitty Job",
        "name": "Squeegee Clean",
        "difficulty_name": "Clean N Sheen",
        "score": 1250,
    },
    MINIGAME_HOOPZ: {
        "id": 57543,
        "title": "Come on and Slam",
        "name": "Hoopz",
        "difficulty_name": "En Fuego",
        "score": 2000,
    },
    MINIGAME_DOCTOR: {
        "id": 57544,
        "title": "Surgical Precision",
        "name": "Doctor Max Stat!",
        "difficulty_name": "Brain Surgeon",
        "score": 1500,
    },
    MINIGAME_COMIC: {
        "id": 57545,
        "title": "Truly Hilarious",
        "name": "Comic Explosion",
        "difficulty_name": "Wild and Crazy Guy",
        "score": 1300,
    },
    MINIGAME_MOTOCROSS: {
        "id": 57546,
        "title": "Pedal to the Metal",
        "name": "Motocross Mayhem",
        "difficulty_name": "Master of Mayhem",
        "score": 500,
    },
    MINIGAME_YAR: {
        "id": 57548,
        "title": "Bumper Boat Boss",
        "name": "Yar Hey! Bombard!",
        "difficulty_name": "Boat Basher Supreme",
        "score": 1500,
    },
    MINIGAME_SOUL: {
        "id": 57549,
        "title": "Defeated the Devil",
        "name": "Soul Music",
        "difficulty_name": "Red Man Incarnate",
        "score": 3000,
    },
}

for minigame in MinigameAchievements
{
    params = MinigameAchievements[minigame]
    
    // Extra check for Soul Music
    extra = if_else(minigame == MINIGAME_SOUL, " Do not use the Golden Fiddle.", "")
    extra_check = if_else(
        minigame == MINIGAME_SOUL,
        !any_of(Inventory, item => item == ITEM_GOLDEN_FIDDLE),
        always_true()
    )
    
    achievement(
        id=params["id"],
        title=params["title"],
        description=format(
            "Get ${0} or more in the {1} minigame on {2} difficulty.{3}",
            params["score"],
            params["name"],
            params["difficulty_name"],
            extra
        ),
        points=10,
        trigger=(
            // Is in a minigame
            IsMinigame() &&
            // Correct minigame
            MinigameID == minigame &&
            // Correct difficulty
            MinigameDifficulty == MAX_MINIGAME_DIFFICULTY &&
            // Is playing the minigame (i.e. not in instructions or end screen)
            IsMinigamePlay() &&
            // Extra check
            extra_check &&
            // Trigger which tracks game score and the game ending
            trigger_when(
                MinigameScore >= params["score"] &&
                IsMinigameOver()
            )
        )
    )
}

// Moogoo Monkey

achievement(
    id=57547,
    title="Don't Touch My Coconuts!", 
    description="Reach 7 coconuts without losing one in the Moogoo Monkey minigame on Moogoo Monkey Master difficulty. Playing with multiple players is disallowed.",
    points=10,
    trigger=(
        // Is in a minigame
        IsMinigame() &&
        // Correct Minigame
        MinigameID == MINIGAME_MOOGOO &&
        // Correct Difficulty
        MinigameDifficulty == MAX_MINIGAME_DIFFICULTY && 
        // Correct number of players
        MoogooMonkeyPlayers == 0 && 
        // Start triggering when we've got at one coconut
        trigger_when(once(MoogooMonkeyCoconuts == 1)) &&
        // Wait for the player to reach 7 coconuts
        trigger_when(MoogooMonkeyCoconuts == 7) &&
        // But fail the challenge should they lose a coconut
        never(MoogooMonkeyCoconuts < prev(MoogooMonkeyCoconuts))
    )
)

// Spell Champ

achievement(
    id=424977,
    title="Best Bee",
    description="Successfully complete the Spelling Bee minigame.",
    points=2,
    trigger=(
        // Is in a minigame
        IsMinigame() &&
        // Correct minigame
        MinigameID == MINIGAME_SPELLING_BEE &&
        // Is playing the minigame (i.e. not in instructions or end screen)
        IsMinigamePlay() &&
        // Trigger which tracks game score and the game ending
        trigger_when(
            // Any score above 0 (probably 200) indicates success
            MinigameScore > 0 &&
            IsMinigameOver()
        )
    )
)

// Carnival Games

function CarnivalGamesTrigger()
{
    games = [MINIGAME_DARTS, MINIGAME_CUPS, MINIGAME_DERBY, MINIGAME_SLOTS]
    comparisons = []
    for game in games
    {
        array_push(comparisons,
            once(
                IsMinigame() &&
                IsMinigameOver() &&
                MinigameID == game &&
                MinigameScore > 10
            )
        )
    }
    
    return measured(tally(length(comparisons), comparisons))
}

achievement(
    id=424978,
    title="Carnival Connoisseur",
    description="Earn more than $10 from each carnival minigame within one attempt, in one session.",
    points=3,
    trigger=CarnivalGamesTrigger()
)

// Minigame promotion achievements

PromotionAchievements = {
    MINIGAME_MOOGOO: {
        "id": 424968,
        "title": "Moogoo Monkey Master",
        "name": "Moogoo Monkey",
    },
    MINIGAME_COMIC: {
        "id": 424969,
        "title": "Wild and Crazy Guy",
        "name": "Comic Explosion",
    },
    MINIGAME_DOCTOR: {
        "id": 424970,
        "title": "Brain Surgeon",
        "name": "Doctor Max Stat!",
    },
    MINIGAME_SQUEEGEE: {
        "id": 424971,
        "title": "Clean N Sheen",
        "name": "Squeegee Clean",
    },
    MINIGAME_HOOPZ: {
        "id": 424972,
        "title": "En Fuego",
        "name": "Hoopz",
    },
    MINIGAME_YAR: {
        "id": 424974,
        "title": "Boat Basher Supreme",
        "name": "Yar Hey! Bombard!",
    },
    MINIGAME_SOUL: {
        "id": 424973,
        "title": "Red Man Incarnate",
        "name": "Soul Music",
    },
    MINIGAME_MOTOCROSS: {
        "id": 424975,
        "title": "Master of Mayhem",
        "name": "Motocross Mayhem",
    }
}

for minigame in PromotionAchievements
{
    params = PromotionAchievements[minigame]
    achievement(
        id=params["id"],
        title=params["title"],
        description=format("Earn the highest promotion in the {0} minigame.", params["name"]),
        points=10,
        trigger=(
            IsMinigame() &&
            // We got the highest job level
            GetJobLevel(minigame) == MAX_MINIGAME_DIFFICULTY &&
            prev(GetJobLevel(minigame)) != MAX_MINIGAME_DIFFICULTY
        )
    )
}

// Misc. achievements

// Get Housewarming Gift
// unfortunately, very difficult to track. There appears to be a 16-bit index at 0x22B2 for special conversation reactions,
// but the values for liking the player's pad seem to vary by NPC. There may be some record of which NPCs have given out gifts,
// but I haven't seen that yet.

achievement(
    id=424979,
    title="I Like Your Crib, G",
    description="Invite another Urb over to your house and receive a housewarming gift.",
    points=3,
    trigger=(
        // In conversation
        GameMode == MODE_SOCIAL &&
        // received the gift
        any_of(Inventory, item => IsHousewarmingGift(item) && prev(item) == ITEM_NONE)
    )
)

// Get into Club Xizzle

achievement(
    id=424976,
    title="Welcome To Our Club",
    description="Gain entry to Club Xizzle. Happy dancing, homie!",
    points=5,
    trigger=(
        // Don't need save protection since if you know the password there's no barrier anyways
        AreaID == AREA_CLUB_XIZZLE &&
        prev(AreaID) != AREA_CLUB_XIZZLE
    )
)

// Visit Time Travel areas

achievement(
    id=57522,
    title="Overly Curious",
    description = "Travel to every location possible using the time machine.",
    points=3,
    trigger=(
        // Don't think this needs any sort of save protection but if we wanted to,
        // we should reset this on going to the main menu (since going to the "save game"
        // menu would reset this if we used SaveProtection, which would be annoying)
        all_of(time_travel_areas, area => once(AreaID == area))
    )
)

achievement(
    id=57551,
    title="1984",
    description = "Take a blast to the past.",
    points=1,
    trigger=(
        SaveProtection() &&
        // Looking kind of retro
        AreaID == AREA_PAPER_BOY_TIME_MACHINE &&
        // but for short enough a time for a retro achievement?
        prev(AreaID) != AREA_PAPER_BOY_TIME_MACHINE
    )
)

// Inventory

achievement(
    id=57553,
    title="Rosebud", 
    description="You know what to do.",
    points=1,
    trigger=(
        SaveProtection() &&
        // We have the item
        any_of(Inventory, item => item == ITEM_ROSEBUD) &&
        // We didn't have the item
        all_of(Inventory, item => prev(item) != ITEM_ROSEBUD)
    )
)

achievement(
    id=57554,
    title="Why Did The Chicken Cross The Road?", 
    description="Fill your inventory with chickens.",
    points=1,
    trigger=(
        SaveProtection() &&
        // We're full up on chickens
        all_of(Inventory, item => item == ITEM_CHICKEN) &&
        // We weren't full up on chickens
        any_of(Inventory, item => prev(item) != ITEM_CHICKEN)
    )
)

// Romance :)

chapter_1_female_npcs = [NPC_KRIS_THISTLE, NPC_LILY_GATES, NPC_MISTY_WATERS, NPC_SUE_PIRNOVA]
achievement(
    id=57552,
    title="Master of Seduction",
    description="Romance four different women before leaving King Tower at the start of the game.",
    points=10,
    type="missable",
    trigger=(
        SaveProtection() &&
        // Did Squegee Clean
        IsObjectiveComplete(0, 0, 0) == 1 &&
        // Haven't found the key yet
        IsMissionComplete(0, 3) == 0 &&
        // Trigger to show this achievement is active during chapter 1
        trigger_when(
            // All NPCs romanced
            all_of(chapter_1_female_npcs, npc => (
                GetRelationshipStatus(npc) & RELATIONSHIP_LOVE == RELATIONSHIP_LOVE
            )) &&
            // 1 NPC wasn't romanced last frame
            any_of(chapter_1_female_npcs, npc => (
                prev(GetRelationshipStatus(npc)) & RELATIONSHIP_LOVE != RELATIONSHIP_LOVE
            ))
        )
    )
)

// Trash

achievement(
    id=57526,
    title="I <3 Trash",
    description="Collect 100 piles of trash. Feel free to recycle!",
    points=2,
    trigger=(
        // NOTE: TrashPiles is stored as a byte in game and with the patch
        // could technically overflow, but I don't foresee it causing any
        // major issues. The player should already have this achievement.
        SaveProtection() &&
        measured(TrashPiles == 100, when=prev(TrashPiles) < 100)
    )
)

// Max Penthouse

achievement(
    id=57523,
    title="Some People Say I Like Money. Others? They Say the Same Thing.",
    description="Purchase the Penthouse and every home upgrade for it.",
    points=5,
    trigger=(
        SaveProtection() &&
        // Own Penthouse
        HouseID == HOUSE_PENTHOUSE &&
        // All utilities max
        all_of(range(0, NUM_UTILITIES - 1), utility => GetUtility(HOUSE_PENTHOUSE, utility) == MAX_UTILITY_LEVEL) &&
        // One of the utilities not max last frame
        any_of(range(0, NUM_UTILITIES - 1), utility => prev(GetUtility(HOUSE_PENTHOUSE, utility)) != MAX_UTILITY_LEVEL)
    )
)

// Mueseum

achievement(
    id=57541,
    title="Museum Mogul",
    description="Purchase every exhibit in the museum.",
    points=10,
    trigger=(
        SaveProtection() &&
        // We have all exhibits
        CheckAllExhibitsPurchased() &&
        // we didn't last frame
        !CheckAllExhibitsPurchased(prev) &&
        // Sanity check that we're in game
        GameMode == MODE_INGAME
    )
)

// Bike

optimal_bike = [
    [BikeChassis, 2],
    [BikeSuspension, 0],
    [BikeEngine, 3],
    [BikeNitro, 0],
    [BikeTires, 3],
]
achievement(
    id=57524,
    title="Fastest Hogg in Urbania",
    description="In Create-a-Hogg, have your ride have the highest top speed possible.",
    points=3,
    trigger=(
        SaveProtection() &&
        // We have the optimal bike
        all_of(optimal_bike, param => param[0] == param[1]) &&
        // We didn't have the optimal bike last frame
        any_of(optimal_bike, param => prev(param[0]) != param[1])
    )
)

// Xizzles

achievement(
    id=57525,
    title="Simply Xizzlin'",
    description="Have 25 or more Xizzle Beads on you at once",
    type="missable",
    points=10,
    trigger=(
        SaveProtection() &&
        // We have the beads
        XizzleBeads >= 25 &&
        // and we didn't have the beads
        prev(XizzleBeads) < 25
    )
)

// Flunk that intro quiz

achievement(
    id=57550,
    title="Yes, You May Refer to Me as the Master of Quizzes",
    description="Answer the laziest possible combination of answers when creating your character.",
    points=0,
    trigger=(
        // Left the quiz
        prev(GameMode) == MODE_CHARACTER_CREATE_QUIZ &&
        // and entered the next screen
        GameMode == NODE_CHARACTER_CREATE_CONFIRM &&
        // Answered 0 to all questions
        all_of(range(0, 6 - 1), i => byte(QuizAnswers + i) == 0)
    )
)

// LEADERBOARDS START

MinigameLeaderboards = {
    MINIGAME_MOOGOO:
    {
        "id": 96725,
        "name": "Moogoo Monkey",
    },
    MINIGAME_COMIC:
    {
        "id": 96726,
        "name": "Comic Explosion",
    },
    MINIGAME_DOCTOR:
    {
        "id": 96727,
        "name": "Doctor Max Stat!",
    },
    MINIGAME_SQUEEGEE:
    {
        "id": 96728,
        "name": "Squeegee Clean",
    },
    MINIGAME_HOOPZ:
    {
        "id": 96729,
        "name": "Hoopz",
    },
    MINIGAME_SOUL:
    {
        "id": 96730,
        "name": "Soul Music",
    },
    MINIGAME_YAR:
    {
        "id": 96731,
        "name": "Yar Hey! Bombard!",
    },
}

for minigame in MinigameLeaderboards
{
    params = MinigameLeaderboards[minigame]
    
    // Extra check for Soul Music
    extra = if_else(minigame == MINIGAME_SOUL, " Do not use the Golden Fiddle.", "")
    extra_check = if_else(
        minigame == MINIGAME_SOUL,
        !any_of(Inventory, item => item == ITEM_GOLDEN_FIDDLE),
        always_true()
    )
    
    leaderboard(
        id=params["id"],
        title=format("{0} - Highest Score", params["name"]),
        description=format(
            "Earn the highest score in the {0} minigame!{1}", 
            params["name"],
            extra
        ),
        start=(
            // In minigame
            IsMinigame() &&
            // Correct minigame
            MinigameID == minigame &&
            // Extra check
            extra_check &&
            // Started gameplay
            IsMinigamePlay() &&
            !IsMinigamePlay(prev)
        ),
        cancel=(
            !IsMinigame()
        ),
        submit=(
            IsMinigameOver()
        ),
        value=(
            MinigameScore
        )
    )
}

// Motocross
leaderboard(
    id=96732,
    title="Motocross Mayhem - Fastest Time",
    description="Complete Motocross Mayhem as quickly as possible!",
    format="CENTISECS",
    lower_is_better=true,
    start=(
        // In minigame
        IsMinigame() &&
        // Correct minigame
        MinigameID == MINIGAME_MOTOCROSS &&
        // Started gameplay
        IsMinigamePlay() &&
        !IsMinigamePlay(prev)
    ),
    cancel=(
        !IsMinigame()
    ),
    submit=(
        IsMinigameOver()
    ),
    value=(
        MotocrossMayhemCentiseconds
    )
)

// LEADERBOARDS END

// RICH PRESENCE START

// Time and Date (no man's land)

// We could do this smarter if we had modulus, but we should be able to hardcode this for now
DAYS_TO_CALC = 1000

Weekdays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
Months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
DaysPerMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

// Day-based lookups
function CalcDays()
{
    MonthLookup = {} // Month
    DayLookup = {} // Day of the month
    WeekdayLookup = {} // Weekday
    YearLookup = {} // Years

    // October 16th, 2004
    day = 15
    month = 9
    year = 2004
    
    for i in range(0, DAYS_TO_CALC - 1)
    {
        WeekdayLookup[i] = Weekdays[i % 7]
        DayLookup[i] = format("{0}", day + 1) // convert to string
        MonthLookup[i] = Months[month]
        YearLookup[i] = format("{0}", year)
        
        day = day + 1
        if day >= DaysPerMonth[month]
        {
            month = month + 1
            day = 0
        }
        if month >= 12
        {
            year = year + 1
            month = 0
        }
    }
    
    return [MonthLookup, DayLookup, WeekdayLookup, YearLookup]
}
foo = CalcDays()
MonthLookup = foo[0]
DayLookup = foo[1]
WeekdayLookup = foo[2]
YearLookup = foo[3]

function CalcHours()
{
    TimeOfDayLookup = {}
    HourLookup = {}
    for i in range(0, 24 - 1)
    {
        hour = if_else(i % 12 == 0, 12, i % 12)
        HourLookup[i] = format("{0}", hour) // convert to string
        TimeOfDayLookup[i] = if_else(i < 12, "AM", "PM")
    }
    
    return [TimeOfDayLookup, HourLookup]
}
foo = CalcHours()
TimeOfDayLookup = foo[0]
HourLookup = foo[1]

// Zero-padding for minutes
ZeroPadLookup = {
    0: "0",
    1: "0",
    2: "0",
    3: "0",
    4: "0",
    5: "0",
    6: "0",
    7: "0",
    8: "0",
    9: "0",
}

// Player name psuedo-generator

function shift(n)
{
    // We can't left shift then right shift or & the result of an add source chain,
    // so we have to use the upper bits of the int32 number so junk can be swept off
    res = n * 0x4000000
    
    // Avoid "Number too large" error
    if USE_64_BIT
    {
        res = res * 0x10000
        res = res * 0x10000
    }
    
    return res
}

// Here we'll choose a player name using a hash of their name + their gender.
// The length of this lookup needs to be a power of 2 so it can be accessed with &.
NameLookup = {
    // Sims 1
    // Goth Family
    shift(0): "Mortimer",  // (Boy)
    shift(1): "Bella",     // (Girl)
    shift(2): "Alexander", // (Boy, and so on)
    shift(3): "Cassandra", // (Girl, and so on)
    shift(4): "Gunther",
    shift(5): "Cornelia",
    // Newbie Family
    shift(6): "Bob",
    shift(7): "Betty",
    shift(8): "Robert",
    shift(9): "Mags",
    // Pleasant Family
    shift(10): "Jeff",
    shift(11): "Diane",
    shift(12): "Daniel",
    shift(13): "Jennifer",
    //
    shift(15): "Angela",
    //
    shift(17): "Lilth",
    // Bachelor Family
    shift(14): "Michael",
    // Roomies Family
    //
    shift(19): "Chris",
    //
    shift(21): "Melissa",
    // Mashuga Family
    shift(16): "Frankie",
    shift(23): "Sylvia",
    // Burb Family
    shift(18): "Brad",
    shift(20): "Johnny",
    shift(22): "Tucker",
    shift(25): "Tiffany",
    //
    shift(27): "Lucy",
    // Kat Family
    shift(29): "Ginia",
    // Charming Family
    shift(31): "Claire",
    // Half Life 2
    shift(24): "Gordon",
    shift(26): "Eli",
    shift(28): "Wallace",
    shift(30): "Barney",
    shift(33): "Alyx",
    // My Little Pony
    shift(32): "Spike",
    shift(35): "Luna",
    // GTA: VC
    shift(34): "Victor",
    shift(36): "Lance",
    shift(37): "Mercedes",
    shift(38): "Tommy",
    shift(39): "Barbie", // slash Barbie
    shift(40): "Ken",
    // In Stars & Time
    shift(41): "Mirabelle",
    shift(42): "Isabeau",
    shift(43): "Odile",
    // Siffrin/ Bonnie goes into non-binary names
    // Raw Danger
    shift(44): "Keith",
    shift(45): "Kelly",
    shift(46): "Joshua",
    shift(47): "Stephanie",
    shift(48): "Aidan",
    shift(49): "Amber",
    shift(50): "Isaac",
    shift(51): "Sophia",
    shift(52): "Ivan",
    shift(53): "Paige",
    shift(54): "Geo",
    shift(55): "Emily",
    shift(56): "Greg",
    shift(57): "Sierra",
    // Non-binary names
    // In Stars & Time
    shift(58): "Siffrin",
    shift(59): "Siffrin",
    shift(60): "Bonnie",
    shift(61): "Bonnie",
    // Crypt of the NecroDancer
    shift(62): "Bolt",
    shift(63): "Bolt",
}

function HashPlayerName()
{
    res = 0
    for i in range(0, 16 - 1)
    {
        res = res + byte(PlayerName + i)
    }
    
    res = res * 2
    res = res + PlayerGender
    res = shift(res) // left-shift off upper bits since we can't & the result or do lshift/rshift...
    return res
}

// Misc. lookups
// Minigames

function EncodeDifficulty(minigame, difficulty)
{
    return minigame * 0x100 + difficulty
}

MinigameNameLookup = {
    MINIGAME_MOOGOO: "Bluffing in Moogoo Monkey",
    MINIGAME_COMIC: "Raising the roof in Comic Explosion",
    MINIGAME_DOCTOR: "Saving patients in Doctor Max Stat!",
    MINIGAME_SQUEEGEE: "Cleaning windows in Squeegee Clean",
    MINIGAME_HOOPZ: "Shooting some b-ball in Hoopz",
    MINIGAME_SOUL: "Fiddling the Red Man in Soul Music",
    MINIGAME_YAR: "Bumping in Yar, Hey! Bombard!",
    MINIGAME_MOTOCROSS: "Speeding in Motocross Mayhem"
}

ED = EncodeDifficulty
MinigameDifficultyLookup = {
    ED(MINIGAME_MOOGOO, 0): "Wannabe Primate",
    ED(MINIGAME_MOOGOO, 1): "Lucky Monkey",
    ED(MINIGAME_MOOGOO, 2): "Awesome Orangutan",
    ED(MINIGAME_MOOGOO, 3): "Great Gorilla",
    ED(MINIGAME_MOOGOO, 4): "Moogoo Monkey master",
    ED(MINIGAME_COMIC, 0): "Wiseguy",
    ED(MINIGAME_COMIC, 1): "Prop Comic",
    ED(MINIGAME_COMIC, 2): "Comedian",
    ED(MINIGAME_COMIC, 3): "Cable Comedian",
    ED(MINIGAME_COMIC, 4): "Wild and Crazy Guy",
    ED(MINIGAME_DOCTOR, 0): "Intern",
    ED(MINIGAME_DOCTOR, 1): "Bonesaw",
    ED(MINIGAME_DOCTOR, 2): "Resident",
    ED(MINIGAME_DOCTOR, 3): "Doctor",
    ED(MINIGAME_DOCTOR, 4): "Brain Surgeon",
    ED(MINIGAME_SQUEEGEE, 0): "Bird Watcher",
    ED(MINIGAME_SQUEEGEE, 1): "Streaker",
    ED(MINIGAME_SQUEEGEE, 2): "Glass Buffer",
    ED(MINIGAME_SQUEEGEE, 3): "Squeegy Guru",
    ED(MINIGAME_SQUEEGEE, 4): "Clean N Sheen",
    ED(MINIGAME_HOOPZ, 0): "Got No Game",
    ED(MINIGAME_HOOPZ, 1): "Granny Styler",
    ED(MINIGAME_HOOPZ, 2): "Sure Shot",
    ED(MINIGAME_HOOPZ, 3): "Hoop Master",
    ED(MINIGAME_HOOPZ, 4): "En Fuego",
    ED(MINIGAME_SOUL, 0): "L'il Fiddler",
    ED(MINIGAME_SOUL, 1): "Prodigy",
    ED(MINIGAME_SOUL, 2): "Maestro",
    ED(MINIGAME_SOUL, 3): "Virtuoso",
    ED(MINIGAME_SOUL, 4): "Red Man Incarnate",
    ED(MINIGAME_YAR, 0): "Seaman",
    ED(MINIGAME_YAR, 1): "Scurvy Dog",
    ED(MINIGAME_YAR, 2): "First Mate",
    ED(MINIGAME_YAR, 3): "Captain Chaos",
    ED(MINIGAME_YAR, 4): "Boat Basher Supreme",
    ED(MINIGAME_MOTOCROSS, 0): "Novice",
    ED(MINIGAME_MOTOCROSS, 1): "Rookie",
    ED(MINIGAME_MOTOCROSS, 2): "Pro",
    ED(MINIGAME_MOTOCROSS, 3): "Expert Rider",
    ED(MINIGAME_MOTOCROSS, 4): "Master of Mayhem",
}

SpecialMinigameLookup = {
    MINIGAME_STUDY_COOKING: "Studying Cooking at Miniopolis U.",
    MINIGAME_STUDY_CREATIVITY: "Studying Creativity at Miniopolis U.",
    MINIGAME_STUDY_LOGIC: "Studying Logic at Miniopolis U.",
    MINIGAME_STUDY_MECHANICAL: "Studying Mechanical at Miniopolis U.",
    MINIGAME_SPELLING_BEE: "Seplling wlel in Spelling Bee",
    MINIGAME_DARTS: "Playing Darts at the Carnival",
    MINIGAME_CUPS: "Playing Cups at the Carnival",
    MINIGAME_DERBY: "Playing Derby at the Carnival",
    MINIGAME_SLOTS: "Playing Slots at the Carnival",
}

// Chapter

ChapterLookup = {
    0: "Chapter 1: Squatting in King Tower",
    1: "Chapter 2: Establishing oneself in Urbania",
    2: "Chapter 3: Moving on up in Sim Quarter",
    3: "Chapter 4: Walking the dazzling streets of Glasstown",
    4: "Chapter 5: Cleaning up Miniopolis",
}

// Area

TimeTravelDateLookup = {
    AREA_CIVIL_WAR_TIME_MACHINE: "Saturday, December 31 1870",
    AREA_HAYSEEDS_FARM_TIME_MACHINE: "Tuesday, December 2 2003", 
    AREA_PLANET_OF_THE_APES_TIME_MACHINE: "3978 A.D.",
    AREA_PAPER_BOY_TIME_MACHINE: "Thursday, November 29, 1984",
    AREA_TAR_PIT_TIME_MACHINE: "1,000,000 B.C.",
}

AreaLookup = {
    0: "on the Streetball Court",
    1: "in the Bayou",
    2: "in the Carnival",
    3: "in the Graveyard",
    4: "in Glasstown",
    5: "in the Civil War",
    6: "near Hayseed's Farm",
    7: "in the Crater",
    8: "near the Paperboy's Route",
    9: "on Paradise Island",
    10: "on the Planet of the Apes",
    11: "on the River",
    12: "on Salty's Riverboat",
    13: "in the Sim Quarter Farmer's Market",
    14: "near a tar pit",
    15: "on the Twin's River Bed",
    16: "in Urbania's Park",
    17: "in the Glasstown Mega-Mall",
    18: "in the Glasstown Mega-Mall",
    19: "in the Small Brownstone",
    20: "in the Large Brownstone",
    21: "inside Bus Storage",
    22: "in the Captain's Quarters",
    23: "in Salty's Lounge",
    24: "in the Cinema d'Urbania",
    25: "in the Cinema Theater",
    26: "in the City Apartment",
    27: "in the City Apartment Lobby",
    28: "inside City Storage",
    29: "in Zeke's Zydeco Club",
    30: "in the Coffee Shop",
    31: "in the Crawfish Shack",
    32: "in the Dark Tree",
    33: "in the First Mate's Quarters",
    34: "in the Fortune Teller's Shop",
    35: "in the Chopper Garage",
    36: "in the Miniopolis Hospital",
    37: "in Café Multiplaya",
    38: "in Jail",
    39: "in the Magic Lamp",
    40: "in the Mausoleum",
    41: "on Moon Base Zeta",
    42: "Epoch Museum's 1st Floor",
    43: "Epoch Museum's 2nd Floor",
    44: "Epoch Museum's Lobby",
    45: "inside Miniopolis Chronicle",
    46: "inside Slice O' Life Pizza",
    47: "inside Sim Quarter Storage",
    48: "inside the Artsie Clubhouse",
    49: "inside the Rep Group Clubhouse",
    50: "inside the Nerdie Clubhouse",
    51: "inside the Richie Clubhouse",
    52: "inside the Streetie Clubhouse",
    53: "in the Secret Lab",
    54: "in a Secret Tunnel",
    55: "in the King Tower Executive Office",
    56: "in the King Tower Waters' Gym",
    57: "in the King Tower Law Offices",
    58: "in the King Tower Tower Lobby",
    59: "in the King Tower Penthouse",
    60: "in the unfinished King Tower Penthouse",
    61: "in the 2nd floor of the King Tower Penthouse",
    62: "on the King Tower Roof",
    63: "on the King Tower Roof",
    64: "in the Second Looks Thrift Emporium",
    65: "in the Townhouse",
    66: "in the Townhouse",
    67: "in the Twins' Bayou Shack",
    68: "inside Miniopolis University",
    69: "inside the Junked Schoolbus",
    70: "inside Club Xizzle",
    71: "in a bird cage in King Tower",
}

// NPCs
// (NOTE: For whatever reason, NPCs are shifted by 0x21 when talking to them)

NPCLookup = {
    (NPC_BAYOO_BOO + 0x21): "Bayoo Boo",
    (NPC_BERKELEY_CLODD + 0x21): "Berkeley Clodd",
    (NPC_CANNONBALL_COLEMAN + 0x21): "Cannonball Coleman",
    (NPC_CRAWDAD_CLEM + 0x21): "Crawdad Clem",
    (NPC_CRYSTAL + 0x21): "Crystal",
    (NPC_DADDY_BIGBUCKS + 0x21): "Daddy Bigbucks",
    (NPC_DARIUS + 0x21): "Darius",
    (NPC_DET_DAN_D_MAN + 0x21): "Det. Dan D. Mann",
    (NPC_DUSTY_HOGG + 0x21): "Dusty Hogg",
    (NPC_EPHRAM_EARL + 0x21): "Ephram Earl",
    (NPC_EWAN_WATAHMEE + 0x21): "Ewan Watahmee",
    (NPC_GIUSEPPI_MEZZOLATO + 0x21): "Giuseppi Mezzolato",
    (NPC_GRAMMA_HATTIE + 0x21): "Gramma Hattie",
    (NPC_HARLAN_KING + 0x21): "Harlan King",
    (NPC_KRIS_THISTLE + 0x21): "Kris Thistle",
    (NPC_LILY_GATES + 0x21): "Lily Gates",
    (NPC_LINCOLN_BROADSHEET + 0x21): "Lincoln Broadsheet",
    (NPC_LOTTIE_CASH + 0x21): "Lottie Cash",
    (NPC_LUTHOR_L_BIGBUCKS + 0x21): "Luthor L. Bigbucks",
    (NPC_MAMBO_LOA + 0x21): "Mambo Loa",
    (NPC_MAXIMILLIAN_MOORE + 0x21): "Maximillian Moore",
    (NPC_MISTY_WATERS + 0x21): "Misty Waters",
    (NPC_OLDE_SALTY + 0x21): "Olde Salty",
    (NPC_PHEOBE_TWIDDLE + 0x21): "Phoebe Twiddle",
    (NPC_POLLY_NOMINAL + 0x21): "Polly Nomial",
    (NPC_PRITCHARD_LOCKSLEY + 0x21): "Pritchard Locksley",
    (NPC_ROXANNA_MOXIE + 0x21): "Roxanna Moxie",
    (NPC_SUE_PIRNOVA + 0x21): "Sue Pirnova",
    (NPC_THERESA_BULLHORN + 0x21): "Theresa Bullhorn",
    // Special NPCs
    0x3E: "the Casino Dealer",
    0x3F: "Gordie Puck",
    0x40: "Lloyd",
    0x41: "Pepper Pete",
    0x42: "the professor",
    0x43: "the Red Man",
    0x44: "the Xizzle Door",
}

MODE_CHARACTER_CREATE_NAME_ENTRY = 25
MODE_CHARACTER_CREATE_UNKNOWN = 26
MODE_CHARACTER_CREATE_CLOTHING = 27
NODE_CHARACTER_CREATE_CONFIRM = 28
MODE_CHARACTER_CREATE_QUIZ = 29

// Title screen (or load/save)
rich_presence_conditional_display(
    any_of(
        [MODE_COPYRIGHT, MODE_BOOTSPLASH, MODE_TITLE, MODE_SAVELOAD],
        i => GameMode == i
    ) ||
    (GameMode == MODE_JOBSMENU && LastGameModeSticky == MODE_TITLE),
    "In the title or load screen"
)
// In Create-an-Urb
rich_presence_conditional_display(
    any_of(
        [MODE_CHARACTER_CREATE_NAME_ENTRY, MODE_CHARACTER_CREATE_UNKNOWN, MODE_CHARACTER_CREATE_CLOTHING, NODE_CHARACTER_CREATE_CONFIRM, MODE_CHARACTER_CREATE_QUIZ],
        i => GameMode == i
    ),
    "In Create-an-Urb"
)
// Watching the intro cutscene
rich_presence_conditional_display(
    GameMode == MODE_INTRO_CUTSCENE,
    "Getting the run-down on their new life in the legendary Miniopolis"
)
// Playing a minigame from the main menu
rich_presence_conditional_display(
    GameMode == MODE_MINIGAME && LastGameModeSticky == MODE_JOBSMENU, 
    "{0} on the {1} difficulty, from the main menu",
    rich_presence_lookup("MINIGAME", MinigameID, MinigameNameLookup),
    rich_presence_lookup("DIFFICULTY", ED(MinigameID, MinigameDifficulty), MinigameDifficultyLookup)
)
// Playing a job minigame
rich_presence_conditional_display(
    IsJob(),
    "An Urb is Urbin' in Miniopolis | They look like a \"{0}\" to me | {1}, {2} {3} {4} {5}:{6}{7} {8} | {9} | {10} on the {11} difficulty",
    rich_presence_lookup("PLAYERNAME", HashPlayerName(), NameLookup),
    rich_presence_lookup("WEEKDAY", Days, WeekdayLookup),
    rich_presence_lookup("MONTH", Days, MonthLookup),
    rich_presence_lookup("DAYSOFMONTH", Days, DayLookup),
    rich_presence_lookup("YEAR", Days, YearLookup),
    rich_presence_lookup("HOURS", Hours, HourLookup),
    rich_presence_lookup("ZEROPAD", Minutes, ZeroPadLookup, ""),
    rich_presence_value("MINUTES", Minutes),
    rich_presence_lookup("TIMEOFDAY", Hours, TimeOfDayLookup),
    rich_presence_lookup("CHAPTER", GetCurrentChapter(), ChapterLookup),
    rich_presence_lookup("MINIGAME", MinigameID, MinigameNameLookup),
    rich_presence_lookup("DIFFICULTY", ED(MinigameID, MinigameDifficulty), MinigameDifficultyLookup)
)
// Playing a special minigame (i.e. carnival games, spell champ)
rich_presence_conditional_display(
    IsMinigame(),
    "An Urb is Urbin' in Miniopolis | They look like a \"{0}\" to me | {1}, {2} {3} {4} {5}:{6}{7} {8} | {9} | {10}",
    rich_presence_lookup("PLAYERNAME", HashPlayerName(), NameLookup),
    rich_presence_lookup("WEEKDAY", Days, WeekdayLookup),
    rich_presence_lookup("MONTH", Days, MonthLookup),
    rich_presence_lookup("DAYSOFMONTH", Days, DayLookup),
    rich_presence_lookup("YEAR", Days, YearLookup),
    rich_presence_lookup("HOURS", Hours, HourLookup),
    rich_presence_lookup("ZEROPAD", Minutes, ZeroPadLookup, ""),
    rich_presence_value("MINUTES", Minutes),
    rich_presence_lookup("TIMEOFDAY", Hours, TimeOfDayLookup),
    rich_presence_lookup("CHAPTER", GetCurrentChapter(), ChapterLookup),
    rich_presence_lookup("MINIGAME_SPECIAL", MinigameID, SpecialMinigameLookup)
)
// In time travel area
rich_presence_conditional_display(
    any_of(time_travel_areas, area => AreaID == area),
    "An Urb is Urbin' through time | They look like a \"{0}\" to me | {1} {2}:{3}{4} {5} | {6} | Running around {7}",
    rich_presence_lookup("PLAYERNAME", HashPlayerName(), NameLookup),
    rich_presence_lookup("TIMETRAVEL", AreaID, TimeTravelDateLookup),
    rich_presence_lookup("HOURS", Hours, HourLookup),
    rich_presence_lookup("ZEROPAD", Minutes, ZeroPadLookup, ""),
    rich_presence_value("MINUTES", Minutes),
    rich_presence_lookup("TIMEOFDAY", Hours, TimeOfDayLookup),
    rich_presence_lookup("CHAPTER", GetCurrentChapter(), ChapterLookup),
    rich_presence_lookup("AREA", AreaID, AreaLookup)
)
// Talking to NPC
rich_presence_conditional_display(
    GameMode == MODE_SOCIAL,
    "An Urb is Urbin' in Miniopolis | They look like a \"{0}\" to me | {1}, {2} {3} {4} {5}:{6}{7} {8} | {9} | Talking to {10} {11}",
    rich_presence_lookup("PLAYERNAME", HashPlayerName(), NameLookup),
    rich_presence_lookup("WEEKDAY", Days, WeekdayLookup),
    rich_presence_lookup("MONTH", Days, MonthLookup),
    rich_presence_lookup("DAYSOFMONTH", Days, DayLookup),
    rich_presence_lookup("YEAR", Days, YearLookup),
    rich_presence_lookup("HOURS", Hours, HourLookup),
    rich_presence_lookup("ZEROPAD", Minutes, ZeroPadLookup, ""),
    rich_presence_value("MINUTES", Minutes),
    rich_presence_lookup("TIMEOFDAY", Hours, TimeOfDayLookup),
    rich_presence_lookup("CHAPTER", GetCurrentChapter(), ChapterLookup),
    rich_presence_lookup("NPCNAME", ConversationNPC, NPCLookup, "an unknown Urb"),
    rich_presence_lookup("AREA", AreaID, AreaLookup)
)
// Just doing whatever
rich_presence_display(
    "An Urb is Urbin' in Miniopolis | They look like a \"{0}\" to me | {1}, {2} {3} {4} {5}:{6}{7} {8} | {9} | Running around {10}",
    rich_presence_lookup("PLAYERNAME", HashPlayerName(), NameLookup),
    rich_presence_lookup("WEEKDAY", Days, WeekdayLookup),
    rich_presence_lookup("MONTH", Days, MonthLookup),
    rich_presence_lookup("DAYSOFMONTH", Days, DayLookup),
    rich_presence_lookup("YEAR", Days, YearLookup),
    rich_presence_lookup("HOURS", Hours, HourLookup),
    rich_presence_lookup("ZEROPAD", Minutes, ZeroPadLookup, ""),
    rich_presence_value("MINUTES", Minutes),
    rich_presence_lookup("TIMEOFDAY", Hours, TimeOfDayLookup), 
    rich_presence_lookup("CHAPTER", GetCurrentChapter(), ChapterLookup),
    rich_presence_lookup("AREA", AreaID, AreaLookup)
)

// RICH PRESENCE END
