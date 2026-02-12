//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/datum/stargazer_mindnet_ability/mindlink
	id = "mindlink"
	name = "Mindlink"
	/// much like MMIs, the description hides the horrors of what this actually is.
	desc = "Imprint your neural patterns on this mind, creating a more lasting attunement."

	can_be_cooperated_while_unconscious = TRUE

	// pretty much requires a full grab
	attunement_cooperative_threshold = 60
	enforce_reachability = TRUE

	default_do_after = 8 SECONDS
	default_do_after_flags = DO_AFTER_IGNORE_MOVEMENT | DO_AFTER_IGNORE_ACTIVE_ITEM

	default_feedback_emit = FALSE

	var/backfire_on_resist = TRUE
	/**
	 * Break the hold on the target if distance goes past this.
	 * * 0 = same tile, 1 = adjacent, null = **reachability**
	 * * Note that reachability is not the same as say, a grab or a hold.
	 */
	#warn impl
	var/enforce_target_prompt_distance = null

	cooldown_global = 15 SECONDS

/datum/stargazer_mindnet_ability/mindlink/default_pre_do_after(datum/stargazer_mindnet_exec/exec)
	. = ..()
	if(!.)
		return
	var/mob/resolved = exec.resolve_target_mob()
	if(exec.actor.performer.Reachability(resolved))
		exec.actor.visible_feedback(
			target = resolved,
			otherwise_self = SPAN_WARNING("You put your hands on [resolved], and you feel their consciousness ripple under yours."),
			visible = SPAN_WARNING("[exec.actor.performer] puts [exec.actor.performer.p_their()] hands on [resolved]. [resolved]'s movements briefly subside under [exec.actor.performer]'s intense concentration.")
		)
	else
		exec.actor.visible_feedback(
			target = resolved,
			otherwise_self = SPAN_WARNING("You concentrate intensely on [resolved], and you feel their consciousness ripple under yours."),
			visible = SPAN_WARNING("[exec.actor.performer] focuses intensely upon [resolved]. [resolved]'s movements briefly subside.")
		)

/datum/stargazer_mindnet_ability/mindlink/default_pre_prompt(datum/stargazer_mindnet_exec/exec)
	. = ..()
	if(!.)
		return
	var/mob/resolved = exec.resolve_target_mob()
	exec.actor.visible_feedback(
		target = resolved,
		otherwise_self = SPAN_WARNING("Your mind bridges with [resolved]'s own. [resolved.p_they()] grow still."),
		visible = SPAN_WARNING("[resolved] falls eerily still under [exec.actor.performer]'s concentration.")
	)

	// restrain them
	ADD_TRAIT(resolved, TRAIT_MOBILITY_MOVE_BLOCKED, TRAIT_SOURCE_STARGAZER_MINDNET_ABILITY(id))
	ADD_TRAIT(resolved, TRAIT_MOBILITY_STAND_BLOCKED, TRAIT_SOURCE_STARGAZER_MINDNET_ABILITY(id))
	ADD_TRAIT(resolved, TRAIT_MOBILITY_USE_BLOCKED, TRAIT_SOURCE_STARGAZER_MINDNET_ABILITY(id))
	ADD_TRAIT(resolved, TRAIT_MOBILITY_UI_BLOCKED, TRAIT_SOURCE_STARGAZER_MINDNET_ABILITY(id))
	ADD_TRAIT(resolved, TRAIT_MOBILITY_RESIST_BLOCKED, TRAIT_SOURCE_STARGAZER_MINDNET_ABILITY(id))
	REMOVE_TRAIT_IN(resolved, TRAIT_MOBILITY_MOVE_BLOCKED, TRAIT_SOURCE_STARGAZER_MINDNET_ABILITY(id), 15 SECONDS)
	REMOVE_TRAIT_IN(resolved, TRAIT_MOBILITY_STAND_BLOCKED, TRAIT_SOURCE_STARGAZER_MINDNET_ABILITY(id), 15 SECONDS)
	REMOVE_TRAIT_IN(resolved, TRAIT_MOBILITY_USE_BLOCKED, TRAIT_SOURCE_STARGAZER_MINDNET_ABILITY(id), 15 SECONDS)
	REMOVE_TRAIT_IN(resolved, TRAIT_MOBILITY_UI_BLOCKED, TRAIT_SOURCE_STARGAZER_MINDNET_ABILITY(id), 15 SECONDS)
	REMOVE_TRAIT_IN(resolved, TRAIT_MOBILITY_RESIST_BLOCKED, TRAIT_SOURCE_STARGAZER_MINDNET_ABILITY(id), 15 SECONDS)

/datum/stargazer_mindnet_ability/mindlink/default_post_prompt(datum/stargazer_mindnet_exec/exec)
	. = ..()
	if(!.)
		return

	var/mob/resolved = exec.resolve_target_mob()
	REMOVE_TRAIT(resolved, TRAIT_MOBILITY_MOVE_BLOCKED, TRAIT_SOURCE_STARGAZER_MINDNET_ABILITY(id))
	REMOVE_TRAIT(resolved, TRAIT_MOBILITY_STAND_BLOCKED, TRAIT_SOURCE_STARGAZER_MINDNET_ABILITY(id))
	REMOVE_TRAIT(resolved, TRAIT_MOBILITY_USE_BLOCKED, TRAIT_SOURCE_STARGAZER_MINDNET_ABILITY(id))
	REMOVE_TRAIT(resolved, TRAIT_MOBILITY_UI_BLOCKED, TRAIT_SOURCE_STARGAZER_MINDNET_ABILITY(id))
	REMOVE_TRAIT(resolved, TRAIT_MOBILITY_RESIST_BLOCKED, TRAIT_SOURCE_STARGAZER_MINDNET_ABILITY(id))

	resolved.invoke_emote("gasp")
	if(exec.is_cooperative)
		// cooperated, perform the link
		resolved.innate_feedback(SPAN_ALIEN("Your mind reels before drifting with [exec.actor.performer]'s consciousness. \
		You realize you feel their presence in the back of your head, somehow."))
		exec.actor.chat_feedback(
			SPAN_ALIEN("You link your mind with [resolved]'s own, bringing their consciousness into your mind's field of influence. \
			Stargazer abilities may now be used at longer range or with less restrictions when targeting [resolved], \
			and you are now able to sense their presence at immense distances."),
		)
		var/datum/stargazer_mindnet_link/mind_link = exec.mindnet.get_or_create_mind_link(exec.target_mind)
		mind_link.established_at = world.time
		// look sir! free name update
		mind_link.known_name = resolved.real_name
	else
		// not cooperative, invalidated, etc.
		// or maybe just disconnected or forgot to press the chat prompt.
		if(backfire_on_resist)
			// fun ensues. unfortunately, this can't be too fun, because it just neuralquaking would be comedic.
			resolved.innate_feedback(SPAN_DANGER("You violently push back against [exec.actor.performer]'s intrusion into your mind, \
			creating a surge of psionic energy."))
			exec.actor.visible_feedback(
				visible = SPAN_DANGER("[exec.actor.performer] jerks backwards away from [resolved]."),
				otherwise_self = SPAN_DANGER("You jerk away from [resolved], the backscatter of psionic energy piercing your head. \
				Ouch.")
			)
			exec.actor.performer.invoke_emote("gasp")
			exec.actor.performer.default_combat_knockdown(3 SECONDS)
			if(isliving(exec.actor.performer))
				var/mob/living/casted_performer = exec.actor.performer
				casted_performer.adjustHalLoss(35)
		else
			resolved.innate_feedback(SPAN_WARNING("You push back against [exec.actor.performer]'s intrusion into your mind, and the presence subsides."))
			exec.actor.chat_feedback(
				SPAN_WARNING("[resolved] pushes back against your intrusion into their mind, and you withdraw."),
			)
