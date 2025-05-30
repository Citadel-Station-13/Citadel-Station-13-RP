//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

// TODO: put into SSspatial_effects
/**
 * Creates a shrapnel explosion
 *
 * todo: /pellet shouldn't be /bullet/pellet
 * todo: there has to be a better way to set vars on every cloud than passing them in as args
 *
 * @params
 * * total_fragments - total pellets. this is divided by turfs within the given radius and rounded up.
 * * radius - radius to target. fragments are spread into every turf in the range, making one pellet cloud projectile
 * * fragment_types - either a type, or a list of types to pick from. weighted lists are not allowed for speed reasons. all types must be /obj/projectile/bullet/pellet.
 * * source - (optional) actual source; used to detect if something is on the ground or not
 * * shot_from_name - (legacy - pending reconsideration) what we were shot from
 * * firer - (legacy - pending reconsideration) what to set firer to
 */
/turf/proc/shrapnel_explosion(total_fragments, radius, fragment_types = /obj/projectile/bullet/pellet/fragment, atom/movable/source, shot_from_name, firer)
	SHOULD_NOT_OVERRIDE(TRUE)
	shrapnel_explosion_impl(total_fragments, radius, fragment_types, source, shot_from_name, firer)

/turf/proc/shrapnel_explosion_impl(total_fragments, radius, fragment_types, atom/movable/source, shot_from_name, firer)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(radius > 8)
		// remember that for radius 8 we're making 32 projectiles already
		CRASH("attempted radius [radius]; this is too large.")
	// todo: verify getcircle() behavior is what we want
	// todo: the answer is probably no, as this doesn't work near map edges.
	var/list/target_turfs = getcircle(src, radius)
	// round up
	var/fragments_per_projectile = ceil(total_fragments / length(target_turfs))
	// make shrapnel clouds
	. = list()
	for(var/turf/T in target_turfs)
		var/fragment_type = islist(fragment_types) ? pick(fragment_types) : fragment_types
		var/obj/projectile/bullet/pellet/pellet_cloud = new fragment_type(src)
		pellet_cloud.pellets = fragments_per_projectile
		pellet_cloud.shot_from = shot_from_name
		pellet_cloud.firer = firer
		pellet_cloud.fire(arctan(T.y - y, T.x - x), null, TRUE)
		. += pellet_cloud

/**
 * make a shrapnel explosion
 */
/obj/proc/shrapnel_explosion(total_fragments, radius, fragment_types)
	var/turf/turf = get_turf(src)
	if(!turf)
		return
	var/list/obj/projectile/bullet/pellet/pellet_clouds = turf.shrapnel_explosion(total_fragments, radius, fragment_types, src, name, src)
	// hit things in our turf
	for(var/mob/living/victim in turf)
		for(var/obj/projectile/bullet/pellet/pellet_cloud as anything in pellet_clouds)
			if(QDELETED(pellet_cloud))
				continue
			// they're laying on us, o h n o
			if(victim.lying && (loc == turf))
				if(prob(90))
					pellet_cloud.impact(victim)
			// they're not laying down but they're holding the source and standing
			else if(!victim.lying && victim.is_holding(src))
				if(prob(25))
					pellet_cloud.impact(victim)
			// they are either holding us while laying down or just on the turf without holding us
			else
				if(prob(15))
					pellet_cloud.impact(victim)
