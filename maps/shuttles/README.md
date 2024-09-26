# Shuttles

Shuttle maps & datum defs go in here, as well as their corrosponding code, but not their docks.

Shuttles may be re-instanced multiple times unless specified otherwise.

## Bounding Boxes

Shuttles have:

- A basic square bounding box used for bounds checks
- Their actual /area bounding box

The /area's in them that aren't `world.area` are used for the square bounding box allocation, but only the turfs in those said areas will move with the shuttle.

There is currently, as of December 2023, no way to expand the areas in game without admin intervention.

## Factions

Organize as an exmaple like this;

`maps/shuttles/factions/corporations/nanotrasen/*`
`maps/shuttles/factions/orion/tristar/*`
`maps/shuttles/generic/civillian/*`
`maps/shuttles/generic/outlaw/*`

So on, so forth.

Basically, just like the `code/game/content/*` and `icons/content/*` folders.

# todo

i'm kind of silly, we should finish the readme later ~silicons
