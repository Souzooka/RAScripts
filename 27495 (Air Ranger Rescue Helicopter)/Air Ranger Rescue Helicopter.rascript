// Air Ranger: Rescue Helicopter
// #ID = 27495

NULL = 0
True = 1
False = 0

REGION_EU = 0
REGION_JP = 1
EU = REGION_EU
JP = REGION_JP
Regions = [EU, JP]

function GetRegion()
{
    return EU
}

function IsRegion(region)
{
    return region == GetRegion()
}

function GetRealAddress(eu_address, jp_address)
{
    return eu_address
}

GameState = byte(GetRealAddress(0x237738, 0))
CurrentMissionID = word(GetRealAddress(0x237760, 0))
ResultState = dword(GetRealAddress(0x2373B8, 0))
ResultMedal = dword(GetRealAddress(0x1EB5F58, 0))
StarCoins = GetRealAddress(0x1EC4E94, 0)

EGameState_Game = 0xF
EResultState_SuccessMedalAnim = 4
EResultState_SuccessIdle = 5
EResultMedal_Platinum = 0

// RICH PRESENCE START

TitleLookup = {
    EU: "Air Ranger: Rescue Helicopter",
    JP: "レスキューヘリエアレンジャー",
}

MissionLookup = {
    0: "BK-117-B | Airlifting a severely injured traffic accident victim in San Fernando City",
    1: "CH-47J | Transporting a crashed tanker off a bridge in San Fernando City",
    2: "BK-117-B | Rescuing victims of a shipwreck off White Coast",
    3: "OH-6D | Undergoing search and rescue of survivors adrift in sea off White Coast",
    4: "CH-47J | Recovering a truck carrying a load of timber which fell off a cliff in the Missoula Mountains",
    5: "OH-6D | Undergoing search and rescue of two geologists stranded in a steep ravine in the Missoula Mountains",
    6: "OH-6D | Rescuing two train operators stuck on a runaway freight train in Hickory Canyon",
    7: "BK-117-B | Extinguishing a fire that has engulfed a factory in Hickory Canyon",
}

rich_presence_conditional_display(
    GameState == EGameState_Game,
    "{0} | {1}",
    rich_presence_lookup("Title", GetRegion(), TitleLookup),
    rich_presence_lookup("Mission", CurrentMissionID, MissionLookup)
)
rich_presence_display(
    "{0} | Not inside a mission",
    rich_presence_lookup("Title", GetRegion(), TitleLookup)
)

// RICH PRESENCE END

// ACHIEVEMENTS START

EASY = 0
HARD = 1

MissionDifficulties = [
    EASY,
    EASY,
    HARD,
    HARD,
    HARD,
    HARD,
    HARD,
    HARD,
]

MissionNames = [
    "Mission 1-1",
    "Mission 1-2",
    "Mission 2-1",
    "Mission 2-2",
    "Mission 3-1",
    "Mission 3-2",
    "Mission 4-1",
    "Mission 4-2",
]

MissionCompleteTitles = [
    "Mission 1-1",
    "Mission 1-2",
    "Mission 2-1",
    "Mission 2-2",
    "Mission 3-1",
    "Mission 3-2",
    "Mission 4-1",
    "Mission 4-2",
]

MissionCompleteIDs = []

MissionPerfectTitles = [
    "Mission 1-1 - Platinum",
    "Mission 1-2 - Platinum",
    "Mission 2-1 - Platinum",
    "Mission 2-2 - Platinum",
    "Mission 3-1 - Platinum",
    "Mission 3-2 - Platinum",
    "Mission 4-1 - Platinum",
    "Mission 4-2 - Platinum",
]

MissionPerfectIDs = []

MissionStarCoinTitles = [
    "Mission 1-1 - Star Coins",
    "Mission 1-2 - Star Coins",
    "Mission 2-1 - Star Coins",
    "Mission 2-2 - Star Coins",
    "Mission 3-1 - Star Coins",
    "Mission 3-2 - Star Coins",
    "Mission 4-1 - Star Coins",
    "Mission 4-2 - Star Coins",
]

MissionStarCoinIDs = []

function MissionCompleteTrigger(mission_id)
{
    return CurrentMissionID == mission_id &&
           prev(ResultState) == EResultState_SuccessMedalAnim &&
           ResultState == EResultState_SuccessIdle
}

function MissionPerfectTrigger(mission_id)
{
    return MissionCompleteTrigger(mission_id) &&
           ResultMedal == EResultMedal_Platinum
}

SIZEOF_COIN = 2
NUM_COINS_PER_MISSION = 5
function _CountNumCoins(mission_id)
{
    coins = StarCoins + (mission_id * (NUM_COINS_PER_MISSION * SIZEOF_COIN))
    
    num_coins = 0
    for i in range(0, NUM_COINS_PER_MISSION - 1)
    {
        num_coins = num_coins + bit(0, coins)
        coins = coins + SIZEOF_COIN
    }
    
    return num_coins
}
function MissionStarCoinsTrigger(mission_id)
{
    return prev(_CountNumCoins(mission_id)) == NUM_COINS_PER_MISSION - 1 &&
           measured(
             _CountNumCoins(mission_id) == NUM_COINS_PER_MISSION, 
             when=GameState == EGameState_Game && CurrentMissionID == mission_id
           )
}

for i in range(0, length(MissionNames) - 1)
{
    // Calculate points for completing a mission or perfecting it
    partialPoints = 5
    fullPoints = 10
    if MissionDifficulties[i] == EASY
    {
        partialPoints = 3
        fullPoints = 5
    }
    
    // Completion achievements
    achievement(
        title=MissionCompleteTitles[i],
        description=format("Complete {0}.", MissionNames[i]),
        points=partialPoints,
        trigger=MissionCompleteTrigger(i)
    )
    
    // Platinum medal achievements
    achievement(
        title=MissionPerfectTitles[i],
        description=format("Complete {0} and obtain a platinum medal.", MissionNames[i]),
        points=fullPoints,
        trigger=MissionPerfectTrigger(i)
    )
    
    // Star Coin achievements
    achievement(
        title=MissionStarCoinTitles[i],
        description=format("Locate and pick up all Star Coins in {0}.", MissionNames[i]),
        points=5,
        trigger=MissionStarCoinsTrigger(i)
    )
}

// ACHIEVEMENTS END

