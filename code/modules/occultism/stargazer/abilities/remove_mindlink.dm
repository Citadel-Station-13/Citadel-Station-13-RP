//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/datum/stargazer_mindnet_ability/remove_mindlink
	id = "remove_mindlink"
	name = "Remove Mindlink"
	desc = "Remove the pattern of their consciousness from your mind permanently, severing the link \
	you held with the target."

	attunement_cooperative_threshold = 0
	attunement_forced_threshold = 0

	default_do_after = 8 SECONDS
	default_do_after_flags = DO_AFTER_IGNORE_MOVEMENT | DO_AFTER_IGNORE_ACTIVE_ITEM
	default_feedback_emit = FALSE

/datum/stargazer_mindnet_ability/remove_mindlink/default_pre_do_after(datum/stargazer_mindnet_exec/exec)
	. = ..()
	if(!.)
		return
	var/mob/resolved = exec.resolve_target_mob()

/datum/stargazer_mindnet_ability/remove_mindlink/default_pre_prompt(datum/stargazer_mindnet_exec/exec)
	. = ..()
	if(!.)
		return
	var/mob/resolved = exec.resolve_target_mob()

/datum/stargazer_mindnet_ability/remove_mindlink/default_post_prompt(datum/stargazer_mindnet_exec/exec)
	. = ..()
	if(!.)
		return

#warn impl
