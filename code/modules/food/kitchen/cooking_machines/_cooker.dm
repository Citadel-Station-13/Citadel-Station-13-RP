<<<<<<< HEAD
/obj/machinery/appliance/cooker
	var/temperature = T20C
	var/min_temp = 80 + T0C	//Minimum temperature to do any cooking
	var/optimal_temp = 200 + T0C	//Temperature at which we have 100% efficiency. efficiency is lowered on either side of this
	var/optimal_power = 0.1//cooking power at 100%

	var/loss = 1	//Temp lost per proc when equalising
	var/resistance = 320000	//Resistance to heating. combines with active power usage to determine how long heating takes

	var/light_x = 0
	var/light_y = 0
	cooking_power = 0

/obj/machinery/appliance/cooker/examine(var/mob/user)
	. = ..()
	if (.)	//no need to duplicate adjacency check
		if (!stat)
			if (temperature < min_temp)
				to_chat(user, span("warning", "\The [src] is still heating up and is too cold to cook anything yet."))
=======
// This folder contains code that was originally ported from Apollo Station and then refactored/optimized/changed.

// Tracks precooked food to stop deep fried baked grilled grilled grilled diona nymph cereal.
/obj/item/weapon/reagent_containers/food/snacks/var/list/cooked

// Root type for cooking machines. See following files for specific implementations.
/obj/machinery/cooker
	name = "cooker"
	desc = "You shouldn't be seeing this!"
	icon = 'icons/obj/cooking_machines.dmi'
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 5

	var/on_icon						// Icon state used when cooking.
	var/off_icon					// Icon state used when not cooking.
	var/cooking						// Whether or not the machine is currently operating.
	var/cook_type					// A string value used to track what kind of food this machine makes.
	var/cook_time = 200				// How many ticks the cooking will take.
	var/can_cook_mobs				// Whether or not this machine accepts grabbed mobs.
	var/food_color					// Colour of resulting food item.
	var/cooked_sound				// Sound played when cooking completes.
	var/can_burn_food				// Can the object burn food that is left inside?
	var/burn_chance = 10			// How likely is the food to burn?
	var/obj/item/cooking_obj		// Holder for the currently cooking object.

	// If the machine has multiple output modes, define them here.
	var/selected_option
	var/list/output_options = list()

/obj/machinery/cooker/Destroy()
	if(cooking_obj)
		qdel(cooking_obj)
		cooking_obj = null
	return ..()

/obj/machinery/cooker/proc/set_cooking(new_setting)
	cooking = new_setting
	icon_state = new_setting ? on_icon : off_icon

/obj/machinery/cooker/examine()
	..()
	if(cooking_obj && Adjacent(usr))
		usr << "You can see \a [cooking_obj] inside."

/obj/machinery/cooker/attackby(var/obj/item/I, var/mob/user)

	if(!cook_type || (stat & (NOPOWER|BROKEN)))
		user << "<span class='warning'>\The [src] is not working.</span>"
		return

	if(cooking)
		user << "<span class='warning'>\The [src] is running!</span>"
		return

	if(default_unfasten_wrench(user, I, 20))
		return

	// We are trying to cook a grabbed mob.
	var/obj/item/weapon/grab/G = I
	if(istype(G))

		if(!can_cook_mobs)
			user << "<span class='warning'>That's not going to fit.</span>"
			return

		if(!isliving(G.affecting))
			user << "<span class='warning'>You can't cook that.</span>"
			return

		cook_mob(G.affecting, user)
		return

	// We're trying to cook something else. Check if it's valid.
	var/obj/item/weapon/reagent_containers/food/snacks/check = I
	if(istype(check) && islist(check.cooked) && (cook_type in check.cooked))
		user << "<span class='warning'>\The [check] has already been [cook_type].</span>"
		return 0
	else if(istype(check, /obj/item/weapon/reagent_containers/glass))
		user << "<span class='warning'>That would probably break [src].</span>"
		return 0
	else if(istype(check, /obj/item/weapon/disk/nuclear))
		user << "Central Command would kill you if you [cook_type] that."
		return 0
	else if(!istype(check) && !istype(check, /obj/item/weapon/holder) && !istype(check, /obj/item/organ)) //Gripper check has to go here, else it still just cuts it off. ~Mechoid
		// Is it a borg using a gripper?
		if(istype(check, /obj/item/weapon/gripper)) // Grippers. ~Mechoid.
			var/obj/item/weapon/gripper/B = check	//B, for Borg.
			if(!B.wrapped)
				user << "\The [B] is not holding anything."
				return 0
>>>>>>> 8b08e45... Merge pull request #4838 from VOREStation/master
			else
				to_chat(user, span("notice", "It is running at [round(get_efficiency(), 0.1)]% efficiency!"))
			to_chat(user, "Temperature: [round(temperature - T0C, 0.1)]C / [round(optimal_temp - T0C, 0.1)]C")
		else
<<<<<<< HEAD
			to_chat(user, span("warning", "It is switched off."))

/obj/machinery/appliance/cooker/list_contents(var/mob/user)
	if (cooking_objs.len)
		var/string = "Contains...</br>"
		var/num = 0
		for (var/a in cooking_objs)
			num++
			var/datum/cooking_item/CI = a
			if (CI && CI.container)
				string += "- [CI.container.label(num)], [report_progress(CI)]</br>"
		to_chat(user, string)
	else
		to_chat(user, span("notice","It is empty."))

/obj/machinery/appliance/cooker/proc/get_efficiency()
	//RefreshParts()
	return (cooking_power / optimal_power) * 100

/obj/machinery/appliance/cooker/New()
	. = ..()
	loss = (active_power_usage / resistance)*0.5
	cooking_objs = list()
	for (var/i = 0, i < max_contents, i++)
		cooking_objs.Add(new /datum/cooking_item/(new container_type(src)))
	cooking = 0

	update_icon() // this probably won't cause issues, but Aurora used SSIcons and queue_icon_update() instead

/obj/machinery/appliance/cooker/update_icon()
	cut_overlays()
	var/image/light
	if (use_power == 2 && !stat)
		light = image(icon, "light_on")
	else
		light = image(icon, "light_off")
	light.pixel_x = light_x
	light.pixel_y = light_y
	add_overlay(light)

/obj/machinery/appliance/cooker/process()
	if (!stat)
		heat_up()
	else
		var/turf/T = get_turf(src)
		if (temperature > T.temperature)
			equalize_temperature()
	..()

/obj/machinery/appliance/cooker/power_change()
	. = ..()
	update_icon() // this probably won't cause issues, but Aurora used SSIcons and queue_icon_update() instead
=======
			user << "<span class='warning'>That's not edible.</span>"
			return 0

	if(istype(I, /obj/item/organ))
		var/obj/item/organ/O = I
		if(O.robotic)
			user << "<span class='warning'>That would probably break [src].</span>"
			return

	// Gotta hurt.
	if(istype(cooking_obj, /obj/item/weapon/holder))
		for(var/mob/living/M in cooking_obj.contents)
			M.apply_damage(rand(30,40), BURN, "chest")

	// Not sure why a food item that passed the previous checks would fail to drop, but safety first. (Hint: Borg grippers. That is why. ~Mechoid.)
	if(!user.unEquip(I) && !istype(user,/mob/living/silicon/robot))
		return

	// We can actually start cooking now.
	user.visible_message("<span class='notice'>\The [user] puts \the [I] into \the [src].</span>")
	cooking_obj = I
	cooking_obj.forceMove(src)
	set_cooking(TRUE)
	icon_state = on_icon

	// Doop de doo. Jeopardy theme goes here.
	sleep(cook_time)

	// Sanity checks.
	if(!cooking_obj || cooking_obj.loc != src)
		cooking_obj = null
		icon_state = off_icon
		set_cooking(FALSE)
		return

	// RIP slow-moving held mobs.
	if(istype(cooking_obj, /obj/item/weapon/holder))
		for(var/mob/living/M in cooking_obj.contents)
			M.death()
			qdel(M)

	// Cook the food.
	var/cook_path
	if(selected_option && output_options.len)
		cook_path = output_options[selected_option]
	if(!cook_path)
		cook_path = /obj/item/weapon/reagent_containers/food/snacks/variable
	var/obj/item/weapon/reagent_containers/food/snacks/result = new cook_path(src) //Holy typepaths, Batman.

	// Set icon and appearance.
	change_product_appearance(result)

	// Update strings.
	change_product_strings(result)

	// Copy reagents over. trans_to_obj must be used, as trans_to fails for snacks due to is_open_container() failing.
	if(cooking_obj.reagents && cooking_obj.reagents.total_volume)
		cooking_obj.reagents.trans_to_obj(result, cooking_obj.reagents.total_volume)

	// Set cooked data.
	var/obj/item/weapon/reagent_containers/food/snacks/food_item = cooking_obj
	if(istype(food_item) && islist(food_item.cooked))
		result.cooked = food_item.cooked.Copy()
	else
		result.cooked = list()
	result.cooked |= cook_type

	// Reset relevant variables.
	qdel(cooking_obj)
	src.visible_message("<span class='notice'>\The [src] pings!</span>")
	if(cooked_sound)
		playsound(get_turf(src), cooked_sound, 50, 1)

	if(!can_burn_food)
		icon_state = off_icon
		set_cooking(FALSE)
		result.forceMove(get_turf(src))
		cooking_obj = null
	else
		var/failed
		var/overcook_period = max(FLOOR(cook_time/5, 1),1)
		cooking_obj = result
		var/count = overcook_period
		while(1)
			sleep(overcook_period)
			count += overcook_period
			if(!cooking || !result || result.loc != src)
				failed = 1
			else if(prob(burn_chance) || count == cook_time)	//Fail before it has a chance to cook again.
				// You dun goofed.
				qdel(cooking_obj)
				cooking_obj = new /obj/item/weapon/reagent_containers/food/snacks/badrecipe(src)
				// Produce nasty smoke.
				visible_message("<span class='danger'>\The [src] vomits a gout of rancid smoke!</span>")
				var/datum/effect/effect/system/smoke_spread/bad/smoke = new /datum/effect/effect/system/smoke_spread/bad()
				smoke.attach(src)
				smoke.set_up(10, 0, usr.loc)
				smoke.start()
				failed = 1

			if(failed)
				set_cooking(FALSE)
				icon_state = off_icon
				break

/obj/machinery/cooker/attack_hand(var/mob/user)

	if(cooking_obj && user.Adjacent(src)) //Fixes borgs being able to teleport food in these machines to themselves.
		user << "<span class='notice'>You grab \the [cooking_obj] from \the [src].</span>"
		user.put_in_hands(cooking_obj)
		set_cooking(FALSE)
		cooking_obj = null
		icon_state = off_icon
		return
>>>>>>> 8b08e45... Merge pull request #4838 from VOREStation/master

/obj/machinery/appliance/cooker/proc/update_cooking_power()
	var/temp_scale = 0
	if(temperature > min_temp)

		temp_scale = (temperature - min_temp) / (optimal_temp - min_temp)
		//If we're between min and optimal this will yield a value in the range 0-1

		if (temp_scale > 1)
			//We're above optimal, efficiency goes down as we pass too much over it
			if (temp_scale >= 2)
				temp_scale = 0
			else
				temp_scale = 1 - (temp_scale - 1)


	cooking_power = optimal_power * temp_scale
	//RefreshParts()

/obj/machinery/appliance/cooker/proc/heat_up()
	if (temperature < optimal_temp)
		if (use_power == 1 && ((optimal_temp - temperature) > 5))
			playsound(src, 'sound/machines/click.ogg', 20, 1)
			use_power = 2.//If we're heating we use the active power
			update_icon()
		temperature += active_power_usage / resistance
		update_cooking_power()
		return 1
	else
		if (use_power == 2)
			use_power = 1
			playsound(src, 'sound/machines/click.ogg', 20, 1)
			update_icon()
		//We're holding steady. temperature falls more slowly
		if (prob(25))
			equalize_temperature()
			return -1

/obj/machinery/appliance/cooker/proc/equalize_temperature()
	temperature -= loss//Temperature will fall somewhat slowly
	update_cooking_power()

//Cookers do differently, they use containers
/obj/machinery/appliance/cooker/has_space(var/obj/item/I)
	if (istype(I, /obj/item/weapon/reagent_containers/cooking_container))
		//Containers can go into an empty slot
		if (cooking_objs.len < max_contents)
			return 1
	else
		//Any food items directly added need an empty container. A slot without a container cant hold food
		for (var/datum/cooking_item/CI in cooking_objs)
			if (CI.container.check_contents() == 0)
				return CI

	return 0

/obj/machinery/appliance/cooker/add_content(var/obj/item/I, var/mob/user)
	var/datum/cooking_item/CI = ..()
	if (CI && CI.combine_target)
		to_chat(user, "\The [I] will be used to make a [selected_option]. Output selection is returned to default for future items.")
		selected_option = null
