// Raw Danger! | Zettai Zetsumei Toshi 2: Itetsuita Kiokutachi
// #ID = 5616

NULL = 0

// Region check
function is_EU() => byte(0x100120) == 0x87
function is_JP() => byte(0x100120) == 0x86

// EU memory
function EU_Player() => dword(0x6003A4)
function EU_PlayerFromIndex(id) => dword(0x5eae00 + (id * 4))
function EU_CompassID() => byte(0x48FAE8)
function EU_BodyHeat() => float(EU_Player() + 0x000370)
function EU_WetLevel() => word(0x64781C)
function EU_Flags() => 0x609470
function EU_MapObjs() => 0x492460
function EU_MapTimeFrames() => dword(0x48F49C)
function EU_LoadedMapPack() => dword(0x48F4F0)
function EU_CutsceneFlag() => byte(0x48F900)

// Map IDs
function EU_AreaID() => dword(0x492450)
function EU_LevelID() => dword(0x492454)
function EU_SublevelID() => dword(0x492458)
function EU_GateID() => dword(0x49245C)
function EU_MapID() => EU_AreaID() * 10000 + EU_LevelID() * 100 + EU_SublevelID()
function EU_MapWithGateID() => EU_MapID() * 100 + EU_GateID()

// JP memory (TODO; doublecheck all of these)
function JP_Player() => dword(0x5FEDA4)
function JP_PlayerFromIndex(id) => dword(0x5E9800 + (id * 4))
function JP_CompassID() => byte(0x48E4E8)
function JP_BodyHeat() => float(JP_Player() + 0x000370)
function JP_WetLevel() => word(0x644FDC)
function JP_Flags() => 0x607E70
function JP_MapObjs() => 0x490E60
function JP_MapTimeFrames() => dword(0x48DE9C)
function JP_LoadedMapPack() => dword(0x48DEF0)
function JP_CutsceneFlag() => byte(0x48E300)

// Map IDs
function JP_AreaID() => dword(0x490E50)
function JP_LevelID() => dword(0x490E54)
function JP_SublevelID() => dword(0x490E58)
function JP_GateID() => dword(0x490E5C)
function JP_MapID() => JP_AreaID() * 10000 + JP_LevelID() * 100 + JP_SublevelID()
function JP_MapWithGateID() => JP_MapID() * 100 + JP_GateID()

// General functions

function IsInTutorial()
{
    return (is_EU() && EU_MapID() == 019900) || (is_JP() && JP_MapID() == 019900)
}

function IsInCutscene()
{
    return (is_EU() && EU_CutsceneFlag() == 1) || (is_JP() && JP_CutsceneFlag() == 1)
}

function LoadProtection()
{
    // Returns true if we aren't loading a map
    // (MapTimeFrames is 0 in title screen, load screens, etc.)
    MIN_FRAMES = 3
    
    return (is_EU() && EU_MapTimeFrames() >= MIN_FRAMES) ||
           (is_JP() && JP_MapTimeFrames() >= MIN_FRAMES)
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

// Flags
function FlagGet(flags, flag)
{
    // Returns a memory accessor for a particular game flag
    return bit(flag % 8, flags + flag / 8)
}
function FlagGetBool(flag)
{
    // More abstracted version of FlagGet; returns a boolean value representing the flag's state and not a memory accessor
    return (is_EU() && FlagGet(EU_Flags(), flag) == 1) ||
           (is_JP() && FlagGet(JP_Flags(), flag) == 1)
}

function FlagChangedToSetHelper(flags, flag) => prev(FlagGet(flags, flag)) == 0 && FlagGet(flags, flag) == 1
function FlagChangedToSet(flag) => (is_EU() && FlagChangedToSetHelper(EU_Flags(), flag)) ||
                                   (is_JP() && FlagChangedToSetHelper(JP_Flags(), flag))

// ACHIEVEMENTS START

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

// Not sure exactly what this map object is, but it's set to inactive at the start of the cutscene,
// and active afterwards. Doesn't appear to be touched otherwise in this map.
MAPOBJ_GEO = 1485
function EU_TRIGGER_HiImGeo()
{
    active_accessor = MapObjIsActive(MapObjGet(EU_MapObjs(), MAPOBJ_GEO))
    return IsInCutscene() && EU_MapID() == 010100 && prev(active_accessor) == 0 && active_accessor == 1
}
function JP_TRIGGER_HiImGeo()
{
    active_accessor = MapObjIsActive(MapObjGet(JP_MapObjs(), MAPOBJ_GEO))
    return IsInCutscene() && JP_MapID() == 010100 && prev(active_accessor) == 0 && active_accessor == 1
}
function TRIGGER_HiImGeo() => (is_JP() && JP_TRIGGER_HiImGeo()) || (is_EU() && EU_TRIGGER_HiImGeo())

achievement(
    title="Hi, I'm Geo!",
    description="In the underground convention center, find a costume of Geo as Joshua.",
    points=1,
    trigger=TRIGGER_HiImGeo()
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
    0: "Standard Compass",
    1: "Relief Center Compass",
    2: "Mascot Compass",
    3: "Pedometer Compass",
    4: "Backpack Compass",
    5: "Holiday Tree Compass",
    6: "Monorail Compass",
    7: "Steambot Compass",
    8: "Fisherman Compass",
    9: "Jetski Compass",
    10: "Cloud Compass",
    11: "Porridge Compass",
    12: "Rabbit Compass",
    13: "Clown Compass",
    14: "Heart Compass",
    15: "Train Compass",
    16: "Media Tower Compass",
    17: "Ice Cream Compass",
    18: "Frozen Compass",
    19: "Blokus Compass",
    20: "Fig Compass",
    21: "Stocking Compass",
    22: "Fruitcake Compass",
    23: "Music Box Compass",
    24: "Diver Compass",
    25: "Piglet Compass",
    26: "Snowflake Compass",
    27: "Baby Compass",
    28: "Dam Compass",
    29: "Therapy Ball Compass",
    30: "Turkey Leg Compass",
    31: "Trumpet Compass",
    32: "Anime Compass",
    33: "Yose Nabe Compass",
    34: "NorCal Compass",
    35: "Banana Compass",
    36: "Hostess Compass",
    37: "Kiddo Compass",
    38: "Cucumber Compass",
    39: "Blue Marlin Compass",
    40: "Snowboarder Compass",
    41: "Assistant Compass",
    42: "Tweezers Compass",
    43: "Triangle Compass",
    44: "Statue Compass",
    45: "Beam Compass",
    46: "Hot Dog Compass",
    47: "Rubber Compass",
    48: "Cat Compass",
    49: "Hardhat Compass",
    50: "Rudolphs Compass",
    51: "R9D Compass",
    52: "Snowman Compass",
    53: "Samurai Compass",
    54: "Curry Rice Compass",
    55: "Sea Urchin Compass",
    56: "Candle Compass",
    57: "Faucet Compass",
    58: "Helicopter Compass",
    59: "Sea Gull Compass",
    60: "Big Dipper Compass",
    61: "Cartoon Compass",
    62: "Crowbar Compass",
    63: "King Crab Compass",
    64: "Survivor Compass",
}

WetLookup = {
    0: "Dry",
    1: "💧",
    2: "💧💧",
    3: "💧💧💧",
}

rp_fallback_string = "In a loading screen or the title screen"

rich_presence_conditional_display(is_EU() && EU_Player() != NULL, "ᵉᵘ {0} | {1} | BT: {2} / 30000.0 | {3}",
    rich_presence_lookup("MapName", EU_MapWithGateID(), MapNameLookup),
    rich_presence_lookup("Compass", EU_CompassID(), CompassLookup),
    rich_presence_value("Float1", EU_BodyHeat(), format="FLOAT1"),
    rich_presence_lookup("Wet", EU_WetLevel(), WetLookup)
)

rich_presence_conditional_display(is_JP() && JP_Player() != NULL, "ʲᵖ {0} | {1} | BT: {2} / 30000.0 | {3}",
    rich_presence_lookup("MapName", JP_MapWithGateID(), MapNameLookup),
    rich_presence_lookup("Compass", JP_CompassID(), CompassLookup),
    rich_presence_value("Float1", JP_BodyHeat(), format="FLOAT1"),
    rich_presence_lookup("Wet", JP_WetLevel(), WetLookup)
)

rich_presence_conditional_display(is_EU(), "ᵉᵘ {0}", rp_fallback_string)
rich_presence_conditional_display(is_JP(), "ʲᵖ {0}", rp_fallback_string)
rich_presence_display(rp_fallback_string)


// RICH PRESENCE END