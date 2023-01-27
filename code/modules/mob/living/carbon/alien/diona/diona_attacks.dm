/mob/living/carbon/alien/diona/OnMouseDropLegacy(var/atom/over_object)
	var/mob/living/carbon/human/H = over_object
	if(!istype(H) || !Adjacent(H))
		return ..()
	if(H.a_intent == "grab" && hat && !H.hands_full())
		H.put_in_hands_or_drop(hat)
		H.visible_message(SPAN_DANGER("\The [H] removes \the [src]'s [hat]."))
		hat = null
		updateicon()
	else
		return ..()

/mob/living/carbon/alien/diona/attackby(var/obj/item/W, var/mob/user)
	if(user.a_intent == "help" && istype(W, /obj/item/clothing/head))
		if(hat)
			to_chat(user, SPAN_WARNING("\The [src] is already wearing \the [hat]."))
			return
		if(!user.attempt_insert_item_for_installation(W, src))
			return
		wear_hat(W)
		user.visible_message(SPAN_NOTICE("\The [user] puts \the [W] on \the [src]."))
		return CLICKCHAIN_DO_NOT_PROPAGATE
	return ..()
