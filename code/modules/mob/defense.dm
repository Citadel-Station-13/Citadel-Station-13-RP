/**
 * calculates the resulting damage from an attack, taking into account our armor and soak
 *
 * @params
 * * damage - raw damage
 * * tier - penetration / attack tier
 * * flag - armor flag as seen in [code/__DEFINES/combat/armor.dm]
 * * mode - damage_mode
 * * attack_type - (optional) attack type flags from [code/__DEFINES/combat/attack_types.dm]
 * * weapon - (optional) attacking /obj/item for melee or thrown, /obj/projectile for ranged, /mob for unarmed
 * * target_zone - where it's impacting
 *
 * @return args as list.
 */
/mob/proc/check_mob_armor(damage, tier, flag, mode, attack_type, datum/weapon, target_zone)
	var/list/returned = check_armor(damage, tier, flag, mode, attack_type, weapon)
	damage = returned[1]
	mode = returned[4]
	return args.Copy()

/**
 * runs armor against an incoming attack
 * this proc can have side effects
 *
 * @params
 * * damage - raw damage
 * * tier - penetration / attack tier
 * * flag - armor flag as seen in [code/__DEFINES/combat/armor.dm]
 * * mode - damage_mode
 * * attack_type - (optional) attack type flags from [code/__DEFINES/combat/attack_types.dm]
 * * weapon - (optional) attacking /obj/item for melee or thrown, /obj/projectile for ranged, /mob for unarmed
 * * target_zone - where it's impacting
 *
 * @return args as list.
 */
/mob/proc/run_mob_armor(damage, tier, flag, mode, attack_type, datum/weapon, target_zone)
	var/list/returned = run_armor(damage, tier, flag, mode, attack_type, weapon)
	damage = returned[1]
	mode = returned[4]
	return args.Copy()

/**
 * check overall armor
 * does not support modifying damage modes.
 *
 * @params
 * * damage - raw damage
 * * tier - penetration / attack tier
 * * flag - armor flag as seen in [code/__DEFINES/combat/armor.dm]
 * * mode - damage_mode
 * * attack_type - (optional) attack type flags from [code/__DEFINES/combat/attack_types.dm]
 * * weapon - (optional) attacking /obj/item for melee or thrown, /obj/projectile for ranged, /mob for unarmed
 * * target_zone - where it's impacting
 *
 * @return args as list.
 */
/mob/proc/check_overall_armor(damage, tier, flag, mode, attack_type, datum/weapon, target_zone)
	var/list/returned = check_armor(damage, tier, flag, mode, attack_type, weapon)
	damage = returned[1]
	mode = returned[4]
	return args.Copy()

/**
 * runs overall armor against an incoming attack
 * this proc can have side effects
 * does not support modifying damage modes.
 *
 * @params
 * * damage - raw damage
 * * tier - penetration / attack tier
 * * flag - armor flag as seen in [code/__DEFINES/combat/armor.dm]
 * * mode - damage_mode
 * * attack_type - (optional) attack type flags from [code/__DEFINES/combat/attack_types.dm]
 * * weapon - (optional) attacking /obj/item for melee or thrown, /obj/projectile for ranged, /mob for unarmed
 * * target_zone - where it's impacting
 *
 * @return args as list.
 */
/mob/proc/run_overall_armor(damage, tier, flag, mode, attack_type, datum/weapon, target_zone)
	var/list/returned = run_armor(damage, tier, flag, mode, attack_type, weapon)
	damage = returned[1]
	mode = returned[4]
	return args.Copy()
