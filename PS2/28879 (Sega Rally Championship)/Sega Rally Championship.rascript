// Sega Rally Championship
// #ID = 28879

// MISC. SCRIPT HELPERS

NULL = 0
True = 1
False = 0

function if_else(cond, v1, v2)
{
    if cond == true
    {
        return v1
    }
    return v2
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

// GAME VARIABLES

MainGameState = dword(0x30FD44)
SecondaryGameState = dword(0x30FD48)
TernaryGameState = dword(0x30FD50)

// GAME FUNCTIONS

function InGame()
{
    return MainGameState == 3 &&
           any_of([5, 7], state => SecondaryGameState == state) &&
           any_of([2, 3, 4, 5], state => TernaryGameState == state)
}

function InChampionship()
{
    return InGame() &&
           any_of([2, 3], state => TernaryGameState == state)
}

function InPractice()
{
    return InGame() &&
           any_of([4, 5], state => TernaryGameState == state)
}

// RICH PRESENCE

rich_presence_conditional_display(
    InChampionship(),
    "In-Game (in Championship)"
)
rich_presence_conditional_display(
    InPractice(),
    "In-Game (in Practice)"
)
rich_presence_display(
    "INSERT COIN(S)"
)
