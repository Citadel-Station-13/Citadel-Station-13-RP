//Energy weapons.
/datum/firemode/energy
	var/e_cost = SCALE_ENERGY_WEAPON_NORMAL(10)				//energy cost to fire
	var/mode_icon_state				//usually the name.
	var/mode_item_state				//see energy.dm

	//variables for /obj/item/ammo_casing/energy
	var/projectile_type = /obj/item/projectile/energy		//type of projectile
	var/casing_flags = NONE									//casing ammo_flags
	var/casing_pellets = 1									//number of pellets
	var/casing_variance = 0									//casing inherent spread
	var/firing_effect_type = /obj/effect/temp_visual/dir_setting/firing_effect

	dualwield_volatility = 0.5

/datum/firemode/energy/apply_to_casing(obj/item/ammu_casing/C)
	. = ..()
	C.projectile_type = projectile_type
	C.ammo_flags = casing_flags
	C.pellets = casing_pellets
	C.variance = casing_variance
	C.firing_effect_type = firing_effect_type
	if(istype(C.projectile))
		qdel(C.projectile)
	C.initialize_projectile()
