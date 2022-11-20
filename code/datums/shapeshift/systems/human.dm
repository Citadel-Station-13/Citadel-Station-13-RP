/datum/shapeshift_system/human

#warn impl

/datum/shapeshift/human

/datum/shapeshift/human/apply_to_mob(mob/living/carbon/human/applying, capabilities)
	. = ..()

/datum/shapeshift/human/copy_from_mob(mob/living/carbon/human/template, capabilities)
	. = ..()

/datum/shapeshift/proc/clone()
	var/datum/shapeshift/human/cloned = ..()

#warn impl
