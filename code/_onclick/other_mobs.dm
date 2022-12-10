// Generic damage proc (slimes and monkeys).
/atom/proc/attack_generic(mob/user as mob)
	return 0

/atom/proc/attack_alien(mob/user)

/atom/proc/take_damage(var/damage)
	return 0

/*
	Humans:
	Adds an exception for gloves, to allow special glove types like the ninja ones.

	Otherwise pretty standard.
*/
/mob/living/carbon/human/UnarmedAttack(atom/A, proximity)
	// if(HAS_TRAIT(src, TRAIT_HANDS_BLOCKED))
	// 	if(src == A)
	// 		check_self_for_injuries()
	// 	return
	if(!..())
		return

	// Special glove functions:
	// If the gloves do anything, have them return 1 to stop
	// normal attack_hand() here.
	var/obj/item/clothing/gloves/G = gloves // not typecast specifically enough in defines
	if(istype(G) && G.Touch(A,1))
		return

	A.attack_hand(src)


/**
 * Return TRUE to cancel other attack hand effects that respect it.
 * Modifiers is the assoc list for click info such as if it was a right click.
 */
/atom/proc/attack_hand(mob/user, list/modifiers)
	. = FALSE
	if(!(interaction_flags_atom & INTERACT_ATOM_NO_FINGERPRINT_ON_TOUCH))
		add_fingerprint(user)
	if(SEND_SIGNAL(src, COMSIG_ATOM_ATTACK_HAND, user, modifiers))
		. = TRUE
	if(interaction_flags_atom & INTERACT_ATOM_ATTACK_HAND)
		. = _try_interact(user)


/**
 * Return a non FALSE value to cancel whatever called this from propagating, if it respects it.
 */
/atom/proc/_try_interact(mob/user)
	if(isAdminGhostAI(user)) //admin abuse
		return interact(user)
	if(can_interact(user))
		return interact(user)
	return FALSE

/atom/proc/can_interact(mob/user, require_adjacent_turf = TRUE)
	if(!user.can_interact_with(src, interaction_flags_atom & INTERACT_ATOM_ALLOW_USER_LOCATION))
		return FALSE
	if((interaction_flags_atom & INTERACT_ATOM_REQUIRES_DEXTERITY) && !user.IsAdvancedToolUser())
		to_chat(user, SPAN_WARNING("You don't have the dexterity to do this!"))
		return FALSE
	if(!(interaction_flags_atom & INTERACT_ATOM_IGNORE_INCAPACITATED))
		//! Pointless without TG's Incapacitated status effect flags. @Zandario
		// var/ignore_flags = NONE
		// if(interaction_flags_atom & INTERACT_ATOM_IGNORE_RESTRAINED)
		// 	ignore_flags |= IGNORE_RESTRAINTS
		// if(!(interaction_flags_atom & INTERACT_ATOM_CHECK_GRAB))
		// 	ignore_flags |= IGNORE_GRAB

		if(user.incapacitated())
		// if(user.incapacitated(ignore_flags))
			return FALSE
	return TRUE

/atom/ui_status(mob/user)
	. = ..()
	/// Check if both user and atom are at the same location.
	if(!can_interact(user))
		. = min(., UI_UPDATE)

/atom/movable/can_interact(mob/user)
	. = ..()
	if(!.)
		return
	if(!anchored && (interaction_flags_atom & INTERACT_ATOM_REQUIRES_ANCHORED))
		return FALSE

/atom/proc/interact(mob/user)
	if(interaction_flags_atom & INTERACT_ATOM_NO_FINGERPRINT_INTERACT)
		add_hiddenprint(user)
	else
		add_fingerprint(user)
	if(interaction_flags_atom & INTERACT_ATOM_UI_INTERACT)
		// SEND_SIGNAL(src, COMSIG_ATOM_UI_INTERACT, user)
		ui_interact(user)
		nano_ui_interact(user)
		return
	return FALSE

/mob/living/carbon/human/RestrainedClickOn(atom/A)
	return

/mob/living/carbon/human/RangedAttack(atom/A)
	. = ..()
	if(.)
		return
	if(isturf(A) && get_dist(A, src) <= 1)
		move_pulled_towards(A)
		return
	if(!gloves && !mutations.len && !spitting)
		return
	var/obj/item/clothing/gloves/G = gloves

	if(istype(G) && G.Touch(A,0)) // for magic gloves
		return

	else if(MUTATION_TELEKINESIS in mutations)
		A.attack_tk(src)

	else if(spitting) //Only used by xenos right now, can be expanded.
		Spit(A)

/mob/living/RestrainedClickOn(atom/A)
	return

/**
 *! Animals & All Unspecified
 */
// /mob/living/UnarmedAttack(atom/A)
// 	A.attack_animal(src)

// /atom/proc/attack_animal(mob/user)
// 	SEND_SIGNAL(src, COMSIG_ATOM_ATTACK_ANIMAL, user)

/**
 *! Aliens
 */

/mob/living/carbon/alien/RestrainedClickOn(var/atom/A)
	return

/mob/living/carbon/alien/UnarmedAttack(atom/A)
	if(!..())
		return FALSE

	setClickCooldown(get_attack_speed())
	A.attack_generic(src,rand(5,6),"bitten")

/**
 * ! pAI
 * Stops runtimes due to attack_animal being the default
 */
/mob/living/silicon/pai/UnarmedAttack(atom/A)//
	return

/**
 * New Players:
 * Have no reason to click on anything at all.
 */
/mob/new_player/ClickOn()
	return
