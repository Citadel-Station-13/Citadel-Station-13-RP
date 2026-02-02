/mob/living/death(gibbed)
	wipe_fullscreens()
	if(istype(ai_holder, /datum/ai_holder/polaris))
		var/datum/ai_holder/polaris/ai_holder = src.ai_holder
		ai_holder.go_sleep()

	if(nest) //Ew.
		if(istype(nest, /obj/structure/prop/nest))
			var/obj/structure/prop/nest/N = nest
			N.remove_creature(src)
		if(istype(nest, /obj/structure/blob/factory))
			var/obj/structure/blob/factory/F = nest
			F.spores -= src
		nest = null

	for(var/s in owned_soul_links)
		var/datum/soul_link/S = s
		S.owner_died(gibbed)
	for(var/s in shared_soul_links)
		var/datum/soul_link/S = s
		S.sharer_died(gibbed)
	remove_ghostrole() //gone too soon to realize their potential, if they had it.
	. = ..()

/mob/living/gib()
	if(butchery_drops_organs)
		for(var/path in internal_organs)
			if(ispath(path))
				var/obj/item/organ/neworg = new path(src, TRUE)
				internal_organs -= path
				neworg.name = "[name] [neworg.name]"
				neworg.meat_type = meat_type
				internal_organs |= neworg

		for(var/obj/item/organ/I in internal_organs)
			I.removed()
			// Some organs qdel themselves or other things when removed.
			if(isturf(I?.loc))
				I.throw_at_old(get_edge_target_turf(src, pick(GLOB.alldirs)), rand(1,3), 30)

		for(var/obj/item/organ/external/E in src.organs)
			if(!ispath(E))
				E.droplimb(FALSE, DROPLIMB_EDGE, TRUE)
	..()
