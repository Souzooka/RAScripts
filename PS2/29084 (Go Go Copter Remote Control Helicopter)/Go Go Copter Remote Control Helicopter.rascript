// Go Go Copter: Remote Control Helicopter
// #ID = 29084

g_game_mode = dword(0xC70000)
GM_BOOT = 0x0
GM_IN_GAME = 0x1
GM_MENU = 0x2
GM_DEMO = 0x3 // Intro FMV
GM_SPLASH = 0x4 // Splash screen at boot
GM_VS_GAME = 0x8 // V.S. Game
GM_START_CHECK = 0x9 // Basic Now Loading screen at boot
GM_ENDING = 0xA // Ending FMV (?)

g_game_type = dword(0xC86A08)
GAME_CHALLENGE = 0
GAME_ADVENTURE = 1

g_level = dword(0xC86A0C)
g_adventure_stage = g_level
g_challenge_stage = g_level
g_challenge_heli = g_level

g_adventure_heli = dword(0xC86A10)

rp_challenge_stage = rich_presence_value("CHA_STAGE", (g_challenge_stage / 4) + 1)
rp_challenge_stage_sub = rich_presence_value("CHA_STAGE_SUB", (g_challenge_stage & 0x3) + 1)

ChallengeHeliLookup = {
    0x0: "MD520N",
    0x1: "KV_107",
    0x2: "OH_1",
    0x3: "A_109",
    0x4: "A_109",
    0x5: "MD520N",
    0x6: "BK117",
    0x7: "OH_1",
    0x8: "MD520N",
    0x9: "A_109",
    0xA: "BK117",
    0xB: "MD520N",
    0xC: "BK117",
    0xD: "AH_64",
    0xE: "MD520N",
    0xF: "A_109",
    0x10: "A_109",
    0x11: "R_44",
    0x12: "A_109",
    0x13: "OH_1T",
}

rp_challenge_heli = rich_presence_lookup("CHA_HELI", g_challenge_heli, ChallengeHeliLookup)

AdventureStageLookup = {
    0x0: "Child's Room A",
    0x1: "Child's Room B",
    0x2: "Library",
    0x3: "Kitchen",
    0x4: "UNDER_G",
    0x5: "Living Room",
    0x6: "Bedroom",
    0x7: "Entrance",
    0x8: "Bathroom",
    0x9: "TOILET",
    0xA: "UTILITY",
    0xB: "Hobby Room",
    0xC: "Gym",
    0xD: "Washitsu",
    0xE: "Garden",
}

AdventureHeliLookup = {
    0x0: "MD520N",
    0x1: "A_109",
    0x2: "KV_107",
    0x3: "CH_46",
    0x4: "BK117",
    0x5: "OH_1",
    0x6: "OH_1T",
    0x7: "OH_1T2",
    0x8: "AH_64",
    0x9: "R_44",
    0xA: "MH_53E",
    0xB: "V_22",
}

rp_adventure_stage = rich_presence_lookup("ADV_STAGE", g_adventure_stage, AdventureStageLookup)
rp_adventure_heli = rich_presence_lookup("ADV_HELI", g_adventure_heli, AdventureHeliLookup)

rich_presence_conditional_display(
    any_of([GM_BOOT, GM_SPLASH, GM_START_CHECK], v => v == g_game_mode),
    "Booting Go Go Copter: Remote Control Helicopter!"
)
rich_presence_conditional_display(
    g_game_mode == GM_DEMO,
    "Viewing the intro FMV"
)
rich_presence_conditional_display(
    g_game_mode == GM_ENDING,
    "Viewing the ending FMV"
)
rich_presence_conditional_display(
    g_game_mode == GM_MENU,
    "In a menu"
)
rich_presence_conditional_display(
    g_game_mode == GM_VS_GAME,
    "In a V.S. Game!"
)
rich_presence_conditional_display(
    g_game_mode == GM_IN_GAME && g_game_type == GAME_CHALLENGE,
    "Tackling Challenge Mode | Stage {0}-{1} | 🚁 {2}",
    rp_challenge_stage,
    rp_challenge_stage_sub,
    rp_challenge_heli
)
rich_presence_conditional_display(
    g_game_mode == GM_IN_GAME && g_game_type == GAME_ADVENTURE,
    "Tackling Adventure Mode | Location: {0} | 🚁 {1}",
    rp_adventure_stage,
    rp_adventure_heli
)
rich_presence_display(
    "Playing Go Go Copter: Remote Control Helicopter"
)