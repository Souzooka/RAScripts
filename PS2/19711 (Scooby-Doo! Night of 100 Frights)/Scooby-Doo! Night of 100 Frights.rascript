// Scooby-Doo! Night of 100 Frights
// #ID = 19711

function if_else(cond, a, b)
{
    if cond == true
        return a
    return b
}

function RegionData(region_id)
{
    addr = 0x362FD0 + (0xD0 * region_id)
    obj = {
        "m_tokens": dword(addr + 0xDA4),
        "m_snacks": dword(addr + 0xDAC),
    }    
    
    return obj
}

function RegionParams(snacks, tokens, area_ids)
{
    obj = {
        "m_snacks": snacks,
        "m_tokens": tokens,
        "m_level_ids": array_map(area_ids, v => v),
    }
    
    return obj
}

REGION_MYSTERY_MACHINE = 1
REGION_HEDGE = 2
REGION_GREENHOUSE = 3
REGION_HILL = 4
REGION_CLIFF = 5
REGION_CAVE = 6
REGION_GRAVE = 7
REGION_CRYPT = 8
REGION_TOMB = 9
REGION_DOCK = 10
REGION_FISH = 11
REGION_PIER = 12
REGION_COAST = 13
REGION_WITCH = 14
REGION_LIGHTHOUSE = 15
REGION_DECK = 16
REGION_MAST = 17
REGION_TIMBERS = 18
REGION_MANOR1 = 19
REGION_MANOR2 = 20
REGION_UPSTAIRS = 21
REGION_MANOR_EXTERIOR = 22
REGION_ATTIC = 23
REGION_KNIGHT = 24
REGION_CELLAR = 25
REGION_HALLWAYS = 26
REGION_UNDERGROUND = 27
REGION_LAB = 28
REGION_MASTERMIND = 29

// extracted from executable via Python script
region_params = {
    REGION_MYSTERY_MACHINE: RegionParams(118, 1, ["100H", "200H", "300H"]),
    REGION_HEDGE: RegionParams(371, 2, ["100E", "200E", "300E", "400E"]),
    REGION_GREENHOUSE: RegionParams(143, 0, ["500E", "600E"]),
    REGION_HILL: RegionParams(309, 0, ["700E", "800E", "900E"]),
    REGION_CLIFF: RegionParams(394, 0, ["100C", "200C", "300C", "400C"]),
    REGION_CAVE: RegionParams(257, 1, ["500C", "600C", "700C"]),
    REGION_GRAVE: RegionParams(116, 1, ["100G", "200G"]),
    REGION_CRYPT: RegionParams(224, 1, ["300G", "400G", "500G", "600G"]),
    REGION_TOMB: RegionParams(264, 1, ["700G", "800G", "900G"]),
    REGION_DOCK: RegionParams(154, 0, ["100F", "300F"]),
    REGION_FISH: RegionParams(386, 2, ["400F", "500F", "600F", "700F"]),
    REGION_PIER: RegionParams(202, 0, ["800F", "900F", "010F"]),
    REGION_COAST: RegionParams(373, 2, ["110L", "310L", "410L"]),
    REGION_WITCH: RegionParams(121, 0, ["510L"]),
    REGION_LIGHTHOUSE: RegionParams(269, 0, ["710L", "810L", "910L"]),
    REGION_DECK: RegionParams(268, 1, ["020W", "120W", "220W"]),
    REGION_MAST: RegionParams(375, 1, ["320W", "520W", "620W"]),
    REGION_TIMBERS: RegionParams(117, 0, ["720W", "820W"]),
    REGION_MANOR1: RegionParams(220, 1, ["100I", "020I", "120I", "300I"]),
    REGION_MANOR2: RegionParams(228, 1, ["400I", "500I", "600I"]),
    REGION_UPSTAIRS: RegionParams(390, 1, ["100R", "020R", "120R", "300R"]),
    REGION_MANOR_EXTERIOR: RegionParams(163, 0, ["400R", "500R", "600R"]),
    REGION_ATTIC: RegionParams(342, 2, ["100O", "200O", "300O", "400O"]),
    REGION_KNIGHT: RegionParams(240, 0, ["500O", "600O", "800O"]),
    REGION_CELLAR: RegionParams(205, 1, ["100B", "200B", "300B", "400B"]),
    REGION_HALLWAYS: RegionParams(165, 0, ["100P", "200P", "300P"]),
    REGION_UNDERGROUND: RegionParams(110, 0, ["400P", "500P"]),
    REGION_LAB: RegionParams(160, 2, ["100S", "200S", "300S"]),
    REGION_MASTERMIND: RegionParams(64, 0, ["400S", "500S"]),
}

g_level_id_str = dword(0x363B64) + 0x6C
region_data = {}
for region in region_params
{
    region_data[region] = RegionData(region)
}

function get_level_id(region, part)
{
    return region_params[region]["m_level_ids"][part - 1]
}

function is_level(level_id)
{
    return ascii_string_equals(g_level_id_str, level_id, length=4)
}

function is_region(region_id)
{
    return __ornext(any_of(region_params[region_id]["m_level_ids"], is_level))
}

function save_protection()
{
    return !prev(ascii_string_equals(g_level_id_str, "3UNM", length=4))
}

function cheat_protection()
{
    return bit4(0x362e70) != 0
}

//
// Inventions
//

achievement(
    id=230437,
    title="Digging For Clues, Scooby-Doo?",
    description="Get the Shovel.",
    type="progression",
    points=3,
    trigger=
        save_protection() &&
        cheat_protection() &&
        // In correct level
        is_level(get_level_id(REGION_MYSTERY_MACHINE, 1)) &&
        // Invention unlocked
        prev(bit5(0x3635B9)) == 0 && bit5(0x3635B9) == 1
)

achievement(
    id=230436,
    title="The Spring's The Thing!",
    description="Get the Professor's \"Springs\" invention.",
    type="progression",
    points=5,
    trigger=
        save_protection() &&
        cheat_protection() &&
        // In correct level
        is_level(get_level_id(REGION_PIER, 3)) &&
        // Invention unlocked
        prev(bit1(0x3635B9)) == 0 && bit1(0x3635B9) == 1
)

achievement(
    id=230435,
    title="Get Some Light or You're In For A Fright!",
    description="Get the Professor's \"Slippers\" and \"Lampshade\" inventions.",
    type="progression",
    points=5,
    trigger=
        save_protection() &&
        cheat_protection() &&
        // In correct level
        is_level(get_level_id(REGION_HEDGE, 2)) &&
        // Invention unlocked
        prev(bit4(0x3635B8)) == 0 && bit4(0x3635B8) == 1
)

achievement(
    id=230434,
    title="Bash Through The Monster Mash!",
    description="Get the Professor's \"Helmet\" invention.",
    type="progression",
    points=5,
    trigger=
        save_protection() &&
        cheat_protection() &&
        // In correct level
        is_level(get_level_id(REGION_HILL, 3)) &&
        // Invention unlocked
        prev(bit3(0x3635B9)) == 0 && bit3(0x3635B9) == 1
)

achievement(
    id=230433,
    title="Stylin' Shoes, Scooby-Doo!",
    description="Get the Professor's \"Anti-Sticking Galoshes\" invention.",
    type="progression",
    points=10,
    trigger=
        save_protection() &&
        cheat_protection() &&
        // In correct level
        is_level(get_level_id(REGION_KNIGHT, 3)) &&
        // Invention unlocked
        prev(bit2(0x3635B8)) == 0 && bit2(0x3635B8) == 1
)

achievement(
    id=230431,
    title="Crash, Bash, and Smash!",
    description="Get the Professor's \"Super Smash\" invention.",
    type="progression",
    points=5,
    trigger=
        save_protection() &&
        cheat_protection() &&
        // In correct level
        is_level(get_level_id(REGION_LIGHTHOUSE, 1)) &&
        // Invention unlocked
        prev(bit2(0x3635B9)) == 0 && bit2(0x3635B9) == 1
)

achievement(
    id=230430,
    title="Evil And Medieval!",
    description="Get the \"Black Knight Armor\" upgrade.",
    type="progression",
    points=5,
    trigger=
        save_protection() &&
        cheat_protection() &&
        // In correct level
        is_level(get_level_id(REGION_MANOR_EXTERIOR, 1)) &&
        // Invention unlocked
        prev(bit6(0x3635B8)) == 0 && bit6(0x3635B8) == 1
)

achievement(
    id=230429,
    title="Plungin' In The Dungeon!",
    description="Get the Professor's \"Plunger\" invention.",
    type="progression",
    points=5,
    trigger=
        save_protection() &&
        cheat_protection() &&
        // In correct level
        is_level(get_level_id(REGION_HALLWAYS, 3)) &&
        // Invention unlocked
        prev(bit3(0x3635B8)) == 0 && bit3(0x3635B8) == 1
)

achievement(
    id=230428,
    title="Even Faster Ghoul Thrasher!",
    description="Get the Professor's \"Super Sonic Smash\" invention enhancement.",
    type="progression",
    points=5,
    trigger=
        save_protection() &&
        cheat_protection() &&
        // In correct level
        is_level(get_level_id(REGION_CAVE, 3)) &&
        // Invention unlocked
        prev(bit6(0x3635B9)) == 0 && bit6(0x3635B9) == 1
)

achievement(
    id=230427,
    title="Barely Flying, More Like Gliding!",
    description="Get the Professor's \"Umbrella\" invention.",
    type="progression",
    points=10,
    trigger=
        save_protection() &&
        cheat_protection() &&
        // In correct level
        is_level(get_level_id(REGION_TOMB, 3)) &&
        // Invention unlocked
        prev(bit4(0x3635B9)) == 0 && bit4(0x3635B9) == 1
)

achievement(
    id=230425,
    title="A Tricky, Sticky Situation!",
    description="Get the Professor's \"Tricky Sticky Gum Doohickey\" invention.",
    type="progression",
    points=10,
    trigger=
        save_protection() &&
        cheat_protection() &&
        // In correct level
        is_level(get_level_id(REGION_TIMBERS, 2)) &&
        // Invention unlocked
        prev(bit0(0x3635B8)) == 0 && bit0(0x3635B8) == 1
)

achievement(
    id=230423,
    title="A Mean, Clean, Ghost Fighting Machine!",
    description="Get the Professor's \"Soap Bubble\" invention.",
    type="progression",
    points=10,
    trigger=
        save_protection() &&
        cheat_protection() &&
        // In correct level
        is_level(get_level_id(REGION_CELLAR, 4)) &&
        // Invention unlocked
        prev(bit1(0x3635B8)) == 0 && bit1(0x3635B8) == 1
)

//
// Warp gates
//

g_warp_gates = array_map(range(0, 26-1), i => dword(0x2B3154 + i * 0xC))

achievement(
    id=230420,
    title="To Here And Back, And Here Again",
    description="Find all 26 Warp Gates.",
    points=10,
    trigger=
        save_protection() &&
        cheat_protection() &&
        sum_of(g_warp_gates, prev) == length(g_warp_gates) - 1 &&
        measured(sum_of(g_warp_gates, v => v) == length(g_warp_gates))
)

//
// Upgrade capacity
//

achievement(
    id=230419,
    title="All Gummed Up",
    description="Upgrade your max gum capacity to 75.",
    points=10,
    trigger=
        save_protection() &&
        cheat_protection() &&
        // Upgraded to 75 gum capacity
        prev(dword(0x3635C8)) == 65 &&
        measured(
            dword(0x3635C8) == 75,
            // when we have the gum upgrade
            when=bit0(0x3635B8) == 1
        )
)

achievement(
    id=230418,
    title="Fresh Like A Spring Breeze",
    description="Upgrade your soap capacity to 85.",
    points=10,
    trigger=
        save_protection() &&
        cheat_protection() &&
        // Upgraded to 85 soap capacity
        prev(dword(0x3635C8)) == 75 &&
        measured(
            dword(0x3635C8) == 85,
            // when we have the soap upgrade
            when=bit1(0x3635B8) == 1
        )
)

//
// Snacks
// 

SNACK_PARAMS = [
    {
        "region": REGION_MYSTERY_MACHINE,
        "id": 230417,
        "title": "Free Food!",
        "description": "Collect all Scooby Snacks and the Gargoyle monster token in \"Mystery Machine\".",
        "points": 5,
    },
    {
        "region": REGION_HEDGE,
        "id": 230416,
        "title": "Tastes Like Branches",
        "description": "Collect all Scooby Snacks and the Werewolf and Witch monster tokens in \"On Edge In The Hedge!\"",
        "points": 10,
    },
    {
        "region": REGION_GREENHOUSE,
        "id": 230415,
        "title": "Tastes Like Chlorophyll",
        "description": "Collect all Scooby Snacks in \"It's A Mean Greenhouse, Scooby!\"",
        "points": 10,
    },
    {
        "region": REGION_HILL,
        "id": 230414,
        "title": "Tastes Like Ghosts",
        "description": "Collect all Scooby Snacks in \"Chills And Spills On Haunted Hill!\"",
        "points": 10,
    },
    {
        "region": REGION_CLIFF,
        "id": 230413,
        "title": "Tastes Like Calcium",
        "description": "Collect all Scooby Snacks in \"Scared Stiff at Skull Cliff!\"",
        "points": 10,
    },
    {
        "region": REGION_CAVE,
        "id": 230412,
        "title": "Tastes Like Stalagmites",
        "description": "Collect all Scooby Snacks and the Green Ghost monster token in \"Misbehavin'? Cause a Cave In\".",
        "points": 10,
    },
    {
        "region": REGION_GRAVE,
        "id": 230411,
        "title": "Tastes Like Flesh",
        "description": "Collect all Scooby Snacks and the Zombie monster token in \"A Tight Spot For A Grave Plot!\"",
        "points": 10,
    },
    {
        "region": REGION_CRYPT,
        "id": 230410,
        "title": "Tastes Like Bones",
        "description": "Collect all Scooby Snacks and the Ghost monster token in \"A One Way Trip To The Crypt!\"",
        "points": 10,
    },
    {
        "region": REGION_TOMB,
        "id": 230409,
        "title": "Tastes Like Bones",
        "description": "Collect all Scooby Snacks and the Scarecrow monster token in \"Gloom And Doom Down In The Tomb!\"",
        "points": 10,
    },
    {
        "region": REGION_DOCK,
        "id": 230408,
        "title": "Tastes Like Crustaceans",
        "description": "Collect all Scooby Snacks in \"Shock On The Dock!\"",
        "points": 10,
    },
    {
        "region": REGION_FISH,
        "id": 230407,
        "title": "Tastes Like Fish",
        "description": "Collect all Scooby Snacks and the Tar Monster and Ghost Diver monster tokens in \"Fishy Clues For Scooby-Doo?\"",
        "points": 10,
    },
    {
        "region": REGION_PIER,
        "id": 230406,
        "title": "Tastes Like Seaweed",
        "description": "Collect all Scooby Snacks in \"Fear On The Pier!\"",
        "points": 10,
    },
    {
        "region": REGION_COAST,
        "id": 230405,
        "title": "Tastes Like The Palaeolithic Era",
        "description": "Collect all Scooby Snacks and the Caveman and Sea Creature monster tokens in \"Coast For Some Ghosts!\"",
        "points": 10,
    },
    {
        "region": REGION_WITCH,
        "id": 230404,
        "title": "Tastes Like Magic",
        "description": "Collect all Scooby Snacks in \"Going Down Witch Way?\"",
        "points": 5,
    },
    {
        "region": REGION_LIGHTHOUSE,
        "id": 230403,
        "title": "Tastes Like Steel",
        "description": "Collect all Scooby Snacks in \"Lighthouse Fright House!\"",
        "points": 10,
    },
    {
        "region": REGION_DECK,
        "id": 230402,
        "title": "Tastes Like The Titanic",
        "description": "Collect all Scooby Snacks and the Captain Moody monster token in \"Wreck On The Deck!\"",
        "points": 10,
    },
    {
        "region": REGION_MAST,
        "id": 230401,
        "title": "Tastes Like Beard Hair",
        "description": "Collect all Scooby Snacks and the Redbeard monster token in \"Aghast By The Mast!\"",
        "points": 10,
    },
    {
        "region": REGION_TIMBERS,
        "id": 230400,
        "title": "Tastes Like Booty",
        "description": "Collect all Scooby Snacks in \"Shiver Your Timbers, Scooby!\"",
        "points": 5,
    },
    {
        "region": REGION_MANOR1,
        "id": 230399,
        "title": "Tastes Like Antiquated Architecture",
        "description": "Collect all Scooby Snacks and the Headless Specter monster token in \"Clamor In The Manor!\"",
        "points": 10,
    },
    {
        "region": REGION_MANOR2,
        "id": 230398,
        "title": "Tastes Like Platitudes",
        "description": "Collect all Scooby Snacks and the Geronimo monster token in \"Mind Your Manors!\"",
        "points": 10,
    },
    {
        "region": REGION_UPSTAIRS,
        "id": 230397,
        "title": "Tastes Like Wood",
        "description": "Collect all Scooby Snacks and the Witch Doctor monster token in \"All Scares Upstairs!\"",
        "points": 10,
    },
    {
        "region": REGION_MANOR_EXTERIOR,
        "id": 230396,
        "title": "Tastes Like Rain",
        "description": "Collect all Scooby Snacks in \"Don't Look Down, Scooby-Doo!\"",
        "points": 10,
    },
    {
        "region": REGION_ATTIC,
        "id": 230395,
        "title": "Tastes Like Old Family Heirlooms",
        "description": "Collect all Scooby Snacks and the Black Knight and Creeper tokens in \"Cower In The Tower!\" and \"Panic In The Attic!\"",
        "points": 10,
    },
    {
        "region": REGION_KNIGHT,
        "id": 230394,
        "title": "Tastes Like Chivalry",
        "description": "Collect all Scooby Snacks in \"A Dark And Stormy Knight!\"",
        "points": 10,
    },
    {
        "region": REGION_HALLWAYS,
        "id": 230393,
        "title": "Tastes Like Spiders",
        "description": "Collect all Scooby Snacks in \"Creepy Crawlies In The Hallways!\"",
        "points": 10,
    },
    {
        "region": REGION_UNDERGROUND,
        "id": 230392,
        "title": "Tastes Like Air",
        "description": "Collect all Scooby Snacks in \"Gusts Abound Underground!\"",
        "points": 10,
    },
    {
        "region": REGION_CELLAR,
        "id": 230391,
        "title": "Tastes Like Dust",
        "description": "Collect all Scooby Snacks and the Space Kook token in \"Who's Yella In The Cellar?\"",
        "points": 10,
    },
    {
        "region": REGION_LAB,
        "id": 230390,
        "title": "Tastes Like Trinitrobenzene",
        "description": "Collect all Scooby Snacks and the Funland Robot and Mastermind tokens in \"Little Lab Of Horrors!\"",
        "points": 10,
    },
    {
        "region": REGION_MASTERMIND,
        "id": 230389,
        "title": "One Last Snack",
        "description": "Collect all Scooby Snacks in \"Mastermind Unmasked!\"",
        "points": 5,
    },
]

function SnackTrigger(region)
{
    params = region_params[region]
    target_snacks = params["m_snacks"]
    target_tokens = params["m_tokens"]
    level_ids = params["m_level_ids"]
    stats = RegionData(region)
    
    main_cond = 
        cheat_protection() &&
        save_protection() &&
        __ornext(any_of(level_ids, id => is_level(id)))
    snack_cond =
        prev(stats["m_snacks"]) >= target_snacks - 11 &&
        prev(stats["m_snacks"]) < target_snacks &&
        stats["m_snacks"] == target_snacks &&
        stats["m_tokens"] == target_tokens
    token_cond =
        if_else(
            target_tokens != 0,
            //
            prev(stats["m_tokens"]) == target_tokens - 1 &&
            stats["m_tokens"] == target_tokens &&
            stats["m_snacks"] == target_snacks,
            //
            always_false()
        )
        
    return main_cond && (snack_cond || token_cond)
}



for params in SNACK_PARAMS
{
    achievement(
        id=params["id"],
        title=params["title"],
        description=params["description"],
        points=params["points"],
        trigger=SnackTrigger(params["region"])
    )
}

//
// Miscellaneous
//

// OCA
achievement(
    id=230388,
    title="A Hop And A Drop Away!", 
    description="Find the secret entrance to \"Creepy Crawlies In The Hallways!\"",
    points=5,
    trigger=
        prev(is_level(get_level_id(REGION_DOCK, 2))) &&
        is_level(get_level_id(REGION_HALLWAYS, 1))
)
