/obj/vehicle/ridden/bike 	// TODO, make this fly @ktoma36
	name = "space-bike"
	desc = "Space wheelies! Woo! This one doesnt seem to fly!"
	icon = 'icons/obj/bike.dmi'
	icon_state = "bike_off"
	dir = SOUTH
	integrity = 100
	integrity_max = 100
	mechanical = FALSE				//We DO use power to move
	riding_handler_type = /datum/component/riding_handler/vehicle/bike/small
	var/bike_icon = "bike"			//For different power states
	var/custom_paint = FALSE 		//For handling alpha channels
	var/paint_color = "#ffffff"   //For paint color
	var/datum/effect_system/ion_trail_follow/ion


/datum/component/riding_handler/vehicle/bike
	vehicle_move_delay = 0.5
	allowed_turf_types = list(
		/turf/simulated/floor,
		/turf/unsimulated/floor
	)
	vehicle_offsets = list(
		list(1, 2),
		list(1, 2),
		list(1, 2),
		list(1, 2)
	)

/datum/component/riding_handler/vehicle/bike/small
	rider_offsets = list(
		list(
			list(1, 7, 0.1, null),
			list(2, 2, 0.1, null),
			list(1, 10, 0.1, null),
			list(-2, 2, 0.1, null)
		)
	)
	rider_offset_format = CF_RIDING_OFFSETS_ENUMERATED
	riding_handler_flags = list(CF_RIDING_HANDLER_ALLOW_BORDER,
	CF_RIDING_HANDLER_IS_CONTROLLABLE)

/obj/vehicle/ridden/bike/Initialize(mapload)
	. = ..()
	cell_type = /obj/item/cell/high	//Start with a high capacity cell
	ion = new /datum/effect_system/ion_trail_follow()
	ion.set_up(src)
	icon_state = "[bike_icon]_off"
	update_icon()

//Random bikes spawn with a random color
/obj/vehicle/ridden/bike/random/Initialize(mapload)
	. = ..()
	paint_color = rgb(rand(1,255),rand(1,255),rand(1,255))

//Set a custom color via multitool
/obj/vehicle/ridden/bike/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/multitool) && maint_panel_open)
		var/new_paint = input("Please select paint color.", "Paint Color", paint_color) as color|null
		if(new_paint)
			paint_color = new_paint
			update_icon()
			return
	..()

//! Replace with emiting sound verbs when key is inserted or removed. An extra engine toggle verb is bloat.
/*
/obj/vehicle_old/bike/verb/toggle()
	set name = "Toggle Engine"
	set category = "Vehicle"
	set src in view(0)

	if(!isliving(usr) || ismouse(usr))
		return

	if(usr.incapacitated()) return

	if(!on && cell && cell.charge > charge_use)
		turn_on()
		src.visible_message("\The [src] rumbles to life.", "You hear something rumble deeply.")
	else
		turn_off()
		src.visible_message("\The [src] putters before turning off.", "You hear something putter slowly.")
*/
//! Similarly attach ion.start ion.stop and anchored to key presence. We need less bloat.
/*
/obj/vehicle_old/bike/turn_on()
	ion.start()
	anchored = 1

	update_icon()

	if(pulledby)
		pulledby.stop_pulling()
	..()

/obj/vehicle_old/bike/turn_off()
	ion.stop()
	anchored = kickstand

	update_icon()

	..()
*/

//! This thing is a huge mess and I don't understand icons yet. It feels like pointless duplicated logic.
/obj/vehicle/ridden/bike/update_icon()
	cut_overlays()
	var/list/overlays_to_add = list()

	if(custom_paint)
		if(inserted_key)
			var/image/bodypaint = image('icons/obj/custom_items_vehicle.dmi', "[bike_icon]_on_a", src.layer)
			bodypaint.color = paint_color
			overlays_to_add += bodypaint

			var/image/overmob = image('icons/obj/custom_items_vehicle.dmi', "[bike_icon]_on_overlay", MOB_LAYER + 1)
			var/image/overmob_color = image('icons/obj/custom_items_vehicle.dmi', "[bike_icon]_on_overlay_a", MOB_LAYER + 1)
			overmob.plane = MOB_PLANE
			overmob_color.plane = MOB_PLANE
			overmob_color.color = paint_color
			overlays_to_add += overmob
			overlays_to_add += overmob_color
			if(maint_panel_open)
				icon_state = "[bike_icon]_on-open"
			else
				icon_state = "[bike_icon]_on"
		else
			var/image/bodypaint = image('icons/obj/custom_items_vehicle.dmi', "[bike_icon]_off_a", src.layer)
			bodypaint.color = paint_color
			overlays_to_add += bodypaint

			var/image/overmob = image('icons/obj/custom_items_vehicle.dmi', "[bike_icon]_off_overlay", MOB_LAYER + 1)
			var/image/overmob_color = image('icons/obj/custom_items_vehicle.dmi', "[bike_icon]_off_overlay_a", MOB_LAYER + 1)
			overmob.plane = MOB_PLANE
			overmob_color.plane = MOB_PLANE
			overmob_color.color = paint_color
			overlays_to_add += overmob
			overlays_to_add += overmob_color
			if(maint_panel_open)
				icon_state = "[bike_icon]_off-open"
			else
				icon_state = "[bike_icon]_off"
		add_overlay(overlays_to_add)
		..()
		return

	if(inserted_key)
		var/image/bodypaint = image('icons/obj/bike.dmi', "[bike_icon]_on_a", src.layer)
		bodypaint.color = paint_color
		overlays_to_add += bodypaint

		var/image/overmob = image('icons/obj/bike.dmi', "[bike_icon]_on_overlay", MOB_LAYER + 1)
		var/image/overmob_color = image('icons/obj/bike.dmi', "[bike_icon]_on_overlay_a", MOB_LAYER + 1)
		overmob.plane = MOB_PLANE
		overmob_color.plane = MOB_PLANE
		overmob_color.color = paint_color
		overlays_to_add += overmob
		overlays_to_add += overmob_color
		if(maint_panel_open)
			icon_state = "[bike_icon]_on-open"
		else
			icon_state = "[bike_icon]_on"
	else
		var/image/bodypaint = image('icons/obj/bike.dmi', "[bike_icon]_off_a", src.layer)
		bodypaint.color = paint_color
		overlays_to_add += bodypaint

		var/image/overmob = image('icons/obj/bike.dmi', "[bike_icon]_off_overlay", MOB_LAYER + 1)
		var/image/overmob_color = image('icons/obj/bike.dmi', "[bike_icon]_off_overlay_a", MOB_LAYER + 1)
		overmob.plane = MOB_PLANE
		overmob_color.plane = MOB_PLANE
		overmob_color.color = paint_color
		overlays_to_add += overmob
		overlays_to_add += overmob_color
		if(maint_panel_open)
			icon_state = "[bike_icon]_off-open"
		else
			icon_state = "[bike_icon]_off"

	add_overlay(overlays_to_add)

	..()

//Make sure to cleanup when done.
/obj/vehicle/ridden/bike/Destroy()
	qdel(ion)

	..()

