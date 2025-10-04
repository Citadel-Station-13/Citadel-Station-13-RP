/client/proc/Debug2()
	set category = VERB_CATEGORY_DEBUG
	set name = "Debug-Game"
	set desc = "Toggles game debugging."

	if(!check_rights(R_DEBUG))	return

	GLOB.Debug2 = !GLOB.Debug2
	var/message = "toggled debugging [(GLOB.Debug2 ? "ON" : "OFF")]"
	message_admins("[key_name_admin(src)] [message].")
	log_admin("[key_name(src)] [message].")

	feedback_add_details("admin_verb","DG2") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/Cell()
	set category = "Debug"
	set name = "Cell"
	if(!mob)
		return
	var/turf/T = mob.loc

	if (!( istype(T, /turf) ))
		return

	var/datum/gas_mixture/env = T.return_air()

	var/t = "<font color=#4F49AF>Coordinates: [T.x],[T.y],[T.z]\n</font>"
	t += "<font color='red'>Temperature: [env.temperature]\n</font>"
	t += "<font color='red'>Pressure: [env.return_pressure()]kPa\n</font>"
	for(var/g in env.gas)
		t += "<font color=#4F49AF>[g]: [env.gas[g]] / [env.gas[g] * R_IDEAL_GAS_EQUATION * env.temperature / env.volume]kPa\n</font>"

	usr.show_message(t, 1)
	feedback_add_details("admin_verb","ASL") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_robotize(var/mob/M in GLOB.mob_list)
	set category = "Fun"
	set name = "Make Robot"

	if(istype(M, /mob/living/carbon/human))
		log_admin("[key_name(src)] has robotized [M.key].")
		spawn(10)
			M:Robotize()

	else
		alert("Invalid mob")

/client/proc/cmd_admin_animalize(var/mob/M in GLOB.mob_list)
	set category = "Fun"
	set name = "Make Simple Animal"

	if(!M)
		alert("That mob doesn't seem to exist, close the panel and try again.")
		return

	if(istype(M, /mob/new_player))
		alert("The mob must not be a new_player.")
		return

	log_admin("[key_name(src)] has animalized [M.key].")
	spawn(10)
		M.Animalize()


/client/proc/makepAI(var/turf/T in GLOB.mob_list)
	set category = "Fun"
	set name = "Make pAI"
	set desc = "Specify a location to spawn a pAI device, then specify a key to play that pAI"

	var/list/available = list()
	for(var/mob/C in GLOB.mob_list)
		if(C.key)
			available.Add(C)
	var/mob/choice = input("Choose a player to play the pAI", "Spawn pAI") in available
	if(!choice)
		return 0
	if(!istype(choice, /mob/observer/dead))
		var/confirm = input("[choice.key] isn't ghosting right now. Are you sure you want to yank them out of them out of their body and place them in this pAI?", "Spawn pAI Confirmation", "No") in list("Yes", "No")
		if(confirm != "Yes")
			return 0
	var/obj/item/paicard/card = new(T)
	var/mob/living/silicon/pai/pai = new(card)
	pai.name = sanitizeSafe(input(choice, "Enter your pAI name:", "pAI Name", "Personal AI") as text)
	pai.real_name = pai.name
	choice.transfer_client_to(pai)
	card.setPersonality(pai)
	for(var/datum/paiCandidate/candidate in paiController.pai_candidates)
		if(candidate.key == choice.key)
			paiController.pai_candidates.Remove(candidate)
	feedback_add_details("admin_verb","MPAI") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_alienize(var/mob/M in GLOB.mob_list)
	set category = "Fun"
	set name = "Make Alien"

	if(ishuman(M))
		log_admin("[key_name(src)] has alienized [M.key].")
		spawn(10)
			M:Alienize()
			feedback_add_details("admin_verb","MKAL") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
		log_admin("[key_name(usr)] made [key_name(M)] into an alien.")
		message_admins("<span class='notice'>[key_name_admin(usr)] made [key_name(M)] into an alien.</span>", 1)
	else
		alert("Invalid mob")

/client/proc/poll_type_to_del(search_string)
	var/list/types = get_fancy_list_of_atom_types()
	if (!isnull(search_string) && search_string != "")
		types = filter_fancy_list(types, search_string)

	if(!length(types))
		return

	var/key = input(usr, "Choose an object to delete.", "Delete:") as null|anything in sortList(types)

	if(!key)
		return
	return types[key]

/client/proc/cmd_del_all(object as text)
	set category = VERB_CATEGORY_DEBUG
	set name = "Del-All"
	set desc = "Delete all datums with the specified type."

	if(!check_rights(R_DEBUG|R_SPAWN))	return

	var/type_to_del = src.poll_type_to_del(object)
	if(!type_to_del)
		return

	var/counter = 0
	for(var/atom/O in world)
		if(istype(O, type_to_del))
			counter++
			qdel(O)
		CHECK_TICK
	log_admin("[key_name(src)] has deleted all ([counter]) instances of [type_to_del].")
	message_admins("[key_name_admin(src)] has deleted all ([counter]) instances of [type_to_del].")

/client/proc/cmd_del_all_force(object as text)
	set category = VERB_CATEGORY_DEBUG
	set name = "Force-Del-All"
	set desc = "Forcibly delete all datums with the specified type."

	if(!check_rights(R_DEBUG|R_SPAWN))	return

	var/type_to_del = src.poll_type_to_del(object)
	if(!type_to_del)
		return

	var/counter = 0
	for(var/atom/O in world)
		if(istype(O, type_to_del))
			counter++
			qdel(O, force = TRUE)
		CHECK_TICK
	log_admin("[key_name(src)] has force-deleted all ([counter]) instances of [type_to_del].")
	message_admins("[key_name_admin(src)] has force-deleted all ([counter]) instances of [type_to_del].")

/client/proc/cmd_del_all_hard(object as text)
	set category = VERB_CATEGORY_DEBUG
	set name = "Hard-Del-All"
	set desc = "Hard delete all datums with the specified type."

	if(!check_rights(R_DEBUG|R_SPAWN))	return

	var/type_to_del = src.poll_type_to_del(object)
	if(!type_to_del)
		return

	var/choice = alert(src, "ARE YOU SURE that you want to hard delete this type? It will cause MASSIVE lag.", "Hoooo lad what happen?", "Yes", "No")
	if(choice != "Yes")
		return

	choice = alert(src, "Do you want to pre qdelete the atom? This will speed things up significantly, but may break depending on your level of fuckup.", "How do you even get it that bad", "Yes", "No")
	var/should_pre_qdel = TRUE
	if(choice == "No")
		should_pre_qdel = FALSE

	choice = alert(src, "Ok one last thing, do you want to yield to the game? or do it all at once. These are hard deletes remember.", "Jesus christ man", "Yield", "Ignore the server")
	var/should_check_tick = TRUE
	if(choice == "Ignore the server")
		should_check_tick = FALSE

	var/counter = 0
	if(should_check_tick)
		for(var/atom/O in world)
			if(istype(O, type_to_del))
				counter++
				if(should_pre_qdel)
					qdel(O)
				del(O)
			CHECK_TICK
	else
		for(var/atom/O in world)
			if(istype(O, type_to_del))
				counter++
				if(should_pre_qdel)
					qdel(O)
				del(O)

	log_admin("[key_name(src)] has hard deleted all ([counter]) instances of [type_to_del].")
	message_admins("[key_name_admin(src)] has hard deleted all ([counter]) instances of [type_to_del].")

/client/proc/cmd_debug_make_powernets()
	set category = VERB_CATEGORY_DEBUG
	set name = "Make Powernets"
	set desc = "Regenerates all powernets for all cables."

	if(!check_rights(R_DEBUG|R_SERVER))	return

	SSmachines.makepowernets()
	log_admin("[key_name(src)] has remade the powernet. SSmachines.makepowernets() called.")
	message_admins("[key_name_admin(src)] has remade the powernets. SSmachines.makepowernets() called.", 0)
	feedback_add_details("admin_verb","MPWN") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_grantfullaccess(var/mob/M in GLOB.mob_list)
	set category = VERB_CATEGORY_DEBUG
	set name = "Grant Full Access"
	set desc = "Grant full access to a mob."

	if(!check_rights(R_DEBUG))	return

	if(!SSticker.HasRoundStarted())
		tgui_alert(src, "Wait until the game starts")
		return
	if (ishuman(M))
		var/mob/living/carbon/human/H = M

		if (H.wear_id)
			var/obj/item/card/id/id = H.wear_id
			if(istype(H.wear_id, /obj/item/pda))
				var/obj/item/pda/pda = H.wear_id
				id = pda.id
			id.icon_state = "gold"
			id.access = get_all_accesses().Copy()
		else
			var/obj/item/card/id/id = new/obj/item/card/id(M);
			id.icon_state = "gold"
			id.access = get_all_accesses().Copy()
			id.registered_name = H.real_name
			id.assignment = "Facility Director"
			id.name = "[id.registered_name]'s ID Card ([id.assignment])"
			H.equip_to_slot_or_del(id, SLOT_ID_WORN_ID)
			H.update_inv_wear_id()
	else
		alert("Invalid mob")
	feedback_add_details("admin_verb","GFA") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	log_admin("[key_name(src)] has granted [M.key] full access.")
	message_admins(SPAN_ADMINNOTICE("[key_name_admin(usr)] has granted [M.key] full access."))

/client/proc/cmd_debug_mob_lists()
	set category = VERB_CATEGORY_DEBUG
	set name = "Debug Mob Lists"
	set desc = "For when you just gotta know"

	if(!check_rights(R_DEBUG))	return

	var/chosen_list = input("Which list?") in list("Players","Admins","Mobs","Living Mobs","Dead Mobs","Clients")
	if(isnull(chosen_list))
		return
	switch(chosen_list)
		if("Players")
			to_chat(usr, jointext(GLOB.player_list,","), confidential = TRUE)
		if("Admins")
			to_chat(usr, jointext(GLOB.admins,","), confidential = TRUE)
		if("Mobs")
			to_chat(usr, jointext(GLOB.mob_list,","), confidential = TRUE)
		if("Living Mobs")
			to_chat(usr, jointext(living_mob_list,","), confidential = TRUE)
		if("Dead Mobs")
			to_chat(usr, jointext(dead_mob_list,","), confidential = TRUE)
		if("Clients")
			to_chat(usr, jointext(GLOB.clients,","), confidential = TRUE)

/client/proc/cmd_display_del_log()
	set category = VERB_CATEGORY_DEBUG
	set name = "Display del() Log"
	set desc = "Display del's log of everything that's passed through it."

	if(!check_rights(R_DEBUG))	return

	var/list/dellog = list("<B>List of things that have gone through qdel this round</B><BR><BR><ol>")
	tim_sort(SSgarbage.items, cmp=GLOBAL_PROC_REF(cmp_qdel_item_time), associative = TRUE)
	for(var/path in SSgarbage.items)
		var/datum/qdel_item/I = SSgarbage.items[path]
		dellog += "<li><u>[path]</u><ul>"
		if (I.failures)
			dellog += "<li>Failures: [I.failures]</li>"
		dellog += "<li>qdel() Count: [I.qdels]</li>"
		dellog += "<li>Destroy() Cost: [I.destroy_time]ms</li>"
		if (I.hard_deletes)
			dellog += "<li>Total Hard Deletes [I.hard_deletes]</li>"
			dellog += "<li>Time Spent Hard Deleting: [I.hard_delete_time]ms</li>"
		if (I.slept_destroy)
			dellog += "<li>Sleeps: [I.slept_destroy]</li>"
		if (I.no_respect_force)
			dellog += "<li>Ignored force: [I.no_respect_force]</li>"
		if (I.no_hint)
			dellog += "<li>No hint: [I.no_hint]</li>"
		dellog += "</ul></li>"

	dellog += "</ol>"

	var/datum/browser/browser = new(usr, "dellog", "Del Log", 200, 400)
	browser.set_content(dellog.Join())
	browser.open()

/client/proc/cmd_display_overlay_log()
	set category = VERB_CATEGORY_DEBUG
	set name = "Display overlay Log"
	set desc = "Display SSoverlays log of everything that's passed through it."

	if(!check_rights(R_DEBUG)) return

	render_stats(SSoverlays.stats, src)

/client/proc/cmd_display_init_log()
	set category = VERB_CATEGORY_DEBUG
	set name = "Display Initialize() Log"
	set desc = "Displays a list of things that didn't handle Initialize() properly"

	if(!check_rights(R_DEBUG)) return

	var/datum/browser/browser = new(usr, "initlog", "Initialize Log", 500, 500)
	browser.set_content(replacetext(SSatoms.InitLog(), "\n", "<br>"))
	browser.open()

/datum/admins/proc/view_runtimes()
	set category = VERB_CATEGORY_DEBUG
	set name = "View Runtimes"
	set desc = "Open the Runtime Viewer"

	if(!check_rights(R_DEBUG)) return

	GLOB.error_cache.show_to(usr)

	// The runtime viewer has the potential to crash the server if there's a LOT of runtimes
	// this has happened before, multiple times, so we'll just leave an alert on it
	if(GLOB.total_runtimes >= 50000) // arbitrary number, I don't know when exactly it happens
		var/warning = "There are a lot of runtimes, clicking any button (especially \"linear\") can have the potential to lag or crash the server"
		if(GLOB.total_runtimes >= 100000)
			warning = "There are a TON of runtimes, clicking any button (especially \"linear\") WILL LIKELY crash the server"
		// Not using TGUI alert, because it's view runtimes, stuff is probably broken
		alert(src, "[warning]. Proceed with caution. If you really need to see the runtimes, download the runtime log and view it in a text editor.", "HEED THIS WARNING CAREFULLY MORTAL")

/client/proc/check_timer_sources()
	set category = VERB_CATEGORY_DEBUG
	set name = "Check Timer Sources"
	set desc = "Checks the sources of running timers."

	if(!check_rights(R_DEBUG)) return

	var/bucket_list_output = generate_timer_source_output(SStimer.bucket_list)
	var/second_queue = generate_timer_source_output(SStimer.second_queue)

	var/datum/browser/browser = new(src, "check_timer_sources", "Timer Sources", 700, 700)
	browser.set_content({"
		<h3>bucket_list</h3>
		[bucket_list_output]

		<h3>second_queue</h3>
		[second_queue]
	"})
	browser.open()

/client/proc/toggle_browser_inspect()
	set category = VERB_CATEGORY_DEBUG
	set name = "Toggle Browser Inspect"
	set desc = "Toggle browser debugging via inspect"

	if(!check_rights(R_DEBUG)) return

	if(src.byond_version < 516)
		to_chat(src, SPAN_WARNING("Browser Inspection is not supported in this version of BYOND, please update to 516 or later."))
		return

	var/browser_options = winget(src, null, "browser-options")

	if(findtext(browser_options, "devtools"))
		winset(src, null, list("browser-options" = "-devtools"))
		to_chat(src, SPAN_NOTICE("You can no longer right click to use inspect on browsers."))
	else
		winset(src, null, list("browser-options" = "+devtools"))
		to_chat(src, SPAN_NOTICE("You can now right click to use inspect on browsers."))


/client/proc/cmd_admin_clear_mobs()
	set category = "Admin"
	set name = "Clear Mobs"

	var/range = input(usr, "Choose a range in tiles FROM your location", "If uncertain, enter 25 or below.") as num
	if(range >= 50) // ridiculously high
		alert("Please enter a valid range below 50.")
		return
	var/list/victims = list()
	for(var/mob/C in view(range, src)) // get all mobs in the range from us we specified
		victims += C
	var/hsbitem = input(usr, "Choose a mob type to clear.", "Delete ALL of this type:") as null|anything in typesof(victims, /mob)
	var/friendlyname = type2top(hsbitem)
	var/warning = alert(usr, "Are you ABSOLUTELY CERTAIN you wish to delete EVERY [friendlyname] in [range] tiles?", "Warning", "Yes", "Cancel") // safety
	if (warning == "Yes")
		if(hsbitem)
			for(var/mob/O in view(range, src))
				if(istype(O, hsbitem))
					qdel(O)
			log_admin("[key_name(src)] has deleted all instances of [hsbitem] in a range of [range] tiles.")
			message_admins("[key_name_admin(src)] has deleted all instances of [hsbitem] in a range of [range] tiles.", 0)
	feedback_add_details("admin_verb","CLRM") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_debug_tog_aliens()
	set category = "Server"
	set name = "Toggle Aliens"

	config_legacy.aliens_allowed = !config_legacy.aliens_allowed
	log_admin("[key_name(src)] has turned aliens [config_legacy.aliens_allowed ? "on" : "off"].")
	message_admins("[key_name_admin(src)] has turned aliens [config_legacy.aliens_allowed ? "on" : "off"].", 0)
	feedback_add_details("admin_verb","TAL") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_assume_direct_control(var/mob/M in GLOB.mob_list)
	set category = "Admin"
	set name = "Assume direct control"
	set desc = "Direct intervention"

	if(!check_rights(R_DEBUG|R_ADMIN))	return
	if(M.ckey)
		if(alert("This mob is being controlled by [M.ckey]. Are you sure you wish to assume control of it? [M.ckey] will be made a ghost.",,"Yes","No") != "Yes")
			return
		else
			var/mob/observer/dead/ghost = new/mob/observer/dead(M,1)
			M.transfer_client_to(ghost)
	message_admins("<font color=#4F49AF>[key_name_admin(usr)] assumed direct control of [M].</font>", 1)
	log_admin("[key_name(usr)] assumed direct control of [M].")
	var/mob/adminmob = src.mob
	transfer_to(M)
	if( isobserver(adminmob) )
		qdel(adminmob)
	feedback_add_details("admin_verb","ADC") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/take_picture(atom/A in world)
	set name = "Save PNG"
	set category = "Debug"
	set desc = "Opens a dialog to save a PNG of any object in the game."

	if(!check_rights(R_DEBUG))
		return

	download_icon(A)

/client/proc/cmd_admin_areatest()
	set category = "Mapping"
	set name = "Test areas"

	var/list/areas_all = list()
	var/list/areas_with_APC = list()
	var/list/areas_with_air_alarm = list()
	var/list/areas_with_RC = list()
	var/list/areas_with_light = list()
	var/list/areas_with_LS = list()
	var/list/areas_with_intercom = list()
	var/list/areas_with_camera = list()

	for(var/area/A in GLOB.sortedAreas)
		if(!(A.type in areas_all))
			areas_all.Add(A.type)

	for(var/obj/machinery/power/apc/apc in GLOB.apcs)
		var/area/A = get_area(apc)
		if(A && !(A.type in areas_with_APC))
			areas_with_APC.Add(A.type)

	for(var/obj/machinery/air_alarm/alarm in GLOB.machines)
		var/area/A = get_area(alarm)
		if(A && !(A.type in areas_with_air_alarm))
			areas_with_air_alarm.Add(A.type)

	for(var/obj/machinery/requests_console/RC in GLOB.machines)
		var/area/A = get_area(RC)
		if(A && !(A.type in areas_with_RC))
			areas_with_RC.Add(A.type)

	for(var/obj/machinery/light/L in GLOB.machines)
		var/area/A = get_area(L)
		if(A && !(A.type in areas_with_light))
			areas_with_light.Add(A.type)

	for(var/obj/machinery/light_switch/LS in GLOB.machines)
		var/area/A = get_area(LS)
		if(A && !(A.type in areas_with_LS))
			areas_with_LS.Add(A.type)

	for(var/obj/item/radio/intercom/I in GLOB.machines)
		var/area/A = get_area(I)
		if(A && !(A.type in areas_with_intercom))
			areas_with_intercom.Add(A.type)

	for(var/obj/machinery/camera/C in GLOB.machines)
		var/area/A = get_area(C)
		if(A && !(A.type in areas_with_camera))
			areas_with_camera.Add(A.type)

	var/list/areas_without_APC = areas_all - areas_with_APC
	var/list/areas_without_air_alarm = areas_all - areas_with_air_alarm
	var/list/areas_without_RC = areas_all - areas_with_RC
	var/list/areas_without_light = areas_all - areas_with_light
	var/list/areas_without_LS = areas_all - areas_with_LS
	var/list/areas_without_intercom = areas_all - areas_with_intercom
	var/list/areas_without_camera = areas_all - areas_with_camera

	to_chat(world, "<b>AREAS WITHOUT AN APC:</b>")
	for(var/areatype in areas_without_APC)
		to_chat(world, "* [areatype]")

	to_chat(world, "<b>AREAS WITHOUT AN AIR ALARM:</b>")
	for(var/areatype in areas_without_air_alarm)
		to_chat(world, "* [areatype]")

	to_chat(world, "<b>AREAS WITHOUT A REQUEST CONSOLE:</b>")
	for(var/areatype in areas_without_RC)
		to_chat(world, "* [areatype]")

	to_chat(world, "<b>AREAS WITHOUT ANY LIGHTS:</b>")
	for(var/areatype in areas_without_light)
		to_chat(world, "* [areatype]")

	to_chat(world, "<b>AREAS WITHOUT A LIGHT SWITCH:</b>")
	for(var/areatype in areas_without_LS)
		to_chat(world, "* [areatype]")

	to_chat(world, "<b>AREAS WITHOUT ANY INTERCOMS:</b>")
	for(var/areatype in areas_without_intercom)
		to_chat(world, "* [areatype]")

	to_chat(world, "<b>AREAS WITHOUT ANY CAMERAS:</b>")
	for(var/areatype in areas_without_camera)
		to_chat(world, "* [areatype]")

/datum/admins/proc/cmd_admin_dress(input in getmobs())
	set category = "Fun"
	set name = "Select equipment"

	if(!check_rights(R_FUN))
		return

	var/target = getmobs()[input]
	if(!target)
		return

	if(!ishuman(target))
		return

	var/mob/living/carbon/human/H = target

	var/datum/outfit/outfit = input("Select outfit.", "Select equipment.") as null|anything in get_all_outfits()
	if(!outfit)
		return

	feedback_add_details("admin_verb","SEQ")
	dressup_human(H, outfit, 1)

/proc/dressup_human(var/mob/living/carbon/human/H, var/datum/outfit/outfit)
	if(!H || !outfit)
		return
	if(outfit.undress)
		H.delete_inventory()
	outfit.equip(H)
	log_and_message_admins("changed the equipment of [key_name(H)] to [outfit.name].")

/client/proc/startSinglo()

	set category = "Debug"
	set name = "Start Singularity"
	set desc = "Sets up the singularity and all machines to get power flowing through the station"

	if(alert("Are you sure? This will start up the engine. Should only be used during debug!",,"Yes","No") != "Yes")
		return

	for(var/obj/machinery/power/emitter/E in GLOB.machines)
		if(istype(get_area(E), /area/space))
			E.anchored = TRUE
			E.state = 2
			E.connect_to_network()
			E.active = TRUE
	for(var/obj/machinery/field_generator/F in GLOB.machines)
		if(istype(get_area(F), /area/space))
			F.Varedit_start = 1
	for(var/obj/machinery/power/grounding_rod/GR in GLOB.machines)
		GR.anchored = TRUE
		GR.update_icon()
	for(var/obj/machinery/power/tesla_coil/TC in GLOB.machines)
		TC.anchored = TRUE
		TC.update_icon()
	for(var/obj/structure/particle_accelerator/PA in GLOB.machines)
		PA.anchored = TRUE
		PA.construction_state = 3
		PA.update_icon()
	for(var/obj/machinery/particle_accelerator/PA in GLOB.machines)
		PA.anchored = TRUE
		PA.construction_state = 3
		PA.update_icon()

	for(var/obj/machinery/power/rad_collector/Rad in GLOB.machines)
		if(Rad.anchored)
			if(!Rad.P)
				var/obj/item/tank/phoron/Phoron = new/obj/item/tank/phoron(Rad)
				/// supercooled so we don't just maxcap the engine lol
				Phoron.air_contents.adjust_gas_temp(GAS_ID_PHORON, 350, 25)
				Phoron.forceMove(Rad)
				Rad.P = Phoron

			if(!Rad.active)
				Rad.toggle_power()

/client/proc/setup_supermatter_engine()
	set category = "Debug"
	set name = "Setup supermatter"
	set desc = "Sets up the supermatter engine"

	if(!check_rights(R_DEBUG|R_ADMIN))      return

	var/response = alert("Are you sure? This will start up the engine. Should only be used during debug!",,"Setup Completely","Setup except coolant","No")

	if(response == "No")
		return

	var/found_the_pump = 0
	var/obj/machinery/power/supermatter/SM

	for(var/obj/machinery/M in GLOB.machines)
		if(!M)
			continue
		if(!M.loc)
			continue
		if(!M.loc.loc)
			continue

		if(istype(M.loc.loc,/area/engineering/engine_room))
			if(istype(M,/obj/machinery/power/rad_collector))
				var/obj/machinery/power/rad_collector/Rad = M
				Rad.anchored = 1
				Rad.connect_to_network()

				var/obj/item/tank/phoron/Phoron = new/obj/item/tank/phoron(Rad)

				Phoron.air_contents.gas[GAS_ID_PHORON] = 29.1154	//This is a full tank if you filled it from a canister
				Phoron.air_contents.update_values()
				Rad.P = Phoron

				Phoron.loc = Rad

				if(!Rad.active)
					Rad.toggle_power()
				Rad.update_icon()

			else if(istype(M,/obj/machinery/atmospherics/component/binary/pump))	//Turning on every pump.
				var/obj/machinery/atmospherics/component/binary/pump/Pump = M
				if(Pump.name == "Engine Feed" && response == "Setup Completely")
					found_the_pump = 1
					Pump.air2.gas[GAS_ID_NITROGEN] = 3750	//The contents of 2 canisters.
					Pump.air2.temperature = 50
					Pump.air2.update_values()
				Pump.update_use_power(USE_POWER_IDLE)
				Pump.target_pressure = 4500
				Pump.update_icon()

			else if(istype(M,/obj/machinery/power/supermatter))
				SM = M
				spawn(50)
					SM.power = 320

			else if(istype(M,/obj/machinery/power/smes))	//This is the SMES inside the engine room.  We don't need much power.
				var/obj/machinery/power/smes/SMES = M
				SMES.input_attempt = 1
				SMES.input_level = 200000
				SMES.output_level = 75000

		else if(istype(M.loc.loc,/area/engineering/engine_smes))	//Set every SMES to charge and spit out 300,000 power between the 4 of them.
			if(istype(M,/obj/machinery/power/smes))
				var/obj/machinery/power/smes/SMES = M
				SMES.input_attempt = 1
				SMES.input_level = 200000
				SMES.output_level = 75000

	if(!found_the_pump && response == "Setup Completely")
		to_chat(src, "<font color='red'>Unable to locate air supply to fill up with coolant, adding some coolant around the supermatter</font>")
		var/turf/simulated/T = SM.loc
		T.zone.air.gas[GAS_ID_NITROGEN] += 450
		T.zone.air.temperature = 50
		T.zone.air.update_values()


	log_admin("[key_name(usr)] setup the supermatter engine [response == "Setup except coolant" ? "without coolant" : ""]")
	message_admins("<font color=#4F49AF>[key_name_admin(usr)] setup the supermatter engine  [response == "Setup except coolant" ? "without coolant": ""]</font>", 1)
	return

// DNA2 - Admin Hax
/client/proc/cmd_admin_toggle_block(var/mob/M,var/block)
	if(istype(M, /mob/living/carbon))
		M.dna.SetSEState(block,!M.dna.GetSEState(block))
		domutcheck(M,null,MUTCHK_FORCED)
		M.update_mutations()
		var/state="[M.dna.GetSEState(block)?"on":"off"]"
		var/blockname=assigned_blocks[block]
		message_admins("[key_name_admin(src)] has toggled [M.key]'s [blockname] block [state]!")
		log_admin("[key_name(src)] has toggled [M.key]'s [blockname] block [state]!")
	else
		alert("Invalid mob")

/datum/admins/proc/change_weather()
	set category = "Debug"
	set name = "Change Weather"
	set desc = "Changes the current weather."

	if(!check_rights(R_DEBUG))
		return

	var/datum/planet/planet = input(usr, "Which planet do you want to modify the weather on?", "Change Weather") in SSplanets.planets
	var/datum/weather/new_weather = input(usr, "What weather do you want to change to?", "Change Weather") as null|anything in planet.weather_holder.allowed_weather_types
	if(new_weather)
		planet.weather_holder.change_weather(new_weather)
		planet.weather_holder.rebuild_forecast()
		var/log = "[key_name(src)] changed [planet.name]'s weather to [new_weather]."
		message_admins(log)
		log_admin(log)

/datum/admins/proc/change_time()
	set category = "Debug"
	set name = "Change Planet Time"
	set desc = "Changes the time of a planet."

	if(!check_rights(R_DEBUG))
		return

	var/datum/planet/planet = input(usr, "Which planet do you want to modify time on?", "Change Time") in SSplanets.planets

	var/datum/time/current_time_datum = planet.current_time
	var/new_hour = input(usr, "What hour do you want to change to?", "Change Time", text2num(current_time_datum.show_time("hh"))) as null|num
	if(!isnull(new_hour))
		var/new_minute = input(usr, "What minute do you want to change to?", "Change Time", text2num(current_time_datum.show_time("mm")) ) as null|num
		if(!isnull(new_minute))
			var/type_needed = current_time_datum.type
			var/datum/time/new_time = new type_needed()
			new_time = new_time.add_hours(new_hour)
			new_time = new_time.add_minutes(new_minute)
			planet.current_time = new_time
			spawn(1)
				planet.update_sun()

			var/log = "[key_name(src)] changed [planet.name]'s time to [planet.current_time.show_time("hh:mm")]."
			message_admins(log)
			log_admin(log)

/datum/admins/proc/quick_nif()
	set category = "Fun"
	set name = "Quick NIF"
	set desc = "Spawns a NIF into someone in quick-implant mode."

	var/input_NIF

	if(!check_rights(R_ADMIN))
		return

	var/mob/living/carbon/human/H = input("Pick a mob with a player","Quick NIF") as null|anything in GLOB.player_list

	if(!H)
		return

	if(!istype(H))
		to_chat(usr,"<span class='warning'>That mob type ([H.type]) doesn't support NIFs, sorry.</span>")
		return

	if(!H.get_organ(BP_HEAD))
		to_chat(usr,"<span class='warning'>Target is unsuitable.</span>")
		return

	if(H.nif)
		to_chat(usr,"<span class='warning'>Target already has a NIF.</span>")
		return

	//if the admins want to adminbus a prommie with a full veymed, let them. screw the system. NIFs aren't in the plans to last long anyways. :^)
	var/list/NIF_types = typesof(/obj/item/nif)
	var/list/NIFs = list()

	for(var/NIF_type in NIF_types)
		var/obj/item/nif/S = NIF_type
		NIFs[capitalize(initial(S.name))] = NIF_type

	var/list/show_NIFs = sortList(NIFs) // the list that will be shown to the user to pick from

	input_NIF = input("Pick the NIF type","Quick NIF") in show_NIFs
	var/chosen_NIF = NIFs[capitalize(input_NIF)]

	var/obj/item/nif/created
	if(chosen_NIF)
		created = new chosen_NIF(H)
	else
		created = new /obj/item/nif(H)
	created.install_done = world.time

	log_and_message_admins("[key_name(src)] Quick NIF'd [H.real_name] with a [input_NIF].")
	feedback_add_details("admin_verb","QNIF") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/proc/generate_timer_source_output(list/datum/timedevent/events)
	var/list/per_source = list()

	// Collate all events and figure out what sources are creating the most
	for (var/_event in events)
		if (!_event)
			continue
		var/datum/timedevent/event = _event

		do
			if (event.source)
				if (per_source[event.source] == null)
					per_source[event.source] = 1
				else
					per_source[event.source] += 1
			event = event.next
		while (event && event != _event)

	// Now, sort them in order
	var/list/sorted = list()
	for (var/source in per_source)
		sorted += list(list("source" = source, "count" = per_source[source]))
	tim_sort(sorted, GLOBAL_PROC_REF(cmp_timer_data))

	// Now that everything is sorted, compile them into an HTML output
	var/output = "<table border='1'>"

	for (var/_timer_data in sorted)
		var/list/timer_data = _timer_data
		output += {"<tr>
			<td><b>[timer_data["source"]]</b></td>
			<td>[timer_data["count"]]</td>
		</tr>"}

	output += "</table>"

	return output

/proc/cmp_timer_data(list/a, list/b)
	return b["count"] - a["count"]
