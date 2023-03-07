
/obj/machinery/chemical_dispenser/attackby(obj/item/W, mob/user)
	else if(istype(W, /obj/item/reagent_containers/glass) || istype(W, /obj/item/reagent_containers/food))
		if(container)
			to_chat(user, "<span class='warning'>There is already \a [container] on \the [src]!</span>")
			return

		var/obj/item/reagent_containers/RC = W

		if(!accept_drinking && istype(RC,/obj/item/reagent_containers/food))
			to_chat(user, "<span class='warning'>This machine only accepts beakers!</span>")
			return
		if(!RC.is_open_container())
			to_chat(user, "<span class='warning'>You don't see how \the [src] could dispense reagents into \the [RC].</span>")
			return
		if(!user.attempt_insert_item_for_installation(RC, src))
			return
		container =  RC
		to_chat(user, "<span class='notice'>You set \the [RC] on \the [src].</span>")
		SStgui.update_uis(src) // update all UIs attached to src

	else
		return ..()

/obj/machinery/chemical_dispenser/ui_interact(mob/user, datum/tgui/ui = null)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ChemDispenser", ui_title) // 390, 655
		ui.open()

/obj/machinery/chemical_dispenser/ui_data(mob/user)
	var/data[0]
	data["amount"] = amount
	data["isBeakerLoaded"] = container ? 1 : 0
	data["glass"] = accept_drinking

	var/beakerContents[0]
	if(container && container.reagents && container.reagents.reagent_list.len)
		for(var/datum/reagent/R in container.reagents.reagent_list)
			beakerContents.Add(list(list("name" = R.name, "id" = R.id, "volume" = R.volume))) // list in a list because Byond merges the first list...
	data["beakerContents"] = beakerContents

	if(container)
		data["beakerCurrentVolume"] = container.reagents.total_volume
		data["beakerMaxVolume"] = container.reagents.maximum_volume
	else
		data["beakerCurrentVolume"] = null
		data["beakerMaxVolume"] = null

	var/chemicals[0]
	for(var/label in cartridges)
		var/obj/item/reagent_containers/chem_disp_cartridge/C = cartridges[label]
		chemicals.Add(list(list("title" = label, "id" = label, "amount" = C.reagents.total_volume))) // list in a list because Byond merges the first list...
	data["chemicals"] = chemicals
	return data

/obj/machinery/chemical_dispenser/ui_act(action, params)
	if("ejectBeaker")
		if(!container)
			return
		if(!usr)
			return
		usr.grab_item_from_interacted_with(container, src)
		container = null
	else
		return FALSE

/obj/machinery/chemical_dispenser/attack_ghost(mob/user)
	. = ..()
	if(machine_stat & BROKEN)
		return
	ui_interact(user)
