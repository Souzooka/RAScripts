// Beverly Hills Cop
// #ID = 24141
// #MinimumVersion = 1.3

NULL = 0

InGame = () => dword(0x314958) != NULL
Mission = dword(0x314948)

rp_mission = rich_presence_lookup(
    "MISSION", 
    Mission, 
    {
        6: "Mission 1: Garage",
        7: "Mission 2: Warehouse",
        8: "Mission 3: Docks Shipping Office",
        9: "Mission 4: Strip Club",
        10: "Mission 5: Docks",
        11: "Mission 6: Mansion",
    },
    fallback="Unknown Mission"
)

rich_presence_conditional_display(
    InGame(),
    "In {0}",
    rp_mission
)
rich_presence_display("In menu or loading screen")