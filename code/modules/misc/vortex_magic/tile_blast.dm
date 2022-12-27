/obj/effect/vortex_tile/blast
	name = "vortex blast"
	desc = "A blinding burst of energy."
	#warn icon
	icon = ''
	icon_state = ""

	/// time before detonation
	var/detonate_time
	/// source
	var/atom/attacker
	/// damage
	var/damage = 10


/obj/effect/vortex_tile/blast/Initialize(mapload)
	. = ..()

#warn AYO

/obj/effect/vortex_tile/blast/proc/detonate()
	var/turf/T = get_turf(src)

/obj/effect/vortex_tile/blast/proc/attack_mob(mob/M)
	if(ff_check_mob(M))
		return


/obj/effect/vortex_tile/blast/proc/attack_obj(obj/O)
	if(!ff_check_obj(O))
		return

/obj/effect/vortex_tile/blast/proc/ff_check_mob(mob/M)

/obj/effect/vortex_tile/blast/proc/ff_check_obj(obj/O)
	return TRUE
