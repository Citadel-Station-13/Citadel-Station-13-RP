// physics_mode
/// entirely disabled
#define ENTITY_PHYSICS_DISABLED				0
/// normal
#define ENTITY_PHYSICS_SIMULATED			1
/// temporarily halted
#define ENTITY_PHYSICS_PAUSED				2

// physics pause sources
/// paused from FTL
#define ENTITY_PHYSICS_PAUSE_FOR_FTL			"ftl"
/// paused from docking/being inside another object
#define ENTITY_PHYSICS_PAUSE_FOR_DOCKED			"docked"
/// admin pausing
#define ENTITY_PHYSICS_PAUSE_FOR_ADMIN			"admin"

// instantiation
/// entirely virtual
#define ENTITY_INSTANTIATION_VIRTUAL				0
/// instantiated
#define ENTITY_INSTANTIATION_REAL					1
/// can instantiate but not requested to yet
#define ENTITY_INSTANTIATION_UNLOADED				2
/// instantiation errored
#define ENTITY_INSTANTIATION_ERROR					3
