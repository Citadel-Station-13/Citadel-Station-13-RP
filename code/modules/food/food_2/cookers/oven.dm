/obj/machinery/cooking/oven
	name = "oven"
	desc = "A NanoTrasen Commercial Catering NTCC-35 combi-oven. This one is a smaller model with only three shelves."
	icon_state = "oven_off"

	cooker_type = METHOD_OVEN

	max_contents = 3
	visible_position_xy = list(list(0, 0), list(0, 4), list(0,8))


/obj/machinery/cooking/oven/Initialize(mapload, newdir)
	..()
	if(prob(0.1))
		desc = "Why do they call it oven when you of in the cold food of out hot eat the food?"

/obj/machinery/cooking/oven/update_icon()
	cut_overlays()
	add_overlay("ovenpanel_[cooking_power]")

	for(var/I in food_containers)
		var/mutable_appearance/cooktop_overlay
		if(istype(I, /obj/item/reagent_containers/glass/food_holder))
			var/obj/item/reagent_containers/glass/food_holder/FH = I

			cooktop_overlay = mutable_appearance(icon, "oven_item")
			var/mutable_appearance/filling_overlay = mutable_appearance(icon, "oven_filling")

			var/px = visible_position_xy[food_containers[I]][1] //get 'location' from food containers, get pixel_x (first item of list) from visible_position_xy
			var/py = visible_position_xy[food_containers[I]][2]
			cooktop_overlay.pixel_x = px
			cooktop_overlay.pixel_y = py
			filling_overlay.pixel_x = px
			filling_overlay.pixel_y = py
			filling_overlay.color = FH.tally_color()

			add_overlay(cooktop_overlay)
			if(LAZYLEN(FH.contents))
				add_overlay(filling_overlay)


		else if(istype(I, /obj/item/reagent_containers/food/snacks/ingredient))
			var/obj/item/reagent_containers/food/snacks/ingredient/cooking_thingy = I

			cooktop_overlay = mutable_appearance(icon, "oven_food")

			var/px = visible_position_xy[food_containers[I]][1] //get 'location' from food containers, get pixel_x (first item of list) from visible_position_xy
			var/py = visible_position_xy[food_containers[I]][2]
			cooktop_overlay.pixel_x = px
			cooktop_overlay.pixel_y = py
			cooktop_overlay.color = AverageColor(get_flat_icon(cooking_thingy, cooking_thingy.dir, 0))

			add_overlay(cooktop_overlay)

	if(cooking_power)
		icon_state = "oven_on"
		add_overlay("ovendoor_closed")
	else
		icon_state = "oven_off"
		add_overlay("ovendoor_open")
