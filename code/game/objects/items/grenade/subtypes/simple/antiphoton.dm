/obj/item/grenade/simple/antiphoton
	desc = "An experimental device for temporarily removing light in a limited area."
	name = "photon disruption grenade"
	icon = 'icons/obj/grenade.dmi'
	icon_state = "emp"
	origin_tech = list(TECH_BLUESPACE = 4, TECH_MATERIAL = 4)
	activation_detonate_delay = 2 SECONDS
	detonation_delete_self = TRUE
	detonation_sound = 'sound/effects/phasein.ogg'

/obj/item/grenade/simple/antiphoton/on_detonate(turf/location, atom/grenade_location)
	. = ..()
	var/extra_delay = rand(0, 9 SECONDS)
	QDEL_IN(src, extra_delay)
	set_light(10, -10, "#FFFFFF")
