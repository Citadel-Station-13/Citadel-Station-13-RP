// Base type for cooking machines
// Contributes to a food's cooking timer. That's basically it.
/obj/machinery/cooking
	name = "stove"
	desc = "A stove, for cooking food."
	icon = 'icons/obj/food_ingredients/cooking_machines.dmi'
	icon_state = "stove"

	density = 1
	anchored = 1
	default_unanchor = 5 SECONDS

	use_power = 0
	idle_power_usage = 5			// Power used when turned on, but not processing anything
	active_power_usage = 1000		// Power used when turned on and actively cooking something

	speed_process = PROCESS_ON_SSPROCESSING


	var/cooker_type = METHOD_STOVE
	var/cooking_power = 0

	var/max_contents = 4			// Maximum number of things this appliance can simultaneously cook
	var/list/food_containers //what food (/obj/item/reagent_containers/glass/food_holder = 1, /reagent_containers/snacks/ingredient = 2) we are cooking, and their positions inside the thing
	var/list/visible_position_xy = list(list(-7, 6), list(7, 6),list(-7, -3), list(7, -3))//for mapping a pixel_x, pixel_y to abstract ''position


/obj/machinery/cooking/examine(mob/user, dist)
	. = ..()
	switch(cooking_power)
		if(0)
			. += "<span class='notice'> [src] is off.</span>"
		if(HEAT_LOW)
			. += "<span class='notice'> [src] is on low heat.</span>"
		if(HEAT_MID)
			. += "<span class='notice'> [src] is medium heat.</span>"
		if(HEAT_HIGH)
			. += "<span class='notice'> [src] is high heat.</span>"


/obj/machinery/cooking/Initialize(mapload, newdir)
	. = ..()
	food_containers = list()
	component_parts = list()
	component_parts += /obj/item/circuitboard/machine/cooker
	component_parts += /obj/item/stock_parts/capacitor
	component_parts += /obj/item/stock_parts/scanning_module
	component_parts += /obj/item/stock_parts/matter_bin

/obj/machinery/cooking/RefreshParts()
	..()
	var/scan_rating = 0
	var/cap_rating = 0

	for(var/obj/item/stock_parts/P in src.component_parts)
		if(istype(P, /obj/item/stock_parts/scanning_module))
			scan_rating += P.rating
		else if(istype(P, /obj/item/stock_parts/capacitor))
			cap_rating += P.rating

	active_power_usage = initial(active_power_usage) - ((scan_rating + cap_rating) * 5)

/obj/machinery/cooking/process(delta_time)
	if(cooking_power > 0)
		for(var/I in food_containers)
			if(istype(I, /obj/item/reagent_containers/glass/food_holder))
				var/obj/item/reagent_containers/glass/food_holder/FH = I
				FH.tick_heat(1 SECONDS, cooking_power, cooker_type)
			else if(istype(I, /obj/item/reagent_containers/food/snacks/ingredient))
				var/obj/item/reagent_containers/food/snacks/ingredient/cooking_thingy = I
				cooking_thingy.process_cooked(1 SECONDS, cooking_power, cooker_type)

/obj/item/circuitboard/machine/cooker
	name = "kitchen appliance circuitry"
	desc = "The circuitboard for many kitchen appliances. Not of much use."
	origin_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	req_components = list(
							/obj/item/stock_parts/capacitor = 1,
							/obj/item/stock_parts/scanning_module = 1,
							/obj/item/stock_parts/matter_bin = 1)


/obj/machinery/cooking/attackby(obj/item/I, mob/user)
	if(machine_stat & (BROKEN))
		to_chat(user, "<span class='warning'>\The [src] is not working.</span>")
		return

	if(default_deconstruction_screwdriver(user, I))
		return
	if(default_part_replacement(user, I))
		return
	if(default_deconstruction_crowbar(user, I))
		return

	if(food_containers.len >= max_contents)
		return //no inserties if full
	if(istype(I, /obj/item/reagent_containers/glass/food_holder) || istype(I, /obj/item/reagent_containers/food/snacks/ingredient))
		//From here we can start cooking food
		insert_item(I, user)
		
/obj/machinery/cooking/update_icon()
	var/fire_color = COLOR_YELLOW
	cut_overlays()
	switch(cooking_power)
		if(0)
			fire_color = null
		if(HEAT_LOW)
			fire_color = COLOR_RED
		if(HEAT_HIGH)
			fire_color = COLOR_CYAN
	for(var/I in food_containers)
		var/mutable_appearance/cooktop_overlay
		var/mutable_appearance/fire_overlay
		if(istype(I, /obj/item/reagent_containers/glass/food_holder))
			var/obj/item/reagent_containers/glass/food_holder/FH = I

			cooktop_overlay = mutable_appearance(icon, "[FH.cooker_overlay]")
			var/mutable_appearance/filling_overlay = mutable_appearance(icon, "filling_overlay")

			var/px = visible_position_xy[food_containers[I]][1] //get 'location' from food containers, get pixel_x (first item of list) from visible_position_xy
			var/py = visible_position_xy[food_containers[I]][2]
			cooktop_overlay.pixel_x = px
			cooktop_overlay.pixel_y = py
			filling_overlay.pixel_x = px
			filling_overlay.pixel_y = py
			filling_overlay.color = FH.reagents.get_color() //TODO: tally_colour()

			switch(FH.cooker_overlay)
				if("skillet")
					filling_overlay.pixel_y -= 3
				if("pan")
					filling_overlay.pixel_y -= 2

			if(fire_color)
				fire_overlay = mutable_appearance(icon, "stove_flame")
				fire_overlay.pixel_x = px
				fire_overlay.pixel_y = py
				fire_overlay.color = fire_color
				add_overlay(fire_overlay)
				
			add_overlay(cooktop_overlay)
			add_overlay(filling_overlay)


		else if(istype(I, /obj/item/reagent_containers/food/snacks/ingredient))
			var/obj/item/reagent_containers/food/snacks/ingredient/cooking_thingy = I

			cooktop_overlay = mutable_appearance(icon, "[cooking_thingy.cooker_overlay]_stove")

			var/px = visible_position_xy[food_containers[I]][1] //get 'location' from food containers, get pixel_x (first item of list) from visible_position_xy
			var/py = visible_position_xy[food_containers[I]][2]
			cooktop_overlay.pixel_x = px
			cooktop_overlay.pixel_y = py

			if(fire_color)
				fire_overlay = mutable_appearance(icon, "[icon_state]_flame")
				fire_overlay.pixel_x = px
				fire_overlay.pixel_y = py
				fire_overlay.color = fire_color
				add_overlay(fire_overlay)
			add_overlay(cooktop_overlay)


/obj/machinery/cooking/proc/insert_item(obj/item/I, mob/user)
	if(!user.attempt_insert_item_for_installation(I, src))
		return
	var/list/used_list = list(1,2,3,4) //this feels so bad but i literally cannot think of a better way
	for(var/t in food_containers)
		used_list -= food_containers[t]
	food_containers[I] = pick(used_list) //random position :D
	user.visible_message("<span class='notice'>[user] puts [I] into [src].</span>", "<span class='notice'>You put [I] into [src].</span>")
	update_icon()

/obj/machinery/cooking/attack_hand(mob/user, list/params)
	if(!isliving(user))
		return ..()
	if(eject_item(user))
		return
	else
		return ..() //if there's nothing to remove, we act as normal

/obj/machinery/cooking/proc/eject_item(mob/user)
	var/list/removables = list()
	var/counter = 0
	for(var/obj/item/reagent_containers/food/snacks/ingredient/I in food_containers)
		if(counter)
			removables["[I.name] ([counter]) \[[I.cookstage2text()]\]"] = I
		else
			removables["[I.name] \[[I.cookstage2text()]\]"] = I
		counter++
	counter = 0
	for(var/obj/item/reagent_containers/glass/food_holder/FH in food_containers)
		if(counter)
			removables["[FH.name] ([counter])"] = FH
		else
			removables[FH.name] = FH
		counter++
	var/remove_item = removables[1]
	if(LAZYLEN(food_containers ) > 1)
		remove_item = input(user, "What to remove?", "Remove from cooker", null) as null|anything in removables
	if(remove_item)
		food_containers -= removables[remove_item]
		user.put_in_hands_or_drop(removables[remove_item])
		update_icon()
		return TRUE
	return FALSE

/obj/machinery/cooking/proc/has_space()
	if (food_containers.len >= max_contents)
		return FALSE
	return TRUE


/obj/machinery/cooking/AltClick(mob/user)

	var/temp_setting = input(user, "Select a temperature setting.", "Temperature Control", null) as null | anything in list("off", "low", "medium", "high")

	switch(temp_setting)
		if("off")
			machine_stat |= POWEROFF
			use_power = FALSE
			user.visible_message("[user] turns [src] off.", "You turn off [src].")
			cooking_power = 0
		if("low")
			if(machine_stat & POWEROFF)
				machine_stat &= ~POWEROFF
				use_power = TRUE
				user.visible_message("[user] turns [src] on.", "You turn on [src].")
			user.visible_message("[user] turns [src] to low power.", "You turn [src] to low power.")
			cooking_power = HEAT_LOW
		if("medium")
			if(machine_stat & POWEROFF)
				machine_stat &= ~POWEROFF
				use_power = TRUE
				user.visible_message("[user] turns [src] on.", "You turn on [src].")
			user.visible_message("[user] turns [src] to low power.", "You turn [src] to medium power.")
			cooking_power = HEAT_MID
		if("high")
			if(machine_stat & POWEROFF)
				machine_stat &= ~POWEROFF
				use_power = TRUE
				user.visible_message("[user] turns [src] on.", "You turn on [src].")
			user.visible_message("[user] turns [src] to low power.", "You turn [src] to high power.")
			cooking_power = HEAT_HIGH
		

	playsound(src, 'sound/machines/click.ogg', 40, 1)
	update_icon()




