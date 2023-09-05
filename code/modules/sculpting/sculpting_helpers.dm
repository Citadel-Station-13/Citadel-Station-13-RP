//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * grabs an icon from something for sculpting, processing it into a greyscale toned to the material's color
 *
 * @params
 * * to_clone - the atom the person is trying to replicate with the sculpt. no turfs.
 * * material_color - the color to tone to as rgb color string
 *
 * @return list(icon, x, y) where x/y are centering offsets
 */
/obj/structure/sculpting_block/proc/get_model_tuple(atom/movable/to_clone, material_color)
	. = get_flat_icon(to_clone)
	if(isnull(.))
		return
	var/icon/flattened = .[1]
	flattened.ColorTone(material_color)

/**
 * get things in range of user that can be sculpted
 */
/obj/structure/sculpting_block/proc/get_possible_targets(mob/user, range_to_scan = 7)
	. = list()
	var/list/atom/potential = view(range_to_scan, user)
	for(var/atom/movable/AM in potential)
		if(AM.atom_flags & ATOM_ABSTRACT)
			continue
		if(AM.invisibility > user.see_invisible)
			continue
		if(!user.can_see_plane(AM.plane))
			continue
		if(isobj(AM))
			var/obj/O = AM
			if(!(O.obj_flags & OBJ_NO_SCULPTING))
				continue
		else
			var/mob/M = AM
			//! legacy code
			if(M.is_incorporeal())
				continue
			//! end
		. += AM
