/obj/item/vehicle_module/lazy/legacy/gravcatapult
	name = "gravitational catapult"
	desc = "An exosuit mounted gravitational catapult."
	icon_state = "mecha_teleport"
	origin_tech = list(TECH_BLUESPACE = 2, TECH_MAGNET = 3)
	equip_cooldown = 10
	energy_drain = 100
	range = MELEE|RANGED

	module_slot = VEHICLE_MODULE_SLOT_UTILITY

	var/fire_delay = 1 SECONDS
	var/next_fire = 0
	var/mode
	var/const/C_GRAV_MODE_SLING = "sling"
	var/const/C_GRAV_MODE_PULSE = "pulse"
	var/datum/weakref/locked_atom_weakref

/obj/item/vehicle_module/lazy/legacy/gravcatapult/render_ui()
	..()
	var/selected_mode
	switch(mode)
		if(C_GRAV_MODE_SLING)
			selected_mode = "Sling"
		if(C_GRAV_MODE_PULSE)
			selected_mode = "Pulse"
	l_ui_select("mode", "Mode", list("Sling", "Pulse"), selected_mode)

/obj/item/vehicle_module/lazy/legacy/gravcatapult/on_l_ui_select(key, name)
	. = ..()
	if(.)
		return
	switch(key)
		if("mode")
			switch(name)
				if("Sling")
					mode = C_GRAV_MODE_SLING
					return TRUE
				if("Pulse")
					mode = C_GRAV_MODE_PULSE
					return TRUE

/obj/item/vehicle_module/lazy/legacy/gravcatapult/action(atom/movable/target)

	if(world.time >= last_fired + fire_delay)
		last_fired = world.time
	else
		if (world.time % 3)
			occupant_message("<span class='warning'>[src] is not ready to fire again!</span>")
		return 0

	if(mode == C_GRAV_MODE_SLING)
		if(!action_checks(target) && !locked)
			return
		var/atom/movable/locked = locked_atom_weakref?.resolve()
		if(!locked)
			if(!istype(target) || target.anchored)
				occupant_message("Unable to lock on [target]")
				return
			locked_atom_weakref = WEAKREF(target)
			occupant_message("Locked on [target]")
			return
		else if(target!=locked)
			if(locked in view(chassis))
				locked.throw_at_old(target, 14, 1.5, chassis)
				locked_atom_weakref = null
				set_ready_state(0)
				chassis.use_power(energy_drain)
				do_after_cooldown()
			else
				locked_atom_weakref = null
				occupant_message("Lock on [locked] disengaged.")
	else if(mode == C_GRAV_MODE_PULSE)
		if(2)
			if(!action_checks(target))
				return
			var/list/atoms = list()
			if(isturf(target))
				atoms = range(target,3)
			else
				atoms = orange(target,3)
			for(var/atom/movable/A in atoms)
				if(A.anchored)
					continue
				spawn(0)
					var/iter = 5-get_dist(A,target)
					for(var/i=0 to iter)
						step_away(A,target)
						sleep(2)
			set_ready_state(0)
			chassis.use_power(energy_drain)
			do_after_cooldown()
