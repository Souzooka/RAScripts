// Tokyo Bus Guide 2
// #ID = 33572

NULL = 0

function if_else(cond, a, b)
{
    if cond == true
        return a
    return b
}

addr = (v) => v // Dummy accessor for ptr for if the pointed-to address is desired
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

function call_with_args(fn, args)
{
    if (length(args) == 0) fn()
    if (length(args) == 1) fn(args[0])
    if (length(args) == 2) fn(args[0], args[1])
    if (length(args) == 3) fn(args[0], args[1], args[2])
    if (length(args) == 4) fn(args[0], args[1], args[2], args[3])
    if (length(args) == 5) fn(args[0], args[1], args[2], args[3], args[4])
    if (length(args) == 6) fn(args[0], args[1], args[2], args[3], args[4], args[5])
    if (length(args) == 7) fn(args[0], args[1], args[2], args[3], args[4], args[5], args[6])
    if (length(args) == 8) fn(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7])
}

MODE_BOOT = 3
MODE_LOGO = 4
MODE_TITLE = 5
MODE_NEWGAME = 6
MODE_GAME = 7
MODE_GAMERESULT = 8
MODE_OPTION = 9
MODE_SAVE = 10
MODE_LOAD = 11
MODE_STAFFROLL = 12
MODE_NOWLOADING = 13
MODE_MODESELECT = 14
MODE_PRACTICE = 15
MODE_PASSENGER = 16
MODE_MAP = 17
MODE_DRIVERMODE = 18
MODE_CARSELECT = 19
MODE_COURSESELECT = 20
MODE_CHALLENGE = 21
MODE_CHALLENGETECHNIQUE = 22
MODE_NAMEENTRY = 23
MODE_RANKING = 24
MODE_SETGAME = 25
MODE_SETCONTROLLER = 26
MODE_KEYCONFIG = 28
MODE_SETTING = 29
MODE_SETSOUND = 30
MODE_2PLAYER = 31
MODE_2PLAYERPASSENGER = 33
MODE_BUSSTOP = 34
g_game_mode = byte(0x2a6795)
practices_completed = array_map(range(0, 12-1), i => bit(i, 0x01d65d28))

achievement(
    title="Stamp of Approval",
    description="Complete all practice lessons.",
    points=5,
    trigger=
        g_game_mode == MODE_GAME &&
        sum_of(practices_completed, v => prev(v)) == 11 &&
        measured(sum_of(practices_completed, v => v) == 12)
)

boot_string = "Starting up the bus"
menu_string = "In menus"

rp_format_strings = [
    [g_game_mode < MODE_BOOT, boot_string],
    [g_game_mode == MODE_BOOT, boot_string],
    [g_game_mode == MODE_LOGO, boot_string],
    [g_game_mode == MODE_TITLE, "In title screen"],
    [g_game_mode == MODE_NEWGAME, "Meeting Minkuru"],
    [g_game_mode == MODE_GAME, "Driving the bus"],
    [g_game_mode == MODE_GAMERESULT, "Reviewing route performance"],
    [g_game_mode == MODE_OPTION, menu_string],
    [g_game_mode == MODE_SAVE, menu_string],
    [g_game_mode == MODE_LOAD, menu_string],
    [g_game_mode == MODE_STAFFROLL, "Watching credits"],
    [g_game_mode == MODE_NOWLOADING, "In loading screen"],
    [g_game_mode == MODE_MODESELECT, menu_string],
    [g_game_mode == MODE_PRACTICE , menu_string],
    [g_game_mode == MODE_PASSENGER, "In Passenger state?"],
    [g_game_mode == MODE_MAP, "Checking the map"],
    [g_game_mode == MODE_DRIVERMODE, menu_string],
    [g_game_mode == MODE_CARSELECT, "Choosing a bus"],
    [g_game_mode == MODE_COURSESELECT, "Choosing a route"],
    [g_game_mode == MODE_CHALLENGE, menu_string],
    [g_game_mode == MODE_CHALLENGETECHNIQUE, menu_string],
    [g_game_mode == MODE_NAMEENTRY, menu_string],
    [g_game_mode == MODE_RANKING, menu_string],
    [g_game_mode == MODE_SETGAME, menu_string],
    [g_game_mode == MODE_SETCONTROLLER, menu_string],
    [g_game_mode == MODE_KEYCONFIG, menu_string],
    [g_game_mode == MODE_SETTING, menu_string],
    [g_game_mode == MODE_SETSOUND, menu_string],
    [g_game_mode == MODE_2PLAYER, "In 2-player mode"],
    [g_game_mode == MODE_2PLAYERPASSENGER, "In 2-player mode"],
    [g_game_mode == MODE_BUSSTOP, "In Bus Stop state?"],
]

for args in rp_format_strings
    call_with_args(rich_presence_conditional_display, args)
    
rich_presence_display("Playing Tokyo Bus Guide 2")