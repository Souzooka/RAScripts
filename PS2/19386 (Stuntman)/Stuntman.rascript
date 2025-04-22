// Stuntman
// #ID = 19386

NULL = 0

function in_game()
{
    // Tentative
    return g_player_car != NULL
}

function get_stunt_id()
{
    addr = 0x269b70 + (g_map_id * 0x54)
    return to_stunt_id(g_map_id, dword(addr))
}

function to_stunt_id(map_id, stunt_id)
{
    return map_id * 0x100 + stunt_id
}

g_map_id = dword(0x315118)
g_player_car = dword(0x267464)

SID = to_stunt_id

rp_arena_maps = [1, 5, 9, 0xC, 0xF]
rp_stunt_lookup = {
    SID(0,0): "Hiccup With the Piccup",
    SID(0,1): "Safe Stealing",
    SID(0,2): "Rozzer Bozzer",
    SID(0,3): "Fink in the Dink",
    SID(0,4): "Filled In",
    SID(1,0): "Cannon Jump",
    SID(2,0): "Outta Town Nitro",
    SID(3,0): "The Corkscrew",
    SID(4,0): "Tame The Train",
    SID(5,0): "Car Dominoes",
    SID(6,0): "Office Obliteration",
    SID(7,0): "Downtown Dash",
    SID(7,1): "Tuk Tuk Chase",
    SID(8,0): "Rooftop Rumble",
    SID(9,0): "Hell Drivers",
    SID(10,0): "Suspects on Snowmobiles",
    SID(10,1): "Hunted by Microlites",
    SID(11,0): "River Race",
    SID(12,0): "Monster Trucks",
    SID(13,0): "Wake the Garrison",
    SID(14,0): "Panzer Attack",
    SID(14,1): "Temple Trap",
    SID(14,2): "Sink the U-Boat",
    SID(15,0): "World Record Attempt",
    SID(16,0): "Mountain Chase",
    SID(16,1): "Head On",
    SID(17,0): "Police Chase",
    SID(18,0): "Moving Target",
    SID(19,0): "Stop the Stealth Jet",
    SID(20,0): "Precision Test 1",
    SID(20,1): "Precision Test 2",
    SID(20,2): "Precision Test 3",
    SID(20,3): "Precision Test 4",
    SID(20,4): "Precision Test 5",
    SID(21,0): "the Speed Test in London",
    SID(22,0): "the Speed Test in Louisiana",
    SID(23,0): "the Speed Test in Bangkok",
    SID(24,0): "the Speed Test in Switzerland",
    SID(25,0): "the Speed Test in Egypt",
    SID(26,0): "the Speed Test in Monaco",
    SID(27,0): "the Speed Test in Arena",
    SID(28,0): "Stunt Test 1",
    SID(28,1): "Stunt Test 2",
    SID(28,2): "Stunt Test 3",
}

rp_stunt = rich_presence_lookup("STUNT", get_stunt_id(), rp_stunt_lookup, "UNKNOWN STUNT")

rich_presence_conditional_display(
    in_game() && any_of(rp_arena_maps, map => map == g_map_id),
    "Saul Stuntman is performing the death-dying stunt \"{0}\" at the stunt arena!",
    rp_stunt
)
rich_presence_conditional_display(
    in_game() && g_map_id == 29,
    "Saul Stuntman is in the Stunt Constructor"
)
rich_presence_conditional_display(
    in_game() && g_map_id >= 20,
    "Saul Stuntman is undertaking {0}!",
    rp_stunt
)
rich_presence_conditional_display(
    in_game(),
    "Saul Stuntman is filming the stunt \"{0}\"",
    rp_stunt
)
rich_presence_display("Saul Stuntman is in their trailer")