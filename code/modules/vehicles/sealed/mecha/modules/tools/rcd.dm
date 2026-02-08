/obj/item/vehicle_module/lazy/legacy/tool/rcd
	name = "mounted RCD"
	desc = "An exosuit-mounted Rapid Construction Device."
	icon_state = "mecha_rcd"
	origin_tech = list(TECH_MATERIAL = 4, TECH_BLUESPACE = 3, TECH_MAGNET = 4, TECH_POWER = 4)
	equip_cooldown = 10
	energy_drain = 250
	range = MELEE|RANGED
	module_slot = VEHICLE_MODULE_SLOT_SPECIAL
	var/obj/item/rcd/electric/mounted/mecha/my_rcd = null

/obj/item/vehicle_module/lazy/legacy/tool/rcd/Initialize(mapload)
	my_rcd = new(src)
	return ..()

/obj/item/vehicle_module/lazy/legacy/tool/rcd/Destroy()
	QDEL_NULL(my_rcd)
	return ..()

/obj/item/vehicle_module/lazy/legacy/tool/rcd/render_ui()
	..()
	if(my_rcd)
		l_ui_select("mode", "Mode", my_rcd.modes, my_rcd.modes[my_rcd.mode_index])

/obj/item/vehicle_module/lazy/legacy/tool/rcd/on_l_ui_select(datum/event_args/actor/actor, key, name)
	. = ..()
	if(.)
		return
	switch(key)
		if("mode")
			if(name in my_rcd.modes)
				my_rcd.mode_index = my_rcd.modes.Find(name)
				occupant_message("RCD reconfigured to '[my_rcd.modes[my_rcd.mode_index]]'.")
			return TRUE

/obj/item/vehicle_module/lazy/legacy/tool/rcd/action(atom/target)
	if(!action_checks(target) || get_dist(chassis, target) > 3)
		return FALSE

	my_rcd.use_rcd(target, chassis.occupant_legacy)
