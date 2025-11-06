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
	if(stat)
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

#define MAX_HUGE_MESSAGE_LEN 8192
#define POST_DELIMITER_STR "\<\>"
// TODO: NUKE THIS PROC!!
/proc/sanitize_or_reflect(message, user, encode)
	//Way too long to send
	if(length_char(message) > MAX_HUGE_MESSAGE_LEN)
		fail_to_chat(user, null)
		return

	message = sanitize(message, max_length = MAX_HUGE_MESSAGE_LEN, encode = encode)

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
