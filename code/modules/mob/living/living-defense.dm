//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/mob/living/is_melee_targetable(datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	return TRUE

//* FX *//

/mob/living/get_combat_fx_classifier(attack_type, datum/attack_source, target_zone)
	if(isSynthetic())
		return COMBAT_IMPACT_FX_METAL
	return COMBAT_IMPACT_FX_FLESH

//* Melee Handling *//

/mob/living/melee_act(mob/attacker, obj/item/weapon, datum/melee_attack/weapon/style, target_zone, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	. = ..()
	if(. & CLICKCHAIN_FLAGS_ATTACK_ABORT)
		return
	ai_holder?.react_to_attack_polaris(attacker)

//* Projectile Handling *//

/mob/living/bullet_act(obj/projectile/proj, impact_flags, def_zone, efficiency)
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
	def_zone = process_bullet_miss(proj, impact_flags, def_zone, efficiency)
	def_zone = proj.process_zone_miss(src, def_zone, proj.distance_travelled, TRUE)
	if(!def_zone)
		if(!proj.silenced)
			visible_message(SPAN_WARNING("\The [proj] misses [src] narrowly!"))
			playsound(src, pick(proj.miss_sounds), 60, TRUE)
		add_attack_logs(
			proj.firer,
			src,
			"shot with [proj] ([type]) (missed)",
		)
		impact_flags |= PROJECTILE_IMPACT_PASSTHROUGH
		return ..()

	//! END

	return ..()

/mob/living/on_bullet_act(obj/projectile/proj, impact_flags, list/bullet_act_args)
	// todo: better logging
	if(impact_flags & PROJECTILE_IMPACT_FLAGS_TARGET_ABORT)
		add_attack_logs(
			proj.firer,
			src,
			"shot with [proj] ([type]) (aborted)",
		)
		return
	add_attack_logs(
		proj.firer,
		src,
		"shot with [proj] ([type])[(impact_flags & PROJECTILE_IMPACT_BLOCKED)? " (blocked)" : ""]",
	)
	// emit feedback
	if(!(impact_flags & PROJECTILE_IMPACT_BLOCKED))
		if(proj.silenced)
			to_chat(src, SPAN_DANGER("You've been hit in the [parse_zone(bullet_act_args[BULLET_ACT_ARG_ZONE])] with \the [proj]!"))
		else
			visible_message(SPAN_DANGER("\The [src] is hit by [proj] in the [parse_zone(bullet_act_args[BULLET_ACT_ARG_ZONE])]"))

	//! LEGACY
	//Being hit while using a deadman switch
	for(var/obj/item/assembly/signaler/signaler in get_held_items())
		if(signaler.deadman && prob(80))
			log_and_message_admins("has triggered a signaler deadman's switch")
			visible_message("<font color='red'>[src] triggers their deadman's switch!</font>")
			spawn(-1)
				signaler.signal()

	if(ai_holder && proj.firer)
		ai_holder.react_to_attack_polaris(proj.firer)
	//! END

	return ..()

/**
 * @return zone to hit, or null to miss
 */
/mob/living/proc/process_bullet_miss(obj/projectile/proj, impact_flags, def_zone, efficiency)
	var/hit_probability = process_baymiss(proj)
	if(!prob(hit_probability))
		return null
	return def_zone

/**
 * * our_opinion is intentionally mutable; it is however only mutable from before ..(), so call ..() after modifying for pre-modification
 * * our_opinion and impact_check are defaulted in the base function; this means that if you need to use it before, default it yourself.
 *
 * todo: 0 to 100 for accuracy might not be amazing; maybe allow negative values evasion-style?
 * todo: don't default our_opinion and impact_check so early wtf; BYOND proc structure disagrees with the design here.
 *
 * @params
 * * proj - the projectile
 * * our_opinion - base probability of hitting
 * * impact_check - are we checking if we should impact at all? used by pellets.
 *
 * @return 0 to 100 % probability of hitting
 */
/mob/living/proc/process_baymiss(obj/projectile/proj, our_opinion = 100, impact_check = TRUE)
	our_opinion = clamp(our_opinion - get_evasion(), 5, INFINITY)
	return proj.process_accuracy(src, our_opinion, null, impact_check)

//* Throwing *//

/mob/living/throw_impacted(atom/movable/AM, datum/thrownthing/TT)
	. = ..()
	if(TT.throw_flags & THROW_AT_IS_GENTLE)
		return

	// - semi-legacy code; needs re-tuning
	if(isitem(AM))
		var/miss_chance = 5 + min(90, (TT.dist_travelled - 2 * 5))
		if(prob(miss_chance))
			AM.visible_message(
				SPAN_WARNING("[AM] misses [src] narrowly!"),
			)
			return COMPONENT_THROW_HIT_PIERCE | COMPONENT_THROW_HIT_NEVERMIND
	var/hit_zone = ran_zone(TT.target_zone || BP_TORSO, 75)
	// - end

	var/shieldcall_returns = atom_shieldcall_handle_throw_impact(
		TT,
		FALSE,
		NONE,
	)

	var/sc_pierce
	var/sc_block
	if(shieldcall_returns & SHIELDCALL_FLAGS_SHOULD_PROCESS)
		sc_block = shieldcall_returns & SHIELDCALL_FLAGS_BLOCK_ATTACK
		sc_pierce = shieldcall_returns & SHIELDCALL_FLAGS_PIERCE_ATTACK

	if(sc_block)
		return sc_pierce? COMPONENT_THROW_HIT_PIERCE | COMPONENT_THROW_HIT_NEVERMIND : NONE

	visible_message(
		SPAN_RED("[src] has been hit by [AM]."),
	)

	// - legacy code for reaction
	if(ismob(TT.thrower))
		ai_holder?.react_to_attack_polaris(TT.thrower)
	// - end

	// - legacy logging code; not amazing. all this should be replaced with logging module API calls.
	add_attack_logs(TT.thrower, src, "hit by thrown [AM.name] ([AM.type])")
	// - end

	// todo: /atom/movable/proc/throw_impact_attack(atom/target)
	if(isitem(AM))
		var/obj/item/I = AM

		inflict_atom_damage(
			I.throw_force * TT.get_damage_multiplier(src),
			I.damage_type,
			TT.get_damage_tier(src),
			I.damage_flag,
			I.damage_mode,
			hit_zone,
			ATTACK_TYPE_THROWN,
			TT,
		)
	else
		inflict_atom_damage(
			AM.throw_force * TT.get_damage_multiplier(src),
			DAMAGE_TYPE_BRUTE,
			TT.get_damage_tier(src),
			ARMOR_MELEE,
			NONE,
			hit_zone,
			ATTACK_TYPE_THROWN,
			TT,
		)

	// - semi-legacy: transfer momentum and stagger them if it's fast enough
	var/effective_mass = 1.5
	if(isitem(AM))
		var/obj/item/reading_item_for_mass = AM
		effective_mass = reading_item_for_mass.w_class / THROWNOBJ_KNOCKBACK_DIVISOR
	var/momentum_transfer_amount = effective_mass * TT.speed
	if(momentum_transfer_amount >= THROWNOBJ_KNOCKBACK_SPEED)
		var/dir = angle2dir(TT.get_current_angle())
		visible_message(
			SPAN_RED("[src] staggers under the impact!"),
			SPAN_RED("You stagger under the impact!"),
		)
		throw_at(get_edge_target_turf(src, dir), 1, momentum_transfer_amount / 3, THROW_AT_DO_NOT_SPIN)

	return sc_pierce? COMPONENT_THROW_HIT_PIERCE | COMPONENT_THROW_HIT_NEVERMIND : NONE

//* Misc Effects *//

/mob/living/electrocute_act(efficiency, energy, damage, stun_power, flags, hit_zone, atom/movable/source, list/shared_blackboard, out_energy_consumed)
	// todo: rework this maybe
	if((fire_stacks < 0) && !(flags & ELECTROCUTE_ACT_FLAG_INTERNAL))
		// water makes you more ocnductive
		efficiency *= 1.5
	return ..()

/mob/living/on_electrocute_act(efficiency, energy, damage, stun_power, flags, hit_zone, atom/movable/source, list/shared_blackboard)
	if(efficiency > 0)
		inflict_electrocute_damage(damage * efficiency, stun_power * efficiency, flags, hit_zone)
		if(!(flags & ELECTROCUTE_ACT_FLAG_SILENT))
			playsound(src, /datum/soundbyte/sparks, 50, TRUE, -1)
			if(damage * efficiency > 15)
				visible_message(
					SPAN_WARNING("[src] was electrocuted[source ? " by [source]" : ""]!"),
					SPAN_DANGER("You feel a powerful shock course through your body[source ? " as you make contact with [source]" : ""]!"),
					SPAN_WARNING("You hear a heavy electrical crack."),
				)
			else
				visible_message(
					SPAN_WARNING("[src] was shocked[source ? " by [source]" : ""]!"),
					SPAN_DANGER("You feel a shock course through your body[source ? " as you make contact with [source]" : ""]!"),
					SPAN_WARNING("You hear an electrical crack."),
				)
		if(!(flags & ELECTROCUTE_ACT_FLAG_CONTAINED))
			var/datum/effect_system/spark_spread/sparks = new /datum/effect_system/spark_spread
			sparks.set_up(5, 1, loc)
			sparks.start()
	return ..()

/**
 * Called to apply the damage from [electrocute_act()]
 */
/mob/living/proc/inflict_electrocute_damage(damage, stun_power, flags, hit_zone)
	return

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
