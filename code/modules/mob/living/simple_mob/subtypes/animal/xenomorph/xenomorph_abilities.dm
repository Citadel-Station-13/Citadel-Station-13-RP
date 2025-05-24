
// Breaker Charge

/mob/living/simple_mob/animal/space/xenomorph/breaker/do_special_attack(atom/A)
	var/charge_warmup = 1 SECOND // How long the leap telegraphing is.
	var/charge_sound = 'sound/mobs/biomorphs/breaker_charge.ogg'
	set waitfor = FALSE
	set_AI_busy(TRUE)
	charging = 1
	movement_shake_radius = 5
	movement_sound = 'sound/mobs/biomorphs/breaker_charge.ogg'
	visible_message("<span class='warning'>\The [src] prepares to charge at \the [A]!</span>")
	sleep(charging_warning)
	playsound(src, charge_sound, 75, 1)
	do_windup_animation(A, charge_warmup) ///This was stolen from the Hunter Spiders means you can see them prepare to charge
	sleep(charge_warmup)
	update_icon()
	var/chargeturf = get_turf(A)
	if(!chargeturf)
		return
	var/chargedir = get_dir(src, chargeturf)
	setDir(chargedir)
	var/turf/T = get_ranged_target_turf(chargeturf, chargedir, IS_DIAGONAL(chargedir) ? 1 : 2)
	if(!T)
		charging = 0
		movement_shake_radius = null
		movement_sound = 'sound/mobs/biomorphs/breaker_walk_stomp.ogg'
		update_icon()
		visible_message("<span class='warning'>\The [src] desists from charging at \the [A]</span>")
		return
	for(var/distance = get_dist(src.loc, T), src.loc!=T && distance>0, distance--)
		var/movedir = get_dir(src.loc, T)
		var/moveturf = get_step(src.loc, movedir)
		SelfMove(moveturf, movedir, 2)
		sleep(2 * world.tick_lag) //Speed it will move, default is two server ticks. You may want to slow it down a lot.
	sleep((get_dist(src, T) * 2.2))
	charging = 0
	update_icon()
	movement_shake_radius = 0
	movement_sound = 'sound/mobs/biomorphs/breaker_walk_stomp.ogg'
	set_AI_busy(FALSE)

/mob/living/simple_mob/animal/space/xenomorph/breaker/Bump(atom/movable/AM)
	if(charging)
		visible_message("<span class='warning'>[src] rams [AM]!</span>")
		if(istype(AM, /mob/living))
			var/mob/living/M = AM
			M.afflict_paralyze(1 SECONDS)
			M.afflict_knockdown(2 SECONDS)
			var/throwdir = pick(turn(dir, 45), turn(dir, -45))
			M.throw_at_old(get_step(src.loc, throwdir), 1, 1, src)
			runOver(M) // Actually should not use this, placeholder
		else if(isobj(AM))
			AM.inflict_atom_damage(charge_damage, charge_damage_tier, charge_damage_flag, charge_damage_mode, ATTACK_TYPE_MELEE)
	..()

/mob/living/simple_mob/animal/space/xenomorph/breaker/proc/runOver(var/mob/living/M)
	if(istype(M))
		visible_message("<span class='warning'>[src] runs [M] over!</span>")
		playsound(src, "sound/mobs/biomorphs/breaker_charge_hit.ogg", 50, 1)
		// todo: this ignores charge_damage
		var/damage = rand(3,4)
		M.apply_damage(2 * damage, DAMAGE_TYPE_BRUTE, BP_HEAD)
		M.apply_damage(2 * damage, DAMAGE_TYPE_BRUTE, BP_TORSO)
		M.apply_damage(0.5 * damage, DAMAGE_TYPE_BRUTE, BP_L_LEG)
		M.apply_damage(0.5 * damage, DAMAGE_TYPE_BRUTE, BP_R_LEG)
		M.apply_damage(0.5 * damage, DAMAGE_TYPE_BRUTE, BP_L_ARM)
		M.apply_damage(0.5 * damage, DAMAGE_TYPE_BRUTE, BP_R_ARM)

		var/datum/blood_mixture/to_use
		if(iscarbon(M))
			var/mob/living/carbon/carbon = M
			to_use = carbon.get_blood_mixture()
		blood_splatter_legacy(get_turf(M), to_use, TRUE)

/mob/living/simple_mob/animal/space/xenomorph/breaker/apply_melee_effects(atom/A)
	if(isliving(A))
		var/mob/living/L = A
		if(L.mob_size <= MOB_MEDIUM)
			visible_message(SPAN_DANGER("\The [src] sends \the [L] flying with their heavy claws!"))
			playsound(src, "sound/mobs/biomorphs/breaker_slam.ogg", 50, 1)
			var/throw_dir = get_dir(src, L)
			var/throw_dist = L.incapacitated(INCAPACITATION_DISABLED) ? 4 : 1
			L.throw_at_old(get_edge_target_turf(L, throw_dir), throw_dist, 1, src)
		else
			to_chat(L, SPAN_WARNING( "\The [src] punches you with incredible force, but you remain in place."))

// Monarch Charge

/mob/living/simple_mob/animal/space/xenomorph/monarch/update_icon()
	if(charging)
		icon_state = "monarch_charge-charge"
	..()

/mob/living/simple_mob/animal/space/xenomorph/monarch/do_special_attack(atom/A)
	var/charge_warmup = 0 SECOND // How long the leap telegraphing is.
	var/charge_sound = 'sound/mobs/biomorphs/monarch_charge.ogg'
	set waitfor = FALSE
	set_AI_busy(TRUE)
	charging = 1
	movement_shake_radius = 5
	movement_sound = 'sound/mobs/biomorphs/monarch_charge.ogg'
	visible_message("<span class='warning'>\The [src] prepares to charge at \the [A]!</span>")
	sleep(charging_warning)
	playsound(src, charge_sound, 75, 1)
	do_windup_animation(A, charge_warmup) ///This was stolen from the Hunter Spiders means you can see them prepare to charge
	sleep(charge_warmup)
	update_icon()
	var/chargeturf = get_turf(A)
	if(!chargeturf)
		return
	var/chargedir = get_dir(src, chargeturf)
	setDir(chargedir)
	var/turf/T = get_ranged_target_turf(chargeturf, chargedir, IS_DIAGONAL(chargedir) ? 1 : 2)
	if(!T)
		charging = 0
		movement_shake_radius = null
		movement_sound = 'sound/mobs/biomorphs/monarch_move.ogg'
		update_icon()
		visible_message("<span class='warning'>\The [src] desists from charging at \the [A]</span>")
		return
	for(var/distance = get_dist(src.loc, T), src.loc!=T && distance>0, distance--)
		var/movedir = get_dir(src.loc, T)
		var/moveturf = get_step(src.loc, movedir)
		SelfMove(moveturf, movedir, 2)
		sleep(2 * world.tick_lag) //Speed it will move, default is two server ticks. You may want to slow it down a lot.
	sleep((get_dist(src, T) * 2.2))
	charging = 0
	update_icon()
	movement_shake_radius = 0
	movement_sound = 'sound/mobs/biomorphs/monarch_move.ogg'
	set_AI_busy(FALSE)

/mob/living/simple_mob/animal/space/xenomorph/monarch/Bump(atom/movable/AM)
	if(charging)
		visible_message("<span class='warning'>[src] runs [AM]!</span>")
		if(istype(AM, /mob/living))
			var/mob/living/M = AM
			M.afflict_stun(20 * 5)
			M.afflict_paralyze(20 * 3)
			var/throwdir = pick(turn(dir, 45), turn(dir, -45))
			M.throw_at_old(get_step(src.loc, throwdir), 1, 1, src)
			runOver(M) // Actually should not use this, placeholder
		else if(isobj(AM))
			AM.inflict_atom_damage(
				charge_damage,
				charge_damage_tier,
				charge_damage_flag,
				charge_damage_mode,
				ATTACK_TYPE_MELEE,
			)
	..()

/mob/living/simple_mob/animal/space/xenomorph/monarch/proc/runOver(var/mob/living/M)
	if(istype(M))
		visible_message("<span class='warning'>[src] runs [M] over!</span>")
		playsound(src, "sound/mobs/biomorphs/monarch_charge.ogg", 50, 1)
		// todo: this ignores charge_damage
		var/damage = rand(3,4)
		M.apply_damage(2 * damage, DAMAGE_TYPE_BRUTE, BP_HEAD)
		M.apply_damage(2 * damage, DAMAGE_TYPE_BRUTE, BP_TORSO)
		M.apply_damage(0.5 * damage, DAMAGE_TYPE_BRUTE, BP_L_LEG)
		M.apply_damage(0.5 * damage, DAMAGE_TYPE_BRUTE, BP_R_LEG)
		M.apply_damage(0.5 * damage, DAMAGE_TYPE_BRUTE, BP_L_ARM)
		M.apply_damage(0.5 * damage, DAMAGE_TYPE_BRUTE, BP_R_ARM)
		var/datum/blood_mixture/using_blood_mixture
		if(iscarbon(M))
			var/mob/living/carbon/carbon_victim = M
			using_blood_mixture = carbon_victim.get_blood_mixture()
		blood_splatter_legacy(get_turf(src), using_blood_mixture, TRUE)

/mob/living/simple_mob/animal/space/xenomorph/monarch/apply_melee_effects(atom/A)
	if(isliving(A))
		var/mob/living/L = A
		if(L.mob_size <= MOB_MEDIUM)
			visible_message(SPAN_DANGER("\The [src] sends \the [L] flying with their heavy claws!"))
			playsound(src, "sound/mobs/biomorphs/breaker_slam.ogg", 50, 1)
			var/throw_dir = get_dir(src, L)
			var/throw_dist = L.incapacitated(INCAPACITATION_DISABLED) ? 4 : 1
			L.throw_at_old(get_edge_target_turf(L, throw_dir), throw_dist, 1, src)
		else
			to_chat(L, SPAN_WARNING( "\The [src] punches you with incredible force, but you remain in place."))

/mob/living/simple_mob/animal/space/xenomorph/special/burrower/should_special_attack(atom/A)
	// Make sure its possible for the spider to reach the target so it doesn't try to go through a window.
	var/turf/destination = get_turf(A)
	var/turf/starting_turf = get_turf(src)
	var/turf/T = starting_turf
	for(var/i = 1 to get_dist(starting_turf, destination))
		if(T == destination)
			break

		T = get_step(T, get_dir(T, destination))
		if(T.check_density(ignore_mobs = TRUE))
			return FALSE
	return T == destination

// Burrower Tunneling

/mob/living/simple_mob/animal/space/xenomorph/special/burrower/do_special_attack(atom/A)
	set waitfor = FALSE
	set_AI_busy(TRUE)

	// Save where we're gonna go soon.
	var/turf/destination = get_turf(A)
	var/turf/starting_turf = get_turf(src)

	// Telegraph to give a small window to dodge if really close.
	do_windup_animation(A, tunnel_warning)
	sleep(tunnel_warning) // For the telegraphing.

	// Do the dig!
	visible_message(SPAN_DANGER("\The [src] tunnels towards \the [A]!"))
	submerge()

	if(handle_tunnel(destination) == FALSE)
		set_AI_busy(FALSE)
		emerge()
		return FALSE

	// Did we make it?
	if(!(src in destination))
		set_AI_busy(FALSE)
		emerge()
		return FALSE

	var/overshoot = TRUE

	// Test if something is at destination.
	for(var/mob/living/L in destination)
		if(L == src)
			continue

		visible_message(SPAN_DANGER("\The [src] erupts from underneath, and hits \the [L]!"))
		playsound(L, 'sound/weapons/heavysmash.ogg', 75, 1)
		L.afflict_paralyze(20 * 3)
		overshoot = FALSE

	if(!overshoot) // We hit the target, or something, at destination, so we're done.
		set_AI_busy(FALSE)
		emerge()
		return TRUE

	// Otherwise we need to keep going.
	to_chat(src, SPAN_WARNING( "You overshoot your target!"))
	playsound(src, 'sound/weapons/punchmiss.ogg', 75, 1)
	var/dir_to_go = get_dir(starting_turf, destination)
	for(var/i = 1 to rand(2, 4))
		destination = get_step(destination, dir_to_go)

	if(handle_tunnel(destination) == FALSE)
		set_AI_busy(FALSE)
		emerge()
		return FALSE

	set_AI_busy(FALSE)
	emerge()
	return FALSE



// Does the tunnel movement, stuns enemies, etc.
/mob/living/simple_mob/animal/space/xenomorph/special/burrower/proc/handle_tunnel(turf/destination)
	var/turf/T = get_turf(src) // Hold our current tile.

	// Regular tunnel loop.
	for(var/i = 1 to get_dist(src, destination))
		if(stat)
			return FALSE // We died or got knocked out on the way.
		if(loc == destination)
			break // We somehow got there early.

		// Update T.
		T = get_step(src, get_dir(src, destination))
		if(T.check_density(ignore_mobs = TRUE))
			to_chat(src, SPAN_CRITICAL("You hit something really solid!"))
			playsound(src, "punch", 75, 1)
			afflict_paralyze(20 * 5)
			add_modifier(/datum/modifier/tunneler_vulnerable, 10 SECONDS)
			return FALSE // Hit a wall.

		// Stun anyone in our way.
		for(var/mob/living/L in T)
			playsound(L, 'sound/weapons/heavysmash.ogg', 75, 1)
			L.afflict_paralyze(20 * 2)

		// Get into the tile.
		forceMove(T)

		// Visuals and sound.
		dig_under_floor(get_turf(src))
		playsound(src, 'sound/effects/break_stone.ogg', 75, 1)
		sleep(tunnel_tile_speed)

// For visuals.
/mob/living/simple_mob/animal/space/xenomorph/special/burrower/proc/submerge()
	alpha = 0
	dig_under_floor(get_turf(src))
	new /obj/effect/temporary_effect/tunneler_hole(get_turf(src))

// Ditto.
/mob/living/simple_mob/animal/space/xenomorph/special/burrower/proc/emerge()
	alpha = 255
	dig_under_floor(get_turf(src))
	new /obj/effect/temporary_effect/tunneler_hole(get_turf(src))

/mob/living/simple_mob/animal/space/xenomorph/special/burrower/proc/dig_under_floor(turf/T)
	new /obj/item/stack/ore/glass(T) // This will be rather weird when on station but the alternative is too much work.

/obj/effect/temporary_effect/tunneler_hole
	name = "hole"
	desc = "A collapsing tunnel hole."
	icon_state = "tunnel_hole"
	time_to_die = 1 MINUTE

/datum/modifier/tunneler_vulnerable
	name = "Vulnerable"
	desc = "You are vulnerable to more harm than usual."
	on_created_text = "<span class='warning'>You feel vulnerable...</span>"
	on_expired_text = "<span class='notice'>You feel better.</span>"
	stacks = MODIFIER_STACK_EXTEND

	incoming_damage_percent = 2
	evasion = -100

// Sprinter Leap

// Multiplies damage if the victim is stunned in some form, including a successful leap.
/mob/living/simple_mob/animal/space/xenomorph/sprinter/apply_bonus_melee_damage(atom/A, damage_amount)
	if(isliving(A))
		var/mob/living/L = A
		if(L.incapacitated(INCAPACITATION_DISABLED))
			return damage_amount * 1.5
	return ..()


// The actual leaping attack.
/mob/living/simple_mob/animal/space/xenomorph/sprinter/do_special_attack(atom/A)
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


// Berserker Rage
/mob/living/simple_mob/animal/space/xenomorph/berserker/handle_special()
	if((get_polaris_AI_stance() in list(STANCE_APPROACH, STANCE_FIGHT)) && !is_AI_busy() && isturf(loc))
		if(health <= (maxHealth * 0.5)) // At half health, and fighting someone currently.
			berserk()

/mob/living/simple_mob/animal/space/xenomorph/berserker/verb/berserk()
	set name = "Berserk"
	set desc = "Enrage and become vastly stronger for a period of time, however you will be weaker afterwards."
	set category = "Abilities"

	add_modifier(/datum/modifier/berserk, 30 SECONDS)

// Burster Explosion

/mob/living/simple_mob/animal/space/xenomorph/special/burster/proc/baneling()
    visible_message(SPAN_CRITICAL("\The [src]'s body begins to rupture!"))
    var/delay = rand(explosion_delay_lower, explosion_delay_upper)
    spawn(0)
        // Flash black and red as a warning.
        for(var/i = 1 to delay)
            if(i % 2 == 0)
                color = "#04310c"
            else
                color = "#31cc1d"
            sleep(1)

    spawn(delay)
        // The actual boom.
        if(src && !exploded)
            visible_message(SPAN_DANGER("\The [src]'s body detonates!"))
            exploded = TRUE
            explosion(src.loc, explosion_dev_range, explosion_heavy_range, explosion_light_range, explosion_flash_range)

/mob/living/simple_mob/animal/space/xenomorph/special/burster/death()
    baneling()


// Inferno's Fire Projectile
/obj/projectile/potent_fire
	name = "ember"
	icon = 'icons/effects/effects.dmi'
	icon_state = "explosion_particle"
	modifier_type_to_apply = /datum/modifier/fire
	modifier_duration = 8 SECONDS // About 15 damage per stack, as Life() ticks every two seconds.
	damage_force = 0
	nodamage = TRUE
