
//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station developers.          *//

/obj/projectile/trace
	atom_flags = ATOM_ABSTRACT | ATOM_NONWORLD
	invisibility = INVISIBILITY_ABSTRACT
	hitscan = TRUE
	has_tracer = FALSE
	damage = 0
	nodamage = TRUE
	/// did we manage to hit the given target?
	var/could_hit_target = FALSE
	/// delete on hitting target?
	var/del_on_success = FALSE

/obj/projectile/trace/Bump(atom/A)
	. = ..()
	if(A == original)
		could_hit_target = TRUE
		if(del_on_success)
			qdel(src)

/obj/projectile/trace/proc/prepare_trace(atom/target)
	src.original = target
	src.range = max(src.range, (get_dist(src, target) + 1) * WORLD_ICON_SIZE)

/**
 * Simple trace to see if we could hit a given target
 */
/obj/projectile/trace/proc/simple_trace(atom/target, angle)
	prepare_trace(target)
	fire(angle)
	del_on_success = TRUE
	return could_hit_target
