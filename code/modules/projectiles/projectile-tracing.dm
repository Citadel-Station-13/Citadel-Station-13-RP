
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
	/// do we check opacity?
	var/check_opacity = FALSE

/obj/projectile/trace/Bump(atom/A)
	if(A == original)
		could_hit_target = TRUE
		if(del_on_success)
			qdel(src)
			return
	return ..()

/obj/projectile/trace/projectile_attack_mob()
	return

/obj/projectile/trace/Moved()
	. = ..()
	if(check_opacity && isturf(loc))
		// *sigh* //
		var/turf/T = loc
		if(T.has_opaque_atom)
			qdel(src)

/obj/projectile/trace/proc/prepare_trace(atom/target, pass_flags = ATOM_PASS_GLASS | ATOM_PASS_GRILLE | ATOM_PASS_TABLE, check_opacity)
	src.pass_flags = pass_flags
	src.original = target
	src.check_opacity = check_opacity
	src.range = max(src.range, (get_dist(src, target) + 1) * WORLD_ICON_SIZE)

/**
 * Simple trace to see if we could hit a given target
 */
/obj/projectile/trace/proc/simple_trace(atom/target, angle)
	prepare_trace(target)
	fire(angle)
	del_on_success = TRUE
	return could_hit_target
