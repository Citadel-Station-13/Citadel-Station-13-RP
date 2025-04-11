/obj/item/gun/proc/process_point_blank(obj/projectile, mob/user, atom/target)
	var/obj/projectile/P = projectile
	if(!istype(P))
		return //default behaviour only applies to true projectiles

	//default point blank multiplier
	var/damage_mult = 1.3

	//determine multiplier due to the target being grabbed
	if(ismob(target))
		var/mob/M = target
		if(M.grabbed_by.len)
			var/grabstate = 0
			for(var/obj/item/grab/G in M.grabbed_by)
				grabstate = max(grabstate, G.state)
			if(grabstate >= GRAB_NECK)
				damage_mult = 2.5
			else if(grabstate >= GRAB_AGGRESSIVE)
				damage_mult = 1.5
	P.damage_force *= damage_mult

/obj/item/gun/proc/process_accuracy(obj/projectile, mob/living/user, atom/target, var/burst, var/held_twohanded)
	var/obj/projectile/P = projectile
	if(!istype(P))
		return //default behaviour only applies to true projectiles

	var/acc_mod = burst_accuracy?[min(burst, burst_accuracy.len)] || 0
	var/disp_mod = dispersion?[min(burst, dispersion.len)] || 0

	if(one_handed_penalty)
		if(!held_twohanded)
			acc_mod += -CEILING(one_handed_penalty/2, 1)
			disp_mod += one_handed_penalty*0.5 //dispersion per point of two-handedness

	//Accuracy modifiers
	if(!isnull(accuracy_disabled))
		P.accuracy_disabled = accuracy_disabled

	P.accuracy_overall_modify *= 1 + (acc_mod / 100)
	P.accuracy_overall_modify *= 1 - (user.get_accuracy_penalty() / 100)
	P.dispersion = disp_mod

	//accuracy bonus from aiming
	if (aim_targets && (target in aim_targets))
		//If you aim at someone beforehead, it'll hit more often.
		//Kinda balanced by fact you need like 2 seconds to aim
		//As opposed to no-delay pew pew
		P.accuracy_overall_modify *= 1.3

	// Some modifiers make it harder or easier to hit things.
	for(var/datum/modifier/M in user.modifiers)
		if(!isnull(M.accuracy))
			P.accuracy_overall_modify += 1 + (M.accuracy / 100)
		if(!isnull(M.accuracy_dispersion))
			P.dispersion = max(P.dispersion + M.accuracy_dispersion, 0)

/obj/item/gun/proc/play_fire_sound(var/mob/user, var/obj/projectile/P)
	var/shot_sound = legacy_resolve_fire_sound(user, P)
	if(!shot_sound) // If there's still no sound...
		return

	if(silenced)
		playsound(src, shot_sound, 10, 1)
	else
		playsound(src, shot_sound, 50, 1)

/obj/item/gun/proc/legacy_resolve_fire_sound(var/mob/user, var/obj/projectile/P)
	. = fire_sound

	if(!. && istype(P)) // If the gun didn't have a fire_sound, but the projectile exists, and has a sound...
		. = P.resolve_fire_sfx()
