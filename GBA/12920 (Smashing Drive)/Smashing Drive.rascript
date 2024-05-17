// Smashing Drive
// #ID = 12920

// GAME VARIABLES

CurrentProcess = dword(0x6A04)
PROCESS_TRACKS = 0x8032A34
PROCESS_GOTONEXT = 0x8032A60
PROCESS_GAMEOVER = 0x8032A8C

in_game_processes = [PROCESS_TRACKS, PROCESS_GOTONEXT, PROCESS_GAMEOVER]

Route = byte(0x87FA)
Track = byte(0x87FB)
Level = word_be(0x87FA) // little cheeky trick to put the route first in a 16-bit value

// RICH PRESENCE START

RouteLookup = {
    1: "Early Bird",
    2: "Rush Hour",
    3: "Night Owl",
    4: "Dusk and Wired",
    5: "the Bonus Route in Early Bird",
    6: "the Bonus Route in Rush Hour",
    7: "the Bonus Route in Night Owl",
}

LevelLookup = {
    0x0100: "To Brooklyn",
    0x0101: "To Wall Street",
    0x0102: "To Little Italy",
    0x0200: "To Brooklyn Navy Yard",
    0x0201: "To The Music City Hall",
    0x0202: "To West Central Park",
    0x0300: "To Sea & Air Museum",
    0x0301: "To 5th Ave-34 St.",
    0x0302: "To Times Square",
    0x0400: "To The Statue of Liberty",
}

rich_presence_conditional_display(
    any_of(in_game_processes, process => process == CurrentProcess) && Route < 5,
    "Delivering a passenger {0} in the {1} Route.",
    rich_presence_lookup("LEVEL", Level, LevelLookup),
    rich_presence_lookup("ROUTE", Route, RouteLookup)
)
rich_presence_conditional_display(
    any_of(in_game_processes, process => process == CurrentProcess),
    "Driving {0}.",
    rich_presence_lookup("ROUTE", Route, RouteLookup)
)
rich_presence_display("Playing Smashing Drive")
