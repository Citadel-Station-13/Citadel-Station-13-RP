// Contains code for slimes getting attacked, beat, touched, etc, and reacting to that.

// Clicked on by empty hand.
// Handles trying to wrestle a slime off of someone being eatten.
/mob/living/simple_mob/slime/xenobio/attack_hand(mob/user, datum/event_args/actor/clickchain/e_args)
	var/mob/living/L = user
	if(!istype(L))
		return
	if(victim) // Are we eating someone?
		var/fail_odds = 30
		if(victim == L) // Harder to get the slime off if it's you that is being eatten.
			fail_odds = 60

		if(prob(fail_odds))
			visible_message(SPAN_WARNING( "\The [L] attempts to wrestle \the [name] off!"))
			playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)

		else
			visible_message(SPAN_WARNING( "\The [L] manages to wrestle \the [name] off!"))
			playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)

			if(prob(40))
				adjust_discipline(1) // Do this here so that it will be justified discipline.
			stop_consumption()
			step_away(src, L)

	else
		..()

// Handles the actual harming by a melee weapon.
/mob/living/simple_mob/slime/xenobio/on_melee_impact(mob/attacker, obj/item/weapon, datum/melee_attack/attack_style, target_zone, datum/event_args/actor/clickchain/clickchain, clickchain_flags, list/damage_instance_results)
	..()
	if(!IS_CONSCIOUS(src))
		return
	if(damage_instance_results[SHIELDCALL_ARG_DAMAGE] <= 0)
		return
	if(!is_justified_to_discipline()) // Wow, buddy, why am I getting attacked??
		adjust_discipline(1) // This builds resentment due to being unjustified.

		if(attacker in friends) // Friend attacking us for no reason.
			if(prob(25))
				friends -= attacker
				say("[attacker]... not friend...")

	else // We're actually being bad.
		var/prob_to_back_down = round(damage_instance_results[SHIELDCALL_ARG_DAMAGE] * 2)
		if(is_adult)
			prob_to_back_down /= 2
		if(prob(prob_to_back_down))
			adjust_discipline(2) // Justified.

/mob/living/simple_mob/slime/xenobio/inflict_electrocute_damage(damage, agony, flags, hit_zone)
	return

/mob/living/simple_mob/slime/xenobio/on_electrocute_act(efficiency, energy, damage, agony, flags, hit_zone, list/shared_blackboard)
	. = ..()
	power_charge = between(0, power_charge + round(damage / 10), 10)

// Getting slimebatoned/xenotased.
/mob/living/simple_mob/slime/xenobio/slimebatoned(mob/living/user, amount)
	adjust_discipline(round(amount/2))
	afflict_paralyze(20 * amount) // This needs to come afterwards or else it will always be considered abuse to the slime.
