
/client/proc/fucky_wucky()
	set category = "Debug"
	set name = "Fucky Wucky"
	set desc = "Inform the players that the code monkeys at our headquarters are working very hard to fix this."

	log_and_message_admins("[key_name(src)] made a fucky wucky.")

	var/datum/asset_pack/assets = SSassets.load_asset_pack(/datum/asset_pack/simple/fuckywucky)
	var/img_src = assets.get_url("fuckywucky.png")
	SSassets.send_asset_pack(GLOB.player_list, assets)

	for(var/victim as anything in GLOB.player_list)
		SEND_SOUND(victim, 'sound/misc/fuckywucky.ogg')
		to_chat(victim, "<img src='[img_src]'>")
