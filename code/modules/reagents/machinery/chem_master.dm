/obj/machinery/chem_master
	name = "ChemMaster 3000"
	desc = "Used to seperate and package chemicals in to autoinjectors, lollipops, patches, pills, or bottles. Warranty void if used to create Space Drugs."
	density = TRUE
	anchored = TRUE
	icon = 'icons/obj/medical/chemical.dmi'
	icon_state = "mixer0"
	base_icon_state = "mixer"
	circuit = /obj/item/circuitboard/chem_master
	use_power = USE_POWER_IDLE
	idle_power_usage = 20
	flags = OPENCONTAINER
	clicksound = "button"

	/// Input reagents container.
	var/obj/item/reagent_containers/beaker = null
	/// Pill bottle for newly created pills.
	var/obj/item/storage/pill_bottle/pill_bottle = null
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
	var/chosen_condi_style = CONDIMASTER_STYLE_AUTO
	/// List of available condi styles for UI
	var/list/condi_styles

/obj/machinery/chem_master/condimaster
	name = "CondiMaster 3000"
	condi = TRUE

/obj/machinery/chem_master/Initialize(mapload, newdir)
	. = ..()
	default_apply_parts()
	create_reagents(1000)

/obj/machinery/chem_master/Destroy()
	QDEL_NULL(beaker)
	QDEL_NULL(pill_bottle)
	return ..()

/obj/machinery/chem_master/RefreshParts()
	. = ..()
	reagents.maximum_volume = 0
	for(var/obj/item/reagent_containers/glass/beaker/B in component_parts)
		reagents.maximum_volume += B.reagents.maximum_volume

/obj/machinery/chem_master/legacy_ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				qdel(src)
				return

/obj/machinery/chem_master/update_icon_state()
	icon_state = "[base_icon_state][beaker ? 1 : 0][(machine_stat & BROKEN) ? "_b" : (powered() ? null : "_nopower")]"
	return ..()

/obj/machinery/chem_master/update_overlays()
	. = ..()
	if(machine_stat & BROKEN)
		. += "waitlight"

/obj/machinery/chem_master/blob_act(obj/structure/blob/B)
	if (prob(50))
		qdel(src)

/obj/machinery/chem_master/attackby(obj/item/I, mob/user, params)
	if(default_unfasten_wrench(user, I, 20))
		return
	else if(default_deconstruction_screwdriver(user, "mixer0_nopower", "mixer0", I))
		return

	else if(default_deconstruction_crowbar(I))
		return

	if(is_reagent_container(I) && !(I.item_flags & ATOM_ABSTRACT) && I.is_open_container())
		. = TRUE // no afterattack
		if(panel_open)
			to_chat(user, SPAN_WARNING("You can't use the [src.name] while its panel is opened!"))
			return
		if(src.beaker)
			to_chat(user, "\A [beaker] is already loaded into the machine.")
			return
		var/obj/item/reagent_containers/B = I
		. = TRUE // no afterattack
		if(!user.attempt_insert_item_for_installation(B, src))
			return

		replace_beaker(user, B)
		to_chat(user, SPAN_NOTICE("You add [B] to [src]."))
		ui_interact(user)
		update_appearance()

	else if(!condi && istype(I, /obj/item/storage/pill_bottle))
		if(pill_bottle)
			to_chat(user, SPAN_WARNING("A pill bottle is already loaded into [src]!"))
			return
		if(!user.attempt_insert_item_for_installation(I, src))
			return
		pill_bottle = I
		to_chat(user, SPAN_NOTICE("You add [I] into the dispenser slot."))
		ui_interact(user)
	else
		return ..()

/obj/machinery/chem_master/on_deconstruction()
	replace_beaker()
	if(pill_bottle)
		pill_bottle.forceMove(drop_location())
		adjust_item_drop_location(pill_bottle)
		pill_bottle = null
	return ..()

/obj/machinery/chem_master/attack_hand(mob/user)
	if(machine_stat & BROKEN)
		return
	user.set_machine(src)
	ui_interact(user)

/**
 * Handles process of moving input reagents containers in/from machine
 *
 * When called checks for previously inserted beaker and gives it to user.
 * Then, if new_beaker provided, places it into src.beaker.
 * Returns `boolean`. TRUE if user provided (ignoring whether threre was any beaker change) and FALSE if not.
 *
 * Arguments:
 * * user - Mob that initialized replacement, gets previously inserted beaker if there's any
 * * new_beaker - New beaker to insert. Optional
 */
/obj/machinery/chem_master/proc/replace_beaker(mob/living/user, obj/item/reagent_containers/new_beaker)
	if(!user)
		return FALSE
	if(beaker)
		try_put_in_hand(beaker, user)
		beaker = null
	if(new_beaker)
		beaker = new_beaker
	update_appearance()
	return TRUE

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

/obj/machinery/chem_master/ui_data(mob/user)
	var/list/data = list()

	data["autosprite"] = autosprite
	data["mode"] = mode
	data["printing"] = printing
	data["condi"] = condi

	data["pill_bottle"] = !!pill_bottle
	if(pill_bottle)
		data["pill_bottle_name"] = pill_bottle.name
		data["pill_bottle_contents_len"] = pill_bottle.contents.len
		data["pill_bottle_storage_slots"] = pill_bottle.max_storage_space

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

	data["chosen_pill_style"] = chosen_pill_style
	data["chosen_bottle_style"] = chosen_bottle_style
	data["chosen_patch_style"] = chosen_patch_style
	data["chosenCondiStyle"] = chosen_condi_style
	data["autoCondiStyle"] = CONDIMASTER_STYLE_AUTO

	// Transfer modal information if there is one
	data["modal"] = ui_modal_data(src)

	return data

/obj/machinery/chem_master/ui_static_data(mob/user)
	var/list/data = list()
	//Calculated once since it'll never change
	if(!pill_styles || !bottle_styles || !chosen_patch_style || !patch_styles)
		load_styles()
	data["pill_styles"] = pill_styles
	data["bottle_styles"] = bottle_styles
	data["patch_styles"] = patch_styles
	data["condi_styles"] = condi_styles

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
			ui_open_modal(action, params, ui, state, id, arguments)
		if(UI_MODAL_ANSWER)
			var/answer = params["answer"]
			ui_answer_modal(action, params, ui, state, id, arguments, answer)
		else
			return FALSE

/**
 * Called in ui_act_modal() to process modal calls
 *
 *! This is a temporary solution until we have a better way to handle modals.
 *! Prefereably not what Virgo made.
 *! @Zandario
 */
/obj/machinery/chem_master/proc/ui_open_modal(action, params, datum/tgui/ui, datum/ui_state/state, id, arguments)
	switch(id)

		//! UNIVERSAL MODALS

		if("analyze")
			var/idx = text2num(arguments["idx"]) || 0
			var/from_beaker = text2num(arguments["beaker"]) || FALSE
			var/reagent_list = from_beaker ? beaker.reagents.reagent_list : reagents.reagent_list
			if(idx < 1 || idx > length(reagent_list))
				return

			var/datum/reagent/analyzed_reagent = GLOB.name2reagent[idx]
			var/list/result = list(
				"idx" = analyzed_reagent.id,
				"name" = analyzed_reagent.name,
				"desc" = analyzed_reagent.description,
			)
			if(!condi && istype(analyzed_reagent, /datum/reagent/blood))
				var/datum/reagent/blood/B = analyzed_reagent
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

		//! CONDIMENT MODALS

		if("create_condi_pack")
			if(!condi || !reagents.total_volume)
				return
			ui_modal_input(src, id, "Please name your new condiment pack:", null, arguments, reagents.get_master_reagent_name(), MAX_CUSTOM_NAME_LEN)

		//! PILL MODALS

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

		//! PATCH MODALS

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

		//! LOLLIPOP MODALS

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

		//! AUTOINJECTOR MODALS

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

		//! BOTTLE MODALS

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

/**
 * Called in ui_act_modal() to process modal answers
 *
 *! This is a temporary solution until we have a better way to handle modals.
 *! Prefereably not what Virgo made.
 *! @Zandario
 */
/obj/machinery/chem_master/proc/ui_answer_modal(action, params, datum/tgui/ui, datum/ui_state/state, id, arguments, answer)
	switch(id)

		//! UNIVERSAL MODALS

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

		//! CONDIMENTS MODALS

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

		//! PILL MODALS

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
					to_chat(usr, SPAN_NOTICE("Not enough reagents to create these pills!"))
					return

				var/obj/item/reagent_containers/pill/P = new(loc)
				P.name = "[answer] pill"
				adjust_item_drop_location(P)

				// Set our Icon and color.
				if(chosen_pill_style == RANDOM_PILL_STYLE)
					P.icon_state ="pill[rand(1, PILL_STYLE_COUNT)]"
				else
					P.icon_state = "pill[chosen_pill_style]"
				if(P.icon_state in PILL_STYLE_RED)
					P.desc = "A tablet or capsule, but not just any, a red one, one taken by the ones not scared of knowledge, freedom, uncertainty and the brutal truths of reality."
				if(P.icon_state in PILL_STYLE_COLORABLE) // if using greyscale, take colour from reagent
					P.color = reagents.get_color()

				reagents.trans_to_obj(P, amount_per_pill)
				// Load the pills in the bottle if there's one loaded
				if(istype(pill_bottle) && length(pill_bottle.contents) < pill_bottle.max_storage_space)
					P.forceMove(pill_bottle)

		if("create_pill_multiple")
			if(condi || !reagents.total_volume)
				return
			ui_act("modal_open", list("id" = "create_pill", "arguments" = list("num" = answer)), ui, state)

		//! PATCH MODALS

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
					to_chat(usr, SPAN_NOTICE("Not enough reagents to create these patches!"))
					return

				var/obj/item/reagent_containers/pill/patch/P = new(loc)
				P.name = trim("[answer] patch")
				P.icon_state = chosen_patch_style
				adjust_item_drop_location(P)
				reagents.trans_to_obj(P, amount_per_patch)

		if("create_patch_multiple")
			if(condi || !reagents.total_volume)
				return
			ui_act("modal_open", list("id" = "create_patch", "arguments" = list("num" = answer)), ui, state)

		//! LOLLIPOP MODALS

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
					to_chat(usr, SPAN_NOTICE("Not enough reagents to create these candies!"))
					return

				var/obj/item/reagent_containers/hard_candy/lollipop/L = new(loc)
				L.name = trim("[name] lollipop")
				adjust_item_drop_location(L)
				reagents.trans_to_obj(L, amount_per_lolli)

		if("create_lollipop_multiple")
			if(condi || !reagents.total_volume)
				return
			ui_act("modal_open", list("id" = "create_lollipop", "arguments" = list("num" = answer)), ui, state)

		//! AUTOINJECTOR MODALS

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
					to_chat(usr, SPAN_NOTICE("Not enough reagents to create these injectors!"))
					return

				var/obj/item/reagent_containers/hypospray/autoinjector/empty/A = new(loc)
				A.name = trim("[answer] autoinjector")
				adjust_item_drop_location(A)
				reagents.trans_to_obj(A, amount_per_auto)

		if("create_autoinjector_multiple")
			if(condi || !reagents.total_volume)
				return
			ui_act("modal_open", list("id" = "create_autoinjector", "arguments" = list("num" = answer)), ui, state)

		//! BOTTLE MODALS

		if("create_bottle")
			if(condi || !reagents.total_volume)
				return
			var/count = clamp(round(text2num(arguments["num"]) || 0), 0, MAX_MULTI_AMOUNT)
			if(!count)
				return

			if(!length(answer))
				answer = reagents.get_master_reagent_name()
			var/amount_per_bottle = clamp(reagents.total_volume / count, 0, MAX_UNITS_PER_BOTTLE)
			var/obj/item/reagent_containers/glass/bottle/P
			while(count--)
				if(reagents.total_volume <= 0)
					to_chat(usr, SPAN_NOTICE("Not enough reagents to create these bottles!"))
					return

				P = new/obj/item/reagent_containers/glass/bottle(drop_location())
				P.name = trim("[answer] bottle")
				P.icon_state = "bottle-[chosen_bottle_style]" || "bottle-1"
				adjust_item_drop_location(P)
				reagents.trans_to_obj(P, amount_per_bottle)

		if("create_bottle_multiple")
			if(condi || !reagents.total_volume)
				return
			ui_act("modal_open", list("id" = "create_bottle", "arguments" = list("num" = answer)), ui, state)

		else
			return FALSE

/obj/machinery/chem_master/ui_act(action, params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

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

		if("eject")
			replace_beaker(usr)
			return TRUE

		if("eject_pill_bottle")
			if(!pill_bottle)
				return FALSE
			pill_bottle.forceMove(drop_location())
			adjust_item_drop_location(pill_bottle)
			pill_bottle = null
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

		if("change_bottle_style")
			var/id = text2num(params["id"])
			chosen_bottle_style = id
			return TRUE

		if("change_pill_style")
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

		if("create_condi_bottle")
			if(!condi || !reagents.total_volume)
				return FALSE
			var/obj/item/reagent_containers/food/condiment/P = new(loc)
			R.trans_to_obj(P, 50)
			return TRUE

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

/obj/machinery/chem_master/adjust_item_drop_location(atom/movable/AM) // Special version for chemmasters and condimasters
	if (AM == beaker)
		AM.pixel_x = AM.base_pixel_x - 8
		AM.pixel_y = AM.base_pixel_y + 8
		return null
	else if (AM == pill_bottle)
		if (length(pill_bottle.contents))
			AM.pixel_x = AM.base_pixel_x - 13
		else
			AM.pixel_x = AM.base_pixel_x - 7
		AM.pixel_y = AM.base_pixel_y - 8
		return null
	else if (istype(AM, /obj/item/reagent_containers/pill))
		AM.pixel_x = AM.base_pixel_x + rand(-7, 7)
		AM.pixel_y = AM.base_pixel_y + rand(-7, 7)
		return null
	else
		var/md5 = md5(AM.name)
		for (var/i in 1 to 32)
			. += hex2num(md5[i])
		. = . % 9
		AM.pixel_x = AM.base_pixel_x + ((.%3)*6)
		AM.pixel_y = AM.base_pixel_y - 8 + (round( . / 3)*8)
