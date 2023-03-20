/**
 * calculates the resulting damage from an attack, taking into account our armor and soak
 *
 * @params
 * * damage - raw damage
 * * tier - penetration / attack tier
 * * flag - armor flag as seen in [code/__DEFINES/combat/armor.dm]
 * * mode - reserved - todo: pointer to damage mode to allow for dampening of piercing / etc.
 * * attack_type - (optional) attack type flags from [code/__DEFINES/combat/attack_types.dm]
 * * weapon - (optional) attacking /obj/item for melee or thrown, /obj/projectile for ranged, /mob for unarmed
 * * target_zone - where it's impacting
 *
 * @return resulting damage
 */
/mob/proc/check_mob_armor(damage, tier, flag, mode, attack_type, datum/weapon, target_zone)
	damage = check_armor(damage, tier, flag, mode, attack_type, weapon)
	return damage

/**
 * runs armor against an incoming attack
 * this proc can have side effects
 *
 * @params
 * * damage - raw damage
 * * tier - penetration / attack tier
 * * flag - armor flag as seen in [code/__DEFINES/combat/armor.dm]
 * * mode - reserved - todo: pointer to damage mode to allow for dampening of piercing / etc.
 * * attack_type - (optional) attack type flags from [code/__DEFINES/combat/attack_types.dm]
 * * weapon - (optional) attacking /obj/item for melee or thrown, /obj/projectile for ranged, /mob for unarmed
 * * target_zone - where it's impacting
 *
 * @return resulting damage
 */
/mob/proc/run_mob_armor(damage, tier, flag, mode, attack_type, datum/weapon, target_zone)
	damage = run_armor(damage, tier, flag, mode, attack_type, weapon)
	return damage

/**
 * check overall armor
 */
/mob/proc/check_overall_armor(damage, tier, flag, mode, attack_type, datum/weapon, target_zone)
	damage = check_armor(damage, tier, flag, mode, attack_type, weapon)
	return damage

/**
 * check overall armor
 */
/mob/proc/run_overall_armor(damage, tier, flag, mode, attack_type, datum/weapon, target_zone)
	damage = run_armor(damage, tier, flag, mode, attack_type, weapon)
	return damage
