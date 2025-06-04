//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* Melee Handling *//

/mob/living/carbon/human/on_melee_act(mob/attacker, obj/item/weapon, datum/melee_attack/attack_style, target_zone, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	// TODO: sparring / blocking
	return ..()

//* Throw Handling *//

/mob/living/carbon/human/throw_impacted(atom/movable/AM, datum/thrownthing/TT)
	if(isitem(AM) && in_throw_mode && CHECK_ALL_MOBILITY(src, MOBILITY_CAN_USE | MOBILITY_CAN_PICKUP))
		var/obj/item/trying_to_catch = AM
		if(TT.speed <= THROW_SPEED_CATCHABLE && can_catch(trying_to_catch) && put_in_active_hand(trying_to_catch))
			visible_message(
				SPAN_WARNING("[src] catches [trying_to_catch]!"),
			)
			throw_mode_off()
			return COMPONENT_THROW_HIT_NEVERMIND
	return ..()

//* Projectile Handling *//

/mob/living/carbon/human/on_bullet_act(obj/projectile/proj, impact_flags, list/bullet_act_args)
	. = ..()
	if(. & PROJECTILE_IMPACT_FLAGS_TARGET_ABORT)
		return

	if(impact_flags & PROJECTILE_IMPACT_BLOCKED)
		return

	// todo: this shit shouldn't be here
	var/obj/item/organ/external/organ = get_organ(bullet_act_args[BULLET_ACT_ARG_ZONE])

	if(!proj.nodamage)
		organ.add_autopsy_data("[proj.name]", proj.damage_force)

	//Shrapnel
	if(proj.can_embed())
		var/armor = getarmor_organ(organ, "bullet")
		if(!prob(armor/2))		//Even if the armor doesn't stop the bullet from hurting you, it might stop it from embedding.
			var/hit_embed_chance = proj.embed_chance + (proj.damage_force - armor)	//More damage equals more chance to embed
			if(prob(max(hit_embed_chance, 0)))
				var/obj/item/material/shard/shrapnel/SP = new(organ)
				SP.name = (proj.name != "shrapnel")? "[proj.name] shrapnel" : "shrapnel"
				SP.desc = "[SP.desc] It looks like it was fired from [proj.shot_from]."
				organ.embed(SP)

//* Misc Effects *//

/mob/living/carbon/human/slip_act(slip_class, source, hard_strength, soft_strength, suppressed)
	var/footcoverage_check = length(inventory.query_coverage(FEET))
	var/obj/item/shoes = inventory.get_slot_single(/datum/inventory_slot/inventory/shoes)
	if(((species.species_flags & NO_SLIP) && !footcoverage_check) || (shoes && (shoes.clothing_flags & NOSLIP))) //Footwear negates a species' natural traction.
		return 0
	return ..()
