// WARNING - This entire system is subject to later rewrite

// todo: way to differentiate between donor blood and host blood; we removed this functionality in the reagents rewrite.

/mob/living/carbon/human/var/datum/reagent_holder/vessel // Container for blood and BLOOD ONLY. Do not transfer other chems here.
/mob/living/carbon/human/var/var/pale = 0          // Should affect how mob sprite is drawn, but currently doesn't.

/mob/living/carbon/human/proc/assert_blood(rebuild)
	// todo: why is this separate from reagents_bloodstream?
	if(species.species_flags & NO_BLOOD)
		return

	if(isnull(vessel) || rebuild)
		vessel = new /datum/reagent_holder(species.blood_volume, src)

	// todo: ugh?
	if(!should_have_organ(O_HEART))
		return

	var/current = max(0, vessel.get_reagent_amount(/datum/reagent/blood))

	var/list/blood_data = build_blood_data()

	vessel.add_reagent(
		/datum/reagent/blood,
		species.blood_volume - current,
	)

	var/datum/reagent/blood_reagent = SSchemistry.fetch_reagent(/datum/reagent/blood)

	if(rebuild)
		vessel.reagent_datas[blood_reagent.id] = blood_data
	else
		vessel.reagent_datas[blood_reagent.id] |= blood_data


/mob/living/carbon/human/proc/build_blood_data()
	return list(
		"donor_ref" = REF(src),
		"blood_DNA" = dna.unique_enzymes,
		"blood_color" = species.get_blood_colour(src),
		"blood_type" = dna.b_type,
		"blood_name" = species.get_blood_name(src),
		"species_id" = species.id,
	)

// Takes care blood loss and regeneration
/mob/living/carbon/human/handle_blood()
	if(inStasisNow())
		return

	if(!should_have_organ(O_HEART))
		return

	var/stabilization = HAS_TRAIT(src, TRAIT_MECHANICAL_VENTILATION)
	var/mechanical_circulation = HAS_TRAIT(src, TRAIT_MECHANICAL_CIRCULATION)

	if(stat != DEAD && bodytemperature >= 170)	//Dead or cryosleep people do not pump the blood.

		var/blood_volume_raw = vessel.get_reagent_amount("blood")
		var/blood_volume = round((blood_volume_raw/species.blood_volume)*100) // Percentage.

		//Blood regeneration if there is some space
		if(blood_volume_raw < species.blood_volume)
			var/datum/reagent/blood/B = locate() in vessel.reagent_list //Grab some blood
			if(B) // Make sure there's some blood at all
				if(B.data["donor"] != src) //If it's not theirs, then we look for theirs
					for(var/datum/reagent/blood/D in vessel.reagent_list)
						if(D.data["donor"] == src)
							B = D
							break

				B.volume += 0.1 // regenerate blood VERY slowly
				if(CHEMICAL_EFFECT_BLOODRESTORE in chem_effects)
					B.volume += chem_effects[CHEMICAL_EFFECT_BLOODRESTORE]

		// Damaged heart virtually reduces the blood volume, as the blood isn't
		// being pumped properly anymore.
		if(species && should_have_organ(O_HEART) && !mechanical_circulation)
			var/obj/item/organ/internal/heart/heart = internal_organs_by_name[O_HEART]

			if(!heart)
				blood_volume = 0
			else if(heart.is_broken())
				blood_volume *= 0.3
			else if(heart.is_bruised())
				blood_volume *= 0.7
			else if(heart.damage)
				blood_volume *= 0.8

		//Effects of bloodloss
		var/dmg_coef = 1				//Lower means less damage taken
		var/threshold_coef = 1			//Lower means the damage caps off lower

		if((CHEMICAL_EFFECT_STABLE in chem_effects) || stabilization)
			dmg_coef *= 0.5
			threshold_coef *= 0.75

//	These are Bay bits, do some sort of calculation.
//			dmg_coef = min(1, 10/chem_effects[CHEMICAL_EFFECT_STABLE]) //TODO: add effect for increased damage
//			threshold_coef = min(dmg_coef / CHEMICAL_EFFECT_STABLE_THRESHOLD, 1)

		if(blood_volume_raw >= species.blood_volume*species.blood_level_safe)
			if(pale)
				pale = 0
				update_icons_body()
		else if(blood_volume_raw >= species.blood_volume*species.blood_level_warning)
			if(!pale)
				pale = 1
				update_icons_body()
				var/word = pick("dizzy", "woozy" ,"faint" ,"disoriented" ,"unsteady")
				to_chat(src, SPAN_DANGER("You feel slightly [word]"))
			if(prob(1))
				var/word = pick("dizzy","woozy","faint","disoriented","unsteady")
				to_chat(src, SPAN_BOLDDANGER("You feel [word]"))
			if(getOxyLoss() < 20 * threshold_coef)
				adjustOxyLoss(3 * dmg_coef)
		else if(blood_volume_raw >= species.blood_volume*species.blood_level_danger)
			if(!pale)
				pale = 1
				update_icons_body()
			eye_blurry = max(eye_blurry,6)
			if(getOxyLoss() < 50 * threshold_coef)
				adjustOxyLoss(10 * dmg_coef)
			adjustOxyLoss(1 * dmg_coef)
			if(prob(15))
				afflict_unconscious(20 * rand(1,3))
				var/word = pick("dizzy","woozy","faint","disoriented","unsteady")
				to_chat(src, SPAN_USERDANGER("You feel dangerously [word]"))
		else if(blood_volume_raw >= species.blood_volume*species.blood_level_fatal)
			adjustOxyLoss(5 * dmg_coef)
//			adjustToxLoss(3 * dmg_coef)
			if(prob(15))
				var/word = pick("dizzy","woozy","faint","disoriented","unsteady")
				to_chat(src, SPAN_USERDANGER("You feel extremely [word]"))
		else //Not enough blood to survive (usually)
			if(!pale)
				pale = 1
				update_icons_body()
			eye_blurry = max(eye_blurry,6)
			afflict_unconscious(20 * 3)
			adjustToxLoss(3 * dmg_coef)
			adjustOxyLoss(75 * dmg_coef) // 15 more than dexp fixes (also more than dex+dexp+tricord)

		// Without enough blood you slowly go hungry.
		if(blood_volume_raw < species.blood_volume*species.blood_level_safe)
			if(nutrition >= 300)
				nutrition -= 10
			else if(nutrition >= 200)
				nutrition -= 3

		//Bleeding out
		var/blood_max = 0
		var/blood_loss_divisor = 30.01	//lower factor = more blood loss

		// Some species bleed out differently
		blood_loss_divisor /= species.bloodloss_rate

		// Some modifiers can make bleeding better or worse.  Higher multiplers = more bleeding.
		var/blood_loss_modifier_multiplier = 1.0
		for(var/datum/modifier/M in modifiers)
			if(!isnull(M.bleeding_rate_percent))
				blood_loss_modifier_multiplier += (M.bleeding_rate_percent - 1.0)

		blood_loss_divisor /= blood_loss_modifier_multiplier


		//This 30 is the "baseline" of a cut in the "vital" regions (head and torso).
		for(var/obj/item/organ/external/temp in bad_external_organs)
			if(!(temp.status & ORGAN_BLEEDING) || (temp.robotic >= ORGAN_ROBOT))
				continue
			for(var/datum/wound/W as anything in temp.wounds)
				if(W.bleeding())
					if(W.damage_type == PIERCE) //gunshots and spear stabs bleed more
						blood_loss_divisor = max(blood_loss_divisor - 5, 1)
					else if(W.damage_type == BRUISE) //bruises bleed less
						blood_loss_divisor = max(blood_loss_divisor + 5, 1)
					//the farther you get from those vital regions, the less you bleed
					//depending on how dangerous bleeding turns out to be, it might be better to only apply the reduction to hands and feet
					if((temp.organ_tag == BP_L_ARM) || (temp.organ_tag == BP_R_ARM) || (temp.organ_tag == BP_L_LEG) || (temp.organ_tag == BP_R_LEG))
						blood_loss_divisor = max(blood_loss_divisor + 5, 1)
					else if((temp.organ_tag == BP_L_HAND) || (temp.organ_tag == BP_R_HAND) || (temp.organ_tag == BP_L_FOOT) || (temp.organ_tag == BP_R_FOOT))
						blood_loss_divisor = max(blood_loss_divisor + 10, 1)
					if(CHEMICAL_EFFECT_STABLE in chem_effects)	//Inaprov slows bloodloss
						blood_loss_divisor = max(blood_loss_divisor + 10, 1)
					if(temp.applied_pressure)
						if(ishuman(temp.applied_pressure))
							var/mob/living/carbon/human/H = temp.applied_pressure
							H.bloody_hands(src, 0)
						//somehow you can apply pressure to every wound on the organ at the same time
						//you're basically forced to do nothing at all, so let's make it pretty effective
						var/min_eff_damage = max(0, W.damage - 10) / (blood_loss_divisor / 5) //still want a little bit to drip out, for effect
						blood_max += max(min_eff_damage, W.damage - 30) / blood_loss_divisor
					else
						blood_max += W.damage / blood_loss_divisor

			if(temp.open)
				blood_max += 2 //Yer stomach is cut open
		drip(blood_max)

//Makes a blood drop, leaking amt units of blood from the mob
/mob/living/carbon/human/proc/drip(amt)
	if(!remove_blood(amt))
		return
	blood_splatter(loc, src)

/mob/living/carbon/human/proc/remove_blood(amt)
	if(!should_have_organ(O_HEART)) //TODO: Make drips come from the reagents instead.
		return 0

	if(!amt)
		return 0

	var/we_have = vessel.get_reagent_amount(/datum/reagent/blood)
	if(amt > we_have)
		amt = max(0, we_have - 1)

	// todo: why tf does mob size matter?
	return vessel.remove_reagent(/datum/reagent/blood, we_have)

/****************************************************
				BLOOD TRANSFERS
****************************************************/

/**
 * @params
 * * holder - reagent holder to transfer into
 * * amount - how much to transfer, in units
 * * filtered - if set to TRUE, we won't include stuff like bloodstream reagents.
 *
 * @return units transferred, null for impossible / nonsensical
 */
/mob/living/carbon/proc/transfer_blood_to_holder(datum/reagent_holder/holder, amount, filtered)
/mob/living/carbon/human/transfer_blood_to_holder(datum/reagent_holder/holder, amount, filtered)
	if(!should_have_organ(O_HEART))
		return null
	if(filtered)
		var/datum/reagent/casted_reagent = /datum/reagent/blood
		var/blood_id = initial(casted_reagent.id)
		return vessel.transfer_to_holder(holder, list(blood_id), amount = amount)
	else
		return vessel.transfer_to_holder(holder, amount = amount)

//Transfers blood from container ot vessels
/mob/living/carbon/proc/inject_blood(list/blood_data, amount)
	#warn impl

/mob/living/carbon/proc/inject_blood(var/datum/reagent/blood/injected, var/amount)
	if (!injected || !istype(injected))
		return
	var/list/sniffles = virus_copylist(blood_data["virus2"])
	for(var/ID in sniffles)
		var/datum/disease2/disease/sniffle = sniffles[ID]
		infect_virus2(src,sniffle,1)
	if (blood_data["antibodies"] && prob(5))
		antibodies |= blood_data["antibodies"]
	var/list/chems = list()
	chems = params2list(blood_data["trace_chem"])
	for(var/C in chems)
		src.reagents.add_reagent(C, (text2num(chems[C]) / species.blood_volume) * amount)//adds trace chemicals to owner's blood
	reagents.update_total()

/mob/living/carbon/human/inject_blood(list/blood_data, amount)
	#warn impl

	if(!should_have_organ(O_HEART))
		reagents.add_reagent("blood", amount, injected.data)
		reagents.update_total()
		return

	var/datum/reagent/blood/our = get_blood(vessel)

	if (!injected || !our)
		return
	if(blood_incompatible_legacy(blood_data["blood_type"],our.data["blood_type"],blood_data["species_id"],our.data["species_id"]) )
		reagents.add_reagent(
			/datum/reagent/toxin,
			amount * 0.5,
		)
		reagents.update_total()
	else
		vessel.add_reagent(/datum/reagent/blood, amount) // DO NOT ADD DATA, WE DO NOT WANT TO OVERWITE
	..()

/proc/blood_incompatible_legacy(donor_bloodtype, receiver_bloodtype, donor_species_id, receiver_species_id)
	if(!donor_bloodtype || !receiver_bloodtype)
		return FALSE
	if(donor_species_id && receiver_species_id && (donor_species_id != receiver_species_id))
		return TRUE

	var/donor_antigen = copytext(donor_bloodtype, 1, length(donor_bloodtype))
	var/receiver_antigen = copytext(receiver_bloodtype, 1, length(receiver_bloodtype))
	var/donor_rh = donor_bloodtype[length(donor_bloodtype)] == "+"
	var/receiver_rh = receiver_bloodtype[length(receiver_bloodtype)] == "+"

	if(donor_rh && !receiver_rh)
		return TRUE

	switch(receiver_antigen)
		if("A")
			return donor_antigen != "A" && donor_antigen != "O"
		if("AB")
		if("B")
			return donor_antigen != "B" && donor_antigen != "O"
		if("O")
			return donor_antigen != "O"
	return FALSE

/proc/blood_splatter(target, source, large)
	var/turf/where = get_turf(target)
	if(isnull(where))
		return

	#warn if source is list, it's data list

	// We're not going to splatter at all because we're in something and that's silly.
	if(istype(source,/atom/movable))
		var/atom/movable/A = source
		if(!isturf(A.loc))
			return

	var/obj/effect/debris/cleanable/blood/B
	var/decal_type = /obj/effect/debris/cleanable/blood/splatter
	var/turf/T = get_turf(target)
	var/synth = 0

	if(istype(source,/mob/living/carbon/human))
		var/mob/living/carbon/human/M = source
		if(M.isSynthetic()) synth = 1
		source = M.get_blood(M.vessel)

	// Are we dripping or splattering?
	var/list/drips = list()
	// Only a certain number of drips (or one large splatter) can be on a given turf.
	for(var/obj/effect/debris/cleanable/blood/drip/drop in T)
		drips |= drop.drips
		qdel(drop)
	if(!large && drips.len < 3)
		decal_type = /obj/effect/debris/cleanable/blood/drip

	// Find a blood decal or create a new one.
	B = locate(decal_type) in T
	if(!B)
		B = new decal_type(T)

	var/obj/effect/debris/cleanable/blood/drip/drop = B
	if(istype(drop) && drips && drips.len && !large)
		drop.add_overlay(drips)
		drop.drips |= drips

	// If there's no data to copy, call it quits here.
	if(!istype(source))
		return B

	// Update appearance.
	if(source.data["blood_color"])
		B.basecolor = source.data["blood_color"]
		B.synthblood = synth
		B.update_icon()

	if(source.data["blood_name"])
		B.name = source.data["blood_name"]

	// Update blood information.
	if(source.data["blood_DNA"])
		B.blood_DNA = list()
		if(source.data["blood_type"])
			B.blood_DNA[source.data["blood_DNA"]] = source.data["blood_type"]
		else
			B.blood_DNA[source.data["blood_DNA"]] = "O+"

	// Update virus information.
	if(source.data["virus2"])
		B.virus2 = virus_copylist(source.data["virus2"])

	B.fluorescent  = 0
	B.invisibility = 0
	return B
