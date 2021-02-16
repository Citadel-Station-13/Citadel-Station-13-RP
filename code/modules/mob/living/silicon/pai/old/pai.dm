/mob/living/silicon/pai


/mob/living/silicon/pai/verb/fold_out()
	set category = "pAI Commands"
	set name = "Unfold Chassis"

	if(stat || sleeping || paralysis || weakened)
		return

	if(src.loc != card)
		return

	if(world.time <= last_special)
		return

	last_special = world.time + 100

	//I'm not sure how much of this is necessary, but I would rather avoid issues.
	if(istype(card.loc,/obj/item/rig_module))
		to_chat(src, "There is no room to unfold inside this rig module. You're good and stuck.")
		return 0
	else if(istype(card.loc,/mob))
		var/mob/holder = card.loc
		var/datum/belly/inside_belly = check_belly(card) //VOREStation edit.
		if(inside_belly) //VOREStation edit.
			to_chat(src, "<span class='notice'>There is no room to unfold in here. You're good and stuck.</span>") //VOREStation edit.
			return 0 //VOREStation edit.
		if(ishuman(holder))
			var/mob/living/carbon/human/H = holder
			for(var/obj/item/organ/external/affecting in H.organs)
				if(card in affecting.implants)
					affecting.take_damage(rand(30,50))
					affecting.implants -= card
					H.visible_message("<span class='danger'>\The [src] explodes out of \the [H]'s [affecting.name] in shower of gore!</span>")
					break
		holder.drop_from_inventory(card)
	else if(istype(card.loc,/obj/item/pda))
		var/obj/item/pda/holder = card.loc
		holder.pai = null

	src.client.perspective = EYE_PERSPECTIVE
	src.client.eye = src
	src.forceMove(get_turf(card))

	card.forceMove(src)
	card.screen_loc = null
