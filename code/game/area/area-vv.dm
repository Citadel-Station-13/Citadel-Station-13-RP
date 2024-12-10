/area/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_OPTION("check_static_power", "Check Static Power")

/area/vv_do_topic(list/href_list)
	. = ..()
	if(href_list["check_static_power"])
		debug_static_power(usr)

/// Debugging proc to report if static power is correct or not.
/area/proc/debug_static_power(mob/user)
	var/list/was = power_usage_static.Copy()
	retally_power()
	if(user)
		var/list/report = list()
		report += "[src] ([type]) static power trace: was --> actual:"
		for(var/i in 1 to POWER_CHANNEL_COUNT)
			report += "[global.power_channel_names[i]] - [power_usage_static[i] == was[i]? "<span class='good'>" : "<span class='bad'>"][was[i]] --> [power_usage_static[i]]</span>"
		to_chat(user, jointext(report, "<br>"))
	return was ~= power_usage_static
