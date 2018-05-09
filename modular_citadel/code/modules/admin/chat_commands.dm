/datum/tgs_chat_command/irccheck
	name = "check"
	help_text = "Returns the playercount and address of the server"
	var/last_check = 0

/datum/tgs_chat_command/irccheck/Run(datum/tgs_chat_user/sender, params)
	if(world.time - last_check < 10)
		return
	last_check = world.time
	return "Players: [clients.len] -- Address: [world.internet_address]:[world.port]"

/datum/tgs_chat_command/ahelp
	name = "ahelp"
	help_text = "<ckey> <message>"
	admin_only = TRUE

/datum/tgs_chat_command/ahelp/Run(datum/tgs_chat_user/sender, params)
	var/list/all_params = splittext(params, " ")
	if(all_params.len < 2)
		return "Do I look like a psychic to you?"
	var/target = ckey(all_params[1])
	all_params.Cut(1, 2)
	if(target)
		var/client/C = directory[target]
		if(C)
			var/reconstructedmessage = all_params.Join(" ")
			C << "<spam class='message'>Discord Admin PM from [sender.friendly_name]: [reconstructedmessage]</span>"
			C << 'sound/effects/adminhelp.ogg'
			log_admin("Discord PM: [sender.friendly_name]->[key_name(C)]: [reconstructedmessage]")
			return "Admin PM sent!"
		return "Failed to send PM - Client doesnt exist"
	return "Failed to send PM - Cant even find the target"
