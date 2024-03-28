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
    return byte(0x10019C)
}

function IsRegion(region)
{
    return region == GetRegion()
}

function GetRealAddress(eu_address, jp_address)
{
    jp_offset = jp_address - eu_address
    return eu_address + (jp_offset * GetRegion())
}

GameState = byte(GetRealAddress(0x237738, 0x233DA8))
CurrentMissionID = word(GetRealAddress(0x237760, 0x233970))
ResultState = dword(GetRealAddress(0x2373B8, 0x233B58))
ResultMedal = dword(GetRealAddress(0x1EB5F58, 0x1EBA268))
ResultTime = dword(GetRealAddress(0x1EB5F34, 0x1EBA244))
StarCoins = GetRealAddress(0x1EC4E94, 0x01E4D904)
// Set to 1 as soon as the mission is completed and control is taken from the player (followed by
// "MISSION COMPLETE" showing up on screen, then fade to result). We need to use this because we need
// to actually unfortunately trigger leaderboard submissions a bit early, as the game converts frames
// in ResultTime to seconds when the mission completes, and then trashes the prior by adding 1 a few frames
// later.
MissionComplete = byte(GetRealAddress(0x237434, 0x233EE4))

EGameState_Game = 0xF
EResultState_SuccessMedalAnim = 4
EResultState_SuccessIdle = 5
EResultMedal_Platinum = 0

// RICH PRESENCE START

TitleLookup = {
    EU: "Air Ranger: Rescue Helicopter",
    JP: "レスキューヘリ エアレンジャー",
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
    "Stretching Out a Helping Hand",
    "Quick Reaction",
    "Working Ferry Efficiently",
    "I Haven't Mist Anyone",
    "Ledge Get You Out of Here",
    "A Coordinated Rescue Mission",
    "I've Been Trained for This",
    "De-lightful Job",
]

MissionCompleteIDs = [411897, 411898, 411899, 411900, 411901, 411902, 411903, 411904]

MissionPerfectTitles = [
    "Flawless Flight",
    "Excellent Ecologist",
    "Shipwreck Savior",
    "Superb Sea Scanner",
    "Talented Transporter",
    "Skillful Seeker",
    "Risky Rail Rescuer",
    "First-Class Firefighter",
]

MissionPerfectIDs = [411905, 411906, 411908, 411909, 411910, 411911, 411912, 411913]

MissionStarCoinTitles = [
    "Starry Skyline",
    "Starry Overpass",
    "Starry Coast",
    "Starry Ocean",
    "Starry Mountain",
    "Starry Ravine",
    "Starry Tracks",
    "Starry Ocean",
]

MissionStarCoinIDs = [411914, 411915, 411916, 411917, 411918, 411919, 411920, 411921]

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
             when=GameState == EGameState_Game // && CurrentMissionID == mission_id // probably not necessary
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
        id=MissionCompleteIDs[i],
        title=MissionCompleteTitles[i],
        description=format("Complete {0}.", MissionNames[i]),
        points=partialPoints,
        trigger=MissionCompleteTrigger(i)
    )
    
    // Platinum medal achievements
    achievement(
        id=MissionPerfectIDs[i],
        title=MissionPerfectTitles[i],
        description=format("Complete {0} and obtain a platinum medal.", MissionNames[i]),
        points=fullPoints,
        trigger=MissionPerfectTrigger(i)
    )
    
    // Star Coin achievements
    achievement(
        id=MissionStarCoinIDs[i],
        title=MissionStarCoinTitles[i],
        description=format("Locate and pick up all Star Coins in {0}.", MissionNames[i]),
        points=5,
        trigger=MissionStarCoinsTrigger(i)
    )
}

// ACHIEVEMENTS END

// LEADERBOARDS START

function LeaderboardStart(mission_id)
{
    // This triggers as soon as player control is turned off when landing in-game,
    // a bit earlier than I would have liked but this is the latest possible point for frame-based precision
    return CurrentMissionID == mission_id &&
           prev(MissionComplete) == 0 &&
           MissionComplete == 1
}

function LeaderboardValue()
{
    return ResultTime / 60.0 * 100.0
}

LEADERBOARD_START_ID = 92674

for i in range(0, length(MissionNames) -1)
{
    leaderboard(
        id=LEADERBOARD_START_ID + i,
        title=format("{0} - Best Time", MissionNames[i]),
        description=format("Complete {0} as fast as possible!", MissionNames[i]),
        start=LeaderboardStart(i),
        cancel=always_false(),
        submit=always_true(),
        value=LeaderboardValue(),
        lower_is_better=true,
        format="MILLISECS"
    )
}

// LEADERBOARDS END

