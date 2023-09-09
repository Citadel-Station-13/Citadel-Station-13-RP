var/list/table_icon_cache = list()

/obj/structure/table
	name = "table frame"
	icon = 'icons/obj/tables.dmi'
	icon_state = "frame"
	desc = "It's a table, for putting things on. Or standing on, if you really want to."
	density = TRUE
	pass_flags_self = ATOM_PASS_THROWN | ATOM_PASS_CLICK | ATOM_PASS_TABLE | ATOM_PASS_OVERHEAD_THROW | ATOM_PASS_BUCKLED
	anchored = TRUE
	layer = TABLE_LAYER
	surgery_odds = 66
	connections = list("nw0", "ne0", "sw0", "se0")

	// smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = (SMOOTH_GROUP_TABLES)
	canSmoothWith = (SMOOTH_GROUP_TABLES + SMOOTH_GROUP_LOW_WALL)

	integrity = 200
	integrity_max = 200
	climb_allowed = TRUE
	depth_level = 8
	depth_projected = TRUE

	material_parts = MATERIAL_DEFAULT_ABSTRACTED

	var/datum/material/material_base = /datum/material/steel
	var/datum/material/material_reinforcing

	var/flipped = 0

	// For racks.
	var/can_reinforce = 1
	var/can_plate = 1

	var/manipulating = 0

	// Gambling tables. I'd prefer reinforced with carpet/felt/cloth/whatever, but AFAIK it's either harder or impossible to get /obj/item/stack/material of those.
	// Convert if/when you can easily get stacks of these.
	var/carpeted = 0
	var/carpeted_type = /obj/item/stack/tile/carpet

	/// Can people place items on us by clicking on us?
	var/item_place = TRUE
	/// Do people pixel-place items or center place?
	var/item_pixel_place = TRUE

/obj/structure/table/Initialize(mapload, base_material, reinforcing_material)
	if(!isnull(base_material))
		material_base = base_material
	if(!isnull(reinforcing_material))
		material_reinforcing = reinforcing_material
	. = ..()

	// One table per turf.
	for(var/obj/structure/table/T in loc)
		if(T != src)
			// There's another table here that's not us, break to metal.
			// break_to_parts calls qdel(src)
			break_to_parts(full_return = 1)
			return

	// reset color/alpha, since they're set for nice map previews
	color = "#ffffff"
	alpha = 255
	if(mapload)		// screw off
		return INITIALIZE_HINT_LATELOAD
	else
		update_connections(TRUE)
		update_icon()
		update_desc()

/obj/structure/table/LateInitialize()		// CURSE YOU DUMB AS ROCKS MATERIAL SYSTEM
	. = ..()
	update_connections(FALSE)
	update_icon()
	update_desc()

/obj/structure/table/Destroy()
	var/old_loc = loc
	// i am so sorry ~silicons
	spawn(0)
		for(var/obj/structure/table/T in old_loc)
			T.update_connections()
	return ..()

/obj/structure/table/examine_more(mob/user)
	. = ..()
	if(carpeted)
		. += SPAN_NOTICE("Use a <b>crowbar</b> to remove its carpet.")
	if(isnull(material_reinforcing))
		if(!isnull(material_base))
			. += SPAN_NOTICE("<b>Clickdrag</b> a material stack to this to apply a reinforcement layer.")
			. += SPAN_NOTICE("Use a <b>wrench</b> to remove its surface plating.")
		else
			. += SPAN_NOTICE("Use a <b>wrench</b> to deconstruct the frame.")
	else
		. += SPAN_NOTICE("Use a <b>screwdriver</b> to remove its reinforcement.")

/obj/structure/table/crowbar_act(obj/item/I, mob/user, flags, hint)
	. = ..()
	if(.)
		return
	if(!carpeted)
		return FALSE
	if(!use_crowbar(I, user, flags, 0, usage = TOOL_USAGE_DECONSTRUCT))
		return TRUE
	if(!carpeted)
		return TRUE
	user.visible_action_feedback(
		target = src,
		hard_range = MESSAGE_RANGE_CONSTRUCTION,
		visible_hard = SPAN_NOTICE("[user] removes the carpet from [src]."),
		visible_self = SPAN_NOTICE("You remove the carpet from [src]."),
		audible_hard = SPAN_WARNING("You hear something soft being pulled off a surface."),
	)
	user.actor_construction_log(src, "de-carpeted")
	new carpeted_type(loc)
	carpeted = FALSE
	update_appearance()
	return TRUE

/obj/structure/table/wrench_act(obj/item/I, mob/user, flags, hint)
	. = ..()
	if(.)
		return
	if(!isnull(material_reinforcing))
		user.action_feedback(SPAN_WARNING("[src] needs to have its reinforcement removed before being dismantled!"))
		return TRUE
	if(isnull(material_base))
		user.visible_action_feedback(
			target = src,
			hard_range = MESSAGE_RANGE_CONSTRUCTION,
			visible_hard = SPAN_NOTICE("[user] begins dismantling \the [src]."),
			visible_self = SPAN_NOTICE("You begin dismantling [src]."),
			audible_hard = SPAN_WARNING("You hear the sound of bolts and screws being undone."),
		)
		user.actor_construction_log(src, "started dismantling")
		if(!use_wrench(I, user, flags, 1.5 SECONDS, usage = TOOL_USAGE_DECONSTRUCT))
			return TRUE
		if(!isnull(material_reinforcing) || !isnull(material_base))
			user.action_feedback(SPAN_WARNING("[src] needs to be entirely stripped before being dismantled!"))
			return TRUE
		user.visible_action_feedback(
			target = src,
			hard_range = MESSAGE_RANGE_CONSTRUCTION,
			visible_hard = SPAN_NOTICE("[user] dismantles \the [src]."),
			visible_self = SPAN_NOTICE("You dismantle [src]."),
			audible_hard = SPAN_WARNING("You hear the sound of something being folded down and dismantled."),
		)
		user.actor_construction_log(src, "dismantled")
		deconstruct(ATOM_DECONSTRUCT_DISASSEMBLED)
	else
		user.visible_action_feedback(
			target = src,
			hard_range = MESSAGE_RANGE_CONSTRUCTION,
			visible_hard = SPAN_NOTICE("[user] begins removing the plating from \the [src]."),
			visible_self = SPAN_NOTICE("You begin removing the plating from \the [src]."),
			audible_hard = SPAN_WARNING("You hear the sound of bolts being undone."),
		)
		user.actor_construction_log(src, "started de-plating")
		if(!use_wrench(I, user, flags, 3 SECONDS, usage = TOOL_USAGE_DECONSTRUCT))
			return TRUE
		if(!isnull(material_reinforcing))
			user.action_feedback(SPAN_WARNING("[src] needs to have its reinforcement removed before being dismantled!"))
			return TRUE
		user.visible_action_feedback(
			target = src,
			hard_range = MESSAGE_RANGE_CONSTRUCTION,
			visible_hard = SPAN_NOTICE("[user] removes the plating from \the [src]."),
			visible_self = SPAN_NOTICE("You remove the plating from \the [src]."),
			audible_hard = SPAN_WARNING("You hear the sound of a heavy plate being lifted off of something."),
		)
		user.actor_construction_log(src, "de-plated")
		material_base.place_sheet(loc, 1)
		set_material_part("base", null)
	return TRUE

/obj/structure/table/screwdriver_act(obj/item/I, mob/user, flags, hint)
	. = ..()
	if(.)
		return
	if(isnull(material_reinforcing))
		return FALSE
	user.visible_action_feedback(
		target = src,
		hard_range = MESSAGE_RANGE_CONSTRUCTION,
		visible_hard = SPAN_NOTICE("[user] begins removing the reinforcement from \the [src]."),
		visible_self = SPAN_NOTICE("You begin removing the reinforcement from \the [src]."),
		audible_hard = SPAN_WARNING("You hear the sound of screws being undone."),
	)
	user.actor_construction_log(src, "started de-reinforcing")
	if(!use_wrench(I, user, flags, 1.5 SECONDS, usage = TOOL_USAGE_DECONSTRUCT))
		return TRUE
	if(!isnull(material_reinforcing))
		return TRUE
	user.visible_action_feedback(
		target = src,
		hard_range = MESSAGE_RANGE_CONSTRUCTION,
		visible_hard = SPAN_NOTICE("[user] removes the reinforcement from \the [src]."),
		visible_self = SPAN_NOTICE("You remove the reinforcement from \the [src]."),
		audible_hard = SPAN_WARNING("You hear the sound of screws falling out and something being slid out."),
	)
	user.actor_construction_log(src, "de-reinforced")
	material_reinforcing.place_sheet(loc, 1)
	set_material_part("reinf", null)
	return TRUE

/obj/structure/table/dynamic_tool_functions(obj/item/I, mob/user)
	. = list()
	if(carpeted)
		.[TOOL_CROWBAR] = "remove carpet"
	if(isnull(material_reinforcing))
		if(isnull(material_base))
			.[TOOL_WRENCH] = "dismantle"
		else
			.[TOOL_WRENCH] = "remove plating"
	else
		.[TOOL_SCREWDRIVER] = "remove reinforcement"
	return merge_double_lazy_assoc_list(., ..())

/obj/structure/table/dynamic_tool_image(function, hint)
	switch(hint)
		if("remove carpet")
			return dyntool_image_backward(TOOL_CROWBAR)
		if("dismantle", "remove plating")
			return dyntool_image_backward(TOOL_WRENCH)
		if("remove reinforcement")
			return dyntool_image_backward(TOOL_SCREWDRIVER)
	return ..()

/obj/structure/table/attackby(obj/item/I, mob/living/user, list/params, clickchain_flags, damage_multiplier)
	if(!carpeted && !isnull(material_base) && istype(W, /obj/item/stack/tile/carpet))
		var/obj/item/stack/tile/carpet/C = W
		if(C.use(1))
			user.visible_message("<span class='notice'>\The [user] adds \the [C] to \the [src].</span>",
			                              "<span class='notice'>You add \the [C] to \the [src].</span>")
			carpeted = 1
			carpeted_type = W.type
			update_icon()
			return 1
		else
			to_chat(user, "<span class='warning'>You don't have enough carpet!</span>")

	if(integrity < integrity_max && istype(W, /obj/item/weldingtool))
		var/obj/item/weldingtool/F = W
		if(F.welding)
			to_chat(user, "<span class='notice'>You begin reparing damage to \the [src].</span>")
			playsound(src, F.tool_sound, 50, 1)
			if(!do_after(user, 20 * F.tool_speed) || !F.remove_fuel(1, user))
				return
			user.visible_message("<span class='notice'>\The [user] repairs some damage to \the [src].</span>",
			                              "<span class='notice'>You repair some damage to \the [src].</span>")
			adjust_integrity(integrity_max / 2)
			return 1

	if(!material && can_plate && istype(W, /obj/item/stack/material))
		material = common_material_add(W, user, "plat")
		if(material)
			update_connections(1)
			update_icon()
			update_desc()
		return 1

	return ..()

/obj/structure/table/MouseDroppedOnLegacy(obj/item/stack/material/what)
	if(can_reinforce && isliving(usr) && (!usr.stat) && istype(what) && usr.get_active_held_item() == what && Adjacent(usr))
		reinforce_table(what, usr)
	else
		return ..()

/obj/structure/table/proc/reinforce_table(obj/item/stack/material/S, mob/user)
	if(get_material_part("reinf"))
		to_chat(user, "<span class='warning'>\The [src] is already reinforced!</span>")
		return

	if(!can_reinforce)
		to_chat(user, "<span class='warning'>\The [src] cannot be reinforced!</span>")
		return

	if(!get_material_part("base"))
		to_chat(user, "<span class='warning'>Plate \the [src] before reinforcing it!</span>")
		return

	if(flipped)
		to_chat(user, "<span class='warning'>Put \the [src] back in place before reinforcing it!</span>")
		return

	reinforced = common_material_add(S, user, "reinforc")
	if(reinforced)
		update_desc()
		update_icon()

/obj/structure/table/update_name(updates)
	name = isnull(material_base)? "table frame" : "[material_base.display_name] table"
	if(!isnull(material_reinforcing))
		name = "reinforced [name]"
	return ..()

/obj/structure/table/update_desc()
	desc = initial(desc)
	if(!isnull(material_reinforcing))
		desc = "[desc] This one seems to be reinforced with [material_reinforcing.display_name]."
	return ..()

// Returns the material to set the table to.
/obj/structure/table/proc/common_material_add(obj/item/stack/material/S, mob/user, verb) // Verb is actually verb without 'e' or 'ing', which is added. Works for 'plate'/'plating' and 'reinforce'/'reinforcing'.
	var/datum/material/M = S.get_material()
	if(!istype(M))
		to_chat(user, "<span class='warning'>You cannot [verb]e \the [src] with \the [S].</span>")
		return null

	if(manipulating) return M
	manipulating = 1
	to_chat(user, "<span class='notice'>You begin [verb]ing \the [src] with [M.display_name].</span>")
	if(!do_after(user, 20) || !S.use(1))
		manipulating = 0
		return null
	user.visible_message("<span class='notice'>\The [user] [verb]es \the [src] with [M.display_name].</span>", "<span class='notice'>You finish [verb]ing \the [src].</span>")
	manipulating = 0
	return M

// Returns a list of /obj/item/material/shard objects that were created as a result of this table's breakage.
// Used for !fun! things such as embedding shards in the faces of tableslammed people.

// The repeated
//     S = [x].place_shard(loc)
//     if(S) shards += S
// is to avoid filling the list with nulls, as place_shard won't place shards of certain materials (holo-wood, holo-steel)

/obj/structure/table/proc/break_to_parts(full_return = 0)
	var/list/shards = list()
	var/obj/item/material/shard/S = null
	if(reinforced)
		if(reinforced.stack_type && (full_return || prob(20)))
			reinforced.place_sheet(loc)
		else
			S = reinforced.place_shard(loc)
			if(S) shards += S
	if(material)
		if(material.stack_type && (full_return || prob(20)))
			material.place_sheet(loc)
		else
			S = material.place_shard(loc)
			if(S) shards += S
	if(carpeted && (full_return || prob(50))) // Higher chance to get the carpet back intact, since there's no non-intact option
		new carpeted_type(src.loc)
	if(full_return || prob(20))
		new /obj/item/stack/material/steel(src.loc)
	else
		var/datum/material/M = get_material_by_name(MAT_STEEL)
		S = M.place_shard(loc)
		if(S) shards += S
	qdel(src)
	return shards

/proc/get_table_image(var/icon/ticon,var/ticonstate,var/tdir,var/tcolor,var/talpha)
	var/icon_cache_key = "\ref[ticon]-[ticonstate]-[tdir]-[tcolor]-[talpha]"
	var/image/I = table_icon_cache[icon_cache_key]
	if(!I)
		I = image(icon = ticon, icon_state = ticonstate, dir = tdir)
		if(tcolor)
			I.color = tcolor
		if(talpha)
			I.alpha = talpha
		table_icon_cache[icon_cache_key] = I

	return I

/obj/structure/table/update_icon()
	cut_overlays()
	var/list/overlays_to_add = list()

	if(flipped != 1)
		icon_state = "blank"

		// Base frame shape. Mostly done for glass/diamond tables, where this is visible.
		for(var/i = 1 to 4)
			var/image/I = get_table_image(icon, connections[i], 1<<(i-1))
			overlays_to_add += I

		// Standard table image
		if(material)
			for(var/i = 1 to 4)
				var/image/I = get_table_image(icon, "[material.table_icon_base]_[connections[i]]", 1<<(i-1), material.icon_colour, 255 * material.opacity)
				overlays_to_add += I

		// Reinforcements
		if(reinforced)
			for(var/i = 1 to 4)
				var/image/I = get_table_image(icon, "[reinforced.table_reinf_icon_base]_[connections[i]]", 1<<(i-1), reinforced.icon_colour, 255 * reinforced.opacity)
				overlays_to_add += I

		if(carpeted)
			for(var/i = 1 to 4)
				var/image/I = get_table_image(icon, "carpet_[connections[i]]", 1<<(i-1))
				overlays_to_add += I
	else
		var/type = 0
		var/tabledirs = 0
		for(var/direction in list(turn(dir,90), turn(dir,-90)) )
			var/obj/structure/table/T = locate(/obj/structure/table ,get_step(src,direction))
			if (T && T.flipped == 1 && T.dir == src.dir && material && T.material && T.material.name == material.name)
				type++
				tabledirs |= direction

		type = "[type]"
		if (type=="1")
			if (tabledirs & turn(dir,90))
				type += "-"
			if (tabledirs & turn(dir,-90))
				type += "+"

		icon_state = "flip[type]"
		if(material)
			var/image/I = image(icon, "[material.table_icon_base]_flip[type]")
			I.color = material.icon_colour
			I.alpha = 255 * material.opacity
			overlays_to_add += I
			name = "[material.display_name] table"
		else
			name = "table frame"

		if(reinforced)
			var/image/I = image(icon, "[reinforced.table_reinf_icon_base]_flip[type]")
			I.color = reinforced.icon_colour
			I.alpha = 255 * reinforced.opacity
			overlays_to_add += I

		if(carpeted)
			overlays_to_add += "carpet_flip[type]"

	add_overlay(overlays_to_add)

// set propagate if you're updating a table that should update tables around it too, for example if it's a new table or something important has changed (like material).
/obj/structure/table/update_connections(propagate=0)
	if(!material_base)
		connections = list("0", "0", "0", "0")
		if(propagate)
			for(var/obj/structure/table/T in orange(src, 1))
				T.update_connections()
				T.update_icon()
		return

	var/list/blocked_dirs = list()
	for(var/obj/structure/window/W in get_turf(src))
		if(W.fulltile)
			connections = list("0", "0", "0", "0")
			return
		blocked_dirs |= W.dir

	for(var/D in list(NORTH, SOUTH, EAST, WEST) - blocked_dirs)
		var/turf/T = get_step(src, D)
		for(var/obj/structure/window/W in T)
			if(W.fulltile || W.dir == global.reverse_dir[D])
				blocked_dirs |= D
				break
			else
				if(W.dir != D) // it's off to the side
					blocked_dirs |= W.dir|D // blocks the diagonal

	for(var/D in list(NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST) - blocked_dirs)
		var/turf/T = get_step(src, D)

		for(var/obj/structure/window/W in T)
			if(W.fulltile || W.dir & global.reverse_dir[D])
				blocked_dirs |= D
				break

	// Blocked cardinals block the adjacent diagonals too. Prevents weirdness with tables.
	for(var/x in list(NORTH, SOUTH))
		for(var/y in list(EAST, WEST))
			if((x in blocked_dirs) || (y in blocked_dirs))
				blocked_dirs |= x|y

	var/list/connection_dirs = list()

	for(var/obj/structure/table/T in orange(src, 1))
		var/T_dir = get_dir(src, T)
		if(T_dir in blocked_dirs)
			continue
		if(material_base && T.material_base && material_base.name == T.material_base.name && flipped == T.flipped)
			connection_dirs |= T_dir
		if(propagate)
			spawn(0)
				T.update_connections()
				T.update_icon()

	connections = dirs_to_corner_states(connection_dirs)

#define CORNER_NONE 0
#define CORNER_COUNTERCLOCKWISE 1
#define CORNER_DIAGONAL 2
#define CORNER_CLOCKWISE 4

/*
  turn() is weird:
    turn(icon, angle) turns icon by angle degrees clockwise
    turn(matrix, angle) turns matrix by angle degrees clockwise
    turn(dir, angle) turns dir by angle degrees counter-clockwise
*/

/proc/dirs_to_corner_states(list/dirs)
	if(!istype(dirs))
		return

	var/list/ret = list(NORTHWEST, SOUTHEAST, NORTHEAST, SOUTHWEST)

	for(var/i = 1 to ret.len)
		var/dir = ret[i]
		. = CORNER_NONE
		if(dir in dirs)
			. |= CORNER_DIAGONAL
		if(turn(dir,45) in dirs)
			. |= CORNER_COUNTERCLOCKWISE
		if(turn(dir,-45) in dirs)
			. |= CORNER_CLOCKWISE
		ret[i] = "[.]"

	return ret

/**
 * generates corner state for a corner
 * smoothing_junction must be set at this point
 * corner is 0 to 3 not 1 to 4
 *
 * proc usually used for helping us commit war crimes with custom_smooth().
 */
/atom/proc/get_corner_state_using_junctions(corner)
	// north, south, east, west, in that order
	// which translates to northwest, southeast, northeast, southwest in that order
	// honestly fuck you, precompute.
	// cache for sanic speed
	var/smoothing_junction = src.smoothing_junction
	switch(corner)
		if(0)
			return ((smoothing_junction & NORTHWEST_JUNCTION)? CORNER_DIAGONAL : NONE) | ((smoothing_junction & NORTH_JUNCTION)? CORNER_CLOCKWISE : NONE) | ((smoothing_junction & WEST_JUNCTION)? CORNER_COUNTERCLOCKWISE : NONE)
		if(1)
			return ((smoothing_junction & SOUTHEAST_JUNCTION)? CORNER_DIAGONAL : NONE) | ((smoothing_junction & SOUTH_JUNCTION)? CORNER_CLOCKWISE : NONE) | ((smoothing_junction & EAST_JUNCTION)? CORNER_COUNTERCLOCKWISE : NONE)
		if(2)
			return ((smoothing_junction & NORTHEAST_JUNCTION)? CORNER_DIAGONAL : NONE) | ((smoothing_junction & EAST_JUNCTION)? CORNER_CLOCKWISE : NONE) | ((smoothing_junction & NORTH_JUNCTION)? CORNER_COUNTERCLOCKWISE : NONE)
		if(3)
			return ((smoothing_junction & SOUTHWEST_JUNCTION)? CORNER_DIAGONAL : NONE) | ((smoothing_junction & WEST_JUNCTION)? CORNER_CLOCKWISE : NONE) | ((smoothing_junction & SOUTH_JUNCTION)? CORNER_COUNTERCLOCKWISE : NONE)

/datum/silly_datum_to_block_byond_bug_2072419

#undef CORNER_NONE
#undef CORNER_COUNTERCLOCKWISE
#undef CORNER_DIAGONAL
#undef CORNER_CLOCKWISE
