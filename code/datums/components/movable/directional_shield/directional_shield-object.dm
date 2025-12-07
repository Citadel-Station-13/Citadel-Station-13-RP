//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

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
	// while north
	var/x_offset = 0
	// while north
	var/y_offset = 0
	// while north
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
