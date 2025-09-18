// Harry Potter and the Sorcerer's Stone
// #ID = 21736

conds = []
prev_conds = []

function InGame()
{
    return dword(0x326110) == 9
}

STORY_DIAGON_DONE = 0

function watch_story_flag(flag)
{
    return
        dword(0x395740) == flag + 6 &&
        dword(0x395740) != dword(0x39573C) &&
        dword(0x39573C) >= 6 &&
        dword(0x39573C) != prev(dword(0x39573C))
}

get_story_flag = flag => dword(0x390210 + 0x2A4 * flag)

g_challenge_shields = [
    word(0x394c32),
    word(0x394c36),
    word(0x394c38),
    word(0x394c3a),
]

g_percentage = float(0x394d14) * 10000.0
TARGET_PERCENTAGE = 0.8879 * 10000.0 // 10000 instead of 100 to offer more granularity to measured%
PER_SHIELD = 0.0025 * 10000.0

shield_total = sum_of(g_challenge_shields, v => v)
MAX_SHIELDS = 40

all_spells = all_of(g_challenge_shields, v => v != 0xFFFF)
no_new_glitched_shields = all_of(g_challenge_shields, v => v == 0xA || prev(v) == v) // :(
achievement(
    id=355382,
    title="Gryffindor's Bravest",
    description="Achieve full completion by witnessing all story events, returning all lost items, collecting all Wizard Cards, and collecting all Challenge Shields",
    points=50,
    trigger=
        InGame() &&
        g_percentage > prev(g_percentage) &&
        all_of(g_challenge_shields, v => v >= 10) &&
        (
            measured(
                g_percentage - (PER_SHIELD * (shield_total - 40)) >= TARGET_PERCENTAGE, when=shield_total>=40, format="percent"
            ) ||
            measured(
                g_percentage >= TARGET_PERCENTAGE, when=shield_total<40 || !all_spells, format="percent"
            )
        )
)

achievement(
    id=356702,
    title="Diagon Alley Explorer",
    description="Complete the first day",
    type="progression",
    points=3,
    trigger=
        InGame() &&
        watch_story_flag(STORY_DIAGON_DONE)
)