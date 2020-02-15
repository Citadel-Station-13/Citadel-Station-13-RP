/proc/send2irc(var/channel, var/msg)
	return  // VOREStation Edit - Can't exploit shell if we never call shell!
	if (config_legacy.use_irc_bot)
		if (config_legacy.use_node_bot)
			shell("node bridge.js -h \"[config_legacy.irc_bot_host]\" -p \"[config_legacy.irc_bot_port]\" -c \"[channel]\" -m \"[escape_shell_arg(msg)]\"")
		else
			if (config_legacy.irc_bot_host)
				if(config_legacy.irc_bot_export)
					spawn(-1) // spawn here prevents hanging in the case that the bot isn't reachable
						world.Export("http://[config_legacy.irc_bot_host]:45678?[list2params(list(pwd=config_legacy.comms_password, chan=channel, mesg=msg))]")
				else
					if(config_legacy.use_lib_nudge)
						var/nudge_lib
						if(world.system_type == MS_WINDOWS)
							nudge_lib = "lib\\nudge.dll"
						else
							nudge_lib = "lib/nudge.so"

						spawn(0)
							call(nudge_lib, "nudge")("[config_legacy.comms_password]","[config_legacy.irc_bot_host]","[channel]","[escape_shell_arg(msg)]")
					else
						spawn(0)
							ext_python("ircbot_message.py", "[config_legacy.comms_password] [config_legacy.irc_bot_host] [channel] [escape_shell_arg(msg)]")
	return

/proc/send2mainirc(var/msg)
	if(config_legacy.main_irc)
		send2irc(config_legacy.main_irc, msg)
	return

/proc/send2adminirc(var/msg)
	if(config_legacy.admin_irc)
		send2irc(config_legacy.admin_irc, msg)
	return


/hook/startup/proc/ircNotify()
	send2mainirc("Server starting up on byond://[config_legacy.serverurl ? config_legacy.serverurl : (config_legacy.server ? config_legacy.server : "[world.address]:[world.port]")]")
	return 1

