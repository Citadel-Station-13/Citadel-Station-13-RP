/datum/reagent/acid
	name = "Sulphuric acid"
	id = "sacid"
	description = "A very corrosive mineral acid with the molecular formula H2SO4."
	taste_description = "acid"
	reagent_state = REAGENT_LIQUID
	color = "#DB5008"
	metabolism_rate = REM * 2
	touch_met = 50 // It's acid!
	var/power = 5
	var/meltdose = 10 // How much is needed to melt

/datum/reagent/acid/legacy_affect_blood(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	if(issmall(M))
		removed *= 2
	M.take_random_targeted_damage(brute = 0, brute = removed * power * 2)

/datum/reagent/acid/legacy_affect_touch(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism) // This is the most interesting
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.head)
			if(H.head.integrity_flags & INTEGRITY_ACIDPROOF)
				to_chat(H, "<span class='danger'>Your [H.head] protects you from the acid.</span>")
				metabolism.legacy_current_holder.remove_reagent(id, metabolism.legacy_volume_remaining)
				return
			else if(removed > meltdose)
				to_chat(H, "<span class='danger'>Your [H.head] melts away!</span>")
				qdel(H.head)
				H.update_inv_head(1)
				H.update_hair(1)
				removed -= meltdose
		if(removed <= 0)
			return

		if(H.wear_mask)
			if(H.wear_mask.integrity_flags & INTEGRITY_ACIDPROOF)
				to_chat(H, "<span class='danger'>Your [H.wear_mask] protects you from the acid.</span>")
				metabolism.legacy_current_holder.remove_reagent(id, metabolism.legacy_volume_remaining)
				return
			else if(removed > meltdose)
				to_chat(H, "<span class='danger'>Your [H.wear_mask] melts away!</span>")
				qdel(H.wear_mask)
				H.update_inv_wear_mask(1)
				H.update_hair(1)
				removed -= meltdose
		if(removed <= 0)
			return

		if(H.glasses)
			if(H.glasses.integrity_flags & INTEGRITY_ACIDPROOF)
				to_chat(H, "<span class='danger'>Your [H.glasses] partially protect you from the acid!</span>")
				removed /= 2
			else if(removed > meltdose)
				to_chat(H, "<span class='danger'>Your [H.glasses] melt away!</span>")
				qdel(H.glasses)
				H.update_inv_glasses(1)
				removed -= meltdose / 2
		if(removed <= 0)
			return

	if(metabolism.legacy_volume_remaining < meltdose) // Not enough to melt anything
		M.take_random_targeted_damage(brute = 0, burn = removed * power * 0.2) //burn damage, since it causes chemical burns. Acid doesn't make bones shatter, like brute trauma would.
		return
	if(!M.unacidable && removed > 0)
		if(istype(M, /mob/living/carbon/human) && metabolism.legacy_volume_remaining >= meltdose)
			var/mob/living/carbon/human/H = M
			var/obj/item/organ/external/affecting = H.get_organ(BP_HEAD)
			if(affecting)
				affecting.inflict_bodypart_damage(
					burn = removed * power * 0.1,
				)
				if(prob(100 * removed / meltdose)) // Applies disfigurement
					if (affecting.organ_can_feel_pain())
						H.emote("scream")
		else
			M.take_random_targeted_damage(brute = 0, brute = removed * power * 0.1) // Balance. The damage is instant, so it's weaker. 10 units -> 5 damage, double for pacid. 120 units beaker could deal 60, but a) it's burn, which is not as dangerous, b) it's a one-use weapon, c) missing with it will splash it over the ground and d) clothes give some protection, so not everything will hit

/datum/reagent/acid/on_touch_obj(obj/target, remaining, allocated, data, spread_between)
	. = ..()
	var/obj/O = target
	if(O.integrity_flags & (INTEGRITY_INDESTRUCTIBLE | INTEGRITY_ACIDPROOF))
		return
	// todo: newacid
	if((istype(O, /obj/item) || istype(O, /obj/effect/plant)) && (allocated > meltdose))
		var/obj/effect/debris/cleanable/molten_item/I = new/obj/effect/debris/cleanable/molten_item(O.loc)
		I.desc = "Looks like this was \an [O] some time ago."
		for(var/mob/M in viewers(5, O))
			to_chat(M, "<span class='warning'>\The [O] melts.</span>")
		qdel(O)
		. += meltdose

