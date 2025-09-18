// Kurohyou: Ryu ga Gotoku Shinshou
// #ID = 18382

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
    mask = 0x7FFFFFF
    val = dword(base) & mask
    
    for i in range(0, length(offsets) - 1)
    {
        addr = val + offsets[i]
        if (i == length(offsets) - 1)
        {
            val = accessor(addr)
        }
        else
        {
            val = dword(addr) & mask
        }
    }
    
    return val
}

function SaveProtection()
{
    return ptr(0xEAA7E8, [0x90C], dword) != 0x15
}

function InGame()
{
    return ptr(0xEAA7E8, [0x90C], dword) == 0x0
}

function SawShinjouCutscene()
{
    return prev(ptr(0xEAA7E8, [0x90C], dword)) == 0x81
}

// Per the code notes...
valid_substories = [
    ptr(0xea6db0, [0x2], bit5), ptr(0xea6db0, [0x3], bit2), ptr(0xea6db0, [0x3], bit7), ptr(0xea6db0, [0x4], bit4), ptr(0xea6db0, [0x5], bit1),
    ptr(0xea6db0, [0x5], bit6), ptr(0xea6db0, [0x8C], bit7), ptr(0xea6db0, [0x8D], bit0), ptr(0xea6db0, [0x8D], bit1), ptr(0xea6db0, [0x8D], bit2),
    ptr(0xea6db0, [0x8D], bit3), ptr(0xea6db0, [0x8D], bit4), ptr(0xea6db0, [0x8D], bit7), ptr(0xea6db0, [0x8E], bit1), ptr(0xea6db0, [0x8E], bit3),
    ptr(0xea6db0, [0x8E], bit6), ptr(0xea6db0, [0x8F], bit0), ptr(0xea6db0, [0x8F], bit2), ptr(0xea6db0, [0x8F], bit4), ptr(0xea6db0, [0x8F], bit6),
    ptr(0xea6db0, [0x90], bit0), ptr(0xea6db0, [0x90], bit2), ptr(0xea6db0, [0x90], bit5), ptr(0xea6db0, [0x90], bit7), ptr(0xea6db0, [0x91], bit1),
    ptr(0xea6db0, [0x91], bit3), ptr(0xea6db0, [0x91], bit5), ptr(0xea6db0, [0x91], bit7), ptr(0xea6db0, [0x92], bit1), ptr(0xea6db0, [0x92], bit5),
    ptr(0xea6db0, [0x92], bit7), ptr(0xea6db0, [0x93], bit2), ptr(0xea6db0, [0x93], bit6), ptr(0xea6db0, [0x94], bit1), ptr(0xea6db0, [0x94], bit4),
    ptr(0xea6db0, [0x95], bit2), ptr(0xea6db0, [0x95], bit6), ptr(0xea6db0, [0x96], bit0), ptr(0xea6db0, [0x96], bit6), ptr(0xea6db0, [0x97], bit0),
    ptr(0xea6db0, [0x97], bit2), ptr(0xea6db0, [0x97], bit4), ptr(0xea6db0, [0x97], bit6), ptr(0xea6db0, [0x98], bit0), ptr(0xea6db0, [0x98], bit2),
    ptr(0xea6db0, [0x98], bit4), ptr(0xea6db0, [0x98], bit6), ptr(0xea6db0, [0x99], bit0), ptr(0xea6db0, [0x99], bit3), ptr(0xea6db0, [0x99], bit5),
    ptr(0xea6db0, [0x99], bit7), ptr(0xea6db0, [0x9A], bit1), ptr(0xea6db0, [0x9A], bit3), ptr(0xea6db0, [0x9A], bit5), ptr(0xea6db0, [0x9A], bit7),
    ptr(0xea6db0, [0x9B], bit1), ptr(0xea6db0, [0x9B], bit3), ptr(0xea6db0, [0x9B], bit5), ptr(0xea6db0, [0x9B], bit7), ptr(0xea6db0, [0x9C], bit1),
    ptr(0xea6db0, [0x9C], bit3), ptr(0xea6db0, [0x9C], bit5), ptr(0xea6db0, [0x9C], bit7), ptr(0xea6db0, [0x9D], bit1), ptr(0xea6db0, [0x9D], bit3),
    ptr(0xea6db0, [0x9D], bit5), ptr(0xea6db0, [0x9E], bit0), ptr(0xea6db0, [0x9E], bit2), ptr(0xea6db0, [0x9E], bit4), ptr(0xea6db0, [0x9E], bit6),
    ptr(0xea6db0, [0x9F], bit0), ptr(0xea6db0, [0x9F], bit2), ptr(0xea6db0, [0x9F], bit3), ptr(0xea6db0, [0x9F], bit4), ptr(0xea6db0, [0x9F], bit5),
    ptr(0xea6db0, [0x9F], bit6), ptr(0xea6db0, [0x9F], bit7), ptr(0xea6db0, [0xA0], bitcount), ptr(0xea6db0, [0xA1], bit0), ptr(0xea6db0, [0xA1], bit1),
    ptr(0xea6db0, [0xAA], bit7), ptr(0xea6db0, [0xAB], bitcount), ptr(0xea6db0, [0xAC], bit0), ptr(0xea6db0, [0xB2], bit1), ptr(0xea6db0, [0xB2], bit5),
    ptr(0xea6db0, [0xB4], bit0), ptr(0xea6db0, [0xB4], bit6), ptr(0xea6db0, [0xB5], bit3),
]

// ...
non_gaia_substories = [
    ptr(0xea6db0, [0x2], bit5), ptr(0xea6db0, [0x3], bit2), ptr(0xea6db0, [0x3], bit7), ptr(0xea6db0, [0x4], bit4), ptr(0xea6db0, [0x5], bit1),
    ptr(0xea6db0, [0x5], bit6), ptr(0xea6db0, [0x6], bit3), ptr(0xea6db0, [0x8C], bit7), ptr(0xea6db0, [0x8D], bit0), ptr(0xea6db0, [0x8D], bit1),
    ptr(0xea6db0, [0x8D], bit2), ptr(0xea6db0, [0x8D], bit3), ptr(0xea6db0, [0x8D], bit4), ptr(0xea6db0, [0x8D], bit7), ptr(0xea6db0, [0x8E], bit1),
    ptr(0xea6db0, [0x8E], bit3), ptr(0xea6db0, [0x8E], bit6), ptr(0xea6db0, [0x8F], bit0), ptr(0xea6db0, [0x8F], bit2), ptr(0xea6db0, [0x8F], bit4),
    ptr(0xea6db0, [0x8F], bit6), ptr(0xea6db0, [0x90], bit0), ptr(0xea6db0, [0x90], bit2), ptr(0xea6db0, [0x90], bit5), ptr(0xea6db0, [0x90], bit7),
    ptr(0xea6db0, [0x91], bit1), ptr(0xea6db0, [0x91], bit3), ptr(0xea6db0, [0x91], bit5), ptr(0xea6db0, [0x91], bit7), ptr(0xea6db0, [0x92], bit1),
    ptr(0xea6db0, [0x92], bit5), ptr(0xea6db0, [0x92], bit7), ptr(0xea6db0, [0x93], bit2), ptr(0xea6db0, [0x93], bit6), ptr(0xea6db0, [0x94], bit1),
    ptr(0xea6db0, [0x94], bit4), ptr(0xea6db0, [0x95], bit2), ptr(0xea6db0, [0x95], bit6), ptr(0xea6db0, [0x96], bit0), ptr(0xea6db0, [0x96], bit6),
    ptr(0xea6db0, [0x97], bit0), ptr(0xea6db0, [0x97], bit2), ptr(0xea6db0, [0x97], bit4), ptr(0xea6db0, [0x97], bit6), ptr(0xea6db0, [0x98], bit0),
    ptr(0xea6db0, [0x98], bit2), ptr(0xea6db0, [0x98], bit4), ptr(0xea6db0, [0x98], bit6), ptr(0xea6db0, [0x99], bit0), ptr(0xea6db0, [0x99], bit3),
    ptr(0xea6db0, [0x99], bit5), ptr(0xea6db0, [0x99], bit7), ptr(0xea6db0, [0x9A], bit1), ptr(0xea6db0, [0x9A], bit3), ptr(0xea6db0, [0x9A], bit5),
    ptr(0xea6db0, [0x9A], bit7), ptr(0xea6db0, [0x9B], bit1), ptr(0xea6db0, [0x9B], bit3), ptr(0xea6db0, [0x9B], bit5), ptr(0xea6db0, [0x9B], bit7),
    ptr(0xea6db0, [0x9C], bit1), ptr(0xea6db0, [0x9C], bit3), ptr(0xea6db0, [0x9C], bit5), ptr(0xea6db0, [0x9C], bit7), ptr(0xea6db0, [0x9D], bit1),
    ptr(0xea6db0, [0x9D], bit3), ptr(0xea6db0, [0x9D], bit5), ptr(0xea6db0, [0x9E], bit0), ptr(0xea6db0, [0x9E], bit2), ptr(0xea6db0, [0x9E], bit4),
    ptr(0xea6db0, [0x9E], bit6), ptr(0xea6db0, [0x9F], bit0), ptr(0xea6db0, [0x9F], bit2), ptr(0xea6db0, [0x9F], bit3), ptr(0xea6db0, [0x9F], bit4),
    ptr(0xea6db0, [0x9F], bit5), ptr(0xea6db0, [0x9F], bit6), ptr(0xea6db0, [0x9F], bit7), ptr(0xea6db0, [0xA0], bitcount), ptr(0xea6db0, [0xA1], bit0),
    ptr(0xea6db0, [0xA1], bit1), ptr(0xea6db0, [0xAA], bit7), ptr(0xea6db0, [0xAB], bitcount), ptr(0xea6db0, [0xAC], bit0), ptr(0xea6db0, [0xB1], bit2),
    ptr(0xea6db0, [0xB2], bit1), ptr(0xea6db0, [0xB2], bit5), ptr(0xea6db0, [0xB4], bit0), ptr(0xea6db0, [0xB4], bit6), ptr(0xea6db0, [0xB5], bit3)
]

achievement(
    title = "Brute Force", points = 10, type="missable",
    description = "In Normal or higher, beat Tomoki without blocking or using counters. (Premium New Game is not allowed)",
    id = 490747, badge = "555910", published = "1/7/2025 9:59:48 PM", modified = "8/3/2025 1:19:33 PM",
    trigger = dword(0xEC2A78) != 0 && prev(float((dword(0xEC2A78) & 0x1FFFFFF) + 0x000038)) > 0.0 &&
              dword(0xEC2A08) != 0 && trigger_when(float((dword(0xEC2A08) & 0x1FFFFFF) + 0x001C80) == 0.0) &&
              byte(0xEA22FC) == 1 && byte(0xE9E9DC) == 0 && byte(0xE9E9DA) != 0 &&
              once(bit0(0xF142A5) > prev(bit0(0xF142A5)) || word(0xEA266C) > prev(word(0xEA266C))) &&
              never(dword((dword(0xEC2A04) & 0x1FFFFFF) + 0x001C78) == 0.0) && word(0xEA2794) == 10001 &&
              never(dword((dword(0xEC2A04) & 0x7FFFFFF) + 0x001F38) == 4) &&
              never(dword((dword(0xEC2A04) & 0x1FFFFFF) + 0x001F38) == 18) &&
              never(dword((dword(0xEC2A04) & 0x1FFFFFF) + 0x001F38) == 16)
)

achievement(
    title = "Number One", points = 3, type="progression",
    description = "Complete Chapter 1",
    id = 423468, badge = "555595", published = "5/5/2024 1:15:54 PM", modified = "2/7/2025 5:27:08 PM",
    trigger = prev(byte(0xEA22FC)) == 1 && byte(0xEA22FC) == 2 && SaveProtection()
)

achievement(
    title = "Sting Like a Bee", points = 1, type="progression",
    description = "Learn the Boxing Style",
    id = 423471, badge = "555598", published = "5/5/2024 1:16:28 PM", modified = "1/29/2025 5:58:28 PM",
    trigger = prev(bit5(0xE9EA30)) == 0 && bit5(0xE9EA30) == 1 && SaveProtection()
)

achievement(
    title = "'Tis but a Scratch", points = 10, type="missable",
    description = "In Normal difficulty or higher, defeat Hyuga in Chapter 2 without treating your injuries (Premium New Game not allowed)",
    id = 490884, badge = "556079", published = "1/8/2025 9:58:36 PM", modified = "8/3/2025 1:19:34 PM",
    trigger = dword(0xEC2A78) != 0 && dword(0xEC2A08) != 0 &&
              prev(float((dword(0xEC2A78) & 0x1FFFFFF) + 0x000038)) > 0.0 &&
              trigger_when(float((dword(0xEC2A08) & 0x1FFFFFF) + 0x001C80) == 0.0) && byte(0xEA22FC) == 2 &&
              byte(0xE9E9DC) == 0 && byte(0xE9E9DA) != 0 && word(0xEA2794) == 10002 &&
              once(bit0(0xF142A5) > prev(bit0(0xF142A5)) || word(0xEA266C) > prev(word(0xEA266C))) &&
              never(dword((dword(0xEC2A04) & 0x1FFFFFF) + 0x001C78) == 0.0) &&
              never((prev(dword(0x1402850)) == 47316 && word(0x1402850) == 0)) &&
              never((prev(word(0x1402858)) == 47316 && word(0x1402858) == 0)) &&
              never((prev(word(0x1402860)) == 47316 && word(0x1402860) == 0)) &&
              never((prev(word(0x1402868)) == 47316 && word(0x1402868) == 0)) &&
              never((prev(word(0x1402870)) == 47316 && word(0x1402870) == 0)) &&
              never((prev(word(0x1402878)) == 47316 && word(0x1402878) == 0)) &&
              never((prev(word(0x1402880)) == 47316 && word(0x1402880) == 0)) &&
              never((prev(word(0x1402888)) == 47316 && word(0x1402888) == 0)) &&
              never((prev(word(0x1402890)) == 47316 && word(0x1402890) == 0)) &&
              never((prev(word(0x1402898)) == 47316 && word(0x1402898) == 0)) &&
              never((prev(word(0x14028A0)) == 47316 && word(0x14028A0) == 0)) &&
              never((prev(word(0x14028A8)) == 47316 && word(0x14028A8) == 0)) &&
              never((prev(word(0x1402850)) == 47360 && word(0x1402850) == 0)) &&
              never((prev(word(0x1402858)) == 47360 && word(0x1402858) == 0)) &&
              never((prev(word(0x1402860)) == 47360 && word(0x1402860) == 0)) &&
              never((prev(word(0x1402868)) == 47360 && word(0x1402868) == 0)) &&
              never((prev(word(0x1402870)) == 47360 && word(0x1402870) == 0)) &&
              never((prev(word(0x1402878)) == 47360 && word(0x1402878) == 0)) &&
              never((prev(word(0x1402880)) == 47360 && word(0x1402880) == 0)) &&
              never((prev(word(0x1402888)) == 47360 && word(0x1402888) == 0)) &&
              never((prev(word(0x1402890)) == 47360 && word(0x1402890) == 0)) &&
              never((prev(word(0x1402898)) == 47360 && word(0x1402898) == 0)) &&
              never((prev(word(0x14028A0)) == 47360 && word(0x14028A0) == 0)) &&
              never((prev(word(0x14028A8)) == 47360 && word(0x14028A8) == 0)) &&
              never((prev(word(0x1402850)) == 47404 && word(0x1402850) == 0)) &&
              never((prev(word(0x1402858)) == 47404 && word(0x1402858) == 0)) &&
              never((prev(word(0x1402860)) == 47404 && word(0x1402860) == 0)) &&
              never((prev(word(0x1402868)) == 47404 && word(0x1402868) == 0)) &&
              never((prev(word(0x1402870)) == 47404 && word(0x1402870) == 0)) &&
              never((prev(word(0x1402878)) == 47404 && word(0x1402878) == 0)) &&
              never((prev(word(0x1402880)) == 47404 && word(0x1402880) == 0)) &&
              never((prev(word(0x1402888)) == 47404 && word(0x1402888) == 0)) &&
              never((prev(word(0x1402890)) == 47404 && word(0x1402890) == 0)) &&
              never((prev(word(0x1402898)) == 47404 && word(0x1402898) == 0)) &&
              never((prev(word(0x14028A0)) == 47404 && word(0x14028A0) == 0)) &&
              never((prev(word(0x14028A8)) == 47404 && word(0x14028A8) == 0)) &&
              never((prev(word(0x1402850)) == 47448 && word(0x1402850) == 0)) &&
              never((prev(word(0x1402858)) == 47448 && word(0x1402858) == 0)) &&
              never((prev(word(0x1402860)) == 47448 && word(0x1402860) == 0)) &&
              never((prev(word(0x1402868)) == 47448 && word(0x1402868) == 0)) &&
              never((prev(word(0x1402870)) == 47448 && word(0x1402870) == 0)) &&
              never((prev(word(0x1402878)) == 47448 && word(0x1402878) == 0)) &&
              never((prev(word(0x1402880)) == 47448 && word(0x1402880) == 0)) &&
              never((prev(word(0x1402888)) == 47448 && word(0x1402888) == 0)) &&
              never((prev(word(0x1402890)) == 47448 && word(0x1402890) == 0)) &&
              never((prev(word(0x1402898)) == 47448 && word(0x1402898) == 0)) &&
              never((prev(word(0x14028A0)) == 47448 && word(0x14028A0) == 0)) &&
              never((prev(word(0x14028A8)) == 47448 && word(0x14028A8) == 0)) &&
              never((prev(word(0x1402850)) == 43488 && word(0x1402850) == 0)) &&
              never((prev(word(0x1402858)) == 43488 && word(0x1402858) == 0)) &&
              never((prev(word(0x1402860)) == 43488 && word(0x1402860) == 0)) &&
              never((prev(word(0x1402868)) == 43488 && word(0x1402868) == 0)) &&
              never((prev(word(0x1402870)) == 43488 && word(0x1402870) == 0)) &&
              never((prev(word(0x1402878)) == 43488 && word(0x1402878) == 0)) &&
              never((prev(word(0x1402880)) == 43488 && word(0x1402880) == 0)) &&
              never((prev(word(0x1402888)) == 43488 && word(0x1402888) == 0)) &&
              never((prev(word(0x1402890)) == 43488 && word(0x1402890) == 0)) &&
              never((prev(word(0x1402898)) == 43488 && word(0x1402898) == 0)) &&
              never((prev(word(0x14028A0)) == 43488 && word(0x14028A0) == 0)) &&
              never((prev(word(0x14028A8)) == 43488 && word(0x14028A8) == 0)) &&
              never((prev(word(0x1402850)) == 47228 && word(0x1402850) == 0)) &&
              never((prev(word(0x1402858)) == 47228 && word(0x1402858) == 0)) &&
              never((prev(word(0x1402860)) == 47228 && word(0x1402860) == 0)) &&
              never((prev(word(0x1402868)) == 47228 && word(0x1402868) == 0)) &&
              never((prev(word(0x1402870)) == 47228 && word(0x1402870) == 0)) &&
              never((prev(word(0x1402878)) == 47228 && word(0x1402878) == 0)) &&
              never((prev(word(0x1402880)) == 47228 && word(0x1402880) == 0)) &&
              never((prev(word(0x1402888)) == 47228 && word(0x1402888) == 0)) &&
              never((prev(word(0x1402890)) == 47228 && word(0x1402890) == 0)) &&
              never((prev(word(0x1402898)) == 47228 && word(0x1402898) == 0)) &&
              never((prev(word(0x14028A0)) == 47228 && word(0x14028A0) == 0)) &&
              never((prev(word(0x14028A8)) == 47228 && word(0x14028A8) == 0)) &&
              never((prev(word(0x1402850)) == 47184 && word(0x1402850) == 0)) &&
              never((prev(word(0x1402858)) == 47184 && word(0x1402858) == 0)) &&
              never((prev(word(0x1402860)) == 47184 && word(0x1402860) == 0)) &&
              never((prev(word(0x1402868)) == 47184 && word(0x1402868) == 0)) &&
              never((prev(word(0x1402870)) == 47184 && word(0x1402870) == 0)) &&
              never((prev(word(0x1402878)) == 47184 && word(0x1402878) == 0)) &&
              never((prev(word(0x1402880)) == 47184 && word(0x1402880) == 0)) &&
              never((prev(word(0x1402888)) == 47184 && word(0x1402888) == 0)) &&
              never((prev(word(0x1402890)) == 47184 && word(0x1402890) == 0)) &&
              never((prev(word(0x1402898)) == 47184 && word(0x1402898) == 0)) &&
              never((prev(word(0x14028A0)) == 47184 && word(0x14028A0) == 0)) &&
              never((prev(word(0x14028A8)) == 47184 && word(0x14028A8) == 0)) &&
              never((prev(word(0x1402850)) == 47140 && word(0x1402850) == 0)) &&
              never((prev(word(0x1402858)) == 47140 && word(0x1402858) == 0)) &&
              never((prev(word(0x1402860)) == 47140 && word(0x1402860) == 0)) &&
              never((prev(word(0x1402868)) == 47140 && word(0x1402868) == 0)) &&
              never((prev(word(0x1402870)) == 47140 && word(0x1402870) == 0)) &&
              never((prev(word(0x1402878)) == 47140 && word(0x1402878) == 0)) &&
              never((prev(word(0x1402880)) == 47140 && word(0x1402880) == 0)) &&
              never((prev(word(0x1402888)) == 47140 && word(0x1402888) == 0)) &&
              never((prev(word(0x1402890)) == 47140 && word(0x1402890) == 0)) &&
              never((prev(word(0x1402898)) == 47140 && word(0x1402898) == 0)) &&
              never((prev(word(0x14028A0)) == 47140 && word(0x14028A0) == 0)) &&
              never((prev(word(0x14028A8)) == 47140 && word(0x14028A8) == 0))
)

achievement(
    title = "The Pride of Dragon Heat", points = 4, type="progression",
    description = "Complete Chapter 2",
    id = 423469, badge = "555596", published = "5/5/2024 1:16:04 PM", modified = "2/5/2025 9:39:40 PM",
    trigger = prev(byte(0xEA22FC)) == 2 && byte(0xEA22FC) == 3 && SaveProtection()
)

achievement(
    title = "You Dare Use My Own Spells?", points = 25, type="missable",
    description = "In Normal difficulty or higher, beat Yuki by only using counters, grabs and heat actions (Premium New Game not allowed)",
    id = 491837, badge = "557333", published = "1/12/2025 8:03:27 PM", modified = "8/3/2025 1:19:35 PM",
    trigger = dword(0xEC2A78) != 0 && prev(float((dword(0xEC2A78) & 0x1FFFFFF) + 0x000038)) > 0.0 &&
              dword(0xEC2A08) != 0 && trigger_when(float((dword(0xEC2A08) & 0x1FFFFFF) + 0x001C80) == 0.0) &&
              byte(0xEA22FC) == 3 && byte(0xE9E9DC) == 0 && byte(0xE9E9DA) != 0 &&
              once(bit0(0xF142A5) > prev(bit0(0xF142A5)) || word(0xEA266C) > prev(word(0xEA266C))) &&
              never(dword((dword(0xEC2A04) & 0x1FFFFFF) + 0x001C78) == 0.0) && word(0xEA2794) == 10003 &&
              never(dword((dword(0xEC2A04) & 0x1FFFFFF) + 0x001F38) == 14) &&
              never(dword((dword(0xEC2A04) & 0x1FFFFFF) + 0x001F38) == 10) &&
              never(dword((dword(0xEC2A04) & 0x1FFFFFF) + 0x001F38) == 11) &&
              never(dword((dword(0xEC2A04) & 0x1FFFFFF) + 0x001F38) == 7) &&
              never(dword((dword(0xEC2A04) & 0x1FFFFFF) + 0x001F38) == 15) &&
              never(dword((dword(0xEC2A04) & 0x1FFFFFF) + 0x001F38) == 13) &&
              never(byte((dword(0xEC2A04) & 0x1FFFFFF) + 0x001F38) == 9) &&
              never((prev(byte((dword(0xEC2A04) & 0x1FFFFFF) + 0x001F38)) != 16) &&
                  prev(byte((dword(0xEC2A04) & 0x1FFFFFF) + 0x001F38)) != 8 &&
                  byte((dword(0xEC2A04) & 0x1FFFFFF) + 0x001F38) == 8
              )
)

achievement(
    title = "Lesson in Strength", points = 4, type="progression",
    description = "Complete Chapter 3",
    id = 423470, badge = "555597", published = "5/5/2024 1:16:19 PM", modified = "3/9/2025 1:57:59 PM",
    trigger = prev(byte(0xEA22FC)) == 3 && byte(0xEA22FC) == 4 && SaveProtection()
)

achievement(
    title = "From Teacher to Student", points = 3,
    description = "Learn Ancient Martial Arts",
    id = 423473, badge = "556482", published = "5/5/2024 1:16:55 PM", modified = "5/9/2025 4:30:27 AM",
    trigger = prev(bit2(0xE9EA32)) == 0 && bit2(0xE9EA32) == 1 && InGame()
)

achievement(
    title = "Def Jam", points = 10, type="missable",
    description = "In Normal or higher, defeat Fujimoto using Street Fighting level 1 (Premium New Game not allowed)",
    id = 491071, badge = "556357", published = "1/10/2025 6:01:30 PM", modified = "8/3/2025 1:19:36 PM",
    trigger = dword(0xEC2A78) != 0 && prev(float((dword(0xEC2A78) & 0x1FFFFFF) + 0x000038)) > 0.0 &&
              dword(0xEC2A08) != 0 && trigger_when(float((dword(0xEC2A08) & 0x1FFFFFF) + 0x001C80) == 0.0) &&
              byte(0xE9EA14) == 0 && byte(0xEA22FC) == 4 && byte(0xE9E9DC) == 0 && byte(0xE9E9DA) != 0 &&
              once(bit0(0xF142A5) > prev(bit0(0xF142A5)) || word(0xEA266C) > prev(word(0xEA266C))) &&
              never(dword((dword(0xEC2A04) & 0x1FFFFFF) + 0x001C78) == 0.0) && word(0xEA2794) == 10004
)

achievement(
    title = "Father's Love", points = 4, type="progression",
    description = "Complete Chapter 4",
    id = 423472, badge = "555599", published = "5/5/2024 1:16:48 PM", modified = "2/5/2025 9:39:42 PM",
    trigger = prev(byte(0xEA22FC)) == 4 && byte(0xEA22FC) == 5 && SaveProtection()
)

achievement(
    title = "Young Bee Need Young Flower", points = 5,
    description = "Learn Karate",
    id = 449202, badge = "555743", published = "7/17/2024 5:15:36 PM", modified = "2/5/2025 9:39:42 PM",
    trigger = prev(bit5(0xE9EA31)) == 0 && bit5(0xE9EA31) == 1 && SaveProtection()
)

achievement(
    title = "The Masochist of Kamurocho", points = 10, type="missable",
    description = "In Normal or higher, defeat Makabe without performing Quick Steps or using Heat Actions (Premium New Game not allowed)",
    id = 491898, badge = "557432", published = "1/13/2025 4:39:14 PM", modified = "8/3/2025 1:19:37 PM",
    trigger = dword(0xEC2A78) != 0 && prev(float((dword(0xEC2A78) & 0x1FFFFFF) + 0x000038)) > 0.0 &&
              dword(0xEC2A08) != 0 && trigger_when(float((dword(0xEC2A08) & 0x1FFFFFF) + 0x001C80) == 0.0) &&
              byte(0xEA22FC) == 5 && byte(0xE9E9DC) == 0 && byte(0xE9E9DA) != 0 &&
              never(dword((dword(0xEC2A04) & 0x1FFFFFF) + 0x001F38) == 1) &&
              never(dword((dword(0xEC2A04) & 0x1FFFFFF) + 0x001F38) == 41) && dword(0xEC2A04) != 0 &&
              once(bit0(0xF142A5) > prev(bit0(0xF142A5)) || word(0xEA266C) > prev(word(0xEA266C))) &&
              never(dword((dword(0xEC2A04) & 0x1FFFFFF) + 0x001C78) == 0.0) && word(0xEA2794) == 10005
)

achievement(
    title = "Payback Time", points = 5, type="missable",
    description = "Bite Makabe on his shoulder (Premium New Game only)",
    id = 491881, badge = "557416", published = "1/13/2025 3:02:16 PM", modified = "7/26/2025 5:26:41 PM",
    trigger = prev(dword((dword(0xEC2A04) & 0x1FFFFFF) + 0x000820)) == 1109393408 &&
              dword((dword(0xEC2A04) & 0x1FFFFFF) + 0x000820) == 1131413504 && byte(0xEA22FC) == 5 &&
              byte(0xE9EA14) == 58 && word(0xEA2794) == 10005
)

achievement(
    title = "Mad Dog vs. Mad Dragon", points = 4, type="progression",
    description = "Complete Chapter 5",
    id = 423475, badge = "555715", published = "5/5/2024 1:34:30 PM", modified = "7/26/2025 5:15:15 PM",
    trigger = prev(byte(0xEA22FC)) == 5 && byte(0xEA22FC) == 6 && SaveProtection()
)

achievement(
    title = "THE NAKED PANTHER", points = 25, type="missable",
    description = "In Normal or higher, defeat Hyuga in Chapter 6 without taking more than 5 hits (Premium New Game not allowed)",
    id = 491916, badge = "557470", published = "1/13/2025 8:19:13 PM", modified = "8/3/2025 1:19:38 PM",
    trigger = dword(0xEC2A78) != 0 && prev(float((dword(0xEC2A78) & 0x1FFFFFF) + 0x000038)) > 0.0 &&
              dword(0xEC2A08) != 0 && trigger_when(float((dword(0xEC2A08) & 0x1FFFFFF) + 0x001C80) == 0.0) &&
              byte(0xE9E9DC) == 0 && byte(0xE9E9DA) != 0 && byte(0xEA22FC) == 6 &&
              never(repeated(6,
                  prev(dword((dword(0xEC2A04) & 0x1FFFFFF) + 0x001C78)) > dword((dword(0xEC2A04) & 0x1FFFFFF) + 0x001C78))
              ) && once(bit0(0xF142A5) > prev(bit0(0xF142A5)) || word(0xEA266C) > prev(word(0xEA266C))) &&
              never(dword((dword(0xEC2A04) & 0x1FFFFFF) + 0x001C78) == 0.0) && word(0xEA2794) == 10006
)

achievement(
    title = "End of Rematch", points = 5, type="progression",
    description = "Complete Chapter 6",
    id = 423476, badge = "555716", published = "5/5/2024 1:35:26 PM", modified = "2/6/2025 4:31:42 PM",
    trigger = prev(byte(0xEA22FC)) == 6 && byte(0xEA22FC) == 7 && SaveProtection()
)

achievement(
    title = "This Is Fine", points = 10, type="missable",
    description = "In Normal or higher, defeat Cho with any body part at flashing red before the fight starts (Premium New Game not allowed)",
    id = 497456, badge = "562781", published = "2/5/2025 6:04:18 PM", modified = "8/7/2025 3:29:17 PM",
    trigger = dword(0xEC2A78) != 0 && prev(float((dword(0xEC2A78) & 0x1FFFFFF) + 0x000038)) > 0.0 &&
              dword(0xEC2A08) != 0 && trigger_when(float((dword(0xEC2A08) & 0x1FFFFFF) + 0x001C80) == 0.0) &&
              byte(0xEA22FC) == 7 && byte(0xE9E9DC) == 0 && byte(0xE9E9DA) != 0 &&
              once(bit0(0xF142A5) > prev(bit0(0xF142A5)) || word(0xEA266C) > prev(word(0xEA266C))) &&
              never(dword((dword(0xEC2A04) & 0x1FFFFFF) + 0x001C78) == 0.0) && word(0xEA2794) == 10007 &&
              ((prev(byte(0xE9EAB4)) == 100 && float((dword(0xEC2A04) & 0x7FFFFFF) + 0x001CAC) == 1.0) ||
               (prev(byte(0xE9EAB8)) == 100 && float((dword(0xEC2A04) & 0x7FFFFFF) + 0x001CBC) == 1.0) ||
               (prev(byte(0xE9EABC)) == 100 && float((dword(0xEC2A04) & 0x7FFFFFF) + 0x001CCC) == 1.0) ||
               (prev(byte(0xE9EAC0)) == 100 && float((dword(0xEC2A04) & 0x7FFFFFF) + 0x001CDC) == 1.0))
)

achievement(
    title = "Blinded by Revenge", points = 5, type="progression",
    description = "Complete Chapter 7",
    id = 423478, badge = "555717", published = "5/5/2024 1:54:05 PM", modified = "2/6/2025 4:31:43 PM",
    trigger = prev(byte(0xEA22FC)) == 7 && byte(0xEA22FC) == 8 && SaveProtection()
)

achievement(
    title = "Joint Lock", points = 3, type="progression",
    description = "Learn Jiu-Jitsu",
    id = 492059, badge = "557670", published = "1/14/2025 3:30:16 PM", modified = "5/29/2025 1:26:16 PM",
    trigger = prev(bit5(0xE9EA33)) == 0 && bit5(0xE9EA33) == 1 && byte(0xEA22FC) == 8
)

achievement(
    title = "Wait and See", points = 10, type="missable",
    description = "In Normal or higher, defeat Aramaki without performing KO Strikes and without getting your Torso and Arms injury to orange level (Premium New Game not allowed)",
    id = 495341, badge = "562780", published = "1/29/2025 4:52:09 PM", modified = "8/3/2025 1:19:40 PM",
    trigger = dword(0xEC2A78) != 0 && prev(float((dword(0xEC2A78) & 0x1FFFFFF) + 0x000038)) > 0.0 &&
              dword(0xEC2A08) != 0 && trigger_when(float((dword(0xEC2A08) & 0x1FFFFFF) + 0x001C80) == 0.0) &&
              byte(0xEA22FC) == 8 && byte(0xE9E9DC) == 0 && byte(0xE9E9DA) != 0 &&
              once(bit0(0xF142A5) > prev(bit0(0xF142A5)) || word(0xEA266C) > prev(word(0xEA266C))) &&
              never(dword((dword(0xEC2A04) & 0x1FFFFFF) + 0x001C78) == 0.0) && word(0xEA2794) == 10008 &&
              never(dword((dword(0xEC2A04) & 0x1FFFFFF) + 0x001F38) == 15) &&
              never(float((dword(0xEC2A04) & 0x1FFFFFF) + 0x001CBC) >= 0.7) &&
              never(float((dword(0xEC2A04) & 0x1FFFFFF) + 0x001CCC) >= 0.7)
)

achievement(
    title = "The Lone Mercenary", points = 5, type="progression",
    description = "Complete Chapter 8",
    id = 423479, badge = "555718", published = "5/5/2024 1:55:35 PM", modified = "2/6/2025 4:31:43 PM",
    trigger = prev(byte(0xEA22FC)) == 8 && byte(0xEA22FC) == 9 && SaveProtection()
)

achievement(
    title = "Throwing Hands", points = 5, type="missable",
    description = "Defeat Shima while his Head injury is at 90% or higher",
    id = 497830, badge = "563190", published = "2/7/2025 10:47:33 AM", modified = "8/8/2025 3:12:42 PM",
    trigger = (dword(0xEC2A78) != 0 && prev(float((dword(0xEC2A78) & 0x1FFFFFF) + 0x000038)) > 0.0) &&
              dword(0xEC2A08) != 0 && trigger_when(float((dword(0xEC2A08) & 0x1FFFFFF) + 0x001C80) == 0.0) &&
              byte(0xEA22FC) == 9 && byte(0xE9E9DC) == 0 && byte(0xE9E9DA) != 0 &&
              once(bit0(0xF142A5) > prev(bit0(0xF142A5)) || word(0xEA266C) > prev(word(0xEA266C))) &&
              never(dword((dword(0xEC2A04) & 0x1FFFFFF) + 0x001C78) == 0.0) && word(0xEA2794) == 10009 &&
              float((dword(0xEC2A08) & 0x1FFFFFF) + 0x001CAC) >= 0.9 &&
              never(float((dword(0xEC2A08) & 0x1FFFFFF) + 0x001CAC) == 1.0)
)

achievement(
    title = "Southpaw Stance", points = 25, type="missable",
    description = "In Normal or higher, defeat Shima by using Boxing or Extreme God Hand and without performing grabs (Heat actions are allowed, Premium New Game not allowed)",
    id = 497457, badge = "562782", published = "2/5/2025 7:57:44 PM", modified = "8/8/2025 3:12:42 PM",
    trigger = dword(0xEC2A78) != 0 && prev(float((dword(0xEC2A78) & 0x1FFFFFF) + 0x000038)) > 0.0 &&
              dword(0xEC2A08) != 0 && trigger_when(float((dword(0xEC2A08) & 0x1FFFFFF) + 0x001C80) == 0.0) &&
              byte(0xEA22FC) == 9 && byte(0xE9E9DC) == 0 && byte(0xE9E9DA) != 0 &&
              once(bit0(0xF142A5) > prev(bit0(0xF142A5)) || word(0xEA266C) > prev(word(0xEA266C))) &&
              never(dword((dword(0xEC2A04) & 0x1FFFFFF) + 0x001C78) == 0.0) && word(0xEA2794) == 10009 &&
              never(dword((dword(0xEC2A04) & 0x1FFFFFF) + 0x001F38) == 37) &&
              (byte(0xE9EA14) == 5 || byte(0xE9EA14) == 6 || byte(0xE9EA14) == 7 || byte(0xE9EA14) == 8 ||
                  byte(0xE9EA14) == 9 || byte(0xE9EA14) == 51 || byte(0xE9EA14) == 52
              ) && never(float((dword(0xEC2A08) & 0x1FFFFFF) + 0x001CAC) == 1.0)
)

achievement(
    title = "Mark of a Traitor", points = 5, type="progression",
    description = "Complete Chapter 9",
    id = 423480, badge = "555719", published = "5/5/2024 1:56:23 PM", modified = "2/6/2025 4:31:43 PM",
    trigger = prev(byte(0xEA22FC)) == 9 && byte(0xEA22FC) == 10 && SaveProtection()
)

achievement(
    title = "Untouchable", points = 25, type="missable",
    description = "In Normal or higher, defeat the final boss without using any items (Premium New Game not allowed)",
    id = 495342, badge = "560353", published = "1/29/2025 4:59:02 PM", modified = "8/3/2025 1:19:42 PM",
    trigger = dword(0xEC2A78) != 0 && prev(float((dword(0xEC2A78) & 0x1FFFFFF) + 0x000038)) > 0.0 &&
              dword(0xEC2A08) != 0 && trigger_when(float((dword(0xEC2A08) & 0x1FFFFFF) + 0x001C80) == 0.0) &&
              byte(0xEA22FC) == 10 && byte(0xE9E9DC) == 0 && byte(0xE9E9DA) != 0 &&
              once(bit0(0xF142A5) > prev(bit0(0xF142A5)) || word(0xEA266C) > prev(word(0xEA266C))) &&
              never(dword((dword(0xEC2A04) & 0x1FFFFFF) + 0x001C78) == 0.0) && word(0xEA2794) == 10011 &&
              never(float((dword(0xEC2A04) & 0x1FFFFFF) + 0x001C78) == 0.0) &&
              never((prev(word(0x1402850)) != 0 && word(0x1402850) == 0)) &&
              never((prev(word(0x1402858)) != 0 && word(0x1402858) == 0)) &&
              never((prev(word(0x1402860)) != 0 && word(0x1402860) == 0)) &&
              never((prev(word(0x1402868)) != 0 && word(0x1402868) == 0)) &&
              never((prev(word(0x1402870)) != 0 && word(0x1402870) == 0)) &&
              never((prev(word(0x1402878)) != 0 && word(0x1402878) == 0)) &&
              never((prev(word(0x1402880)) != 0 && word(0x1402880) == 0)) &&
              never((prev(word(0x1402888)) != 0 && word(0x1402888) == 0)) &&
              never((prev(word(0x1402890)) != 0 && word(0x1402890) == 0)) &&
              never((prev(word(0x1402898)) != 0 && word(0x1402898) == 0)) &&
              never((prev(word(0x14028A0)) != 0 && word(0x14028A0) == 0)) &&
              never((prev(word(0x14028A8)) != 0 && word(0x14028A8) == 0))
)

achievement(
    title = "A Reason to Fight", points = 10, type="win_condition",
    description = "Complete the Finale",
    id = 427394, badge = "555720", published = "5/15/2024 4:29:59 PM", modified = "8/1/2025 5:34:33 PM",
    trigger = SawShinjouCutscene() && InGame() && word(0xEA2794) == 10011
)

achievement(
    title = "Town Bully", points = 5,
    description = "Defeat 100 enemies",
    id = 428441, badge = "555721", published = "5/16/2024 3:58:39 PM", modified = "2/6/2025 4:31:44 PM",
    trigger = prev(word(0xEA2670)) < 100 && measured(word(0xEA2670) >= 100) && SaveProtection()
)

achievement(
    title = "Street Warrior", points = 10,
    description = "Defeat 1000 enemies",
    id = 428442, badge = "555722", published = "5/16/2024 3:58:39 PM", modified = "2/6/2025 4:31:44 PM",
    trigger = prev(word(0xEA2670)) < 1000 && measured(word(0xEA2670) >= 1000) && SaveProtection()
)

achievement(
    title = "Master At Work", points = 10,
    description = "Get 999 points in every part-time job",
    id = 452609, badge = "555749", published = "8/2/2024 2:23:06 PM", modified = "3/26/2025 8:14:13 PM",
    trigger = (prev(word(0xEA9820)) / 999 + prev(word(0xEA9822)) / 999 + prev(word(0xEA9824)) / 999 +
              prev(word(0xEA9826)) / 999) == 3 &&
              measured((word(0xEA9820) / 999 + word(0xEA9822) / 999 + word(0xEA9824) / 999 + word(0xEA9826) / 999) == 4) &&
              SaveProtection()
)

achievement(
    title = "Tell Me a Story", points = 10,
    description = "Complete 20 substories",
    id = 423381, badge = "556291", published = "5/4/2024 8:59:00 PM", modified = "2/6/2025 4:31:45 PM",
    trigger=
        sum_of(valid_substories, prev) == 19 &&
        sum_of(valid_substories, v => v) == 20 &&
        SaveProtection()
)

achievement(
    title = "Never Ending Story", points = 10,
    description = "Complete 50 substories",
    id = 423427, badge = "556290", published = "5/5/2024 10:19:44 AM", modified = "2/7/2025 5:22:07 PM",
    trigger =
        sum_of(valid_substories, prev) == 49 &&
        sum_of(valid_substories, v => v) == 50 &&
        SaveProtection()
)

achievement(
    title = "Hero of the Story", points = 25, type="missable",
    description = "Complete all substories excluding Gaia",
    id = 423429, badge = "556272", published = "5/5/2024 10:19:53 AM", modified = "8/2/2025 9:58:10 AM",
    trigger = 
        sum_of(non_gaia_substories, prev) == 103 &&
        sum_of(non_gaia_substories, v => v) == 104 &&
        SaveProtection()
)

achievement(
    title = "That Man, Gaia", points = 25, type="missable",
    description = "Beat the final substory boss, Gaia",
    id = 423428, badge = "556271", published = "5/5/2024 10:19:49 AM", modified = "7/31/2025 1:30:44 PM",
    trigger = (dword(0xEC2A78) != 0 && prev(float((dword(0xEC2A78) & 0x1FFFFFF) + 0x000038)) > 0.0) &&
              (dword(0xEC2A08) != 0 && float((dword(0xEC2A08) & 0x1FFFFFF) + 0x001C80) == 0.0) &&
              once(bit0(0xF142A5) > prev(bit0(0xF142A5)) || word(0xEA266C) > prev(word(0xEA266C))) &&
              never(dword((dword(0xEC2A04) & 0x1FFFFFF) + 0x001C78) == 0.0) && word(0xEA2794) == 12078
)

achievement(
    title = "We're Halfway There", points = 5,
    description = "Reach rank 20 in the Kamurocho Strongest Ranking",
    id = 423432, badge = "556285", published = "5/5/2024 10:20:26 AM", modified = "2/6/2025 4:31:47 PM",
    trigger = prev(bit0(0x14027DD)) == 0 && bit0(0x14027DD) == 1 && SaveProtection()
)

achievement(
    title = "Climbing up the Rankings", points = 10,
    description = "Reach rank 10 in the Kamurocho Strongest Ranking",
    id = 423431, badge = "556284", published = "5/5/2024 10:20:19 AM", modified = "7/26/2025 5:20:02 PM",
    trigger = prev(bit2(0x14027DD)) == 0 && bit2(0x14027DD) == 1 && SaveProtection()
)

achievement(
    title = "The Very Best", points = 25,
    description = "Reach the first rank and defeat NOBU in Kamurocho Strongest Ranking",
    id = 423430, badge = "556283", published = "5/5/2024 10:20:08 AM", modified = "2/6/2025 4:31:48 PM",
    trigger = prev(bit4(0x14027DD)) == 0 && bit4(0x14027DD) == 1 && SaveProtection()
)

achievement(
    title = "Dangerous Tough Guys", points = 3,
    description = "Bump into 100 civilians",
    id = 472600, badge = "556282", published = "10/21/2024 4:06:03 PM", modified = "7/26/2025 5:38:32 PM",
    trigger = prev(bit3(0xEA6DF5)) == 0 && bit3(0xEA6DF5) == 1 && SaveProtection()
)

achievement(
    title = "A Step Forward", points = 10,
    description = "Reach level 30",
    id = 465179, badge = "556280", published = "9/21/2024 1:43:25 PM", modified = "2/6/2025 4:31:49 PM",
    trigger = prev(dword(0xE9EBD8)) <= 304999 && prev(dword(0xE9EBD8)) > 0 && dword(0xE9EBD8) >= 305000 &&
              SaveProtection()
)

achievement(
    title = "Peak Tatsuya", points = 25,
    description = "Reach level 50 (Premium adventure/NG+ only)",
    id = 465180, badge = "556281", published = "9/21/2024 1:43:25 PM", modified = "6/9/2025 3:06:58 PM",
    trigger = prev(dword(0xE9EBD8)) <= 799999 && dword(0xE9EBD8) == 800000 && SaveProtection() &&
              prev(dword(0xE9EBD8)) > 0
)

achievement(
    title = "Hungry for Life", points = 5,
    description = "Order every food and drink item in the game",
    id = 450336, badge = "556481", published = "7/23/2024 9:05:35 PM", modified = "4/27/2025 4:25:47 PM",
    trigger = (prev(bit1(0xEA2634)) + prev(bit2(0xEA2634)) + prev(bit3(0xEA2634)) + prev(bit4(0xEA2634)) +
              prev(bit5(0xEA2634)) + prev(bit6(0xEA2634)) + prev(bit7(0xEA2634)) + prev(bitcount(0xEA2635)) +
              prev(bitcount(0xEA2636)) + prev(bitcount(0xEA2637)) + prev(bit1(0xEA2638)) + prev(bit2(0xEA2638)) +
              prev(bit3(0xEA2638)) + prev(bit4(0xEA2638)) + prev(bit5(0xEA2638)) + prev(bit6(0xEA2638)) +
              prev(bit7(0xEA2638)) + prev(bit1(0xEA2639)) + prev(bit0(0xEA2639)) + prev(bit1(0xEA263B)) +
              prev(bit2(0xEA263C)) + prev(bit3(0xEA263C)) + prev(bit4(0xEA263C)) + prev(bit5(0xEA263C)) +
              prev(bit6(0xEA263C)) + prev(bit7(0xEA263C)) + prev(bit0(0xEA263D)) + prev(bit1(0xEA263D)) +
              prev(bitcount(0xEA2645)) + prev(bitcount(0xEA2646)) + prev(bitcount(0xEA2647)) + prev(bitcount(0xEA2648))
              + prev(bitcount(0xEA2649)) + prev(bit0(0xEA264A)) + prev(bit1(0xEA264A)) + prev(bit2(0xEA264A)) +
              prev(bit3(0xEA264A)) + prev(bit4(0xEA264A)) + prev(bit0(0xEA264C)) + prev(bit1(0xEA264C)) +
              prev(bit3(0xEA264C)) + prev(bit4(0xEA264C)) + prev(bit5(0xEA264C)) + prev(bit6(0xEA264C)) +
              prev(bit7(0xEA264C)) + prev(bit0(0xEA264D)) + prev(bit1(0xEA264D)) + prev(bit2(0xEA264D)) +
              prev(bit3(0xEA264D)) + prev(bit4(0xEA264D)) + prev(bit5(0xEA264D))) == 106 &&
              measured((bit1(0xEA2634) + bit2(0xEA2634) + bit3(0xEA2634) + bit4(0xEA2634) + bit5(0xEA2634) +
                  bit6(0xEA2634) + bit7(0xEA2634) + bitcount(0xEA2635) + bitcount(0xEA2636) + bitcount(0xEA2637) +
                  bit1(0xEA2638) + bit2(0xEA2638) + bit3(0xEA2638) + bit4(0xEA2638) + bit5(0xEA2638) + bit6(0xEA2638) +
                  bit7(0xEA2638) + bit1(0xEA2639) + bit0(0xEA2639) + bit1(0xEA263B) + bit2(0xEA263C) + bit3(0xEA263C) +
                  bit4(0xEA263C) + bit5(0xEA263C) + bit6(0xEA263C) + bit7(0xEA263C) + bit0(0xEA263D) + bit1(0xEA263D) +
                  bitcount(0xEA2645) + bitcount(0xEA2646) + bitcount(0xEA2647) + bitcount(0xEA2648) + bitcount(0xEA2649) +
                  bit0(0xEA264A) + bit1(0xEA264A) + bit2(0xEA264A) + bit3(0xEA264A) + bit4(0xEA264A) + bit0(0xEA264C) +
                  bit1(0xEA264C) + bit3(0xEA264C) + bit4(0xEA264C) + bit5(0xEA264C) + bit6(0xEA264C) + bit7(0xEA264C) +
                  bit0(0xEA264D) + bit1(0xEA264D) + bit2(0xEA264D) + bit3(0xEA264D) + bit4(0xEA264D) + bit5(0xEA264D)) == 107
              ) && SaveProtection()
)

achievement(
    title = "Back at It Again", points = 3,
    description = "Complete Chapter 1 on EX-HARD",
    id = 459075, badge = "555764", published = "8/27/2024 4:19:59 PM", modified = "7/26/2025 5:18:34 PM",
    trigger = prev(byte(0xEA22FC)) == 1 && byte(0xEA22FC) == 2 && low4(0xE9E9DA) == 3 && SaveProtection()
)

achievement(
    title = "The New Legend", points = 5,
    description = "Complete Chapter 2 on EX-HARD",
    id = 459074, badge = "555763", published = "8/27/2024 4:19:58 PM", modified = "2/11/2025 3:56:55 PM",
    trigger = prev(byte(0xEA22FC)) == 2 && byte(0xEA22FC) == 3 && SaveProtection() && low4(0xE9E9DA) == 3
)

achievement(
    title = "L + Left Stick", points = 5,
    description = "Complete Chapter 3 on EX-HARD",
    id = 459073, badge = "555762", published = "8/27/2024 4:19:58 PM", modified = "2/11/2025 3:56:55 PM",
    trigger = prev(byte(0xEA22FC)) == 3 && byte(0xEA22FC) == 4 && SaveProtection() && low4(0xE9E9DA) == 3
)

achievement(
    title = "Black Belt", points = 5,
    description = "Complete Chapter 4 on EX-HARD",
    id = 459072, badge = "555761", published = "8/27/2024 4:19:57 PM", modified = "2/11/2025 3:56:55 PM",
    trigger = prev(byte(0xEA22FC)) == 4 && byte(0xEA22FC) == 5 && SaveProtection() && low4(0xE9E9DA) == 3
)

achievement(
    title = "Out of the Cage", points = 5,
    description = "Complete Chapter 5 on EX-HARD",
    id = 459071, badge = "555760", published = "8/27/2024 4:19:57 PM", modified = "2/11/2025 3:56:56 PM",
    trigger = prev(byte(0xEA22FC)) == 5 && byte(0xEA22FC) == 6 && SaveProtection() && low4(0xE9E9DA) == 3
)

achievement(
    title = "How Many Times Do We Have to Teach You This Lesson?", points = 10,
    description = "Complete Chapter 6 on EX-HARD",
    id = 459070, badge = "555759", published = "8/27/2024 4:19:57 PM", modified = "7/26/2025 5:19:14 PM",
    trigger = prev(byte(0xEA22FC)) == 6 && byte(0xEA22FC) == 7 && SaveProtection() && low4(0xE9E9DA) == 3
)

achievement(
    title = "The Great Grey Wolf", points = 10,
    description = "Complete Chapter 7 on EX-HARD",
    id = 459069, badge = "555758", published = "8/27/2024 4:19:56 PM", modified = "2/11/2025 3:56:57 PM",
    trigger = prev(byte(0xEA22FC)) == 7 && byte(0xEA22FC) == 8 && SaveProtection() && low4(0xE9E9DA) == 3
)

achievement(
    title = "Cold Blooded Grappler", points = 10,
    description = "Complete Chapter 8 on EX-HARD",
    id = 459068, badge = "555757", published = "8/27/2024 4:19:56 PM", modified = "2/11/2025 3:56:58 PM",
    trigger = prev(byte(0xEA22FC)) == 8 && byte(0xEA22FC) == 9 && SaveProtection() && low4(0xE9E9DA) == 3
)

achievement(
    title = "Flicker Jab", points = 25,
    description = "Complete Chapter 9 on EX-HARD",
    id = 459067, badge = "555756", published = "8/27/2024 4:19:55 PM", modified = "2/11/2025 3:56:58 PM",
    trigger = prev(byte(0xEA22FC)) == 9 && byte(0xEA22FC) == 10 && SaveProtection() && low4(0xE9E9DA) == 3
)

achievement(
    title = "Revenge", points = 25,
    description = "Complete the Finale on EX-HARD",
    id = 459066, badge = "555755", published = "8/27/2024 4:19:55 PM", modified = "8/1/2025 5:34:54 PM",
    trigger = SawShinjouCutscene() && InGame() && low4(0xE9E9DA) == 3
)

achievement(
    title = "Healthy Love", points = 5,
    description = "Max out Yu's affection",
    id = 449087, badge = "555732", published = "7/16/2024 3:19:51 PM", modified = "2/6/2025 4:31:54 PM",
    trigger = prev(ptr(0xea6db0, [0x5], bit6)) == 0 && ptr(0xea6db0, [0x5], bit6) == 1 && SaveProtection()
)

achievement(
    title = "Okinawa Gal", points = 5,
    description = "Max out Mika's affection",
    id = 449088, badge = "555733", published = "7/16/2024 3:19:51 PM", modified = "2/6/2025 4:31:54 PM",
    trigger = prev(ptr(0xea6db0, [0x2], bit5)) == 0 && ptr(0xea6db0, [0x2], bit5) == 1 && SaveProtection()
)

achievement(
    title = "95% Water", points = 5,
    description = "Max out Saya's affection",
    id = 449089, badge = "555734", published = "7/16/2024 3:19:51 PM", modified = "2/6/2025 4:31:55 PM",
    trigger = prev(ptr(0xea6db0, [0x3], bit2)) == 0 && ptr(0xea6db0, [0x3], bit2) == 1 && SaveProtection()
)

achievement(
    title = "Arte", points = 5,
    description = "Max out Kirie's affection",
    id = 449090, badge = "555735", published = "7/16/2024 3:19:52 PM", modified = "2/6/2025 4:31:55 PM",
    trigger = prev(ptr(0xea6db0, [0x3], bit7)) == 0 && ptr(0xea6db0, [0x3], bit7) == 1 && SaveProtection()
)

achievement(
    title = "Rock 'N' Roll", points = 5,
    description = "Max out Aya's affection",
    id = 449091, badge = "555736", published = "7/16/2024 3:19:52 PM", modified = "2/6/2025 4:31:56 PM",
    trigger = prev(ptr(0xea6db0, [0x5], bit1)) == 0 && ptr(0xea6db0, [0x5], bit1) == 1 && SaveProtection()
)

achievement(
    title = "Nothing Stronger than Family", points = 5,
    description = "Max out Jo's affection",
    id = 449092, badge = "555737", published = "7/16/2024 3:19:53 PM", modified = "7/26/2025 5:20:20 PM",
    trigger = prev(ptr(0xea6db0, [0x4], bit4)) == 0 && ptr(0xea6db0, [0x4], bit4) == 1 && SaveProtection()
)

achievement(
    title = "Koi no Disco Queen", points = 5,
    description = "Max out Yurika's affection",
    id = 449093, badge = "555738", published = "7/16/2024 3:19:53 PM", modified = "2/6/2025 4:31:57 PM",
    trigger = prev(ptr(0xea6db0, [0x6], bit3)) == 0 && ptr(0xea6db0, [0x6], bit3) == 1 && SaveProtection()
)

achievement(
    title = "Lighting Reflexes", points = 10,
    description = "Earn 10k chips in Speed",
    id = 431684, badge = "555723", published = "5/27/2024 4:39:29 PM", modified = "2/6/2025 4:31:58 PM",
    trigger = prev(word(0xEA2660)) < 10000 && word(0xEA2660) == 10000 && SaveProtection()
)

achievement(
    title = "Double Down", points = 10,
    description = "Earn 10k chips in Blackjack",
    id = 431685, badge = "555724", published = "5/27/2024 4:39:30 PM", modified = "5/30/2025 4:16:34 AM",
    trigger = prev(word(0xEA265C)) < 10000 && word(0xEA265C) == 10000 && SaveProtection()
)

achievement(
    title = "Texas Hold'em", points = 10,
    description = "Earn 10k chips in Poker",
    id = 431686, badge = "555725", published = "5/27/2024 4:39:30 PM", modified = "2/6/2025 4:31:59 PM",
    trigger = prev(word(0xEA2664)) < 10000 && word(0xEA2664) == 10000 && SaveProtection()
)

achievement(
    title = "Casino Solitaire", points = 10,
    description = "Earn 10k chips in Free Cell",
    id = 431687, badge = "555726", published = "5/27/2024 4:39:30 PM", modified = "2/6/2025 4:31:59 PM",
    trigger = prev(word(0xEA2662)) < 10000 && word(0xEA2662) == 10000 && SaveProtection()
)

achievement(
    title = "33%", points = 10,
    description = "Earn 10k chips in Baccarat",
    id = 431688, badge = "555727", published = "5/27/2024 4:39:31 PM", modified = "2/6/2025 4:32:00 PM",
    trigger = prev(word(0xEA265E)) < 10000 && word(0xEA265E) == 10000 && SaveProtection()
)

achievement(
    title = "Against All Odds", points = 10,
    description = "Clear Kumite Challenge I",
    id = 464712, badge = "556277", published = "9/19/2024 1:52:11 PM", modified = "2/6/2025 4:32:00 PM",
    trigger = prev(bit7(0xEA9834)) == 0 && bit7(0xEA9834) == 1 && SaveProtection()
)

achievement(
    title = "1 vs. 24", points = 10,
    description = "Clear Kumite Challenge II",
    id = 464713, badge = "556278", published = "9/19/2024 1:52:12 PM", modified = "7/26/2025 5:15:33 PM",
    trigger = prev(bit0(0xEA9835)) == 0 && bit0(0xEA9835) == 1 && SaveProtection()
)

achievement(
    title = "One Man Army", points = 25,
    description = "Clear Kumite Challenge III",
    id = 464714, badge = "556279", published = "9/19/2024 1:52:12 PM", modified = "2/6/2025 4:32:01 PM",
    trigger = prev(bit1(0xEA9835)) == 0 && bit1(0xEA9835) == 1 && SaveProtection()
)

achievement(
    title = "Sandbagger", points = 10,
    description = "Get a perfect game on Bowling",
    id = 431690, badge = "555728", published = "5/27/2024 5:14:47 PM", modified = "2/6/2025 4:32:02 PM",
    trigger = prev(bit1(0xEA2666)) == 0 && bit1(0xEA2666) == 1 && SaveProtection()
)

achievement(
    title = "Claw, Kick, Claw, Kick", points = 3,
    description = "Collect every animal in the UFO Catcher",
    id = 431692, badge = "555729", published = "5/27/2024 5:14:48 PM", modified = "2/7/2025 5:28:42 PM",
    trigger = prev(bit2(0xEA2666)) == 0 && bit2(0xEA2666) == 1 && SaveProtection()
)

achievement(
    title = "Parry Addiction", points = 10,
    description = "Successfully land a Counter 100 times",
    id = 452947, badge = "556483", published = "8/3/2024 4:24:59 PM", modified = "2/6/2025 4:32:03 PM",
    trigger = prev(word(0xEA2678)) < 100 && measured(word(0xEA2678) >= 100) && SaveProtection()
)

achievement(
    title = "Shoulder Roll", points = 10,
    description = "Successfully Auto Step (dodge) 100 times",
    id = 452948, badge = "556484", published = "8/3/2024 4:26:57 PM", modified = "2/6/2025 4:32:03 PM",
    trigger = prev(word(0xEA2676)) < 100 && measured(word(0xEA2676) >= 100) && SaveProtection()
)

achievement(
    title = "101 Dalmatians", points = 10,
    description = "Rescue all of the 101 cats",
    id = 452951, badge = "555753", published = "8/3/2024 4:35:33 PM", modified = "2/6/2025 4:32:04 PM",
    trigger = prev(byte(0xEA2525)) == 100 && measured(byte(0xEA2525) == 101) && SaveProtection()
)

achievement(
    title = "One on One", points = 2,
    description = "Clear all the level 1 Co-Op Challenges",
    id = 464734, badge = "556491", published = "9/19/2024 5:36:51 PM", modified = "2/7/2025 5:29:01 PM",
    trigger = (prev(byte(0xEA1BE9)) + prev(byte(0xEA1C05)) + prev(byte(0xEA1C21)) + prev(byte(0xEA1C3D)) +
              prev(byte(0xEA1C59)) + prev(byte(0xEA1C75)) + prev(byte(0xEA1C91)) + prev(byte(0xEA1CAD)) +
              prev(byte(0xEA1CC9))) == 8 &&
              measured((byte(0xEA1BE9) + byte(0xEA1C05) + byte(0xEA1C21) + byte(0xEA1C3D) + byte(0xEA1C59) +
                  byte(0xEA1C75) + byte(0xEA1C91) + byte(0xEA1CAD) + byte(0xEA1CC9)) == 9
              ) && SaveProtection()
)

achievement(
    title = "Virtual Insanity", points = 5,
    description = "Clear all the level 3 Co-Op challenges",
    id = 464735, badge = "556485", published = "9/19/2024 5:36:52 PM", modified = "2/7/2025 5:29:10 PM",
    trigger = (prev(byte(0xEA1DFD)) + prev(byte(0xEA1E19)) + prev(byte(0xEA1E35)) + prev(byte(0xEA1E51)) +
              prev(byte(0xEA1E6D)) + prev(byte(0xEA1E89)) + prev(byte(0xEA1EA5)) + prev(byte(0xEA1EC1)) +
              prev(byte(0xEA1EDD))) == 8 &&
              measured((byte(0xEA1DFD) + byte(0xEA1E19) + byte(0xEA1E35) + byte(0xEA1E51) + byte(0xEA1E6D) +
                  byte(0xEA1E89) + byte(0xEA1EA5) + byte(0xEA1EC1) + byte(0xEA1EDD)) == 9)
              && SaveProtection()
)

achievement(
    title = "Your Knife Feels Good", points = 25,
    description = "Clear all of the level 5 Co-Op missions",
    id = 464736, badge = "556486", published = "9/19/2024 5:36:52 PM", modified = "8/11/2025 7:03:33 PM",
    trigger = (prev(byte(0xEA2011)) + prev(byte(0xEA202D)) + prev(byte(0xEA2049)) + prev(byte(0xEA2065)) +
              prev(byte(0xEA2081)) + prev(byte(0xEA209D)) + prev(byte(0xEA20B9)) + prev(byte(0xEA20D5)) +
              prev(byte(0xEA20F1)) + prev(byte(0xEA210D)) + prev(byte(0xEA2129)) + prev(byte(0xEA2145))) == 11 &&
              measured((byte(0xEA2011) + byte(0xEA202D) + byte(0xEA2049) + byte(0xEA2065) + byte(0xEA2081) +
                  byte(0xEA209D) + byte(0xEA20B9) + byte(0xEA20D5) + byte(0xEA20F1) + byte(0xEA210D) + byte(0xEA2129) +
                  byte(0xEA2145)) == 12
              ) && SaveProtection()
)

achievement(
    title = "There's Not Even Gonna Be a Fight!", points = 3,
    description = "Defeat an enemy in 3 seconds or less",
    id = 464741, badge = "556275", published = "9/19/2024 6:51:50 PM", modified = "2/6/2025 4:32:06 PM",
    trigger = prev(bit3(0xEA6DEF)) == 0 && bit3(0xEA6DEF) == 1 && SaveProtection()
)

achievement(
    title = "I'm Still Standing", points = 25, type="missable",
    description = "Beat the game without retrying",
    id = 458368, badge = "555754", published = "8/24/2024 3:27:59 PM", modified = "4/27/2025 4:25:51 PM",
    trigger = SawShinjouCutscene() && InGame() && word(0xEA266C) == 0 && word(0xEA2794) == 10011
)

achievement(
    title = "Feel the Heat", points = 25, type="missable",
    description = "Perform every Heat Action",
    id = 433799, badge = "556274", published = "6/1/2024 4:32:56 PM", modified = "8/3/2025 4:39:45 PM",
    trigger = (prev(word(0xEA2534)) / prev(word(0xEA2534)) + prev(word(0xEA2536)) / prev(word(0xEA2536)) +
              prev(word(0xEA2538)) / prev(word(0xEA2538)) + prev(word(0xEA253A)) / prev(word(0xEA253A)) +
              prev(word(0xEA253C)) / prev(word(0xEA253C)) + prev(word(0xEA253E)) / prev(word(0xEA253E)) +
              prev(word(0xEA2540)) / prev(word(0xEA2540)) + prev(word(0xEA2542)) / prev(word(0xEA2542)) +
              prev(word(0xEA2544)) / prev(word(0xEA2544)) + prev(word(0xEA2546)) / prev(word(0xEA2546)) +
              prev(word(0xEA2548)) / prev(word(0xEA2548)) + prev(word(0xEA254A)) / prev(word(0xEA254A)) +
              prev(word(0xEA254C)) / prev(word(0xEA254C)) + prev(word(0xEA254E)) / prev(word(0xEA254E)) +
              prev(word(0xEA2550)) / prev(word(0xEA2550)) + prev(word(0xEA2552)) / prev(word(0xEA2552)) +
              prev(word(0xEA2554)) / prev(word(0xEA2554)) + prev(word(0xEA2556)) / prev(word(0xEA2556)) +
              prev(word(0xEA2558)) / prev(word(0xEA2558)) + prev(word(0xEA255A)) / prev(word(0xEA255A)) +
              prev(word(0xEA255C)) / prev(word(0xEA255C)) + prev(word(0xEA255E)) / prev(word(0xEA255E)) +
              prev(word(0xEA2560)) / prev(word(0xEA2560)) + prev(word(0xEA2562)) / prev(word(0xEA2562)) +
              prev(word(0xEA2564)) / prev(word(0xEA2564)) + prev(word(0xEA2566)) / prev(word(0xEA2566)) +
              prev(word(0xEA2568)) / prev(word(0xEA2568)) + prev(word(0xEA256A)) / prev(word(0xEA256A)) +
              prev(word(0xEA256C)) / prev(word(0xEA256C)) + prev(word(0xEA256E)) / prev(word(0xEA256E)) +
              prev(word(0xEA2570)) / prev(word(0xEA2570)) + prev(word(0xEA2572)) / prev(word(0xEA2572)) +
              prev(word(0xEA2574)) / prev(word(0xEA2574)) + prev(word(0xEA2576)) / prev(word(0xEA2576)) +
              prev(word(0xEA2578)) / prev(word(0xEA2578)) + prev(word(0xEA257A)) / prev(word(0xEA257A)) +
              prev(word(0xEA257C)) / prev(word(0xEA257C)) + prev(word(0xEA257E)) / prev(word(0xEA257E)) +
              prev(word(0xEA2580)) / prev(word(0xEA2580)) + prev(word(0xEA2582)) / prev(word(0xEA2582)) +
              prev(word(0xEA2584)) / prev(word(0xEA2584)) + prev(word(0xEA2586)) / prev(word(0xEA2586)) +
              prev(word(0xEA2588)) / prev(word(0xEA2588)) + prev(word(0xEA258A)) / prev(word(0xEA258A)) +
              prev(word(0xEA258C)) / prev(word(0xEA258C)) + prev(word(0xEA258E)) / prev(word(0xEA258E)) +
              prev(word(0xEA2590)) / prev(word(0xEA2590)) + prev(word(0xEA2592)) / prev(word(0xEA2592)) +
              prev(word(0xEA2594)) / prev(word(0xEA2594)) + prev(word(0xEA2596)) / prev(word(0xEA2596)) +
              prev(word(0xEA2598)) / prev(word(0xEA2598)) + prev(word(0xEA259A)) / prev(word(0xEA259A)) +
              prev(word(0xEA259C)) / prev(word(0xEA259C)) + prev(word(0xEA259E)) / prev(word(0xEA259E)) +
              prev(word(0xEA25A0)) / prev(word(0xEA25A0)) + prev(word(0xEA25A2)) / prev(word(0xEA25A2)) +
              prev(word(0xEA25A4)) / prev(word(0xEA25A4)) + prev(word(0xEA25A6)) / prev(word(0xEA25A6)) +
              prev(word(0xEA25A8)) / prev(word(0xEA25A8))) == 58 &&
              measured((word(0xEA2534) / word(0xEA2534) + word(0xEA2536) / word(0xEA2536) + word(0xEA2538) /
                  word(0xEA2538) + word(0xEA253A) / word(0xEA253A) + word(0xEA253C) / word(0xEA253C) + word(0xEA253E) /
                  word(0xEA253E) + word(0xEA2540) / word(0xEA2540) + word(0xEA2542) / word(0xEA2542) + word(0xEA2544) /
                  word(0xEA2544) + word(0xEA2546) / word(0xEA2546) + word(0xEA2548) / word(0xEA2548) + word(0xEA254A) /
                  word(0xEA254A) + word(0xEA254C) / word(0xEA254C) + word(0xEA254E) / word(0xEA254E) + word(0xEA2550) /
                  word(0xEA2550) + word(0xEA2552) / word(0xEA2552) + word(0xEA2554) / word(0xEA2554) + word(0xEA2556) /
                  word(0xEA2556) + word(0xEA2558) / word(0xEA2558) + word(0xEA255A) / word(0xEA255A) + word(0xEA255C) /
                  word(0xEA255C) + word(0xEA255E) / word(0xEA255E) + word(0xEA2560) / word(0xEA2560) + word(0xEA2562) /
                  word(0xEA2562) + word(0xEA2564) / word(0xEA2564) + word(0xEA2566) / word(0xEA2566) + word(0xEA2568) /
                  word(0xEA2568) + word(0xEA256A) / word(0xEA256A) + word(0xEA256C) / word(0xEA256C) + word(0xEA256E) /
                  word(0xEA256E) + word(0xEA2570) / word(0xEA2570) + word(0xEA2572) / word(0xEA2572) + word(0xEA2574) /
                  word(0xEA2574) + word(0xEA2576) / word(0xEA2576) + word(0xEA2578) / word(0xEA2578) + word(0xEA257A) /
                  word(0xEA257A) + word(0xEA257C) / word(0xEA257C) + word(0xEA257E) / word(0xEA257E) + word(0xEA2580) /
                  word(0xEA2580) + word(0xEA2582) / word(0xEA2582) + word(0xEA2584) / word(0xEA2584) + word(0xEA2586) /
                  word(0xEA2586) + word(0xEA2588) / word(0xEA2588) + word(0xEA258A) / word(0xEA258A) + word(0xEA258C) /
                  word(0xEA258C) + word(0xEA258E) / word(0xEA258E) + word(0xEA2590) / word(0xEA2590) + word(0xEA2592) /
                  word(0xEA2592) + word(0xEA2594) / word(0xEA2594) + word(0xEA2596) / word(0xEA2596) + word(0xEA2598) /
                  word(0xEA2598) + word(0xEA259A) / word(0xEA259A) + word(0xEA259C) / word(0xEA259C) + word(0xEA259E) /
                  word(0xEA259E) + word(0xEA25A0) / word(0xEA25A0) + word(0xEA25A2) / word(0xEA25A2) + word(0xEA25A4) /
                  word(0xEA25A4) + word(0xEA25A6) / word(0xEA25A6) + word(0xEA25A8) / word(0xEA25A8)) == 59
              )
)

achievement(
    title = "High Five!", points = 10, type="missable",
    description = "Perform every Tag Team heat action",
    id = 445436, badge = "555731", published = "7/4/2024 8:09:47 AM", modified = "8/1/2025 4:29:49 PM",
    trigger = measured((word(0xEA2534) / 4001 + word(0xEA2536) / 4001 + word(0xEA2538) / 4001 + word(0xEA253A) / 4001 +
                  word(0xEA253C) / 4001 + word(0xEA253E) / 4001 + word(0xEA2540) / 4001 + word(0xEA2542) / 4001 +
                  word(0xEA2544) / 4001 + word(0xEA2546) / 4001 + word(0xEA2548) / 4001 + word(0xEA254A) / 4001 +
                  word(0xEA254C) / 4001 + word(0xEA254E) / 4001 + word(0xEA2550) / 4001 + word(0xEA2552) / 4001 +
                  word(0xEA2554) / 4001 + word(0xEA2556) / 4001 + word(0xEA2558) / 4001 + word(0xEA255A) / 4001 +
                  word(0xEA255C) / 4001 + word(0xEA255E) / 4001 + word(0xEA2560) / 4001 + word(0xEA2562) / 4001 +
                  word(0xEA2564) / 4001 + word(0xEA2566) / 4001 + word(0xEA2568) / 4001 + word(0xEA256A) / 4001 +
                  word(0xEA256C) / 4001 + word(0xEA256E) / 4001 + word(0xEA2570) / 4001 + word(0xEA2572) / 4001 +
                  word(0xEA2574) / 4001 + word(0xEA2576) / 4001 + word(0xEA2578) / 4001 + word(0xEA257A) / 4001 +
                  word(0xEA257C) / 4001 + word(0xEA257E) / 4001 + word(0xEA2580) / 4001 + word(0xEA2582) / 4001 +
                  word(0xEA2584) / 4001 + word(0xEA2586) / 4001 + word(0xEA2588) / 4001 + word(0xEA258A) / 4001 +
                  word(0xEA258C) / 4001 + word(0xEA258E) / 4001 + word(0xEA2590) / 4001 + word(0xEA2592) / 4001 +
                  word(0xEA2594) / 4001 + word(0xEA2596) / 4001 + word(0xEA2598) / 4001 + word(0xEA259A) / 4001 +
                  word(0xEA259C) / 4001 + word(0xEA259E) / 4001 + word(0xEA25A0) / 4001 + word(0xEA25A2) / 4001 +
                  word(0xEA25A4) / 4001 + word(0xEA25A6) / 4001 + word(0xEA25A8) / 4001) == 5
              ) && byte(0x14D111C) != 21 &&
              (((prev(word(0xEA2534)) != 4001 && prev(word(0xEA2536)) != 4001 && prev(word(0xEA2538)) != 4001 &&
                    prev(word(0xEA253A)) != 4001 && prev(word(0xEA253C)) != 4001 && prev(word(0xEA253E)) != 4001 &&
                    prev(word(0xEA2540)) != 4001 && prev(word(0xEA2542)) != 4001 && prev(word(0xEA2544)) != 4001 &&
                    prev(word(0xEA2546)) != 4001 && prev(word(0xEA2548)) != 4001 && prev(word(0xEA254A)) != 4001 &&
                    prev(word(0xEA254C)) != 4001 && prev(word(0xEA254E)) != 4001 && prev(word(0xEA2550)) != 4001 &&
                    prev(word(0xEA2552)) != 4001 && prev(word(0xEA2554)) != 4001 && prev(word(0xEA2556)) != 4001 &&
                    prev(word(0xEA2558)) != 4001 && prev(word(0xEA255A)) != 4001 && prev(word(0xEA255C)) != 4001 &&
                    prev(word(0xEA255E)) != 4001 && prev(word(0xEA2560)) != 4001 && prev(word(0xEA2562)) != 4001 &&
                    prev(word(0xEA2564)) != 4001 && prev(word(0xEA2566)) != 4001 && prev(word(0xEA2568)) != 4001 &&
                    prev(word(0xEA256A)) != 4001 && prev(word(0xEA256C)) != 4001 && prev(word(0xEA256E)) != 4001 &&
                    prev(word(0xEA2570)) != 4001 && prev(word(0xEA2572)) != 4001 && prev(word(0xEA2574)) != 4001 &&
                    prev(word(0xEA2576)) != 4001 && prev(word(0xEA2578)) != 4001 && prev(word(0xEA257A)) != 4001 &&
                    prev(word(0xEA257C)) != 4001 && prev(word(0xEA257E)) != 4001 && prev(word(0xEA2580)) != 4001 &&
                    prev(word(0xEA2582)) != 4001 && prev(word(0xEA2584)) != 4001 && prev(word(0xEA2586)) != 4001 &&
                    prev(word(0xEA2588)) != 4001 && prev(word(0xEA258A)) != 4001 && prev(word(0xEA258C)) != 4001 &&
                    prev(word(0xEA258E)) != 4001 && prev(word(0xEA2590)) != 4001 && prev(word(0xEA2592)) != 4001 &&
                    prev(word(0xEA2594)) != 4001 && prev(word(0xEA2596)) != 4001 && prev(word(0xEA2598)) != 4001 &&
                    prev(word(0xEA259A)) != 4001 && prev(word(0xEA259C)) != 4001 && prev(word(0xEA259E)) != 4001 &&
                    prev(word(0xEA25A0)) != 4001 && prev(word(0xEA25A2)) != 4001 && prev(word(0xEA25A4)) != 4001 &&
                    prev(word(0xEA25A6)) != 4001 && prev(word(0xEA25A8)) != 4001
                )) ||
               ((prev(word(0xEA2534)) != 4002 && prev(word(0xEA2536)) != 4002 && prev(word(0xEA2538)) != 4002 &&
                    prev(word(0xEA253A)) != 4002 && prev(word(0xEA253C)) != 4002 && prev(word(0xEA253E)) != 4002 &&
                    prev(word(0xEA2540)) != 4002 && prev(word(0xEA2542)) != 4002 && prev(word(0xEA2544)) != 4002 &&
                    prev(word(0xEA2546)) != 4002 && prev(word(0xEA2548)) != 4002 && prev(word(0xEA254A)) != 4002 &&
                    prev(word(0xEA254C)) != 4002 && prev(word(0xEA254E)) != 4002 && prev(word(0xEA2550)) != 4002 &&
                    prev(word(0xEA2552)) != 4002 && prev(word(0xEA2554)) != 4002 && prev(word(0xEA2556)) != 4002 &&
                    prev(word(0xEA2558)) != 4002 && prev(word(0xEA255A)) != 4002 && prev(word(0xEA255C)) != 4002 &&
                    prev(word(0xEA255E)) != 4002 && prev(word(0xEA2560)) != 4002 && prev(word(0xEA2562)) != 4002 &&
                    prev(word(0xEA2564)) != 4002 && prev(word(0xEA2566)) != 4002 && prev(word(0xEA2568)) != 4002 &&
                    prev(word(0xEA256A)) != 4002 && prev(word(0xEA256C)) != 4002 && prev(word(0xEA256E)) != 4002 &&
                    prev(word(0xEA2570)) != 4002 && prev(word(0xEA2572)) != 4002 && prev(word(0xEA2574)) != 4002 &&
                    prev(word(0xEA2576)) != 4002 && prev(word(0xEA2578)) != 4002 && prev(word(0xEA257A)) != 4002 &&
                    prev(word(0xEA257C)) != 4002 && prev(word(0xEA257E)) != 4002 && prev(word(0xEA2580)) != 4002 &&
                    prev(word(0xEA2582)) != 4002 && prev(word(0xEA2584)) != 4002 && prev(word(0xEA2586)) != 4002 &&
                    prev(word(0xEA2588)) != 4002 && prev(word(0xEA258A)) != 4002 && prev(word(0xEA258C)) != 4002 &&
                    prev(word(0xEA258E)) != 4002 && prev(word(0xEA2590)) != 4002 && prev(word(0xEA2592)) != 4002 &&
                    prev(word(0xEA2594)) != 4002 && prev(word(0xEA2596)) != 4002 && prev(word(0xEA2598)) != 4002 &&
                    prev(word(0xEA259A)) != 4002 && prev(word(0xEA259C)) != 4002 && prev(word(0xEA259E)) != 4002 &&
                    prev(word(0xEA25A0)) != 4002 && prev(word(0xEA25A2)) != 4002 && prev(word(0xEA25A4)) != 4002 &&
                    prev(word(0xEA25A6)) != 4002 && prev(word(0xEA25A8)) != 4002
                )) ||
               ((prev(word(0xEA2534)) != 4003 && prev(word(0xEA2536)) != 4003 && prev(word(0xEA2538)) != 4003 &&
                    prev(word(0xEA253A)) != 4003 && prev(word(0xEA253C)) != 4003 && prev(word(0xEA253E)) != 4003 &&
                    prev(word(0xEA2540)) != 4003 && prev(word(0xEA2542)) != 4003 && prev(word(0xEA2544)) != 4003 &&
                    prev(word(0xEA2546)) != 4003 && prev(word(0xEA2548)) != 4003 && prev(word(0xEA254A)) != 4003 &&
                    prev(word(0xEA254C)) != 4003 && prev(word(0xEA254E)) != 4003 && prev(word(0xEA2550)) != 4003 &&
                    prev(word(0xEA2552)) != 4003 && prev(word(0xEA2554)) != 4003 && prev(word(0xEA2556)) != 4003 &&
                    prev(word(0xEA2558)) != 4003 && prev(word(0xEA255A)) != 4003 && prev(word(0xEA255C)) != 4003 &&
                    prev(word(0xEA255E)) != 4003 && prev(word(0xEA2560)) != 4003 && prev(word(0xEA2562)) != 4003 &&
                    prev(word(0xEA2564)) != 4003 && prev(word(0xEA2566)) != 4003 && prev(word(0xEA2568)) != 4003 &&
                    prev(word(0xEA256A)) != 4003 && prev(word(0xEA256C)) != 4003 && prev(word(0xEA256E)) != 4003 &&
                    prev(word(0xEA2570)) != 4003 && prev(word(0xEA2572)) != 4003 && prev(word(0xEA2574)) != 4003 &&
                    prev(word(0xEA2576)) != 4003 && prev(word(0xEA2578)) != 4003 && prev(word(0xEA257A)) != 4003 &&
                    prev(word(0xEA257C)) != 4003 && prev(word(0xEA257E)) != 4003 && prev(word(0xEA2580)) != 4003 &&
                    prev(word(0xEA2582)) != 4003 && prev(word(0xEA2584)) != 4003 && prev(word(0xEA2586)) != 4003 &&
                    prev(word(0xEA2588)) != 4003 && prev(word(0xEA258A)) != 4003 && prev(word(0xEA258C)) != 4003 &&
                    prev(word(0xEA258E)) != 4003 && prev(word(0xEA2590)) != 4003 && prev(word(0xEA2592)) != 4003 &&
                    prev(word(0xEA2594)) != 4003 && prev(word(0xEA2596)) != 4003 && prev(word(0xEA2598)) != 4003 &&
                    prev(word(0xEA259A)) != 4003 && prev(word(0xEA259C)) != 4003 && prev(word(0xEA259E)) != 4003 &&
                    prev(word(0xEA25A0)) != 4003 && prev(word(0xEA25A2)) != 4003 && prev(word(0xEA25A4)) != 4003 &&
                    prev(word(0xEA25A6)) != 4003 && prev(word(0xEA25A8)) != 4003
                )) ||
               ((prev(word(0xEA2534)) != 4004 && prev(word(0xEA2536)) != 4004 && prev(word(0xEA2538)) != 4004 &&
                    prev(word(0xEA253A)) != 4004 && prev(word(0xEA253C)) != 4004 && prev(word(0xEA253E)) != 4004 &&
                    prev(word(0xEA2540)) != 4004 && prev(word(0xEA2542)) != 4004 && prev(word(0xEA2544)) != 4004 &&
                    prev(word(0xEA2546)) != 4004 && prev(word(0xEA2548)) != 4004 && prev(word(0xEA254A)) != 4004 &&
                    prev(word(0xEA254C)) != 4004 && prev(word(0xEA254E)) != 4004 && prev(word(0xEA2550)) != 4004 &&
                    prev(word(0xEA2552)) != 4004 && prev(word(0xEA2554)) != 4004 && prev(word(0xEA2556)) != 4004 &&
                    prev(word(0xEA2558)) != 4004 && prev(word(0xEA255A)) != 4004 && prev(word(0xEA255C)) != 4004 &&
                    prev(word(0xEA255E)) != 4004 && prev(word(0xEA2560)) != 4004 && prev(word(0xEA2562)) != 4004 &&
                    prev(word(0xEA2564)) != 4004 && prev(word(0xEA2566)) != 4004 && prev(word(0xEA2568)) != 4004 &&
                    prev(word(0xEA256A)) != 4004 && prev(word(0xEA256C)) != 4004 && prev(word(0xEA256E)) != 4004 &&
                    prev(word(0xEA2570)) != 4004 && prev(word(0xEA2572)) != 4004 && prev(word(0xEA2574)) != 4004 &&
                    prev(word(0xEA2576)) != 4004 && prev(word(0xEA2578)) != 4004 && prev(word(0xEA257A)) != 4004 &&
                    prev(word(0xEA257C)) != 4004 && prev(word(0xEA257E)) != 4004 && prev(word(0xEA2580)) != 4004 &&
                    prev(word(0xEA2582)) != 4004 && prev(word(0xEA2584)) != 4004 && prev(word(0xEA2586)) != 4004 &&
                    prev(word(0xEA2588)) != 4004 && prev(word(0xEA258A)) != 4004 && prev(word(0xEA258C)) != 4004 &&
                    prev(word(0xEA258E)) != 4004 && prev(word(0xEA2590)) != 4004 && prev(word(0xEA2592)) != 4004 &&
                    prev(word(0xEA2594)) != 4004 && prev(word(0xEA2596)) != 4004 && prev(word(0xEA2598)) != 4004 &&
                    prev(word(0xEA259A)) != 4004 && prev(word(0xEA259C)) != 4004 && prev(word(0xEA259E)) != 4004 &&
                    prev(word(0xEA25A0)) != 4004 && prev(word(0xEA25A2)) != 4004 && prev(word(0xEA25A4)) != 4004 &&
                    prev(word(0xEA25A6)) != 4004 && prev(word(0xEA25A8)) != 4004
                )) ||
               ((prev(word(0xEA2534)) != 4005 && prev(word(0xEA2536)) != 4005 && prev(word(0xEA2538)) != 4005 &&
                    prev(word(0xEA253A)) != 4005 && prev(word(0xEA253C)) != 4005 && prev(word(0xEA253E)) != 4005 &&
                    prev(word(0xEA2540)) != 4005 && prev(word(0xEA2542)) != 4005 && prev(word(0xEA2544)) != 4005 &&
                    prev(word(0xEA2546)) != 4005 && prev(word(0xEA2548)) != 4005 && prev(word(0xEA254A)) != 4005 &&
                    prev(word(0xEA254C)) != 4005 && prev(word(0xEA254E)) != 4005 && prev(word(0xEA2550)) != 4005 &&
                    prev(word(0xEA2552)) != 4005 && prev(word(0xEA2554)) != 4005 && prev(word(0xEA2556)) != 4005 &&
                    prev(word(0xEA2558)) != 4005 && prev(word(0xEA255A)) != 4005 && prev(word(0xEA255C)) != 4005 &&
                    prev(word(0xEA255E)) != 4005 && prev(word(0xEA2560)) != 4005 && prev(word(0xEA2562)) != 4005 &&
                    prev(word(0xEA2564)) != 4005 && prev(word(0xEA2566)) != 4005 && prev(word(0xEA2568)) != 4005 &&
                    prev(word(0xEA256A)) != 4005 && prev(word(0xEA256C)) != 4005 && prev(word(0xEA256E)) != 4005 &&
                    prev(word(0xEA2570)) != 4005 && prev(word(0xEA2572)) != 4005 && prev(word(0xEA2574)) != 4005 &&
                    prev(word(0xEA2576)) != 4005 && prev(word(0xEA2578)) != 4005 && prev(word(0xEA257A)) != 4005 &&
                    prev(word(0xEA257C)) != 4005 && prev(word(0xEA257E)) != 4005 && prev(word(0xEA2580)) != 4005 &&
                    prev(word(0xEA2582)) != 4005 && prev(word(0xEA2584)) != 4005 && prev(word(0xEA2586)) != 4005 &&
                    prev(word(0xEA2588)) != 4005 && prev(word(0xEA258A)) != 4005 && prev(word(0xEA258C)) != 4005 &&
                    prev(word(0xEA258E)) != 4005 && prev(word(0xEA2590)) != 4005 && prev(word(0xEA2592)) != 4005 &&
                    prev(word(0xEA2594)) != 4005 && prev(word(0xEA2596)) != 4005 && prev(word(0xEA2598)) != 4005 &&
                    prev(word(0xEA259A)) != 4005 && prev(word(0xEA259C)) != 4005 && prev(word(0xEA259E)) != 4005 &&
                    prev(word(0xEA25A0)) != 4005 && prev(word(0xEA25A2)) != 4005 && prev(word(0xEA25A4)) != 4005 &&
                    prev(word(0xEA25A6)) != 4005 && prev(word(0xEA25A8)) != 4005
                )))
)

achievement(
    title = "My Fingers Hurt!", points = 10,
    description = "Get a score of over 200 at karaoke 10 times",
    id = 444554, badge = "555730", published = "7/2/2024 9:17:17 AM", modified = "2/6/2025 4:32:08 PM",
    trigger = prev(byte(0xEA9829)) < 10 && byte(0xEA9829) == 10 && SaveProtection()
)

achievement(
    title = "Knowing Is Not Enough", points = 10,
    description = "Learn every Punch and Kick KO Strikes",
    id = 464791, badge = "557335", published = "9/20/2024 3:40:42 PM", modified = "2/6/2025 4:32:08 PM",
    trigger = (prev(bit1(0xE9EA92)) + prev(bit2(0xE9EA92)) + prev(bit3(0xE9EA92)) + prev(bit4(0xE9EA92)) +
              prev(bit5(0xE9EA92)) + prev(bit6(0xE9EA92)) + prev(bit7(0xE9EA92)) + prev(bitcount(0xE9EA93)) +
              prev(bit0(0xE9EA94)) + prev(bit1(0xE9EA94)) + prev(bit2(0xE9EA94)) + prev(bit3(0xE9EA94)) +
              prev(bit4(0xE9EA94)) + prev(bit6(0xE9EA94)) + prev(bit7(0xE9EA94)) + prev(bitcount(0xE9EA95)) +
              prev(bitcount(0xE9EA96)) + prev(bit0(0xE9EA97)) + prev(bit1(0xE9EA97))) == 39 &&
              measured((bit1(0xE9EA92) + bit2(0xE9EA92) + bit3(0xE9EA92) + bit4(0xE9EA92) + bit5(0xE9EA92) +
                  bit6(0xE9EA92) + bit7(0xE9EA92) + bitcount(0xE9EA93) + bit0(0xE9EA94) + bit1(0xE9EA94) + bit2(0xE9EA94) +
                  bit3(0xE9EA94) + bit4(0xE9EA94) + bit6(0xE9EA94) + bit7(0xE9EA94) + bitcount(0xE9EA95) +
                  bitcount(0xE9EA96) + bit0(0xE9EA97) + bit1(0xE9EA97)) == 40
              ) && SaveProtection()
)

achievement(
    title = "Brotherly Fight", points = 3,
    description = "Defeat Tenma in the Kamurocho Special Battle Ranking. Only available in Premium Adventure.",
    id = 464792, badge = "556286", published = "9/20/2024 5:05:05 PM", modified = "7/31/2025 1:30:44 PM",
    trigger = (dword(0xEC2A78) != 0 && prev(float((dword(0xEC2A78) & 0x1FFFFFF) + 0x000038)) > 0.0) &&
              (dword(0xEC2A08) != 0 && float((dword(0xEC2A08) & 0x1FFFFFF) + 0x001C80) == 0.0) && byte(0xE9E9DA) != 0 &&
              once(bit0(0xF142A5) > prev(bit0(0xF142A5)) || word(0xEA266C) > prev(word(0xEA266C))) &&
              never(dword((dword(0xEC2A04) & 0x1FFFFFF) + 0x001C78) == 0.0) && word(0xEA2794) == 15112
)

achievement(
    title = "Fatal Battle", points = 25,
    description = "Reach the 1st rank in the Kamurocho Special Battle Ranking",
    id = 464793, badge = "556273", published = "9/20/2024 5:05:05 PM", modified = "3/10/2025 6:09:11 PM",
    trigger = prev(byte(0xEA1B0A)) == 0 && byte(0xEA1B0A) == 11 && SaveProtection()
)

achievement(
    title = "Am I Not Good Enough?", points = 2, type="missable",
    description = "Ask Taizan where's Saki",
    id = 422787, badge = "556490", published = "5/2/2024 5:54:58 PM", modified = "2/7/2025 10:46:30 AM",
    trigger = prev(ptr(0xea6db0, [0xC1], bit5)) == 0 && ptr(0xea6db0, [0xC1], bit5) == 1 && byte(0xEA22FC) == 8 && SaveProtection()
)

achievement(
    title = "Dead Souls", points = 10,
    description = "Defeat the Death Corps' leader",
    id = 449198, badge = "555739", published = "7/17/2024 4:43:12 PM", modified = "2/7/2025 10:46:31 AM",
    trigger = prev(ptr(0xea6db0, [0x9C], bit7)) == 0 && ptr(0xea6db0, [0x9C], bit7) == 1 && SaveProtection()
)

achievement(
    title = "Armor King", points = 5,
    description = "Learn Pro Wrestling",
    id = 449203, badge = "555744", published = "7/17/2024 5:15:36 PM", modified = "2/7/2025 10:46:31 AM",
    trigger = prev(bit2(0xE9EA34)) == 0 && bit2(0xE9EA34) == 1 && SaveProtection()
)

achievement(
    title = "Fallen Kingdom", points = 10,
    description = "Defeat Kingdom's leader and finish the gang substory-line",
    id = 449199, badge = "555740", published = "7/17/2024 4:43:12 PM", modified = "2/7/2025 10:46:32 AM",
    trigger = prev(ptr(0xea6db0, [0x9F], bit2)) == 0 && ptr(0xea6db0, [0x9F], bit2) == 1 && SaveProtection()
)

achievement(
    title = "DIS-truction", points = 5,
    description = "Defeat the DIS leader",
    id = 449201, badge = "555742", published = "7/17/2024 4:43:13 PM", modified = "2/7/2025 10:46:32 AM",
    trigger = prev(ptr(0xea6db0, [0x9A], bit3)) == 0 && ptr(0xea6db0, [0x9A], bit3) == 1 && SaveProtection()
)

achievement(
    title = "I Can See What You See Not", points = 4,
    description = "Defeat Diablo's leader",
    id = 449200, badge = "555741", published = "7/17/2024 4:43:13 PM", modified = "2/7/2025 10:46:33 AM",
    trigger = prev(ptr(0xea6db0, [0x9E], bit6)) == 0 && ptr(0xea6db0, [0x9E], bit6) == 1 && SaveProtection()
)

achievement(
    title = "God Roulette", points = 10,
    description = "Learn Extreme God Hand",
    id = 449204, badge = "555745", published = "7/17/2024 5:15:37 PM", modified = "2/7/2025 10:46:33 AM",
    trigger = prev(bit3(0xE9EA36)) == 0 && bit3(0xE9EA36) == 1 && SaveProtection()
)

achievement(
    title = "Eddy Gordo", points = 10,
    description = "Learn Extreme God Leg",
    id = 449205, badge = "555746", published = "7/17/2024 5:15:37 PM", modified = "2/7/2025 10:46:34 AM",
    trigger = prev(bit5(0xE9EA36)) == 0 && bit5(0xE9EA36) == 1 && SaveProtection()
)

achievement(
    title = "Vigour of the Mind", points = 10,
    description = "Learn Extreme Vigour",
    id = 449207, badge = "556287", published = "7/17/2024 5:15:38 PM", modified = "2/7/2025 10:46:34 AM",
    trigger = prev(bit5(0xE9EA37)) == 0 && bit5(0xE9EA37) == 1 && SaveProtection()
)

achievement(
    title = "As All Things Should Be", points = 10,
    description = "Learn Extreme Balance",
    id = 449206, badge = "556288", published = "7/17/2024 5:15:38 PM", modified = "2/7/2025 10:46:35 AM",
    trigger = prev(bit7(0xE9EA36)) == 0 && bit7(0xE9EA36) == 1 && SaveProtection()
)

achievement(
    title = "Awakened & Unleashed", points = 10,
    description = "Learn Extreme Awakening",
    id = 449208, badge = "556489", published = "7/17/2024 5:15:38 PM", modified = "2/7/2025 10:46:35 AM",
    trigger = prev(bit1(0xE9EA37)) == 0 && bit1(0xE9EA37) == 1 && SaveProtection()
)

achievement(
    title = "Dragon's Determination", points = 10,
    description = "Learn Extreme Tenacity",
    id = 449209, badge = "556292", published = "7/17/2024 5:15:39 PM", modified = "2/7/2025 10:46:36 AM",
    trigger = prev(bit3(0xE9EA37)) == 0 && bit3(0xE9EA37) == 1 && SaveProtection()
)

achievement(
    title = "Kiwami Means Extreme!", points = 25,
    description = "Learn Extreme Man",
    id = 449210, badge = "555748", published = "7/17/2024 5:15:39 PM", modified = "2/7/2025 10:46:36 AM",
    trigger = prev(bit7(0xE9EA37)) == 0 && bit7(0xE9EA37) == 1 && SaveProtection()
)

achievement(
    title = "#1 Fan", points = 5,
    description = "Collect every Trading Card",
    id = 432872, badge = "556289", published = "5/29/2024 4:23:34 PM", modified = "2/11/2025 3:54:44 PM",
    trigger = 
        (
            prev(ptr(0xea6db0, [0xB5], bit3)) +
            prev(ptr(0xea6db0, [0xB4], bit0)) +
            prev(ptr(0xea6db0, [0xB4], bit6)) +
            prev(ptr(0xea6db0, [0xB2], bit1)) +
            prev(ptr(0xea6db0, [0xB2], bit5)) +
            prev(ptr(0xea6db0, [0xB1], bit2))
        ) == 5 &&
        measured((
            ptr(0xea6db0, [0xB5], bit3) + 
            ptr(0xea6db0, [0xB4], bit0) + 
            ptr(0xea6db0, [0xB4], bit6) + 
            ptr(0xea6db0, [0xB2], bit1) + 
            ptr(0xea6db0, [0xB2], bit5) + 
            ptr(0xea6db0, [0xB1], bit2)) == 6
        ) && 
        SaveProtection()
)

achievement(
    title = "VOID", points = 0,
    description = "VOID",
    id = 495347, badge = "00000", published = "1/29/2025 5:49:30 PM", modified = "1/29/2025 5:49:30 PM",
    trigger = byte(0xE9E9DA) == 35
)

achievement(
    title = "Chick Magnet [scrapped]", points = 10,
    description = "Max out all 7 hostesses' affection",
    id = 449197, badge = "556488", published = "7/17/2024 4:10:09 PM", modified = "7/31/2025 5:17:24 PM",
    trigger = 
        (
            prev(ptr(0xea6db0, [0x2], bit5)) +
            prev(ptr(0xea6db0, [0x3], bit2)) +
            prev(ptr(0xea6db0, [0x3], bit7)) +
            prev(ptr(0xea6db0, [0x5], bit1)) +
            prev(ptr(0xea6db0, [0x5], bit6)) +
            prev(ptr(0xea6db0, [0x4], bit4)) +
            prev(ptr(0xea6db0, [0x6], bit3))
        ) == 6 &&
        measured((
            ptr(0xea6db0, [0x2], bit5) +
            ptr(0xea6db0, [0x3], bit2) +
            ptr(0xea6db0, [0x3], bit7) +
            ptr(0xea6db0, [0x5], bit1) +
            ptr(0xea6db0, [0x5], bit6) +
            ptr(0xea6db0, [0x4], bit4) +
            ptr(0xea6db0, [0x6], bit3)) == 7
        ) && 
        SaveProtection()
)

achievement(
    title = "Scrooge McDuck [scrapped, possible subset]", points = 10,
    description = "Spend 1 million Yen in Cabaret Clubs",
    id = 452944, badge = "555752", published = "8/3/2024 4:20:27 PM", modified = "6/9/2025 3:00:11 PM",
    trigger = prev(dword(0xEA2768)) < 1000000 && dword(0xEA2768) >= 1000000 && SaveProtection()
)

achievement(
    title = "Counting Cards [scrapped, possible subset]", points = 25,
    description = "Earn 500k chips in the Casino",
    id = 452932, badge = "555751", published = "8/3/2024 2:49:27 PM", modified = "6/9/2025 3:00:11 PM",
    trigger = prev(dword(0xEA1940)) < 500000 && dword(0xEA1940) >= 500000 && SaveProtection()
)

achievement(
    title = "Think Fast Chucklenuts [possible subset]", points = 10,
    description = "Get 15 Home Runs or more in a row",
    id = 431691, badge = "556276", published = "5/27/2024 5:14:48 PM", modified = "6/9/2025 3:00:11 PM",
    trigger = prev(bit0(0xEA2666)) == 0 && bit0(0xEA2666) == 1 && SaveProtection()
)

achievement(
    title = "Devil In A New Dress [possible subset]", points = 50,
    description = "S-rank every Co-Op mission",
    id = 463471, badge = "555765", published = "9/14/2024 3:40:30 PM", modified = "6/9/2025 3:00:11 PM",
    trigger = (prev(byte(0xEA1BE4)) / 3 + prev(byte(0xEA1C00)) / 3 + prev(byte(0xEA1C1C)) / 3 + prev(byte(0xEA1C38)) / 3
              + prev(byte(0xEA1C54)) / 3 + prev(byte(0xEA1C70)) / 3 + prev(byte(0xEA1C8C)) / 3 + prev(byte(0xEA1CA8)) /
              3 + prev(byte(0xEA1CC4)) / 3 + prev(byte(0xEA1CE0)) / 3 + prev(byte(0xEA1CFC)) / 3 + prev(byte(0xEA1D18))
              / 3 + prev(byte(0xEA1D34)) / 3 + prev(byte(0xEA1D50)) / 3 + prev(byte(0xEA1D6C)) / 3 +
              prev(byte(0xEA1D88)) / 3 + prev(byte(0xEA1DA4)) / 3 + prev(byte(0xEA1DC0)) / 3 + prev(byte(0xEA1DDC)) / 3
              + prev(byte(0xEA1DF8)) / 3 + prev(byte(0xEA1E14)) / 3 + prev(byte(0xEA1E30)) / 3 + prev(byte(0xEA1E4C)) /
              3 + prev(byte(0xEA1E68)) / 3 + prev(byte(0xEA1E84)) / 3 + prev(byte(0xEA1EA0)) / 3 + prev(byte(0xEA1EBC))
              / 3 + prev(byte(0xEA1ED8)) / 3 + prev(byte(0xEA1EF4)) / 3 + prev(byte(0xEA1F10)) / 3 +
              prev(byte(0xEA1F2C)) / 3 + prev(byte(0xEA1F48)) / 3 + prev(byte(0xEA1F64)) / 3 + prev(byte(0xEA1F80)) / 3
              + prev(byte(0xEA1F9C)) / 3 + prev(byte(0xEA1FB8)) / 3 + prev(byte(0xEA1FD4)) / 3 + prev(byte(0xEA1FF0)) /
              3 + prev(byte(0xEA200C)) / 3 + prev(byte(0xEA2028)) / 3 + prev(byte(0xEA2044)) / 3 + prev(byte(0xEA2060))
              / 3 + prev(byte(0xEA207C)) / 3 + prev(byte(0xEA2098)) / 3 + prev(byte(0xEA20B4)) / 3 +
              prev(byte(0xEA20D0)) / 3 + prev(byte(0xEA20EC)) / 3 + prev(byte(0xEA2108)) / 3 + prev(byte(0xEA2124)) / 3
              + prev(byte(0xEA2140)) / 3) == 49 &&
              measured((byte(0xEA1BE4) / 3 + byte(0xEA1C00) / 3 + byte(0xEA1C1C) / 3 + byte(0xEA1C38) / 3 +
                  byte(0xEA1C54) / 3 + byte(0xEA1C70) / 3 + byte(0xEA1C8C) / 3 + byte(0xEA1CA8) / 3 + byte(0xEA1CC4) / 3 +
                  byte(0xEA1CE0) / 3 + byte(0xEA1CFC) / 3 + byte(0xEA1D18) / 3 + byte(0xEA1D34) / 3 + byte(0xEA1D50) / 3 +
                  byte(0xEA1D6C) / 3 + byte(0xEA1D88) / 3 + byte(0xEA1DA4) / 3 + byte(0xEA1DC0) / 3 + byte(0xEA1DDC) / 3 +
                  byte(0xEA1DF8) / 3 + byte(0xEA1E14) / 3 + byte(0xEA1E30) / 3 + byte(0xEA1E4C) / 3 + byte(0xEA1E68) / 3 +
                  byte(0xEA1E84) / 3 + byte(0xEA1EA0) / 3 + byte(0xEA1EBC) / 3 + byte(0xEA1ED8) / 3 + byte(0xEA1EF4) / 3 +
                  byte(0xEA1F10) / 3 + byte(0xEA1F2C) / 3 + byte(0xEA1F48) / 3 + byte(0xEA1F64) / 3 + byte(0xEA1F80) / 3 +
                  byte(0xEA1F9C) / 3 + byte(0xEA1FB8) / 3 + byte(0xEA1FD4) / 3 + byte(0xEA1FF0) / 3 + byte(0xEA200C) / 3 +
                  byte(0xEA2028) / 3 + byte(0xEA2044) / 3 + byte(0xEA2060) / 3 + byte(0xEA207C) / 3 + byte(0xEA2098) / 3 +
                  byte(0xEA20B4) / 3 + byte(0xEA20D0) / 3 + byte(0xEA20EC) / 3 + byte(0xEA2108) / 3 + byte(0xEA2124) / 3 +
                  byte(0xEA2140) / 3) == 50
              )
)

achievement(
    title = "The Junk Man [scrapped, possible subset]", points = 25, type="missable",
    description = "Collect every item in the game",
    id = 464742, badge = "556487", published = "9/19/2024 7:02:59 PM", modified = "8/1/2025 5:16:41 PM",
    trigger = prev(bit7(0xEA6DF0)) == 0 && bit7(0xEA6DF0) == 1 && byte(0x14D111C) != 21
)
