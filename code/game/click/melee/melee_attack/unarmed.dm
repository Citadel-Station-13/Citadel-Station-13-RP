GLOBAL_LIST_EMPTY(unarmed_attack_cache)

/proc/fetch_unarmed_style(datum/melee_attack/unarmed/path)
	if(isnull(GLOB.unarmed_attack_cache[path]))
		GLOB.unarmed_attack_cache[path] = new path
	return GLOB.unarmed_attack_cache[path]

/**
 * Unarmed attacks for mobs
 */
/datum/melee_attack/unarmed
	//? Damage
	/// damage amount - flat
	var/damage = 5
	/// add damage - low
	var/damage_add_low = 0
	/// add damage - high
	var/damage_add_high = 5
	/// damage mode flags
	var/damage_mode = NONE
	/// damage tier
	var/damage_tier = 2
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

	/// past participle verb form describing the attack
	/// * example: "[target] has been [past participle] in their [zone] by [attacker]!"
	var/list/verb_past_participle = list("attacked")
	//  TODO: do this
	/// present tense third person verb form describing the attack
	/// * example: "[attacker] [third person] [target] in their [zone]"
	// var/list/verb_third_person
	//  TODO: do this
	/// present infinitive verb
	/// * example: "[target] parries [attacker]'s [infinitive] with their [parry object]"
	// var/list/verb_infinitive

	//? legacy
	var/attack_verb_legacy = list("attack")	// Empty hand hurt intent verb.
	var/attack_noun = list("fist")
	var/infected_wound_probability = 10
	var/attack_name = "fist"

	var/sparring_variant_type = /datum/melee_attack/unarmed/light_strike

	var/eye_attack_text
	var/eye_attack_text_victim

/datum/melee_attack/unarmed/perform_attack_impact(atom/movable/attacker, atom/target, missed, obj/item/weapon, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	var/damage_force = get_base_damage(attacker, target)

	// TODO: should this all be here?
	//         (no it shouldn't)
	damage_force = max(0, damage_force + rand(damage_add_low, damage_add_high))
	if(ishuman(attacker))
		var/mob/living/carbon/human/H = attacker
		if(MUTATION_HULK in H.mutations)
			damage_force *= 2 // Hulks do twice the damage
		if(istype(H.gloves, /obj/item/clothing/gloves))
			var/obj/item/clothing/gloves/G = H.gloves
			damage_force += G.punch_force

	clickchain.data[ACTOR_DATA_UNARMED_LOG] = "[damage_force]-[damage_type]-[damage_flag]@[damage_tier]m[damage_mode]"
	var/list/results = target.run_damage_instance(
		damage_force,
		damage_type,
		damage_tier,
		damage_flag,
		damage_mode | (DAMAGE_MODE_REQUEST_ARMOR_BLUNTING | DAMAGE_MODE_REQUEST_ARMOR_RANDOMIZATION),
		ATTACK_TYPE_MELEE,
		clickchain,
		NONE,
		clickchain.target_zone,
	)
	clickchain.data[ACTOR_DATA_MELEE_DAMAGE_INSTANCE_RESULTS] = results
	target.on_melee_impact(attacker, weapon, src, clickchain.target_zone, clickchain, clickchain_flags, results)

	var/list/additional_legacy_effects = ismob(target) && apply_effects(
		attacker,
		target,
		0, // NO ARMOR YOLOOOO
		results[SHIELDCALL_ARG_DAMAGE],
		results[SHIELDCALL_ARG_HIT_ZONE],
	)
	if(length(additional_legacy_effects))
		clickchain.data["legacy-punching-additional"] = additional_legacy_effects

	return clickchain_flags

/datum/melee_attack/unarmed/perform_attack_animation(atom/movable/attacker, atom/target, missed, obj/item/weapon, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	return ..()

/datum/melee_attack/unarmed/perform_attack_message(atom/movable/attacker, atom/target, missed, obj/item/weapon, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	if(missed)
		return ..()
	var/where_phrase
	if(iscarbon(target))
		var/mob/living/carbon/carbon_target = target
		var/obj/item/organ/where_hit = carbon_target.get_organ(clickchain.target_zone)
		if(where_hit)
			where_phrase = " in \the [where_hit]"
	attacker.visible_message(
		SPAN_DANGER("[target] has been [islist(verb_past_participle)? pick(verb_past_participle) : verb_past_participle][where_phrase] by [attacker]!"),
		range = MESSAGE_RANGE_COMBAT_LOUD,
	)
	return TRUE

/datum/melee_attack/unarmed/perform_attack_sound(atom/movable/attacker, atom/target, missed, obj/item/weapon, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	if(missed)
		return ..()
	playsound(target, target.hitsound_unarmed(attacker, src), 50, TRUE, -1)
	return TRUE

/datum/melee_attack/unarmed/estimate_damage(atom/movable/attacker, atom/target, obj/item/weapon)
	return damage

// TODO: rid of this
/datum/melee_attack/unarmed/proc/operator""()
	return pick(attack_verb_legacy)

/datum/melee_attack/unarmed/proc/get_base_damage(atom/movable/attacker, atom/target)
	. = damage
	if(isobj(target))
		. += damage_structural_add

//* Feedback *//

/datum/melee_attack/unarmed/proc/get_sparring_variant()
	return fetch_unarmed_style(sparring_variant_type)

/datum/melee_attack/unarmed/proc/is_usable(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone)
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

// TODO: refactor this shit
/datum/melee_attack/unarmed/proc/apply_effects(var/mob/living/carbon/human/user,var/mob/living/carbon/human/target,var/armour,var/attack_damage,var/zone)

	var/stun_chance = rand(0, 100)
	var/datum/gender/TT = GLOB.gender_datums[target.get_visible_gender()]
	. = list()

	if(attack_damage >= 5 && armour < 2 && !(target == user) && stun_chance <= attack_damage * 5)
		switch(zone) // strong punches can have effects depending on where they hit
			if(BP_HEAD, O_EYES, O_MOUTH)
				// Induce blurriness
				target.visible_message("<span class='danger'>[target] looks momentarily disoriented.</span>", "<span class='danger'>You see stars.</span>")
				target.apply_effect(attack_damage*2, EYE_BLUR, armour)
				. +=  "disorient"
			if(BP_L_ARM, BP_L_HAND)
				var/obj/item/knocked_away = target.get_left_held_item()
				if (knocked_away)
					// Disarm left hand
					//Urist McAssistant dropped the macguffin with a scream just sounds odd.
					target.visible_message("<span class='danger'>\The [knocked_away] was knocked right out of [target]'s grasp!</span>")
					target.drop_item_to_ground(knocked_away)
					. +=  "disarmed [knocked_away] left"
			if(BP_R_ARM, BP_R_HAND)
				var/obj/item/knocked_away = target.get_left_held_item()
				if (knocked_away)
					// Disarm right hand
					target.visible_message("<span class='danger'>\The [knocked_away] was knocked right out of [target]'s grasp!</span>")
					target.drop_item_to_ground(knocked_away)
					. +=  "disarmed [knocked_away] right"
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
					. +=  "flew backwards"
			if(BP_GROIN)
				if(!target.isSynthetic())
					target.visible_message("<span class='warning'>[target] looks like [TT.he] [TT.is] in pain!</span>", "<span class='warning'>[(target.gender=="female") ? "Oh god that hurt!" : "Oh no, not your[pick("testicles", "crown jewels", "clockweights", "family jewels", "marbles", "bean bags", "teabags", "sweetmeats", "goolies")]!"]</span>") // """""""I see no easy way to fix this for non-organic or neuter characters.""""""" - original coder
					target.apply_effects(stutter = attack_damage * 2, agony = attack_damage* 3, blocked = armour)
					. +=  "dick punched"
			if("l_leg", "l_foot", "r_leg", "r_foot")
				if(!target.lying)
					target.visible_message("<span class='warning'>[target] gives way slightly.</span>")
					target.apply_effect(attack_damage * 3, AGONY, armour)
					. +=  "shin kicked"
	else if(attack_damage >= 5 && !(target == user) && (stun_chance + attack_damage * 2 >= 100) && armour < 2)
		if(!target.lying)
			target.visible_message("<span class='danger'>[target] [pick("slumps", "falls", "drops")] down to the ground!</span>")
		else
			target.visible_message("<span class='danger'>[target] has been weakened!</span>")
		target.apply_effect(1, WEAKEN, armour)
		. +=  "knocked down"

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
			. += "wound infected"

/datum/melee_attack/unarmed/proc/show_attack(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone, var/attack_damage)
	var/obj/item/organ/external/affecting = target.get_organ(zone)
	user.visible_message("<span class='warning'>[user] [pick(attack_verb_legacy)] [target] in the [affecting.name]!</span>")
	playsound(user.loc, attack_sound, 25, 1, -1)

/datum/melee_attack/unarmed/proc/handle_eye_attack(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target)
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
