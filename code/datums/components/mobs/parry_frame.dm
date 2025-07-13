//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * ## Active Parry
 *
 * Datastructure for active parry on mobs.
 *
 * * One, or more, may exist at a time; all of them will be shieldcall-registered, be very careful when doing this.
 * * Items should generally not allow adding another parry frame while one is active
 */
/datum/component/parry_frame
	registered_type = /datum/component/parry_frame

	/// active defensive data
	var/datum/parry_frame/active_parry
	/// current number of processed hits
	var/hit_count = 0
	/// world.time of start
	var/start_time
	/// world time of drop
	var/drop_time
	/// registered shieldcall
	var/datum/shieldcall/bound/parry_frame/shieldcall

/**
 * * frame - the parry frame
 * * kick_time_forwards - start this many deciseconds into the frame.
 */
/datum/component/parry_frame/Initialize(datum/parry_frame/frame, kick_time_forwards)
	if(!ismovable(parent))
		return COMPONENT_INCOMPATIBLE
	. = ..()
	if(. == COMPONENT_INCOMPATIBLE)
		return
	src.active_parry = frame
	src.start_time = world.time - kick_time_forwards
	src.drop_time = src.start_time + max(frame.parry_timing_active, frame.parry_timing_perfect) + frame.parry_timing_stop
	if(src.drop_time < world.time)
		. = COMPONENT_INCOMPATIBLE
		CRASH("attempted to start a parry that ended in the past.")
	shieldcall = new(src)
	shieldcall.tool_text = parent
	var/delete_in = src.drop_time - world.time
	QDEL_IN(src, delete_in)
	// this is non-transferable, duh
	new frame.parry_vfx(null, parent, frame)

/datum/component/parry_frame/Destroy()
	. = ..()
	// shieldcall must be deleted after unregister
	QDEL_NULL(shieldcall)

/datum/component/parry_frame/RegisterWithParent()
	var/atom/movable/AM = parent
	AM.register_shieldcall(shieldcall)

/datum/component/parry_frame/UnregisterFromParent()
	var/atom/movable/AM = parent
	AM.unregister_shieldcall(shieldcall)

/datum/component/parry_frame/proc/on_parry(attack_type, datum/attack_source, shieldcall_returns, efficiency)
	++hit_count
	// check drop
	if(hit_count > active_parry.parry_drop_after_hits)
		qdel(src)
		return

//* -- Shieldcall -- *//

/**
 * Shieldcall used as a listener for [/datum/component/parry_frame]
 */
/datum/shieldcall/bound/parry_frame
	expected_type = /datum/component/parry_frame

	/// text to describe the used tool, if any
	var/tool_text

//* -- Parry Frame -- *//

/**
 * Datastructure for parry data, now far more simplified.
 *
 * * Please avoid anonymous typing this where possible, this is a heavy datum and caching helps a lot.
 * * While this is very close to /datum/block_frame, it is different in separate major ways.
 * * Parrying tends to be more powerful and complex, as it's meant to simulate a very dynamic action.
 * * Parrying is more expensive to deal with than blocking.
 *
 * todo: this should be a serializable prototype
 * todo: estimated_severity for audiovisuals needs a revisit; sound is not linear.
 */
/datum/parry_frame
	//* Arc *//
	/// shield arc, in both CW/CCW from user facing direction
	///
	/// * given RP doesn't have combat mode, you should really just keep this at 180
	/// * realistically the cutoffs are 45, 90, 135, and 180 for anything that's not a projectile as only those sim physics
	var/parry_arc = 180
	/// should we round parry arc down for non-projectiles?
	///
	/// * this means 179 can't cover behind us
	/// * this is needed because non-projectiles don't have exact angles
	var/parry_arc_round_down = TRUE

	//* Timing *//
	/// spinup time
	///
	/// * keep this at 0 in most cases
	/// * the parry does nothing while it's spinning up
	/// * parries landing on the tick this ends count as having spun up
	/// * overrules both perfect and active timing
	var/parry_timing_start = 0 SECONDS
	/// perfect time
	///
	/// * this is the amount of time we are a perfect parry after tick 0
	/// * this means that this overlaps with [parry_timing_start]!
	/// * this is done for performance reasons.
	/// * parries landing on the tick this ends still count as perfect
	/// * overrules active timing
	/// * overruled by start timing
	var/parry_timing_perfect = 0 SECONDS
	/// no-falloff time
	///
	/// * this is the amount of time we are at full [parry_efficiency_active] after tick 0
	/// * this means that this overlaps with both [parry_timing_start] and [parry_timing_perfect].
	/// * this is done for performance reasons.
	/// * parries landing on the tick this ends still count as fully active
	/// * overruled by start and perfect timing
	var/parry_timing_active = 0 SECONDS
	/// end time
	///
	/// * this is the amount of time we are still active after [parry_timing_active] or [parry_timing_perfect], whatever is longer
	/// * efficiency linearly drops from active efficiency to 0 during this time
	/// * the parry immediately drops after
	/// * parries landing on the tick this ends are dropped
	var/parry_timing_stop = 0 SECONDS

	//* Attack Types *//
	/// attack types we are allowed to parry
	var/parry_attack_types = NONE

	//* Efficiency *//
	/// parry efficiency at perfect; [0, 1]
	///
	/// * parry efficiency is ratio of damage to block
	var/parry_efficiency_perfect = 1
	/// parry efficiency at active; [0, 1]
	///
	/// * parry efficiency is ratio of damage to block
	var/parry_efficiency_active = 1
	/// minimum efficiency to drop to
	var/parry_efficiency_floor = 0
	/// parry efficiency at which we count as a full block
	var/parry_efficiency_blocked = 1
	/// parry efficiency at which redirection occurs
	var/parry_efficiency_redirection = 1

	//* Defender Effects *//
	/// action-lock the defender while parrying
	//  todo: implement
	var/parry_lock_defender = TRUE
	/// drop action-lock on defender when a parry succeeds
	//  todo: implement
	var/parry_free_defender_on_success = TRUE

	//* Configuration *//
	/// immediately drop the parry after this many hits
	var/parry_drop_after_hits = 1

	//* Counter Effects *//
	/// counterattack on hit
	///
	/// * keep this off, this is a good exercise in 'just because you can doesn't mean you should'
	//  todo: implement
	var/parry_counter_attack = FALSE
	/// status effects to apply on hit to attacker
	///
	/// supports:
	/// * /datum/status_effect status effects; associate to duration
	///
	/// does not support:
	/// * any status effect supertype that isn't listed above. right now, that's grouped and stacking.
	var/list/parry_counter_effects

	//* Counter Effects - Projectiles / Vector *//
	/// default handling: reflect attack types
	///
	/// * yeah you probably shouldn't put anything other than ATTACK_TYPE_PROJECTILE in here.
	var/parry_redirect_attack_types = NONE
	/// default handling: reflect attack back at attacker
	///
	/// * yeah you probably should leave this off
	var/parry_redirect_return_to_sender = FALSE
	/// redirection arc CW/CCW of angle of incidence
	///
	/// * if return_to_sender is off, this is the valid arc from attack source it can be reflected to
	/// * if return_to_sender is on, this is the arc in error from attack source we can reflect to
	var/parry_redirect_arc = 45

	//* Defense - Damage *//
	/// if 100% of damage is blocked, do we set SHIELDCALL_BLOCKED and similar flags?
	///
	/// * this means things like syringes would be blocked from injecting.
	var/parry_can_prevent_contact = FALSE
	/// always add BLOCKED, even if not 100% mitigated / transmuted
	var/parry_always_prevents_contact = FALSE
	/// maximum damage blocked per attack instance
	//  todo: implement
	var/parry_damage_max = INFINITY

	//* Defense - Transmute *//
	//  todo: implement
	/// ratio [0, INFINITY] of **blocked** damage to convert to another type
	var/parry_transmute = 0
	/// damage type to transmute to; null to default to attacking damage type
	var/parry_transmute_type = null
	/// damage tier used for transmuted damage; null to default to attacking tier
	var/parry_transmute_tier = null
	/// damage mode used for transmuted damage; null to default to attacking mode
	var/parry_transmute_mode = null
	/// damage flag the transmuted damage counts as; null = inherit from attack
	var/parry_transmute_flag = null
	/// the transmuted damage should be simulated as close to a proper melee hit as possible,
	/// instead of just going through run_damage_instance()
	///
	/// * DO NOT TURN THIS ON WITHOUT GOOD REASON. Melee sim is several times more expensive than armor / low-level intercepts for damage instances.
	/// * Currently does nothing, as we do not have a way to simulate a standard melee hit arbitrarily without side effects.
	var/parry_transmute_simulation = FALSE

	//* Defender Cooldown *//
	/// hard cooldown to apply to parrying with the thing parrying wth
	//  todo: implement
	var/parry_cooldown_tool = 2 SECONDS
	/// hard cooldown to apply to parrying at all as the mob
	//  todo: implement
	var/parry_cooldown_user = 0 SECONDS
	/// is the parry cooldown ignored if a successful parry was made
	//  todo: implement
	var/parry_cooldown_on_success = FALSE

	//* Audiovisuals & Feedback *//
	/// a sound, or a list of sounds that can be played when we're hit
	/// list can be weighted by associated number for relative chance
	///
	/// * sound can be a file
	/// * sound can be a /datum/soundbyte typepath or instance
	var/list/parry_sfx = /datum/soundbyte/grouped/metal_parry
	/// a typepath of /atom/movable/parry_frame to use as our visual; this is placed in the defending atom's vis_contents
	var/parry_vfx = /atom/movable/render/parry_frame/default
	/// "[person] [start_verb] with [item]"
	//  todo: implement
	var/start_verb = "shifts into a defensive stance"
	/// "[person] [block_verb] [attack_source_descriptor] with [item]"
	var/block_verb = "parries"
	/// "[person] [deflect_verb] [attack_source_descriptor] with [item]"
	///
	/// * used if an attack was redirected and not just blocked
	var/deflect_verb = "deflects"

/**
 * * 0 if in spinup
 * * perfect efficiency if in perfect (from 0)
 * * active efficiency if in active (from 0)
 * * linear falloff to 0 if in spindown (from active time end)
 */
/datum/parry_frame/proc/calculate_parry_efficiency(time_into_parry)
	if(time_into_parry < parry_timing_start)
		return 0
	if(time_into_parry <= parry_timing_perfect)
		return parry_timing_perfect
	if(time_into_parry <= parry_timing_active)
		return parry_timing_active
	var/drop_time = parry_timing_active + parry_timing_stop
	if(time_into_parry >= drop_time)
		return 0
	var/time_into_drop = time_into_parry - parry_timing_active
	return parry_efficiency_active - (parry_efficiency_active - parry_efficiency_floor) * ((time_into_drop) / parry_timing_stop)

/**
 * @params
 * * time_into_parry - ds elapsed since parry start
 *
 * @return TRUE / FALSE
 */
/datum/parry_frame/proc/is_parry_perfect(time_into_parry)
	return (time_into_parry >= parry_timing_start) && (time_into_parry <= parry_timing_perfect)

/**
 * Called when parrying something
 *
 * @params
 * * defending - thing being defended against an attack
 * * attack_type - (optional) type of attack
 * * efficiency - (optional) parry efficiency
 * * weapon - (optional) incoming weapon, depends on ATTACK_TYPE
 * * shieldcall_flags - (optional) the attack's shieldcall flags
 * * severity - (optional) arbitrary 0 to 100 severity of how bad the hit is estimated to be
 * * attack_source_descriptor - (optional) text, or an entity to describe the attack. entities will be automatically handled.
 * * tool_text - (optional) text to describe the parry tool
 */
/datum/parry_frame/proc/perform_audiovisuals(atom/defending, attack_type, efficiency, datum/attack_source, shieldcall_flags, severity = 75, attack_source_descriptor, tool_text)
	playsound(defending, (islist(parry_sfx) && length(parry_sfx)) ? pick(parry_sfx) : parry_sfx , severity, TRUE)
	new parry_vfx(null, defending, src, shieldcall_flags & SHIELDCALL_FLAG_SINGLE_PARRY)

	var/parry_verb
	if((attack_type & parry_redirect_attack_types) && (efficiency >= parry_efficiency_redirection))
		parry_verb = deflect_verb
	else
		parry_verb = block_verb

	var/attack_descriptor = "the attack"
	if(attack_source_descriptor)
		// generic processing
		attack_descriptor = "\the [attack_source_descriptor]"
		// item processing
		if(isitem(attack_source_descriptor))
			var/obj/item/item_source_descriptor = attack_source_descriptor
			var/mob/mob_holding_item = item_source_descriptor.get_worn_mob()
			if(mob_holding_item)
				attack_descriptor = "[mob_holding_item]'s [item_source_descriptor]"

	defending.visible_message(
		SPAN_DANGER("[defending] [parry_verb] [attack_descriptor][tool_text && " with \the [tool_text]"]!"),
	)

/**
 * Called when something is parried
 *
 * @params
 * * defending - thing being defended against an attack
 * * attack_type - (optional) type of attack
 * * efficiency - (optional) parry efficiency
 * * attack_source - (optional) incoming weapon, depends on ATTACK_TYPE
 * * shieldcall_flags - (optional) the attack's shieldcall flags
 *
 * @return SHIELDCALL_* flags; these override the caller's!
 */
/datum/parry_frame/proc/perform_aftereffects(atom/defending, attack_type, efficiency, datum/attack_source, shieldcall_flags)
	. = shieldcall_flags

	var/atom/movable/aggressor

	// detect aggressor
	if(istype(attack_source, /obj/projectile))
		var/obj/projectile/weapon_proj = attack_source
		aggressor = weapon_proj.firer
	else if(istype(attack_source, /datum/event_args/actor/clickchain))
		var/datum/event_args/actor/clickchain/weapon_clickchain = attack_source
		aggressor = weapon_clickchain.performer
	else if(istype(attack_source, /datum/thrownthing))
		var/datum/thrownthing/weapon_thrown = attack_source
		aggressor = weapon_thrown.thrower

	switch(attack_type)
		if(ATTACK_TYPE_PROJECTILE)
			var/obj/projectile/proj = attack_source
			if((parry_redirect_attack_types & ATTACK_TYPE_PROJECTILE) && (efficiency >= parry_efficiency_redirection))
				var/outgoing_angle
				if(parry_redirect_return_to_sender && aggressor)
					outgoing_angle = arctan(aggressor.y - defending.y, aggressor.x - defending.x)
				else
					// todo: this should be angle of incidence maybe?
					outgoing_angle = turn(proj.angle, 180) + rand(-parry_redirect_arc, parry_redirect_arc)
				proj.set_angle(outgoing_angle)
				. |= SHIELDCALL_FLAG_ATTACK_REDIRECT

	// effects that are only valid if we have a retaliation target
	if(aggressor)
		if(ismob(aggressor))
			var/mob/aggressor_mob = aggressor
			for(var/key in parry_counter_effects)
				var/value = parry_counter_effects[key]
				if(ispath(key, /datum/status_effect))
					aggressor_mob.apply_status_effect(key, value)

		if(parry_counter_attack)
			// RIP AND TEAR
			// todo: counterattacks are offline due to clickchain not being entirely nailed down
			//       we need clickchain flags to be actually checked in active block/parry so that REFLEX_COUNTER flagged clicks don't get re-parried.
			pass()

/**
 * Called to transmute an instance of damage into another instance of damage and apply it to the defender.
 */
/datum/parry_frame/proc/perform_transmuted_damage(atom/defending, damage, damage_tier, damage_type, damage_mode, damage_flag, hit_zone, shieldcall_flags)
	// todo: parry_transmute_simulation
	defending.run_damage_instance(
		parry_transmute * damage,
		isnull(parry_transmute_type) ? damage_type : parry_transmute_type,
		isnull(parry_transmute_tier) ? damage_tier : parry_transmute_tier,
		isnull(parry_transmute_flag) ? damage_flag : parry_transmute_flag,
		isnull(parry_transmute_mode) ? damage_mode : parry_transmute_mode,
		ATTACK_TYPE_DEFENSIVE_PASSTHROUGH,
		null,
		SHIELDCALL_FLAG_SECOND_CALL,
		hit_zone,
	)

//* Bindings - Bullet *//

/datum/shieldcall/bound/parry_frame/handle_bullet(atom/defending, shieldcall_returns, fake_attack, list/bullet_act_args)
	var/datum/component/parry_frame/frame = bound
	if(!(frame.active_parry.parry_attack_types & ATTACK_TYPE_PROJECTILE))
		return
	if(!check_defensive_arc_tile(defending, bullet_act_args[BULLET_ACT_ARG_PROJECTILE], frame.active_parry.parry_arc, !frame.active_parry.parry_arc_round_down))
		return
	var/efficiency = frame.active_parry.calculate_parry_efficiency(frame.start_time - world.time)
	. = frame.active_parry.handle_bullet(defending, shieldcall_returns, fake_attack, efficiency, bullet_act_args, tool_text)
	frame.on_parry(ATTACK_TYPE_PROJECTILE, bullet_act_args[BULLET_ACT_ARG_PROJECTILE], ., efficiency)

/datum/parry_frame/proc/handle_bullet(atom/defending, shieldcall_returns, fake_attack, efficiency, list/bullet_act_args, tool_text)
	. = shieldcall_returns
	// todo: doesn't take into account any damage randomization
	var/obj/projectile/proj = bullet_act_args[BULLET_ACT_ARG_PROJECTILE]
	var/estimated_severity = clamp(proj.damage_force / 20 * 75, 0, 100)
	bullet_act_args[BULLET_ACT_ARG_EFFICIENCY] = bullet_act_args[BULLET_ACT_ARG_EFFICIENCY] * clamp(1 - efficiency, 0, 1)
	. = perform_aftereffects(defending, ATTACK_TYPE_PROJECTILE, efficiency, proj, .)
	perform_audiovisuals(defending, ATTACK_TYPE_PROJECTILE, efficiency, proj, ., estimated_severity, proj, tool_text)
	if(. & (SHIELDCALL_FLAG_ATTACK_PASSTHROUGH | SHIELDCALL_FLAG_ATTACK_REDIRECT))
		bullet_act_args[BULLET_ACT_ARG_FLAGS] |= PROJECTILE_IMPACT_REFLECT
	if(parry_always_prevents_contact || (parry_can_prevent_contact && (efficiency >= parry_efficiency_blocked)))
		bullet_act_args[BULLET_ACT_ARG_FLAGS] |= PROJECTILE_IMPACT_BLOCKED

//* Bindings - Melee *//

/datum/shieldcall/bound/parry_frame/handle_melee(atom/defending, shieldcall_returns, fake_attack, datum/event_args/actor/clickchain/clickchain, clickchain_flags, obj/item/weapon, datum/melee_attack/weapon/style)
	var/datum/component/parry_frame/frame = bound
	if(!(frame.active_parry.parry_attack_types & ATTACK_TYPE_MELEE))
		return
	if(clickchain && !check_defensive_arc_tile(defending, clickchain.performer, frame.active_parry.parry_arc, !frame.active_parry.parry_arc_round_down))
		return
	var/efficiency = frame.active_parry.calculate_parry_efficiency(frame.start_time - world.time)
	. = frame.active_parry.handle_melee(defending, shieldcall_returns, fake_attack, efficiency, clickchain, style, weapon, tool_text)
	frame.on_parry(ATTACK_TYPE_MELEE, clickchain, ., efficiency)

// todo: reconcile with shieldcall args
/datum/parry_frame/proc/handle_melee(atom/defending, shieldcall_returns, fake_attack, efficiency, datum/event_args/actor/clickchain/clickchain, datum/melee_attack/style, obj/item/weapon, tool_text)
	. = shieldcall_returns
	// todo: doesn't take into account any damage randomization
	var/estimated_damage = style.estimate_damage(weapon)
	var/estimated_severity = clamp(estimated_damage * clickchain.attack_melee_multiplier / 20 * 75, 0, 100)
	var/contact_penalty = clamp(1 - efficiency, 0, 1)
	clickchain.attack_melee_multiplier *= contact_penalty
	clickchain.attack_contact_multiplier *= contact_penalty
	. = perform_aftereffects(defending, ATTACK_TYPE_MELEE, efficiency, clickchain, .)
	perform_audiovisuals(defending, ATTACK_TYPE_MELEE, efficiency, clickchain, ., estimated_severity, weapon, tool_text)
	if(parry_always_prevents_contact || (parry_can_prevent_contact && (efficiency >= parry_efficiency_blocked)))
		. |= SHIELDCALL_FLAG_ATTACK_BLOCKED

/datum/shieldcall/bound/parry_frame/handle_touch(atom/defending, shieldcall_returns, fake_attack, datum/event_args/actor/clickchain/clickchain, clickchain_flags, contact_flags, contact_specific)
	var/datum/component/parry_frame/frame = bound
	if(!(frame.active_parry.parry_attack_types & ATTACK_TYPE_TOUCH))
		return
	if(clickchain && !check_defensive_arc_tile(defending, clickchain.performer, frame.active_parry.parry_arc, !frame.active_parry.parry_arc_round_down))
		return
	var/efficiency = frame.active_parry.calculate_parry_efficiency(frame.start_time - world.time)
	. = frame.active_parry.handle_touch(defending, shieldcall_returns, fake_attack, efficiency, clickchain, contact_flags, contact_specific, tool_text)
	frame.on_parry(ATTACK_TYPE_TOUCH, null, ., efficiency)

// todo: reconcile with shieldcall args
/datum/parry_frame/proc/handle_touch(atom/defending, shieldcall_returns, fake_attack, efficiency, datum/event_args/actor/clickchain/clickchain, contact_flags, contact_specific, tool_text)
	. = shieldcall_returns
	// todo: doesn't take into account any damage randomization
	var/estimated_severity = 50
	var/contact_penalty = clamp(1 - efficiency, 0, 1)
	clickchain.attack_melee_multiplier *= contact_penalty
	clickchain.attack_contact_multiplier *= contact_penalty
	. = perform_aftereffects(defending, ATTACK_TYPE_TOUCH, efficiency, null, ., clickchain)
	perform_audiovisuals(defending, ATTACK_TYPE_TOUCH, efficiency, null, ., estimated_severity, clickchain.performer, tool_text)
	if(parry_always_prevents_contact || (parry_can_prevent_contact && (efficiency >= parry_efficiency_blocked)))
		. |= SHIELDCALL_FLAG_ATTACK_BLOCKED

//* Bindings - Thrown *//

/datum/shieldcall/bound/parry_frame/handle_throw_impact(atom/defending, shieldcall_returns, fake_attack, datum/thrownthing/thrown)
	var/datum/component/parry_frame/frame = bound
	if(!(frame.active_parry.parry_attack_types & ATTACK_TYPE_THROWN))
		return
	if(!check_defensive_arc_tile(defending, thrown, frame.active_parry.parry_arc, !frame.active_parry.parry_arc_round_down))
		return
	var/efficiency = frame.active_parry.calculate_parry_efficiency(frame.start_time - world.time)
	. = frame.active_parry.handle_throw_impact(defending, shieldcall_returns, fake_attack, efficiency, thrown, tool_text)
	frame.on_parry(ATTACK_TYPE_THROWN, thrown, ., efficiency)

// todo: reconcile with shieldcall args
/datum/parry_frame/proc/handle_throw_impact(atom/defending, shieldcall_returns, fake_attack, efficiency, datum/thrownthing/thrown, tool_text)
	. = shieldcall_returns
	// todo: doesn't take into account any damage randomization
	// todo: why isn't thrownthing just with a get_damage() or a better inflict_damage() and get_damage_tuple() idfk man
	var/estimated_severity = clamp(thrown.thrownthing.throw_force * thrown.get_damage_multiplier() / 20 * 75, 0, 100)
	thrown.damage_multiplier *= clamp(1 - efficiency, 0, 1)
	. = perform_aftereffects(defending, ATTACK_TYPE_THROWN, efficiency, thrown, ., thrown.thrownthing, tool_text)
	perform_audiovisuals(defending, ATTACK_TYPE_THROWN, efficiency, thrown, ., estimated_severity)
	if(parry_always_prevents_contact || (parry_can_prevent_contact && (efficiency >= parry_efficiency_blocked)))
		. |= SHIELDCALL_FLAG_ATTACK_BLOCKED

//* -- VFX Render -- *//

INITIALIZE_IMMEDIATE(/atom/movable/render/parry_frame)
/**
 * A visualizer for a parry frame.
 */
/atom/movable/render/parry_frame
	var/atom/movable/bound
	/// set this in your custom procs for cycle and single/spinup/spindown
	var/qdel_time = 1 SECONDS

/atom/movable/render/parry_frame/Initialize(mapload, atom/movable/bind_to, datum/parry_frame/frame, single_deflect)
	SHOULD_CALL_PARENT(FALSE)
	if(!istype(frame))
		. = INITIALIZE_HINT_QDEL
		CRASH("no valid frame, this is bad")
	src.bound = bind_to
	bind_to.vis_contents += src
	cycle(frame, single_deflect)
	QDEL_IN(src, qdel_time)
	return INITIALIZE_HINT_NORMAL

/atom/movable/render/parry_frame/Destroy()
	bound.vis_contents -= src
	bound = null
	return ..()

/atom/movable/render/parry_frame/proc/cycle(datum/parry_frame/frame, single_deflect)
	if(single_deflect)
		single()
		return
	spinup(frame.parry_timing_start)
	addtimer(CALLBACK(src, PROC_REF(spindown), frame.parry_timing_stop), max(frame.parry_timing_active, frame.parry_timing_perfect))

/atom/movable/render/parry_frame/proc/single()
	return

/atom/movable/render/parry_frame/proc/spinup(start_time)
	return

/atom/movable/render/parry_frame/proc/spindown(stop_time)
	return

//* -- VFX Default -- *//

/atom/movable/render/parry_frame/default
	icon = 'icons/effects/defensive/main_parry.dmi'
	icon_state = "hold"

/atom/movable/render/parry_frame/default/single()
	animate(src, time = 0.3 SECONDS, alpha = 0)
	qdel_time = 0.3 SECONDS
