
/*
 * Patches. A subtype of pills, in order to inherit the possible future produceability within chem-masters, and dissolving.
 */

/obj/item/reagent_containers/pill/patch
	name = "patch"
	desc = "A patch."
	icon = 'icons/obj/medical/chemical.dmi'
	icon_state = null
	base_icon_state = "patch"
	item_state = "pill"

	possible_transfer_amounts = null
	w_class = ITEMSIZE_TINY
	slot_flags = SLOT_EARS
	volume = 60

	var/pierce_material = FALSE	// If true, the patch can be used through thick material.

//! Non-implemented Subtypes
/*
/obj/item/reagent_containers/pill/patch/libital
	name = "libital patch (brute)"
	desc = "A pain reliever. Does minor liver damage. Diluted with Granibitaluri."
	list_reagents = list(/datum/reagent/medicine/c2/libital = 2, /datum/reagent/medicine/granibitaluri = 8) //10 iterations
	icon_state = "bandaid_brute"

/obj/item/reagent_containers/pill/patch/aiuri
	name = "aiuri patch (burn)"
	desc = "Helps with burn injuries. Does minor eye damage. Diluted with Granibitaluri."
	list_reagents = list(/datum/reagent/medicine/c2/aiuri = 2, /datum/reagent/medicine/granibitaluri = 8)
	icon_state = "bandaid_burn"

/obj/item/reagent_containers/pill/patch/synthflesh
	name = "synthflesh patch"
	desc = "Helps with brute and burn injuries. Slightly toxic."
	list_reagents = list(/datum/reagent/medicine/c2/synthflesh = 20)
	icon_state = "bandaid_both"
*/
//! End ofNon-implemented Subtypes

/obj/item/reagent_containers/pill/patch/attack(mob/M as mob, mob/user as mob)
	var/mob/living/L = user

	if(M == L)
		if(istype(M, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = M
			var/obj/item/organ/external/affecting = H.get_organ(check_zone(L.zone_sel.selecting))
			if(!affecting)
				to_chat(user, SPAN_WARNING("The limb is missing!"))
				return
			if(affecting.robotic >= ORGAN_ROBOT)
				to_chat(user, SPAN_WARNING("\The [src] won't work on a robotic limb!"))
				return

			if(!H.can_inject(user, FALSE, L.zone_sel.selecting, pierce_material))
				to_chat(user, SPAN_NOTICE("\The [src] can't be applied through such a thick material!"))
				return

			if(affecting.open)// you cant place Bandaids on open surgeries, why chemical patches.
				to_chat(user, SPAN_NOTICE("The [affecting.name] is cut open, you'll need more than a bandage!"))
				return


			to_chat(H, SPAN_NOTICE("\The [src] is placed on your [affecting]."))
			M.temporarily_remove_from_inventory(src, INV_OP_FORCE)
			if(reagents.total_volume)
				reagents.trans_to_mob(M, reagents.total_volume, CHEM_TOUCH)
			qdel(src)

			for(var/datum/wound/W in affecting.wounds)
				if (W.internal)//ignore internal wounds and check the remaining
					continue
				if(W.bandaged)//already bandaged wounds dont need to be bandaged again
					continue
				W.bandage()
				break;//dont bandage more than one wound, its only one patch you can have in your stack
			affecting.update_damages()
			return TRUE

	else if(istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/affecting = H.get_organ(check_zone(L.zone_sel.selecting))
		if(!affecting)
			to_chat(user, SPAN_WARNING("The limb is missing!"))
			return

		if(affecting.robotic >= ORGAN_ROBOT)
			to_chat(user, SPAN_NOTICE("\The [src] won't work on a robotic limb!"))
			return

		if(!H.can_inject(user, FALSE, L.zone_sel.selecting, pierce_material))
			to_chat(user, SPAN_NOTICE("\The [src] can't be applied through such a thick material!"))
			return
		if(affecting.open)// you cant place Bandaids on open surgeries, why chemical patches.
			to_chat(user, SPAN_NOTICE("The [affecting.name] is cut open, you'll need more than a bandage!"))
			return

		user.visible_message(SPAN_WARNING("[user] attempts to place \the [src] onto [H]`s [affecting]."))

		user.setClickCooldown(user.get_attack_speed(src))
		if(!do_mob(user, M))
			return

		user.temporarily_remove_from_inventory(src, INV_OP_FORCE)
		user.visible_message(SPAN_WARNING("[user] applies \the [src] to [H]."))
		user.visible_message(
			SPAN_NOTICE("[user] applies \the [src] to [H]."),
			SPAN_NOTICE("You apply \the [src] to [H]."),
		)

		var/contained = reagentlist()
		add_attack_logs(user, M, "Applied a patch containing [contained]")

		to_chat(H, SPAN_NOTICE("\The [src] is placed on your [affecting]."))
		M.temporarily_remove_from_inventory(src, INV_OP_FORCE)

		if(reagents.total_volume)
			reagents.trans_to_mob(M, reagents.total_volume, CHEM_TOUCH)
		qdel(src)

		for(var/datum/wound/W in affecting.wounds)
			if (W.internal) //ignore internal wounds and check the remaining
				continue
			if(W.bandaged) //already bandaged wounds dont need to be bandaged again
				continue
			W.bandage()
			break //dont bandage more than one wound, its only one patch you can have in your stack
		affecting.update_damages()

		return TRUE
	return FALSE
