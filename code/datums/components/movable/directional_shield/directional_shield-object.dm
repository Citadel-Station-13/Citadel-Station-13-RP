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

/atom/movable/directional_shield/proc/update_dir(turf/to_where, to_dir, to_degrees)
	if(to_dir != oriented_dir)
		// reorient
		oriented_dir = to_dir
		setDir(turn(north_facing_dir, to_degrees))
		switch(to_dir)
			if(NORTH)
				oriented_x_offset = x_offset
				oriented_y_offset = y_offset
			if(SOUTH)
				oriented_x_offset = -x_offset
				oriented_y_offset = y_offset
			if(EAST)
				oriented_x_offset = y_offset
				oriented_y_offset = x_offset
			if(WEST)
				oriented_x_offset = -y_offset
				oriented_y_offset = -x_offset

	abstract_move(locate(to_where.x + oriented_x_offset, to_where.y + oriented_y_offset, to_where.z))

/atom/movable/directional_shield/proc/update_pos(turf/to_where)
	abstract_move(locate(to_where.x + oriented_x_offset, to_where.y + oriented_y_offset, to_where.z))

/atom/movable/directional_shield/CanPass(atom/movable/mover, turf/target)
	if(istype(mover, /obj/projectile))
		// allows pass if they're going out as oriented dir is going outwards
		return get_dir(mover, target) & oriented_dir
	return ..()

/atom/movable/directional_shield/on_bullet_act(obj/projectile/proj, impact_flags, list/bullet_act_args)
	// no please go ahead, do hit us even if you want to pierce!
	impact_flags &= ~PROJECTILE_IMPACT_FLAGS_SHOULD_NOT_HIT
	return ..()

/atom/movable/directional_shield/inflict_damage_instance(SHIELDCALL_PROC_HEADER)
	owning_component.on_damage_instance(src, args)

/atom/movable/directional_shield/is_melee_targetable(datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	return FALSE
