/mob/living/carbon/human/mouse_drop_strip_interaction(mob/user)
	// don't collide with riding
	if(user.check_grab(src) == GRAB_PASSIVE && user.a_intent == INTENT_GRAB && lying)
		return
	return ..()

/mob/living/carbon/human/strip_menu_options(mob/user)
	. = ..()
	.["splints"] = "Remove Splints"
	if(strip_menu_check_valid_internals_items())
		.["internals"] = "Toggle Internals"

/mob/living/carbon/human/strip_menu_act(mob/user, action)
	. = ..()
	switch(action)
		if("splints")
			return try_remove_splints(user)
		if("internals")
			return try_toggle_internals(user)

/mob/living/carbon/human/proc/try_remove_splints(mob/user)
	visible_message(
		SPAN_WARNING("[user] is trying to remove [src]'s splints!"),
		SPAN_WARNING("[user] is trying to remove your splints!")
	)
	if(!do_after(user, HUMAN_STRIP_DELAY, src))
		return FALSE
	remove_splints(user)
	return TRUE

// Remove all splints.
/mob/living/carbon/human/proc/remove_splints(var/mob/living/user)

	var/can_reach_splints = 1
	if(istype(wear_suit,/obj/item/clothing/suit/space))
		var/obj/item/clothing/suit/space/suit = wear_suit
		if(suit.supporting_limbs && suit.supporting_limbs.len)
			to_chat(user, "<span class='warning'>You cannot remove the splints - [src]'s [suit] is supporting some of the breaks.</span>")
			can_reach_splints = 0

	if(can_reach_splints)
		var/removed_splint
		for(var/obj/item/organ/external/o in organs)
			if (o && o.splinted)
				var/obj/item/S = o.splinted
				if(istype(S) && S.loc == o) //can only remove splints that are actually worn on the organ (deals with hardsuit splints)
					S.add_fingerprint(user)
					if(o.remove_splint())
						user.put_in_active_hand(S)
						removed_splint = 1
		if(removed_splint)
			visible_message("<span class='danger'>\The [user] removes \the [src]'s splints!</span>")
			add_attack_logs(user, src, "removed splints")
		else
			to_chat(user, "<span class='warning'>\The [src] has no splints to remove.</span>")

/mob/living/carbon/human/proc/try_toggle_internals(mob/user)
	visible_message(
		SPAN_WARNING("[user] is trying to toggle [src]'s internals!"),
		SPAN_WARNING("[user] is trying to toggle your internals!")
	)
	if(!do_after(user, HUMAN_STRIP_DELAY, src))
		return FALSE
	toggle_internals(user)
	return TRUE

// Set internals on or off.
/mob/living/carbon/human/proc/toggle_internals(var/mob/living/user)
	if(internal)
		internal.add_fingerprint(user)
		internal = null
		if(internals)
			internals.icon_state = "internal0"
	else
		// Check for airtight mask/helmet.
		if(!(istype(wear_mask, /obj/item/clothing/mask) || istype(head, /obj/item/clothing/head/helmet/space)))
			return
		// Find an internal source.
		if(istype(back, /obj/item/tank))
			internal = back
		else if(istype(s_store, /obj/item/tank))
			internal = s_store
		else if(istype(belt, /obj/item/tank))
			internal = belt

	if(internal)
		visible_message("<span class='warning'>\The [src] is now running on internals!</span>")
		internal.add_fingerprint(user)
		if (internals)
			internals.icon_state = "internal1"
		add_attack_logs(user, src, "turned on internals")
	else
		visible_message("<span class='danger'>\The [user] disables \the [src]'s internals!</span>")
		add_attack_logs(user, src, "turned off internals")

/mob/living/carbon/human/proc/strip_menu_check_valid_internals_items()
	// todo: proper CLOTHING_ALLOW_INTERNALS flag checks lmao
	if(istype(wear_mask, /obj/item/clothing/mask) || istype(head, /obj/item/clothing/head/helmet/space))
		if(istype(back, /obj/item/tank) || istype(belt, /obj/item/tank) || istype(s_store, /obj/item/tank))
			return TRUE
	return FALSE
