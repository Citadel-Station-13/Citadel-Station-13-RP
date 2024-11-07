//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/firemode
	/// The name of the firemode. This is what is shown in VV, **and** to players.
	var/name = "normal"

	//* firing *//
	/// number of shots in burst
	var/burst_amount = 1
	/// delay between burst shots
	var/burst_delay = 0.2 SECONDS
	/// delay **after** the firing cycle which we cannot fire
	var/cycle_cooldown = 0.4 SECONDS

	//* rendering *//
	/// state key for rendering, if any
	var/render_key
	/// firemode color, used if we're doing colored `-firemode` sprite or colored `-ammo` sprite
	var/render_color
	#warn impl

	//* LEGACY *//
	/// direct vv edits to the gun applied when we're selected.
	///
	/// * this is shit, but it is what it is, for now. we're migrating things out of
	///   it, slowly.
	/// * passed in variables from direct varedits in New() will be append-overwrite
	///   for this list.
	var/list/legacy_direct_varedits

// todo: this shouldn't even exist.
/datum/firemode/New(obj/item/gun/inherit_from_gun, list/direct_varedits)
	if(!length(direct_varedits))
		return
	for(var/varname in direct_varedits)
		var/value = direct_varedits[varname]
		// pull out special crap
		switch(varname)
			if("mode_name")
				src.name = value
			if("burst")
				src.burst_amount = value
			if("fire_delay")
				src.cycle_cooldown = value
			if("burst_delay")
				src.burst_delay = value
		LAZYSET(legacy_direct_varedits, varname, value || inherit_from_gun.vars[varname])

/datum/firemode/clone(include_contents)
	var/datum/firemode/creating = new type
	creating.name = name
	creating.burst_amount = burst_amount
	creating.burst_delay = burst_delay
	creating.cycle_cooldown = cycle_cooldown
	creating.render_color = render_color
	creating.render_key = render_key
	// todo: kill
	creating.legacy_direct_varedits = deep_copy_list(legacy_direct_varedits)
	return creating

// todo: annihilate this
/datum/firemode/proc/apply_legacy_variables(obj/item/gun/gun)
	for(var/varname in legacy_direct_varedits)
		gun.vars[varname] = legacy_direct_varedits[varname]
