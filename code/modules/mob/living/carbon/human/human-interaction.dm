/mob/living/carbon/human/on_clickchain_unarmed_interaction(datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	// TODO: only on successful touch & rework viro lol
	if(istype(clickchain.performer,/mob/living/carbon))
		var/mob/living/carbon/C = clickchain.performer
		C.spread_disease_to(src, "Contact")
	clickchain.performer.break_cloak()
	// TODO: take out hardcoded laying down check
	if(clickchain.performer.lying)
		return CLICKCHAIN_DO_NOT_PROPAGATE
	return ..()

/mob/living/carbon/human/on_clickchain_help_interaction(datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	. = ..()
	if(. & CLICKCHAIN_FLAGS_INTERACT_ABORT)
		return
	if(isliving(clickchain.performer))
		if(apply_pressure(clickchain.performer, clickchain.target_zone))
			return . | CLICKCHAIN_DID_SOMETHING
	if(iscarbon(clickchain.performer))
		var/help_shake_act_shieldcall_results = atom_shieldcall_handle_touch(
			clickchain,
			clickchain_flags,
			SHIELDCALL_CONTACT_FLAG_HELPFUL,
			SHIELDCALL_CONTACT_SPECIFIC_SHAKE_UP,
		)
		if(help_shake_act_shieldcall_results & SHIELDCALL_FLAGS_BLOCK_ATTACK)
			clickchain.performer.do_attack_animation(src)
			return . | CLICKCHAIN_DID_SOMETHING
		help_shake_act(clickchain.performer)
		return . | CLICKCHAIN_DID_SOMETHING

/mob/living/carbon/human/on_clickchain_disarm_interaction(datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	. = ..()
	if(. & CLICKCHAIN_FLAGS_INTERACT_ABORT)
		return
	. |= attempt_clickchain_disarm(clickchain, clickchain_flags)
	if(. & CLICKCHAIN_FLAGS_INTERACT_ABORT)
		return

/mob/living/carbon/human/on_clickchain_grab_interaction(datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	. = ..()
	if(. & CLICKCHAIN_FLAGS_INTERACT_ABORT)
		return
	. |= attempt_clickchain_grab(clickchain, clickchain_flags)
	if(. & CLICKCHAIN_FLAGS_INTERACT_ABORT)
		return

/mob/living/carbon/human/on_clickchain_harm_interaction(datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	. = ..()
	if(. & CLICKCHAIN_FLAGS_INTERACT_ABORT)
		return
	. |= attempt_clickchain_harm(clickchain, clickchain_flags)
	if(. & CLICKCHAIN_FLAGS_INTERACT_ABORT)
		return

// TODO: rework this to an unified melee accuracy handler?
/mob/living/carbon/human/proc/legacy_unarmed_miss_hook(mob/living/carbon/human/H)
	// Should this all be in Touch()?
	if(istype(H))
		if(H.get_accuracy_penalty() && H != src)	//Should only trigger if they're not aiming well
			var/hit_zone = get_zone_with_miss_chance(H.zone_sel.selecting, src, H.get_accuracy_penalty())
			if(!hit_zone)
				H.do_attack_animation(src)
				playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
				visible_message("<font color='red'><B>[H] reaches for [src], but misses!</B></font>")
				return TRUE
	return FALSE

/**
 * todo: rework disarm balancing to shove + disarm?
 *
 * @return clickchain flags
 */
/mob/living/carbon/human/proc/attempt_clickchain_disarm(datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	var/shieldcall_results = atom_shieldcall_handle_touch(
		clickchain,
		clickchain_flags,
		SHIELDCALL_CONTACT_FLAG_HARMFUL,
		SHIELDCALL_CONTACT_SPECIFIC_DISARM,
	)
	if(shieldcall_results & SHIELDCALL_FLAGS_BLOCK_ATTACK)
		clickchain.performer.do_attack_animation(src)
		return CLICKCHAIN_FULL_BLOCKED | CLICKCHAIN_DID_SOMETHING

	// mostly legacy code
	var/mob/living/carbon/human/H = clickchain.performer
	if(!istype(H))
		return NONE
	if(legacy_unarmed_miss_hook(H))
		return CLICKCHAIN_DID_SOMETHING | CLICKCHAIN_ATTACK_MISSED
	var/mob/living/L = H
	add_attack_logs(H,src,"Disarmed")
	L.do_attack_animation(src)

	if(w_uniform)
		w_uniform.add_fingerprint(L)
	var/obj/item/organ/external/affecting = get_organ(ran_zone(L.zone_sel.selecting))

	var/list/holding = list(get_active_held_item() = 40, get_inactive_held_item = 20)

	//See if they have any guns that might go off
	for(var/obj/item/gun/W in holding)
		if(W && prob(holding[W]))
			var/list/turfs = list()
			for(var/turf/T in view())
				turfs += T
			if(turfs.len)
				var/turf/target = pick(turfs)
				visible_message("<span class='danger'>[src]'s [W] goes off during the struggle!</span>")
				return W.afterattack(target,src)

	if(last_push_time + 30 > world.time)
		visible_message("<span class='warning'>[L] has weakly pushed [src]!</span>")
		return CLICKCHAIN_DID_SOMETHING

	var/randn = rand(1, 100)
	last_push_time = world.time
	if(!(species.species_flags & NO_SLIP) && randn <= 25)
		var/armor_check = run_armor_check(affecting, "melee")
		apply_effect(3, WEAKEN, armor_check)
		playsound(src, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
		if(armor_check < 60)
			if(L.zone_sel.selecting == BP_L_LEG || L.zone_sel.selecting == BP_R_LEG || L.zone_sel.selecting == BP_L_FOOT || L.zone_sel.selecting == BP_R_FOOT)
				visible_message("<span class='danger'>[L] has leg swept [src]!</span>")
			else
				visible_message("<span class='danger'>[L] has pushed [src]!</span>")
		else
			visible_message("<span class='warning'>[L] attempted to push [src]!</span>")
		return CLICKCHAIN_DID_SOMETHING

	if(randn <= 60)
		//See about breaking grips or pulls
		if(break_all_grabs(L))
			playsound(src, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
			return CLICKCHAIN_DID_SOMETHING

		//Actually disarm them
		drop_held_items()

		visible_message("<span class='danger'>[L] has disarmed [src]!</span>")
		playsound(src, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
		return CLICKCHAIN_DID_SOMETHING

	playsound(src, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
	visible_message("<font color='red'> <B>[L] attempted to disarm [src]!</B></font>")
	return CLICKCHAIN_DID_SOMETHING

/**
 * @return clickchain flags
 */
/mob/living/carbon/human/proc/attempt_clickchain_grab(datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	var/shieldcall_results = atom_shieldcall_handle_touch(
		clickchain,
		clickchain_flags,
		SHIELDCALL_CONTACT_FLAG_NEUTRAL,
		SHIELDCALL_CONTACT_SPECIFIC_GRAB,
	)
	if(shieldcall_results & SHIELDCALL_FLAGS_BLOCK_ATTACK)
		clickchain.performer.do_attack_animation(src)
		return CLICKCHAIN_DID_SOMETHING | CLICKCHAIN_FULL_BLOCKED

	// mostly legacy code
	var/mob/living/carbon/human/H = clickchain.performer
	if(!istype(H))
		return NONE
	if(legacy_unarmed_miss_hook(H))
		return CLICKCHAIN_DID_SOMETHING | CLICKCHAIN_ATTACK_MISSED
	var/datum/gender/TT = GLOB.gender_datums[user.get_visible_gender()]
	var/mob/living/L = H
	#warn log
	if(L == src || anchored)
		return NONE
	for(var/obj/item/grab/G in src.grabbed_by)
		if(G.assailant == L)
			to_chat(L, "<span class='notice'>You already grabbed [src].</span>")
			return CLICKCHAIN_DID_SOMETHING
	if(w_uniform)
		w_uniform.add_fingerprint(L)

	var/obj/item/grab/G = new /obj/item/grab(L, src)
	if(buckled)
		to_chat(L, "<span class='notice'>You cannot grab [src], [TT.he] is buckled in!</span>")
		return CLICKCHAIN_DID_SOMETHING
	if(!G)	//the grab will delete itself in New if affecting is anchored
		return CLICKCHAIN_DID_SOMETHING
	L.put_in_active_hand(G)
	LAssailant = L

	H.do_attack_animation(src)
	playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
	visible_message("<span class='warning'>[L] has grabbed [src] [(L.zone_sel.selecting == BP_L_HAND || L.zone_sel.selecting == BP_R_HAND)? "by [(gender==FEMALE)? "her" : ((gender==MALE)? "his": "their")] hands": "passively"]!</span>")

	return CLICKCHAIN_DID_SOMETHING

/**
 *
 * @return clickchain flags
 */
/mob/living/carbon/human/proc/attempt_clickchain_harm(datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	// mostly legacy code
	var/mob/living/carbon/human/H = clickchain.performer
	if(!istype(H))
		return NONE
	if(legacy_unarmed_miss_hook(H))
		return CLICKCHAIN_DID_SOMETHING | CLICKCHAIN_ATTACK_MISSED
	var/mob/living/L = H

	if(L.zone_sel.selecting == "mouth" && wear_mask && istype(wear_mask, /obj/item/grenade))
		var/obj/item/grenade/G = wear_mask
		if(!G.active)
			visible_message("<span class='danger'>\The [L] pulls the pin from \the [src]'s [G.name]!</span>")
			G.activate(L)
			update_inv_wear_mask()
		else
			to_chat(L, "<span class='warning'>\The [G] is already primed! Run!</span>")
		return

	var/rand_damage = 0
	var/block = 0
	var/accurate = 0
	var/hit_zone = H.zone_sel.selecting
	var/obj/item/organ/external/affecting = get_organ(hit_zone)

	if(!affecting || affecting.is_stump())
		to_chat(L, "<span class='danger'>They are missing that limb!</span>")
		return NONE

	switch(src.a_intent)
		if(INTENT_HELP)
			// We didn't see this coming, so we get the full blow
			// rand_damage = 5
			accurate = 1
		if(INTENT_HARM, INTENT_GRAB)
			// We're in a fighting stance, there's a chance we block
			if(CHECK_MOBILITY(src, MOBILITY_CAN_MOVE) && src!=H && prob(20))
				block = 1

	if(src.grabbed_by.len || src.buckled || !CHECK_MOBILITY(src, MOBILITY_CAN_MOVE) || src==H)
		accurate = 1 // certain circumstances make it impossible for us to evade punches

	// Process evasion and blocking
	var/miss_type = 0
	var/attack_message
	if(!accurate)

		if(!hit_zone)
			attack_message = "[H] attempted to strike [src], but missed!"
			miss_type = 1

		if(prob(80))
			hit_zone = ran_zone(hit_zone, 70) //70% chance to hit what you're aiming at seems fair?
		if(prob(15) && hit_zone != BP_TORSO) // Missed!
			if(!src.lying)
				attack_message = "[H] attempted to strike [src], but missed!"
			else
				attack_message = "[H] attempted to strike [src], but [TT.he] rolled out of the way!"
				src.setDir(pick(GLOB.cardinal))
			miss_type = 1

	if(!miss_type && block)
		attack_message = "[H] went for [src]'s [affecting.name] but was blocked!"
		miss_type = 2

	// See what attack they use
	var/datum/melee_attack/unarmed/attack = H.get_unarmed_attack(src, hit_zone)
	if(!attack)
		return FALSE

	var/shieldcall_results = atom_shieldcall_handle_melee(
		clickchain,
		clickchain_flags,
		null,
		attack,
	)
	if(shieldcall_results & SHIELDCALL_FLAGS_BLOCK_ATTACK)
		H.do_attack_animation(src)
		return CLICKCHAIN_FULL_BLOCKED | CLICKCHAIN_DID_SOMETHING

	if(attack.unarmed_override(H, src, hit_zone))
		return CLICKCHAIN_DID_SOMETHING

	H.animate_swing_at_target(src)
	animate_hit_by_attack(attack.animation_type)
	if(!attack_message)
		attack.show_attack(H, src, hit_zone, rand_damage)
	else
		H.visible_message("<span class='danger'>[attack_message]</span>")

	playsound(loc, ((miss_type) ? (miss_type == 1 ? attack.miss_sound : 'sound/weapons/thudswoosh.ogg') : attack.attack_sound), 25, 1, -1)

	add_attack_logs(H,src,"Melee attacked with fists (miss/block)")

	if(miss_type)
		return CLICKCHAIN_DID_SOMETHING

	var/real_damage = rand_damage
	var/hit_dam_type = attack.damage_type
	real_damage += attack.get_unarmed_damage(H)
	if(H.gloves)
		if(istype(H.gloves, /obj/item/clothing/gloves))
			var/obj/item/clothing/gloves/G = H.gloves
			real_damage += G.punch_force
			if(H.pulling_punches && !(attack.damage_mode & (DAMAGE_MODE_EDGE | DAMAGE_MODE_SHARP)))	//SO IT IS DECREED: PULLING PUNCHES WILL PREVENT THE ACTUAL DAMAGE FROM RINGS AND KNUCKLES, BUT NOT THE ADDED PAIN, BUT YOU CAN'T "PULL" A KNIFE
				hit_dam_type = AGONY
	real_damage *= damage_multiplier
	rand_damage *= damage_multiplier
	if(MUTATION_HULK in H.mutations)
		real_damage *= 2 // Hulks do twice the damage
		rand_damage *= 2
	real_damage = max(1, real_damage)

	var/armour = run_armor_check(hit_zone, "melee")
	var/soaked = get_armor_soak(hit_zone, "melee")
	// Apply additional unarmed effects.
	attack.apply_effects(H, src, armour, rand_damage, hit_zone)

	// Finally, apply damage to target
	apply_damage(real_damage, hit_dam_type, hit_zone, armour, soaked, sharp = attack.damage_mode & DAMAGE_MODE_SHARP, edge = attack.damage_mode & DAMAGE_MODE_EDGE)
	return CLICKCHAIN_DID_SOMETHING
