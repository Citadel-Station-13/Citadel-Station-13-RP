// Use this define to register something as a creatable!
// * n - The proper name of the purchasable
// * o - The object type path of the purchasable to spawn
// * r - The amount to dispense
// * p - The price of the purchasable in biomass
#define BIOGEN_ITEM(n, o, r, p) n = new /datum/data/biogenerator_item(n, o, r, p)

// Use this define to register something as dispensable
// * n - The proper name of the purchasable
// * o - The reagent ID
// * r - The amount of reagent to dispense
// * p - The price of the purchasable in biomass
#define BIOGEN_REAGENT(n, o, r, p) n = new /datum/data/biogenerator_reagent(n, o, r, p)

/obj/machinery/biogenerator
	name = "biogenerator"
	desc = "Converts plants into biomass, which can be used for fertilizer and sort-of-synthetic products."
	icon = 'icons/obj/biogenerator.dmi'
	icon_state = "biogen"
	base_icon_state = "biogen"
	density = TRUE
	anchored = TRUE
	circuit = /obj/item/circuitboard/biogenerator
	use_power = USE_POWER_IDLE
	idle_power_usage = 40
	var/processing = FALSE	//Are we currently processing?
	var/obj/item/reagent_containers/glass/beaker = null
	var/points = 0
	var/build_eff = 1
	var/eat_eff = 1

	var/list/item_list

/datum/data/biogenerator_item
	var/equipment_path = null
	var/equipment_amt = 1
	var/cost = 0

/datum/data/biogenerator_item/New(name, path, amt, cost)
	src.name = name
	src.equipment_path = path
	src.equipment_amt = amt
	src.cost = cost

/datum/data/biogenerator_reagent
	var/reagent_id = null
	var/reagent_amt = 0
	var/cost = 0

/datum/data/biogenerator_reagent/New(name, id, amt, cost)
	src.name = name
	src.reagent_id = id
	src.reagent_amt = amt
	src.cost = cost


/obj/machinery/biogenerator/Initialize(mapload, newdir)
	. = ..()
	var/datum/reagents/R = new/datum/reagents(1000)
	reagents = R
	R.my_atom = src

	beaker = new /obj/item/reagent_containers/glass/bottle(src)
	default_apply_parts()

	item_list = list()
	item_list["Food Items"] = list(
		BIOGEN_REAGENT("10 milk", "milk", 10, 20),
		BIOGEN_REAGENT("50 milk", "milk", 50, 95),
		BIOGEN_REAGENT("10 Cream", "cream", 10, 30),
		BIOGEN_REAGENT("50 Cream", "cream", 50, 120),
		BIOGEN_ITEM("Slab of meat", /obj/item/reagent_containers/food/snacks/meat, 1, 50),
		BIOGEN_ITEM("5 slabs of meat", /obj/item/reagent_containers/food/snacks/meat, 5, 250),
	)
	item_list["Cooking Ingredients"] = list(
		BIOGEN_REAGENT("10 Universal Enzyme", "enzyme", 10, 30),
		BIOGEN_REAGENT("50 Universal Enzyme", "enzyme", 50, 120),
		BIOGEN_ITEM("Nutri-spread", /obj/item/reagent_containers/food/snacks/spreads, 1, 30),
		BIOGEN_ITEM("5 nutri-spread", /obj/item/reagent_containers/food/snacks/spreads, 5, 120),
	)
	item_list["Gardening Nutrients"] = list(
		BIOGEN_ITEM("E-Z-Nutrient", /obj/item/reagent_containers/glass/bottle/eznutrient, 1, 60),
		BIOGEN_ITEM("5 E-Z-Nutrient", /obj/item/reagent_containers/glass/bottle/eznutrient, 5, 300),
		BIOGEN_ITEM("Left 4 Zed", /obj/item/reagent_containers/glass/bottle/left4zed, 1, 120),
		BIOGEN_ITEM("5 Left 4 Zed", /obj/item/reagent_containers/glass/bottle/left4zed, 5, 600),
		BIOGEN_ITEM("Robust Harvest", /obj/item/reagent_containers/glass/bottle/robustharvest, 1, 150),
		BIOGEN_ITEM("5 Robust Harvest", /obj/item/reagent_containers/glass/bottle/robustharvest, 5, 750),
	)
	item_list["Leather Products"] = list(
		BIOGEN_ITEM("Leather Sheet", /obj/item/stack/material/leather, 1, 20),
		BIOGEN_ITEM("5 Leather Sheets", /obj/item/stack/material/leather, 5, 100),
		BIOGEN_ITEM("Wallet", /obj/item/storage/wallet, 1, 100),
		BIOGEN_ITEM("Botanical gloves", /obj/item/clothing/gloves/botanic_leather, 1, 250),
		BIOGEN_ITEM("Plant bag", /obj/item/storage/bag/plants, 1, 320),
		BIOGEN_ITEM("Large plant bag", /obj/item/storage/bag/plants/large, 1, 640),
		BIOGEN_ITEM("Utility belt", /obj/item/storage/belt/utility, 1, 300),
		BIOGEN_ITEM("Leather Satchel", /obj/item/storage/backpack/satchel, 1, 400),
		BIOGEN_ITEM("Cash Bag", /obj/item/storage/bag/cash, 1, 400),
		BIOGEN_ITEM("Chemistry Bag", /obj/item/storage/bag/chemistry, 1, 400),
		BIOGEN_ITEM("Workboots", /obj/item/clothing/shoes/boots/workboots, 1, 400),
		BIOGEN_ITEM("Leather Chaps", /obj/item/clothing/under/pants/chaps, 1, 400),
		BIOGEN_ITEM("Leather Coat", /obj/item/clothing/suit/leathercoat, 1, 500),
		BIOGEN_ITEM("Leather Jacket", /obj/item/clothing/suit/storage/toggle/brown_jacket, 1, 500),
		BIOGEN_ITEM("Winter Coat", /obj/item/clothing/suit/storage/hooded/wintercoat, 1, 500),
		BIOGEN_ITEM("4 Algae Sheets", /obj/item/stack/material/algae, 4, 400),
		BIOGEN_ITEM("50 Algae Sheets", /obj/item/stack/material/algae, 50, 5000),
	)

/*
 * Insert a new beaker into the biogenerator, replacing/swapping our current beaker if there is one.
 *
 * user - the mob inserting the beaker
 * inserted_beaker - the beaker we're inserting into the biogen
 */
/obj/machinery/biogenerator/proc/insert_beaker(mob/living/user, obj/item/reagent_containers/glass/inserted_beaker)
	if(!can_interact(user))
		return
	if(!user.attempt_insert_item_for_installation(inserted_beaker, src))
		return

	if(beaker)
		to_chat(user, SPAN_NOTICE("You swap out [beaker] in [src] for [inserted_beaker]."))
		eject_beaker(user, silent = TRUE)
	else
		to_chat(user, SPAN_NOTICE("You add [inserted_beaker] to [src]."))

	beaker = inserted_beaker
	update_appearance()

/*
 * Eject the current stored beaker either into the user's hands or onto the ground.
 *
 * user - the mob ejecting the beaker
 * silent - whether to give a message to the user that the beaker was ejected.
 */
/obj/machinery/biogenerator/proc/eject_beaker(mob/living/user, silent = FALSE)
	if(!beaker)
		return

	if(!can_interact(user))
		return

	if(user.put_in_hands(beaker))
		if(!silent)
			to_chat(user, SPAN_NOTICE("You eject [beaker] from [src]."))
	else
		if(!silent)
			to_chat(user, SPAN_NOTICE("You eject [beaker] from [src] onto the ground."))
		beaker.forceMove(drop_location())

	beaker = null
	update_appearance()

/obj/machinery/biogenerator/ui_status(mob/user)
	if(machine_stat & BROKEN || panel_open)
		return UI_CLOSE
	return ..()

/obj/machinery/biogenerator/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Biogenerator", name)
		ui.open()

/obj/machinery/biogenerator/ui_data(mob/user)
	var/list/data = ..()

	data["build_eff"] = build_eff
	data["points"] = points
	data["processing"] = processing
	data["beaker"] = !!beaker

	return data

/obj/machinery/biogenerator/ui_static_data(mob/user)
	var/list/static_data[0]

	// Available items - in static data because we don't wanna compute this list every time! It hardly changes.
	static_data["items"] = list()
	for(var/cat in item_list)
		var/list/cat_items = list()
		for(var/prize_name in item_list[cat])
			var/datum/data/biogenerator_reagent/prize = item_list[cat][prize_name]
			cat_items[prize_name] = list("name" = prize_name, "price" = prize.cost, "reagent" = istype(prize))
		static_data["items"][cat] = cat_items

	return static_data

/obj/machinery/biogenerator/ui_act(action, list/params)
	. = ..()
	if(.)
		return

	switch(action)
		if("activate")
			INVOKE_ASYNC(src, .proc/activate)
			return TRUE
		if("detach")
			eject_beaker(usr)
			return TRUE
		if("purchase")
			var/category = params["cat"]
			var/name = params["name"]

			if(!(category in item_list) || !(name in item_list[category])) // Not trying something that's not in the list, are you?
				return

			var/datum/data/biogenerator_item/bi = item_list[category][name]
			if(!istype(bi))
				var/datum/data/biogenerator_reagent/br = item_list[category][name]
				if(!istype(br))
					return
				if(!beaker)
					return
				var/cost = round(br.cost / build_eff)
				if(cost > points)
					to_chat(usr, SPAN_DANGER("Insufficient biomass."))
					return
				var/amt_to_actually_dispense = round(min(beaker.reagents.get_free_space(), br.reagent_amt))
				if(amt_to_actually_dispense <= 0)
					to_chat(usr, SPAN_DANGER("The loaded beaker is full!"))
					return
				points -= (cost * (amt_to_actually_dispense / br.reagent_amt))
				beaker.reagents.add_reagent(br.reagent_id, amt_to_actually_dispense)
				playsound(src, 'sound/machines/reagent_dispense.ogg', 25, 1)
				return

			var/cost = round(bi.cost / build_eff)
			if(cost > points)
				to_chat(usr, SPAN_DANGER("Insufficient biomass."))
				return

			points -= cost
			if(ispath(bi.equipment_path, /obj/item/stack))
				var/obj/item/stack/S = new bi.equipment_path(loc)
				S.amount = bi.equipment_amt
				playsound(src, 'sound/machines/vending/vending_drop.ogg', 100, 1)
				return TRUE

			for(var/i in 1 to bi.equipment_amt)
				new bi.equipment_path(loc)
				playsound(src, 'sound/machines/vending/vending_drop.ogg', 100, 1)
			return TRUE
		else
			return FALSE

/obj/machinery/biogenerator/on_reagent_change() //When the reagents change, change the icon as well.
	update_appearance()

/obj/machinery/biogenerator/update_icon()
	cut_overlays()
	if(beaker)
		add_overlay("[base_icon_state]-standby")
		if(processing)
			add_overlay("[base_icon_state]-work")

/obj/machinery/biogenerator/attackby(obj/item/O, mob/user)
	if(default_deconstruction_screwdriver(user, O))
		return
	if(default_deconstruction_crowbar(user, O))
		return
	if(default_part_replacement(user, O))
		return
	if(default_unfasten_wrench(user, O, 40))
		return
	if(istype(O, /obj/item/reagent_containers/glass))
		if(beaker)
			to_chat(user, SPAN_NOTICE("\The [src] is already loaded."))
		else
			if(!user.attempt_insert_item_for_installation(O, src))
				return
			beaker = FALSE
			SStgui.update_uis(src)
	else if(processing)
		to_chat(user, SPAN_NOTICE("\The [src] is currently processing."))
	else if(istype(O, /obj/item/storage/bag))
		var/i = 0
		for(var/obj/item/reagent_containers/food/snacks/grown/G in contents)
			i++
		if(i >= 10)
			to_chat(user, SPAN_NOTICE("\The [src] is already full! Activate it."))
		else
			for(var/obj/item/reagent_containers/food/snacks/grown/G in O.contents)
				G.loc = src
				i++
				if(i >= 10)
					to_chat(user, SPAN_NOTICE("You fill \the [src] to its capacity."))
					break
			if(i < 10)
				to_chat(user, SPAN_NOTICE("You empty \the [O] into \the [src]."))


	else if(!istype(O, /obj/item/reagent_containers/food/snacks/grown))
		to_chat(user, SPAN_NOTICE("You cannot put this in \the [src]."))
	else
		var/i = 0
		for(var/obj/item/reagent_containers/food/snacks/grown/G in contents)
			i++
		if(i >= 10)
			to_chat(user, SPAN_NOTICE("\The [src] is full! Activate it."))
		else
			if(!user.attempt_insert_item_for_installation(O, src))
				return
			to_chat(user, SPAN_NOTICE("You put \the [O] in \the [src]"))
	update_appearance()

/obj/machinery/biogenerator/proc/activate()
	if(usr.stat)
		return
	if(machine_stat) //NOPOWER etc
		return
	if(processing)
		to_chat(usr, SPAN_NOTICE("The biogenerator is in the process of working."))
		return
	var/S = 0
	for(var/obj/item/reagent_containers/food/snacks/grown/I in contents)
		S += 5
		if(I.reagents.get_reagent_amount("nutriment") < 0.1)
			points += 1
		else points += I.reagents.get_reagent_amount("nutriment") * 10 * eat_eff
		qdel(I)
	if(S)
		processing = TRUE
		update_appearance()
		playsound(src.loc, 'sound/machines/blender.ogg', 40, TRUE)
		use_power(S * 30)
		sleep((S + 15) / eat_eff)
		processing = FALSE
		SStgui.update_uis(src)
		playsound(src.loc, 'sound/machines/biogenerator_end.ogg', 40, TRUE)
		update_appearance()
	else
		to_chat(usr, SPAN_WARNING("Error: No growns inside. Please insert growns."))
	return

/obj/machinery/biogenerator/RefreshParts()
	..()
	var/man_rating = 0
	var/bin_rating = 0

	for(var/obj/item/stock_parts/P in component_parts)
		if(istype(P, /obj/item/stock_parts/matter_bin))
			bin_rating += P.rating
		if(istype(P, /obj/item/stock_parts/manipulator))
			man_rating += P.rating

	build_eff = man_rating
	eat_eff = bin_rating
