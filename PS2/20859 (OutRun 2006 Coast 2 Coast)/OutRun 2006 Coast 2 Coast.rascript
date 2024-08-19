// OutRun 2006: Coast 2 Coast
// #ID = 20859

NULL = 0
True = 1
False = 0
NO_ADDR = 0xFFFF0 // always 0x0 when read

RegionByte = byte(0x133a03)
US = 0
EU = 1
JP = 2
Regions = [US, EU, JP]

function IsRegion(region)
{
    return region == RegionByte
}

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

function assert(cond, msg="No Assertion Message")
{
    if cond == false
    {
        l = {}
        return l[msg]
    }
    
    return true
}

FRAMES_PER_SECOND = 60.0
function FramesToCentiseconds(val)
{
    return val * (100.0 / FRAMES_PER_SECOND)
}

function TimeToCentiseconds(minutes=0, seconds=0, frames=0)
{
    return FramesToCentiseconds(minutes * (60 * FRAMES_PER_SECOND) + (seconds * FRAMES_PER_SECOND) + frames)
}

// GAME VARIABLES

// Temp 32-bit pointer check which is non-NULL when in-game; TODO: see if there's a better way of
// determining game vs. menu state
inGameCheck = {
    US: dword(0x549B90),
    EU: NO_ADDR,
    JP: NO_ADDR,
}

SKY_GRAN = 0x10D
SKY_SEQU = 0x10E
SKY_SANF = 0x10F
SKY_NEWY = 0x110
SKY_MACH = 0x111
SKY_YOSE = 0x112
SKY_MAYA = 0x113
SKY_NIAG = 0x114
SKY_ALAS = 0x115
SKY_AMAZ = 0x116
SKY_BEAC = 0x117
SKY_LASV = 0x118
SKY_PRIN = 0x119
SKY_FLOR = 0x11A
SKY_EAST = 0x11B
currSky = {
    US: dword(0x549B74),
    EU: NO_ADDR,
    JP: NO_ADDR,
}

// GAME FUNCTIONS

function IsInGame(region)
{
    return inGameCheck[region] != NULL
}

// RICH PRESENCE

region_lookup = {
    US: "ᵘˢ",
    EU: "ᵉᵘ",
    JP: "ʲᵖ",
}

track_lookup = {
    SKY_GRAN: "Canyon",
    SKY_SEQU: "Big Forest",
    SKY_SANF: "Bay Area",
    SKY_NEWY: "Skyscrapers",
    SKY_MACH: "Lost City",
    SKY_YOSE: "National Park",
    SKY_MAYA: "Legend",
    SKY_NIAG: "Water Falls",
    SKY_ALAS: "Ice Scape",
    SKY_AMAZ: "Jungle",
    SKY_BEAC: "Sunny Beach",
    SKY_LASV: "Casino Town",
    SKY_PRIN: "Floral Village",
    SKY_FLOR: "Milky Way",
    SKY_EAST: "Giant Statues",
}

for region in Regions
{
    region_val = rich_presence_lookup("REGION", RegionByte, region_lookup, region_lookup[US])
    track_val = rich_presence_lookup("TRACK", currSky[region], track_lookup, "Unknown Zone")

    rich_presence_conditional_display(
        IsRegion(region) && IsInGame(region),
        "{0} OutRunning in {1}!",
        region_val,
        track_val
    )
    rich_presence_conditional_display(
        IsRegion(region),
        "{0} In menu or loading screen",
        region_val
    )
}

rich_presence_display("Playing OutRun 2006: Coast 2 Coast")
