# Shuttles

Shuttle maps & datum defs go in here.

Shuttles may be re-instanced multiple times unless specified otherwise.

## Bounding Boxes

Shuttles have:

- A basic square bounding box used for bounds checks
- Their actual /area bounding box

The /area's in them that aren't `world.area` are used for the square bounding box allocation, but only the turfs in those said areas will move with the shuttle.

There is currently, as of December 2023, no way to expand the areas in game without admin intervention.
