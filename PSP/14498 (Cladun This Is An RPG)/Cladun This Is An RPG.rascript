// Cladun: This Is An RPG
// #ID = 14498

NULL = 0

function DungeonState(addr)
{
    obj = {
        
    }
    return obj
}

function GameState(addr)
{
    obj = {
        "m_fame10_reward": bit4(addr + 0x1F),
        "m_tavern_unlocked": bit3(addr + 0x25),
        "m_map_id": dword(addr + 0x85C),
        "m_character_id": dword(addr + 0x868),
        "m_dungeon_record_count": dword(addr + 0x880),
        "m_dungeon_record": [],
        "m_characters": [],
    }
    
    for i in range(0, 99) // TODO array length
    {
        array_push(obj["m_dungeon_record"], DungeonRecordInfo(addr + 0x884 + (SIZEOF_DungeonRecordInfo * i)))
    }
    
    for i in range(0, CHARACTER_CUSTOM2)
    {
        array_push(obj["m_characters"], CharacterState(addr + 0x2AE4 + (SIZEOF_CharacterState * i)))
    }
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
    // Dungeons are inserted into game state in an arbitrary order
    // However, since dungeons can only be completed in a specific order,
    // (up until the end of the game), for those within that order, we should be able
    // to avoid checking multiple entries. We want to avoid checking every entry, for every dungeon,
    // even though it's what the game does, because RA has no early exit from loops and it's considered bad form
    MAX_SAFE_DUNGEON = 99 // TODO; minimum ID to check multiple for
    MAX_DUNGEON_COUNT = 99 // TODO; max range to check multiple for

    check_multiple = dungeon > MAX_SAFE_DUNGEON
    
    if check_multiple
    {
        assert(false, "NOT IMPLEMENTED")
    }

    info = g_game_state["m_dungeon_record"][record_idx]
    cond = always_true()
    if dungeon != -1
        // Sanity check (this record is where we expect it to be in memory)
        // If this fails we may need to check ~100 records for every dungeon to be thorough
        cond = cond && info["m_dungeon_id"] == dungeon
    if floor != -1
        // Sanity check (this record is where we expect it to be in memory)
        // If this fails we may need to check ~100 records for every dungeon to be thorough
        cond = cond && info["m_floor"] == floor
    extra = always_true()
    if first
        extra = prev(info["m_clear_count"]) == 0 && info["m_clear_count"] == 1
    else
        extra = prev(info["m_clear_count"]) < info["m_clear_count"]
    return cond && extra
}

CHARACTER_PUDDING = 0
CHARACTER_COCO = 1
CHARACTER_DESPINA = 2
CHARACTER_SOUMA = 3
CHARACTER_SHERBERT = 4
CHARACTER_BATTLEBLO = 5
CHARACTER_DOTACHE = 6
CHARACTER_BOB = 7
CHARACTER_SUNDAY = 8
CHARACTER_ASAGI = 9
CHARACTER_CUSTOM1 = 11
CHARACTER_CUSTOM2 = 12

MAP_TITLE = 0
MAP_HIYO1F = 10001
MAP_COB1F = 10101
MAP_HUB = 50001
MAP_PROLOGUE_DUNGEON = 60001

DUNGEON_ARCANUS = 0
DUNGEON_HIYO = 1
DUNGEON_COB = 2

// These aren't set in stone, but educated guesses for indices these records appear at
// (See note in CheckDungeonCleared)
RECORD_HIYO1F = 0
RECORD_HIYO2F = 1
RECORD_HIYO3F = 2
RECORD_COB1F = 4
RECORD_COB2F = 5
RECORD_COB3F = 6
RECORD_COB4F = 7

pg_game_state = dword(0x9950b8) // Can't mask here because (X & 0x7FFFFFF) == 0 seems to be considered always false
g_game_state = GameState(pg_game_state & 0x7FFFFFF)
g_dungeon_state = DungeonState(dword(0x9950bc) & 0x7FFFFFF)
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
        CheckDungeonCleared(RECORD_COB3F, dungeon=DUNGEON_COB, floor=4)
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
    title = "Draco Florest", points = 5, type="progression",
    description = "Complete Dragon Florest for the first time",
    id = 194805, badge = "216549", published = "1/26/2022 5:47:12 PM", modified = "1/26/2022 6:48:53 PM",
    trigger = (byte(0x1BF53F0) == 3 && byte(0x1BF53F4) == 3) &&
              (prev(word(0x1BF5E54)) == 0 && word(0x1BF5E54) == 1)
)

achievement(
    title = "A Stalker?", points = 5, type="progression",
    description = "Sherbet has joined your party",
    id = 194806, badge = "216550", published = "1/26/2022 5:47:13 PM", modified = "1/26/2022 6:48:53 PM",
    trigger = (byte(0x1BF53F0) == 0 && byte(0x1BF53F4) == 0) &&
              (dword((g_text) + 0x00) == 544567129 && dword((g_text) + 0x04) == 544698222 && dword((g_text) + 0x08) == 1702257000 &&
                  dword((g_text) + 0x0C) == 1667457312 && dword((g_text) + 0x10) == 544437093 && dword((g_text) + 0x14) == 1394634612 &&
                  dword((g_text) + 0x18) == 1651664232 && dword((g_text) + 0x1C) == 3044453
              )
)

achievement(
    title = "\"Ta Pegando Fogo Bicho\"", points = 5, type="progression",
    description = "Complete Burning Cave for the first time",
    id = 194807, badge = "216551", published = "1/26/2022 5:47:13 PM", modified = "1/26/2022 6:48:54 PM",
    trigger = (byte(0x1BF53F0) == 4 && byte(0x1BF53F4) == 3) &&
              (prev(word(0x1BF5ED8)) == 0 && word(0x1BF5ED8) == 1)
)

achievement(
    title = "The Barkeeper and Princess", points = 5, type="progression",
    description = "Dotache has joined your party",
    id = 194808, badge = "216552", published = "1/26/2022 5:47:13 PM", modified = "1/26/2022 6:48:54 PM",
    trigger = (byte(0x1BF53F0) == 0 && byte(0x1BF53F4) == 0) &&
              (dword((g_text) + 0x00) == 544567129 && dword((g_text) + 0x04) == 544698222 && dword((g_text) + 0x08) == 1702257000 &&
                  dword((g_text) + 0x0C) == 1667457312 && dword((g_text) + 0x10) == 544437093 && dword((g_text) + 0x14) == 1142976372 &&
                  dword((g_text) + 0x18) == 1667331183 && dword((g_text) + 0x1C) == 3040616
              )
)

achievement(
    title = "Sub-Zero Cave", points = 5, type="progression",
    description = "Complete Absolute Zero for the first time",
    id = 194809, badge = "216553", published = "1/26/2022 5:47:14 PM", modified = "1/26/2022 6:48:54 PM",
    trigger = (byte(0x1BF53F0) == 5 && byte(0x1BF53F4) == 3) &&
              (prev(word(0x1BF5F5C)) == 0 && word(0x1BF5F5C) == 1)
)

achievement(
    title = "Shrine of Hidden Gold", points = 5, type="progression",
    description = "Complete Golden Shrine for the first time",
    id = 194810, badge = "216554", published = "1/26/2022 5:47:14 PM", modified = "1/26/2022 6:48:55 PM",
    trigger = (byte(0x1BF53F0) == 6 && byte(0x1BF53F4) == 4) &&
              (prev(word(0x1BF600C)) == 0 && word(0x1BF600C) == 1)
)

achievement(
    title = "Dangerous Research Zone", points = 5, type="progression",
    description = "Complete Mystery Lab for the first time",
    id = 194811, badge = "216555", published = "1/26/2022 5:47:14 PM", modified = "1/26/2022 6:48:55 PM",
    trigger = (byte(0x1BF53F0) == 7 && byte(0x1BF53F4) == 3) &&
              (prev(word(0x1BF6090)) == 0 && word(0x1BF6090) == 1)
)

achievement(
    title = "Monster Zone", points = 5, type="progression",
    description = "Complete Monster House for the first time",
    id = 194812, badge = "216556", published = "1/26/2022 5:47:15 PM", modified = "1/26/2022 6:48:55 PM",
    trigger = (byte(0x1BF53F0) == 8 && byte(0x1BF53F4) == 4) &&
              (prev(word(0x1BF6140)) == 0 && word(0x1BF6140) == 1)
)

achievement(
    title = "Results of Warming", points = 5, type="progression",
    description = "Complete Scorching Desert for the first time",
    id = 194813, badge = "216557", published = "1/26/2022 5:47:15 PM", modified = "1/26/2022 6:48:56 PM",
    trigger = (byte(0x1BF53F0) == 9 && byte(0x1BF53F4) == 2) &&
              (prev(word(0x1BF6198)) == 0 && word(0x1BF6198) == 1)
)

achievement(
    title = "Visited by \"Hero Tororo\" in the Past", points = 5, type="progression",
    description = "Complete Nostalgic Castle for the first time",
    id = 194814, badge = "216558", published = "1/26/2022 5:47:15 PM", modified = "1/26/2022 6:48:56 PM",
    trigger = (byte(0x1BF53F0) == 10 && byte(0x1BF53F4) == 4) &&
              (prev(word(0x1BF6248)) == 0 && word(0x1BF6248) == 1)
)

achievement(
    title = "Cavern Fought Over by Monsters", points = 5, type="progression",
    description = "Complete Enemy Cave for the first time",
    id = 194815, badge = "216559", published = "1/26/2022 5:47:16 PM", modified = "1/26/2022 6:48:56 PM",
    trigger = (byte(0x1BF53F0) == 11 && byte(0x1BF53F4) == 4) &&
              (prev(word(0x1BF62F8)) == 0 && word(0x1BF62F8) == 1)
)

achievement(
    title = "Do You Believe in Yourself?", points = 5, type="progression",
    description = "Complete Courage Wanted for the first time",
    id = 194816, badge = "216560", published = "1/26/2022 5:47:16 PM", modified = "1/26/2022 6:48:57 PM",
    trigger = (byte(0x1BF53F0) == 12 && byte(0x1BF53F4) == 4) &&
              (prev(word(0x1BF63A8)) == 0 && word(0x1BF63A8) == 1)
)

achievement(
    title = "Place of Mysterious Power", points = 5, type="progression",
    description = "Complete Energy Square for the first time",
    id = 194817, badge = "216561", published = "1/26/2022 5:47:16 PM", modified = "1/26/2022 6:48:57 PM",
    trigger = (byte(0x1BF53F0) == 13 && byte(0x1BF53F4) == 4) &&
              (prev(word(0x1BF6458)) == 0 && word(0x1BF6458) == 1)
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
    title = "The Beginning and the End", points = 10, type="progression",
    description = "Complete Place of Beginnings for the first time",
    id = 194819, badge = "216563", published = "1/26/2022 5:47:17 PM", modified = "1/26/2022 6:48:58 PM",
    trigger = (byte(0x1BF53F0) == 14 && byte(0x1BF53F4) == 3) &&
              (prev(word(0x1BF64DC)) == 0 && word(0x1BF64DC) == 1)
)

achievement(
    title = "The Magician", points = 5, type="progression",
    description = "Despina has joined your party",
    id = 194820, badge = "216564", published = "1/26/2022 5:47:17 PM", modified = "1/26/2022 6:48:58 PM",
    trigger = (byte(0x1BF53F0) == 0 && byte(0x1BF53F4) == 0) &&
              (dword((g_text) + 0x00) == 544567129 && dword((g_text) + 0x04) == 544698222 && dword((g_text) + 0x08) == 1702257000 &&
                  dword((g_text) + 0x0C) == 1667457312 && dword((g_text) + 0x10) == 544437093 && dword((g_text) + 0x14) == 1142976372 &&
                  dword((g_text) + 0x18) == 1768977253 && dword((g_text) + 0x1C) == 3039598
              )
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
    title = "The True Identity Revealed!", points = 10,
    description = "Complete New Enemy for the first time",
    id = 194822, badge = "216566", published = "1/26/2022 5:47:18 PM", modified = "1/26/2022 6:48:59 PM",
    trigger = once(byte(0x1BF53F0) == 19 && byte(0x1BF53F8) == 1) &&
              (((once(byte(0x1BF53F0) == 19 && byte(0x1BF53F4) == 1 && prev(word(0x1BF6534)) == 0) && word(0x1BF6534) == 1)) ||
               ((once(byte(0x1BF53F0) == 19 && byte(0x1BF53F4) == 1 && prev(word(0x1BF6560)) == 0) && word(0x1BF6560) == 1)) ||
               ((once(byte(0x1BF53F0) == 19 && byte(0x1BF53F4) == 1 && prev(word(0x1BF658C)) == 0) && word(0x1BF658C) == 1)) ||
               ((once(byte(0x1BF53F0) == 19 && byte(0x1BF53F4) == 1 && prev(word(0x1BF65E4)) == 0) && word(0x1BF65E4) == 1)) ||
               ((once(byte(0x1BF53F0) == 19 && byte(0x1BF53F4) == 1 && prev(word(0x1BF65B8)) == 0) && word(0x1BF65B8) == 1)))
)

achievement(
    title = "The \"Main\" Character", points = 10,
    description = "Asagi has joined your party",
    id = 194824, badge = "216568", published = "1/26/2022 5:47:19 PM", modified = "1/26/2022 6:48:59 PM",
    trigger = (byte(0x1BF53F0) == 0 && byte(0x1BF53F4) == 0) &&
              (dword((g_text) + 0x00) == 544567129 && dword((g_text) + 0x04) == 544698222 && dword((g_text) + 0x08) == 1702257000 &&
                  dword((g_text) + 0x10) == 544437093 && dword((g_text) + 0x14) == 1092644724 && dword((g_text) + 0x18) == 1768382835 &&
                  dword((g_text) + 0x1C) == 46
              )
)

achievement(
    title = "Forgotten Land", points = 25,
    description = "Complete Land of Oblivion for the first time",
    id = 194823, badge = "216567", published = "1/26/2022 5:47:18 PM", modified = "1/26/2022 6:48:59 PM",
    trigger = once(byte(0x1BF53F0) == 21 && byte(0x1BF53F8) == 1) &&
              (((once(byte(0x1BF53F0) == 21 && byte(0x1BF53F4) == 4 && prev(word(0x1BF65B8)) == 0) && word(0x1BF65B8) == 1)) ||
               ((once(byte(0x1BF53F0) == 21 && byte(0x1BF53F4) == 4 && prev(word(0x1BF65E4)) == 0) && word(0x1BF65E4) == 1)))
)

achievement(
    title = "Cladun: This is Also Art", points = 1,
    description = "Create and use your first Custom Character",
    id = 194835, badge = "216579", published = "1/26/2022 5:47:22 PM", modified = "1/26/2022 6:49:03 PM",
    trigger = byte(0x1BF53F0) >= 0 && (prev(byte(0x1BF5CA8)) != 11 && byte(0x1BF5CA8) == 11)
)

achievement(
    title = "Searching Everywhere", points = 1,
    description = "Find the Letter from Hiyoji in Arcanus Cella's",
    id = 194843, badge = "216584", published = "1/26/2022 5:47:25 PM", modified = "1/26/2022 6:49:06 PM",
    trigger = (byte(0x1BF53F0) == 0 && byte(0x1BF53F4) == 0) &&
              (dword((g_text) + 0x00) == 1919248468 && dword((g_text) + 0x04) == 1936269413 && dword((g_text) + 0x08) == 1814061344 &&
                  dword((g_text) + 0x0C) == 1702130789 && dword((g_text) + 0x10) == 1701322866 && dword((g_text) + 0x14) == 3040626
              )
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
        once(
            g_conversation_index == 0xAB &&
            g_dialog_window["m_option"] == 0 &&
            prev(g_dialog_window["m_visibility"]) == 1 &&
            g_dialog_window["m_visibility"] == 0 &&
            // reset if we somehow leave conversation
            never(g_conversation_index == -1)
        ) &&
        // second window appears
        prev(g_dialog_window["m_visibility"]) == 4 &&
        g_dialog_window["m_visibility"] == 5
)

achievement(
    title = "\"Senta que la vem historia\"", points = 2,
    description = "Find and read all the chapters of Adventures of the Yam Hero in Arcanus Cella's",
    id = 194844, badge = "216585", published = "1/26/2022 5:47:26 PM", modified = "1/26/2022 6:49:06 PM",
    trigger = (byte(0x1BF53F0) == 0 && byte(0x1BF53F4) == 0) &&
              once(dword((g_text) + 0x00) == 1646292820 && dword((g_text) + 0x04) == 1868767333 && dword((g_text) + 0x08) == 1852404846 &&
                  dword((g_text) + 0x0C) == 543450485 && dword((g_text) + 0x10) == 1663070068 && dword((g_text) + 0x14) == 1953522024 &&
                  dword((g_text) + 0x18) == 840987237 && dword((g_text) + 0x1C) == 46
              ) &&
              once(dword((g_text) + 0x00) == 1646292820 && dword((g_text) + 0x04) == 1868767333 && dword((g_text) + 0x08) == 1852404846 &&
                  dword((g_text) + 0x0C) == 543450485 && dword((g_text) + 0x10) == 1663070068 && dword((g_text) + 0x14) == 1953522024 &&
                  dword((g_text) + 0x18) == 857764453 && dword((g_text) + 0x1C) == 46
              ) &&
              once(dword((g_text) + 0x00) == 1646292820 && dword((g_text) + 0x04) == 1868767333 && dword((g_text) + 0x08) == 1852404846 &&
                  dword((g_text) + 0x0C) == 543450485 && dword((g_text) + 0x10) == 1663070068 && dword((g_text) + 0x14) == 1953522024 &&
                  dword((g_text) + 0x18) == 874541669 && dword((g_text) + 0x1C) == 46
              ) &&
              once(dword((g_text) + 0x00) == 1646292820 && dword((g_text) + 0x04) == 1868767333 && dword((g_text) + 0x08) == 1852404846 &&
                  dword((g_text) + 0x0C) == 543450485 && dword((g_text) + 0x10) == 1663069801 && dword((g_text) + 0x14) == 1953522024 &&
                  dword((g_text) + 0x18) == 891318885 && dword((g_text) + 0x1C) == 46
              ) &&
              once(dword((g_text) + 0x00) == 1646292820 && dword((g_text) + 0x04) == 1868767333 && dword((g_text) + 0x08) == 1852404846 &&
                  dword((g_text) + 0x0C) == 543450485 && dword((g_text) + 0x10) == 1948282740 && dword((g_text) + 0x14) == 1713399144 &&
                  dword((g_text) + 0x18) == 1818324585 && dword((g_text) + 0x1C) == 1634231072 && dword((g_text) + 0x20) == 1919251568 &&
                  dword((g_text) + 0x24) == 46
              ) && once(dword((g_text) + 0x00) == 543516756 && dword((g_text) + 0x04) == 778333765)
)

achievement(
    id=194836,
    title="Something in the Underground...", 
    description="Talk with Hiyoji about the 10 fame reward",
    points=3,
    trigger=
        SaveProtection() &&
        prev(g_game_state["m_fame10_reward"]) == 0 &&
        g_game_state["m_fame10_reward"] == 1
)

achievement(
    title = "The Legendary Artifact, \"Widen!\"", points = 5,
    description = "Talk with Hiyoji about the 30 fame reward",
    id = 194837, badge = "216580", published = "1/26/2022 5:47:23 PM", modified = "1/26/2022 6:49:04 PM",
    trigger = (byte(0x1BF53F0) == 0 && byte(0x1BF53F4) == 0) && word(0x1BF5C9A) >= 30 &&
              (dword((g_text) + 0x00) == 1920298841 && dword((g_text) + 0x04) == 1835099680 && dword((g_text) + 0x08) == 1936269413 &&
                  dword((g_text) + 0x0C) == 1702260512 && dword((g_text) + 0x10) == 808657010 && dword((g_text) + 0x14) == 33 &&
                  dword((g_text) + 0x80) == 1701995848 && dword((g_text) + 0x84) == 1870209068 && dword((g_text) + 0x88) == 1633886325
              )
)

achievement(
    title = "The Legendary Blunt Weapon, \"Prinny Stick!\"", points = 10,
    description = "Talk with Hiyoji about the 50 fame reward",
    id = 194838, badge = "216580", published = "1/26/2022 5:47:24 PM", modified = "1/26/2022 6:49:04 PM",
    trigger = (byte(0x1BF53F0) == 0 && byte(0x1BF53F4) == 0) && word(0x1BF5C9A) >= 50 &&
              (dword((g_text) + 0x00) == 544567129 && dword((g_text) + 0x04) == 544501607 && dword((g_text) + 0x08) == 1701274988 &&
                  dword((g_text) + 0x0C) == 1918985326 && dword((g_text) + 0x10) == 1818370169 && dword((g_text) + 0x14) == 544501365 &&
                  dword((g_text) + 0x18) == 1885431159 && dword((g_text) + 0x1C) == 539782767 && dword((g_text) + 0x20) == 1769099298 &&
                  dword((g_text) + 0x24) == 544829038 && dword((g_text) + 0x28) == 1667855443 && dword((g_text) + 0x2C) == 2236779
              )
)

achievement(
    title = "Buy Weapons with Ultimate Titles at the Store!", points = 25,
    description = "Talk with Hiyoji about the 200 fame reward",
    id = 194839, badge = "216580", published = "1/26/2022 5:47:24 PM", modified = "1/26/2022 6:49:04 PM",
    trigger = (byte(0x1BF53F0) == 0 && byte(0x1BF53F4) == 0) && word(0x1BF5C9A) >= 200 &&
              (dword((g_text) + 0x80) == 1634541641 && dword((g_text) + 0x84) == 1931502948 && dword((g_text) + 0x88) == 543519349 &&
                  dword((g_text) + 0x8C) == 544567161 && dword((g_text) + 0x90) == 544104803 && dword((g_text) + 0x94) == 544830818 &&
                  dword((g_text) + 0x98) == 1885431159 && dword((g_text) + 0x9C) == 544435823 && dword((g_text) + 0xA0) == 1752459639
              )
)

achievement(
    title = "I'm Moving Up and Down, Side to Side Like a Roller Coaster", points = 25,
    description = "Reach New-geon floor 100 or higher",
    id = 194841, badge = "216582", published = "1/26/2022 5:47:25 PM", modified = "1/30/2022 7:32:38 PM",
    trigger = (once(byte(0x1BF53F8) == 1 && prev(byte(0x1BD5C50)) < 100) && byte(0x1BD5C50) >= 100)
)

achievement(
    title = "Dungeon Master", points = 10,
    description = "Complete the 50th floor and to the next of Ran-geon",
    id = 194842, badge = "216583", published = "1/26/2022 5:47:25 PM", modified = "1/30/2022 7:32:38 PM",
    trigger = (once(byte(0x1BF53F8) == 1 && prev(byte(0x1CCCAAA)) == 50) && byte(0x1CCCAAA) == 51)
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
            all_of(g_game_state["m_characters"][CHARACTER_SOUMA]["m_magic_circle_characters"], v => v == 0xFF) &&
            // Reset if we leave
            never(g_game_state["m_map_id"] != MAP_HIYO1F) &&
            // Reset if we take damage
            never(
                g_game_state["m_characters"][CHARACTER_SOUMA]["m_hp"] < prev(g_game_state["m_characters"][CHARACTER_SOUMA]["m_hp"])
            )
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
            all_of(g_game_state["m_characters"][CHARACTER_SOUMA]["m_magic_circle_characters"], v => v == 0xFF) &&
            // Reset if we leave
            never(g_game_state["m_map_id"] != MAP_COB1F) &&
            // Reset if we take damage
            never(
                g_game_state["m_characters"][CHARACTER_SOUMA]["m_hp"] < prev(g_game_state["m_characters"][CHARACTER_SOUMA]["m_hp"])
            )
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
