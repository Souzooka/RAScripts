// Raw Danger! | Zettai Zetsumei Toshi 2: Itetsuita Kiokutachi
// #ID = 5616

NULL = 0

REGION_JP = 1
REGION_EU = 0

function GetRegion() {
  // This is just some arbitrary byte in code that happens to be 1 in JP and 0 in EU
  return byte(0x348FAA)
}

function GetRealAddress(pal_address, jp_address) {
  // Does some funky arithmetic to calculate the address we should access for achievement logic
  // This may break if RA keeps its syntax and then implements 64-bit integer support, but should work if the achievements are re-exported...
  region_offset = jp_address - pal_address
  return pal_address - (region_offset * GetRegion())
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
JewelryInfo = GetRealAddress(0x7173A0, 0x714AE0)

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

MENU_LdGameOv = 13 // Dunno
MENU_LoadGame = 14 // Dunno
MENU_MemoryCardMenu = 18
MENU_GameLoad = 19 // This is actually the one from loading from the MC menu lmao
MENU_Game = 21
MENU_Result = 32

// NOTE: In general, the Free Mode (chapter select) sets flags which allow players
// to be able to achieve shorter endings (which would require set up from a previous chapter).
// For example, Amber's ending where she escapes with the rescue crew requires Joshua to have removed
// the iron bar while he passed through the Downtown Station. I want players to have set these events in motion,
// so I'll be excluding endings which specifically require setup in previous chapters from being achievable in Free Mode.
ENDING_1A = 0 // Joshua - Reaching McMurrough's heli
ENDING_1B = 1 // Joshua - Leaving with Stephanie on overpass
ENDING_1C = 2 // Joshua - Leaving without Stephanie on overpass
ENDING_2A = 3 
ENDING_2B = 4 // Amber - Escape with rescue team in downtown station (requires Joshua to remove iron bar)
//ENDING_2B = 5
ENDING_2C = 6
ENDING_2D = 7
ENDING_3A = 8
ENDING_3B = 9
ENDING_3C = 10
ENDING_3D = 11
ENDING_4A = 12
ENDING_4B = 13
ENDING_4C = 14
ENDING_4D = 15
ENDING_5A = 16
ENDING_5B = 17
ENDING_5C = 18
ENDING_5D = 19
ENDING_6A = 20
ENDING_6B = 21
ENDING_6C = 22
ENDING_6D = 23

// General functions

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
    return CurrentMenu == MENU_Game
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

// Flags
// Some general notes about flags
// 0-5999 - Level specific flags (may be referenced in later levels) (0-1999 are for tutorial/Chapter 1, 2000-2999 for 2, etc. in general)
// 6000-6999 - Stephanie-related flags
// 7000-7999 - Significant flags which have implications across chapters
// 20000-29999 - Chapter epilogue flags? (though not many are actually used later... but hey, easier to detect certain cutscenes so a boon for me)
// 30000-39999 - Cutscene skip flags (these belong to the SYSTEM save - don't use these)
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
    return byte(JewelryInfo + (player_id * 0x18) + 0x16)
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
// (all requirements award 10 points; timing requirements are for when you have player control)
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
function TRIGGER_DisasterPrepared() => FlagGetBool(FLAG_MasterGrade) && FlagChangedToSet(FLAG_GradingOver)
achievement(
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
    title="Hi, I'm Geo!",
    description="In the underground convention center, find a costume of Geo and try it on as Joshua.",
    points=1,
    trigger=TRIGGER_HiImGeo()
)

// Talk to a woman on the ground in the banquet hall looking for her contact lens, then find the lens a bit in front of her
// and GIVE the lens to the woman
FLAG_ReturnedContactLens = 21172
achievement(
    title="I Have Special Eyes",
    description="In the underground convention center, find and return a woman's lost contact lenses as Joshua.",
    points=1,
    trigger=LoadProtection() && FlagChangedToSet(FLAG_ReturnedContactLens)
)

// Talk to the moving chef in the kitchen (not the head chef) and then retrieve his recipe
FLAG_ReturnedItalianRecipe = 996
achievement(
    title="Occupational Hazard",
    description="In the underground convention center, return the Italian Recipe to the chef as Joshua.",
    points=1,
    trigger=LoadProtection() && FlagChangedToSet(FLAG_ReturnedItalianRecipe)
)

// Talk to one of the waiters near the banquet hall door to the kitchen BEFORE bringing food to Stephanie
// and he'll mention his locker is B-1 -- just go examine the locker afterwards.
FLAG_TookStephaniePhoto = 1001
achievement(
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
    title="Good Guy Josh",
    description="In the underground convention center, help Stephanie find the mother of the lost child as Joshua.",
    points=1,
    trigger=LoadProtection() && FlagChangedToSet(FLAG_FoundLostChildMother)
)

// Pretty simple -- after talking to Sophia after picking up the water, the outfit is in a box with red tape near a vending machine in the locker room hallway.
// Give that outfit to her and you're done.
FLAG_GaveSophiaOutfit = 915
achievement(
    title="Behind the Scenes",
    description="In the underground convention center, find and give an investigative reporter a Waitress Uniform as Joshua.",
    points=2,
    trigger=LoadProtection() && FlagChangedToSet(FLAG_GaveSophiaOutfit)
)

// Go left out of the kitchen after picking up the water, watch the cutscene, then examine the water pipe to refill the pitcher
FLAG_RoomTempWaterNoSpill = 21179
achievement(
    title="I Only Drink Cascade Mineral Water",
    description="In the underground convention center, refill the water pitcher with water from the leaking water pipe and deliver it to the mayor without spilling too much as Joshua.",
    points=2,
    trigger=LoadProtection() && FlagChangedToSet(FLAG_RoomTempWaterNoSpill)
)

// M1_01_01 (Destroyed banquet hall)
// Pretty straightforward here, probably want just one progression achievement for escaping the entire setpiece of the underground banquet hall

achievement(
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
    title="Cold as Ice",
    description="Obtain the Cheap Pearl as Joshua.",
    points=4,
    trigger=LoadProtection() && JewelryChangedToSet(PLAYER_Joshua)
)

// M1_02_00 (Downtown Station Area)
// Maybe lighting the wreathes on fire? It does create a little segment later on so it'd be good to spotlight

// Have the lighter equipped and move through the area after the underground shutter you have to open with the Speed Handle
FLAG_JoshuaSetOffFireAlarm = 7002
achievement(
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
    title="We Just Gotta Wait",
    description="Arrive at the evacuation point in West Junction as Joshua.",
    points=5,
    trigger=LoadProtection() && FlagChangedToSet(FLAG_WestJunctionIntroDone)
)

// Pick up some food and then talk to the chef on the other side of the road from where you start, ez
FLAG_WestJunctionCookedMeal = 1323
achievement(
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
    title="I Need a Hero",
    description="At the East Junction, rescue a trapped woman and girl as Joshua.",
    points=5,
    trigger=LoadProtection() && FlagChangedToSet(FLAG_EastJunctionHelicopterApproaching)
)

// Achieve ending 1-B or 1-C
// (Leave on helicopter with or without Stephanie)
achievement(
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
    title="Kitchen Nightmare",
    description="Using the large pot, cook a meal for yourself and/or Stephanie inside the Angelina restaurant as Joshua.",
    points=3,
    trigger=LoadProtection() && 
            any_of([FLAG_StephanieOnePlate, FLAG_StephanieBothPlates, FLAG_StephanieNoPlates], FlagChangedToSet)
)

// M1_05_02 (Mission Care Center Area)

FLAG_ArriveMissionCareCenter = 1580
achievement(
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
    title="Flotsam's Circus Troupe",
    description="Convince the ringmaster in Del Ray Inner Park to keep pursuing his passion as Joshua.",
    points=2,
    trigger=LoadProtection() && FlagGetBool(FLAG_RingmasterDontGiveUp) && FlagChangedToSet(FLAG_RingmasterConversationOver)
)

// See the cutscene where Stephanie reunites with her mother
FLAG_SawMotherCutscene = 21635
achievement(
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
    title="An Unlikely Pair",
    description="Escape the police detective then meet a new companion in the Downtown Station Area as Amber.",
    points=3,
    trigger=LoadProtection() && FlagChangedToSet(FLAG_AidanIntroCutsceneDone)
)

// Cross the ladder to the rescue crew after the station starts collasping (requires Josh to remove iron bar)
// Translator's note: Saiban is "court trial" in Japanese
achievement(
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
    title="Hot Pursuit",
    description="Escape the police detective again in the Hudson Tunnel Area as Amber.",
    points=3,
    trigger=LoadProtection() && MapID() == 020500 && GateID == 1 && prev(GateID) != 1
)

// Give an umbrella to the jewelry thief (she's near an entrance to the underground tunnel on the bridge itself)

// Interact with Ivan in the Hudson Tunnel and have Aidan carry him
// Nothing particularly available to check to time this achievement well,
// but we can just check Ivan's Y value (since when he's being carried away by rescue crew,
// that's when he'll be at the highest point he can be)
FLAG_RescuedIvan = 7026
function TRIGGER_TooMuchEggnog() {
    // Not sure exactly what Y level he's at when carried, but Y=0 is probably just ground level. This should be fine.
    ivan_y = PlayerGetY(PlayerFromIndex(PLAYER_Ivan))
    return LoadProtection() && MapID() == 020500 && FlagGetBool(FLAG_RescuedIvan) && prev(ivan_y) > -1.0 && ivan_y <= -1.0
}
achievement(
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
function TRIGGER_ImAFriendOfAmberBrazil() {
    // Thankfully due to the devs designing all the maps so all the important stuff aligns with cardinal directions,
    // we can just do a cardinal plane check here since you can't reach this point without confronting the detective.
    // And you can't save outside nor return outside the apartment after entering so we don't even need any save protection!!!
    // It's that shrimple, folks
    amber_z = PlayerGetZ(Player)
    return LoadProtection() && MapID() == 020600 && prev(amber_z) < -30.0 && amber_z >= -30.0
}
achievement(
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
    title="FYI I am a Spy",
    description="Obtain Ending 2-A.",
    points=10,
    trigger=LoadProtection() && EndingChangedToSet(ENDING_2A)
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
    //02040000-02040099=Amber and Aiden are sneaking through the Downtown Station Area
    //02050000-02050099=Amber and Aiden are fleeing the police via the Hudson Tunnel
    //02060000-02060099=Amber and Aiden are searching for clues in the Landmark Apartments Area
    //02070000-02070099=Amber and Aiden are attempting the very real crime of grand theft auto in the Angelina Area
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
    //03110000-03110099=Isaac is wasting time at the Cascade Dam while Jaden investigates. I want to get out of here right no
    //03150000-03150099=Isaac is seeking out his taxi fare from an attractive female he picked up in Downtown Geo
    //04020000-04020099=Paige just woke up in a flooded Del Ray High School. Can she reach the gym? // Paige's campaign
    //04030000-04030016=Paige has arrived at the Del Ray High School gymnasium.
    //04030017-04030099=Paige and Emily are heading towards the roof of a Del Ray High School building.
    //05010000=??? is... ugh... what's going on? I can't remember a thing... // Ivan's campaign
    //05010001=??? is cold, wet, and was approached by some strange woman who suddenly fainted
    //05010002-05010099=??? is... a doctor? ??? is trying to help out the collapsed woman
    //05020000-05020039,05020041=05020099=Ivan and Sierra are rowing an air mattress through the flooded Discovery Heights Area
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
