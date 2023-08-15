/datum/status_effect/grouped/crusher_mark
	identifier = "crusher_mark"
	duration = 300 //if you leave for 30 seconds you lose the mark, deal with it
	var/mutable_appearance/marked_underlay

/datum/status_effect/grouped/crusher_mark/on_apply()
	marked_underlay = mutable_appearance('icons/effects/effects.dmi', "shield2")
	marked_underlay.pixel_x = -owner.pixel_x
	marked_underlay.pixel_y = -owner.pixel_y
	owner.add_overlay(marked_underlay, TRUE)
	return ..()

/datum/status_effect/grouped/crusher_mark/on_remove()
	owner.cut_overlay(marked_underlay, TRUE)
	QDEL_NULL(marked_underlay)
	return ..()
