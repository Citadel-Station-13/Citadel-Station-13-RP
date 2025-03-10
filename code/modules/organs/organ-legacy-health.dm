
/obj/item/organ/proc/update_health()
	// TODO: refactor, this should only be on internal!
	if(damage >= max_damage)
		die()

/obj/item/organ/proc/is_dead()
	return (status & ORGAN_DEAD)

/**
 * Checks if we can currently die.
 */
/obj/item/organ/proc/can_die()
	return (robotic < ORGAN_ROBOT)

/**
 * Called to kill this organ.
 *
 * @params
 * * force - ignore can_die()
 *
 * @return TRUE / FALSE based on if this actually killed the organ. Returns TRUE if the organ was already dead.
 */
/obj/item/organ/proc/die(force = FALSE)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(!can_die() && !force)
		return FALSE
	if(is_dead())
		return TRUE
	status |= ORGAN_DEAD
	damage = max_damage
	on_die()
	if(owner)
		handle_organ_mod_special(TRUE)
		if(vital)
			owner.death()
	reconsider_processing()
	return TRUE

/**
 * Called when we die (*not* our owner).
 */
/obj/item/organ/proc/on_die()
	return

/**
 * Checks if we're currently able to be revived.
 */
/obj/item/organ/proc/can_revive()
	return damage < max_damage

/**
 * Called to heal all damages
 */
/obj/item/organ/proc/rejuvenate()
	damage = 0
	germ_level = 0

/**
 * Called to bring us back to life.
 *
 * @params
 * * full_heal - heal all maladies
 * * force - ignore can_revive()
 *
 * @return TRUE / FALSE based on if this actually ended up reviving the organ. Returns TRUE if organ was already alive.
 */
/obj/item/organ/proc/revive(full_heal = FALSE, force = FALSE)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(full_heal)
		rejuvenate()
	if(!is_dead())
		return TRUE
	if(!can_revive() && !force)
		return FALSE
	status &= ~ORGAN_DEAD
	on_revive()
	if(owner)
		handle_organ_mod_special(FALSE)
	reconsider_processing()
	return TRUE

/**
 * Called when we're brought back to life.
 */
/obj/item/organ/proc/on_revive()
	return
