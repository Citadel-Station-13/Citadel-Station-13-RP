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
	/// VV class for the default implementation of prompt_value.
	var/value_vv_class
	/// Allow nulls?
	var/allow_null = FALSE

/datum/variable_setting_entry/New(_value)
	if(!islist(_value))
		value = initial_value = _value
	else
		value = deepCopyList(_value)
		initial_value = deepCopyList(_value)
	if(initial_value && isnull(value_vv_class))
		value_vv_class = vv_get_class(initial_value)
	// we do not handle datums yet.

/datum/variable_setting_entry/proc/reset_to_default()
	if(islist(initial_value))
		value = deepCopyList(initial_value)
	else
		value = initial_value

/datum/variable_setting_entry/proc/set_value(newvalue)
	value = newvalue

/datum/variable_setting_entry/proc/ui_html(datum/variable_settings_controller/host, category)
	. = list()
	. += "<h3>[name]</h3> - <b>\[<a href='?src=[REF(host)];target=[type];set=1;category=[category]'>SET</a>\]</b><br>"
	. += "[desc]"
	return jointext(., "")

#define CANCEL_VALUE "#################____######CANCEL"		//heh
/datum/variable_setting_entry/proc/prompt_value(mob/user)
	var/list/vv_return = user.client.vv_get_value(class = value_vv_class, current_value = value)
	. = vv_return["value"]
	if((.["class"] != VV_NULL) && isnull(.["value"]))
		return CANCEL_VALUE

/datum/variable_setting_entry/proc/OnTopic(href, href_list)
	if(href_list["set"])
		var/val = prompt_value(usr)
		if((isnull(val) && !allow_null) || (val == CANCEL_VALUE))
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

#undef CANCEL_VALUE
