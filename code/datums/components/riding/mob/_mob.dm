/**
 * riding filters for mobs
 *
 * can require offhands on mobs and the person riding
 */
/datum/component/riding_filter/mob
	expected_typepath = /mob
	handler_typepath = /datum/component/riding_handler/mob

	/// base number of offhands required on us
	var/offhands_needed_base = 0
	/// offhands required on us per mob buckled
	var/offhands_needed_per = 0
	/// check ridden offhands the complicated way by tallying max per semantic
	var/complex_ridden_offhands_calculation = FALSE

/datum/component/riding_filter/mob/proc/ridden_offhands_needed(semantic)
	return offhands_needed_per

/datum/component/riding_filter/mob/check_offhands(mob/rider, unbuckling)
	// we do our checks first, as they're cheaper in cases of riders > 1
	if(!offhands_needed_base && !offhands_needed_per)
		return ..()
	var/mob/M = parent
	var/list/obj/item/offhand/riding/offhands = get_offhands_of_rider(M)
	var/has = length(offhands)
	var/needed = offhands_needed_base + offhands_needed_per * length(M.buckled_mobs)
	#warn add complex ridden offhands calculation
	if(!needed)	// none needed
		for(var/i in 1 to has)
			var/obj/item/offhand/riding/offhand = offhands[i]
			offhand._silently_erase()
			LAZYREMOVE(our_offhands, offhand)
		return ..()
	// if not enough, kick off all
	if(has < offhands_needed_base)
		// cleanup all remaining
		for(var/obj/item/offhand/riding/R as anything in offhands)
			R._silently_erase()
		offhands = null
		// kick
		for(var/mob/buckled in M.buckled_mobs)
			buckled.visible_message(
				SPAN_NOTICE("[M] drops [buckled]."),
				SPAN_NOTICE("[M] drops you.")
			)
		M.unbuckle_all_mobs()
		return
	else if(has < needed)
		var/excess = length(M.buckled_mobs) * offhands_needed_per + offhands_needed_base - has

	else if(has == needed)
		// just right
		return ..()
	else
		for(var/i in (has - needed))
			var/obj/item/offhand/riding/R = offhands.len - i + 1
			R._silently_erase()
			LAZYREMOVE(our_offhands, R)
		// too much

	// loop protection
	if(unbuckling)
		// if unbuckling we only
		return ..()
	var/mob/M = parent
	var/needed = offhands_needed_base + length(M.buckled_mobs)
	var/has = 0
	for(var/obj/item/offhand/riding/offhand as anything in M.get_held_items_of_type(/obj/item/offhand/riding))
		if(offhand.filter != src)
			continue
		++has
	if(has > needed)
		M.unbuckle_all_mobs()
	#warn impl

	return ..()

#warn cleanup the above shitcode

/datum/component/riding_handler/mob
	expected_typepath = /mob

#warn we're going to need to make laying down be able to kick people off if needed
