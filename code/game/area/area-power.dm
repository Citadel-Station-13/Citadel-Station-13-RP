/**
 * Gets our master APC.
 */
/area/proc/get_master_apc()
	return apc

/**
 * Called when the area power status changes
 *
 * Updates the area icon, calls power change on all machinees in the area, and sends the `COMSIG_AREA_POWER_CHANGE` signal.
 */
/area/proc/power_change()
	for(var/obj/machinery/M in src)	// for each machine in the area
		M.power_change() // reverify power status (to update icons etc.)
	if (fire || eject || party)
		update_appearance()

/**
 * returns if the channel is being powered
 */
/area/proc/powered(channel)
	if(!isnull(area_power_override))
		return area_power_override
	return power_channels & global.power_channel_bits[channel]

/**
 * use a dynamic amount of burst power
 *
 * @params
 * * amount - how much in joules
 * * channel - power channel
 * * allow_partial - allow partial usage
 * * over_time - (optional) amount of deciseconds this is over, used for smoothing
 *
 * @return power drawn
 */
/area/proc/use_burst_power(amount, channel, allow_partial, over_time)
	if(!powered(channel))
		return 0
	if(area_power_infinite || (area_power_override == TRUE))
		return amount
	return isnull(apc)? 0 : apc.use_burst_power(amount, channel, allow_partial, over_time)

/**
 * set which power channels are turned on
 */
/area/proc/set_power_channels(channels)
	if(channels == power_channels)
		return
	power_channels = channels
	power_change()

/**
 * EXTREMELY SLOW
 *
 * Retallys area power and makes sure it's up to date.
 */
/area/proc/retally_power()
	power_usage_static = EMPTY_POWER_CHANNEL_LIST
	for(var/obj/machinery/M in src)
		switch(M.use_power)
			if(USE_POWER_ACTIVE)
				power_usage_static[M.power_channel] += M.active_power_usage
				M.registered_power_usage = M.active_power_usage
			if(USE_POWER_IDLE)
				power_usage_static[M.power_channel] += M.idle_power_usage
				M.registered_power_usage = M.idle_power_usage
			if(USE_POWER_CUSTOM)
				if(isnull(M.registered_power_usage))
					continue
				power_usage_static[M.power_channel] += M.registered_power_usage
