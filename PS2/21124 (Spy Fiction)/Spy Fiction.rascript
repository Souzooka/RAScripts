// Spy Fiction
// #ID = 21124


_characters = [
    "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k",
    "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v",
    "w", "x", "y", "z", "A", "B", "C", "D", "E", "F", "G",
    "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R",
    "S", "T", "U", "V", "W", "X", "Y", "Z", ".", "'", "\"",
    "!", "?", ",", " ",
]
_key = [
    0x27bdff50, 0xffbf0080, 0x7fb70070, 0x7fb60060,
    0x27b7009c, 0x7fb50050, 0x27b60094, 0x7fb40040,
    0x00a0a82d, 0x7fb30030, 0x00e0a02d, 0x7fb20020,
    0x0100982d, 0x7fb10010, 0x7fb00000, 0x27b100a0,
    0xafa40090, 0x27b00098, 0xaed40000, 0xae130000,
    0xaee60000, 0x8e030000, 0xae230000, 0xae200000,
    0x8e230000, 0x0073082b, 0x1020000b, 0x0080902d,
    0x0240202d, 0x02a0f809, 0x24050001, 0x8e230000,
    0x24630001, 0xae230000, 0x8e230000, 0x0073182b,
    0x1460fff7, 0x02549021, 0x8e030000, 0x8e250000,
    0x00a3082b, 0x10200016, 0x00000000, 0x8ee30000,
    0x10600013, 0x00000000, 0x8ec40000, 0x8fa30090,
    0x00852018, 0x10a0000e, 0x00648021, 0x00000000,
    0x8ec30000, 0x8ee20000, 0x2405ffff, 0x02038023,
    0x0040f809, 0x0200202d, 0x8e230000
]
assert(length(_characters) == length(_key))
_spice = 0x12344321
for i in range(0, length(_key) - 1)
{
    _key[i] = _key[i] ^ _spice
}

function abs(val)
{
    if val == 0x80000000
    {
        return 0x7FFFFFFF
    }
    if val < 0x0
    {
        return val * -1
    }
    return val
}

function static_ptr(addr)
{
    // Thanks suXin for this idea
    return dword((tbyte(0x122E98) * 4) + (addr - 0x100218))
}

_seed = 0
function _rand()
{
    _seed = _seed * 1103515245 + 12345
    return _seed
}

function _create_rp_dictionaries()
{
    ret = {}
    for i in range(0, length(_characters) - 1)
    {
        ret[_characters[i]] = {}
        for j in range(0, length(_characters) - 1)
        {
            if (i != j)
            {
                lookup_key = _rand()
                // Unlikely but try and avoid collisions with the key
                assert(lookup_key != _key[j])
                ret[_characters[i]][lookup_key] = _characters[j]
            }
        }
        
        ret[_characters[i]][_key[i]] = _characters[i]
    }

    for i in range(0, length(_characters) - 1)
    {
       ret[_characters[i]] = rich_presence_lookup("L" + _rand(), static_ptr(0x100450 + (i * 4)) ^ _spice, ret[_characters[i]])
       i = i + 1
    }
    return ret
}

rp_lookups = _create_rp_dictionaries()
l = rp_lookups

// Before game startup
rich_presence_conditional_display(
    dword(0x100008) == 0,
    "\"I'm bootin', I'm bootin'\" - oboeshoesgames"
)
// Spread operator when
rich_presence_display(
    "{0}{1}{2}{3}{4}{5}{6}{7}{8}{9}{10}{11}{12}{13}{14}{15}{16}{17}{18}{19}{20}{21}{22}{23}{24}{25}{26}{27}{28}{29}{30}{31}{32}{33}{34}{35}{36}{37}{38}{39}{40}{41}{42}{43}{44}{45}{46}{47}{48}{49}{50}{51}{52}{53}{54}{55}{56}{57}{58}{59}{60}{61}{62}{63}{64}{65}{66}{67}{68}{69}{70}{71}{72}{73}{74}{75}{76}",
    l["H"],
    l["e"],
    l["l"],
    l["l"],
    l["o"],
    l[" "],
    l["P"],
    l["h"],
    l["a"],
    l["n"],
    l["t"],
    l["o"],
    l["m"],
    l[" "],
    l["A"],
    l["g"],
    l["e"],
    l["n"],
    l["t"],
    l["."],
    l[" "],
    l["T"],
    l["h"],
    l["i"],
    l["s"],
    l[" "],
    l["i"],
    l["s"],
    l[" "],
    l["a"],
    l["n"],
    l[" "],
    l["e"],
    l["n"],
    l["c"],
    l["r"],
    l["y"],
    l["p"],
    l["t"],
    l["e"],
    l["d"],
    l[" "],
    l["m"],
    l["e"],
    l["s"],
    l["s"],
    l["a"],
    l["g"],
    l["e"],
    l["!"],
    l[" "],
    l["P"],
    l["l"],
    l["e"],
    l["a"],
    l["s"],
    l["e"],
    l[" "],
    l["b"],
    l["u"],
    l["r"],
    l["n"],
    l[" "],
    l["a"],
    l["f"],
    l["t"],
    l["e"],
    l["r"],
    l[" "],
    l["r"],
    l["e"],
    l["a"],
    l["d"],
    l["i"],
    l["n"],
    l["g"],
    l["."]
)
