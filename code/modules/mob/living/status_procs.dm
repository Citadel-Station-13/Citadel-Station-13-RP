////////////////////////////// STUN ////////////////////////////////////

/mob/living/proc/IsStun() //If we're stunned
	return has_status_effect(STATUS_EFFECT_STUN)

/mob/living/proc/AmountStun() //How many deciseconds remain in our stun
	var/datum/status_effect/incapacitating/stun/S = IsStun()
	if(S)
		return S.duration - world.time
	return 0

/mob/living/proc/Stun(amount, updating = TRUE, ignore_canstun = FALSE) //Can't go below remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_STUN, amount, updating, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if(!ignore_canstun && (HAS_TRAIT(src, TRAIT_NO_STUN) || HAS_TRAIT(src, TRAIT_FULL_STUN_IMMUNITY)))
		return
	if(absorb_stun(amount, ignore_canstun))
		return
	var/datum/status_effect/incapacitating/stun/S = IsStun()
	if(S)
		S.duration = max(world.time + amount, S.duration)
	else if(amount > 0)
		S = apply_status_effect(STATUS_EFFECT_STUN, amount, updating)
	return S

/mob/living/proc/SetStun(amount, updating = TRUE, ignore_canstun = FALSE) //Sets remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_STUN, amount, updating, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if(((amount > 0) && !ignore_canstun) && (HAS_TRAIT(src, TRAIT_NO_STUN) || HAS_TRAIT(src, TRAIT_FULL_STUN_IMMUNITY)))
		return
	var/datum/status_effect/incapacitating/stun/S = IsStun()
	if(amount <= 0)
		if(S)
			qdel(S)
	else
		if(absorb_stun(amount, ignore_canstun))
			return
		if(S)
			S.duration = world.time + amount
		else
			S = apply_status_effect(STATUS_EFFECT_STUN, amount, updating)
	return S

/mob/living/proc/AdjustStun(amount, updating = TRUE, ignore_canstun = FALSE) //Adds to remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_STUN, amount, updating, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if(((amount > 0) && !ignore_canstun) && (HAS_TRAIT(src, TRAIT_NO_STUN) || HAS_TRAIT(src, TRAIT_FULL_STUN_IMMUNITY)))
		return
	if(absorb_stun(amount, ignore_canstun))
		return
	var/datum/status_effect/incapacitating/stun/S = IsStun()
	if(S)
		S.duration += amount
	else if(amount > 0)
		S = apply_status_effect(STATUS_EFFECT_STUN, amount, updating)
	return S

///////////////////////////////// KNOCKDOWN /////////////////////////////////////

/mob/living/proc/IsKnockdown() //If we're knocked down
	return has_status_effect(STATUS_EFFECT_KNOCKDOWN)

/mob/living/proc/AmountKnockdown() //How many deciseconds remain in our knockdown
	var/datum/status_effect/incapacitating/knockdown/K = IsKnockdown()
	if(K)
		return K.duration - world.time
	return 0

/mob/living/proc/Knockdown(amount, updating = TRUE, ignore_canstun = FALSE) //Can't go below remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_KNOCKDOWN, amount, updating, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if(((amount > 0) && !ignore_canstun) && (HAS_TRAIT(src, TRAIT_NO_KNOCKDOWN) || HAS_TRAIT(src, TRAIT_FULL_STUN_IMMUNITY)))
		return
	if(absorb_stun(amount, ignore_canstun))
		return
	var/datum/status_effect/incapacitating/knockdown/K = IsKnockdown()
	if(K)
		K.duration = max(world.time + amount, K.duration)
	else if(amount > 0)
		K = apply_status_effect(STATUS_EFFECT_KNOCKDOWN, amount, updating)
	return K

/mob/living/proc/SetKnockdown(amount, updating = TRUE, ignore_canstun = FALSE) //Sets remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_KNOCKDOWN, amount, updating, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if(((amount > 0) && !ignore_canstun) && (HAS_TRAIT(src, TRAIT_NO_KNOCKDOWN) || HAS_TRAIT(src, TRAIT_FULL_STUN_IMMUNITY)))
		return
	var/datum/status_effect/incapacitating/knockdown/K = IsKnockdown()
	if(amount <= 0)
		if(K)
			qdel(K)
	else
		if(absorb_stun(amount, ignore_canstun))
			return
		if(K)
			K.duration = world.time + amount
		else
			K = apply_status_effect(STATUS_EFFECT_KNOCKDOWN, amount, updating)
	return K

/mob/living/proc/AdjustKnockdown(amount, updating = TRUE, ignore_canstun = FALSE) //Adds to remaining duration
	if(((amount > 0) && !ignore_canstun) && (HAS_TRAIT(src, TRAIT_NO_KNOCKDOWN) || HAS_TRAIT(src, TRAIT_FULL_STUN_IMMUNITY)))
		return
	if(!ignore_canstun && (!(status_flags & CANKNOCKDOWN) || HAS_TRAIT(src, TRAIT_STUNIMMUNE)))
		return
	if(absorb_stun(amount, ignore_canstun))
		return
	var/datum/status_effect/incapacitating/knockdown/K = IsKnockdown()
	if(K)
		K.duration += amount
	else if(amount > 0)
		K = apply_status_effect(STATUS_EFFECT_KNOCKDOWN, amount, updating)
	return K

///////////////////////////////// IMMOBILIZED ////////////////////////////////////
/mob/living/proc/IsImmobilized() //If we're immobilized
	return has_status_effect(STATUS_EFFECT_IMMOBILIZED)

/mob/living/proc/AmountImmobilized() //How many deciseconds remain in our Immobilized status effect
	var/datum/status_effect/incapacitating/immobilized/I = IsImmobilized()
	if(I)
		return I.duration - world.time
	return 0

/mob/living/proc/Immobilize(amount, updating = TRUE, ignore_canstun = FALSE) //Can't go below remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_IMMOBILIZE, amount, updating, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if(((amount > 0) && !ignore_canstun) && (HAS_TRAIT(src, TRAIT_NO_IMMOBILIZE) || HAS_TRAIT(src, TRAIT_FULL_STUN_IMMUNITY)))
		return
	if(absorb_stun(amount, ignore_canstun))
		return
	var/datum/status_effect/incapacitating/immobilized/I = IsImmobilized()
	if(I)
		I.duration = max(world.time + amount, I.duration)
	else if(amount > 0)
		I = apply_status_effect(STATUS_EFFECT_IMMOBILIZED, amount, updating)
	return I

/mob/living/proc/SetImmobilized(amount, updating = TRUE, ignore_canstun = FALSE) //Sets remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_IMMOBILIZE, amount, updating, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if(((amount > 0) && !ignore_canstun) && (HAS_TRAIT(src, TRAIT_NO_IMMOBILIZE) || HAS_TRAIT(src, TRAIT_FULL_STUN_IMMUNITY)))
		return
	var/datum/status_effect/incapacitating/immobilized/I = IsImmobilized()
	if(amount <= 0)
		if(I)
			qdel(I)
	else
		if(absorb_stun(amount, ignore_canstun))
			return
		if(I)
			I.duration = world.time + amount
		else
			I = apply_status_effect(STATUS_EFFECT_IMMOBILIZED, amount, updating)
	return I

/mob/living/proc/AdjustImmobilized(amount, updating = TRUE, ignore_canstun = FALSE) //Adds to remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_IMMOBILIZE, amount, updating, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if(((amount > 0) && !ignore_canstun) && (HAS_TRAIT(src, TRAIT_NO_IMMOBILIZE) || HAS_TRAIT(src, TRAIT_FULL_STUN_IMMUNITY)))
		return
	if(absorb_stun(amount, ignore_canstun))
		return
	var/datum/status_effect/incapacitating/immobilized/I = IsImmobilized()
	if(I)
		I.duration += amount
	else if(amount > 0)
		I = apply_status_effect(STATUS_EFFECT_IMMOBILIZED, amount, updating)
	return I

///////////////////////////////// PARALYZED //////////////////////////////////
/mob/living/proc/IsParalyzed() //If we're immobilized
	return has_status_effect(STATUS_EFFECT_PARALYZED)

/mob/living/proc/AmountParalyzed() //How many deciseconds remain in our Paralyzed status effect
	var/datum/status_effect/incapacitating/paralyzed/P = IsParalyzed(FALSE)
	if(P)
		return P.duration - world.time
	return 0

/mob/living/proc/Paralyze(amount, updating = TRUE, ignore_canstun = FALSE) //Can't go below remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_PARALYZE, amount, updating, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if(((amount > 0) && !ignore_canstun) && (HAS_TRAIT(src, TRAIT_NO_PARALYZE) || HAS_TRAIT(src, TRAIT_FULL_STUN_IMMUNITY)))
		return
	if(absorb_stun(amount, ignore_canstun))
		return
	var/datum/status_effect/incapacitating/paralyzed/P = IsParalyzed(FALSE)
	if(P)
		P.duration = max(world.time + amount, P.duration)
	else if(amount > 0)
		P = apply_status_effect(STATUS_EFFECT_PARALYZED, amount, updating)
	return P

/mob/living/proc/SetParalyzed(amount, updating = TRUE, ignore_canstun = FALSE) //Sets remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_PARALYZE, amount, updating, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if(((amount > 0) && !ignore_canstun) && (HAS_TRAIT(src, TRAIT_NO_PARALYZE) || HAS_TRAIT(src, TRAIT_FULL_STUN_IMMUNITY)))
		return
	var/datum/status_effect/incapacitating/paralyzed/P = IsParalyzed(FALSE)
	if(amount <= 0)
		if(P)
			qdel(P)
	else
		if(absorb_stun(amount, ignore_canstun))
			return
		if(P)
			P.duration = world.time + amount
		else
			P = apply_status_effect(STATUS_EFFECT_PARALYZED, amount, updating)
	return P

/mob/living/proc/AdjustParalyzed(amount, updating = TRUE, ignore_canstun = FALSE) //Adds to remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_PARALYZE, amount, updating, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if(((amount > 0) && !ignore_canstun) && (HAS_TRAIT(src, TRAIT_NO_PARALYZE) || HAS_TRAIT(src, TRAIT_FULL_STUN_IMMUNITY)))
		return
	if(absorb_stun(amount, ignore_canstun))
		return
	var/datum/status_effect/incapacitating/paralyzed/P = IsParalyzed(FALSE)
	if(P)
		P.duration += amount
	else if(amount > 0)
		P = apply_status_effect(STATUS_EFFECT_PARALYZED, amount, updating)
	return P

///////////////////////////////// DAZED ////////////////////////////////////
/mob/living/proc/IsDazed() //If we're Dazed
	return has_status_effect(STATUS_EFFECT_DAZED)

/mob/living/proc/AmountDazed() //How many deciseconds remain in our Dazed status effect
	var/datum/status_effect/incapacitating/dazed/I = IsDazed()
	if(I)
		return I.duration - world.time
	return 0

/mob/living/proc/Daze(amount, updating = TRUE, ignore_canstun = FALSE) //Can't go below remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_DAZE, amount, updating, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if(((amount > 0) && !ignore_canstun) && (HAS_TRAIT(src, TRAIT_NO_DAZE) || HAS_TRAIT(src, TRAIT_FULL_STUN_IMMUNITY)))
		return
	if(absorb_stun(amount, ignore_canstun))
		return
	var/datum/status_effect/incapacitating/dazed/I = IsDazed()
	if(I)
		I.duration = max(world.time + amount, I.duration)
	else if(amount > 0)
		I = apply_status_effect(STATUS_EFFECT_DAZED, amount, updating)
	return I

/mob/living/proc/SetDazed(amount, updating = TRUE, ignore_canstun = FALSE) //Sets remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_DAZE, amount, updating, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if(((amount > 0) && !ignore_canstun) && (HAS_TRAIT(src, TRAIT_NO_DAZE) || HAS_TRAIT(src, TRAIT_FULL_STUN_IMMUNITY)))
		return
	var/datum/status_effect/incapacitating/dazed/I = IsDazed()
	if(amount <= 0)
		if(I)
			qdel(I)
	else
		if(absorb_stun(amount, ignore_canstun))
			return
		if(I)
			I.duration = world.time + amount
		else
			I = apply_status_effect(STATUS_EFFECT_DAZED, amount, updating)
	return I

/mob/living/proc/AdjustDazed(amount, updating = TRUE, ignore_canstun = FALSE) //Adds to remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_DAZE, amount, updating, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if(((amount > 0) && !ignore_canstun) && (HAS_TRAIT(src, TRAIT_NO_DAZE) || HAS_TRAIT(src, TRAIT_FULL_STUN_IMMUNITY)))
		return
	if(absorb_stun(amount, ignore_canstun))
		return
	var/datum/status_effect/incapacitating/dazed/I = IsDazed()
	if(I)
		I.duration += amount
	else if(amount > 0)
		I = apply_status_effect(STATUS_EFFECT_DAZED, amount, updating)
	return I

//Blanket
/mob/living/proc/AllImmobility(amount, updating, ignore_canstun = FALSE)
	Paralyze(amount, FALSE, ignore_canstun)
	Knockdown(amount, FALSE, ignore_canstun)
	Stun(amount, FALSE, ignore_canstun)
	Immobilize(amount, FALSE, ignore_canstun)
	Daze(amount, FALSE, ignore_canstun)
	// Stagger(amount, FALSE, ignore_canstun)
	if(updating)
		update_mobility()

/mob/living/proc/SetAllImmobility(amount, updating, ignore_canstun = FALSE)
	SetParalyzed(amount, FALSE, ignore_canstun)
	SetKnockdown(amount, FALSE, ignore_canstun)
	SetStun(amount, FALSE, ignore_canstun)
	SetImmobilized(amount, FALSE, ignore_canstun)
	SetDazed(amount, FALSE, ignore_canstun)
	// SetStaggered(amount, FALSE, ignore_canstun)
	if(updating)
		update_mobility()

/mob/living/proc/AdjustAllImmobility(amount, updating, ignore_canstun = FALSE)
	AdjustParalyzed(amount, FALSE, ignore_canstun)
	AdjustKnockdown(amount, FALSE, ignore_canstun)
	AdjustStun(amount, FALSE, ignore_canstun)
	AdjustImmobilized(amount, FALSE, ignore_canstun)
	AdjustDazed(amount, FALSE, ignore_canstun)
	// AdjustStaggered(amount, FALSE, ignore_canstun)
	if(updating)
		update_mobility()

/// Makes sure all 5 of the non-knockout immobilizing status effects are lower or equal to amount.
/mob/living/proc/HealAllImmobilityUpTo(amount, updating, ignore_canstun = FALSE)
	if(AmountStun() > amount)
		SetStun(amount, FALSE, ignore_canstun)
	if(AmountKnockdown() > amount)
		SetKnockdown(amount, FALSE, ignore_canstun)
	if(AmountParalyzed() > amount)
		SetParalyzed(amount, FALSE, ignore_canstun)
	if(AmountImmobilized() > amount)
		SetImmobilized(amount, FALSE, ignore_canstun)
	if(AmountDazed() > amount)
		SetImmobilized(amount, FALSE, ignore_canstun)
	// if(AmountStaggered() > amount)
	// 	SetStaggered(amount, FALSE, ignore_canstun)
	if(updating)
		update_mobility()

/mob/living/proc/HighestImmobilityAmount()
	return max(AmountStun(), AmountKnockdown(), AmountParalyzed(), AmountImmobilized(), AmountDazed()) // , AmountStaggered())

//////////////////UNCONSCIOUS
/mob/living/proc/IsUnconscious() //If we're unconscious
	return has_status_effect(STATUS_EFFECT_UNCONSCIOUS)

/mob/living/proc/AmountUnconscious() //How many deciseconds remain in our unconsciousness
	var/datum/status_effect/incapacitating/unconscious/U = IsUnconscious()
	if(U)
		return U.duration - world.time
	return 0

/mob/living/proc/Unconscious(amount, updating = TRUE, ignore_canstun = FALSE) //Can't go below remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_UNCONSCIOUS, amount, updating, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if(((amount > 0) && !ignore_canstun) && (HAS_TRAIT(src, TRAIT_NO_UNCONSCIOUS) || HAS_TRAIT(src, TRAIT_FULL_STUN_IMMUNITY)))
		return
	var/datum/status_effect/incapacitating/unconscious/U = IsUnconscious()
	if(U)
		U.duration = max(world.time + amount, U.duration)
	else if(amount > 0)
		U = apply_status_effect(STATUS_EFFECT_UNCONSCIOUS, amount, updating)
	return U

/mob/living/proc/SetUnconscious(amount, updating = TRUE, ignore_canstun = FALSE) //Sets remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_UNCONSCIOUS, amount, updating, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if(((amount > 0) && !ignore_canstun) && (HAS_TRAIT(src, TRAIT_NO_UNCONSCIOUS) || HAS_TRAIT(src, TRAIT_FULL_STUN_IMMUNITY)))
		return
	var/datum/status_effect/incapacitating/unconscious/U = IsUnconscious()
	if(amount <= 0)
		if(U)
			qdel(U)
	else if(U)
		U.duration = world.time + amount
	else
		U = apply_status_effect(STATUS_EFFECT_UNCONSCIOUS, amount, updating)
	return U

/mob/living/proc/AdjustUnconscious(amount, updating = TRUE, ignore_canstun = FALSE) //Adds to remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_UNCONSCIOUS, amount, updating, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if(((amount > 0) && !ignore_canstun) && (HAS_TRAIT(src, TRAIT_NO_UNCONSCIOUS) || HAS_TRAIT(src, TRAIT_FULL_STUN_IMMUNITY)))
		return
	var/datum/status_effect/incapacitating/unconscious/U = IsUnconscious()
	if(U)
		U.duration += amount
	else if(amount > 0)
		U = apply_status_effect(STATUS_EFFECT_UNCONSCIOUS, amount, updating)
	return U

/////////////////////////////////// SLEEPING ////////////////////////////////////

/mob/living/proc/IsSleeping() //If we're asleep
	return has_status_effect(STATUS_EFFECT_SLEEPING)

/mob/living/proc/AmountSleeping() //How many deciseconds remain in our sleep
	var/datum/status_effect/incapacitating/sleeping/S = IsSleeping()
	if(S)
		return S.duration - world.time
	return 0

/mob/living/proc/Sleeping(amount, updating = TRUE, ignore_canstun = FALSE) //Can't go below remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_SLEEP, amount, updating, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if(((amount > 0) && !ignore_canstun) && (HAS_TRAIT(src, TRAIT_NO_SLEEPING) || HAS_TRAIT(src, TRAIT_FULL_STUN_IMMUNITY)))
		return
	var/datum/status_effect/incapacitating/sleeping/S = IsSleeping()
	if(S)
		S.duration = max(world.time + amount, S.duration)
	else if(amount > 0)
		S = apply_status_effect(STATUS_EFFECT_SLEEPING, amount, updating)
	return S

/mob/living/proc/SetSleeping(amount, updating = TRUE, ignore_canstun = FALSE) //Sets remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_SLEEP, amount, updating, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if(((amount > 0) && !ignore_canstun) && (HAS_TRAIT(src, TRAIT_NO_SLEEPING) || HAS_TRAIT(src, TRAIT_FULL_STUN_IMMUNITY)))
		retur
	var/datum/status_effect/incapacitating/sleeping/S = IsSleeping()
	if(amount <= 0)
		if(S)
			qdel(S)
	else if(S)
		S.duration = world.time + amount
	else
		S = apply_status_effect(STATUS_EFFECT_SLEEPING, amount, updating)
	return S

/mob/living/proc/AdjustSleeping(amount, updating = TRUE, ignore_canstun = FALSE) //Adds to remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_SLEEP, amount, updating, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if(((amount > 0) && !ignore_canstun) && (HAS_TRAIT(src, TRAIT_NO_SLEEPING) || HAS_TRAIT(src, TRAIT_FULL_STUN_IMMUNITY)))
		return
	var/datum/status_effect/incapacitating/sleeping/S = IsSleeping()
	if(S)
		S.duration += amount
	else if(amount > 0)
		S = apply_status_effect(STATUS_EFFECT_SLEEPING, amount, updating)
	return S

