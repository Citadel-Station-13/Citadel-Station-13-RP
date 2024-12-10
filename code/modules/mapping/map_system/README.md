# Map System

Contains all the datastructures used by SSmapping to maintain the state of the world's physical space.

- /datum/map: Describes a collection of z-levels.
- /datum/map_level: Describes a single z-level and its data / state.
- /datum/map_reservation: A chunk of reserved map-space that can be allocated by request from the mapping subsystem.
- /datum/map_struct: Describes a physical set of z-levels. Used by various game systems to abstract the idea of a group of levels, whether it may be a station, planet, or extended space-field or anything else.
- /datum/map_template: A chunk of map we can paste.
