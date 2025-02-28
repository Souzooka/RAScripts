// Boku wa Chiisai
// #ID = 20793
// #MinimumVersion = 1.3

NULL = 0

g_map_pointer = dword(0x235a94)
g_map = dword(g_map_pointer + 0x44)
InGame = () => g_map_pointer != NULL

rp_area = rich_presence_lookup(
    "AREA",
    g_map,
    {
        0x0: "is in the hallway",
        0x1: "is in the storage closet",
        0x2: "is in the living room",
        0x3: "is inside their PFO",
        0x4: "is in UNKNOWN AREA 0x4",
        0x5: "is in UNKNOWN AREA 0x5",
        0x6: "is in UNKNOWN AREA 0x6",
        0x7: "is in UNKNOWN AREA 0x7",
        0x8: "is on the other side of the storage closet wall",
        0x9: "is in UNKNOWN AREA 0x9",
        0xA: "is in UNKNOWN AREA 0xA",
        0xB: "is in UNKNOWN AREA 0xB",
        0xC: "is in UNKNOWN AREA 0xC",
        0xD: "is in UNKNOWN AREA 0xD",
        0xE: "is in UNKNOWN AREA 0xE",
        0xF: "is in UNKNOWN AREA 0xF",
        0x10: "is in UNKNOWN AREA 0x10",
        0x11: "is in UNKNOWN AREA 0x11",
        0x12: "is in UNKNOWN AREA 0x12",
        0x13: "is in UNKNOWN AREA 0x13",
        0x14: "is traveling through time",
        0x15: "is watching the opening cutscene",
        0x16: "did not defuse the bomb",
        0x100: "is inside their PFO"
    },
    "is in UNKNOWN AREA ?"
)

rich_presence_conditional_display(
    !InGame(),
    "ポム is waiting for you to start the game!" 
)
rich_presence_conditional_display(
    InGame(),
    "ポム {0}!",
    rp_area
)
rich_presence_display("Playing ボクは小さい")