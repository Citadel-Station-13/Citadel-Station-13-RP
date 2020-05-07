var/image/contamination_overlay = image('icons/effects/contamination.dmi')


obj/var/contaminated = 0


/obj/item/proc/can_contaminate()
	//Clothing and backpacks can be contaminated.
	if(flags & PHORONGUARD)
		return 0
	else if(istype(src,/obj/item/storage/backpack))
		return 0 //Cannot be washed :(
	//VOREStation Addition start
	else if(isbelly(loc))
		return 0
	else if(ismob(loc) && isbelly(loc.loc))
		return 0
	//VOREStation Addition end
	else if(istype(src,/obj/item/clothing))
		return 1

/obj/item/proc/contaminate()
	//Do a contamination overlay? Temporary measure to keep contamination less deadly than it was.
	if(!can_contaminate())
		return
	else
		if(!contaminated)
			contaminated = 1
			overlays += contamination_overlay

/obj/item/proc/decontaminate()
	contaminated = 0
	overlays -= contamination_overlay

/mob/proc/contaminate()

/mob/living/carbon/human/contaminate()
	//See if anything can be contaminated.

	if(!pl_suit_protected())
		suit_contamination()

	if(!pl_head_protected())
		if(prob(1))
			suit_contamination() //Phoron can sometimes get through such an open suit.

//Cannot wash backpacks currently.
//	if(istype(back,/obj/item/storage/backpack))
//		back.contaminate()

/mob/proc/pl_effects()

/mob/living/carbon/human/pl_effects()
	GET_VSC_PROP(atmos_vsc, /atmos/phoron/contamination, clothing_contamination)
	GET_VSC_PROP(atmos_vsc, /atmos/phoron/skin_burns, skin_burns)
	GET_VSC_PROP(atmos_vsc, /atmos/phoron/eye_burns, eye_burns)
	GET_VSC_PROP(atmos_vsc, /atmos/phoron/genetic_corruption, genetic_corruption)
	//Handles all the bad things phoron can do.

	//Contamination
	if(clothing_contamination)
		contaminate()

	//Anything else requires them to not be dead.
	if(stat >= 2)
		return

	//Burn skin if exposed.
	if(skin_burns && (species.breath_type != "phoron"))
		if(!pl_head_protected() || !pl_suit_protected())
			burn_skin(0.75)
			if(prob(20))
				to_chat(src, "<span class='danger'>Your skin burns!</span>")
			updatehealth()

	//Burn eyes if exposed.
	if(eye_burns && species.breath_type && (species.breath_type != "phoron"))		//VOREStation Edit: those who don't breathe
		var/burn_eyes = 1

		//Check for protective glasses
		if(glasses && (glasses.body_parts_covered & EYES) && (glasses.item_flags & AIRTIGHT))
			burn_eyes = 0

		//Check for protective maskwear
		if(burn_eyes && wear_mask && (wear_mask.body_parts_covered & EYES) && (wear_mask.item_flags & AIRTIGHT))
			burn_eyes = 0

		//Check for protective helmets
		if(burn_eyes && head && (head.body_parts_covered & EYES) && (head.item_flags & AIRTIGHT))
			burn_eyes = 0

		//VOREStation Edit - NIF Support
		if(nif && nif.flag_check(NIF_V_UVFILTER,NIF_FLAGS_VISION))
			burn_eyes = 0

		//If we still need to, burn their eyes
		if(burn_eyes)
			burn_eyes()

	//Genetic Corruption
	if(genetic_corruption && (species.breath_type != "phoron"))
		if(rand(1,10000) < genetic_corruption)
			randmutb(src)
			to_chat(src, "<span class='danger'>High levels of toxins cause you to spontaneously mutate!</span>")
			domutcheck(src,null)

/mob/living/carbon/human/proc/burn_eyes()
	var/obj/item/organ/internal/eyes/E = internal_organs_by_name[O_EYES]
	if(E)
		if(prob(20))
			to_chat(src, "<span class='danger'>Your eyes burn!</span>")
		E.damage += 2.5
		eye_blurry = min(eye_blurry+1.5,50)
		if (prob(max(0,E.damage - 15) + 1) &&!eye_blind)
			to_chat(src, "<span class='danger'>You are blinded!</span>")
			Blind(20)

/mob/living/carbon/human/proc/pl_head_protected()
	CACHE_VSC_PROP(atmos_vsc, /atmos/phoron/phoronguard_only, phoronguard_only)
	//Checks if the head is adequately sealed.	//This is just odd. TODO: Make this respect the body_parts_covered stuff like thermal gear does.
	if(head)
		if(phoronguard_only)
			if(head.flags & PHORONGUARD)
				return 1
		else if(head.body_parts_covered & EYES)
			return 1
	return 0

/mob/living/carbon/human/proc/pl_suit_protected()
	CACHE_VSC_PROP(atmos_vsc, /atmos/phoron/phoronguard_only, phoronguard_only)

	//Checks if the suit is adequately sealed.	//This is just odd. TODO: Make this respect the body_parts_covered stuff like thermal gear does.
	var/coverage = 0
	for(var/obj/item/protection in list(wear_suit, gloves, shoes))	//This is why it's odd. If I'm in a full suit, but my shoes and gloves aren't phoron proof, damage.
		if(!protection)
			continue
		if(phoronguard_only && !(protection.flags & PHORONGUARD))
			return 0
		coverage |= protection.body_parts_covered

	if(phoronguard_only)
		return 1

	return BIT_TEST_ALL(coverage, UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS)

/mob/living/carbon/human/proc/suit_contamination()
	//Runs over the things that can be contaminated and does so.
	if(w_uniform)
		w_uniform.contaminate()
	if(shoes)
		shoes.contaminate()
	if(gloves)
		gloves.contaminate()


/turf/Entered(obj/item/I)
	..()
	//Items that are in phoron, but not on a mob, can still be contaminated.
	if(istype(I) && vsc.plc.CLOTH_CONTAMINATION && I.can_contaminate())
		var/datum/gas_mixture/env = return_air(1)
		if(!env)
			return
		for(var/g in env.gas)
			if(gas_data.flags[g] & XGM_GAS_CONTAMINANT && env.gas[g] > gas_data.overlay_limit[g] + 1)
				I.contaminate()
				break
