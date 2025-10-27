//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/component/directional_shield
	registered_type = /datum/comopnent/directional_shield

	var/active = TRUE
	var/dir = NORTH
	var/list/atom/movable/directional_shield/segments = list()
	/// called with (src, list/shieldcall_args)
	var/datum/callback/on_damage_instance

/datum/component/directional_shield/Initialize()

#warn impl all

/datum/component/directional_shield/RegisterWithParent()
	. = ..()


/datum/component/directional_shield/UnregisterFromParent()
	. = ..()

/**
 * * Accepts instance or typepath or anonymous type
 */
/datum/component/directional_shield/proc/set_pattern(datum/directional_shield_pattern/patternlike)

/datum/component/directional_shield/proc/set_active(new_active)

/datum/component/directional_shield/proc/make_segments()

/datum/component/directional_shield/proc/destroy_segments()

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

/datum/component/directional_shield/standalone
	/// damage to absorb
	var/health = 200
	var/health_max = 200
	var/color_depleted = "#770000"
	var/color_full = "#33cccc"
	/// called with (src)
	var/datum/callback/on_downed
	/// called with (src)
	var/datum/callback/on_restored

/datum/component/directional_shield/standalone/Initialize()
	. = ..()
	if(. == COMPONENT_INCOMPATIBLE)
		return

/**
 * Must be called to start initially.
 */
/datum/component/directional_shield/standalone/proc/start()

/**
 * * Will restore this if inactive.
 */
/datum/component/directional_shield/standalone/proc/set_health()

/datum/component/directional_shield/standalone/proc/on_downed()

/datum/component/directional_shield/standalone/proc/on_restored()


/datum/component/directional_shield/standalone/recharging
	/// delay before recharging
	var/recharge_delay = 5 SECONDS
	/// recharge speed hp/s
	var/recharge_rate = 10
	/// ignore recharge delay for DAMAGE_MODE_GRADUAL?
	var/recharge_ignore_gradual = TRUE
	/// recharge speed when fully downed.
	/// * if set this is used if we're fully downed and we don't go back up
	///   until we're at a certain ratio of max health
	var/recharge_rebuild_rate = 20
	/// when do we restore once rebuilding from downed?
	/// * we go back to normal [recharge_rate] when we become active again
	/// * 1 = restore when fully back up, 0.5 = when half up, 0 = immediately (don't use rebuild rate)
	var/recharge_rebuild_restore_ratio = 1

/datum/component/directional_shield/standalone/recharging/Initialize()

/**
 * Qdels self on destroyed.
 */
/datum/component/directional_shield/standalone/disposable


/atom/movable/directional_shield
	name = "energy shield"
	desc = "A directional shield used to block hyperkinetic projectiles, amongst other things."
	#warn sprites

	atom_flags = ATOM_NONWORLD
	density = FALSE
	opacity = FALSE
	anchored = FALSE
	integrity_flags = INTEGRITY_ACIDPROOF | INTEGRITY_FIREPROOF | INTEGRITY_LAVAPROOF
	#warn plane / layer

	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

	var/datum/component/directional_shield/owning_component
	var/x_offset = 0
	var/y_offset = 0
	var/north_facing_dir

	var/tmp/oriented_x_offset
	var/tmp/oriented_y_offset
	var/tmp/oriented_dir

/atom/movable/directional_shield/Initialize(datum/component/directional_shield/comp, x_o, y_o, dir)
	. = ..()
	owning_component = comp
	owning_component.segments += src
	x_offset = x_o
	y_offset = y_o
	setDir(dir)

/atom/movable/directional_shield/Destroy()
	owning_component.segments -= src
	owning_component = null
	return ..()

/atom/movable/directional_shield/proc/update_pos()

#warn impl

/atom/movable/directional_shield/CanPass(atom/movable/mover, turf/target)
	. = ..()
	#warn projectile handling

/atom/movable/directional_shield/on_bullet_act(obj/projectile/proj, impact_flags, list/bullet_act_args)
	// no please go ahead, do hit us even if you want to pierce!
	impact_flags &= ~PROJECTILE_IMPACT_FLAGS_SHOULD_NOT_HIT
	return ..()

/atom/movable/directional_shield/inflict_damage_instance(SHIELDCALL_PROC_HEADER)
	#warn impl

/atom/movable/directional_shield/is_melee_targetable(datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	return FALSE

/datum/directional_shield_pattern
	/// expensive. do we need to directionally orient on changing dirs?
	var/directional = FALSE

/**
 * * returned perspective should be NORTH.
 * @return list(list(x_o, y_o, dir), ...)
 */
/datum/directional_shield_pattern/proc/return_tiles() as /list
	return list()

/datum/directional_shield_pattern/linear
	directional = TRUE
	/// distance from entity; 0 is ontop.
	var/distance = 2
	/// length = halflength * 2 + 1
	var/halflength = 2

/datum/directional_shield_pattern/linear/return_tiles()
	if(halflength < 0)
		return list()
	var/list/tiles = list()
	tiles[++tiles.len] = list(
		0,
		distance,
		NORTH,
	)
	for(var/x in 1 to halflength - 1)
		tiles[++tiles.len] = list(
			x,
			distance,
			NORTH,
		)
		tiles[++tiles.len] = list(
			-x,
			distance,
			NORTH,
		)
	if(halflength > 0)
		tiles[++tiles.len] = list(
			halflength,
			distance,
			NORTHEAST,
		)
		tiles[++tiles.len] = list(
			-halflength,
			distance,
			NORTHWEST,
		)

/datum/directional_shield_pattern/square
	/// distance from entity; 2 is 5x5 with 3x3 inner, 1 is 3x3 with 1x1 inner.
	var/radius = 2

/datum/directional_shield_pattern/square/return_tiles()
	if(radius <= 0)
		return list()
	var/list/tiles = list()
	tiles[++tiles.len] = list(
		radius,
		radius,
		NORTHEAST,
	)
	tiles[++tiles.len] = list(
		radius,
		-radius,
		SOUTHEAST,
	)
	tiles[++tiles.len] = list(
		-radius,
		radius,
		NORTHWEST,
	)
	tiles[++tiles.len] = list(
		-radius,
		-radius,
		SOUTHWEST,
	)
	for(var/x in -radius + 1 to radius - 1)
		tiles[++tiles.len] = list(
			x,
			radius,
			NORTH,
		)
		tiles[++tiles.len] = list(
			x,
			-radius,
			SOUTH,
		)
	for(var/y in -radius + 1 to radius - 1)
		tiles[++tiles.len] = list(
			radius,
			y,
			EAST,
		)
		tiles[++tiles.len] = list(
			-radius,
			y,
			WEST,
		)
