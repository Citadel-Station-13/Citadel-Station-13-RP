/**
 * riding filters for mobs
 *
 * can require offhands on mobs and the person riding
 */
/datum/component/riding_filter/mob
	expected_typepath = /mob
	handler_typepath = /datum/component/riding_handler/mob

	/// base number of offhands required on us
	var/offhands_needed_ridden = 0

/**
 * called to check offhands needed
 *
 * @params
 * - buckling - if we're asking because we're about to buckle a ne wmob
 * - semantic - for buckling
 */
/datum/component/riding_filter/mob/proc/ridden_offhands_needed(mob/buckling, semantic)
	var/mob/ridden = parent
	if(!ridden.has_buckled_mobs() && !buckling)
		return 0
	return offhands_needed_ridden

/datum/component/riding_filter/mob/allocate_offhands(mob/rider, semantic, list/offhands)
	. = ..()
	if(!.)
		return
	var/needed = ridden_offhands_needed(rider, semantic) - current_ridden_offhand_count()
	if(needed <= 0)
		return TRUE
	for(var/i in 1 to needed)
		var/obj/item/offhand/riding/R = try_equip_offhand_to_ridden()
		if(!R)
			return FALSE
		offhands += R
	return TRUE

/datum/component/riding_filter/mob/proc/current_ridden_offhand_count()
	var/mob/ridden = parent
	. = 0
	for(var/obj/item/offhand/riding/R in ridden.get_held_items())
		if(R.filter == src)
			++.

/datum/component/riding_filter/mob/proc/get_ridden_offhand()
	var/mob/ridden = parent
	for(var/obj/item/offhand/riding/R in ridden.get_held_items())
		if(R.filter == src)
			return R

/datum/component/riding_filter/mob/check_offhands(mob/rider, unbuckling)
	// we do our checks first, as they're cheaper in cases of riders > 1
	var/needed = ridden_offhands_needed()
	var/current = current_ridden_offhand_count()
	if(unbuckling)
		if(current > needed)
			for(var/i in 1 to current - needed)
				var/obj/item/offhand/riding/R = get_ridden_offhand()
				if(!R)
					stack_trace("failed to find an offhand even though current > needed? at i = [i]")
					continue
				R._silently_erase()
				our_offhands -= R
	else
		if(current < needed)
			var/mob/ridden = parent
			ridden.unbuckle_all_mobs(BUCKLE_OP_FORCE)
			return FALSE
	return ..()

/datum/component/riding_filter/mob/proc/try_equip_offhand_to_ridden()
	RETURN_TYPE(/obj/item/offhand/riding)
	var/mob/M = parent
	var/obj/item/offhand/riding/R = M.allocate_offhand(/obj/item/offhand/riding)
	if(!R)
		return
	R.filter = src
	R.owner = M
	LAZYADD(our_offhands, R)
	return R

/datum/component/riding_filter/mob/offhand_destroyed(obj/item/offhand/riding/offhand, mob/rider)
	if(rider == parent)
		check_offhands()
		return
	return ..()

/datum/component/riding_handler/mob
	expected_typepath = /mob
	rider_offsets = list(
		list(0, 8, 0.01, null),
		list(0, 8, 0.01, null),
		list(0, 8, -0.01, null),
		list(0, 8, 0.01, null)
	)
	rider_offset_format = CF_RIDING_OFFSETS_DIRECTIONAL
