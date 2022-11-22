/**
 * for storing shapeshifts
 */
/datum/shapeshift
	/// our template name for ui
	var/template_name

#warn impl

/datum/shapeshift/proc/apply_to_mob(mob/applying, capabilities, system_flags)
	return

/datum/shapeshift/proc/copy_from_mob(mob/template, capabilities, system_flags)
	return

/datum/shapeshift/proc/clone()
	var/datum/shapeshift/cloned = new type
	return cloned

/datum/shapeshift/ui_data()
	return list(
		"component" = template_name
	)
