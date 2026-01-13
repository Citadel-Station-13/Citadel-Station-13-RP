//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/datum/stargazer_mindnet_ability/commune
	id = "commune"
	name = "Commune"
	desc = "Send a message to a targeted mind, potentially receiving their thoughts \
	back towards you."

	/// brain biologies that can be transmitted to at all
	var/compatible_brain_biology_types = BIOLOGY_TYPES_ALL
	/// brain biologies that results in garbled transmission
	var/garbled_brain_biology_types = BIOLOGY_TYPES_SYNTHETIC

	#warn a way to tell it's them without a name??
	/// %%INPUT%%, will be replaced in this string.
	var/default_text_pattern = SPAN_ALIEN("You feel the distinctly alien voice permeate your mind: <b>%%INPUT%%</b>")
	/// %%INPUT%%, %%TARGET%% will be replaced in this string.
	var/default_response_pattern = SPAN_ALIEN("You feel %%TARGET%% echo a response: <b>%%INPUT%%</b>")

#warn log ocmmune

/datum/stargazer_mindnet_ability/commune/proc/format_user_input(datum/event_args/actor/actor, datum/stargazer_mindnet/mindnet, list/blackboard, datum/mind/target, dangerously_unsanitized_input)
	return string_format(default_text_pattern, list("INPUT" = html_encode(dangerously_unsanitized_input)))

#warn impl

/datum/stargazer_mindnet_ability/commune/proc/on_received(datum/event_args/actor/actor, datum/stargazer_mindnet/mindnet, list/blackboard, datum/mind/target)

/datum/stargazer_mindnet_ability/commune/proc/format_target_response(datum/event_args/actor/actor, datum/stargazer_mindnet/mindnet, list/blackboard, datum/mind/target, dangerously_unsanitized_input)



/datum/stargazer_mindnet_ability/commune/xenochimera
	default_text_pattern = {"[SPAN_INTERFACE("Like lead slabs crashing into the ocean, alien thoughts drop into your mind: <b>%%INPUT%%</b>")]"}
	var/default_chimera_text_pattern = SPAN_DANGER("You feel an alien, yet familiar thought seep into your collective consciousness: [SPAN_NOTICE("<b></b>")"]")

/datum/stargazer_mindnet_ability/commune/xenochimera/format_user_input(datum/event_args/actor/actor, datum/stargazer_mindnet/mindnet, list/blackboard, datum/mind/target, dangerously_unsanitized_input)
	if(iscarbon(target.current))
		var/mob/living/carbon/current = target.current
		if(current.species?.id == /datum/species/shapeshifter/xenochimera::id)
			return string_format(default_chimera_text_pattern, list("INPUT" = html_encode(dangerously_unsanitized_input)))
	return ..()
