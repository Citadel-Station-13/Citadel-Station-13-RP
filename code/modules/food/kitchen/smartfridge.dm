/* SmartFridge.  Much todo
*/
/obj/machinery/smartfridge
	name = "\improper SmartFridge"
	icon = 'icons/obj/vending.dmi'
	icon_state = "fridge_sci"
	density = 1
	anchored = 1
	use_power = USE_POWER_IDLE
	idle_power_usage = 5
	active_power_usage = 100
	atom_flags = NOREACT
	pass_flags = NONE
	CanAtmosPass = ATMOS_PASS_AIR_BLOCKED
	var/max_n_of_items = 999 // Sorry but the BYOND infinite loop detector doesn't look things over 1000.
	var/list/item_records = list()
	var/datum/stored_item/currently_vending = null	//What we're putting out of the machine.
	var/seconds_electrified = 0;
	var/shoot_inventory = 0
	var/locked = 0
	var/scan_id = 1
	var/is_secure = 0
	var/wrenchable = TRUE
	var/list/accepted_types = list(/obj/item/reagent_containers/food/snacks/grown/)
	var/list/blacklisted_types = list()
	var/datum/wires/smartfridge/wires = null
	var/icon_contents = "food"
	var/icon_base = "fridge_sci"

/obj/machinery/smartfridge/secure
	is_secure = 1

/obj/machinery/smartfridge/Initialize(mapload)
	. = ..()
	AIR_UPDATE_ON_INITIALIZE_AUTO
	if(is_secure)
		wires = new/datum/wires/smartfridge/secure(src)
	else
		wires = new/datum/wires/smartfridge(src)

/obj/machinery/smartfridge/Destroy()
	AIR_UPDATE_ON_DESTROY_AUTO
	qdel(wires)
	for(var/A in item_records)	//Get rid of item records.
		qdel(A)
	wires = null
	return ..()

/obj/machinery/smartfridge/Moved(atom/oldloc)
	. = ..()
	AIR_UPDATE_ON_MOVED_AUTO

/obj/machinery/smartfridge/proc/accept_check(var/obj/item/O as obj) //This isn't complex! You didn't need to override this for EVERY. SINGLE. SUBTYPE.
	if(is_type_in_list(O, blacklisted_types))
		return FALSE
	return is_type_in_list(O, accepted_types)

/obj/machinery/smartfridge/process(delta_time)
	if(machine_stat & (BROKEN|NOPOWER))
		return
	if(src.seconds_electrified > 0)
		src.seconds_electrified--
	if(src.shoot_inventory && prob(2))
		src.throw_item()

/obj/machinery/smartfridge/power_change()
	var/old_stat = machine_stat
	..()
	if(old_stat != machine_stat)
		update_icon()

/obj/machinery/smartfridge/update_icon()
	overlays.Cut()
	if(inoperable())
		icon_state = "[icon_base]-off"
	else
		icon_state = icon_base

	if(is_secure)
		add_overlay("[icon_base]-sidepanel")

	if(panel_open)
		add_overlay("[icon_base]-panel")

	var/image/I
	var/is_off = ""
	if(inoperable())
		is_off = "-off"

	// Fridge contents
	switch(length(contents))
		if(0)
			add_overlay("empty[is_off]")
		if(1 to 2)
			add_overlay("[icon_contents]-1[is_off]")
		if(3 to 5)
			add_overlay("[icon_contents]-2[is_off]")
		if(6 to 8)
			add_overlay("[icon_contents]-3[is_off]")
		else
			add_overlay("[icon_contents]-4[is_off]")

	// Fridge top
	I = image(icon, "[icon_base]-top")
	I.pixel_z = 32
	I.layer = ABOVE_WINDOW_LAYER
	overlays += I

/obj/machinery/smartfridge/drying_rack/ashlander
	name = "\improper Bone Drying Kiln"
	desc = "A machine for drying plants and hides."
	icon = 'icons/obj/lavaland.dmi'

/*******************
*   Item Adding
********************/

/obj/machinery/smartfridge/attackby(obj/item/O, mob/user)
	if(O.is_screwdriver())
		panel_open = !panel_open
		user.visible_message("[user] [panel_open ? "opens" : "closes"] the maintenance panel of \the [src].", "You [panel_open ? "open" : "close"] the maintenance panel of \the [src].")
		playsound(src, O.tool_sound, 50, 1)
		update_icon()
		SSnanoui.update_uis(src)
		return

	if(wrenchable && default_unfasten_wrench(user, O, 20))
		return

	if(istype(O, /obj/item/multitool) || O.is_wirecutter())
		if(panel_open)
			attack_hand(user)
		return

	if(machine_stat & NOPOWER)
		to_chat(user, "<span class='notice'>\The [src] is unpowered and useless.</span>")
		return

	if(accept_check(O))
		if(!user.attempt_insert_item_for_installation(O, src))
			return
		stock(O)
		update_icon()
		user.visible_message("<span class='notice'>[user] has added \the [O] to \the [src].</span>", "<span class='notice'>You add \the [O] to \the [src].</span>")


	else if(istype(O, /obj/item/storage/bag))
		var/obj/item/storage/bag/P = O
		var/plants_loaded = 0
		for(var/obj/G in P.contents)
			if(accept_check(G))
				P.remove_from_storage(G) //fixes ui bug - Pull Request 5515
				stock(G)
				plants_loaded = 1
		if(plants_loaded)
			user.visible_message("<span class='notice'>[user] loads \the [src] with \the [P].</span>", "<span class='notice'>You load \the [src] with \the [P].</span>")
			if(P.contents.len > 0)
				to_chat(user, "<span class='notice'>Some items are refused.</span>")

	else if(istype(O, /obj/item/gripper)) // Grippers. ~Mechoid.
		var/obj/item/gripper/B = O	//B, for Borg.
		if(!B.get_item())
			to_chat(user, "\The [B] is not holding anything.")
			return
		else
			var/B_held = B.get_item()
			to_chat(user, "You use \the [B] to put \the [B_held] into \the [src].")
			attackby(B_held, user)
		return

	else
		to_chat(user, "<span class='notice'>\The [src] smartly refuses [O].</span>")
		return 1

/obj/machinery/smartfridge/secure/emag_act(var/remaining_charges, var/mob/user)
	if(!emagged)
		emagged = 1
		locked = -1
		to_chat(user, "You short out the product lock on [src].")
		return 1

/obj/machinery/smartfridge/proc/stock(obj/item/O)
	var/hasRecord = FALSE	//Check to see if this passes or not.
	for(var/datum/stored_item/I in item_records)
		if((O.type == I.item_path) && (O.name == I.item_name))
			I.add_product(O)
			hasRecord = TRUE
			break
	if(!hasRecord)
		var/datum/stored_item/item = new/datum/stored_item(src, O.type, O.name)
		item.add_product(O)
		item_records.Add(item)
	SSnanoui.update_uis(src)

/obj/machinery/smartfridge/proc/vend(datum/stored_item/I)
	I.get_product(get_turf(src))
	SSnanoui.update_uis(src)

/obj/machinery/smartfridge/attack_ai(mob/user as mob)
	attack_hand(user)

/obj/machinery/smartfridge/attack_hand(mob/user, list/params)
	if(machine_stat & (NOPOWER|BROKEN))
		return
	wires.Interact(user)
	nano_ui_interact(user)

/*******************
*   SmartFridge Menu
********************/

/obj/machinery/smartfridge/nano_ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	user.set_machine(src)

	var/data[0]
	data["contents"] = null
	data["electrified"] = seconds_electrified > 0
	data["shoot_inventory"] = shoot_inventory
	data["locked"] = locked
	data["secure"] = is_secure

	var/list/items[0]
	for (var/i=1 to length(item_records))
		var/datum/stored_item/I = item_records[i]
		var/count = I.get_amount()
		if(count > 0)
			items.Add(list(list("display_name" = html_encode(capitalize(I.item_name)), "vend" = i, "quantity" = count)))

	if(items.len > 0)
		data["contents"] = items

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "smartfridge.tmpl", src.name, 400, 500)
		ui.set_initial_data(data)
		ui.open()

/obj/machinery/smartfridge/Topic(href, href_list)
	if(..()) return 0

	var/mob/user = usr
	var/datum/nanoui/ui = SSnanoui.get_open_ui(user, src, "main")

	src.add_fingerprint(user)

	if(href_list["close"])
		user.unset_machine()
		ui.close()
		return 0

	if(href_list["vend"])
		var/index = text2num(href_list["vend"])
		var/amount = text2num(href_list["amount"])
		var/datum/stored_item/I = item_records[index]
		var/count = I.get_amount()

		// Sanity check, there are probably ways to press the button when it shouldn't be possible.
		if(count > 0)
			if((count - amount) < 0)
				amount = count
			for(var/i = 1 to amount)
				vend(I)

		return 1
	return 0

/obj/machinery/smartfridge/proc/throw_item()
	var/obj/throw_item = null
	var/mob/living/target = locate() in view(7,src)
	if(!target)
		return 0

	for(var/datum/stored_item/I in item_records)
		throw_item = I.get_product(get_turf(src))
		if (!throw_item)
			continue
		break

	if(!throw_item)
		return 0
	spawn(0)
		throw_item.throw_at_old(target,16,3,src)
	src.visible_message("<span class='warning'>[src] launches [throw_item.name] at [target.name]!</span>")
	return 1

/************************
*   Secure SmartFridges
*************************/

/obj/machinery/smartfridge/secure/Topic(href, href_list)
	if(machine_stat & (NOPOWER|BROKEN))
		return 0
	if(usr.contents.Find(src) || (in_range(src, usr) && istype(loc, /turf)))
		if(!allowed(usr) && !emagged && locked != -1 && href_list["vend"])
			to_chat(usr, "<span class='warning'>Access denied.</span>")
			return 0
	return ..()

//subtypes. I'm going to kill whoever decided to shove them right below the initial definition.

/obj/machinery/smartfridge/seeds
	name = "\improper MegaSeed Servitor"
	desc = "When you need seeds fast!"
	accepted_types = list(/obj/item/seeds/)

/obj/machinery/smartfridge/secure/extract
	name = "\improper Biological Sample Storage"
	desc = "A refrigerated storage unit for xenobiological samples."
	req_access = list(ACCESS_SCIENCE_MAIN)
	icon_contents = "slime"
	accepted_types = list(/obj/item/slime_extract/, /obj/item/slimepotion/)

/obj/machinery/smartfridge/secure/medbay
	name = "\improper Refrigerated Medicine Storage"
	desc = "A refrigerated storage unit for storing medicine and chemicals."
	req_one_access = list(ACCESS_MEDICAL_MAIN,ACCESS_MEDICAL_CHEMISTRY)
	accepted_types = list(/obj/item/reagent_containers/glass/, /obj/item/storage/pill_bottle/, /obj/item/reagent_containers/pill/)

/obj/machinery/smartfridge/secure/virology
	name = "\improper Refrigerated Virus Storage"
	desc = "A refrigerated storage unit for storing viral material."
	req_access = list(ACCESS_MEDICAL_VIROLOGY)
	accepted_types = list(/obj/item/reagent_containers/glass/beaker/vial/, /obj/item/virusdish/)

/obj/machinery/smartfridge/chemistry
	name = "\improper Smart Chemical Storage"
	desc = "A refrigerated storage unit for medicine and chemical storage."
	accepted_types = list(/obj/item/storage/pill_bottle/, /obj/item/reagent_containers/)

/obj/machinery/smartfridge/chemistry/virology
	name = "\improper Smart Virus Storage"
	desc = "A refrigerated storage unit for volatile sample storage."

/obj/machinery/smartfridge/drinks
	name = "\improper Drink Showcase"
	icon_state = "fridge_dark"
	icon_base = "fridge_dark"
	icon_contents = "drink"
	desc = "A refrigerated storage unit for tasty tasty alcohol."
	accepted_types = list(/obj/item/reagent_containers/glass/,/obj/item/reagent_containers/food/drinks/,/obj/item/reagent_containers/food/condiment/)

/obj/machinery/smartfridge/food
	name = "\improper Hot Foods Display"
	icon_state = "fridge_food"
	icon_state = "fridge_food"
	desc = "A climated storage for dishes waiting to be eaten"
	accepted_types = list(/obj/item/reagent_containers/food/snacks/, /obj/item/reagent_containers/food/condiment/)
	blacklisted_types = list(/obj/item/reagent_containers/food/snacks/grown/)


/obj/machinery/smartfridge/drying_rack
	name = "\improper Drying Rack"
	desc = "A machine for drying plants."
	wrenchable = 1
	icon_state = "drying_rack"

/obj/machinery/smartfridge/drying_rack/accept_check(var/obj/item/O as obj)
	if(istype(O, /obj/item/reagent_containers/food/snacks/))
		var/obj/item/reagent_containers/food/snacks/S = O
		if (S.dried_type)
			return 1
	if(istype(O, /obj/item/stack/wetleather))
		var/obj/item/stack/wetleather/WL = O
		if (WL.wetness == 30)
			return 1
	return 0

/obj/machinery/smartfridge/drying_rack/process(delta_time)
	..()
	if(machine_stat & (BROKEN|NOPOWER))
		return
	if(contents.len)
		dry()
		update_icon()

/obj/machinery/smartfridge/drying_rack/update_icon()
	cut_overlays()
	var/list/overlays_to_add = list()
	var/not_working = machine_stat & (BROKEN|NOPOWER)
	if(not_working)
		icon_state = "drying_rack-off"
	else
		icon_state = "drying_rack"
	var/hasItems
	for(var/datum/stored_item/I in item_records)
		if(I.get_amount())
			hasItems = 1
			break
	if(hasItems)
		overlays_to_add += "drying_rack_filled"
		if(!not_working)
			overlays_to_add += "drying_rack_drying"
	add_overlay(overlays_to_add)

/obj/machinery/smartfridge/drying_rack/attackby(var/obj/item/O as obj, mob/user)
	. = ..()
	if(istype(O, /obj/item/stack/wetleather/))
		var/obj/item/stack/wetleather/WL = O
		if(WL.amount > 2)
			to_chat("<span class='notice'>The rack can only fit one sheet at a time!</span>")
			return 1
		else
			if(!user.attempt_insert_item_for_installation(WL, src))
				return
			stock(WL)
			user.visible_message("<span class='notice'>[user] has added \the [WL] to \the [src].</span>", "<span class='notice'>You add \the [WL] to \the [src].</span>")

/obj/machinery/smartfridge/drying_rack/proc/dry()
	for(var/datum/stored_item/I in item_records)
		for(var/obj/item/reagent_containers/food/snacks/S in I.instances)
			if(S.dry) continue
			if(S.dried_type == S.type)
				S.dry = 1
				S.name = "dried [S.name]"
				S.color = "#AAAAAA"
				I.instances -= S
				S.forceMove(get_turf(src))
			else
				var/D = S.dried_type
				new D(get_turf(src))
				qdel(S)
			return
		for(var/obj/item/stack/wetleather/WL in I.instances)
			WL.use(1)
			I.instances -= WL
			var/L = /obj/item/stack/material/leather
			new L(get_turf(src))
		return

