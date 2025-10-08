/**********************Mineral processing unit console**************************/
#define PROCESS_NONE		0
#define PROCESS_SMELT		1
#define PROCESS_COMPRESS	2
#define PROCESS_ALLOY		3

/obj/machinery/mineral/processing_unit_console
	name = "production machine console"
	icon = 'icons/obj/machines/mining_machines.dmi'
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
		log_debug(SPAN_DEBUG("Ore processing machine console at [src.x], [src.y], [src.z] [ADMIN_JMP(src)] could not find its machine!"))
		qdel(src)

/obj/machinery/mineral/processing_unit_console/Destroy()
	if(inserted_id)
		inserted_id.forceMove(loc) //Prevents deconstructing from deleting whatever ID was inside it.
	. = ..()

/obj/machinery/mineral/processing_unit_console/attack_hand(mob/user, datum/event_args/actor/clickchain/e_args)
	if(..())
		return
	interact(user)

/obj/machinery/mineral/processing_unit_console/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/card/id))
		if(!powered())
			return
		if(!inserted_id)
			if(!user.attempt_insert_item_for_installation(I, src))
				return
			playsound(src, 'sound/machines/terminal_insert_disc.ogg', clickvol, TRUE)
			inserted_id = I
			interact(user)
		return
	..()

/obj/machinery/mineral/processing_unit_console/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "MaterialProcessor", name)
		ui.open()

/obj/machinery/mineral/processing_unit_console/ui_data(mob/user, datum/tgui/ui)
	var/list/data = list()

	var/list/ores = list()
	for(var/orename in GLOB.ore_data)
		var/datum/ore/O = GLOB.ore_data[orename]
		ores.Add(list(list(
			"name" = O.name,
			"displayName" = O.display_name,
			"processing" = machine.ores_processing[O.name],
			"amount" = machine.ores_stored[O.name],
			"ref" = REF(O)
		)))

	data["ores"] = ores
	data["on"] = machine.active
	data["fast"] = machine.speed_process
	data["unclaimedPoints"] = machine.points
	if(inserted_id)
		data["idName"] = inserted_id.registered_name
		data["idPoints"] = inserted_id.get_redemption_points(POINT_REDEMPTION_TYPE_MINING)
	else
		data["idName"] = ""
		data["idPoints"] = 0
	return data

/obj/machinery/mineral/processing_unit_console/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state, datum/event_args/actor/actor)
	if(..())
		return TRUE

	. = TRUE

	add_fingerprint(usr)
	usr.set_machine(src)

	if(action && !issilicon(usr))
		playsound(ui_host(), SFX_ALIAS_TERMINAL, clickvol, TRUE)

	switch(action)
		if("change_mode")
			machine.ores_processing[params["ore"]] = params["mode"]
			return TRUE

		if("toggle_power")
			machine.active = !machine.active
			playsound(src.loc, 'sound/machines/terminal_prompt_confirm.ogg', clickvol, 0)
			return TRUE

		if("toggle_speed")
			machine.toggle_speed()
			return TRUE

		if("eject_id")
			if(istype(inserted_id))
				usr.grab_item_from_interacted_with(inserted_id, src)
				playsound(src, 'sound/machines/terminal_eject.ogg', clickvol, 0)
				inserted_id = null
				return TRUE
		if("claim_points")
			if(istype(inserted_id))
				inserted_id.adjust_redemption_points(POINT_REDEMPTION_TYPE_MINING, machine.points)
				machine.points = 0
				playsound(src.loc, 'sound/machines/ping.ogg', clickvol, 0)
				return TRUE
		if("insert_id")
			var/obj/item/card/id/I = usr.get_active_held_item()
			if(istype(I))
				if(!usr.attempt_insert_item_for_installation(I, src))
					return
				playsound(src, 'sound/machines/terminal_insert_disc.ogg', clickvol, 0)
				inserted_id = I
				return TRUE
			else
				to_chat(usr, "<span class='warning'>No valid ID.</span>")

	return FALSE

/**********************Mineral processing unit**************************/


/obj/machinery/mineral/processing_unit
	name = "material processor" //This isn't actually a goddamn furnace, we're in space and it's processing platinum and flammable phoron...
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "furnace"
	density = TRUE
	anchored = TRUE
	light_range = 3
	speed_process = TRUE
	var/tick = 0
	var/obj/machinery/mineral/input = null
	var/obj/machinery/mineral/output = null
	var/obj/machinery/mineral/console = null
	var/sheets_per_tick = 20
	var/ores_per_tick = 30
	var/list/ores_processing = list()
	var/list/ores_stored = list()
	var/static/list/alloy_data
	var/active = FALSE

	var/points = 0
	var/static/list/ore_values = list(
		"sand" = 1,
		MAT_HEMATITE = 1,
		MAT_CARBON = 1,
		MAT_PHORON = 15,
		MAT_COPPER = 15,
		MAT_SILVER = 16,
		MAT_GOLD = 18,
		MAT_MARBLE = 20,
		MAT_URANIUM = 30,
		MAT_DIAMOND = 50,
		MAT_PLATINUM = 40,
		MAT_LEAD = 40,
		MAT_METALHYDROGEN = 40,
		MAT_VAUDIUM = 50,
		MAT_VERDANTIUM = 60)

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
	// TODO - Eschew input/output machinery and just use dirs ~Leshana
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
		START_PROCESSING(SSprocess_5fps, src)
	else // low gear
		STOP_PROCESSING(SSprocess_5fps, src)
		START_MACHINE_PROCESSING(src)

/obj/machinery/mineral/processing_unit/process(delta_time)

	if (!src.output || !src.input)
		return

	if(panel_open || !powered())
		return

	var/list/tick_alloys = list()
	tick++

	//Grab some more ore to process this tick.
	//Takes ores_per_tick per tick from the various stacks of ores nearby. It'll likely loop at least 0-2 times per tick.
	for(var/i = 0, i < ores_per_tick, i++)
		var/obj/item/stack/ore/O = locate() in input.loc
		if(!O)
			break
		var/taking = min(ores_per_tick - i, O.amount)
		if(!isnull(ores_stored[O.material]))
			ores_stored[O.material] += taking
			points += ore_values[O.material] * taking // Give Points!
		i += taking
		O.use(taking)

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

				var/datum/prototype/material/M = get_material_by_name(O.compresses_to)

				if(!istype(M) || !can_make || ores_stored[metal] < 1)
					continue

				for(var/i=0,i<can_make,i+=2)
					ores_stored[metal]-=2
					sheets+=2
					new M.stack_type(output.loc)

			else if(ores_processing[metal] == PROCESS_SMELT && O.smelts_to) //Smelting.

				var/can_make = clamp(ores_stored[metal],0,sheets_per_tick-sheets)

				var/datum/prototype/material/M = get_material_by_name(O.smelts_to)
				if(!istype(M) || !can_make || ores_stored[metal] < 1)
					continue

				for(var/i=0,i<can_make,i++)
					ores_stored[metal]--
					sheets++
					new M.stack_type(output.loc)
			else
				ores_stored[metal]--
				sheets++
				new /obj/item/stack/ore/slag(output.loc)
		else
			continue

	if(!(tick % 10))
		console.updateUsrDialog()
		tick = 0

#undef PROCESS_NONE
#undef PROCESS_SMELT
#undef PROCESS_COMPRESS
#undef PROCESS_ALLOY
