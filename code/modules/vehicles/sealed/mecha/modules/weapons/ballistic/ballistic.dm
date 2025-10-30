/obj/item/vehicle_module/lazy/legacy/weapon/ballistic
	name = "general ballisic weapon"
	var/projectile_energy_cost

/obj/item/vehicle_module/lazy/legacy/weapon/ballistic/render_ui()
	..()
	l_ui_html("Ammo", "[projectiles] / [initial(projectiles)]")
	l_ui_button("rearm", "Rearming", "Rearm", FALSE, projectiles >= initial(projectiles))

/obj/item/vehicle_module/lazy/legacy/weapon/ballistic/on_l_ui_button(key)
	. = ..()
	if(.)
		return
	switch(key)
		if("rearm")
			if(projectiles >= initial(projectiles))
				return TRUE
			#warn log
			rearm()
			return TRUE

/obj/item/vehicle_module/lazy/legacy/weapon/ballistic/proc/rearm()
	if(projectiles < initial(projectiles))
		var/projectiles_to_add = initial(projectiles) - projectiles
		while(chassis.get_charge() >= projectile_energy_cost && projectiles_to_add)
			projectiles++
			projectiles_to_add--
			chassis.use_power(projectile_energy_cost)
	log_message("Rearmed [src.name].")
