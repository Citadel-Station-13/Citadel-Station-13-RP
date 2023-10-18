// Command to set the ckey of a mob without requiring VV permission
/client/proc/SetCKey(var/mob/M in GLOB.mob_list)
	set category = "Admin"
	set name = "Set CKey"
	set desc = "Mob to teleport"
	if(!src.holder)
		to_chat(src, "Only administrators may use this command.")
		return

	var/list/keys = list()
	for(var/client/C as anything in GLOB.clients)
		keys += C
	var/client/selection = input("Please, select a player!", "Set ckey", null, null) as null|anything in tim_sort(keys, GLOBAL_PROC_REF(cmp_ckey_asc))
	if(!selection || !istype(selection))
		return

	log_admin("[key_name(usr)] set ckey of [key_name(M)] to [selection]")
	message_admins("[key_name_admin(usr)] set ckey of [key_name_admin(M)] to [selection]", 1)
	M.ckey = selection.ckey
	feedback_add_details("admin_verb","SCK") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
