import os
from PIL import Image

if not os.path.isdir("output"):
    os.mkdir("output")

parts = {
    "block": Image.open("Block.png"),
    "border": Image.open("Border.png"),
    "clapper": Image.open("Clapper.png"),
    "complete": Image.open("Complete.png"),
    "fish": Image.open("Fish.png"),
    "key": Image.open("Key.png"),
}
for i in range(1, 7):
    parts[f"level{i}"] = Image.open(f"Level{i}.png")

COMPONENTS = ["block", "clapper", "complete", "fish", "key"]

for i in range(1, 7):
    # Just the level badge
    badge = Image.new("RGBA", (64, 64))

    # BG + border
    level = parts[f"level{i}"].convert("RGB")
    border = parts["border"].convert("RGBA")
    badge.paste(level)
    badge.paste(border, mask=border)
    badge.save(f"output/level{i}.png")

    # Each individual collectible
    for component in COMPONENTS:
        component_img = parts[component].convert("RGBA")
        badge = Image.new("RGBA", (64, 64))
        badge.paste(level)
        badge.paste(component_img, (12, 12), mask=component_img)
        badge.paste(border, mask=border)
        badge.save(f"output/level{i}_{component}.png")

for img in parts.values():
    img.close()