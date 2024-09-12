
//* Emote Module *//
/**
 * Specifically for invoking /datum/emote
 *
 * 'custom emotes' aka 'say'd actions' are not handled by this system.
 */

/**
 * Description WIP
 */
/mob/proc/invoke_emote(key, raw_parameter_string, datum/event_args/actor/actor)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(isnull(actor))
		actor = new(src)
	else if(isnull(actor.performer))
		actor.performer = src
	ASSERT(actor.performer == src)

	var/special_result = process_emote_special(key, raw_parameter_string, actor)
	if(!isnull(special_result))
		return special_result

	#warn impl

/**
 * @return TRUE if successful
 */
/mob/proc/process_emote(datum/emote/emote, raw_parameter_string, datum/event_args/actor/actor)
	#warn impl

/**
 * Process legacy emotes
 *
 * @return TRUE or FALSE if handled, based on success / failure, and `null` if not handled.
 */
/mob/proc/process_emote_special(key, raw_parameter_string, datum/event_args/actor/actor)
	return

/**
 * Return a list of /datum/emote's we can use
 */
/mob/proc/query_emote()
	RETURN_TYPE(/list)
	. = list()
	#warn impl

/**
 * Return a list of legacy emotes associated to descriptions or null
 */
/mob/proc/query_emote_special()
	RETURN_TYPE(/list)
	return list(
		"me" = "Input a custom emote for your character to perform.",
	)

/**
 * Faster version of /datum/emote/can_use()
 *
 * Use against a list of emotes.
 */
/mob/proc/filter_usable_emotes(list/datum/emote/emotes = GLOB.emotes, check_mobility)
	. = list()

	var/our_emote_class = get_usable_emote_class()
	var/our_emote_require = get_usable_emote_require()
	var/datum/event_args/actor/actor = new(src)

	for(var/datum/emote/emote as anything in emotes)
		var/special_check = emote.can_use_special(actor)
		if(!isnull(special_check))
			if(special_check)
				. += emote
			continue
		if(check_mobility && !(mobility_flags & emote.required_mobility_flags))
			continue
		if(!(our_emote_class & emote.emote_class))
			continue
		if(!(our_emote_require & emote.emote_require))
			continue
		. += emote

/**
 * Return emote classes we support.
 */
/mob/proc/get_usable_emote_class()
	return emote_class

/**
 * Return remote require flags we support
 */
/mob/proc/get_usable_emote_require()
	#warn impl

#warn below

/**
 * Legacy below
 */

/mob/proc/emote(var/act, var/type, var/message)
	SHOULD_NOT_OVERRIDE(TRUE)

// All mobs should have custom emote, really..
//m_type == 1 --> visual.
//m_type == 2 --> audible
/mob/proc/custom_emote(var/m_type=1,var/message = null,var/range=world.view)
	SHOULD_NOT_OVERRIDE(TRUE)

// Shortcuts for above proc
/mob/proc/visible_emote(var/act_desc)
	custom_emote(1, act_desc)

/mob/proc/audible_emote(var/act_desc)
	custom_emote(2, act_desc)

/mob/proc/emote_dead(var/message)

	if(client.prefs.muted & MUTE_DEADCHAT)
		to_chat(src, "<span class='danger'>You cannot send deadchat emotes (muted).</span>")
		return

	if(!get_preference_toggle(/datum/game_preference_toggle/chat/dsay))
		to_chat(src, "<span class='danger'>You have deadchat muted.</span>")
		return

	if(!src.client.holder)
		if(!config_legacy.dsay_allowed)
			to_chat(src, "<span class='danger'>Deadchat is globally muted.</span>")
			return

	if(is_role_banned_ckey(ckey, role = BAN_ROLE_OOC))
		to_chat(src, SPAN_WARNING("You are banned from OOC and deadchat."))
		return

	var/input
	if(!message)
		input = sanitize_or_reflect(input(src, "Choose an emote to display.") as text|null, src) // Reflect too long messages, within reason
	else
		input = message

	input = emoji_parse(say_emphasis(input))

	if(input)
		log_ghostemote(input, src)
		if(!invisibility) //If the ghost is made visible by admins or cult. And to see if the ghost has toggled its own visibility, as well. -Mech
			visible_message(SPAN_DEADSAY("<B>[src]</B> [input]"))
		else
			say_dead_direct(input, src)
