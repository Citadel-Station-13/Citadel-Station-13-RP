//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * A descriptor for a melee attack utilizing an item.
 */
/datum/melee_attack/weapon
	/// expected type of the weapon being used
	var/expected_type = /obj/item

/datum/melee_attack/weapon/perform_attack_impact(atom/movable/attacker, atom/target, missed, obj/item/weapon, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	var/list/results = target.run_damage_instance(
		weapon.damage_force * clickchain.attack_melee_multiplier,
		weapon.damage_type,
		weapon.damage_tier,
		weapon.damage_flag,
		weapon.damage_mode | (DAMAGE_MODE_REQUEST_ARMOR_BLUNTING | DAMAGE_MODE_REQUEST_ARMOR_RANDOMIZATION),
		ATTACK_TYPE_MELEE,
		clickchain,
		NONE,
		clickchain.target_zone,
	)
	clickchain.data[ACTOR_DATA_MELEE_DAMAGE_INSTANCE_RESULTS] = results
	target.on_melee_impact(attacker, weapon, src, clickchain.target_zone, clickchain, clickchain_flags, results)
	return clickchain_flags

/datum/melee_attack/weapon/perform_attack_animation(atom/movable/attacker, atom/target, missed, obj/item/weapon, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	if(!missed)
		target.animate_hit_by_weapon(attacker, weapon)
	return ..()

/datum/melee_attack/weapon/perform_attack_sound(atom/movable/attacker, atom/target, missed, obj/item/weapon, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	. = ..()
	if(.)
		return
	if(!weapon.damage_force)
		playsound(target, 'sound/weapons/tap.ogg', 50, TRUE, -1)
	else
		var/resolved = target.hitsound_melee(weapon)
		if(!isnull(resolved))
			playsound(target, resolved, 50, TRUE)

/datum/melee_attack/weapon/perform_attack_message(atom/movable/attacker, atom/target, missed, obj/item/weapon, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	. = ..()
	if(.)
		return
	if(!weapon.damage_force)
		clickchain.visible_feedback(
			target = target,
			range = MESSAGE_RANGE_COMBAT_LOUD,
			visible = SPAN_WARNING("[attacker] harmlessly taps [target] with [weapon]."),
			visible_them = SPAN_WARNING("[attacker] harmlessly taps you with [weapon]."),
			visible_self = SPAN_WARNING("You harmlessly tap [target] with [weapon].")
		)
	else
		clickchain.visible_feedback(
			target = target,
			range = MESSAGE_RANGE_COMBAT_LOUD,
			visible = SPAN_DANGER("[target] has been [islist(weapon.attack_verb)? pick(weapon.attack_verb) : weapon.attack_verb] with [weapon] by [attacker]!")
		)

/datum/melee_attack/weapon/estimate_damage(atom/movable/attacker, atom/target, obj/item/weapon)
	return weapon? weapon.damage_force : 0
