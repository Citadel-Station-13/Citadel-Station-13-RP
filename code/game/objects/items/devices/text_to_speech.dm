/obj/item/text_to_speech
	name = "TTS device"
	desc = "A device that speaks an inputted message. Given to crew which can not speak properly or at all."
	icon = 'icons/obj/integrated_electronics/electronic_setups.dmi'
	icon_state = "setup_small_off"
	w_class = ITEMSIZE_SMALL
	var/named
	var/activated = FALSE
	var/mob/linked_user

/obj/item/text_to_speech/attack_self(mob/user)
	. = ..()
	if(.)
		return
	if(user.incapacitated(INCAPACITATION_STUNNED)) // EDIT: We can use the device only if we are not in certain types of incapacitation. We don't want chairs stopping us from texting!!
		to_chat(user, "You cannot activate the device in your state.")
		return

	activated = !activated
	icon_state = activated ? "setup_small" : "setup_small_off"

	to_chat(user, "You [activated ? "activate" : "deactivate"] the device.")


/obj/item/text_to_speech/equipped(mob/user, slot, accessory, creation, silent)
	link_to_user(user)
	. = ..()

/obj/item/text_to_speech/unequipped(mob/user, slot, flags)
	unlink()
	. = ..()

/obj/item/text_to_speech/proc/link_to_user(mob/user)
	linked_user = user
	RegisterSignal(user, COMSIG_MOB_SAY, PROC_REF(handle_speech))
	name = "[initial(name)] ([user.real_name])"
	desc = "[initial(desc)] This one is assigned to [user.real_name]."

/obj/item/text_to_speech/proc/unlink()
	UnregisterSignal(linked_user, COMSIG_MOB_SAY)
	name = initial(name)
	desc = initial(desc)

/obj/item/text_to_speech/proc/handle_speech(datum/source, list/message_args)
	if(loc != linked_user) // this should never happen, but it's best to be safe in case an unsafe unequip happens somehow
		unlink()
	// you can't use TTS if knocked down or otherwise incapacitated
	if(linked_user.incapacitated(INCAPACITATION_STUNNED))
		return

	if(activated)
		var/message = message_args["message"]
		var/whispering = message_args["whispering"]
		message_args["cancelled"] = TRUE
		audible_message("[icon2html(thing = src, target = world)] \The [name] [whispering ? "quietly states" : "states"], \"[message]\"", null, whispering ? 2 : world.view)
		if(!whispering)
			linked_user.say_overhead(message, FALSE, MESSAGE_RANGE_COMBAT_LOUD)
		playsound(src, 'sound/items/tts/stopped_type.ogg', 25, TRUE)
