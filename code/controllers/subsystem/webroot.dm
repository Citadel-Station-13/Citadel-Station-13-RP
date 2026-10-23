//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

SUBSYSTEM_DEF(webroot)
	name = "Webroot"
	subsystem_flags = SS_NO_INIT | SS_NO_FIRE

/datum/subsystem/webroot/proc/get_webroot_path_root()
	return Configuration.get_entry(/datum/toml_config_entry/assets/webroot_location)

/datum/subsystem/webroot/proc/get_webroot_path(path)
	if(!path)
		return null
	if(path[1] == "/")
		if(length(path) == 1)
			return null
		return Configuration.get_entry(/datum/toml_config_entry/assets/webroot_location) + copytext(path, 2)
	else
		return Configuration.get_entry(/datum/toml_config_entry/assets/webroot_location) + path

/datum/subsystem/webroot/proc/get_webroot_url_root()
	return Configuration.get_entry(/datum/toml_config_entry/assets/webroot_url_base)

/datum/subsystem/webroot/proc/get_webroot_url(url)
	if(!url)
		return null
	if(url[1] == "/")
		if(length(url) == 1)
			return null
		return Configuration.get_entry(/datum/toml_config_entry/assets/webroot_url_base) + copytext(url, 2)
	else
		return Configuration.get_entry(/datum/toml_config_entry/assets/webroot_url_base) + url

