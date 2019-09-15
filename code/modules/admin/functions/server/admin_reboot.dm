/datum/admins/proc/restart()
	set category = "Server"
	set name = "Reboot World"
	set desc="Restarts the world immediately"
	if (!usr.client.holder)
		return

	var/list/options = list("Regular Restart", "Hard Restart (No Delay/Feeback Reason)", "Hardest Restart (No actions, just reboot)")
	if(world.TgsAvailable())
		options += "Server Restart (Kill and restart DD)";

	var/rebootconfirm
	//if(SSticker.admin_delay_notice)
	//	if(alert(usr, "Are you sure you want to reboot? An admin has already delayed the round end for the following reason: [SSticker.admin_delay_notice]", "Confirmation", "Yes", "No") == "Yes")
	if(alert(usr, "Are you sure you want to reboot?", "Confirmation", "Yes", "No") == "Yes")
		rebootconfirm = TRUE
	if(rebootconfirm)
		var/result = input(usr, "Select reboot method", "World Reboot", options[1]) as null|anything in options
		if(result)
			//SSblackbox.record_feedback("tally", "admin_verb", 1, "Reboot World") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
			var/init_by = "Initiated by [usr && usr.client && usr.client.holder && usr.client.holder.fakekey ? "Admin" : usr.key]."
			switch(result)
				if("Regular Restart")
					//SSticker.Reboot(init_by, "admin reboot - by [usr.key] [usr.client.holder.fakekey ? "(stealth)" : ""]", 10)
					//POLARIS CODE REE
					to_chat(world, "<span class='danger'>Rebooting world in 1 second! Initiated by [init_by]</span>")
					spawn(10)
						world.Reboot()
				if("Hard Restart (No Delay, No Feeback Reason)")
					to_chat(world, "<span class='danger'>World reboot - [init_by]</span>")
					world.Reboot()
				if("Hardest Restart (No actions, just reboot)")
					to_chat(world, "<span class='danger'>Hard world reboot - [init_by]</span>")
					world.Reboot(fast_track = TRUE)
				if("Server Restart (Kill and restart DD)")
					to_chat(world, "<span class='danger'>Server hard process restart - [init_by]</span>")
					world.TgsEndProcess()
