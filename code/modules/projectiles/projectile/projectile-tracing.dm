//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station developers.          *//

/obj/projectile/trace
	atom_flags = ATOM_ABSTRACT | ATOM_NONWORLD
	invisibility = INVISIBILITY_ABSTRACT
	hitscan = TRUE
	has_tracer = FALSE
	damage_force = 0
	nodamage = TRUE
	projectile_type = PROJECTILE_TYPE_TRACE

	/// did we manage to hit the given target?
	var/could_hit_target = FALSE
	/// delete on hitting target?
	var/del_on_success = TRUE
	/// do we check opacity?
	var/check_opacity = FALSE
	/// do we only care about opacity, and not pass flags or anything else?
	var/only_opacity = FALSE
	/// do we only need to reach their turf?
	var/require_turf_only = FALSE
	/// target turf, if we only require reaching their turf
	var/turf/require_turf_cached

/obj/projectile/trace/CanPassThrough(atom/blocker, turf/target, blocker_opinion)
	if(only_opacity && !blocker.opacity)
		return TRUE
	return ..()

/obj/projectile/trace/pre_impact(atom/target, impact_flags, def_zone)
	if(target == original_target)
		could_hit_target = TRUE
		if(del_on_success)
			return PROJECTILE_IMPACT_DELETE
	if(get_turf(target) == require_turf_cached)
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
	if(QDELETED(src))
		return
	if(require_turf_cached == loc)
		could_hit_target = TRUE
		if(del_on_success)
			qdel(src)
			return
	if(check_opacity && isturf(loc))
		// *sigh* //
		var/turf/T = loc
		if(T.has_opaque_atom)
			qdel(src)

/**
 * always call this before firing.
 */
/obj/projectile/trace/proc/prepare_trace(atom/target)
	src.original_target = target
	if(require_turf_only)
		src.require_turf_cached = get_turf(target)
