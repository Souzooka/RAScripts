// Disaster Report | SOS: The Final Escape | Zettai Zetsumei Toshi
// #ID = 2663

NULL = 0

REGION_US = 0
REGION_EU = 1
REGION_JP = 2
US = REGION_US
EU = REGION_EU
JP = REGION_JP
RegionByte = byte(0x13547A)
Regions = [US, EU, JP]

IsUS = byte(0x135030)
IsEU = byte(0x1351DA)
IsJP = byte(0x135150)

// NOTE: bad blur call is at 0x00158BFC for US

// NOTE: Dialogue arrow not appearing in HW is a depth issue; arrow is at depth -0x1 and menu is at depth -0x2
// the instruction at 0x192F88 (addiu t2, zero, -0x2) has to be changed to (addiu t2, zero, -0x81 (!!!)) for the arrow to show up. The imprecision!
// Item menu bg depth is at 0x183B10, item tabs at 0x183DC8 -- can just be changed to -0x2F8 and -0x1F8
// Depth for "Save game?" screen with faucet is in memory at 0x26B978 -- can be changed to 0xFFFFFF70
// For "Exit game without saving?" backdrop depth is at memory 0x26A120 and can be changed to 0xFFFFFF70;
// window backdrop is at code 0x199364; can be changed to -0x81

function IsRegion(region)
{
    return region == RegionByte
}

DIFFICULTY_EASY = 0
DIFFICULTY_NORMAL = 1
DIFFICULTY_HARD = 2

BACKPACK_NONE = -1
BACKPACK_KNAPSACK = 0
BACKPACK_RESCUEPACK = 1
BACKPACK_FRAMEPACK = 2
BACKPACK_BACKPACK = 3
BACKPACK_GYMBAG = 4
BACKPACK_CLOTHBAG = 5

Area = {
    US: dword(0x36bbb0),
    EU: dword(0x3933B0),
    JP: dword(0x36dbb0),
}
Subarea = {
    US: dword(0x36bbb8),
    EU: dword(0x3933B8),
    JP: dword(0x36dbb8),
}
Gate = {
    US: dword(0x36bbc0),
    EU: dword(0x3933C0),
    JP: dword(0x36dbc0),
}
Difficulty = {
    US: dword(0x25C2C8),
    EU: dword(0x25F408),
    JP: dword(0x25D1E8),
}
Compass = {
    US: dword(0x3FE8E0),
    EU: dword(0x4252E0),
    JP: dword(0x40A360),
}
Backpack = {
    US: dword(0x3533A0),
    EU: dword(0x37ABA0),
    JP: dword(0x3553A0),
}
BackpackAttachedItemsLength = {
    US: dword(0x3535b8),
    EU: dword(0x37ADB8),
    JP: dword(0x3555B8),
}
MapObjsLength = {
    US: dword(0x36A8C0),
    EU: dword(0x3920C0),
    JP: dword(0x36C8C0),
}
MaxHealth = {
    US: float(0x3808F0),
    EU: float(0x3A70F0),
    JP: float(0x3823F0),
}
MaxQP = {
    US: float(0x3808F4),
    EU: float(0x3A70F4),
    JP: float(0x3823F4),
}
Health = {
    US: float(0x380904),
    EU: float(0x3A7104),
    JP: float(0x382404),
}
QP = {
    US: float(0x380908),
    EU: float(0x3A7108),
    JP: float(0x382408),
}
Flags = {
    US: 0x36CC00,
    EU: 0x394400,
    JP: 0x36EC00,
}
WaitVSyncs = {
    US: dword(0x3DFECC),
    EU: dword(0x40688C),
    JP: dword(0x3EB96C),
}

// Game State
MENU_TRANSITION = -1
MENU_INITIAL = 0x1 // Also used when exiting to the title from game
MENU_TITLE = 0x8
MENU_MCMENU = 0xC
MENU_GAMELOAD = 0x12
MENU_GAMELOAD2 = 0x13
MENU_GAME = 0x14

PreviousMenu = {
    US: dword(0x380760),
    EU: dword(0x3A6F60),
    JP: dword(0x382260),
}
CurrentMenu = {
    US: dword(0x380768),
    EU: dword(0x3A6F68),
    JP: dword(0x382268),
}
NextMenu = {
    US: dword(0x380770),
    EU: dword(0x3A6F70),
    JP: dword(0x382270),
}

function MapID(region)
{
    area = Area[region]
    subarea = Subarea[region]
    return area * 100 + subarea
}

function MapIDPrev(region)
{
    area = prev(Area[region])
    subarea = prev(Subarea[region])
    return area * 100 + subarea
}

function MapIDWithGate(region)
{
    gate = Gate[region]
    return MapID(region) * 100 + gate
}

function IsInGame(region)
{
    // Tentative
    return MapObjsLength[region] > 0
}

function LoadProtection(region)
{
    // Gotta be really careful with this because if we put any ||s in here
    // RA has to think too hard and will refuse to consider the condition valid
    return prior(PreviousMenu[region]) != MENU_MCMENU &&
           PreviousMenu[region] != MENU_MCMENU &&
           CurrentMenu[region] != MENU_MCMENU &&
           CurrentMenu[region] > MENU_TITLE &&
           NextMenu[region] > MENU_TITLE
}

// RICH PRESENCE START

RegionLookup = {
    REGION_US: "ᵘˢ",
    REGION_EU: "ᵉᵘ",
    REGION_JP: "ʲᵖ",
}

GameNameLookup = {
    REGION_US: "Disaster Report",
    REGION_EU: "SOS: The Final Escape",
    REGION_JP: "Zettai Zetsumei Toshi",
}

DifficultyLookup = {
    DIFFICULTY_EASY: "Easy",
    DIFFICULTY_NORMAL: "Normal",
    DIFFICULTY_HARD: "Hard",
}

CompassLookup = {
    0x0: "Standard",
    0x1: "Water",
    0x2: "Apple",
    0x3: "Sphere",
    0x4: "Focus",
    0x5: "Marine",
    0x6: "Tire",
    0x7: "Swan",
    0x8: "King's",
    0x9: "Yacht",
    0xA: "Weathercock",
    0xB: "Daruma",
    0xC: "R-9",
    0xD: "Carton",
    0xE: "Spelunker",
    0xF: "Miner",
    0x10: "Sub",
    0x11: "Gussun",
    0x12: "Shutterbug",
    0x13: "Genzo",
    0x14: "Duck",
    0x15: "Frog",
    0x16: "Turtle",
    0x17: "Dog",
    0x18: "Dancer",
    0x19: "Angel",
    0x1A: "Horse",
    0x1B: "Skull",
    0x1C: "Surfer",
    0x1D: "Flower",
    0x1E: "Wooden",
    0x1F: "Pistol",
    0x20: "Eyeball",
    0x21: "Umbrella", 
    0x22: "Capital City",
}

MapNameLookup = {
    0100: "June 2005, Sunny. Keith sees Stiver Island outside his window. He's a newspaper reporter assigned here. Today is his first day.",
    0101: "Keith is on the Airport Island Bridge, south of the Angelino Restaurant.",
    0111: "Keith is on the Airport Island Bridge, inside the Angelino Restaurant.",
    0102: "Keith is on the Airport Island Bridge, north of the Angelino Restaurant.",
    0103: "Keith and Karen are on the Airport Island Bridge, north of the Angelino Restaurant.",
    0104: "Keith and Karen are on the Airport Island Bridge, north of the Angelino Restaurant.",
    0106: "Keith and Karen are on the overpass over Patrick James Street.",
    0108: "Keith and Karen are near Patrick James Park.",
    0105: "Keith and Karen are heading towards the convenience store at the corner of Girard and Patrick James Street.",
    0109: "Keith and Karen are inside the convenience store at the corner of Girard and Patrick James Street.",
    0107: "Keith is looking for Karen north from Patrick James Street.",
    0110: "Keith is looking for Karen in an overturned building on Girard Street.",
    0200: "Keith and Karen are heading through the Financial District.",
    0201: "Keith is inside a jewelry store on Joseph Street.",
    0202: "Keith and Karen are inside the Construction Area in the Financial District.",
    0203: "Keith is exploring a destroyed building outside the Construction Area.",
    0204: "Keith is exploring a destroyed building outside the Construction Area.",
    0207: "After escaping the destroyed building, Keith, Karen and Greg are deciding how to best split up.",
    0206: "Keith and Karen are fording the Dmitri Canal.",
    0300: "Keith and Karen are on Park Ave & Main.",
    0301: "Keith and Karen are heading towards Karen's house to look for Karen's dog.",
    0302: "Keith and Karen are inside the Main Harbor Station.",
    0303: "Keith and Karen are inside the underground Main Water System.",
    0304: "Keith and Karen are inside the Park Avenue Subway.",
    0205: "Keith is heading towards to the Ocean Breeze Island Amusement Park via the Capital District.",
    0400: "Keith is having the time of his life at the Ocean Breeze Island Amusement Park. If only Karen were here to see this...",    
    0401: "Keith and Kelly are taking a swan boat ride through the eastern part of the Ocean Breeze Island Amusement Park.",
    0402: "Keith and Kelly are looking for Kelly's younger brother in the Residential District.",
    0403: "Keith and Kelly are looking for Kelly's younger brother in her neighborhood.",
    0404: "Keith and Kelly are awaiting rescue at the Santa Katrina Hospital.",
    0500: "Keith and Karen are near the Town Crier News building.",
    0510: "Keith and Kelly are near the Town Crier News building.",
    0501: "Keith and Karen are inside the Town Crier News building.",
    0502: "Keith and Kelly are inside the Town Crier News building.",
    0511: "Keith is near the Town Crier News building.",
    0503: "Keith is in the Christophe Construction building.",
    0505: "Keith and the gang are heading through Windrunner Park.",
    0507: "Keith, Karen, Kelly and Greg are meeting up outside the May Stadium.",
    0508: "Keith is heading through May Stadium.",
    0509: "⚠️ Keith is on an unfinished map. It's dangerous over there! scene_0005_0003_01_1_E[]",
    0600: "Oh my god they've got a helicopter! Keith and Karen are running away from an attack helicopter towards Lincoln Plaza!",
    0605: "Oh my god they've got a helicopter! Keith and Kelly are running away from an attack helicopter towards Lincoln Plaza!",
    0601: "Keith and Karen are on the lower floors of Lincoln Plaza.",
    0606: "Keith and Kelly are on the lower floors of Lincoln Plaza.",
    0602: "Keith is in the residential section of Lincoln Plaza.",
    0607: "Keith is in the residential section of Lincoln Plaza.",
    0603: "Keith and Karen must protect themselves from the paramilitary goons in the upper section of Lincoln Plaza!",
    0608: "Keith and Kelly must protect themselves from the paramilitary goons in the upper section of Lincoln Plaza!",
    0604: "⚠️ Keith and Karen are on an unfinished map. Why is Lincoln Plaza sideways!?",
    0700: "Keith and Karen are crossing over Lucas Canal to reach the last rescue helicopter. Why is it behind a fence?",
    0709: "Keith and Kelly are crossing over Lucas Canal to reach the last rescue helicopter. Why is it behind a fence?",
    0701: "Keith and Karen are in the Stiver Island Control Center.",
    0710: "Keith and Kelly are in the Stiver Island Control Center.",
    0702: "Keith, Greg and Karen are in Terry Stiver's office in the Stiver Island Control Center.",
    0711: "Keith, Greg and Kelly are in Terry Stiver's office in the Stiver Island Control Center.",
    0703: "They've still got a helicopter! Keith, Greg and Karen are fleeing along the Lucas Canal.",
    0712: "They've still got a helicopter! Keith, Greg and Kelly are fleeing along the Lucas Canal.",
    0704: "Keith, Greg and Karen crashed off of the Lucas Canal and now the water is receding. That's a good thing, right?",
    0713: "Keith, Greg and Kelly crashed off of the Lucas Canal and now the water is receding. That's a good thing, right?",
    0705: "Keith, Greg and Karen are scrambling to avoid being swept away by climbing a downtown Capital City building.",
    0714: "Keith, Greg and Kelly are scrambling to avoid being swept away by climbing a downtown Capital City building.",
    0706: "Keith, Greg and Karen are trying to avoid a sniper on the roof of a downtown Capital City building.",
    0715: "Keith, Greg and Kelly are trying to avoid a sniper on the roof of a downtown Capital City building.",
    0707: "Keith and Karen are taking a long, somber walk up the Quinn Building.",
    0716: "Keith and Kelly are taking a long, somber walk up the Quinn Building.",
    0708: "Keith and Karen are continuing to escape the rising waters by climbing the Central Tower Building!",
    0717: "Keith and Karen are continuing to escape the rising waters by climbing the Central Tower Building!",
}

for region in Regions
{
    rich_presence_conditional_display(
        IsRegion(region) && IsInGame(region),
        "{0} | {1} | {2} 🧭 | {3} Difficulty | {4}% HP | {5}% QT",
        rich_presence_lookup("GameName", RegionByte, GameNameLookup),
        rich_presence_lookup("MapName", MapID(region), MapNameLookup),
        rich_presence_lookup("Compass", Compass[region], CompassLookup),
        rich_presence_lookup("Difficulty", Difficulty[region], DifficultyLookup),
        rich_presence_value("Health", Health[region], format="FLOAT1"),
        rich_presence_value("QP", QP[region], format="FLOAT1")
    )
    rich_presence_conditional_display(
        IsRegion(region),
        "{0} | In the title or loading screen.",
        rich_presence_lookup("GameName", RegionByte, GameNameLookup)
    )
}

rich_presence_display("Playing Disaster Report")

// RICH PRESENCE END

// ACHIEVEMENTS START

FLAG_SAVED_KAREN = 0x213E
FLAG_FOUND_KAREN = 0x57E // Overturned building
FLAG_MET_GREG = 0x214E
FLAG_ESCAPE_CONSTRUCTION_SITE = 0x214B

FLAG_COMPASS_START = 9800
FLAG_COMPASS_END = 9834

function BackpackTrigger(region, backpack)
{
    // A false trigger can occur if a player picks up a new backpack, dies, and then respawns with their old backpack.
    // Which then triggers the achievement for obtaining the backpack the player had before they died.
    // We'll guard the achievement with a map ID check to prevent this scenario.
    maps = {
        BACKPACK_RESCUEPACK: 0101,
        BACKPACK_KNAPSACK: 0110,
        BACKPACK_BACKPACK: 0203,
        BACKPACK_GYMBAG: 0000, // TODO
        BACKPACK_CLOTHBAG: 0000, // TODO
        BACKPACK_FRAMEPACK: 0505,
    }
    
    map_cond = MapID(region) == maps[backpack]

    return IsRegion(region) &&
           LoadProtection(region) &&
           map_cond &&
           prev(Backpack[region]) != backpack && 
           Backpack[region] == backpack    
}

function FlagGet(region, flag)
{
    flags = Flags[region]
    return bit(flag % 8, flags + flag / 8)
}

function FlagSetTrigger(region, flag, map=-1)
{
    map_cond = always_true()
    if (map != -1)
    {
        map_cond = MapID(region) == map
    }

    return IsRegion(region) && 
           LoadProtection(region) && 
           map_cond &&
           FlagGet(region, flag) == 1 && 
           prev(FlagGet(region, flag)) == 0
}

function CompassCount(region)
{
    current = 0
    delta = 0
    prior = 0
    
    for flag in range(FLAG_COMPASS_START, FLAG_COMPASS_END)
    {
        current = current + FlagGet(region, flag)
        delta = delta + prev(FlagGet(region, flag))
        prior = prior + prior(FlagGet(region, flag))
    }
    
    // Compass 0 (standard) is flag 9800, but never seems to get set on.
    // We'll add 1 (or not, using XOR, if it is on) to count it anyways.
    current = current + (FlagGet(region, FLAG_COMPASS_START) ^ 1)
    delta = delta + (FlagGet(region, FLAG_COMPASS_START) ^ 1)
    
    return [current, delta, prior]
}

function CompassMeasuredTrigger(region, new_count, old_count=-1)
{
    count = CompassCount(region)
    current = count[0]
    delta = count[1]
    prior = count[2]
    
    measured_condition = current == new_count
    when = IsRegion(region) && LoadProtection(region) && delta < new_count
    
    if (old_count != -1)
    {
        // Only show the measurement if we've acquired enough compasses for the previous checkpoint achievement.
        when = when && current > old_count
    }
    return current > delta && measured(measured_condition, when=when)
}

function MapTransition(region, old_map, new_map)
{
    return IsRegion(region) &&
           LoadProtection(region) &&
           MapID(region) == new_map &&
           MapIDPrev(region) == old_map
}

// Backpacks

achievement(
    title="And Don't Forget Your Backpack",
    description="Obtain the Rescue Pack.",
    points=2,
    trigger=any_of(Regions, region => BackpackTrigger(region, BACKPACK_RESCUEPACK))
)

achievement(
    title="TODO Backpack - Knapsack",
    description="Obtain the Knapsack.",
    points=3,
    trigger=any_of(Regions, region => BackpackTrigger(region, BACKPACK_KNAPSACK))
)

achievement(
    title="TODO Backpack - Backpack",
    description="Obtain the Backpack.",
    points=3,
    trigger=any_of(Regions, region => BackpackTrigger(region, BACKPACK_BACKPACK))
)

achievement(
    title="TODO Backpack - Gym Bag",
    description="Obtain the Gym Bag.",
    points=3,
    trigger=any_of(Regions, region => BackpackTrigger(region, BACKPACK_GYMBAG))
)

achievement(
    title="TODO Backpack - Cloth Bag",
    description="Obtain the Cloth Bag.",
    points=3,
    trigger=any_of(Regions, region => BackpackTrigger(region, BACKPACK_CLOTHBAG))
)

achievement(
    title="TODO Backpack - Frame Pack",
    description="Obtain the Frame Pack.",
    points=5,
    trigger=any_of(Regions, region => BackpackTrigger(region, BACKPACK_FRAMEPACK))
)

// Compasses

achievement(
    title="Compass Novice",
    description="Obtain 10 compasses.",
    points=5,
    trigger=any_of(Regions, region => CompassMeasuredTrigger(region, 10))
)

achievement(
    title="Compass Enthusiast",
    description="Obtain 20 compasses.",
    points=5,
    trigger=any_of(Regions, region => CompassMeasuredTrigger(region, 20, 10))
)

achievement(
    title="Compass Master",
    description="Obtain all 35 compasses.",
    points=25,
    trigger=any_of(Regions, region => CompassMeasuredTrigger(region, 35, 20))
)

// Story events

achievement(
    title="TODO Rescue Karen",
    description="Rescue the injured woman on the Airport Island Bridge.",
    points=3,
    trigger=any_of(Regions, region => FlagSetTrigger(region, FLAG_SAVED_KAREN))
)

function CrowbarTrigger(region)
{
    // This checks the number of items attached to Keith's backpack model,
    // which should only be 0 -> 1 when picking up the crowbar AFAIK.
    // It might go back to 0, then 1, when chipping at the concrete in the subway in Karen's route,
    // but we check the map ID anyways so we should be all good.
    // I could see this still breaking so it might require a revisit later based on testing.
    return IsRegion(region) &&
           LoadProtection(region) &&
           MapID(region) == 0108 &&
           prev(BackpackAttachedItemsLength[region]) == 0 &&
           BackpackAttachedItemsLength[region] == 1
}

achievement(
    title="Keith Helm, in the Flesh",
    description="Obtain the Crowbar.",
    points=2,
    trigger=any_of(Regions, region => CrowbarTrigger(region))
)

achievement(
    title="TODO Find Karen",
    description="Find Karen in the overturned building on Girard Street.",
    points=3,
    trigger=any_of(Regions, region => FlagSetTrigger(region, FLAG_FOUND_KAREN))
)

achievement(
    title="The Aspiring Journalist",
    description="Meet a freelance photographer.",
    points=3,
    trigger=any_of(Regions, region => FlagSetTrigger(region, FLAG_MET_GREG))
)

achievement(
    title="TODO Escape Construction Site",
    description="Escape the construction site.",
    points=3,
    trigger=any_of(Regions, region => MapTransition(region, 0202, 0203))
)

function FreshMemoriesTrigger(region)
{
    // We're waiting for the end of the (only) "slow-mo" shot in this map
    // by checking the wait vsyncs value.
    return MapID(region) == 0204 &&
           WaitVSyncs[region] <= 2 &&
           prev(WaitVSyncs[region]) > 2
}

achievement(
    title="Fresh Memories",
    description="Try and save an elderly couple trapped in a destroyed building.",
    points=3,
    trigger=any_of(Regions, region => FreshMemoriesTrigger(region))
)

// ACHIEVEMENTS END
