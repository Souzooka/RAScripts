// Firefighter F.D.18
// #ID = 27515

function GetRealAddress(us_address, eu_address, jp_address)
{
    // TODO
    return us_address
}

GameStatus = dword(GetRealAddress(0x5A5108, 0x0, 0x0))
StageID = GetRealAddress(0x5A5118, 0x0, 0x0)
Difficulty = dword(GetRealAddress(0x5A51F8, 0x0, 0x0))
PlayerInitialMaxHealth = dword(GetRealAddress(0x5C4F90, 0x0, 0x0))
PlayerMaxHealth = dword(GetRealAddress(0x5C4F94, 0x0, 0x0))
PlayerHealth = dword(GetRealAddress(0x5C4F98, 0x0, 0x0))
CharacterID = dword(GetRealAddress(0x5A548C, 0x0, 0x0))

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
    0x6: "Dean McGregor",
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
    0: "Easy",
    1: "Normal",
    2: "Hard",
    3: "Very Hard",
}

// Because dividing by a runtime value is too high tech,
// we'll just copy the in-game RP 7 times, why not
CharacterMaxHealths = {
    0x0: 60000,
    0x1: 60000,
    0x2: 60000,
    0x3: (45000 - 10), // Tweak the value a little bit so rounding on RP display doesn't show 99% at full health
    0x4: 60000,
    0x5: 90000,
    0x6: 90000,
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
