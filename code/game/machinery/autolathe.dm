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

	circuit = /obj/item/circuitboard/autolathe

	var/static/datum/category_collection/autolathe/autolathe_recipes
	var/list/stored_material =  list(MAT_STEEL = 0, MAT_GLASS = 0)
	var/list/storage_capacity = list(MAT_STEEL = 0, MAT_GLASS = 0)

	var/hacked = FALSE
	var/disabled = FALSE
	var/shocked = FALSE
	var/busy = FALSE

	var/mat_efficiency = 1
	var/build_time = 50

	var/datum/wires/autolathe/wires = null

	var/mb_rating = 0
	var/man_rating = 0

	var/filtertext

/obj/machinery/autolathe/Initialize(mapload)
	. = ..()
	if(!autolathe_recipes)
		autolathe_recipes = new()
	wires = new(src)
	default_apply_parts()

/obj/machinery/autolathe/Destroy()
	QDEL_NULL(wires)
	return ..()

/obj/machinery/autolathe/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Autolathe", name)
		ui.open()

/obj/machinery/autolathe/ui_status(mob/user)
	if(disabled)
		return UI_CLOSE
	return ..()

/obj/machinery/autolathe/ui_static_data(mob/user)
	var/list/data = ..()

	var/list/categories = list()
	var/list/recipes = list()
	for(var/datum/category_group/autolathe/A in autolathe_recipes.categories)
		categories += A.name
		for(var/datum/category_item/autolathe/M in A.items)
			if(M.hidden && !hacked)
				continue
			if(M.man_rating > man_rating)
				continue
			recipes.Add(list(list(
				"category" = A.name,
				"name" = M.name,
				"ref" = REF(M),
				"requirements" = M.resources,
				"hidden" = M.hidden,
				"coeff_applies" = !M.no_scale,
			)))
	data["recipes"] = recipes
	data["categories"] = categories

	return data

/obj/machinery/autolathe/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/spritesheet/sheetmaterials)
	)

/obj/machinery/autolathe/ui_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	var/list/data = ..()

	var/list/material_data = list()
	for(var/mat_id in stored_material)
		var/amount = stored_material[mat_id]
		var/list/material_info = list(
			"name" = mat_id,
			"amount" = amount,
			"sheets" = round(amount / SHEET_MATERIAL_AMOUNT),
			"removable" = amount >= SHEET_MATERIAL_AMOUNT
		)
		material_data += list(material_info)
	data["busy"] = busy
	data["materials"] = material_data
	data["mat_efficiency"] = mat_efficiency
	return data

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

	if(default_deconstruction_screwdriver(user, O))
		interact(user)
		return
	if(default_deconstruction_crowbar(user, O))
		return
	if(default_part_replacement(user, O))
		return

	if(machine_stat)
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
	if(!eating.matter)
		to_chat(user, "\The [eating] does not contain significant amounts of useful materials and cannot be accepted.")
		return

	///Used to determine message.
	var/filltype = 0
	///Amount of material used.
	var/total_used = 0
	///Amount of material constituting one sheet.
	var/mass_per_sheet = 0

	for(var/material in eating.matter)

		if(isnull(stored_material[material]) || isnull(storage_capacity[material]))
			continue

		if(stored_material[material] >= storage_capacity[material])
			continue

		var/total_material = eating.matter[material]

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
		mass_per_sheet += eating.matter[material]

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

/obj/machinery/autolathe/attack_hand(mob/user as mob)
	user.set_machine(src)
	interact(user)

/obj/machinery/autolathe/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE

	usr.set_machine(src)

	if(busy)
		to_chat(usr, SPAN_NOTICE("The autolathe is busy. Please wait for completion of previous operation."))
		return

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
				if(!multiplier || multiplier <= 0 || multiplier > max_sheets || ui_status(usr, state) != UI_INTERACTIVE)
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

/obj/machinery/autolathe/update_icon()
	overlays.Cut()

	icon_state = initial(icon_state)

	if(panel_open)
		icon_state = "autolathe_t"
	else if(busy)
		icon_state = "autolathe_n"
	else
		if(icon_state == "autolathe_n")
			flick("autolathe_u", src) //If lid WAS closed, show opening animation
		icon_state = "autolathe"

//Updates overall lathe storage size.
/obj/machinery/autolathe/RefreshParts()
	..()
	var/mb_rating = 0
	var/man_rating = 0
	for(var/obj/item/stock_parts/matter_bin/MB in component_parts)
		mb_rating += MB.rating
	for(var/obj/item/stock_parts/manipulator/M in component_parts)
		man_rating += M.rating

	storage_capacity[MAT_STEEL] = mb_rating  * 25000
	storage_capacity[MAT_GLASS] = mb_rating  * 12500
	build_time = 50 / man_rating
	mat_efficiency = 1.1 - man_rating * 0.1 //Normally, price is 1.25 the amount of material, so this shouldn't go higher than 0.6. Maximum rating of parts is 5
	update_static_data(usr)

/obj/machinery/autolathe/dismantle()
	for(var/mat in stored_material)
		var/datum/material/M = get_material_by_name(mat)
		if(!istype(M))
			continue
		var/obj/item/stack/material/S = new M.stack_type(get_turf(src))
		if(stored_material[mat] > S.perunit)
			S.amount = round(stored_material[mat] / S.perunit)
		else
			qdel(S)
	..()
	return 1

/datum/category_item/autolathe/arms/classic_smg_9mm
	name = "SMG magazine (9mm)"
	path = /obj/item/ammo_magazine/m9mml
	hidden = 1
/* De-coded?
/datum/category_item/autolathe/arms/classic_smg_9mmr
	name = "SMG magazine (9mm rubber)"
	path = /obj/item/ammo_magazine/m9mml/rubber

/datum/category_item/autolathe/arms/classic_smg_9mmp
	name = "SMG magazine (9mm practice)"
	path = /obj/item/ammo_magazine/m9mml/practice

/datum/category_item/autolathe/arms/classic_smg_9mmf
	name = "SMG magazine (9mm flash)"
	path = /obj/item/ammo_magazine/m9mml/flash
*/

// 0 amount = 0 means ejecting a full stack; -1 means eject everything
/obj/machinery/partslathe/proc/eject_materials(var/material, var/amount)
	var/recursive = amount == -1 ? TRUE : FALSE
	material = lowertext(material)
	var/mattype
	switch(material)
		if(MAT_STEEL)
			mattype = /obj/item/stack/material/steel
		if(MAT_GLASS)
			mattype = /obj/item/stack/material/glass
		else
			return
	var/obj/item/stack/material/S = new mattype(loc)
	if(amount <= 0)
		amount = S.max_amount
	var/ejected = min(round(materials[material] / S.perunit), amount)
	if(!S.set_amount(min(ejected, amount)))
		return
	materials[material] -= ejected * S.perunit
	if(recursive && materials[material] >= S.perunit)
		eject_materials(material, -1)
