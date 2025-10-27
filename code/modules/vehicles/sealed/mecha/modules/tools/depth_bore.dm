/obj/item/vehicle_module/lazy/legacy/tool/depth_bore
	name = "depth bore"
	desc = "This is the drill that'll pierce the depths!"
	icon_state = "mecha_bore"
	energy_drain = 30
	damage_force = 15
	var/drill_delay = 3 SECONDS

/obj/item/vehicle_module/lazy/legacy/tool/depth_bore/action(atom/target)
	if(!action_checks(target))
		return
	set_ready_state(0)
	chassis.use_power(energy_drain)
	chassis.visible_message("<span class='danger'>[chassis] starts to bore into \the [target]</span>", "<span class='warning'>You hear the bore.</span>")
	occupant_message("<span class='danger'>You start to bore into \the [target]</span>")
	var/T = chassis.loc
	var/C = target.loc
	if(!vehicle_do_after_and_sound(null, drill_delay, target))
		if(istype(target, /turf/simulated/wall))
			var/turf/simulated/wall/W = target
			if(W.material_reinf)
				occupant_message("<span class='warning'>[target] is too durable to bore through.</span>")
			else
				log_message("Bored through [target]")
				LEGACY_EX_ACT(target, 2, null)
		else if(istype(target, /turf/simulated/mineral))
			var/turf/simulated/mineral/M = target
			if(!M.density)
				LEGACY_EX_ACT(M, 2, null)
				log_message("Bored into [target]")
			else
				M.GetDrilled()
				log_message("Bored through [target]")
			if(locate(/obj/item/vehicle_module/lazy/legacy/tool/hydraulic_clamp) in chassis.modules)
				var/obj/structure/ore_box/ore_box = locate(/obj/structure/ore_box) in chassis.cargo_held
				if(ore_box)
					for(var/obj/item/stack/ore/ore in range(chassis,1))
						if(get_dir(chassis,ore)&chassis.dir)
							ore.forceMove(ore_box)
		else if(target.loc == C)
			log_message("Drilled through [target]")
			LEGACY_EX_ACT(target, 2, null)
	return 1
