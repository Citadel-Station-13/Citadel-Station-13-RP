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
	src.pattern = config?.pattern
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
	#warn impl

/datum/component/directional_shield/proc/destroy_segments()
	QDEL_LIST(segments)

/datum/component/directional_shield/proc/construct(atom/root = parent:loc)

/datum/component/directional_shield/proc/teardown(atom/root = parent:loc)

/datum/component/directional_shield/proc/update(atom/source, atom/oldloc)

/datum/component/directional_shield/proc/set_dir(dir, update)
	src.dir = dir
	if(update)
		for(var/atom/movable/directional_shield/shield as anything in segments)
			shield.update_pos()

#warn impl

/datum/component/directional_shield/proc/on_damage_instance(list/shieldcall_args)
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

/datum/component/directional_shield/standalone/on_damage_instance(list/shieldcall_args)
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
	set_active(TRUE)

/datum/component/directional_shield/standalone/set_active(new_active)
	var/old_active = active
	..()
	if(old_active != active)
		if(active)
			on_restored()
		else
			on_downed()

/datum/component/directional_shield/standalone/proc/set_health(amount, dont_restore)
	src.health = max(0, amount)
	#warn color

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
	/// recharge speed when fully downed.
	/// * if set this is used if we're fully downed and we don't go back up
	///   until we're at a certain ratio of max health
	var/recharge_rebuild_rate = /datum/directional_shield_config::recharge_rebuild_rate
	/// when do we restore once rebuilding from downed?
	/// * we go back to normal [recharge_rate] when we become active again
	/// * 1 = restore when fully back up, 0.5 = when half up, 0 = immediately (don't use rebuild rate)
	var/recharge_rebuild_restore_ratio = /datum/directional_shield_config::recharge_rebuild_restore_ratio
	/// last time we took damage
	var/last_damage

/datum/component/directional_shield/standalone/recharging/Initialize(datum/directional_shield_config/config, datum/callback/on_damage_instance, datum/callback/on_downed, datum/callback/on_restored)
	. = ..()
	if(. == COMPONENT_INCOMPATIBLE)
		return
	#warn impl

/datum/component/directional_shield/standalone/recharging/RegisterWithParent()
	..()
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

/datum/component/directional_shield/standalone/recharging/on_damage_instance(list/shieldcall_args)
	..()
	#warn recharge logic

/datum/component/directional_shield/standalone/recharging/process()
	#warn impl

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
