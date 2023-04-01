/obj/machinery/autolathe
	name = "autolathe"
	desc = "It produces items using metal and glass."
	icon = 'icons/obj/machines/fabricators/autolathe.dmi'
	icon_state = "autolathe"
	density = TRUE
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 10
	active_power_usage = 2000
	clicksound = "keyboard"
	clickvol = 30

	var/hacked = FALSE
	var/disabled = FALSE
	var/shocked = FALSE
	var/busy = FALSE

#warn  wires?

	var/datum/wires/autolathe/wires = null

/obj/machinery/autolathe/Initialize(mapload)
	. = ..()
	if(!autolathe_recipes)
		autolathe_recipes = new()
	wires = new(src)

/obj/machinery/autolathe/Destroy()
	QDEL_NULL(wires)
	return ..()

/obj/machinery/autolathe/ui_status(mob/user)
	if(disabled)
		return UI_CLOSE
	return ..()

/obj/machinery/autolathe/interact(mob/user)
	if(panel_open)
		return wires.Interact(user)

	if(disabled)
		to_chat(user, SPAN_DANGER("\The [src] is disabled!"))
		return

	if(shocked)
		shock(user, 50)

	ui_interact(user)

/obj/machinery/autolathe/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(busy)
		to_chat(user, SPAN_NOTICE("\The [src] is busy. Please wait for completion of previous operation."))
		return


	if(panel_open)
		//Don't eat multitools or wirecutters used on an open lathe.
		if(O.is_multitool() || O.is_wirecutter())
			wires.Interact(user)
			return

	if(O.loc != user && !(istype(O,/obj/item/stack)))
		return FALSE

	if(is_robot_module(O))
		return FALSE

	if(istype(O,/obj/item/ammo_magazine/clip) || istype(O,/obj/item/ammo_magazine/s357) || istype(O,/obj/item/ammo_magazine/s38) || istype (O,/obj/item/ammo_magazine/s44))
		to_chat(user, "\The [O] is too hazardous to recycle with the autolathe!")
		return

	///Resources are being loaded.
	var/obj/item/eating = O
	if(!eating.materials)
		to_chat(user, "\The [eating] does not contain significant amounts of useful materials and cannot be accepted.")
		return

	///Used to determine message.
	var/filltype = 0
	///Amount of material used.
	var/total_used = 0
	///Amount of material constituting one sheet.
	var/mass_per_sheet = 0

	for(var/material in eating.materials)

		if(isnull(stored_material[material]) || isnull(storage_capacity[material]))
			continue

		if(stored_material[material] >= storage_capacity[material])
			continue

		var/total_material = eating.materials[material]

		//If it's a stack, we eat multiple sheets.
		if(istype(eating,/obj/item/stack))
			var/obj/item/stack/stack = eating
			total_material *= stack.get_amount()

		if(stored_material[material] + total_material > storage_capacity[material])
			total_material = storage_capacity[material] - stored_material[material]
			filltype = 1
		else
			filltype = 2

		stored_material[material] += total_material
		total_used += total_material
		mass_per_sheet += eating.materials[material]

	if(!filltype)
		to_chat(user, SPAN_NOTICE("\The [src] is full. Please remove material from the autolathe in order to insert more."))
		return
	else if(filltype == 1)
		to_chat(user, "You fill \the [src] to capacity with \the [eating].")
	else
		to_chat(user, "You fill \the [src] with \the [eating].")

	flick("autolathe_o", src) //Plays metal insertion animation. Work out a good way to work out a fitting animation. ~Z

	if(istype(eating,/obj/item/stack))
		var/obj/item/stack/stack = eating
		stack.use(max(1, round(total_used/mass_per_sheet))) //Always use at least 1 to prevent infinite materials.
	else
		qdel(O)

	updateUsrDialog()
	return


/obj/machinery/autolathe/ui_act(action, list/params, datum/tgui/ui)
	if(..())
		return TRUE

	switch(action)
		if("make")
			var/datum/category_item/autolathe/making = locate(params["make"])
			if(!istype(making))
				return
			if(making.hidden && !hacked)
				return

			var/multiplier = 1

			if(making.is_stack)
				var/max_sheets
				for(var/material in making.resources)
					var/coeff = (making.no_scale ? 1 : mat_efficiency) //Stacks are unaffected by production coefficient
					var/sheets = round(stored_material[material]/round(making.resources[material]*coeff))
					if(isnull(max_sheets) || max_sheets > sheets)
						max_sheets = sheets
					if(!isnull(stored_material[material]) && stored_material[material] < round(making.resources[material]*coeff))
						max_sheets = 0
				//Build list of multipliers for sheets.
				multiplier = input(usr, "How many do you want to print? (0-[max_sheets])") as num|null
				if(!multiplier || multiplier <= 0 || multiplier > max_sheets || ui_status(usr, ui.state) != UI_INTERACTIVE)
					return FALSE

			busy = making.name
			update_use_power(USE_POWER_ACTIVE)

			//Check if we still have the materials.
			var/coeff = (making.no_scale ? 1 : mat_efficiency) //Stacks are unaffected by production coefficient
			for(var/material in making.resources)
				if(!isnull(stored_material[material]))
					if(stored_material[material] < round(making.resources[material] * coeff) * multiplier)
						return

			//Consume materials.
			for(var/material in making.resources)
				if(!isnull(stored_material[material]))
					stored_material[material] = max(0, stored_material[material] - round(making.resources[material] * coeff) * multiplier)

			update_icon() //So lid closes

			sleep(build_time)

			busy = 0
			update_use_power(USE_POWER_IDLE)
			update_icon() //So lid opens

			//Sanity check.
			if(!making || !src)
				return

			//Create the desired item.
			var/obj/item/I = new making.path(src.loc)
			flick("[initial(icon_state)]_finish", src)
			if(multiplier > 1)
				if(istype(I, /obj/item/stack))
					var/obj/item/stack/S = I
					S.amount = multiplier
				else
					for(multiplier; multiplier > 1; --multiplier) //Create multiple items if it's not a stack.
						new making.path(src.loc)
			return TRUE
	return FALSE
