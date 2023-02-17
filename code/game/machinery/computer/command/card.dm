
/obj/machinery/computer/card
	name = "\improper ID card modification console"
	desc = "Terminal for programming employee ID cards to access parts of the station."
	icon_keyboard = "id_key"
	icon_screen = "id"
	light_color = "#0099ff"
	circuit = /obj/item/circuitboard/card
	/// modification module
	var/datum/tgui_module/card_mod/standard/tgui_cardmod
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

/obj/machinery/computer/card/ui_module_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	.["modify"] = tgui_cardmod.data(user, editing, authing)

/obj/machinery/computer/card/ui_module_static(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	.["modify"] = tgui_cardmod.static_data(user, editing, authing)

#warn update static modules when card is swapped
#warn impl all

/obj/machinery/computer/card/proc/is_authenticated()
	return scan ? check_access(scan) : 0


/obj/machinery/computer/card/verb/eject_id()
	set category = "Object"
	set name = "Eject ID Card"
	set src in oview(1)

	if(!usr || usr.stat || usr.lying)	return

	if(scan)
		to_chat(usr, "You remove \the [scan] from \the [src].")
		scan.forceMove(get_turf(src))
		if(!usr.get_active_held_item() && istype(usr,/mob/living/carbon/human))
			usr.put_in_hands(scan)
		scan = null
	else if(modify)
		to_chat(usr, "You remove \the [modify] from \the [src].")
		modify.forceMove(get_turf(src))
		if(!usr.get_active_held_item() && istype(usr,/mob/living/carbon/human))
			usr.put_in_hands(modify)
		modify = null
	else
		to_chat(usr, "There is nothing to remove from the console.")
	return

/obj/machinery/computer/card/attackby(obj/item/card/id/id_card, mob/user)
	if(!istype(id_card))
		return ..()

	if(!scan && (ACCESS_COMMAND_CARDMOD in id_card.access))
		if(!user.attempt_insert_item_for_installation(id_card, src))
			return
		scan = id_card
	else if(!modify)
		if(!user.attempt_insert_item_for_installation(id_card, src))
			return
		modify = id_card

	SStgui.update_uis(src)
	attack_hand(user)

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
		"owner" = authing.owner || "-----",
		"rank" = authing.rank || "Unassigned",
	) : null
	.["modify_card"] = editing? list(
		"name" = editing.name || "-----",
		"owner" = editing.registered_name || "-----",
		"rank" = editing.rank || "Unassigned",
	) : null

	data["authenticated"] = is_authenticated()

/obj/machinery/computer/card/ui_act(action, list/params, datum/tgui/ui)
	if(..())
		return TRUE

	switch(action)
		if("modify")
			if(modify)
				data_core.manifest_modify(modify.registered_name, modify.assignment, modify.rank)
				modify.name = "[modify.registered_name]'s ID Card ([modify.assignment])"
				if(ishuman(usr))
					modify.forceMove(get_turf(src))
					if(!usr.get_active_held_item())
						usr.put_in_hands(modify)
					modify = null
				else
					modify.forceMove(get_turf(src))
					modify = null
			else
				var/obj/item/I = usr.get_active_held_item()
				if(istype(I, /obj/item/card/id))
					if(!usr.attempt_insert_item_for_installation(I, src))
						return
					modify = I
			. = TRUE

		if("scan")
			if(scan)
				if(ishuman(usr))
					scan.forceMove(get_turf(src))
					if(!usr.get_active_held_item())
						usr.put_in_hands(scan)
					scan = null
				else
					scan.forceMove(get_turf(src))
					scan = null
			else
				var/obj/item/I = usr.get_active_held_item()
				if(istype(I, /obj/item/card/id))
					if(!usr.attempt_insert_item_for_installation(I, src))
						return
					scan = I
			. = TRUE

		if("access")
			if(is_authenticated())
				var/access_type = text2num(params["access_target"])
				var/access_allowed = text2num(params["allowed"])
				if(access_type in (is_centcom() ? get_all_centcom_access() : get_all_station_access()))
					modify.access -= access_type
					if(!access_allowed)
						modify.access += access_type
				modify.lost_access = list()
			. = TRUE

		if("assign")
			if(is_authenticated() && modify)
				var/t1 = params["assign_target"]
				if(t1 == "Custom")
					var/temp_t = sanitize(input("Enter a custom job assignment.","Assignment"), 45)
					//let custom jobs function as an impromptu alt title, mainly for sechuds
					if(temp_t && modify)
						modify.assignment = temp_t
				else
					var/list/access = list()
					if(is_centcom())
						access = get_centcom_access(t1)
					else
						var/datum/role/job/jobdatum = SSjob.get_job(t1)
						if(!jobdatum)
							to_chat(usr, "<span class='warning'>No log exists for this job: [t1]</span>")
							return
						access = jobdatum.get_access()

					modify.access = access
					modify.assignment = t1
					modify.rank = t1
					modify.lost_access = list()

				callHook("reassign_employee", list(modify))
			. = TRUE

		if("reg")
			if(is_authenticated())
				var/temp_name = sanitizeName(params["reg"])
				if(temp_name)
					modify.registered_name = temp_name
				else
					visible_message("<span class='notice'>[src] buzzes rudely.</span>")
			. = TRUE

		if("account")
			if(is_authenticated())
				var/account_num = text2num(params["account"])
				modify.associated_account_number = account_num
			. = TRUE

		if("mode")
			mode = text2num(params["mode_target"])
			. = TRUE

		if("print")
			if(!printing)
				printing = 1
				spawn(50)
					printing = null
					SStgui.update_uis(src)

					var/obj/item/paper/P = new(loc)
					if(mode)
						P.name = text("crew manifest ([])", stationtime2text())
						P.info = {"<h4>Crew Manifest</h4>
							<br>
							[data_core ? data_core.get_manifest(0) : ""]
						"}
					else if(modify)
						P.name = "access report"
						P.info = {"<h4>Access Report</h4>
							<u>Prepared By:</u> [scan.registered_name ? scan.registered_name : "Unknown"]<br>
							<u>For:</u> [modify.registered_name ? modify.registered_name : "Unregistered"]<br>
							<hr>
							<u>Assignment:</u> [modify.assignment]<br>
							<u>Account Number:</u> #[modify.associated_account_number]<br>
							<u>Blood Type:</u> [modify.blood_type]<br><br>
							<u>Access:</u><br>
						"}

						for(var/A in modify.access)
							P.info += "  [get_access_desc(A)]"
				. = TRUE

		if("terminate")
			if(is_authenticated())
				modify.assignment = "Dismissed"
				modify.access = list()
				modify.lost_access = list() // Reset the lost access upon any modifications

				callHook("terminate_employee", list(modify))

			. = TRUE

	if(modify)
		modify.name = "[modify.registered_name]'s ID Card ([modify.assignment])"
