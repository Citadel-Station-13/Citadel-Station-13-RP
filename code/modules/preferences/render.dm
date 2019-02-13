

/datum/preferences/proc/update_preview_icon()
	var/mob/living/carbon/human/dummy/mannequin = generate_or_wait_for_human_dummy(DUMMY_HUMAN_SLOT_PREFERENCES)
	dress_preview_mob(mannequin)
	COMPILE_OVERLAYS(mannequin)
	client.show_character_previews(new /mutable_appearance(mannequin))
	unset_busy_human_dummy(DUMMY_HUMAN_SLOT_PREFERENCES)

