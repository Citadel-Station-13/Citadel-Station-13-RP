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


/mob/living/simple_mob/animal/space/blight/melee/brute/apply_melee_effects(atom/A)
	if(isliving(A))
		var/mob/living/L = A
		if(L.mob_size <= MOB_MEDIUM)
			visible_message(SPAN_DANGER("\The [src] sends \the [L] flying with their clubbed arms!"))
			playsound(src, "sound/mobs/biomorphs/breaker_slam.ogg", 50, 1)
			var/throw_dir = get_dir(src, L)
			var/throw_dist = L.incapacitated(INCAPACITATION_DISABLED) ? 4 : 1
			L.throw_at_old(get_edge_target_turf(L, throw_dir), throw_dist, 1, src)
		else
			to_chat(L, SPAN_WARNING( "\The [src] punches you with incredible force, but you remain in place."))


/mob/living/simple_mob/animal/space/blight/melee/zenith/apply_melee_effects(atom/A)
	if(isliving(A))
		var/mob/living/L = A
		if(L.mob_size <= MOB_MEDIUM)
			visible_message(SPAN_DANGER("\The [src] sends \the [L] flying with their scythed claws!"))
			playsound(src, "sound/mobs/biomorphs/breaker_slam.ogg", 50, 1)
			var/throw_dir = get_dir(src, L)
			var/throw_dist = L.incapacitated(INCAPACITATION_DISABLED) ? 4 : 1
			L.throw_at_old(get_edge_target_turf(L, throw_dir), throw_dist, 1, src)
		else
			to_chat(L, SPAN_WARNING( "\The [src] punches you with incredible force, but you remain in place."))


/mob/living/simple_mob/animal/space/blight/melee/zenith/on_bullet_act(obj/projectile/proj, impact_flags, list/bullet_act_args)
	var/reflectchance = 80 - round(proj.damage_force/3)
	if(prob(reflectchance))
		var/damage_mod = rand(2,4)
		var/projectile_dam_type = proj.damage_type
		var/incoming_damage = (round(proj.damage_force / damage_mod) - (round((proj.damage_force / damage_mod) * 0.3)))
		var/armorcheck = run_armor_check(null, proj.damage_flag)
		var/soakedcheck = get_armor_soak(null, proj.damage_flag)
		if(!(istype(proj, /obj/projectile/energy) || istype(proj, /obj/projectile/beam)))
			visible_message("<span class='danger'>The [proj.name] bounces off of [src]'s exoskeleton!</span>", \
						"<span class='userdanger'>The [proj.name] bounces off of [src]'s exoskeleton!</span>")
			new /obj/item/material/shard/shrapnel(src.loc)
			if(!(proj.damage_type == DAMAGE_TYPE_BRUTE || proj.damage_type == DAMAGE_TYPE_BURN))
				projectile_dam_type = DAMAGE_TYPE_BRUTE
				incoming_damage = round(incoming_damage / 4) //Damage from strange sources is converted to brute for physical projectiles, though severely decreased.
			apply_damage(incoming_damage, projectile_dam_type, null, armorcheck, soakedcheck, is_sharp(proj), has_edge(proj), proj)
			return ..()
		else
			visible_message("<span class='danger'>The [proj.name] gets reflected by [src]'s exoskeleton!</span>", \
						"<span class='userdanger'>The [proj.name] gets reflected by [src]'s exoskeleton!</span>")
			damage_mod = rand(3,5)
			incoming_damage = (round(proj.damage_force / damage_mod) - (round((proj.damage_force / damage_mod) * 0.3)))
			if(!(proj.damage_type == DAMAGE_TYPE_BRUTE || proj.damage_type == DAMAGE_TYPE_BURN))
				projectile_dam_type = DAMAGE_TYPE_BURN
				incoming_damage = round(incoming_damage / 4) //Damage from strange sources is converted to burn for energy-type projectiles, though severely decreased.
			apply_damage(incoming_damage, proj.damage_type, null, armorcheck, soakedcheck, is_sharp(proj), has_edge(proj), proj)

		// Find a turf near or on the original location to bounce to
		if(proj.starting)
			var/new_x = proj.starting.x + pick(0, 0, -1, 1, -2, 2, -2, 2, -2, 2, -3, 3, -3, 3)
			var/new_y = proj.starting.y + pick(0, 0, -1, 1, -2, 2, -2, 2, -2, 2, -3, 3, -3, 3)
			var/turf/curloc = get_turf(src)

			// redirect the projectile
			proj.legacy_redirect(new_x, new_y, curloc, src)
			proj.reflected = 1

		return PROJECTILE_IMPACT_REFLECT
	return ..()


/mob/living/simple_mob/animal/space/blight/melee/zenith/do_special_attack(atom/A)
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

/mob/living/simple_mob/animal/space/blight/melee/zenith/Bump(atom/movable/AM)
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

/mob/living/simple_mob/animal/space/blight/melee/zenith/proc/runOver(var/mob/living/M)
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
