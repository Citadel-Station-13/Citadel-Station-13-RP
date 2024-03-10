//grill time!
/obj/machinery/cooking/grill
	name = "grill"
	desc = "A high-power electric grill."
	icon_state = "fryer_off"

	cooker_type = METHOD_GRILL

	max_contents = 4
	visible_position_xy = list(list(-5, 0), list(5, 0))

/obj/machinery/cooking/grill/Initialize(mapload, newdir)
	. = ..()
	add_overlay("grill")


/obj/machinery/cooking/grill/update_icon()
	if(cooking_power)
		icon_state = "grill_on"
	else
		icon_state = "grill_off"
	cut_overlays()
	add_overlay("grill")

	for(var/I in food_containers)
		var/mutable_appearance/cooktop_overlay
		if(istype(I, /obj/item/reagent_containers/glass/food_holder))
			var/obj/item/reagent_containers/glass/food_holder/FH = I
			cooktop_overlay = mutable_appearance(icon, "[FH.cooker_overlay]")

			var/px = visible_position_xy[food_containers[I]][1]
			var/py = visible_position_xy[food_containers[I]][2]
			cooktop_overlay.pixel_x = px
			cooktop_overlay.pixel_y = (py - 2) //2 down

			add_overlay(cooktop_overlay)



		else if(istype(I, /obj/item/reagent_containers/food/snacks/ingredient))
			var/obj/item/reagent_containers/food/snacks/ingredient/cooking_thingy = I

			cooktop_overlay = get_flat_icon(cooking_thingy, cooking_thingy.dir, 0)
			cooktop_overlay.transform *= 0.25 //the designated space on the grill is 8x8, so 1/4 (1/2?) size
			var/px = visible_position_xy[food_containers[I]][1]
			var/py = visible_position_xy[food_containers[I]][2]
			cooktop_overlay.pixel_x = px
			cooktop_overlay.pixel_y = py

			add_overlay(cooktop_overlay)
