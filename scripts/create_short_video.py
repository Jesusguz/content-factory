import argparse
import json
import shutil
import subprocess
import textwrap
from datetime import datetime, timezone
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
DEFAULT_FFMPEG = Path(
    r"C:\Users\magdi\AppData\Local\Microsoft\WinGet\Packages"
    r"\Gyan.FFmpeg_Microsoft.Winget.Source_8wekyb3d8bbwe"
    r"\ffmpeg-8.1.1-full_build\bin\ffmpeg.exe"
)
DEFAULT_FFPROBE = DEFAULT_FFMPEG.with_name("ffprobe.exe")


def load_json(path):
    return json.loads((ROOT / path).read_text(encoding="utf-8"))


def resolve_tool(explicit, default_path, name):
    if explicit:
        path = Path(explicit)
        if path.exists():
            return path
    found = shutil.which(name)
    if found:
        return Path(found)
    if default_path.exists():
        return default_path
    raise FileNotFoundError(f"{name} not found")


def pick_evenly(items, count):
    if len(items) <= count:
        return items
    if count == 1:
        return [items[0]]
    indexes = [round(i * (len(items) - 1) / (count - 1)) for i in range(count)]
    return [items[index] for index in indexes]


def select_images(dataset, category, count):
    rows = [row for row in dataset if row["category"] == category]
    rows = sorted(rows, key=lambda row: row["category_index"])
    selected = pick_evenly(rows, count)
    paths = [ROOT / row["image_path"] for row in selected]
    missing = [str(path) for path in paths if not path.exists()]
    if missing:
        raise FileNotFoundError("Missing dataset images: " + ", ".join(missing))
    return selected, paths


def select_subtitles(content, category, total_duration):
    items = content["items"]
    hooks = [row["body"] for row in items if row["content_type"] == "hook" and row["category"] == category]
    captions = [row["body"] for row in items if row["content_type"] == "caption" and row["category"] == category]
    stories = [row["body"] for row in items if row["content_type"] == "story" and row["category"] == category]
    lines = []
    if hooks:
        lines.append(hooks[0])
    if captions:
        lines.append(captions[0])
    if stories:
        parts = [part.strip() for part in stories[0].split("|") if part.strip()]
        lines.extend(parts[:3] if parts else [stories[0]])
    while len(lines) < 5:
        lines.append("Un momento simple tambien puede sentirse como una pausa nueva.")
    lines = lines[:5]
    segment = total_duration / len(lines)
    subtitles = []
    for index, line in enumerate(lines):
        start = index * segment
        end = min(total_duration, (index + 1) * segment - 0.05)
        subtitles.append((start, end, clean_subtitle(line)))
    return subtitles


def clean_subtitle(line):
    text = " ".join(str(line).split())
    if "." in text and len(text) > 76:
        first_sentence = text.split(".", 1)[0].strip()
        if len(first_sentence) >= 24:
            text = first_sentence
    text = textwrap.shorten(text, width=52, placeholder="...")
    return textwrap.fill(text, width=26)


def srt_timestamp(seconds):
    milliseconds = int(round((seconds - int(seconds)) * 1000))
    total_seconds = int(seconds)
    hours = total_seconds // 3600
    minutes = (total_seconds % 3600) // 60
    secs = total_seconds % 60
    return f"{hours:02d}:{minutes:02d}:{secs:02d},{milliseconds:03d}"


def write_srt(path, subtitles):
    blocks = []
    for index, (start, end, text) in enumerate(subtitles, start=1):
        blocks.append(
            f"{index}\n{srt_timestamp(start)} --> {srt_timestamp(end)}\n{text}\n"
        )
    path.write_text("\n".join(blocks), encoding="utf-8")


def write_concat(path, image_paths, duration):
    lines = []
    for image_path in image_paths:
        lines.append(f"file '{image_path.as_posix()}'")
        lines.append(f"duration {duration:.3f}")
    lines.append(f"file '{image_paths[-1].as_posix()}'")
    path.write_text("\n".join(lines), encoding="utf-8")


def run_command(command, cwd):
    result = subprocess.run(command, cwd=cwd, text=True, capture_output=True)
    return {
        "returncode": result.returncode,
        "stdout": result.stdout,
        "stderr": result.stderr,
        "command": command,
    }


def ffprobe_video(ffprobe, video_path):
    command = [
        str(ffprobe),
        "-v",
        "error",
        "-select_streams",
        "v:0",
        "-show_entries",
        "stream=codec_name,width,height,r_frame_rate,duration",
        "-of",
        "json",
        str(video_path),
    ]
    result = run_command(command, ROOT)
    if result["returncode"] != 0:
        return result
    parsed = json.loads(result["stdout"])
    result["parsed"] = parsed
    return result


def parse_args():
    parser = argparse.ArgumentParser(description="Create a short vertical video from Valentina Sol images.")
    parser.add_argument("--category", default="lifestyle")
    parser.add_argument("--image-count", type=int, default=6)
    parser.add_argument("--seconds-per-image", type=float, default=2.5)
    parser.add_argument("--dataset-json", default="docs/dataset-valentina-sol.json")
    parser.add_argument("--content-json", default="docs/content-batch-valentina-sol.json")
    parser.add_argument("--output", default="output/videos/valentina_sol_lifestyle_short.mp4")
    parser.add_argument("--srt", default="output/videos/valentina_sol_lifestyle_short.srt")
    parser.add_argument("--concat", default="output/videos/valentina_sol_lifestyle_concat.txt")
    parser.add_argument("--result-json", default="docs/video-pipeline-result.json")
    parser.add_argument("--ffmpeg", default=None)
    parser.add_argument("--ffprobe", default=None)
    return parser.parse_args()


def main():
    args = parse_args()
    dataset = load_json(args.dataset_json)
    content = load_json(args.content_json)
    ffmpeg = resolve_tool(args.ffmpeg, DEFAULT_FFMPEG, "ffmpeg")
    ffprobe = resolve_tool(args.ffprobe, DEFAULT_FFPROBE, "ffprobe")
    output = ROOT / args.output
    srt = ROOT / args.srt
    concat = ROOT / args.concat
    output.parent.mkdir(parents=True, exist_ok=True)
    selected_rows, image_paths = select_images(dataset, args.category, args.image_count)
    total_duration = args.image_count * args.seconds_per_image
    subtitles = select_subtitles(content, args.category, total_duration)
    write_srt(srt, subtitles)
    write_concat(concat, image_paths, args.seconds_per_image)

    srt_filter_path = (Path(args.srt)).as_posix()
    style = (
        "FontName=Arial,FontSize=6,PrimaryColour=&H00FFFFFF,"
        "OutlineColour=&H00000000,Outline=1.2,Shadow=0,Alignment=2,MarginV=130"
    )
    video_filter = (
        "scale=1080:1920:force_original_aspect_ratio=increase,"
        "crop=1080:1920,"
        f"subtitles=filename='{srt_filter_path}':force_style='{style}',"
        "format=yuv420p"
    )
    command = [
        str(ffmpeg),
        "-y",
        "-hide_banner",
        "-f",
        "concat",
        "-safe",
        "0",
        "-i",
        str(concat),
        "-t",
        f"{total_duration:.3f}",
        "-vf",
        video_filter,
        "-r",
        "30",
        "-c:v",
        "libx264",
        "-preset",
        "veryfast",
        "-crf",
        "23",
        "-pix_fmt",
        "yuv420p",
        "-movflags",
        "+faststart",
        "-an",
        str(output),
    ]
    ffmpeg_result = run_command(command, ROOT)
    if ffmpeg_result["returncode"] != 0:
        result = {
            "status": "failed",
            "created_at": datetime.now(timezone.utc).isoformat(),
            "ffmpeg": ffmpeg_result,
        }
        (ROOT / args.result_json).write_text(json.dumps(result, indent=2, ensure_ascii=True), encoding="utf-8")
        raise RuntimeError("ffmpeg failed; see docs/video-pipeline-result.json")

    probe_result = ffprobe_video(ffprobe, output)
    result = {
        "status": "ok",
        "created_at": datetime.now(timezone.utc).isoformat(),
        "category": args.category,
        "image_count": len(image_paths),
        "seconds_per_image": args.seconds_per_image,
        "total_duration_target": total_duration,
        "output": args.output,
        "srt": args.srt,
        "concat": args.concat,
        "selected_images": [row["image_path"] for row in selected_rows],
        "subtitles": [
            {"start": start, "end": end, "text": text}
            for start, end, text in subtitles
        ],
        "ffmpeg_path": str(ffmpeg),
        "ffprobe_path": str(ffprobe),
        "ffmpeg_returncode": ffmpeg_result["returncode"],
        "ffmpeg_stderr_tail": ffmpeg_result["stderr"][-3000:],
        "ffprobe": probe_result,
    }
    (ROOT / args.result_json).write_text(json.dumps(result, indent=2, ensure_ascii=True), encoding="utf-8")
    print(json.dumps({k: result[k] for k in ["status", "output", "srt", "image_count"]}, indent=2), flush=True)


if __name__ == "__main__":
    main()
