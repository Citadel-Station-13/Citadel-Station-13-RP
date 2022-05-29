//Please make sure to:
//return FALSE: You are not going away, stop asking me to digest.
//return non-negative integer: Amount of nutrition/charge gained (scaled to nutrition, other end can multiply for charge scale).

// Ye default implementation.
/obj/item/proc/digest_act(var/atom/movable/item_storage = null)
	if(istype(item_storage,/obj/item/dogborg/sleeper))
		for(var/obj/item/O in contents)
			if(istype(O,/obj/item/storage/internal)) //Dump contents from dummy pockets.
				for(var/obj/item/SO in O)
					if(item_storage)
						SO.forceMove(item_storage)
					qdel(O)
			else if(item_storage)
				O.forceMove(item_storage)
		qdel(src)
		return w_class
	var/g_damage = 1
	if(digest_stage == null)
		digest_stage = w_class
	if(isbelly(item_storage))
		var/obj/belly/B = item_storage
		g_damage = 0.25 * (B.digest_brute + B.digest_burn)
	if(digest_stage > 0)
		if(g_damage > digest_stage)
			g_damage = digest_stage
		digest_stage -= g_damage
	else
		for(var/obj/item/O in contents)
			if(istype(O,/obj/item/storage/internal)) //Dump contents from dummy pockets.
				for(var/obj/item/SO in O)
					if(item_storage)
						SO.forceMove(item_storage)
					qdel(O)
			else if(item_storage)
				O.forceMove(item_storage)
		qdel(src)
	return g_damage

/////////////
// Some indigestible stuff
/////////////
/obj/item/hand_tele/digest_act(var/atom/movable/item_storage = null)
	return FALSE
/obj/item/card/id/gold/captain/spare/digest_act(var/atom/movable/item_storage = null)
	return FALSE
/obj/item/aicard/digest_act(var/atom/movable/item_storage = null)
	return FALSE
/obj/item/paicard/digest_act(var/atom/movable/item_storage = null)
	return FALSE
/obj/item/gun/digest_act(var/atom/movable/item_storage = null)
	return FALSE
/obj/item/pinpointer/digest_act(var/atom/movable/item_storage = null)
	return FALSE
/obj/item/blueprints/digest_act(var/atom/movable/item_storage = null)
	return FALSE
/obj/item/disk/nuclear/digest_act(var/atom/movable/item_storage = null)
	return FALSE
/obj/item/perfect_tele_beacon/digest_act(var/atom/movable/item_storage = null)
	return FALSE //Sorta important to not digest your own beacons.
/obj/item/organ/internal/brain/slime/digest_act(var/atom/movable/item_storage = null)
	return FALSE //so prometheans can be recovered

/////////////
// Some special treatment
/////////////
//PDAs need to lose their ID to not take it with them, so we can get a digested ID
/obj/item/pda/digest_act(var/atom/movable/item_storage = null)
	if(id)
		if(istype(item_storage,/obj/item/dogborg/sleeper) || (!isnull(digest_stage) && digest_stage <= 0))
			id = null
	. = ..()

/obj/item/card/id
	var/lost_access = list()

/obj/item/card/id/digest_act(var/atom/movable/item_storage = null)
	desc = "A partially digested card that has seen better days. The damage appears to be only cosmetic, but the access codes need to be reprogrammed at the HoP office."
	icon = 'icons/obj/card_vr.dmi'
	icon_state = "[initial(icon_state)]_digested"
	if(!(LAZYLEN(lost_access)) && LAZYLEN(access))
		lost_access = access	//Do not forget what access we lose
	access = list()			// Then lose it
	return FALSE

/obj/item/reagent_containers/food/digest_act(var/atom/movable/item_storage = null)
	if(isbelly(item_storage))
		var/obj/belly/B = item_storage
		if(ishuman(B.owner))
			var/mob/living/carbon/human/H = B.owner
			reagents.trans_to_holder(H.ingested, (reagents.total_volume * 0.3), 1, 0)
		else if(isrobot(B.owner))
			var/mob/living/silicon/robot/R = B.owner
			R.cell.charge += 150
		qdel(src)
		return w_class
	. = ..()

/obj/item/holder/digest_act(var/atom/movable/item_storage = null)
	for(var/mob/living/M in contents)
		if(item_storage)
			M.forceMove(item_storage)
	held_mob = null

	. = ..()

/obj/item/organ/digest_act(var/atom/movable/item_storage = null)
	if((. = ..()))
		if(isbelly(item_storage))
			var/obj/belly/B = item_storage
			. += 2 * (B.digest_brute + B.digest_burn)
		else
			. += 30 //Organs give a little more

/obj/item/storage/digest_act(var/atom/movable/item_storage = null)
	for(var/obj/item/I in contents)
		I.screen_loc = null

	. = ..()

/////////////
// Some more complicated stuff
/////////////
/obj/item/mmi/digital/posibrain/digest_act(var/atom/movable/item_storage = null)
	//Replace this with a pref setting so all types of posibrains can/can't be digested on a whim
	return FALSE

// Gradual damage measurement
/obj/item
	var/digest_stage = null
