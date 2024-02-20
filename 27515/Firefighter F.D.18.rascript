// Firefighter F.D.18
// #ID = 27515

NULL = 0

function GetRealAddress(us_address, eu_address, jp_address)
{
    // TODO
    return us_address
}

StageClearedMenu = dword(GetRealAddress(0x52AF00, 0x0, 0x0))
GameStatus = dword(GetRealAddress(0x5A5108, 0x0, 0x0))
StageID = GetRealAddress(0x5A5118, 0x0, 0x0)
Difficulty = dword(GetRealAddress(0x5A51F8, 0x0, 0x0))
CharacterID = dword(GetRealAddress(0x5A548C, 0x0, 0x0))
PlayerInitialMaxHealth = dword(GetRealAddress(0x5C4F90, 0x0, 0x0))
PlayerMaxHealth = dword(GetRealAddress(0x5C4F94, 0x0, 0x0))
PlayerHealth = dword(GetRealAddress(0x5C4F98, 0x0, 0x0))
// See note for 0x5a5178
LostItemsTemp = GetRealAddress(0x5A5188, 0x0, 0x0)
LostItemsPerm = GetRealAddress(0x5A5CD8, 0x0, 0x0)
AwardInfo = GetRealAddress(0x52AEE0, 0x0, 0x0)

// Enums
STATUS_SoftResetLoad = 2
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

DIFFICULTY_Easy = 0
DIFFICULTY_Normal = 1
DIFFICULTY_Hard = 2
DIFFICULTY_VeryHard = 3

AWARD_RecordTimeGold = 2
AWARD_RescuedEntireCity = 13
AWARD_ClearVeryHardMode = 14

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

main_menu_statuses = [STATUS_SoftResetLoad, STATUS_Initial, STATUS_Splash, STATUS_TitleMenu, STATUS_IntroCutsceneLoad, STATUS_IntroCutscene]
game_statuses = [STATUS_GameLoad, STATUS_Game, STATUS_GameCutsceneLoad, STATUS_GameCutscene, STATUS_StageClearedLoad, STATUS_StageCleared]

rich_presence_conditional_display(any_of(main_menu_statuses, x=>x==GameStatus), "ᵘˢ In the title menu.")
rich_presence_conditional_display(GameStatus == STATUS_CinemaViewer, "ᵘˢ Watching a cutscene in the Realtime Cinema Viewer.")
rich_presence_conditional_display(GameStatus >= STATUS_DebugStart, "ᵘˢ ⚠️ In a debug menu.")

for character_id in CharacterNames
{
    rich_presence_conditional_display(
        any_of(game_statuses, x=>x==GameStatus) && CharacterID == character_id, 
        "{0} {1} is {2} {3}. | {4} Difficulty | Max HP: {5}% | HP: {6}%",
        "ᵘˢ ",
        rich_presence_lookup("CharacterName", CharacterID, CharacterNames),
        rich_presence_lookup("StageActivity", byte(StageID), StageActivities),
        rich_presence_lookup("StageName", byte(StageID), StageNames),
        rich_presence_lookup("Difficulty", Difficulty, Difficulties),
        rich_presence_value("MaxHealth", PlayerMaxHealth * (100.0/CharacterMaxHealths[character_id]), "VALUE"),
        rich_presence_value("Health", PlayerHealth * (100.0/CharacterMaxHealths[character_id]), "VALUE")
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

function RecordTimeTrigger(stage_id, difficulty)
{
    OFFSET_clear_type = 0x1C
    ClearType = dword(StageClearedMenu + OFFSET_clear_type)

    // Confirms we're actually on the stage cleared screen (for the right stage and difficulty)
    primary_condition = GameStatus == STATUS_StageCleared && 
                        byte(StageID) == stage_id && 
                        Difficulty == difficulty &&
                        StageClearedMenu != NULL &&
                        ClearType != FINAL_RESULT
                        
    // Now we're going to check for when the "Record Time! Gold!" award appears up on screen
    secondary_condition = always_false()
    
    for i in range(0, 8 - 1)
    {
        OFFSET_award_id = 0x150
        award_info = dword(AwardInfo + i * 4)
        award_id = dword(award_info + OFFSET_award_id)
        OFFSET_award_shown = 0x2C
        stage_cleared_menu = StageClearedMenu
        award_shown = word(stage_cleared_menu + OFFSET_award_shown)
        
        cond = award_info != NULL &&
               award_shown == i &&
               prev(award_shown) != i &&
               award_id == AWARD_RecordTimeGold
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
            trigger=RecordTimeTrigger(stage_id, difficulty)
        )   
    }
}

// ACHIEVEMENTS END