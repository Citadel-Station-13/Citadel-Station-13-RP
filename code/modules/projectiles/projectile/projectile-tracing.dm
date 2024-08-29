//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station developers.          *//

/obj/projectile/trace
	atom_flags = ATOM_ABSTRACT | ATOM_NONWORLD
	invisibility = INVISIBILITY_ABSTRACT
	hitscan = TRUE
	has_tracer = FALSE
	damage = 0
	nodamage = TRUE
	projectile_type = PROJECTILE_TYPE_TRACE
	/// did we manage to hit the given target?
	var/could_hit_target = FALSE
	/// delete on hitting target?
	var/del_on_success = FALSE
	/// do we check opacity?
	var/check_opacity = FALSE

/obj/projectile/trace/pre_impact(atom/target, impact_flags, def_zone)
	if(target == original_target)
		could_hit_target = TRUE
		if(del_on_success)
			return PROJECTILE_IMPACT_DELETE
	. = ..()
	// tracers only count as 'can move across' if pre_impact() says we should phase/pierce.
	if(. & PROJECTILE_IMPACT_FLAGS_SHOULD_GO_THROUGH)
		return PROJECTILE_IMPACT_PASSTHROUGH
	else
		return PROJECTILE_IMPACT_DELETE

/obj/projectile/trace/Moved()
	. = ..()
	if(check_opacity && isturf(loc))
		// *sigh* //
		var/turf/T = loc
		if(T.has_opaque_atom)
			qdel(src)

/obj/projectile/trace/proc/prepare_trace(atom/target, pass_flags = ATOM_PASS_GLASS | ATOM_PASS_GRILLE | ATOM_PASS_TABLE, check_opacity)
	src.pass_flags = pass_flags
	src.original_target = target
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
