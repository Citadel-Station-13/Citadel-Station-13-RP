#define REGULAR_RESTART "Regular Restart"
#define REGULAR_RESTART_DELAYED "Regular Restart (with delay)"
#define NO_EVENT_RESTART "Restart, Skip TGS Event"
#define HARD_RESTART "Hard Restart (No Delay/Feedback Reason)"
#define HARDEST_RESTART "Hardest Restart (No actions, just reboot)"
#define TGS_RESTART "Server Restart (Kill and restart DD)"
/datum/admins/proc/restart()
	set category = "Server"
	set name = "Reboot World"
	set desc = "Restarts the world immediately"
	if (!usr.client.holder)
		return

	var/list/options = list(REGULAR_RESTART, REGULAR_RESTART_DELAYED, HARD_RESTART)

	// this option runs a codepath that can leak db connections because it skips subsystem (specifically SSdbcore) shutdown
	if(!SSdbcore.IsConnected())
		options += HARDEST_RESTART

	if(world.TgsAvailable())
		options.Insert(3, NO_EVENT_RESTART)
		options += TGS_RESTART;

	if(SSticker.admin_delay_notice)
		if(alert(usr, "Are you sure? An admin has already delayed the round end for the following reason: [SSticker.admin_delay_notice]", "Confirmation", "Yes", "No") != "Yes")
			return FALSE

	var/result = input(usr, "Select reboot method", "World Reboot", options[1]) as null|anything in options
	if(isnull(result))
		return

	// BLACKBOX_LOG_ADMIN_VERB("Reboot World")
	var/init_by = "Initiated by [usr.client.holder.fakekey ? "Admin" : usr.key]."
	switch(result)
		if(REGULAR_RESTART, REGULAR_RESTART_DELAYED, NO_EVENT_RESTART)
			var/delay = 1
			if(result == REGULAR_RESTART_DELAYED)
				delay = input("What delay should the restart have (in seconds)?", "Restart Delay", 5) as num|null
			if(!delay)
				return FALSE
			if(!usr.client.is_localhost())
				if(alert(user,"Are you sure you want to restart the server?","This server is live", "Restart", "Cancel") != "Restart")
					return FALSE

			if (result != NO_EVENT_RESTART)
				SSticker.TriggerRoundEndTgsEvent()

			SSticker.Reboot(init_by, "admin reboot - by [usr.key] [usr.client.holder.fakekey ? "(stealth)" : ""]", delay * 10)
		if(HARD_RESTART)
			to_chat(world, "World reboot - [init_by]")
			world.Reboot()
		if(HARDEST_RESTART)
			to_chat(world, "Hard world reboot - [init_by]")
			world.Reboot(fast_track = TRUE)
		if(TGS_RESTART)
			to_chat(world, "Server restart - [init_by]")
			world.TgsEndProcess()

#undef REGULAR_RESTART
#undef REGULAR_RESTART_DELAYED
#undef NO_EVENT_RESTART
#undef HARD_RESTART
#undef HARDEST_RESTART
#undef TGS_RESTART
