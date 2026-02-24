//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/component/directional_shield
	registered_type = /datum/comopnent/directional_shield

	var/active = TRUE
	var/dir = NORTH
	var/datum/directional_shield_pattern/pattern
	var/list/atom/movable/directional_shield/segments = list()
	/// called with (src, list/shieldcall_args)
	var/datum/callback/on_damage_instance

/datum/component/directional_shield/Initialize(datum/directional_shield_config/config, datum/callback/on_damage_instance)
	if(!ismovable(parent))
		return COMPONENT_INCOMPATIBLE
	. = ..()
	if(. == COMPONENT_INCOMPATIBLE)
		return
	if(config)
		set_config(config)
	src.on_damage_instance = on_damage_instance

/datum/component/directional_shield/RegisterWithParent()
	. = ..()
	#warn impl

/datum/component/directional_shield/UnregisterFromParent()
	. = ..()
	#warn impl

/datum/component/directional_shield/proc/set_config(datum/directional_shield_config/configlike)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(ispath(configlike) || IS_ANONYMOUS_TYPEPATH(configlike))
		configlike = new configlike
	set_from_config(configlike)

/datum/component/directional_shield/proc/set_from_config(datum/directional_shield_config/config)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	set_pattern(config.pattern)

/datum/component/directional_shield/proc/set_pattern(datum/directional_shield_pattern/pattern)
	if(active)
		destroy_segments()
	src.pattern = pattern
	if(active)
		make_segments()

/datum/component/directional_shield/proc/set_active(new_active)
	active = new_active
	if(active)
		make_segments()
	else
		destroy_segments()

/datum/component/directional_shield/proc/make_segments()
	var/list/tuples = pattern?.return_tiles()
	if(length(segments) > length(tuples))
		for(var/i in length(tuples) + 1 to length(segments))
			qdel(segments[i])
		segments.len = tuples.len
	var/turf/where = get_turf(parent)
	var/dir = src.dir
	var/angle = dir2angle(dir)
	if(active)
		for(var/i in 1 to length(segments))
			var/list/tuple = tuples[i]
			var/atom/movable/directional_shield/updating = segments[i]
			updating.north_facing_dir = tuple[3]
			updating.x_offset = tuple[1]
			updating.y_offset = tuple[2]
			updating.update_dir(where, dir, angle)
		for(var/i in length(segments) + 1 to length(tuples))
			var/list/tuple = tuples[i]
			var/atom/movable/directional_shield/created = new(null, src, tuple[1], tuple[2], tuple[3])
			segments += created
			created.update_dir(where, dir, angle)
	else
		for(var/i in 1 to length(segments))
			var/list/tuple = tuples[i]
			var/atom/movable/directional_shield/updating = segments[i]
			updating.north_facing_dir = tuple[3]
			updating.x_offset = tuple[1]
			updating.y_offset = tuple[2]
		for(var/i in length(segments) + 1 to length(tuples))
			var/list/tuple = tuples[i]
			var/atom/movable/directional_shield/created = new(null, src, tuple[1], tuple[2], tuple[3])
			segments += created

/datum/component/directional_shield/proc/destroy_segments()
	QDEL_LIST(segments)

/datum/component/directional_shield/proc/construct(atom/root = parent:loc)

/datum/component/directional_shield/proc/teardown(atom/root = parent:loc)

/datum/component/directional_shield/proc/update(atom/source, atom/oldloc)
	#warn impl all
	var/turf/where = get_turf(parent)
	if(active)
		for(var/atom/movable/directional_shield/shield as anything in segments)
			shield.update_pos(where)

/datum/component/directional_shield/proc/set_dir(dir, update)
	src.dir = dir
	var/turf/where = get_turf(parent)
	var/angle = dir2angle(dir)
	if(update && active)
		for(var/atom/movable/directional_shield/shield as anything in segments)
			shield.update_dir(where, dir, angle)

/datum/component/directional_shield/proc/on_damage_instance(atom/movable/directional_shield/segment, list/shieldcall_args)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	on_damage_instance?.invoke_no_sleep(src, shieldcall_args)

/**
 * * We will not automatically go down other than the 'disposable' and 'recharging' variants.
 */
/datum/component/directional_shield/standalone
	/// damage to absorb
	var/health = /datum/directional_shield_config::health
	var/health_max = /datum/directional_shield_config::health_max
	var/color_depleted = /datum/directional_shield_config::color_depleted
	var/color_full = /datum/directional_shield_config::color_full
	var/tmp/color
	/// called with (src)
	var/datum/callback/on_downed
	/// called with (src)
	var/datum/callback/on_restored

/datum/component/directional_shield/standalone/Initialize(datum/directional_shield_config/config, datum/callback/on_damage_instance, datum/callback/on_downed, datum/callback/on_restored)
	. = ..()
	if(. == COMPONENT_INCOMPATIBLE)
		return
	src.on_downed = on_downed
	src.on_restored = on_restored

/datum/component/directional_shield/standalone/on_damage_instance(atom/movable/directional_shield/segment, list/shieldcall_args)
	..()
	adjust_health(-shieldcall_args[SHIELDCALL_ARG_DAMAGE])

/datum/component/directional_shield/standalone/set_from_config(datum/directional_shield_config/config)
	..()
	if(health != config.health)
		health = config.health
	if(health_max != config.health_max)
		health_max = config.health_max
	if(color_depleted != color_depleted)
		color_depleted = config.color_depleted
	if(color_full != color_full)
		color_full = config.color_full

/**
 * Must be called to start initially.
 */
/datum/component/directional_shield/standalone/proc/start()
	// update color
	set_health(health)
	set_active(TRUE)

/datum/component/directional_shield/standalone/set_active(new_active)
	var/old_active = active
	..()
	if(old_active != active)
		if(active)
			on_restored()
		else
			on_downed()

/datum/component/directional_shield/standalone/make_segments()
	for(var/atom/movable/directional_shield/segment as anything in segments)
		segment.color = src.color

/datum/component/directional_shield/standalone/proc/set_color(color)
	for(var/atom/movable/directional_shield/segment as anything in segments)
		segment.color = color
	src.color = color

/datum/component/directional_shield/standalone/proc/set_health(amount, dont_restore)
	src.health = max(0, amount)
	set_color(gradient(color_depleted, color_full, clamp(amount / health_max, 0, 1)))

/datum/component/directional_shield/standalone/proc/adjust_health(amount, dont_restore)
	set_health(health + amount)

/datum/component/directional_shield/standalone/proc/on_downed()
	on_downed?.invoke_no_sleep(src)

/datum/component/directional_shield/standalone/proc/on_restored()
	on_restored?.invoke_no_sleep(src)

/datum/component/directional_shield/standalone/recharging
	/// delay before recharging
	var/recharge_delay = /datum/directional_shield_config::recharge_delay
	/// recharge speed hp/s
	var/recharge_rate = /datum/directional_shield_config::recharge_rate
	/// ignore recharge delay for DAMAGE_MODE_GRADUAL?
	var/recharge_ignore_gradual = /datum/directional_shield_config::recharge_ignore_gradual
	/// min damage to impact recharge
	var/recharge_ignore_threshold = /datum/directional_shield_config::recharge_ignore_threshold
	/// recharge speed when fully downed.
	/// * if set this is used if we're fully downed and we don't go back up
	///   until we're at a certain ratio of max health
	var/recharge_rebuild_rate = /datum/directional_shield_config::recharge_rebuild_rate
	/// when do we restore once rebuilding from downed?
	/// * we go back to normal [recharge_rate] when we become active again
	/// * if 0 we will never go down
	/// * 1 = restore when fully back up, 0.5 = when half up
	var/recharge_rebuild_restore_ratio = /datum/directional_shield_config::recharge_rebuild_restore_ratio
	/// last time we took damage
	var/last_damage
	/// last time we took damage because i literally just cannot stop overengineering everything
	var/last_recharge_tick

/datum/component/directional_shield/standalone/recharging/RegisterWithParent()
	..()
	// TODO: do we need higher resolution on this?
	START_PROCESSING(SSobj, src)

/datum/component/directional_shield/standalone/recharging/UnregisterFromParent()
	STOP_PROCESSING(SSobj, src)
	..()

/datum/component/directional_shield/standalone/recharging/set_from_config(datum/directional_shield_config/config)
	..()
	if(recharge_delay != config.recharge_delay)
		recharge_delay = config.recharge_delay
	if(recharge_rate != config.recharge_rate)
		recharge_rate = config.recharge_rate
	if(recharge_ignore_gradual != config.recharge_ignore_gradual)
		recharge_ignore_gradual = config.recharge_ignore_gradual
	if(recharge_rebuild_rate != config.recharge_rebuild_rate)
		recharge_rebuild_rate = config.recharge_rebuild_rate
	if(recharge_rebuild_restore_ratio != config.recharge_rebuild_restore_ratio)
		recharge_rebuild_restore_ratio = config.recharge_rebuild_restore_ratio
	if(recharge_ignore_threshold != config.recharge_ignore_threshold)
		recharge_ignore_threshold = config.recharge_ignore_threshold

/datum/component/directional_shield/standalone/recharging/set_health(amount, dont_restore)
	..()
	if(health <= 0 && recharge_rebuild_restore_ratio > 0)
		set_active(FALSE)

/datum/component/directional_shield/standalone/recharging/on_damage_instance(atom/movable/directional_shield/segment, list/shieldcall_args)
	..()
	if(shieldcall_args[SHIELDCALL_ARG_DAMAGE] <= recharge_ignore_threshold)
		return
	if(recharge_ignore_gradual && (shieldcall_args[SHIELDCALL_ARG_DAMAGE_MODE] & DAMAGE_MODE_GRADUAL))
		return
	process_recharge()
	last_damage = world.time

/datum/component/directional_shield/standalone/recharging/process(dt)
	process_recharge()

/datum/component/directional_shield/standalone/recharging/proc/process_recharge()
	var/elapsed = max(last_damage + recharge_delay, world.time) - last_recharge_tick
	if(elapsed <= 0)
		return
	last_recharge_tick = world.time
	// the only tick timing inaccuracy in this entire overengineered
	// pile of science coder insanity is this; we process before rebuild,
	// so you can gain some extra health from this
	var/recharged = elapsed * (active ? recharge_rebuild_rate : recharge_rate)
	set_health(recharged, TRUE)
	if(health / health_max >= recharge_rebuild_restore_ratio)
		set_active(TRUE)

/**
 * Qdels self on destroyed.
 */
/datum/component/directional_shield/standalone/disposable

/datum/component/directional_shield/standalone/disposable/set_health()
	..()
	if(health <= 0)
		set_active(FALSE)

/datum/component/directional_shield/standalone/disposable/on_downed()
	..()
	if(!QDELETED(src))
		qdel(src)
