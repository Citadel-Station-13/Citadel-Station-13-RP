/obj/item/organ/internal/brain/xenochimera
	name = "neural colony"
	icon_state = "xenoch_brain"
	parent_organ = BP_TORSO

	/**
	 * Stargazer mindnet holder
	 */
	var/datum/stargazer_mindnet/xenochimera/mindnet

	organ_actions = list(
		/datum/action/organ_action/xenochimera_stargazer_mindnet_panel,
	)

/obj/item/organ/internal/brain/xenochimera/Destroy()
	QDEL_NULL(mindnet)
	return ..()

/datum/action/organ_action/xenochimera_stargazer_mindnet_panel
	target_type = /obj/item/organ/internal/brain/xenochimera

	#warn srpite
	name = "Stargazer Mindlink"
	desc = "Psychically commune with those around you."

/datum/action/organ_action/xenochimera_stargazer_mindnet_panel/invoke_target(obj/item/organ/internal/brain/xenochimera/target, datum/event_args/actor/actor)
	if(!target.mindnet)
		actor.chat_feedback(SPAN_WARNING("You don't have a mindnet anymore, somehow."))
		return TRUE
	target.mindnet.ui_interact(actor.initiator)
	return TRUE
