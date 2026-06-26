# STEMbot Paper Website

Project website for **“STEMbot: A Compliant Robot for Under-Canopy Plant
Navigation,”** accepted to IROS 2026.

The site is a static single-page publication website built with HTML, CSS,
vanilla JavaScript, and Bulma's layout utilities.

## Local Preview

Serve the repository root over HTTP:

```bash
python -m http.server 8000
```

Then open <http://localhost:8000>.

## Media Build

Author-provided source files live locally in:

- `static/new_images/`
- `static/new_videos/`
- `static/paper/`

These folders are intentionally ignored by Git. Generate the committed,
browser-ready media set with:

```bash
./scripts/build_media.sh
```

The script requires FFmpeg, FFprobe, and ImageMagick. It writes optimized
figures, images, posters, H.264 videos, and the paper PDF to `static/media/`.

## Publication TODOs

- Add approved funding and acknowledgment language.
- Replace the local presentation video link when the YouTube upload is ready.
- Activate the arXiv link after public release.
- Replace the provisional BibTeX entry with final proceedings metadata.

## Code

The public code release is available at
[UM-ARM-Lab/stembot](https://github.com/UM-ARM-Lab/stembot).

## Website License

This website is adapted from the
[Nerfies project-page template](https://nerfies.github.io/) and is licensed
under [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/).
