// Raw Danger! | Zettai Zetsumei Toshi 2: Itetsuita Kiokutachi
// #ID = 5616

NULL = 0

// Region check
function is_EU() => byte(0x100120) == 0x87
function is_JP() => byte(0x100120) == 0x86

// EU memory
EU_Player = dword(0x6003A4)
function EU_PlayerFromIndex(id) => dword(0x5eae00 + (id * 4))
EU_CompassID = byte(0x48FAE8)
EU_BodyHeat = float(EU_Player + 0x000370)
EU_WetLevel = word(0x64781C)
EU_Flags = 0x609470
EU_MapObjs = 0x492460
EU_MapTimeFrames = dword(0x48F49C)
EU_LoadedMapPack = dword(0x48F4F0)
EU_CutsceneFlag = byte(0x48F900)
EU_EndingBitset = 0x67DDB6 // Might be saved w/ save file so not sure how useful this is
EU_GameMode = byte(0x67DDBA)
EU_Difficulty = byte(0x67DDBB)
EU_InGameTime = dword(0x67DDC0) // number of frames, divide by 30 for seconds
EU_CurrentMenu = dword(0x48F604)

// Map IDs
EU_AreaIDBackup = dword(0x492440)
EU_LevelIDBackup = dword(0x492444)
EU_SublevelIDBackup = dword(0x492448)
EU_GateIDBackup = dword(0x49244C)
// Some game modes change the current map ID (such as the results screen, which change it to 990000, for whatever reason)
// So we'll use this backup value in some circumstances
function EU_MapIDBackup() => EU_AreaIDBackup * 10000 + EU_LevelIDBackup * 100 + EU_SublevelIDBackup
EU_AreaID = dword(0x492450)
EU_LevelID = dword(0x492454)
EU_SublevelID = dword(0x492458)
EU_GateID = dword(0x49245C)
function EU_MapIDPrev() => prev(EU_AreaID) * 10000 + prev(EU_LevelID) * 100 + prev(EU_SublevelID)
function EU_MapID() => EU_AreaID * 10000 + EU_LevelID * 100 + EU_SublevelID
function EU_MapWithGateID() => EU_MapID() * 100 + EU_GateID

// JP memory (TODO; doublecheck all of these)
JP_Player = dword(0x5FEDA4)
function JP_PlayerFromIndex(id) => dword(0x5E9800 + (id * 4))
JP_CompassID = byte(0x48E4E8)
JP_BodyHeat = float(JP_Player + 0x000370)
JP_WetLevel = word(0x644FDC)
JP_Flags = 0x607E70
JP_MapObjs = 0x490E60
JP_MapTimeFrames = dword(0x48DE9C)
JP_LoadedMapPack = dword(0x48DEF0)
JP_CutsceneFlag = byte(0x48E300)
JP_EndingBitset = 0x67B576
JP_GameMode = byte(0x67B57A)
JP_Difficulty = byte(0x67B57B)
JP_InGameTime = dword(0x67B580)
JP_CurrentMenu = dword(0x48E008)

// Map IDs
JP_AreaIDBackup = dword(0x490E40)
JP_LevelIDBackup = dword(0x490E44)
JP_SublevelIDBackup = dword(0x490E48)
JP_GateIDBackup = dword(0x490E4C)
function JP_MapIDBackup() => JP_AreaIDBackup * 10000 + JP_LevelIDBackup * 100 + JP_SublevelIDBackup
JP_AreaID = dword(0x490E50)
JP_LevelID = dword(0x490E54)
JP_SublevelID = dword(0x490E58)
JP_GateID = dword(0x490E5C)
function JP_MapIDPrev() => prev(JP_AreaID) * 10000 + prev(JP_LevelID) * 100 + prev(JP_SublevelID)
function JP_MapID() => JP_AreaID * 10000 + JP_LevelID * 100 + JP_SublevelID
function JP_MapWithGateID() => JP_MapID() * 100 + JP_GateID


// General enums
MENU_Game = 21
MENU_Result = 32

// General functions

function IsInTutorial()
{
    return (is_EU() && EU_MapID() == 019900) || (is_JP() && JP_MapID() == 019900)
}

function IsInCutscene()
{
    return (is_EU() && EU_CutsceneFlag == 1) || (is_JP() && JP_CutsceneFlag == 1)
}
function IsInMenuTransition(to_menu)
{
    return (is_EU() && prev(EU_CurrentMenu) != to_menu && EU_CurrentMenu == to_menu) ||
           (is_JP() && prev(JP_CurrentMenu) != to_menu && JP_CurrentMenu == to_menu)
}
function IsTransitioningToResult(map_id=-1)
{
    is_on_map = true
    if (map_id != -1)
    {
        // We have to use the backup map value as the results transition overwrites the current map value
        // and saves the last map value to the backup
        is_on_map = (is_EU() && EU_MapIDBackup() == map_id) || (is_JP() && JP_MapIDBackup() == map_id)
    }
    return IsInMenuTransition(MENU_Result) && is_on_map
}

function LoadProtection()
{
    // NOTE: This still doesn't work to both guard loads and ensure map transitions work
    // (we can likely check the "gate" ID for map transitions, as the entry checkpoint ID will almost always be 0 and something different for save points)
    //return PlayerExists()
    
    // Returns true if we aren't loading a map
    // (MapTimeFrames is 0 in title screen, load screens, etc.)
    MIN_FRAMES = 3
    
    return (is_EU() && EU_MapTimeFrames >= MIN_FRAMES) ||
           (is_JP() && JP_MapTimeFrames >= MIN_FRAMES)
}

// Map Objects
function MapObjGet(mapobjs, index)
{
    MAPOBJ_SIZE = 0x2A0
    return mapobjs + (index * MAPOBJ_SIZE)
}

function MapObjIsActive(mapobj)
{
    ACTIVE_OFFSET = 0xF
    return byte(mapobj + ACTIVE_OFFSET)
}

// Players
function PlayerExists()
{
    return (is_EU() && EU_Player != NULL) ||
           (is_JP() && JP_Player != NULL)
}
function PlayerExistsId(player_id)
{
    return (is_EU() && EU_PlayerFromIndex(id) != NULL) ||
           (is_JP() && JP_PlayerFromIndex(id) != NULL)
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
function FlagGet(flags, flag)
{
    // Returns a memory accessor for a particular game flag
    return bit(flag % 8, flags + flag / 8)
}
function FlagGetBool(flag)
{
    // More abstracted version of FlagGet; returns a boolean value representing the flag's state and not a memory accessor
    return (is_EU() && FlagGet(EU_Flags, flag) == 1) ||
           (is_JP() && FlagGet(JP_Flags, flag) == 1)
}

function FlagChangedToSetHelper(flags, flag) => prev(FlagGet(flags, flag)) == 0 && FlagGet(flags, flag) == 1
function FlagChangedToSet(flag) => (is_EU() && FlagChangedToSetHelper(EU_Flags, flag)) ||
                                   (is_JP() && FlagChangedToSetHelper(JP_Flags, flag))

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
FLAG_MasterGrade = 72
FLAG_GradingOver = 79
function TRIGGER_DisasterPrepared() => FlagGetBool(FLAG_MasterGrade) && FlagChangedToSet(FLAG_GradingOver)

achievement(
    title="Disaster-Prepared",
    description="Obtain the rank of 'Master' in the tutorial.",
    points=5,
    trigger=TRIGGER_DisasterPrepared()
)

// M1_01_00 (Underground banquet hall (pre-disaster))

// This is a bit cheeky but other solutions unfortunately did not pan out
// Since Geo never leaves the banquet hall (besides being repositioned for this cutscene), we can check his position for this.
// This'll trigger the achievement at the beginning of the cutscene instead of the end but it's the best I got for now.
// (I don't think checking if he leaves this area would work, as I think he just gets set inactive and stashed away in the ether
// instead of actually being moved back -- that'll happen when Joshua approaches the banquet hall again)
PLAYER_SantaGeo = 60
function EU_TRIGGER_HiImGeo()
{
    // x = 27.0 is about where the hall outside the banquet hall (where the player sets down plates)
    // and the hallway outside the kitchen connect
    geo_x = PlayerGetX(EU_PlayerFromIndex(PLAYER_SantaGeo))
    return EU_MapID() == 010100 && prev(geo_x) < 27.0 && geo_x >= 27.0
}
function JP_TRIGGER_HiImGeo()
{
    geo_x = PlayerGetX(JP_PlayerFromIndex(PLAYER_SantaGeo))
    return JP_MapID() == 010100 && prev(geo_x) < 27.0 && geo_x >= 27.0
}
function TRIGGER_HiImGeo() => (is_JP() && JP_TRIGGER_HiImGeo()) || (is_EU() && EU_TRIGGER_HiImGeo())

achievement(
    title="Hi, I'm Geo!",
    description="In the underground convention center, find a costume of Geo and try it on as Joshua.",
    points=1,
    trigger=TRIGGER_HiImGeo()
)

FLAG_ReturnedContactLens = 21172
achievement(
    title="I Have Special Eyes",
    description="In the underground convention center, find and return a woman's lost contact lenses as Joshua.",
    points=1,
    trigger=LoadProtection() && FlagChangedToSet(FLAG_ReturnedContactLens)
)

FLAG_ReturnedItalianRecipe = 996
achievement(
    title="Occupational Hazard",
    description="In the underground convention center, return the Italian Recipe to the chef as Joshua.",
    points=1,
    trigger=LoadProtection() && FlagChangedToSet(FLAG_ReturnedItalianRecipe)
)

FLAG_TookStephaniePhoto = 1001
achievement(
    title="Candid Caper",
    description="In the underground convention center, find and pick up a picture of Stephanie as Joshua.",
    points=2,
    trigger=LoadProtection() && FlagChangedToSet(FLAG_TookStephaniePhoto)
)

// Is set after finding hole in wall regardless of if we look through it or not (and you wouldn't look through it, of course)
FLAG_FoundPeepHole = 990
achievement(
    title="Peeping Josh",
    description="In the underground convention center, find a (small) hole in the wall as Joshua.",
    points=3,
    trigger=LoadProtection() && FlagChangedToSet(FLAG_FoundPeepHole)
)

// We have three options when talking to the drinker (to agree, to say we're busy, or to refuse).
// The last two will set flag 1063, but also one of 1064 and 1065. We'll want to make sure 1063 is set but neither of the others.
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

FLAG_FoundLostChildMother = 6003
achievement(
    title="Good Guy Josh",
    description="In the underground convention center, help Stephanie find the mother of the lost child as Joshua.",
    points=1,
    trigger=LoadProtection() && FlagChangedToSet(FLAG_FoundLostChildMother)
)

FLAG_GaveSophiaOutfit = 915
achievement(
    title="Behind the Scenes",
    description="In the underground convention center, find and give an investigative reporter a Waitress Uniform as Joshua.",
    points=2,
    trigger=LoadProtection() && FlagChangedToSet(FLAG_GaveSophiaOutfit)
)

FLAG_RoomTempWaterNoSpill = 21179
achievement(
    title="I Only Drink Cascade Mineral Water",
    description="In the underground convention center, refill the water pitcher with water from the leaking water pipe and deliver it to the mayor without spilling too much as Joshua.",
    points=2,
    trigger=LoadProtection() && FlagChangedToSet(FLAG_RoomTempWaterNoSpill)
)

// M1_01_01 (Destroyed banquet hall)
// Pretty straightforward here, probably want just one progression achievement for escaping the entire setpiece of the underground banquet hall

// Don't have solid map transition logic yet, but this should work fine.
// Taking advantage of the fact that the player shouldn't be able to float up here (especially during a cutscene)
function EU_TRIGGER_OutOfTheFryingPan()
{
    // The player gets up to about y = -29.0 in the final cutscene before it is exited (reminder that y is inverted)
    // It appears that this cutscene can't be skipped but even if it could, this logic should still work as cutscene logic should be
    // fast-forwarded when skipped.
    player_y = PlayerGetY(EU_Player)
    return IsInCutscene() && EU_MapID() == 010101 && prev(player_y) > -28.0 && player_y <= -28.0
}
function JP_TRIGGER_OutOfTheFryingPan()
{
    player_y = PlayerGetY(JP_Player)
    return IsInCutscene() && JP_MapID() == 010101 && prev(player_y) > -28.0 && player_y <= -28.0
}
function TRIGGER_OutOfTheFryingPan() => (is_JP() && JP_TRIGGER_OutOfTheFryingPan()) || (is_EU() && EU_TRIGGER_OutOfTheFryingPan())
achievement(
    title="Out of the Frying Pan",
    description="Escape the underground convention center as Joshua.",
    points=5,
    trigger=LoadProtection() && TRIGGER_OutOfTheFryingPan()
)

// M1_01_05 (Downtown Geo Area)
// Just getting the jewelry here, I think
// Also perhaps walking on the electrified water without getting shocked? Not sure how to make that a concise achievement.
// That'd require beating the game (to unlock the Collection feature and be able to take out equipment from recycle bins, and then to use the Rubber Boots)
// Pretty neat detail that didn't require coding in at all lmao

FLAG_ObtainedCheapPearl = 9015
achievement(
    title="Cold as Ice",
    description="In the Downtown Geo Area, obtain the Cheap Pearl as Joshua.",
    points=4,
    trigger=LoadProtection() && FlagChangedToSet(FLAG_ObtainedCheapPearl)
)

// M1_02_00 (Downtown Station Area)
// Maybe lighting the wreathes on fire? It does create a little segment later on so it'd be good to spotlight

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
// (which is known by me - the logic is at 0x3409B0) is too complicated (including || and && in subclause due to the multiregion support --
// that could possibly be alleviated by calculating the flags address as (0x607E70 + ((byte(0x100120) - 0x86) * 0x1600)) but I don't really want to subject anyone to that logic)

FLAG_WestJunctionIntroDone = 1300
achievement(
    title="We Just Gotta Wait",
    description="Arrive at the evacuation point in West Junction as Joshua.",
    points=5,
    trigger=LoadProtection() && FlagChangedToSet(FLAG_WestJunctionIntroDone)
)

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

FLAG_EastJunctionEscapeAlone = 41081 // 1-C
FLAG_EastJunctionEscapeWithStephanie = 41082 // 1-B
achievement(
    title="Future Regret",
    description="Obtain either Ending 1-B or 1-C.",
    points=10,
    trigger=IsTransitioningToResult(map_id=010500) &&
            any_of([FLAG_EastJunctionEscapeAlone, FLAG_EastJunctionEscapeWithStephanie], FlagGetBool)
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
    50: "Rudolphs",
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

REGION_JP = 0x86
REGION_EU = 0x87

function GetRegion()
{
    return byte(0x100120)
}

RegionLookup = {
    REGION_JP: "ʲᵖ",
    REGION_EU: "ᵉᵘ",
}

rp_fallback_string = "{0} In a loading screen or the title screen"

rich_presence_conditional_display(is_EU() && PlayerExists(), "{0} {1} | {2} 🧭 | {3} Difficulty | BT: {4} / 30000.0 | {5}",
    rich_presence_lookup("Region", GetRegion(), RegionLookup),
    rich_presence_lookup("MapName", EU_MapWithGateID(), MapNameLookup),
    rich_presence_lookup("Compass", EU_CompassID, CompassLookup),
    rich_presence_lookup("Difficulty", EU_Difficulty, DifficultyLookup),
    rich_presence_value("Float1", EU_BodyHeat, format="FLOAT1"),
    rich_presence_lookup("WetLevel", EU_WetLevel, WetLookup)
)
rich_presence_conditional_display(is_JP() && PlayerExists(), "{0} {1} | {2} 🧭 | {3} Difficulty | BT: {4} / 30000.0 | {5}",
    rich_presence_lookup("Region", GetRegion(), RegionLookup),
    rich_presence_lookup("MapName", JP_MapWithGateID(), MapNameLookup),
    rich_presence_lookup("Compass", JP_CompassID, CompassLookup),
    rich_presence_lookup("Difficulty", JP_Difficulty, DifficultyLookup),
    rich_presence_value("Float1", JP_BodyHeat, format="FLOAT1"),
    rich_presence_lookup("Wet", JP_WetLevel, WetLookup)
)
rich_presence_display(rp_fallback_string, rich_presence_lookup("Region", byte(0x100120), RegionLookup))


// RICH PRESENCE END
