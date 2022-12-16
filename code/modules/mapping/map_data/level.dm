#define VALIDATION(cond, msg) if(!(cond)) {errors += "validation failed: [#cond] ; [msg]"; . = FALSE;}

/**
 * Represents a miscellaneous level to be loaded at will
 */
/datum/map_data/level
	/// Group
	var/group

/datum/map_data/level/parse(list/data)
	. = ..()
	group = data["group"]

/datum/map_data/level/validate(list/errors, list/level_ids)
	. = ..()
	VALIDATION(istext(group) && length(group), "no group")

#undef VALIDATION
