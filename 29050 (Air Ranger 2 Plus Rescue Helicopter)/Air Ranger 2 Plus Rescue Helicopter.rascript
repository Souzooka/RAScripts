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

// Current heli
Heli = dword(0x2774E0)
// If a replay is happening
Replay = byte(0x277574)
// Current/last menu
Menu = word(0x277AD4)
// Current mission (or free flight location) undertaken
Mission = dword(0x2774DC)
// If the current mission was successful
MissionSuccess = word(0x277D2C)
// Current game mode
Mode = dword(0x2774E4)
// Weather
Weather = dword(0x277764)
// Windspeed
WindPtr = dword(0x002775a8)
WindSpeed = ResolvePointer(WindPtr, [0x604])

// ENUMERATIONS

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

function IsFreeFlight()
{
    return Menu == MENU_FREEFLIGHT
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
    FREEFLIGHT_HARIMA: "Free-flying near Harima Mountain",
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
    MISSION_RM1: "Searching for survivors of a small plane crash on Harima Mountain",
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
    IsInGame() && !IsFreeFlight(),
    "{0}{1} | {2} | {3} | 💨 {4}m",
    rich_presence_lookup("MISSION", Mission, MissionLookup),
    rich_presence_lookup("REPLAY", Replay, ReplayLookup),
    rich_presence_lookup("HELI", Heli, HeliLookup),
    rich_presence_lookup("WEATHER", Weather, WeatherLookup),
    rich_presence_value("WINDSPEED", WindSpeed)
)
// In Free Flight
rich_presence_conditional_display(
    IsInGame() && IsFreeFlight(),
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
           // We're not in a free flight
           !IsFreeFlight() &&
           // We entered the result mode
           prev(Mode) != MODE_RESULT &&
           Mode == MODE_RESULT
}

MissionAchievements = {
    MISSION_PROLOGUE: {
        "id": 0,
        "title": "New Aspirations",
        "points": 1,
        "name": "the prologue",
        "objective": "",
    },
    MISSION_TRIAL1: {
        "id": 0,
        "title": "SIGHTSEEING FLIGHT",
        "points": 5,
        "name": "Trial 1: \"Sightseeing Flight\"",
        "objective": " by earning at least $50",
    },
    MISSION_TRIAL2: {
        "id": 0,
        "title": "HELI TAXI",
        "points": 5,
        "name": "Trial 2: \"Heli Taxi\"",
        "objective": " by delivering at least 4 passengers",
    },
    MISSION_TRIAL3: {
        "id": 0,
        "title": "MIDAIR RECORDING",
        "points": 5,
        "name": "Trial 3: \"Midair Recording\"",
        "objective": " by obtaining a recording quality of at least 35%",
    },
    MISSION_TRIAL4: {
        "id": 0,
        "title": "TRANSPORT",
        "points": 5,
        "name": "Trial 4: \"Transport\"",
        "objective": " by hitting at least 8 targets with your cargo",
    },
    MISSION_TRIAL5: {
        "id": 0,
        "title": "HIT THE TARGET",
        "points": 5,
        "name": "Trial 5: \"Hit the Target\"",
        "objective": " by earning at least 20 points",
    },
    MISSION_TRIAL6: {
        "id": 0,
        "title": "BALLOON POPPING",
        "points": 5,
        "name": "Trial 1: \"Balloon Popping\"",
        "objective": " by popping at least 35 balloons",
    },
    MISSION_RM1: {
        "id": 0,
        "title": "RM HARIMA MOUNTAIN",
        "points": 5,
        "name": "Rescue Mission 1: \"Harima Mountain\"",
        "objective": "",
    },
    MISSION_RM2: {
        "id": 0,
        "title": "RM TONBU BEACH",
        "points": 5,
        "name": "Rescue Mission 2: \"Tonbu Beach\"",
        "objective": "",
    },
    MISSION_RM3: {
        "id": 0,
        "title": "RM AMARAO PLATEAU 1",
        "points": 5,
        "name": "Rescue Mission 3: \"Amarao Plateau 1\"",
        "objective": "",
    },
    MISSION_RM4: {
        "id": 0,
        "title": "RM MORGANSVILLE",
        "points": 10,
        "name": "Rescue Mission 4: \"Morgansville\"",
        "objective": "",
    },
    MISSION_RM5: {
        "id": 0,
        "title": "RM SCHWEITZER",
        "points": 10,
        "name": "Rescue Mission 5: \"Schweitzer\"",
        "objective": "",
    },
    MISSION_RM6: {
        "id": 0,
        "title": "RM NEW CANAL CITY 1",
        "points": 10,
        "name": "Rescue Mission 6: \"New Canal City 1\"",
        "objective": "",
    },
    MISSION_RM7: {
        "id": 0,
        "title": "RM KONPA KONPA ISLANDS",
        "points": 5,
        "name": "Rescue Mission 7: \"Konpa Konpa Islands\"",
        "objective": "",
    },
    MISSION_RM8: {
        "id": 0,
        "title": "RM AMARAO PLATEAU 2",
        "points": 5,
        "name": "Rescue Mission 8: \"Amarao Plateau 2\"",
        "objective": "",
    },
    MISSION_RM9: {
        "id": 0,
        "title": "RM NEW CANAL CITY 2",
        "points": 10,
        "name": "Rescue Mission 9: \"New Canal City 2\"",
        "objective": "",
    },
    MISSION_RM10: {
        "id": 0,
        "title": "Master Pilot",
        "points": 10,
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

// ACHIEVEMENTS END
