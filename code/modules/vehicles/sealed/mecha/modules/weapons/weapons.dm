/obj/item/vehicle_module/weapon
	name = "mecha weapon"
	range = RANGED
	origin_tech = list(TECH_MATERIAL = 3, TECH_COMBAT = 3)
	var/projectile //Type of projectile fired.
	var/projectiles = 1 //Amount of projectiles loaded.
	var/projectiles_per_shot = 1 //Amount of projectiles fired per single shot.
	var/deviation = 0 //Inaccuracy of shots.
	var/fire_cooldown = 0 //Duration of sleep between firing projectiles in single shot.
	var/fire_sound //Sound played while firing.
	var/fire_volume = 50 //How loud it is played.
	var/auto_rearm = 0 //Does the weapon reload itself after each shot?
	required_type = list(/obj/vehicle/sealed/mecha/combat, /obj/vehicle/sealed/mecha/working/hoverpod/combatpod)

	step_delay = 0.1

	equip_type = EQUIP_WEAPON

/obj/item/vehicle_module/weapon/action_checks(atom/target)
	if(projectiles <= 0)
		return 0
	return ..()

/obj/item/vehicle_module/weapon/action(atom/target, params)
	if(!action_checks(target))
		return
	var/turf/curloc = chassis.loc
	var/turf/targloc = get_turf(target)
	if(!curloc || !targloc)
		return
	chassis.use_power(energy_drain)
	chassis.visible_message("<span class='warning'>[chassis] fires [src]!</span>")
	occupant_message("<span class='warning'>You fire [src]!</span>")
	log_message("Fired from [src], targeting [target].")
	var/target_for_log = "unknown"
	if(ismob(target))
		target_for_log = target
	else if(target)
		target_for_log = "[target.name]"
	add_attack_logs(chassis.occupant_legacy,target_for_log,"Fired exosuit weapon [src.name] (MANUAL)")

	for(var/i = 1 to min(projectiles, projectiles_per_shot))
		var/turf/aimloc = targloc
		if(deviation)
			aimloc = locate(targloc.x+GaussRandRound(deviation,1),targloc.y+GaussRandRound(deviation,1),targloc.z)
		if(!aimloc || aimloc == curloc || (locs && (aimloc in locs)))
			break
		playsound(src, fire_sound, fire_volume, 1)
		projectiles--
		var/turf/projectile_turf
		if(chassis.locs && chassis.locs.len)	// Multi tile.
			for(var/turf/Tloc in chassis.locs)
				if(get_dist(Tloc, aimloc) < get_dist(loc, aimloc))
					projectile_turf = get_turf(Tloc)
		if(!projectile_turf)
			projectile_turf = get_turf(curloc)
		var/P = new projectile(projectile_turf)
		Fire(P, target, params)
		if(i == 1)
			set_ready_state(0)
		if(fire_cooldown)
			sleep(fire_cooldown)
	if(auto_rearm)
		projectiles = projectiles_per_shot
//	set_ready_state(0)

	do_after_cooldown()

	return

/obj/item/vehicle_module/weapon/proc/Fire(atom/A, atom/target, params)
	if(istype(A, /obj/projectile))	// Sanity.
		var/obj/projectile/P = A
		P.dispersion = deviation
		process_accuracy(P, chassis.occupant_legacy, target)
		P.launch_projectile_legacy(target, chassis.get_pilot_zone_sel(), chassis.occupant_legacy, params)
	else if(istype(A, /atom/movable))
		var/atom/movable/AM = A
		AM.throw_at_old(target, 7, 1, chassis)

/obj/item/vehicle_module/weapon/proc/process_accuracy(obj/projectile, mob/living/user, atom/target)
	var/obj/projectile/P = projectile
	if(!istype(P))
		return

	P.accuracy_overall_modify *= 1 - (user.get_accuracy_penalty() / 100)

	// Some modifiers make it harder or easier to hit things.
	for(var/datum/modifier/M in user.modifiers)
		if(!isnull(M.accuracy))
			P.accuracy_overall_modify *= 1 + (M.accuracy / 100)
		if(!isnull(M.accuracy_dispersion))
			P.dispersion = max(P.dispersion + M.accuracy_dispersion, 0)
