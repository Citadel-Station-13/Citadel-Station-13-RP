//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/firemode/energy
	//* Energy Usage *//

	/// charge cost of using this in cell units.
	var/charge_cost
	
	//* Projectile Formation *//

	//? Modular weapons make this complicated. The gun reserves the right to   ?//
	//? overrule the firemode as necessary. It would be optimal to separate    ?//
	//? firemodes from 'projectile modes', but it might be overkill given      ?//
	//? the majority of energy guns do not require this functionality.         ?//

	/// projectile type
	var/projectile_type

#warn deal with this

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
