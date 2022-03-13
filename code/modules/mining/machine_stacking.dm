/**********************Mineral stacking unit console**************************/

/obj/machinery/mineral/stacking_unit_console
	name = "stacking machine console"
	icon = 'icons/obj/machines/mining_machines_vr.dmi'  // VOREStation Edit
	icon_state = "console"
	density = TRUE
	anchored = TRUE
	var/obj/machinery/mineral/stacking_machine/machine = null
	//var/machinedir = SOUTHEAST //This is really dumb, so lets burn it with fire.

/obj/machinery/mineral/stacking_unit_console/Initialize(mapload)
	. = ..()
	return INITIALIZE_HINT_LATELOAD

// this is garbage code hecc off
/obj/machinery/mineral/stacking_unit_console/LateInitialize()
	machine = locate(/obj/machinery/mineral/stacking_machine) in range(5,src)
	if(machine)
		machine.console = src
	else
		//Silently failing and causing mappers to scratch their heads while runtiming isn't ideal.
			// yeah well telling the world chat before anyone even connected without logging isn't ideal either, 5brain.
		stack_trace("Stacking machine console at [COORD(src)] could not find its machine!")
		qdel(src)

/obj/machinery/mineral/stacking_unit_console/attack_hand(mob/user)
	add_fingerprint(user)
	ui_interact(user)

/obj/machinery/mineral/stacking_unit_console/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "MiningStackingConsole", name)
		ui.open()

/obj/machinery/mineral/stacking_unit_console/ui_data(mob/user)
	var/list/data = ..()

	var/list/stacktypes = list()
	for(var/stacktype in machine.stack_storage)
		if(machine.stack_storage[stacktype] > 0)
			stacktypes.Add(list(list(
				"type" = stacktype,
				"amt" = machine.stack_storage[stacktype],
			)))
	data["stacktypes"] = stacktypes
	data["stackingAmt"] = machine.stack_amt
	return data

/obj/machinery/mineral/stacking_unit_console/ui_act(action, list/params)
	if(..())
		return TRUE

	switch(action)
		if("change_stack")
			machine.stack_amt = clamp(text2num(params["amt"]), 1, 50)
			. = TRUE

		if("release_stack")
			var/stack = params["stack"]
			if(machine.stack_storage[stack] > 0)
				var/stacktype = machine.stack_paths[stack]
				var/obj/item/stack/material/S = new stacktype(get_turf(machine.output))
				S.amount = machine.stack_storage[stack]
				machine.stack_storage[stack] = 0
				S.update_icon()
			. = TRUE

	add_fingerprint(usr)

/**********************Mineral stacking unit**************************/


/obj/machinery/mineral/stacking_machine
	name = "stacking machine"
	icon = 'icons/obj/machines/mining_machines_vr.dmi' // VOREStation Edit
	icon_state = "stacker"
	density = TRUE
	anchored = TRUE
	var/obj/machinery/mineral/stacking_unit_console/console
	var/obj/machinery/mineral/input = null
	var/obj/machinery/mineral/output = null
	var/list/stack_storage
	var/list/stack_paths
	var/stack_amt = 50; // Amount to stack before releassing

/obj/machinery/mineral/stacking_machine/Initialize(mapload)
	. = ..()
	stack_storage = list()
	stack_paths = list()

	for(var/stacktype in subtypesof(/obj/item/stack/material))
		var/obj/item/stack/S = new stacktype
		stack_storage[S.name] = 0
		stack_paths[S.name] = stacktype
		qdel(S)

	stack_storage["glass"] = 0
	stack_paths["glass"] = /obj/item/stack/material/glass
	stack_storage[DEFAULT_WALL_MATERIAL] = 0
	stack_paths[DEFAULT_WALL_MATERIAL] = /obj/item/stack/material/steel
	stack_storage["plasteel"] = 0
	stack_paths["plasteel"] = /obj/item/stack/material/plasteel
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/mineral/stacking_machine/LateInitialize()
	for (var/dir in GLOB.cardinal)
		input = locate(/obj/machinery/mineral/input, get_step(src, dir))
		if(input)
			break
	for (var/dir in GLOB.cardinal)
		output = locate(/obj/machinery/mineral/output, get_step(src, dir))
		if(output)
			break

/obj/machinery/mineral/stacking_machine/process(delta_time)
	if(!input || !output)
		return
	var/turf/inturf = get_turf(input)
	var/turf/outturf = get_turf(output)
	for(var/obj/item/I in inturf.contents)
		if(istype(I, /obj/item/stack) && !isnull(stack_storage[I.name]))
			var/obj/item/stack/S = I
			stack_storage[S.name] += S.amount
			qdel(S)
			continue
		I.forceMove(outturf)

	//Output amounts that are past stack_amt.
	for(var/sheet in stack_storage)
		if(stack_storage[sheet] >= stack_amt)
			var/stacktype = stack_paths[sheet]
			var/obj/item/stack/material/S = new stacktype(get_turf(output))
			S.amount = stack_amt
			stack_storage[sheet] -= stack_amt
			S.update_icon()

	console.updateUsrDialog()
