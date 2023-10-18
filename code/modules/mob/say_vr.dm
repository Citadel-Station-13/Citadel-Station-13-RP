//////////////////////////////////////////////////////
////////////////////SUBTLE COMMAND////////////////////
//////////////////////////////////////////////////////

/mob/verb/me_verb_subtle(message as message) //This would normally go in say.dm
	set name = "Subtle"
	set category = "IC"
	set desc = "Emote to nearby people (and your pred/prey)"

	message = sanitize_or_reflect(message,src) // Reflect too-long messages (within reason)
	if(!message)
		return

	set_typing_indicator(FALSE)
	if(use_me)
		usr.emote_vr("me",4,message)
	else
		usr.emote_vr(message)

/mob/proc/custom_emote_vr(var/m_type=1,var/message = null) //This would normally go in emote.dm
	if(stat || !use_me && usr == src)
		to_chat(src, "You are unable to emote.")
		return

	var/muzzled = is_muzzled()
	if(m_type == 2 && muzzled) return

	var/input
	if(!message)
		input = sanitize_or_reflect(input(src,"Choose an emote to display.") as text|null, src)
	else
		input = message

	if(input)
		log_subtle(message,src)
		message = "<B>[src]</B> <I>[input]</I>"
	else
		return

	if (message)
		message = say_emphasis(message)
		SEND_SIGNAL(src, COMSIG_MOB_SUBTLE_EMOTE, src, message)

		var/list/vis = get_mobs_and_objs_in_view_fast(get_turf(src),1,2) //Turf, Range, and type 2 is emote
		var/list/vis_mobs = vis["mobs"]
		var/list/vis_objs = vis["objs"]

		for(var/vismob in vis_mobs)
			var/mob/M = vismob
			if(istype(vismob, /mob/observer))
				if(M.client && !M.client.is_preference_enabled(/datum/client_preference/subtle_see))
					continue
			spawn(0)
				M.show_message(message, SAYCODE_TYPE_ALWAYS)

		for(var/visobj in vis_objs)
			var/obj/O = visobj
			spawn(0)
				O.see_emote(src, message, 2)

		var/list/other_viewers = get_hearers_in_view(3, source = src)
		for(var/mob/M in other_viewers - vis_mobs)
			M.show_message(SPAN_SMALL("<i>[src] does something [pick("subtly", "discreetly", "hidden", "obscured")].</i>"), SAYCODE_TYPE_VISIBLE)

/mob/proc/emote_vr(var/act, var/type, var/message) //This would normally go in say.dm
	if(act == "me")
		return custom_emote_vr(type, message)

//////// SHIT COPYPASTE CODE FOR SUBTLER ANTI GHOST

/mob/verb/subtler_anti_ghost(message as message) //This would normally go in say.dm
	set name = "Subtler Anti Ghost"
	set category = "IC"
	set desc = "Emote to nearby people (and your pred/prey), but ghosts can't see it."

	message = sanitize_or_reflect(message,src) // Reflect too-long messages (within reason)
	if(!message)
		return

	set_typing_indicator(FALSE)
	run_subtler(message)

/mob/proc/run_subtler(message)
	if(stat || !use_me && usr == src)
		to_chat(src, "You are unable to emote.")
		return

	var/input
	if(!message)
		input = sanitize_or_reflect(input(src,"Choose an emote to display.") as text|null, src)
	else
		input = message

	if(input)
		log_subtle_anti_ghost(message,src)
		message = "<B>[src]</B> " + SPAN_SINGING(input)
	else
		return

	if (message)
		message = say_emphasis(message)
		SEND_SIGNAL(src, COMSIG_MOB_SUBTLE_EMOTE, src, message)

		var/list/vis = get_mobs_and_objs_in_view_fast(get_turf(src),1,2) //Turf, Range, and type 2 is emote
		var/list/vis_mobs = vis["mobs"]
		var/list/vis_objs = vis["objs"]

		for(var/vismob in vis_mobs)
			var/mob/M = vismob
			if(istype(vismob, /mob/observer))
				continue
			if(M.stat == DEAD)
				continue // get mobs and objs in view fast is shitty; say refactor will deal with that
			M.show_message(message, SAYCODE_TYPE_ALWAYS)

		for(var/visobj in vis_objs)
			var/obj/O = visobj
			O.see_emote(src, message, 2)

		var/list/other_viewers = get_hearers_in_view(3, source = src)
		for(var/mob/M in (other_viewers - vis_mobs))
			if(istype(M, /mob/observer))
				continue
			M.show_message(SPAN_SMALL("<i>[src] does something [pick("subtly", "discreetly", "hidden", "obscured")].</i>"), SAYCODE_TYPE_VISIBLE)

/////// END

//////// SHITTIER COPYPASTE CODE FOR VORE SUBTLE
/mob/living/verb/subtle_vore(message as message)
	set name = "Subtle Vore"
	set category = "Vore"
	set desc = "Emote to people within your vore holders and/or the person whos vore holder you are inside."

	message = sanitize_or_reflect(message,src) // Reflect too-long messages (within reason)
	if(!message)
		return

	set_typing_indicator(FALSE)
	run_subtle_vore(message)

/mob/living/proc/run_subtle_vore(message)
	if(stat || !use_me && usr == src)
		to_chat(src, "You are unable to emote.")
		return

	var/input
	if(!message)
		input = sanitize_or_reflect(input(src,"Choose an emote to display.") as text|null, src)
	else
		input = message

	if(input)
		log_subtle_vore(message,src)
		message = "<B>[src]</B> " + SPAN_SINGING(input)
	else
		return

	if (message)
		message = say_emphasis(message)
		SEND_SIGNAL(src, COMSIG_MOB_SUBTLE_EMOTE, src, message)

		var/list/vis_mobs = new()
		var/list/vis_objs = new()

		// if we're in a vore holder, display to everything inside
		if(istype(src.loc, /obj/belly))
			var/obj/belly/vore_holder = src.loc
			for(var/visible in vore_holder.contents)
				if(ismob(visible))
					vis_mobs.Add(visible)
				else if(isobj(visible))
					vis_objs.Add(visible)
			if(vore_holder.owner)
				vis_mobs.Add(vore_holder.owner)
		else
			// in this case we don't implicitly get added to the list
			vis_mobs.Add(src)

		// if we have vore holders, display to everything inside them (assuming there is anything)
		if(LAZYLEN(src.vore_organs))
			for(var/obj/belly/vore_holder in src.vore_organs)
				if(LAZYLEN(vore_holder.contents))
					for(var/visible in vore_holder.contents)
						if(ismob(visible))
							vis_mobs.Add(visible)
						else if(isobj(visible))
							vis_objs.Add(visible)

		for(var/vismob in vis_mobs)
			var/mob/M = vismob
			if(istype(vismob, /mob/observer))
				continue
			M.show_message(message, SAYCODE_TYPE_ALWAYS)

		for(var/visobj in vis_objs)
			var/obj/O = visobj
			O.see_emote(src, message, 2)

//////// END

#define MAX_HUGE_MESSAGE_LEN 8192
#define POST_DELIMITER_STR "\<\>"
/proc/sanitize_or_reflect(message,user)
	//Way too long to send
	if(length_char(message) > MAX_HUGE_MESSAGE_LEN)
		fail_to_chat(user)
		return

	message = sanitize(message, max_length = MAX_HUGE_MESSAGE_LEN)

	//Came back still too long to send
	if(length_char(message) > MAX_MESSAGE_LEN)
		fail_to_chat(user,message)
		return null
	else
		return message

/proc/fail_to_chat(user,message)
	if(!message)
		to_chat(user,"<span class='danger'>Your message was NOT SENT, either because it was FAR too long, or sanitized to nothing at all.</span>")
		return

	var/length = length_char(message)
	var/posts = CEILING((length/MAX_MESSAGE_LEN), 1)
	to_chat(user,message)
	to_chat(user,"<span class='danger'>^ This message was NOT SENT ^ -- It was [length] characters, and the limit is [MAX_MESSAGE_LEN]. It would fit in [posts] separate messages.</span>")
#undef MAX_HUGE_MESSAGE_LEN
