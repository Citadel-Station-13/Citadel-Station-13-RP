/obj/machinery/cooking/fryer
	name = "deep fryer"
	desc = "A deep fryer. Oil goes in, food goes in, delicious food comes out."
	icon_state = "fryer_off"

	cooker_type = METHOD_DEEPFRY

	max_contents = 2			// Maximum number of things this appliance can simultaneously cook
	visible_position_xy = list(list(-7, 0), list(7, 0))//for mapping a pixel_x, pixel_y to abstract ''position


/obj/machinery/cooking/fryer/attackby(obj/item/I, mob/user)
	if(machine_stat & (BROKEN))
		to_chat(user, "<span class='warning'>\The [src] is not working.</span>")
		return

	if(default_deconstruction_screwdriver(user, I))
		return
	if(default_part_replacement(user, I))
		return
	if(default_deconstruction_crowbar(user, I))
		return

	if(istype(I, /obj/item/reagent_containers/glass/food_holder/fryer_basket)) //only accept baskets
		if(food_containers.len >= max_contents)
			return //no inserties if full
		//From here we can start cooking food
		insert_item(I, user)
	else
		..()

/obj/machinery/cooking/fryer/update_icon()
	if(cooking_power)
		icon_state = "fryer_on"
	else
		icon_state = "fryer_off"
	cut_overlays()
	for(var/I in food_containers)
		var/mutable_appearance/cooktop_overlay
		if(istype(I, /obj/item/reagent_containers/glass/food_holder))

			cooktop_overlay = mutable_appearance(icon, "basket")

			var/px = visible_position_xy[food_containers[I]][1] //get 'location' from food containers, get pixel_x (first item of list) from visible_position_xy
			var/py = visible_position_xy[food_containers[I]][2]
			cooktop_overlay.pixel_x = px
			cooktop_overlay.pixel_y = py

			add_overlay(cooktop_overlay)



		else if(istype(I, /obj/item/reagent_containers/food/snacks/ingredient))
			var/obj/item/reagent_containers/food/snacks/ingredient/cooking_thingy = I

			cooktop_overlay = mutable_appearance(icon, "[cooking_thingy.cooker_overlay]_fryer")

			var/px = visible_position_xy[food_containers[I]][1] //get 'location' from food containers, get pixel_x (first item of list) from visible_position_xy
			var/py = visible_position_xy[food_containers[I]][2]
			cooktop_overlay.pixel_x = px
			cooktop_overlay.pixel_y = py

			add_overlay(cooktop_overlay)
