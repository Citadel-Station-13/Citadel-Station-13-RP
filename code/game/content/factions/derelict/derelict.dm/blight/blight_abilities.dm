/mob/living/simple_mob/animal/space/blight/melee/dasher/apply_bonus_melee_damage(atom/A, damage_amount)
	if(isliving(A))
		var/mob/living/L = A
		if(L.incapacitated(INCAPACITATION_DISABLED))
			return damage_amount * 1.5
	return ..()


// The actual leaping attack.
/mob/living/simple_mob/animal/space/blight/melee/dasher/do_special_attack(atom/A)
	set waitfor = FALSE
	set_AI_busy(TRUE)

	// Telegraph, since getting stunned suddenly feels bad.
	do_windup_animation(A, leap_warmup)
	sleep(leap_warmup) // For the telegraphing.

	// Do the actual leap.
	status_flags |= STATUS_LEAPING // Lets us pass over everything.
	visible_message(SPAN_DANGER("\The [src] leaps at \the [A]!"))
	throw_at_old(get_step(get_turf(A), get_turf(src)), special_attack_max_range+1, 1, src)

	sleep(5) // For the throw to complete. It won't hold up the AI SSticker due to waitfor being false.

	if(status_flags & STATUS_LEAPING)
		status_flags &= ~STATUS_LEAPING // Revert special passage ability.

	var/turf/T = get_turf(src) // Where we landed. This might be different than A's turf.

	. = FALSE

	// Now for the stun.
	var/mob/living/victim = null
	for(var/mob/living/L in T) // So player-controlled spiders only need to click the tile to stun them.
		if(L == src)
			continue

		var/list/shieldcall_result = L.atom_shieldcall(
			40,
			DAMAGE_TYPE_BRUTE,
			3,
			ARMOR_MELEE,
			NONE,
			ATTACK_TYPE_MELEE,
		)
		if(shieldcall_result[SHIELDCALL_ARG_FLAGS] & SHIELDCALL_FLAGS_BLOCK_ATTACK)
			continue

		victim = L
		break

	if(victim)
		victim.afflict_paralyze(20 * 2)
		victim.visible_message(SPAN_DANGER("\The [src] knocks down \the [victim]!"))
		to_chat(victim, SPAN_CRITICAL("\The [src] jumps on you!"))
		. = TRUE

	set_AI_busy(FALSE)
