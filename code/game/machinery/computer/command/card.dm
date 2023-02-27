
/obj/machinery/computer/card
	name = "\improper ID card modification console"
	desc = "Terminal for programming employee ID cards to access parts of the station."
	icon_keyboard = "id_key"
	icon_screen = "id"
	light_color = "#0099ff"
	circuit = /obj/item/circuitboard/card
	/// modification module
	var/datum/tgui_module/card_mod/standard/id_computer/tgui_cardmod
	/// authing ID
	var/obj/item/card/id/authing
	/// editing ID
	var/obj/item/card/id/editing

/obj/machinery/computer/card/Initialize(mapload)
	. = ..()
	tgui_cardmod = new(src)

/obj/machinery/computer/card/Destroy()
	QDEL_NULL(tgui_cardmod)
	return ..()

/obj/machinery/computer/card/ui_module_route(action, list/params, datum/tgui/ui, id)
	. = ..()
	if(.)
		return
	switch(id)
		if("modify")
			return tgui_cardmod.ui_act(action, params, ui)

/obj/machinery/computer/card/ui_module_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	.["modify"] = tgui_cardmod.data(user, editing, authing)

/obj/machinery/computer/card/ui_module_static(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	.["modify"] = tgui_cardmod.static_data(user, editing, authing)

/**
 * for later use: authorized to change slots
 */
/obj/machinery/computer/card/proc/authed_for_slotmod(obj/item/card/id/checking = authing)
	return ACCESS_COMMAND_CARDMOD in checking?.access

/**
 * authed for at least one possible access change OR rank change
 */
/obj/machinery/computer/card/proc/authed_for_edit(obj/item/card/id/checking = authing)
	return checking?.access && length(SSjob.cached_access_edit_relevant & checking.access)

/obj/machinery/computer/card/AltClick(mob/user)
	. = ..()
	if(.)
		return
	// todo: mobility flags
	if(user.stat || user.lying)
		return
	if(attempt_grab_authing(user) || attempt_grab_editing(user))
		return TRUE

/obj/machinery/computer/card/proc/attempt_grab_authing(mob/user)
	if(!authing)
		return FALSE
	user.grab_item_from_interacted_with(authing, src)
	user.action_feedback(SPAN_NOTICE("You remove [authing] from [src]."), src)
	authing = null
	return TRUE

/obj/machinery/computer/card/proc/attempt_grab_editing(mob/user)
	if(!editing)
		return FALSE
	user.grab_item_from_interacted_with(editing, src)
	user.action_feedback(SPAN_NOTICE("You remove [editing] from [src]."), src)
	editing = null
	return TRUE

/obj/machinery/computer/card/attackby(obj/item/I, mob/living/user, params, clickchain_flags, damage_multiplier)
	if(!istype(I, /obj/item/card/id))
		return ..()
	var/obj/item/card/id/id_card = I
	if(!authing && authed_for_edit(id_card))
		if(!user.transfer_item_to_loc(id_card, src))
			user.action_feedback(SPAN_WARNING("[id_card] is stuck to your hand!"))
			return
		authing = id_card
		user.action_feedback(SPAN_NOTICE("You insert [id_card] into [src]."))
		update_static_data()
	else
		if(!user.transfer_item_to_loc(id_card, src))
			user.action_feedback(SPAN_WARNING("[id_card] is stuck to your hand!"))
			return
		if(isnull(editing))
			// insert
			editing = id_card
			user.action_feedback(SPAN_NOTICE("You insert [id_card] into [src]."))
		else
			// swap
			user.grab_item_from_interacted_with(editing, src)
			user.action_feedback(SPAN_NOTICE("You swap out [editing] for [id_card]."))
			editing = id_card
		update_static_data()
	return CLICKCHAIN_DO_NOT_PROPAGATE

/obj/machinery/computer/card/attack_ai(var/mob/user as mob)
	return attack_hand(user)

/obj/machinery/computer/card/attack_hand(mob/user as mob)
	if(..())
		return
	if(machine_stat & (NOPOWER|BROKEN))
		return
	ui_interact(user)

/obj/machinery/computer/card/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "IdentificationComputer", name)
		ui.open()

/obj/machinery/computer/card/ui_static_data(mob/user)
	. = ..()
	//? manifest
	// todo: refactor PDA_Manifest and CrewManifest.js
	data_core.get_manifest_list()
	.["manifest"] = GLOB.PDA_Manifest

/obj/machinery/computer/card/ui_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()

	//? general
	.["printing"] = TIMER_COOLDOWN_CHECK(src, CD_INDEX_IDCONSOLE_PRINT)

	//? card modification
	.["auth_card"] = authing? list(
		"name" = authing.name || "-----",
		"owner" = authing.registered_name || "-----",
		"rank" = authing.rank || "Unassigned",
	) : null
	.["modify_card"] = editing? list(
		"name" = editing.name || "-----",
		"owner" = editing.registered_name || "-----",
		"rank" = editing.rank || "Unassigned",
	) : null

	//? auth
	.["authed_cardmod"] = authed_for_edit()
	.["authed_slotmod"] = authed_for_slotmod()

/obj/machinery/computer/card/ui_act(action, list/params, datum/tgui/ui)
	if(..())
		return TRUE

	switch(action)
		if("auth")
			if(authing)
				usr.grab_item_from_interacted_with(authing, src)
				usr.action_feedback(SPAN_NOTICE("You remove [authing] from [src]."), src)
				authing = null
			else
				var/obj/item/card/id/inserting = usr.get_active_held_item()
				if(!istype(inserting))
					return TRUE
				if(!usr.transfer_item_to_loc(inserting, src))
					usr.action_feedback(SPAN_WARNING("[inserting] is stuck to your hand!"))
					return TRUE
				authing = inserting
				usr.action_feedback(SPAN_NOTICE("You insert [authing] into [src]."))
			update_static_data()
			return TRUE
		if("modify")
			if(editing)
				usr.grab_item_from_interacted_with(editing, src)
				usr.action_feedback(SPAN_NOTICE("You remove [editing] from [src]."), src)
				editing = null
			else
				var/obj/item/card/id/inserting = usr.get_active_held_item()
				if(!istype(inserting))
					return TRUE
				if(!usr.transfer_item_to_loc(inserting, src))
					usr.action_feedback(SPAN_WARNING("[inserting] is stuck to your hand!"))
					return TRUE
				editing = inserting
				usr.action_feedback(SPAN_NOTICE("You insert [editing] into [src]."))
			update_static_data()
			return TRUE
		if("print_manifest")
			if(TIMER_COOLDOWN_CHECK(src, CD_INDEX_IDCONSOLE_PRINT))
				usr.action_feedback(SPAN_WARNING("[src] is still printing something!"), src)
				return
			TIMER_COOLDOWN_START(src, CD_INDEX_IDCONSOLE_PRINT, 5 SECONDS)
			addtimer(CALLBACK(src, /obj/machinery/computer/card/proc/print_manifest), 5 SECONDS)
			return TRUE
		if("print_card_report")
			if(TIMER_COOLDOWN_CHECK(src, CD_INDEX_IDCONSOLE_PRINT))
				usr.action_feedback(SPAN_WARNING("[src] is still printing something!"), src)
				return
			TIMER_COOLDOWN_START(src, CD_INDEX_IDCONSOLE_PRINT, 5 SECONDS)
			addtimer(CALLBACK(src, /obj/machinery/computer/card/proc/print_card_report), 5 SECONDS)
			return TRUE

/obj/machinery/computer/card/proc/print_manifest()
	var/obj/item/paper/P = new(loc)
	P.name = text("crew manifest ([])", stationtime2text())
	P.info = {"<h4>Crew Manifest</h4>
		<br>
		[data_core ? data_core.get_manifest(0) : ""]
	"}

/obj/machinery/computer/card/proc/print_card_report()
	if(!editing || !authing)
		visible_message(SPAN_NOTICE("Printing failed: Target or authenticating card removed."))
		return
	var/obj/item/card/id/scanning = editing
	var/obj/item/paper/P = new(loc)
	P.name = "access report - [scanning.name]"
	P.info = {"<h4>Access Report</h4>
		<u>Prepared By:</u> [authing.registered_name ? authing.registered_name : "Unknown"]<br>
		<u>For:</u> [editing.registered_name ? editing.registered_name : "Unregistered"]<br>
		<hr>
		<u>Assignment:</u> [editing.assignment]<br>
		<u>Account Number:</u> #[editing.associated_account_number]<br>
		<u>Access:</u><br>
	"}
	var/list/by_cat = list()
	var/list/joining = list()
	for(var/datum/access/A in SSjob.access_lookup_multiple(editing.access))
		LAZYADD(by_cat[A.access_category], A)
	for(var/category in by_cat)
		joining += "<b>[category]:</b><br>"
		for(var/datum/access/A as anything in by_cat[category])
			joining += "- [A.access_name]<br>"
	P.info += jointext(joining, "")

