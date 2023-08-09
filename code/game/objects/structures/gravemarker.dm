/obj/structure/gravemarker
	name = "grave marker"
	desc = "An object used in marking graves."
	icon_state = "gravemarker"

	density = TRUE
	pass_flags_self = ATOM_PASS_THROWN | ATOM_PASS_CLICK | ATOM_PASS_TABLE | ATOM_PASS_OVERHEAD_THROW
	climb_allowed = TRUE
	depth_level = 8
	anchored = TRUE

	layer = ABOVE_JUNK_LAYER

	integrity = 300
	integrity_max = 300

	var/grave_name = ""		//Name of the intended occupant
	var/epitaph = ""		//A quick little blurb
//	var/dir_locked = 0		//Can it be spun?	Not currently implemented

	var/datum/material/material

/obj/structure/gravemarker/Initialize(mapload, material_name)
	. = ..()
	if(!material_name)
		material_name = "wood"
	material = get_material_by_name("[material_name]")
	if(!material)
		qdel(src)
		return
	add_atom_colour(material.icon_colour, FIXED_COLOUR_PRIORITY)

/obj/structure/gravemarker/examine(mob/user, dist)
	. = ..()
	if(get_dist(src, user) < 4)
		if(grave_name)
			. += "Here Lies [grave_name]"
	if(get_dist(src, user) < 2)
		if(epitaph)
			. += epitaph

/obj/structure/gravemarker/CanAllowThrough(atom/movable/mover, turf/target)
	if(!(get_dir(loc, target) & dir))
		return TRUE
	return ..()

/obj/structure/gravemarker/CheckExit(atom/movable/AM, atom/newLoc)
	if(!(get_dir(src, newLoc) & dir))
		return TRUE
	if(check_standard_flag_pass(AM))
		return TRUE
	return FALSE

/obj/structure/gravemarker/attackby(obj/item/I, mob/living/user, list/params, clickchain_flags, damage_multiplier)
	if(I.is_screwdriver())
		var/datum/material/material = get_primary_material()
		var/time_mult = (material.regex_this_hardness > 0)? material.regex_this_hardness / 100 : 1 / (material.regex_this_hardness / 100)
		var/carving_1 = sanitizeSafe(input(user, "Who is \the [src.name] for?", "Gravestone Naming", null)  as text, MAX_NAME_LEN)
		if(carving_1)
			user.visible_message("[user] starts carving \the [src.name].", "You start carving \the [src.name].")
			if(do_after(user, time_mult * 2 SECONDS * I.tool_speed))
				user.visible_message("[user] carves something into \the [src.name].", "You carve your message into \the [src.name].")
				grave_name += carving_1
				update_icon()
		var/carving_2 = sanitizeSafe(input(user, "What message should \the [src.name] have?", "Epitaph Carving", null)  as text, MAX_NAME_LEN)
		if(carving_2)
			user.visible_message("[user] starts carving \the [src.name].", "You start carving \the [src.name].")
			if(do_after(user, time_mult * 2 SECONDS * I.tool_speed))
				user.visible_message("[user] carves something into \the [src.name].", "You carve your message into \the [src.name].")
				epitaph += carving_2
				update_icon()
		return
	if(I.is_wrench())
		var/datum/material/material = get_primary_material()
		var/time_mult = (material.regex_this_hardness > 0)? material.regex_this_hardness / 100 : 1 / (material.regex_this_hardness / 100)
		user.visible_message("[user] starts taking down \the [src.name].", "You start taking down \the [src.name].")
		if(do_after(user, time_mult * 2 SECONDS * I.tool_speed))
			user.visible_message("[user] takes down \the [src.name].", "You take down \the [src.name].")
			deconstruct()
	..()

/obj/structure/gravemarker/drop_products(method, atom/where)
	. = ..()
	material.place_dismantled_product(where, method == ATOM_DECONSTRUCT_DISASSEMBLED? 5 : 3)

/obj/structure/gravemarker/verb/rotate_clockwise()
	set name = "Rotate Grave Marker Clockwise"
	set category = "Object"
	set src in oview(1)

	if(anchored)
		return

	if(!usr || !isturf(usr.loc))
		return
	if(usr.stat || usr.restrained())
		return
	if(ismouse(usr) || (isobserver(usr) && !config_legacy.ghost_interaction))
		return

	setDir(turn(src.dir, 270))
