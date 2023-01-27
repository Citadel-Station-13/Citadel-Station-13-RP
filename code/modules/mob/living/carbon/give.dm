/mob/living/carbon/human/verb/give(var/mob/living/carbon/target in valid_give_mobs())
	set category = "IC"
	set name = "Give"

	// TODO :  Change to incapacitated() on merge.
	if(src.stat || src.lying || src.resting || src.handcuffed)
		return
	if(!istype(target) || target.stat || target.lying || target.resting || target.handcuffed || target.client == null)
		return

	var/obj/item/I = src.get_active_held_item()
	if(!I)
		I = src.get_inactive_held_item()
	if(!I)
		to_chat(src, SPAN_WARNING("You don't have anything in your hands to give to \the [target]."))
		return

	if(alert(target,"[src] wants to give you \a [I]. Will you accept it?","Item Offer","Yes","No") == "No")
		target.visible_message("<span class='notice'>\The [src] tried to hand \the [I] to \the [target], \
		but \the [target] didn't want it.</span>")
		return

	if(!I) return

	if(!Adjacent(target))
		to_chat(src, SPAN_WARNING("You need to stay in reaching distance while giving an object."))
		to_chat(target, SPAN_WARNING("\The [src] moved too far away."))
		return

	if(I.loc != src || !is_holding(I))
		to_chat(src, SPAN_WARNING("You need to keep the item in your hands."))
		to_chat(target, SPAN_WARNING("\The [src] seems to have given up on passing \the [I] to you."))
		return

	if(target.hands_full())
		to_chat(target, SPAN_WARNING("Your hands are full."))
		to_chat(src, SPAN_WARNING("Their hands are full."))
		return

	if(transfer_item_to_loc(I, target))
		target.put_in_hands_or_drop(I) // If this fails it will just end up on the floor, but that's fitting for things like dionaea.
		target.visible_message(SPAN_NOTICE("\The [src] handed \the [I] to \the [target]."))

/mob/living/carbon/human/proc/valid_give_mobs()
	var/static/list/living_typecache = typecacheof(/mob/living)
	var/list/scan = view(1)		// lmao shitcode
	. = list()
	for(var/i in scan)
		var/mob/living/L = i
		if(!living_typecache[L.type])
			continue
		. += L
	. -= src
