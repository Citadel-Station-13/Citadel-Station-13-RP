#define FLUID_STAGE_FLOOD		1
#define FLUID_STAGE_TURFS		2
#define FLUID_STAGE_GROUPS		3
#define FLUID_STAGE_ACT			4
#define FLUID_STAGE_DONE		5

SUBSYSTEM_DEF(fluids)
	wait = 2
	priority = FIRE_PRIORITY_FLUIDS
	init_order = INIT_ORDER_FLUIDS

	/// current stage
	var/stage = FLUID_STAGE_FLOOD
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
	/// defer act to the next process
	var/static/list/atom/act_deferred = list()
	/// currentrun var
	var/static/list/currentrun = list()

	/// flood step cost
	var/cost_flood = 0
	/// turf step cost
	var/cost_turf = 0
	/// groups step cost
	var/cost_groups = 0
	/// act step cost
	var/cost_act = 0

	/// delay before breaking down groups
	var/group_breakdown_delay = 5 SECONDS

/datum/controller/subsystem/fluids/Initialize()
	EqualizeAllFluids()
	return ..()

/datum/controller/subsystem/fluids/stat_entry(msg)
	return ..("F: [cost_flood] T: [cost_turf] G: [cost_groups] A: [cost_act] F#: [length(flood_objects)] T#: [length(active_turfs)] G#: [length(groups)] A#: [length(act_processing)]")

/datum/controller/subsystem/fluids/fire(resumed)
	if(!resumed)
		stage = FLUID_STAGE_FLOOD

	if(stage == FLUID_STAGE_FLOOD)
		if(!resumed)
			currentrun = flood_objs.Copy()

		while(currentrun.len)
			var/obj/effect/fluid_source/F = currentrun[currentrun.len--]

		resumed = 0
		stage = FLUID_STAGE_TURFS

	if(stage == FLUID_STAGE_TURFS)
		if(!resumed)
			currentrun = active_turfs.Copy()

		while(currentrun.len)
			var/turf/T = currentrun[currentrun.len--]

		resumed = 0
		stage = FLUID_STAGE_GROUPS

	if(stage == FLUID_STAGE_GROUPS)
		if(!resumed)
			currentrun = groups.Copy()

		while(currentrun.len)
			var/datum/fluid_group/G = currentrun[currentrun.len--]
			if(G.last_motion <= world.time - group_breakdown_delay)
				qdel(G)
			if(MC_TICK_CHECK)
				return

		resumed = 0
		stage = FLUID_STAGE_ACT

	if(stage == FLUID_STAGE_ACT)
		if(!resumed)
			currentrun = act_processing.Copy()
			act_deferred.len = 0

		while(currentrun.len)
			var/atom/A = currentrun[currentrun.len]
			--currentrun.len
			if(act_deferred[A])
				continue
			if(QDELETED(A))
				act_processing -= A
				continue
			var/turf/T = A.loc
			if(!istype(T) || !T.fluid_active)
				act_processing -= A
				continue
			A.fluid_act(T.reagents, FALSE)
			if(MC_TICK_CHECK)
				return

		resumed = 0
		stage = FLUID_STAGE_DONE

/datum/controller/subsystem/fluids/Recover()
	currentrun = list()

/**
 * Equalizes all fluids in the world.
 */
/datum/controller/subsystem/fluids/proc/EqualizeAllFluids()

/**
 * Gets a fluid graphic based on a fluid
 */
/datum/controller/subsystem/fluids/proc/GetGraphic(datum/reagents/reagents)

/**
 * Starts act processing an atom
 */
/datum/controller/subsystem/fluids/proc/StartActProcessing(atom/A, defer = FALSE)
	if(defer)
		act_deferred[A] = TRUE
	act_processing[A] = TRUE

#undef FLUID_STAGE_FLOOD
#undef FLUID_STAGE_TURFS
#undef FLUID_STAGE_GROUPS
#undef FLUID_STAGE_ACT
#undef FLUID_STAGE_DONE
