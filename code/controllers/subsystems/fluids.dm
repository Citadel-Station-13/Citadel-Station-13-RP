#define FLUID_STAGE_FLOOD		1
#define FLUID_STAGE_TURFS		2
#define FLUID_STAGE_GROUPS		3
#define FLUID_STAGE_ACT			4

SUBSYSTEM_DEF(fluids)
	wait = 2
	priority = FIRE_PRIORITY_FLUIDS
	init_order = INIT_ORDER_FLUIDS

	/// all constant fluid sources
	var/static/list/obj/effect/fluid_source/flood_objs = list()
	/// all active fluid turfs
	var/static/list/turf/active_turfs = list()
	/// all objects being processed for fluid_act
	var/static/list/atom/act_processing = list()
	/// all excited groups
	var/static/list/datum/fluid_group/groups = list()
	/// Cached graphics objects for fluids
	var/static/list/obj/effect/overlay/fluid/graphics = list()

/datum/controller/subsystem/fluids/Initialize()
	EqualizeAllFluids()
	return ..()

/datum/controller/subsystem/fluids/fire(resumed)

/**
 * Equalizes all fluids in the world.
 */
/datum/controller/subsystem/fluids/proc/EqualizeAllFluids()

/**
 * Gets a fluid graphic based on a fluid
 */
/datum/controller/subsystem/fluids/proc/GetGraphic(datum/reagents/reagents)

#undef FLUID_STAGE_FLOOD
#undef FLUID_STAGE_TURFS
#undef FLUID_STAGE_GROUPS
#undef FLUID_STAGE_ACT
