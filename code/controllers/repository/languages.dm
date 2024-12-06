//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

REPOSITORY_DEF(languages)
	name = "Repository - Languages"
	expected_type = /datum/prototype/language

	var/list/legacy_language_lookup
	var/list/legacy_language_keys

/datum/controller/repository/languages/Create()
	legacy_language_lookup = list()
	legacy_language_keys = list()
	return ..()

/datum/controller/repository/languages/load(datum/prototype/language/instance)
	. = ..()
	if(!.)
		return
	legacy_language_lookup[lowertext(instance.name)] = instance
	if(!(instance.language_flags & LANGUAGE_NONGLOBAL) && instance.key && !legacy_language_keys[instance.key])
		legacy_language_keys[instance.key] = instance

/datum/controller/repository/languages/unload(datum/prototype/language/instance)
	. = ..()
	legacy_language_lookup -= lowertext(instance.name)
	if(legacy_language_keys[instance.key] == instance)
		legacy_language_keys -= instance.key

/datum/controller/repository/languages/proc/legacy_resolve_language_name(name)
	return legacy_language_lookup[lowertext(name)]

/datum/controller/repository/languages/proc/legacy_resolve_language_key(key)
	return legacy_language_keys[key]

/datum/controller/repository/languages/proc/legacy_sorted_all_language_names()
	return tim_sort(legacy_language_lookup.Copy(), /proc/cmp_text_asc)
