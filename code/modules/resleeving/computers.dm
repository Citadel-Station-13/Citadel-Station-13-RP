#define MENU_MAIN 1
#define MENU_BODY 2
#define MENU_MIND 3

/obj/machinery/computer/transhuman/resleeving
	name = "resleeving control console"
	catalogue_data = list(///datum/category_item/catalogue/information/organization/vey_med,
						/datum/category_item/catalogue/technology/resleeving)
	icon_keyboard = "med_key"
	icon_screen = "dna"
	light_color = "#315ab4"
	circuit = /obj/item/circuitboard/resleeving_control
	req_access = list(access_heads) //Only used for record deletion right now.
	var/list/pods = null //Linked grower pods.
	var/list/spods = null
	var/list/sleevers = null //Linked resleeving booths.
	var/list/temp = null
	var/menu = MENU_MAIN //Which menu screen to display
	var/datum/transhuman/body_record/active_br = null
	var/datum/transhuman/mind_record/active_mr = null
	var/organic_capable = 1
	var/synthetic_capable = 1
	var/obj/item/disk/transcore/disk
	var/obj/machinery/clonepod/transhuman/selected_pod
	var/obj/machinery/transhuman/synthprinter/selected_printer
	var/obj/machinery/transhuman/resleever/selected_sleever
	var/hasmirror = null

/obj/machinery/computer/transhuman/resleeving/Initialize(mapload)
	. = ..()
	pods = list()
	spods = list()
	sleevers = list()
	updatemodules()

/obj/machinery/computer/transhuman/resleeving/Destroy()
	releasepods()
	return ..()

/obj/machinery/computer/transhuman/resleeving/proc/updatemodules()
	releasepods()
	findpods()

/obj/machinery/computer/transhuman/resleeving/proc/releasepods()
	for(var/obj/machinery/clonepod/transhuman/P in pods)
		P.connected = null
		P.name = initial(P.name)
	pods.Cut()
	for(var/obj/machinery/transhuman/synthprinter/P in spods)
		P.connected = null
		P.name = initial(P.name)
	spods.Cut()
	for(var/obj/machinery/transhuman/resleever/P in sleevers)
		P.connected = null
		P.name = initial(P.name)
	sleevers.Cut()

/obj/machinery/computer/transhuman/resleeving/proc/findpods()
	var/num = 1
	var/area/A = get_area(src)
	for(var/obj/machinery/clonepod/transhuman/P in A.get_contents())
		if(!P.connected)
			pods += P
			P.connected = src
			P.name = "[initial(P.name)] #[num++]"
	for(var/obj/machinery/transhuman/synthprinter/P in A.get_contents())
		if(!P.connected)
			spods += P
			P.connected = src
			P.name = "[initial(P.name)] #[num++]"
	for(var/obj/machinery/transhuman/resleever/P in A.get_contents())
		if(!P.connected)
			sleevers += P
			P.connected = src
			P.name = "[initial(P.name)] #[num++]"

/obj/machinery/computer/transhuman/resleeving/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/multitool))
		var/obj/item/multitool/M = W
		var/obj/machinery/clonepod/transhuman/P = M.connecting
		if(istype(P) && !(P in pods))
			pods += P
			P.connected = src
			P.name = "[initial(P.name)] #[pods.len]"
			to_chat(user, "<span class='notice'>You connect [P] to [src].</span>")
	else if(istype(W, /obj/item/disk/transcore) && SStranscore && !SStranscore.core_dumped)
		user.unEquip(W)
		disk = W
		disk.forceMove(src)
		to_chat(user, "<span class='notice'>You insert \the [W] into \the [src].</span>")
	if(istype(W, /obj/item/disk/body_record))
		var/obj/item/disk/body_record/brDisk = W
		if(!brDisk.stored)
			to_chat(user, "<span class='warning'>\The [W] does not contain a stored body record.</span>")
			return
		user.unEquip(W)
		W.forceMove(get_turf(src)) // Drop on top of us
		active_br = new /datum/transhuman/body_record(brDisk.stored) // Loads a COPY!
		to_chat(user, "<span class='notice'>\The [src] loads the body record from \the [W] before ejecting it.</span>")
		attack_hand(user)
	if(istype(W, /obj/item/implant/mirror))
		user.drop_item()
		W.forceMove(src)
		hasmirror = W
		user.visible_message("[user] inserts the [W] into the [src].", "You insert the [W] into the [src].")
	if(istype(W, /obj/item/mirrortool))
		var/obj/item/mirrortool/MT = W
		if(MT.imp)
			active_mr = MT.imp.stored_mind
			hasmirror = MT.imp
			MT.imp = null
			user.visible_message("Mirror successfully transferred.")
		else
			if(!MT.imp)
				user.visible_message("This Mirror Installation Tool is empty.")
	if(istype(W, /obj/item/dogborg/mirrortool))
		var/obj/item/mirrortool/MT = W
		if(MT.imp)
			active_mr = MT.imp.stored_mind
			hasmirror = MT.imp
			MT.imp = null
			user.visible_message("Mirror successfully transferred.")
		else
			if(!MT.imp)
				user.visible_message("This Mirror Installation Tool is empty.")


	return ..()

/obj/machinery/computer/transhuman/resleeving/verb/eject_mirror()
	set category = "Object"
	set name = "Eject Mirror"
	set src in oview(1)

	if(hasmirror)
		to_chat(usr, "You eject the mirror.")
		usr.put_in_hands(hasmirror)
		hasmirror = null
		active_mr = null
	else
		to_chat(usr, "There is no mirror to eject.")

/obj/machinery/computer/transhuman/resleeving/attack_ai(mob/user as mob)
	return attack_hand(user)

/obj/machinery/computer/transhuman/resleeving/attack_hand(mob/user as mob)
	user.set_machine(src)
	add_fingerprint(user)

	if(stat & (BROKEN|NOPOWER))
		return

	updatemodules()
	ui_interact(user)

/obj/machinery/computer/transhuman/resleeving/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/simple/namespaced/cloning),
		get_asset_datum(/datum/asset/simple/namespaced/cloning/resleeving),
	)

/obj/machinery/computer/transhuman/resleeving/ui_interact(mob/user, datum/tgui/ui = null)
	if(stat & (NOPOWER|BROKEN))
		return

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ResleevingConsole", "Resleeving Console")
		ui.open()

/obj/machinery/computer/transhuman/resleeving/ui_data(mob/user)
	var/data[0]
	data["menu"] = menu

	var/list/temppods[0]
	for(var/obj/machinery/clonepod/transhuman/pod in pods)
		var/status = "idle"
		if(pod.mess)
			status = "mess"
		else if(pod.occupant && !(pod.stat & NOPOWER))
			status = "cloning"
		temppods.Add(list(list(
			"pod" = "\ref[pod]",
			"name" = sanitize(capitalize(pod.name)),
			"biomass" = pod.get_biomass(),
			"status" = status,
			"progress" = (pod.occupant && pod.occupant.stat != DEAD) ? pod.get_completion() : 0
		)))
	data["pods"] = temppods.Copy()
	temppods.Cut()

	for(var/obj/machinery/transhuman/synthprinter/spod in spods)
		temppods.Add(list(list(
			"spod" = "\ref[spod]",
			"name" = sanitize(capitalize(spod.name)),
			"busy" = spod.busy,
			"steel" = spod.stored_material[DEFAULT_WALL_MATERIAL],
			"glass" = spod.stored_material["glass"]
		)))
	data["spods"] = temppods.Copy()
	temppods.Cut()

	for(var/obj/machinery/transhuman/resleever/resleever in sleevers)
		temppods.Add(list(list(
			"sleever" = "\ref[resleever]",
			"name" = sanitize(capitalize(resleever.name)),
			"occupied" = !!resleever.occupant,
			"occupant" = resleever.occupant ? resleever.occupant.real_name : "None"
		)))
	data["sleevers"] = temppods.Copy()
	temppods.Cut()

	data["coredumped"] = SStranscore.core_dumped
	data["emergency"] = disk
	data["temp"] = temp
	data["selected_pod"] = "\ref[selected_pod]"
	data["selected_printer"] = "\ref[selected_printer]"
	data["selected_sleever"] = "\ref[selected_sleever]"

	var/bodyrecords_list_ui[0]
	for(var/N in SStranscore.body_scans)
		var/datum/transhuman/body_record/BR = SStranscore.body_scans[N]
		bodyrecords_list_ui[++bodyrecords_list_ui.len] = list("name" = N, "recref" = "\ref[BR]")
	data["bodyrecords"] = bodyrecords_list_ui

	var/mindrecords_list_ui[0]
	for(var/N in SStranscore.backed_up)
		var/datum/transhuman/mind_record/MR = SStranscore.backed_up[N]
		mindrecords_list_ui[++mindrecords_list_ui.len] = list("name" = N, "recref" = "\ref[MR]")
	data["mindrecords"] = mindrecords_list_ui

	data["modal"] = ui_modal_data(src)
	return data

/obj/machinery/computer/transhuman/resleeving/ui_act(action, params)
	if(..())
		return

	. = TRUE
	switch(ui_modal_act(src, action, params))
		if(UI_MODAL_ANSWER)
			// if(params["id"] == "del_rec" && active_record)
			// 	var/obj/item/card/id/C = usr.get_active_hand()
			// 	if(!istype(C) && !istype(C, /obj/item/pda))
			// 		set_temp("ID not in hand.", "bad")
			// 		return
			// 	if(check_access(C))
			// 		records.Remove(active_record)
			// 		qdel(active_record)
			// 		set_temp("Record deleted.", "success")
			// 		menu = MENU_RECORDS
			// 	else
			// 		set_temp("Access denied.", "bad")
			return

	switch(action)
		if("view_b_rec")
			var/ref = params["ref"]
			if(!length(ref))
				return
			active_br = locate(ref)
			if(istype(active_br))
				if(isnull(active_br.ckey))
					qdel(active_br)
					set_temp("Error: Record corrupt.", "bad")
				else
					var/can_grow_active = 1
					if(!synthetic_capable && active_br.synthetic) //Disqualified due to being synthetic in an organic only.
						can_grow_active = 0
						set_temp("Error: Cannot grow [active_br.mydna.name] due to lack of synthfabs.", "bad")
					else if(!organic_capable && !active_br.synthetic) //Disqualified for the opposite.
						can_grow_active = 0
						set_temp("Error: Cannot grow [active_br.mydna.name] due to lack of cloners.", "bad")
					else if(!synthetic_capable && !organic_capable) //What have you done??
						can_grow_active = 0
						set_temp("Error: Cannot grow [active_br.mydna.name] due to lack of synthfabs and cloners.", "bad")
					else if(active_br.toocomplex)
						can_grow_active = 0
						set_temp("Error: Cannot grow [active_br.mydna.name] due to species complexity.", "bad")
					var/list/payload = list(
						activerecord = "\ref[active_br]",
						realname = sanitize(active_br.mydna.name),
						species = active_br.speciesname ? active_br.speciesname : active_br.mydna.dna.species,
						sex = active_br.bodygender,
						mind_compat = active_br.locked ? "Low" : "High",
						synthetic = active_br.synthetic,
						oocnotes = active_br.body_oocnotes ? active_br.body_oocnotes : "None",
						can_grow_active = can_grow_active,
					)
					ui_modal_message(src, action, "", null, payload)
			else
				active_br = null
				set_temp("Error: Record missing.", "bad")
		if("view_m_rec")
			var/ref = params["ref"]
			if(!length(ref))
				return
			active_mr = locate(ref)
			if(istype(active_mr))
				if(isnull(active_mr.ckey))
					qdel(active_mr)
					set_temp("Error: Record corrupt.", "bad")
				else
					var/can_sleeve_active = 1
					if(!LAZYLEN(sleevers))
						can_sleeve_active = 0
						set_temp("Error: Cannot sleeve due to no sleevers.", "bad")
					if(!selected_sleever)
						can_sleeve_active = 0
						set_temp("Error: Cannot sleeve due to no selected sleever.", "bad")
					if(selected_sleever && !selected_sleever.occupant)
						can_sleeve_active = 0
						set_temp("Error: Cannot sleeve due to lack of sleever occupant.", "bad")
					var/list/payload = list(
						activerecord = "\ref[active_mr]",
						realname = sanitize(active_mr.mindname),
						obviously_dead = active_mr.dead_state == MR_DEAD ? "Past-due" : "Current",
						oocnotes = active_mr.mind_oocnotes ? active_mr.mind_oocnotes : "None.",
						can_sleeve_active = can_sleeve_active,
					)
					ui_modal_message(src, action, "", null, payload)
			else
				active_mr = null
				set_temp("Error: Record missing.", "bad")
		if("coredump")
			if(disk)
				SStranscore.core_dump(disk)
				sleep(5)
				visible_message("<span class='warning'>\The [src] spits out \the [disk].</span>")
				disk.forceMove(get_turf(src))
				disk = null
		if("ejectdisk")
			disk.forceMove(get_turf(src))
			disk = null

		if("create")
			if(istype(active_br))
				//Tried to grow a synth but no synth pods.
				if(active_br.synthetic && !spods.len)
					set_temp("Error: No SynthFabs detected.", "bad")
				//Tried to grow an organic but no growpods.
				else if(!active_br.synthetic && !pods.len)
					set_temp("Error: No growpods detected.", "Bad")
				//We have the machines. We can rebuild them. Probably.
				else
					//We're cloning a synth.
					if(active_br.synthetic)
						var/obj/machinery/transhuman/synthprinter/spod = selected_printer
						if(!istype(spod))
							set_temp("Error: No SynthFab selected.", "bad")
							return

						//Already doing someone.
						if(spod.busy)
							set_temp("Error: SynthFab is currently busy.", "bad")
							return

						//Not enough steel or glass
						else if(spod.stored_material[DEFAULT_WALL_MATERIAL] < spod.body_cost)
							set_temp("Error: Not enough [DEFAULT_WALL_MATERIAL] in SynthFab.", "bad")
							return
						else if(spod.stored_material["glass"] < spod.body_cost)
							set_temp("Error: Not enough glass in SynthFab.", "bad")
							return

						//Gross pod (broke mid-cloning or something).
						else if(spod.broken)
							set_temp("Error: SynthFab malfunction.", "bad")
							return

						//Do the cloning!
						else if(spod.print(active_br))
							set_temp("Initiating printing cycle...", "good")
							menu = 1
						else
							set_temp("Initiating printing cycle... Error: Post-initialisation failed. Printing cycle aborted.", "bad")
							return

					//We're cloning an organic.
					else
						var/obj/machinery/clonepod/transhuman/pod = selected_pod
						if(!istype(pod))
							set_temp("Error: No clonepod selected.", "bad")
							return

						//Already doing someone.
						if(pod.occupant)
							set_temp("Error: Growpod is currently occupied.", "bad")
							return

						//Not enough materials.
						else if(pod.get_biomass() < CLONE_BIOMASS)
							set_temp("Error: Not enough biomass.", "bad")
							return

						//Gross pod (broke mid-cloning or something).
						else if(pod.mess)
							set_temp("Error: Growpod malfunction.", "bad")
							return

						//Disabled in config.
						else if(!config_legacy.revival_cloning)
							set_temp("Error: Unable to initiate growing cycle.", "bad")
							return

						//Do the cloning!
						else if(pod.growclone(active_br))
							set_temp("Initiating growing cycle...", "good")
							menu = 1
						else
							set_temp("Initiating growing cycle... Error: Post-initialisation failed. Growing cycle aborted.", "bad")
							return

			//The body record is broken somehow.
			else
				set_temp("Error: Data corruption.", "bad")
				return

		if("sleeve")
			if(istype(active_mr))
				if(!sleevers.len)
					set_temp("Error: No sleevers detected.", "bad")
				else
					var/mode = text2num(params["mode"])
					var/override
					var/obj/machinery/transhuman/resleever/sleever = selected_sleever
					if(!istype(sleever))
						set_temp("Error: No resleeving pod selected.", "bad")
						return

					switch(mode)
						if(1) //Body resleeving
							//No body to sleeve into.
							if(!sleever.occupant)
								set_temp("Error: Resleeving pod is not occupied.", "bad")
								return

							//OOC body lock thing.
							if(sleever.occupant.resleeve_lock && active_mr.ckey != sleever.occupant.resleeve_lock)
								set_temp("Error: Mind incompatible with body.", "bad")
								return

							var/list/subtargets = list()
							for(var/mob/living/carbon/human/H in sleever.occupant)
								if(H.resleeve_lock && active_mr.ckey != H.resleeve_lock)
									continue
								subtargets += H
							if(subtargets.len)
								var/oc_sanity = sleever.occupant
								override = input(usr,"Multiple bodies detected. Select target for resleeving of [active_mr.mindname] manually. Sleeving of primary body is unsafe with sub-contents, and is not listed.", "Resleeving Target") as null|anything in subtargets
								if(!override || oc_sanity != sleever.occupant || !(override in sleever.occupant))
									set_temp("Error: Target selection aborted.", "bad")
									return

						if(2) //Card resleeving
							if(sleever.sleevecards <= 0)
								set_temp("Error: No available cards in resleever.", "bad")
								return

					//Body to sleeve into, but mind is in another living body.
					if(active_mr.mind_ref.current && active_mr.mind_ref.current.stat < DEAD) //Mind is in a body already that's alive
						var/answer = alert(active_mr.mind_ref.current,"Someone is attempting to restore a backup of your mind. Do you want to abandon this body, and move there? You MAY suffer memory loss! (Same rules as CMD apply)","Resleeving","No","Yes")

						//They declined to be moved.
						if(answer == "No")
							set_temp("Initiating resleeving... Error: Post-initialisation failed. Resleeving cycle aborted.", "bad")
							menu = MENU_MAIN
							return TRUE

					//They were dead, or otherwise available.
					if(!temp)
						sleever.putmind(active_mr,mode,override)
						set_temp("Initiating resleeving...")
						menu = 1
						return
		if("refresh")
			SStgui.update_uis(src)
		if("selectpod")
			var/ref = params["ref"]
			if(!length(ref))
				return
			var/obj/machinery/clonepod/selected = locate(ref)
			if(istype(selected) && (selected in pods))
				selected_pod = selected
		if("selectprinter")
			var/ref = params["ref"]
			if(!length(ref))
				return
			var/obj/machinery/transhuman/synthprinter/selected = locate(ref)
			if(istype(selected) && (selected in spods))
				selected_printer = selected
		if("selectsleever")
			var/ref = params["ref"]
			if(!length(ref))
				return
			var/obj/machinery/transhuman/resleever/selected = locate(ref)
			if(istype(selected) && (selected in sleevers))
				selected_sleever = selected
		if("menu")
			menu = clamp(text2num(params["num"]), MENU_MAIN, MENU_MIND)
		if("cleartemp")
			temp = null
		else
			return FALSE

// In here because only relevant to computer
/obj/item/cmo_disk_holder
	name = "cmo emergency packet"
	desc = "A small paper packet with printing on one side. \"Tear open in case of Code Delta or Emergency Evacuation ONLY. Use in any other case is UNLAWFUL.\""
	catalogue_data = list(/datum/category_item/catalogue/technology/resleeving)
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "cmoemergency"
	item_state = "card-id"

/obj/item/cmo_disk_holder/attack_self(var/mob/attacker)
	playsound(src, 'sound/items/poster_ripped.ogg', 50)
	to_chat(attacker, "<span class='warning'>You tear open \the [name].</span>")
	attacker.unEquip(src)
	var/obj/item/disk/transcore/newdisk = new(get_turf(src))
	attacker.put_in_any_hand_if_possible(newdisk)
	qdel(src)

/obj/item/disk/transcore
	name = "TransCore Dump Disk"
	desc = "It has a small label. \n\
	\"1.INSERT DISK INTO RESLEEVING CONSOLE\n\
	2. BEGIN CORE DUMP PROCEDURE\n\
	3. ENSURE DISK SAFETY WHEN EJECTED\""
	catalogue_data = list(/datum/category_item/catalogue/technology/resleeving)
	icon = 'icons/obj/cloning.dmi'
	icon_state = "harddisk"
	item_state = "card-id"
	w_class = ITEMSIZE_SMALL
	var/list/datum/transhuman/mind_record/stored = list()

/**
  * Sets a temporary message to display to the user
  *
  * Arguments:
  * * text - Text to display, null/empty to clear the message from the UI
  * * style - The style of the message: (color name), info, success, warning, danger
  */
/obj/machinery/computer/transhuman/resleeving/proc/set_temp(text = "", style = "info", update_now = FALSE)
	temp = list(text = text, style = style)
	if(update_now)
		SStgui.update_uis(src)

#undef MENU_MAIN
#undef MENU_BODY
#undef MENU_MIND
