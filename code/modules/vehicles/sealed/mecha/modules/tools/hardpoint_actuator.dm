/*
 * A special device used to pick up and equip other exosuit components on the fly, without leaving an Exosuit. Costly.
 */

/obj/item/vehicle_module/hardpoint_actuator
	name = "hardpoint actuator clamp"
	icon_state = "mecha_clamp"
	equip_cooldown = 10 SECONDS
	energy_drain = 600
	equip_type = EQUIP_HULL
	origin_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 5, TECH_POWER = 4, TECH_COMBAT = 1, TECH_MAGNET = 4)

/obj/item/vehicle_module/hardpoint_actuator/action(atom/target)
	if(!action_checks(target))
		return

	if(istype(target,/obj/item/vehicle_module))
		var/obj/item/vehicle_module/ME = target
		if(ME.can_attach(chassis))
			occupant_message("[ME] can be integrated. Stand by.")
			if(do_after(chassis.occupant_legacy, 3 SECONDS, target))
				if(ME.can_attach(chassis) && action_checks(target))
					ME.attach(chassis)
					occupant_message("[ME] successfully integrated.")
		else
			occupant_message("[ME] cannot be integrated due to lack of free hardpoints.")

	else
		occupant_message("[target] is not compatible with any present hardpoints.")

	set_ready_state(0)
	chassis.use_power(energy_drain)
	do_after_cooldown()
	return
