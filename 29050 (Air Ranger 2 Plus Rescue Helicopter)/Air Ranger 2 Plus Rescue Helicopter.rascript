// Air Ranger 2 Plus: Rescue Helicopter
// #ID = 29050

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

function ResolvePointer(base, offsets, accessor=dword)
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

// GAME VARIABLES

// If Free Flight is active
FreeFlight = word(0x277D48)
// If the giga engine is active
GigaEngine = bit(1, 0x3736BF)
// Current heli
Heli = dword(0x2774E0)
// Array of bitsets indicating which helicopters have completed each rescue mission
HeliClears = 0x3736C0
// Current/last menu
Menu = word(0x277AD4)
// Current mission (or free flight location) undertaken
Mission = dword(0x2774DC)
// 32-bit bitset of cleared missions, indexed by mission ID
MissionsCleared = dword(0x37359C)
// The custom scoring metric for trials
MissionScore = word(0x277D38)
// If the current mission was successful
MissionSuccess = word(0x277D2C)
// How many seconds were spent in the mission (set on mission finish)
MissionTime = dword(0x277D34)
// Current game mode
Mode = dword(0x2774E4)
// If a replay is happening
Replay = byte(0x277574)
// Array of star coin bitsets per locale
StarCoins = 0x3736CA
// Weather
Weather = dword(0x277764)
// Windspeed
WindPtr = dword(0x002775a8)
WindSpeed = ResolvePointer(WindPtr, [0x604])

// ENUMERATIONS

// Areas (not used by the game -- this is how we index Star Coins)
AREA_KOPAN_KOPAN_DAY = 0
AREA_NEW_CANAL_DAY = 1
AREA_NEW_CANAL_NIGHT = 2
AREA_KOPAN_KOPAN_SUNSET = 3
AREA_HARIMA = 4
AREA_TONBU = 5
AREA_AMARAO = 6
AREA_MORGANSVILLE = 7
AREA_SCHWEITZER = 8
AREA_WAHINA_ROMA = 9

// Helis
HELI_300CB = 0
HELI_OH_6D = 1
HELI_BK_117_B = 2
HELI_AS365N2 = 3
HELI_MH_53E = 4
HELI_CH_47J = 5

// Menus
MENU_FREEFLIGHT = 0xB

// Missions
MISSION_PROLOGUE = 0x17
MISSION_LESSON1 = 0x0
MISSION_LESSON2 = 0x1
MISSION_LESSON3 = 0x2
MISSION_LESSON4 = 0x3
MISSION_LESSON5 = 0x4
MISSION_LESSON6 = 0x5
MISSION_TRIAL1 = 0x6
MISSION_TRIAL2 = 0x7
MISSION_TRIAL3 = 0x8
MISSION_TRIAL4 = 0x9
MISSION_TRIAL5 = 0xA
MISSION_TRIAL6 = 0xB
MISSION_TRIAL7 = 0xC
MISSION_RM1 = 0xD
MISSION_RM2 = 0xF
MISSION_RM3 = 0x15
MISSION_RM4 = 0x11
MISSION_RM5 = 0x10
MISSION_RM6 = 0x13
MISSION_RM7 = 0x14
MISSION_RM8 = 0xE
MISSION_RM9 = 0x16
MISSION_RM10 = 0x12
FREEFLIGHT_MENADO = 0x0
FREEFLIGHT_KOPAN_KOPAN = 0x6
FREEFLIGHT_NEW_CANAL_DAY = 0x7
FREEFLIGHT_NEW_CANAL_NIGHT = 0x8
FREEFLIGHT_HARIMA = 0xD
FREEFLIGHT_AMARAO = 0xE
FREEFLIGHT_TONBU = 0xF
FREEFLIGHT_SCHWEITZER = 0x10
FREEFLIGHT_MORGANSVILLE = 0x11
FREEFLIGHT_WAHINA_ROMA = 0x12

// Modes
MODE_IN_GAME = 0x1
MODE_RESULT = 0x1F

// Weather
WEATHER_SUNNY = 0x0
WEATHER_LIGHT_CLOUDS = 0x1
WEATHER_HEAVY_CLOUDS = 0x2
WEATHER_LIGHT_RAIN = 0x3
WEATHER_MEDIUM_RAIN = 0x4
WEATHER_HEAVY_RAIN = 0x5
WEATHER_LIGHT_SNOW = 0x6
WEATHER_HEAVY_SNOW = 0x7

// MISC. GAME HELPERS

function IsReplay()
{
    return Replay == 1
}

function IsInGame()
{
    // We check for the existence of wind data otherwise we might get some invalid readings for RP
    // while loading
    return Mode == MODE_IN_GAME && WindPtr != NULL
}

// RICH PRESENCE START

HeliLookup = {
    HELI_300CB: "🚁 300CB",
    HELI_OH_6D: "🚁 OH-6D",
    HELI_BK_117_B: "🚁 BK_117_B",
    HELI_AS365N2: "🚁 AS365N2",
    HELI_MH_53E: "🚁 MH-53E",
    HELI_CH_47J: "🚁 CH-47J",
}

FreeFlightLookup = {
    FREEFLIGHT_MENADO: "Free-flying in the Menado Desert",
    FREEFLIGHT_KOPAN_KOPAN: "Free-flying near the Konpa Konpa Islands",
    FREEFLIGHT_NEW_CANAL_DAY: "Free-flying in New Canal City during the day",
    FREEFLIGHT_NEW_CANAL_NIGHT: "Free-flying in New Canal City during the night",
    FREEFLIGHT_HARIMA: "Free-flying around the Harima Mountains",
    FREEFLIGHT_AMARAO: "Free-flying near the Amarao Plateau",
    FREEFLIGHT_TONBU: "Free-flying at Tonbu Beach",
    FREEFLIGHT_SCHWEITZER: "Free-flying near Schweitzer Village",
    FREEFLIGHT_MORGANSVILLE: "Free-flying in Morgansville",
    FREEFLIGHT_WAHINA_ROMA: "Free-flying near the Wahina Roma Volcano",
}

MissionLookup = {
    MISSION_PROLOGUE: "Rescuing Chris and their father in the Prologue",
    MISSION_LESSON1: "Learning how to take off, maintain level flight, and land in Alpha Aviation School",
    MISSION_LESSON2: "Learning how to read their instruments in Alpha Aviation School",
    MISSION_LESSON3: "Learning how to hover in Alpha Aviation School",
    MISSION_LESSON4: "Learning how to fly at speed in Alpha Aviation School",
    MISSION_LESSON5: "Learning how to taxi in Alpha Aviation School",
    MISSION_LESSON6: "Learning how to land safely with a broken engine in Alpha Aviation School",
    MISSION_TRIAL1: "Undergoing a sightseeing flight on the Konpa Konpa Islands",
    MISSION_TRIAL2: "Delivering customers as a helicopter taxi in New Canal City",
    MISSION_TRIAL3: "Filming a car chase in New Canal City",
    MISSION_TRIAL4: "Transporting a ball through some rings on the Konpa Konpa Islands",
    MISSION_TRIAL5: "Hitting some targets with paintballs on the Konpa Konpa Islands",
    MISSION_TRIAL6: "Popping some balloons on Konpa Konpa Island",
    MISSION_RM1: "Searching for survivors of a small plane crash in the Harima Mountains",
    MISSION_RM2: "Putting out fires and airlifting survivors from a hotel on Tonbu Beach",
    MISSION_RM3: "Searching for passengers who parachuted out of a shot-down plane in the Amarao Plateau",
    MISSION_RM4: "Airlifting civilians away from the path of a tornado in Morgansville",
    MISSION_RM5: "Airlifting flooding victims to safety from Schweitzer Village",
    MISSION_RM6: "Rescuing passengers from a bus which will explode if its speed gets too low in New Canal City",
    MISSION_RM7: "Rescuing passengers of a shipwreck off a volcano near the Konpa Konpa Islands",
    MISSION_RM8: "Delivering supplies to evacuees in the Amarao Plateau",
    MISSION_RM9: "Herding escaped animals in New Canal City",
    MISSION_RM10: "Evacuating civilians near the Wahina Roma Volcano",
}

ReplayLookup = {
    False: "",
    True: " (watching replay)",
}

WeatherLookup = {
    WEATHER_SUNNY: "☀️ Clear",
    WEATHER_LIGHT_CLOUDS: "☁️ Lightly Cloudy",
    WEATHER_HEAVY_CLOUDS: "☁️☁️ Overcast",
    WEATHER_LIGHT_RAIN: "🌧️ Rain",
    WEATHER_MEDIUM_RAIN: "🌧️ Heavy Rain",
    WEATHER_HEAVY_RAIN: "⛈️ Thunderstorms",
    WEATHER_LIGHT_SNOW: "❄️ Snow",
    WEATHER_HEAVY_SNOW: "🌨️ Blizzard",
}

// In mission
rich_presence_conditional_display(
    IsInGame() && FreeFlight == False,
    "{0}{1} | {2} | {3} | 💨 {4}m",
    rich_presence_lookup("MISSION", Mission, MissionLookup),
    rich_presence_lookup("REPLAY", Replay, ReplayLookup),
    rich_presence_lookup("HELI", Heli, HeliLookup),
    rich_presence_lookup("WEATHER", Weather, WeatherLookup),
    rich_presence_value("WINDSPEED", WindSpeed)
)
// In Free Flight
rich_presence_conditional_display(
    IsInGame() && FreeFlight == False,
    "{0}{1} | {2} | {3} | 💨 {4}m",
    rich_presence_lookup("FREEFLIGHT", Mission, FreeFlightLookup),
    rich_presence_lookup("REPLAY", Replay, ReplayLookup),
    rich_presence_lookup("HELI", Heli, HeliLookup),
    rich_presence_lookup("WEATHER", Weather, WeatherLookup),
    rich_presence_value("WINDSPEED", WindSpeed)
)
rich_presence_display("In a menu or loading screen")


// RICH PRESENCE END

// ACHIEVEMENTS START

// Prologue, Trials, Rescue Missions
// For lessons I want to check if all are completed -- this is tracked somewhere else in the background but I gotta find it
function MissionSuccessTrigger(mission)
{
    // TODO: Fine-tine the timing of this to pop at a certain point in the result state?
    
           // We completed the mission
    return MissionSuccess == True &&
           // The current mission matches
           Mission == mission &&
           // We're not in a free flight (this seems unnecessary)
           //FreeFlight == False &&
           // We entered the result mode
           prev(Mode) != MODE_RESULT &&
           Mode == MODE_RESULT
}

MissionAchievements = {
    MISSION_PROLOGUE: {
        "id": 419354,
        "title": "New Aspirations",
        "points": 1,
        "name": "the prologue",
        "objective": "",
    },
    MISSION_TRIAL1: {
        "id": 419340,
        "title": "SIGHTSEEING FLIGHT",
        "points": 5,
        "name": "Trial 1: \"Sightseeing Flight\"",
        "objective": " by earning at least $50",
    },
    MISSION_TRIAL2: {
        "id": 419341,
        "title": "HELI TAXI",
        "points": 5,
        "name": "Trial 2: \"Heli Taxi\"",
        "objective": " by delivering at least 4 passengers",
    },
    MISSION_TRIAL3: {
        "id": 419342,
        "title": "MIDAIR REPORT",
        "points": 5,
        "name": "Trial 3: \"Midair Report\"",
        "objective": " by obtaining viewer ratings of at least 35%",
    },
    MISSION_TRIAL4: {
        "id": 419343,
        "title": "TRANSPORT",
        "points": 5,
        "name": "Trial 4: \"Transport\"",
        "objective": " by hitting at least 8 targets with your cargo",
    },
    MISSION_TRIAL5: {
        "id": 419344,
        "title": "HIT THE TARGET",
        "points": 5,
        "name": "Trial 5: \"Hit the Target\"",
        "objective": " by earning at least 20 points",
    },
    MISSION_TRIAL6: {
        "id": 419345,
        "title": "BALLOON POPPING",
        "points": 5,
        "name": "Trial 6: \"Balloon Popping\"",
        "objective": " by popping at least 35 balloons",
    },
    MISSION_RM1: {
        "id": 419355,
        "title": "RM HARIMA MOUNTAINS",
        "points": 5,
        "name": "Rescue Mission 1: \"Harima Mountains\"",
        "objective": "",
    },
    MISSION_RM2: {
        "id": 419347,
        "title": "RM TONBU BEACH",
        "points": 5,
        "name": "Rescue Mission 2: \"Tonbu Beach\"",
        "objective": "",
    },
    MISSION_RM3: {
        "id": 419353,
        "title": "RM AMARAO PLATEAU 1",
        "points": 5,
        "name": "Rescue Mission 3: \"Amarao Plateau 1\"",
        "objective": "",
    },
    MISSION_RM4: {
        "id": 419349,
        "title": "RM MORGANSVILLE",
        "points": 10,
        "name": "Rescue Mission 4: \"Morgansville\"",
        "objective": "",
    },
    MISSION_RM5: {
        "id": 419348,
        "title": "RM SCHWEITZER",
        "points": 10,
        "name": "Rescue Mission 5: \"Schweitzer\"",
        "objective": "",
    },
    MISSION_RM6: {
        "id": 419351,
        "title": "Like Speed, but with a Helicopter",
        "points": 10,
        "name": "Rescue Mission 6: \"New Canal City 1\"",
        "objective": "",
    },
    MISSION_RM7: {
        "id": 419352,
        "title": "RM KONPA KONPA ISLANDS",
        "points": 5,
        "name": "Rescue Mission 7: \"Konpa Konpa Islands\"",
        "objective": "",
    },
    MISSION_RM8: {
        "id": 419346,
        "title": "RM AMARAO PLATEAU 2",
        "points": 5,
        "name": "Rescue Mission 8: \"Amarao Plateau 2\"",
        "objective": "",
    },
    MISSION_RM9: {
        "id": 419369,
        "title": "RM NEW CANAL CITY 2",
        "points": 10,
        "name": "Rescue Mission 9: \"New Canal City 2\"",
        "objective": "",
    },
    MISSION_RM10: {
        "id": 419350,
        "title": "Master Pilot",
        "points": 25,
        "name": "Rescue Mission 10: \"Wahina Roma Volcano\"",
        "objective": "",
    },
}

for mission in MissionAchievements
{
    params = MissionAchievements[mission]
    achievement(
        id=params["id"],
        title=params["title"],
        description=format("Complete {0}{1}.", params["name"], params["objective"]),
        points=params["points"],
        trigger=MissionSuccessTrigger(mission),
        type=if_else(mission == MISSION_RM10, "win_condition", "progression")
    )
}

// Lessons

function AllLessonsTrigger()
{
           // In results screen
    return Mode == MODE_RESULT &&
           // The first 6 bits of the missions cleared bitset have been set (indicating we completed all six lessons)
           prev(MissionsCleared) & 0x3F != 0x3F &&
           MissionsCleared & 0x3F == 0x3F
}

achievement(
    id=419370,
    title="Certified Pilot",
    description="Complete all of the lessons in the Alpha Aviation School.",
    points=10,
    trigger=AllLessonsTrigger(),
    type="progression"
)

// Trials (Challenge)

function ChallengeMissionTrigger(mission, target)
{
           // We completed the mission
    return MissionSuccess == True &&
           // The current mission matches
           Mission == mission &&
           // We earned a high enough score to meet the target
           MissionScore >= target &&
           // We entered the result mode
           prev(Mode) != MODE_RESULT &&
           Mode == MODE_RESULT
}

ChallengeMissionAchievements = {
    MISSION_TRIAL1: {
        "id": 419371,
        "title": "SIGHTSEEING FLIGHT EX",
        "points": 10,
        "target": 80,
        "description": "Complete Trial 1: \"Sightseeing Flight\" and earn at least ${0}.",
    },
    MISSION_TRIAL2: {
        "id": 419356,
        "title": "HELI TAXI EX",
        "points": 10,
        "target": 7,
        "description": "Complete Trial 2: \"Heli Taxi\" and deliver at least {0} passengers.",
    },
    MISSION_TRIAL3: {
        "id": 419372,
        "title": "You're a Psycho!",
        "points": 10,
        "target": 95,
        "description": "Complete Trial 3: \"Midair Report\" and have viewer ratings of at least {0}%. You can obtain better footage by getting very close to the suspect car!",
    },
    MISSION_TRIAL4: {
        "id": 419357,
        "title": "TRANSPORT EX",
        "points": 10,
        "target": 20,
        "description": "Complete Trial 4: \"Transport\" and hit at least {0} targets with your cargo.",
    },
    MISSION_TRIAL5: {
        "id": 419373,
        "title": "HIT THE TARGET EX",
        "points": 10,
        "target": 40,
        "description": "Complete Trial 5: \"Hit the Target\" and earn at least {0} points.",
    },
    MISSION_TRIAL6: {
        "id": 419358,
        "title": "BALLOON POPPING EX",
        "points": 10,
        "target": 50,
        "description": "Complete Trial 6: \"Balloon Popping\" and pop at least {0} balloons.",
    },
}

for mission in ChallengeMissionAchievements
{
    params = ChallengeMissionAchievements[mission]
    target = params["target"]
    description = format(params["description"], target)
    
    achievement(
        id=params["id"],
        title=params["title"],
        description=description,
        points=params["points"],
        trigger=ChallengeMissionTrigger(mission, target)
    )
}

// Trial 7 baybee

function Trial7Trigger()
{
    minutes = 2
    seconds = 30
    time = minutes * 60 + seconds

           // yadayada current mission
    return Mission == MISSION_TRIAL7 &&
           // mission success
           MissionSuccess == 1 &&
           // mission time
           MissionTime <= time &&
           // results mode
           Mode == MODE_RESULT &&
           prev(Mode) != MODE_RESULT
}

achievement(
    id=419374,
    title="TRIATHLON",
    description="Complete Trial 7: \"Triathlon\" in 2 minutes and 30 seconds or less.",
    points=10,
    trigger=Trial7Trigger()
)

// Now we get into the *really* dumb stuff
// Star Coins (is it me or is there nowhere in this game to check what coins you've collected in a locale??? What trash)

// It'd be nice to measure a combination of the temporary star coin storage (@ 0x373023) plus the permanent storage (saved in result screen to 0x3736CA)
// However, RA's toolkit is graceful enough to alleviate us of that burden due to its limitations
// We should try to have the measurement ALWAYS ACTIVE so players can actually check their coin progress!!!!

function StarCoinsTrigger(area)
{
           // Always measure to make up for the UX sins of Garden Ltd.
    return measured(bitcount(StarCoins + area) == 5) &&
           prev(bitcount(StarCoins + area)) != 5 &&
           // Star Coins get set on the result screen, so check that also as save protection
           Mode == MODE_RESULT
}

AREA_KOPAN_KOPAN_DAY = 0
AREA_NEW_CANAL_DAY = 1
AREA_NEW_CANAL_NIGHT = 2
AREA_KOPAN_KOPAN_SUNSET = 3
AREA_HARIMA = 4
AREA_TONBU = 5
AREA_AMARAO = 6
AREA_MORGANSVILLE = 7
AREA_SCHWEITZER = 8
AREA_WAHINA_ROMA = 9

StarCoinsAchievements = {
    AREA_KOPAN_KOPAN_DAY: {
        "id": 419359,
        "title": "STAR KOPAN KOPAN DAY",
        "description": "Collect all 5 Star Coins in the Kopan Kopan Islands during the day (Trial 1/4/5/6).",
        "points": 5,
    },
    AREA_NEW_CANAL_DAY: {
        "id": 419375,
        "title": "STAR NEW CANAL CITY DAY",
        "description": "Collect all 5 Star Coins in New Canal City during the day (Trial 2, Rescue Mission 6/9).",
        "points": 5,
    },
    AREA_NEW_CANAL_NIGHT: {
        "id": 419376,
        "title": "STAR NEW CANAL CITY NIGHT",
        "description": "Collect all 5 Star Coins in New Canal City during the night (Trial 3).",
        "points": 5,
    },
    AREA_KOPAN_KOPAN_SUNSET: {
        "id": 419360,
        "title": "STAR KOPAN KOPAN SUNSET",
        "description": "Collect all 5 Star Coins in the Kopan Kopan Islands during the sunset (Trial 7, Rescue Mission 7).",
        "points": 5,
    },
    AREA_HARIMA: {
        "id": 419361,
        "title": "STAR HARIMA",
        "description": "Collect all 5 Star Coins around Harima Mountains (Rescue Mission 1).",
        "points": 5,
    },
    AREA_TONBU: {
        "id": 419377,
        "title": "STAR TONBU",
        "description": "Collect all 5 Star Coins on Tonbu Beach (Rescue Mission 2).",
        "points": 5,
    },
    AREA_AMARAO: {
        "id": 419362,
        "title": "STAR AMARAO",
        "description": "Collect all 5 Star Coins in the Amarao Plateau (Rescue Mission 3/8).",
        "points": 5,
    },
    AREA_MORGANSVILLE: {
        "id": 419378,
        "title": "STAR MORGANSVILLE",
        "description": "Collect all 5 Star Coins in Morgansville (Rescue Mission 4).",
        "points": 5,
    },
    AREA_SCHWEITZER: {
        "id": 419379,
        "title": "STAR SCHWEITZER VILLAGE",
        "description": "Collect all 5 Star Coins around Schweitzer Village (Rescue Mission 5).",
        "points": 5,
    },
    AREA_WAHINA_ROMA: {
        "id": 419363,
        "title": "STAR WAHINA ROMA VOLCANO",
        "description": "Collect all 5 Star Coins around the Wahina Roma Volcano (Rescue Mission 10).",
        "points": 5,
    },
}

for area in StarCoinsAchievements
{
    params = StarCoinsAchievements[area]
    achievement(
        id=params["id"],
        title=params["title"],
        description=params["description"] + " New progress is evaluated when a mission is concluded.",
        points=params["points"],
        trigger=StarCoinsTrigger(area)
    )
}

// Complete all rescue missions as every helicopter type (why????)
// This unlocks the Giga Engine...

function HeliClearTrigger(mission)
{
           // Count those heli clears
    return measured(bitcount(HeliClears + (mission - MISSION_RM1)) == 5) &&
           prev(bitcount(HeliClears + (mission - MISSION_RM1))) != 5 &&
           // Save protection
           Mode == MODE_RESULT
}

HeliClearAchievements = {
    MISSION_RM1: {
        "id": 419380,
        "title": "CH HARIMA MOUNTAINS",
        "points": 10,
        "name": "Rescue Mission 1: \"Harima Mountains\"",
    },
    MISSION_RM2: {
        "id": 419381,
        "title": "CH TONBU BEACH",
        "points": 10,
        "name": "Rescue Mission 2: \"Tonbu Beach\"",
    },
    MISSION_RM3: {
        "id": 419384,
        "title": "CH AMARAO PLATEAU 1",
        "points": 10,
        "name": "Rescue Mission 3: \"Amarao Plateau 1\"",
    },
    MISSION_RM4: {
        "id": 419382,
        "title": "CH MORGANSVILLE",
        "points": 10,
        "name": "Rescue Mission 4: \"Morgansville\"",
    },
    MISSION_RM5: {
        "id": 419365,
        "title": "CH SCHWEITZER",
        "points": 10,
        "name": "Rescue Mission 5: \"Schweitzer\"",
    },
    MISSION_RM6: {
        "id": 419383,
        "title": "CH NEW CANAL CITY 1",
        "points": 10,
        "name": "Rescue Mission 6: \"New Canal City 1\"",
    },
    MISSION_RM7: {
        "id": 419367,
        "title": "CH KONPA KONPA ISLANDS",
        "points": 10,
        "name": "Rescue Mission 7: \"Konpa Konpa Islands\"",
    },
    MISSION_RM8: {
        "id": 419364,
        "title": "CH AMARAO PLATEAU 2",
        "points": 10,
        "name": "Rescue Mission 8: \"Amarao Plateau 2\"",
    },
    MISSION_RM9: {
        "id": 419368,
        "title": "CH NEW CANAL CITY 2",
        "points": 25,
        "name": "Rescue Mission 9: \"New Canal City 2\"",
    },
    MISSION_RM10: {
        "id": 419366,
        "title": "CH WAHIMA ROMA VOLCANO",
        "points": 25,
        "name": "Rescue Mission 10: \"Wahina Roma Volcano\"",
    },
}

for mission in HeliClearAchievements
{
    params = HeliClearAchievements[mission]
    achievement(
        id=params["id"],
        title=params["title"],
        description=format("Complete {0} with all 5 available helicopter types.", params["name"]),
        points=params["points"],
        trigger=HeliClearTrigger(mission)
    )
}
// ACHIEVEMENTS END

// LEADERBOARDS START

// Trials 1-6 (Score attack)

ScoreLeaderboards = {
    MISSION_TRIAL1: {
        "id": 95872,
        "title": "Sightseeing Flight - Score Attack",
        "description": "Finish Trial 1: \"Sightseeing Flight\" with the greatest amount of cash earned!",
    },
    MISSION_TRIAL2: {
        "id": 95873,
        "title": "Heli Taxi - Score Attack",
        "description": "Finish Trial 2: \"Heli Taxi\" with the greatest amount of passengers delivered!",
    },
    MISSION_TRIAL3: {
        "id": 95874,
        "title": "Midair Report - Score Attack",
        "description": "Finish Trial 3: \"Midair Report\" with the best viewer ratings!",
    },
    MISSION_TRIAL4: {
        "id": 95875,
        "title": "Transport - Score Attack",
        "description": "Finish Trial 4: \"Transport\" while hitting the most targets with your cargo!",
    },
    MISSION_TRIAL5: {
        "id": 95876,
        "title": "Hit the Target - Score Attack",
        "description": "Finish Trial 5: \"Hit the Target\" with the greatest amount of points!",
    },
    MISSION_TRIAL6: {
        "id": 95877,
        "title": "Balloon Popping - Score Attack",
        "description": "Finish Trial 6: \"Balloon Popping\" with the greatest amount of balloons popped!",
    },
}

TimeLeaderboards = {
    MISSION_TRIAL7: {
        "id": 95878,
        "title": "Triathlon - Time Attack",
        "name": "Trial 7: \"Triathlon\"",
    },
    MISSION_RM1: {
        "id": 95879,
        "title": "Harima Mountains - Time Attack",
        "name": "Rescue Mission 1: \"Harima Mountains\"",
    },
    MISSION_RM2: {
        "id": 95881,
        "title": "Tonbu Beach - Time Attack",
        "name": "Rescue Mission 2: \"Tonbu Beach\"",
    },
    MISSION_RM3: {
        "id": 95887,
        "title": "Amarao Plateau 1 - Time Attack",
        "name": "Rescue Mission 3: \"Amarao Plateau 1\"",
    },
    MISSION_RM4: {
        "id": 95883,
        "title": "Morgansville - Time Attack",
        "name": "Rescue Mission 4: \"Morgansville\"",
    },
    MISSION_RM5: {
        "id": 95882,
        "title": "Schweitzer - Time Attack",
        "name": "Rescue Mission 5: \"Schweitzer\"",
    },
    MISSION_RM6: {
        "id": 95885,
        "title": "New Canal City 1 - Time Attack",
        "name": "Rescue Mission 6: \"New Canal City 1\"",
    },
    MISSION_RM7: {
        "id": 95886,
        "title": "Konpa Konpa Islands - Time Attack",
        "name": "Rescue Mission 7: \"Konpa Konpa Islands\"",
    },
    MISSION_RM8: {
        "id": 95880,
        "title": "Amarao Plateau 2 - Time Attack",
        "name": "Rescue Mission 8: \"Amarao Plateau 2\"",
    },
    MISSION_RM9: {
        "id": 95888,
        "title": "New Canal City 2 - Time Attack",
        "name": "Rescue Mission 9: \"New Canal City 2\"",
    },
    MISSION_RM10: {
        "id": 95884,
        "title": "Wahina Roma Volcano - Time Attack",
        "name": "Rescue Mission 10: \"Wahina Roma Volcano\"",
    },
}

for mission in ScoreLeaderboards
{
    params = ScoreLeaderboards[mission]

    leaderboard(
        id=params["id"],
        title=params["title"],
        description=params["description"] + " Use of the giga engine is disallowed.",
              // Correct mission
        start=Mission == mission &&
              // Mission success
              MissionSuccess == True &&
              // Giga Engine is banned
              GigaEngine == False &&
              // Transition to mission result
              Mode == MODE_RESULT &&
              prev(Mode) != MODE_RESULT,
        cancel=always_false(),
        submit=always_true(),
        value=MissionScore
    )
}

for mission in TimeLeaderboards
{
    params = TimeLeaderboards[mission]
    
    leaderboard(
        id=params["id"],
        title=params["title"],
        description=format("Finish {0} as quickly as possible! Use of the giga engine is disallowed.", params["name"]),
              // Correct mission
        start=Mission == mission &&
              // Mission success
              MissionSuccess == True &&
              // Giga Engine is banned
              GigaEngine == False &&
              // Transition to mission result
              Mode == MODE_RESULT &&
              prev(Mode) != MODE_RESULT,
        cancel=always_false(),
        submit=always_true(),
        value=MissionTime,
        format="SECS",
        lower_is_better=true
    )
}

// LEADERBOARDS END

