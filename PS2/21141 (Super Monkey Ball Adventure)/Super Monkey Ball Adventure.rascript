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
    "ls\\jungisle\\village": "Jungle Island - Village",
    "ls\\jungisle\\jipath": "Jungle Island - Path to Palace",
    "ls\\jungisle\\palext": "Jungle Island - Palace Exterior",
    "ls\\jungisle\\pallock": "Jungle Island - Palace Lock",
    //"ls\\jungisle\\pallocka": "Jungle Island - Palace Lock A",
    //"ls\\jungisle\\pallockb": "Jungle Island - Palace Lock B",
    "ls\\jungisle\\palint": "Jungle Island - Palace Interior",
    "ls\\jungisle\\chamber": "Jungle Island - Chamber",
    "ls\\jungisle\\beach": "Jungle Island - Distant Islands",
    "ls\\jungisle\\gateway": "Jungle Island - Gateway",
    "ls\\newhave\\arvlpark": "Moonhaven - Arrival Park",
    "ls\\newhave\\coglock": "Moonhaven - Cog Lock",
    "ls\\newhave\\airauto": "Moonhaven - Air Automaton",
    "ls\\newhave\\tmbllock": "Moonhaven - Air Automaton",
    "ls\\newhave\\undrcity": "Moonhaven - Undercity",
    "ls\\newhave\\liftlock": "Moonhaven - Lift Lock",
    "ls\\newhave\\watrpark": "Moonhaven - Water Automaton",
    "ls\\newhave\\locklock": "Moonhaven - Lift Lock",
    "ls\\zootopib\\mainst": "Zootopia - Main Street",
    "ls\\zootopib\\zt_link": "Zootopia - Main Street <-> Hedge Maze",
    "ls\\zootopib\\zt_maze": "Zootopia - Hedge Maze",
    "ls\\zootopib\\z_al1": "Zootopia - Main Street <-> Roller Coaster",
    "ls\\zootopib\\z_al2": "Zootopia - Roller Coaster <-> Fat Cat",
    "ls\\zootopib\\z_al3": "Zootopia - Hedge Maze <-> Fat Cat",
    "ls\\zootopib\\rc01": "Zootopia - Roller Coaster",
    "ls\\zootopib\\fatcat": "Zootopia - Fat Cat",
    "ls\\monktrop\\mk_pol": "Monkitropolis - Police Station",
    "ls\\monktrop\\mk_race": "Monkitropolis - Raceway",
    "ls\\monktrop\\link": "Monkitropolis - Police Station <-> Raceway",
    // can't have nice things
    //"ls\\monktrop\\tlink1": "Monkitropolis - Throne <-> Kongri-la",
    //"ls\\monktrop\\tlink2": "Monkitropolis - Raceway <-> Throne",
    "ls\\monktrop\\tlink": "Monkitropolis - Palace Elevator",
    "ls\\monktrop\\throne": "Monkitropolis - Throne Room",
    "ls\\monktrop\\mk_kong": "Monkitropolis - Kongri-la",
    //"ls\\monktrop\\mk_kong1": "Monkitropolis - Kongri-la",
    //"ls\\monktrop\\mk_kong2": "Monkitropolis - Kongri-la",
    "ls\\monktrop\\mk_link": "Monkitropolis - Kongri-la",
    "ls\\monktrop\\mk_dlink": "Monkitropolis - Kongri-la",
    "ls\\monktrop\\d_link2": "Monkitropolis - Kongri-la",
}

puzzle_level_name_lookup = {
    "ls\\puzzles\\p02_everdecreasing\\edc01": "p02_everdecreasing - edc01",
    "ls\\puzzles\\p08_ripple\\rb01": "Ripple",
    "ls\\puzzles\\p09_plughole\\dtp01": "Plughole",
    "ls\\puzzles\\p12_wells\\gw01": "Gravity Wells",
    "ls\\puzzles\\p13_cog\\cog01": "Cog",
    "ls\\puzzles\\p23_cascade\\casc01": "Cascade",
    "ls\\puzzles\\p24_zzstop\\zzs01": "ZZ Stop",
    "ls\\puzzles\\p25_jump\\jump01": "Jump",
    "ls\\puzzles\\p29_tiptoe\\tt01": "Tiptoe",
    "ls\\puzzles\\p31_squeegee\\sq02": "Squeegee",
    "ls\\puzzles\\p33_checkmate\\chk01": "Checkmate",
    "ls\\puzzles\\p35_breadbasket\\bb01": "Bread Basket",
    "ls\\puzzles\\p37_dimple\\dim01": "Dimple",
    "ls\\puzzles\\p39_overun\\vr01": "Overrun",
    "ls\\puzzles\\p40_bumps\\bnb01": "Bumps",
    "ls\\puzzles\\p41_simplesplit\\ss01": "Simple Split",
    "ls\\puzzles\\p43_smile\\grin01": "Smile",
    "ls\\puzzles\\p44_roundabout\\rab01": "p44_roundabout - rab01",
    "ls\\puzzles\\p48_ridgewalker\\rw01": "Ridge Walker",
    "ls\\puzzles\\p49_hairpins\\hir01": "Hairpins",
    "ls\\puzzles\\p51_serpent\\asp01": "Serpent",
    "ls\\puzzles\\p52_skidbiffers\\skid01": "Skid Slalom",
    "ls\\puzzles\\p53_electricbiffersofdoom\\ebd01": "Slider",
    "ls\\puzzles\\p57_spindle\\spin01": "p57_spindle - spin01",
    "ls\\puzzles\\p56_shuffle\\shfl01": "Shuffle",
    "ls\\puzzles\\p59_holes\\hole01": "Holes",
    "ls\\puzzles\\p10_whirlpool\\wp01": "p10_whirlpool - wp01",
    "ls\\puzzles\\p32_funnelrun\\fun01": "Funrun",
    "ls\\puzzles\\p36_overthehills\\oth01": "Over The Hills",
    "ls\\puzzles\\p55_spiralscratch\\sp01": "Spiral Scratch",
    "ls\\puzzles\\p62_sequencer\\seq01": "Sequencer",
    "ls\\puzzles\\p85_tonguetwister\\tw01": "Tongue Twister",
    "ls\\puzzles\\p84_captureflag\\cf01": "p84_captureflag - cf01",
    "ls\\puzzles\\p67_eternal\\et01": "Eternal",
    "ls\\puzzles\\p71_slalom\\sm01": "Slalom",
    "ls\\puzzles\\p14_elementary\\el01": "Elementary",
    "ls\\puzzles\\p47_hoopsnake\\hs01": "Hoopsnake",
    "ls\\puzzles\\p03_slipknot\\sk01": "Slipknot",
    "ls\\puzzles\\p11_drag\\dd01": "p11_drag - dd01",
    "ls\\puzzles\\p16_sega\\s01": "p16_sega - s01",
    "ls\\puzzles\\p81_sissi\\sis01": "p81_sissi - sis01",
    "ls\\puzzles\\p42_celticknots\\ck02": "Celtic Knots",
    "ls\\puzzles\\p82_whirlingdervishes\\wd01": "p82_whirlingdervishes - wd01",
    "ls\\puzzles\\p26_spinnera\\sa01": "p26_spinnera - sa01",
    "ls\\puzzles\\p07_frightrings\\fr01": "p07_frightrings - fr01",
    "ls\\puzzles\\p01_ringgoal\\rg01": "p01_ringgoal - rg01",
    "ls\\puzzles\\p77_jawbridge\\jb01": "Jawbridge",
    "ls\\puzzles\\p65_mesmerise\\mes01": "p65_mesmerise - mes01",
    "ls\\puzzles\\p107_stinkysteps\\stst01": "Stinkysteps",
    "ls\\puzzles\\pp12_backslider\\bu01": "Backslider",
    "ls\\puzzles\\p54_floorslider\\fs01": "Floor Sliders",
    "ls\\puzzles\\pp11_deadline\\uad01": "Deadline",
    "ls\\puzzles\\p112_gankanny\\htl01": "Gankanny",
    "ls\\puzzles\\p104_threebie\\thr01": "Headlong",
    "ls\\puzzles\\pp14_backflip\\bf01": "Backflip",
    "ls\\puzzles\\p58_crossroads\\cros01": "Crossroads",
    "ls\\puzzles\\p113_bowls\\b01": "Bowls",
    "ls\\puzzles\\p108_threewheel\\twh01": "Freewheeler",
    "ls\\puzzles\\p114_sidestep\\sst01": "Sidestep",
    "ls\\puzzles\\pp13_pitchnputt\\pnp01": "Pitch And Putt",
    "ls\\puzzles\\p105_threedom\\td01": "Circuits",
    "ls\\puzzles\\pp15_loopit\\lit01": "Loop It",
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