// Cladun: This Is An RPG
// #ID = 14498

NULL = 0

function if_else(cond, a, b)
{
    if cond
        return a
    return b
}

function DungeonState(addr)
{
    obj = {
        "m_newgeon_floor": dword(addr + 0x10),
        "m_dungeon_id": dword(addr + 0x1F7B0),
        "m_floor": dword(addr + 0x1F7B4),
        "m_in_dungeon": dword(addr + 0x1F7B8),
    }
    return obj
}

function GameState(addr)
{
    obj = {
        "m_fame10_reward": bit4(addr + 0x1F),
        "m_fame30_reward": bit5(addr + 0x1F),
        "m_fame50_reward": bit6(addr + 0x1F),
        "m_fame200_reward": bit7(addr + 0x1F),
        "m_tavern_unlocked": bit3(addr + 0x25),
        "m_map_id": dword(addr + 0x85C),
        "m_character_id": dword(addr + 0x868),
        "m_dungeon_record_count": dword(addr + 0x880),
        "m_dungeon_record": array_map(range(0, 128-1), i => DungeonRecordInfo(addr + 0x884 + (SIZEOF_DungeonRecordInfo * i))),
        "m_main_character": NULL,
        "m_characters":  array_map(range(0, CHARACTER_CUSTOM10-1), i => CharacterState(addr + 0x2AE4 + (SIZEOF_CharacterState * i))),
    }
    
    // Special property for Rich Presence
    obj["m_main_character"] = CharacterState(addr + 0x2AE4 + (SIZEOF_CharacterState * obj["m_character_id"]))
    
    return obj
}

SIZEOF_CharacterState = 0x99C
function CharacterState(addr)
{
    obj = {
        "m_hp": dword(addr + 0x2C),
        // Eight slots (I think should be the max) of 8-bit character IDs
        "m_magic_circle_characters": array_map(range(0, 8-1), i => byte(addr + 0xE8 + i)),
        "m_unlocked": byte(addr + 0x4F0),
        "m_color": byte(addr + 0x4F1),
    }
    
    return obj
}

SIZEOF_DungeonRecordInfo = 0x2C
function DungeonRecordInfo(addr)
{
    obj = {
        "m_dungeon_id": word(addr + 0x0),
        "m_floor": word(addr + 0x2),
        "m_clear_count": dword(addr + 0x4),
    }
    return obj
}

function DialogWindow(addr)
{
    obj = {
        // The chosen dialogue option; sticky
        "m_option": dword(addr + 0x45C),
        // 5 = visible, 0 = invisible -- transition states from fade in/out
        "m_visibility": dword(addr + 0x4A0),
    }
    
    return obj
}

function RangeonState(addr)
{
    obj = {
        "m_floor": word(addr + 0x1C02A),
        "m_in_rangeon": byte(addr + 0x1C128),
    }
    
    return obj
}

function SaveProtection()
{
    return pg_game_state != NULL && prev(g_game_state["m_map_id"]) != MAP_TITLE
}

function InTitle()
{
    return g_game_state["m_map_id"] == MAP_TITLE
}

function PlayerLocked(delta=false)
{
    mem = dword((dword(0x998BE0) & 0x7FFFFFF) + 0x10E1C)
    if delta
        return prev(mem) != NULL
    return mem != NULL
}

function CheckCutsceneFlag(flag)
{
    return
        once(
            // Make sure we aren't on title
            SaveProtection() &&
            // Flag set
            prev(flag) == 0 && flag == 1 &&
            // reset if the player somehow gets back to the title?
            never(InTitle())
        ) &&
        // check that cutscene ended
        PlayerLocked(delta=true) && !PlayerLocked()
}

function CheckDungeonCleared(dungeon=-1, floor=-1, first=true)
{
    // Dungeon clear stats are inserted into game state in order based on when you first enter a floor
    // In some circumstances, it seems that side dungeons can enter this list even before hitting the credits
    // (are these MP maps, maybe?) so to be thorough we should check the whole list.
    MAX_SAFE_DUNGEON = -1//RECORD_LASTBOSS1F//-1 // max ID to not check multiple for
    MAX_DUNGEON_COUNT = 200//RECORD_REMEMBRANCE9994F//200 // max range to check multiple for

    // Check every single possible slot
    infos = array_map(range(0, length(g_game_state["m_dungeon_record"])-1), i => {"index": i, "data": g_game_state["m_dungeon_record"][i]})
    
    base_cond = g_dungeon_state["m_dungeon_id"] == dungeon && g_dungeon_state["m_floor"] == floor
    conds = [] 
    for info in infos
    {
        idx = info["index"]
        data = info["data"]
        
        // Turns out arbitrary records can make their way into the list, screwing up progression order.
        // Since the expected behavior of the clear count value is that it can only increment by 1 on a new frame,
        // we can squish checking a change in clear count into a giant OrNext chain.
        
        if first
            // Since we're checking 0 -> 1 (and 1 -> 0 should be impossible while in-game), we can check mem + delta = 1
            cond = prev(data["m_clear_count"]) + data["m_clear_count"] == 1
        else
            // For non-first, simply have to check that mem > delta
            cond = prev(data["m_clear_count"]) < data["m_clear_count"]
            
        array_push(conds, cond)
    }
    
    return base_cond && __ornext(any_of(conds, v=>v))
}

function CheckBadEnding(character)
{
    // For last boss defeat (don't want to trigger these after defeating last boss)
    pause = disable_when(g_game_state["m_map_id"] == MAP_LASTBOSS1F_BATTLE_AFTER, until=!PlayerLocked())

    return
        pause &&
        repeated(
            15485, // Timed to appear as "[Production and Planning]" leaves screen and "Nippon Ichi Software" is left
            // You can't do anything but wait once you hit the credits; no way to skip, so this should be fine.
            once(
                pg_game_state != NULL &&
                // Correct character
                g_game_state["m_character_id"] == character &&
                // Credits!
                g_game_state["m_map_id"] == MAP_CREDITS &&
                // Credits map is actually used for some scenes (like Battleblo's) before actual credits, but the "in stage"
                // flag gets set when credits start, so we can utilize that.
                g_dungeon_state["m_in_dungeon"] == 1 &&
                (
                    // These can get set out of order depending on ending,
                    // for example this first line gets set last in Battleblo's ending
                    prev(g_dungeon_state["m_in_dungeon"]) == 0 ||
                    // while this gets set last in Souma's ending
                    prev(g_game_state["m_map_id"]) != MAP_CREDITS
                )
            ) && always_true()
        ) ||
        // the achievement should be awarded before returning to title but just in case
        (
            pg_game_state != NULL &&
            prev(g_game_state["m_character_id"]) == character &&
            prev(g_game_state["m_map_id"]) == MAP_CREDITS && 
            g_game_state["m_map_id"] == MAP_TITLE
        )
}

CHARACTER_PUDDING = 0
CHARACTER_COCO = 1
CHARACTER_DESPINA = 2
CHARACTER_SOUMA = 3
CHARACTER_SHERBET = 4
CHARACTER_BATTLEBLO = 5
CHARACTER_DOTACHE = 6
CHARACTER_BOB = 7
CHARACTER_SUNDAY = 8
CHARACTER_ASAGI = 9
CHARACTER_CUSTOM1 = 11
CHARACTER_CUSTOM2 = 12
CHARACTER_CUSTOM3 = 13
CHARACTER_CUSTOM4 = 14
CHARACTER_CUSTOM5 = 15
CHARACTER_CUSTOM6 = 16
CHARACTER_CUSTOM7 = 17
CHARACTER_CUSTOM8 = 18
CHARACTER_CUSTOM9 = 19
CHARACTER_CUSTOM10 = 20

MAP_TITLE = 0
MAP_CREDITS = 10
MAP_HIYO1F = 10001
MAP_COB1F = 10101
MAP_LASTBOSS1F_BATTLE = 11401
MAP_LASTBOSS1F_BATTLE_AFTER = 11408
MAP_HUB = 50001
MAP_PROLOGUE_CUTSCENE = 60000
MAP_PROLOGUE_DUNGEON = 60001

DUNGEON_ARCANUS = 0
DUNGEON_HIYO = 1
DUNGEON_COB = 2
DUNGEON_DRAGON = 3
DUNGEON_BURN = 4
DUNGEON_ZERO = 5
DUNGEON_SHRINE = 6
DUNGEON_LAB = 7
DUNGEON_HOUSE = 8
DUNGEON_DESERT = 9
DUNGEON_CASTLE = 10
DUNGEON_CAVE = 11
DUNGEON_COURAGE = 12
DUNGEON_SQUARE = 13
DUNGEON_POB = 14
DUNGEON_NEWENEMY = 19
DUNGEON_LASTBOSS = 20
DUNGEON_OBLIVION = 21
DUNGEON_KHAMUN = 23
// MP maps
DUNGEON_CONNECTING_FOREST = 30

pg_game_state = dword(0x9950b8) // Can't mask here because (X & 0x7FFFFFF) == 0 seems to be considered always false
g_game_state = GameState(pg_game_state & 0x7FFFFFF)
g_dungeon_state = DungeonState(dword(0x9950bc) & 0x7FFFFFF)
pg_rangeon_state = dword(0x999498)
g_rangeon_state = RangeonState(pg_rangeon_state & 0x7FFFFFF)
g_text = dword(0x9996D0) & 0x7FFFFFF
g_dialog_window = DialogWindow(g_text)
g_conversation_index = dword((dword((dword(0x996190) & 0x7FFFFFF) + 0x0) & 0x7FFFFFF) + 0x880)


achievement(
    id=194798,
    title="Starting a New Adventure",
    description="Complete the Prologue Stage and reach Arcanus Cella",
    type="progression",
    points=1,
    trigger=
        SaveProtection() &&
        prev(g_game_state["m_map_id"]) == MAP_PROLOGUE_DUNGEON &&
        g_game_state["m_map_id"] == MAP_HUB
)

achievement(
    id=194799,
    title="The Most Unlucky Guy", 
    description="Coco has joined your party",
    type="progression",
    points=2,
    trigger=
        SaveProtection() &&
        prev(g_game_state["m_characters"][CHARACTER_COCO]["m_unlocked"]) == 0 &&
        g_game_state["m_characters"][CHARACTER_COCO]["m_unlocked"] == 1
)

achievement(
    id=194800,
    title="The Cave Hiyo Lives in", 
    description="Complete Hiyo's Cave for the first time",
    type="progression",
    points=2,
    trigger=
        SaveProtection() &&
        CheckDungeonCleared(dungeon=DUNGEON_HIYO, floor=3)
)

achievement(
    id=194801,
    title="'Taberna do Seu Miguel'", 
    description="You now have access to the Tavern",
    type="progression",
    points=2,
    trigger=
        SaveProtection() &&
        CheckCutsceneFlag(g_game_state["m_tavern_unlocked"])
)

achievement(
    id=194802,
    title="The Handsome Swordswoman and The Shield Addict Guy", 
    description="Sunday and Battleblo have joined your party",
    type="progression",
    points=4,
    trigger=
        SaveProtection() &&
        prev(g_game_state["m_characters"][CHARACTER_SUNDAY]["m_unlocked"]) == 0 &&
        g_game_state["m_characters"][CHARACTER_SUNDAY]["m_unlocked"] == 1
)

achievement(
    id=194803,
    title="Easy Cave", 
    description="Complete Cave of Beginnings for the first time",
    type="progression",
    points=5,
    trigger=
        SaveProtection() &&
        CheckDungeonCleared(dungeon=DUNGEON_COB, floor=4)
)

achievement(
    id=194804,
    title="Bob Ross Is That You?",
    description="Bob has joined your party",
    type="progression",
    points=5, 
    trigger=
        SaveProtection() &&
        prev(g_game_state["m_characters"][CHARACTER_BOB]["m_unlocked"]) == 0 &&
        g_game_state["m_characters"][CHARACTER_BOB]["m_unlocked"] == 1
)

achievement(
    id=194805,
    title="Draco Forest",
    type="progression",
    points=5,
    description="Complete Dragon Forest for the first time",
    trigger=
        SaveProtection() &&
        CheckDungeonCleared(dungeon=DUNGEON_DRAGON, floor=3)
)

achievement(
    id=194806,
    title="A Stalker?", 
    description="Sherbet has joined your party",
    type="progression",
    points=5, 
    trigger=
        SaveProtection() &&
        prev(g_game_state["m_characters"][CHARACTER_SHERBET]["m_unlocked"]) == 0 &&
        g_game_state["m_characters"][CHARACTER_SHERBET]["m_unlocked"] == 1
)

achievement(
    id=194807,
    title="'Ta Pegando Fogo Bicho'", 
    description="Complete Burning Cave for the first time",
    type="progression",
    points=5,
    trigger=
        SaveProtection() &&
        CheckDungeonCleared(dungeon=DUNGEON_BURN, floor=3)
)

achievement(
    id=194808,
    title="The Barkeeper and Princess", 
    description="Dotache has joined your party",
    type="progression",
    points=5,
    trigger=
        SaveProtection() &&
        prev(g_game_state["m_characters"][CHARACTER_DOTACHE]["m_unlocked"]) == 0 &&
        g_game_state["m_characters"][CHARACTER_DOTACHE]["m_unlocked"] == 1
)

achievement(
    id=194809,
    title="Sub-Zero Cave",
    description="Complete Absolute Zero for the first time",
    type="progression",
    points=5,
    trigger=
        SaveProtection() &&
        CheckDungeonCleared(dungeon=DUNGEON_ZERO, floor=3)
)

achievement(
    id=194810,
    title="Shrine of Hidden Gold", 
    description="Complete Golden Shrine for the first time",
    type="progression",
    points=5,
    trigger=
        SaveProtection() &&
        CheckDungeonCleared(dungeon=DUNGEON_SHRINE, floor=4)
)

achievement(
    id=194811,
    title="Dangerous Research Zone", 
    description="Complete Mystery Lab for the first time",
    type="progression",
    points=5,
    trigger=
        SaveProtection() &&
        CheckDungeonCleared(dungeon=DUNGEON_LAB, floor=3)
)

achievement(
    id=194812,
    title="Monster Zone", 
    description="Complete Monster House for the first time",
    type="progression",
    points=5, 
    trigger=
        SaveProtection() &&
        CheckDungeonCleared(dungeon=DUNGEON_HOUSE, floor=4)
)

achievement(
    id=194813, 
    title="Results of Warming", 
    description="Complete Scorching Desert for the first time",
    type="progression",
    points=5,
    trigger=
        SaveProtection() &&
        CheckDungeonCleared(dungeon=DUNGEON_DESERT, floor=2)
)

achievement(
    id=194814,
    title="Visited by \"Hero Tororo\" in the Past", 
    description="Complete Nostalgic Castle for the first time",
    type="progression",
    points=5,
    trigger=
        SaveProtection() &&
        CheckDungeonCleared(dungeon=DUNGEON_CASTLE, floor=4)
)

achievement(
    id=194815,
    title="Cavern Fought Over by Monsters", 
    description="Complete Enemy Cave for the first time",
    type="progression",
    points=5, 
    trigger=
        SaveProtection() &&
        CheckDungeonCleared(dungeon=DUNGEON_CAVE, floor=4)
)

achievement(
    id=194816,
    title="Do You Believe in Yourself?", 
    description="Complete Courage Wanted for the first time",
    type="progression",
    points=5,
    trigger=
        SaveProtection() &&
        CheckDungeonCleared(dungeon=DUNGEON_COURAGE, floor=4)
)

achievement(
    id=194817, 
    title="Place of Mysterious Power", 
    description="Complete Energy Square for the first time",
    type="progression",
    points=5, 
    trigger=
        SaveProtection() &&
        CheckDungeonCleared(dungeon=DUNGEON_SQUARE, floor=4)
)

achievement(
    id=194818,
    title="Chances of Contamination Is One in a Million, See He Has No Luck",
    description="You now have Zombie Coco in your team!",
    type="progression",
    points=2,
    trigger=
        SaveProtection() &&
        // There may be some game flag here but since the game effectively just changes Coco's color palette,
        // this is an intuitive check to do here
        prev(g_game_state["m_characters"][CHARACTER_COCO]["m_color"]) == 6 &&
        g_game_state["m_characters"][CHARACTER_COCO]["m_color"] == 2
)

achievement(
    id=194819,
    title="The Beginning and the End", 
    description="Complete Place of Beginnings for the first time",
    type="progression",
    points=10, 
    trigger=
        SaveProtection() &&
        CheckDungeonCleared(dungeon=DUNGEON_POB, floor=3)
)

achievement(
    id=194820,
    title="The Magician", 
    description="Despina has joined your party",
    type="progression",
    points=5,
    trigger=
        SaveProtection() &&
        prev(g_game_state["m_characters"][CHARACTER_DESPINA]["m_unlocked"]) == 0 &&
        g_game_state["m_characters"][CHARACTER_DESPINA]["m_unlocked"] == 1
)

achievement(
    id=194821,
    title="Out of Control Power",
    description="Beat the Last Boss for the first time",
    type="win_condition",
    points=10,
    trigger=
        SaveProtection() &&
        prev(g_game_state["m_map_id"]) == MAP_LASTBOSS1F_BATTLE &&
        g_game_state["m_map_id"] == MAP_LASTBOSS1F_BATTLE_AFTER
)

achievement(
    id=194822,
    title="The True Identity Revealed!", 
    description="Complete New Enemy for the first time",
    points=10,
    trigger=
        SaveProtection() &&
        CheckDungeonCleared(dungeon=DUNGEON_NEWENEMY, floor=1)
)

achievement(
    id=194824,
    title="The \"Main\" Character", 
    description="Asagi has joined your party",
    points=10,
    trigger=
        SaveProtection() &&
        prev(g_game_state["m_characters"][CHARACTER_ASAGI]["m_unlocked"]) == 0 &&
        g_game_state["m_characters"][CHARACTER_ASAGI]["m_unlocked"] == 1
)

achievement(
    id=194823,
    title="Forgotten Land", 
    description="Complete Land of Oblivion for the first time",
    points=25,
    trigger=
        SaveProtection() &&
        CheckDungeonCleared(dungeon=DUNGEON_OBLIVION, floor=4)
)

achievement(
    id=194835, 
    title="Cladun: This Is Also Art", 
    description="Create and use your first Custom Character",
    points=1,
    trigger=
        SaveProtection() &&
        prev(g_game_state["m_character_id"]) != CHARACTER_CUSTOM1 &&
        g_game_state["m_character_id"] == CHARACTER_CUSTOM1
        // pending revision if needed?
        //__ornext(prev(g_game_state["m_character_id"]) < CHARACTER_CUSTOM1 || prev(g_game_state["m_character_id"]) > CHARACTER_CUSTOM10) &&
        //g_game_state["m_character_id"] >= CHARACTER_CUSTOM1 && g_game_state["m_character_id"] <= CHARACTER_CUSTOM10
)

achievement(
    id=194843,
    title="Searching Everywhere", 
    description="Find the Letter from Hiyoji in Arcanus Cella",
    points=1,
    trigger=
        g_game_state["m_map_id"] == MAP_HUB &&
        prev(g_conversation_index == 0xAF) &&
        g_conversation_index == -1
)


achievement(
    id=194840,
    title="The Kindest People of the World", 
    description="Be kind with Arcanus Cella's pumpkins",
    points=1,
    trigger=
        // In Arcanus Cella
        g_game_state["m_map_id"] == MAP_HUB &&
        // We're in the right conversation and chose option 0 (indicated by window fading out with option 0 selected)
        g_dialog_window["m_option"] == 0 &&
        prev(g_conversation_index == 0xAB) &&
        g_conversation_index == -1
)

YAM_HERO_CONVERSATIONS = range(0xCC, 0xD1)
achievement(
    id=194844,
    title="'Senta que la Vem Historia'", 
    description="Find and read all the chapters of Adventures of the Yam Hero in Arcanus Cella",
    points=2,
    trigger=
        measured(
            tally_of(
                YAM_HERO_CONVERSATIONS,
                length(YAM_HERO_CONVERSATIONS),
                i =>
                    once(
                        // In Arcanus
                        g_dungeon_state["m_dungeon_id"] == DUNGEON_ARCANUS &&
                        // Read the book
                        prev(g_conversation_index) == i &&
                        g_conversation_index == -1 &&
                        // Reset measured on return to title
                        never(InTitle())
                    )
            )
        )
)

achievement(
    id=194836,
    title="Something in the Underground...", 
    description="Talk with Hiyoji about the 10 fame reward",
    points=3,
    trigger=
        CheckCutsceneFlag(g_game_state["m_fame10_reward"])
)

achievement(
    title="The Legendary Artifact, \"Widen!\"", points = 5,
    description = "Talk with Hiyoji about the 30 fame reward",
    id = 194837,
    trigger=
        CheckCutsceneFlag(g_game_state["m_fame30_reward"])
)

achievement(
    id=194838,
    title="The Legendary Blunt Weapon, \"Prinny Stick!\"",
    description="Talk with Hiyoji about the 50 fame reward",
    points=10,
    trigger=
        CheckCutsceneFlag(g_game_state["m_fame50_reward"])
)

achievement(
    id=194839,
    title="Buy Weapons With Ultimate Titles at the Store!",
    description="Talk with Hiyoji about the 200 fame reward",
    points=25,
    trigger=
        CheckCutsceneFlag(g_game_state["m_fame200_reward"])
)

achievement(
    id=194841,
    title="I'm Moving Up and Down, Side to Side Like a Roller Coaster",
    description="Reach New-geon floor 100 or higher",
    points=25,
    trigger=
        g_dungeon_state["m_in_dungeon"] == 1 &&
        prev(g_dungeon_state["m_newgeon_floor"]) < 100 &&
        g_dungeon_state["m_newgeon_floor"] >= 100
)

achievement(
    id=194842,
    title="Dungeon Master",
    description="Complete the 50th floor and move onto the next of floor of the Ran-geon",
    points = 10,
    trigger=
        pg_rangeon_state != NULL &&
        g_rangeon_state["m_in_rangeon"] == 1 &&
        prev(g_rangeon_state["m_floor"]) == 50 &&
        g_rangeon_state["m_floor"] == 51
)

function DamagelessFloor(dungeon, floor, character=CHARACTER_SOUMA)
{
    // Reset if we leave
    leave_reset = never(g_dungeon_state["m_dungeon_id"] != dungeon)
    if dungeon == DUNGEON_LASTBOSS
    {
        // Special case for last boss to handle ending cutscene
        leave_reset = never(
            g_dungeon_state["m_dungeon_id"] != dungeon &&
            g_game_state["m_map_id"] != MAP_LASTBOSS1F_BATTLE_AFTER
        )
    }

    return
        // Enter stage (as character and with no subs)
        once(
            pg_game_state != NULL &&
            // Entered the map
            prev(g_dungeon_state["m_dungeon_id"]) != dungeon &&
            g_dungeon_state["m_dungeon_id"] == dungeon &&
            g_dungeon_state["m_floor"] == floor &&
            // Is character
            g_game_state["m_character_id"] == character &&
            // No subs
            all_of(g_game_state["m_characters"][character]["m_magic_circle_characters"], v => v == 0xFF)
        ) &&
        // Reset if we leave
        leave_reset &&
        // Reset if we take damage
        never(
            g_game_state["m_characters"][character]["m_hp"] < prev(g_game_state["m_characters"][character]["m_hp"])
        ) &&
        // Complete stage
        trigger_when(
            if_else(
                dungeon == DUNGEON_LASTBOSS,
                CheckDungeonCleared(dungeon=dungeon, floor=floor, first=false) ||
                (
                    prev(g_game_state["m_map_id"]) == MAP_LASTBOSS1F_BATTLE &&
                    g_game_state["m_map_id"] == MAP_LASTBOSS1F_BATTLE_AFTER
                ),
                CheckDungeonCleared(dungeon=dungeon, floor=floor, first=false)
            )
        )
}

achievement(
    id=194845,
    title="Th-The Mask", 
    description="As Souma and without any Sub Characters, complete the Last Boss without taking damage",
    points=10,
    trigger=
        DamagelessFloor(DUNGEON_LASTBOSS, floor=1)
)

achievement(
    id=194846,
    title="Damageless Run I", 
    description="As Souma and without any Sub Characters, complete Hiyo's Cave 1F without taking damage",
    points=10,
    trigger=
        DamagelessFloor(DUNGEON_HIYO, floor=1)
)

achievement(
    id=194847,
    title="Damageless Run II",
    description="As Souma and without any Sub Characters, complete Cave of Beginnings 1F without taking damage",
    points=10,
    trigger=
        DamagelessFloor(DUNGEON_COB, floor=1)
)

ending_params = [
    {
        "id": 194825,
        "title": "No Way, 100 Years Passed Since I Left?!",
        "description": "Get the Pudding Ending",
        "points": 2,
        "character": CHARACTER_PUDDING,
    },
    {
        "id": 194826,
        "title": "I’m So Unlucky to Be Sealed by Mistake",
        "description": "Get the Coco Ending",
        "points": 3,
        "character": CHARACTER_COCO,
    },
    {
        "id": 194827,
        "title": "Why Did I Even Create This World?",
        "description": "Get the Despina Ending",
        "points": 10,
        "character": CHARACTER_DESPINA,
    },
    {
        "id": 194828,
        "title": "Bye, Puddie, Take Care of Yourself, Okay...?",
        "description": "Get the Souma Ending",
        "points": 2,
        "character": CHARACTER_SOUMA,
    },
    {
        "id": 194829,
        "title": "Somebody Please Give Me an Order",
        "description": "Get the Sherbet Ending",
        "points": 5,
        "character": CHARACTER_SHERBET,
    },
    {
        "id": 194830,
        "title": "Completely Useless against People Who Don't Attack",
        "description": "Get the Battleblo Ending",
        "points": 5,
        "character": CHARACTER_BATTLEBLO,
    },
    {
        "id": 194831,
        "title": "It Pains Me to be Called \"Barkeep\" Now",
        "description": "Get the Dotache Ending",
        "points": 5,
        "character": CHARACTER_DOTACHE,
    },
    {
        "id": 194832,
        "title": "The Hair I Wanted All This Time Can't Be Found Here",
        "description": "Get the Bob Ending",
        "points": 5,
        "character": CHARACTER_BOB,
    },
    {
        "id": 194833,
        "title": "It's So Dark... I'm So Scared...",
        "description": "Get the Sunday Ending",
        "points": 5,
        "character": CHARACTER_SUNDAY,
    },
    {
        "id": 194834,
        "title": "I Really Don't Belong Here",
        "description": "Get the Asagi Ending",
        "points": 10,
        "character": CHARACTER_ASAGI,
    },
]

for params in ending_params
{
    achievement(
        id=params["id"],
        title=params["title"],
        description=params["description"],
        points=params["points"],
        trigger=CheckBadEnding(params["character"])
    )
}

// Rich Presence

function InPrologue()
{
    return any_of([MAP_PROLOGUE_CUTSCENE, MAP_PROLOGUE_DUNGEON], m => m == g_game_state["m_map_id"])
}

function InRangeon()
{
    return g_rangeon_state["m_in_rangeon"] == 1
}

function InDungeon()
{
    // Also includes Rangeon
    return g_dungeon_state["m_in_dungeon"] == 1
}

function MeasuredNoneSubChars()
{
    return 
        measured(
            once(
                all_of(g_game_state["m_main_character"]["m_magic_circle_characters"], v => v == 0xFF) &&
                never(any_of(g_game_state["m_main_character"]["m_magic_circle_characters"], v => v != 0xFF))
            )
        )
}

dungeon_lookup = {
    DUNGEON_ARCANUS: "Arcanus Cella",
    DUNGEON_HIYO: "Hiyo's Cave",
    DUNGEON_COB: "Cave of Beginnings",
    DUNGEON_DRAGON: "Dragon Forest",
    DUNGEON_BURN: "Burning Cave",
    DUNGEON_ZERO: "Absolute Zero",
    DUNGEON_SHRINE: "Golden Shrine",
    DUNGEON_LAB: "Mystery Lab",
    DUNGEON_HOUSE: "Monster House",
    DUNGEON_DESERT: "Scorching Desert",
    DUNGEON_CASTLE: "Nostalgic Castle",
    DUNGEON_CAVE: "Enemy Cave",
    DUNGEON_COURAGE: "Courage Wanted",
    DUNGEON_SQUARE: "Energy Square",
    DUNGEON_POB: "Place of Beginnings",
    15: "UNKNOWN AREA 0xF",
    16: "UNKNOWN AREA 0x10",
    17: "UNKNOWN AREA 0x11",
    18: "UNKNOWN AREA 0x12",
    DUNGEON_NEWENEMY: "New Enemy",
    DUNGEON_LASTBOSS: "Last Boss",
    DUNGEON_OBLIVION: "Land of Oblivion",
    22: "UNKNOWN AREA 0x16",
    DUNGEON_KHAMUN: "Khamun's Revenge",
    24: "UNKNOWN AREA 0x18",
    25: "UNKNOWN AREA 0x19",
    26: "UNKNOWN AREA 0x1A",
    27: "UNKNOWN AREA 0x1B",
    28: "UNKNOWN AREA 0x1C",
    29: "UNKNOWN AREA 0x1D",
    DUNGEON_CONNECTING_FOREST: "Connecting Forest",
}

char_lookup = {
    CHARACTER_PUDDING: "Pudding",
    CHARACTER_COCO: "Coco",
    CHARACTER_DESPINA: "Despina",
    CHARACTER_SOUMA: "Souma",
    CHARACTER_SHERBET: "Sherbet",
    CHARACTER_BATTLEBLO: "Battleblo",
    CHARACTER_DOTACHE: "Dotache",
    CHARACTER_BOB: "Bob",
    CHARACTER_SUNDAY: "Sunday",
    CHARACTER_ASAGI: "Asagi",
    10: "UNKNOWN CHARACTER 0xA",
    CHARACTER_CUSTOM1: "Custom",
    CHARACTER_CUSTOM2: "Custom",
    CHARACTER_CUSTOM3: "Custom",
    CHARACTER_CUSTOM4: "Custom",
    CHARACTER_CUSTOM5: "Custom",
    CHARACTER_CUSTOM6: "Custom",
    CHARACTER_CUSTOM7: "Custom",
    CHARACTER_CUSTOM8: "Custom",
    CHARACTER_CUSTOM9: "Custom",
    CHARACTER_CUSTOM10: "Custom",
}

// The following is just some trickery to *try* and get some semblance of a sub character list
// with the limited string processing
rp_sub_chars = array_map(
    range(0, 8-1), 
    i => 
        rich_presence_lookup("SUB_CHAR", g_game_state["m_main_character"]["m_magic_circle_characters"][i], char_lookup)
)
none_sub_char_lookup = {0: ""}
rp_sub_none = rich_presence_lookup("NONE_SUB", MeasuredNoneSubChars(), none_sub_char_lookup, "None")
commas_lookup = {0: ""}
rp_commas = []
for i in range(0, 7-1)
{
    list = g_game_state["m_main_character"]["m_magic_circle_characters"]
    sublist = []
    for j in range(i + 1, length(list) - 1)
    {
        array_push(sublist, list[j])
    }
    cond =
        measured(
            once(
                any_of(sublist, v => v != 0xFF) &&
                list[i] != 0xFF &&
                never(all_of(sublist, v => v == 0xFF)) &&
                never(list[i] == 0xFF)
            )
        )
    array_push(rp_commas, rich_presence_lookup("COMMA_JOIN", cond, commas_lookup, ", "))
}

rp_char = rich_presence_lookup("CHAR", g_game_state["m_character_id"], char_lookup)
rp_rangeon_floor = rich_presence_value("RANGEON_FLOOR", g_rangeon_state["m_floor"])
rp_floor = rich_presence_value("FLOOR", g_dungeon_state["m_floor"])
rp_dungeon = rich_presence_lookup("DUNGEON", g_dungeon_state["m_dungeon_id"], dungeon_lookup, "UNKNOWN AREA")

rich_presence_conditional_display(
    InTitle(),
    "In the title menu"
)
rich_presence_conditional_display(
    InPrologue(),
    "Souma and Pudding are on their way to Arcanus Cella"
)
rich_presence_conditional_display(
    InRangeon(),
    "{0} is on {1}F of Ran-Geon | Subs: {2}{3}{4}{5}{6}{7}{8}{9}{10}{11}{12}{13}{14}{15}{16}{17}",
    rp_char,
    rp_floor,
    rp_sub_chars[0],
    rp_commas[0],
    rp_sub_chars[1],
    rp_commas[1],
    rp_sub_chars[2],
    rp_commas[2],
    rp_sub_chars[3],
    rp_commas[3],
    rp_sub_chars[4],
    rp_commas[4],
    rp_sub_chars[5],
    rp_commas[5],
    rp_sub_chars[6],
    rp_commas[6],
    rp_sub_chars[7],
    rp_sub_none
)
rich_presence_conditional_display(
    g_dungeon_state["m_dungeon_id"] == DUNGEON_ARCANUS,
    "{0} is in Arcanus Cella",
    rp_char
)
rich_presence_conditional_display(
    pg_game_state != NULL, // Default case (if we're in game)
    "{0} is on {1}F of {2} | Subs: {3}{4}{5}{6}{7}{8}{9}{10}{11}{12}{13}{14}{15}{16}{17}{18}",
    rp_char,
    rp_floor,
    rp_dungeon,
    rp_sub_chars[0],
    rp_commas[0],
    rp_sub_chars[1],
    rp_commas[1],
    rp_sub_chars[2],
    rp_commas[2],
    rp_sub_chars[3],
    rp_commas[3],
    rp_sub_chars[4],
    rp_commas[4],
    rp_sub_chars[5],
    rp_commas[5],
    rp_sub_chars[6],
    rp_commas[6],
    rp_sub_chars[7],
    rp_sub_none
)
rich_presence_display(
    "Booting up an RPG"
)
