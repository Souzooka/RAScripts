// Smashing Drive
// #ID = 30565

u8 = byte
u16 = word_be
u32 = dword_be
f32 = float_be

g_game_state = u32(0x1ee660)
g_game_state_sub = u32(0x1ee664)

GAME_STATE_DRIVING = 0x4
GAME_STATE_HIT_GOAL = 0x5

GAME_STATE_SUB_DEMO = 0x4
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

g_score = f32(0x1ee904)

function InDemo()
{
    return g_game_state_sub == GAME_STATE_SUB_DEMO
}

function RouteFinished(route_id)
{
    return
        !InDemo() &&
        g_route_id == route_id &&
        prev(g_game_state) == GAME_STATE_DRIVING &&
        g_game_state == GAME_STATE_HIT_GOAL
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
