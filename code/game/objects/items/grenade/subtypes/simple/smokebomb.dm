/obj/item/grenade/simple/smoke
	desc = "It is set to detonate in 2 seconds. These high-tech grenades can have their color adapted on the fly with a multitool!"
	name = "smoke bomb"
	icon = 'icons/obj/grenade.dmi'
	icon_state = "flashbang"
	activation_detonate_delay = 20
	item_state = "flashbang"
	slot_flags = SLOT_BELT
	worth_intrinsic = 50
	var/datum/effect_system/smoke_spread/bad/smoke
	var/smoke_color
	var/smoke_strength = 8

/obj/item/grenade/simple/smoke/Initialize(mapload)
	. = ..()
	src.smoke = new /datum/effect_system/smoke_spread/bad()
	src.smoke.attach(src)

/obj/item/grenade/simple/smoke/Destroy()
	QDEL_NULL(smoke)
	return ..()

/obj/item/grenade/simple/smoke/on_detonate(turf/location, atom/grenade_location)
	..()
	playsound(location, 'sound/effects/smoke.ogg', 50, 1, -3)
	src.smoke.set_up(10, 0, location)
	spawn()
		for(var/i = 1 to smoke_strength)
			src.smoke.start(smoke_color)
			sleep(10)

/obj/item/grenade/simple/smoke/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I,/obj/item/multitool))
		var/new_smoke_color = input(user, "Choose a color for the smoke:", "Smoke Color", smoke_color) as color|null
		if(new_smoke_color)
			smoke_color = new_smoke_color
