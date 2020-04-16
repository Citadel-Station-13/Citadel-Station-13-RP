

/datum/controller/subsystem/ticker/proc/standard_reboot()
	if(ready_for_reboot)
		if(mode.station_was_nuked)
			Reboot("Station destroyed by Nuclear Device.", 60 SECONDS)
		else
			Reboot("Round ended.")
	else
		CRASH("Attempted standard reboot without ticker roundend completion")
