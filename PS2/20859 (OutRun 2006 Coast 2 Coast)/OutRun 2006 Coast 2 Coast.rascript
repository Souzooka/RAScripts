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

inRace = {
    US: dword(0x359a4c),
    EU: dword(NO_ADDR),
    JP: dword(NO_ADDR),
}

SKY_PALM = 0x71
SKY_LAKE = 0x72
SKY_INDU = 0x73
SKY_ALPI = 0x74
SKY_SNOW = 0x75
SKY_CLOU = 0x76
SKY_CAST = 0x77
SKY_GHOS = 0x78
SKY_FORE = 0x79
SKY_DESE = 0x7A
SKY_TULI = 0x7B
SKY_METR = 0x7C
SKY_RUIN = 0x7D
SKY_CAPE = 0x7E
SKY_IMPE = 0x7F
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
// The filename idx for the currently-used sky, used for zone detection
currSky = {
    US: dword(0x549B74),
    EU: dword(NO_ADDR),
    JP: dword(NO_ADDR),
}

// The currently-selected car
CAR_F50 = 0
CAR_DINO = 1
CAR_288GTO = 2
CAR_512BB = 3
CAR_365GTS = 4
CAR_ENZO = 5
CAR_TESTA = 6
CAR_SPIDER = 7
CAR_F40 = 8
CAR_250GTO = 9
car = {
    US: byte(0x369BE8),
    EU: byte(NO_ADDR),
    JP: byte(NO_ADDR),
}

// Transmission type
TRANS_AUTO = 0x0
TRANS_MANUAL = 0x1
transmission = {
    US: byte(0x369BEA),
    EU: byte(NO_ADDR),
    JP: byte(NO_ADDR),
}

// The type of active event
EVENT_TIME_ATTACK = 0
EVENT_OUTRUN = 1
EVENT_HEART_ATTACK = 2
EVENT_GIRLFRIEND = 5
EVENT_FLAGMAN = 6
eventType = {
    US: dword(0x443F08),
    EU: dword(NO_ADDR),
    JP: dword(NO_ADDR),
}

// GAME FUNCTIONS

function IsInGame(region)
{
    return inRace[region] == True
}

// RICH PRESENCE

region_lookup = {
    US: "ᵘˢ",
    EU: "ᵉᵘ",
    JP: "ʲᵖ",
}

track_lookup = {
    SKY_PALM: "Palm Beach",
    SKY_LAKE: "Deep Lake",
    SKY_INDU: "Industrial Complex",
    SKY_ALPI: "Alpine",
    SKY_SNOW: "Snow Mountain",
    SKY_CLOU: "Cloudy Highland",
    SKY_CAST: "Castle Wall",
    SKY_GHOS: "Ghost Forest",
    SKY_FORE: "Coniferous Forest",
    SKY_DESE: "Desert",
    SKY_TULI: "Tulip Garden",
    SKY_METR: "Metropolis",
    SKY_RUIN: "Ancient Ruins",
    SKY_CAPE: "Cape Way",
    SKY_IMPE: "Imperial Avenue",
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

trans_lookup = {
    TRANS_AUTO: "AT",
    TRANS_MANUAL: "MT",
}

car_lookup = {
    CAR_F50: "F50",
    CAR_DINO: "Dino 246 GTS",
    CAR_288GTO: "288 GTO",
    CAR_512BB: "512 BB",
    CAR_365GTS: "365 GTS/4 Daytona",
    CAR_ENZO: "Enzo Ferrari",
    CAR_TESTA: "Testarossa",
    CAR_SPIDER: "360 Spider",
    CAR_F40: "F40",
    CAR_250GTO: "250 GTO",
}

event_lookup = {
    EVENT_TIME_ATTACK: "Time Attack Mode",
    EVENT_OUTRUN: "OutRun Mode",
    EVENT_HEART_ATTACK: "Heart Attack Mode",
    EVENT_GIRLFRIEND: "Girlfriend Event",
    EVENT_FLAGMAN: "Flagman Event",
}

for region in Regions
{
    rp_region = rich_presence_lookup("REGION", RegionByte, region_lookup, region_lookup[US])
    rp_track = rich_presence_lookup("TRACK", currSky[region], track_lookup, "Unknown Zone")
    rp_trans = rich_presence_lookup("TRANS", transmission[region], trans_lookup, "Unknown Transmission")
    rp_car = rich_presence_lookup("CAR", car[region], car_lookup, "Unknown Car")
    rp_event = rich_presence_lookup("EVENT", eventType[region], event_lookup, "Unknown Event")

    rich_presence_conditional_display(
        IsRegion(region) && IsInGame(region),
        "{0} OutRunning | {1} | {2} ({3}) | {4}",
        rp_region,
        rp_event,
        rp_car,
        rp_trans,
        rp_track
    )
    rich_presence_conditional_display(
        IsRegion(region),
        "{0} In menu or loading screen",
        rp_region
    )
}

rich_presence_display("Playing OutRun 2006: Coast 2 Coast")
