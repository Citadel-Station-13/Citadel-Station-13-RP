/proc/log_nsay(text, inside, mob/speaker)
	if (config_legacy.log_say)
		WRITE_LOG(GLOB.world_game_log, "NSAY (NIF:[inside]): [speaker.simple_info_line()]: [html_decode(text)]")

/proc/log_nme(text, inside, mob/speaker)
	if (config_legacy.log_emote)
		WRITE_LOG(GLOB.world_game_log, "NME (NIF:[inside]): [speaker.simple_info_line()]: [html_decode(text)]")

/proc/log_subtle(text, mob/speaker)
	if (config_legacy.log_emote)
		WRITE_LOG(GLOB.world_game_log, "SUBTLE: [speaker.simple_info_line()]: [html_decode(text)]")

/proc/log_subtle_anti_ghost(text, mob/speaker)
	if (config_legacy.log_emote)
		WRITE_LOG(GLOB.world_game_log, "SUBTLER: [speaker.simple_info_line()]: [html_decode(text)]")
