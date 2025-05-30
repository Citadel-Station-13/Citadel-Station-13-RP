//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

// todo: this typing is .. weird. we are bending over backwards
//       to specifically cast everything on /energy type.
//       we're going to need to decide how to deal with that
/datum/firemode/energy
	//* Energy Usage *//
	/// charge cost of using this in cell units.
	var/charge_cost

	//* Projectile Formation *//
	/// projectile type
	/// * This can be either a type, or an anonymous type
	var/projectile_type
	/// projectile instance
	/// * overrides [projectile_type]
	/// * if set, causes the gun to clone this projectile on fire
	/// * this is considered a shared reference if set! this means cloned firemodes share the same projectile instance
	var/obj/projectile/projectile_instance

	//* Safety *//
	/// Setting is considered lethal
	var/considered_lethal = FALSE

// todo: this shouldn't even exist.
/datum/firemode/energy/New(obj/item/gun/inherit_from_gun, list/direct_varedits)
	..()
	if(isnull(charge_cost))
		var/obj/item/gun/projectile/energy/they_were_lazy_so_grab_from_gun = inherit_from_gun
		charge_cost = they_were_lazy_so_grab_from_gun.charge_cost
	if(isnull(projectile_type))
		var/obj/item/gun/projectile/energy/they_were_lazy_so_grab_from_gun = inherit_from_gun
		projectile_type = they_were_lazy_so_grab_from_gun.projectile_type

/datum/firemode/energy/parse_legacy_varset(key, value)
	. = TRUE
	switch(key)
		if("charge_cost")
			src.charge_cost = value
		if("projectile_type")
			src.projectile_type = value
		else
			return ..()

/datum/firemode/energy/clone()
	var/datum/firemode/energy/cloning = ..()
	cloning.charge_cost = charge_cost
	cloning.projectile_type = projectile_type
	cloning.projectile_instance = projectile_instance
	return cloning

/datum/firemode/energy/proc/instance_projectile()
	if(projectile_instance)
		return projectile_instance.clone()
	return projectile_type ? new projectile_type : null
