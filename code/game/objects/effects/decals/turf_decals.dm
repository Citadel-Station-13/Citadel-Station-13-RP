/obj/effect/turf_decal
	icon = 'icons/turf/flooring/decals_vr.dmi'
	plane = DECAL_PLANE //TODO: Plane unification. @Zandario
	layer = MAPPER_DECAL_LAYER
	anchored = TRUE

	var/supplied_dir

/**
 * This is with the intent of optimizing mapload.
 * See spawners for more details since we use the same pattern.
 * Basically rather then creating and deleting ourselves, why not just do the bare minimum?
 */
/obj/effect/turf_decal/Initialize(mapload)
	SHOULD_CALL_PARENT(FALSE)
	if(flags & INITIALIZED)
		stack_trace("Warning: [src]([type]) initialized multiple times!")
	flags |= INITIALIZED

	var/turf/our_turf = loc
	if(!istype(our_turf)) //you know this will happen somehow
		CRASH("Turf decal initialized in an object/nullspace")
	our_turf.AddElement(/datum/element/decal, icon, icon_state, dir, null, null, alpha, color, null, FALSE, null)
	return INITIALIZE_HINT_QDEL

/obj/effect/turf_decal/Destroy(force)
	SHOULD_CALL_PARENT(FALSE)
#ifdef UNIT_TESTS
// If we don't do this, turf decals will end up stacking up on a tile, and break the overlay limit
// I hate it too bestie
	if(GLOB.running_create_and_destroy)
		var/turf/our_turf = loc
		our_turf.RemoveElement(/datum/element/decal, icon, icon_state, dir, null, null, alpha, color, null, FALSE, null)
#endif
	moveToNullspace()
	return QDEL_HINT_QUEUE
