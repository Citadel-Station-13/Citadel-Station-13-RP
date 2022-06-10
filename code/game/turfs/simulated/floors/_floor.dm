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

	overfloor_placed = TRUE

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
	if(broken_states)
		stack_trace("broken_states defined at the object level for [type], move it to setup_broken_states()")
	else
		broken_states = string_list(setup_broken_states())
	if(burnt_states)
		stack_trace("burnt_states defined at the object level for [type], move it to setup_burnt_states()")
	else
		var/list/new_burnt_states = setup_burnt_states()
		if(new_burnt_states)
			burnt_states = string_list(new_burnt_states)
	if(!broken && broken_states && (icon_state in broken_states))
		broken = TRUE
	if(!burnt && burnt_states && (icon_state in burnt_states))
		burnt = TRUE

	// if(mapload && prob(33))
	// 	MakeDirty()
	if(mapload && can_dirty && can_start_dirty)
		if(prob(dirty_prob))
			dirt += rand(50,100)
			update_dirt() //5% chance to start with dirt on a floor tile- give the janitor something to do

	// if(is_station_level(z))
	// 	GLOB.station_turfs += src
	if(outdoors)
		SSplanets.addTurf(src)

/turf/simulated/floor/proc/setup_broken_states()
	return list("damaged1", "damaged2", "damaged3", "damaged4", "damaged5")

/turf/simulated/floor/proc/setup_burnt_states()
	return

/turf/simulated/floor/Destroy()
	// if(is_station_level(z))
	// 	GLOB.station_turfs -= src
	if(outdoors)
		SSplanets.removeTurf(src)
	return ..()

/turf/simulated/floor/proc/break_tile_to_plating()
	var/turf/simulated/floor/plating/T = make_plating()
	if(!istype(T))
		return
	T.break_tile()

/turf/simulated/floor/break_tile()
	if(broken)
		return
	icon_state = pick(broken_states)
	broken = 1

/turf/simulated/floor/burn_tile()
	if(broken || burnt)
		return
	if(LAZYLEN(burnt_states))
		icon_state = pick(burnt_states)
	else
		icon_state = pick(broken_states)
	burnt = 1

/// Things seem to rely on this actually returning plating. Override it if you have other baseturfs.
/turf/simulated/floor/proc/make_plating(force = FALSE)
	return ScrapeAway(flags = CHANGETURF_INHERIT_AIR)

///For when the floor is placed under heavy load. Calls break_tile(), but exists to be overridden by floor types that should resist crushing force.
/turf/simulated/floor/proc/crush()
	break_tile()

/turf/simulated/floor/ChangeTurf(path, new_baseturf, flags)
	if(!isfloorturf(src))
		return ..() //fucking turfs switch the fucking src of the fucking running procs
	if(!ispath(path, /turf/simulated/floor))
		return ..()
	var/old_dir = dir
	var/turf/simulated/floor/W = ..()
	W.setDir(old_dir)
	W.update_appearance()
	return W

/turf/simulated/floor/attackby(obj/item/object, mob/living/user, params)
	if(!object || !user)
		return TRUE
	. = ..()
	if(.)
		return .
	if(overfloor_placed && istype(object, /obj/item/stack/tile))
		try_replace_tile(object, user, params)
		return TRUE
	// if(user.a_intent == INTENT_HARM && istype(object, /obj/item/stack/sheet))
	// 	var/obj/item/stack/sheet/sheets = object
	// 	return sheets.on_attack_floor(user, params)
	return FALSE

/turf/simulated/floor/crowbar_act(mob/living/user, obj/item/I)
	if(overfloor_placed && pry_tile(I, user))
		return TRUE

/turf/simulated/floor/proc/try_replace_tile(obj/item/stack/tile/T, mob/user, params)
	if(T.turf_type == type && T.turf_dir == dir)
		return
	var/obj/item/tool/crowbar/CB = user.is_holding_item_of_type(/obj/item/tool/crowbar)
	if(!CB)
		return
	var/turf/simulated/floor/plating/P = pry_tile(CB, user, TRUE)
	if(!istype(P))
		return
	P.attackby(T, user, params)

/turf/simulated/floor/proc/pry_tile(obj/item/I, mob/user, silent = FALSE)
	I.play_tool_sound(src, 80)
	return remove_tile(user, silent)

/turf/simulated/floor/proc/remove_tile(mob/user, silent = FALSE, make_tile = TRUE, force_plating)
	if(broken || burnt)
		broken = FALSE
		burnt = FALSE
		if(user && !silent)
			to_chat(user, SPAN_NOTICE("You remove the broken plating."))
	else
		if(user && !silent)
			to_chat(user, SPAN_NOTICE("You remove the floor tile."))
		if(make_tile)
			spawn_tile()
	return make_plating(force_plating)

/turf/simulated/floor/proc/has_tile()
	return floor_tile

/turf/simulated/floor/proc/spawn_tile()
	if(!has_tile())
		return null
	return new floor_tile(src)

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
