/*
	Integrated circuits are essentially modular machines.  Each circuit has a specific function, and combining them inside Electronic Assemblies allows
a creative player the means to solve many problems.  Circuits are held inside an electronic assembly, and are wired using special tools.
*/

/obj/item/integrated_circuit
	name = "integrated circuit"
	desc = "It's a tiny chip!  This one doesn't seem to do much, however."
	icon = 'icons/obj/integrated_electronics/electronic_components.dmi'
	icon_state = "template"
	w_class = ITEMSIZE_TINY
	/// Reference to the assembly holding this circuit, if any.
	var/obj/item/electronic_assembly/assembly = null
	var/extended_desc = null
	var/can_be_asked_input = 0
	var/list/inputs = list()
	/// Assoc list which will fill a pin with data upon creation.  e.g. "2" = 0 will set input pin 2 to equal 0 instead of null.
	var/list/inputs_default = list()
	var/list/outputs = list()
	/// Ditto, for output.
	var/list/outputs_default = list()
	var/list/activators = list()
	///Uses world.time
	var/next_use = 0
	///This acts as a limitation on building machines, more resource-intensive components cost more 'space'.
	var/complexity = 1
	var/size = null
	///This acts as a limitation on building machines, bigger components cost more 'space'. -1 for size 0
	var/cost = 1
	/// Circuits are limited in how many times they can be work()'d by this variable.
	var/cooldown_per_use = IC_DEFAULT_COOLDOWN
	/// Circuits are limited in how many times they can be work()'d with external world by this variable.
	var/ext_cooldown = 0
	/// How much power is drawn when work()'d.
	var/power_draw_per_use = 0
	/// How much power is drawn when doing nothing.
	var/power_draw_idle = 0
	/// Used for world initializing, see the #defines above.
	var/spawn_flags = null
	/// Used for telling circuits that can do certain actions from other circuits.
	var/action_flags = NONE
	/// To show up on circuit printer, and perhaps other places.
	var/category_text = "NO CATEGORY THIS IS A BUG"
	/// Determines if a circuit is removable from the assembly.
	var/removable = TRUE
	var/displayed_name = ""
	/// Allows additional multitool functionality
	var/allow_multitool = 1

/obj/item/integrated_circuit/examine(mob/user)
	. = ..()
	external_examine(user)
	ui_interact(user)

/// Can be called via electronic_assembly/attackby()
/obj/item/integrated_circuit/proc/additem(var/obj/item/I, var/mob/living/user)
	attackby(I, user)

/// This should be used when someone is examining while the case is opened.
/obj/item/integrated_circuit/proc/internal_examine(mob/user)
	to_chat(user, "This board has [inputs.len] input pin\s, [outputs.len] output pin\s and [activators.len] activation pin\s.")
	for(var/datum/integrated_io/I in inputs)
		if(I.linked.len)
			to_chat(user, "The '[I]' is connected to [I.get_linked_to_desc()].")
	for(var/datum/integrated_io/O in outputs)
		if(O.linked.len)
			to_chat(user, "The '[O]' is connected to [O.get_linked_to_desc()].")
	for(var/datum/integrated_io/activate/A in activators)
		if(A.linked.len)
			to_chat(user, "The '[A]' is connected to [A.get_linked_to_desc()].")
	to_chat(user, any_examine(user))
	ui_interact(user)

/// This should be used when someone is examining from an 'outside' perspective, e.g. reading a screen or LED.
/obj/item/integrated_circuit/proc/external_examine(mob/user)
	return any_examine(user)

/obj/item/integrated_circuit/proc/any_examine(mob/user)
	return

/obj/item/integrated_circuit/proc/attackby_react(var/atom/movable/A,mob/user)
	return

/obj/item/integrated_circuit/proc/sense(var/atom/movable/A,mob/user,prox)
	return

/obj/item/integrated_circuit/Initialize(mapload)
	displayed_name = name
	if(!size)
		size = w_class
	if(!cost)
		cost = size * IC_MATERIAL_MODIFIER
	if(size == -1)
		size = 0
	setup_io(inputs, /datum/integrated_io, inputs_default, IC_INPUT)
	setup_io(outputs, /datum/integrated_io, outputs_default, IC_OUTPUT)
	setup_io(activators, /datum/integrated_io/activate, null, IC_ACTIVATOR)
	. = ..()

/obj/item/integrated_circuit/proc/on_data_written() //Override this for special behaviour when new data gets pushed to the circuit.
	return

/obj/item/integrated_circuit/Destroy()
	QDEL_LIST(inputs)
	QDEL_LIST(outputs)
	QDEL_LIST(activators)
	. = ..()

/obj/item/integrated_circuit/emp_act(severity)
	for(var/datum/integrated_io/io in inputs + outputs + activators)
		io.scramble()

/obj/item/integrated_circuit/proc/check_interactivity(mob/user)
	return ui_status(user, GLOB.physical_state) && !assembly || assembly.opened == UI_INTERACTIVE

/obj/item/integrated_circuit/verb/rename_component()
	set name = "Rename Circuit"
	set category = "Object"
	set desc = "Rename your circuit, useful to stay organized."

	var/mob/M = usr
	var/input = tgui_input_text(usr, "What do you want to name this circuit?", "Rename", src.name, MAX_NAME_LEN)
	if(src && input)
		to_chat(M, SPAN_NOTICE("The circuit '[src.name]' is now labeled '[input]'."))
		displayed_name = input

/obj/item/integrated_circuit/ui_state(mob/user)
	return GLOB.physical_state

/obj/item/integrated_circuit/ui_host(mob/user)
	if(istype(loc, /obj/item/electronic_assembly))
		return loc.ui_host()
	return ..()

/obj/item/integrated_circuit/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ICCircuit", name, parent_ui)
		ui.open()

/obj/item/integrated_circuit/ui_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	var/list/data = ..()

	data["name"] = name
	data["desc"] = desc
	data["displayed_name"] = displayed_name
	data["removable"] = removable

	data["complexity"] = complexity
	data["power_draw_idle"] = power_draw_idle
	data["power_draw_per_use"] = power_draw_per_use
	data["extended_desc"] = extended_desc
	data["cooldown_per_use"] = cooldown_per_use
	data["ext_cooldown"] = ext_cooldown

	var/list/inputs_list = list()
	var/list/outputs_list = list()
	var/list/activators_list = list()
	for(var/datum/integrated_io/io in inputs)
		inputs_list.Add(list(tgui_pin_data(io)))

	for(var/datum/integrated_io/io in outputs)
		outputs_list.Add(list(tgui_pin_data(io)))

	for(var/datum/integrated_io/io in activators)
		var/list/list/activator = list(
			"ref" = REF(io),
			"name" = io.name,
			"pulse_out" = io.data,
			"linked" = list()
		)
		for(var/datum/integrated_io/linked in io.linked)
			activator["linked"].Add(list(list(
				"ref" = REF(linked),
				"name" = linked.name,
				"holder_ref" = REF(linked.holder),
				"holder_name" = linked.holder.displayed_name,
			)))

		activators_list.Add(list(activator))

	data["inputs"] = inputs_list
	data["outputs"] = outputs_list
	data["activators"] = activators_list

	return data

/obj/item/integrated_circuit/proc/tgui_pin_data(datum/integrated_io/io)
	if(!istype(io))
		return list()
	var/list/pindata = list()
	pindata["type"] = io.display_pin_type()
	pindata["name"] = io.name
	pindata["data"] = io.display_data(io.data)
	pindata["ref"] = REF(io)
	var/list/linked_list = list()
	for(var/datum/integrated_io/linked in io.linked)
		linked_list.Add(list(list(
			"ref" = REF(linked),
			"name" = linked.name,
			"holder_ref" = REF(linked.holder),
			"holder_name" = linked.holder.displayed_name,
		)))
	pindata["linked"] = linked_list

	return pindata

/obj/item/integrated_circuit/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE

	var/datum/integrated_io/pin = locate(params["pin"]) in inputs + outputs + activators
	var/datum/integrated_io/linked = null

	if(params["link"])
		linked = locate(params["link"]) in pin.linked

	var/obj/held_item = usr.get_active_hand()

	. = TRUE
	switch(action)
		if("rename")
			rename_component(usr)
			return

		if("wire", "pin_name", "pin_data", "pin_unwire")
			if(istype(held_item, /obj/item/multitool) && allow_multitool)
				var/obj/item/multitool/M = held_item
				switch(action)
					if("pin_name")
						M.wire(pin, usr)
					if("pin_data")
						var/datum/integrated_io/io = pin
						io.ask_for_pin_data(usr, held_item) // The pins themselves will determine how to ask for data, and will validate the data.
					if("pin_unwire")
						M.unwire(pin, linked, usr)

			else if(istype(held_item, /obj/item/integrated_electronics/wirer))
				var/obj/item/integrated_electronics/wirer/wirer = held_item
				if(linked)
					wirer.wire(linked, usr)
				else if(pin)
					wirer.wire(pin, usr)

			else if(istype(held_item, /obj/item/integrated_electronics/debugger))
				var/obj/item/integrated_electronics/debugger/debugger = held_item
				if(pin)
					debugger.write_data(pin, usr)
			else
				to_chat(usr, SPAN_WARNING("You can't do a whole lot without the proper tools."))
			return

		if("scan")
			if(istype(held_item, /obj/item/integrated_electronics/debugger))
				var/obj/item/integrated_electronics/debugger/D = held_item
				if(D.accepting_refs)
					D.afterattack(src, usr, TRUE)
				else
					to_chat(usr, SPAN_WARNING("The Debugger's 'ref scanner' needs to be on."))
			else
				to_chat(usr, SPAN_WARNING("You need a multitool/debugger set to 'ref' mode to do that."))
			return

		if("examine")
			var/obj/item/integrated_circuit/examined = locate(params["ref"])
			if(istype(examined) && (examined.loc == loc))
				if(ui.parent_ui)
					examined.ui_interact(usr, null, ui.parent_ui)
				else
					examined.ui_interact(usr)

		if("remove")
			remove(usr, index = params["index"])
			return
	return FALSE

/obj/item/integrated_circuit/proc/remove(mob/user, silent, index)
	var/obj/item/electronic_assembly/A = assembly
	if(!A && !silent)
		to_chat(user, SPAN_WARNING("This circuit is not in an assembly!"))
		return
	if(!removable && !silent)
		to_chat(user, SPAN_WARNING("\The [src] seems to be permanently attached to the case."))
		return
	var/obj/item/electronic_assembly/ea = loc

	power_fail()
	disconnect_all()
	// Remove from helper and TGUI lists
	A.ui_circuit_props.Cut(index, index + 1)
	A.assembly_components.Cut(index, index + 1)

	var/turf/T = get_turf(src)
	forceMove(T)
	assembly = null
	if(!silent)
		playsound(T, 'sound/items/Crowbar.ogg', 50, TRUE)
		to_chat(user, SPAN_NOTICE("You pop \the [src] out of the case, and slide it out."))

	if(istype(ea))
		ea.ui_interact(user)


/obj/item/integrated_circuit/proc/push_data()
	for(var/datum/integrated_io/O in outputs)
		O.push_data()

//! Don't use this!  Very bad!  Takes all data from attached pins regardless of pulse state.  Make sure you understand the consequences of this if you insist on using it.
/obj/item/integrated_circuit/proc/pull_data()
	for(var/datum/integrated_io/I in inputs)
		I.push_data()

/obj/item/integrated_circuit/proc/draw_idle_power()
	if(assembly)
		return assembly.draw_power(power_draw_idle)

/// Override this for special behaviour when there's no power left.
/obj/item/integrated_circuit/proc/power_fail()
	return

/// Returns true if there's enough power to work().
/obj/item/integrated_circuit/proc/check_power()
	if(!assembly)
		return FALSE // Not in an assembly, therefore no power.
	if(assembly.draw_power(power_draw_per_use))
		return TRUE // Battery has enough.
	return FALSE // Not enough power.

/obj/item/integrated_circuit/proc/check_then_do_work(ord, ignore_power = FALSE)
	if(world.time < next_use) 	// All intergrated circuits have an internal cooldown, to protect from spam.
		return FALSE
	if(assembly && ext_cooldown && (world.time < assembly.ext_next_use)) 	// Some circuits have external cooldown, to protect from spam.
		return FALSE
	if(power_draw_per_use && !ignore_power)
		if(!check_power())
			power_fail()
			return FALSE
	next_use = world.time + cooldown_per_use
	if(assembly)
		assembly.ext_next_use = world.time + ext_cooldown
	do_work(ord)
	return TRUE

/obj/item/integrated_circuit/proc/do_work(ord)
	return

/obj/item/integrated_circuit/proc/disconnect_all()
	var/datum/integrated_io/I

	for(var/i in inputs)
		I = i
		I.disconnect_all()

	for(var/i in outputs)
		I = i
		I.disconnect_all()

	for(var/i in activators)
		I = i
		I.disconnect_all()

/obj/item/integrated_circuit/proc/ext_moved(oldLoc, dir)
	return


/// Returns the object that is supposed to be used in attack messages, location checks, etc.
/obj/item/integrated_circuit/proc/get_object()
	// If the component is located in an assembly, let assembly determine it.
	if(assembly)
		return assembly.get_object()
	else
		return src	// If not, the component is acting on its own.


/// Returns the location to be used for dropping items.
/// Same as the regular drop_location(), but with proc being run on assembly if there is any.
/obj/item/integrated_circuit/drop_location()
	// If the component is located in an assembly, let the assembly figure that one out.
	if(assembly)
		return assembly.drop_location()
	else
		return ..()	// If not, the component is acting on its own.


/// Checks if the target object is reachable.  Useful for various manipulators and manipulator-like objects.
/obj/item/integrated_circuit/proc/check_target(atom/target, exclude_contents = FALSE, exclude_components = FALSE, exclude_self = FALSE, exclude_outside = FALSE)
	if(!target)
		return FALSE

	var/atom/movable/acting_object = get_object()

	if(exclude_self && target == acting_object)
		return FALSE
	if(exclude_components && assembly)
		if(target in assembly.assembly_components)
			return FALSE
		if(target == assembly.battery)
			return FALSE
	if(!exclude_outside && target.Adjacent(acting_object) && isturf(target.loc))
		return TRUE
	if(!exclude_contents && (target in acting_object.GetAllContents()))
		return TRUE
	if(target in acting_object.loc)
		return TRUE
	return FALSE
/*  TBI: Hand recog
/obj/item/integrated_circuit/can_trigger_gun(mob/living/user)
	if(!user.is_holding(src))
		return FALSE
	return ..()
*/
/obj/item/integrated_circuit/proc/on_anchored()
	return

/obj/item/integrated_circuit/proc/on_unanchored()
	return
