/obj/item/vehicle_module/lazy/legacy/tool/drill
	name = "drill"
	desc = "This is the drill that'll pierce the heavens!"
	icon_state = "mecha_drill"
	equip_cooldown = 30
	energy_drain = 10
	damage_force = 15
	var/drill_delay = 1 SECONDS
	var/advanced = 0	//Determines if you can pierce the heavens or not. Used in diamond drill.

/obj/item/vehicle_module/lazy/legacy/tool/drill/action(atom/target)
	if(!action_checks(target))
		return
	set_ready_state(0)
	chassis.use_power(energy_drain)
	chassis.visible_message("<span class='danger'>[chassis] starts to drill [target]</span>", "<span class='warning'>You hear the drill.</span>")
	occupant_message("<span class='danger'>You start to drill [target]</span>")
	var/T = chassis.loc
	var/C = target.loc	//why are these backwards? we may never know -Pete
	if(!vehicle_do_after_and_sound(null, drill_delay, target))
		if(istype(target, /turf/simulated/wall))
			var/turf/simulated/wall/W = target
			if(W.material_reinf && !advanced)//R wall but no good drill
				occupant_message("<span class='warning'>[target] is too durable to drill through.</span>")
				return

			else if((W.material_reinf && advanced) || do_after_cooldown(target))//R wall with good drill
				log_message("Drilled through [target]")
				LEGACY_EX_ACT(target, 3, null)
			else
				log_message("Drilled through [target]")
				LEGACY_EX_ACT(target, 2, null)

		else if(istype(target, /turf/simulated/mineral))
			for(var/turf/simulated/mineral/M in range(chassis,1))
				if(get_dir(chassis,M)&chassis.dir)
					M.GetDrilled()
			log_message("Drilled through [target]")
			if(locate(/obj/item/vehicle_module/lazy/legacy/tool/hydraulic_clamp) in chassis.modules)
				var/obj/structure/ore_box/ore_box = locate(/obj/structure/ore_box) in chassis.cargo_held
				if(ore_box)
					for(var/obj/item/stack/ore/ore in range(chassis,1))
						if(get_dir(chassis,ore) & chassis.dir)
							ore.forceMove(ore_box)
		else if(isliving(target))
			drill_mob(target, chassis.occupant_legacy)
			return 1
		else if(target.loc == C)
			log_message("Drilled through [target]")
			LEGACY_EX_ACT(target, 2, null)
	return 1

/obj/item/vehicle_module/lazy/legacy/tool/drill/proc/drill_mob(mob/living/target, mob/user)
	add_attack_logs(user, target, "attacked", "[name]", "(INTENT: [uppertext(user.a_intent)]) (DAMTYPE: [uppertext(DAMAGE_TYPE_BRUTE)])")
	var/drill_force = damage_force	//Couldn't manage it otherwise.
	if(ishuman(target))
		target.apply_damage(drill_force, DAMAGE_TYPE_BRUTE)
		return

	else if(istype(target, /mob/living/simple_mob))
		var/mob/living/simple_mob/S = target
		if(target.stat == DEAD)
			if(S.meat_amount > 0)
				S.harvest(user)
				return
			else
				S.gib()
				return
		else
			S.apply_damage(drill_force)
			return

/obj/item/vehicle_module/lazy/legacy/tool/drill/diamonddrill
	name = "diamond drill"
	desc = "This is an upgraded version of the drill that'll pierce the heavens!"
	icon_state = "mecha_diamond_drill"
	origin_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 3)
	equip_cooldown = 10
	damage_force = 15
	advanced = 1
	drill_delay = 0.5 SECONDS
