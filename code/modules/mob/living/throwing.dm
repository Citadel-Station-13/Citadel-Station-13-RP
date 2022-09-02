#warn impl overhand
/mob/living/throw_item(atom/target)
	// TODO: refactor to not be hardcoded active held item
	// todo: overhand throws
	src.throw_mode_off()
	if(usr.stat || !target)
		return
	if(target.type == /atom/movable/screen)
		return

	var/atom/movable/item = src.get_active_held_item()

	if(!item)
		return
	var/throw_range = item.throw_range
	if (istype(item, /obj/item/grab))
		var/obj/item/grab/G = item
		item = G.throw_held() //throw the person instead of the grab
		if(ismob(item))
			var/mob/M = item

			//limit throw range by relative mob size
			throw_range = round(M.throw_range * min(src.mob_size/M.mob_size, 1))

			var/turf/end_T = get_turf(target)
			if(end_T)
				add_attack_logs(src,M,"Thrown via grab to [end_T.x],[end_T.y],[end_T.z]")
			drop_item_to_ground(G, INV_OP_FORCE)
		else
			return		// wild
	else
		if(!drop_item_to_ground(item))
			throw_mode_off()
			return

	if(!item || !isturf(item.loc))
		return

	//actually throw it!
	src.visible_message("<span class='warning'>[src] has thrown [item].</span>")

	if(!src.lastarea)
		src.lastarea = get_area(src.loc)

	newtonian_move(get_dir(target, src))

	item.throw_at(target, throw_range, null, a_intent == INTENT_HELP? THROW_AT_IS_NEAT : NONE, src, force = throw_impulse)
