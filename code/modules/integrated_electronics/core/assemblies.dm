// Here is where the base definition lives.
// Specific subtypes are in their own folder.
/obj/item/electronic_assembly
	name = "electronic assembly"
	obj_flags = CAN_BE_HIT
	desc = "It's a case, for building small electronics with."
	w_class = ITEMSIZE_SMALL
	icon = 'icons/obj/integrated_electronics/electronic_setups.dmi'
	icon_state = "setup_small"
	item_flags = ITEM_NOBLUDGEON
	show_messages = TRUE
	datum_flags = DF_USE_TAG
	var/list/assembly_components = list()
	var/list/ui_circuit_props = list()
	/// Players who built the circuit can scan it as a ghost.
	var/list/ckeys_allowed_to_scan = list()
	var/max_components = IC_COMPONENTS_BASE
	var/max_complexity = IC_COMPLEXITY_BASE
	var/opened = FALSE
	/// Internal cell which most circuits need to work.
	var/obj/item/cell/device/battery = null
	/// Set every tick, to display how much power is being drawn in total.
	var/net_power = 0
	/// Can it be charged in a recharger?
	var/can_charge = TRUE
	/// Can it fire/throw weapons when the assembly is being held?
	var/can_fire_equipped = FALSE
	var/charge_sections = 4
	var/charge_tick = FALSE
	var/charge_delay = 4
	var/use_cyborg_cell = TRUE
	/// Time until circuit cn perform another external action
	var/ext_next_use = 0
	var/atom/collw
	var/obj/item/card/id/access_card
	/// Which circuit flags are allowed
	var/allowed_circuit_action_flags = IC_ACTION_COMBAT | IC_ACTION_LONG_RANGE
	/// Number of combat cicuits in the assembly, used for diagnostic hud
	var/combat_circuits = 0
	/// Number of long range cicuits in the assembly, used for diagnostic hud
	var/long_range_circuits = 0
	/// Used by the AR circuit to change the hud icon.
	var/prefered_hud_icon = "hudstat"
	/// Circuit creator ckey if any
	var/creator
	var/static/next_assembly_id = 0
// TBI	var/hud_possible = list(DIAG_STAT_HUD, DIAG_BATT_HUD, DIAG_TRACK_HUD, DIAG_CIRCUIT_HUD) //diagnostic hud overlays
	/// If true, wrenching it will anchor it.
	var/can_anchor = TRUE
	/// Holds a ref to the circuit which is currently bolting the assembly, if applicable.
	var/anchored_by = null
	/// Incremented by panel locking circuits.
	var/panel_locked = null
	var/detail_color = COLOR_ASSEMBLY_BLACK
	/// Cost set to default during init if unset.
	var/cost = 0

/obj/item/electronic_assembly/GenerateTag()
	tag = "assembly_[next_assembly_id++]"

/obj/item/electronic_assembly/examine(mob/user)
	. = ..()
	if(can_anchor)
		. += "<span class='notice'>The anchoring bolts [anchored ? "are" : "can be"] <b>wrenched</b> in place and the maintenance panel [opened ? "can be" : "is"] <b>screwed</b> in place.</span>"
	else
		. += "<span class='notice'>The maintenance panel [opened ? "can be" : "is"] <b>screwed</b> in place.</span>"

	// Not using internal examine? Why? TBI? Will test how horrible/spammy it is.
	for(var/I in assembly_components)
		var/obj/item/integrated_circuit/IC = I
		var/text = IC.external_examine(user)
		if(text)
			. += text

	if(Adjacent(user))
		var/datum/tgui/ui = SStgui.get_open_ui(src.loc, src)
		if(ui)
			ui_interact(user, ui, ui)
		else ui_interact(user)

	if(isobserver(user))
		if(isobserver(user) && ckeys_allowed_to_scan[user.ckey] || IsAdminGhost(user))
			. += "You can <a href='?src=[REF(src)];ghostscan=1'>scan</a> this circuit."
		ui_interact(user)

/obj/item/electronic_assembly/Bump(atom/AM)
	collw = AM
	.=..()
	if((istype(collw, /obj/machinery/door/airlock) ||  istype(collw, /obj/machinery/door/window)) && (!isnull(access_card)))
		var/obj/machinery/door/D = collw
		if(D.check_access(access_card))
			D.open()

/obj/item/electronic_assembly/Initialize(mapload)
	battery = new(src)
	src.max_components = round(max_components)
	src.max_complexity = round(max_complexity)
	if(!cost)
		cost = IC_ASSEMBLY_COST(src)
	START_PROCESSING(SSobj, src)
/* TBI //sets up diagnostic hud view
	prepare_huds()
	for(var/datum/atom_hud/data/diagnostic/diag_hud in GLOB.huds)
		diag_hud.add_to_hud(src)
	diag_hud_set_circuithealth()
	diag_hud_set_circuitcell()
	diag_hud_set_circuitstat()
	diag_hud_set_circuittracking()
*/
	access_card = new /obj/item/card/id(src)
	. =..()

/obj/item/electronic_assembly/Destroy()
	battery = null // It will be qdel'd by ..() if still in our contents
	STOP_PROCESSING(SSobj, src)
//	for(var/datum/atom_hud/data/diagnostic/diag_hud in GLOB.huds)
// TBI		diag_hud.remove_from_hud(src)
	QDEL_NULL(access_card)
	return ..()

/obj/item/electronic_assembly/process(delta_time)
	handle_idle_power()
	check_pulling()
/* TBI	diag hud
	//updates diagnostic hud
	diag_hud_set_circuithealth()
	diag_hud_set_circuitcell()
*/
/obj/item/electronic_assembly/proc/handle_idle_power()
	net_power = 0 // Reset this. This gets increased/decreased with [give/draw]_power() outside of this loop.

	// First we generate power.
	for(var/obj/item/integrated_circuit/passive/power/P in assembly_components)
		P.make_energy()

	// Now spend it.
	for(var/I in assembly_components)
		var/obj/item/integrated_circuit/IC = I
		/* Uncomment for debugging purposes. */
		if(!IC)
			TO_WORLD(SPAN_DEBUGERROR("Bad assembly_components entry in [src].  Has remove() been called incorrectly?"))
			var/x = assembly_components.Find(null)
			assembly_components.Cut(x,++x)
			return
		//*/
		if(IC.power_draw_idle)
			if(!draw_power(IC.power_draw_idle))
				IC.power_fail()

/obj/item/electronic_assembly/proc/check_interactivity(mob/user)
	return ui_status(user, GLOB.physical_state) == UI_INTERACTIVE

/obj/item/electronic_assembly/get_cell()
	return battery

// TGUI
/obj/item/electronic_assembly/ui_state(mob/user, datum/tgui_module/module)
	return GLOB.physical_state

/obj/item/electronic_assembly/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ICAssembly", name, parent_ui)
		ui.open()

/obj/item/electronic_assembly/ui_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	var/list/data = ..()

	var/total_parts = 0
	var/total_complexity = 0
	for(var/obj/item/integrated_circuit/part in assembly_components)
		total_parts += part.size
		total_complexity = total_complexity + part.complexity

	data["opened"] = opened
	data["total_parts"] = total_parts
	data["max_components"] = max_components
	data["total_complexity"] = total_complexity
	data["max_complexity"] = max_complexity

	data["battery_charge"] = round(battery?.charge, 0.1)
	data["battery_max"] = round(battery?.maxcharge, 0.1)
	data["net_power"] = DYNAMIC_CELL_UNITS_TO_W(net_power, 1)
	data["circuit_props"] = ui_circuit_props
	// This works because lists are always passed by reference in BYOND, so modifying unremovable_circuits
	// after setting data["unremovable_circuits"] = unremovable_circuits also modifies data["unremovable_circuits"]
	// Same for the removable one
	//var/list/unremovable_circuits = list()
	//data["unremovable_circuits"] = unremovable_circuits
	//var/list/removable_circuits = list()
	//data["removable_circuits"] = removable_circuits
	//var/list/available_inputs = list()
	//data["available_inputs"] = available_inputs
	/*
	for(var/obj/item/integrated_circuit/circuit in assembly_components)
		var/list/target = circuit.removable ? removable_circuits : unremovable_circuits
		target.
		if(istype(circuit, /obj/item/integrated_circuit))
			var/obj/item/integrated_circuit/input = circuit
			if(input.can_be_asked_input)
				available_inputs.Add(list(list(
					"name" = circuit.displayed_name,
					"ref" = REF(circuit),
				)))*/
	return data

/obj/item/electronic_assembly/ui_act(action, list/params, datum/tgui/ui)
	if(..())
		return TRUE

	var/obj/held_item = usr.get_active_held_item()

	switch(action)
		//Actual assembly actions
		if("rename")
			rename(usr)
			return TRUE

		if("remove_cell")
			var/turf/T = get_turf(src)
			battery.forceMove(T)
			playsound(T, 'sound/items/Crowbar.ogg', 50, TRUE)
			to_chat(usr, SPAN_NOTICE("You pull \the [battery] out of \the [src]'s power supplier."))
			battery = null
			return TRUE

		// Circuit actions
		if("open_circuit")
			var/obj/item/integrated_circuit/C = locate(params["ref"]) in assembly_components
			if(!istype(C))
				return
			C.ui_interact(usr, null, ui)
			return TRUE

		if("rename_circuit")
			var/obj/item/integrated_circuit/C = locate(params["ref"]) in assembly_components
			if(!istype(C))
				return
			C.rename_component(usr)
			return TRUE

		if("scan_circuit")
			var/obj/item/integrated_circuit/C = locate(params["ref"]) in assembly_components
			if(!istype(C))
				return
			if(istype(held_item, /obj/item/integrated_electronics/debugger))
				var/obj/item/integrated_electronics/debugger/D = held_item
				if(D.accepting_refs)
					D.afterattack(C, usr, TRUE)
				else
					to_chat(usr, SPAN_WARNING("The Debugger's 'ref scanner' needs to be on."))
			else
				to_chat(usr, SPAN_WARNING("You need a multitool/debugger set to 'ref' mode to do that."))
			return TRUE

		if("remove_circuit")
			var/obj/item/integrated_circuit/C = locate(params["ref"]) in assembly_components
			if(!istype(C))
				return
			C.remove(usr, TRUE, index = params["index"])
			return TRUE

		if("bottom_circuit")
			var/obj/item/integrated_circuit/C = locate(params["ref"]) in assembly_components
			if(!istype(C))
				return
			// Puts it at the bottom of our contents
			// Note, this intentionally does *not* use forceMove, because forceMove will stop if it detects the same loc
			ui_circuit_props.Cut(params["index"], 1 + params["index"])
			ui_circuit_props.Add(list(list("name" = C.displayed_name,"ref" = REF(C),"removable" = C.removable,"input" = C.can_be_asked_input)))
			assembly_components.Cut(params["index"], 1 + params["index"])
			assembly_components.Add(C)
			C.loc = null
			C.loc = src

		if("input_selection")
			var/obj/item/integrated_circuit/input/C = locate(params["ref"]) in assembly_components
			if(C.ask_for_input(usr,held_item,usr.a_intent))
				return TRUE
			else
				var/obj/item/integrated_circuit/D = C
				D.attackby_react(usr,held_item,usr.a_intent)
				return TRUE

	return FALSE

// Input window data.

// End TGUI
/* TBI	diag hud
/obj/item/electronic_assembly/pickup(mob/user, flags, atom/oldLoc)
	. = ..()
	//update diagnostic hud when picked up, true is used to force the hud to be hidden
	diag_hud_set_circuithealth(TRUE)
	diag_hud_set_circuitcell(TRUE)
	diag_hud_set_circuitstat(TRUE)
	diag_hud_set_circuittracking(TRUE)

/obj/item/electronic_assembly/dropped(mob/user, flags, atom/newLoc)
	. = ..()
	//update diagnostic hud when dropped
	diag_hud_set_circuithealth()
	diag_hud_set_circuitcell()
	diag_hud_set_circuitstat()
	diag_hud_set_circuittracking()

*/
/obj/item/electronic_assembly/verb/rename()
	set name = "Rename Circuit"
	set category = "Object"
	set desc = "Rename your circuit, useful to stay organized."
	set src in usr

	var/mob/M = usr
	var/input = tgui_input_text(usr, "What do you want to name this?", "Rename", src.name, MAX_NAME_LEN)
	if(!check_interactivity(M))
		return
	if(src && input)
		to_chat(M, SPAN_NOTICE("The machine now has a label reading '[input]'."))
		name = input

/obj/item/electronic_assembly/proc/add_allowed_scanner(ckey)
	ckeys_allowed_to_scan[ckey] = TRUE

/obj/item/electronic_assembly/proc/can_move()
	return FALSE

/obj/item/electronic_assembly/update_icon()
	if(opened)
		icon_state = initial(icon_state) + "-open"
	else
		icon_state = initial(icon_state)
	cut_overlays()
	if(detail_color == COLOR_ASSEMBLY_BLACK) //Black colored overlay looks almost but not exactly like the base sprite, so just cut the overlay and avoid it looking kinda off.
		return
	var/mutable_appearance/detail_overlay = mutable_appearance('icons/obj/integrated_electronics/electronic_setups.dmi', "[icon_state]-color")
	detail_overlay.color = detail_color
	add_overlay(detail_overlay)


/obj/item/electronic_assembly/GetAccess()
	. = list()
	for(var/obj/item/integrated_circuit/part in contents)
		. |= part.GetAccess()

/obj/item/electronic_assembly/GetIdCard()
	. = list()
	for(var/obj/item/integrated_circuit/part in contents)
		var/id_card = part.GetIdCard()
		if(id_card)
			return id_card

/obj/item/electronic_assembly/proc/return_total_complexity()
	. = 0
	for(var/obj/item/integrated_circuit/part in assembly_components)
		. += part.complexity

/obj/item/electronic_assembly/proc/return_total_size()
	. = 0
	for(var/obj/item/integrated_circuit/part in assembly_components)
		. += part.size

// Returns true if the circuit made it inside.
/obj/item/electronic_assembly/proc/try_add_component(var/obj/item/integrated_circuit/IC, var/mob/user)
	if(!opened)
		to_chat(user, SPAN_WARNING("\The [src] isn't opened, so you can't put anything inside.  Try using a crowbar."))
		return FALSE

	if(IC.w_class > src.w_class)
		to_chat(user, SPAN_WARNING("\The [IC] is way too big to fit into \the [src]."))
		return FALSE

	var/total_part_size = return_total_size()
	var/total_complexity = return_total_complexity()

	if((total_part_size + IC.size) > max_components)
		to_chat(user, SPAN_WARNING("You can't seem to add the '[IC.name]', as there's insufficient space."))
		return FALSE
	if((total_complexity + IC.complexity) > max_complexity)
		to_chat(user, SPAN_WARNING("You can't seem to add the '[IC.name]', since this setup's too complicated for the case."))
		return FALSE
	if((allowed_circuit_action_flags & IC.action_flags) != IC.action_flags)
		to_chat(user, SPAN_WARNING("You can't seem to add the '[IC.name]', since the case doesn't support the circuit type."))
		return FALSE
	if(!IC.forceMove(src))
		return FALSE

	to_chat(user, SPAN_NOTICE("You slide [IC] inside [src]."))
	playsound(src, 'sound/items/Deconstruct.ogg', 50, 1)
	add_allowed_scanner(user.ckey)
	investigate_log("had [IC]([IC.type]) inserted by [key_name(user)].", INVESTIGATE_CIRCUIT)
	add_component(IC)

	return TRUE

// Actually puts the circuit inside, doesn't perform any checks.
/obj/item/electronic_assembly/proc/add_component(var/obj/item/integrated_circuit/IC)
	IC.forceMove(get_object())
	IC.assembly = src
	// Build TGUI lists here for efficiency.  We don't need to do that every time the UI updates.
	ui_circuit_props.Add(list(list("name" = IC.displayed_name,"ref" = REF(IC),"removable" = IC.removable,"input" = IC.can_be_asked_input)))
	assembly_components |= IC
	/* TBI	diag hud
	//increment numbers for diagnostic hud
	if(component.action_flags & IC_ACTION_COMBAT)
		combat_circuits += 1;
	if(component.action_flags & IC_ACTION_LONG_RANGE)
		long_range_circuits += 1;

	//diagnostic hud update
	diag_hud_set_circuitstat()
	diag_hud_set_circuittracking()
	*/

/obj/item/electronic_assembly/afterattack(atom/target, mob/user, proximity)
	. = ..()
	for(var/obj/item/integrated_circuit/input/S in assembly_components)
		if(S.sense(target,user,proximity))
			visible_message(SPAN_NOTICE("\The [user] waves \the [src] around [target]."))

/obj/item/electronic_assembly/attackby(var/obj/item/I, var/mob/user, intent)
	if(can_anchor && I.is_wrench())
		if(anchored_by)
			to_chat(user, SPAN_WARNING(pick("You fail to get purchase on [anchored_by]'s bolts.","[src]'s [anchored_by] protests!","The bolts defeat your paltry attempts to loosen them.")))
			return
		anchored = !anchored
		to_chat(user, SPAN_NOTICE("You've [anchored ? "" : "un"]secured \the [src] to \the [get_turf(src)]."))
		if(anchored)
			on_anchored()
		else
			on_unanchored()
		playsound(src, I.tool_sound, 50, 1)
		return TRUE

	else if(istype(I, /obj/item/integrated_circuit))
		if(!user.attempt_insert_item_for_installation(I, src))
			return
		if(try_add_component(I, user))
			ui_interact(user)
			return TRUE
		else
			I.forceMove(drop_location())

	else if(I.is_crowbar())
		if(!opened)
			return FALSE
		if(!battery)
			to_chat(usr, SPAN_WARNING("There's no power cell to remove from \the [src]."))
			return FALSE
		battery.forceMove(get_turf(src))
		playsound(get_turf(src), 'sound/items/Crowbar.ogg', 50, 1)
		to_chat(user, SPAN_NOTICE("You pull \the [battery] out of \the [src]'s power supplier."))
		battery = null
		return TRUE

	else if(I.is_screwdriver())
		if(panel_locked)
			to_chat(user, SPAN_NOTICE("The screws are hidden."))
			return FALSE
		playsound(get_turf(src), 'sound/items/Screwdriver.ogg', 50, 1)
		opened = !opened
		to_chat(user, SPAN_NOTICE("You [opened ? "opened" : "closed"] \the [src]."))
		update_icon()
		return TRUE

	else if(istype(I, /obj/item/integrated_electronics/wirer) || istype(I, /obj/item/integrated_electronics/debugger) || I.is_screwdriver())
		if(opened)
			ui_interact(user)
		else
			to_chat(user, SPAN_WARNING("\The [src] isn't opened, so you can't fiddle with the internal components.  Try using a screwdriver."))
		return TRUE

	else if(istype(I, /obj/item/integrated_electronics/detailer))
		var/obj/item/integrated_electronics/detailer/D = I
		detail_color = D.detail_color
		update_icon()
		return TRUE

	else if(istype(I, /obj/item/cell/device))
		if(!opened)
			to_chat(user, SPAN_WARNING("\The [src] isn't opened, so you can't put anything inside.  Try using a crowbar."))
			for(var/obj/item/integrated_circuit/input/S in assembly_components)
				S.attackby_react(I,user,user.a_intent)
			return FALSE
		if(battery)
			to_chat(user, SPAN_WARNING("\The [src] already has \a [battery] inside.  Remove it first if you want to replace it."))
			for(var/obj/item/integrated_circuit/input/S in assembly_components)
				S.attackby_react(I,user,user.a_intent)
			return FALSE
		var/obj/item/cell/device/cell = I
		if(!user.attempt_insert_item_for_installation(cell, src))
			return
		battery = cell
		// TBI diag_hud_set_circuitstat() //update diagnostic hud
		playsound(get_turf(src), 'sound/items/Deconstruct.ogg', 50, 1)
		to_chat(user, SPAN_NOTICE("You slot \the [cell] inside \the [src]'s power supplier."))
		ui_interact(user)
		return TRUE
	else if(istype(I, /obj/item/integrated_electronics/analyzer))
		if(!opened)
			to_chat(usr, SPAN_WARNING("You need to open the [src] to analyze the contents!"))
			return
		var/save = SScircuit.save_electronic_assembly(src)
		var/saved = "[src.name] analyzed! On circuit printers with cloning enabled, you may use the code below to clone the circuit:<br><br><code>[save]</code>"
		if(save)
			to_chat(usr, SPAN_WARNING("You scan [src]."))
			user << browse(saved, "window=circuit_scan;size=500x600;border=1;can_resize=1;can_close=1;can_minimize=1")
		else
			to_chat(usr, SPAN_WARNING("[src] is not complete enough to be encoded!"))
		return TRUE
	else for(var/obj/item/integrated_circuit/S in assembly_components)
		if(S.attackby_react(I,user,user.a_intent))
			return TRUE
	return ..()

/obj/item/electronic_assembly/attack_self(mob/user)
	if(!check_interactivity(user))
		return
	ui_interact(user)

/obj/item/electronic_assembly/attack_robot(mob/user as mob)
	if(Adjacent(user))
		return attack_self(user)
	else
		return ..()

/obj/item/electronic_assembly/emp_act(severity)
	. = ..()
//	if(. & EMP_PROTECT_CONTENTS)
//		return
	for(var/atom/movable/AM in contents)
		AM.emp_act(severity)

// Returns true if power was successfully drawn.
/obj/item/electronic_assembly/proc/draw_power(amount)
	if(battery)
		var/lost = battery.use(DYNAMIC_W_TO_CELL_UNITS(amount, 1))
		net_power -= lost
		return lost > 0
	return FALSE

// Ditto for giving.
/obj/item/electronic_assembly/proc/give_power(amount)
	if(battery)
		var/gained = battery.give(DYNAMIC_W_TO_CELL_UNITS(amount, 1))
		net_power += gained
		return TRUE
	return FALSE

// Returns true if power was successfully drawn.
/obj/item/electronic_assembly/proc/draw_power_kw(amount)
	if(battery)
		var/lost = battery.use(DYNAMIC_KW_TO_CELL_UNITS(amount, 1))
		net_power -= lost
		return lost > 0
	return FALSE

// Ditto for giving.
/obj/item/electronic_assembly/proc/give_power_kw(amount)
	if(battery)
		var/gained = battery.give(DYNAMIC_KW_TO_CELL_UNITS(amount, 1))
		net_power += gained
		return TRUE
	return FALSE

/obj/item/electronic_assembly/on_loc_moved(oldloc)
	. = ..()
	for(var/obj/item/integrated_circuit/IC in assembly_components)
		IC.ext_moved(oldloc, dir)
	if(light) //Update lighting objects (From light circuits).
		update_light()

/obj/item/electronic_assembly/Moved(oldloc, dir)
	. = ..()
	for(var/obj/item/integrated_circuit/IC in assembly_components)
		IC.ext_moved(oldloc, dir)
	if(light) //Update lighting objects (From light circuits).
		update_light()

/obj/item/electronic_assembly/stop_pulling()
	for(var/I in assembly_components)
		var/obj/item/integrated_circuit/IC = I
		IC.stop_pulling()
	..()


// Returns the object that is supposed to be used in attack messages, location checks, etc.
// Override in children for special behavior.
/obj/item/electronic_assembly/proc/get_object()
	return src

// Returns the location to be used for dropping items.
// Same as the regular drop_location(), but with checks being run on acting_object if necessary.
/obj/item/integrated_circuit/drop_location()
	var/atom/movable/acting_object = get_object()

	// plz no infinite loops
	if(acting_object == src)
		return ..()

	return acting_object.drop_location()

/obj/item/electronic_assembly/attack_tk(mob/user)
	if(anchored)
		return
	..()

/obj/item/electronic_assembly/attack_hand(mob/user, act_intent = user.a_intent, unarmed_attack_flags)
	if(anchored)
		attack_self(user)
		return
	..()
/*	TBI: Hand recog, can_trigger_gun
/obj/item/electronic_assembly/can_trigger_gun(mob/living/user) //sanity checks against pocket death weapon circuits
	if(!can_fire_equipped || !user.is_holding(src))
		return FALSE
	return ..()
*/
/obj/item/electronic_assembly/proc/on_anchored()
	for(var/obj/item/integrated_circuit/IC in contents)
		IC.on_anchored()

/obj/item/electronic_assembly/proc/on_unanchored()
	for(var/obj/item/integrated_circuit/IC in contents)
		IC.on_unanchored()
