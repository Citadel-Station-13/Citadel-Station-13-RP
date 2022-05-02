// physics
/// called when physics is unpaused: ()
#define COMSIG_OVERMAP_ENTITY_PHYSICS_UNPAUSED				"overmap_entity_unpause"
/// called when physics is paused: ()
#define COMSIG_OVERMAP_ENTITY_PHYSICS_PAUSED				"overmap_entity_pause"
/// called when we switch overmaps
#define COMSIG_OVERMAP_ENTITY_SET_OVERMAP					"overmap_entity_change_overmap"
/// called when we move off the overmap into an entity: (entity)
#define COMSIG_OVERMAP_ENTITY_PHYSICS_DOCK					"overmap_entity_dock"
/// called when we move onto the overmap from an entity: (entity)
#define COMSIG_OVERMAP_ENTITY_PHYSICS_UNDOCK				"overmap_entity_undock"
/// called when we enter into a new entity for any reason whatsoever, either into the world or another entity: (E)
#define COMSIG_OVERMAP_ENTITY_PHYSICS_ENTER					"overmap_entity_enter"
/// called when we exit from an overmap entity for any reason whatsoever, either into the world or another entity: (E)
#define COMSIG_OVERMAP_ENTITY_PHYSICS_EXIT					"overmap_entity_exit"
