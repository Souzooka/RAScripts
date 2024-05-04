// Urbz, The: Sims in the City
// #ID = 5057

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
MODE_TITLE = 5
MODE_SAVELOAD = 6
MODE_MINIGAME = 17
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

// GAME VARIABLES

MAX_MINIGAME_DIFFICULTY = 4
MAX_UTILITY_LEVEL = 2
NUM_UTILITIES = 4
NUM_MUSEUM_EXHIBITS = 5

// The current game mode (See Game Modes enumeration)
GameMode = dword(0x4910)
// Used for storing the last game mode in some states or during transitions
LastGameMode = dword(0x4914)
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

function IsInInventory(item_id, pred=mirror)
{
    return any_of(Inventory, item => pred(item) == item_id)
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

// Misc. achievements

// Visit Time Travel areas
time_travel_areas = [
    AREA_CIVIL_WAR_TIME_MACHINE,
    AREA_HAYSEEDS_FARM_TIME_MACHINE,
    AREA_PAPER_BOY_TIME_MACHINE,
    AREA_PLANET_OF_THE_APES_TIME_MACHINE,
    AREA_TAR_PIT_TIME_MACHINE,
]

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
        !CheckAllExhibitsPurchased(prev)
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
        DayLookup[i] = day + 1
        MonthLookup[i] = Months[month]
        YearLookup[i] = year
        
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
        hour = if_else(i % 12 == 0, 12, i)
        HourLookup[i] = hour
        TimeOfDayLookup[i] = if_else(i < 12, "AM", "PM")
    }
    
    return [TimeOfDayLookup, HourLookup]
}
foo = CalcHours()
TimeOfDayLookup = foo[0]
HourLookup = foo[1]

// sigh just let me put numbers in rich_presence_lookup I beg you
ITOALookup = {
    0: "0", 
    1: "1", 
    2: "2", 
    3: "3", 
    4: "4", 
    5: "5", 
    6: "6", 
    7: "7", 
    8: "8", 
    9: "9", 
    10: "10", 
    11: "11", 
    12: "12", 
    13: "13", 
    14: "14", 
    15: "15", 
    16: "16", 
    17: "17", 
    18: "18", 
    19: "19", 
    20: "20", 
    21: "21", 
    22: "22", 
    23: "23", 
    24: "24", 
    25: "25", 
    26: "26", 
    27: "27", 
    28: "28", 
    29: "29", 
    30: "30", 
    31: "31",
    2004: "2004", 
    2005: "2005", 
    2006: "2006", 
    2007: "2007", 
    2008: "2008", 
    2009: "2009", 
    2010: "2010", 
    2011: "2011", 
    2012: "2012", 
    2013: "2013", 
    2014: "2014", 
    2015: "2015", 
    2016: "2016", 
    2017: "2017", 
    2018: "2018", 
    2019: "2019",
}

// Convert ints to strings...
for i in DayLookup
    DayLookup[i] = ITOALookup[DayLookup[i]]
for i in YearLookup
    YearLookup[i] = ITOALookup[YearLookup[i]]
for i in HourLookup
    HourLookup[i] = ITOALookup[HourLookup[i]]

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

rich_presence_display(
    "It is {0}:{1}{2} {3} on {4}, {5} {6} {7}.",
    rich_presence_lookup("HOURS", Hours, HourLookup),
    rich_presence_lookup("ZEROPAD", Minutes, ZeroPadLookup, ""),
    rich_presence_value("MINUTES", Minutes),
    rich_presence_lookup("TIMEOFDAY", Hours, TimeOfDayLookup),
    rich_presence_lookup("WEEKDAY", Days, WeekdayLookup),
    rich_presence_lookup("MONTH", Days, MonthLookup),
    rich_presence_lookup("DAYSOFMONTH", Days, DayLookup),
    rich_presence_lookup("YEAR", Days, YearLookup)
)


// RICH PRESENCE END
