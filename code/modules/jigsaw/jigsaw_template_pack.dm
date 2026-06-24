//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/datum/prototype/jigsaw_template_pack
	/**
	 * May be ID, typepath, instance.
	 */
	var/list/templates = list()

/datum/prototype/jigsaw_template_pack/proc/validate_templates()
	for(var/resolvable in src.templates)
		var/datum/prototype/jigsaw_template/template = fetch_cached_jigsaw_template(resolvable)
		if(!template)
			CRASH("Invalid template '[resolvable]' detected in pack.")

/datum/prototype/jigsaw_template_pack/proc/resolve_templates() as /list
	var/list/datum/prototype/jigsaw_template/resolved = list()
	for(var/resolvable in src.templates)
		var/datum/prototype/jigsaw_template/template = fetch_cached_jigsaw_template(resolvable)
		if(!template)
			continue
		resolved += template
	return resolved
