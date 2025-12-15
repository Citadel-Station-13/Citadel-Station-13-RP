// todo: /obj/effect/shield_matrix
// This is the actual shield.  The projector is a different item.
/obj/effect/directional_shield
	name = "directional combat shield"
	desc = "A wide shield, which has the property to block incoming projectiles but allow outgoing projectiles to pass it.  \
	Slower moving objects are not blocked, so people can walk in and out of the barrier, and things can be thrown into and out \
	of it."
	icon = 'icons/effects/effects.dmi'
	icon_state = "directional_shield"
	density = FALSE // People can move pass these shields.
	opacity = FALSE
	anchored = TRUE
	integrity_flags = INTEGRITY_ACIDPROOF | INTEGRITY_FIREPROOF | INTEGRITY_LAVAPROOF
	layer = MOB_LAYER + 0.1
	mouse_opacity = FALSE
	var/obj/item/shield_projector/projector = null // The thing creating the shield.
	var/x_offset = 0 // Offset from the 'center' of where the projector is, so that if it moves, the shield can recalc its position.
	var/y_offset = 0 // Ditto.

/obj/effect/directional_shield/Initialize(mapload, new_projector)
	if(new_projector)
		projector = new_projector
		var/turf/us = get_turf(src)
		var/turf/them = get_turf(projector)
		if(them)
			x_offset = us.x - them.x
			y_offset = us.y - them.y
	else
		update_color()
	return ..()

/obj/effect/directional_shield/proc/relocate()
	if(!projector)
		return // Nothing to follow.
	var/turf/T = get_turf(projector)
	if(!T)
		return
	var/turf/new_pos = locate(T.x + x_offset, T.y + y_offset, T.z)
	if(new_pos)
		forceMove(new_pos)
	else
		qdel(src)

/obj/effect/directional_shield/proc/update_color(var/new_color)
	if(!projector)
		color = "#0099FF"
	else
		animate(src, color = new_color, 5)
//	color = new_color

/obj/effect/directional_shield/Destroy()
	if(projector)
		projector.active_shields -= src
		projector = null
	return ..()

/obj/effect/directional_shield/CanPass(atom/movable/mover, turf/target)
	. = ..()
	if(istype(mover, /obj/projectile))
		var/obj/projectile/P = mover
		if(P.projectile_type & PROJECTILE_TYPE_TRACE)
			return TRUE
		if(check_defensive_arc_tile(src, P, 90, null, dir))
			return FALSE
	return TRUE

/obj/effect/directional_shield/on_bullet_act(obj/projectile/proj, impact_flags, list/bullet_act_args)
	impact_flags &= ~PROJECTILE_IMPACT_FLAGS_SHOULD_NOT_HIT
	. = ..()
	if(. & PROJECTILE_IMPACT_FLAGS_UNCONDITIONAL_ABORT)
		return
	adjust_health(-proj.get_structure_damage())
	playsound(src, 'sound/effects/EMPulse.ogg', 75, 1)

// All the shields tied to their projector are one 'unit', and don't have individualized health values like most other shields.
/obj/effect/directional_shield/proc/adjust_health(amount)
	if(projector)
		projector.adjust_health(amount) // Projector will kill the shield if needed.
	// If the shield lacks a projector, then it was probably spawned in by an admin for bus, so it's indestructable.
