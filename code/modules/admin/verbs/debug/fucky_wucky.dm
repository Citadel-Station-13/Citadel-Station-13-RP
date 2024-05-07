
/client/proc/fucky_wucky()
	set category = "Debug"
	set name = "Fucky Wucky"
	set desc = "Inform the players that the code monkeys at our headquarters are working very hard to fix this."

	log_and_message_admins("[key_name(src)] made a fucky wucky.")

	for(var/victim as anything in GLOB.player_list)
		var/datum/asset_pack/fuckywucky = get_asset_datum(/datum/asset_pack/simple/fuckywucky)
		fuckywucky.send(victim)
		SEND_SOUND(victim, 'sound/misc/fuckywucky.ogg')
		to_chat(victim, "<img src='fuckywucky.png'>")
