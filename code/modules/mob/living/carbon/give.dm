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
		to_chat(src, "<span class='warning'>You don't have anything in your hands to give to \the [target].</span>")
		return

	if(alert(target,"[src] wants to give you \a [I]. Will you accept it?","Item Offer","Yes","No") == "No")
		target.visible_message("<span class='notice'>\The [src] tried to hand \the [I] to \the [target], \
		but \the [target] didn't want it.</span>")
		return

	if(!I) return

	if(!Adjacent(target))
		to_chat(src, "<span class='warning'>You need to stay in reaching distance while giving an object.</span>")
		to_chat(target, "<span class='warning'>\The [src] moved too far away.</span>")
		return

	if(I.loc != src || !is_holding(I))
		to_chat(src, "<span class='warning'>You need to keep the item in your hands.</span>")
		to_chat(target, "<span class='warning'>\The [src] seems to have given up on passing \the [I] to you.</span>")
		return

	if(target.hands_full())
		to_chat(target, "<span class='warning'>Your hands are full.</span>")
		to_chat(src, "<span class='warning'>Their hands are full.</span>")
		return

	if(transfer_item_to_loc(I, target))
		target.put_in_hands_or_drop(I) // If this fails it will just end up on the floor, but that's fitting for things like dionaea.
		target.visible_message("<span class='notice'>\The [src] handed \the [I] to \the [target].</span>")

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
