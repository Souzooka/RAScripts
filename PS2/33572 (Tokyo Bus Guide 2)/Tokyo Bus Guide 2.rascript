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

MODE_GAME = 7
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
