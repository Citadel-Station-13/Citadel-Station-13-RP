# Map System

Maps are parsed with the following rules by SSmapping:
maps/levels/ are /datum/map_data/level's
maps/worlds/ are /datum/map_data/station's

Anything else is ignored

## .json format

.json configuration is split into two hierarchies

### Maps

Map .jsons are included in these folders:

- maps/levels
- maps/worlds
- config/maps/levels
- config/maps/worlds

They describe everything needed to load a level.
If a map in config/ has the same ID as a map in code folders,
it will *overwrite* the map of the same ID.

#### Format

#### Levels

