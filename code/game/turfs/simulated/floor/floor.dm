/**
 * # Floors.
 *
 * ## A note on what a floor is and isn't.
 *
 * We need to talk about floors. **All simulated turfs are capable of being a floor.
 * The difference is /turf/simulated/floor simulates the floor part of being a floor,
 * like changing flooring prototypes/singletons.
 *
 * * If you don't need / want this (e.g. for lava), don't use it.
 * * If are unwilling to handle this cleanly by having **all** behaviors abstracted to
 *   a flooring prototype/singleton (e.g. lava didn't do this), don't use it.
 */
/turf/simulated/floor
	name = "plating"
	desc = "Unfinished flooring."
	icon = 'icons/turf/flooring/plating.dmi'
	icon_state = "plating"
	base_icon_state = "plating"
	thermal_conductivity = 0.040
	heat_capacity = 10000
	permit_ao = TRUE

	#ifdef IN_MAP_EDITOR // Display disposal pipes etc. above walls in map editors.
	layer = PLATING_LAYER
	#endif

	smoothing_flags = SMOOTH_CUSTOM
	smoothing_groups = (SMOOTH_GROUP_TURF_OPEN + SMOOTH_GROUP_OPEN_FLOOR)
	canSmoothWith = (SMOOTH_GROUP_TURF_OPEN + SMOOTH_GROUP_OPEN_FLOOR)
	outdoors = FALSE

	// Damage to flooring.
	var/broken
	var/burnt

	// Plating data.
	var/base_name = "plating"
	var/base_desc = "The naked hull."
	var/base_icon = 'icons/turf/flooring/plating.dmi'
	var/static/list/base_footstep_sounds = list("human" = list(
		'sound/effects/footstep/plating1.ogg',
		'sound/effects/footstep/plating2.ogg',
		'sound/effects/footstep/plating3.ogg',
		'sound/effects/footstep/plating4.ogg',
		'sound/effects/footstep/plating5.ogg',
	))

	var/list/old_decals = null // Remember what decals we had between being pried up and replaced.

	//* Flooring *//

	/// A path or ID to resolve for initial flooring datum.
	var/initial_flooring
	/// Resolved flooring datum. This is a singleton, do not modify under any circumstances.
	var/datum/prototype/flooring/flooring

	//* Flooring - Legacy *//

	/// legacy: override icon state
	var/flooring_legacy_override_state


/turf/simulated/floor/Initialize(mapload, floortype)
	. = ..()
	if(floortype)
		CRASH("additional arg detected in /floor Initialize. turfs do not have init arguments as ChangeTurf does not accept them.")
	if(initial_flooring)
		set_flooring(RSflooring.fetch(flooring), TRUE)
	else
		// todo: these are only here under else because set flooring will trigger it
		footstep_sounds = base_footstep_sounds
		update_underfloor_objects()
	if(mapload && can_dirty && can_start_dirty)
		if(prob(dirty_prob))
			dirt += rand(50,100)
			update_dirt() //5% chance to start with dirt on a floor tile- give the janitor something to do
	update_layer()

/turf/simulated/floor/is_plating()
	return !flooring

#warn deal with this
/turf/simulated/floor/hides_underfloor_objects()
	return flooring

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
 * Tear down a layer of flooring.
 *
 * @params
 * * drop_product - drop dismantled product
 * * strip_to_base - strip every layer of flooring.
 *
 * @return layers strpped
 */
/turf/simulated/floor/proc/dismantle_flooring(drop_product, strip_to_base)
	if(strip_to_base)
		var/safety = 10
		// incase ChangeTurf is invoked
		var/turf/simulated/floor/self_reference_maybe = src
		src = null
		while(istype(self_reference_maybe) && self_reference_maybe.flooring)
			--safety
			if(safety < 0)
				CRASH("infinite loop guard triggered on dismantling flooring to base.")
			self_reference_maybe.dismantle_flooring(drop_product, FALSE)
			++.
	else
		if(drop_product)
			flooring.drop_product(src)
		set_flooring(flooring.base_flooring)
		. = 1

/**
 * Sets our flooring to a specific instance.
 *
 * * This will trample any variable overrides like appearance data that we have on us
 *   in favor of the flooring's!
 * * Passing in 'null' will clear flooring.
 *
 * @params
 * * instance - the instance to use. this can be null.
 * * init - are we being hit from Initialize()? if so, we will refrain from setting variables
 *          already set by macros.
 */
/turf/simulated/floor/proc/set_flooring(datum/prototype/flooring/instance, init)
	if(instance == flooring)
		return

	flooring = instance

	var/new_mz_flags
	if(instance)
		if(!init || !instance.__is_not_legacy)
			name = instance.name
			icon = instance.icon
			icon_state = instance.icon_base
		new_mz_flags = instance.mz_flags
	else
		name = /turf/simulated/floor::name
		icon = /turf/simulated/floor::icon
		icon_state = /turf/simulated/floor::icon_state
		new_mz_flags = /turf/simulated/floor::mz_flags

	if(new_mz_flags & MZ_MIMIC_BELOW)
		enable_zmimic(new_mz_flags)
		if(mz_flags != new_mz_flags)
			mz_flags = new_mz_flags
	else
		disable_zmimic()

	if(!init)
		QUEUE_SMOOTH(src)
		QUEUE_SMOOTH_NEIGHBORS(src)

	#warn below
	make_plating(null, TRUE, TRUE)

	footstep_sounds = instance.footstep_sounds
	// We are plating switching to flooring, swap out old_decals for decals
	var/list/overfloor_decals = old_decals
	old_decals = decals
	decals = overfloor_decals

	update_underfloor_objects()
	update_layer()
	#warn above

//This proc will set floor_type to null and the update_icon() proc will then change the icon_state of the turf
//This proc auto corrects the grass tiles' siding.
/turf/simulated/floor/proc/make_plating(place_product, defer_icon_update, strip_bare)

	if(flooring)
		// We are flooring switching to plating, swap out old_decals for decals.
		var/list/underfloor_decals = old_decals
		old_decals = decals
		decals = underfloor_decals
		color = null

		if(place_product)
			flooring.drop_product(src)
		var/newtype = flooring.get_plating_type()
		if(newtype && !strip_bare) // Has a custom plating type to become
			set_flooring(RSflooring.fetch(newtype))
		else
			flooring = null
			// this branch is only if we don't set flooring because otherwise it'll do it for us
			if(!defer_icon_update)
				name = base_name
				desc = base_desc
				icon = base_icon
				icon_state = base_icon_state
				footstep_sounds = base_footstep_sounds
				QUEUE_SMOOTH(src)
				QUEUE_SMOOTH_NEIGHBORS(src)
				update_underfloor_objects()
				update_layer()

	broken = null
	burnt = null
	flooring_legacy_override_state = null

/turf/simulated/floor/proc/update_layer()
	if(flooring)
		layer = TURF_LAYER
	else
		layer = PLATING_LAYER

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
				RCD_VALUE_COST = RCD_SHEETS_PER_MATTER_UNIT * 2
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
			var/datum/prototype/material/M = get_material_by_name(the_rcd.material_to_use)
			T.set_materials(M, the_rcd.make_rwalls ? M : null, M)
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

//* Multiz *//

/turf/simulated/floor/update_multiz()
	update_ceilingless_overlay()

/turf/simulated/floor/proc/update_ceilingless_overlay()
	// Show 'ceilingless' overlay.
	var/turf/above = above(src)
	if(isopenturf(above) && !istype(src, /turf/simulated/floor/outdoors)) // This won't apply to outdoor turfs since its assumed they don't have a ceiling anyways.
		add_overlay(GLOB.no_ceiling_image, TRUE)
	else
		cut_overlay(GLOB.no_ceiling_image, TRUE)


