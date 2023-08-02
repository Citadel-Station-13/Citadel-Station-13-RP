/datum/status_effect/grouped/crusher_mark
	identifier = "crusher_mark"
	duration = 300 //if you leave for 30 seconds you lose the mark, deal with it
	var/mutable_appearance/marked_underlay
	var/obj/item/kinetic_crusher/hammer_synced

/datum/status_effect/grouped/crusher_mark/on_apply(obj/item/kinetic_crusher/crusher, ...)
	hammer_synced = crusher
	marked_underlay = mutable_appearance('icons/effects/effects.dmi', "shield2")
	marked_underlay.pixel_x = -owner.pixel_x
	marked_underlay.pixel_y = -owner.pixel_y
	owner.underlays += marked_underlay
	return ..()

/datum/status_effect/grouped/crusher_mark/on_remove()
	hammer_synced = null
	owner.underlays -= marked_underlay
	QDEL_NULL(marked_underlay)
	return ..()
