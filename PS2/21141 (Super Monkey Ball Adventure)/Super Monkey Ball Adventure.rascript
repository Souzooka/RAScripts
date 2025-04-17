// Super Monkey Ball Adventure
// #ID = 21141

NULL = 0

mirror = (v) => v // Dummy accessor for ptr for if the pointed-to address is desired
function ptr(base, offsets, accessor=dword)
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

function in_game()
{
    // Tentative
    return dword(0x473224) != NULL &&
        ptr(dword(0x473224), [0xC0], dword) != NULL &&
        ptr(dword(0x473224), [0xC0, 0x4AC], dword) != NULL
}

function in_puzzle()
{
    // "puzzle"
    return ascii_string_equals(g_level_name3, "uzzl")
}

function in_party_game()
{
    // "partygames"
    return ascii_string_equals(g_level_name3, "arty")
}

function in_race()
{
    // "partygames\\race"
    return ascii_string_equals(g_level_name5, "s\\ra")
}

function in_target()
{
    // "partygames\\glide"
    return ascii_string_equals(g_level_name5, "s\\gl")
}

function in_bounce()
{
    // "partygames\\bounce"
    return ascii_string_equals(g_level_name6, "unce")
}

function in_boxing()
{
    // "partygames\\boxing"
    return ascii_string_equals(g_level_name6, "xing")
}

function in_cannon()
{
    // "partygames\\castle"
    return ascii_string_equals(g_level_name5, "s\\ca")
}

function in_tag()
{
    // "partygames\\monkytag"
    return ascii_string_equals(g_level_name5, "s\\mo")
}


g_level_name = ptr(dword(0x473224), [0xC0, 0x4AC, 0x0, 0xA0, 0x138, 0x4], mirror) // RATools doesn't generate the last offset if it's 0, for whatever reason
g_level_name3 = ptr(dword(0x473224), [0xC0, 0x4AC, 0x0, 0xA0, 0x138, 0x8], mirror)
g_level_name5 = ptr(dword(0x473224), [0xC0, 0x4AC, 0x0, 0xA0, 0x138, 0x10], mirror)
g_level_name6 = ptr(dword(0x473224), [0xC0, 0x4AC, 0x0, 0xA0, 0x138, 0x14], mirror)

adventure_level_name_lookup = {
    "ls\\jungisle\\village": "jungisle - village",
    "ls\\newhave\\arvlpark": "newhave - arvlpark",
    "ls\\zootopib\\mainst": "zootopib - mainst",
    "ls\\montrop\\mk_pol": "montrop - mk_pol",
}

puzzle_level_name_lookup = {
    "ls\\puzzles\\p02_everdecreasing\\edc01": "p02_everdecreasing - edc01",
    "ls\\puzzles\\p08_ripple\\rb01": "p08_ripple - rb01",
    "ls\\puzzles\\p09_plughole\\dtp01": "p09_plughole - dtp01",
    "ls\\puzzles\\p12_wells\\gw01": "p12_wells - gw01",
    "ls\\puzzles\\p13_cog\\cog01": "p13_cog - cog01",
    "ls\\puzzles\\p23_cascade\\casc01": "p23_cascade - casc01",
    "ls\\puzzles\\p24_zzstop\\zzs01": "p24_zzstop - zzs01",
    "ls\\puzzles\\p25_jump\\jump01": "p25_jump - jump01",
    "ls\\puzzles\\p29_tiptoe\\tt01": "p29_tiptoe - tt01",
    "ls\\puzzles\\p31_squeegee\\sq02": "p31_squeegee - sq02",
    "ls\\puzzles\\p33_checkmate\\chk01": "p33_checkmate - chk01",
    "ls\\puzzles\\p35_breadbasket\\bb01": "p35_breadbasket - bb01",
    "ls\\puzzles\\p37_dimple\\dim01": "p37_dimple - dim01",
    "ls\\puzzles\\p39_overun\\vr01": "p39_overun - vr01",
    "ls\\puzzles\\p40_bumps\\bnb01": "p40_bumps - bnb01",
    "ls\\puzzles\\p41_simplesplit\\ss01": "p41_simplesplit - ss01",
    "ls\\puzzles\\p43_smile\\grin01": "p43_smile - grin01",
    "ls\\puzzles\\p44_roundabout\\rab01": "p44_roundabout - rab01",
    "ls\\puzzles\\p48_ridgewalker\\rw01": "p48_ridgewalker - rw01",
    "ls\\puzzles\\p49_hairpins\\hir01": "p49_hairpins - hir01",
    "ls\\puzzles\\p51_serpent\\asp01": "p51_serpent - asp01",
    "ls\\puzzles\\p52_skidbiffers\\skid01": "p52_skidbiffers - skid01",
    "ls\\puzzles\\p53_electricbiffersofdoom\\ebd01": "p53_electricbiffersofdoom - ebd01",
    "ls\\puzzles\\p57_spindle\\spin01": "p57_spindle - spin01",
    "ls\\puzzles\\p56_shuffle\\shfl01": "p56_shuffle - shfl01",
    "ls\\puzzles\\p59_holes\\hole01": "p59_holes - hole01",
    "ls\\puzzles\\p10_whirlpool\\wp01": "p10_whirlpool - wp01",
    "ls\\puzzles\\p32_funnelrun\\fun01": "p32_funnelrun - fun01",
    "ls\\puzzles\\p36_overthehills\\oth01": "p36_overthehills - oth01",
    "ls\\puzzles\\p55_spiralscratch\\sp01": "p55_spiralscratch - sp01",
    "ls\\puzzles\\p62_sequencer\\seq01": "p62_sequencer - seq01",
    "ls\\puzzles\\p85_tonguetwister\\tw01": "p85_tonguetwister - tw01",
    "ls\\puzzles\\p84_captureflag\\cf01": "p84_captureflag - cf01",
    "ls\\puzzles\\p67_eternal\\et01": "p67_eternal - et01",
    "ls\\puzzles\\p71_slalom\\sm01": "p71_slalom - sm01",
    "ls\\puzzles\\p14_elementary\\el01": "p14_elementary - el01",
    "ls\\puzzles\\p47_hoopsnake\\hs01": "p47_hoopsnake - hs01",
    "ls\\puzzles\\p03_slipknot\\sk01": "p03_slipknot - sk01",
    "ls\\puzzles\\p11_drag\\dd01": "p11_drag - dd01",
    "ls\\puzzles\\p16_sega\\s01": "p16_sega - s01",
    "ls\\puzzles\\p81_sissi\\sis01": "p81_sissi - sis01",
    "ls\\puzzles\\p42_celticknots\\ck02": "p42_celticknots - ck02",
    "ls\\puzzles\\p82_whirlingdervishes\\wd01": "p82_whirlingdervishes - wd01",
    "ls\\puzzles\\p26_spinnera\\sa01": "p26_spinnera - sa01",
    "ls\\puzzles\\p07_frightrings\\fr01": "p07_frightrings - fr01",
    "ls\\puzzles\\p01_ringgoal\\rg01": "p01_ringgoal - rg01",
    "ls\\puzzles\\p77_jawbridge\\jb01": "p77_jawbridge - jb01",
    "ls\\puzzles\\p65_mesmerise\\mes01": "p65_mesmerise - mes01",
    "ls\\puzzles\\p107_stinkysteps\\stst01": "p107_stinkysteps - stst01",
    "ls\\puzzles\\pp12_backslider\\bu01": "pp12_backslider - bu01",
    "ls\\puzzles\\p54_floorslider\\fs01": "p54_floorslider - fs01",
    "ls\\puzzles\\pp11_deadline\\uad01": "pp11_deadline - uad01",
    "ls\\puzzles\\p112_gankanny\\htl01": "p112_gankanny - htl01",
    "ls\\puzzles\\p104_threebie\\thr01": "p104_threebie - thr01",
    "ls\\puzzles\\pp14_backflip\\bf01": "pp14_backflip - bf01",
    "ls\\puzzles\\p58_crossroads\\cros01": "p58_crossroads - cros01",
    "ls\\puzzles\\p113_bowls\\b01": "p113_bowls - b01",
    "ls\\puzzles\\p108_threewheel\\twh01": "p108_threewheel - twh01",
    "ls\\puzzles\\p114_sidestep\\sst01": "p114_sidestep - sst01",
    "ls\\puzzles\\pp13_pitchnputt\\pnp01": "pp13_pitchnputt - pnp01",
    "ls\\puzzles\\p105_threedom\\td01": "p105_threedom - td01",
    "ls\\puzzles\\pp15_loopit\\lit01": "pp15_loopit - lit01",
}

bounce_game_name_lookup = {
    "ls\\partygames\\bounce\\bounce": "bounce - bounce",
}

boxing_game_name_lookup = {
    "ls\\partygames\\boxing\\zootopia\\boxarena": "boxing - zootopia - boxarena",
    "ls\\partygames\\boxing\\jungleisland\\boxarena": "boxing - jungleisland - boxarena",
}

target_game_name_lookup = {
    "ls\\partygames\\glide\\glide3": "glide - glide3",
    "ls\\partygames\\glide\\glide2": "glide - glide2",
    "ls\\partygames\\glide\\glide_a": "glide - glide_A",
    "ls\\partygames\\glide\\glide1": "glide - glide1",
}

race_game_name_lookup = {
    "ls\\partygames\\race\\track_a": "race - track_a",
    "ls\\partygames\\race\\track_am": "race - track_am",
    "ls\\partygames\\race\\track_b": "race - track_b",
    "ls\\partygames\\race\\track_bm": "race - track_bm",
    "ls\\partygames\\race\\track_c": "race - track_c",
    "ls\\partygames\\race\\track_cm": "race - track_cm",
    "ls\\partygames\\race\\track_d": "race - track_d",
    "ls\\partygames\\race\\track_dm": "race - track_dm",
}

cannon_game_name_lookup = {
    "ls\\partygames\\castles\\castle": "castles - castle",
}

tag_game_name_lookup = {
    "ls\\partygames\\monkytag\\monktaga": "monkytag - monktaga",
    "ls\\partygames\\monkytag\\monktagb": "monkytag - monktagb",
}


rp_adventure_level = rich_presence_ascii_string_lookup("ADVENTURE_LEVEL", g_level_name, adventure_level_name_lookup)
rp_puzzle_level = rich_presence_ascii_string_lookup("PUZZLE_LEVEL", g_level_name, puzzle_level_name_lookup)
rp_bounce_game_level = rich_presence_ascii_string_lookup("BOUNCE_LEVEL", g_level_name, bounce_game_name_lookup)
rp_boxing_game_level = rich_presence_ascii_string_lookup("BOXING_LEVEL", g_level_name, boxing_game_name_lookup)
rp_target_game_level = rich_presence_ascii_string_lookup("TARGET_LEVEL", g_level_name, target_game_name_lookup)
rp_race_game_level = rich_presence_ascii_string_lookup("RACE_LEVEL", g_level_name, race_game_name_lookup)
rp_cannon_game_level = rich_presence_ascii_string_lookup("CANNON_LEVEL", g_level_name, cannon_game_name_lookup)
rp_tag_game_level = rich_presence_ascii_string_lookup("TAG_LEVEL", g_level_name, tag_game_name_lookup)

rich_presence_conditional_display(
    in_game() && in_puzzle(),
    "In Puzzle Level: {0}",
    rp_puzzle_level
)
rich_presence_conditional_display(
    in_game() && in_bounce(),
    "In Bounce Level: {0}",
    rp_bounce_game_level
)
rich_presence_conditional_display(
    in_game() && in_boxing(),
    "In Boxing Level: {0}",
    rp_boxing_game_level
)
rich_presence_conditional_display(
    in_game() && in_target(),
    "In Target Level: {0}",
    rp_target_game_level
)
rich_presence_conditional_display(
    in_game() && in_race(),
    "In Race Level: {0}",
    rp_race_game_level
)
rich_presence_conditional_display(
    in_game() && in_cannon(),
    "In Cannon Level: {0}",
    rp_cannon_game_level
)
rich_presence_conditional_display(
    in_game() && in_tag(),
    "In Tag Level: {0}",
    rp_tag_game_level
)
rich_presence_conditional_display(
    in_game(),
    "In Adventure Level: {0}",
    rp_adventure_level
)
rich_presence_display("In title menu or a loading screen.")