/obj/vehicle/ridden/wheelchair
	name = "wheelchair"
	desc = "You sit in this. Either by will or force."
	icon = 'icons/obj/furniture.dmi'		//Todo, move icon for wheelchair shit into their own folder
	icon_state = "wheelchair"
	overlays = list ("w_overlay")
	integrity = 50
	max_integrity = 50
	riding_handler_type = /datum/component/riding_handler/vehicle/ridden/wheelchair

/obj/vehicle/ridden/wheelchair/update_icon()
	..()
	overlays.Cut()
	add_overlay(image(icon = 'icons/obj/furniture.dmi', icon_state = "w_overlay", layer = src.layer + 2))
//	var/image/O = image(icon = 'icons/obj/furniture.dmi', icon_state = "w_overlay", layer = src.layer + 1)
//	overlays += O
	return


/datum/component/riding_handler/vehicle/ridden/wheelchair
	var/movement_inhibited
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
	CF_RIDING_CHECK_UNCONSCIOUS
	)

	riding_handler_flags = list(CF_RIDING_HANDLER_ALLOW_BORDER,
	CF_RIDING_HANDLER_IS_CONTROLLABLE)

/datum/component/riding_handler/vehicle/ridden/wheelchair/ride_check(mob/M)
	var/atom/movable/AM = parent
	if(!check_rider(M, AM.buckled_mobs[M]))
		movement_inhibited = TRUE
	else
		movement_inhibited = FALSE


/datum/component/riding_handler/vehicle/ridden/wheelchair/update_riders_on_move(atom/old_loc, dir)
	var/atom/movable/AM = parent
	// first check ridden mob
	if(!check_ridden(parent, TRUE))
		// kick everyone off
		for(var/mob/M as anything in AM.buckled_mobs)
		return
	for(var/mob/M as anything in AM.buckled_mobs)
		if(!check_rider(M, AM.buckled_mobs[M], TRUE))
			continue	// don't do rest of logic


/datum/component/riding_handler/vehicle/ridden/wheelchair/signal_hook_handle_move(atom/movable/source, atom/old_loc, dir)
	if(movement_inhibited == TRUE)
		return
	else
		update_riders_on_move(old_loc, dir)
		SIGNAL_HANDLER
		last_turf = isturf(old_loc)? old_loc : null




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

/obj/vehicle/ridden/wheelchair/OnMouseDrop(over_object, src_location, over_location)
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
