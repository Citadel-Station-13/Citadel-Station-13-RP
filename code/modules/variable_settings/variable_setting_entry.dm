/**
  * Variable settings entry. There cannot be duplicate entries of the same typepath in a controller.
  */
/datum/variable_setting_entry
	/// User friendly name
	var/name = "Entry"
	/// User friendly description
	var/desc = "A bugged entry!"
	/// Category
	var/category = "General"
	/// Current value
	var/value
	/// Initial value
	var/initial_value
	/// Value type
	var/value_type = VSC_VALUE_NUMBER

/datum/variable_setting_entry/New(_value)
	if(!islist(_value))
		value = initial_value = _value
	else
		value = deepCopyList(_value)
		initial_value = deepCopyList(_value)
	// we do not handle datums yet.

/datum/variable_setting_entry/proc/reset_to_default()
	if(islist(initial_value))
		value = deepCopyList(initial_value)
	else
		value = initial_value

/datum/variable_setting_entry/proc/set_value(newvalue)
	value = newvalue

/datum/variable_setting_entry/proc/render_value()
	switch(value_type)
		if(VSC_VALUE_NUMBER)
			return value
		if(VSC_VALUE_BOOLEAN)
			return value? "On" : "Off"
		else
			return value

/datum/variable_setting_entry/proc/ui_html(datum/variable_settings_controller/host, category)
	. = list()
	. += "<b>[name]</b><br><a href='?src=[REF(host)];target=[type];set=1;category=[category]'>Set</a> \[[render_value()]\]<br>"
	. += "[desc]"
	return jointext(., "")

/datum/variable_setting_entry/proc/prompt_value(mob/user)
	switch(value_type)
		if(VSC_VALUE_NUMBER)
			return input(user, "Input a number.", "Set Value", value) as num|null
		if(VSC_VALUE_BOOLEAN)
			return !value

/datum/variable_setting_entry/proc/OnTopic(href, href_list)
	if(href_list["set"])
		var/val = prompt_value(usr)
		if(isnull(val))
			return FALSE
		var/logstr = "[key_name(usr)] set [src]([type]) to [val]."
		message_admins(logstr)
		log_admin(logstr)
		set_value(val)
		return TRUE
	if(href_list["initial"])
		var/logstr = "[key_name(usr)] reset [src]([type]) to default."
		message_admins(logstr)
		log_admin(logstr)
		reset_to_default()
		return TRUE
	return FALSE
