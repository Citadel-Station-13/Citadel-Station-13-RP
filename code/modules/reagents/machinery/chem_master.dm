/obj/machinery/chem_master
	name = "ChemMaster 3000"
	desc = "Used to seperate and package chemicals in to autoinjectors, lollipops, patches, pills, or bottles. Warranty void if used to create Space Drugs."
	density = TRUE
	anchored = TRUE
	icon = 'icons/obj/medical/chemical.dmi'
	icon_state = "mixer0"
	circuit = /obj/item/circuitboard/chem_master
	use_power = USE_POWER_IDLE
	idle_power_usage = 20
	flags = OPENCONTAINER
	clicksound = "button"

	/// Input reagents container.
	var/obj/item/reagent_containers/beaker = null
	/// Pill bottle for newly created pills.
	var/obj/item/storage/pill_bottle/loaded_pill_bottle = null
	var/useramount = 15 // Last used amount
	var/pillamount = 10
	var/lolliamount = 5
	var/autoamount = 5
	var/max_pill_count = 20
	var/max_lolli_count = 10
	var/max_auto_count = 5
	var/printing = FALSE
	var/autosprite = TRUE

	/// Whether separated reagents should be moved back to container or destroyed. 1 - move, 0 - destroy
	var/mode = 1
	/// Decides what UI to show. If TRUE shows UI of CondiMaster, if FALSE - ChemMaster
	var/condi = FALSE

	/// Currently selected pill style.
	var/chosen_pill_style = 1
	/// List of available pill styles for UI
	var/list/pill_styles

	/// Currently selected bottle style.
	var/chosen_bottle_style = 1
	/// List of available bottle styles for UI
	var/list/bottle_styles

	/// Currently selected patch style.
	var/chosen_patch_style = DEFAULT_PATCH_STYLE
	/// List of available patch styles for UI
	var/list/patch_styles

	/// Currently selected condi style.
	var/chosen_condi_style = 1
	/// List of available condi styles for UI
	var/list/condi_styles

/obj/machinery/chem_master/Initialize(mapload, newdir)
	. = ..()
	default_apply_parts()
	create_reagents(1000)

/obj/machinery/chem_master/legacy_ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				qdel(src)
				return

/obj/machinery/chem_master/update_icon()
	icon_state = "mixer[beaker ? "1" : "0"]"

/obj/machinery/chem_master/attackby(var/obj/item/B as obj, var/mob/user as mob)

	if(istype(B, /obj/item/reagent_containers/glass) || istype(B, /obj/item/reagent_containers/food))

		if(src.beaker)
			to_chat(user, "\A [beaker] is already loaded into the machine.")
			return
		if(!user.attempt_insert_item_for_installation(B, src))
			return
		src.beaker = B
		to_chat(user, "You add \the [B] to the machine.")
		update_icon()

	else if(istype(B, /obj/item/storage/pill_bottle))

		if(src.loaded_pill_bottle)
			to_chat(user, "A \the [loaded_pill_bottle] s already loaded into the machine.")
			return
		if(!user.attempt_insert_item_for_installation(B, src))
			return

		src.loaded_pill_bottle = B
		to_chat(user, "You add \the [loaded_pill_bottle] into the dispenser slot.")

	else if(default_unfasten_wrench(user, B, 20))
		return
	if(default_deconstruction_screwdriver(user, B))
		return
	if(default_deconstruction_crowbar(user, B))
		return

	return

/obj/machinery/chem_master/attack_hand(mob/user)
	if(machine_stat & BROKEN)
		return
	user.set_machine(src)
	ui_interact(user)

/obj/machinery/chem_master/proc/load_styles()
	/// Calculate the span tags and ids fo all the available pill icons.
	var/datum/asset/spritesheet/simple/pill_assets = get_asset_datum(/datum/asset/spritesheet/simple/pills)
	pill_styles = list()
	for (var/x in 1 to PILL_STYLE_COUNT)
		var/list/pill_style_list = list()
		pill_style_list["id"] = x
		pill_style_list["class_name"] = pill_assets.icon_class_name("pill[x]")
		pill_styles += list(pill_style_list)

	var/datum/asset/spritesheet/simple/bottle_assets = get_asset_datum(/datum/asset/spritesheet/simple/bottles)
	bottle_styles = list()
	for (var/x in 1 to BOTTLE_STYLE_COUNT)
		var/list/bottle_style_list = list()
		bottle_style_list["id"] = x
		bottle_style_list["class_name"] = bottle_assets.icon_class_name("bottle[x]")
		bottle_styles += list(bottle_style_list)

	var/datum/asset/spritesheet/simple/patches_assets = get_asset_datum(/datum/asset/spritesheet/simple/patches)
	patch_styles = list()
	for (var/raw_patch_style in PATCH_STYLE_LIST)
		//adding class_name for use in UI
		var/list/patch_style = list()
		patch_style["style"] = raw_patch_style
		patch_style["class_name"] = patches_assets.icon_class_name(raw_patch_style)
		patch_styles += list(patch_style)

/obj/machinery/chem_master/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/spritesheet/simple/pills),
		get_asset_datum(/datum/asset/spritesheet/simple/bottles),
		get_asset_datum(/datum/asset/spritesheet/simple/patches),
	)

/obj/machinery/chem_master/ui_interact(mob/user, datum/tgui/ui = null)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ChemMaster", name)
		ui.open()

/**
 *  Display the NanoUI window for the chem master.
 *
 *  See NanoUI documentation for details.
 */
/obj/machinery/chem_master/ui_data(mob/user)
	var/list/data = list()

	data["autosprite"] = autosprite
	data["mode"] = mode
	data["printing"] = printing
	data["condi"] = condi

	data["loaded_pill_bottle"] = !!loaded_pill_bottle
	if(loaded_pill_bottle)
		data["loaded_pill_bottle_name"] = loaded_pill_bottle.name
		data["loaded_pill_bottle_contents_len"] = loaded_pill_bottle.contents.len
		data["loaded_pill_bottle_storage_slots"] = loaded_pill_bottle.max_storage_space

	data["beaker"] = !!beaker
	if(beaker)
		var/list/beaker_reagents_list = list()
		data["beaker_reagents"] = beaker_reagents_list
		for(var/datum/reagent/R in beaker.reagents.reagent_list)
			beaker_reagents_list[++beaker_reagents_list.len] = list("name" = R.name, "volume" = R.volume, "description" = R.description, "id" = R.id)

		var/list/buffer_reagents_list = list()
		data["buffer_reagents"] = buffer_reagents_list
		for(var/datum/reagent/R in reagents.reagent_list)
			buffer_reagents_list[++buffer_reagents_list.len] = list("name" = R.name, "volume" = R.volume, "description" = R.description, "id" = R.id)

	//Calculated once since it'll never change
	if(!pill_styles || !bottle_styles || !chosen_patch_style || !patch_styles)
		load_styles()
	data["pill_styles"] = pill_styles
	data["bottle_styles"] = bottle_styles
	data["patch_styles"] = patch_styles
	data["chosen_pill_style"] = chosen_pill_style
	data["chosen_bottle_style"] = chosen_bottle_style
	data["chosen_patch_style"] = chosen_patch_style

	// Transfer modal information if there is one
	data["modal"] = ui_modal_data(src)

	return data

/**
  * Called in ui_act() to process modal actions
  *
  * Arguments:
  * * action - The action passed by tgui
  * * params - The params passed by tgui
  */
/obj/machinery/chem_master/proc/ui_act_modal(action, params, datum/tgui/ui, datum/ui_state/state)
	. = TRUE
	var/id = params["id"] // The modal's ID
	var/list/arguments = istext(params["arguments"]) ? json_decode(params["arguments"]) : params["arguments"]
	switch(ui_modal_act(src, action, params))
		if(UI_MODAL_OPEN)
			switch(id)
				if("analyze")
					var/idx = text2num(arguments["idx"]) || 0
					var/from_beaker = text2num(arguments["beaker"]) || FALSE
					var/reagent_list = from_beaker ? beaker.reagents.reagent_list : reagents.reagent_list
					if(idx < 1 || idx > length(reagent_list))
						return

					var/datum/reagent/R = reagent_list[idx]
					var/list/result = list("idx" = idx, "name" = R.name, "desc" = R.description)
					if(!condi && istype(R, /datum/reagent/blood))
						var/datum/reagent/blood/B = R
						result["blood_type"] = B.data["blood_type"]
						result["blood_dna"] = B.data["blood_DNA"]

					arguments["analysis"] = result
					ui_modal_message(src, id, "", null, arguments)
				if("addcustom")
					if(!beaker || !beaker.reagents.total_volume)
						return
					ui_modal_input(src, id, "Please enter the amount to transfer to buffer:", null, arguments, useramount)
				if("removecustom")
					if(!reagents.total_volume)
						return
					ui_modal_input(src, id, "Please enter the amount to transfer to [mode ? "beaker" : "disposal"]:", null, arguments, useramount)
			//! CONDIMENTS
				if("create_condi_pack")
					if(!condi || !reagents.total_volume)
						return
					ui_modal_input(src, id, "Please name your new condiment pack:", null, arguments, reagents.get_master_reagent_name(), MAX_CUSTOM_NAME_LEN)
			//! PILLS
				if("create_pill")
					if(condi || !reagents.total_volume)
						return
					var/num = round(text2num(arguments["num"] || 1))
					if(!num)
						return
					arguments["num"] = num
					var/amount_per_pill = clamp(reagents.total_volume / num, 0, MAX_UNITS_PER_PILL)
					var/default_name = "[reagents.get_master_reagent_name()] ([amount_per_pill]u)"
					var/pills_text = num == 1 ? "new pill" : "[num] new pills"
					ui_modal_input(src, id, "Please name your [pills_text]:", null, arguments, default_name, MAX_CUSTOM_NAME_LEN)
				if("create_pill_multiple")
					if(condi || !reagents.total_volume)
						return
					ui_modal_input(src, id, "Please enter the amount of pills to make (max [MAX_MULTI_AMOUNT] at a time):", null, arguments, pillamount, 5)
			//! PATCHES
				if("create_patch")
					if(condi || !reagents.total_volume)
						return
					var/num = round(text2num(arguments["num"] || 1))
					if(!num)
						return
					arguments["num"] = num
					var/amount_per_patch = clamp(reagents.total_volume / num, 0, MAX_UNITS_PER_PATCH)
					var/default_name = "[reagents.get_master_reagent_name()] ([amount_per_patch]u)"
					var/patches_text = num == 1 ? "new patch" : "[num] new patches"
					ui_modal_input(src, id, "Please name your [patches_text]:", null, arguments, default_name, MAX_CUSTOM_NAME_LEN)
				if("create_patch_multiple")
					if(condi || !reagents.total_volume)
						return
					ui_modal_input(src, id, "Please enter the amount of patches to make (max [MAX_MULTI_AMOUNT] at a time):", null, arguments, pillamount, 5)
			//! LOLLIPOPS
				if("create_lollipop")
					if(condi || !reagents.total_volume)
						return
					var/num = round(text2num(arguments["num"] || 1))
					if(!num)
						return
					arguments["num"] = num
					var/amount_per_lolli = clamp(reagents.total_volume / num, 0, MAX_UNITS_PER_LOLLI)
					var/default_name = "[reagents.get_master_reagent_name()] ([amount_per_lolli]u)"
					var/lolli_text = num == 1 ? "new lollipop" : "[num] new lollipops"
					ui_modal_input(src, id, "Please name your [lolli_text]:", null, arguments, default_name, MAX_CUSTOM_NAME_LEN)
				if("create_lollipop_multiple")
					if(condi || !reagents.total_volume)
						return
					ui_modal_input(src, id, "Please enter the amount of lollipops to make (max [MAX_MULTI_AMOUNT] at a time):", null, arguments, lolliamount, 5)
			//! AUTOINJECTORS
				if("create_autoinjector")
					if(condi || !reagents.total_volume)
						return
					var/num = round(text2num(arguments["num"] || 1))
					if(!num)
						return
					arguments["num"] = num
					var/amount_per_auto = clamp(reagents.total_volume / num, 0, MAX_UNITS_PER_AUTO)
					var/default_name = "[reagents.get_master_reagent_name()] ([amount_per_auto]u)"
					var/auto_text = num == 1 ? "new autoinjector" : "[num] new autoinjectors"
					ui_modal_input(src, id, "Please name your [auto_text]:", null, arguments, default_name, MAX_CUSTOM_NAME_LEN)
				if("create_autoinjector_multiple")
					if(condi || !reagents.total_volume)
						return
					ui_modal_input(src, id, "Please enter the amount of autoinjectors to make (max [MAX_MULTI_AMOUNT] at a time):", null, arguments, autoamount, 5)
			//! BOTTLES
				if("create_bottle")
					if(condi || !reagents.total_volume)
						return
					var/num = round(text2num(arguments["num"] || 1))
					if(!num)
						return
					arguments["num"] = num
					var/amount_per_bottle = clamp(reagents.total_volume / num, 0, MAX_UNITS_PER_BOTTLE)
					var/default_name = "[reagents.get_master_reagent_name()]"
					var/bottles_text = num == 1 ? "new bottle" : "[num] new bottles"
					ui_modal_input(src, id, "Please name your [bottles_text] ([amount_per_bottle]u in bottle):", null, arguments, default_name, MAX_CUSTOM_NAME_LEN)
				if("create_bottle_multiple")
					if(condi || !reagents.total_volume)
						return
					ui_modal_input(src, id, "Please enter the amount of bottles to make (max [MAX_MULTI_AMOUNT] at a time):", null, arguments, 2, 5)//two bottles on default
				else
					return FALSE
		if(UI_MODAL_ANSWER)
			var/answer = params["answer"]
			switch(id)
				if("addcustom")
					var/amount = isgoodnumber(text2num(answer))
					if(!amount || !arguments["id"])
						return
					ui_act("add", list("id" = arguments["id"], "amount" = amount), ui, state)
				if("removecustom")
					var/amount = isgoodnumber(text2num(answer))
					if(!amount || !arguments["id"])
						return
					ui_act("remove", list("id" = arguments["id"], "amount" = amount), ui, state)
				if("create_condi_pack")
					if(!condi || !reagents.total_volume)
						return
					if(!length(answer))
						answer = reagents.get_master_reagent_name()
					var/obj/item/reagent_containers/pill/P = new(loc)
					P.name = "[answer] pack"
					P.desc = "A small condiment pack. The label says it contains [answer]."
					P.icon_state = "bouilloncube"//Reskinned monkey cube
					reagents.trans_to_obj(P, 10)
				if("create_pill")
					if(condi || !reagents.total_volume)
						return
					var/count = clamp(round(text2num(arguments["num"]) || 0), 0, MAX_MULTI_AMOUNT)
					if(!count)
						return

					if(!length(answer))
						answer = reagents.get_master_reagent_name()
					var/amount_per_pill = clamp(reagents.total_volume / count, 0, MAX_UNITS_PER_PILL)
					while(count--)
						if(reagents.total_volume <= 0)
							to_chat(usr, "<span class='notice'>Not enough reagents to create these pills!</span>")
							return

						var/obj/item/reagent_containers/pill/P = new(loc)
						P.name = "[answer] pill"
						P.pixel_x = rand(-7, 7) // Random position
						P.pixel_y = rand(-7, 7)
						P.icon_state = "pill[chosen_pill_style]"
						if(P.icon_state in list("pill1", "pill2", "pill3", "pill4")) // if using greyscale, take colour from reagent
							P.color = reagents.get_color()
						reagents.trans_to_obj(P, amount_per_pill)
						// Load the pills in the bottle if there's one loaded
						if(istype(loaded_pill_bottle) && length(loaded_pill_bottle.contents) < loaded_pill_bottle.max_storage_space)
							P.forceMove(loaded_pill_bottle)
				if("create_pill_multiple")
					if(condi || !reagents.total_volume)
						return
					ui_act("modal_open", list("id" = "create_pill", "arguments" = list("num" = answer)), ui, state)
				if("create_patch")
					if(condi || !reagents.total_volume)
						return
					var/count = clamp(round(text2num(arguments["num"]) || 0), 0, MAX_MULTI_AMOUNT)
					if(!count)
						return

					if(!length(answer))
						answer = reagents.get_master_reagent_name()
					var/amount_per_patch = clamp(reagents.total_volume / count, 0, MAX_UNITS_PER_PATCH)
					// var/is_medical_patch = chemical_safety_check(reagents)
					while(count--)
						if(reagents.total_volume <= 0)
							to_chat(usr, "<span class='notice'>Not enough reagents to create these patches!</span>")
							return

						var/obj/item/reagent_containers/pill/patch/P = new(loc)
						P.name = "[answer] patch"
						P.pixel_x = rand(-7, 7) // random position
						P.pixel_y = rand(-7, 7)
						reagents.trans_to_obj(P, amount_per_patch)
						// if(is_medical_patch)
							// P.instant_application = TRUE
							// P.icon_state = "bandaid_med"
				if("create_patch_multiple")
					if(condi || !reagents.total_volume)
						return
					ui_act("modal_open", list("id" = "create_patch", "arguments" = list("num" = answer)), ui, state)
				if("create_lollipop")
					if(condi || !reagents.total_volume)
						return
					var/count = clamp(round(text2num(arguments["num"]) || 0), 0, MAX_MULTI_AMOUNT)
					if(!count)
						return

					if(!length(answer))
						answer = reagents.get_master_reagent_name()
					var/amount_per_lolli = clamp(reagents.total_volume / count, 0, MAX_UNITS_PER_LOLLI)
					// var/is_medical_patch = chemical_safety_check(reagents)
					while(count--)
						if(reagents.total_volume <= 0)
							to_chat(usr, "<span class='notice'>Not enough reagents to create these candies!</span>")
							return

						var/obj/item/reagent_containers/hard_candy/lollipop/L = new(loc)
						L.name = "[answer] lollipop"
						L.pixel_x = rand(-7, 7) // random position
						L.pixel_y = rand(-7, 7)
						reagents.trans_to_obj(L, amount_per_lolli)
				if("create_lollipop_multiple")
					if(condi || !reagents.total_volume)
						return
					ui_act("modal_open", list("id" = "create_lollipop", "arguments" = list("num" = answer)), ui, state)
				if("create_autoinjector")
					if(condi || !reagents.total_volume)
						return
					var/count = clamp(round(text2num(arguments["num"]) || 0), 0, MAX_MULTI_AMOUNT)
					if(!count)
						return

					if(!length(answer))
						answer = reagents.get_master_reagent_name()
					var/amount_per_auto = clamp(reagents.total_volume / count, 0, MAX_UNITS_PER_AUTO)
					// var/is_medical_patch = chemical_safety_check(reagents)
					while(count--)
						if(reagents.total_volume <= 0)
							to_chat(usr, "<span class='notice'>Not enough reagents to create these injectors!</span>")
							return

						var/obj/item/reagent_containers/hypospray/autoinjector/empty/A = new(loc)
						A.name = "[answer] autoinjector"
						A.pixel_x = rand(-7, 7) // random position
						A.pixel_y = rand(-7, 7)
						reagents.trans_to_obj(A, amount_per_auto)
				if("create_autoinjector_multiple")
					if(condi || !reagents.total_volume)
						return
					ui_act("modal_open", list("id" = "create_autoinjector", "arguments" = list("num" = answer)), ui, state)
				if("create_bottle")
					if(condi || !reagents.total_volume)
						return
					var/count = clamp(round(text2num(arguments["num"]) || 0), 0, MAX_MULTI_AMOUNT)
					if(!count)
						return

					if(!length(answer))
						answer = reagents.get_master_reagent_name()
					var/amount_per_bottle = clamp(reagents.total_volume / count, 0, MAX_UNITS_PER_BOTTLE)
					while(count--)
						if(reagents.total_volume <= 0)
							to_chat(usr, "<span class='notice'>Not enough reagents to create these bottles!</span>")
							return
						var/obj/item/reagent_containers/glass/bottle/P = new(loc)
						P.name = "[answer] bottle"
						P.pixel_x = rand(-7, 7) // random position
						P.pixel_y = rand(-7, 7)
						P.icon_state = "bottle-[bottle_styles]" || "bottle-1"
						reagents.trans_to_obj(P, amount_per_bottle)
						P.update_icon()
				if("create_bottle_multiple")
					if(condi || !reagents.total_volume)
						return
					ui_act("modal_open", list("id" = "create_bottle", "arguments" = list("num" = answer)), ui, state)
				else
					return FALSE
		else
			return FALSE

/obj/machinery/chem_master/ui_act(action, params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE

	if(ui_act_modal(action, params, ui, state))
		return TRUE

	if(. || !beaker)
		return

	add_fingerprint(usr)
	usr.set_machine(src)
	var/datum/reagents/R = beaker.reagents

	switch(action)
		if("toggle")
			mode = !mode
			return TRUE

		if("ejectp")
			if(loaded_pill_bottle)
				loaded_pill_bottle.forceMove(get_turf(src))
				if(Adjacent(usr) && !issilicon(usr))
					usr.put_in_hands(loaded_pill_bottle)
				loaded_pill_bottle = null
			return TRUE

		if("print")
			if(printing || condi)
				return FALSE
			var/idx = text2num(params["idx"]) || 0
			var/from_beaker = text2num(params["beaker"]) || FALSE
			var/reagent_list = from_beaker ? beaker.reagents.reagent_list : reagents.reagent_list
			if(idx < 1 || idx > length(reagent_list))
				return FALSE

			var/datum/reagent/reagent_id = reagent_list[idx]

			printing = TRUE
			visible_message("<span class='notice'>[src] rattles and prints out a sheet of paper.</span>")
			// playsound(loc, 'sound/goonstation/machines/printer_dotmatrix.ogg', 50, 1)

			var/obj/item/paper/P = new /obj/item/paper(loc)
			P.info = "<center><b>Chemical Analysis</b></center><br>"
			P.info += "<b>Time of analysis:</b> [worldtime2stationtime(world.time)]<br><br>"
			P.info += "<b>Chemical name:</b> [reagent_id.name]<br>"
			if(istype(reagent_id, /datum/reagent/blood))
				var/datum/reagent/blood/B = reagent_id
				P.info += "<b>Description:</b> N/A<br><b>Blood Type:</b> [B.data["blood_type"]]<br><b>DNA:</b> [B.data["blood_DNA"]]"
			else
				P.info += "<b>Description:</b> [reagent_id.description]"
			P.info += "<br><br><b>Notes:</b><br>"
			P.name = "Chemical Analysis - [reagent_id.name]"
			spawn(50)
				printing = FALSE
			return TRUE

		if("bottle_style")
			var/id = text2num(params["id"])
			chosen_bottle_style = id
			return TRUE

		if("pill_style")
			var/id = text2num(params["id"])
			chosen_pill_style = id
			return TRUE

		if("change_patch_style")
			chosen_patch_style = params["patch_style"]
			return TRUE

		if("add")
			var/id = params["id"]
			var/amount = text2num(params["amount"])
			if(!id || !amount)
				return FALSE
			R.trans_id_to(src, id, amount)
			return TRUE

		if("remove")
			var/id = params["id"]
			var/amount = text2num(params["amount"])
			if(!id || !amount)
				return FALSE
			if(mode)
				reagents.trans_id_to(beaker, id, amount)
			else
				reagents.remove_reagent(id, amount)
			return TRUE

		if("eject")
			if(!beaker)
				return FALSE
			beaker.forceMove(get_turf(src))
			if(Adjacent(usr) && !issilicon(usr))
				usr.put_in_hands(beaker)
			beaker = null
			R.clear_reagents()
			update_icon()
			return TRUE

		if("create_condi_bottle")
			if(!condi || !reagents.total_volume)
				return FALSE
			var/obj/item/reagent_containers/food/condiment/P = new(loc)
			R.trans_to_obj(P, 50)
			return TRUE

		if("create")
			if(reagents.total_volume == 0)
				return FALSE
			var/item_type = params["type"]
			// Get amount of items
			var/amount = text2num(params["amount"])
			if(amount == null)
				amount = text2num(input(usr,
					"Max 10. Buffer content will be split evenly.",
					"How many to make?", 1))
			amount = clamp(round(amount), 0, 10)
			if (amount <= 0)
				return FALSE
			// Get units per item
			var/vol_each = text2num(params["volume"])
			var/vol_each_text = params["volume"]
			var/vol_each_max = reagents.total_volume / amount
			var/list/style
			use_power(active_power_usage)
			if (item_type == "pill")
				vol_each_max = min(50, vol_each_max)
			else if (item_type == "patch")
				vol_each_max = min(40, vol_each_max)
			else if (item_type == "bottle")
				vol_each_max = min(30, vol_each_max)
			else if (item_type == "condimentPack")
				vol_each_max = min(10, vol_each_max)
			// else if (item_type == "condimentBottle")
			// 	var/list/styles = get_condi_styles()
			// 	if (chosen_condi_style == CONDIMASTER_STYLE_AUTO || !(chosen_condi_style in styles))
			// 		style = guess_condi_style(reagents)
			// 	else
			// 		style = styles[chosen_condi_style]
			// 	vol_each_max = min(50, vol_each_max)
			else
				return FALSE
			if(vol_each_text == "auto")
				vol_each = vol_each_max
			if(vol_each == null)
				vol_each = text2num(input(usr,
					"Maximum [vol_each_max] units per item.",
					"How many units to fill?",
					vol_each_max))
			vol_each = round(clamp(vol_each, 0, vol_each_max), 0.01)
			if(vol_each <= 0)
				return FALSE
			// Get item name
			var/name = params["name"]
			var/name_has_units = item_type == "pill" || item_type == "patch"
			if(!name)
				var/name_default
				if (style && style["name"] && !style["generate_name"])
					name_default = style["name"]
				else
					name_default = reagents.get_master_reagent_name()
				if (name_has_units)
					name_default += " ([vol_each]u)"
				name = tgui_input_text(usr,
					"Give it a name!",
					"Name",
					name_default,
					MAX_NAME_LEN)
			if(!name || !reagents.total_volume || !src || QDELETED(src) || !usr.canUseTopic(src, !issilicon(usr)))
				return FALSE
			// Start filling
			if(item_type == "pill")
				var/obj/item/reagent_containers/pill/P
				var/target_loc = drop_location()
				var/drop_threshold = INFINITY
				if(loaded_pill_bottle)
					if(loaded_pill_bottle.max_storage_space)
						drop_threshold = loaded_pill_bottle.max_storage_space - loaded_pill_bottle.contents.len
						target_loc = loaded_pill_bottle
				for(var/i in 1 to amount)
					if(i-1 < drop_threshold)
						P = new/obj/item/reagent_containers/pill(target_loc)
					else
						P = new/obj/item/reagent_containers/pill(drop_location())
					P.name = trim("[name] pill")
					if(chosen_pill_style == RANDOM_PILL_STYLE)
						P.icon_state ="pill[rand(1, PILL_STYLE_COUNT)]"
					else
						P.icon_state = "pill[chosen_pill_style]"
					if(P.icon_state == "pill4")
						P.desc = "A tablet or capsule, but not just any, a red one, one taken by the ones not scared of knowledge, freedom, uncertainty and the brutal truths of reality."
					adjust_item_drop_location(P)
					reagents.trans_to(P, vol_each)
				return TRUE
			if(item_type == "patch")
				var/obj/item/reagent_containers/pill/patch/P
				for(var/i in 1 to amount)
					P = new/obj/item/reagent_containers/pill/patch(drop_location())
					P.name = trim("[name] patch")
					P.icon_state = chosen_patch_style
					adjust_item_drop_location(P)
					reagents.trans_to(P, vol_each)
				return TRUE
			if(item_type == "bottle")
				var/obj/item/storage/pill_bottle/P
				for(var/i in 1 to amount)
					P = new/obj/item/storage/pill_bottle(drop_location())
					P.name = trim("[name] bottle")
					adjust_item_drop_location(P)
					reagents.trans_to(P, vol_each)
				return TRUE
			// if(item_type == "condimentPack")
			// 	var/obj/item/reagent_containers/condiment/pack/P
			// 	for(var/i in 1 to amount)
			// 		P = new/obj/item/reagent_containers/condiment/pack(drop_location())
			// 		P.originalname = name
			// 		P.name = trim("[name] pack")
			// 		P.desc = "A small condiment pack. The label says it contains [name]."
			// 		reagents.trans_to(P, vol_each)
			// 	return TRUE
			// if(item_type == "condimentBottle")
			// 	var/obj/item/reagent_containers/condiment/P
			// 	for(var/i in 1 to amount)
			// 		P = new/obj/item/reagent_containers/condiment(drop_location())
			// 		if (style)
			// 			apply_condi_style(P, style)
			// 		P.renamedByPlayer = TRUE
			// 		P.name = name
			// 		reagents.trans_to(P, vol_each)
			// 	return TRUE
			return FALSE

	return FALSE

/obj/machinery/chem_master/attack_ai(mob/user)
	return attack_hand(user)

/obj/machinery/chem_master/proc/isgoodnumber(num)
	if(isnum(num))
		if(num > 200)
			num = 200
		else if(num < 0)
			num = 1
		return num
	else
		return FALSE

// /obj/machinery/chem_master/proc/chemical_safety_check(datum/reagents/R)
// 	var/all_safe = TRUE
// 	for(var/datum/reagent/A in R.reagent_list)
// 		if(!GLOB.safe_chem_list.Find(A.id))
// 			all_safe = FALSE
// 	return all_safe

/obj/machinery/chem_master/condimaster
	name = "CondiMaster 3000"
	condi = 1

/obj/machinery/chem_master/adjust_item_drop_location(atom/movable/AM) // Special version for chemmasters and condimasters
	if (AM == beaker)
		AM.pixel_x = AM.base_pixel_x - 8
		AM.pixel_y = AM.base_pixel_y + 8
		return null
	else if (AM == loaded_pill_bottle)
		if (length(loaded_pill_bottle.contents))
			AM.pixel_x = AM.base_pixel_x - 13
		else
			AM.pixel_x = AM.base_pixel_x - 7
		AM.pixel_y = AM.base_pixel_y - 8
		return null
	else
		var/md5 = md5(AM.name)
		for (var/i in 1 to 32)
			. += hex2num(md5[i])
		. = . % 9
		AM.pixel_x = AM.base_pixel_x + ((.%3)*6)
		AM.pixel_y = AM.base_pixel_y - 8 + (round( . / 3)*8)
