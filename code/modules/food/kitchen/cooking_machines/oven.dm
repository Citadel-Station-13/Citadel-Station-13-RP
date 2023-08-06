/obj/machinery/appliance/cooker/oven
	name = "oven"
	desc = "Cookies are ready, dear."
	icon = 'icons/obj/cooking_machines.dmi'
	icon_state = "ovenopen"
	cook_type = "baked"
	appliancetype = OVEN
	food_color = "#A34719"
	can_burn_food = 1
	var/datum/looping_sound/oven/oven_loop
	active_power_usage = 6 KILOWATTS
	//Based on a double deck electric convection oven

	resistance = 3200
	idle_power_usage = 2 KILOWATTS
	//uses ~3% power to stay warm
	optimal_power = 0.2

	light_x = 2
	max_contents = 5
	container_type = /obj/item/reagent_containers/cooking_container/oven

	machine_stat = POWEROFF	//Starts turned off

	var/open = TRUE

	output_options = list(
		"Pizza" = /obj/item/reagent_containers/food/snacks/variable/pizza,
		"Bread" = /obj/item/reagent_containers/food/snacks/variable/bread,,
		"Pie" = /obj/item/reagent_containers/food/snacks/variable/pie,
		"Cake" = /obj/item/reagent_containers/food/snacks/variable/cake,
		"Hot Pocket" = /obj/item/reagent_containers/food/snacks/variable/pocket,
		"Kebab" = /obj/item/reagent_containers/food/snacks/variable/kebab,
		"Waffles" = /obj/item/reagent_containers/food/snacks/variable/waffles,
		"Cookie" = /obj/item/reagent_containers/food/snacks/variable/cookie,
		"Donut" = /obj/item/reagent_containers/food/snacks/variable/donut,
		"Default" = null
	)

	var/static/list/radial_menu = list(
		"Pizza"= image(icon = 'icons/obj/food.dmi', icon_state = "pizzamargherita"),
		"Bread" = image(icon = 'icons/obj/food.dmi', icon_state = "bread"),
		"Pie" = image(icon = 'icons/obj/food.dmi', icon_state = "pie"),
		"Cake" = image(icon = 'icons/obj/food.dmi', icon_state = "plaincake"),
		"Hot Pocket" = image(icon = 'icons/obj/food.dmi', icon_state = "donkpocket"),
		"Kebab" = image(icon = 'icons/obj/food.dmi', icon_state = "kabob"),
		"Waffles" = image(icon = 'icons/obj/food.dmi', icon_state = "waffles"),
		"Cookie" = 	image(icon = 'icons/obj/food.dmi', icon_state = "COOKIE!!!"),
		"Donut" = image(icon = 'icons/obj/food.dmi', icon_state = "donut1"),
		"Default" = image(icon = 'icons/mob/radial.dmi', icon_state = "red_x")
	)

/obj/machinery/appliance/cooker/oven/Initialize(mapload)
	. = ..()

	oven_loop = new(list(src), FALSE)

/obj/machinery/appliance/cooker/oven/Destroy()
	QDEL_NULL(oven_loop)
	return ..()

/obj/machinery/appliance/cooker/oven/update_icon()
	if (!open)
		if (!machine_stat)
			icon_state = "ovenclosed_on"
			if(oven_loop)
				oven_loop.stop(src)
		else
			icon_state = "ovenclosed_off"
			if(oven_loop)
				oven_loop.stop(src)
	else
		icon_state = "ovenopen"
		if(oven_loop)
			oven_loop.stop(src)
	..()

/obj/machinery/appliance/cooker/oven/choose_output()
	set src in view()
	set name = "Choose output"
	set category = "Object"

	if(!can_use_check(usr))
		return

	if(output_options.len)
		var/choice = show_radial_menu(usr, src, radial_menu, require_near = !issilicon(usr))
		if(!choice)
			return
		if(choice == "Default")
			selected_option = null
			to_chat(usr, "<span class='notice'>You decide not to make anything specific with \the [src].</span>")
		else
			selected_option = choice
			to_chat(usr, "<span class='notice'>You prepare \the [src] to make \a [selected_option] with the next thing you put in. Try putting several ingredients in a container!</span>")

/obj/machinery/appliance/cooker/oven/AltClick(var/mob/user)
	try_toggle_door(user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)

/obj/machinery/appliance/cooker/oven/CtrlClick(var/mob/user)
	choose_output()
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)

/obj/machinery/appliance/cooker/oven/verb/toggle_door()
	set src in oview(1)
	set category = "Object"
	set name = "Open/close oven door"

	try_toggle_door(usr)

/obj/machinery/appliance/cooker/oven/proc/try_toggle_door(mob/user)
	if(!can_use_check(user, TRUE))
		return

	if (open)
		open = FALSE
		loss = (active_power_usage / resistance)*0.5
	else
		open = TRUE
		loss = (active_power_usage / resistance)*4
		//When the oven door is opened, heat is lost MUCH faster

	playsound(src, 'sound/machines/hatch_open.ogg', 20, 1)
	update_icon()

/obj/machinery/appliance/cooker/oven/can_insert(var/obj/item/I, var/mob/user)
	if (!open)
		to_chat(user, "<span class='warning'>You can't put anything in while the door is closed!</span>")
		return FALSE

	else
		return ..()

//If an oven's door is open it will lose heat every proc, even if it also gained it
//But dont call equalize twice in one stack. A return value of -1 from the parent indicates equalize was already called
/obj/machinery/appliance/cooker/oven/heat_up()
	.=..()
	if (open && . != -1)
		var/turf/T = get_turf(src)
		if (temperature > T.temperature)
			equalize_temperature()

/obj/machinery/appliance/cooker/oven/can_remove_items(var/mob/user)
	if (!open)
		to_chat(user, "<span class='warning'>You can't take anything out while the door is closed!</span>")
		return FALSE

	else
		return ..()


//Oven has lots of recipes and combine options. The chance for interference is high, so
//If a combine target is set the oven will do it instead of checking recipes
/obj/machinery/appliance/cooker/oven/finish_cooking(var/datum/cooking_item/CI)
	if(CI.combine_target)
		CI.result_type = 3//Combination type. We're making something out of our ingredients
		combination_cook(CI)
		return
	else
		..()
