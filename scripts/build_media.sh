#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
IMAGE_SOURCE="$ROOT/static/new_images"
VIDEO_SOURCE="$ROOT/static/new_videos"
PAPER_SOURCE="$ROOT/static/paper/STEMbot_paper.pdf"
OUTPUT="$ROOT/static/media"
IMAGE_OUTPUT="$OUTPUT/images"
FIGURE_OUTPUT="$IMAGE_OUTPUT/figures"
VIDEO_OUTPUT="$OUTPUT/videos"
POSTER_OUTPUT="$OUTPUT/posters"
TMP="$(mktemp -d)"

trap 'rm -rf "$TMP"' EXIT

require() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "Missing required command: $1" >&2
    exit 1
  }
}

require ffmpeg
require ffprobe
require convert

mkdir -p "$FIGURE_OUTPUT" "$VIDEO_OUTPUT" "$POSTER_OUTPUT"
cp "$PAPER_SOURCE" "$OUTPUT/STEMbot_paper.pdf"

skip_existing() {
  [[ "${SKIP_EXISTING:-0}" == "1" && -s "$1" ]] || return 1

  if [[ "$1" == *.mp4 ]]; then
    ffprobe -v error -show_entries format=duration -of csv=p=0 "$1" \
      >/dev/null 2>&1
    return
  fi

  return 0
}

copy_figure() {
  local source="$1"
  local target="$2"
  cp "$IMAGE_SOURCE/figures/$source" "$FIGURE_OUTPUT/$target"
}

# Prefer the supplied JPEG encodings for large photographic figures and PNG
# sources for line art and diagrams.
copy_figure hero.jpg hero.jpg
copy_figure system.png system.png
copy_figure hardware.jpg hardware.jpg
copy_figure perception.jpg perception.jpg
copy_figure b_constraints.png heading-constraints.png
copy_figure state.png state-projection.png
copy_figure branch.jpg branch-transition.jpg
copy_figure goal_generation.jpg goal-generation.jpg
copy_figure hardware-extremes.png traversal-extremes.png
copy_figure mapping_experiments.jpg mapping-experiments.jpg
copy_figure chamfer_metrics.png chamfer-metrics.png

convert "$IMAGE_SOURCE/browser_tab_logo.png" \
  -resize 512x512 -strip "$IMAGE_OUTPUT/stembot-logo.png"
convert "$IMAGE_SOURCE/browser_tab_logo.png" \
  -resize 64x64 -strip "$IMAGE_OUTPUT/favicon.png"
convert "$IMAGE_SOURCE/hardware_image.png" \
  -resize '1400x1400>' -strip -quality 88 "$IMAGE_OUTPUT/hardware-detail.jpg"

for plant in 2 3 5 6; do
  convert "$IMAGE_SOURCE/plant_${plant}.png" \
    -resize '720x720>' -strip -quality 86 "$IMAGE_OUTPUT/plant-${plant}.webp"
done

video_duration() {
  ffprobe -v error -show_entries format=duration -of default=nw=1:nk=1 "$1"
}

encode_clip() {
  local source="$1"
  local target="$2"
  local filter="${3:-scale=-2:720}"

  skip_existing "$target" && return

  ffmpeg -y -hide_banner -loglevel error -i "$source" \
    -map 0:v:0 -an -vf "$filter" -c:v libx264 -preset medium -crf 25 \
    -pix_fmt yuv420p -movflags +faststart "$target"
}

encode_timelapse() {
  local source="$1"
  local target="$2"
  local target_duration="$3"
  local duration
  local speed

  skip_existing "$target" && return

  duration="$(video_duration "$source")"
  speed="$(awk -v d="$duration" -v t="$target_duration" 'BEGIN { printf "%.8f", t / d }')"
  encode_clip "$source" "$target" \
    "setpts=${speed}*PTS,fps=30,scale=-2:720"
}

encode_keyframe_timelapse() {
  local source="$1"
  local target="$2"
  local target_duration="$3"
  local duration
  local speed

  skip_existing "$target" && return

  duration="$(video_duration "$source")"
  speed="$(awk -v d="$duration" -v t="$target_duration" 'BEGIN { printf "%.8f", t / d }')"

  ffmpeg -y -hide_banner -loglevel error -skip_frame nokey -i "$source" \
    -map 0:v:0 -an \
    -vf "setpts=${speed}*PTS,fps=30,scale=-2:720" \
    -c:v libx264 -preset medium -crf 25 -pix_fmt yuv420p \
    -movflags +faststart "$target"
}

make_poster() {
  local source="$1"
  local target="$2"
  local seek="${3:-1}"

  skip_existing "$target" && return

  ffmpeg -y -hide_banner -loglevel error -ss "$seek" -i "$source" \
    -frames:v 1 -vf "scale=-2:720" \
    -q:v 3 "$target"
}

# Main five-minute presentation video: retain audio while targeting a GitHub-
# compatible file comfortably below the 100 MB per-file limit.
if ! skip_existing "$VIDEO_OUTPUT/stembot-presentation.mp4"; then
  ffmpeg -y -hide_banner -loglevel error \
    -i "$VIDEO_SOURCE/stembot_full_video.mp4" \
    -map 0:v:0 -map 0:a:0? -vf "scale=-2:720" \
    -c:v libx264 -preset medium -b:v 1900k -maxrate 2200k -bufsize 4400k \
    -pix_fmt yuv420p -c:a aac -b:a 96k -movflags +faststart \
    "$VIDEO_OUTPUT/stembot-presentation.mp4"
fi
make_poster "$VIDEO_OUTPUT/stembot-presentation.mp4" \
  "$POSTER_OUTPUT/stembot-presentation.jpg" 4

for diameter in 8 9 10 12 14 16 18 20 25; do
  encode_clip "$VIDEO_SOURCE/${diameter}mm.MOV" \
    "$VIDEO_OUTPUT/diameter-${diameter}mm.mp4"
  make_poster "$VIDEO_OUTPUT/diameter-${diameter}mm.mp4" \
    "$POSTER_OUTPUT/diameter-${diameter}mm.jpg"
done

declare -A BRANCH_SOURCES=(
  [angle-30]="branch-switch-30.MOV"
  [angle-60]="branch-switch-60.MOV"
  [angle-90]="branch-switch-90.MOV"
  [angle-120-failure]="branch-switch-120-failure.MOV"
  [curve-r50]="branch-switch-curved-r50mm.MOV"
  [curve-r75]="branch-switch-curved-r75mm.MOV"
  [curve-r100]="branch-switch-curved-r100mm.MOV"
)

for key in "${!BRANCH_SOURCES[@]}"; do
  encode_clip "$VIDEO_SOURCE/${BRANCH_SOURCES[$key]}" \
    "$VIDEO_OUTPUT/branch-${key}.mp4"
  make_poster "$VIDEO_OUTPUT/branch-${key}.mp4" \
    "$POSTER_OUTPUT/branch-${key}.jpg"
done

encode_clip "$VIDEO_SOURCE/perception_demo.mp4" \
  "$VIDEO_OUTPUT/perception-demo.mp4"
make_poster "$VIDEO_OUTPUT/perception-demo.mp4" \
  "$POSTER_OUTPUT/perception-demo.jpg"

for experiment in 1 2 3 4; do
  encode_timelapse "$VIDEO_SOURCE/Experiment_${experiment}_robot.MOV" \
    "$VIDEO_OUTPUT/experiment-${experiment}-robot.mp4" 30
  encode_timelapse "$VIDEO_SOURCE/Experiment_${experiment}_map.webm" \
    "$VIDEO_OUTPUT/experiment-${experiment}-map.mp4" 30
  make_poster "$VIDEO_OUTPUT/experiment-${experiment}-robot.mp4" \
    "$POSTER_OUTPUT/experiment-${experiment}-robot.jpg"
  make_poster "$VIDEO_OUTPUT/experiment-${experiment}-map.mp4" \
    "$POSTER_OUTPUT/experiment-${experiment}-map.jpg"
done

if ! skip_existing "$VIDEO_OUTPUT/assembly-overview.mp4"; then
  for part in 1 2 3 4; do
    encode_keyframe_timelapse "$VIDEO_SOURCE/assembly_part_${part}.MOV" \
      "$TMP/assembly-${part}.mp4" 15
  done

  {
    for part in 1 2 3 4; do
      printf "file '%s'\n" "$TMP/assembly-${part}.mp4"
    done
  } > "$TMP/assembly.txt"

  ffmpeg -y -hide_banner -loglevel error -f concat -safe 0 \
    -i "$TMP/assembly.txt" -c copy -movflags +faststart \
    "$VIDEO_OUTPUT/assembly-overview.mp4"
fi
make_poster "$VIDEO_OUTPUT/assembly-overview.mp4" \
  "$POSTER_OUTPUT/assembly-overview.jpg" 2

for experiment in 1 2 3 4; do
  for kind in semantic_overlay chamfer_heatmap; do
    source="$IMAGE_SOURCE/experiment_${experiment}_${kind}.gif"
    target_kind="${kind//_/-}"
    target="$VIDEO_OUTPUT/experiment-${experiment}-${target_kind}.mp4"
    if ! skip_existing "$target"; then
      ffmpeg -y -hide_banner -loglevel error -i "$source" -an \
        -vf "fps=24,scale=600:600:force_original_aspect_ratio=decrease,\
pad=600:600:(ow-iw)/2:(oh-ih)/2:color=white" \
        -c:v libx264 -preset medium -crf 24 -pix_fmt yuv420p \
        -movflags +faststart "$target"
    fi
    make_poster "$VIDEO_OUTPUT/experiment-${experiment}-${target_kind}.mp4" \
      "$POSTER_OUTPUT/experiment-${experiment}-${target_kind}.jpg" 0
  done
done

echo "Generated media in $OUTPUT"
