// We Love Katamari
// #ID = 2672

g_game_profile_base_addr = 0x663778
g_level_id = byte(0x663684)
g_in_level = byte(0x663680)
LEVEL_TITLE_MENU = 31

True = 1
False = 0

function is_in_title_menu()
{
    // Arbitrary code address to check that a particular overlay is loaded
    // addiu a1,v0,0x3778
    return dword(0xCDDC34) == 0x24453778
}

function get_save_collection_start()
{
    g_save_profiles_base_addr = 0xD20D88
    g_save_index = byte(0xD00D73)
    addr = (g_save_index * 0x2EA0) + g_save_profiles_base_addr
    return addr
}

LIVE_COLLECTION = {
    "STRANGE": [
        0x663dd3, // strange: registered trademark
        0x663dd8, // strange: na
        0x663dd9, // Strange: m
        0x663dda, // strange: co
        0x663fab, // strange: small ball
        0x663fac, // strange: cone
        0x663fad, // strange: projection
        0x663fae, // strange: long 'n thin
        0x663faf, // strange: big ball
        0x663fb0, // strange: big cone
        0x663fb1, // strange: big projection
        0x663fb2, // strange: big 'n long
        0x664325, // strange: cube
        0x664326, // strange: crystal
        0x664327, // strange: pyramid
        0x664328, // strange: ninja spike
        0x664329, // strange: ball
        0x66432A, // strange: ring
        0x66438a, // strange: big sphere
        0x66438b, // strange: big square
        0x66438c, // strange: big triangle
        0x66438d, // strange: big ball
        0x66438e, // strange: big ring
        0x6644ad, // strange: snowman (mini-circle)
        0x6644ae, // strange: snowman (mini-triangle)
        0x6644af, // strange: snowman (mini-projection)
        0x6644b0, // strange: short 'n green
    ]
}

// Relative offsets to start of save data
SAVE_COLLECTION = {
    "STRANGE": array_map(LIVE_COLLECTION["STRANGE"], v => v - g_game_profile_base_addr),
}

function do_collection(collection_name)
{
    collection = array_map(LIVE_COLLECTION[collection_name], bit0)

    // Save protection
    // Not in title menu and in level
    return g_level_id != LEVEL_TITLE_MENU && g_in_level == True &&
    // measured add source check
    measured(sum_of(collection, v => v) == length(collection), format="percent") &&
    sum_of(collection, prev) < length(collection)
}

function do_collection_strange_safety()
{
    // Safety check for rolling up "n", "am", "co", and/or the trademark symbol on the title menu to complete collection
    strange_save_collection = SAVE_COLLECTION["STRANGE"]
    save_data_start = get_save_collection_start()
    
    collection_saved = array_map(strange_save_collection, v => bit0(save_data_start + v))
    collection_live = array_map(LIVE_COLLECTION["STRANGE"], bit0)
    assert(length(collection_saved) == length(collection_live))
    
    // We *ARE* in the title menu
    return is_in_title_menu() &&
    // Check that the save data collection did not have all of the items
    sum_of(collection_saved, prev) < length(collection_saved) &&
    // Check that the live data collection had nothing (save data not yet written to game data)
    sum_of(collection_live, prev) == 0 &&
    // Now the live data collection has all items (since the save data didn't have every item, we must have picked up the last item(s) from the title menu)
    sum_of(collection_live, v => v) == length(collection_saved)
}

achievement(
    id = 225847,
    title = "We Love The Weird",
    description = "Collect all objects in the Strange category",
    points = 10,
    trigger = do_collection("STRANGE") || do_collection_strange_safety()
)
