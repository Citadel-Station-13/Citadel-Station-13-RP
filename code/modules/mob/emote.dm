
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
	if(stat || !use_me && usr == src)
		to_chat(src, "You are unable to emote.")
		return

	var/muzzled = is_muzzled()
	if(m_type == 2 && muzzled)
		return

	var/input
	if(!message)
		input = sanitize_or_reflect(input(src,"Choose an emote to display.") as text|null, src) // Reflect too long messages, within reason.
	else
		input = message
	if(input)
		log_emote(message,src) //Log before we add junk
		//If the message starts with a comma or apostrophe, no space after the name.
		//We have to account for sanitization so we take the whole first word to see if it's a character code.
		var/nospace = GLOB.valid_starting_punctuation.Find(input)
		message = "<span class='emote'><B>[src]</B>[nospace ? "" : " "][input]</span>"
	else
		return


	if (message)
		message = say_emphasis(message)
		var/overhead_message = ("** [message] **")
		say_overhead(overhead_message, FALSE, range)

 // Hearing gasp and such every five seconds is not good emotes were not global for a reason.
 // Maybe some people are okay with that.

		var/turf/T = get_turf(src)
		if(!T) return
		var/list/in_range = get_mobs_and_objs_in_view_fast(T,range,2,remote_ghosts = client ? TRUE : FALSE)
		var/list/m_viewers = in_range["mobs"]
		var/list/o_viewers = in_range["objs"]

		for(var/mob in m_viewers)
			var/mob/M = mob
			spawn(0) // It's possible that it could be deleted in the meantime, or that it runtimes.
				if(M)
					if(istype(M, /mob/observer/dead/))
						var/mob/observer/dead/D = M
						if(ckey || (src in view(D)))
							M.show_message(message, m_type)
					else
						M.show_message(message, m_type)

		for(var/obj in o_viewers)
			var/obj/O = obj
			spawn(0)
				if(O)
					O.see_emote(src, message, m_type)

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
