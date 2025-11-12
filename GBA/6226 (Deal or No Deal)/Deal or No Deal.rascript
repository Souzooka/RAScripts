// Deal or No Deal
// #ID = 6226

function if_else(cond, a, b)
{
    if cond
        return a
    return b
}

function FinishedTVGame()
{
    return
        // 0x1C= kept case, 0x1B= switched case
        g_last_menu == 0x1C &&//|| g_last_menu == 0x1B &&
        prev(g_case_timer) == 0xBF &&
        g_case_timer == 0xFFFFFFFF
}

function IsSinglePlayer()
{
    return word(0x1770) == 0
}

function IsTVGame()
{
    return word(0x1772) == 0
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

g_player_case = word(0x1714)
// Value index of the player's case
g_player_case_value = word(0x4450 + g_player_case * 2)
g_last_menu = word(0x1750)
g_case_timer = dword(0x1734)

CASE_PARAMS = [
    {
        "id": 162690,
        "title": "Never Lucky, Rubber Ducky",
        "description": "Win $0.01 or $1 dollar by keeping your own case",
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
            FinishedTVGame() &&
            //!TookDeal() &&
            params["rule"]
    )
}

achievement(
    title = "Stray Off The Path", points = 5,
    description = "Have the dealer offer you a deal worth at least $100.000",
    id = 162691, badge = "183006", published = "7/20/2021 10:38:40 AM", modified = "7/20/2021 10:39:23 AM",
    trigger = byte(0x001740) == 10 && byte(0x001741) >= 1 && byte(0x001770) == 0 && byte(0x001772) == 0 &&
              byte(0x001744) == 12
)

achievement(
    title = "Deal Or No Deal?", points = 10,
    description = "Have the dealer offer you a deal worth at least $400.000",
    id = 162692, badge = "183007", published = "7/20/2021 10:38:40 AM", modified = "7/20/2021 10:39:23 AM",
    trigger = byte(0x001740) == 10 && byte(0x001741) >= 4 && byte(0x001770) == 0 && byte(0x001772) == 0 &&
              byte(0x001744) == 12
)

achievement(
    title = "I'll Make You An Offer You Can't Refuse", points = 25,
    description = "Have the dealer offer you a deal worth at least $600.000",
    id = 162693, badge = "183008", published = "7/20/2021 10:38:40 AM", modified = "7/20/2021 10:39:24 AM",
    trigger = byte(0x001740) == 10 && byte(0x001741) >= 6 && byte(0x001770) == 0 && byte(0x001772) == 0 &&
              byte(0x001744) == 12
)

achievement(
    title = "Entry Level ESP Classes", points = 5,
    description = "Guess 8 cases correctly in High Low",
    id = 162547, badge = "183010", published = "7/18/2021 9:38:08 AM", modified = "7/20/2021 10:39:20 AM",
    trigger = prev(byte(0x004484)) == 7 && byte(0x004484) == 8 && byte(0x001772) == 2 && byte(0x001770) == 0
)

achievement(
    title = "Sixth Sense", points = 10,
    description = "Guess 15 cases correctly in High Low",
    id = 162548, badge = "183011", published = "7/18/2021 9:38:08 AM", modified = "7/20/2021 10:39:20 AM",
    trigger = prev(byte(0x004484)) == 14 && byte(0x004484) == 15 && byte(0x001772) == 2 && byte(0x001770) == 0
)

achievement(
    title = "Lockpicking", points = 5,
    description = "Win at least $100.000 in The Vault",
    id = 162550, badge = "183013", published = "7/18/2021 9:38:09 AM", modified = "7/20/2021 10:39:21 AM",
    trigger = byte(0x001744) == 12 && byte(0x001741) >= 1 && byte(0x001772) == 1 && byte(0x001770) == 0 &&
              prev(byte(0x001758)) == 28 && byte(0x001758) == 61
)

achievement(
    title = "Code Breaker", points = 10,
    description = "Win at least $250.000 in The Vault",
    id = 162551, badge = "183014", published = "7/18/2021 9:38:09 AM", modified = "7/20/2021 10:39:21 AM",
    trigger = byte(0x001744) == 12 && byte(0x001772) == 1 && byte(0x001770) == 0 && prev(byte(0x001758)) == 28 &&
              byte(0x001758) == 61 &&
              ((byte(0x001741) >= 3) ||
               (byte(0x001741) == 2 && byte(0x001742) == 5))
)

achievement(
    title = "Cracked The Vault", points = 25,
    description = "Win at least $400.000 in The Vault",
    id = 162552, badge = "183015", published = "7/18/2021 9:38:10 AM", modified = "7/20/2021 10:39:21 AM",
    trigger = byte(0x001744) == 12 && byte(0x001741) >= 4 && byte(0x001772) == 1 && byte(0x001770) == 0 &&
              prev(byte(0x001758)) == 28 && byte(0x001758) == 61
)

leaderboard(
    id = 122535, title = "High Low Correct Guesses",
    description = "Most correct guesses in a row in High Low",
    start  = byte(0x001770) == 0 && byte(0x001772) == 2 && prev(byte(0x007B68)) == 33 &&
             (byte(0x007B68) == 11 || byte(0x007B68) == 60),
    cancel = always_false(),
    submit = always_true(),
    value  = measured(byte(0x004484)),
    format = "VALUE"
)

leaderboard(
    id = 122536, title = "Vault Winnings",
    description = "Win the most money in Vault Game",
    start  = byte(0x001770) == 0 && byte(0x001772) == 1 && prev(byte(0x001758)) == 28 &&
             (byte(0x001758) == 55 || byte(0x001758) == 59 || byte(0x001758) == 60 || byte(0x001758) == 61),
    cancel = always_false(),
    submit = always_true(),
    value  = max_of(
                 measured(byte(0x001741) * 100000 + byte(0x001742) * 10000, when=byte(0x001744) == 12),
                 measured(byte(0x001741) * 10000 + byte(0x001742) * 1000, when=byte(0x001743) == 12),
                 measured(byte(0x001741) * 1000, when=byte(0x001742) == 12)
             ),
    format = "VALUE"
)

leaderboard(
    id = 122537, title = "TV Game Winnings",
    description = "Win the most money in TV Game",
    start  = always_true() &&
             ((byte(0x001770) == 0 && byte(0x001772) == 0 && prev(byte(0x004438)) == 0 && byte(0x004438) == 1) ||
              (byte(0x004438) == 4 && byte(0x001740) == 36 && prev(byte(0x001740)) != 36) ||
              (byte(0x004438) == 5 && dword(0x001734) == 191 && prev(dword(0x001734)) == 0)),
    cancel = always_false(),
    submit = always_true(),
    value  = measured(tbyte(0x001694)),
    format = "VALUE"
)
