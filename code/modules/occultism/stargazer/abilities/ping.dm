//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/datum/stargazer_mindnet_ability/ping
	id = "ping"
	name = "Ping"
	desc = "Ping the targeted mind to detect if they sense you and \
	where they are."

	can_be_cooperated_while_unconscious = TRUE
	attunement_cooperative_threshold = 10
	attunement_forced_threshold = 60

	default_do_after = 1 SECONDS

	var/ping_for_time = 10 SECONDS

#warn impl; dedupe?

/datum/stargazer_mindnet_ability/ping/default_post_prompt(datum/stargazer_mindnet_exec/exec)
	if(!exec.is_cooperative)
		exec.actor?.chat_feedback(
			SPAN_WARNING("You fail to pinpoint the presence of [exec.get_target_name()]'s consciousness.")
		)
		return
	#warn ping and message

/datum/stargazer_mindnet_ability/ping/proc/create_cm_style_ping(datum/stargazer_mindnet_exec/exec)
	var/mob/locked_on = target.current


	#warn impl; 'icons/effects/motion_blip.dmi', "cm-motion", "cm-motion-offscreen"
