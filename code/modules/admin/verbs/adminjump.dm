//Replace the stuff below the comment block with the stuff in it sometime soon.
/*
/client/proc/jumptoarea(area/A in GLOB.sortedAreas)
	set name = "Jump to Area"
	set desc = "Area to jump to"
	set category = "Admin"
	if(!src.holder)
		to_chat(src, "Only administrators may use this command.")
		return

	if(!A)
		return

	var/list/turfs = list()
	for(var/turf/T in A)
		if(T.density)
			continue
		turfs.Add(T)

	var/turf/T = safepick(turfs)
	if(!T)
		to_chat(src, "Nowhere to jump to!")
		return
	usr.forceMove(T)
	log_admin("[key_name(usr)] jumped to [AREACOORD(A)]")
	message_admins("[key_name_admin(usr)] jumped to [AREACOORD(A)]")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Jump To Area") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/jumptoturf(turf/T in world)
	set name = "Jump to Turf"
	set category = "Admin"
	if(!src.holder)
		to_chat(src, "Only administrators may use this command.")
		return

	log_admin("[key_name(usr)] jumped to [AREACOORD(T)]")
	message_admins("[key_name_admin(usr)] jumped to [AREACOORD(T)]")
	usr.forceMove(T)
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Jump To Turf") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/client/proc/jumptomob(mob/M in GLOB.mob_list)
	set category = "Admin"
	set name = "Jump to Mob"

	if(!src.holder)
		to_chat(src, "Only administrators may use this command.")
		return

	log_admin("[key_name(usr)] jumped to [key_name(M)]")
	message_admins("[key_name_admin(usr)] jumped to [ADMIN_LOOKUPFLW(M)] at [AREACOORD(M)]")
	if(src.mob)
		var/mob/A = src.mob
		var/turf/T = get_turf(M)
		if(T && isturf(T))
			SSblackbox.record_feedback("tally", "admin_verb", 1, "Jump To Mob") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
			A.forceMove(M.loc)
		else
			to_chat(A, "This mob is not located in the game world.")

/client/proc/jumptocoord(tx as num, ty as num, tz as num)
	set category = "Admin"
	set name = "Jump to Coordinate"

	if (!holder)
		to_chat(src, "Only administrators may use this command.")
		return

	if(src.mob)
		var/mob/A = src.mob
		var/turf/T = locate(tx,ty,tz)
		A.forceMove(T)
		SSblackbox.record_feedback("tally", "admin_verb", 1, "Jump To Coordiate") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	message_admins("[key_name_admin(usr)] jumped to coordinates [tx], [ty], [tz]")

/client/proc/jumptokey()
	set category = "Admin"
	set name = "Jump to Key"

	if(!src.holder)
		to_chat(src, "Only administrators may use this command.")
		return

	var/list/keys = list()
	for(var/mob/M in GLOB.player_list)
		keys += M.client
	var/client/selection = input("Please, select a player!", "Admin Jumping", null, null) as null|anything in sortKey(keys)
	if(!selection)
		to_chat(src, "No keys found.")
		return
	var/mob/M = selection.mob
	log_admin("[key_name(usr)] jumped to [key_name(M)]")
	message_admins("[key_name_admin(usr)] jumped to [ADMIN_LOOKUPFLW(M)]")

	usr.forceMove(M.loc)

	SSblackbox.record_feedback("tally", "admin_verb", 1, "Jump To Key") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/Getmob(mob/M in GLOB.mob_list - GLOB.dummy_mob_list)
	set category = "Admin"
	set name = "Get Mob"
	set desc = "Mob to teleport"
	if(!src.holder)
		to_chat(src, "Only administrators may use this command.")
		return

	var/atom/loc = get_turf(usr)
	log_admin("[key_name(usr)] teleported [key_name(M)] to [AREACOORD(loc)]")
	var/msg = "[key_name_admin(usr)] teleported [ADMIN_LOOKUPFLW(M)] to [ADMIN_VERBOSEJMP(loc)]"
	message_admins(msg)
	admin_ticket_log(M, msg)
	M.forceMove(loc)
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Get Mob") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/Getkey()
	set category = "Admin"
	set name = "Get Key"
	set desc = "Key to teleport"

	if(!src.holder)
		to_chat(src, "Only administrators may use this command.")
		return

	var/list/keys = list()
	for(var/mob/M in GLOB.player_list)
		keys += M.client
	var/client/selection = input("Please, select a player!", "Admin Jumping", null, null) as null|anything in sortKey(keys)
	if(!selection)
		return
	var/mob/M = selection.mob

	if(!M)
		return
	log_admin("[key_name(usr)] teleported [key_name(M)]")
	var/msg = "[key_name_admin(usr)] teleported [ADMIN_LOOKUPFLW(M)]"
	message_admins(msg)
	admin_ticket_log(M, msg)
	if(M)
		M.forceMove(get_turf(usr))
		usr.forceMove(M.loc)
		SSblackbox.record_feedback("tally", "admin_verb", 1, "Get Key") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/sendmob(mob/M in sortmobs())
	set category = "Admin"
	set name = "Send Mob"
	if(!src.holder)
		to_chat(src, "Only administrators may use this command.")
		return
	var/area/A = input(usr, "Pick an area.", "Pick an area") in GLOB.sortedAreas|null
	if(A && istype(A))
		if(M.forceMove(safepick(get_area_turfs(A))))

			log_admin("[key_name(usr)] teleported [key_name(M)] to [AREACOORD(A)]")
			var/msg = "[key_name_admin(usr)] teleported [ADMIN_LOOKUPFLW(M)] to [AREACOORD(A)]"
			message_admins(msg)
			admin_ticket_log(M, msg)
		else
			to_chat(src, "Failed to move mob to a valid location.")
		SSblackbox.record_feedback("tally", "admin_verb", 1, "Send Mob") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
*/

/client/proc/Jump(var/area/A in return_sorted_areas())
	set name = "Jump to Area"
	set desc = "Area to jump to"
	set category = "Admin"
	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG))
		return

	if(config.allow_admin_jump)
		user.forceMove(pick(get_area_turfs(A)))

		log_admin("[key_name(usr)] jumped to [A]")
		message_admins("[key_name_admin(usr)] jumped to [A]", 1)
		feedback_add_details("admin_verb","JA") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	else
		alert("Admin jumping disabled")

/client/proc/jumptoturf(turf/T in world)
	set name = "Jump to Turf"
	set category = "Admin"
	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG))
		return
	if(config.allow_admin_jump)
		log_admin("[key_name(usr)] jumped to [T.x],[T.y],[T.z] in [T.loc]")
		message_admins("[key_name_admin(usr)] jumped to [T.x],[T.y],[T.z] in [T.loc]", 1)
		usr.forceMove(T)
		feedback_add_details("admin_verb","JT") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	else
		alert("Admin jumping disabled")
	return

/client/proc/jumptomob(var/mob/M in mob_list)
	set category = "Admin"
	set name = "Jump to Mob"
	set popup_menu = FALSE //VOREStation Edit - Declutter.
	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG))
		return

	if(config.allow_admin_jump)
		log_admin("[key_name(usr)] jumped to [key_name(M)]")
		message_admins("[key_name_admin(usr)] jumped to [key_name_admin(M)]", 1)
		if(src.mob)
			var/mob/A = src.mob
			var/turf/T = get_turf(M)
			if(T && isturf(T))
				feedback_add_details("admin_verb","JM") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
				A.forceMove(T)
			else
				A << "This mob is not located in the game world."
	else
		alert("Admin jumping disabled")

/client/proc/jumptocoord(tx as num, ty as num, tz as num)
	set category = "Admin"
	set name = "Jump to Coordinate"

	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG))
		return

	if (config.allow_admin_jump)
		if(src.mob)
			var/mob/A = src.mob
			A.forceMove(locate(tx, ty, tz))
			feedback_add_details("admin_verb","JC") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
		message_admins("[key_name_admin(usr)] jumped to coordinates [tx], [ty], [tz]")

	else
		alert("Admin jumping disabled")

/client/proc/jumptokey()
	set category = "Admin"
	set name = "Jump to Key"

	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG))
		return

	if(config.allow_admin_jump)
		var/list/keys = list()
		for(var/mob/M in player_list)
			keys += M.client
		var/selection = input("Please, select a player!", "Admin Jumping", null, null) as null|anything in sortKey(keys)
		if(!selection)
			src << "No keys found."
			return
		var/mob/M = selection:mob
		log_admin("[key_name(usr)] jumped to [key_name(M)]")
		message_admins("[key_name_admin(usr)] jumped to [key_name_admin(M)]", 1)
		usr.forceMove(M.loc)
		feedback_add_details("admin_verb","JK") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	else
		alert("Admin jumping disabled")

/client/proc/Getmob(var/mob/M in mob_list)
	set category = "Admin"
	set name = "Get Mob"
	set desc = "Mob to teleport"
	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG))
		return
	if(config.allow_admin_jump)
		log_admin("[key_name(usr)] jumped to [key_name(M)]")
		var/msg = "[key_name_admin(usr)] jumped to [key_name_admin(M)]"
		message_admins(msg)
		admin_ticket_log(M, msg)
		M.forceMove(get_turf(usr))
		feedback_add_details("admin_verb","GM") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	else
		alert("Admin jumping disabled")

/client/proc/Getkey()
	set category = "Admin"
	set name = "Get Key"
	set desc = "Key to teleport"

	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG))
		return

	if(config.allow_admin_jump)
		var/list/keys = list()
		for(var/mob/M in player_list)
			keys += M.client
		var/selection = input("Please, select a player!", "Admin Jumping", null, null) as null|anything in sortKey(keys)
		if(!selection)
			return
		var/mob/M = selection:mob

		if(!M)
			return
		log_admin("[key_name(usr)] teleported [key_name(M)]")
		var/msg = "[key_name_admin(usr)] teleported [ADMIN_LOOKUPFLW(M)]"
		message_admins(msg)
		admin_ticket_log(M, msg)
		if(M)
			M.forceMove(get_turf(usr))
			feedback_add_details("admin_verb","GK") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	else
		alert("Admin jumping disabled")

/client/proc/sendmob(var/mob/M in sortmobs())
	set category = "Admin"
	set name = "Send Mob"
	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG))
		return
	var/area/A = input(usr, "Pick an area.", "Pick an area") in return_sorted_areas()
	if(A)
		if(config.allow_admin_jump)
			M.forceMove(pick(get_area_turfs(A)))
			feedback_add_details("admin_verb","SMOB") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

			log_admin("[key_name(usr)] teleported [key_name(M)]")
			var/msg = "[key_name_admin(usr)] teleported [ADMIN_LOOKUPFLW(M)]"
			message_admins(msg)
			admin_ticket_log(M, msg)
		else
			alert("Admin jumping disabled")