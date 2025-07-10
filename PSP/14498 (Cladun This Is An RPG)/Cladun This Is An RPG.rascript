// Cladun: This Is An RPG
// #ID = 14498

NULL = 0

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
        "m_dungeon_record": [],
        "m_current_character": NULL,
        "m_characters": [],
    }
    
    for i in range(0, 200-1)
    {
        array_push(obj["m_dungeon_record"], DungeonRecordInfo(addr + 0x884 + (SIZEOF_DungeonRecordInfo * i)))
    }
    
    for i in range(0, CHARACTER_CUSTOM10)
    {
        array_push(obj["m_characters"], CharacterState(addr + 0x2AE4 + (SIZEOF_CharacterState * i)))
    }
    
    // Special property for Rich Presence
    obj["m_current_character"] = CharacterState(addr + 0x2AE4 + (SIZEOF_CharacterState * obj["m_character_id"]))
    
    return obj
}

SIZEOF_CharacterState = 0x99C
function CharacterState(addr)
{
    obj = {
        "m_hp": dword(addr + 0x2C),
        "m_magic_circle_characters": [],
        "m_unlocked": byte(addr + 0x4F0),
    }
    
    for i in range(0, 8-1)
    {
        // Eight slots (I think should be the max) of 8-bit character IDs
        array_push(obj["m_magic_circle_characters"], byte(addr + 0xE8 + i))
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

function CheckDungeonCleared(record_idx, dungeon=-1, floor=-1, first=true)
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
    
    if first
        return base_cond && __ornext(any_of(conds, v=>v))
    else
        // Use tally here (to prevent alt groups for damageless achievements)
        return base_cond && tally_of(conds, 1, v=>v)
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
CHARACTER_CUSTOM3 = 12
CHARACTER_CUSTOM4 = 13
CHARACTER_CUSTOM5 = 15
CHARACTER_CUSTOM6 = 16
CHARACTER_CUSTOM7 = 17
CHARACTER_CUSTOM8 = 18
CHARACTER_CUSTOM9 = 19
CHARACTER_CUSTOM10 = 20

MAP_TITLE = 0
MAP_HIYO1F = 10001
MAP_COB1F = 10101
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


// These aren't set in stone, but educated guesses for indices these records appear at
// (See note in CheckDungeonCleared)
RECORD_HIYO1F = 0
RECORD_HIYO2F = 1
RECORD_HIYO3F = 2
RECORD_COB1F = 3
RECORD_COB2F = 4
RECORD_COB3F = 5
RECORD_COB4F = 6
RECORD_DRAGON1F = 7
RECORD_DRAGON2F = 8
RECORD_DRAGON3F = 9
RECORD_BURN1F = 10
RECORD_BURN2F = 11
RECORD_BURN3F = 12
RECORD_ZERO1F = 13
RECORD_ZERO2F = 14
RECORD_ZERO3F = 15
RECORD_SHRINE1F = 16
RECORD_SHRINE2F = 17
RECORD_SHRINE3F = 18
RECORD_SHRINE4F = 19
RECORD_LAB1F = 20
RECORD_LAB2F = 21
RECORD_LAB3F = 22
RECORD_HOUSE1F = 23
RECORD_HOUSE2F = 24
RECORD_HOUSE3F = 25
RECORD_HOUSE4F = 26
RECORD_DESERT1F = 27
RECORD_DESERT2F = 28
RECORD_CASTLE1F = 29
RECORD_CASTLE2F = 30
RECORD_CASTLE3F = 31
RECORD_CASTLE4F = 32
RECORD_CAVE1F = 33
RECORD_CAVE2F = 34
RECORD_CAVE3F = 35
RECORD_CAVE4F = 36
RECORD_COURAGE1F = 37
RECORD_COURAGE2F = 38
RECORD_COURAGE3F = 39
RECORD_COURAGE4F = 40
RECORD_SQUARE1F = 41
RECORD_SQUARE2F = 42
RECORD_SQUARE3F = 43
RECORD_SQUARE4F = 44
RECORD_POB1F = 45
RECORD_POB2F = 46
RECORD_POB3F = 47
RECORD_LASTBOSS1F = 48
RECORD_NEWENEMY1F = 49
RECORD_OBLIVION1F = 50
RECORD_OBLIVION2F = 51
RECORD_OBLIVION3F = 52
RECORD_OBLIVION4F = 53
RECORD_KHAMUN1F = 54
RECORD_REMEMBRANCE1F = 55
RECORD_REMEMBRANCE2F = 56
RECORD_REMEMBRANCE3F = 57
RECORD_REMEMBRANCE4F = 58
RECORD_EVIL1F = 59
RECORD_EVIL2F = 60
RECORD_EVIL3F = 61
RECORD_OVERFIEND1F = 62
RECORD_OVERFIEND2F = 63
RECORD_OVERFIEND3F = 64
RECORD_OVERFIEND4F = 65
RECORD_EVIL9991F = 66
RECORD_EVIL9992F = 67
RECORD_EVIL9993F = 68
RECORD_REMEMBRANCE9991F = 69
RECORD_REMEMBRANCE9992F = 70
RECORD_REMEMBRANCE9993F = 71
RECORD_REMEMBRANCE9994F = 72


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
    description="Complete the Prologue Stage and reach Arcanus Cella (Some Achievements need some time to trigger)",
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
        CheckDungeonCleared(RECORD_HIYO3F, dungeon=DUNGEON_HIYO, floor=3)
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
        CheckDungeonCleared(RECORD_COB4F, dungeon=DUNGEON_COB, floor=4)
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
        CheckDungeonCleared(RECORD_DRAGON3F, dungeon=DUNGEON_DRAGON, floor=3)
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
        CheckDungeonCleared(RECORD_BURN3F, dungeon=DUNGEON_BURN, floor=3)
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
        CheckDungeonCleared(RECORD_ZERO3F, dungeon=DUNGEON_ZERO, floor=3)
)

achievement(
    id=194810,
    title="Shrine of Hidden Gold", 
    description="Complete Golden Shrine for the first time",
    type="progression",
    points=5,
    trigger=
        SaveProtection() &&
        CheckDungeonCleared(RECORD_SHRINE4F, dungeon=DUNGEON_SHRINE, floor=4)
)

achievement(
    id=194811,
    title="Dangerous Research Zone", 
    description="Complete Mystery Lab for the first time",
    type="progression",
    points=5,
    trigger=
        SaveProtection() &&
        CheckDungeonCleared(RECORD_LAB3F, dungeon=DUNGEON_LAB, floor=3)
)

achievement(
    id=194812,
    title="Monster Zone", 
    description="Complete Monster House for the first time",
    type="progression",
    points=5, 
    trigger=
        SaveProtection() &&
        CheckDungeonCleared(RECORD_HOUSE4F, dungeon=DUNGEON_HOUSE, floor=4)
)

achievement(
    id=194813, 
    title="Results of Warming", 
    description="Complete Scorching Desert for the first time",
    type="progression",
    points=5,
    trigger=
        SaveProtection() &&
        CheckDungeonCleared(RECORD_DESERT2F, dungeon=DUNGEON_DESERT, floor=2)
)

achievement(
    id=194814,
    title="Visited by \"Hero Tororo\" in the Past", 
    description="Complete Nostalgic Castle for the first time",
    type="progression",
    points=5,
    trigger=
        SaveProtection() &&
        CheckDungeonCleared(RECORD_CASTLE4F, dungeon=DUNGEON_CASTLE, floor=4)
)

achievement(
    id=194815,
    title="Cavern Fought Over by Monsters", 
    description="Complete Enemy Cave for the first time",
    type="progression",
    points=5, 
    trigger=
        SaveProtection() &&
        CheckDungeonCleared(RECORD_CAVE4F, dungeon=DUNGEON_CAVE, floor=4)
)

achievement(
    id=194816,
    title="Do You Believe in Yourself?", 
    description="Complete Courage Wanted for the first time",
    points=5,
    type="progression",
    trigger=
        SaveProtection() &&
        CheckDungeonCleared(RECORD_COURAGE4F, dungeon=DUNGEON_COURAGE, floor=4)
)

achievement(
    id=194817, 
    title="Place of Mysterious Power", 
    description="Complete Energy Square for the first time",
    type="progression",
    points=5, 
    trigger=
        SaveProtection() &&
        CheckDungeonCleared(RECORD_SQUARE4F, dungeon=DUNGEON_SQUARE, floor=4)
)

achievement(
    title = "Chances of Contamination Is One in a Million, See He Has No Luck", points = 2, type="progression",
    description = "You now have Zombie Coco in your team!",
    id = 194818, badge = "216562", published = "1/26/2022 5:47:17 PM", modified = "1/26/2022 6:57:20 PM",
    trigger = (byte(0x1BF53F0) == 0 && byte(0x1BF53F4) == 0) &&
              (dword((g_text) + 0x00) == 1634230600 && dword((g_text) + 0x04) == 539058536 && dword((g_text) + 0x08) == 1952540756 &&
                  dword((g_text) + 0x0C) == 1629516583 && dword((g_text) + 0x10) == 1701996320 && dword((g_text) + 0x14) == 1931506785 &&
                  dword((g_text) + 0x18) == 560426607
              )
)

achievement(
    id=194819,
    title="The Beginning and the End", 
    description="Complete Place of Beginnings for the first time",
    type="progression",
    points=10, 
    trigger=
        SaveProtection() &&
        CheckDungeonCleared(RECORD_POB3F, dungeon=DUNGEON_POB, floor=3)
)

achievement(
    id=194820,
    title="The Magician", 
    description="Despina has joined your party",
    points=5, 
    type="progression",
    trigger=
        SaveProtection() &&
        prev(g_game_state["m_characters"][CHARACTER_DESPINA]["m_unlocked"]) == 0 &&
        g_game_state["m_characters"][CHARACTER_DESPINA]["m_unlocked"] == 1
)

achievement(
    title = "Out of Control Power", points = 10, type="win_condition",
    description = "Beat the Last Boss for the first time",
    id = 194821, badge = "216565", published = "1/26/2022 5:47:18 PM", modified = "1/26/2022 6:48:58 PM",
    trigger = (byte(0x1BF53F0) == 0 && byte(0x1BF53F4) == 0) &&
              (dword((g_text) + 0x00) == 544567129 && dword((g_text) + 0x04) == 544104818 && dword((g_text) + 0x08) == 543452769 &&
                  dword((g_text) + 0x0C) == 1702257000 && dword((g_text) + 0x10) == 1919903264 && dword((g_text) + 0x14) == 1701536115 &&
                  dword((g_text) + 0x18) == 1701650542
              )
)

achievement(
    id=194822,
    title="The True Identity Revealed!", 
    description="Complete New Enemy for the first time",
    points=10,
    trigger=
        SaveProtection() &&
        CheckDungeonCleared(RECORD_NEWENEMY1F, dungeon=DUNGEON_NEWENEMY, floor=1)
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
        CheckDungeonCleared(RECORD_OBLIVION4F, dungeon=DUNGEON_OBLIVION, floor=4)
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

achievement(
    title = "Th-The Mask", points = 10,
    description = "Complete the Last Boss with Souma and without taking damage, without having a cutscene [No Sub/Support Character]",
    id = 194845, badge = "216586", published = "1/26/2022 5:47:26 PM", modified = "3/5/2023 11:59:24 PM",
    trigger = (byte(0x1BF53F0) == 20 && byte(0x1BF53F4) == 1) && unless(byte(0x1BF5CA8) == 3) &&
              trigger_when(word(0x1BF6508) > prev(word(0x1BF6508))) &&
              disable_when(byte(0x1BF53F0) == 20 && word(0x1BF9C24) < prev(word(0x1BF9C24))) &&
              disable_when(dword(0x1BF9CE0) != 4294967295) && disable_when(dword(0x1BF9CE4) != 4294967295) &&
              (always_false() || (never(byte(0x1BF53F0) != 20)))
)

achievement(
    id=194846,
    title="Damageless Run I", 
    description="As Souma and without any Sub Characters, complete Hiyo's Cave 1F without taking damage",
    points=10,
    trigger=
        // Enter stage (as Souma and with no subs)
        once(
            pg_game_state != NULL &&
            // Entered the map
            prev(g_game_state["m_map_id"]) != MAP_HIYO1F &&
            g_game_state["m_map_id"] == MAP_HIYO1F &&
            // Is Souma
            g_game_state["m_character_id"] == CHARACTER_SOUMA &&
            // No subs
            all_of(g_game_state["m_characters"][CHARACTER_SOUMA]["m_magic_circle_characters"], v => v == 0xFF)
        ) &&
        // Reset if we leave
        never(g_game_state["m_map_id"] != MAP_HIYO1F) &&
        // Reset if we take damage
        never(
            g_game_state["m_characters"][CHARACTER_SOUMA]["m_hp"] < prev(g_game_state["m_characters"][CHARACTER_SOUMA]["m_hp"])
        ) &&
        // Complete stage
        trigger_when(
            CheckDungeonCleared(RECORD_HIYO1F, dungeon=DUNGEON_HIYO, floor=1, first=false)
        )
)

achievement(
    id=194847,
    title="Damageless Run II",
    description="As Souma and without any Sub Characters, complete Cave of Beginnings 1F without taking damage",
    points=10,
    trigger=
        // Enter stage (as Souma and with no subs)
        once(
            pg_game_state != NULL &&
            // Entered the map
            prev(g_game_state["m_map_id"]) != MAP_COB1F &&
            g_game_state["m_map_id"] == MAP_COB1F &&
            // Is Souma
            g_game_state["m_character_id"] == CHARACTER_SOUMA &&
            // No subs
            all_of(g_game_state["m_characters"][CHARACTER_SOUMA]["m_magic_circle_characters"], v => v == 0xFF)
        ) &&
        // Reset if we leave
        never(g_game_state["m_map_id"] != MAP_COB1F) &&
        // Reset if we take damage
        never(
            g_game_state["m_characters"][CHARACTER_SOUMA]["m_hp"] < prev(g_game_state["m_characters"][CHARACTER_SOUMA]["m_hp"])
        ) &&
        // Complete stage
        trigger_when(
            CheckDungeonCleared(RECORD_COB1F, dungeon=DUNGEON_COB, floor=1, first=false)
        )
)

achievement(
    title = "No way, 100 Years Passed Since I Left?!", points = 2,
    description = "Get the Pudding Ending",
    id = 194825, badge = "216569", published = "1/26/2022 5:47:19 PM", modified = "1/26/2022 6:49:00 PM",
    trigger = (byte(0x1BF53F0) == 0 && byte(0x1BF53F4) == 0) &&
              (dword((g_text) + 0x00) == 661939532 && dword((g_text) + 0x04) == 1702043763 && dword((g_text) + 0x08) == 1411395173 &&
                  dword((g_text) + 0x0C) == 544434536 && dword((g_text) + 0x10) == 1931506537 && dword((g_text) + 0x14) == 1869639797 &&
                  dword((g_text) + 0x18) == 543450483 && dword((g_text) + 0x1C) == 1646292852 && dword((g_text) + 0x20) == 1752440933 &&
                  dword((g_text) + 0x24) == 1635197029 && dword((g_text) + 0x28) == 1869095033 && dword((g_text) + 0x2C) == 3040621
              )
)

achievement(
    title = "I’m So Unlucky to Be Sealed by Mistake", points = 3,
    description = "Get the Coco Ending",
    id = 194826, badge = "216570", published = "1/26/2022 5:47:19 PM", modified = "1/26/2022 6:49:00 PM",
    trigger = (byte(0x1BF53F0) == 0 && byte(0x1BF53F4) == 0) &&
              (dword((g_text) + 0x00) == 539781199 && dword((g_text) + 0x04) == 1936287860 && dword((g_text) + 0x08) == 1853057312 &&
                  dword((g_text) + 0x0C) == 1948283943 && dword((g_text) + 0x10) == 1948280168 && dword((g_text) + 0x14) == 1701603695 &&
                  dword((g_text) + 0x18) == 16244
              )
)

achievement(
    title = "Why Did I Even Create This World?", points = 10,
    description = "Get the Despina Ending",
    id = 194827, badge = "216571", published = "1/26/2022 5:47:20 PM", modified = "1/26/2022 6:49:00 PM",
    trigger = (byte(0x1BF53F0) == 0 && byte(0x1BF53F4) == 0) &&
              (dword((g_text) + 0x00) == 544827479 && dword((g_text) + 0x04) == 543451492 && dword((g_text) + 0x08) == 1986338889 &&
                  dword((g_text) + 0x0C) == 1663069797 && dword((g_text) + 0x10) == 1952540018 && dword((g_text) + 0x14) == 1752440933 &&
                  dword((g_text) + 0x18) == 1998615401 && dword((g_text) + 0x1C) == 1684828783
              )
)

achievement(
    title = "Bye, Puddie, Take Care of Yourself, Okay...?", points = 2,
    description = "Get the Souma Ending",
    id = 194828, badge = "216572", published = "1/26/2022 5:47:20 PM", modified = "1/26/2022 6:49:01 PM",
    trigger = (byte(0x1BF53F0) == 0 && byte(0x1BF53F4) == 0) &&
              (dword((g_text) + 0x00) == 1952540759 && dword((g_text) + 0x04) == 1701994784 && dword((g_text) + 0x08) == 1970239776 &&
                  dword((g_text) + 0x0C) == 1768907808 && dword((g_text) + 0x10) == 539780974 && dword((g_text) + 0x14) == 1836412755 &&
                  dword((g_text) + 0x18) == 16225
              )
)

achievement(
    title = "Somebody Please Give Me an Order", points = 5,
    description = "Get the Sherbet Ending",
    id = 194829, badge = "216573", published = "1/26/2022 5:47:20 PM", modified = "1/26/2022 6:49:01 PM",
    trigger = (byte(0x1BF53F0) == 0 && byte(0x1BF53F4) == 0) &&
              (dword((g_text) + 0x00) == 779314521 && dword((g_text) + 0x04) == 1831291168 && dword((g_text) + 0x08) == 1919252000 &&
                  dword((g_text) + 0x0C) == 1869815929 && dword((g_text) + 0x10) == 779711090
              )
)

achievement(
    title = "Completely Useless against People Who Don't Attack", points = 5,
    description = "Get the Battleblo Ending",
    id = 194830, badge = "216574", published = "1/26/2022 5:47:21 PM", modified = "1/26/2022 6:49:01 PM",
    trigger = (byte(0x1BF53F0) == 0 && byte(0x1BF53F4) == 0) &&
              (dword((g_text) + 0x00) == 1952540756 && dword((g_text) + 0x04) == 1768452896 && dword((g_text) + 0x08) == 560229477 &&
                  dword((g_text) + 0x80) == 543519297 && dword((g_text) + 0x84) == 544567161 && dword((g_text) + 0x88) == 1869835361 &&
                  dword((g_text) + 0x8C) == 1701736224 && dword((g_text) + 0x90) == 1869117216
              )
)

achievement(
    title = "It Pains Me to be Called \"Barkeep\" Now", points = 5,
    description = "Get the Dotache Ending",
    id = 194831, badge = "216575", published = "1/26/2022 5:47:21 PM", modified = "1/26/2022 6:49:02 PM",
    trigger = (byte(0x1BF53F0) == 0 && byte(0x1BF53F4) == 0) &&
              (dword((g_text) + 0x00) == 746153288 && dword((g_text) + 0x04) == 1701345056 && dword((g_text) + 0x08) == 1763730802 &&
                  dword((g_text) + 0x0C) == 1866735731 && dword((g_text) + 0x10) == 1751343476 && dword((g_text) + 0x14) == 1869029477 &&
                  dword((g_text) + 0x18) == 1063743081
              )
)

achievement(
    title = "The Hair I Wanted All This Time Can't Be Found Here", points = 5,
    description = "Get the Bob Ending",
    id = 194832, badge = "216576", published = "1/26/2022 5:47:21 PM", modified = "1/26/2022 6:49:02 PM",
    trigger = (byte(0x1BF53F0) == 0 && byte(0x1BF53F4) == 0) &&
              (dword((g_text) + 0x00) == 543516756 && dword((g_text) + 0x04) == 1919508840 && dword((g_text) + 0x08) == 1998604576 &&
                  dword((g_text) + 0x0C) == 1702129249 && dword((g_text) + 0x10) == 1818304612 && dword((g_text) + 0x14) == 1752440940 &&
                  dword((g_text) + 0x18) == 1948283753 && dword((g_text) + 0x1C) == 6647145
              )
)

achievement(
    title = "It's So Dark... I'm So Scared...", points = 5,
    description = "Get the Sunday Ending",
    id = 194833, badge = "216577", published = "1/26/2022 5:47:22 PM", modified = "1/26/2022 6:49:02 PM",
    trigger = (byte(0x1BF53F0) == 0 && byte(0x1BF53F4) == 0) &&
              once(dword((g_text) + 0x00) == 1746956103 && dword((g_text) + 0x04) == 543519333 && dword((g_text) + 0x08) == 1914728308 &&
                  dword((g_text) + 0x0C) == 1920300133
              ) &&
              (dword((g_text) + 0x00) == 1931965513 && dword((g_text) + 0x04) == 544174880 && dword((g_text) + 0x08) == 1802658148 &&
                  dword((g_text) + 0x0C) == 46
              )
)

achievement(
    title = "I Really Don't Belong Here", points = 10,
    description = "Get the Asagi Ending",
    id = 194834, badge = "216578", published = "1/26/2022 5:47:22 PM", modified = "1/26/2022 6:49:03 PM",
    trigger = (byte(0x1BF53F0) == 0 && byte(0x1BF53F4) == 0) &&
              (dword((g_text) + 0x00) == 1701978185 && dword((g_text) + 0x04) == 2037148769 && dword((g_text) + 0x08) == 1852793888 &&
                  dword((g_text) + 0x0C) == 29735 && dword((g_text) + 0x80) == 1869374818 && dword((g_text) + 0x84) == 1746954094 &&
                  dword((g_text) + 0x88) == 778400357
              )
)

// Rich Presence

function InPrologue()
{
    return any_of([MAP_PROLOGUE_CUTSCENE, MAP_PROLOGUE_DUNGEON], m => m == g_game_state["m_map_id"])
}

function InRangeon()
{
    return m_rangeon_state["m_in_rangeon"] == 1
}

function MeasuredNoneSubChars()
{
    return 
        once(
            all_of(g_game_state["m_current_character"]["m_magic_circle_characters"], v == 0xFF) &&
            never(any_of(g_game_state["m_current_character"]["m_magic_circle_characters"], v != 0xFF))
        )
}
