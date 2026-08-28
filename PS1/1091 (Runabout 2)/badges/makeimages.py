import os
from PIL import Image

if not os.path.isdir("output"):
    os.mkdir("output")

borders = {
    "progression": Image.open("BorderWhite.png").convert("RGBA").resize((64, 64), resample=Image.Resampling.NEAREST),
    "pacifist": Image.open("BorderBlue.png").convert("RGBA").resize((64, 64), resample=Image.Resampling.NEAREST),
    "damage": Image.open("BorderRed.png").convert("RGBA").resize((64, 64), resample=Image.Resampling.NEAREST),
    "time": Image.open("BorderCheckered.png").convert("RGBA").resize((64, 64), resample=Image.Resampling.NEAREST),
}

for i in range(1, 13+1):
    level = Image.open(f"Level{i}.png").convert("RGB").resize((64, 64), resample=Image.Resampling.LANCZOS)

    for name in borders:
        badge = Image.new("RGBA", (64, 64))
        badge.paste(level)
        badge.paste(borders[name], mask=borders[name])
        badge.save(f"output/level{i}_{name}.png")
