// Firefighter F.D.18
// #ID = 27515

// MISC. SCRIPT HELPERS

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

// Region checks
// I'm working on a 60-fps hack but these addresses should be used for debug menu code, so they shouldn't get touched
isEU = byte(0x280B0D)
isJP = byte(0x280D7D)
isUS = byte(0x280B21)

// Just for scripting purposes
Region = byte(0x28693C) // Direct lookup for RP, constant 0=US, 1=EU, 2=JP
REGION_US = 0
REGION_EU = 1
REGION_JP = 2

function isRegion(region)
{
    if region == REGION_US
    {
        return isUS == 1
    }
    if region == REGION_EU
    {
        return isEU == 1
    }
    return isJP == 1
}

function GetRealAddress(us_address, eu_address, jp_address)
{
    eu_offset = (eu_address - us_address) * isEU
    jp_offset = 0 // We can't construct an address from multiple memory lookups -- BUT the US and JP memory addresses we use are exactly the same. Big W.
    return us_address + eu_offset + jp_offset
}

StageClearedMenu = dword(GetRealAddress(0x52AF00, 0x52B080, 0x52AF00))
GameStatus = dword(GetRealAddress(0x5A5108, 0x5A5288, 0x5A5108))
StageID = GetRealAddress(0x5A5118, 0x5A5298, 0x5A5118)
Difficulty = dword(GetRealAddress(0x5A51F8, 0x5A5378, 0x5A51F8))
CharacterID = dword(GetRealAddress(0x5A548C, 0x5A560C, 0x5A548C))
PlayerInitialMaxHP = dword(GetRealAddress(0x5C4F90, 0x5C5110, 0x5C4F90))
PlayerMaxHP = dword(GetRealAddress(0x5C4F94, 0x5C5114, 0x5C4F94))
PlayerHP = dword(GetRealAddress(0x5C4F98, 0x5C5118, 0x5C4F98))
_player_pos = GetRealAddress(0x531520, 0x5316A0, 0x531520)
PlayerPos = {
    "x": float(_player_pos + 0x0),
    "y": float(_player_pos + 0x4),
    "z": float(_player_pos + 0x8),
}
// See note for 0x5a5178
LostItemsTemp = GetRealAddress(0x5A5188, 0x5A5308, 0x5A5188)
LostItemsPerm = GetRealAddress(0x5A5CD8, 0x5A5E58, 0x5A5CD8)
AwardInfo = GetRealAddress(0x52AEE0, 0x52B060, 0x52AEE0)
BossMaxHP = dword(GetRealAddress(0x5288F4, 0x528A74, 0x5288F4))
BossHP = dword(GetRealAddress(0x5288F8, 0x528A78, 0x5288F8))

// Enums
STATUS_SoftResetLoad = 2
STATUS_LanguageSelect = 3
STATUS_Initial = 4
STATUS_Splash = 5
STATUS_TitleMenu = 6
STATUS_GameLoad = 7
STATUS_Game = 8
STATUS_StageClearedLoad = 10
STATUS_StageCleared = 11
STATUS_GameCutsceneLoad = 13
STATUS_GameCutscene = 14
STATUS_IntroCutsceneLoad = 16
STATUS_IntroCutscene = 17
STATUS_CinemaViewer = 22
STATUS_DebugStart = 23

DIFFICULTY_Any = -1 // Just for scripting purposes
DIFFICULTY_Easy = 0
DIFFICULTY_Normal = 1
DIFFICULTY_Hard = 2
DIFFICULTY_VeryHard = 3

STAGE_Any = -1 // Just for scripting purposes

CHARACTER_Any = -1 // Just for scripting purposes
CHARACTER_MissCrimson = 3

AWARD_SuperPlay = 1 // Beating dev time maybe...? Need to look into this one
AWARD_RecordTimeGold = 2
AWARD_RecordTimeSilver = 3
AWARD_RecordTimeBronze = 4
AWARD_EveryoneUnharmed = 6
AWARD_NoContinues = 7
AWARD_Rescue50People = 10
AWARD_PlayedGameFor24Hours = 11 // lol get out of here
AWARD_OneMillionExtinguishPoints = 12
AWARD_RescuedEntireCity = 13
AWARD_ClearVeryHardMode = 14

RANK_Beginner = 0
RANK_Trainee = 1
RANK_Rookie = 2
RANK_Novice = 3
RANK_Expert = 4
RANK_Veteran = 5
RANK_Professional = 6
RANK_Hero = 7

SCM_STATUS_Awards = 39
SCM_STATUS_AwardsDone = 29

FINAL_RESULT = 1

function TestStageIDElement(address, element_size, test_func)
{
    // StageID is stored in an unorthodox way in game. For example,
    // Stage 2-5 (6) is stored as 25h and the game does some dumb math to convert this
    // to a real array index constantly. I tried to calculate the address as such:
    // <array_start> + ((byte(0x4CAE70 + high4(StageID)) + (low4(StageID) - 1)) * 4
    // (0x4CAE70 is an array of [0, 1, 2, 7, 10] in game and is used in the index calculation in NTSCU)
    // but this address calculation doesn't appear to compile into RA syntax unfortunately
    //
    // This function should be able to test *simple* conditions based on items in arrays accessed via the stage ID
    // but should only be used as the last resort since more complicated conditions probably won't work,
    // and this generates at least 4 alt groups for the 4 major stage numbers
    // USE AS A LAST RESORT. Pain. Pain. Pain. Pain.
    // Thankfully, RA Syntax is so performant we could do a ton of redundant work as many achievements do instead
    // of just converting the number and testing a condition once in Python. Truly a pinnacle of technology.
    offsets = {
        1: 1,
        2: 2,
        3: 7,
        4: 10,
    }
    
    condition = always_false()
    for key in offsets
    {
        base_addr = address + (offsets[key] * element_size)
        val_addr = base_addr + (low4(StageID) - 1 * element_size)
        condition = condition || (high4(StageID) == key && test_func(val_addr))
    }
    return condition
}

// RICH PRESENCE START

CharacterNames = {
    0x0: "Dean McGregor",
    0x1: "Dean McGregor",
    0x2: "Dean McGregor",
    0x3: "Miss Crimson",
    0x4: "Miss Jet-Black",
    0x5: "Miss Holy White",
}

StageNames = {
    0x00: "in テスト用", // You better be in softcore mode dude
    0x11: "in the tunnel under Interstate 42",
    0x21: "in Cyclone Networks Laboratory's west wing 2F",
    0x22: "in Cyclone Networks Laboratory's west wing 3F",
    0x23: "in Cyclone Networks Laboratory's west wing 5F",
    0x24: "in Cyclone Networks Laboratory's east wing 4F",
    0x25: "in Cyclone Networks Laboratory's stairwell",
    0x31: "in the cruiser's ballroom",
    0x32: "in the cruiser's cabin area",
    0x33: "in the cruiser's engine room",
    0x41: "in the chemical plant's storeroom",
    0x42: "in the chemical plant's control room",
    0x43: "in the chemical plant's chemical warehouse",
    0x44: "in the chemical plant's production line",
    0x45: "on the chemical plant's tank",
    0x46: "in the chemical plant's chemical warehouse",
}

StageActivities = {
    0x00: "checking out the debug menu",
    0x11: "here to rescue every single person who needs help",
    0x21: "fighting fires and saving survivors",
    0x22: "fighting fires and saving survivors",
    0x23: "fighting fires and saving survivors",
    0x24: "fighting fires and saving survivors",
    0x25: "fighting fires and saving survivors",
    0x31: "getting revenge on the fire that kidnapped Dean's sister",
    0x32: "getting revenge on the fire that kidnapped Dean's sister",
    0x33: "getting revenge on the fire that kidnapped Dean's sister",
    0x41: "fighting fires and saving survivors",
    0x42: "fighting fires and saving survivors",
    0x43: "fighting fires and saving survivors",
    0x44: "fighting fires and saving survivors",
    0x45: "seeking answers to what has been happening",
    0x46: "saving survivors and enroute to evacuation",
}

Difficulties = {
    DIFFICULTY_Easy: "Easy",
    DIFFICULTY_Normal: "Normal",
    DIFFICULTY_Hard: "Hard",
    DIFFICULTY_VeryHard: "Very Hard",
}

// You *CAN* divide by a runtime value (i.e. PlayerInitialMaxHealth) BUT you
// seemingly can't string together 2 arithmetic operations for an RP value
// so we have to do constant folding for max health / 100
CharacterMaxHealths = {
    0x0: 60000,
    0x1: 60000,
    0x2: 60000,
    0x3: (45000 - 10), // Tweak the value a little bit so rounding on RP display doesn't show 99% at full health
    0x4: 60000,
    0x5: 90000,
}

main_menu_statuses = [STATUS_SoftResetLoad, STATUS_LanguageSelect, STATUS_Initial, STATUS_Splash, STATUS_TitleMenu, STATUS_IntroCutsceneLoad, STATUS_IntroCutscene]
pre_game_statuses = [STATUS_GameLoad, STATUS_GameCutsceneLoad, STATUS_GameCutscene]
game_statuses = [STATUS_Game, STATUS_StageClearedLoad, STATUS_StageCleared]

regions = [REGION_US, REGION_EU, REGION_JP]
region_text = {
    REGION_US: "ᵘˢ",
    REGION_EU: "ᵉᵘ",
    REGION_JP: "ʲᵖ",
}


// Title/Options
rich_presence_conditional_display(
    any_of(main_menu_statuses, x=>x==GameStatus),
    "{0} In the title menu.",
    rich_presence_lookup("Region", Region, region_text)
)

// Cinema viewer
rich_presence_conditional_display(
    GameStatus == STATUS_CinemaViewer, 
    "{0} Watching a cutscene in the Realtime Cinema Viewer.",
    rich_presence_lookup("Region", Region, region_text)
)

// Debug menus -- what are you doing there?
rich_presence_conditional_display(
    GameStatus >= STATUS_DebugStart,
    "{0} ⚠️ In a debug menu.",
    rich_presence_lookup("Region", Region, region_text)
)

// Pre-game (i.e. in a cutscene -- the character's HP isn't initialized at this point,
// which could lead to Miss Crimson for example displaying as having 133% HP if Dean was played before)
rich_presence_conditional_display(
    any_of(pre_game_statuses, x=>x==GameStatus), 
    "{0} {1} is {2} {3}. | {4} Difficulty",
    rich_presence_lookup("Region", Region, region_text),
    rich_presence_lookup("CharacterName", CharacterID, CharacterNames),
    rich_presence_lookup("StageActivity", byte(StageID), StageActivities),
    rich_presence_lookup("StageName", byte(StageID), StageNames),
    rich_presence_lookup("Difficulty", Difficulty, Difficulties)
)

// Game state
for character_id in CharacterNames
{
    rich_presence_conditional_display(
        any_of(game_statuses, x=>x==GameStatus) && CharacterID == character_id, 
        "{0} {1} is {2} {3}. | {4} Difficulty | Max HP: {5}% | HP: {6}%",
        rich_presence_lookup("Region", Region, region_text),
        rich_presence_lookup("CharacterName", CharacterID, CharacterNames),
        rich_presence_lookup("StageActivity", byte(StageID), StageActivities),
        rich_presence_lookup("StageName", byte(StageID), StageNames),
        rich_presence_lookup("Difficulty", Difficulty, Difficulties),
        rich_presence_value("MaxHealth", PlayerMaxHP * (100.0/CharacterMaxHealths[character_id]), "VALUE"),
        rich_presence_value("Health", PlayerHP * (100.0/CharacterMaxHealths[character_id]), "VALUE")
    )
}


rich_presence_display("Playing Firefighter F.D.18")

// RICH PRESENCE END

// LEADERBOARDS START

LeaderboardStageNames = {
    0x11: "Tunnel",
    0x21: "Lab. West wing 2F",
    0x22: "Lab. West wing 3F",
    0x23: "Lab. West wing 5F",
    0x24: "Lab. East wing 4F",
    0x25: "Lab. Stairwell",
    0x31: "Cruiser Ballroom",
    0x32: "Cruiser Cabin",
    0x33: "Cruiser Engine room",
    0x41: "Plant Storeroom",
    0x42: "Plant Control room",
    0x43: "Plant Chemical warehouse 1",
    0x44: "Plant Production line",
    0x45: "Plant Tank",
    0x46: "Plant Chemical warehouse 2",
}

LeaderboardStageIDs = {
    0x11: "1",
    0x21: "2-1",
    0x22: "2-2",
    0x23: "2-3",
    0x24: "2-4",
    0x25: "2-5",
    0x31: "3-1",
    0x32: "3-2",
    0x33: "3-3",
    0x41: "4-1",
    0x42: "4-2",
    0x43: "4-3",
    0x44: "4-4",
    0x45: "4-5",
    0x46: "4-6",
}

// Upon consultation with speedrunners these are different enough to justify splitting them up
LeaderboardCharacterNames = {
    0: "Dean Fire Coat",
    1: "Dean Unarmed",
    2: "Dean Max McGregor",
    3: "Miss Crimson",
    4: "Miss Jet-Black",
    5: "Miss Holy White",
}

function CreateLeaderboardStart(stage_id, character_id, difficulty)
{
    OFFSET_clear_type = 0x1C
    OFFSET_clear_time = 0x128
    OFFSET_tallied_clear_time = 0x148
    ClearType = dword(StageClearedMenu + OFFSET_clear_type)
    ClearTime = float(StageClearedMenu + OFFSET_clear_time)
    TalliedClearTime = float(StageClearedMenu + OFFSET_tallied_clear_time)
    
    return GameStatus == STATUS_StageCleared && 
           byte(StageID) == stage_id && 
           CharacterID == character_id &&
           Difficulty == difficulty &&
           StageClearedMenu != NULL &&
           ClearType != FINAL_RESULT &&
           // Takes a bit for the clear time value to be set to the true value,
           // but it is memset to 0 (nor do we expect someone to finish a stage in 0 frames)
           // so we can just check it's not that value to make sure the time is accurate.
           ClearTime != 0 &&
           // And actually for timing purposes we'll send off the record once the display matches the actual clear time
           prev(TalliedClearTime) != ClearTime &&
           TalliedClearTime == ClearTime
}

function CreateLeaderboardCancel(stage_id, character_id, difficulty)
{
    return always_false()
}

function CreateLeaderboardSubmit(stage_id, character_id, difficulty)
{
    return always_true()
}

function CreateLeaderboardValue(stage_id, character_id, difficulty)
{
    OFFSET_clear_time = 0x128
    return float(StageClearedMenu + OFFSET_clear_time) * 100.0 // convert to centisecs
}

for character_id in LeaderboardCharacterNames
{
    for stage_id in LeaderboardStageNames
    {
       for difficulty in Difficulties
       {
           leaderboard(
               title=format(
                   "Stage {0} - Record Time - {1} - {2}",
                   LeaderboardStageIDs[stage_id],
                   LeaderboardCharacterNames[character_id],
                   Difficulties[difficulty]
               ),
               description=format(
                   "Complete the {0} stage on the {1} difficulty as {2} in the fastest time!", 
                   LeaderboardStageNames[stage_id], 
                   Difficulties[difficulty],
                   LeaderboardCharacterNames[character_id]
               ),
               start=CreateLeaderboardStart(stage_id, character_id, difficulty),
               cancel=CreateLeaderboardCancel(stage_id, character_id, difficulty),
               submit=CreateLeaderboardSubmit(stage_id, character_id, difficulty),
               value=CreateLeaderboardValue(stage_id, character_id, difficulty),
               format="MILLISECS",
               lower_is_better=true
           )
       }
    }
}

// LEADERBOARDS END

// ACHIEVEMENTS START

// These are title case (as opposed to the in-game names used in the stage select for the leaderboard, which are not)
AchievementStageNames = {
    0x11: "Tunnel",
    0x21: "Lab. West Wing 2F",
    0x22: "Lab. West Wing 3F",
    0x23: "Lab. West Wing 5F",
    0x24: "Lab. East Wing 4F",
    0x25: "Lab. Stairwell",
    0x31: "Cruiser Ballroom",
    0x32: "Cruiser Cabin",
    0x33: "Cruiser Engine Room",
    0x41: "Plant Storeroom",
    0x42: "Plant Control Room",
    0x43: "Plant Chemical Warehouse 1",
    0x44: "Plant Production Line",
    0x45: "Plant Tank",
    0x46: "Plant Chemical Warehouse 2",
}

// LOST ITEMS

function dict_map(dict, predicate)
{
    // no dict_map??
    result = {}
    for key in dict
    {
        result[key] = predicate(dict[key])
    }
    return result
}

function CalcLostItemPoints(arr)
{
    if length(arr) > 5
    {
        // 3-2 is a special boi
        return 10
    }
    return length(arr)
}

// For constant-time logic
StageIDToIndex = {
    0x11: 1,
    0x21: 2,
    0x22: 3,
    0x23: 4,
    0x24: 5,
    0x25: 6,
    0x31: 7,
    0x32: 8,
    0x33: 9,
    0x41: 10,
    0x42: 11,
    0x43: 12,
    0x44: 13,
    0x45: 14,
    0x46: 15,
}

LostItemIDs = {
    0x11: [16, 34, 42],
    0x21: [2, 8, 17],
    0x22: [11, 19, 21],
    0x23: [5, 24, 40, 44],
    0x24: [22, 27, 31],
    0x25: [9, 13, 35, 38],
    0x31: [0, 3, 6],
    0x32: [1, 4, 7, 32, 39, 41, 43, 45], // bruh why do you have 8
    0x33: [12, 14, 18, 36],
    0x41: [15, 25],
    0x42: [20, 29],
    0x43: [23, 26, 33],
    0x44: [28, 30, 46],
    0x46: [10, 37, 47],
}

// This ends up being exactly 50 points, so it works out well
LostItemPoints = dict_map(LostItemIDs, CalcLostItemPoints)

function LostItemsTrigger(stage_id)
{
    nowVal = 0
    deltaVal = 0
    for lost_item_id in LostItemIDs[stage_id]
    {
        nowItem = byte(LostItemsPerm + lost_item_id)
        deltaItem = prev(nowItem)
    
        // NOTE: 0 / 0 is 0 in RA
        nowVal = nowVal + (nowItem / nowItem)
        deltaVal = deltaVal + (deltaItem / deltaItem)
    }
    
    return measured(
               nowVal == length(LostItemIDs[stage_id]),
               when=GameStatus == STATUS_StageCleared && 
                    byte(StageID) == stage_id &&
                    nowVal != deltaVal
           )
}

for stage_id in LostItemIDs
{
    achievement(
        title=format("Lost Items - {0}", AchievementStageNames[stage_id]),
        description=format("Collect all Lost Items in Stage {0}.", LeaderboardStageIDs[stage_id]),
        points=LostItemPoints[stage_id],
        trigger=LostItemsTrigger(stage_id)
    )
}

// RECORD TIMES - GOLD

// While I don't necessarily agree with the design, we want to direct players to earn gold record times
// on *EVERY* difficulty; earning all gold times on any one difficulty unlocks a new character in the Character Select

// Arbitrary designations (mostly for course length + difficulty tweak) for point distributions
// Kind of silly if a stage that is 3 minutes is scored the same as a 15 minute one

SHORT = 0
MEDIUM = 1
LONG = 2
VERY_LONG = 3

RecordTimePoints = {
    DIFFICULTY_Easy: {
        SHORT: 2,
        MEDIUM: 3,
        LONG: 4,
        VERY_LONG: 5,
    },
    DIFFICULTY_Normal: {
        SHORT: 3,
        MEDIUM: 4,
        LONG: 5,
        VERY_LONG: 10,
    },
    DIFFICULTY_Hard: {
        SHORT: 4,
        MEDIUM: 5,
        LONG: 10,
        VERY_LONG: 10,
    },
    DIFFICULTY_VeryHard: {
        SHORT: 5,
        MEDIUM: 10,
        LONG: 10,
        VERY_LONG: 25,
    }
}

StageLengths = {
    0x11: SHORT, // 3:30
    0x21: SHORT, // 4:50 (5:14 Very Hard)
    0x22: MEDIUM, // 5:20 (5:59)
    0x23: MEDIUM, // 6:10 (9:30)
    0x24: LONG, // 9:50 (12:38)
    0x25: MEDIUM, // 6:20 (10:19)
    0x31: SHORT, // 4:10 (4:43)
    0x32: VERY_LONG, // 9:50 (16:14)
    0x33: VERY_LONG, // 16:00 (16:53)
    0x41: MEDIUM, // 4:10 (6:38)
    0x42: MEDIUM, // 5:50
    0x43: LONG, // 9:50 (10:17)
    0x44: VERY_LONG, // 11:40 (14:57)
    0x45: LONG, // 3:10 (3:46) - this one gets a boost because the final bosses are ass
    0x46: SHORT, // 3:20 (5:10)
}

function AwardTrigger(
    award, 
    stage=STAGE_Any, 
    difficulty=DIFFICULTY_Any, 
    allow_harder=false,
    character=CHARACTER_Any
)
{
    // award: The ID of the award being checked
    // stage: The stage that the award must be awarded in. Defaults to STAGE_Any.
    // difficulty: The difficulty that the award must be awarded in. Defaults to DIFFICULTY_Any.
    // allow_harder: If difficulty is provided, and allow_harder is true, then the trigger works on the provided difficulty or higher. Defaults to false.
    // character: The character that must be played for the award to be awarded in. Defaults to CHARACTER_Any.

    // Match stage if provided
    stage_cond = always_true()
    if stage != STAGE_Any
    {
        stage_cond = byte(StageID) == stage
    }
    
    // Match difficulty if provided
    difficulty_cond = always_true()
    if difficulty != DIFFICULTY_Any
    {
        if allow_harder == true
        {
            // Include higher difficulties if desired
            difficulty_cond = Difficulty >= difficulty    
        }
        else
        {
            difficulty_cond = Difficulty == difficulty
        }
    }
    
    // Match character if provided
    character_cond = always_true()
    if character != CHARACTER_Any
    {
        character_cond = CharacterID == character
    }
    
    // Ignore FINAL_RESULT (except for awards for beating the game)
    OFFSET_clear_type = 0x1C
    ClearType = dword(StageClearedMenu + OFFSET_clear_type)
    clear_type_cond = ClearType != FINAL_RESULT
    if award == AWARD_RescuedEntireCity || award == AWARD_ClearVeryHardMode
    {
        clear_type_cond = ClearType == FINAL_RESULT
    }

    // Confirms we're actually on the stage cleared screen (for the right stage and difficulty)
    primary_condition = GameStatus == STATUS_StageCleared && 
                        stage_cond && 
                        difficulty_cond &&
                        character_cond &&
                        StageClearedMenu != NULL &&
                        clear_type_cond
                        
    // Now we're going to check for when the appropriate award appears up on screen
    secondary_condition = always_false()
    
    for i in range(0, 8 - 1)
    {
        OFFSET_award_id = 0x150
        award_info = dword(AwardInfo + i * 4)
        award_id = dword(award_info + OFFSET_award_id)
        OFFSET_award_shown = 0x2C
        stage_cleared_menu = StageClearedMenu
        award_shown = word(stage_cleared_menu + OFFSET_award_shown)
        
        award_shown_cond = prev(award_shown) != i && award_shown == i
        if i == 0
        {
            // we can't check for 0 because the menu already starts at showing 0
            // so we'll check a different value that says awards are being given out
            OFFSET_status = 0
            status = dword(stage_cleared_menu + OFFSET_status)
            award_shown_cond = prev(status) != SCM_STATUS_Awards && status == SCM_STATUS_Awards
        }
        
        cond = award_info != NULL &&
               award_shown_cond &&
               award_id == award
        secondary_condition = secondary_condition || cond
    }
    
    return primary_condition && secondary_condition
}

for difficulty in Difficulties
{
    for stage_id in StageLengths
    {
        achievement(
            title=format(
                "Record Time - {0} - {1}",
                Difficulties[difficulty],
                AchievementStageNames[stage_id]
            ),
            description=format(
                "Obtain the \"Record Time! Gold!\" award on the {0} difficulty on Stage {1}.",
                Difficulties[difficulty],
                LeaderboardStageIDs[stage_id]
            ),
            points=RecordTimePoints[difficulty][StageLengths[stage_id]],
            trigger=AwardTrigger(AWARD_RecordTimeGold, stage_id, difficulty)
        )   
    }
}

// BOSSES
// (cooler progression than just beating stages, since they mark the end of stages anyways)

// 4-5 needs special logic because it's a bad stage with 2 bad bosses
// Both bosses have 10k max HP so that can't even be used :( -- hopefully we can just check character position
BossNames = {
    0x11: "Blaze",
    0x21: "Inferno",
    0x22: "Angel Flare",
    0x23: "Firestorm",
    0x24: "Core/Tentacle",
    0x25: "Hellfire",
    0x31: "Death Pyre",
    0x32: "Helldriver",
    0x33: "Parasite Flame",
    0x41: "Tri-Blade",
    0x42: "Fatal Pulse",
    0x43: "Blister Flare",
    0x44: "Cremator",
}

BossAchievementTitles = {
    0x11: "Blaze of Glory",
    0x21: "Infernal Contraption",
    0x22: "I Could Be Your Angel",
    0x23: "Heated Meeting",
    0x24: "Bullet Hell",
    0x25: "He'll Fire Anyone",
    0x31: "Unarmed and Dangerous",
    0x32: "Ghost Rider",
    0x33: "Emotion Engine",
    0x41: "Let It Rip",
    0x42: "Stop, This Beat is Killing Me",
    0x43: "Crank That",
    0x44: "Assume the Party Escort Submission Position"
}

function GetBossHPCond(stage_id)
{
    // The >= 0x80000000 is to check for if boss HP goes into the negatives
    boss_hp_check = prev(BossHP) > 0 && (BossHP == 0 || BossHP >= 0x80000000)
    
    // Each boss is non-standardized and has its own structure and functions for logic.
    // SOME don't follow the convention of updating the display HP to 0 or negative when dying 
    // Sigh
    // Unfortunately, true boss HP is inaccessible in RA even if we wanted to read it due to the nature of bosses
    // being controlled by in-game tasks, which by the nature of the task-manager paradigm there is no static pointer path to them.
    // NOTE: tbh we might want to use this as a fallback condition universally maybe?
    //problematic_stages = [0x23, 0x31, 0x33, 0x44]
    //for stage in problematic_stages
    //{
    //    if stage == stage_id
    //    {
    //        // TODO: Investigate this boolean some more
    //        BossMaybeDead = dword(GetRealAddress(0x528904, 0x528A84, 0x528904))
    //        boss_hp_check = prev(BossMaybeDead) == 0 &&
    //                        BossMaybeDead == 1 &&
    //                        // Sanity check display HP of boss is under 5%
    //                        BossHP / BossMaxHP < 0.05
    //    }
    //}
    // TODO: Investigate this boolean some more
    BossMaybeDead = dword(GetRealAddress(0x528904, 0x528A84, 0x528904))
    fallback_check = prev(BossMaybeDead) == 0 &&
                     BossMaybeDead == 1 &&
                     // Sanity check display HP of boss is under 5%
                     BossHP / BossMaxHP < 0.05

    return (boss_hp_check || fallback_check) &&
           !(PlayerHP == 0 || PlayerHP >= 0x80000000) // Prevent the achievement from triggering if Dean "kills" the boss in the afterlife (i.e. while dying)
}

function RegularBossTrigger(stage_id)
{
    boss_hp_cond = GetBossHPCond(stage_id)
    return byte(StageID) == stage_id &&
           GameStatus == STATUS_Game &&
           prev(GameStatus) == STATUS_Game && // Try to prevent a false trigger when entering a new stage after soft-resetting another stage while in the boss
           boss_hp_cond &&
           // This is just a sanity check because boss max/current HP aren't zeroed out from exit until entering the game
           // (and it might also prevent triggers on death too?)
           BossMaxHP != 0
}

for stage_id in BossNames
{
    achievement(
        title=BossAchievementTitles[stage_id],
        description=format("Defeat {0}.", BossNames[stage_id]),
        type="progression",
        points=5,
        trigger=RegularBossTrigger(stage_id)
    )
}

// Jason Hunt & Bodyguard :)
// The two bosses have the same max HP, are fought at the same height, and have arenas which can't be contained
// within non-overlapping boxes. They're special boys. Very very good bosses. The only thing I could find that was accessible (i.e. part of a non-task data)
// which differs was the boss name (which changes in each language anyways).
// Anyways, we should be able to create a rotated 2D plane even within RA's limited mathematics, with a fairly simple slope
// as the two boss areas can be separated with a 45* plane.

// First position (near the line on Jason's side)
// X: 6787.07
// Z: -3129.25

// Second position (near the line on Bodyguard's side)
// X: 7742.54
// Z: -2316.61

// We take the interpolation of these two positions to see how we should transform the slope.
// X: 7264.805
// Z: -2722.93

// HINT: Plug (-x+7264.805)+(-y-2722.93)>0.0 or (-x+7264.805)+(-y-2722.93)<0.0 into Desmos
// Simplifying the above equation:
// (x + y) < 4541.875 for Jason's side, (x + y) > 4541.875 for bodyguard's side
// NOTE: For the above, x and z are taken from the 3d position and mapped to x and y on a 2d coordinate plane.
in_jason_arena = (PlayerPos["x"] + PlayerPos["z"]) < 4541.875

achievement(
    title="Don't Shoot the Messenger",
    description="Defeat Jason Hunt.",
    points=5,
    type="progression",
    trigger=RegularBossTrigger(0x45) &&
            in_jason_arena
)

achievement(
    title="I'll Guard Every Body!",
    description="Defeat Bodyguard.",
    points=5,
    type="progression",
    trigger=RegularBossTrigger(0x45) &&
            !in_jason_arena
)

// WIN CONDITIONS

AllowHigherDifficulty = {
    DIFFICULTY_Easy: 1,
    DIFFICULTY_Normal: 1,
    DIFFICULTY_Hard: 0,
    DIFFICULTY_VeryHard: 0,
}

OrHigherSuffix = ["", " or a higher difficulty mode"]

WinConditionAwards = {
    DIFFICULTY_Easy: AWARD_RescuedEntireCity,
    DIFFICULTY_Normal: AWARD_RescuedEntireCity,
    DIFFICULTY_Hard: AWARD_RescuedEntireCity,
    DIFFICULTY_VeryHard: AWARD_ClearVeryHardMode,
}

WinConditionAchievementTitles = {
    DIFFICULTY_Easy: "No More Fires!",
    DIFFICULTY_Normal: "No More Casualties!",
    DIFFICULTY_Hard: "I'm Ending This Right Here, Right Now!",
    DIFFICULTY_VeryHard: "I Hate Fire!",
}

WinConditionAchievementPoints = {
    DIFFICULTY_Easy: 5,
    DIFFICULTY_Normal: 10,
    DIFFICULTY_Hard: 25,
    DIFFICULTY_VeryHard: 50,
}

for difficulty in Difficulties
{
    achievement(
        title=WinConditionAchievementTitles[difficulty],
        description=format(
            "Clear {0} Mode{1}.",
            Difficulties[difficulty],
            OrHigherSuffix[AllowHigherDifficulty[difficulty]]
        ),
        type=if_else(difficulty == DIFFICULTY_Easy, "win_condition", ""),
        points=WinConditionAchievementPoints[difficulty],
        trigger=AwardTrigger(
            WinConditionAwards[difficulty], 
            difficulty=difficulty, 
            allow_harder=AllowHigherDifficulty[difficulty] == 1
        )
    )
}

// MISS CRIMSON
// (so we can make sure people fill out the cinema viewer)

achievement(
    title="Can This Be Called a Multiple Perspective Story?",
    description="Clear the game on any difficulty with Miss Crimson.",
    points=10,
    trigger=AwardTrigger(WinConditionAwards[DIFFICULTY_Easy], character=CHARACTER_MissCrimson)
)

// Misc. in-game awards

// Achieve Super Play
// NOTE: It isn't (just) a really good time -- gotta figure out what this is
achievement(
    title="A Super Great Friend to All",
    description="Achieve \"Super Play\" by achieving a gold record time, not using any firefighter support, and not using any recovery items in a stage.",
    points=4,
    trigger=AwardTrigger(AWARD_SuperPlay)
)

// No injuries
achievement(
    title="Never Say \"Casualties\"",
    description="Complete a stage with rescuing all people unharmed.",
    points=1,
    trigger=AwardTrigger(AWARD_EveryoneUnharmed)
)

// No continues
achievement(
    title="You Only Firefight Once",
    description="Complete a stage without using any continues.",
    points=2,
    trigger=AwardTrigger(AWARD_NoContinues)
)

// Rescue 50 people
achievement(
    title="Only 8 Billion More to Rescue",
    description="Rescue 50 people.",
    points=5,
    trigger=AwardTrigger(AWARD_Rescue50People)
)

// Achieve 1 mil extinguish points
achievement(
    title="Cooled Off",
    description="Achieve 1 million extinguish points.",
    points=10,
    trigger=AwardTrigger(AWARD_OneMillionExtinguishPoints)
)

// Achieve a rank of 'Hero'
function RankTrigger(_rank)
{
    OFFSET_Status = 0x0
    status = dword(StageClearedMenu + OFFSET_Status)
    OFFSET_Rank = 0x2E
    rank = dword(StageClearedMenu + OFFSET_Rank)
    
    return GameStatus == STATUS_StageCleared &&
           StageClearedMenu != NULL &&
           rank == _rank &&
           status == SCM_STATUS_AwardsDone &&
           prev(status) != SCM_STATUS_AwardsDone
}

achievement(
    title="Brave Firefighter",
    description="Achieve the rank of Hero by, in one campaign playthrough and on the Hard difficulty or higher, " +
                "obtaining 10 gold record times and no worse times, " +
                "rescuing all survivors with 45% health or more, " +
                "using no continues, " +
                "and obtaining 500,000 extinguish points.",
    points=100,
    trigger=RankTrigger(RANK_Hero)
)

// ACHIEVEMENTS END