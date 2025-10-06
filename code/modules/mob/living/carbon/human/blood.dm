/****************************************************
				BLOOD SYSTEM
****************************************************/
//Blood levels. These are percentages based on the species blood_volume var.
//Retained for archival/reference purposes - KK
/*
var/const/BLOOD_VOLUME_SAFE =    85
var/const/BLOOD_VOLUME_OKAY =    75
var/const/BLOOD_VOLUME_BAD =     60
var/const/BLOOD_VOLUME_SURVIVE = 40
var/const/CE_STABLE_THRESHOLD = 0.5
*/

/mob/living/carbon/human/var/var/pale = 0          // Should affect how mob sprite is drawn, but currently doesn't.

/mob/living/carbon/human/proc/reset_blood_to_species_if_needed(do_not_regenerate)
	if(species.species_flags & NO_BLOOD)
		return
	if(!should_have_organ(O_HEART))
		return
	reset_blood_to_species(do_not_regenerate)

// Takes care blood loss and regeneration
/mob/living/carbon/human/handle_blood()
	if(inStasisNow())
		return

	if(!should_have_organ(O_HEART))
		return

	var/stabilization = HAS_TRAIT(src, TRAIT_MECHANICAL_VENTILATION)
	var/mechanical_circulation = HAS_TRAIT(src, TRAIT_MECHANICAL_CIRCULATION)

	if(stat != DEAD && bodytemperature >= 170)	//Dead or cryosleep people do not pump the blood.
		// assimilate foreign blood separately
		blood_holder.do_assimilate(0.5)

		var/blood_volume_raw = blood_holder.get_total_volume()
		var/blood_volume = round((blood_volume_raw/species.blood_volume)*100) // Percentage.

		//Blood regeneration if there is some space
		if(blood_volume_raw < species.blood_volume)
			var/regenerating_volume = 0.1 + max(0, chem_effects[CE_BLOODRESTORE])
			blood_holder.adjust_host_volume(regenerating_volume)

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

		if((CE_STABLE in chem_effects) || stabilization)
			dmg_coef *= 0.5
			threshold_coef *= 0.75

//	These are Bay bits, do some sort of calculation.
//			dmg_coef = min(1, 10/chem_effects[CE_STABLE]) //TODO: add effect for increased damage
//			threshold_coef = min(dmg_coef / CE_STABLE_THRESHOLD, 1)

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
					if(W.wound_type == WOUND_TYPE_PIERCE) //gunshots and spear stabs bleed more
						blood_loss_divisor = max(blood_loss_divisor - 5, 1)
					else if(W.wound_type == WOUND_TYPE_BRUISE) //bruises bleed less
						blood_loss_divisor = max(blood_loss_divisor + 5, 1)
					//the farther you get from those vital regions, the less you bleed
					//depending on how dangerous bleeding turns out to be, it might be better to only apply the reduction to hands and feet
					if((temp.organ_tag == BP_L_ARM) || (temp.organ_tag == BP_R_ARM) || (temp.organ_tag == BP_L_LEG) || (temp.organ_tag == BP_R_LEG))
						blood_loss_divisor = max(blood_loss_divisor + 5, 1)
					else if((temp.organ_tag == BP_L_HAND) || (temp.organ_tag == BP_R_HAND) || (temp.organ_tag == BP_L_FOOT) || (temp.organ_tag == BP_R_FOOT))
						blood_loss_divisor = max(blood_loss_divisor + 10, 1)
					if(CE_STABLE in chem_effects)	//Inaprov slows bloodloss
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
/mob/living/carbon/human/proc/drip(var/amt)
	if(erase_blood(amt))
		blood_splatter_legacy(get_turf(src), get_blood_mixture())

/****************************************************
				BLOOD TRANSFERS
****************************************************/

/**
 * puts blood into container
 *
 * @return amount transferred
 */
/mob/living/carbon/proc/take_blood_legacy(obj/item/reagent_containers/container, amount)
	ASSERT(container.reagents)

	var/wanted = clamp(container.reagents.maximum_volume - container.reagents.total_volume, 0, amount)
	if(!wanted)
		return 0

	var/datum/blood_mixture/taken_mixture = take_blood_mixture(wanted)
	var/amount_given = container.reagents.add_reagent(/datum/reagent/blood, taken_mixture.ctx_return_amount, taken_mixture)

	if(amount_given < taken_mixture.ctx_return_amount)
		// give back the remainder if we couldn't fill
		give_blood_mixture(taken_mixture, taken_mixture.ctx_return_amount - amount_given)

	return amount_given

//For humans, blood does not appear from blue, it comes from vessels.
/mob/living/carbon/human/take_blood_legacy(obj/item/reagent_containers/container, amount)
	if(!should_have_organ(O_HEART))
		return 0
	if(blood_holder.get_total_volume() < amount)
		return 0
	return ..()

//Transfers blood from container ot vessels
/mob/living/carbon/proc/inject_blood_legacy(datum/blood_mixture/mixture, amount)
	return give_blood_mixture(mixture, amount)

//Transfers blood from reagents to vessel, respecting blood types compatability.
/mob/living/carbon/human/inject_blood_legacy(datum/blood_mixture/mixture, amount)
	if(!blood_holder)
		return 0
	if(!should_have_organ(O_HEART))
		return ..()

	// todo: ??? why is this here ???
	reset_blood_to_species_if_needed(TRUE)

	// at some point we'll simulate immune system but for now this is just
	// raw conversion to toxin
	//
	// too bad!

	mixture = mixture.clone()

	//! behavior tightly coupled to /datum/blood_mixture. !//
	var/total_ratio_incompatible = 0
	var/list/direct_mixture_fragment_ratios = mixture.unsafe_get_fragment_list_ref()
	var/datum/blood_fragment/our_host_blood_fragment = blood_holder.unsafe_get_host_fragment_ref()
	for(var/datum/blood_fragment/fragment as anything in direct_mixture_fragment_ratios)
		if(our_host_blood_fragment.compatible_with_self(fragment))
			continue
		// rejected
		var/fragment_ratio = direct_mixture_fragment_ratios[fragment]
		bloodstr.add_reagent(/datum/reagent/toxin, amount * 0.5 * fragment_ratio)
		total_ratio_incompatible += fragment_ratio
		direct_mixture_fragment_ratios -= fragment
	if(total_ratio_incompatible)
		var/total_amount_incompatible = amount * total_ratio_incompatible
		amount *= (1 - total_ratio_incompatible)
		var/expand_ratio = 1 / total_ratio_incompatible
		for(var/datum/blood_fragment/expanding_to_fill as anything in direct_mixture_fragment_ratios)
			direct_mixture_fragment_ratios[expanding_to_fill] *= expand_ratio
		bloodstr.add_reagent(/datum/reagent/toxin, total_amount_incompatible)

	return ..()

/proc/blood_splatter_legacy(turf/target, datum/blood_mixture/mixture, large)
	if(!istype(target))
		return

	var/splatter_type = /obj/effect/debris/cleanable/blood/splatter
	var/obj/effect/debris/cleanable/blood/existing_splatter

	// todo: change how this works, we should stop making effects like this! only one should ever
	//       exist.

	var/list/drips = list()
	for(var/obj/effect/debris/cleanable/blood/drip/drop in target)
		drips += drop.icon_state
		qdel(drop)

	if(!large && length(drips) < 3)
		splatter_type = /obj/effect/debris/cleanable/blood/drip

	existing_splatter = locate(splatter_type) in target
	if(!existing_splatter)
		existing_splatter = new splatter_type(target)

	// todo: this is fucking stupid

	var/obj/effect/debris/cleanable/blood/drip/is_it_drips = existing_splatter
	if(istype(is_it_drips) && length(drips) && !large)
		is_it_drips.add_overlay(drips)
		is_it_drips.drips |= drips

	// is there data to copy?
	if(!mixture)
		return existing_splatter

	existing_splatter.name = mixture.get_name()
	existing_splatter.basecolor = mixture.get_color()
	existing_splatter.synthblood = mixture.legacy_is_synthetic
	existing_splatter.update_icon()

	existing_splatter.blood_DNA = mixture.legacy_get_forensic_blood_dna()
	if(mixture.legacy_virus2)
		existing_splatter.virus2 = virus_copylist(mixture.legacy_virus2)

	return existing_splatter
