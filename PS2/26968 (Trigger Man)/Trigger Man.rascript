// Trigger Man
// #ID = 26968

NULL = 0

function IsRegion(region)
{
    return true
}

function if_else(cond, v1, v2)
{
    if cond == true
        return v1
    return v2
}

function dict_get(dict, key, default=false)
{
    if dictionary_contains_key(dict, key)
        return dict[key]
    return default
}

function max(a, b)
{
    return if_else(a > b, a, b)
}

function min(a, b)
{
    return if_else(a < b, a, b)
}

addr = (v) => v // Dummy accessor for ptr for if the pointed-to address is desired
function ptr(base, offsets, accessor=dword)
{
    val = base
    
    for i in range(0, length(offsets) - 1)
    {
        addr = val + offsets[i]
        if (i == length(offsets) - 1)
            val = accessor(addr)
        else
            val = dword(addr)
    }
    
    return val
}

function time_to_centisecs(minutes=0, seconds=0)
{
    return
        seconds * 100 +
        minutes * 60 * 100
}

function AntiCheat()
{
    // there's 8 but only the first 2 can be edited without a cheat device
    NUM_CHEATS = 2
    return all_of(array_map(range(0, NUM_CHEATS-1), i => bit0(0x25181c + i * 0x20)), cheat => cheat == 0)
}

function MissionComplete(mission)
{
    return
        AntiCheat() &&
        level_id == mission &&
        prev(g_mission_complete) == 1 &&
        g_mission_complete == 0
}

function GetIGT()
{
    g_game_days = dword(0x277610)
    g_game_time = float(0x277614)
    return g_game_time * 100 + (g_game_days * 100 * 60 * 60 * 24)
}

function BossDead()
{
    // Need to "use after free" here because bosses are tossed from g_boss as soon as they die
    // (even though the actor still exists, so this data *should* be fine and not actually free)
    prev_g_boss = Human(prev(p_boss))
    return p_boss == NULL && prev(p_boss) != NULL && prev(prev_g_boss["m_health"] > 0.0) && prev_g_boss["m_health"] <= 0.0
}

function MissionStart(mission)
{
    return level_id == mission &&
        GetIGT() != 0 &&
        prev(GetIGT()) == 0
}

function MissionCancel(mission)
{
    return !AntiCheat() || g_scene_id != -1 && level_id != mission
}

function Vec4(addr)
{
    obj = {
        "x": float(addr + 0x0),
        "y": float(addr + 0x4),
        "z": float(addr + 0x8),
        "w": float(addr + 0xC),
    }
    
    return obj
}

function Box2(x1, x2, z1, z2)
{
    obj = {
        "x1": min(x1, x2),
        "x2": max(x1, x2),
        "z1": min(z1, z2),
        "z2": max(z1, z2),
    }
    
    return obj
}

function Box2_enter(box, point)
{
    return
        box["x1"] <= point["x"] &&
        box["x2"] >= point["x"] &&
        box["z1"] <= point["z"] &&
        box["z2"] >= point["z"] &&
        __ornext(
            box["x1"] > prev(point["x"]) ||
            box["x2"] < prev(point["x"]) ||
            box["z1"] > prev(point["z"]) ||
            box["z2"] < prev(point["z"])
        )
}

function Human(addr)
{
    obj = {
        "m_health_max": float(addr + 0x34),
        "m_health": float(addr + 0x3C),
        "m_position": Vec4(addr + 0x60),
        "p_weapon": dword(addr + 0x604),
        "m_weapon": Weapon(dword(addr + 0x604)),
    }
    
    return obj
}

function Weapon(addr)
{
    obj = {
        "m_params": WeaponParams(dword(addr + 0x14)),
        "m_clip": WeaponClip(dword(addr + 0x64)),
        "m_ammo": byte(addr + 0x82),
    }
    
    return obj
}

function WeaponParams(addr)
{
    obj = {
        "m_type": byte(addr + 0xC),
    }
    
    return obj
}

function WeaponClip(addr)
{
    obj = {
        "p_projectile": dword(addr + 0xC),
        "m_projectile": Projectile(dword(addr + 0xC)),
    }
    
    return obj
}

function Projectile(addr)
{
    obj = {
        "m_count": word(addr + 0x10),
    }
    
    return obj
}

function WeaponHasReserveAmmo()
{
    return g_player["m_weapon"]["m_clip"]["p_projectile"] != NULL
}

function WeaponGetReserveAmmo()
{
    return g_player["m_weapon"]["m_clip"]["m_projectile"]["m_count"]
}

STAT_DIFFICULTY = 0
STAT_IGT_DAYS = 1
STAT_IGT_HOURS = 2
STAT_IGT_MINUTES = 3
STAT_IGT_SECONDS = 4
STAT_TOTAL_KILLS = 5
STAT_PLAYER_KILLS = 6
STAT_HEAD_SHOTS = 7
STAT_KNIFE_STRIKES = 8
STAT_SHOTS_FIRED = 10
STAT_HITS = 11

function StatGet(stat)
{
    g_scoreMan = 0x54A6E0
    addr = g_scoreMan + 0x720
    addr = addr + (stat * 4)
    return dword(addr)
}

g_scene_id = dword(0x277940)
g_next_scene_id = dword(0x277944)
level_id = g_scene_id / 100
next_level_id = g_next_scene_id / 100
p_boss = dword(0x277ea0)
g_boss = Human(p_boss)
p_player = dword(0x277ea8)
g_player = Human(p_player)
g_mission_complete = dword(0x27795c)

g_difficulty = ptr(dword(0x2786c4), [0x4], dword)
DIFFICULTY_NORMAL = 1
DIFFICULTY_DEADLY = 2

MISSION_PARAMS = [
    {
        "mission": 1,
        "normal_id": 596397,
        "hard_id": 596398,
        "normal_title": "Oceans One",
        "hard_title": "Oceans One - Deadly",
        "type": "progression",
        "normal_points": 5,
        "hard_points": 5,
    },
    {
        "mission": 2,
        "normal_id": 596399,
        "hard_id": 596400,
        "normal_title": "The Future is Now, Old Man",
        "hard_title": "The Future is Now, Old Man - Deadly",
        "type": "progression",
        "normal_points": 5,
        "hard_points": 5,
    },
    {
        "mission": 3,
        "normal_id": 596401,
        "hard_id": 596402,
        "normal_title": "Parking Validated",
        "hard_title": "Parking Validated - Deadly",
        "type": "progression",
        "normal_points": 5,
        "hard_points": 5,
    },
    {
        "mission": 4,
        "normal_id": 596403,
        "hard_id": 596404,
        "normal_title": "The Sewer Escort Affair",
        "hard_title": "The Sewer Escort Affair - Deadly",
        "type": "progression",
        "normal_points": 5,
        "hard_points": 5,
    },
    {
        "mission": 5,
        "normal_id": 596405,
        "hard_id": 596406,
        "normal_title": "I Like Trains",
        "hard_title": "I Like Trains - Deadly",
        "type": "progression",
        "normal_points": 5,
        "hard_points": 5,
    },
    {
        "mission": 6,
        "normal_id": 596407,
        "hard_id": 596408,
        "normal_title": "Fuzzy Pasta",
        "hard_title": "Fuzzy Pasta - Deadly",
        "type": "progression",
        "normal_points": 5,
        "hard_points": 5,
    },
    {
        "mission": 7,
        "normal_id": 596409,
        "hard_id": 596410,
        "normal_title": "Ship It",
        "hard_title": "Ship It - Deadly",
        "type": "progression",
        "normal_points": 5,
        "hard_points": 5,
    },
    {
        "mission": 8,
        "normal_id": 596411,
        "hard_id": 596412,
        "normal_title": "Now You're a Hero",
        "hard_title": "Now You're a Hero - Deadly",
        "normal_description": "You managed to beat the whole damn ga-ame. We're happy you made it, but how are you gonna spend the rest of this da-ay?",
        "hard_description": "You managed to beat the whole damn ga-ame (but on the Deadly difficulty). Yes, it's over now, we didn't want to make a longer game.",
        "type": "win_condition",
        "normal_points": 5,
        "hard_points": 5,
    },
]

for params in MISSION_PARAMS
{
    achievement(
        id=params["normal_id"],
        title=params["normal_title"],
        description=
            dict_get(
                params,
                "normal_description",
                format("Complete mission {0}.", params["mission"])
            ),
        type=params["type"],
        points=params["normal_points"],
        trigger=
            MissionComplete(params["mission"])
    )
    achievement(
        id=params["hard_id"],
        title=params["hard_title"],
        description=
            dict_get(
                params,
                "hard_description",
                format("Complete mission {0} on the Deadly difficulty.", params["mission"])
            ),
        points=params["hard_points"],
        trigger=
            MissionComplete(params["mission"]) &&
            g_difficulty == DIFFICULTY_DEADLY
    )
}

WEAPON_MP5 = 0x5
WEAPON_M203 = 0xC
WEAPON_5ROUNDSNIPER = 0xD

achievement(
    id=596495,
    title="Finger on the Trigger, Man",
    description="Complete mission 1 without ever reloading any of your weapons.",
    points=10,
    type="missable",
    trigger=
        // Record mission start
        once(MissionStart(1)) &&
        // Reset upon weapon ammo increasing (and last weapon is same as now weapon)
        never(
            MissionCancel(1) ||
            (
                p_player != NULL &&
                // Prevents respawns from invalidating achievement
                g_scene_id != -1 &&
                // Ammo in magazine for equipped weapon increased (thus the player reloaded)
                g_player["p_weapon"] != NULL &&
                prev(g_player["p_weapon"]) == g_player["p_weapon"] &&
                g_player["m_weapon"]["m_ammo"] > prev(g_player["m_weapon"]["m_ammo"])
            )
        ) &&
        // Trigger upon mission completion
        trigger_when(MissionComplete(1))
)

achievement(
    id=596496,
    title="Remember the Basics of CQC, Jack",
    description="Complete mission 2 while only firing your sniper rifle or using your knife.",
    points=10,
    type="missable",
    trigger=
        // Record mission start
        once(MissionStart(2)) &&
        // Reset upon weapon ammo decreasing (if not sniper) (and last weapon is same as now weapon)
        never(
            MissionCancel(2) ||
            (
                p_player != NULL &&
                // Prevents respawns from invalidating achievement
                g_scene_id != -1 &&
                // Ammo in magazine for equipped weapon decreased (thus the player used the weapon)
                g_player["p_weapon"] != NULL &&
                prev(g_player["p_weapon"]) == g_player["p_weapon"] &&
                g_player["m_weapon"]["m_params"]["m_type"] != WEAPON_5ROUNDSNIPER &&
                (
                    g_player["m_weapon"]["m_ammo"] < prev(g_player["m_weapon"]["m_ammo"]) ||
                    (
                        // The weapon actually uses projectiles (and isn't like, the (non-thrown) knife)
                        WeaponHasReserveAmmo() &&
                        // Weapon reserve ammo decreased (detects auto-reloaded weapons like throwing knife)
                        WeaponGetReserveAmmo() < prev(WeaponGetReserveAmmo())
                    )
                )
            )
        ) &&
        // Trigger upon mission completion
        trigger_when(MissionComplete(2))
)

// Without dying since dying doesn't reset the knife strikes set to a checkpoint value :(
KNIFE_AMOUNT = 15
achievement(
    id=596497,
    title="Donkey Punch!",
    description=format("From the start of mission 3, kill {0} enemies using your knife without dying.", KNIFE_AMOUNT),
    points=10,
    type="missable",
    trigger=
        // Record mission start
        once(MissionStart(3)) &&
        never(MissionCancel(3) || g_scene_id == -1) &&
        (
            (
                trigger_when(always_false())
            ) ||
            (
                // Activate when getting enough knife strikes
                prev(StatGet(STAT_KNIFE_STRIKES)) == KNIFE_AMOUNT-1 &&
                measured(StatGet(STAT_KNIFE_STRIKES) == KNIFE_AMOUNT, when=once(MissionStart(3)))
            )
        )
)

achievement(
    id=596498,
    title="Subway Surfer",
    description="Complete mission 4 with an in-game time of less than 4 minutes and 44 seconds.",
    points=10,
    type="missable",
    trigger=
        once(MissionStart(4)) &&
        never(MissionCancel(4)) &&
        GetIGT() < time_to_centisecs(minutes=4, seconds=44) &&
        trigger_when(MissionComplete(4))
)

achievement(
    id=596499,
    title="Wake Me Up When Septober Ends",
    description="In mission 5, defeat Johnny Navarro without letting him leave the office area.",
    points=10,
    type="missable",
    trigger=
        // Record mission start (or having respawned)
        once(MissionStart(5) || prev(g_scene_id) == -1 && level_id == 5) &&
        // Reset upon boss leaving office
        never(MissionCancel(5) || 
            (
                p_boss != NULL &&
                g_boss["m_position"]["x"] != 0.0 && // boss not yet initialized
                (
                    g_boss["m_position"]["x"] > -16.0 ||
                    g_boss["m_position"]["z"] > -3.5
                )
            )
        ) &&
        // Trigger upon boss death
        trigger_when(BossDead())
)

achievement(
    id=596500,
    title="Greet My Friend",
    description="In mission 6, find the stashed MP5.",
    points=2,
    type="missable",
    trigger=
        // Record mission start
        once(MissionStart(6)) &&
        never(MissionCancel(6) || g_next_scene_id != 601) &&
        // Trigger on switching to MP5
        trigger_when(
            prev(g_player["m_weapon"]["m_params"]["m_type"]) != WEAPON_MP5 &&
            g_player["m_weapon"]["m_params"]["m_type"] == WEAPON_MP5
        )
)

achievement(
    id=596501,
    title="Tip the Collector",
    description="In mission 7, locate the weapon shipment.",
    points=2,
    type="missable",
    trigger=
        g_next_scene_id == 707 &&
        trigger_when(
            p_player != NULL &&
            Box2_enter(Box2(18.5, 27.0, -5.0, 2.0), g_player["m_position"])
        )
)

achievement(
    id=596502,
    title="W+M1",
    description="In mission 8, beat Donna Bella without having picked up the M203 Grenade Launcher.",
    points=10,
    type="missable",
    trigger=
        // Record mission start (or having respawned)
        once(MissionStart(8) || prev(g_scene_id) == -1 && level_id == 8) &&
        // Reset upon picking up the grenade launcher
        never(MissionCancel(8) || g_player["m_weapon"]["m_params"]["m_type"] == WEAPON_M203) &&
        // Trigger upon boss death
        trigger_when(BossDead())
)

LB_ID = 159451

for mission in range(1, 8)
{
    leaderboard(
        id=LB_ID + mission - 1,
        title=format("Mission {0} - Time Attack", mission),
        description=format("Complete mission {0} as quickly as possible!", mission),
        format="CENTISECS",
        lower_is_better=true,
        start=
            MissionStart(mission),
        cancel=
            MissionCancel(mission),
        submit=
            MissionComplete(mission),
        value=
            GetIGT()
    )
}

rp_difficulty_lookup = {
    DIFFICULTY_NORMAL: "Normal",
    DIFFICULTY_DEADLY: "Deadly",
}

rich_presence_conditional_display(
    next_level_id == 9,
    "In credits"
)
rich_presence_conditional_display(
    next_level_id > 0 && p_player != NULL,
    "In mission {0} | {1} | {2}% health",
    rich_presence_value("VALUE", next_level_id),
    rich_presence_lookup("DIFFICULTY", g_difficulty, rp_difficulty_lookup),
    rich_presence_value("VALUE", 100 * (g_player["m_health"] / g_player["m_health_max"]))
)
rich_presence_display("In main menu")
