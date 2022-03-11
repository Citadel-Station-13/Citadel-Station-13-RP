/**********************Mineral processing unit console**************************/
#define PROCESS_NONE		0
#define PROCESS_SMELT		1
#define PROCESS_COMPRESS	2
#define PROCESS_ALLOY		3

/obj/machinery/mineral/processing_unit_console
	name = "production machine console"
	icon = 'icons/obj/machines/mining_machines_vr.dmi' // VOREStation Edit
	icon_state = "console"
	density = TRUE
	anchored = TRUE

	var/obj/item/card/id/inserted_id	// Inserted ID card, for points

	var/obj/machinery/mineral/processing_unit/machine = null
	var/show_all_ores = FALSE

/obj/machinery/mineral/processing_unit_console/Initialize(mapload)
	. = ..()
	src.machine = locate(/obj/machinery/mineral/processing_unit) in range(5, src)
	if (machine)
		machine.console = src
	else
		log_debug("Ore processing machine console at [src.x], [src.y], [src.z] could not find its machine!")
		qdel(src)

/obj/machinery/mineral/processing_unit_console/Destroy()
	if(inserted_id)
		inserted_id.forceMove(loc) //Prevents deconstructing from deleting whatever ID was inside it.
	. = ..()

/obj/machinery/mineral/processing_unit_console/attack_hand(mob/user)
	if(..())
		return
	if(!allowed(user))
		to_chat(user, "<span class='warning'>Access denied.</span>")
		return
	ui_interact(user)

/obj/machinery/mineral/processing_unit_console/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/card/id))
		if(!powered())
			return
		if(!inserted_id && user.unEquip(I))
			I.forceMove(src)
			inserted_id = I
			SStgui.update_uis(src)
		return
	..()

/obj/machinery/mineral/processing_unit_console/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "MiningOreProcessingConsole", name)
		ui.open()

/obj/machinery/mineral/processing_unit_console/ui_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	var/list/data = ..()
	data["unclaimedPoints"] = machine.points

	if(inserted_id)
		data["has_id"] = TRUE
		data["id"] = list(
			"name" = inserted_id.registered_name,
			"points" = inserted_id.mining_points,
		)
	else
		data["has_id"] = FALSE

	data["ores"] = list()
	for(var/ore in machine.ores_processing)
		if(!machine.ores_stored[ore] && !show_all_ores)
			continue
		var/datum/ore/O = GLOB.ore_data[ore]
		if(!O)
			continue
		data["ores"].Add(list(list(
			"ore" = ore,
			"name" = O.display_name,
			"amount" = machine.ores_stored[ore],
			"processing" = machine.ores_processing[ore] ? machine.ores_processing[ore] : 0,
		)))

	data["showAllOres"] = show_all_ores
	data["power"] = machine.active

	return data

/obj/machinery/mineral/processing_unit_console/ui_act(action, list/params)
	if(..())
		return TRUE

	add_fingerprint(usr)
	switch(action)
		if("toggleSmelting")
			var/ore = params["ore"]
			var/new_setting = params["set"]
			if(new_setting == null)
				new_setting = input("What setting do you wish to use for processing [ore]]?") as null|anything in list("Smelting","Compressing","Alloying","Nothing")
				if(!new_setting)
					return
				switch(new_setting)
					if("Nothing") new_setting = PROCESS_NONE
					if("Smelting") new_setting = PROCESS_SMELT
					if("Compressing") new_setting = PROCESS_COMPRESS
					if("Alloying") new_setting = PROCESS_ALLOY
			machine.ores_processing[ore] = new_setting
			. = TRUE
		if("power")
			machine.active = !machine.active
			. = TRUE
		if("showAllOres")
			show_all_ores = !show_all_ores
			. = TRUE
		if("logoff")
			if(!inserted_id)
				return
			usr.put_in_hands(inserted_id)
			inserted_id = null
			. = TRUE
		if("claim")
			if(istype(inserted_id))
				inserted_id.mining_points += machine.points
				machine.points = 0
			. = TRUE
		if("insert")
			var/obj/item/card/id/I = usr.get_active_hand()
			if(istype(I))
				usr.drop_item()
				I.forceMove(src)
				inserted_id = I
			else
				to_chat(usr, "<span class='warning'>No valid ID.</span>")
			. = TRUE
		else
			return FALSE
/**********************Mineral processing unit**************************/


/obj/machinery/mineral/processing_unit
	name = "material processor" //This isn't actually a goddamn furnace, we're in space and it's processing platinum and flammable phoron...
	icon = 'icons/obj/machines/mining_machines_vr.dmi' // VOREStation Edit
	icon_state = "furnace"
	density = TRUE
	anchored = TRUE
	light_range = 3
	speed_process = TRUE
	var/tick = 0
	var/obj/machinery/mineral/input = null
	var/obj/machinery/mineral/output = null
	var/obj/machinery/mineral/console = null
	var/sheets_per_tick = 10
	var/list/ores_processing = list()
	var/list/ores_stored = list()
	var/static/list/alloy_data
	var/active = FALSE

	var/points = 0
	var/static/list/ore_values = list(
		"sand" = 1,
		"hematite" = 1,
		"carbon" = 1,
		"phoron" = 15,
		"copper" = 15,
		"silver" = 16,
		"gold" = 18,
		"marble" = 20,
		"uranium" = 30,
		"diamond" = 50,
		"platinum" = 40,
		"lead" = 40,
		"mhydrogen" = 40,
		"vaudium" = 50,
		"verdantium" = 60)

/obj/machinery/mineral/processing_unit/Initialize(mapload)
	. = ..()
	// initialize static alloy_data list
	if(!alloy_data)
		alloy_data = list()
		for(var/alloytype in typesof(/datum/alloy)-/datum/alloy)
			alloy_data += new alloytype()
	for(var/orename in GLOB.ore_data)
		var/datum/ore/O = GLOB.ore_data[orename]
		ores_processing[O.name] = 0
		ores_stored[O.name] = 0

/obj/machinery/mineral/processing_unit/Initialize(mapload)
	. = ..()
	// TODO: Eschew input/output machinery and just use dirs ~Leshana
	//Locate our output and input machinery.
	for (var/dir in GLOB.cardinal)
		src.input = locate(/obj/machinery/mineral/input, get_step(src, dir))
		if(src.input) break
	for (var/dir in GLOB.cardinal)
		src.output = locate(/obj/machinery/mineral/output, get_step(src, dir))
		if(src.output) break
	return

/obj/machinery/mineral/processing_unit/proc/toggle_speed()
	speed_process = !speed_process // switching gears
	if(speed_process) // high gear
		STOP_MACHINE_PROCESSING(src)
		START_PROCESSING(SSfastprocess, src)
	else // low gear
		STOP_PROCESSING(SSfastprocess, src)
		START_MACHINE_PROCESSING(src)

/obj/machinery/mineral/processing_unit/process(delta_time)

	if (!src.output || !src.input)
		return

	if(panel_open || !powered())
		return

	var/list/tick_alloys = list()
	tick++

	//Grab some more ore to process this tick.
	for(var/i = 0,i<sheets_per_tick,i++)
		var/obj/item/ore/O = locate() in input.loc
		if(!O) break
		if(!isnull(ores_stored[O.material]))
			ores_stored[O.material]++
			points += ore_values[O.material] // Give Points!
		qdel(O)

	if(!active)
		return

	//Process our stored ores and spit out sheets.
	var/sheets = 0
	for(var/metal in ores_stored)

		if(sheets >= sheets_per_tick) break

		if(ores_stored[metal] > 0 && ores_processing[metal] != 0)

			var/datum/ore/O = GLOB.ore_data[metal]

			if(!O) continue

			if(ores_processing[metal] == PROCESS_ALLOY && O.alloy) //Alloying.

				for(var/datum/alloy/A in alloy_data)

					if(A.metaltag in tick_alloys)
						continue

					tick_alloys += A.metaltag
					var/enough_metal

					if(!isnull(A.requires[metal]) && ores_stored[metal] >= A.requires[metal]) //We have enough of our first metal, we're off to a good start.

						enough_metal = 1

						for(var/needs_metal in A.requires)
							//Check if we're alloying the needed metal and have it stored.
							if(ores_processing[needs_metal] != PROCESS_ALLOY || ores_stored[needs_metal] < A.requires[needs_metal])
								enough_metal = 0
								break

					if(!enough_metal)
						continue
					else
						var/total
						for(var/needs_metal in A.requires)
							ores_stored[needs_metal] -= A.requires[needs_metal]
							total += A.requires[needs_metal]
							total = max(1,round(total*A.product_mod)) //Always get at least one sheet.
							sheets += total-1

						for(var/i=0,i<total,i++)
							new A.product(output.loc)

			else if(ores_processing[metal] == PROCESS_COMPRESS && O.compresses_to) //Compressing.

				var/can_make = clamp(ores_stored[metal],0,sheets_per_tick-sheets)
				if(can_make%2>0) can_make--

				var/datum/material/M = get_material_by_name(O.compresses_to)

				if(!istype(M) || !can_make || ores_stored[metal] < 1)
					continue

				for(var/i=0,i<can_make,i+=2)
					ores_stored[metal]-=2
					sheets+=2
					new M.stack_type(output.loc)

			else if(ores_processing[metal] == PROCESS_SMELT && O.smelts_to) //Smelting.

				var/can_make = clamp(ores_stored[metal],0,sheets_per_tick-sheets)

				var/datum/material/M = get_material_by_name(O.smelts_to)
				if(!istype(M) || !can_make || ores_stored[metal] < 1)
					continue

				for(var/i=0,i<can_make,i++)
					ores_stored[metal]--
					sheets++
					new M.stack_type(output.loc)
			else
				ores_stored[metal]--
				sheets++
				new /obj/item/ore/slag(output.loc)
		else
			continue

	if(!(tick % 10))
		console.updateUsrDialog()
		tick = 0

#undef PROCESS_NONE
#undef PROCESS_SMELT
#undef PROCESS_COMPRESS
#undef PROCESS_ALLOY
