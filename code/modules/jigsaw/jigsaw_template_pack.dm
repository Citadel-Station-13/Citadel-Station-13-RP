//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

GLOBAL_LIST_EMPTY(jigsaw_template_pack_cache)

/proc/fetch_cached_jigsaw_template_pack(datum/jigsaw_template_pack/resolvable)
	if(istype(resolvable))
		return resolvable
	else if(isnull(resolvable))
		return null

	if(GLOB.jigsaw_template_pack_cache[resolvable])
		return GLOB.jigsaw_template_pack_cache[resolvable]

	if(!ispath(resolvable))
		return null

	var/datum/jigsaw_template_pack/template = new resolvable
	GLOB.jigsaw_template_pack_cache[resolvable] = template

	return template

/datum/jigsaw_template_pack
	/**
	 * May be ID, typepath, instance.
	 */
	var/list/templates = list()

/datum/jigsaw_template_pack/proc/validate_templates()
	for(var/resolvable in src.templates)
		var/datum/jigsaw_template/template = fetch_cached_jigsaw_template(resolvable)
		if(!template)
			CRASH("Invalid template '[resolvable]' detected in pack.")

/datum/jigsaw_template_pack/proc/resolve_templates() as /list
	var/list/datum/jigsaw_template/resolved = list()
	for(var/resolvable in src.templates)
		var/datum/jigsaw_template/template = fetch_cached_jigsaw_template(resolvable)
		if(!template)
			continue
		resolved += template
	return resolved
