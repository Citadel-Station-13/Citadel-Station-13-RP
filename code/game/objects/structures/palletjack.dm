//Formally known as the Sokoban-ificator
/obj/structure/palletjack
	name = "\improper pallet jack"
	desc = "An ancient device used for jacking pallets. Do not stand on it!\
	\nIt can only be pulled by the handle, and cannot be pulled diagonally.\
	\nAdditionally, it can only move forward and back.\
	\nIf it gets stuck, you can click and drag it around to move it forward or back."
	icon = 'icons/obj/furniture.dmi'
	icon_state = "wheelchair"
	layer = BELOW_OBJ_LAYER
	density = TRUE
	atom_flags = ATOM_BORDER
	pass_flags = NONE
	pass_flags_self = ATOM_PASS_OVERHEAD_THROW | ATOM_PASS_THROWN
	generic_canpass = FALSE

	economic_category_obj = ECONOMIC_CATEGORY_OBJ_INDUSTRIAL
	worth_intrinsic = 25

/obj/structure/palletjack/Initialize(mapload)
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/structure/palletjack/LateInitialize()
	. = ..()
	update_appearance(UPDATE_ICON)

/obj/structure/palletjack/Moved(atom/old_loc, movement_dir, forced, list/old_locs, momentum_change)
	. = ..()
	if(has_gravity())
		playsound(src, 'sound/effects/roll.ogg', 50, TRUE)

/obj/structure/palletjack/update_overlays()
	. = ..()
	var/mutable_appearance/front_layer = mutable_appearance(icon, "w_overlay", ABOVE_MOB_LAYER, plane)
	. += front_layer

	for(var/atom/movable/M in contents)
		var/mutable_appearance/content_appearance = new
		content_appearance.appearance = M.appearance
		content_appearance.pixel_z += 4
		content_appearance.appearance_flags |= RESET_COLOR | RESET_ALPHA | RESET_TRANSFORM | KEEP_APART
		. += content_appearance

/obj/structure/palletjack/proc/absorb_tile_contents()
	var/picked_up = FALSE
	for(var/atom/movable/M in loc)
		if(M == src || M.anchored || M.atom_flags & ATOM_ABSTRACT || istype(M, /obj/effect))
			continue
		M.forceMove(src)
		picked_up = TRUE
	if(picked_up)
		playsound(src, 'sound/effects/metalscrape1.ogg', 50, TRUE)
		update_appearance(UPDATE_ICON)
		atom_flags &= ~ATOM_BORDER
		if(contents.len == 1)
			visible_message("[src] lifts up [contents[1]].")
		else
			visible_message("[src] lifts up the objects on top of it.") // why? Funni. :>

/obj/structure/palletjack/proc/expel_contents()
	if(contents.len)
		for(var/atom/movable/M in contents)
			M.forceMove(loc)
		playsound(src, 'sound/effects/metal_close.ogg', 50, TRUE)
		update_appearance(UPDATE_ICON)
		atom_flags |= ATOM_BORDER

/obj/structure/palletjack/on_attack_hand(datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	. = ..()
	if(. & CLICKCHAIN_FLAGS_INTERACT_ABORT)
		return

	if(!contents.len)
		absorb_tile_contents()
	else
		expel_contents()

//shamelessly plagiarized from thin windows
/obj/structure/palletjack/CanAllowThrough(atom/movable/mover, turf/target)
	. = ..()
	if(. || contents.len)
		return
	if(get_dir(mover, target) & dir)
		return !density
	return TRUE

/obj/structure/palletjack/CanPassThrough(atom/blocker, turf/target, blocker_opinion)
	. = ..()
	if(!contents.len && !. && ismovable(blocker))
		var/atom/movable/AM = blocker
		if(AM.density && !AM.anchored && get_dir(src, target) & dir)
			return TRUE

/obj/structure/palletjack/CheckExit(atom/movable/AM, atom/newLoc)
	. = ..()
	if(contents.len)
		return
	if(istype(AM) && (check_standard_flag_pass(AM)))
		return TRUE
	if(get_dir(src, newLoc) & global.reverse_dir[dir])
		return !density
	return TRUE

/obj/structure/palletjack/Move(atom/newloc, direct, step_x, step_y, glide_size_override)
	if(direct != dir && direct != global.reverse_dir[dir])
		return FALSE

	var/old_dir = dir

	if(!contents.len && direct == dir)
		for (var/atom/movable/AM in loc)
			if(AM != src && AM.density && !AM.anchored)
				return FALSE

	. = ..()

	setDir(old_dir)

/obj/structure/palletjack/proc/check_adjust_dir(atom/movable/mover, atom/oldloc, direction)
	var/target_dir = get_dir(mover, src)

	if(target_dir != dir && IS_CARDINAL(target_dir))
		setDir(target_dir)
		playsound(src, 'sound/effects/roll.ogg', 50, TRUE)

/obj/structure/palletjack/can_be_pulled(atom/movable/user, force)
	. = ..()
	if(.)
		if(dir & NORTH)
			return y > user.y
		else if(dir & SOUTH)
			return y < user.y
		else if (dir & WEST)
			return x < user.x
		else if (dir & EAST)
			return x > user.x

/obj/structure/palletjack/can_move_pulled(atom/movable/puller)
	if(Adjacent(puller))
		return FALSE
	return TRUE

/obj/structure/palletjack/on_start_pulled_by(atom/movable/puller)
	RegisterSignal(puller, COMSIG_MOVABLE_MOVED, PROC_REF(check_adjust_dir))
	. = ..()

/obj/structure/palletjack/on_stop_pulled_by(atom/movable/puller)
	. = ..()
	UnregisterSignal(puller, COMSIG_MOVABLE_MOVED)

/obj/structure/palletjack/relaymove(mob/user, direction)
	user.forceMove(loc)
	update_appearance(UPDATE_ICON)
	if(!contents.len)
		atom_flags |= ATOM_BORDER

/obj/structure/palletjack/OnMouseDrop(atom/over, mob/user, proximity, params)
	if(proximity && isturf(over) && over != loc && Adjacent(over))
		step_towards(src, over)
		return CLICKCHAIN_FLAGS_INTERACT_ABORT
	. = ..()
