//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Replaces all instances of "$key" in a text string with the given variable.
 *
 * Keys are provided as a key list associated to replacements.
 *
 * Example: fmttext("$user hits $target with $weapon", list("user" = src, "target" = target, "weapon" = get_active_held_item()))
 */
/proc/fmttext(str, list/keys)
	. = str
	if(isnull(.))
		// mimics byond behavior of returning null if input is null for <x>text() procs
		return
	// todo: optimize this if needed, maybe dynamic regex?
	for(var/key in keys)
		. = replacetext_char(., "$[key]", keys[key])
