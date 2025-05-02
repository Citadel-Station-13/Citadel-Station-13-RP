/obj/item/grenade/simple/supermatter
	name = "supermatter grenade"
	icon_state = "banana"
	item_state = "emergency_engi"
	origin_tech = list(TECH_BLUESPACE = 5, TECH_MAGNET = 4, TECH_ENGINEERING = 5)
	activation_sound = 'sound/effects/3.wav'
	detonation_delete_self = FALSE

	var/imploding = FALSE
	var/implosion_delay = 10 SECONDS

/obj/item/grenade/simple/supermatter/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/grenade/simple/supermatter/on_detonate(turf/location)
	..()
	START_PROCESSING(SSobj, src)
	addtimer(CALLBACK(src, PROC_REF(implode)), implosion_delay)
	imploding = TRUE
	playsound(src, 'sound/weapons/wave.ogg', 100)
	update_icon()

/obj/item/grenade/simple/supermatter/update_overlays()
	. = ..()
	. += image(
		icon = 'icons/rust.dmi',
		icon_state = "emfield_s1",
	)

/obj/item/grenade/simple/supermatter/process(delta_time)
	if(!isturf(loc) && get_turf(src))
		forceMove(get_turf(src))
	playsound(src, 'sound/effects/supermatter.ogg', 100)
	supermatter_pull(src, world.view, STAGE_THREE)

/obj/item/grenade/simple/supermatter/proc/implode()
	explosion(src, 1, 3, 5, 4)
	qdel(src)
