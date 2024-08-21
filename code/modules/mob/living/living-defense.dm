//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station developers.          *//

//* Projectile Handling *//

/mob/living/bullet_act(obj/projectile/proj, impact_flags, def_zone, blocked)
	//! LEGACY

	// Using someone as a shield
	// todo: need a counter to this..
	for(var/mob/living/victim in get_grabbing_of_state(GRAB_NECK))
		if(victim.stat == DEAD)
			// small mobs are penalized; this is a holdover.
			var/shield_chance = min(80, (30 * (mob_size / 10)))
			if(prob(shield_chance))
				visible_message("<span class='danger'>\The [src] uses [victim] as a shield!</span>")
				if(!(proj.impact_redirect(victim, args) | (PROJECTILE_IMPACT_FLAGS_SHOULD_GO_THROUGH | PROJECTILE_IMPACT_DUPLICATE)))
					return
			else
				visible_message("<span class='danger'>\The [src] tries to use [victim] as a shield, but fails!</span>")
		else
			visible_message("<span class='danger'>\The [src] uses [victim] as a shield!</span>")
			if(!(proj.impact_redirect(victim, args) | (PROJECTILE_IMPACT_FLAGS_SHOULD_GO_THROUGH | PROJECTILE_IMPACT_DUPLICATE)))
				return
	// Process baymiss & zonemiss
	def_zone = process_bullet_miss(proj, impact_flags, def_zone, blocked)
	def_zone = proj.process_zone_miss(src, def_zone, proj.distance_travelled, TRUE)
	if(!def_zone)
		if(!proj.silenced)
			visible_message(SPAN_WARNING("\The [proj] misses [src] narrowly!"))
			playsound(src, pick(proj.miss_sounds), 60, TRUE)
		add_attack_logs(
			proj.firer,
			src,
			"shot with [src] ([type]) (missed)",
		)
		return PROJECTILE_IMPACT_PASSTHROUGH

	//! END

	. = ..()

	// todo: better logging
	if(. & PROJECTILE_IMPACT_FLAGS_TARGET_ABORT)
		add_attack_logs(
			proj.firer,
			src,
			"shot with [src] ([type]) (aborted)",
		)
		return
	add_attack_logs(
		proj.firer,
		src,
		"shot with [src] ([type])",
	)
	// emit feedback/workspaces/Citadel-Station-13-RP/code/modules/random_map
	if(proj.silenced)
		to_chat(src, SPAN_DANGER("You've been hit in the [parse_zone(def_zone)] with \the [proj]!"))
	else
		visible_message(SPAN_DANGER("\The [src] is hit by [proj] in the [parse_zone(def_zone)]"))

	//! LEGACY

	//Being hit while using a deadman switch
	for(var/obj/item/assembly/signaler/signaler in get_held_items())
		if(signaler.deadman && prob(80))
			log_and_message_admins("has triggered a signaler deadman's switch")
			src.visible_message("<font color='red'>[src] triggers their deadman's switch!</font>")
			signaler.signal()

	if(ai_holder && proj.firer)
		ai_holder.react_to_attack_polaris(proj.firer)

	//! END

	. |= proj.process_damage_instance(src, blocked, impact_flags, def_zone)

/mob/living/get_bullet_impact_effect_type(var/def_zone)
	return BULLET_IMPACT_MEAT

/**
 * @return zone to hit, or null to miss
 */
/mob/living/proc/process_bullet_miss(obj/projectile/proj, impact_flags, def_zone, blocked)
	var/hit_probability = process_baymiss(proj)
	if(!prob(hit_probability))
		return null
	return def_zone

/**
 * * our_opinion is intentionally mutable.
 *
 * todo: 0 to 100 for accuracy might not be amazing; maybe allow negative values evasion-style?
 *
 * @params
 * * proj - the projectile
 * * our_opinion - base probability of hitting
 *
 * @return 0 to 100 % probability of hitting
 */
/mob/living/proc/process_baymiss(obj/projectile/proj, our_opinion = 100)
	our_opinion = clamp(our_opinion - get_evasion(), 5, INFINITY)
	return proj.process_accuracy(src, our_opinion, proj.distance_travelled, TRUE)

//* Misc Effects *//

/**
 * Processes a slip.
 *
 * * hard / soft strength are not necessarily directly mapped to stuns
 * * hard / soft strength can do a lot more than stun so don't go overboard
 *
 * @params
 * * slip_class - SLIP_CLASS_* flags of what the slip is
 * * source - a text string, or an atom, of what the source is
 * * hard_strength - nominally the amount of time it'll hardstun someone for; this should be very, very low
 * * soft_strength - nominally how strong the slip should be in terms of stun power. this is, optimally, 0 to 100, with the assumption most people go down at 100
 * * suppressed - suppress outgoing sound and text.
 *
 * @return 0 to 1 for effectiveness, with 0 being 'entirely resisted' and 1 being 'entirely hit'
 */
/mob/living/proc/slip_act(slip_class, source, hard_strength, soft_strength, suppressed)
	return 1
//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station developers.          *//
