// Base type for cooking machines
// Contributes to a food's cooking timer. That's basically it.
/obj/machinery/cooking
	name = "generic food cooking machine"
	desc = "A food cooking machine that cooks food. Generically. You shouldn't be seeing this!"
	icon = 'icons/obj/cooking_machines.dmi'
	icon_state = "grill_off"

	density = 1
	anchored = 1
	default_unanchor = 5 SECONDS

	use_power = 0
	idle_power_usage = 5			// Power used when turned on, but not processing anything
	active_power_usage = 1000		// Power used when turned on and actively cooking something

	speed_process = PROCESS_ON_SSPROCESSING

	var/cooker_type = METHOD_OVEN
	var/cooking_power = 0

	var/max_contents = 2			// Maximum number of things this appliance can simultaneously cook
	var/on_icon						// Icon state used when cooking.
	var/off_icon					// Icon state used when not cooking.


	var/list/food_containers //what food (/obj/item/reagent_containers/food_holder, /reagent_containers/snacks/ingredient) we are cooking

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
	visible_message("[src] processes silently...")
	if(cooking_power > 0)
		visible_message("[src] processes loudly...")
		for(var/obj/item/reagent_containers/food_holder/FH in food_containers)
			visible_message("[src] processes a food holder [FH]...")
			FH.tick_heat(1 SECOND, cooking_power, cooker_type)
		for(var/obj/item/reagent_containers/food/snacks/ingredient/I in food_containers)
			visible_message("[src] processes a lone ingredient [I]...")
			I.process_cooked(1 SECOND, cooking_power, cooker_type)

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

	if(istype(I, /obj/item/reagent_containers/food_holder) || istype(I, /obj/item/reagent_containers/food/snacks/ingredient))
		//From here we can start cooking food
		insert_item(I, user)
		update_icon()

/obj/machinery/cooking/proc/insert_item(obj/item/I, mob/user)
	if(!user.attempt_insert_item_for_installation(I, src))
		return
	food_containers += I
	user.visible_message("<span class='notice'>[user] puts [I] into [src].</span>", "<span class='notice'>You put [I] into [src].</span>")


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
	for(var/obj/item/reagent_containers/food_holder/FH in food_containers)
		if(counter)
			removables["[FH.name] ([counter])"] = FH
		else
			removables[FH.name] = FH
		counter++
	var/remove_item = removables[1]
	to_chat(user, "You attempt remove [remove_item] from [src]")
	if(LAZYLEN(food_containers ) > 1)
		remove_item = input(user, "What to remove?", "Remove from cooker", null) as null|anything in removables
	if(remove_item)
		food_containers -= removables[remove_item]
		user.put_in_hands_or_drop(removables[remove_item])
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
			icon_state = "grill_off"
		if("low")
			if(machine_stat & POWEROFF)
				machine_stat &= ~POWEROFF
				use_power = TRUE
				user.visible_message("[user] turns [src] on.", "You turn on [src].")
			user.visible_message("[user] turns [src] to low power.", "You turn [src] to low power.")
			cooking_power = HEAT_LOW
			icon_state = "grill_on"
		if("medium")
			if(machine_stat & POWEROFF)
				machine_stat &= ~POWEROFF
				use_power = TRUE
				user.visible_message("[user] turns [src] on.", "You turn on [src].")
			user.visible_message("[user] turns [src] to low power.", "You turn [src] to medium power.")
			cooking_power = HEAT_MID
			icon_state = "grill_on"
		if("high")
			if(machine_stat & POWEROFF)
				machine_stat &= ~POWEROFF
				use_power = TRUE
				user.visible_message("[user] turns [src] on.", "You turn on [src].")
			user.visible_message("[user] turns [src] to low power.", "You turn [src] to high power.")
			cooking_power = HEAT_HIGH
			icon_state = "grill_on"
		

	playsound(src, 'sound/machines/click.ogg', 40, 1)
	update_icon()
