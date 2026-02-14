//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/datum/stargazer_mindnet_ability/commune
	id = "commune"
	name = "Commune"
	desc = "Send a message to a targeted mind, potentially receiving their thoughts \
	back towards you."

	can_be_cooperated_while_unconscious = TRUE
	attunement_cooperative_threshold = 7.5
	attunement_forced_threshold = 40

	/// brain biologies that can be transmitted to at all
	var/compatible_brain_biology_types = BIOLOGY_TYPES_ALL
	/// brain biologies that results in garbled transmission
	var/garbled_brain_biology_types = BIOLOGY_TYPES_SYNTHETIC

	#warn a way to tell it's them without a name??
	/// %%INPUT%%, will be replaced in this string.
	var/default_text_pattern = SPAN_ALIEN_CONST("You feel the distinctly alien voice permeate your mind: <b>%%INPUT%%</b>")
	/// %%INPUT%%, %%TARGET%% will be replaced in this string.
	var/default_response_pattern = SPAN_ALIEN_CONST("You feel %%TARGET%% echo a response: <b>%%INPUT%%</b>")

#warn log ocmmune

/datum/stargazer_mindnet_ability/commune/proc/format_user_input(datum/stargazer_mindnet_exec/exec, dangerously_unsanitized_input)
	return string_format(default_text_pattern, list("INPUT" = html_encode(dangerously_unsanitized_input)))

#warn impl

/datum/stargazer_mindnet_ability/commune/proc/format_target_response(datum/stargazer_mindnet_exec/exec, dangerously_unsanitized_input)

/datum/stargazer_mindnet_ability/commune/proc/on_received(datum/event_args/actor/actor, datum/stargazer_mindnet/mindnet, list/blackboard, datum/mind/target)

/datum/stargazer_mindnet_ability/commune/default_pre_prompt(datum/event_args/actor/actor, datum/stargazer_mindnet/mindnet, list/blackboard, datum/mind/target, datum/stargazer_mindnet_exec/exec)
	. = ..()
	var/unsanitized_user_message = tgui_input_text(actor.initiator, "What do you want to telepathically tell [target_name]?", "Stargazer Commune", "", 8192, TRUE, FALSE, 2 MINUTES)

/datum/stargazer_mindnet_ability/commune/default_post_prompt(datum/event_args/actor/actor, datum/stargazer_mindnet/mindnet, list/blackboard, datum/mind/target, datum/stargazer_mindnet_exec/exec)
	. = ..()

	var/mob/receiving_mob = target.get_active_game_mob()

	exec.on_unhandled_topic = CALLBACK(src, PROC_REF(on_exec_receiv_topic))

/datum/stargazer_mindnet_ability/commune/proc/on_exec_receiv_topic(datum/stargazer_mindnet_exec/exec, mob/user, list/href_list)

/datum/stargazer_mindnet_ability/commune/xenochimera
	default_text_pattern = SPAN_INTERFACE_CONST("Like lead slabs crashing into the ocean, alien thoughts drop into your mind: <b>%%INPUT%%</b>")
	var/default_chimera_text_pattern = SPAN_DANGER_CONST("You feel an alien, yet familiar thought seep into your collective consciousness: " + SPAN_NOTICE_CONST("<b></b>"))

/datum/stargazer_mindnet_ability/commune/xenochimera/format_user_input(datum/event_args/actor/actor, datum/stargazer_mindnet/mindnet, list/blackboard, datum/mind/target, dangerously_unsanitized_input)
	if(iscarbon(target.current))
		var/mob/living/carbon/current = target.current
		// TODO: check if brain is chimeric
		if(current.species?.id == /datum/species/shapeshifter/xenochimera::id)
			return string_format(default_chimera_text_pattern, list("INPUT" = html_encode(dangerously_unsanitized_input)))
	return ..()
