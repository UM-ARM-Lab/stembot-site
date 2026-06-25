# Website Structure

## Page Narrative

The single-page site follows this order:

1. Publication header and resources
2. Abstract, contributions, and key results
3. Integrated system architecture
4. Compliant hardware and assembly
5. Geometric and semantic perception
6. Manifold-constrained motion planning
7. Traversal capability videos
8. Four autonomous plant experiments
9. Full presentation video
10. Provisional citation and publication TODOs

The visual direction is a neutral IEEE-style research site with restrained
Michigan blue, maize, and botanical-green accents.

## Experiment Mapping

The experiment numbering follows the manuscript and supplied media:

| Experiment | Specimen | Type | Goal | Plant image |
| --- | --- | --- | --- | --- |
| 1 | Dracaena | Artificial | State | `plant_5.png` |
| 2 | Monstera deliciosa | Live | Visibility | `plant_6.png` |
| 3 | Ficus lyrata | Live | State | `plant_2.png` |
| 4 | Olea europaea | Artificial | Visibility | `plant_3.png` |

`plant_1.png` and `plant_4.png` are not experimental specimens and are excluded.

## Media Pipeline

`scripts/build_media.sh` converts ignored source media into committed web
assets under `static/media/`.

- Source figures in `static/new_images/figures/` are authoritative; figures are
  not extracted from the PDF.
- Diagrams use the supplied PNG files. Large photographic composites use the
  supplied JPEG alternatives.
- The five-minute presentation retains audio.
- Demo, experiment, and assembly derivatives are muted H.264 MP4 files.
- Long experiment runs become complete approximately 30-second timelapses.
- The four assembly recordings become one approximately 60-second overview.
- GIF result rotations become controllable MP4 loops with static posters.

## Approved Technical Wording

- The camera is an Intel RealSense D405 camera incorporating the D401 depth
  module.
- Demonstrated traversal includes 7–33 mm stems, branch junctions up to 90
  degrees, and curves with radii as tight as 50 mm.
- Mean one-way Chamfer distance is 3.85 mm for artificial specimens and
  13.36 mm for live specimens.

## Open Publication Items

- All five authors are affiliated with the University of Michigan Department
  of Robotics.
- Zachary Charlick and Dmitry Berenson are additionally affiliated with the
  Autonomous Robotic Manipulation Lab (ARM).
- Nilay Roy Choudhury and Xiaonan Huang are additionally affiliated with the
  Hybrid Dynamic Robotics Lab.
- Funding and acknowledgment wording remains a visible TODO.
- Code and arXiv are marked “Coming soon.”
- No dataset-release link or patent-status wording is shown.
- BibTeX is explicitly provisional until proceedings metadata is available.
