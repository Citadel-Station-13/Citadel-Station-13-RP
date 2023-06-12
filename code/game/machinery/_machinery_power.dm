
#warn parse 
// todo: oh boy audit all of this

// returns true if the area has power on given channel (or doesn't require power).
// defaults to power_channel
/obj/machinery/proc/powered(var/chan = CURRENT_CHANNEL) // defaults to power_channel
	//Don't do this. It allows machines that set use_power to 0 when off (many machines) to
	//be turned on again and used after a power failure because they never gain the NOPOWER flag.
	//if(!use_power)
	//	return 1

	var/area/A = get_area(src)		// make sure it's in an area
	if(!A)
		return 0					// if not, then not powered
	if(chan == CURRENT_CHANNEL)
		chan = power_channel
	return A.powered(chan)			// return power status of the area

// called whenever the power settings of the containing area change
// by default, check equipment channel & set/clear NOPOWER flag
// Returns TRUE if NOPOWER machine_stat flag changed.
// can override if needed
/obj/machinery/proc/power_change()
	var/oldstat = machine_stat
	if(powered(power_channel))
		machine_stat &= ~NOPOWER
	else
		machine_stat |= NOPOWER
	return (machine_stat != oldstat)
	#warn parse that

