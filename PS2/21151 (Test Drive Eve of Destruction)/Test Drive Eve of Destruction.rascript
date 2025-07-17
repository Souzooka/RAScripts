// Test Drive: Eve of Destruction
// #ID = 21151

achievement(
    title = "REPLAY WARNING", points = 0,
    description = "IF YOU WATCH A REPLAY WITH HITS IN IT YOU WILL BE LOCKED OUT OF CAREER/REPUTATION ACHIEVEMENTS AND MUST RESET! ANY CHEAT USED WILL LOCK ALL ACHIEVEMENTS!",
    id = 412125, badge = "467042", published = "3/27/2024 10:41:20 PM", modified = "3/27/2024 10:41:20 PM",
    trigger = dword(0x3E9704) > prev(dword(0x3E9704))
)

achievement(
    title = "Destruction Rookie", points = 5, type="progression",
    description = "Reach the top 75 during career mode.",
    id = 412126, badge = "467043", published = "3/27/2024 10:41:44 PM", modified = "4/13/2024 3:40:01 PM",
    trigger = dword(0x1FFE784) == 0 && prior(dword(0xB64000)) > 74 && (dword(0xB64000) <= 74 && dword(0xB64000) >= 68) &&
              dword(0x3E9704) != 0 &&
              disable_when(((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000) && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Destruction Pro", points = 5, type="progression",
    description = "Reach the top 50 during career mode.",
    id = 412127, badge = "467044", published = "3/27/2024 10:41:44 PM", modified = "4/13/2024 3:40:02 PM",
    trigger = dword(0x1FFE784) == 0 && prior(dword(0xB64000)) > 49 && (dword(0xB64000) <= 49 && dword(0xB64000) >= 38) &&
              dword(0x3E9704) != 0 && disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Destruction Veteran", points = 10, type="progression",
    description = "Reach the top 25 during career mode.",
    id = 412128, badge = "467045", published = "3/27/2024 10:41:45 PM", modified = "4/13/2024 3:40:02 PM",
    trigger = dword(0x1FFE784) == 0 && prior(dword(0xB64000)) > 24 && (dword(0xB64000) <= 24 && dword(0xB64000) >= 10) &&
              dword(0x3E9704) != 0 && disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Destruction Champ", points = 10, type="progression",
    description = "Reach the top 10 during career mode.",
    id = 412129, badge = "467046", published = "3/27/2024 10:41:45 PM", modified = "4/13/2024 3:40:02 PM",
    trigger = dword(0x1FFE784) == 0 && prior(dword(0xB64000)) > 9 && (dword(0xB64000) <= 9 && dword(0xB64000) >= 1) &&
              dword(0x3E9704) != 0 && disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0)
)

achievement(
    title = "A Car for This, a Car for That", points = 3,
    description = "Own 4 cars at once during career mode.",
    id = 412130, badge = "467047", published = "3/27/2024 10:41:45 PM", modified = "3/27/2024 10:41:45 PM",
    trigger = prev(dword(0xB6334C)) == 3 && dword(0xB6334C) == 4 && dword(0x3CDA00) == 3 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Crash Dummy", points = 5,
    description = "Get a car to 50% irreparable damage during career mode.",
    id = 412131, badge = "467048", published = "3/27/2024 10:41:45 PM", modified = "3/27/2024 10:41:45 PM",
    trigger = dword(0x1FFE784) == 0 && dword(0x3E9704) == 1 && dword(0x3CDA00) == 9 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0) &&
              dword(0x3D8130) == 4294967295 &&
              (((prev(dword(0x3C442C)) <= 58 && prev(dword(0x3C442C)) >= 51) && dword(0x3C442C) == 50) ||
               ((dword(0x3C446C) <= 58 && dword(0x3C446C) >= 51) && dword(0x3C446C) == 50))
)

achievement(
    title = "Smackfest - Josh Black", points = 2, type="missable",
    description = "Beat Josh Black on the way to the Ashland Smackfest eve.",
    id = 412132, badge = "467049", published = "3/27/2024 10:42:29 PM", modified = "3/27/2024 10:42:29 PM",
    trigger = prev(dword(0x3CDA24)) == 4 && dword(0x3CDA24) == 5 && dword(0x3CDA30) == 50 && dword(0x3CDA34) == 50 &&
              dword(0x3CDA54) == 1 && dword(0x3CDA40) == 1 && dword(0x3CDA2C) == 1 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Ashland Smackfest", points = 3, type="missable",
    description = "Get 1st place in the Ashland Smackfest eve.",
    id = 412133, badge = "467050", published = "3/27/2024 10:42:29 PM", modified = "3/27/2024 10:42:29 PM",
    trigger = dword(0x3CDA30) == 50 && dword(0x3CDA24) == 6 && dword(0x3E5B80) == 3 && prior(dword(0x3E5B80)) == 2 &&
              dword(dword(0x1FFC42C) + 0xFFFFFFF8) == 1 && prev(dword(dword(0x1FFC42C) + 0xFFFFFFF8)) != 1 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Crash Test - Brett Stinski", points = 2, type="missable",
    description = "Beat Brett Stinski on the way to the Woodly Crash Test eve.",
    id = 412134, badge = "467051", published = "3/27/2024 10:42:29 PM", modified = "3/27/2024 10:42:29 PM",
    trigger = prev(dword(0x3CDA24)) == 4 && dword(0x3CDA24) == 5 && dword(0x3CDA30) == 75 && dword(0x3CDA34) == 75 &&
              dword(0x3CDA54) == 1 && dword(0x3CDA40) == 1 && dword(0x3CDA2C) == 1 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Woodly Crash Test", points = 3, type="missable",
    description = "Get 1st place in the Woodly Crash Test eve.",
    id = 412135, badge = "467052", published = "3/27/2024 10:42:29 PM", modified = "3/27/2024 10:42:29 PM",
    trigger = dword(0x3CDA30) == 75 && dword(0x3CDA24) == 6 && dword(0x3E5B80) == 3 && prior(dword(0x3E5B80)) == 2 &&
              dword(dword(0x1FFC42C) + 0xFFFFFFF8) == 1 && prev(dword(dword(0x1FFC42C) + 0xFFFFFFF8)) != 1 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0)
)

achievement(
    title = "County Derby - Glen Harris", points = 2, type="missable",
    description = "Beat Glen Harris on the way to Eagan County Derby eve.",
    id = 412136, badge = "467053", published = "3/27/2024 10:42:30 PM", modified = "3/27/2024 10:42:30 PM",
    trigger = prev(dword(0x3CDA24)) == 4 && dword(0x3CDA24) == 5 && dword(0x3CDA30) == 100 && dword(0x3CDA34) == 100 &&
              dword(0x3CDA54) == 1 && dword(0x3CDA40) == 1 && dword(0x3CDA2C) == 1 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Eagan County Derby", points = 3, type="missable",
    description = "Get 1st place in the Eagan County Derby eve.",
    id = 412137, badge = "467054", published = "3/27/2024 10:42:30 PM", modified = "3/27/2024 10:42:30 PM",
    trigger = dword(0x3CDA30) == 100 && dword(0x3CDA24) == 6 && dword(0x3E5B80) == 4 && prior(dword(0x3E5B80)) == 3 &&
              dword(dword(0x1FFC42C) + 0xFFFFFFF8) == 1 && prev(dword(dword(0x1FFC42C) + 0xFFFFFFF8)) != 1 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Crunch - Tex Babcock", points = 2, type="missable",
    description = "Beat Tex Babcock on the way to the Crunch Time at Hampton eve.",
    id = 412138, badge = "467055", published = "3/27/2024 10:42:30 PM", modified = "3/27/2024 10:42:30 PM",
    trigger = prev(dword(0x3CDA24)) == 4 && dword(0x3CDA24) == 5 && dword(0x3CDA30) == 125 && dword(0x3CDA34) == 125 &&
              dword(0x3CDA54) == 1 && dword(0x3CDA40) == 1 && dword(0x3CDA2C) == 1 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Crunch Time at Hampton", points = 4, type="missable",
    description = "Get 1st place in the Crunch Time at Hampton eve.",
    id = 412139, badge = "467056", published = "3/27/2024 10:42:31 PM", modified = "3/27/2024 10:42:31 PM",
    trigger = dword(0x3CDA30) == 125 && dword(0x3CDA24) == 6 && dword(0x3E5B80) == 4 && prior(dword(0x3E5B80)) == 3 &&
              dword(dword(0x1FFC42C) + 0xFFFFFFF8) == 1 && prev(dword(dword(0x1FFC42C) + 0xFFFFFFF8)) != 1 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Hell - William Anderson", points = 2, type="missable",
    description = "Beat William Anderson on the way to the Hastings Hell on Wheels eve.",
    id = 412140, badge = "467057", published = "3/27/2024 10:42:31 PM", modified = "3/27/2024 10:42:31 PM",
    trigger = prev(dword(0x3CDA24)) == 4 && dword(0x3CDA24) == 5 && dword(0x3CDA30) == 150 && dword(0x3CDA34) == 150 &&
              dword(0x3CDA54) == 1 && dword(0x3CDA40) == 1 && dword(0x3CDA2C) == 1 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Hastings Hell on Wheels", points = 4, type="missable",
    description = "Get 1st place in the Hastings Hell on Wheels eve.",
    id = 412141, badge = "467058", published = "3/27/2024 10:42:31 PM", modified = "3/27/2024 10:42:31 PM",
    trigger = dword(0x3CDA30) == 150 && dword(0x3CDA24) == 6 && dword(0x3E5B80) == 4 && prior(dword(0x3E5B80)) == 3 &&
              dword(dword(0x1FFC42C) + 0xFFFFFFF8) == 1 && prev(dword(dword(0x1FFC42C) + 0xFFFFFFF8)) != 1 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Dennison - Bob Brandt", points = 2, type="missable",
    description = "Beat Bob Brandt on the way to the Dennison Derby eve.",
    id = 412142, badge = "467059", published = "3/27/2024 10:42:31 PM", modified = "3/27/2024 10:42:31 PM",
    trigger = prev(dword(0x3CDA24)) == 4 && dword(0x3CDA24) == 5 && dword(0x3CDA30) == 175 && dword(0x3CDA34) == 175 &&
              dword(0x3CDA54) == 1 && dword(0x3CDA40) == 1 && dword(0x3CDA2C) == 1 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Dennison Derby", points = 4, type="missable",
    description = "Get 1st place in the Dennison Derby eve.",
    id = 412143, badge = "467060", published = "3/27/2024 10:42:32 PM", modified = "3/27/2024 10:42:32 PM",
    trigger = dword(0x3CDA30) == 175 && dword(0x3CDA24) == 6 && dword(0x3E5B80) == 4 && prior(dword(0x3E5B80)) == 3 &&
              dword(dword(0x1FFC42C) + 0xFFFFFFF8) == 1 && prev(dword(dword(0x1FFC42C) + 0xFFFFFFF8)) != 1 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Crash Up - Glen Norberg", points = 2, type="missable",
    description = "Beat Glen Norberg on the way to the Kenyon Crash Up eve.",
    id = 412144, badge = "467061", published = "3/27/2024 10:42:32 PM", modified = "3/27/2024 10:42:32 PM",
    trigger = prev(dword(0x3CDA24)) == 4 && dword(0x3CDA24) == 5 && dword(0x3CDA30) == 200 && dword(0x3CDA34) == 200 &&
              dword(0x3CDA54) == 1 && dword(0x3CDA40) == 1 && dword(0x3CDA2C) == 1 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Kenyon Crash Up", points = 5, type="missable",
    description = "Get 1st place in the Kenyon Crash Up eve.",
    id = 412145, badge = "467062", published = "3/27/2024 10:42:32 PM", modified = "3/27/2024 10:42:32 PM",
    trigger = dword(0x3CDA30) == 200 && dword(0x3CDA24) == 6 && dword(0x3E5B80) == 5 && prior(dword(0x3E5B80)) == 4 &&
              dword(dword(0x1FFC42C) + 0xFFFFFFF8) == 1 && prev(dword(dword(0x1FFC42C) + 0xFFFFFFF8)) != 1 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Dundas - Darrell Frandson", points = 2, type="missable",
    description = "Beat Darrell Frandson on the way to the Destruction at Dundas eve.",
    id = 412146, badge = "467063", published = "3/27/2024 10:42:32 PM", modified = "3/27/2024 10:42:32 PM",
    trigger = prev(dword(0x3CDA24)) == 4 && dword(0x3CDA24) == 5 && dword(0x3CDA30) == 225 && dword(0x3CDA34) == 225 &&
              dword(0x3CDA54) == 1 && dword(0x3CDA40) == 1 && dword(0x3CDA2C) == 1 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Destruction at Dundas", points = 5, type="missable",
    description = "Get 1st place in the Destruction at Dundas eve.",
    id = 412147, badge = "467064", published = "3/27/2024 10:42:33 PM", modified = "3/27/2024 10:42:33 PM",
    trigger = dword(0x3CDA30) == 225 && dword(0x3CDA24) == 6 && dword(0x3E5B80) == 5 && prior(dword(0x3E5B80)) == 4 &&
              dword(dword(0x1FFC42C) + 0xFFFFFFF8) == 1 && prev(dword(dword(0x1FFC42C) + 0xFFFFFFF8)) != 1 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Mayhem - Lenny Zabinski", points = 2, type="missable",
    description = "Beat Lenny Zabinski on the way to the Mankato Mayhem eve.",
    id = 412148, badge = "467065", published = "3/27/2024 10:42:33 PM", modified = "3/27/2024 10:42:33 PM",
    trigger = prev(dword(0x3CDA24)) == 4 && dword(0x3CDA24) == 5 && dword(0x3CDA30) == 250 && dword(0x3CDA34) == 250 &&
              dword(0x3CDA54) == 1 && dword(0x3CDA40) == 1 && dword(0x3CDA2C) == 1 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Mankato Mayhem", points = 5, type="missable",
    description = "Get 1st place in the Mankato Mayhem eve.",
    id = 412149, badge = "467066", published = "3/27/2024 10:42:46 PM", modified = "3/27/2024 10:42:46 PM",
    trigger = dword(0x3CDA30) == 250 && dword(0x3CDA24) == 6 && dword(0x3E5B80) == 5 && prior(dword(0x3E5B80)) == 4 &&
              dword(dword(0x1FFC42C) + 0xFFFFFFF8) == 1 && prev(dword(dword(0x1FFC42C) + 0xFFFFFFF8)) != 1 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Anarchy - Darrin Fink", points = 2, type="missable",
    description = "Beat Darrin Fink on the way to the Anoka Anarchy eve.",
    id = 412150, badge = "467067", published = "3/27/2024 10:42:46 PM", modified = "3/27/2024 10:42:46 PM",
    trigger = prev(dword(0x3CDA24)) == 4 && dword(0x3CDA24) == 5 && dword(0x3CDA30) == 275 && dword(0x3CDA34) == 275 &&
              dword(0x3CDA54) == 1 && dword(0x3CDA40) == 1 && dword(0x3CDA2C) == 1 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Anoka Anarchy", points = 5, type="missable",
    description = "Get 1st place in the Anoka Anarchy eve.",
    id = 412151, badge = "467068", published = "3/27/2024 10:42:46 PM", modified = "3/27/2024 10:42:46 PM",
    trigger = dword(0x3CDA30) == 275 && dword(0x3CDA24) == 6 && dword(0x3E5B80) == 5 && prior(dword(0x3E5B80)) == 4 &&
              dword(dword(0x1FFC42C) + 0xFFFFFFF8) == 1 && prev(dword(dword(0x1FFC42C) + 0xFFFFFFF8)) != 1 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Guts - Chuck Holt", points = 2, type="missable",
    description = "Beat Chuck Holt on the way to the Gilroy Blood and Guts eve.",
    id = 412152, badge = "467069", published = "3/27/2024 10:42:47 PM", modified = "3/27/2024 10:42:47 PM",
    trigger = prev(dword(0x3CDA24)) == 4 && dword(0x3CDA24) == 5 && dword(0x3CDA30) == 300 && dword(0x3CDA34) == 300 &&
              dword(0x3CDA54) == 1 && dword(0x3CDA40) == 1 && dword(0x3CDA2C) == 1 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Gilroy Blood and Guts", points = 5, type="missable",
    description = "Get 1st place in the Gilroy Blood and Guts eve.",
    id = 412153, badge = "467070", published = "3/27/2024 10:42:47 PM", modified = "3/27/2024 10:42:47 PM",
    trigger = dword(0x3CDA30) == 300 && dword(0x3CDA24) == 6 && dword(0x3E5B80) == 6 && prior(dword(0x3E5B80)) == 5 &&
              dword(dword(0x1FFC42C) + 0xFFFFFFF8) == 1 && prev(dword(dword(0x1FFC42C) + 0xFFFFFFF8)) != 1 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Bust Up - Matthew Kato", points = 2, type="missable",
    description = "Beat Matthew Kato on the way to the Baxter Bust Up eve.",
    id = 412154, badge = "467071", published = "3/27/2024 10:42:47 PM", modified = "3/27/2024 10:42:47 PM",
    trigger = prev(dword(0x3CDA24)) == 4 && dword(0x3CDA24) == 5 && dword(0x3CDA30) == 325 && dword(0x3CDA34) == 325 &&
              dword(0x3CDA54) == 1 && dword(0x3CDA40) == 1 && dword(0x3CDA2C) == 1 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Baxter Bust Up", points = 5, type="missable",
    description = "Get 1st place in the Baxter Bust Up eve.",
    id = 412155, badge = "467072", published = "3/27/2024 10:42:47 PM", modified = "3/27/2024 10:42:47 PM",
    trigger = dword(0x3CDA30) == 325 && dword(0x3CDA24) == 6 && dword(0x3E5B80) == 6 && prior(dword(0x3E5B80)) == 5 &&
              dword(dword(0x1FFC42C) + 0xFFFFFFF8) == 1 && prev(dword(dword(0x1FFC42C) + 0xFFFFFFF8)) != 1 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Speedfest - Jake Harris", points = 3, type="missable",
    description = "Beat Jake Harris on the way to the Ashland Speedfest eve.",
    id = 412156, badge = "467073", published = "3/27/2024 10:42:48 PM", modified = "3/27/2024 10:42:48 PM",
    trigger = prev(dword(0x3CDA24)) == 4 && dword(0x3CDA24) == 5 && dword(0x3CDA30) == 350 && dword(0x3CDA34) == 350 &&
              dword(0x3CDA54) == 1 && dword(0x3CDA40) == 1 && dword(0x3CDA2C) == 1 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Ashland Speedfest", points = 10, type="missable",
    description = "Get 1st place in the Ashland Speedfest eve.",
    id = 412157, badge = "467074", published = "3/27/2024 10:42:48 PM", modified = "3/27/2024 10:42:48 PM",
    trigger = dword(0x3CDA30) == 350 && dword(0x3CDA24) == 6 && dword(0x3E5B80) == 6 && prior(dword(0x3E5B80)) == 5 &&
              dword(dword(0x1FFC42C) + 0xFFFFFFF8) == 1 && prev(dword(dword(0x1FFC42C) + 0xFFFFFFF8)) != 1 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Apocalypse - Rusty Ripple", points = 3, type="missable",
    description = "Beat Rusty Ripple on the way to the Woodly Apocalypse eve.",
    id = 412158, badge = "467075", published = "3/27/2024 10:42:48 PM", modified = "3/27/2024 10:42:48 PM",
    trigger = prev(dword(0x3CDA24)) == 4 && dword(0x3CDA24) == 5 && dword(0x3CDA30) == 375 && dword(0x3CDA34) == 375 &&
              dword(0x3CDA54) == 1 && dword(0x3CDA40) == 1 && dword(0x3CDA2C) == 1 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Woodly Apocalypse", points = 10, type="missable",
    description = "Get 1st place in the Woodly Apocalypse eve.",
    id = 412159, badge = "467076", published = "3/27/2024 10:42:48 PM", modified = "3/27/2024 10:42:48 PM",
    trigger = dword(0x3CDA30) == 375 && dword(0x3CDA24) == 6 && dword(0x3E5B80) == 6 && prior(dword(0x3E5B80)) == 5 &&
              dword(dword(0x1FFC42C) + 0xFFFFFFF8) == 1 && prev(dword(dword(0x1FFC42C) + 0xFFFFFFF8)) != 1 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Tri County - Stan Fazioli", points = 3, type="missable",
    description = "Beat Stan Fazioli on the way to the Eagan Tri County Derby eve.",
    id = 412160, badge = "467077", published = "3/27/2024 10:42:49 PM", modified = "3/27/2024 10:42:49 PM",
    trigger = prev(dword(0x3CDA24)) == 4 && dword(0x3CDA24) == 5 && dword(0x3CDA30) == 400 && dword(0x3CDA34) == 400 &&
              dword(0x3CDA54) == 1 && dword(0x3CDA40) == 1 && dword(0x3CDA2C) == 1 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Eagan Tri County Derby", points = 10, type="missable",
    description = "Get 1st place in the Eagan Tri County Derby eve.",
    id = 412161, badge = "467078", published = "3/27/2024 10:42:49 PM", modified = "3/27/2024 10:42:49 PM",
    trigger = dword(0x3CDA30) == 400 && dword(0x3CDA24) == 6 && dword(0x3E5B80) == 6 && prior(dword(0x3E5B80)) == 5 &&
              dword(dword(0x1FFC42C) + 0xFFFFFFF8) == 1 && prev(dword(dword(0x1FFC42C) + 0xFFFFFFF8)) != 1 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Hampton - Evan Rattner", points = 3, type="missable",
    description = "Beat Evan Rattner on the way to the Hampton Battles eve.",
    id = 412162, badge = "467079", published = "3/27/2024 10:42:49 PM", modified = "3/27/2024 10:42:49 PM",
    trigger = prev(dword(0x3CDA24)) == 4 && dword(0x3CDA24) == 5 && dword(0x3CDA30) == 425 && dword(0x3CDA34) == 425 &&
              dword(0x3CDA54) == 1 && dword(0x3CDA40) == 1 && dword(0x3CDA2C) == 1 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Hampton Battles", points = 10, type="missable",
    description = "Get 1st place in the Hampton Battles eve.",
    id = 412163, badge = "467080", published = "3/27/2024 10:42:49 PM", modified = "3/27/2024 10:42:49 PM",
    trigger = dword(0x3CDA30) == 425 && dword(0x3CDA24) == 6 && dword(0x3E5B80) == 7 && prior(dword(0x3E5B80)) == 6 &&
              dword(dword(0x1FFC42C) + 0xFFFFFFF8) == 1 && prev(dword(dword(0x1FFC42C) + 0xFFFFFFF8)) != 1 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Havoc - Nelson Thornhill", points = 3, type="missable",
    description = "Beat Nelson Thornhill on the way to the Havoc at Hastings eve.",
    id = 412164, badge = "467081", published = "3/27/2024 10:42:50 PM", modified = "3/27/2024 10:42:50 PM",
    trigger = prev(dword(0x3CDA24)) == 4 && dword(0x3CDA24) == 5 && dword(0x3CDA30) == 450 && dword(0x3CDA34) == 450 &&
              dword(0x3CDA54) == 1 && dword(0x3CDA40) == 1 && dword(0x3CDA2C) == 1 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Havoc at Hastings", points = 10, type="missable",
    description = "Get 1st place in the Havoc at Hastings eve.",
    id = 412165, badge = "467082", published = "3/27/2024 10:42:50 PM", modified = "3/27/2024 10:42:50 PM",
    trigger = dword(0x3CDA30) == 450 && dword(0x3CDA24) == 6 && dword(0x3E5B80) == 7 && prior(dword(0x3E5B80)) == 6 &&
              dword(dword(0x1FFC42C) + 0xFFFFFFF8) == 1 && prev(dword(dword(0x1FFC42C) + 0xFFFFFFF8)) != 1 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Daredevil - Howard Jones", points = 3, type="missable",
    description = "Beat Howard Jones on the way to the Dennison Daredevils eve.",
    id = 412166, badge = "467083", published = "3/27/2024 10:43:04 PM", modified = "3/27/2024 10:43:04 PM",
    trigger = prev(dword(0x3CDA24)) == 4 && dword(0x3CDA24) == 5 && dword(0x3CDA30) == 475 && dword(0x3CDA34) == 475 &&
              dword(0x3CDA54) == 1 && dword(0x3CDA40) == 1 && dword(0x3CDA2C) == 1 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Dennison Daredevils", points = 10, type="missable",
    description = "Get 1st place in the Dennison Daredevils eve.",
    id = 412167, badge = "467084", published = "3/27/2024 10:43:04 PM", modified = "3/27/2024 10:43:04 PM",
    trigger = dword(0x3CDA30) == 475 && dword(0x3CDA24) == 6 && dword(0x3E5B80) == 7 && prior(dword(0x3E5B80)) == 6 &&
              dword(dword(0x1FFC42C) + 0xFFFFFFF8) == 1 && prev(dword(dword(0x1FFC42C) + 0xFFFFFFF8)) != 1 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Hard Knocks - David Fellows", points = 4, type="missable",
    description = "Beat David Fellows on the way to the Kenyon Hard Knocks eve.",
    id = 412168, badge = "467085", published = "3/27/2024 10:43:05 PM", modified = "3/27/2024 10:43:05 PM",
    trigger = prev(dword(0x3CDA24)) == 4 && dword(0x3CDA24) == 5 && dword(0x3CDA30) == 500 && dword(0x3CDA34) == 500 &&
              dword(0x3CDA54) == 1 && dword(0x3CDA40) == 1 && dword(0x3CDA2C) == 1 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Kenyon Hard Knocks", points = 10, type="missable",
    description = "Get 1st place in the Kenyon Hard Knocks eve.",
    id = 412169, badge = "467086", published = "3/27/2024 10:43:05 PM", modified = "3/27/2024 10:43:05 PM",
    trigger = dword(0x3CDA30) == 500 && dword(0x3CDA24) == 6 && dword(0x3E5B80) == 7 && prior(dword(0x3E5B80)) == 6 &&
              dword(dword(0x1FFC42C) + 0xFFFFFFF8) == 1 && prev(dword(dword(0x1FFC42C) + 0xFFFFFFF8)) != 1 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Rust and Bust - Charlie Zwolenski", points = 4, type="missable",
    description = "Beat Charlie Zwolenski on the way to the Dundas Rust and Bust eve.",
    id = 412170, badge = "467087", published = "3/27/2024 10:43:05 PM", modified = "3/27/2024 10:43:05 PM",
    trigger = prev(dword(0x3CDA24)) == 4 && dword(0x3CDA24) == 5 && dword(0x3CDA30) == 550 && dword(0x3CDA34) == 550 &&
              dword(0x3CDA54) == 1 && dword(0x3CDA40) == 1 && dword(0x3CDA2C) == 1 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Dundas Rust and Bust", points = 10, type="missable",
    description = "Get 1st place in the Dundas Rust and Bust eve.",
    id = 412171, badge = "467088", published = "3/27/2024 10:43:05 PM", modified = "3/27/2024 10:43:05 PM",
    trigger = dword(0x3CDA30) == 550 && dword(0x3CDA24) == 6 && dword(0x3E5B80) == 8 && prior(dword(0x3E5B80)) == 7 &&
              dword(dword(0x1FFC42C) + 0xFFFFFFF8) == 1 && prev(dword(dword(0x1FFC42C) + 0xFFFFFFF8)) != 1 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Madness - Chase Martin", points = 4, type="missable",
    description = "Beat Chase Martin on the way to the Mankato Madness eve.",
    id = 412172, badge = "467089", published = "3/27/2024 10:43:06 PM", modified = "3/27/2024 10:43:06 PM",
    trigger = prev(dword(0x3CDA24)) == 4 && dword(0x3CDA24) == 5 && dword(0x3CDA30) == 600 && dword(0x3CDA34) == 600 &&
              dword(0x3CDA54) == 1 && dword(0x3CDA40) == 1 && dword(0x3CDA2C) == 1 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Mankato Madness", points = 10, type="missable",
    description = "Get 1st place in the Mankato Madness eve.",
    id = 412173, badge = "467090", published = "3/27/2024 10:43:06 PM", modified = "3/27/2024 10:43:06 PM",
    trigger = dword(0x3CDA30) == 600 && dword(0x3CDA24) == 6 && dword(0x3E5B80) == 8 && prior(dword(0x3E5B80)) == 7 &&
              dword(dword(0x1FFC42C) + 0xFFFFFFF8) == 1 && prev(dword(dword(0x1FFC42C) + 0xFFFFFFF8)) != 1 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0)
)

achievement(
    title = "T-Bone Royale - Ron Yancey", points = 5, type="missable",
    description = "Beat Ron Yancey on the way to the Anoka T-Bone Royale eve.",
    id = 412174, badge = "467091", published = "3/27/2024 10:43:06 PM", modified = "3/27/2024 10:43:06 PM",
    trigger = prev(dword(0x3CDA24)) == 4 && dword(0x3CDA24) == 5 && dword(0x3CDA30) == 650 && dword(0x3CDA34) == 650 &&
              dword(0x3CDA54) == 1 && dword(0x3CDA40) == 1 && dword(0x3CDA2C) == 1 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Anoka T-Bone Royale", points = 10, type="missable",
    description = "Get 1st place in the Anoka T-Bone Royale eve.",
    id = 412175, badge = "467092", published = "3/27/2024 10:43:06 PM", modified = "3/27/2024 10:43:06 PM",
    trigger = dword(0x3CDA30) == 650 && dword(0x3CDA24) == 6 && dword(0x3E5B80) == 9 && prior(dword(0x3E5B80)) == 8 &&
              dword(dword(0x1FFC42C) + 0xFFFFFFF8) == 1 && prev(dword(dword(0x1FFC42C) + 0xFFFFFFF8)) != 1 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Smash and Pass - Grant McBain", points = 5, type="missable",
    description = "Beat Grant McBain on the way to the Gilroy Smash and Pass eve.",
    id = 412176, badge = "467093", published = "3/27/2024 10:43:07 PM", modified = "3/27/2024 10:43:07 PM",
    trigger = prev(dword(0x3CDA24)) == 4 && dword(0x3CDA24) == 5 && dword(0x3CDA30) == 700 && dword(0x3CDA34) == 700 &&
              dword(0x3CDA54) == 1 && dword(0x3CDA40) == 1 && dword(0x3CDA2C) == 1 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Gilroy Smash and Pass", points = 10, type="missable",
    description = "Get 1st in the Gilroy Smash and Pass eve.",
    id = 412177, badge = "467094", published = "3/27/2024 10:43:07 PM", modified = "3/27/2024 10:43:07 PM",
    trigger = dword(0x3CDA30) == 700 && dword(0x3CDA24) == 6 && dword(0x3E5B80) == 9 && prior(dword(0x3E5B80)) == 8 &&
              dword(dword(0x1FFC42C) + 0xFFFFFFF8) == 1 && prev(dword(dword(0x1FFC42C) + 0xFFFFFFF8)) != 1 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Big One - Pat Hurley", points = 5, type="missable",
    description = "Beat Pat Hurley on the way to the Baxter Big One eve.",
    id = 412178, badge = "467095", published = "3/27/2024 10:43:07 PM", modified = "3/27/2024 10:43:07 PM",
    trigger = prev(dword(0x3CDA24)) == 4 && dword(0x3CDA24) == 5 && dword(0x3CDA30) == 750 && dword(0x3CDA34) == 750 &&
              dword(0x3CDA54) == 1 && dword(0x3CDA40) == 1 && dword(0x3CDA2C) == 1 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Baxter Big One", points = 10, type="missable",
    description = "Get 1st in the Baxter Big One eve.",
    id = 412179, badge = "467096", published = "3/27/2024 10:43:08 PM", modified = "3/27/2024 10:43:08 PM",
    trigger = dword(0x3CDA30) == 750 && dword(0x3CDA24) == 6 && dword(0x3E5B80) == 9 && prior(dword(0x3E5B80)) == 8 &&
              dword(dword(0x1FFC42C) + 0xFFFFFFF8) == 1 && prev(dword(dword(0x1FFC42C) + 0xFFFFFFF8)) != 1 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Destruction Championship", points = 25, type="win_condition",
    description = "Get 1st in the Destruction Championship eve.",
    id = 412180, badge = "467097", published = "3/27/2024 10:43:08 PM", modified = "4/2/2024 1:13:20 AM",
    trigger = dword(0x3CDA30) == 10 && dword(0x3E5B80) == 9 && dword(0x3CDA24) == 6 && prior(dword(0x3E5B80)) == 8 &&
              dword(dword(0x1FFC42C) + 0xFFFFFFF8) == 1 && prev(dword(dword(0x1FFC42C) + 0xFFFFFFF8)) != 1 &&
              dword(0x4AE4D0) == 4294967295 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0) &&
              dword(0x3CDA00) != 0
)

achievement(
    title = "TJ's - Tom Collins", points = 2,
    description = "Win the race against Tom Collins at TJ's Diner and Maltshop.",
    id = 412181, badge = "467098", published = "3/27/2024 10:43:08 PM", modified = "4/13/2024 3:04:36 PM",
    trigger = repeated(1111, dword(0x4AE4D0) == 0) && dword(0x4AE4D4) == 0 && dword(0x3C43A4) == 1 &&
              prev(dword(0x3CDAC8)) == 0 && dword(0x3CDAC8) == 1 && dword(0x3CDAC4) == 0 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0) &&
              dword(0x3D8130) == 4294967295 && never(dword(0x4AE4D0) == 4294967295) && dword(0x1FFE784) == 0 &&
              never(dword(0x3C4428) <= 2)
)

achievement(
    title = "TJ's - Eddie Delcastro", points = 2,
    description = "Win the race against Eddie Delcastro at TJ's Diner and Maltshop.",
    id = 412182, badge = "467099", published = "3/27/2024 10:43:08 PM", modified = "4/13/2024 3:04:37 PM",
    trigger = repeated(1111, dword(0x4AE4D0) == 1) && dword(0x4AE4D4) == 0 && dword(0x3C43A4) == 1 &&
              prev(dword(0x3CDAC8)) == 0 && dword(0x3CDAC8) == 1 && dword(0x3CDAC4) == 0 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0) &&
              dword(0x3D8130) == 4294967295 && never(dword(0x4AE4D0) == 4294967295) && never(dword(0x3C4428) <= 2)
)

achievement(
    title = "TJ's - Scott Johnson", points = 2,
    description = "Win the race against Scott Johnson at TJ's Diner and Maltshop.",
    id = 412183, badge = "467100", published = "3/27/2024 10:43:23 PM", modified = "4/13/2024 3:04:37 PM",
    trigger = repeated(1111, dword(0x4AE4D0) == 2) && dword(0x4AE4D4) == 0 && dword(0x3C43A4) == 1 &&
              prev(dword(0x3CDAC8)) == 0 && dword(0x3CDAC8) == 1 && dword(0x3CDAC4) == 0 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0) &&
              dword(0x3D8130) == 4294967295 && never(dword(0x4AE4D0) == 4294967295) && never(dword(0x3C4428) <= 2)
)

achievement(
    title = "TJ's - Max Powers", points = 2,
    description = "Win the race against Max Powers at TJ's Diner and Maltshop.",
    id = 412184, badge = "467101", published = "3/27/2024 10:43:23 PM", modified = "4/13/2024 3:04:37 PM",
    trigger = repeated(1111, dword(0x3CDAC4) == 0 && dword(0x4AE4D0) == 3) && dword(0x4AE4D4) == 0 &&
              dword(0x3C43A4) == 1 && prev(dword(0x3CDAC8)) == 0 && dword(0x3CDAC8) == 1 && dword(0x3CDAC4) == 0 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0) &&
              dword(0x3D8130) == 4294967295 && never(dword(0x4AE4D0) == 4294967295) && never(dword(0x3C4428) <= 2)
)

achievement(
    title = "TJ's - Barry Likens", points = 2,
    description = "Win the race against Barry Likens at TJ's Diner and Maltshop.",
    id = 412185, badge = "467102", published = "3/27/2024 10:43:23 PM", modified = "4/13/2024 3:04:37 PM",
    trigger = repeated(1111, dword(0x4AE4D0) == 4) && dword(0x4AE4D4) == 0 && dword(0x3C43A4) == 1 &&
              prev(dword(0x3CDAC8)) == 0 && dword(0x3CDAC8) == 1 && dword(0x3CDAC4) == 0 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0) &&
              dword(0x3D8130) == 4294967295 && never(dword(0x4AE4D0) == 4294967295) && never(dword(0x3C4428) <= 2)
)

achievement(
    title = "TJ's - Corky Inman", points = 2,
    description = "Win the race against Corky Inman at TJ's Diner and Maltshop.",
    id = 412186, badge = "467103", published = "3/27/2024 10:43:23 PM", modified = "4/13/2024 3:04:38 PM",
    trigger = repeated(1111, dword(0x4AE4D0) == 5) && dword(0x4AE4D4) == 0 && dword(0x3C43A4) == 1 &&
              prev(dword(0x3CDAC8)) == 0 && dword(0x3CDAC8) == 1 && dword(0x3CDAC4) == 0 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0) &&
              dword(0x3D8130) == 4294967295 && never(dword(0x4AE4D0) == 4294967295) && never(dword(0x3C4428) <= 2)
)

achievement(
    title = "TJ's - Harrol Bundy", points = 2,
    description = "Win the race against Harrol Bundy at TJ's Diner and Maltshop.",
    id = 412187, badge = "467104", published = "3/27/2024 10:43:24 PM", modified = "4/13/2024 3:04:38 PM",
    trigger = repeated(1111, dword(0x4AE4D0) == 6) && dword(0x4AE4D4) == 0 && dword(0x3C43A4) == 1 &&
              prev(dword(0x3CDAC8)) == 0 && dword(0x3CDAC8) == 1 && dword(0x3CDAC4) == 0 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0) &&
              dword(0x3D8130) == 4294967295 && never(dword(0x4AE4D0) == 4294967295) && never(dword(0x3C4428) <= 2)
)

achievement(
    title = "TJ's - Sam Tallman", points = 2,
    description = "Win the race against Sam Tillman at TJ's Diner and Maltshop.",
    id = 412188, badge = "467105", published = "3/27/2024 10:43:24 PM", modified = "4/13/2024 3:04:38 PM",
    trigger = repeated(1111, dword(0x4AE4D0) == 7) && dword(0x4AE4D4) == 0 && dword(0x3C43A4) == 1 &&
              prev(dword(0x3CDAC8)) == 0 && dword(0x3CDAC8) == 1 && dword(0x3CDAC4) == 0 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0) &&
              dword(0x3D8130) == 4294967295 && never(dword(0x4AE4D0) == 4294967295) && never(dword(0x3C4428) <= 2)
)

achievement(
    title = "TJ's - Matthew Kato", points = 2,
    description = "Win the race against Matthew Kato at TJ's Diner and Maltshop.",
    id = 412189, badge = "467106", published = "3/27/2024 10:43:24 PM", modified = "4/13/2024 3:04:39 PM",
    trigger = repeated(1111, dword(0x4AE4D0) == 8) && dword(0x4AE4D4) == 0 && dword(0x3C43A4) == 1 &&
              prev(dword(0x3CDAC8)) == 0 && dword(0x3CDAC8) == 1 && dword(0x3CDAC4) == 0 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0) &&
              dword(0x3D8130) == 4294967295 && never(dword(0x4AE4D0) == 4294967295) && never(dword(0x3C4428) <= 2)
)

achievement(
    title = "TJ's - Tiger Jones", points = 2,
    description = "Win the race against Tiger Jones at TJ's Diner and Maltshop.",
    id = 412190, badge = "467107", published = "3/27/2024 10:43:24 PM", modified = "4/13/2024 3:04:39 PM",
    trigger = repeated(1111, dword(0x4AE4D0) == 9) && dword(0x4AE4D4) == 0 && dword(0x3C43A4) == 1 &&
              prev(dword(0x3CDAC8)) == 0 && dword(0x3CDAC8) == 1 && dword(0x3CDAC4) == 0 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0) &&
              dword(0x3D8130) == 4294967295 && never(dword(0x4AE4D0) == 4294967295) && never(dword(0x3C4428) <= 2)
)

achievement(
    title = "TJ's - Andy Wheeler", points = 2,
    description = "Win the race against Andy Wheeler at TJ's Diner and Maltshop.",
    id = 412191, badge = "467108", published = "3/27/2024 10:43:25 PM", modified = "4/13/2024 3:04:39 PM",
    trigger = repeated(1111, dword(0x4AE4D0) == 10) && dword(0x4AE4D4) == 0 && dword(0x3C43A4) == 1 &&
              prev(dword(0x3CDAC8)) == 0 && dword(0x3CDAC8) == 1 && dword(0x3CDAC4) == 0 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0) &&
              dword(0x3D8130) == 4294967295 && never(dword(0x4AE4D0) == 4294967295) && never(dword(0x3C4428) <= 2)
)

achievement(
    title = "TJ's - Mike Harder", points = 3,
    description = "Win the race against Mike Harder at TJ's Diner and Maltshop.",
    id = 412192, badge = "467109", published = "3/27/2024 10:43:25 PM", modified = "4/13/2024 3:04:39 PM",
    trigger = repeated(1111, dword(0x4AE4D0) == 11) && dword(0x4AE4D4) == 0 && dword(0x3C43A4) == 1 &&
              prev(dword(0x3CDAC8)) == 0 && dword(0x3CDAC8) == 1 && dword(0x3CDAC4) == 0 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0) &&
              dword(0x3D8130) == 4294967295 && never(dword(0x4AE4D0) == 4294967295) && never(dword(0x3C4428) <= 2)
)

achievement(
    title = "TJ's - Erik Truet", points = 3,
    description = "Win the race against Erik Truet at TJ's Diner and Maltshop.",
    id = 412193, badge = "467110", published = "3/27/2024 10:43:25 PM", modified = "4/13/2024 3:04:40 PM",
    trigger = repeated(1111, dword(0x4AE4D0) == 12) && dword(0x4AE4D4) == 0 && dword(0x3C43A4) == 1 &&
              prev(dword(0x3CDAC8)) == 0 && dword(0x3CDAC8) == 1 && dword(0x3CDAC4) == 0 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0) &&
              dword(0x3D8130) == 4294967295 && never(dword(0x4AE4D0) == 4294967295) && never(dword(0x3C4428) <= 2)
)

achievement(
    title = "TJ's - Kyle Martin", points = 3,
    description = "Win the race against Kyle Martin at TJ's Diner and Maltshop.",
    id = 412194, badge = "467111", published = "3/27/2024 10:43:25 PM", modified = "4/13/2024 3:04:40 PM",
    trigger = repeated(1000, dword(0x4AE4D0) == 13 && never(repeated(1111, dword(0x4AE4D0) != 13))) &&
              dword(0x4AE4D4) == 0 && dword(0x3C43A4) == 1 && prev(dword(0x3CDAC8)) == 0 && dword(0x3CDAC8) == 1 &&
              dword(0x3CDAC4) == 0 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC)), until=) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000, until=) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0, until=) &&
              dword(0x3D8130) == 4294967295 && never(dword(0x4AE4D0) == 4294967295) && never(dword(0x3C4428) <= 2)
)

achievement(
    title = "TJ's - Harvey Battle", points = 3,
    description = "Win the race against Harvey Battle at TJ's Diner and Maltshop.",
    id = 412195, badge = "467112", published = "3/27/2024 10:43:26 PM", modified = "4/13/2024 3:04:40 PM",
    trigger = repeated(1111, dword(0x4AE4D0) == 14) && dword(0x4AE4D4) == 0 && dword(0x3C43A4) == 1 &&
              prev(dword(0x3CDAC8)) == 0 && dword(0x3CDAC8) == 1 && dword(0x3CDAC4) == 0 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0) &&
              dword(0x3D8130) == 4294967295 && never(dword(0x4AE4D0) == 4294967295) && never(dword(0x3C4428) <= 2)
)

achievement(
    title = "TJ's - Peter Henke", points = 3,
    description = "Win the race against Peter Henke at TJ's Diner and Maltshop.",
    id = 412196, badge = "467113", published = "3/27/2024 10:43:26 PM", modified = "4/13/2024 3:04:40 PM",
    trigger = repeated(1111, dword(0x4AE4D0) == 15) && dword(0x4AE4D4) == 0 && dword(0x3C43A4) == 1 &&
              prev(dword(0x3CDAC8)) == 0 && dword(0x3CDAC8) == 1 && dword(0x3CDAC4) == 0 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0) &&
              dword(0x3D8130) == 4294967295 && never(dword(0x4AE4D0) == 4294967295) && never(dword(0x3C4428) <= 2)
)

achievement(
    title = "TJ's - Bruce Eckardt", points = 3,
    description = "Win the race against Bruce Eckardt at TJ's Diner and Maltshop.",
    id = 412197, badge = "467114", published = "3/27/2024 10:43:26 PM", modified = "4/13/2024 3:04:41 PM",
    trigger = repeated(1111, dword(0x4AE4D0) == 16) && dword(0x4AE4D4) == 0 && dword(0x3C43A4) == 1 &&
              prev(dword(0x3CDAC8)) == 0 && dword(0x3CDAC8) == 1 && dword(0x3CDAC4) == 0 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0) &&
              dword(0x3D8130) == 4294967295 && never(dword(0x4AE4D0) == 4294967295) && never(dword(0x3C4428) <= 2)
)

achievement(
    title = "TJ's - Troy Harder", points = 4,
    description = "Win the race against Troy Harder at TJ's Diner and Maltshop.",
    id = 412198, badge = "467115", published = "3/27/2024 10:43:27 PM", modified = "4/13/2024 3:04:41 PM",
    trigger = repeated(1111, dword(0x4AE4D0) == 17) && dword(0x4AE4D4) == 0 && dword(0x3C43A4) == 1 &&
              prev(dword(0x3CDAC8)) == 0 && dword(0x3CDAC8) == 1 && dword(0x3CDAC4) == 0 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0) &&
              dword(0x3D8130) == 4294967295 && never(dword(0x4AE4D0) == 4294967295) && never(dword(0x3C4428) <= 2)
)

achievement(
    title = "Troy's - Josh Black", points = 3,
    description = "Win the race against Josh Black at Troy's Place.",
    id = 412199, badge = "467116", published = "3/27/2024 10:43:27 PM", modified = "4/13/2024 3:04:41 PM",
    trigger = repeated(1111, dword(0x4AE4D0) == 0) && dword(0x4AE4D4) == 1 && dword(0x3C43A4) == 1 &&
              prev(dword(0x3CDAC8)) == 0 && dword(0x3CDAC8) == 1 && dword(0x3CDAC4) == 0 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0) &&
              dword(0x3D8130) == 4294967295 && never(dword(0x4AE4D0) == 4294967295) && never(dword(0x3C4428) <= 2)
)

achievement(
    title = "Troy's - William Anderson", points = 3,
    description = "Win the race against William Anderson at Troy's Place.",
    id = 412200, badge = "467117", published = "3/27/2024 10:43:36 PM", modified = "4/13/2024 3:04:41 PM",
    trigger = repeated(1111, dword(0x4AE4D0) == 1) && dword(0x4AE4D4) == 1 && dword(0x3C43A4) == 1 &&
              prev(dword(0x3CDAC8)) == 0 && dword(0x3CDAC8) == 1 && dword(0x3CDAC4) == 0 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0) &&
              dword(0x3D8130) == 4294967295 && never(dword(0x4AE4D0) == 4294967295) && never(dword(0x3C4428) <= 2)
)

achievement(
    title = "Troy's - Bubba Murray", points = 3,
    description = "Win the race against Bubba Murray at Troy's Place.",
    id = 412201, badge = "467118", published = "3/27/2024 10:43:36 PM", modified = "4/13/2024 3:04:42 PM",
    trigger = repeated(1111, dword(0x4AE4D0) == 2) && dword(0x4AE4D4) == 1 && dword(0x3C43A4) == 1 &&
              prev(dword(0x3CDAC8)) == 0 && dword(0x3CDAC8) == 1 && dword(0x3CDAC4) == 0 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0) &&
              dword(0x3D8130) == 4294967295 && never(dword(0x4AE4D0) == 4294967295) && never(dword(0x3C4428) <= 2)
)

achievement(
    title = "Troy's - Matthew Kato", points = 3,
    description = "Win the race against Matthew Kato at Troy's Place.",
    id = 412202, badge = "467119", published = "3/27/2024 10:43:37 PM", modified = "4/13/2024 3:04:42 PM",
    trigger = repeated(1111, dword(0x4AE4D0) == 3) && dword(0x4AE4D4) == 1 && dword(0x3C43A4) == 1 &&
              prev(dword(0x3CDAC8)) == 0 && dword(0x3CDAC8) == 1 && dword(0x3CDAC4) == 0 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0) &&
              dword(0x3D8130) == 4294967295 && never(dword(0x4AE4D0) == 4294967295) && never(dword(0x3C4428) <= 2)
)

achievement(
    title = "Troy's - Junior Delcastro", points = 3,
    description = "Win the race against Junior Delcastro at Troy's Place.",
    id = 412203, badge = "467120", published = "3/27/2024 10:43:37 PM", modified = "4/13/2024 3:04:42 PM",
    trigger = repeated(1111, dword(0x4AE4D0) == 4) && dword(0x4AE4D4) == 1 && dword(0x3C43A4) == 1 &&
              prev(dword(0x3CDAC8)) == 0 && dword(0x3CDAC8) == 1 && dword(0x3CDAC4) == 0 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0) &&
              dword(0x3D8130) == 4294967295 && never(dword(0x4AE4D0) == 4294967295) && never(dword(0x3C4428) <= 2)
)

achievement(
    title = "Troy's - Mike Harder", points = 4,
    description = "Win the race against Mike Harder at Troy's Place.",
    id = 412204, badge = "467121", published = "3/27/2024 10:43:37 PM", modified = "4/13/2024 3:04:43 PM",
    trigger = repeated(1111, dword(0x4AE4D0) == 5) && dword(0x4AE4D4) == 1 && dword(0x3C43A4) == 1 &&
              prev(dword(0x3CDAC8)) == 0 && dword(0x3CDAC8) == 1 && dword(0x3CDAC4) == 0 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0) &&
              dword(0x3D8130) == 4294967295 && never(dword(0x4AE4D0) == 4294967295) && never(dword(0x3C4428) <= 2)
)

achievement(
    title = "Troy's - Derek Blom", points = 4,
    description = "Win the race against Derek Blom at Troy's Place.",
    id = 412205, badge = "467122", published = "3/27/2024 10:43:37 PM", modified = "4/13/2024 3:04:43 PM",
    trigger = repeated(1111, dword(0x4AE4D0) == 6) && dword(0x4AE4D4) == 1 && dword(0x3C43A4) == 1 &&
              prev(dword(0x3CDAC8)) == 0 && dword(0x3CDAC8) == 1 && dword(0x3CDAC4) == 0 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0) &&
              dword(0x3D8130) == 4294967295 && never(dword(0x4AE4D0) == 4294967295) && never(dword(0x3C4428) <= 2)
)

achievement(
    title = "Troy's - Kevin Pritchard", points = 4,
    description = "Win the race against Kevin Pritchard at Troy's Place.",
    id = 412206, badge = "467123", published = "3/27/2024 10:43:38 PM", modified = "4/13/2024 3:04:49 PM",
    trigger = repeated(1111, dword(0x4AE4D0) == 7) && dword(0x4AE4D4) == 1 && dword(0x3C43A4) == 1 &&
              prev(dword(0x3CDAC8)) == 0 && dword(0x3CDAC8) == 1 && dword(0x3CDAC4) == 0 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0) &&
              dword(0x3D8130) == 4294967295 && never(dword(0x4AE4D0) == 4294967295) && never(dword(0x3C4428) <= 2)
)

achievement(
    title = "Troy's - Bruce Eckardt", points = 4,
    description = "Win the race against Bruce Eckardt at Troy's Place.",
    id = 412207, badge = "467124", published = "3/27/2024 10:43:38 PM", modified = "4/13/2024 3:04:50 PM",
    trigger = repeated(1111, dword(0x4AE4D0) == 8) && dword(0x4AE4D4) == 1 && dword(0x3C43A4) == 1 &&
              prev(dword(0x3CDAC8)) == 0 && dword(0x3CDAC8) == 1 && dword(0x3CDAC4) == 0 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0) &&
              dword(0x3D8130) == 4294967295 && never(dword(0x4AE4D0) == 4294967295) && never(dword(0x3C4428) <= 2)
)

achievement(
    title = "Infield Race 1", points = 10,
    description = "Beat the Infield Race 1 time trial in career mode in under 1:08.0.",
    id = 412208, badge = "467125", published = "3/27/2024 10:43:57 PM", modified = "4/2/2024 1:24:17 AM",
    trigger = dword(0x4AE4D0) == 4294967295 && dword(0x3CDA88) == 1 &&
              trigger_when(tally(2, repeated(2,
                  prior(dword(0x3CDA00)) == 5 && prev(dword(dword(0x1FFDD40) + 0xFFF9E174)) == 0 &&
                  dword(dword(0x1FFDD40) + 0xFFF9E174) == 1 && never(dword(dword(0x1FFDD40) + 0xFFF9E160) != 1)))
              ) && dword(0x3CDA8C) <= 4266 && dword(0x3CDA24) == 6 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) && dword(0x3CDA30) == 10 &&
              trigger_when(prior(dword(0x3CDA00)) == 5) && trigger_when(dword(0x3CDA00) == 9) &&
              dword(dword(0x1FFDD40) + 0xFFF9E160) == 1 && never(prior(dword(0x3CDA00)) != 5) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Infield Race 2", points = 10,
    description = "Beat the Infield Race 2 time trial in career mode in under 1:17.0.",
    id = 412209, badge = "467126", published = "3/27/2024 10:43:57 PM", modified = "3/27/2024 10:43:57 PM",
    trigger = dword(0x4AE4D0) == 4294967295 && dword(0x3CDA88) == 1 &&
              trigger_when(tally(2, repeated(2,
                  prior(dword(0x3CDA00)) == 6 && prev(dword(dword(0x1FFDD40) + 0xFFF9E174)) == 0 &&
                  dword(dword(0x1FFDD40) + 0xFFF9E174) == 1 && never(dword(dword(0x1FFDD40) + 0xFFF9E160) != 1)))
              ) && dword(0x3CDA8C) <= 4790 && dword(0x3CDA24) == 6 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              disable_when(dword(0x3CDA30) == 75 && dword(0xB63344) > 10000) && dword(0x3CDA30) == 10 &&
              trigger_when(prior(dword(0x3CDA00)) == 6) && trigger_when(dword(0x3CDA00) == 9) &&
              dword(dword(0x1FFDD40) + 0xFFF9E160) == 1 && never(prior(dword(0x3CDA00)) != 6) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Career Killer I", points = 10,
    description = "Get at least 50 kills during career mode.",
    id = 412210, badge = "467127", published = "3/27/2024 10:44:06 PM", modified = "3/28/2024 7:54:11 PM",
    trigger = prior(dword(dword(0x3D9394) + 0x00017C)) < 50 && dword(dword(0x3D9394) + 0x00017C) >= 50 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              never(dword(0x3E9704) == 0) && prev(dword(0x3CDA88)) == 1 &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0) &&
              dword(dword(0x3D9394) + 0x00017C) > 0
)

achievement(
    title = "Career Killer II", points = 25, type="missable",
    description = "Get at least 100 kills during career mode.",
    id = 412211, badge = "467128", published = "3/27/2024 10:44:06 PM", modified = "3/28/2024 7:54:11 PM",
    trigger = prior(dword(dword(0x3D9394) + 0x00017C)) < 100 && dword(dword(0x3D9394) + 0x00017C) >= 100 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              never(dword(0x3E9704) == 0) && prev(dword(0x3CDA88)) == 1 &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0) &&
              dword(dword(0x3D9394) + 0x00017C) > 0
)

achievement(
    title = "Career Hits I", points = 10,
    description = "Get at least 50 hits during career mode.",
    id = 412212, badge = "467129", published = "3/27/2024 10:44:06 PM", modified = "3/28/2024 7:54:12 PM",
    trigger = prior(dword(dword(0x3D9394) + 0x000178)) < 50 && dword(dword(0x3D9394) + 0x000178) >= 50 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              never(dword(0x3E9704) == 0) && prev(dword(0x3CDA88)) == 1 &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0) &&
              dword(dword(0x3D9394) + 0x000178) > 0
)

achievement(
    title = "Career Hits II", points = 25, type="missable",
    description = "Get at least 100 hits during career mode.",
    id = 412213, badge = "467130", published = "3/27/2024 10:44:06 PM", modified = "3/28/2024 7:54:12 PM",
    trigger = prior(dword(dword(0x3D9394) + 0x000178)) < 100 && dword(dword(0x3D9394) + 0x000178) >= 100 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              never(dword(0x3E9704) == 0) && prev(dword(0x3CDA88)) == 1 &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0) &&
              dword(dword(0x3D9394) + 0x000178) > 0
)

achievement(
    title = "Crash Course - Suicide Surprise", points = 2,
    description = "Finish 1st place in the Suicide Surprise dare in A Crash Course.",
    id = 412214, badge = "467131", published = "3/27/2024 10:44:31 PM", modified = "3/27/2024 10:44:31 PM",
    trigger = dword(0x3D8124) == 4 && dword(0x3D8130) == 0 && dword(0x3D8150) == 0 && dword(0x3D8154) == 1 &&
              dword(0x3C43E4) == 4 && dword(0x3C43A4) == 1 && prev(dword(0x3CDAC8)) == 0 && dword(0x3CDAC8) == 1 &&
              dword(0x3CDA88) == 1 &&
              (dword(dword(0x018DB4) + 0xFFFFFCC0) == 1) || dword(dword(0x01A5DC) + 0xFFFFFF40) == 1 ||
              dword(dword(0x437BC4) + 0xFFFFF404) == 1 &&
              disable_when(((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000) && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Crash Course - Demolition Derby", points = 2,
    description = "Finish 1st place in the Demolition Derby dare in A Crash Course.",
    id = 412215, badge = "467132", published = "3/27/2024 10:44:31 PM", modified = "3/27/2024 10:44:31 PM",
    trigger = dword(0x3D8124) == 4 && dword(0x3D8130) == 0 && dword(0x3D8150) == 1 && dword(0x3D8154) == 1 &&
              dword(0x3C43A4) > 0 && prev(dword(0x3CDAC8)) == 0 && dword(0x3CDAC8) == 1 && dword(0x3CDA88) == 1 &&
              (dword(dword(0x018DB4) + 0xFFFFFCC0) == 1) || dword(dword(0x01A5DC) + 0xFFFFFF40) == 1 ||
              dword(dword(0x437BC4) + 0xFFFFF404) == 1 &&
              disable_when(((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000) && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Crash Course - Figure 8 Jump", points = 2,
    description = "Finish 1st place in the Figure 8 Jump Race dare in A Crash Course.",
    id = 412216, badge = "467133", published = "3/27/2024 10:44:31 PM", modified = "3/27/2024 10:44:31 PM",
    trigger = dword(0x3D8124) == 4 && dword(0x3D8130) == 0 && dword(0x3D8150) == 2 && dword(0x3D8154) == 1 &&
              dword(0x3C43E4) == 4 && dword(0x3C43A4) == 1 && prev(dword(0x3CDAC8)) == 0 && dword(0x3CDAC8) == 1 &&
              dword(0x3CDA88) == 1 &&
              (dword(dword(0x018DB4) + 0xFFFFFCC0) == 1) || dword(dword(0x01A5DC) + 0xFFFFFF40) == 1 ||
              dword(dword(0x437BC4) + 0xFFFFF404) == 1 &&
              disable_when(((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000) && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Crash Course - No Rules", points = 2,
    description = "Finish 1st place in the No Rules Race dare in A Crash Course.",
    id = 412217, badge = "467134", published = "3/27/2024 10:44:31 PM", modified = "3/27/2024 10:44:31 PM",
    trigger = dword(0x3D8124) == 4 && dword(0x3D8130) == 0 && dword(0x3D8150) == 3 && dword(0x3D8154) == 1 &&
              dword(0x3C43E4) == 3 && dword(0x3C43A4) == 1 && prev(dword(0x3CDAC8)) == 0 && dword(0x3CDAC8) == 1 &&
              dword(0x3CDA88) == 1 &&
              (dword(dword(0x018DB4) + 0xFFFFFCC0) == 1) || dword(dword(0x01A5DC) + 0xFFFFFF40) == 1 ||
              dword(dword(0x437BC4) + 0xFFFFF404) == 1 &&
              disable_when(((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000) && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Technical - Whip Around", points = 2,
    description = "Finish 1st place in the Whip Around Race dare in The Technical Circuit.",
    id = 412218, badge = "467135", published = "3/27/2024 10:44:32 PM", modified = "3/27/2024 10:44:32 PM",
    trigger = dword(0x3D8124) == 6 && dword(0x3D8130) == 1 && dword(0x3D8150) == 0 && dword(0x3D8154) == 1 &&
              dword(0x3C43E4) == 4 && dword(0x3C43A4) == 1 && prev(dword(0x3CDAC8)) == 0 && dword(0x3CDAC8) == 1 &&
              dword(0x3CDA88) == 1 &&
              (dword(dword(0x018DB4) + 0xFFFFFCC0) == 1) || dword(dword(0x01A5DC) + 0xFFFFFF40) == 1 ||
              dword(dword(0x437BC4) + 0xFFFFF404) == 1 &&
              disable_when(((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000) && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Technical - Shortcut", points = 2,
    description = "Finish 1st place in the Shortcut Race dare in The Technical Circuit.",
    id = 412219, badge = "467136", published = "3/27/2024 10:44:32 PM", modified = "3/27/2024 10:44:32 PM",
    trigger = dword(0x3D8124) == 6 && dword(0x3D8130) == 1 && dword(0x3D8150) == 1 && dword(0x3D8154) == 1 &&
              dword(0x3C43E4) == 4 && dword(0x3C43A4) == 1 && prev(dword(0x3CDAC8)) == 0 && dword(0x3CDAC8) == 1 &&
              dword(0x3CDA88) == 1 &&
              (dword(dword(0x018DB4) + 0xFFFFFCC0) == 1) || dword(dword(0x01A5DC) + 0xFFFFFF40) == 1 ||
              dword(dword(0x437BC4) + 0xFFFFF404) == 1 &&
              disable_when(((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000) && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Technical - Figure 8", points = 2,
    description = "Finish 1st place in the Figure 8 Jump Race dare in The Technical Circuit.",
    id = 412220, badge = "467137", published = "3/27/2024 10:44:32 PM", modified = "3/27/2024 10:44:32 PM",
    trigger = dword(0x3D8124) == 6 && dword(0x3D8130) == 1 && dword(0x3D8150) == 2 && dword(0x3D8154) == 1 &&
              dword(0x3C43E4) == 5 && dword(0x3C43A4) == 1 && prev(dword(0x3CDAC8)) == 0 && dword(0x3CDAC8) == 1 &&
              dword(0x3CDA88) == 1 &&
              (dword(dword(0x018DB4) + 0xFFFFFCC0) == 1) || dword(dword(0x01A5DC) + 0xFFFFFF40) == 1 ||
              dword(dword(0x437BC4) + 0xFFFFF404) == 1 &&
              disable_when(((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000) && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Technical - No Rules", points = 2,
    description = "Finish 1st place in the No Rules Race dare in The Technical Circuit.",
    id = 412221, badge = "467138", published = "3/27/2024 10:44:33 PM", modified = "3/27/2024 10:44:33 PM",
    trigger = dword(0x3D8124) == 6 && dword(0x3D8130) == 1 && dword(0x3D8150) == 3 && dword(0x3D8154) == 1 &&
              dword(0x3C43E4) == 3 && dword(0x3C43A4) == 1 && prev(dword(0x3CDAC8)) == 0 && dword(0x3CDAC8) == 1 &&
              dword(0x3CDA88) == 1 &&
              (dword(dword(0x018DB4) + 0xFFFFFCC0) == 1) || dword(dword(0x01A5DC) + 0xFFFFFF40) == 1 ||
              dword(dword(0x437BC4) + 0xFFFFF404) == 1 &&
              disable_when(((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000) && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Technical - Suicide Race", points = 2,
    description = "Finish 1st place in the Suicide Race dare in The Technical Circuit.",
    id = 412222, badge = "467139", published = "3/27/2024 10:44:33 PM", modified = "3/27/2024 10:44:33 PM",
    trigger = dword(0x3D8124) == 6 && dword(0x3D8130) == 1 && dword(0x3D8150) == 4 && dword(0x3D8154) == 1 &&
              dword(0x3C43E4) == 4 && dword(0x3C43A4) == 1 && prev(dword(0x3CDAC8)) == 0 && dword(0x3CDAC8) == 1 &&
              dword(0x3CDA88) == 1 &&
              (dword(dword(0x018DB4) + 0xFFFFFCC0) == 1) || dword(dword(0x01A5DC) + 0xFFFFFF40) == 1 ||
              dword(dword(0x437BC4) + 0xFFFFF404) == 1 &&
              disable_when(((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000) && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Technical - Flagpole", points = 2,
    description = "Finish 1st place in the Flagpole Race dare in The Technical Circuit.",
    id = 412223, badge = "467140", published = "3/27/2024 10:44:33 PM", modified = "3/27/2024 10:44:33 PM",
    trigger = dword(0x3D8124) == 6 && dword(0x3D8130) == 1 && dword(0x3D8150) == 5 && dword(0x3D8154) == 1 &&
              dword(0x3C43E4) == 4 && dword(0x3C43A4) == 1 && prev(dword(0x3CDAC8)) == 0 && dword(0x3CDAC8) == 1 &&
              dword(0x3CDA88) == 1 &&
              (dword(dword(0x018DB4) + 0xFFFFFCC0) == 1) || dword(dword(0x01A5DC) + 0xFFFFFF40) == 1 ||
              dword(dword(0x437BC4) + 0xFFFFF404) == 1 &&
              disable_when(((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000) && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Destruction - Push Off", points = 2,
    description = "Finish 1st place in the Push Off dare in The Destruction Circuit.",
    id = 412224, badge = "467141", published = "3/27/2024 10:44:33 PM", modified = "3/27/2024 10:44:33 PM",
    trigger = dword(0x3D8124) == 6 && dword(0x3D8130) == 2 && dword(0x3D8150) == 0 && dword(0x3D8154) == 1 &&
              dword(0x3C43A4) > 1 && prev(dword(0x3CDAC8)) == 0 && dword(0x3CDAC8) == 1 && dword(0x3CDA88) == 1 &&
              (dword(dword(0x018DB4) + 0xFFFFFCC0) == 1) || dword(dword(0x01A5DC) + 0xFFFFFF40) == 1 ||
              dword(dword(0x437BC4) + 0xFFFFF404) == 1 &&
              disable_when(((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000) && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Destruction - Chain Race", points = 2,
    description = "Finish 1st place in the Chain Race dare in The Destruction Circuit.",
    id = 412225, badge = "467142", published = "3/27/2024 10:44:34 PM", modified = "3/27/2024 10:44:34 PM",
    trigger = dword(0x3D8124) == 6 && dword(0x3D8130) == 2 && dword(0x3D8150) == 1 && dword(0x3D8154) == 1 &&
              dword(0x3C43E4) == 3 && dword(0x3C43A4) == 1 && prev(dword(0x3CDAC8)) == 0 && dword(0x3CDAC8) == 1 &&
              dword(0x3CDA88) == 1 &&
              (dword(dword(0x018DB4) + 0xFFFFFCC0) == 1) || dword(dword(0x01A5DC) + 0xFFFFFF40) == 1 ||
              dword(dword(0x437BC4) + 0xFFFFF404) == 1 &&
              disable_when(((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000) && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Destruction - Red Rover", points = 2,
    description = "Finish 1st place in the Red Rover dare in The Destruction Circuit.",
    id = 412226, badge = "467143", published = "3/27/2024 10:44:34 PM", modified = "3/27/2024 10:44:34 PM",
    trigger = dword(0x3D8124) == 6 && dword(0x3D8130) == 2 && dword(0x3D8150) == 2 && dword(0x3D8154) == 1 &&
              prev(dword(0x3CDAC8)) == 0 && dword(0x3CDAC8) == 1 && dword(0x3CDA88) == 1 && dword(0x3C43A4) < 100 &&
              (dword(dword(0x018DB4) + 0xFFFFFCC0) == 1) || dword(dword(0x01A5DC) + 0xFFFFFF40) == 1 ||
              dword(dword(0x437BC4) + 0xFFFFF404) == 1 &&
              disable_when(((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000) && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Destruction - Point to Point", points = 2,
    description = "Finish 1st place in the Point to Point dare in The Destruction Circuit.",
    id = 412227, badge = "467144", published = "3/27/2024 10:44:34 PM", modified = "3/27/2024 10:44:34 PM",
    trigger = dword(0x3D8124) == 6 && dword(0x3D8130) == 2 && dword(0x3D8150) == 3 && dword(0x3D8154) == 1 &&
              dword(0x3C43E4) == 2 && dword(0x3C43A4) == 1 && prev(dword(0x3CDAC8)) == 0 && dword(0x3CDAC8) == 1 &&
              dword(0x3CDA88) == 1 &&
              (dword(dword(0x018DB4) + 0xFFFFFCC0) == 1) || dword(dword(0x01A5DC) + 0xFFFFFF40) == 1 ||
              dword(dword(0x437BC4) + 0xFFFFF404) == 1 &&
              disable_when(((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000) && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Destruction - Trailer Derby", points = 2,
    description = "Finish 1st place in the Trailer Derby dare in The Destruction Circuit.",
    id = 412228, badge = "467145", published = "3/27/2024 10:44:34 PM", modified = "3/27/2024 10:44:34 PM",
    trigger = dword(0x3D8124) == 6 && dword(0x3D8130) == 2 && dword(0x3D8150) == 4 && dword(0x3D8154) == 1 &&
              dword(0x3C43E8) == 8 && dword(0x3C4424) == 3 && prev(dword(0x3CDAC8)) == 0 && dword(0x3CDAC8) == 1 &&
              dword(0x3CDA88) == 1 &&
              (dword(dword(0x018DB4) + 0xFFFFFCC0) == 1) || dword(dword(0x01A5DC) + 0xFFFFFF40) == 1 ||
              dword(dword(0x437BC4) + 0xFFFFF404) == 1 &&
              disable_when(((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000) && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Destruction - Demolition Derby", points = 2,
    description = "Finish 1st place in the Demolition Derby dare in The Destruction Circuit.",
    id = 412229, badge = "467146", published = "3/27/2024 10:44:35 PM", modified = "3/27/2024 10:44:35 PM",
    trigger = dword(0x3D8124) == 6 && dword(0x3D8130) == 2 && dword(0x3D8150) == 5 && dword(0x3D8154) == 1 &&
              dword(0x3C43A4) > 0 && prev(dword(0x3CDAC8)) == 0 && dword(0x3CDAC8) == 1 && dword(0x3CDA88) == 1 &&
              (dword(dword(0x018DB4) + 0xFFFFFCC0) == 1) || dword(dword(0x01A5DC) + 0xFFFFFF40) == 1 ||
              dword(dword(0x437BC4) + 0xFFFFF404) == 1 &&
              disable_when(((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000) && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Specialty - School Bus", points = 2,
    description = "Finish 1st place in the School Bus Race dare in The Specialty Circuit.",
    id = 412230, badge = "467147", published = "3/27/2024 10:44:35 PM", modified = "3/27/2024 10:44:35 PM",
    trigger = dword(0x3D8124) == 6 && dword(0x3D8130) == 3 && dword(0x3D8150) == 0 && dword(0x3D8154) == 1 &&
              dword(0x3C43A4) == 1 && dword(0x3C43E4) == 4 && prev(dword(0x3CDAC8)) == 0 && dword(0x3CDAC8) == 1 &&
              dword(0x3CDA88) == 1 &&
              (dword(dword(0x018DB4) + 0xFFFFFCC0) == 1) || dword(dword(0x01A5DC) + 0xFFFFFF40) == 1 ||
              dword(dword(0x437BC4) + 0xFFFFF404) == 1 &&
              disable_when(((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000) && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Specialty - Shortcut", points = 4,
    description = "Finish 1st place in the Shortcut Race dare in The Specialty Circuit.",
    id = 412231, badge = "467148", published = "3/27/2024 10:44:47 PM", modified = "3/27/2024 10:44:47 PM",
    trigger = dword(0x3D8124) == 6 && dword(0x3D8130) == 3 && dword(0x3D8150) == 1 && dword(0x3D8154) == 1 &&
              dword(0x3C43A4) == 1 && dword(0x3C43E4) == 4 && prev(dword(0x3CDAC8)) == 0 && dword(0x3CDAC8) == 1 &&
              dword(0x3CDA88) == 1 &&
              (dword(dword(0x018DB4) + 0xFFFFFCC0) == 1) || dword(dword(0x01A5DC) + 0xFFFFFF40) == 1 ||
              dword(dword(0x437BC4) + 0xFFFFF404) == 1 &&
              disable_when(((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000) && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Specialty - Flagpole", points = 4,
    description = "Finish 1st place in the Flagpole Race dare in The Specialty Circuit.",
    id = 412232, badge = "467149", published = "3/27/2024 10:44:47 PM", modified = "3/27/2024 10:44:47 PM",
    trigger = dword(0x3D8124) == 6 && dword(0x3D8130) == 3 && dword(0x3D8150) == 2 && dword(0x3D8154) == 1 &&
              dword(0x3C43A4) == 1 && dword(0x3C43E4) == 3 && prev(dword(0x3CDAC8)) == 0 && dword(0x3CDAC8) == 1 &&
              dword(0x3CDA88) == 1 &&
              (dword(dword(0x018DB4) + 0xFFFFFCC0) == 1) || dword(dword(0x01A5DC) + 0xFFFFFF40) == 1 ||
              dword(dword(0x437BC4) + 0xFFFFF404) == 1 &&
              disable_when(((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000) && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Specialty - Red Rover", points = 5,
    description = "Finish 1st place in the Red Rover dare in The Specialty Circuit.",
    id = 412233, badge = "467150", published = "3/27/2024 10:44:47 PM", modified = "3/27/2024 10:44:47 PM",
    trigger = dword(0x3D8124) == 6 && dword(0x3D8130) == 3 && dword(0x3D8150) == 3 && dword(0x3D8154) == 1 &&
              dword(0x3C43A4) < 100 && prev(dword(0x3CDAC8)) == 0 && dword(0x3CDAC8) == 1 && dword(0x3CDA88) == 1 &&
              (dword(dword(0x018DB4) + 0xFFFFFCC0) == 1) || dword(dword(0x01A5DC) + 0xFFFFFF40) == 1 ||
              dword(dword(0x437BC4) + 0xFFFFF404) == 1 &&
              disable_when(((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000) && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Specialty - Push Off", points = 3,
    description = "Finish 1st place in the Push Off dare in The Specialty Circuit.",
    id = 412234, badge = "467151", published = "3/27/2024 10:44:47 PM", modified = "3/27/2024 10:44:47 PM",
    trigger = dword(0x3D8124) == 6 && dword(0x3D8130) == 3 && dword(0x3D8150) == 4 && dword(0x3D8154) == 1 &&
              dword(0x3C43A4) > 0 && prev(dword(0x3CDAC8)) == 0 && dword(0x3CDAC8) == 1 && dword(0x3CDA88) == 1 &&
              (dword(dword(0x018DB4) + 0xFFFFFCC0) == 1) || dword(dword(0x01A5DC) + 0xFFFFFF40) == 1 ||
              dword(dword(0x437BC4) + 0xFFFFF404) == 1 &&
              disable_when(((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000) && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Specialty - Figure 8 Bus", points = 2,
    description = "Finish 1st place in the Figure 8 Bus Race dare in The Specialty Circuit.",
    id = 412235, badge = "467152", published = "3/27/2024 10:44:48 PM", modified = "3/27/2024 10:44:48 PM",
    trigger = dword(0x3D8124) == 6 && dword(0x3D8130) == 3 && dword(0x3D8150) == 5 && dword(0x3D8154) == 1 &&
              dword(0x3C43A4) == 1 && dword(0x3C43E4) == 4 && prev(dword(0x3CDAC8)) == 0 && dword(0x3CDAC8) == 1 &&
              dword(0x3CDA88) == 1 &&
              (dword(dword(0x018DB4) + 0xFFFFFCC0) == 1) || dword(dword(0x01A5DC) + 0xFFFFFF40) == 1 ||
              dword(dword(0x437BC4) + 0xFFFFF404) == 1 &&
              disable_when(((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000) && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Good Luck - Figure 8 Jump", points = 3,
    description = "Finish 1st place in the Figure 8 Jump Race dare in Good Luck Out There!",
    id = 412236, badge = "467153", published = "3/27/2024 10:44:48 PM", modified = "3/27/2024 10:44:48 PM",
    trigger = dword(0x3D8124) == 4 && dword(0x3D8130) == 4 && dword(0x3D8150) == 0 && dword(0x3D8154) == 1 &&
              dword(0x3C43A4) == 1 && dword(0x3C43E4) == 4 && prev(dword(0x3CDAC8)) == 0 && dword(0x3CDAC8) == 1 &&
              dword(0x3CDA88) == 1 &&
              (dword(dword(0x018DB4) + 0xFFFFFCC0) == 1) || dword(dword(0x01A5DC) + 0xFFFFFF40) == 1 ||
              dword(dword(0x437BC4) + 0xFFFFF404) == 1 &&
              disable_when(((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000) && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Good Luck - Trailer Derby", points = 4,
    description = "Finish 1st place in the Trailer Derby dare in Good Luck Out There!",
    id = 412237, badge = "467154", published = "3/27/2024 10:44:48 PM", modified = "3/27/2024 10:44:48 PM",
    trigger = dword(0x3D8124) == 4 && dword(0x3D8130) == 4 && dword(0x3D8150) == 1 && dword(0x3D8154) == 1 &&
              dword(0x3C43E4) == 1 && dword(0x3C4424) == 3 && prev(dword(0x3CDAC8)) == 0 && dword(0x3CDAC8) == 1 &&
              dword(0x3CDA88) == 1 &&
              (dword(dword(0x018DB4) + 0xFFFFFCC0) == 1) || dword(dword(0x01A5DC) + 0xFFFFFF40) == 1 ||
              dword(dword(0x437BC4) + 0xFFFFF404) == 1 &&
              disable_when(((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000) && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Good Luck - Flagpole", points = 4,
    description = "Finish 1st place in the Flagpole Race dare in Good Luck Out There!",
    id = 412238, badge = "467155", published = "3/27/2024 10:44:48 PM", modified = "3/27/2024 10:44:48 PM",
    trigger = dword(0x3D8124) == 4 && dword(0x3D8130) == 4 && dword(0x3D8150) == 2 && dword(0x3D8154) == 1 &&
              dword(0x3C43A4) == 1 && dword(0x3C43E4) == 4 && prev(dword(0x3CDAC8)) == 0 && dword(0x3CDAC8) == 1 &&
              dword(0x3CDA88) == 1 &&
              (dword(dword(0x018DB4) + 0xFFFFFCC0) == 1) || dword(dword(0x01A5DC) + 0xFFFFFF40) == 1 ||
              dword(dword(0x437BC4) + 0xFFFFF404) == 1 &&
              disable_when(((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000) && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Good Luck - Gauntlet", points = 3,
    description = "Finish 1st place in the The Gauntlet dare in Good Luck Out There!",
    id = 412239, badge = "467156", published = "3/27/2024 10:44:49 PM", modified = "3/27/2024 10:44:49 PM",
    trigger = dword(0x3D8124) == 4 && dword(0x3D8130) == 4 && dword(0x3D8150) == 3 && dword(0x3D8154) == 1 &&
              dword(0x3C43A4) == 5 && dword(0x3C43E4) >= 1 && prev(dword(0x3CDAC8)) == 0 && dword(0x3CDAC8) == 1 &&
              dword(0x3CDA88) == 1 &&
              (dword(dword(0x018DB4) + 0xFFFFFCC0) == 1) || dword(dword(0x01A5DC) + 0xFFFFFF40) == 1 ||
              dword(dword(0x437BC4) + 0xFFFFF404) == 1 &&
              disable_when(((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000) && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Detention Served", points = 5,
    description = "Have all 13 cars destroyed in a Detention race in Action with at least 70 score, no multi.",
    id = 412240, badge = "467157", published = "3/27/2024 10:45:26 PM", modified = "3/27/2024 10:45:26 PM",
    trigger = dword(0x4332F0) == 1 && dword(0x3D8130) == 4294967295 && dword(0x3CDA88) == 1 && dword(0x3C43E4) == 0 &&
              dword(0x3C43A4) >= 70 && prev(dword(0x3CDAC8)) == 0 && dword(0x3CDAC8) == 1 && dword(0x3C43A8) == 0 &&
              dword(0x1FFE784) > 0 &&
              disable_when(((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000) && dword(0x3CDAB0) == 0) &&
              (((dword(0x1FFE780) == 3 || dword(0x1FFE780) == 4 || dword(0x1FFE780) == 6 || dword(0x1FFE780) == 8 ||
                    dword(0x1FFE780) == 1 || dword(0x1FFE780) == 11 || dword(0x1FFE780) == 0
                ) && dword(0x3E5BB0) == 16) ||
               ((dword(0x1FFE780) == 5 || dword(0x1FFE780) == 7 || dword(0x1FFE780) == 10 || dword(0x1FFE780) == 2 ||
                    dword(0x1FFE780) == 16
                ) && dword(0x3E5BB0) == 17))
)

achievement(
    title = "Car Soccer", points = 10,
    description = "Finish a Soccer Match with at least 5 team points while holding the other team to 0 points in Action mode, no multi.",
    id = 412241, badge = "467158", published = "3/27/2024 10:45:27 PM", modified = "3/27/2024 10:45:27 PM",
    trigger = dword(0x1FFE784) > 0 && dword(0x3E5BB0) == 8 &&
              (dword(0x1FFE780) == 5 || dword(0x1FFE780) == 7 || dword(0x1FFE780) == 10 || dword(0x1FFE780) == 2) &&
              dword(0x4332F0) == 1 && dword(dword(0x3CD5BC) + 0x0007B0) >= 5 && dword(dword(0x3CD5BC) + 0x000EA0) == 0 &&
              dword(0x3CDA88) == 1 && prev(dword(0x3CDAC8)) == 0 && dword(0x3CDAC8) == 1
)

achievement(
    title = "Jump Legend", points = 10,
    description = "On Legend difficulty get 1st place in a Jump race in Action mode, no multi, no turbo feat.",
    id = 412242, badge = "467159", published = "3/27/2024 10:45:27 PM", modified = "3/27/2024 10:45:27 PM",
    trigger = dword(0x1FFD8B8) == 4 && dword(0x3C43A4) == 1 && dword(0x3C43E4) == dword(0x3C43E8) &&
              prev(dword(0x3CDAC8)) == 0 && dword(0x3CDAC8) == 1 && dword(0x4332F0) == 1 && dword(0x3CDA88) == 1 &&
              dword(0x1FFE784) > 0 && dword(0x3E5BB0) == 0 &&
              disable_when(((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000) && dword(0x3CDAB0) == 0) &&
              (dword(dword(0x018DB4) + 0xFFFFFCC0) == 1) || dword(dword(0x01A5DC) + 0xFFFFFF40) == 1 ||
              dword(dword(0x437BC4) + 0xFFFFF404) == 1 && (dword(0x1FFE780) != 9 && dword(0x1FFE780) != 15) &&
              dword(0x3D8130) == 4294967295 && dword(0x3D80E0) == 0
)

achievement(
    title = "Reverse Legend", points = 10,
    description = "On Legend difficulty get 1st place in a Forward-Backward race in Action mode, no multi, no turbo feat.",
    id = 412243, badge = "467160", published = "3/27/2024 10:45:27 PM", modified = "3/27/2024 10:45:27 PM",
    trigger = dword(0x1FFD8B8) == 4 && dword(0x3C43A4) == 1 && dword(0x3C43E4) == dword(0x3C43E8) &&
              dword(0x4332F0) == 1 && prev(dword(0x3CDAC8)) == 0 && dword(0x3CDAC8) == 1 && dword(0x3CDA88) == 1 &&
              dword(0x3D8130) == 4294967295 && dword(0x3D80E0) == 0 && dword(0x1FFE784) > 0 &&
              disable_when(((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000) && dword(0x3CDAB0) == 0) &&
              (dword(dword(0x018DB4) + 0xFFFFFCC0) == 1) || dword(dword(0x01A5DC) + 0xFFFFFF40) == 1 ||
              dword(dword(0x437BC4) + 0xFFFFF404) == 1 &&
              (((dword(0x1FFE780) == 3 || dword(0x1FFE780) == 4 || dword(0x1FFE780) == 6 || dword(0x1FFE780) == 8 ||
                    dword(0x1FFE780) == 11 || dword(0x1FFE780) == 1 || dword(0x1FFE780) == 0
                ) && dword(0x3E5BB0) == 20) ||
               ((dword(0x1FFE780) == 5 || dword(0x1FFE780) == 7 || dword(0x1FFE780) == 10 || dword(0x1FFE780) == 2 ||
                    dword(0x1FFE780) == 16
                ) && dword(0x3E5BB0) == 21))
)

achievement(
    title = "Gauntlet Vengeance", points = 10,
    description = "Finish a Gauntlet race in Action with AI Vengeance turned ON, all other feats turned OFF, no multi.",
    id = 412244, badge = "467161", published = "3/27/2024 10:45:46 PM", modified = "3/27/2024 10:45:46 PM",
    trigger = dword(0x3D80E0) == 0 && dword(0x3D80E4) == 0 && dword(0x3D80E8) == 0 && dword(0x3D80EC) == 0 &&
              dword(0x3D80F0) == 0 && dword(0x3D80F4) == 0 && dword(0x3D80F8) == 0 && dword(0x3D80FC) == 1 &&
              dword(0x4332F0) == 1 && dword(0x3D8130) == 4294967295 && dword(0x3CDA88) == 1 &&
              prev(dword(0x3CDAC8)) == 0 && dword(0x3CDAC8) == 1 && dword(0x3C43E4) >= 1 &&
              dword(0x3C43A4) == dword(0x3C43A8) && dword(0x1FFE784) > 0 &&
              disable_when(((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000) && dword(0x3CDAB0) == 0) &&
              (dword(dword(0x018DB4) + 0xFFFFFCC0) == 1) || dword(dword(0x01A5DC) + 0xFFFFFF40) == 1 ||
              dword(dword(0x437BC4) + 0xFFFFF404) == 1 &&
              (((dword(0x1FFE780) == 3 || dword(0x1FFE780) == 4 || dword(0x1FFE780) == 6 || dword(0x1FFE780) == 8 ||
                    dword(0x1FFE780) == 1 || dword(0x1FFE780) == 11 || dword(0x1FFE780) == 0
                ) && dword(0x3E5BB0) == 21) ||
               ((dword(0x1FFE780) == 5 || dword(0x1FFE780) == 7 || dword(0x1FFE780) == 10 || dword(0x1FFE780) == 2 ||
                    dword(0x1FFE780) == 16
                ) && dword(0x3E5BB0) == 22) ||
               (dword(0x1FFE780) == 9 && dword(0x3E5BB0) == 15) ||
               (dword(0x1FFE780) == 15 && dword(0x3E5BB0) == 6))
)

achievement(
    title = "Dead Rover", points = 10,
    description = "Finish 1st place in a Red Rover race in Action with AI Vengeance turned ON, all other feats turned OFF, no multi.",
    id = 412245, badge = "467162", published = "3/27/2024 10:45:46 PM", modified = "3/27/2024 10:45:46 PM",
    trigger = dword(0x3D80E0) == 0 && dword(0x3D80E4) == 0 && dword(0x3D80E8) == 0 && dword(0x3D80EC) == 0 &&
              dword(0x3D80F0) == 0 && dword(0x3D80F4) == 0 && dword(0x3D80F8) == 0 && dword(0x3D80FC) == 1 &&
              dword(0x4332F0) == 1 && prev(dword(0x3CDAC8)) == 0 && dword(0x3CDAC8) == 1 &&
              dword(0x3D8130) == 4294967295 && dword(0x3CDA88) == 1 && dword(0x3C43E4) == dword(0x3C43E8) &&
              dword(0x3C43A4) > 0 && dword(0x1FFE784) > 0 &&
              disable_when(((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000) && dword(0x3CDAB0) == 0) &&
              (dword(dword(0x018DB4) + 0xFFFFFCC0) == 1) || dword(dword(0x01A5DC) + 0xFFFFFF40) == 1 ||
              dword(dword(0x437BC4) + 0xFFFFF404) == 1 &&
              (((dword(0x1FFE780) == 3 || dword(0x1FFE780) == 4 || dword(0x1FFE780) == 6 || dword(0x1FFE780) == 8 ||
                    dword(0x1FFE780) == 1 || dword(0x1FFE780) == 11 || dword(0x1FFE780) == 5 || dword(0x1FFE780) == 7 ||
                    dword(0x1FFE780) == 10 || dword(0x1FFE780) == 2 || dword(0x1FFE780) == 0
                ) && dword(0x3E5BB0) == 5) ||
               (dword(0x1FFE780) == 16 && dword(0x3E5BB0) == 6) ||
               (dword(0x1FFE780) == 9 && dword(0x3E5BB0) == 7))
)

achievement(
    title = "Flagpole Flying", points = 10,
    description = "Finish 1st place in a Flagpole race in Action with AI Vengeance turned ON, all other feats turned OFF, no multi.",
    id = 412246, badge = "467163", published = "3/27/2024 10:45:46 PM", modified = "3/27/2024 10:45:46 PM",
    trigger = dword(0x3D80E0) == 0 && dword(0x3D80E4) == 0 && dword(0x3D80E8) == 0 && dword(0x3D80EC) == 0 &&
              dword(0x3D80F0) == 0 && dword(0x3D80F4) == 0 && dword(0x3D80F8) == 0 && dword(0x3D80FC) == 1 &&
              dword(0x4332F0) == 1 && prev(dword(0x3CDAC8)) == 0 && dword(0x3CDAC8) == 1 &&
              dword(0x3D8130) == 4294967295 && dword(0x3CDA88) == 1 && dword(0x3C43E4) == dword(0x3C43E8) &&
              dword(0x3C43A4) == 1 && dword(0x1FFE784) > 0 &&
              disable_when(((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000) && dword(0x3CDAB0) == 0) &&
              (dword(dword(0x018DB4) + 0xFFFFFCC0) == 1) || dword(dword(0x01A5DC) + 0xFFFFFF40) == 1 ||
              dword(dword(0x437BC4) + 0xFFFFF404) == 1 &&
              (((dword(0x1FFE780) == 3 || dword(0x1FFE780) == 4 || dword(0x1FFE780) == 6 || dword(0x1FFE780) == 8 ||
                    dword(0x1FFE780) == 1 || dword(0x1FFE780) == 11 || dword(0x1FFE780) == 0
                ) && dword(0x3E5BB0) == 19) ||
               ((dword(0x1FFE780) == 5 || dword(0x1FFE780) == 7 || dword(0x1FFE780) == 10 || dword(0x1FFE780) == 2 ||
                    dword(0x1FFE780) == 16
                ) && dword(0x3E5BB0) == 20))
)

achievement(
    title = "Wobble Wobble", points = 5,
    description = "Finish 1st place in a Trailer race in Action with Hardcore turned ON, all other feats turned OFF, no multi.",
    id = 412247, badge = "467164", published = "3/27/2024 10:45:47 PM", modified = "3/27/2024 10:45:47 PM",
    trigger = dword(0x3D80E0) == 0 && dword(0x3D80E4) == 0 && dword(0x3D80E8) == 0 && dword(0x3D80EC) == 0 &&
              dword(0x3D80F0) == 1 && dword(0x3D80F4) == 0 && dword(0x3D80F8) == 0 && dword(0x3D80FC) == 0 &&
              dword(0x4332F0) == 1 && prev(dword(0x3CDAC8)) == 0 && dword(0x3CDAC8) == 1 &&
              dword(0x3D8130) == 4294967295 && dword(0x3CDA88) == 1 && dword(0x3C43E4) == 1 &&
              dword(0x3C4424) == dword(0x3C4428) && dword(0x1FFE784) > 0 &&
              disable_when(((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000) && dword(0x3CDAB0) == 0) &&
              (dword(dword(0x018DB4) + 0xFFFFFCC0) == 1) || dword(dword(0x01A5DC) + 0xFFFFFF40) == 1 ||
              dword(dword(0x437BC4) + 0xFFFFF404) == 1 &&
              (((dword(0x1FFE780) == 3 || dword(0x1FFE780) == 4 || dword(0x1FFE780) == 6 || dword(0x1FFE780) == 8 ||
                    dword(0x1FFE780) == 1 || dword(0x1FFE780) == 11
                ) && dword(0x3E5BB0) == 11) ||
               ((dword(0x1FFE780) == 5 || dword(0x1FFE780) == 7 || dword(0x1FFE780) == 10 || dword(0x1FFE780) == 2 ||
                    dword(0x1FFE780) == 9 || dword(0x1FFE780) == 16
                ) && dword(0x3E5BB0) == 12) ||
               (dword(0x1FFE780) == 15 && dword(0x3E5BB0) == 4) ||
               (dword(0x1FFE780) == 0 && dword(0x3E5BB0) == 13))
)

achievement(
    title = "Chain Reaction", points = 5,
    description = "Finish 1st place in a Chain race in Action with Hardcore turned ON, all other feats turned OFF, no multi.",
    id = 412248, badge = "467165", published = "3/27/2024 10:45:47 PM", modified = "3/27/2024 10:45:47 PM",
    trigger = dword(0x3D80E0) == 0 && dword(0x3D80E4) == 0 && dword(0x3D80E8) == 0 && dword(0x3D80EC) == 0 &&
              dword(0x3D80F0) == 1 && dword(0x3D80F4) == 0 && dword(0x3D80F8) == 0 && dword(0x3D80FC) == 0 &&
              dword(0x4332F0) == 1 && dword(0x3D8130) == 4294967295 && prev(dword(0x3CDAC8)) == 0 &&
              dword(0x3CDAC8) == 1 && dword(0x3CDA88) == 1 && dword(0x3C43E4) == dword(0x3C43E8) && dword(0x3C43A4) == 1 &&
              dword(0x1FFE784) > 0 &&
              disable_when(((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000) && dword(0x3CDAB0) == 0) &&
              (dword(dword(0x018DB4) + 0xFFFFFCC0) == 1) || dword(dword(0x01A5DC) + 0xFFFFFF40) == 1 ||
              dword(dword(0x437BC4) + 0xFFFFF404) == 1 &&
              (((dword(0x1FFE780) == 3 || dword(0x1FFE780) == 4 || dword(0x1FFE780) == 6 || dword(0x1FFE780) == 8 ||
                    dword(0x1FFE780) == 1 || dword(0x1FFE780) == 11 || dword(0x1FFE780) == 0
                ) && dword(0x3E5BB0) == 14) ||
               ((dword(0x1FFE780) == 5 || dword(0x1FFE780) == 7 || dword(0x1FFE780) == 10 || dword(0x1FFE780) == 2 ||
                    dword(0x1FFE780) == 16
                ) && dword(0x3E5BB0) == 15) ||
               (dword(0x1FFE780) == 15 && dword(0x3E5BB0) == 5))
)

achievement(
    title = "Hardcore Figure 8", points = 5,
    description = "Finish 1st place in a Figure 8 Jump race in Action with Hardcore turned ON, all other feats turned OFF, no multi.",
    id = 412249, badge = "467166", published = "3/27/2024 10:45:47 PM", modified = "3/27/2024 10:45:47 PM",
    trigger = dword(0x3D80E0) == 0 && dword(0x3D80E4) == 0 && dword(0x3D80E8) == 0 && dword(0x3D80EC) == 0 &&
              dword(0x3D80F0) == 1 && dword(0x3D80F4) == 0 && dword(0x3D80F8) == 0 && dword(0x3D80FC) == 0 &&
              dword(0x4332F0) == 1 && prev(dword(0x3CDAC8)) == 0 && dword(0x3CDAC8) == 1 &&
              dword(0x3D8130) == 4294967295 && dword(0x3CDA88) == 1 && dword(0x3C43E4) == dword(0x3C43E8) &&
              dword(0x3C43A4) == 1 && dword(0x1FFE784) > 0 &&
              disable_when(((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000) && dword(0x3CDAB0) == 0) &&
              (dword(dword(0x018DB4) + 0xFFFFFCC0) == 1) || dword(dword(0x01A5DC) + 0xFFFFFF40) == 1 ||
              dword(dword(0x437BC4) + 0xFFFFF404) == 1 &&
              (((dword(0x1FFE780) == 3 || dword(0x1FFE780) == 4 || dword(0x1FFE780) == 6 || dword(0x1FFE780) == 8 ||
                    dword(0x1FFE780) == 1 || dword(0x1FFE780) == 11 || dword(0x1FFE780) == 0
                ) && dword(0x3E5BB0) == 18) ||
               ((dword(0x1FFE780) == 5 || dword(0x1FFE780) == 7 || dword(0x1FFE780) == 10 || dword(0x1FFE780) == 2 ||
                    dword(0x1FFE780) == 16
                ) && dword(0x3E5BB0) == 19))
)

achievement(
    title = "Chicken Derby", points = 5,
    description = "Finish 1st place in a Demolition Derby in Action with Buh-Kwawk turned ON, all other feats turned OFF, no multi.",
    id = 412250, badge = "467167", published = "3/27/2024 10:45:47 PM", modified = "3/27/2024 10:45:47 PM",
    trigger = dword(0x3D80E0) == 0 && dword(0x3D80E4) == 0 && dword(0x3D80E8) == 1 && dword(0x3D80EC) == 0 &&
              dword(0x3D80F0) == 0 && dword(0x3D80F4) == 0 && dword(0x3D80F8) == 0 && dword(0x3D80FC) == 0 &&
              dword(0x4332F0) == 1 && prev(dword(0x3CDAC8)) == 0 && dword(0x3CDAC8) == 1 &&
              dword(0x3D8130) == 4294967295 && dword(0x3CDA88) == 1 && dword(0x3C43A4) > 0 && dword(0x1FFE784) > 0 &&
              disable_when(((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000) && dword(0x3CDAB0) == 0) &&
              (dword(dword(0x018DB4) + 0xFFFFFCC0) == 1) || dword(dword(0x01A5DC) + 0xFFFFFF40) == 1 ||
              dword(dword(0x437BC4) + 0xFFFFF404) == 1 &&
              (((dword(0x1FFE780) == 3 || dword(0x1FFE780) == 4 || dword(0x1FFE780) == 6 || dword(0x1FFE780) == 8 ||
                    dword(0x1FFE780) == 1 || dword(0x1FFE780) == 11 || dword(0x1FFE780) == 0
                ) && dword(0x3E5BB0) == 15) ||
               ((dword(0x1FFE780) == 5 || dword(0x1FFE780) == 7 || dword(0x1FFE780) == 10 || dword(0x1FFE780) == 2 ||
                    dword(0x1FFE780) == 16
                ) && dword(0x3E5BB0) == 16) ||
               (dword(0x1FFE780) == 9 && dword(0x3E5BB0) == 14))
)

achievement(
    title = "Chicken Push", points = 10,
    description = "Finish 1st place in a Push-Off race in Action with Buh-Kwawk turned ON, all other feats turned OFF, no multi.",
    id = 412251, badge = "467168", published = "3/27/2024 10:45:48 PM", modified = "3/27/2024 10:45:48 PM",
    trigger = dword(0x3D80E0) == 0 && dword(0x3D80E4) == 0 && dword(0x3D80E8) == 1 && dword(0x3D80EC) == 0 &&
              dword(0x3D80F0) == 0 && dword(0x3D80F4) == 0 && dword(0x3D80F8) == 0 && dword(0x3D80FC) == 0 &&
              prev(dword(0x3CDAC8)) == 0 && dword(0x3CDAC8) == 1 && dword(0x4332F0) == 1 &&
              dword(0x3D8130) == 4294967295 && dword(0x3CDA88) == 1 && dword(0x3C43A4) > 0 && dword(0x1FFE784) > 0 &&
              disable_when(((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000) && dword(0x3CDAB0) == 0) &&
              (dword(dword(0x018DB4) + 0xFFFFFCC0) == 1) || dword(dword(0x01A5DC) + 0xFFFFFF40) == 1 ||
              dword(dword(0x437BC4) + 0xFFFFF404) == 1 &&
              (((dword(0x1FFE780) == 3 || dword(0x1FFE780) == 4 || dword(0x1FFE780) == 6 || dword(0x1FFE780) == 8 ||
                    dword(0x1FFE780) == 1 || dword(0x1FFE780) == 5 || dword(0x1FFE780) == 7 || dword(0x1FFE780) == 10 ||
                    dword(0x1FFE780) == 2 || dword(0x1FFE780) == 11
                ) && dword(0x3E5BB0) == 4) ||
               (dword(0x1FFE780) == 16 && dword(0x3E5BB0) == 5))
)

achievement(
    title = "Last Man Standing", points = 5,
    description = "Finish 1st place in a Last Man race in Action with Deadly Ambition turned ON, all other feats turned OFF, no multi.",
    id = 412252, badge = "467169", published = "3/27/2024 10:45:48 PM", modified = "3/27/2024 10:45:48 PM",
    trigger = dword(0x3D80E0) == 0 && dword(0x3D80E4) == 1 && dword(0x3D80E8) == 0 && dword(0x3D80EC) == 0 &&
              dword(0x3D80F0) == 0 && dword(0x3D80F4) == 0 && dword(0x3D80F8) == 0 && dword(0x3D80FC) == 0 &&
              dword(0x4332F0) == 1 && prev(dword(0x3CDAC8)) == 0 && dword(0x3CDAC8) == 1 &&
              dword(0x3D8130) == 4294967295 && dword(0x3CDA88) == 1 && dword(0x3C43E4) == dword(0x3C43E8) &&
              dword(0x3C43A4) == 1 && dword(0x1FFE784) > 0 &&
              disable_when(((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000) && dword(0x3CDAB0) == 0) &&
              (dword(dword(0x018DB4) + 0xFFFFFCC0) == 1) || dword(dword(0x01A5DC) + 0xFFFFFF40) == 1 ||
              dword(dword(0x437BC4) + 0xFFFFF404) == 1 &&
              (((dword(0x1FFE780) == 3 || dword(0x1FFE780) == 4 || dword(0x1FFE780) == 6 || dword(0x1FFE780) == 8 ||
                    dword(0x1FFE780) == 1 || dword(0x1FFE780) == 5 || dword(0x1FFE780) == 7 || dword(0x1FFE780) == 10 ||
                    dword(0x1FFE780) == 2 || dword(0x1FFE780) == 11
                ) && dword(0x3E5BB0) == 1) ||
               ((dword(0x1FFE780) == 16 || dword(0x1FFE780) == 0) && dword(0x3E5BB0) == 2))
)

achievement(
    title = "Shortcut of Death", points = 10,
    description = "Finish 1st place in a Shortcut race in Action with Deadly Ambition turned ON, all other feats turned OFF, no multi.",
    id = 412253, badge = "467170", published = "3/27/2024 10:45:48 PM", modified = "3/27/2024 10:45:48 PM",
    trigger = dword(0x3D80E0) == 0 && dword(0x3D80E4) == 1 && dword(0x3D80E8) == 0 && dword(0x3D80EC) == 0 &&
              dword(0x3D80F0) == 0 && dword(0x3D80F4) == 0 && dword(0x3D80F8) == 0 && dword(0x3D80FC) == 0 &&
              dword(0x4332F0) == 1 && prev(dword(0x3CDAC8)) == 0 && dword(0x3CDAC8) == 1 &&
              dword(0x3D8130) == 4294967295 && dword(0x3CDA88) == 1 && dword(0x3C43E4) == dword(0x3C43E8) &&
              dword(0x3C43A4) == 1 && dword(0x1FFE784) > 0 &&
              disable_when(((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000) && dword(0x3CDAB0) == 0) &&
              (dword(dword(0x018DB4) + 0xFFFFFCC0) == 1) || dword(dword(0x01A5DC) + 0xFFFFFF40) == 1 ||
              dword(dword(0x437BC4) + 0xFFFFF404) == 1 &&
              (((dword(0x1FFE780) == 3 || dword(0x1FFE780) == 4 || dword(0x1FFE780) == 6 || dword(0x1FFE780) == 8 ||
                    dword(0x1FFE780) == 1 || dword(0x1FFE780) == 11 || dword(0x1FFE780) == 5 || dword(0x1FFE780) == 7 ||
                    dword(0x1FFE780) == 10 || dword(0x1FFE780) == 2 || dword(0x1FFE780) == 0
                ) && dword(0x3E5BB0) == 7) ||
               (dword(0x1FFE780) == 16 && dword(0x3E5BB0) == 8))
)

achievement(
    title = "Fast Wrangling", points = 5,
    description = "Take out the car in under 30 seconds in a Wranging race in Action with Fast Forward ON, all other feats turned OFF, no multi.",
    id = 412254, badge = "467171", published = "3/27/2024 10:45:48 PM", modified = "3/27/2024 10:45:48 PM",
    trigger = dword(0x3D80E0) == 0 && dword(0x3D80E4) == 0 && dword(0x3D80E8) == 0 && dword(0x3D80EC) == 0 &&
              dword(0x3D80F0) == 0 && trigger_when(dword(0x3D80F4) == 1) && dword(0x3D80F8) == 0 && dword(0x3D80FC) == 0 &&
              dword(0x4332F0) == 1 && prev(dword(0x3CDAC4)) == 0 && dword(0x3CDA8C) < 1980 &&
              dword(0x3D8130) == 4294967295 && dword(0x3CDA88) == 1 && trigger_when(dword(0x3C43E4) == 0) &&
              dword(0x1FFE784) > 0 &&
              disable_when(((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000) && dword(0x3CDAB0) == 0) &&
              once(dword(0x3C43E4) == 100 && never(dword(0x3CDA8C) < 184)) &&
              trigger_when((dword(0x3CDAC8) == 1 && dword(0x3CDAC4) == 1)) &&
              (((dword(0x1FFE780) == 3 || dword(0x1FFE780) == 4 || dword(0x1FFE780) == 6 || dword(0x1FFE780) == 8 ||
                    dword(0x1FFE780) == 1 || dword(0x1FFE780) == 11
                ) && dword(0x3E5BB0) == 13) ||
               ((dword(0x1FFE780) == 5 || dword(0x1FFE780) == 7 || dword(0x1FFE780) == 10 || dword(0x1FFE780) == 2 ||
                    dword(0x1FFE780) == 16
                ) && dword(0x3E5BB0) == 14) ||
               (dword(0x1FFE780) == 0 && dword(0x3E5BB0) == 12))
)

achievement(
    title = "Survival of the Fastest", points = 10,
    description = "Finish a Survival race in Action with Fast Forward turned ON, all other feats turned OFF, no multi.",
    id = 412255, badge = "467172", published = "3/27/2024 10:45:49 PM", modified = "3/27/2024 10:45:49 PM",
    trigger = dword(0x3D80E0) == 0 && dword(0x3D80E4) == 0 && dword(0x3D80E8) == 0 && dword(0x3D80EC) == 0 &&
              dword(0x3D80F0) == 0 && dword(0x3D80F4) == 1 && dword(0x3D80F8) == 0 && dword(0x3D80FC) == 0 &&
              dword(0x4332F0) == 1 && prev(dword(0x3CDAC8)) == 0 && dword(0x3CDAC8) == 1 && dword(0x3C4424) == 4 &&
              dword(0x3D8130) == 4294967295 && dword(0x3CDA88) == 1 && dword(0x1FFE784) > 0 &&
              disable_when(((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000) && dword(0x3CDAB0) == 0) &&
              (((dword(0x1FFE780) == 3 || dword(0x1FFE780) == 4 || dword(0x1FFE780) == 6 || dword(0x1FFE780) == 8 ||
                    dword(0x1FFE780) == 1 || dword(0x1FFE780) == 11 || dword(0x1FFE780) == 0
                ) && dword(0x3E5BB0) == 10) ||
               ((dword(0x1FFE780) == 5 || dword(0x1FFE780) == 7 || dword(0x1FFE780) == 10 || dword(0x1FFE780) == 2 ||
                    dword(0x1FFE780) == 9 || dword(0x1FFE780) == 16
                ) && dword(0x3E5BB0) == 11))
)

achievement(
    title = "Back In My Day", points = 5,
    description = "Finish 1st place in a School Bus race in Action with Olde Tyme Racyng turned ON, all other feats turned OFF, no multi.",
    id = 412256, badge = "467173", published = "3/27/2024 10:45:49 PM", modified = "3/27/2024 10:45:49 PM",
    trigger = dword(0x3D80E0) == 0 && dword(0x3D80E4) == 0 && dword(0x3D80E8) == 0 && dword(0x3D80EC) == 0 &&
              dword(0x3D80F0) == 0 && dword(0x3D80F4) == 0 && dword(0x3D80F8) == 1 && dword(0x3D80FC) == 0 &&
              dword(0x4332F0) == 1 && prev(dword(0x3CDAC8)) == 0 && dword(0x3CDAC8) == 1 &&
              dword(0x3D8130) == 4294967295 && dword(0x3CDA88) == 1 && dword(0x3C43E4) == dword(0x3C43E8) &&
              dword(0x3C43A4) == 1 && dword(0x1FFE784) > 0 &&
              disable_when(((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000) && dword(0x3CDAB0) == 0) &&
              (dword(dword(0x018DB4) + 0xFFFFFCC0) == 1) || dword(dword(0x01A5DC) + 0xFFFFFF40) == 1 ||
              dword(dword(0x437BC4) + 0xFFFFF404) == 1 &&
              (((dword(0x1FFE780) == 3 || dword(0x1FFE780) == 4 || dword(0x1FFE780) == 6 || dword(0x1FFE780) == 8 ||
                    dword(0x1FFE780) == 1 || dword(0x1FFE780) == 11 || dword(0x1FFE780) == 5 || dword(0x1FFE780) == 7 ||
                    dword(0x1FFE780) == 10 || dword(0x1FFE780) == 2 || dword(0x1FFE780) == 0
                ) && dword(0x3E5BB0) == 6) ||
               (dword(0x1FFE780) == 16 && dword(0x3E5BB0) == 7) ||
               (dword(0x1FFE780) == 9 && dword(0x3E5BB0) == 10) ||
               (dword(0x1FFE780) == 15 && dword(0x3E5BB0) == 1))
)

achievement(
    title = "The Ole Stop and Go", points = 5,
    description = "Finish 1st place in a Stop-and-Go race in Action with Olde Tyme Racyng turned ON, all other feats turned OFF, no multi.",
    id = 412257, badge = "467174", published = "3/27/2024 10:45:49 PM", modified = "3/27/2024 10:45:49 PM",
    trigger = dword(0x3D80E0) == 0 && dword(0x3D80E4) == 0 && dword(0x3D80E8) == 0 && dword(0x3D80EC) == 0 &&
              dword(0x3D80F0) == 0 && dword(0x3D80F4) == 0 && dword(0x3D80F8) == 1 && dword(0x3D80FC) == 0 &&
              dword(0x4332F0) == 1 && prev(dword(0x3CDAC8)) == 0 && dword(0x3CDAC8) == 1 &&
              dword(0x3D8130) == 4294967295 && dword(0x3CDA88) == 1 && dword(0x3C43E4) == dword(0x3C43E8) &&
              dword(0x3C43A4) == 1 && dword(0x1FFE784) > 0 &&
              disable_when(((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000) && dword(0x3CDAB0) == 0) &&
              (dword(dword(0x018DB4) + 0xFFFFFCC0) == 1) || dword(dword(0x01A5DC) + 0xFFFFFF40) == 1 ||
              dword(dword(0x437BC4) + 0xFFFFF404) == 1 &&
              (((dword(0x1FFE780) == 3 || dword(0x1FFE780) == 4 || dword(0x1FFE780) == 6 || dword(0x1FFE780) == 8 ||
                    dword(0x1FFE780) == 1 || dword(0x1FFE780) == 11 || dword(0x1FFE780) == 0
                ) && dword(0x3E5BB0) == 8) ||
               ((dword(0x1FFE780) == 5 || dword(0x1FFE780) == 7 || dword(0x1FFE780) == 10 || dword(0x1FFE780) == 2 ||
                    dword(0x1FFE780) == 16
                ) && dword(0x3E5BB0) == 9) ||
               (dword(0x1FFE780) == 15 && dword(0x3E5BB0) == 2))
)

achievement(
    title = "Hearse Car", points = 1,
    description = "Unlock the Hearse by reaching at least 500 reputation points.",
    id = 412258, badge = "467175", published = "3/27/2024 10:46:03 PM", modified = "3/27/2024 10:46:03 PM",
    trigger = (prev(dword(0x3CC150)) * 100 + prev(dword(0x3CC154)) * 50 + prev(dword(0x3CC158))) < 500 &&
              (dword(0x3CC150) * 100 + dword(0x3CC154) * 50 + dword(0x3CC158)) >= 500 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              never(dword(0x3E9704) == 0) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Hastings Track", points = 2,
    description = "Unlock the Hastings track by reaching at least 2500 reputation points.",
    id = 412259, badge = "467176", published = "3/27/2024 10:46:03 PM", modified = "3/27/2024 10:46:03 PM",
    trigger = (prev(dword(0x3CC150)) * 100 + prev(dword(0x3CC154)) * 50 + prev(dword(0x3CC158))) < 2500 &&
              (dword(0x3CC150) * 100 + dword(0x3CC154) * 50 + dword(0x3CC158)) >= 2500 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              never(dword(0x3E9704) == 0) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Bulldog Car", points = 3,
    description = "Unlock the Bulldog car by reaching at least 5000 reputation points.",
    id = 412260, badge = "467177", published = "3/27/2024 10:46:03 PM", modified = "3/27/2024 10:46:03 PM",
    trigger = (prev(dword(0x3CC150)) * 100 + prev(dword(0x3CC154)) * 50 + prev(dword(0x3CC158))) < 5000 &&
              (dword(0x3CC150) * 100 + dword(0x3CC154) * 50 + dword(0x3CC158)) >= 5000 &&
              (dword(0x3CC150) * 100 + dword(0x3CC154) * 50 + dword(0x3CC158)) < 10000 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              never(dword(0x3E9704) == 0) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Cannon Car", points = 4,
    description = "Unlock the Cannon car by reaching at least 10000 reputation points.",
    id = 412261, badge = "467178", published = "3/27/2024 10:46:04 PM", modified = "3/27/2024 10:46:04 PM",
    trigger = (prev(dword(0x3CC150)) * 100 + prev(dword(0x3CC154)) * 50 + prev(dword(0x3CC158))) < 10000 &&
              (dword(0x3CC150) * 100 + dword(0x3CC154) * 50 + dword(0x3CC158)) >= 10000 &&
              (dword(0x3CC150) * 100 + dword(0x3CC154) * 50 + dword(0x3CC158)) < 15000 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              never(dword(0x3E9704) == 0) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Dundas Track", points = 4,
    description = "Unlock the Dundas track by reaching at least 15000 reputation points.",
    id = 412262, badge = "467179", published = "3/27/2024 10:46:04 PM", modified = "3/27/2024 10:46:04 PM",
    trigger = (prev(dword(0x3CC150)) * 100 + prev(dword(0x3CC154)) * 50 + prev(dword(0x3CC158))) < 15000 &&
              (dword(0x3CC150) * 100 + dword(0x3CC154) * 50 + dword(0x3CC158)) >= 15000 &&
              (dword(0x3CC150) * 100 + dword(0x3CC154) * 50 + dword(0x3CC158)) < 20000 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              never(dword(0x3E9704) == 0) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Empire Car", points = 4,
    description = "Unlock the Empire car by reaching at least 20000 reputation points.",
    id = 412263, badge = "467180", published = "3/27/2024 10:46:04 PM", modified = "3/27/2024 10:46:04 PM",
    trigger = (prev(dword(0x3CC150)) * 100 + prev(dword(0x3CC154)) * 50 + prev(dword(0x3CC158))) < 20000 &&
              (dword(0x3CC150) * 100 + dword(0x3CC154) * 50 + dword(0x3CC158)) >= 20000 &&
              (dword(0x3CC150) * 100 + dword(0x3CC154) * 50 + dword(0x3CC158)) < 25000 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              never(dword(0x3E9704) == 0) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Postal Car", points = 5,
    description = "Unlock the Postal car by reaching at least 25000 reputation points.",
    id = 412264, badge = "467181", published = "3/27/2024 10:46:04 PM", modified = "3/27/2024 10:46:04 PM",
    trigger = (prev(dword(0x3CC150)) * 100 + prev(dword(0x3CC154)) * 50 + prev(dword(0x3CC158))) < 25000 &&
              (dword(0x3CC150) * 100 + dword(0x3CC154) * 50 + dword(0x3CC158)) >= 25000 &&
              (dword(0x3CC150) * 100 + dword(0x3CC154) * 50 + dword(0x3CC158)) < 30000 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              never(dword(0x3E9704) == 0) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Kenyon Track", points = 5,
    description = "Unlock the Kenyon track by reaching at least 30000 reputation points.",
    id = 412265, badge = "467182", published = "3/27/2024 10:46:05 PM", modified = "3/27/2024 10:46:05 PM",
    trigger = (prev(dword(0x3CC150)) * 100 + prev(dword(0x3CC154)) * 50 + prev(dword(0x3CC158))) < 30000 &&
              (dword(0x3CC150) * 100 + dword(0x3CC154) * 50 + dword(0x3CC158)) >= 30000 &&
              (dword(0x3CC150) * 100 + dword(0x3CC154) * 50 + dword(0x3CC158)) < 35000 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              never(dword(0x3E9704) == 0) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Outlaw Car", points = 10,
    description = "Unlock the Outlaw car by reaching at least 35000 reputation points.",
    id = 412266, badge = "467183", published = "3/27/2024 10:46:05 PM", modified = "3/27/2024 10:46:05 PM",
    trigger = (prev(dword(0x3CC150)) * 100 + prev(dword(0x3CC154)) * 50 + prev(dword(0x3CC158))) < 35000 &&
              (dword(0x3CC150) * 100 + dword(0x3CC154) * 50 + dword(0x3CC158)) >= 35000 &&
              (dword(0x3CC150) * 100 + dword(0x3CC154) * 50 + dword(0x3CC158)) < 40000 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              never(dword(0x3E9704) == 0) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Ambulance Car", points = 10,
    description = "Unlock the Ambulance car by reaching at least 40000 reputation points.",
    id = 412267, badge = "467184", published = "3/27/2024 10:46:05 PM", modified = "3/27/2024 10:46:05 PM",
    trigger = (prev(dword(0x3CC150)) * 100 + prev(dword(0x3CC154)) * 50 + prev(dword(0x3CC158))) < 40000 &&
              (dword(0x3CC150) * 100 + dword(0x3CC154) * 50 + dword(0x3CC158)) >= 40000 &&
              (dword(0x3CC150) * 100 + dword(0x3CC154) * 50 + dword(0x3CC158)) < 45000 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              never(dword(0x3E9704) == 0) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Baxter Track", points = 10,
    description = "Unlock the Baxter track by reaching at least 45000 reputation points.",
    id = 412268, badge = "467185", published = "3/27/2024 10:46:05 PM", modified = "3/27/2024 10:46:05 PM",
    trigger = (prev(dword(0x3CC150)) * 100 + prev(dword(0x3CC154)) * 50 + prev(dword(0x3CC158))) < 45000 &&
              (dword(0x3CC150) * 100 + dword(0x3CC154) * 50 + dword(0x3CC158)) >= 45000 &&
              (dword(0x3CC150) * 100 + dword(0x3CC154) * 50 + dword(0x3CC158)) < 50000 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              never(dword(0x3E9704) == 0) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Orbital Car", points = 10,
    description = "Unlock the Orbital car by reaching at least 50000 reputation points.",
    id = 412269, badge = "467186", published = "3/27/2024 10:46:06 PM", modified = "3/27/2024 10:46:06 PM",
    trigger = (prev(dword(0x3CC150)) * 100 + prev(dword(0x3CC154)) * 50 + prev(dword(0x3CC158))) < 50000 &&
              (dword(0x3CC150) * 100 + dword(0x3CC154) * 50 + dword(0x3CC158)) >= 50000 &&
              (dword(0x3CC150) * 100 + dword(0x3CC154) * 50 + dword(0x3CC158)) < 55000 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              never(dword(0x3E9704) == 0) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Mankato Track", points = 10,
    description = "Unlock the Mankato track by reaching at least 55000 reputation points.",
    id = 412270, badge = "467187", published = "3/27/2024 10:46:06 PM", modified = "3/27/2024 10:46:06 PM",
    trigger = (prev(dword(0x3CC150)) * 100 + prev(dword(0x3CC154)) * 50 + prev(dword(0x3CC158))) < 55000 &&
              (dword(0x3CC150) * 100 + dword(0x3CC154) * 50 + dword(0x3CC158)) >= 55000 &&
              (dword(0x3CC150) * 100 + dword(0x3CC154) * 50 + dword(0x3CC158)) < 60000 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              never(dword(0x3E9704) == 0) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Taxi Car", points = 10,
    description = "Unlock the Taxi car by reaching at least 60000 reputation points.",
    id = 412271, badge = "467188", published = "3/27/2024 10:46:06 PM", modified = "3/27/2024 10:46:06 PM",
    trigger = (prev(dword(0x3CC150)) * 100 + prev(dword(0x3CC154)) * 50 + prev(dword(0x3CC158))) < 60000 &&
              (dword(0x3CC150) * 100 + dword(0x3CC154) * 50 + dword(0x3CC158)) >= 60000 &&
              (dword(0x3CC150) * 100 + dword(0x3CC154) * 50 + dword(0x3CC158)) < 65000 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              never(dword(0x3E9704) == 0) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Rocket Car", points = 10,
    description = "Unlock the Rocket car by reaching at least 65000 reputation points.",
    id = 412272, badge = "467189", published = "3/27/2024 10:46:07 PM", modified = "3/27/2024 10:46:07 PM",
    trigger = (prev(dword(0x3CC150)) * 100 + prev(dword(0x3CC154)) * 50 + prev(dword(0x3CC158))) < 65000 &&
              (dword(0x3CC150) * 100 + dword(0x3CC154) * 50 + dword(0x3CC158)) >= 65000 &&
              (dword(0x3CC150) * 100 + dword(0x3CC154) * 50 + dword(0x3CC158)) < 70000 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              never(dword(0x3E9704) == 0) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0)
)

achievement(
    title = "Welch Track", points = 10,
    description = "Unlock the Welch track by reaching at least 70000 reputation points.",
    id = 412273, badge = "467190", published = "3/27/2024 10:46:07 PM", modified = "3/27/2024 10:46:07 PM",
    trigger = (prev(dword(0x3CC150)) * 100 + prev(dword(0x3CC154)) * 50 + prev(dword(0x3CC158))) < 70000 &&
              (dword(0x3CC150) * 100 + dword(0x3CC154) * 50 + dword(0x3CC158)) >= 70000 &&
              (dword(0x3CC150) * 100 + dword(0x3CC154) * 50 + dword(0x3CC158)) < 80000 &&
              disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))) &&
              never(dword(0x3E9704) == 0) &&
              disable_when((dword(0x3CC150) - prev(dword(0x3CC150))) == 1000 && dword(0x3CDAB0) == 0)
)

leaderboard(
    id = 92693, title = "Infield Race 1",
    description = "Time Trial",
    start  = dword(dword(0x1FFDD40) + 0xFFF9E160) == 1 && dword(dword(0x1FFDD40) + 0xFFF9E174) == 0 &&
             dword(0x3CDA8C) > prev(dword(0x3CDA8C)) && prior(dword(0x3CDA00)) == 5 && dword(0x3CDA00) == 9,
    cancel = (dword(dword(0x1FFDD40) + 0xFFF9E160) == 0) || prior(dword(0x3CDA00)) != 5,
    submit = tally(2, repeated(2,
                 (prev(dword(dword(0x1FFDD40) + 0xFFF9E174)) == 0) && dword(dword(0x1FFDD40) + 0xFFF9E174) == 1 &&
                 never(dword(dword(0x1FFDD40) + 0xFFF9E160) != 1))
             ) && prior(dword(0x3CDA00)) == 5 && dword(0x3CDA00) == 9 && dword(dword(0x1FFDD40) + 0xFFF9E160) == 1,
    value  = measured(tally(0, dword(0x3CDA8C) >= 183)) && unless(dword(0x3CDAC4) == 1),
    format = "FRAMES", lower_is_better = true
)

leaderboard(
    id = 92694, title = "Infield Race 2",
    description = "Time Trial",
    start  = dword(dword(0x1FFDD40) + 0xFFF9E160) == 1 && dword(dword(0x1FFDD40) + 0xFFF9E174) == 0 &&
             dword(0x3CDA8C) > prev(dword(0x3CDA8C)) && prior(dword(0x3CDA00)) == 6 && dword(0x3CDA00) == 9,
    cancel = (dword(dword(0x1FFDD40) + 0xFFF9E160) == 0) || prior(dword(0x3CDA00)) != 6,
    submit = tally(2, repeated(2,
                 (prev(dword(dword(0x1FFDD40) + 0xFFF9E174)) == 0) && dword(dword(0x1FFDD40) + 0xFFF9E174) == 1 &&
                 never(dword(dword(0x1FFDD40) + 0xFFF9E160) != 1))
             ) && prior(dword(0x3CDA00)) == 6 && dword(0x3CDA00) == 9 && dword(dword(0x1FFDD40) + 0xFFF9E160) == 1,
    value  = measured(tally(0, dword(0x3CDA8C) >= 183)) && unless(dword(0x3CDAC4) == 1),
    format = "FRAMES", lower_is_better = true
)

leaderboard(
    id = 92695, title = "Career Kills",
    description = "Submits after final eve.",
    start  = dword(dword(0x3D9394) + 0x00017C) > prior(dword(dword(0x3D9394) + 0x00017C)) && dword(0x3CDA30) == 10 &&
             dword(0x3CDA24) == 7 && dword(0x3CDA34) == 0 && dword(0x3E5B80) == 9 && dword(0x4AE4D0) == 4294967295 &&
             disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))),
    cancel = (dword(0x3CDA30) != 10 || dword(0x3E5B80) != 9),
    submit = dword(0x3CDA30) == 10 && dword(0x3CDA24) == 7 && dword(0x3CDA34) == 0 && dword(0x3E5B80) == 9 &&
             dword(0x4AE4D0) == 4294967295,
    value  = measured(((dword(dword(0x3D9394) + 0x00017C)))),
    format = "VALUE"
)

leaderboard(
    id = 92696, title = "Career Hits",
    description = "Submits after final eve.",
    start  = dword(dword(0x3D9394) + 0x000178) > prior(dword(dword(0x3D9394) + 0x000178)) && dword(0x3CDA30) == 10 &&
             dword(0x3CDA24) == 7 && dword(0x3CDA34) == 0 && dword(0x3E5B80) == 9 && dword(0x4AE4D0) == 4294967295 &&
             disable_when(dword(0x4332C0) == 1 && dword(0x3D18BC) > prev(dword(0x3D18BC))),
    cancel = (dword(0x3CDA30) != 10 || dword(0x3E5B80) != 9),
    submit = dword(0x3CDA30) == 10 && dword(0x3CDA24) == 7 && dword(0x3CDA34) == 0 && dword(0x3E5B80) == 9 &&
             dword(0x4AE4D0) == 4294967295,
    value  = measured(((dword(dword(0x3D9394) + 0x000178)))),
    format = "VALUE"
)

leaderboard(
    id = 92697, title = "Soccer Match",
    description = "Most team points scored while holding opponent team to 0.",
    start  = dword(0x1FFE784) > 0 && dword(0x3E5BB0) == 8 &&
             (dword(0x1FFE780) == 5 || dword(0x1FFE780) == 7 || dword(0x1FFE780) == 10 || dword(0x1FFE780) == 2) &&
             dword(0x4332F0) == 1 && dword(dword(0x3CD5BC) + 0x0007B0) > 0 && dword(dword(0x3CD5BC) + 0x000EA0) == 0 &&
             dword(0x3CDA88) == 1 && prev(dword(0x3CDAC8)) == 0 && dword(0x3CDAC8) == 1 && dword(0x3CDA8C) > 13568,
    cancel = (dword(0x3CDAB0) == 7 || dword(0x3CDA8C) < 13568 || dword(0x3E5BB0) != 8),
    submit = dword(0x1FFE784) > 0 && dword(0x3E5BB0) == 8 &&
             (dword(0x1FFE780) == 5 || dword(0x1FFE780) == 7 || dword(0x1FFE780) == 10 || dword(0x1FFE780) == 2) &&
             dword(0x4332F0) == 1 && dword(dword(0x3CD5BC) + 0x0007B0) > 0 && dword(dword(0x3CD5BC) + 0x000EA0) == 0 &&
             dword(0x3CDA88) == 1 && prev(dword(0x3CDAC8)) == 0 && dword(0x3CDAC8) == 1 && dword(0x3CDA8C) > 13568,
    value  = measured(((dword(dword(0x3CD5BC) + 0x0007B0)))),
    format = "VALUE"
)
