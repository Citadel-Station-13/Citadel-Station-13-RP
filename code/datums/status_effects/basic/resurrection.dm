/datum/status_effect/resurrection_sickness
	identifier = "resurrection"
	alert_admins_when_leaving = TRUE

/datum/status_effect/resurrection_sickness/on_apply(...)
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.add_modifier(/datum/modifier/resurrection_sickness)

/datum/status_effect/resurrection_sickness/on_remove()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.remove_a_modifier_of_type(/datum/modifier/resurrection_sickness)

/datum/status_effect/resurrection_sickness/resleeve
	identifier = "resleeve"

