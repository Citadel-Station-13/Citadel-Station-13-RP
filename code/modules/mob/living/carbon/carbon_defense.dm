//Called when the mob is hit with an item in combat.
/mob/living/carbon/resolve_item_attack(obj/item/I, mob/living/user, var/effective_force, var/hit_zone)
	if(check_neckgrab_attack(I, user, hit_zone))
		return null
	..()

/mob/living/carbon/standard_weapon_hit_effects(obj/item/I, mob/living/user, var/effective_force, var/blocked, var/soaked, var/hit_zone)
	if(!effective_force || blocked >= 100)
		return 0

	//If the armor soaks all of the damage, it just skips the rest of the checks
	if(effective_force <= soaked)
		return 0

	//Apply weapon damage
	var/weapon_sharp = is_sharp(I)
	var/weapon_edge = has_edge(I)
	var/hit_embed_chance = I.embed_chance
	if(prob(run_mob_armor(hit_zone, "melee"))) //melee armour provides a chance to turn sharp/edge weapon attacks into blunt ones
		weapon_sharp = 0
		weapon_edge = 0
		hit_embed_chance = I.force/(I.w_class*3)

	apply_damage(effective_force, I.damtype, hit_zone, blocked, soaked, sharp=weapon_sharp, edge=weapon_edge, used_weapon=I)

	//Melee weapon embedded object code.
	if (I && I.damtype == BRUTE && !I.anchored && !is_robot_module(I) && I.embed_chance > 0)
		var/damage = effective_force
		if (blocked)
			damage *= (100 - blocked)/100
			hit_embed_chance *= (100 - blocked)/100

		//blunt objects should really not be embedding in things unless a huge amount of force is involved
		var/embed_threshold = weapon_sharp? 5*I.w_class : 15*I.w_class

		if(damage > embed_threshold && prob(hit_embed_chance))
			src.embed(I, hit_zone)

	return 1

// Attacking someone with a weapon while they are neck-grabbed
/mob/living/carbon/proc/check_neckgrab_attack(obj/item/W, mob/user, var/hit_zone)
	if(user.a_intent == INTENT_HARM)
		for(var/obj/item/grab/G in src.grabbed_by)
			if(G.assailant == user)
				if(G.state >= GRAB_AGGRESSIVE)
					if(hit_zone == BP_TORSO && shank_attack(W, G, user))
						return 1
				if(G.state >= GRAB_NECK)
					if(hit_zone == BP_HEAD && attack_throat(W, G, user, hit_zone))
						return 1
	return 0

/mob/living/carbon/electrocute_act(var/shock_damage, var/obj/source, var/siemens_coeff = 1.0, var/def_zone = null, var/stun = 1)
	if(status_flags & GODMODE)
		return 0	//godmode
	if(def_zone == "l_hand" || def_zone == "r_hand") //Diona (And any other potential plant people) hands don't get shocked.
		if(species.species_flags & IS_PLANT)
			return 0
	shock_damage *= siemens_coeff
	if (shock_damage<1)
		return 0

	src.apply_damage(shock_damage, BURN, def_zone, used_weapon="Electrocution")
	playsound(loc, "sparks", 50, 1, -1)
	if (shock_damage > 15)
		src.visible_message(
			"<span class='warning'>[src] was electrocuted[source ? " by the [source]" : ""]!</span>", \
			"<span class='danger'>You feel a powerful shock course through your body!</span>", \
			"<span class='warning'>You hear a heavy electrical crack.</span>" \
		)
	else
		src.visible_message(
			"<span class='warning'>[src] was shocked[source ? " by the [source]" : ""].</span>", \
			"<span class='warning'>You feel a shock course through your body.</span>", \
			"<span class='warning'>You hear a zapping sound.</span>" \
		)

	if(stun)
		switch(shock_damage)
			if(16 to 20)
				Stun(2)
			if(21 to 25)
				Weaken(2)
			if(26 to 30)
				Weaken(5)
			if(31 to INFINITY)
				Weaken(10) //This should work for now, more is really silly and makes you lay there forever

	var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
	s.set_up(5, 1, loc)
	s.start()

	return shock_damage

// Knifing
/mob/living/carbon/proc/attack_throat(obj/item/W, obj/item/grab/G, mob/user)

	if(!W.edge || !W.force || W.damtype != BRUTE)
		return 0 //unsuitable weapon

	user.visible_message("<span class='danger'>\The [user] begins to slit [src]'s throat with \the [W]!</span>")

	user.next_move = world.time + 20 //also should prevent user from triggering this repeatedly
	if(!do_after(user, 20))
		return 0
	if(!(G && G.assailant == user && G.affecting == src)) //check that we still have a grab
		return 0

	var/damage_mod = 1
	//presumably, if they are wearing a helmet that stops pressure effects, then it probably covers the throat as well
	var/obj/item/clothing/head/helmet = item_by_slot(SLOT_ID_HEAD)
	if(istype(helmet) && (helmet.body_cover_flags & HEAD) && (helmet.min_pressure_protection != null)) // Both min- and max_pressure_protection must be set for it to function at all, so we can just check that one is set.
		//we don't do an armor_check here because this is not an impact effect like a weapon swung with momentum, that either penetrates or glances off.
		damage_mod = 1.0 - (helmet.armor["melee"]/100)

	var/total_damage = 0
	for(var/i in 1 to 3)
		var/damage = min(W.force*1.5, 20)*damage_mod
		apply_damage(damage, W.damtype, "head", 0, sharp=W.sharp, edge=W.edge)
		total_damage += damage

	var/oxyloss = total_damage
	if(total_damage >= 40) //threshold to make someone pass out
		oxyloss = 60 // Brain lacks oxygen immediately, pass out

	adjustOxyLoss(min(oxyloss, 100 - getOxyLoss())) //don't put them over 100 oxyloss

	if(total_damage)
		if(oxyloss >= 40)
			user.visible_message("<span class='danger'>\The [user] slit [src]'s throat open with \the [W]!</span>")
		else
			user.visible_message("<span class='danger'>\The [user] cut [src]'s neck with \the [W]!</span>")

		if(W.hitsound)
			playsound(loc, W.hitsound, 50, 1, -1)

	G.last_action = world.time
	flick(G.hud.icon_state, G.hud)

	add_attack_logs(user,src,"Knifed (throat slit)")

	return 1

/mob/living/carbon/proc/shank_attack(obj/item/W, obj/item/grab/G, mob/user, hit_zone)

	if(!W.sharp || !W.force || W.damtype != BRUTE)
		return 0 //unsuitable weapon

	user.visible_message("<span class='danger'>\The [user] plunges \the [W] into \the [src]!</span>")

	var/damage = shank_armor_helper(W, G, user)
	apply_damage(damage, W.damtype, "torso", 0, sharp=W.sharp, edge=W.edge)

	if(W.hitsound)
		playsound(loc, W.hitsound, 50, 1, -1)

	add_attack_logs(user,src,"Knifed (shanked)")

	return 1

/mob/living/carbon/proc/shank_armor_helper(obj/item/W, obj/item/grab/G, mob/user)
	var/damage = W.force
	var/damage_mod = 1
	if(W.edge)
		damage = damage * 1.25 //small damage bonus for having sharp and edge

	var/obj/item/clothing/suit/worn_suit
	var/obj/item/clothing/under/worn_under
	var/worn_suit_armor
	var/worn_under_armor

	//if(SLOT_ID_SUIT)
	if(item_by_slot(SLOT_ID_SUIT))
		worn_suit = item_by_slot(SLOT_ID_SUIT)
		//worn_suit = item_by_slot(SLOT_ID_SUIT)
		worn_suit_armor = worn_suit.armor["melee"]
	else
		worn_suit_armor = 0

	//if(SLOT_ID_UNIFORM)
	if(item_by_slot(SLOT_ID_UNIFORM))
		worn_under = item_by_slot(SLOT_ID_UNIFORM)
		//worn_under_armor = SLOT_ID_UNIFORM.armor["melee"]
		worn_under_armor = worn_under.armor["melee"]
	else
		worn_under_armor = 0

	if(worn_under_armor > worn_suit_armor)
		damage_mod = 1 - (worn_under_armor/100)
	else
		damage_mod = 1 - (worn_suit_armor/100)

	damage = damage * damage_mod

	return damage
