/obj/item/assembly/voice
	name = "voice analyzer"
	desc = "A small electronic device able to record a voice sample, and send a signal when that sample is repeated."
	icon_state = "voice"
	atom_flags = ATOM_HEAR
	origin_tech = list(TECH_MAGNET = 1)
	materials = list(MAT_STEEL = 500, MAT_GLASS = 50)
	var/listening = 0
	var/recorded	//the activation message

/obj/item/assembly/voice/hear_say(raw_message, message, name, voice_ident, atom/movable/actor, remote, datum/language/lang, list/spans, list/params)
	. = ..()
	if(listening)
		recorded = message
		listening = 0
		var/turf/T = get_turf(src)	//otherwise it won't work in hand
		T.visible_message("[icon2html(thing = src, target = world)] beeps, \"Activation message is '[recorded]'.\"")
	else if(recorded)
		if(findtext(message, recorded))
			pulse(0)

/obj/item/assembly/voice/activate()
	if(secured)
		if(!holder)
			listening = !listening
			var/turf/T = get_turf(src)
			T.visible_message("[icon2html(thing = src, target = world)] beeps, \"[listening ? "Now" : "No longer"] recording input.\"")


/obj/item/assembly/voice/attack_self(mob/user)
	. = ..()
	if(.)
		return
	if(!user)
		return FALSE
	activate()
	return TRUE

/obj/item/assembly/voice/toggle_secure()
	. = ..()
	listening = 0
