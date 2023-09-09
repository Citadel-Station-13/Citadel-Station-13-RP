/**
 * straight connected tables for flipping
 *
 * @return null if invalid (e.g. if table has other tables connected parallel to direction of flip), list of tables otherwise.
 */
/obj/structure/table/proc/tableflip_closure(dir_to_flip, unflipping = FALSE)
	if(!unflipping && isnull(material_base))
		return
	if(!isturf(loc))
		return
	// no stacked tables
	if(!unflipping)
		for(var/obj/structure/table/other in loc)
			if(other != src)
				return
	var/rev_to_flip = turn(dir_to_flip, 180)
	// ensure there's no adjacent parallels
	if(!unflipping)
		for(var/obj/structure/table/other in get_step(loc, dir_to_flip))
			if(other.tableflip_connects(src))
				return
		for(var/obj/structure/table/other in get_step(loc, rev_to_flip))
			if(other.tableflip_connects(src))
				return
	var/list/collected = list(src)
	var/turf/parsing
	var/dir_to_parse
	dir_to_parse = turn(dir_to_flip, 90)
	parsing = get_step(loc, dir_to_parse)
	while(isturf(parsing))
		var/found_any = FALSE
		for(var/obj/structure/table/found in parsing)
			if(found_any && !unflipping)
				return
			if(!tableflip_connects(found))
				continue
			found_any = TRUE
			if(!unflipping)
				for(var/obj/structure/table/other in get_step(parsing, dir_to_flip))
					if(other.tableflip_connects(found))
						return
				for(var/obj/structure/table/other in get_step(parsing, rev_to_flip))
					if(other.tableflip_connects(found))
						return
			collected += found
		if(!found_any)
			break
	dir_to_parse = turn(dir_to_flip, -90)
	parsing = get_step(loc, dir_to_parse)
	while(isturf(parsing))
		var/found_any = FALSE
		for(var/obj/structure/table/found in parsing)
			if(found_any && !unflipping)
				return
			if(!tableflip_connects(found))
				continue
			found_any = TRUE
			if(!unflipping)
				for(var/obj/structure/table/other in get_step(parsing, dir_to_flip))
					if(other.tableflip_connects(found))
						return
				for(var/obj/structure/table/other in get_step(parsing, rev_to_flip))
					if(other.tableflip_connects(found))
						return
			collected += found
		if(!found_any)
			break
	return collected

/**
 * can we connect to another table visually? this is called tableflip_connects but technically can/should
 * be eventually used for visual handling as well.
 */
/obj/structure/table/proc/tableflip_connects(obj/structure/table/other)
	return other.flipped == flipped && other.material_base == material_base

/obj/structure/table/verb/do_flip()
	set name = "Flip table"
	set desc = "Flips a non-reinforced table"
	set category = "Object"
	set src in oview(1)

	if (!can_touch(usr) || ismouse(usr))
		return

	if(flipped < 0 || !flip(get_cardinal_dir(usr,src)))
		to_chat(usr, "<span class='notice'>It won't budge.</span>")
		return

	usr.visible_message("<span class='warning'>[usr] flips \the [src]!</span>")
	shake_climbers()

/obj/structure/table/proc/do_put()
	set name = "Put table back"
	set desc = "Puts flipped table back"
	set category = "Object"
	set src in oview(1)

	if (!can_touch(usr))
		return

	var/list/obj/structure/table/tables = tableflip_closure(dir, unflipping = TRUE)
	var/failed = FALSE
	var/blocking
	for(var/obj/structure/table/table as anything in tables)
		for(var/mob/living/L in table.loc)
			if(L.density)
				failed = TRUE
				blocking = "[L]"
				break
		for(var/obj/O in table.loc)
			if(O == table)
				continue
			if(O.climb_allowed)
				continue
			if(O.density)
				failed = TRUE
				blocking = "[O]"
				break
	if(failed)
		to_chat(usr, SPAN_WARNING("[blocking? "[blocking] is in the way!" : "It won't budge."]"))

	unflip()

/obj/structure/table/proc/flip(var/direction)
	var/list/obj/structure/table/tables = tableflip_closure(direction)
	if(isnull(tables))
		return FALSE

	for(var/obj/structure/table/other as anything in tables)
		other.set_flipped(direction)

	return TRUE

/obj/structure/table/proc/unflip()
	var/list/obj/structure/table/tables = tableflip_closure(dir, unflipping = TRUE)
	if(isnull(tables))
		return FALSE

	for(var/obj/structure/table/other as anything in tables)
		other.set_unflipped()

	return TRUE

/obj/structure/table/proc/set_flipped(direction)
	remove_obj_verb(src, /obj/structure/table/verb/do_flip)
	add_obj_verb(src, /obj/structure/table/proc/do_put)

	var/list/targets = list(get_step(src,dir),get_step(src,turn(dir, 45)),get_step(src,turn(dir, -45)))
	for(var/atom/movable/A in get_turf(src))
		if(!A.anchored)
			A.throw_at_old(pick(targets),1,1)

	setDir(direction)
	if(dir != NORTH)
		plane = MOB_PLANE
		layer = ABOVE_MOB_LAYER
	climb_delay = 10 SECONDS
	flipped = 1
	atom_flags |= ATOM_BORDER
	update_connections(1)
	update_icon()

/obj/structure/table/proc/set_unflipped()
	remove_obj_verb(src, /obj/structure/table/proc/do_put)
	add_obj_verb(src, /obj/structure/table/verb/do_flip)

	reset_plane_and_layer()
	flipped = 0
	climb_delay = initial(climb_delay)
	atom_flags &= ~ATOM_BORDER
	update_connections(1)
	update_icon()
