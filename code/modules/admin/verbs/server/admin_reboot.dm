/datum/admins/proc/restart()
	set category = "Server"
	set name = "Reboot World"
	set desc = "Restarts the world immediately"
	if (!usr.client.holder)
		return

	var/localhost_addresses = list("127.0.0.1", "::1")
	var/list/options = list("Regular Restart", "Regular Restart (with delay)", "Hard Restart (No Delay/Feeback Reason)", "Hardest Restart (No actions, just reboot)")
	if(world.TgsAvailable())
		options += "Server Restart (Kill and restart DD)";

	if(SSticker.admin_delay_notice)
		if(alert(usr, "Are you sure? An admin has already delayed the round end for the following reason: [SSticker.admin_delay_notice]", "Confirmation", "Yes", "No") != "Yes")
			return FALSE

	var/result = input(usr, "Select reboot method", "World Reboot", options[1]) as null|anything in options
	if(result)
		// SSblackbox.record_feedback("tally", "admin_verb", 1, "Reboot World") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
		var/init_by = "Initiated by [usr.client.holder.fakekey ? "Admin" : usr.key]."
		switch(result)
			if("Regular Restart")
				if(!(isnull(usr.client.address) || (usr.client.address in localhost_addresses)))
					if(alert(usr, "Are you sure you want to restart the server?","This server is live", "Restart", "Cancel") != "Restart")
						return FALSE
				SSticker.Reboot(init_by, "admin reboot - by [usr.key] [usr.client.holder.fakekey ? "(stealth)" : ""]", 1 SECOND)
			if("Regular Restart (with delay)")
				var/delay = input("What delay should the restart have (in seconds)?", "Restart Delay", 5) as num|null
				if(!delay)
					return FALSE
				if(!(isnull(usr.client.address) || (usr.client.address in localhost_addresses)))
					if(alert(usr,"Are you sure you want to restart the server?","This server is live", "Restart", "Cancel") != "Restart")
						return FALSE
				SSticker.Reboot(init_by, "admin reboot - by [usr.key] [usr.client.holder.fakekey ? "(stealth)" : ""]", delay * 10)
			if("Hard Restart (No Delay, No Feeback Reason)")
				to_chat(world, "World reboot - [init_by]")
				world.Reboot()
			if("Hardest Restart (No actions, just reboot)")
				to_chat(world, "Hard world reboot - [init_by]")
				world.Reboot(fast_track = TRUE)
			if("Server Restart (Kill and restart DD)")
				to_chat(world, "Server restart - [init_by]")
				world.TgsEndProcess()
