/client/proc/Jump(area/target in GLOB.sortedAreas)
	set name = "Jump to Area"
	set desc = "Area to jump to"
	set category = "Admin"

	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG))
		return

	// try not to area jump in walls
	var/turf/drop_location
	top_level:
		for(var/turf/area_turf as anything in get_area_turfs(target))
			if(area_turf.density)
				continue
			drop_location = area_turf
			break top_level

	if(isnull(drop_location))
		to_chat(usr, SPAN_WARNING("No valid drop location found in the area!"))
		return

	mob.abstract_move(drop_location)
	log_admin("[key_name(usr)] jumped to [AREACOORD(drop_location)]")
	message_admins("[key_name_admin(usr)] jumped to [AREACOORD(drop_location)]")
	feedback_add_details("admin_verb","JA") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/jumptoturf(turf/locale in world)
	set name = "Jump to Turf"
	set category = "Admin"
	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG))
		return

	log_admin("[key_name(usr)] jumped to [AREACOORD(locale)]")
	message_admins("[key_name_admin(usr)] jumped to [AREACOORD(locale)]")
	mob.abstract_move(locale)
	feedback_add_details("admin_verb","JT") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/jumptomob(mob/target in GLOB.mob_list)
	set category = "Admin"
	set name = "Jump to Mob"
	set popup_menu = FALSE
	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG))
		return

	mob.abstract_move(target.loc)
	log_admin("[key_name(usr)] jumped to [key_name(target)]")
	message_admins("[key_name_admin(usr)] jumped to [ADMIN_LOOKUPFLW(target)] at [AREACOORD(target)]")
	feedback_add_details("admin_verb","JM") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/jumptocoord(tx as num, ty as num, tz as num)
	set category = "Admin"
	set name = "Jump to Coordinate"

	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG))
		return

	var/turf/where_we_droppin = locate(tx, ty,tz)
	if(isnull(where_we_droppin))
		to_chat(usr, SPAN_WARNING("Invalid coordinates."))
		return

	mob.abstract_move(where_we_droppin)
	message_admins("[key_name_admin(usr)] jumped to coordinates [tx], [ty], [tz]")
	feedback_add_details("admin_verb","JC") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/jumptokey()
	set category = "Admin"
	set name = "Jump to Key"

	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG))
		return

	if(!isobserver(mob))
		admin_ghost()

	var/list/keys = list()
	for(var/mob/M in GLOB.player_list)
		keys += M.client
	var/client/selection = input(usr, "Please, select a player!", "Admin Jumping") as null|anything in sortKey(keys)
	if(!selection)
		to_chat(usr, "No keys found.", confidential = TRUE)
		return
	var/mob/M = selection.mob
	log_admin("[key_name(usr)] jumped to [key_name(M)]")
	message_admins("[key_name_admin(usr)] jumped to [ADMIN_LOOKUPFLW(M)]")
	mob.abstract_move(M.loc)
	feedback_add_details("admin_verb","JK") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/Getmob(mob/target in GLOB.mob_list)
	set category = "Admin"
	set name = "Get Mob"
	set desc = "Mob to teleport"
	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG))
		return
	var/atom/loc = get_turf(mob)
	target.admin_teleport(loc)
	feedback_add_details("admin_verb","GM") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/// Proc to hook user-enacted teleporting behavior and keep logging of the event.
/atom/movable/proc/admin_teleport(atom/new_location)
	if(isnull(new_location))
		log_admin("[key_name(usr)] teleported [key_name(src)] to nullspace")
		moveToNullspace()
	else
		var/turf/location = get_turf(new_location)
		log_admin("[key_name(usr)] teleported [key_name(src)] to [AREACOORD(location)]")
		forceMove(new_location)

/mob/admin_teleport(atom/new_location)
	var/turf/location = get_turf(new_location)
	var/msg = "[key_name_admin(usr)] teleported [ADMIN_LOOKUPFLW(src)] to [isnull(new_location) ? "nullspace" : ADMIN_VERBOSEJMP(location)]"
	message_admins(msg)
	admin_ticket_log(src, msg)
	return ..()

/client/proc/Getkey()
	set category = "Admin"
	set name = "Get Key"
	set desc = "Key to teleport"

	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG))
		return

	var/list/keys = list()
	for(var/mob/M in GLOB.player_list)
		keys += M.client
	var/client/selection = input(usr, "Please, select a player!", "Admin Jumping") as null|anything in sortKey(keys)
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
		feedback_add_details("admin_verb","GK") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/sendmob(mob/jumper in sortmobs())
	set category = "Admin"
	set name = "Send Mob"
	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG))
		return
	var/area/target_area = tgui_input_list(usr, "Pick an area", "Send Mob", GLOB.sortedAreas)
	if(isnull(target_area))
		return
	if(!istype(target_area))
		return
	var/list/turfs = get_area_turfs(target_area)
	if(length(turfs) && jumper.forceMove(pick(turfs)))
		log_admin("[key_name(usr)] teleported [key_name(jumper)] to [AREACOORD(jumper)]")
		var/msg = "[key_name_admin(usr)] teleported [ADMIN_LOOKUPFLW(jumper)] to [AREACOORD(jumper)]"
		message_admins(msg)
		admin_ticket_log(jumper, msg)
	else
		to_chat(usr, "Failed to move mob to a valid location.", confidential = TRUE)
	feedback_add_details("admin_verb","SMOB") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
