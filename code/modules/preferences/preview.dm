/**
 * generates an appearance from our current looks
 */
/datum/preferences/proc/render_to_appearance(flags)
	var/mob/living/carbon/human/dummy/mannequin/renderer = generate_or_wait_for_human_dummy("prefs/render_to_appearance")
	copy_to(renderer, flags)
	renderer.compile_overlays()
	. = renderer.appearance
	unset_busy_human_dummy("prefs/render_to_appearance")
