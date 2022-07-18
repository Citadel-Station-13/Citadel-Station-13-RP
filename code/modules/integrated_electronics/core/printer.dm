/obj/item/integrated_circuit_printer
	name = "integrated circuit printer"
	desc = "A portable(ish) machine made to print tiny modular circuitry out of metal."
	icon = 'icons/obj/integrated_electronics/electronic_tools.dmi'
	icon_state = "circuit_printer"
	w_class = ITEMSIZE_LARGE
	var/cur_metal = 0
	var/max_metal = 250
	/// One sheet equals this much metal.
	var/metal_per_sheet = 10
	/// When hit with an upgrade disk, will turn true, allowing it to print the higher tier circuits.
	var/upgraded = FALSE
	/// Same for above, but will allow the printer to duplicate a specific assembly.
	var/can_clone = TRUE
	/// If this is false, then cloning will take an amount of deciseconds equal to the metal cost divided by 100.
	var/fast_clone = FALSE
	/// If true, metal is infinite.
	var/debug = FALSE
	var/static/list/recipe_list = list()
	/// If the printer is currently creating a circuit
	var/cloning = FALSE
	/// If an assembly is being emptied into this printer
	var/recycling = FALSE
	/// Currently loaded save, in form of list
	var/list/program
	var/dirty_items = FALSE

/obj/item/integrated_circuit_printer/examine(mob/user)
	. = ..()
	ui_interact(user)

/obj/item/integrated_circuit_printer/upgraded
	upgraded = TRUE
	can_clone = TRUE
	fast_clone = TRUE

/obj/item/integrated_circuit_printer/debug
	name = "fractal integrated circuit printer"
	desc = "A portable(ish) machine that makes modular circuitry seemingly out of thin air."
	debug = TRUE
	upgraded = TRUE
	can_clone = TRUE
	fast_clone = TRUE
	w_class = WEIGHT_CLASS_TINY
/* TBI: Requires material containers
/obj/item/integrated_circuit_printer/Initialize(mapload)
	. = ..()
	var/datum/component/material_container/materials = AddComponent(/datum/component/material_container, list(/datum/material/iron), MINERAL_MATERIAL_AMOUNT * 25, TRUE, list(/obj/item/stack, /obj/item/integrated_circuit, /obj/item/electronic_assembly))
	materials.precise_insertion = TRUE
*/
/obj/item/integrated_circuit_printer/proc/print_program(mob/user)
	visible_message(SPAN_NOTICE("[src] has finished printing its assembly!"))
	playsound(src, 'sound/items/poster_being_created.ogg', 50, TRUE)
	var/obj/item/electronic_assembly/assembly = SScircuit.load_electronic_assembly(get_turf(src), program)
	assembly.creator = key_name(user)
	assembly.investigate_log("was printed by [assembly.creator].", INVESTIGATE_CIRCUIT)
	cloning = FALSE

/obj/item/integrated_circuit_printer/proc/check_max_metal(inc)
	if(cur_metal + inc > max_metal)
		inc = CEILING(src.cur_metal + inc - src.max_metal, src.metal_per_sheet) / 10
		var/obj/item/stack/material/steel/S = new /obj/item/stack/material/steel(loc, inc, TRUE)
		to_chat(usr, SPAN_NOTICE("[src] ejects [S.amount] [S.singular_name]\s!"))
		src.cur_metal -= src.metal_per_sheet * inc
		return TRUE
	return FALSE

/obj/item/integrated_circuit_printer/attack_robot(mob/user as mob)
	if(Adjacent(user))
		return ui_interact(user)
	else
		return ..()

/obj/item/integrated_circuit_printer/attackby(var/obj/item/O, var/mob/user)
	if(istype(O,/obj/item/stack/material))
		var/obj/item/stack/material/stack = O
		if(stack.material.name == MAT_STEEL)
			if(debug)
				to_chat(user, SPAN_WARNING("\The [src] does not need any material."))
				return
			var/num = round(min((max_metal - cur_metal) / metal_per_sheet, stack.amount))
			if(num < 1)
				to_chat(user, SPAN_WARNING("\The [src] is too full to add more metal."))
				return
			if(stack.use(max(1, round(num)))) // We don't want to create stacks that aren't whole numbers
				to_chat(user, SPAN_NOTICE("You add [num] sheet\s to \the [src]."))
				cur_metal += num * metal_per_sheet
				attack_self(user)
				return TRUE

	if(istype(O,/obj/item/integrated_circuit))
		var/obj/item/integrated_circuit/IC = O
		to_chat(user, SPAN_NOTICE("You insert the circuit into \the [src]."))
		user.unEquip(IC)
		check_max_metal(IC.cost)
		cur_metal += IC.cost
		qdel(IC)
		attack_self(user)
		return TRUE

	if(istype(O,/obj/item/disk/integrated_circuit/upgrade/advanced))
		if(upgraded)
			to_chat(user, SPAN_WARNING("\The [src] already has this upgrade."))
			return TRUE
		to_chat(user, SPAN_NOTICE("You install \the [O] into  \the [src]."))
		upgraded = TRUE
		dirty_items = TRUE
		attack_self(user)
		return TRUE

	if(istype(O,/obj/item/disk/integrated_circuit/upgrade/clone))
		if(fast_clone)
			to_chat(user, SPAN_WARNING("\The [src] already has this upgrade."))
			return TRUE
		to_chat(user, SPAN_NOTICE("You install \the [O] into  \the [src]."))
		can_clone = TRUE
		fast_clone = TRUE
		attack_self(user)
		return TRUE

	if(istype(O, /obj/item/electronic_assembly))
		var/obj/item/electronic_assembly/EA = O //microtransactions not included
		if(recycling)
			return
		if(!EA.opened)
			to_chat(user, SPAN_WARNING("You can't reach [EA]'s components to remove them!"))
			return
		if(EA.battery)
			to_chat(user, SPAN_WARNING("Remove [EA]'s power cell first!"))
			return
		var/inc = 0
		for(var/V in EA.assembly_components)	// Start looking for recyclable components.
			var/obj/item/integrated_circuit/IC = V
			if(IC.removable)	// If found, don't destroy the assembly later.
				++inc
				to_chat(user, SPAN_NOTICE("You begin recycling [EA]'s components..."))
				playsound(src, 'sound/items/electronic_assembly_emptying.ogg', 50, TRUE)
				if(!do_after(user, 30, target = src) && !recycling) //short channel so you don't accidentally start emptying out a complex assembly
					recycling = TRUE
				break
		if (inc == 1)
			for(var/V in EA.assembly_components)
				var/obj/item/integrated_circuit/IC = V
				if(IC.removable)
					if(!do_after(user, 5, target = user))
						recycling = FALSE
						return
					if(IC.removable)
						playsound(src, 'sound/items/crowbar.ogg', 50, TRUE)
						check_max_metal(IC.cost)
						cur_metal += IC.cost
						IC.remove(usr, TRUE, inc)
						qdel(IC)
					else ++inc
			to_chat(user, SPAN_NOTICE("You recycle all the components[EA.assembly_components.len ? " you could " : " "]from [EA]!"))
			playsound(src, 'sound/items/electronic_assembly_empty.ogg', 50, TRUE)
			recycling = FALSE
			return TRUE
		if(inc == 0)
			if(!do_after(user, 10, target = user))
				recycling = FALSE
				return
			to_chat(user, SPAN_NOTICE("You recycle the [EA]!"))
			check_max_metal(EA.cost)
			cur_metal += EA.cost
			user.remove_from_mob(EA)
			qdel(EA)
			return TRUE
	return ..()

/obj/item/integrated_circuit_printer/vv_edit_var(var_name, var_value)
	// Gotta update the static data in case an admin VV's the upgraded var for some reason..! //I would :) -Zan
	if(var_name == "upgraded")
		dirty_items = TRUE
	return ..()

/obj/item/integrated_circuit_printer/attack_self(var/mob/user)
	ui_interact(user)

/obj/item/integrated_circuit_printer/ui_state(mob/user)
	return GLOB.physical_state

/obj/item/integrated_circuit_printer/ui_interact(mob/user, datum/tgui/ui)
	if(dirty_items)
		update_static_data(user, ui)
		dirty_items = FALSE

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ICPrinter", name) // 500, 600
		ui.open()

/obj/item/integrated_circuit_printer/ui_static_data(mob/user)
	var/list/data = ..()

	var/list/categories = list()
	for(var/category in SScircuit.circuit_fabricator_recipe_list)
		var/list/cat_obj = list(
			"name" = category,
			"items" = null
		)
		var/list/circuit_list = SScircuit.circuit_fabricator_recipe_list[category]
		var/list/items = list()
		for(var/path in circuit_list)
			var/obj/O = path
			var/can_build = TRUE
			var/obj/item/integrated_circuit/IC = path

			if(ispath(path, /obj/item/integrated_circuit))
				if((initial(IC.spawn_flags) & IC_SPAWN_RESEARCH) && (!(initial(IC.spawn_flags) & IC_SPAWN_DEFAULT)) && !upgraded)
					can_build = FALSE

			var/cost = 1
			if(ispath(path, /obj/item/electronic_assembly))
				var/obj/item/electronic_assembly/E = path
				cost = round((initial(E.max_complexity) + initial(E.max_components)) / 4)
			else if(ispath(path, /obj/item/integrated_circuit))
			//	var/obj/item/integrated_circuit/I = path
				cost = initial(IC.cost)
			else
				cost = initial(O.w_class)

			items.Add(list(list(
				"name" = initial(O.name),
				"desc" = initial(O.desc),
				"can_build" = can_build,
				"cost" = cost,
				"path" = path,
			)))

		cat_obj["items"] = items
		categories.Add(list(cat_obj))
	data["categories"] = categories

	return data

/obj/item/integrated_circuit_printer/ui_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	var/list/data = ..()

	data["metal"] = cur_metal
	data["max_metal"] = max_metal
	data["metal_per_sheet"] = metal_per_sheet
	data["debug"] = debug
	data["upgraded"] = upgraded
	data["can_clone"] = can_clone
	data["program"] = program
	/*
	data["used_space"] = program.Find("used_space")
	data["max_space"] = program.Find("max_space")
	data["complexity"] = program.Find("complexity")
	data["max_complexity"] = program.Find("max_complexity")
	data["metal_cost"] = program.Find("metal_cost")
	data["unsupported_circuit"] = program.Find("unsupported_circuit")
	data["requires_upgrades"] = program.Find("requires_upgrades")
*/

	return data

/obj/item/integrated_circuit_printer/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE

	switch(action)
		if("build")
			var/cost = text2num(params["cost"])
			var/build_type = text2path(params["build"])
			if(!build_type || !ispath(build_type))
				return TRUE

			var/in_some_category = FALSE
			for(var/category in SScircuit.circuit_fabricator_recipe_list)
				if(build_type in SScircuit.circuit_fabricator_recipe_list[category])
					in_some_category = TRUE
					break
			if(!in_some_category)
				return

			if(!debug)
				if(!Adjacent(usr))
					to_chat(usr, SPAN_NOTICE("You are too far away from \the [src]."))
				if(cur_metal - cost < 0)
					to_chat(usr, SPAN_WARNING("You need [cost] metal to build that!."))
					return TRUE
				cur_metal -= cost
			var/obj/item/built = new build_type(get_turf(loc))
			usr.put_in_hands(built)
			to_chat(usr, SPAN_NOTICE("[capitalize(built.name)] printed."))
			playsound(src, 'sound/items/jaws_pry.ogg', 50, TRUE)
			return TRUE
		if("load_blueprint") //! This should be done through disks and modular comps! For now we have copy-paste here.
			var/new_input = input(usr, "Enter blueprint:", "loading",null) as null|text
			if(!new_input)
				program = null
				return
			if(istext(new_input))
				to_chat(usr, SPAN_NOTICE("[new_input] load blueprint pressed"))

			var/validation = SScircuit.validate_electronic_assembly(new_input)
			// Validation error codes are returned as text.
			if(istext(validation))
				to_chat(usr, SPAN_WARNING("Error: [validation]"))
				return
			else if(islist(validation))
				program = validation
				to_chat(usr, SPAN_NOTICE("This is a valid program for [program["assembly"]["type"]]."))
				if(program["requires_upgrades"])
					if(upgraded)
						to_chat(usr, SPAN_NOTICE("It uses advanced component designs."))
					else
						to_chat(usr, SPAN_WARNING("It uses unknown component designs.  Printer upgrade is required to proceed."))
				if(program["unsupported_circuit"])
					to_chat(usr, SPAN_WARNING("This program uses components not supported by the specified assembly.  Please change the assembly type in the save file to a supported one."))
				to_chat(usr, SPAN_NOTICE("Used space: [program["used_space"]]/[program["max_space"]]."))
				to_chat(usr, SPAN_NOTICE("Complexity: [program["complexity"]]/[program["max_complexity"]]."))
				to_chat(usr, SPAN_NOTICE("Metal cost: [program["metal_cost"]]."))
			return TRUE
		if("clone")
			if(!program || cloning)
				return
			if(program["requires_upgrades"] && !upgraded && !debug)
				to_chat(usr, SPAN_WARNING("This program uses unknown component designs.  Printer upgrade is required to proceed."))
				return
			if(program["unsupported_circuit"] && !debug)
				to_chat(usr, SPAN_WARNING("This program uses components not supported by the specified assembly.  Please change the assembly type in the save file to a supported one."))
				return
			else if(fast_clone)
				if(debug || cur_metal < program["metal_cost"])
					cloning = TRUE
					print_program(usr)
					return TRUE
				else
					to_chat(usr, SPAN_WARNING("You need [program["metal_cost"]] metal to build that!"))
			else
				if(cur_metal < program["metal_cost"])
					to_chat(usr, SPAN_WARNING("You need [program["metal_cost"]] metal to build that!"))
					return
				var/cloning_time = round(program["metal_cost"] / 15)
				cloning_time = min(cloning_time, MAX_CIRCUIT_CLONE_TIME)
				cloning = TRUE
				cur_metal -= program["metal_cost"]
				to_chat(usr, SPAN_NOTICE("You begin printing a custom assembly.  This will take approximately [DisplayTimeText(cloning_time)].  You can still print \
				off normal parts during this time."))
				playsound(src, 'sound/items/poster_being_created.ogg', 50, TRUE)
				addtimer(CALLBACK(src, .proc/print_program, usr), cloning_time)
				return TRUE

		if("cancel")
			if(!cloning || !program)
				return
			to_chat(usr, SPAN_NOTICE("Cloning has been canceled.  Metal cost has been refunded."))
			cloning = FALSE
			cur_metal += program["metal_cost"]
			check_max_metal(cur_metal)
			return TRUE


// FUKKEN UPGRADE DISKS
/obj/item/disk/integrated_circuit/upgrade
	name = "integrated circuit printer upgrade disk"
	desc = "Install this into your integrated circuit printer to enhance it."
	icon = 'icons/obj/integrated_electronics/electronic_tools.dmi'
	icon_state = "upgrade_disk"
	item_state = "card-id"
	w_class = ITEMSIZE_SMALL
	origin_tech = list(TECH_ENGINEERING = 3, TECH_DATA = 4)

/obj/item/disk/integrated_circuit/upgrade/advanced
	name = "integrated circuit printer upgrade disk - advanced designs"
	desc = "Install this into your integrated circuit printer to enhance it.  This one adds new, advanced designs to the printer."

/obj/item/disk/integrated_circuit/upgrade/clone
	name = "integrated circuit printer upgrade disk - circuit cloner"
	desc = "Install this into your integrated circuit printer to enhance it.  This one allows the printer to duplicate assemblies."
	icon_state = "upgrade_disk_clone"
	origin_tech = list(TECH_ENGINEERING = 5, TECH_DATA = 6)
