GLOBAL_LIST_EMPTY(unarmed_attack_cache)

/proc/fetch_unarmed_style(datum/unarmed_attack/path)
	if(isnull(GLOB.unarmed_attack_cache[path]))
		GLOB.unarmed_attack_cache[path] = new path
	return GLOB.unarmed_attack_cache[path]

/**
 * Unarmed attacks for mobs
 */
/datum/unarmed_attack
	//? Damage
	/// damage amount - flat
	var/damage = 5
	/// add damage - low
	var/damage_add_low = 0
	/// add damage - high
	var/damage_add_high = 0
	/// damage mode flags
	var/damage_mode = NONE
	/// damage tier
	var/damage_tier = MELEE_TIER_UNARMED_DEFAULT
	/// damage type
	var/damage_type = DAMAGE_TYPE_BRUTE
	/// damage flag
	var/damage_flag = ARMOR_MELEE
	/// flat damage buff when attacking structures
	//  todo: damage_structural_add is awful and shouldn't be kept in the future
	var/damage_structural_add = 0

	//? Sounds
	/// sound when attacking
	var/attack_sound = "punch"
	/// sound when missing
	var/miss_sound = 'sound/weapons/punchmiss.ogg'

	//? Visuals
	/// ATTACK_ANIMATION_X enum
	var/animation_type = ATTACK_ANIMATION_PUNCH

	//? Text
	/// past tense, aka "[person] has [past] [target] in their [zone]"
	var/list/verb_past_participle = list("attacked")

	//? legacy
	var/attack_verb_legacy = list("attack")	// Empty hand hurt intent verb.
	var/attack_noun = list("fist")
	var/infected_wound_probability = 10

	var/sparring_variant_type = /datum/unarmed_attack/light_strike

	var/eye_attack_text
	var/eye_attack_text_victim

/datum/unarmed_attack/proc/operator""()
	return pick(attack_verb_legacy)

//* Feedback

/datum/unarmed_attack/proc/get_sparring_variant()
	return fetch_unarmed_style(sparring_variant_type)

/datum/unarmed_attack/proc/is_usable(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone)
	if(user.restrained())
		return FALSE

	// Check if they have a functioning hand.
	var/obj/item/organ/external/E = user.organs_by_name["l_hand"]
	if(E && !E.is_stump())
		return TRUE

	E = user.organs_by_name["r_hand"]
	if(E && !E.is_stump())
		return TRUE

	return FALSE

/datum/unarmed_attack/proc/get_unarmed_damage(mob/attacker, atom/defender)
	// todo: damage_structural_add is awful and shouldn't be kept in the future
	return damage + rand(damage_add_low, damage_add_high) + (ismob(defender)? 0 : damage_structural_add)

/datum/unarmed_attack/proc/apply_effects(var/mob/living/carbon/human/user,var/mob/living/carbon/human/target,var/armour,var/attack_damage,var/zone)

	var/stun_chance = rand(0, 100)
	var/datum/gender/TT = GLOB.gender_datums[target.get_visible_gender()]

	if(attack_damage >= 5 && armour < 2 && !(target == user) && stun_chance <= attack_damage * 5) // 25% standard chance
		switch(zone) // strong punches can have effects depending on where they hit
			if(BP_HEAD, O_EYES, O_MOUTH)
				// Induce blurriness
				target.visible_message("<span class='danger'>[target] looks momentarily disoriented.</span>", "<span class='danger'>You see stars.</span>")
				target.apply_effect(attack_damage*2, EYE_BLUR, armour)
			if(BP_L_ARM, BP_L_HAND)
				var/obj/item/knocked_away = target.get_left_held_item()
				if (knocked_away)
					// Disarm left hand
					//Urist McAssistant dropped the macguffin with a scream just sounds odd.
					target.visible_message("<span class='danger'>\The [knocked_away] was knocked right out of [target]'s grasp!</span>")
					target.drop_item_to_ground(knocked_away)
			if(BP_R_ARM, BP_R_HAND)
				var/obj/item/knocked_away = target.get_left_held_item()
				if (knocked_away)
					// Disarm right hand
					target.visible_message("<span class='danger'>\The [knocked_away] was knocked right out of [target]'s grasp!</span>")
					target.drop_item_to_ground(knocked_away)
			if(BP_TORSO)
				if(!target.lying)
					var/turf/T = get_step(get_turf(target), get_dir(get_turf(user), get_turf(target)))
					if(!T.density)
						step(target, get_dir(get_turf(user), get_turf(target)))
						target.visible_message("<span class='danger'>[pick("[target] was sent flying backward!", "[target] staggers back from the impact!")]</span>")
					else
						target.visible_message("<span class='danger'>[target] slams into [T]!</span>")
					if(prob(50))
						target.setDir(global.reverse_dir[target.dir])
					target.apply_effect(attack_damage * 0.3, WEAKEN, armour)
			if(BP_GROIN)
				if(!target.isSynthetic())
					target.visible_message("<span class='warning'>[target] looks like [TT.he] [TT.is] in pain!</span>", "<span class='warning'>[(target.gender=="female") ? "Oh god that hurt!" : "Oh no, not your[pick("testicles", "crown jewels", "clockweights", "family jewels", "marbles", "bean bags", "teabags", "sweetmeats", "goolies")]!"]</span>") // """""""I see no easy way to fix this for non-organic or neuter characters.""""""" - original coder
					target.apply_effects(stutter = attack_damage * 2, agony = attack_damage* 3, blocked = armour)
			if("l_leg", "l_foot", "r_leg", "r_foot")
				if(!target.lying)
					target.visible_message("<span class='warning'>[target] gives way slightly.</span>")
					target.apply_effect(attack_damage * 3, AGONY, armour)
	else if(attack_damage >= 5 && !(target == user) && (stun_chance + attack_damage * 5 >= 100) && armour < 2) // Chance to get the usual throwdown as well (25% standard chance)
		if(!target.lying)
			target.visible_message("<span class='danger'>[target] [pick("slumps", "falls", "drops")] down to the ground!</span>")
		else
			target.visible_message("<span class='danger'>[target] has been weakened!</span>")
		target.apply_effect(3, WEAKEN, armour)

	if(user.species.infect_wounds)		//Creates a pre-damaged, pre-infected wound. As nasty as this code.
		if(prob(infected_wound_probability))
			var/obj/item/organ/external/affecting = target.get_organ(zone)
			var/attack_message
			var/datum/wound/W
			if(damage_mode & DAMAGE_MODE_EDGE)
				W = affecting.create_specific_wound(/datum/wound/cut/small, 5)
				attack_message = "leaves behind infested residue in [target]!"
			else
				W = affecting.create_specific_wound(/datum/wound/bruise, 5)
				attack_message = "scratches and pummels, their infested fluids mixing with [target]!"
			W?.force_infect()

			target.visible_message("<span class='danger'><i>[user] [attack_message]</i></span>")

/datum/unarmed_attack/proc/show_attack(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone, var/attack_damage)
	var/obj/item/organ/external/affecting = target.get_organ(zone)
	user.visible_message("<span class='warning'>[user] [pick(attack_verb_legacy)] [target] in the [affecting.name]!</span>")
	playsound(user.loc, attack_sound, 25, 1, -1)

/datum/unarmed_attack/proc/handle_eye_attack(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target)
	var/obj/item/organ/internal/eyes/eyes = target.internal_organs_by_name[O_EYES]
	var/datum/gender/TU = GLOB.gender_datums[user.get_visible_gender()]
	var/datum/gender/TT = GLOB.gender_datums[target.get_visible_gender()]
	if(eyes)
		eyes.take_damage(rand(3,4), 1)
		user.visible_message("<span class='danger'>[user] presses [TU.his] [eye_attack_text] into [target]'s [eyes.name]!</span>")
		var/eye_pain = eyes.organ_can_feel_pain()
		to_chat(target, "<span class='danger'>You experience[(eye_pain) ? "" : " immense pain as you feel" ] [eye_attack_text_victim] being pressed into your [eyes.name][(eye_pain)? "." : "!"]</span>")
		return
	user.visible_message("<span class='danger'>[user] attempts to press [TU.his] [eye_attack_text] into [target]'s eyes, but [TT.he] [TT.does]n't have any!</span>")

/datum/unarmed_attack/proc/unarmed_override(var/mob/living/carbon/human/user,var/mob/living/carbon/human/target,var/zone)
	return FALSE //return true if the unarmed override prevents further attacks

/datum/unarmed_attack/bite
	verb_past_participle = list("bitten")
	attack_verb_legacy = list("bit")
	attack_sound = 'sound/weapons/bite.ogg'
	damage = 3
	damage_mode = NONE
	damage_tier = MELEE_TIER_UNARMED_FISTS

/datum/unarmed_attack/bite/is_usable(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone)

	if (user.is_muzzled())
		return 0
	if (user == target && (zone == BP_HEAD || zone == O_EYES || zone == O_MOUTH))
		return 0
	return TRUE

/datum/unarmed_attack/punch
	verb_past_participle = list("punched")
	attack_verb_legacy = list("punched")
	attack_noun = list("fist")
	eye_attack_text = "fingers"
	eye_attack_text_victim = "digits"
	damage_add_low = 0
	damage_add_high = 5
	damage_tier = MELEE_TIER_UNARMED_FISTS

/datum/unarmed_attack/punch/show_attack(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone, var/attack_damage)
	var/obj/item/organ/external/affecting = target.get_organ(zone)
	var/organ = affecting.name

	var/datum/gender/TU = GLOB.gender_datums[user.get_visible_gender()]
	var/datum/gender/TT = GLOB.gender_datums[target.get_visible_gender()]

	attack_damage = clamp(attack_damage - 5, 1, 5) // We expect damage input of 1 to 5 for this proc. But we leave this check juuust in case.

	if(target == user)
		user.visible_message("<span class='danger'>[user] [pick(attack_verb_legacy)] [TU.himself] in the [organ]!</span>")
		return 0

	if(!target.lying)
		switch(zone)
			if(BP_HEAD, O_MOUTH, O_EYES)
				// ----- HEAD ----- //
				switch(attack_damage)
					if(1 to 2)
						user.visible_message("<span class='danger'>[user] slapped [target] across [TT.his] cheek!</span>")
					if(3 to 4)
						user.visible_message(pick(
							40; "<span class='danger'>[user] [pick(attack_verb_legacy)] [target] in the head!</span>",
							30; "<span class='danger'>[user] struck [target] in the head[pick("", " with a closed fist")]!</span>",
							30; "<span class='danger'>[user] threw a hook against [target]'s head!</span>"
							))
					if(5)
						user.visible_message(pick(
							30; "<span class='danger'>[user] gave [target] a resounding [pick("slap", "punch")] to the face!</span>",
							40; "<span class='danger'>[user] smashed [TU.his] [pick(attack_noun)] into [target]'s face!</span>",
							30; "<span class='danger'>[user] gave a strong blow against [target]'s jaw!</span>"
							))
			else
				// ----- BODY ----- //
				switch(attack_damage)
					if(1 to 2)	user.visible_message("<span class='danger'>[user] threw a glancing punch at [target]'s [organ]!</span>")
					if(1 to 4)	user.visible_message("<span class='danger'>[user] [pick(attack_verb_legacy)] [target] in [TT.his] [organ]!</span>")
					if(5)
						user.visible_message(pick(
							50; "<span class='danger'>[user] smashed [TU.his] [pick(attack_noun)] into [target]'s [organ]!</span>",
							50; "<span class='danger'>[user] landed a striking [pick(attack_noun)] on [target]'s [organ]!</span>"
							))
	else
		user.visible_message("<span class='danger'>[user] [pick("punched", "threw a punch against", "struck", "slammed [TU.his] [pick(attack_noun)] into")] [target]'s [organ]!</span>") //why do we have a separate set of verbs for lying targets?

/datum/unarmed_attack/kick
	verb_past_participle = list("kicked")
	attack_verb_legacy = list("kicked", "kicked", "kicked", "kneed")
	attack_noun = list("kick", "kick", "kick", "knee strike")
	attack_sound = "swing_hit"
	damage_add_low = 0
	damage_add_high = 5

/datum/unarmed_attack/kick/is_usable(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone)
	if (user.legcuffed)
		return FALSE

	if(!(zone in list("l_leg", "r_leg", "l_foot", "r_foot", BP_GROIN)))
		return FALSE

	var/obj/item/organ/external/E = user.organs_by_name["l_foot"]
	if(E && !E.is_stump())
		return TRUE

	E = user.organs_by_name["r_foot"]
	if(E && !E.is_stump())
		return TRUE

	return FALSE

/datum/unarmed_attack/kick/get_unarmed_damage(var/mob/living/carbon/human/user)
	var/obj/item/clothing/shoes = user.shoes
	if(!istype(shoes))
		return damage
	return damage + max(0, shoes ? shoes.damage_force - 5 : 0)

/datum/unarmed_attack/kick/show_attack(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone, var/attack_damage)
	var/obj/item/organ/external/affecting = target.get_organ(zone)
	var/datum/gender/TT = GLOB.gender_datums[target.get_visible_gender()]
	var/organ = affecting.name

	attack_damage = clamp(attack_damage - 5, 1, 5)

	switch(attack_damage)
		if(1 to 2)	user.visible_message("<span class='danger'>[user] threw [target] a glancing [pick(attack_noun)] to the [organ]!</span>") //it's not that they're kicking lightly, it's that the kick didn't quite connect
		if(3 to 4)	user.visible_message("<span class='danger'>[user] [pick(attack_verb_legacy)] [target] in [TT.his] [organ]!</span>")
		if(5)		user.visible_message("<span class='danger'>[user] landed a strong [pick(attack_noun)] against [target]'s [organ]!</span>")

/datum/unarmed_attack/stomp
	verb_past_participle = list("stomped")
	attack_verb_legacy = list("stomped")
	attack_noun = list("stomp")
	attack_sound = "swing_hit"
	damage_add_low = 0
	damage_add_high = 5

/datum/unarmed_attack/stomp/is_usable(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone)

	if (user.legcuffed)
		return FALSE

	if(!istype(target))
		return FALSE

	if (!user.lying && (target.lying || (zone in list("l_foot", "r_foot"))))
		if(target.grabbed_by == user && target.lying)
			return FALSE
		var/obj/item/organ/external/E = user.organs_by_name["l_foot"]
		if(E && !E.is_stump())
			return TRUE

		E = user.organs_by_name["r_foot"]
		if(E && !E.is_stump())
			return TRUE

		return FALSE

/datum/unarmed_attack/stomp/get_unarmed_damage(var/mob/living/carbon/human/user)
	var/obj/item/clothing/shoes = user.shoes
	return damage + max(0, shoes ? shoes.damage_force - 5 : 0)

/datum/unarmed_attack/stomp/show_attack(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone, var/attack_damage)
	var/obj/item/organ/external/affecting = target.get_organ(zone)
	var/organ = affecting.name
	var/obj/item/clothing/shoes = user.shoes
	var/datum/gender/TU = GLOB.gender_datums[user.get_visible_gender()]

	attack_damage = clamp(attack_damage - 5, 1, 5)

	switch(attack_damage)
		if(1 to 4)	user.visible_message("<span class='danger'>[pick("[user] stomped on", "[user] slammed [TU.his] [shoes ? copytext(shoes.name, 1, -1) : "foot"] down onto")] [target]'s [organ]!</span>")
		if(5)		user.visible_message("<span class='danger'>[pick("[user] landed a powerful stomp on", "[user] stomped down hard on", "[user] slammed [TU.his] [shoes ? copytext(shoes.name, 1, -1) : "foot"] down hard onto")] [target]'s [organ]!</span>") //Devastated lol. No. We want to say that the stomp was powerful or forceful, not that it /wrought devastation/

/datum/unarmed_attack/light_strike
	verb_past_participle = list("lightly struck")
	attack_noun = list("tap","light strike")
	attack_verb_legacy = list("tapped", "lightly struck")
	damage = 5
	damage_mode = NONE
	damage_type = DAMAGE_TYPE_HALLOSS
