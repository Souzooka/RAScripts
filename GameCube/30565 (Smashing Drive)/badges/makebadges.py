import os
from PIL import Image
from typing import Dict

if not os.path.isdir("output"):
    os.mkdir("output")

def load_background_image(file_path):
    return Image.open(file_path).convert("RGB").resize((64, 64), resample=Image.Resampling.LANCZOS)

def load_component(file_path, w, h):
    return Image.open(file_path).convert("RGBA").resize((w, h), resample=Image.Resampling.LANCZOS)

level_bgs = {i: load_background_image(f"level{i}.png") for i in range(1, 10+1)}
bonus_bgs = {i: load_background_image(f"bonus{i}.png") for i in range(1, 3+1)}
route_bgs: Dict[str, Image.Image] = {}
for name in ("earlyBird", "rushHour", "nightOwl", "duskAndWired"):
    route_bgs[name] = load_background_image(f"{name}.png")

border = Image.open("border128.png").resize((64, 64), resample=Image.Resampling.LANCZOS).convert("RGBA")

components = {
    "arrow": load_component("arrow.png", 40, 14),
    "booster": load_component("booster.png", 20, 20),
    "damage": load_component("damage.png", 48, 14),
}

# First, just save copies of the route BGs as is
for name in route_bgs:
    route_bgs[name].save(f"output/{name}.png")

# Now we got bonuses
for i in bonus_bgs:
    img = bonus_bgs[i].copy()
    img.paste(border, mask=border)
    img.save(f"output/bonus{i}.png")

# Survival
for name in route_bgs:
    img = route_bgs[name].copy()
    img.paste(components["damage"], (8, 45))
    img.save(f"output/{name}_survival.png")

# Now individual route cheevos
for i in level_bgs:
    # Boosters
    img = level_bgs[i].copy()
    img.paste(components["booster"], (5, 38), mask=components["booster"])
    img.paste(border, mask=border)
    img.save(f"output/level{i}_boosters.png")

    # Risky Routes
    img = level_bgs[i].copy()
    img.paste(components["arrow"], (5, 42), mask=components["arrow"])
    img.paste(border, mask=border)
    img.save(f"output/level{i}_shortcuts.png")