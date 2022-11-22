/obj/vehicle/ridden/wheelchair
	name = "wheelchair"
	desc = "You sit in this. Either by will or force."
	icon = 'icons/obj/furniture.dmi'		//Todo, move icon for wheelchair shit into their own folder
	icon_state = "wheelchair"
	integrity = 50
	max_integrity = 50
	riding_handler_type = /datum/component/riding_handler/vehicle/ridden/wheelchair

/obj/vehicle/ridden/wheelchair/update_icon()
	..()
	overlays.Cut()
	var/image/O = image(icon = 'icons/obj/furniture.dmi', icon_state = "w_overlay", layer = src.layer + 1)
	overlays += O
	return


/datum/component/riding_handler/vehicle/ridden/wheelchair
	vehicle_move_delay = 2
	allowed_turf_types = list(
		/turf/simulated,
		/turf/unsimulated
	)


/datum/component/riding_handler/vehicle/ridden/wheelchair
	rider_offsets = list(
		list(
			list(0, 0, -0.1, null),
			list(0, 0, 0.1, null),
			list(0, 0, 0.1, null),
			list(0, 0, 0.1, null)
		)
	)
	rider_offset_format = CF_RIDING_OFFSETS_ENUMERATED
	rider_check_flags = list(CF_RIDING_CHECK_RESTRAINED,
	CF_RIDING_CHECK_INCAPACITATED,
	CF_RIDING_CHECK_UNCONSCIOUS
	)
	riding_handler_flags = list(CF_RIDING_HANDLER_ALLOW_BORDER,
	CF_RIDING_HANDLER_IS_CONTROLLABLE)



/obj/item/wheelchair
	name = "wheelchair"
	desc = "A folded wheelchair that can be carried around."
	icon = 'icons/obj/furniture.dmi'	//Todo, move icon for wheelchair shit into their own folder
	icon_state = "wheelchair_folded"
	item_state = "wheelchair"
	w_class = ITEMSIZE_HUGE // Can't be put in backpacks. Oh well.
	/// What we unfold to
	var/unfolded_type = /obj/vehicle/ridden/wheelchair

/obj/item/wheelchair/attack_self(mob/user)
		var/obj/vehicle/ridden/wheelchair/R = new /obj/vehicle/ridden/wheelchair(user.loc)
		R.add_fingerprint(user)
		R.name = src.name
		R.color = src.color
		qdel(src)

/obj/vehicle/ridden/wheelchair/OnMouseDropLegacy(over_object, src_location, over_location)
	..()
	if((over_object == usr && (in_range(src, usr) || usr.contents.Find(src))))
		if(!ishuman(usr))	return
		if(has_buckled_mobs())	return 0
		visible_message("[usr] collapses \the [src.name].")
		var/obj/item/wheelchair/R = new/obj/item/wheelchair(get_turf(src))
		R.name = src.name
		R.color = src.color
		spawn(0)
			qdel(src)
		return




/*
//Dolly Below

/obj/structure/bed/chair/wheelchair/dolly
	name = "transport dolly"
	desc = "The safest way to transport high-risk patients."
	icon_state = "wheelchair_dolly"

/obj/structure/bed/chair/wheelchair/dolly/setDir()
	..()
	overlays = null
	var/image/O = image(icon = 'icons/obj/furniture.dmi', icon_state = "d_overlay", layer = FLY_LAYER, dir = src.dir)
	overlays += O
	if(has_buckled_mobs())
		for(var/A in buckled_mobs)
			var/mob/living/L = A
			L.setDir(dir)
*/
