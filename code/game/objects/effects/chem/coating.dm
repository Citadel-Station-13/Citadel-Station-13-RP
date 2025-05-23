/*
 * Home of the floor chemical coating.
 */

/obj/effect/debris/cleanable/chemcoating
	icon = 'icons/effects/effects.dmi'
	icon_state = "dirt"

/obj/effect/debris/cleanable/chemcoating/Initialize(mapload)
	. = ..()
	create_reagents(100)

/obj/effect/debris/cleanable/chemcoating/Initialize(mapload)
	. = ..()
	var/turf/T = get_turf(src)
	if(T)
		for(var/obj/O in get_turf(src))
			if(O == src)
				continue
			if(istype(O, /obj/effect/debris/cleanable/chemcoating))
				var/obj/effect/debris/cleanable/chemcoating/C = O
				if(C.reagents?.total_volume)
					C.reagents.trans_to_obj(src,C.reagents.total_volume)
				qdel(O)

// todo: apply to whole body or just feet depending on if they're laying down, when crossed by mob or obj

/obj/effect/debris/cleanable/chemcoating/update_icon()
	..()
	color = reagents.get_color()
