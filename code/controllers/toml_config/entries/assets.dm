//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/toml_config_entry/assets
	abstract_type = /datum/toml_config_entry/assets
	category = "assets"

/datum/toml_config_entry/assets/webroot_location
	key = "webroot_location"
	desc = "The location of the webroot directory. Assets will be placed in there that are \
	expected to be served by 'webroot_url_base', if it's enabled."

/datum/toml_config_entry/assets/webroot_location/apply(raw_config_value)
	. = ..()
	#warn trim last /

/datum/toml_config_entry/assets/webroot_url_base
	key = "webroot_url_base"
	desc = "The base webroot URL. If set, assets are expected to be served from this URL \
	with a path-join to 'webroot_location'. If not set, systems that require webroot \
	to be set will fallback to asset cache or simply not work at all."

/datum/toml_config_entry/assets/webroot_url_base/apply(raw_config_value)
	. = ..()
	#warn trim last /

#warn set in configs?
