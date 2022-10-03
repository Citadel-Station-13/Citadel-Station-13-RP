/obj/item/energy_net
	name = "energy net"
	desc = "It's a net made of green energy."
	icon = 'icons/effects/effects.dmi'
	icon_state = "energynet"
	throw_force = 0
	force = 0
	var/net_type = /obj/effect/energy_net

/obj/item/energy_net/dropped(mob/user, flags, atom/newLoc)
	. = ..()
	QDEL_IN(src, 10)

/obj/item/energy_net/throw_impact(atom/hit_atom)
	..()

	var/mob/living/M = hit_atom

	if(!istype(M) || locate(/obj/effect/energy_net) in M.loc)
		qdel(src)
		return 0

	var/turf/T = get_turf(M)
	if(T)
		var/obj/effect/energy_net/net = new net_type(T)
		if(net.buckle_mob(M))
			T.visible_message("[M] was caught in an energy net!")
		qdel(src)

	// If we miss or hit an obstacle, we still want to delete the net.
	spawn(10)
		if(src) qdel(src)

/obj/effect/energy_net
	name = "energy net"
	desc = "It's a net made of green energy."
	icon = 'icons/effects/effects.dmi'
	icon_state = "energynet"

	density = TRUE
	opacity = FALSE
	mouse_opacity = MOUSE_OPACITY_ICON
	anchored = FALSE

	buckle_allowed = TRUE
	buckle_flags = BUCKLING_NO_DEFAULT_BUCKLE // maybe when these aren't bullshit op i'll feel the need to """fix""" the fact that they're perfect projectile blockers half the time
	buckle_restrained_resist_time = 0

	var/escape_time = 8 SECONDS

/obj/effect/energy_net/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/effect/energy_net/Destroy()
	if(has_buckled_mobs())
		for(var/A in buckled_mobs)
			to_chat(A,"<span class='notice'>You are free of the net!</span>")
			unbuckle_mob(A)

	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/effect/energy_net/process(delta_time)
	if(!has_buckled_mobs())
		qdel(src)

/obj/effect/energy_net/Move()
	..()
	if(has_buckled_mobs())
		for(var/A in buckled_mobs)
			var/mob/living/occupant = A
			occupant.buckled = null
			occupant.forceMove(src.loc)
			occupant.buckled = src
			if (occupant && (src.loc != occupant.loc))
				unbuckle_mob(occupant)
				qdel(src)

/obj/effect/energy_net/mob_resist_buckle(mob/M, semantic)
	. = ..()
	if(!.)
		return
	M.setClickCooldown(M.get_attack_speed())
	visible_message("<span class='danger'>[M] begins to tear at \the [src]!</span>")
	if(!do_after(M, escape_time, src, incapacitation_flags = INCAPACITATION_DEFAULT & ~(INCAPACITATION_RESTRAINED | INCAPACITATION_BUCKLED_FULLY)))
		return FALSE
	visible_message("<span class='danger'>[M] manages to tear \the [src] apart!</span>")
	qdel(src)
	return FALSE

/obj/effect/energy_net/mob_buckled(mob/M, flags, mob/user, semantic)
	. = ..()
	layer = M.layer + 1
