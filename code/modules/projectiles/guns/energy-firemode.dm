//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/firemode/energy
	//* Energy Usage *//
	/// charge cost of using this in cell units.
	var/charge_cost

	//* Projectile Formation *//
	/// projectile type
	var/projectile_type

// todo: this shouldn't even exist.
/datum/firemode/energy/New(obj/item/gun/inherit_from_gun, list/direct_varedits)
	..()
	if(!length(direct_varedits))
		return
	for(var/varname in direct_varedits)
		var/value = direct_varedits[varname]
		// pull out special crap
		switch(varname)
			if("charge_cost")
				src.charge_cost = value
			if("projectile_type")
				src.projectile_type = value

/datum/firemode/energy/clone(include_contents)
	var/datum/firemode/energy/cloning = ..()
	cloning.charge_cost = charge_cost
	cloning.projectile_type = projectile_type
	return cloning
