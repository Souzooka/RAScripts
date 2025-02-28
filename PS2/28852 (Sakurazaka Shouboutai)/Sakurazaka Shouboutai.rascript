// Sakurazaka Shouboutai
// #ID = 28852
// #MinimumVersion = 1.3

NULL = 0

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

function GameLoaded()
{
    // This is a pointer to the task array, and is part of initialized data when the game boots
    return dword(0x26bd64) != NULL
}

g_scene_task = dword(0xBE9854)

function SceneValid()
{
    return g_scene_task != NULL
}

// Very generic check
SCENE_LOADING = 0
SCENE_VN_CUTSCENE2 = 0x3
SCENE_MENU = 0x13
SCENE_STATION = 0x16
SCENE_GAME2 = 0x1A // Firetruck ladder platform?
SCENE_GAME = 0x22
SCENE_VN_CUTSCENE = 0x28
SCENE_MC_CHECK = 0x3F
g_scene_type = ptr(g_scene_task, [0x2C], word)

g_stage = dword(0x274364)
g_floor = dword(0x274368)

function MapID()
{
    return g_stage * 0x100 + g_floor
}

g_result_task = dword(0xbe9a54)

function ResultFinished()
{
    // Checking the update function pointer for this one
    update_fn = dword(g_result_task + 0x10)
    return g_result_task != NULL && 
           update_fn == 0x1BA730 &&
           update_fn != prev(update_fn)
}

g_result_rescue = dword(g_result_task + 0x30)
g_result_safety = dword(g_result_task + 0x34)
g_result_evidence = dword(g_result_task + 0x38)
g_result_fire = dword(g_result_task + 0x3C)
g_result_time = dword(g_result_task + 0x40)
g_result_total = dword(g_result_task + 0x44)
g_result_rank = dword(g_result_task + 0x48)
g_result_idle_frames = dword(g_result_task + 0x6C)
RANK_S = 0
RANK_A = 1
RANK_B = 2
RANK_C = 3
RANK_D = 4

for stage in range(1, 7)
{
    achievement(
        id=0,
        title=format("Complete Stage {0}", stage),
        description=format("Complete Stage {0}", stage),
        points=5,
        type="progression",
        trigger=ResultFinished() &&
        g_stage == stage
    )
    achievement(
        id=0,
        title=format("Complete Stage {0} With S Rank", stage),
        description=format("Complete Stage {0} With S Rank", stage),
        points=5,
        trigger=ResultFinished() &&
        g_stage == stage &&
        g_result_rank == RANK_S
    )
}

MapNames = {
    "en": {
        0x100: "Sakurazaka Manufacturing Plant - Manufacturing and Lodging Area",
        0x101: "Sakurazaka Manufacturing Plant - R&D Area Floor 1",
        0x102: "Sakurazaka Manufacturing Plant - R&D Area Floor 2",
        0x103: "Sakurazaka Manufacturing Plant - Boiler Area",
        0x201: "Stage 2-1",
        0x202: "Hanamura Building - Exterior",
        0x203: "Stage 2-3",
        0x204: "Stage 2-4",
        0x301: "Stage 3-1",
        0x302: "Stage 3-2",
        0x303: "Stage 3-3",
        0x304: "Stage 3-4",
        0x401: "Stage 4-1",
        0x402: "Stage 4-2",
        0x403: "Stage 4-3",
        0x404: "Stage 4-4",
        0x501: "Stage 5-1",
        0x502: "Stage 5-2",
        0x503: "Stage 5-3",
        0x504: "Stage 5-4",
        0x601: "Stage 6-1",
        0x602: "Stage 6-2",
        0x603: "Stage 6-3",
        0x604: "Stage 6-4",
        0x701: "Stage 7-1",
        0x702: "Stage 7-2",
        0x703: "Stage 7-3",
        0x704: "Stage 7-4",
    },
    "jp": {
        0x100: "桜坂製作所　加工棟＆宿泊棟",
        0x101: "桜坂製作所　研究管理棟１階",
        0x102: "桜坂製作所　研究管理棟２階",
        0x103: "桜坂製作所　ボイラー棟",
        0x201: "ステージ 2-1",
        0x202: "花村ビルディング　周辺",
        0x203: "ステージ 2-3",
        0x204: "ステージ 2-4",
        0x301: "ステージ 3-1",
        0x302: "ステージ 3-2",
        0x303: "ステージ 3-3",
        0x304: "ステージ 3-4",
        0x401: "ステージ 4-1",
        0x402: "ステージ 4-2",
        0x403: "ステージ 4-3",
        0x404: "ステージ 4-4",
        0x501: "ステージ 5-1",
        0x502: "ステージ 5-2",
        0x503: "ステージ 5-3",
        0x504: "ステージ 5-4",
        0x601: "ステージ 6-1",
        0x602: "ステージ 6-2",
        0x603: "ステージ 6-3",
        0x604: "ステージ 6-4",
        0x701: "ステージ 7-1",
        0x702: "ステージ 7-2",
        0x703: "ステージ 7-3",
        0x704: "ステージ 7-4",
    }
}

rp_en_map = rich_presence_lookup("MAP_EN", MapID(), MapNames["en"])
rp_jp_map = rich_presence_lookup("MAP_JP", MapID(), MapNames["jp"])

rich_presence_conditional_display(
    !SceneValid() || g_scene_type == SCENE_LOADING,
    "In a loading screen"
)

// In-Game
rich_presence_conditional_display(
    any_of([SCENE_GAME, SCENE_GAME2], scene => g_scene_type == scene),
    "Fighting fires at {0} ({1})",
    rp_en_map,
    rp_jp_map
)


rich_presence_conditional_display(
    any_of([SCENE_MENU, SCENE_MC_CHECK], scene => g_scene_type == scene),
    "In a menu"
)
rich_presence_conditional_display(
    any_of([SCENE_VN_CUTSCENE, SCENE_VN_CUTSCENE2], scene => g_scene_type == scene),
    "In a cutscene"
)
rich_presence_conditional_display(
    g_scene_type == SCENE_STATION,
    "Inside the Sakurazaka Fire Station"
)
rich_presence_display(
    "Filled with the collective spirit of each firefighter in the Sakurazaka Fire Brigade"
)