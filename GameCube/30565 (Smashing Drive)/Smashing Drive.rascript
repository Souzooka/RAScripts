// Smashing Drive
// #ID = 30565

function if_else(cond, a, b)
{
    if cond
        return a
    return b
}

u8 = byte
u16 = word_be
u32 = dword_be
f32 = float_be

g_game_mode = u32(0xf1a48)

GAME_MODE_ARCADE = 0x0
GAME_MODE_SURVIVAL = 0x1
GAME_MODE_MULTI = 0x2

g_game_state = u32(0x1ee660)
g_game_state_sub = u32(0x1ee664)

GAME_STATE_MENU = 0x1
GAME_STATE_DRIVING_START = 0xB
GAME_STATE_DRIVING = 0x4
GAME_STATE_HIT_GOAL = 0x5
GAME_STATE_GOAL = 0x6

GAME_STATE_SUB_DEMO = 0x4
GAME_STATE_SUB_DRIVING = 0x6
GAME_STATE_SUB_INSERT_NAME = 0x7

g_route_id = u16(0x1ee7a2)

ROUTE_EARLYBIRD_1 = 1
ROUTE_EARLYBIRD_2 = 2
ROUTE_EARLYBIRD_3 = 3
ROUTE_RUSHHOUR_1 = 4
ROUTE_RUSHHOUR_2 = 5
ROUTE_RUSHHOUR_3 = 6
ROUTE_NIGHTOWL_1 = 7
ROUTE_NIGHTOWL_2 = 8
ROUTE_NIGHTOWL_3 = 9
ROUTE_DUSKANDWIRED = 10
ROUTE_EARLYBIRD_BONUS = 11
ROUTE_RUSHHOUR_BONUS = 12
ROUTE_NIGHTOWL_BONUS = 13

g_route_time = u32(0x1ee808)

g_risky_routes = u32(0x1ee8ac)

g_score = f32(0x1ee904)

g_bonus_route_pct = f32(0x1ee998)

g_boosters_obtained = u32(0x1ee9e0)

function InDemo()
{
    return g_game_state_sub == GAME_STATE_SUB_DEMO
}

function RouteFinished(route_id)
{
    // Normal routes
    sub_cond =
        prev(g_game_state) == GAME_STATE_DRIVING &&
        g_game_state == GAME_STATE_HIT_GOAL
    if route_id >= ROUTE_EARLYBIRD_BONUS
    {
        // Bonus routes
        // Need to check bonus route completion and that's
        // set just slightly later than hitting the goal
        sub_cond =
            prev(g_game_state) == GAME_STATE_HIT_GOAL &&
            g_game_state == GAME_STATE_GOAL &&
            g_bonus_route_pct == 100.0 
    }

    return
        !InDemo() &&
        g_route_id == route_id &&
        g_game_mode != GAME_MODE_MULTI &&
        g_game_state_sub == GAME_STATE_SUB_DRIVING &&
        sub_cond
}

ROUTE_NAMES = {
    ROUTE_EARLYBIRD_1: {
        "route": "Early Bird",
        "leg": "To Brooklyn",
    },
    ROUTE_EARLYBIRD_2: {
        "route": "Early Bird",
        "leg": "To Wall Street",
    },
    ROUTE_EARLYBIRD_3: {
        "route": "Early Bird",
        "leg": "To Little Italy",
    },
    ROUTE_EARLYBIRD_BONUS: {
        "route": "Early Bird",
        "leg": "Bonus Route",
    },
    ROUTE_RUSHHOUR_1: {
        "route": "Rush Hour",
        "leg": "To Brooklyn Navy Yard",
    },
    ROUTE_RUSHHOUR_2: {
        "route": "Rush Hour",
        "leg": "To The Music City Hall",
    },
    ROUTE_RUSHHOUR_3: {
        "route": "Rush Hour",
        "leg": "To West Central Park",
    },
    ROUTE_RUSHHOUR_BONUS: {
        "route": "Rush Hour",
        "leg": "Bonus Route",
    },
    ROUTE_NIGHTOWL_1: {
        "route": "Night Owl",
        "leg": "To Sea & Air Museum",
    },
    ROUTE_NIGHTOWL_2: {
        "route": "Night Owl",
        "leg": "To 5th Ave - 34 St",
    },
    ROUTE_NIGHTOWL_3: {
        "route": "Night Owl",
        "leg": "To Times Square",
    },
    ROUTE_NIGHTOWL_BONUS: {
        "route": "Night Owl",
        "leg": "Bonus Route",
    },
    ROUTE_DUSKANDWIRED: {
        "route": "Dusk & Wired",
        "leg": "To The Statue of Liberty",
    },
}

leaderboard(
    id=171579,
    title="High Score",
    description="Obtain the highest score!",
    format="VALUE",
    start=
        g_game_mode != GAME_MODE_MULTI &&
        prev(g_game_state_sub) != GAME_STATE_SUB_INSERT_NAME &&
        g_game_state_sub == GAME_STATE_SUB_INSERT_NAME &&
        g_score > 0,
    cancel=always_false(),
    submit=always_true(),
    value=g_score
)

LB_START_ID = 171580
for route_id in range(ROUTE_EARLYBIRD_1, ROUTE_DUSKANDWIRED)
{
    leaderboard(
        id=LB_START_ID + route_id - ROUTE_EARLYBIRD_1,
        title=format("{0} - Fastest Time", ROUTE_NAMES[route_id]["leg"]),
        description=format("Drive the fastest lap in {0} - {1}!", ROUTE_NAMES[route_id]["route"], ROUTE_NAMES[route_id]["leg"]),
        format="FRAMES",
        lower_is_better=true,
        start=RouteFinished(route_id),
        cancel=always_false(),
        submit=always_true(),
        value=g_route_time
    )
}

ROUTE_PARAMS = {
    ROUTE_EARLYBIRD_1: {
        "ach_booster_id": 0,
        "ach_shortcut_id": 0,
        "ach_booster_amount": 11,
        "ach_shortcut_amount": 3,
        "ach_booster_points": 2, // easy enough
        "ach_shortcut_points": 2, // easy enough
    },
    ROUTE_EARLYBIRD_2: {
        "ach_booster_id": 0,
        "ach_shortcut_id": 0,
        "ach_booster_amount": 9,
        "ach_shortcut_amount": 5,
        "ach_booster_points": 3, // bit trickier
        "ach_shortcut_points": 3, // easy enough
    },
    ROUTE_EARLYBIRD_3: {
        "ach_booster_id": 0,
        "ach_shortcut_id": 0,
        "ach_progression_id": 0,
        "ach_survival_id": 0,
        "ach_booster_amount": 19,
        "ach_shortcut_amount": 5,
        "ach_booster_points": 3, // is this possible??
        "ach_shortcut_points": 3, // Easy enough
        "ach_progression_points": 4,
        "ach_survival_points": 3,
    },
    ROUTE_EARLYBIRD_BONUS: {
        "ach_bonus_id": 0,
        "ach_bonus_points": 5,
    },
    ROUTE_RUSHHOUR_1: {
        "ach_booster_id": 0,
        "ach_shortcut_id": 0,
        "ach_booster_amount": 12,
        "ach_shortcut_amount": 5,
        "ach_booster_points": 4, // Bit trickier
        "ach_shortcut_points": 3, // Easy enough, game also doublecounts some for some reason
    },
    ROUTE_RUSHHOUR_2: {
        "ach_booster_id": 0,
        "ach_shortcut_id": 0,
        "ach_booster_amount": 11, // Nerfed from 12 for anti-frustration
        // Maybe there's 5 in total? Though there only seem to be 4,
        // and 3 seems to be the practical max to get in one run.
        "ach_shortcut_amount": 3,
        "ach_booster_points": 5, // Tricky
        "ach_shortcut_points": 4,
    },
    ROUTE_RUSHHOUR_3: {
        "ach_booster_id": 0,
        "ach_shortcut_id": 0,
        "ach_progression_id": 0,
        "ach_survival_id": 0,
        "ach_booster_amount": 11, // Nerfed from 12 for anti-frustration
        "ach_shortcut_amount": 5,
        "ach_booster_points": 5, 
        "ach_shortcut_points": 3,
        "ach_progression_points": 4,
        "ach_survival_points": 3,
    },
    ROUTE_RUSHHOUR_BONUS: {
        "ach_bonus_id": 0,
        "ach_bonus_points": 5,
    },
    ROUTE_NIGHTOWL_1: {
        "ach_booster_id": 0,
        "ach_shortcut_id": 0,
        "ach_booster_amount": 15,
        "ach_shortcut_amount": 3, // dunno where this 4th shortcut is...
        "ach_booster_points": 3, // should be easy enough
        "ach_shortcut_points": 3,
    },
    ROUTE_NIGHTOWL_2: {
        "ach_booster_id": 0,
        "ach_shortcut_id": 0,
        "ach_booster_amount": 14,
        "ach_shortcut_amount": 3,
        "ach_booster_points": 3, // doable
        "ach_shortcut_points": 3, // easy enough
    },
    ROUTE_NIGHTOWL_3: {
        "ach_booster_id": 0,
        "ach_shortcut_id": 0,
        "ach_progression_id": 0,
        "ach_survival_id": 0,
        "ach_booster_amount": 17,
        "ach_shortcut_amount": 4,
        "ach_booster_points": 5, // doable if you avoid shortcuts
        "ach_shortcut_points": 3, // take every shortcut on way, easy enough
        "ach_progression_points": 4,
        "ach_survival_points": 3,
    },
    ROUTE_NIGHTOWL_BONUS: {
        "ach_bonus_id": 0,
        "ach_bonus_points": 5,
    },
    ROUTE_DUSKANDWIRED: {
        "ach_booster_id": 0,
        "ach_shortcut_id": 0,
        "ach_progression_id": 0,
        "ach_survival_id": 0,
        "ach_booster_amount": 28, // Nerfed from 35
        // Nerfed from 9 -- I think 9 is possible, though the 9th is probably
        // the fountain near the end, which seems to not work or be unreliable?
        // and then we'll also give a cushion shortcut
        "ach_shortcut_amount": 7,
        "ach_booster_points": 5,
        "ach_shortcut_points": 5,
        "ach_progression_points": 5,
        "ach_survival_points": 2,
    },
}

for route_id in [ROUTE_EARLYBIRD_3, ROUTE_RUSHHOUR_3, ROUTE_NIGHTOWL_3, ROUTE_DUSKANDWIRED]
{
    achievement(
        id=ROUTE_PARAMS[route_id]["ach_progression_id"],
        title=format("{0} - Progression", ROUTE_NAMES[route_id]["route"]),
        description=format("Complete {0}", ROUTE_NAMES[route_id]["route"]),
        type=if_else(route_id == ROUTE_DUSKANDWIRED, "win_condition", "progression"),
        points=ROUTE_PARAMS[route_id]["ach_progression_points"],
        trigger=RouteFinished(route_id)
    )
}

for route_id in [ROUTE_EARLYBIRD_BONUS, ROUTE_RUSHHOUR_BONUS, ROUTE_NIGHTOWL_BONUS]
{
    achievement(
        id=ROUTE_PARAMS[route_id]["ach_bonus_id"],
        title=format("{0} - Bonus", ROUTE_NAMES[route_id]["route"]),
        description=format("Earn a high enough score to access and then complete the Bonus Route for {0}", ROUTE_NAMES[route_id]["route"]),
        points=ROUTE_PARAMS[route_id]["ach_bonus_points"],
        trigger=RouteFinished(route_id)
    )
}

for route_id in [ROUTE_EARLYBIRD_3, ROUTE_RUSHHOUR_3, ROUTE_NIGHTOWL_3, ROUTE_DUSKANDWIRED]
{
    achievement(
        id=ROUTE_PARAMS[route_id]["ach_survival_id"],
        title=format("{0} - Survival", ROUTE_NAMES[route_id]["route"]),
        description=format("Complete {0} in the Survival Mode", ROUTE_NAMES[route_id]["route"]),
        points=ROUTE_PARAMS[route_id]["ach_survival_points"],
        trigger=RouteFinished(route_id) && g_game_mode == GAME_MODE_SURVIVAL
    )
}

for route_id in range(ROUTE_EARLYBIRD_1, ROUTE_DUSKANDWIRED)
{
    achievement(
        id=ROUTE_PARAMS[route_id]["ach_booster_id"],
        title=format("{0} - Boosters Obtained", ROUTE_NAMES[route_id]["leg"]),
        description=format(
            "Obtain {0} Boosters and complete {1} - {2}", 
            ROUTE_PARAMS[route_id]["ach_shortcut_amount"],
            ROUTE_NAMES[route_id]["route"],
            ROUTE_NAMES[route_id]["leg"]
       ),
        points=ROUTE_PARAMS[route_id]["ach_booster_points"],
        trigger=
            RouteFinished(route_id) &&
            g_boosters_obtained >= ROUTE_PARAMS[route_id]["ach_booster_amount"]
            //measured(
            //    g_boosters_obtained >= ROUTE_PARAMS[route_id]["ach_booster_amount"],
            //    when=g_route_id == route_id && prev(g_game_state) == GAME_STATE_DRIVING
            //)
    )
    
    // Hidden leaderboards to work around measured spam
    leaderboard(
        id=0,
        title="Booster Counter!",
        description=format("Aim for {0}", ROUTE_PARAMS[route_id]["ach_booster_amount"]),
        format="VALUE",
        start=
            !InDemo() &&
            g_game_mode != GAME_MODE_MULTI &&
            prev(g_game_state) == GAME_STATE_DRIVING_START &&
            g_game_state == GAME_STATE_DRIVING &&
            g_route_id == route_id,
        cancel=
            g_game_state == GAME_STATE_MENU,
        submit=
            RouteFinished(route_id),
        value=
            g_boosters_obtained
    )
    
    achievement(
        id=ROUTE_PARAMS[route_id]["ach_shortcut_id"],
        title=format("{0} - Risky Routes", ROUTE_NAMES[route_id]["leg"]),
        description=format(
            "Take {0} Risky Routes and complete {1} - {2}", 
            ROUTE_PARAMS[route_id]["ach_shortcut_amount"],
            ROUTE_NAMES[route_id]["route"],
            ROUTE_NAMES[route_id]["leg"]
       ),
        points=ROUTE_PARAMS[route_id]["ach_shortcut_points"],
        trigger=
            RouteFinished(route_id) &&
            measured(
                g_risky_routes >= ROUTE_PARAMS[route_id]["ach_shortcut_amount"],
                when=
                    g_route_id == route_id && 
                    prev(g_game_state) == GAME_STATE_DRIVING &&
                    !InDemo()
            )
    )
}

