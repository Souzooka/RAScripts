// Raw Danger! | Zettai Zetsumei Toshi 2: Itetsuita Kiokutachi
// #ID = 5616

NULL = 0

REGION_JP = 1
REGION_EU = 0

FRAMES_PER_SECOND = 30

function GetRegion() {
  // This is just some arbitrary byte in code that happens to be 1 in JP and 0 in EU
  return byte(0x348FAA)
}

function GetRealAddress(pal_address, jp_address) {
  // Does some funky arithmetic to calculate the address we should access for achievement logic
  // This may break if RA keeps its syntax and then implements 64-bit integer support, but should work if the achievements are re-exported...
  region_offset = jp_address - pal_address
  return pal_address + (region_offset * GetRegion())
}

// Memory values
Player = dword(GetRealAddress(0x6003A4, 0x5FEDA4))
function PlayerFromIndex(id) => dword(GetRealAddress(0x5eae00, 0x5E9800) + (id * 4))
CompassID = byte(GetRealAddress(0x48FAE8, 0x48E4E8))
BodyHeat = float(Player + 0x370)
WetLevel = word(GetRealAddress(0x64781C, 0x644FDC))
Flags = GetRealAddress(0x609470, 0x607E70)
MapObjs = GetRealAddress(0x492460, 0x490E60)
MapTimeFrames = dword(GetRealAddress(0x48F49C, 0x48DE9C))
LoadedMapPack = dword(GetRealAddress(0x48F4F0, 0x48DEF0))
CutsceneFlag = byte(GetRealAddress(0x48F900, 0x48E300))
// 24-bit bitset which records all endings seen during one playthrough
// (I did check and this does properly zero-out during new game)
EndingBitset = GetRealAddress(0x67DDB6, 0x67B576)
GameMode = byte(GetRealAddress(0x67DDBA, 0x67B57A))
Difficulty = byte(GetRealAddress(0x67DDBB, 0x67B57B))
InGameTime = dword(GetRealAddress(0x67DDC0, 0x67B580)) // number of frames, divide by 30 for seconds
CurrentMenu = dword(GetRealAddress(0x48F604, 0x48E008))
GameResultInfo = GetRealAddress(0x7173A0, 0x714AE0) // this is probably actually meta information for the game results screen but I would have to investigate
IsaacIntroDrivingGrade = dword(GetRealAddress(0x48EDC0, 0x48D818))
// The ItemController holds multiple buffers of item instances and meta information for how those items are being handled
// (e.g. who "owns" those items and has them in their inventory or equipped, etc.)
ItemController = GetRealAddress(0x622000, 0x61F900)
CreditsScript = dword(GetRealAddress(0x48FD74, 0x48E76C))

// Map IDs
AreaID = dword(GetRealAddress(0x492450, 0x490E50))
LevelID = dword(GetRealAddress(0x492454, 0x490E54))
SublevelID = dword(GetRealAddress(0x492458, 0x490E58))
GateID = dword(GetRealAddress(0x49245C, 0x490E5C))
function MapIDPrev() => prev(AreaID) * 10000 + prev(LevelID) * 100 + prev(SublevelID)
function MapWithGateIDPrev() => MapIDPrev() * 100 + prev(GateID)
function MapID() => AreaID * 10000 + LevelID * 100 + SublevelID
function MapWithGateID() => MapID() * 100 + GateID
// Alternate set of addresses for map IDs, usually these are used for menus and such
AreaIDBackup = dword(GetRealAddress(0x492440, 0x490E40))
LevelIDBackup = dword(GetRealAddress(0x492444, 0x490E44))
SublevelIDBackup = dword(GetRealAddress(0x492448, 0x490E48))
GateIDBackup = dword(GetRealAddress(0x49244C, 0x490E4C))
function MapIDBackupPrev() => prev(AreaIDBackup) * 10000 + prev(LevelIDBackup) * 100 + prev(SublevelIDBackup)
function MapIDBackup() => AreaIDBackup * 10000 + LevelIDBackup * 100 + SublevelIDBackup
function MapIDBackupWithGateID() => AreaIDBackup * 10000 + LevelIDBackup * 100 + SublevelIDBackup

// General enums
PLAYER_Joshua = 0
PLAYER_Amber = 1
PLAYER_Isaac = 2
PLAYER_Paige = 3
PLAYER_Ivan = 4
PLAYER_Keith = 5
PLAYER_Stephanie = 6
PLAYER_Aiden = 8
PLAYER_Sophia = 10
PLAYER_Sierra = 11
PLAYER_Emily = 19
PLAYER_SantaGeo = 60

GAMEMODE_Normal = 0
GAMEMODE_FreeMode = 1

DIFFICULTY_Easy = 0
DIFFICULTY_Normal = 1
DIFFICULTY_Hard = 2

MENU_Title = 11
MENU_LdGameOv = 13 // Dunno
MENU_LoadGame = 14 // Dunno
MENU_Tutorial = 17
MENU_MemoryCardMenu = 18
MENU_GameLoad = 19 // This is actually the one from loading from the MC menu lmao
MENU_Game = 21
MENU_GameOver = 22
MENU_ItemMenu = 23 // Also applies for picking up items (which we definitely need for the Small Opal)
// I dunno what IRESENT (that's the internal string) means; it's used for the item pickup prompt for Isaac's Flawed Sapphire, for whatever reason...
MENU_IRESENT = 24
MENU_Result = 32

// NOTE: In general, the Free Mode (chapter select) sets flags which allow players
// to be able to achieve shorter endings (which would require set up from a previous chapter).
// For example, Amber's ending where she escapes with the rescue crew requires Joshua to have removed
// the iron bar while he passed through the Downtown Station. I want players to have set these events in motion,
// so I'll be excluding endings which specifically require setup in previous chapters from being achievable in Free Mode.
ENDING_1A = 0 // Joshua - Reaching McMurrough's heli
ENDING_1B = 1 // Joshua - Leaving with Stephanie on overpass
ENDING_1C = 2 // Joshua - Leaving without Stephanie on overpass
ENDING_2A = 3 // Amber - Normal ending at Cascade Dam
ENDING_2B = 4 // Amber - Escape with rescue team in downtown station (requires Joshua to remove iron bar)
ENDING_3A = 5 // Isaac - Normal ending
ENDING_3B = 6 // Isaac - Have Amber remove the oil tanker pipe, then have Isaac interact with the taxi after the explosion in the police station area
ENDING_4A = 7 // Paige - Make it to the roof (whether or not Emily is saved does not matter)
ENDING_4B = 8 // Paige - During the collapsed stairs cutscene, yell at Emily about a dozen or so times.
ENDING_5A = 9 // Ivan - Destroy Echidna
ENDING_5B = 10 // Ivan - Return Echidna to Apolon
ENDING_5C = 11 // Ivan - Have Joshua dislodge the stuck train in Central Geo, then have Ivan fail to catch the drifting container
ENDING_6A_J = 12 // Joshua (Final Chapter) - Normal Ending
ENDING_6A_K = 13 // Keith (Final Chapter; leave early as Joshua for his chapter) - Sophia survives police station (i.e. no ending 3-B)
ENDING_6B_K = 14 // Keith (Final Chapter) - Sophia dies at police station (ending 3-B)

// General functions
function TimeToFrames(hours=0, minutes=0, seconds=0)
{
    return SecondsToFrames(hours * 3600 + minutes * 60 + seconds)
}
function SecondsToFrames(seconds)
{
    // NOTE: seconds should be an int here, not a float
    return seconds * FRAMES_PER_SECOND
}
function GetInGameTime(player_id=-1)
{
    if (player_id == -1)
    {
        return InGameTime
    }
    
    SIZE_GameResultInfo = 0x18
    OFFSET_InGameTime = 0x0
    return dword(GameResultInfo + (player_id * SIZE_GameResultInfo) + OFFSET_InGameTime)
}
function StartCampaign(player_id)
{
    start_map_ids = {
        PLAYER_Joshua: 01000000,
        PLAYER_Amber: 02020000,
        PLAYER_Isaac: 03010000,
        PLAYER_Paige: 04020000,
        PLAYER_Ivan: 05010000,
    }

    return MapWithGateID() == start_map_ids[player_id]
}
function CancelCampaign()
{
    return CurrentMenu == MENU_Title || CurrentMenu == MENU_GameOver
}
function StartAndNeverLeaveCampaignOrDie(player_id)
{
    return once(StartCampaign(player_id)) && never(CancelCampaign())
}
function CreditsStarted()
{
    // I know this gets set to NULL every time the map changes, and
    // it should also get set to NULL when exiting to the title or going to the game result screen I think
    // so this should be fine to check even if you immediately get the easy achievement, and then exit and load up a hard difficulty
    // save (which you shouldn't have anyways) at the last checkpoint
    return CreditsScript != NULL && prev(CreditsScript) == NULL
}
function ItemNowExists(item_id)
{
    // This checks if an item came into existence in the world. This does NOT check if a specific player has an item in their inventory
    // or equipped (we just don't have the power to do that in this script), just that now there is an existing item instance with the specific item ID.
    // very very very very performant code here don't worry, better than Lua probably -- just checking for a length change and then the 
    // top element of the buffer isn't something our CPUs our optimized for, we'll put these 128 delta checks in an AVX512 instruction
    buffer_capacity = 0x80
    SIZE_ItemWork = 0x44
    OFFSET_ItemID = 0x14
    OFFSET_ItemBuf0 = 0x0
    
    // This code iterates over every item instance in the ItemController's main buffer to generate a condition to see if any items became the item indicated by item_id.
    curr = ItemController + OFFSET_ItemBuf0
    requirement = always_false()
    for i in range(0, buffer_capacity - 1)
    {
        curr_item_id = word(curr + OFFSET_ItemID)
        requirement = requirement || (curr_item_id == item_id && prev(curr_item_id) != item_id)
        curr = curr + SIZE_ItemWork
    }
    
    return requirement
}
function PlayerEnteredBoundingBox(player, x1, y1, z1, x2, y2, z2)
{
    // Checks if a player enters a (unrotated only, sorry :() 3D bounding box
    player_x = PlayerGetX(player)
    player_y = PlayerGetY(player)
    player_z = PlayerGetZ(player)
    in_box = player_x >= x1 && player_x <= x2 &&
             player_y >= y1 && player_y <= y2 &&
             player_z >= z1 && player_z <= z2
    // If we want to check specifically entering (though it's probably not necessary here (and RA syntax hates this!! - generates tons of alt groups))
    //was_outside_box = prev(player_x) < x1 || prev(player_x) > x2 ||
    //                  prev(player_y) < y1 || prev(player_y) > y2 ||
    //                  prev(player_z) < z1 || prev(player_z) > z2
    return in_box
}
function MapTransitioned(to_map, from_map)
{
    // Here's another case where we have to use the back up map ID, as that is actually set here first before we start loading
    // So we can check to make sure we aren't on the MC Menu (the normal map ID is set in MENU_GameLoad in both loading a save file and
    // normal transitions, so it's difficult to check that)
    return CurrentMenu != MENU_MemoryCardMenu && MapIDBackup() == to_map && MapIDBackupPrev() == from_map
}
function IsFreeMode()
{
    return GameMode == GAMEMODE_FreeMode
}

function IsInTutorial()
{
    return MapID() == 019900
}

function IsInCutscene()
{
    return CutsceneFlag == 1
}

function IsInMenuTransition(to_menu)
{
    return prev(CurrentMenu) != to_menu && CurrentMenu == to_menu
}

//function IsTransitioningToResult(map_id=-1)
//{
//    is_on_map = true
//    if (map_id != -1)
//    {
//        // We have to use the backup map value as the results transition overwrites the current map value
//        // and saves the last map value to the backup
//        is_on_map = (is_EU() && EU_MapIDBackup() == map_id) || (is_JP() && JP_MapIDBackup() == map_id)
//    }
//    return IsInMenuTransition(MENU_Result) && is_on_map
//}

function LoadProtection()
{    
    return CurrentMenu == MENU_Game ||     // Normal game state
           CurrentMenu == MENU_ItemMenu || // Needed for some other Jewelry
           CurrentMenu == MENU_IRESENT ||  // Needed for Isaac's Jewelry
           CurrentMenu == MENU_Result      // Needed for properly recording Jeweled Suit
    // Checking that we're not in a menu (or rather, just in the normal game mode) should work fine for most achievements,
    // though some other triggers (like for the map transition logic) may have its own special logic.
    //return (is_EU() && EU_CurrentMenu == MENU_Game) ||
    //       (is_JP() && JP_CurrentMenu == MENU_Game)
    // NOTE: This still doesn't work to both guard loads and ensure map transitions work
    // (we can likely check the "gate" ID for map transitions, as the entry checkpoint ID will almost always be 0 and something different for save points)
    //return PlayerExists()
    
    // Returns true if we aren't loading a map
    // (MapTimeFrames is 0 in title screen, load screens, etc.)
    //MIN_FRAMES = 3
    
    //return (is_EU() && EU_MapTimeFrames >= MIN_FRAMES) ||
    //       (is_JP() && JP_MapTimeFrames >= MIN_FRAMES)
}

// Map Objects
function MapObjGet(index)
{
    MAPOBJ_SIZE = 0x2A0
    return MapObjs + (index * MAPOBJ_SIZE)
}

function MapObjIsActive(mapobj)
{
    ACTIVE_OFFSET = 0xF
    return byte(mapobj + ACTIVE_OFFSET)
}

// Players
function PlayerExists()
{
    return Player != NULL
}
function PlayerExistsId(player_id)
{
    return PlayerFromIndex(player_id) != NULL
}
function PlayerGetX(player)
{
    // Using the compass, +X is East and -X is West
    return float(player + 0xA0)
}
function PlayerGetY(player)
{
    // Up and down; negative values higher (yeah I dunno why either)
    return float(player + 0xA4)
}
function PlayerGetZ(player)
{
    // Using the compass, +Z is North and -Z is South
    return float(player + 0xA8)
}
function PlayerGetH(player)
{
    return float(player + 0xB0)
}
function PlayerGetP(player)
{
    return float(player + 0xB4)
}
function PlayerGetR(player)
{
    return float(player + 0xB8)
}
function PlayerGetVehicle(player)
{
    return dword(player + 0x1854)
}

// Flags
// Some general notes about flags
// 0-5999 - Level specific flags (may be referenced in later levels) (0-1999 are for tutorial/Chapter 1, 2000-2999 for 2, etc. in general)
// 6000-6999 - Stephanie-related flags
// 7000-7999 - Significant flags which have implications across chapters
// 20000-29999 - Epilogue/Map note flags
// 30000-39999 - Cutscene skip flags (these belong to the SYSTEM save - don't use these)
// (39000+ seem to be also used for Ivan personality markers -- I'll have to make sure these are initialized properly)
// 40000-42099 - Also SYSTEM save flags? Unsure
function FlagGet(flag)
{
    // Returns a memory accessor for a particular game flag
    return bit(flag % 8, Flags + flag / 8)
}
function FlagGetBool(flag)
{
    // More abstracted version of FlagGet; returns a boolean value representing the flag's state and not a memory accessor
    return FlagGet(flag) == 1
}
function FlagChangedToSet(flag) => prev(FlagGet(flag)) == 0 && FlagGet(flag) == 1
                                   
                                   
// Endings
function EndingGet(flag)
{
    return bit(flag % 8, EndingBitset + flag / 8)
}
function EndingGetBool(flag)
{
    return EndingGet(flag) == 1
}
function EndingChangedToSet(flag) => prev(EndingGet(flag)) == 0 && EndingGet(flag) == 1

// Jewelries
function JewelryGet(player_id)
{
    SIZE_GameResultInfo = 0x18
    OFFSET_JewelryObtained = 0x16
    return byte(GameResultInfo + (player_id * SIZE_GameResultInfo) + OFFSET_JewelryObtained)
}
function JewelryGetBool(player_id)
{
    return JewelryGet(player_id) != 0
}
function JewelryChangedToSet(player_id) => prev(JewelryGet(player_id)) == 0 && JewelryGet(player_id) != 0


// ACHIEVEMENTS START

// PROGRESSION/CAMPAIGN

// TUTORIAL

// Tutorial grading flags are set after the last room is completed, and reset when starting the tutorial
// Using either the points flag or rank flag is effective
// 0 points = 120
// 10 points = 119
// 20 points = 118
// 30 points = 117
// 40 points = 116
// 50 points = 115
// 60 points = 114
// 70 points = 113
// 80 points = 112
// 90 points = 111
// 100 points = 110
// Adequate rank (0+ points) = 76
// Satisfactory rank (25+ points) = 75
// Average rank (50+ points) = 74
// Elite rank (75+ points) = 73
// Master rank (100 points) = 72
// GRADE REQUIREMENTS:
// (failing the first req. will give you 10 points, failing the second will always give you 0 points)
//
// ROOM 01:
// * Beat room in under 141 frames (4.6667 seconds or better) (おやおや、どうしたのかな？)
// * Beat room in under 2701 frames (90 seconds or better) (向いてないんじゃない？　アクションゲーム)
//
// ROOM 02:
// * Beat room in under 176 frames (5.8333 seconds or better) (おやおや、どうしたのかな？)
// * Don't die from TP loss
//
// ROOM 03:
// * Beat room in under 451 frames (15 seconds or better) (おやおや、どうしたのかな？)
// * Beat room in under 2701 frames (90 seconds or better)
//
// ROOM 04:
// * Beat room in under 1201 frames (40 seconds or better) (おやおや、どうしたのかな？)
// * Don't fall down holes 3 or more times (you can handle this one, come on)
//
// ROOM 05:
// * Beat room in under 621 frames (20.6667 seconds or better) (おやおや、どうしたのかな？)
// * Don't get knocked back by rushing water (i.e. in either cling section)
FLAG_MasterGrade = 72
FLAG_GradingOver = 79
// Flags which mark grading failures in each tutorial room
FLAG_BadGrades = [17, 18, 28, 29, 38, 39, 49, 140, 57, 58]
// 10 point and 0 point stamp flags for each room
FLAG_BadStamps = [20028, 20029, 20031, 20032, 20034, 20035, 20037, 20038, 20040, 20041]
// 20 point stamp flags for each room
FLAG_GoodStamps = [20027, 20030, 20033, 20036, 20039]
function TRIGGER_DisasterPrepared() 
{
    start = once(LoadProtection() && IsInTutorial())
    cancel = never(CurrentMenu == MENU_Tutorial || any_of(FLAG_BadStamps, FlagGetBool))
    submit = trigger_when(FlagGetBool(FLAG_MasterGrade) && FlagChangedToSet(FLAG_GradingOver))
    
    return start && cancel && submit
}
achievement(
    id=392855,
    title="Disaster-Prepared",
    description="Obtain the rank of 'Master' in the tutorial.",
    points=5,
    trigger=TRIGGER_DisasterPrepared()
)

// JOSHUA
// M1_01_00 (Underground banquet hall (pre-disaster))

// This is a bit cheeky but other solutions unfortunately did not pan out
// Since Geo never leaves the banquet hall (besides being repositioned for this cutscene), we can check his position for this.
// This'll trigger the achievement at the beginning of the cutscene instead of the end but it's the best I got for now.
// (I don't think checking if he leaves this area would work, as I think he just gets set inactive and stashed away in the ether
// instead of actually being moved back -- that'll happen when Joshua approaches the banquet hall again)
function TRIGGER_HiImGeo()
{
    // x = 27.0 is about where the hall outside the banquet hall (where the player sets down plates)
    // and the hallway outside the kitchen connect
    geo_x = PlayerGetX(PlayerFromIndex(PLAYER_SantaGeo))
    return MapID() == 010100 && prev(geo_x) < 27.0 && geo_x >= 27.0
}

// The box for the Geo costume is behind a shelf in the kitchen (you have to crawl into that area to reach it)
achievement(
    id=392823,
    title="Hi, I'm Geo!",
    description="In the underground convention center, find a costume of Geo and try it on as Joshua.",
    points=1,
    trigger=TRIGGER_HiImGeo()
)

// Talk to a woman on the ground in the banquet hall looking for her contact lens, then find the lens a bit in front of her
// and GIVE the lens to the woman
FLAG_ReturnedContactLens = 21172
achievement(
    id=392824,
    title="I Have Special Eyes",
    description="In the underground convention center, find and return a woman's lost contact lenses as Joshua.",
    points=1,
    trigger=LoadProtection() && FlagChangedToSet(FLAG_ReturnedContactLens)
)

// Talk to the moving chef in the kitchen (not the head chef) and then retrieve his recipe
FLAG_ReturnedItalianRecipe = 996
achievement(
    id=392825,
    title="Occupational Hazard",
    description="In the underground convention center, return the Italian Recipe to the chef as Joshua.",
    points=1,
    trigger=LoadProtection() && FlagChangedToSet(FLAG_ReturnedItalianRecipe)
)

// Talk to one of the waiters near the banquet hall door to the kitchen BEFORE bringing food to Stephanie
// and he'll mention his locker is B-1 -- just go examine the locker afterwards.
FLAG_TookStephaniePhoto = 1001
achievement(
    id=392831,
    title="Candid Caper",
    description="In the underground convention center, find and pick up a picture of Stephanie as Joshua.",
    points=2,
    trigger=LoadProtection() && FlagChangedToSet(FLAG_TookStephaniePhoto)
)

// Is set after finding hole in wall regardless of if we look through it or not (and you wouldn't look through it, of course)
// Talk to the chef tucked away in the corner of the kitchen (run all the way through and around the center bit)
// then examine the peeled poster in the male locker room
FLAG_FoundPeepHole = 990
achievement(
    id=392828,
    title="Peeping Josh",
    description="In the underground convention center, find a (small) hole in the wall as Joshua.",
    points=3,
    trigger=LoadProtection() && FlagChangedToSet(FLAG_FoundPeepHole)
)

// We have three options when talking to the drinker (to agree, to say we're busy, or to refuse).
// The last two will set flag 1063, but also one of 1064 and 1065. We'll want to make sure 1063 is set but neither of the others.
// Simply talk to the drinking man at a table to the right of the center table AFTER bringing food, then agree to bring them wine and do so
// (you can bring wine after talking, or deliver the wine immediately if the cart is close enough to him)
FLAG_DrinkerEventDone = 1063
FLAG_DrinkerIgnoredByJoshua = 1064
FLAG_DrinkerWasRefusedDrinks = 1065
achievement(
    id=392826,
    title="Maybe They'll Have Free Drinks There",
    description="In the underground convention center, serve a drunk guest a few more bottles of wine as Joshua.",
    points=1,
    trigger=LoadProtection() && 
            FlagChangedToSet(FLAG_DrinkerEventDone) && 
            !FlagGetBool(FLAG_DrinkerIgnoredByJoshua) && 
            !FlagGetBool(FLAG_DrinkerWasRefusedDrinks)
)

// After delivering food, go to the outer area and talk to Stephanie to kick this one off
FLAG_FoundLostChildMother = 6003
achievement(
    id=392827,
    title="Good Guy Josh",
    description="In the underground convention center, help Stephanie find the mother of the lost child as Joshua.",
    points=1,
    trigger=LoadProtection() && FlagChangedToSet(FLAG_FoundLostChildMother)
)

// Pretty simple -- after talking to Sophia after picking up the water, the outfit is in a box with red tape near a vending machine in the locker room hallway.
// Give that outfit to her and you're done.
FLAG_GaveSophiaOutfit = 915
achievement(
    id=392829,
    title="Behind the Scenes",
    description="In the underground convention center, find and give an investigative reporter a Waitress Uniform as Joshua.",
    points=2,
    trigger=LoadProtection() && FlagChangedToSet(FLAG_GaveSophiaOutfit)
)

// Go left out of the kitchen after picking up the water, watch the cutscene, then examine the water pipe to refill the pitcher
FLAG_RoomTempWaterNoSpill = 21179
achievement(
    id=392830,
    title="I Only Drink Cascade Mineral Water",
    description="In the underground convention center, refill the water pitcher with water from the leaking water pipe and deliver it to the mayor without spilling too much as Joshua.",
    points=2,
    trigger=LoadProtection() && FlagChangedToSet(FLAG_RoomTempWaterNoSpill)
)

// M1_01_01 (Destroyed banquet hall)
// Pretty straightforward here, probably want just one progression achievement for escaping the entire setpiece of the underground banquet hall

achievement(
    id=392832,
    title="Out of the Frying Pan",
    description="Escape the underground convention center as Joshua.",
    points=5,
    trigger=MapTransitioned(010105, 010101)
)

// M1_01_05 (Downtown Geo Area)
// Just getting the jewelry here, I think
// Also perhaps walking on the electrified water without getting shocked? Not sure how to make that a concise achievement.
// That'd require beating the game (to unlock the Collection feature and be able to take out equipment from recycle bins, and then to use the Rubber Boots)
// Pretty neat detail that didn't require coding in at all lmao

// Inside the PAPCO building, talk to the jewelry thief then GIVE her a Heating Pad, then talk to her once more
achievement(
    id=392833,
    title="Cold as Ice",
    description="Obtain the Cheap Pearl.",
    points=4,
    trigger=LoadProtection() && JewelryChangedToSet(PLAYER_Joshua)
)

// M1_02_00 (Downtown Station Area)
// Maybe lighting the wreathes on fire? It does create a little segment later on so it'd be good to spotlight

// Have the lighter equipped and move through the area after the underground shutter you have to open with the Speed Handle
FLAG_JoshuaSetOffFireAlarm = 7002
achievement(
    id=392834,
    title="Hot Like Fire",
    description="In the Downtown Station Area, light a band of wreathes on fire as Joshua.",
    points=3,
    trigger=LoadProtection() && FlagChangedToSet(FLAG_JoshuaSetOffFireAlarm)
)

// It'd be nice to maybe have an achievement for finding and equipping every Santa outfit piece, but considering that all existing items
// are in a giant buffer and have some properties that indicate how they're being used (e.g. equipped on Joshua) I don't think it's particularly
// practical for RAScript to access them. Equipment isn't directly accessible by the game -- instead there is a static ItemController which manages every existing
// item instance currently in the game, including those equipped by the player/NPCs, and there's a ton of complicated logic involved in iterating over that.
// For those brave enough, the function 0x1B5720 (PAL) accepts two arguments -- the index of the player and the equipment type, and returns the item ID of the equipped item (or -1 if nothing in that slot)
// ADDENDUM: Actually, maybe this could be done a slightly sneaky way? Perhaps making 4 bounding boxes and checking if the player enters the item pickup state,
// though of course they can decline picking up the item... something to think about maybe.

// M1_03_00 (West Junction)
// Free progression achievement for getting off the bus here, I think, along with making a meal.
// There's a funny option for taking the hanging chef's hat, but all options in that dialogue actually just play the same animation so that's probably near impossible to detect
// Was thinking about an achievement for Stephanie referring to you as her boyfriend here but recreating the logic for determining Stephanie's affection for you
// (which is known by me - the logic is at 0x3409B0) -- now that there's region abstraction via arithmetic implementing this function might actually work

FLAG_WestJunctionIntroDone = 1300
achievement(
    id=392835,
    title="We Just Gotta Wait",
    description="Arrive at the evacuation point in West Junction as Joshua.",
    points=5,
    trigger=LoadProtection() && FlagChangedToSet(FLAG_WestJunctionIntroDone)
)

// Pick up some food and then talk to the chef on the other side of the road from where you start, ez
FLAG_WestJunctionCookedMeal = 1323
achievement(
    id=392836,
    title="Popup Chef",
    description="At the West Junction evacuation point, cook a meal with the chef as Joshua.",
    points=3,
    trigger=LoadProtection() && FlagChangedToSet(FLAG_WestJunctionCookedMeal)
)

// M1_04_00 (Historic Rest Area)
// Anything of note here? You just kind of pass through here...
// There's a cool jetski though - and sunglasses!! those are pretty cool

// M1_05_00 (East Junction)

// Rescuing Stephanie triggers the heli to approach
FLAG_EastJunctionHelicopterApproaching = 1501
achievement(
    id=392837,
    title="I Need a Hero",
    description="At the East Junction, rescue a trapped woman and girl as Joshua.",
    points=5,
    trigger=LoadProtection() && FlagChangedToSet(FLAG_EastJunctionHelicopterApproaching)
)

// Achieve ending 1-B or 1-C
// (Leave on helicopter with or without Stephanie)
achievement(
    id=392838,
    title="Future Regret",
    description="Obtain either Ending 1-B or 1-C.",
    points=10,
    trigger=LoadProtection() && any_of([ENDING_1B, ENDING_1C], EndingChangedToSet)
)

// M1_05_01 (Angelina Area)

// While this one may seem completely free (and it is *pretty* free) this requires Stephanie to like you enough to
// ask you to call her "Steph" (in English) or by her first name (in Japanese) so you can lock yourself out of
// this choice by not being nice enough to Stephanie.
FLAG_StephanieNickName = 6029
achievement(
    id=392839,
    title="Social Link Rank Up",
    description="Adopt a new name for Stephanie as Joshua.",
    points=1,
    trigger=LoadProtection() && FlagChangedToSet(FLAG_StephanieNickName)
)

// Also missable (even if you go along this route) since you can talk to Stephanie twice to skip the whole cooking thing
// Ingredients and the large pot are in the back of the restaurant
FLAG_StephanieOnePlate = 6035
FLAG_StephanieBothPlates = 6036
FLAG_StephanieNoPlates = 6037
achievement(
    id=392840,
    title="Kitchen Nightmare",
    description="Using the large pot, cook a meal for yourself and/or Stephanie inside the Angelina restaurant as Joshua.",
    points=3,
    trigger=LoadProtection() && 
            any_of([FLAG_StephanieOnePlate, FLAG_StephanieBothPlates, FLAG_StephanieNoPlates], FlagChangedToSet)
)

// M1_05_02 (Mission Care Center Area)

FLAG_ArriveMissionCareCenter = 1580
achievement(
    id=392841,
    title="We May Be Too Late...",
    description="Arrive at the Mission Care Center with Stephanie as Joshua.",
    points=5,
    trigger=LoadProtection() && FlagChangedToSet(FLAG_ArriveMissionCareCenter)
)

// M1_06_00 (Del Ray Inner Park)

// NOTE: If you refuse to help the person near the collapsed help, you won't have the opportunity to bring them soup
// So you'll have to make sure to carry them too.
FLAG_SpilledTooMuchSoup = 1611
FLAG_DeliveredSoup = 1621
achievement(
    id=392842,
    title="Waiting is the Hardest Part",
    description="Assist in rescuing a collapsed person in Del Ray Inner Park as Joshua, then bring them food without spilling too much.",
    points=3,
    trigger=LoadProtection() && FlagChangedToSet(FLAG_DeliveredSoup) && !FlagGetBool(FLAG_SpilledTooMuchSoup)
)

// This achievement requires telling the park owner "Don't give up!"
// Though if you want to change it to just talking to the ringmaster,
// Using just flag 1648 should work fine.
// You get a Pirate Hat out of this conversation, which I think is the only way to acquire it (actually, Ivan might find one on a highway overpass...).
FLAG_RingmasterDontGiveUp = 1645
FLAG_RingmasterConversationOver = 1648 // Just for achievement pop timing purposes (this should place the redeem after the last subtitle)
achievement(
    id=392843,
    title="Flotsam's Circus Troupe",
    description="Convince the ringmaster in Del Ray Inner Park to keep pursuing his passion as Joshua.",
    points=2,
    trigger=LoadProtection() && FlagGetBool(FLAG_RingmasterDontGiveUp) && FlagChangedToSet(FLAG_RingmasterConversationOver)
)

// See the cutscene where Stephanie reunites with her mother
FLAG_SawMotherCutscene = 21635
achievement(
    id=392844,
    title="Conflict Resolution",
    description="Reunite Stephanie with her mother as Joshua.",
    points=5,
    trigger=LoadProtection() && FlagChangedToSet(FLAG_SawMotherCutscene)
)

// M1_07_00 (Central Geo Distict)
// Anything of interest here? Maybe knocking down the hanging trains and surviving...

// M1_09_00 (Media Tower Area)
// Just the ending here... but we'll revisit this map, in the epilogue!

achievement(
    id=392845,
    title="Let's Go Home, Princess",
    description="Obtain Ending 1-A.",
    points=10,
    trigger=LoadProtection() && EndingChangedToSet(ENDING_1A)
)

// AMBER

// M2_01_00 (Landmark Apartments (flashback))
// Not much to do here

// M2_02_00 (Police Station Area)
// Actually pretty straightforward here despite the complexity of this area
// Just one achievement for now for the smart route (though the alternate route of escape
// involves blowing up a fuel tanker, which sets up an ending/achievements later)

// There's a room in the garage with some items, including an Officer's Skirt and Officer's Suit.
// Have these equipped and patrolling guards will ignore you (but arrest you if you try to talk to them)
// You can then talk to the gate guard for him to let you out.
FLAG_AmberGateEscape = 2251
achievement(
    id=392846,
    title="Master of Disguise",
    description="Escape out of the gate of the Police Station parking lot as Amber.",
    points=3,
    trigger=LoadProtection() && FlagChangedToSet(FLAG_AmberGateEscape)
)

// M2_03_00 (Downtown Geo Area)
// Nothing too exciting here, either you snitched on Amber (and she pretty much skips to the end of the area)
// or you go around the outskirts of the area. Either way you meet the detective at the end then escape,
// and an achievement is probably fitting for that but we'll move it to the next area

// M2_04_00 (Downtown Station Area)

// Triggers after the conversation at the top of the escalator (hey, free progression points)
FLAG_AidanIntroCutsceneDone = 22404
achievement(
    id=392847,
    title="Just Another Day in Paradise",
    description="Escape the police detective in the Downtown Geo Area as Amber.",
    points=3,
    trigger=LoadProtection() && MapTransitioned(020400, 020300)
)

// Cross the ladder to the rescue crew after the station starts collasping (requires Josh to remove iron bar)
// Translator's note: Saiban is "court trial" in Japanese
achievement(
    id=392848,
    title="Aidan Today, Saiban Tomorrow",
    description="Obtain Ending 2-B [No Free Mode].",
    points=10,
    trigger=LoadProtection() && EndingChangedToSet(ENDING_2B) && !IsFreeMode()
)

// M2_05_00 (Hudson Tunnel Area)
// Fun fact: The woman trying to get across the bridge in the cutscene has an internal name of Maya Randall, and 刈谷 美津子
// in Japanese (Kariya Mitsuko (?)). Guess her role was relegated to cut content like a lot of stuff in this game.

// No flags to check here, but it does change the checkpoint. We should expect the checkpoint to always be 0 and become 1 here.
// If not, hey, you must be good at breaking this game. Good job. We'll check NOT 1 -> 1 just to be sure.
achievement(
    id=392849,
    title="Hot Pursuit",
    description="Escape the police detective again in the Hudson Tunnel Area as Amber.",
    points=3,
    trigger=LoadProtection() && MapID() == 020500 && GateID == 1 && prev(GateID) != 1
)

// Give an umbrella (you can get one from the police station parking area) to the jewelry thief (she's near an entrance to the underground tunnel on the bridge itself)
achievement(
    id=392854,
    title="When's This Rain Gonna Stop?",
    description="Obtain the Small Opal.",
    points=4,
    trigger=LoadProtection() && JewelryChangedToSet(PLAYER_Amber)
)

// Interact with Ivan in the Hudson Tunnel and have Aidan carry him
// Nothing particularly available to check to time this achievement well,
// but we can just check Ivan's Y value (since when he's being carried away by rescue crew,
// that's when he'll be at the highest point he can be)
FLAG_RescuedIvan = 7026
function TRIGGER_TooMuchEggnog() 
{
    // Not sure exactly what Y level he's at when carried, but Y=0 is probably just ground level. This should be fine.
    ivan_y = PlayerGetY(PlayerFromIndex(PLAYER_Ivan))
    return LoadProtection() && MapID() == 020500 && FlagGetBool(FLAG_RescuedIvan) && prev(ivan_y) > -1.0 && ivan_y <= -1.0
}
achievement(
    id=392851,
    title="Too Much Eggnog",
    description="Rescue the unconscious man in the Hudson Tunnel Area as Amber.",
    points=2,
    trigger=TRIGGER_TooMuchEggnog()
)

// M2_06_00 (Landmark Apartments Area)
// Another fun fact, Amber arrives here chronologically after Isaac but since it's earlier in the game,
// she can take any items that spawn here and they won't be here for Isaac. Maybe there's someone in the
// background trying to prevent a time paradox.

// Not even a cutscene after this one...
function TRIGGER_ImAFriendOfAmberBrazil() 
{
    // Thankfully due to the devs designing all the maps so all the important stuff aligns with cardinal directions,
    // we can just do a cardinal plane check here since you can't reach this point without confronting the detective.
    // And you can't save outside nor return outside the apartment after entering so we don't even need any save protection!!!
    // It's that shrimple, folks
    amber_z = PlayerGetZ(Player)
    return LoadProtection() && MapID() == 020600 && prev(amber_z) < -30.0 && amber_z >= -30.0
}
achievement(
    id=392852,
    title="I'm a Friend of Amber Brazil",
    description="Escape the police detective (again) in the Landmark Apartments Area as Amber.",
    points=3,
    trigger=TRIGGER_ImAFriendOfAmberBrazil()
)

// M2_07_00 (Angelina Area)
// Nothing too significant here; Amber and the gang steal a car which, you know, is a felony, so...

// M2_08_00 (Cascade Dam)
// Perhaps maybe a silly 1 pointer for looking through a Geo standee at the top of the dam

// I'm in a dream, Snake Eater...
achievement(
    id=392853,
    title="FYI I am a Spy",
    description="Obtain Ending 2-A.",
    points=10,
    trigger=LoadProtection() && EndingChangedToSet(ENDING_2A)
)

// Isaac

// M3_01_00
// We definitely need an achievement for buying the Throat Spray /j

// Deliver the passenger and meet all his arbitrary grading requirements
// Gotta check this is the same requirements in JP (which I doubt it's different) as that would complicate this
// Points start at 100 and all violations reduce the score by 5.
// 1. Don't travel through red lights
// ("What are you blind or something?" "You just ran a red light.")
// 2. Don't hit objects.
// ("What the hell!" "Watch out!" / ""Slow down!" "You're going to get us killed.")
// 3. Don't go the wrong way
// ("Hey! It's the other way!")
// 4. Don't go too fast
// ("Hey! You're going to [sic] fast, pal!")
// The four possible assessments are from getting at least 91 (yep, not 90), 60, 40, or less than 40 points
// These also flags 3100, 3101, 3102, 3103 (worst to best) set when finishing the previous stage though checking these probably isn't necessary
// (moreso a way to pass this info between stages for dev)
// 3100: "You're a good driver. Thank you for the ride."
// 3101: "Hey, go ahead and drop me off here. Sorry for rushing you."
// 3102: "Man, you're a horrible driver!"
// 3103: "Um, I'm just going to get off here."
// Flags set after dropping the passenger off (worst to best) are 23220, 23221, 23223, 23222
FLAG_IsaacPassengerBestGrade = 23222
function TRIGGER_UpNRunning() 
{
    // Prime the icon if Isaac is in the taxi in the first area
    start = once(MapID() == 030100 && Player != NULL && PlayerGetVehicle(Player) != NULL)
    // Reset the icon if Isaac leaves the taxi
    // 030200 is just a cutscene so the vehicle pointer for Isaac might be NULL, just gonna check MapID for the vehicle NULL check just in case.
    // Additionally, the vehicle pointer might get set to NULL during the map transition, so we'll put in a menu state check just in case.
    cancel = never(CurrentMenu == MENU_Title || IsaacIntroDrivingGrade < 91 || (CurrentMenu == MENU_Game && MapID() == 030100 && PlayerGetVehicle(Player) == NULL))
    submit = trigger_when(FlagChangedToSet(FLAG_IsaacPassengerBestGrade))
    
    return start && cancel && submit
}
achievement(
    id=393434,
    title="Up & Running", // Smashing Drive reference :)
    description="Deliver the maintenance worker to Downtown Geo and receive the best assessment as Isaac [See comment].",
    points=5,
    trigger=TRIGGER_UpNRunning()
)

// M3_02_01 (Police Station Area)
// I should go look for her.
// I could use some coffee.
// I should go look for her.
// I could use some coffee.
// I should go look for her.
// I should go look for her.
// Just an ending here... 

achievement(
    id=393429,
    title="She Didn't Have Any Money",
    description="Obtain ending 3-B [No Free Mode].",
    points=10,
    trigger=LoadProtection() && EndingChangedToSet(ENDING_3B) && !IsFreeMode()
)

// M3_05_00 (Landmark Apartments Area)
// Nothing here but to further the story; have a psuedo-progression achievement buddy

// The only thing this game does is set this flag then immediately check it and, if it's not set (never) then it skips the fade into the cutscene.
// Brilliant. The game's weird code is our gain.
FLAG_IsaacReplacedTire = 3535
achievement(
    id=393430,
    title="Wheelman",
    description="Replace a tire on your taxi as Isaac.",
    points=3,
    trigger=LoadProtection() && FlagChangedToSet(FLAG_IsaacReplacedTire)
)

// M3_06_00 (NorCal Area (first visit))
// ... there's a repair shop in the sewer under the greenhouse. The only repair shop you could find normally.
// (There's also one in Downtown Station, if you didn't sink it, but it requires glitching into on the non-JP versions)
// This level also has a function called PYLON_MASTER, which is neat I suppose, and also a variable for counting how many cones you hit.

// No flags or easy ways to check this; let's do something *spicy*
// thanks again to IREM for designing these to face cardinal directions because I certainly can't do math for rotated boxes
repair_prompt_boundaries = {
    030300: [203, 3, 228, 207, 8, 235],
    030600: [247, 5, 13, 251, 8, 22]
}

function TRIGGER_GreatParkingAndEaseOfAccess()
{
    box1 = repair_prompt_boundaries[030300]
    box2 = repair_prompt_boundaries[030600]
    return LoadProtection() && Player != NULL &&
           ((MapID() == 030300 && PlayerEnteredBoundingBox(Player, box1[0], box1[1], box1[2], box1[3], box1[4], box1[5])) ||
           (MapID() == 030600 && PlayerEnteredBoundingBox(Player, box2[0], box2[1], box2[2], box2[3], box2[4], box2[5])))
}

achievement(
    id=393431,
    title="Great Parking and Ease of Access",
    description="Find a taxi repair shop as Isaac.",
    points=5,
    trigger=TRIGGER_GreatParkingAndEaseOfAccess()
)

// M3_03_00 (Downtown Station Area (non-linear))
// Nothing to do here

// M3_09_00 (Angelina Area (non-linear))
// Can transport the jewelry thief from here for the jewelry

achievement(
    id=392850,
    title="Leave a 5-Star Review",
    description="Obtain the Flawed Sapphire.",
    points=4,
    trigger=LoadProtection() && JewelryChangedToSet(PLAYER_Isaac)
)

// M3_07_00 (Discovery Heights)
// If you travel down from the start point towards the end of the road, there's a family on the left, and you can honk next to the curb
// to interact with them. It would be nice to have an achievement for delivering them, but there's nothing to check from the actual cutscene code for this one.
// No flags, nothing. The family aren't actually real "players" either so we can't position check them. We *could* check if the player got the Kiddo Compass,
// the reward for this interaction, but you can just refuse that outright for whatever reason. You'll see this if you get all compasses at least...
// We could check if Isaac is out of the car at the cutscene area, though that's a bit spicy

// M3_10_00
// Meh

// M3_11_00
// Meh

// M3_06_01
// One for removing Sophia from the flooded room I suppose

// No good flags to use here but the checkpoint does change so we can detect that
achievement(
    id=393432,
    title="25 Hour Lifeguard", // Poor Sophia, trapped in there from 5 PM Dec 24 to 6 PM Dec 25
    description="Rescue Sophia from a flooded room in the NorCal R&D Department as Isaac.",
    points=3,
    trigger=LoadProtection() && MapID() == 030601 && prev(GateID) != 30 && GateID == 30
)

// M3_15_00
// Just the ending

achievement(
    id=393433,
    title="I Picked Up an Attractive Female in Downtown Geo",
    description="Obtain Ending 3-A.",
    points=10,
    trigger=LoadProtection() && EndingChangedToSet(ENDING_3A)
)

// Paige
// M4_02_00 (Del Ray High School 1)

// This one I'm just putting in as a fresh system save file check mostly -- there's a cutscene tied to picking up a compass.
// Since compasses are saved on the system save file, this can only be seen once and never again, even across new playthroughs,
// unless the system save file is deleted (this is just normal save data which can be deleted on the bios memory card screen).
FLAG_HotDogCompassObtained = 24227
achievement(
    title="Frozen Memories",
    description="Obtain the Hot Dog Compass and relive a bad memory as Paige.",
    points=3,
    trigger=LoadProtection() && FlagChangedToSet(FLAG_HotDogCompassObtained)
)

// This is just for using Vegetable Oil on the trapped teacher (the player doesn't have to continue this interaction past that)
// Not really programmed well, 24229 puts the text note "I put vegetable oil on her legs, but it didn't help" on the map
// regardless of whether or not you actually use it inside the interaction or not but at least you discover this interaction.
FLAG_UsedVegetableOil = 24229
achievement(
    title="Tight Squeeze",
    description="Consider using Vegetable Oil to free the trapped teacher as Paige.",
    points=2,
    trigger=LoadProtection() && FlagChangedToSet(FLAG_UsedVegetableOil)
)

// And a progression achievement (both because we're missing out on *forced* progression achievements and because Paige's
// chapter is so short she doesn't get many achievements so we'll take what we can get.)
achievement(
    title="Evacuate to the Gym",
    description="Reach the gymnasium as Paige.",
    points=3,
    trigger=MapTransitioned(040300, 040200)
)

// M4_03_00 (Del Ray High School 2)
// Endings! You want it? It's yours my friend, if you have enough yen.

// But first, jewelry -- just talk to the thief outside the gymnasium entrance
achievement(
    title="You're a Lot Like Me",
    description="Obtain the Crimson Ruby.",
    points=4,
    trigger=LoadProtection() && JewelryChangedToSet(PLAYER_Paige)
)

// Either save or let Emily fall and continue to the roof, both give 4-A
// Why does this only get one ending when Joshua gets two separate short endings?
achievement(
    title="Forgive or Forget",
    description="Obtain Ending 4-A.",
    points=10,
    trigger=LoadProtection() && EndingChangedToSet(ENDING_4A)
)

// Fun fact, the machine code for the one function which handles the cutscene on the stairs is a whopping ~28KB long
// For reference, the size of Super Mario Bros (NES) is about 32KB
// At the collapsing stairs, yell at Emily a dozen or so times to get this one.
achievement(
    title="My Life as a Teenage Onryou", // https://en.wikipedia.org/wiki/Onry%C5%8D
    description="Obtain Ending 4-B.",
    points=10,
    trigger=LoadProtection() && EndingChangedToSet(ENDING_4B)
)

// Ivan

// Optional memory fragments
// There's a few memory fragments (mostly for the Personality category) obtainable through side conversations/choices
// which may be fun to collect.
// Fun fact: These are called "memory fragment" or "fragment of memory" depending on the map -- very primo translation job

// In Ivan's apartment, choose "That dreadful container..." when prompted
FLAG_FragmentBrave = 39057
achievement(
    title="Memory Fragment - Brave",
    description="Obtain the Brave memory fragment as Ivan.",
    points=3,
    trigger=LoadProtection() && FlagChangedToSet(FLAG_FragmentBrave)
)

// In Ivan's apartment, choose "I remember Echidna!" when prompted
FLAG_FragmentCurious = 39053
achievement(
    title="Memory Fragment - Curious",
    description="Obtain the Curious memory fragment as Ivan.",
    points=3,
    trigger=LoadProtection() && FlagChangedToSet(FLAG_FragmentCurious)
)

// In M5_01_00 (the first area), give the man in the underhang next to the medical tent a cardboard box, then talk to him twice.
FLAG_FragmentDevoted = 39051
achievement(
    title="Memory Fragment - Devoted",
    description="Obtain the Devoted memory fragment as Ivan.",
    points=3,
    trigger=LoadProtection() && FlagChangedToSet(FLAG_FragmentDevoted)
)

// In Ivan's apartment, choose "That dreadful container..." when prompted OR say "Excellent!" after Spritz dies at the high school
FLAG_FragmentEvil = 39061
achievement(
    title="Memory Fragment - Evil",
    description="Obtain the Evil memory fragment as Ivan.",
    points=3,
    trigger=LoadProtection() && FlagChangedToSet(FLAG_FragmentEvil)
)

// Deny Sierra from coming with Ivan at the end of Del Ray High School, and say David wanted to protect her
FLAG_FragmentFriendship = 39050
achievement(
    title="Memory Fragment - Friendship",
    description="Obtain the Friendship memory fragment as Ivan.",
    points=3,
    trigger=LoadProtection() && FlagChangedToSet(FLAG_FragmentFriendship)
)

// In Ivan's apartment, choose "That dreadful container..." when prompted
FLAG_FragmentHonorable = 39052
achievement(
    title="Memory Fragment - Honorable",
    description="Obtain the Honorable memory fragment as Ivan.",
    points=3,
    trigger=LoadProtection() && FlagChangedToSet(FLAG_FragmentHonorable)
)

// Deny Sierra from coming with Ivan at the end of Del Ray High School, and say you love her
FLAG_FragmentInLove = 39055
achievement(
    title="Memory Fragment - In Love",
    description="Obtain the In Love memory fragment as Ivan.",
    points=3,
    trigger=LoadProtection() && FlagChangedToSet(FLAG_FragmentInLove)
)

// Deny Sierra from coming with Ivan at the end of Del Ray High School
FLAG_FragmentLoyal = 39056
achievement(
    title="Memory Fragment - Loyal",
    description="Obtain the Loyal memory fragment as Ivan.",
    points=3,
    trigger=LoadProtection() && FlagChangedToSet(FLAG_FragmentLoyal)
)

// Have Paige call Ivan handsome when she sees him
FLAG_FragmentNarcissist = 39058
achievement(
    title="Memory Fragment - Narcissist",
    description="Obtain the Narcissist memory fragment as Ivan.",
    points=3,
    trigger=LoadProtection() && FlagChangedToSet(FLAG_FragmentNarcissist)
)

// In Ivan's apartment, choose "That lovely container..." when prompted OR have Paige call Ivan a pervert in the high school
FLAG_FragmentPervert = 39060
achievement(
    title="Memory Fragment - Pervert",
    description="Obtain the Pervert memory fragment as Ivan.",
    points=3,
    trigger=LoadProtection() && FlagChangedToSet(FLAG_FragmentPervert)
)

// Deny Sierra from coming with Ivan at the end of Del Ray High School, and say she'll get in your way
FLAG_FragmentSelfish = 39054
achievement(
    title="Memory Fragment - Selfish",
    description="Obtain the Selfish memory fragment as Ivan.",
    points=3,
    trigger=LoadProtection() && FlagChangedToSet(FLAG_FragmentSelfish)
)

// M5_01_00 (Convenience Store Area)

// Technically you could craft this item anywhere as Ivan if you pick up the Oars and carry all the pieces around like a weirdo.
// There's Oars in an alley behind the laundromat that you could just pick up, but you could also do all this
// hard work to assemble some Assembled Oars instead. What a deal!
ITEM_AssembledOars = 190
achievement(
    title="Your Name is MacGyver",
    description="Assemble Assembled Oars.",
    points=5,
    trigger=CurrentMenu == MENU_ItemMenu && ItemNowExists(ITEM_AssembledOars) // PAIN
)

// M5_02_00 (Landmark Apartments Area)

// Just jewelry here
achievement(
    title="Do You Think Love Can Bloom, Even in a Disaster?",
    description="Obtain the Large Diamond.",
    points=4,
    trigger=LoadProtection() && JewelryChangedToSet(PLAYER_Ivan)
)

// M5_03_00 (Angelina Area)
// Yadayada progression achievement go, we gotta get something in this chapter

FLAG_IvanEnterApartment = 5334
achievement(
    title="No Central Heating",
    description="Reach Ivan's apartment as Ivan.",
    points=3,
    trigger=LoadProtection() && FlagChangedToSet(FLAG_IvanEnterApartment)
)

// M5_04_00 (Del Ray High School)
// Not too much here I think

// M5_06_00 (Central Geo District)
// Got an ending here

// Have Joshua dislodge the stuck train here and then fail to catch the container
achievement(
    title="A Worldwide Pandemic (& Knuckles)",
    description="Obtain Ending 5-C [No Free Mode].",
    points=10,
    trigger=LoadProtection() && EndingChangedToSet(ENDING_5C) && !IsFreeMode()
)

// M5_07_00 (Substation)
// More endings

// Destroy Echidna
achievement(
    title="Prosperity Built From Sacrifice", // https://www.youtube.com/watch?v=A_MA2GCNbG8
    description="Obtain Ending 5-A.",
    points=10,
    trigger=LoadProtection() && EndingChangedToSet(ENDING_5A)
)

// Give Echidna to Apolon
achievement(
    title="Grab an Umbrella",
    description="Obtain Ending 5-B.",
    points=10,
    trigger=LoadProtection() && EndingChangedToSet(ENDING_5B)
)

// FINAL CHAPTER

// Beat the game
// This one exists mostly just to mark as a Win Condition (so the actual endings can be marked Missable)
achievement(
    title="I'm Just Warming Up",
    description="Beat the game and witness the credits on the Easy difficulty or higher.",
    points=5,
    trigger=CreditsStarted()
)

// And hard difficulty for good measure
achievement(
    title="I'm on Fire!",
    description="Beat the game and witness the credits on the Hard difficulty.",
    points=25,
    trigger=CreditsStarted() && Difficulty == DIFFICULTY_Hard
)

// Joshua

// Normal ending
achievement(
    title="I Saw the Sun Shining Through the Clouds",
    description="Obtain Ending 6-A (Joshua).",
    points=25,
    trigger=LoadProtection() && EndingChangedToSet(ENDING_6A_J)
)

// Keith (Get Ending 1-B or 1-C)

// Ending 3-B not obtained
achievement(
    title="This'll Make a Good Story",
    description="Obtain Ending 6-A (Keith).",
    points=25,
    trigger=LoadProtection() && EndingChangedToSet(ENDING_6A_K)
)

// Ending 3-B not obtained
achievement(
    title="This Would Have Made a Good Story",
    description="Obtain Ending 6-B (Keith) [No Free Mode].",
    points=25,
    trigger=LoadProtection() && EndingChangedToSet(ENDING_6B_K) && !IsFreeMode()
)

// FREE MODE

// Simple one to start to test logic
achievement(
    title="Rush Hour",
    description="Complete Isaac's chapter in 4 minutes or less [Free Mode] [Hard Difficulty] [0 Game Overs] [Any Ending].",
    points=10,
    trigger=StartAndNeverLeaveCampaignOrDie(PLAYER_Isaac) &&
            IsFreeMode() &&
            Difficulty == DIFFICULTY_Hard &&
            GetInGameTime(PLAYER_Isaac) <= TimeToFrames(minutes=4, seconds=0) &&
            trigger_when(CurrentMenu == MENU_Result)
)

FLAG_RescuedSophia = 3261 // Can no longer get 3-B after this is set
leaderboard(
    title="Isaac's Chapter - Fastest Completion [Ending 3-B]",
    description="Complete Isaac's chapter in Free Mode and obtain Ending 3-B as fast as possible [Hard Difficulty] [0 Game Overs]!",
    start=StartCampaign(PLAYER_Isaac) && IsFreeMode() && Difficulty == DIFFICULTY_Hard,
    cancel=CancelCampaign() || FlagChangedToSet(FLAG_RescuedSophia),
    submit=EndingGetBool(ENDING_3B) && CurrentMenu == MENU_Result,
    value=GetInGameTime(PLAYER_Isaac) * (60/FRAMES_PER_SECOND),
    format="FRAMES",
    lower_is_better=true
)
leaderboard(
    title="Isaac's Chapter - Fastest Completion [Ending 3-A]",
    description="Complete Isaac's chapter in Free Mode and obtain Ending 3-A as fast as possible [Hard Difficulty] [0 Game Overs]!",
    start=once(StartCampaign(PLAYER_Isaac) && never(CancelCampaign())) && 
          IsFreeMode() && 
          Difficulty == DIFFICULTY_Hard &&
          FlagChangedToSet(FLAG_RescuedSophia), // Start this leaderboard once we can no longer get 3-B
    cancel=CancelCampaign(),
    submit=EndingGetBool(ENDING_3A) && CurrentMenu == MENU_Result,
    value=GetInGameTime(PLAYER_Isaac) * (60/FRAMES_PER_SECOND),
    format="FRAMES",
    lower_is_better=true
)


// ACHIEVEMENTS END 

// RICH PRESENCE START

// Intentionally left blank, RAScript doesn't play nice with ranges
MapNameLookup = {
    //01990000-01990099=Joshua is at the Del Ray Relief Center, preparing for a future disaster // Tutorial
    //01000000-01000099=Learning about how Geo City is the safest city ever // Joshua's campaign
    //01010000-01010099=Joshua is serving guests in the underground Convention Center
    //01010100-01010199=Joshua and Stephanie are trapped in the underground Convention Center
    //01010500-01010599=Joshua and Stephanie are above ground in the Geo City Downtown Area, outside the underground Convention Center
    //01020000-01020001=Joshua and Stephanie are at the Downtown Station Area. Can they use train?
    //01020002-01020008,01020010-01020099=Joshua is trying to find his way to an unconscious Stephanie in the Downtown Station Area
    //01020009=Joshua would be considering taking a dip in the water in the Downtown Station Area, but he knows that would softlock the game if Stephanie were conscious so he better not
    //01030000=Joshua and Stephanie are traveling to the Del Ray West Junction by bus
    //01030001-01030099=Joshua and Stephanie are awaiting rescue by helicopter at Del Ray West Junction
    //01040000-01040099=Joshua is passing by the Historic Rest Area while searching for Stephanie
    //01050000-01050099=Joshua is attempting a rescue at Del Ray East Junction
    //01050100-01050199=Joshua and Stephanie are looking for shelter in the Angelina Area
    //01050200-01050299=Joshua and Stephanie are making their way to the Mission Care Center
    //01060000-01060099=Joshua and Stephanie are visiting a circus in Del Ray Inner Park
    //01070000-01070099=Joshua and Stephanie are crossing over the flooded Central Geo District
    //01090010=Joshua and Stephanie are passing through Del Ray Station to reach a helicopter
    //01090000-01090009,01090011-01090099=Joshua is climbing up the Media Tower // Joshua's epilogue
    //02010000-02010099=Amber is visiting her brother, David, at his Landmark Apartments apartment // Amber's campaign
    //02020000-02020099=Amber is in the Police Station Jail for a crime she did not commit
    //02030000-02030099=Amber is on the run from the police in the Geo City Downtown Area
    //02040000-02040099=Amber and Aidan are sneaking through the Downtown Station Area
    //02050000-02050099=Amber and Aidan are fleeing the police via the Hudson Tunnel
    //02060000-02060099=Amber and Aidan are searching for clues in the Landmark Apartments Area
    //02070000-02070099=Amber and Aidan are attempting the very real crime of grand theft auto in the Angelina Area
    //02080000-02080029=Amber is scaling the Cascade Dam
    //02080030-02080099=Amber is climbing a really long ladder while in handcuffs at the Cascade Dam
    //03010000-03010099=Isaac is reading a magazine in the Convenience Store Area // Isaac's campaign
    //03020000-03020099=Isaac is arguing with a customer about their taxi fare in the Geo City Downtown Area
    //03020100-03020099=Isaac and his customer are passing by the Geo Police Station
    //03030000-03030091,03030093-03030099=Isaac decided to drive to the Downtown Station Area while looking for Jaden Bradford, for some reason. Doesn't he know all the content for him here was cut?
    //03030092=Isaac managed to exploit his way to the north entrance of the Downtown Station Area and is enjoying the unvoiced cutscenes, what a cool dude
    //03050000-03050099=Isaac and his customer are trying to break into Landmark Apartments
    //03060000-03060099=Isaac and Sophia are sneaking around the NorCal Factory Area
    //03060100-03060199=Isaac and Jaden are attempting to rescue Sophia from the NorCal Factory Area
    //03070000-03070099=Isaac is looking for a Jaden Bradford in Discovery Heights
    //03080000-03080099=Isaac and Jaden are passing through Del Ray High School on the way to the NorCal Factory Area
    //03090000-03090099=Isaac is looking for a Jaden Bradford in the Angelina Area
    //03100000-03100099=Isaac and Jaden are heading to the Cascade Dam through Cascade Pass
    //03110000-03110099=Isaac is wasting time at the Cascade Dam while Jaden investigates
    //03150000-03150099=Isaac is seeking out his taxi fare from an attractive female he picked up in Downtown Geo
    //04020000-04020099=Paige just woke up in a flooded Del Ray High School. Can she reach the gym? // Paige's campaign
    //04030000-04030016=Paige has arrived at the Del Ray High School gymnasium
    //04030017-04030099=Paige and Emily are heading towards the roof of a Del Ray High School building
    //05010000=??? is... ugh... what's going on? I can't remember a thing... // Ivan's campaign
    //05010001=??? is cold, wet, and was approached by some strange woman who suddenly fainted
    //05010002-05010099=??? is... a doctor? ??? is trying to help out the collapsed woman
    //05020000-05020039,05020041-05020099=Ivan and Sierra are rowing an air mattress through the flooded Discovery Heights Area
    //05020040=Ivan and Sierra are investigating David Brazil's apartment in Landmark Apartments
    //05030000,05030030-05030034,05030036-05030099=Ivan and Sierra are walking through the Angelina Area towards Ivan's apartment
    //05030015=Ivan is thinking about cooking up a delicious meal in the Angelina restaurant... there's a time and place for everything, but not now // Just checking the checkpoint is a bit limiting in determining map state lmao
    //05030001-05030014,05030016-05030029=Ivan is looking for help to rescue a trapped Sierra
    //05030035=Ivan doesn't remember buying all of this leopard-print furniture in his apartment...
    //05040000-05040011=Ivan and Sierra are looking for Dr. Spritz in Del Ray High School
    //05040012-05040099=Ivan is trying to remember how to destroy Echidna...
    //05060000-05060099=Ivan is chasing after a container of Echidna in the Central Geo District Area
    //05070000-05070029=Ivan is attempting to destroy Echidna at a Substation
    //05070030-05070039=Ivan is confronting Apolon at the Substation
    //05070040-05070099=Ivan will destroy Echidna, regardless of Apolon's interference in his plans
    //06010000,06010012=Keith is attempting to escape to higher ground via the Media Center building // Keith epilogue
    //06010013-06010099=Keith is climbing up the Media Tower
}

CompassLookup = {
    0: "Standard",
    1: "Relief Center",
    2: "Mascot",
    3: "Pedometer",
    4: "Backpack",
    5: "Holiday Tree",
    6: "Monorail",
    7: "Steambot",
    8: "Fisherman",
    9: "Jetski",
    10: "Cloud",
    11: "Porridge",
    12: "Rabbit",
    13: "Clown",
    14: "Heart",
    15: "Train",
    16: "Media Tower",
    17: "Ice Cream",
    18: "Frozen",
    19: "Blokus",
    20: "Fig",
    21: "Stocking",
    22: "Fruitcake",
    23: "Music Box",
    24: "Diver",
    25: "Piglet",
    26: "Snowflake",
    27: "Baby",
    28: "Dam",
    29: "Therapy Ball",
    30: "Turkey Leg",
    31: "Trumpet",
    32: "Anime",
    33: "Yose Nabe",
    34: "NorCal",
    35: "Banana",
    36: "Hostess",
    37: "Kiddo",
    38: "Cucumber",
    39: "Blue Marlin",
    40: "Snowboarder",
    41: "Assistant",
    42: "Tweezers",
    43: "Triangle",
    44: "Statue",
    45: "Beam",
    46: "Hot Dog",
    47: "Rubber",
    48: "Cat",
    49: "Hardhat",
    50: "Rudolph's",
    51: "R9D",
    52: "Snowman",
    53: "Samurai",
    54: "Curry Rice",
    55: "Sea Urchin",
    56: "Candle",
    57: "Faucet",
    58: "Helicopter",
    59: "Sea Gull",
    60: "Big Dipper",
    61: "Cartoon",
    62: "Crowbar",
    63: "King Crab",
    64: "Survivor",
}

DifficultyLookup = {
    0: "Easy",
    1: "Normal",
    2: "Hard",
}

WetLookup = {
    0: "Dry",
    1: "💧",
    2: "💧💧",
    3: "💧💧💧",
}

RegionLookup = {
    REGION_JP: "ʲᵖ",
    REGION_EU: "ᵉᵘ",
}

rp_fallback_string = "{0} In a loading screen or the title screen"

for region in [REGION_EU, REGION_JP] {
    rich_presence_conditional_display(region == GetRegion() && PlayerExists(), "{0} {1} | {2} 🧭 | {3} Difficulty | BT: {4} / 30000.0 | {5}",
        rich_presence_lookup("Region", GetRegion(), RegionLookup),
        rich_presence_lookup("MapName", MapWithGateID(), MapNameLookup),
        rich_presence_lookup("Compass", CompassID, CompassLookup),
        rich_presence_lookup("Difficulty", Difficulty, DifficultyLookup),
        rich_presence_value("Float1", BodyHeat, format="FLOAT1"),
        rich_presence_lookup("WetLevel", WetLevel, WetLookup)
    )
}

rich_presence_display(rp_fallback_string, rich_presence_lookup("Region", GetRegion(), RegionLookup))


// RICH PRESENCE END
