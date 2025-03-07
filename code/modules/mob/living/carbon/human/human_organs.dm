/**
 * returns if we semantically have a certain organ
 */
/mob/living/carbon/human/proc/has_organ(name)
	var/obj/item/organ/external/O = organs_by_name[name]
	return (O && !O.is_stump())

/mob/living/carbon/human/proc/recheck_bad_external_organs()
	var/damage_this_tick = getToxLoss()
	for(var/obj/item/organ/external/O in organs)
		damage_this_tick += O.burn_dam + O.brute_dam
		if(O.germ_level)
			damage_this_tick += 1 //Just tap it if we have germs so we can process those

	if(damage_this_tick > last_dam)
		. = TRUE
	last_dam = damage_this_tick

// Takes care of organ related updates, such as broken and missing limbs
/mob/living/carbon/human/proc/handle_organs(dt)

	var/force_process = recheck_bad_external_organs()

	if(force_process)
		bad_external_organs.Cut()
		for(var/obj/item/organ/external/Ex in organs)
			bad_external_organs += Ex

	//processing internal organs is pretty cheap, do that first.
	if(STAT_IS_DEAD(stat))
		//todo: internal organs list when zandario fixes it lmao
		for(var/obj/item/organ/internal/I in internal_organs)
			I.tick_death(dt)
	else
		for(var/obj/item/organ/internal/I in internal_organs)
			I.tick_life(dt)

	handle_stance()
	handle_grasp()

	if(!force_process && !bad_external_organs.len)
		return

	wound_tally = 0 // You have to reduce this at some point...
	for(var/obj/item/organ/external/E in bad_external_organs)
		if(!E)
			continue
		if(!E.need_process())
			bad_external_organs -= E
			continue
		else
			if(STAT_IS_DEAD(stat))
				E.tick_death(dt)
			else
				E.tick_life(dt)
			wound_tally += E.wound_tally

			if (!lying && !buckled && world.time - l_move_time < 15)
			//Moving around with fractured ribs won't do you any good
				if (prob(10) && !stat && can_feel_pain() && chem_effects[CE_PAINKILLER] < 50 && E.is_broken() && E.internal_organs.len)
					custom_pain("Pain jolts through your broken [E.encased ? E.encased : E.name], staggering you!", 50)
					drop_active_held_item()
					afflict_stun(20 * 2)

				//Moving makes open wounds get infected much faster
				if (length(E.wounds))
					for(var/datum/wound/W as anything in E.wounds)
						if (W.infection_check())
							W.germ_level += 1

/mob/living/carbon/human/proc/handle_stance()
	// Don't need to process any of this if they aren't standing anyways
	// unless their stance is damaged, and we want to check if they should stay down
	if (!stance_damage && (lying || resting) && (life_tick % 4) != 0)
		return

	stance_damage = 0

	// Buckled to a bed/chair. Stance damage is forced to 0 since they're sitting on something solid
	if (istype(buckled, /obj/structure/bed))
		return

	var/limb_pain
	for(var/limb_tag in list("l_leg","r_leg","l_foot","r_foot"))
		var/obj/item/organ/external/E = organs_by_name[limb_tag]
		if(!E || !E.is_usable())
			stance_damage += 2 // let it fail even if just foot&leg
		else if (E.is_malfunctioning() && !(lying || resting))
			//malfunctioning only happens intermittently so treat it as a missing limb when it procs
			stance_damage += 2
			if(isturf(loc) && prob(10))
				visible_message("\The [src]'s [E.name] [pick("twitches", "shudders")] and sparks!")
				var/datum/effect_system/spark_spread/spark_system = new ()
				spark_system.set_up(5, 0, src)
				spark_system.attach(src)
				spark_system.start()
				spawn(10)
					qdel(spark_system)
		else if (E.is_broken())
			stance_damage += 1
		else if (E.is_dislocated())
			stance_damage += 0.5

		if(E) limb_pain = E.organ_can_feel_pain()

	// Canes and crutches help you stand (if the latter is ever added)
	// One cane mitigates a broken leg+foot, or a missing foot.
	// Two canes are needed for a lost leg. If you are missing both legs, canes aren't gonna help you.
	for(var/obj/item/cane/cane as anything in get_held_items_of_type(/obj/item/cane))
		stance_damage -= 4

	// standing is poor
	if(stance_damage >= 4 || (stance_damage >= 2 && prob(5)))
		if(!(lying || resting) && !buckled && !isbelly(loc))
			if(limb_pain)
				emote_nosleep("scream")
			custom_emote(1, "collapses!")
		afflict_paralyze(20 * 5) //can't emote while weakened, apparently.

/mob/living/carbon/human/proc/handle_grasp()
	for(var/i in 1 to length(inventory?.held_items))
		var/obj/item/held = inventory.held_items[i]
		if(isnull(held))
			continue
		var/obj/item/organ/external/hand = get_hand_organ(i)
		var/obj/item/organ/external/arm = get_organ(hand.parent_organ)
		if(isnull(arm) || isnull(hand))
			visible_message("<span class='danger'>Lacking a functioning left hand, \the [src] drops \the [held].</span>")
			drop_item_to_ground(held, INV_OP_FORCE)
			continue
		if(((hand.is_broken() || hand.is_dislocated()) && !hand.splinted) || ((arm.is_broken() || arm.is_dislocated()) && !arm.splinted))
			var/emote_scream = pick("screams in pain and ", "lets out a sharp cry and ", "cries out and ")
			emote("me", 1, "[(can_feel_pain()) ? "" : emote_scream ]drops what they were holding in their [hand.name]!")
			drop_item_to_ground(held, INV_OP_FORCE)
			continue
		else if(hand.is_malfunctioning())
			emote("me", 1, "drops what they were holding, their [hand.name] malfunctioning!")
			drop_item_to_ground(held, INV_OP_FORCE)
			var/datum/effect_system/spark_spread/spark_system = new /datum/effect_system/spark_spread()
			spark_system.set_up(5, 0, src)
			spark_system.attach(src)
			spark_system.start()
			QDEL_IN(spark_system, 1 SECONDS)
		else if(arm.is_malfunctioning())
			emote("me", 1, "drops what they were holding, their [hand.name] malfunctioning!")
			drop_item_to_ground(held, INV_OP_FORCE)
			var/datum/effect_system/spark_spread/spark_system = new /datum/effect_system/spark_spread()
			spark_system.set_up(5, 0, src)
			spark_system.attach(src)
			spark_system.start()
			QDEL_IN(spark_system, 1 SECONDS)

//Handles chem traces
/mob/living/carbon/human/proc/handle_trace_chems()
	//New are added for reagents to random organs.
	for(var/datum/reagent/A in reagents.get_reagent_datums())
		var/obj/item/organ/O = pick(organs)
		O.trace_chemicals[A.name] = 100

/mob/living/carbon/human/proc/sync_organ_dna()
	var/list/all_bits = internal_organs|organs
	for(var/obj/item/organ/O in all_bits)
		O.set_dna(dna)
	reset_blood_to_species()		// make sure we have the right DNA since blood is an ""organ"" (scientists say it is!!)
