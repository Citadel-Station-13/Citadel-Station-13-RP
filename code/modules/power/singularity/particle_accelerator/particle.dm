//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

/obj/effect/accelerated_particle
	name = "Accelerated Particles"
	desc = "Small things moving very fast."
	icon = 'icons/obj/machines/particle_accelerator2.dmi'
	icon_state = "particle1"//Need a new icon for this
	anchored = TRUE
	density = TRUE
	generic_canpass = FALSE
	plane = MOB_PLANE
	layer = ABOVE_MOB_LAYER
	var/movement_range = 10
	var/energy = 10		//energy in eV
	var/mega_energy = 0	//energy in MeV
	var/frequency = 1
	var/ionizing = 0
	var/particle_type
	var/additional_particles = 0
	var/turf/target
	var/turf/source
	var/movetotarget = 1

/obj/effect/accelerated_particle/CanPassThrough(atom/blocker, turf/target, blocker_opinion)
	SHOULD_CALL_PARENT(FALSE)
	return TRUE

/obj/effect/accelerated_particle/weak
	icon_state = "particle0"
	movement_range = 8
	energy = 5

/obj/effect/accelerated_particle/strong
	icon_state = "particle2"
	movement_range = 15
	energy = 15

/obj/effect/accelerated_particle/powerful
	icon_state = "particle3"
	movement_range = 25
	energy = 50

/obj/effect/accelerated_particle/reverse
	icon_state = "particle3"
	movement_range = 15
	energy = -20

/obj/effect/accelerated_particle/Initialize(mapload, dir = SOUTH)
	setDir(dir)
	. = ..()
	START_PROCESSING(SSprocess_5fps, src)

/obj/effect/accelerated_particle/Destroy()
	STOP_PROCESSING(SSprocess_5fps, src)
	return ..()

/obj/effect/accelerated_particle/process(delta_time)
	var/old_z = z
	var/turf/where_to = get_step(src, dir)
	if(!where_to)
		qdel(src)
		return
	if(!Move(where_to))
		if(!QDELETED(src))
			qdel(src)
			return
		else
			return PROCESS_KILL
	// being deleted changes Z so that's also an implicit qdeleted() check.
	if(z != old_z)
		if(!QDELETED(src))
			qdel(src)
			return
		else
			return PROCESS_KILL

/obj/effect/accelerated_particle/Moved()
	. = ..()
	if(!isturf(loc))
		return
	for(var/atom/movable/AM as anything in loc)
		do_the_funny(AM)
		if(QDELETED(src))
			return

// todo: particle_accelerator_act() or something
/obj/effect/accelerated_particle/proc/do_the_funny(atom/A)
	if (A)
		if(ismob(A))
			toxmob(A)
		if((istype(A,/obj/machinery/the_singularitygen))||(istype(A,/obj/singularity/))||(istype(A, /obj/machinery/particle_smasher)))
			A:energy += energy
		//R-UST port
		if(istype(A, /obj/effect/fusion_em_field))
			var/obj/effect/fusion_em_field/field = A
			if(particle_type && particle_type != "neutron")
				if(field.owned_core.AddParticles(particle_type, 1 + additional_particles))
					field.plasma_temperature += mega_energy
					field.energy += energy
					qdel(src)
					return

/obj/effect/accelerated_particle/singularity_act()
	return

/obj/effect/accelerated_particle/proc/toxmob(var/mob/living/M)
	if(!istype(M))
		return
	M.afflict_radiation(energy * 5, TRUE)
