// Deal or No Deal
// #ID = 6226

function if_else(cond, a, b)
{
    if cond
        return a
    return b
}

function FinishedTVGameWithCase(allow_swap=false)
{
    // 0x1C= kept case, 0x1B= switched case
    menu_cond = g_last_menu == 0x1C || g_last_menu == 0x1B
    if !allow_swap
        menu_cond = g_last_menu == 0x1C

    return
        menu_cond &&
        prev(g_timer) == 0 &&
        g_timer == 0xBF
}

function FinishedTVGameWithDeal()
{
    return dword(0x4438) == 1 && prev(dword(0x4438)) == 0
}

function FinishedHighLow()
{
    // The state in which the game in when this game mode is finished
    // seems to be opaque, so we'll emulate the game conditions
    // which lead to the completion state
    picked_case_value = word(0x4450 + g_picked_case * 2)
    last_case_value = dword(0x25B0)
    
    got_any = dword(0x25C4) != 0
    got_all = dword(0x25C4) == 26 && prev(dword(0x25C4)) == 25
    
    chose_lower = word(0x1750) == 0x21
    chose_higher = word(0x1750) == 0x22
    was_lower = picked_case_value < last_case_value
    was_higher = picked_case_value > last_case_value
    
    timer_check = g_timer == 0 && prev(g_timer) > 0
    low_check = got_any && chose_lower && was_higher && timer_check
    high_check = got_any && chose_higher && was_lower && timer_check
    
    return (low_check || high_check || got_all)
}

function FinishedVaultGame()
{
    // Bit funky but seems to work
    return
        g_secret_sauce > prev(g_secret_sauce) &&
        g_game_music == 0x0800CBB8 &&
        // prevents achievement from activating the first frame we switch scenes
        g_game_music == prev(g_game_music)
}

function IsSinglePlayer()
{
    return word(0x1770) == 0
}

function IsTVGame()
{
    return word(0x1772) == 0
}

function IsVaultGame()
{
    return word(0x1772) == 1 && word(0x1750) == 0x13
}

function IsHighLow()
{
    return word(0x1772) == 2
}

function TookDeal()
{
    n_offers = dword(0x25C4)
    current_offer = dword(0x25B0)
    last_offer = dword(0x25D0 + (n_offers - 1) * 4)
    
    return
        n_offers == 0 ||
        last_offer != current_offer
}

function ReceivedOffer(rule)
{
    offer = dword(0x25B0)

    return
        // Correct timer type (i.e. waiting for banker offer)
        g_timer_type == 1 &&
        // Timer became appropriate value
        prev(g_timer) > 0x9D &&
        g_timer <= 0x9D &&
        // Offer satisfies the provided rule
        rule(offer)
}

VALUE_TO_CASE = {
    0.01: 0,
    1: 1,
    5: 2,
    10: 3,
    25: 4,
    50: 5,
    75: 6,
    100: 7,
    200: 8,
    300: 9,
    400: 10,
    500: 11,
    750: 12,
    1000: 13,
    5000: 14,
    10000: 15,
    25000: 16,
    50000: 17,
    75000: 18,
    100000: 19,
    200000: 20,
    300000: 21,
    400000: 22,
    500000: 23,
    750000: 24,
    1000000: 25,
}

g_game_winnings = dword(0x1694)
g_player_case = word(0x1714)
// Value index of the player's case
g_player_case_value = word(0x4450 + g_player_case * 2)
g_last_menu = word(0x1750)
g_timer = dword(0x1734)
g_timer_type = word(0x1738)
g_high_low_guesses = dword(0x4484)
// Maybe this is the amount of sprites on screen or something? Goes from 0x1C to 0x3D
// when winning amount is shown in Vault Game
g_secret_sauce = dword(0x1758)
g_vault_game_winnings = dword(0x25B0)
g_game_music = dword(0x44B0)
g_picked_case = word(0x4390)

CASE_PARAMS = [
    {
        "id": 162690,
        "title": "Never Lucky, Rubber Ducky",
        "description": "Win $0.01 or $1 by keeping your own case",
        "type": "",
        "points": 5,
        "rule": g_player_case_value <= VALUE_TO_CASE[1],
    },
    {
        "id": 162687,
        "title": "Contestant Number X",
        "description": "Win $100,000 or more by keeping your own case",
        "type": "",
        "points": 5,
        "rule": g_player_case_value >= VALUE_TO_CASE[100000],
    },
    {
        "id": 162688,
        "title": "Slumdog Millionaire",
        "description": "Win $400,000 or more by keeping your own case",
        "type": "",
        "points": 10,
        "rule": g_player_case_value >= VALUE_TO_CASE[400000],
    },
    {
        "id": 162689,
        "title": "Who Wants to Be a Millionaire?",
        "description": "Win $1,000,000 by keeping your own case",
        "type": "win_condition",
        "points": 25,
        "rule": g_player_case_value == VALUE_TO_CASE[1000000],
    },
]

for params in CASE_PARAMS
{
    achievement(
        id=params["id"],
        title=params["title"],
        description=params["description"],
        type=params["type"],
        points=params["points"],
        trigger=
            IsSinglePlayer() &&
            IsTVGame() &&
            FinishedTVGameWithCase() &&
            //!TookDeal() &&
            params["rule"]
    )
}

OFFER_PARAMS = [
    {
        "id": 162691,
        "title": "Stray Off the Path",
        "description": "Have the dealer offer you a deal worth at least $100,000",
        "points": 5,
        "rule": (offer) => offer >= 100000,
    },
    {
        "id": 162692,
        "title": "Deal or No Deal?",
        "description": "Have the dealer offer you a deal worth at least $400,000",
        "points": 10,
        "rule": (offer) => offer >= 400000,
    },
    {
        "id": 162693,
        "title": "I'll Make You an Offer You Can't Refuse",
        "description": "Have the dealer offer you a deal worth at least $600,000",
        "points": 25,
        "rule": (offer) => offer >= 600000,
    },
]

for params in OFFER_PARAMS
{
    achievement(
        id=params["id"],
        title=params["title"],
        description=params["description"],
        points=params["points"],
        trigger=
            IsSinglePlayer() &&
            IsTVGame() &&
            ReceivedOffer(params["rule"])
    )
}

HIGH_LOW_PARAMS = [
    {
        "id": 162547,
        "title": "Entry Level ESP Classes",
        "points": 5,
        "amount": 8,
    },
    {
        "id": 162548,
        "title": "Sixth Sense",
        "points": 10,
        "amount": 15,
    },
]

for params in HIGH_LOW_PARAMS
{
    achievement(
        id=params["id"],
        title=params["title"],
        description=format("Guess {0} cases correctly in High Low", params["amount"]),
        points=params["points"],
        trigger=
            IsSinglePlayer() &&
            IsHighLow() &&
            prev(g_high_low_guesses) == params["amount"] - 1 &&
            g_high_low_guesses == params["amount"]
    )
}

VAULT_PARAMS = [
    {
        "id": 162550,
        "title": "Lockpicking",
        "description": "Win at least $100,000 in The Vault",
        "points": 5,
        "amount": 100000,
    },
    {
        "id": 162551,
        "title": "Code Breaker",
        "description": "Win at least $250,000 in The Vault",
        "points": 10,
        "amount": 250000,
    },
    {
        "id": 162552,
        "title": "Cracked the Vault",
        "description": "Win at least $400,000 in The Vault",
        "points": 25,
        "amount": 400000,
    },
]

for params in VAULT_PARAMS
{
    achievement(
        id=params["id"],
        title=params["title"],
        description=params["description"],
        points=params["points"],
        trigger=
            IsSinglePlayer() &&
            IsVaultGame() &&
            // End of the game
            FinishedVaultGame() &&
            // Amount
            g_vault_game_winnings >= params["amount"]
    )
}

leaderboard(
    id = 122535, title = "High Low Correct Guesses",
    description = "Most correct guesses in a row in High Low",
    start  = IsSinglePlayer() && IsHighLow() && FinishedHighLow(),
    cancel = always_false(),
    submit = always_true(),
    value  = g_high_low_guesses,
    format = "VALUE"
)

leaderboard(
    id = 122536, title = "Vault Winnings",
    description = "Win the most money in Vault Game",
    start  = IsSinglePlayer() && IsVaultGame() && FinishedVaultGame(),
    cancel = always_false(),
    submit = always_true(),
    value  = g_vault_game_winnings,
    format = "VALUE"
)

leaderboard(
    id = 122537, title = "TV Game Winnings",
    description = "Win the most money in TV Game",
    start=
        IsSinglePlayer() &&
        IsTVGame() &&
        (FinishedTVGameWithCase(allow_swap=true) || FinishedTVGameWithDeal()),
    cancel = always_false(),
    submit = always_true(),
    value  = max_of(
        // Took the banker's deal
        measured(g_game_winnings, when=FinishedTVGameWithDeal()),
        // Kept/swapped to case with at least $1 value
        measured(g_game_winnings, when=FinishedTVGameWithCase(allow_swap=true) && g_player_case_value != 0),
        // Won $.01 :(
        measured(0, when=always_true())
    ),
    format = "VALUE"
)
