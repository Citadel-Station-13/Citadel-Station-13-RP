/turf/simulated/floor
	name = "floor"
	icon = 'icons/turf/floors.dmi'
	base_icon_state = "floor"
	baseturfs = /turf/simulated/floor/plating

	footstep = FOOTSTEP_FLOOR
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	// flags = NO_SCREENTIPS
	// turf_flags = CAN_BE_DIRTY | IS_SOLID

	smoothing_groups = list(SMOOTH_GROUP_TURF_OPEN, SMOOTH_GROUP_OPEN_FLOOR)
	canSmoothWith = list(SMOOTH_GROUP_OPEN_FLOOR, SMOOTH_GROUP_TURF_OPEN)


	thermal_conductivity = 0.04
	heat_capacity = 10000
	// tiled_dirt = TRUE

	// overfloor_placed = TRUE

	// Damage to flooring.
	var/broken = FALSE
	var/burnt = FALSE
	/// Path of the tile that this floor drops
	var/floor_tile = null
	var/list/broken_states
	var/list/burnt_states



	// Plating data.
	var/base_name = "plating"
	var/base_desc = "The naked hull."
	var/base_icon = 'icons/turf/flooring/plating.dmi'

	var/list/old_decals = null // Remember what decals we had between being pried up and replaced.

	// Flooring data.
	var/flooring_override
	var/initial_flooring
	var/decl/flooring/flooring
	var/mineral = MAT_STEEL

/turf/simulated/floor/is_plating()
	return !flooring

/turf/simulated/floor/Initialize(mapload, floortype)
	. = ..()
	if(!floortype && initial_flooring)
		floortype = initial_flooring

	if(floortype)
		set_flooring(get_flooring_data(floortype), TRUE)

	if(mapload && can_dirty && can_start_dirty)
		if(prob(dirty_prob))
			dirt += rand(50,100)
			update_dirt() //5% chance to start with dirt on a floor tile- give the janitor something to do

	if(outdoors)
		SSplanets.addTurf(src)

/turf/simulated/floor/Destroy()
	if(outdoors)
		SSplanets.removeTurf(src)
	return ..()

/turf/simulated/proc/make_outdoors()
	outdoors = TRUE
	SSplanets.addTurf(src)

/turf/simulated/proc/make_indoors()
	outdoors = FALSE
	SSplanets.removeTurf(src)

/turf/simulated/AfterChange(flags, oldType)
	. = ..()
	RemoveLattice()
	// If it was outdoors and still is, it will not get added twice when the planet controller gets around to putting it in.
	if(flags & CHANGETURF_PRESERVE_OUTDOORS)
		// if it didn't preserve then we don't need to recheck now do we
		if(outdoors)
			make_outdoors()
		else
			make_indoors()

/**
 * TODO: REWORK FLOORING GETTERS/INIT/SETTERS THIS IS BAD
 */

/turf/simulated/floor/proc/set_flooring(decl/flooring/newflooring, init)
	make_plating(null, TRUE, TRUE)
	flooring = newflooring
	footstep_sounds = newflooring.footstep_sounds
	// We are plating switching to flooring, swap out old_decals for decals
	var/list/overfloor_decals = old_decals
	old_decals = decals
	decals = overfloor_decals
	if(!init)
		QUEUE_SMOOTH(src)
		QUEUE_SMOOTH_NEIGHBORS(src)
	levelupdate()

/// Things seem to rely on this actually returning plating. Override it if you have other baseturfs.
/turf/simulated/floor/proc/make_plating(force = FALSE)
	return ScrapeAway(flags = CHANGETURF_INHERIT_AIR)

/turf/simulated/floor/break_tile()
	if(broken)
		return
	icon_state = pick(broken_states)
	broken = TRUE

///For when the floor is placed under heavy load. Calls break_tile(), but exists to be overridden by floor types that should resist crushing force.
/turf/simulated/floor/proc/crush()
	break_tile()

/turf/simulated/floor/levelupdate()
	for(var/obj/O in src)
		O.hide(O.hides_under_flooring() && src.flooring)

/turf/simulated/floor/rcd_values(mob/living/user, obj/item/rcd/the_rcd, passed_mode)
	switch(passed_mode)
		if(RCD_FLOORWALL)
			// A wall costs four sheets to build (two for the grider and two for finishing it).
			var/cost = RCD_SHEETS_PER_MATTER_UNIT * 4
			// R-walls cost five sheets, however.
			if(the_rcd.make_rwalls)
				cost += RCD_SHEETS_PER_MATTER_UNIT * 1
			return list(
				RCD_VALUE_MODE = RCD_FLOORWALL,
				RCD_VALUE_DELAY = 2 SECONDS,
				RCD_VALUE_COST = cost
			)
		if(RCD_AIRLOCK)
			// Airlock assemblies cost four sheets. Let's just add another for the electronics/wires/etc.
			return list(
				RCD_VALUE_MODE = RCD_AIRLOCK,
				RCD_VALUE_DELAY = 5 SECONDS,
				RCD_VALUE_COST = RCD_SHEETS_PER_MATTER_UNIT * 5
			)
		if(RCD_WINDOWGRILLE)
			// One steel sheet for the girder (two rods, which is one sheet).
			return list(
				RCD_VALUE_MODE = RCD_WINDOWGRILLE,
				RCD_VALUE_DELAY = 1 SECOND,
				RCD_VALUE_COST = RCD_SHEETS_PER_MATTER_UNIT * 1
			)
		if(RCD_DECONSTRUCT)
			// Old RCDs made deconning the floor cost 10 units (IE, three times on full RCD).
			// Now it's ten sheets worth of units (which is the same capacity-wise, three times on full RCD).
			return list(
				RCD_VALUE_MODE = RCD_DECONSTRUCT,
				RCD_VALUE_DELAY = 5 SECONDS,
				RCD_VALUE_COST = RCD_SHEETS_PER_MATTER_UNIT * 10
			)
	return FALSE


/turf/simulated/floor/rcd_act(mob/living/user, obj/item/rcd/the_rcd, passed_mode)
	switch(passed_mode)
		if(RCD_FLOORWALL)
			to_chat(user, SPAN_NOTICE("You build a wall."))
			PlaceOnTop(/turf/simulated/wall)
			var/turf/simulated/wall/T = get_turf(src) // Ref to the wall we just built.
			// Apparently set_material(...) for walls requires refs to the material singletons and not strings.
			// This is different from how other material objects with their own set_material(...) do it, but whatever.
			var/datum/material/M = name_to_material[the_rcd.material_to_use]
			T.set_material(M, the_rcd.make_rwalls ? M : null, M)
			T.add_hiddenprint(user)
			return TRUE
		if(RCD_AIRLOCK)
			if(locate(/obj/machinery/door/airlock) in src)
				return FALSE // No more airlock stacking.
			to_chat(user, SPAN_NOTICE("You build an airlock."))
			new the_rcd.airlock_type(src)
			return TRUE
		if(RCD_WINDOWGRILLE)
			if(locate(/obj/structure/grille) in src)
				return FALSE
			to_chat(user, SPAN_NOTICE("You construct the grille."))
			var/obj/structure/grille/G = new(src)
			G.anchored = TRUE
			return TRUE
		if(RCD_DECONSTRUCT)
			to_chat(user, SPAN_NOTICE("You deconstruct \the [src]."))
			ScrapeAway(flags = CHANGETURF_INHERIT_AIR|CHANGETURF_PRESERVE_OUTDOORS)
			return TRUE
