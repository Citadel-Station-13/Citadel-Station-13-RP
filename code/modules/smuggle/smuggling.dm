/**********************Cargo transit unit console**************************/
#define PROCESS_NONE		0
#define PROCESS_CARGOACTIVE		1

/obj/machinery/smuggling/processing_unit_console
	name = "Cargo transit processing console"
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "console"
	density = TRUE
	anchored = TRUE

	var/obj/item/card/id/inserted_id	// Inserted ID card, for points

	var/obj/machinery/smuggling/processing_unit/machine = null

/obj/machinery/smuggling/processing_unit_console/Initialize(mapload)
	. = ..()
	src.machine = locate(/obj/machinery/smuggling/processing_unit) in range(5, src)
	if (machine)
		machine.console = src
	else
		log_debug(SPAN_DEBUG("Cargo transit processing console at [src.x], [src.y], [src.z] [ADMIN_JMP(src)] could not find its machine!"))
		qdel(src)

/obj/machinery/smuggling/processing_unit_console/Destroy()
	if(inserted_id)
		inserted_id.forceMove(loc) //Prevents deconstructing from deleting whatever ID was inside it.
	. = ..()

/obj/machinery/smuggling/processing_unit_console/attack_hand(mob/user, datum/event_args/actor/clickchain/e_args)
	if(..())
		return
	interact(user)

/obj/machinery/smuggling/processing_unit_console/attackby(var/obj/item/I, var/mob/user)
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

/obj/machinery/smuggling/processing_unit_console/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "MaterialProcessor", name)
		ui.open()

/obj/machinery/smuggling/processing_unit_console/ui_data(mob/user, datum/tgui/ui)
	var/list/data = list()

	var/list/cargotransit = list()
	for(var/cargotransitname in GLOB.cargotransit_data)
		var/datum/cargotransit/O = GLOB.cargotransit_data[cargotransitname]
		cargotransits.Add(list(list(
			"name" = O.name,
			"displayName" = O.display_name,
			"processing" = machine.cargotransits_processing[O.name],
			"amount" = machine.cargotransits_stored[O.name],
			"ref" = REF(O)
		)))

	data["cargotransits"] = cargotransits
	data["on"] = machine.active
	data["fast"] = machine.speed_process
	data["unclaimedPoints"] = machine.points
	if(inserted_id)
		data["idName"] = inserted_id.registered_name
		data["idPoints"] = inserted_id.get_redemption_points(POINT_REDEMPTION_TYPE_SMUGGLE)
	else
		data["idName"] = ""
		data["idPoints"] = 0
	return data

/obj/machinery/smuggling/processing_unit_console/ui_act(action, list/params, datum/tgui/ui)
	if(..())
		return TRUE

	. = TRUE

	add_fingerprint(usr)
	usr.set_machine(src)

	if(action && !issilicon(usr))
		playsound(ui_host(), SFX_ALIAS_TERMINAL, clickvol, TRUE)

	switch(action)
		if("change_mode")
			machine.cargotransits_processing[params["cargotransit"]] = params["mode"]
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
				inserted_id.adjust_redemption_points(POINT_REDEMPTION_TYPE_SMUGGLE, machine.points)
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


/obj/machinery/smuggling/processing_unit
	name = "Cargo transit processor"
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "unloader-corner2"
	density = TRUE
	anchored = TRUE
	light_range = 3
	speed_process = TRUE
	var/tick = 0
	var/obj/machinery/smuggling/input = null
	var/obj/machinery/smuggling/console = null
	var/sheets_per_tick = 20
	var/cargotransits_per_tick = 30
	var/list/cargotransits_processing = list()
	var/list/cargotransits_stored = list()
	var/active = FALSE

	var/points = 0
	var/static/list/cargotransit_values = list(
		"/obj/structure/cargotransitcrate" = 250,
		"/obj/structure/cargotransitcrate/illegal" = 500)

/obj/machinery/smuggling/processing_unit/Initialize(mapload)
	. = ..()
	// TODO - Eschew input/output machinery and just use dirs ~Leshana
	//Locate our output and input machinery.
	for (var/dir in GLOB.cardinal)
		src.input = locate(/obj/machinery/smuggling/input, get_step(src, dir))
		if(src.input) break
	return

/obj/machinery/smuggling/processing_unit/proc/toggle_speed()
	speed_process = !speed_process // switching gears
	if(speed_process) // high gear
		STOP_MACHINE_PROCESSING(src)
		START_PROCESSING(SSprocess_5fps, src)
	else // low gear
		STOP_PROCESSING(SSprocess_5fps, src)
		START_MACHINE_PROCESSING(src)

/obj/machinery/smuggling/processing_unit/process(delta_time)

	if (!src.output || !src.input)
		return

	if(panel_open || !powered())
		return

	var/list/tick_alloys = list()
	tick++

	//Grab some more cargotransit to process this tick.
	//Takes cargotransits_per_tick per tick from the various stacks of cargotransits nearby. It'll likely loop at least 0-2 times per tick.
	for(var/i = 0, i < cargotransits_per_tick, i++)
		var/obj/item/stack/cargotransit/O = locate() in input.loc
		if(!O)
			break
		var/taking = min(cargotransits_per_tick - i, O.amount)
		if(!isnull(cargotransits_stcargotransitd[O.material]))
			cargotransits_stcargotransitd[O.material] += taking
			points += cargotransit_values[O.material] * taking // Give Points!
		i += taking
		O.use(taking)

	if(!active)
		return



#undef PROCESS_NONE
#undef PROCESS_CARGOACTIVE

/obj/machinery/smuggling/processing_unit/nt
	name = "NT Cargo transit processor"
	var/static/list/cargotransit_values = list(
		"/obj/structure/cargotransitcrate/ftu" = 260,
		"/obj/structure/cargotransitcrate/miaphus" = 275,
		"/obj/structure/cargotransitcrate/gaia" = 275,
		"/obj/structure/cargotransitcrate/sky" = 275,
		"/obj/structure/cargotransitcrate/atlas" = 105
		)


/obj/machinery/smuggling/processing_unit/ftu
	name = "FTU Cargo transit processor"
	var/static/list/cargotransit_values = list(
		"/obj/structure/cargotransitcrate/nt" = 270,
		"/obj/structure/cargotransitcrate/miaphus" = 285,
		"/obj/structure/cargotransitcrate/gaia" = 260,
		"/obj/structure/cargotransitcrate/sky" = 285,
		"/obj/structure/cargotransitcrate/atlas" = 300,
		"/obj/structure/cargotransitcrate/illegal/pirate" = 550,
		"/obj/structure/cargotransitcrate/illegal/merc" = 500,
		"/obj/structure/cargotransitcrate/illegal/rebel" = 500,
		"/obj/structure/cargotransitcrate/illegal/drugs" = 600,
		"/obj/structure/cargotransitcrate/illegal/nka" = 500,
		"/obj/structure/cargotransitcrate/illegal/operative" = 500,
		)

/obj/machinery/smuggling/processing_unit/miaphus
	name = "Miaphus Cargo transit processor"
	var/static/list/cargotransit_values = list(
		"/obj/structure/cargotransitcrate/nt" = 250,
		"/obj/structure/cargotransitcrate/ftu" = 250,
		"/obj/structure/cargotransitcrate/gaia" = 250,
		"/obj/structure/cargotransitcrate/sky" = 260,
		"/obj/structure/cargotransitcrate/atlas" = 285,
		"/obj/structure/cargotransitcrate/illegal/pirate" = 500,
		"/obj/structure/cargotransitcrate/illegal/ftu" = 500,
		"/obj/structure/cargotransitcrate/illegal/rebel" = 550,
		"/obj/structure/cargotransitcrate/illegal/drugs" = 500,
		"/obj/structure/cargotransitcrate/illegal/nka" = 600,
		"/obj/structure/cargotransitcrate/illegal/operative" = 500,
		)

/obj/machinery/smuggling/processing_unit/gaia
	name = "Gaia Cargo transit processor"
	var/static/list/cargotransit_values = list(
		"/obj/structure/cargotransitcrate/nt" = 250,
		"/obj/structure/cargotransitcrate/ftu" = 300,
		"/obj/structure/cargotransitcrate/miaphus" = 250,
		"/obj/structure/cargotransitcrate/sky" = 250,
		"/obj/structure/cargotransitcrate/atlas" = 250,
		"/obj/structure/cargotransitcrate/illegal/pirate" = 500,
		"/obj/structure/cargotransitcrate/illegal/merc" = 500,
		"/obj/structure/cargotransitcrate/illegal/rebel" = 500,
		"/obj/structure/cargotransitcrate/illegal/drugs" = 600,
		"/obj/structure/cargotransitcrate/illegal/nka" = 500,
		"/obj/structure/cargotransitcrate/illegal/operative" = 500,
		"/obj/structure/cargotransitcrate/illegal/ftu" = 500,
		)

/obj/machinery/smuggling/processing_unit/sky
	name = "Sky Planet Cargo transit processor"
	var/static/list/cargotransit_values = list(
		"/obj/structure/cargotransitcrate/nt" = 250,
		"/obj/structure/cargotransitcrate/ftu" = 250,
		"/obj/structure/cargotransitcrate/miaphus" = 300,
		"/obj/structure/cargotransitcrate/gaia" = 250,
		"/obj/structure/cargotransitcrate/atlas" = 250,
		"/obj/structure/cargotransitcrate/illegal/pirate" = 500,
		"/obj/structure/cargotransitcrate/illegal/merc" = 600,
		"/obj/structure/cargotransitcrate/illegal/ftu" = 500,
		"/obj/structure/cargotransitcrate/illegal/drugs" = 500,
		"/obj/structure/cargotransitcrate/illegal/nka" = 550,
		"/obj/structure/cargotransitcrate/illegal/operative" = 500,
		)

/obj/machinery/smuggling/processing_unit/casino
	name = "Casino Cargo transit processor"
	var/static/list/cargotransit_values = list(
		"/obj/structure/cargotransitcrate/nt" = 285,
		"/obj/structure/cargotransitcrate/ftu" = 270,
		"/obj/structure/cargotransitcrate/miaphus" = 250,
		"/obj/structure/cargotransitcrate/gaia" = 300,
		"/obj/structure/cargotransitcrate/atlas" = 250,
		"/obj/structure/cargotransitcrate/sky" = 270,
		"/obj/structure/cargotransitcrate/illegal/pirate" = 600,
		"/obj/structure/cargotransitcrate/illegal/merc" = 600,
		"/obj/structure/cargotransitcrate/illegal/ftu" = 550,
		"/obj/structure/cargotransitcrate/illegal/nka" = 550,
		"/obj/structure/cargotransitcrate/illegal/rebel" = 500,
		"/obj/structure/cargotransitcrate/illegal/operative" = 550,
		)

/obj/machinery/smuggling/processing_unit/classd
	name = "Class D transit processor"
	var/static/list/cargotransit_values = list(
		"/obj/structure/cargotransitcrate/nt" = 285,
		"/obj/structure/cargotransitcrate/ftu" = 285,
		"/obj/structure/cargotransitcrate/miaphus" = 285,
		"/obj/structure/cargotransitcrate/sky" = 300,
		"/obj/structure/cargotransitcrate/atlas" = 285,
		"/obj/structure/cargotransitcrate/illegal/pirate" = 500,
		"/obj/structure/cargotransitcrate/illegal/merc" = 550,
		"/obj/structure/cargotransitcrate/illegal/rebel" = 600,
		"/obj/structure/cargotransitcrate/illegal/drugs" = 500,
		"/obj/structure/cargotransitcrate/illegal/nka" = 550,
		"/obj/structure/cargotransitcrate/illegal/ftu" = 600,
		)
