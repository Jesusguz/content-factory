import json
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont


ROOT = Path(__file__).resolve().parents[1]
METADATA = ROOT / "docs" / "dataset-valentina-sol.json"
OUTPUT = ROOT / "docs" / "dataset-contact-sheet.jpg"
CATEGORIES = ["playa", "cafeteria", "gym", "viajes", "lifestyle"]
SAMPLES_PER_CATEGORY = 3
THUMB_W = 170
THUMB_H = 255
LABEL_H = 28
PAD = 16
HEADER_H = 42


def load_rows():
    return json.loads(METADATA.read_text(encoding="utf-8"))


def pick_samples(rows):
    selected = []
    for category in CATEGORIES:
        group = [row for row in rows if row["category"] == category]
        indexes = [0, len(group) // 2, len(group) - 1]
        for index in indexes[:SAMPLES_PER_CATEGORY]:
            selected.append(group[index])
    return selected


def main():
    rows = load_rows()
    selected = pick_samples(rows)
    cols = SAMPLES_PER_CATEGORY
    rows_count = len(CATEGORIES)
    width = PAD + cols * (THUMB_W + PAD)
    height = HEADER_H + PAD + rows_count * (THUMB_H + LABEL_H + PAD)
    sheet = Image.new("RGB", (width, height), (245, 242, 236))
    draw = ImageDraw.Draw(sheet)
    font = ImageFont.load_default()
    draw.text((PAD, 12), "Valentina Sol dataset visual QA - 15 samples", fill=(32, 32, 32), font=font)

    for category_index, category in enumerate(CATEGORIES):
        group = [row for row in selected if row["category"] == category]
        for sample_index, row in enumerate(group):
            path = ROOT / row["image_path"]
            image = Image.open(path).convert("RGB")
            image.thumbnail((THUMB_W, THUMB_H))
            x = PAD + sample_index * (THUMB_W + PAD)
            y = HEADER_H + PAD + category_index * (THUMB_H + LABEL_H + PAD)
            frame = Image.new("RGB", (THUMB_W, THUMB_H), (232, 228, 220))
            frame.paste(image, ((THUMB_W - image.width) // 2, (THUMB_H - image.height) // 2))
            sheet.paste(frame, (x, y))
            draw.text((x, y + THUMB_H + 8), f"{category} {row['category_index']:02d}", fill=(32, 32, 32), font=font)

    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    sheet.save(OUTPUT, quality=92)
    print(str(OUTPUT))


if __name__ == "__main__":
    main()
