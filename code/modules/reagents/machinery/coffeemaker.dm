#define BEAN_CAPACITY 10 //amount of coffee beans that can fit inside the coffeemaker

/obj/machinery/coffeemaker
	name = "coffeemaker"
	desc = "A Modello 3 Coffeemaker that brews coffee and holds it at the perfect temperature of 176 fahrenheit. Made by Piccionaia Home Appliances."
	icon = 'icons/obj/medical/chemical.dmi'
	icon_state = "coffeemaker_nopot_nocart"
	base_icon_state = "coffeemaker"
	circuit = /obj/item/circuitboard/machine/coffeemaker
	interaction_flags_machine = parent_type::interaction_flags_machine | INTERACT_MACHINE_OFFLINE
	var/obj/item/reagent_containers/food/drinks/coffeepot/coffeepot = null
	var/brewing = FALSE
	var/brew_time = 20 SECONDS
	var/speed = 1
	/// The coffee cartridge to make coffee from. In the future, coffee grounds are like printer ink.
	var/obj/item/coffee_cartridge/cartridge = null
	/// The type path to instantiate for the coffee cartridge the device initially comes with, eg. /obj/item/coffee_cartridge
	var/initial_cartridge = /obj/item/coffee_cartridge
	/// The number of cups left
	var/coffee_cups = 15
	var/max_coffee_cups = 15
	/// The amount of sugar packets left
	var/sugar_packs = 10
	var/max_sugar_packs = 10
	/// The amount of sweetener packets left
	var/sweetener_packs = 10
	var/max_sweetener_packs = 10
	/// The amount of creamer packets left
	var/creamer_packs = 10
	var/max_creamer_packs = 10

	var/static/radial_examine = image(icon = 'icons/hud/radial.dmi', icon_state = "radial_examine")
	var/static/radial_brew = image(icon = 'icons/hud/radial_coffee.dmi', icon_state = "radial_brew")
	var/static/radial_eject_pot = image(icon = 'icons/hud/radial_coffee.dmi', icon_state = "radial_eject_pot")
	var/static/radial_eject_cartridge = image(icon = 'icons/hud/radial_coffee.dmi', icon_state = "radial_eject_cartridge")
	var/static/radial_take_cup = image(icon = 'icons/hud/radial_coffee.dmi', icon_state = "radial_take_cup")
	var/static/radial_take_sugar = image(icon = 'icons/hud/radial_coffee.dmi', icon_state = "radial_take_sugar")
	var/static/radial_take_sweetener = image(icon = 'icons/hud/radial_coffee.dmi', icon_state = "radial_take_sweetener")
	var/static/radial_take_creamer = image(icon = 'icons/hud/radial_coffee.dmi', icon_state = "radial_take_creamer")

/obj/machinery/coffeemaker/Initialize(mapload)
	. = ..()
	if(mapload)
		coffeepot = new /obj/item/reagent_containers/food/drinks/coffeepot(src)
		cartridge = new /obj/item/coffee_cartridge(src)

/obj/machinery/coffeemaker/deconstructed(disassembled)
	coffeepot?.forceMove(drop_location())
	cartridge?.forceMove(drop_location())

/obj/machinery/coffeemaker/Destroy()
	QDEL_NULL(coffeepot)
	QDEL_NULL(cartridge)
	return ..()

/obj/machinery/coffeemaker/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone == coffeepot)
		coffeepot = null
		update_appearance(UPDATE_OVERLAYS)
	if(gone == cartridge)
		cartridge = null
		update_appearance(UPDATE_OVERLAYS)

/obj/machinery/coffeemaker/RefreshParts()
	. = ..()
	speed = 0
	for(var/obj/item/stock_parts/micro_laser/laser in component_parts)
		speed += laser.rating

/obj/machinery/coffeemaker/examine(mob/user)
	. = ..()
	if(!in_range(user, src) && !issilicon(user) && !isobserver(user))
		. += SPAN_WARNING("You're too far away to examine [src]'s contents and display!")
		return

	if(brewing)
		. += SPAN_WARNING("\The [src] is brewing.")
		return

	if(panel_open)
		. += SPAN_NOTICE("[src]'s maintenance hatch is open!")
		return

	if(coffeepot || cartridge)
		. += SPAN_NOTICE("\The [src] contains:")
		if(coffeepot)
			. += SPAN_NOTICE("- \A [coffeepot].")
		if(cartridge)
			. += SPAN_NOTICE("- \A [cartridge].")
		return

	if(!(machine_stat & (NOPOWER|BROKEN)))
		. += "[SPAN_NOTICE("The status display reads:")]\n"+\
		SPAN_NOTICE("- Brewing coffee at <b>[speed*100]%</b>.")
		if(coffeepot)
			for(var/id as anything in coffeepot.reagents.reagent_volumes)
				. += SPAN_NOTICE("- [coffeepot.reagents.reagent_volumes[id]] units of coffee in pot.")
		if(cartridge)
			if(cartridge.charges < 1)
				. += SPAN_NOTICE("- grounds cartridge is empty.")
			else
				. += SPAN_NOTICE("- grounds cartridge has [cartridge.charges] charges remaining.")

	if (coffee_cups >= 1)
		. += SPAN_NOTICE("There [coffee_cups == 1 ? "is" : "are"] [coffee_cups] coffee cup[coffee_cups != 1 && "s"] left.")
	else
		. += SPAN_NOTICE("There are no cups left.")

	if (sugar_packs >= 1)
		. += SPAN_NOTICE("There [sugar_packs == 1 ? "is" : "are"] [sugar_packs] packet[sugar_packs != 1 && "s"] of sugar left.")
	else
		. += SPAN_NOTICE("There is no sugar left.")

	if (sweetener_packs >= 1)
		. += SPAN_NOTICE("There [sweetener_packs == 1 ? "is" : "are"] [sweetener_packs] packet[sweetener_packs != 1 && "s"] of sweetener left.")
	else
		. += SPAN_NOTICE("There is no sweetener left.")

	if (creamer_packs > 1)
		. += SPAN_NOTICE("There [creamer_packs == 1 ? "is" : "are"] [creamer_packs] packet[creamer_packs != 1 && "s"] of creamer left.")
	else
		. += SPAN_NOTICE("There is no creamer left.")

/obj/machinery/coffeemaker/AltClick(mob/user)
	..()
	if(!can_interact(user) || !user.canUseTopic(src, !issilicon(user)))
		return FALSE
	if(brewing)
		return FALSE
	replace_pot(user)
	return TRUE

/obj/machinery/coffeemaker/CtrlClick(mob/user)
	if(!can_interact(user) || !user.canUseTopic(src, !issilicon(user)))
		return FALSE
	if(brewing)
		return FALSE
	brew()

/obj/machinery/coffeemaker/update_overlays()
	. = ..()
	. += overlay_checks()

/obj/machinery/coffeemaker/proc/overlay_checks()
	. = list()
	if(coffeepot)
		if(istype(coffeepot, /obj/item/reagent_containers/food/drinks/coffeepot/bluespace))
			. += "coffeemaker_pot_bluespace"
		else
			. += "coffeemaker_pot_[coffeepot.reagents.total_volume ? "full" : "empty"]"
	if(cartridge)
		. += "coffeemaker_cartidge"
	return .

/obj/machinery/coffeemaker/proc/replace_pot(mob/living/user, obj/item/reagent_containers/food/drinks/coffeepot/new_coffeepot)
	if(!user)
		return FALSE
	if(coffeepot)
		try_put_in_hand(coffeepot, user)
	if(new_coffeepot)
		coffeepot = new_coffeepot
	update_appearance(UPDATE_OVERLAYS)
	return TRUE

/obj/machinery/coffeemaker/proc/replace_cartridge(mob/living/user, obj/item/coffee_cartridge/new_cartridge)
	if(!user)
		return FALSE
	if(cartridge)
		try_put_in_hand(cartridge, user)
	if(new_cartridge)
		cartridge = new_cartridge
	update_appearance(UPDATE_OVERLAYS)
	return TRUE

/obj/machinery/coffeemaker/wrench_act(mob/living/user, obj/item/tool)
	. = ..()
	default_unfasten_wrench(user, tool)
	return TRUE

/obj/machinery/coffeemaker/using_item_on(obj/item/attack_item, mob/living/user, params)
	//You can only screw open empty grinder
	if(!coffeepot && default_deconstruction_screwdriver(user, icon_state, icon_state, attack_item))
		return CLICKCHAIN_DO_NOT_PROPAGATE

	if(default_deconstruction_crowbar(attack_item))
		return CLICKCHAIN_DO_NOT_PROPAGATE

	if(panel_open) //Can't insert objects when its screwed open
		return CLICKCHAIN_DO_NOT_PROPAGATE

	if (istype(attack_item, /obj/item/reagent_containers/food/drinks/coffeepot) && attack_item.is_open_container())
		var/obj/item/reagent_containers/food/drinks/coffeepot/new_pot = attack_item
		. = TRUE //no afterattack
		//if(!user.transferItemToLoc(new_pot, src))
		//	return TRUE
		new_pot.forceMove(src)
		replace_pot(user, new_pot)
		update_appearance(UPDATE_OVERLAYS)
		return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING //no afterattack

	if (istype(attack_item, /obj/item/reagent_containers/food/drinks/coffee_cup) && attack_item.is_open_container())
		var/obj/item/reagent_containers/food/drinks/coffee_cup/new_cup = attack_item
		if(new_cup.reagents.total_volume > 0)
			to_chat(user, SPAN_NOTICE("The cup must be full!"))
			return CLICKCHAIN_DO_NOT_PROPAGATE
		if(coffee_cups >= max_coffee_cups)
			to_chat(user, SPAN_NOTICE("The cup holder is full!"))
			return CLICKCHAIN_DO_NOT_PROPAGATE
		attack_item.forceMove(src)
		coffee_cups++
		update_appearance(UPDATE_OVERLAYS)
		return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING //no afterattack

	if (istype(attack_item, /obj/item/reagent_containers/food/condiment/small/packet/sugar))
		var/obj/item/reagent_containers/food/condiment/small/packet/sugar/new_pack = attack_item
		if(new_pack.reagents.total_volume < new_pack.reagents.maximum_volume)
			to_chat(user, SPAN_NOTICE("The pack must be full!"))
			return CLICKCHAIN_DO_NOT_PROPAGATE
		if(sugar_packs >= max_sugar_packs)
			to_chat(user, SPAN_NOTICE("The sugar compartment is full!"))
			return CLICKCHAIN_DO_NOT_PROPAGATE
		attack_item.forceMove(src)
		sugar_packs++
		update_appearance(UPDATE_OVERLAYS)
		return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING //no afterattack

	if (istype(attack_item, /obj/item/reagent_containers/food/condiment/small/packet/creamer))
		var/obj/item/reagent_containers/food/condiment/small/packet/creamer/new_pack = attack_item
		if(new_pack.reagents.total_volume < new_pack.reagents.maximum_volume)
			to_chat(user, SPAN_NOTICE("The pack be full!"))
			return CLICKCHAIN_DO_NOT_PROPAGATE
		if(creamer_packs >= max_creamer_packs)
			to_chat(user, SPAN_NOTICE("The creamer compartment is full!"))
			return CLICKCHAIN_DO_NOT_PROPAGATE
		attack_item.forceMove(src)
		creamer_packs++
		update_appearance(UPDATE_OVERLAYS)
		return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING //no afterattack

	if (istype(attack_item, /obj/item/reagent_containers/food/condiment/small/packet/astrotame))
		var/obj/item/reagent_containers/food/condiment/small/packet/astrotame/new_pack = attack_item
		if(new_pack.reagents.total_volume < new_pack.reagents.maximum_volume)
			to_chat(user, SPAN_NOTICE("The pack must be full!"))
			return CLICKCHAIN_DO_NOT_PROPAGATE
		if(sweetener_packs >= max_sweetener_packs)
			to_chat(user, SPAN_NOTICE("The sweetener compartment is full!"))
			return CLICKCHAIN_DO_NOT_PROPAGATE
		attack_item.forceMove(src)
		sweetener_packs++
		update_appearance(UPDATE_OVERLAYS)
		return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING //no afterattack

	if (istype(attack_item, /obj/item/coffee_cartridge))
		var/obj/item/coffee_cartridge/new_cartridge = attack_item
		new_cartridge.forceMove(src)
		replace_cartridge(user, new_cartridge)
		update_appearance(UPDATE_OVERLAYS)
		return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING //no afterattack

/obj/machinery/coffeemaker/proc/try_brew()
	if(!cartridge)
		to_chat(usr, SPAN_NOTICE("There is no coffee cartridge installed!"))
		return FALSE
	if(cartridge.charges < 1)
		to_chat(usr, SPAN_NOTICE("The coffee cartridge is empty!"))
		return FALSE
	if(!coffeepot)
		to_chat(usr, SPAN_NOTICE("There's no coffeepot!"))
		return FALSE
	if(machine_stat & (NOPOWER|BROKEN))
		to_chat(usr, SPAN_NOTICE("The machnine isn't powered!"))
		return FALSE
	if(coffeepot.reagents.total_volume >= coffeepot.reagents.maximum_volume)
		to_chat(usr, SPAN_NOTICE("The coffeepot is already full!"))
		return FALSE
	return TRUE

/obj/machinery/coffeemaker/ui_interact(mob/user) // The microwave Menu //I am reasonably certain that this is not a microwave //I am positively certain that this is not a microwave
	. = ..()

	if(!can_interact(user) || !user.canUseTopic(src, !issilicon(user)))
		return FALSE
	if(brewing)
		return

	var/list/options = list()

	if(coffeepot)
		options["Eject Pot"] = radial_eject_pot

	if(cartridge)
		options["Eject Cartridge"] = radial_eject_cartridge

	options["Brew"] = radial_brew //brew is always available as an option, when the machine is unable to brew the player is told by balloon alerts whats exactly wrong

	if(coffee_cups > 0)
		options["Take Cup"] = radial_take_cup

	if(sugar_packs > 0)
		options["Take Sugar"] = radial_take_sugar

	if(sweetener_packs > 0)
		options["Take Sweetener"] = radial_take_sweetener

	if(creamer_packs > 0)
		options["Take Creamer"] = radial_take_creamer

	if(isAI(user))
		if(machine_stat & NOPOWER)
			return
		options["Examine"] = radial_examine

	var/choice

	if(length(options) < 1)
		return
	if(length(options) == 1)
		choice = options[1]
	else
		choice = show_radial_menu(user, src, options, require_near = !issilicon(user))

	// post choice verification
	if(brewing || (isAI(user) && machine_stat & NOPOWER))
		return

	switch(choice)
		if("Brew")
			brew(user)
		if("Eject Pot")
			eject_pot(user)
		if("Eject Cartridge")
			eject_cartridge(user)
		if("Examine")
			examine(user)
		if("Take Cup")
			take_cup(user)
		if("Take Sugar")
			take_sugar(user)
		if("Take Sweetener")
			take_sweetener(user)
		if("Take Creamer")
			take_creamer(user)

/obj/machinery/coffeemaker/proc/eject_pot(mob/user)
	if(coffeepot)
		replace_pot(user)

/obj/machinery/coffeemaker/proc/eject_cartridge(mob/user)
	if(cartridge)
		replace_cartridge(user)

/obj/machinery/coffeemaker/proc/take_cup(mob/user)
	if(!coffee_cups) //shouldn't happen, but we all know how stuff manages to break
		to_chat(user, SPAN_NOTICE("There are no cups left!"))
		return
	var/obj/item/reagent_containers/food/drinks/coffee_cup/new_cup = new(get_turf(src))
	user.put_in_hands(new_cup)
	coffee_cups--
	update_appearance(UPDATE_OVERLAYS)

/obj/machinery/coffeemaker/proc/take_sugar(mob/user)
	if(!sugar_packs)
		to_chat(user, SPAN_NOTICE("There is no sugar left"))
		return
	var/obj/item/reagent_containers/food/condiment/small/packet/sugar/new_pack = new(get_turf(src))
	user.put_in_hands(new_pack)
	sugar_packs--
	update_appearance(UPDATE_OVERLAYS)

/obj/machinery/coffeemaker/proc/take_sweetener(mob/user)
	if(!sweetener_packs)
		to_chat(user, SPAN_NOTICE("There is no sweetener left"))
		return
	var/obj/item/reagent_containers/food/condiment/small/packet/astrotame/new_pack = new(get_turf(src))
	user.put_in_hands(new_pack)
	sweetener_packs--
	update_appearance(UPDATE_OVERLAYS)

/obj/machinery/coffeemaker/proc/take_creamer(mob/user)
	if(!creamer_packs)
		to_chat(user, SPAN_NOTICE("There is no creamer left"))
		return
	var/obj/item/reagent_containers/food/condiment/small/packet/creamer/new_pack = new(drop_location())
	user.put_in_hands(new_pack)
	creamer_packs--
	update_appearance(UPDATE_OVERLAYS)

/obj/machinery/coffeemaker/proc/operate_for(time, silent = FALSE)
	brewing = TRUE
	if(!silent)
		playsound(src, 'sound/machines/coffeemaker_brew.ogg', 20, vary = TRUE)
	use_power(active_power_usage * time / (1 SECONDS)) // .1 needed here to convert time (in deciseconds) to seconds such that watts * seconds = joules
	addtimer(CALLBACK(src, PROC_REF(stop_operating)), time / speed)

/obj/machinery/coffeemaker/proc/stop_operating()
	brewing = FALSE

/obj/machinery/coffeemaker/proc/brew()
	power_change()
	if(!try_brew())
		return
	operate_for(brew_time)
	for(var/id in cartridge.drink_type)
		coffeepot.reagents.add_reagent(id, cartridge.drink_type[id])
	cartridge.charges--
	update_appearance(UPDATE_OVERLAYS)

//Coffee Cartridges: like toner, but for your coffee!
/obj/item/coffee_cartridge
	name = "coffeemaker cartridge- Caffè Generico"
	desc = "A coffee cartridge manufactured by Piccionaia Coffee, for use with the Modello 3 system."
	icon = 'icons/obj/food.dmi'
	icon_state = "cartridge_basic"
	var/charges = 4
	var/list/drink_type = list("coffee" = 120)

/obj/item/coffee_cartridge/examine(mob/user)
	. = ..()
	if(charges)
		. += SPAN_WARNING("The cartridge has [charges] portions of grounds remaining.")
	else
		. += SPAN_WARNING("The cartridge has no unspent grounds remaining.")

/obj/item/coffee_cartridge/fancy
	name = "coffeemaker cartridge - Caffè Fantasioso"
	desc = "A fancy coffee cartridge manufactured by Piccionaia Coffee, for use with the Modello 3 system."
	icon_state = "cartridge_blend"

//Here's the joke before I get 50 issue reports: they're all the same, and that's intentional
/obj/item/coffee_cartridge/fancy/Initialize(mapload)
	. = ..()
	var/coffee_type = pick("blend", "blue_mountain", "kilimanjaro", "mocha")
	switch(coffee_type)
		if("blend")
			name = "coffeemaker cartridge - Miscela di Piccione"
			icon_state = "cartridge_blend"
		if("blue_mountain")
			name = "coffeemaker cartridge - Montagna Blu"
			icon_state = "cartridge_blue_mtn"
		if("kilimanjaro")
			name = "coffeemaker cartridge - Kilimangiaro"
			icon_state = "cartridge_kilimanjaro"
		if("mocha")
			name = "coffeemaker cartridge - Moka Arabica"
			icon_state = "cartridge_mocha"

/obj/item/coffee_cartridge/decaf
	name = "coffeemaker cartridge - Caffè Decaffeinato"
	desc = "A decaf coffee cartridge manufactured by Piccionaia Coffee, for use with the Modello 3 system."
	icon_state = "cartridge_decaf"
	drink_type = list("decafcoffee" = 120)

// no you can't just squeeze the juice bag into a glass!
/obj/item/coffee_cartridge/bootleg
	name = "coffeemaker cartridge - Botany Blend"
	desc = "A jury-rigged coffee cartridge. Should work with a Modello 3 system, though it might void the warranty."
	icon_state = "cartridge_bootleg"

// blank cartridge for crafting's sake, can be made at the service lathe
/obj/item/blank_coffee_cartridge
	name = "blank coffee cartridge"
	desc = "A blank coffee cartridge, ready to be filled with coffee paste."
	icon = 'icons/obj/food.dmi'
	icon_state = "cartridge_blank"
	materials_base = list(MAT_PLASTIC = 500)

//now, how do you store coffee carts? well, in a rack, of course!
/obj/item/storage/fancy/coffee_cart_rack
	name = "coffeemaker cartridge rack"
	desc = "A small rack for storing coffeemaker cartridges."
	icon = 'icons/obj/food/containers.dmi'
	icon_state = "coffee_cartrack1"
	base_icon_state = "coffee_cartrack"
	max_items = 4
	insertion_whitelist = list(/obj/item/coffee_cartridge)
	materials_base = list(MAT_PLASTIC = 500)

#undef BEAN_CAPACITY
