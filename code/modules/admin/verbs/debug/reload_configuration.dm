
/client/proc/reload_configuration()
	set category = "Debug"
	set name = "Reload Configuration"
	set desc = "Force config reload to world default"
	if(!check_rights(R_DEBUG))
		return
	if(alert(usr, "Are you absolutely sure you want to reload the configuration from the default path on the disk, wiping any in-round modificatoins?", "Really reset?", "No", "Yes") == "Yes")
		log_and_message_admins("[key_name(usr)] reloaded server configuration.")
		config.admin_reload()
		Configuration.admin_reload()
		load_legacy_configuration()		//for legacy
