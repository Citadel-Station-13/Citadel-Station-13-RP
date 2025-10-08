
/**
 * Legacy below
 */

/mob/proc/emote(var/act, var/type, var/message)
	SHOULD_NOT_OVERRIDE(TRUE)
	#warn impl


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

/// Deprecated.
/mob/proc/visible_emote(var/act_desc)
	run_custom_emote(act_desc, saycode = SAYCODE_TYPE_VISIBLE)

/// Deprecated.
/mob/proc/audible_emote(var/act_desc)
	run_custom_emote(act_desc, saycode = SAYCODE_TYPE_AUDIBLE)

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
