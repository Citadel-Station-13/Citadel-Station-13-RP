
/obj/item/organ/proc/is_damaged()
	return damage > 0

/obj/item/organ/proc/is_bruised()
	return damage >= min_bruised_damage

/obj/item/organ/proc/is_broken()
	return (damage >= min_broken_damage || (status & ORGAN_CUT_AWAY) || (status & ORGAN_BROKEN))

//Note: external organs have their own version of this proc
/obj/item/organ/proc/take_damage(amount, var/silent=0)
	ASSERT(amount >= 0)
	if(src.robotic >= ORGAN_ROBOT)
		src.damage = between(0, src.damage + (amount * 0.8), max_damage)
	else
		src.damage = between(0, src.damage + amount, max_damage)

		//only show this if the organ is not robotic
		if(owner && parent_organ && amount > 0)
			var/obj/item/organ/external/parent = owner?.legacy_organ_by_zone(parent_organ)
			if(parent && !silent)
				owner.custom_pain("Something inside your [parent.name] hurts a lot.", amount)

/obj/item/organ/proc/bruise()
	damage = max(damage, min_bruised_damage)

// todo: unified organ damage system
// for now, this is how to heal internal organs
/obj/item/organ/proc/heal_damage_i(amount, force, can_revive)
	ASSERT(amount > 0)
	var/dead = !!(status & ORGAN_DEAD)
	if(dead && !force && !can_revive)
		return FALSE
	//? which is better again..?
	// damage = clamp(damage - round(amount, DAMAGE_PRECISION), 0, max_damage)
	damage = clamp(round(damage - amount, DAMAGE_PRECISION), 0, max_damage)
	if(dead && can_revive)
		revive()
