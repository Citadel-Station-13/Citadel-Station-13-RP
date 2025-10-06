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

	//* projectile *//

	/// impart base dispersion to every single projectile
	/// * this should rarely be used; instability system is better and
	///   more suited for compatibility with other sources of dispersion
	var/projectile_base_dispersion = 0
	/// passed to bullet in fire()
	var/list/projectile_effects_add

	//* rendering *//

	/// modify the gun's base state when active
	/// * very, very dangerous, know what you are doing.
	var/override_icon_base
	/// state key for rendering, if any
	var/render_key
	/// firemode color, used if we're doing colored `-firemode` sprite or colored `-ammo` sprite
	var/render_color

	//* UI *//

	/// appearance used for radial
	///
	/// supported values:
	/// * /image
	/// * /mutable_appearance
	///
	/// this must be created in [make_radial_appearance()] as this cannot be set to image() or similar at compile time
	var/radial_appearance

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
	for(var/varname in direct_varedits)
		var/value = direct_varedits[varname]
		if(value)
			LAZYSET(legacy_direct_varedits, varname, value)
		else if(inherit_from_gun.vars.Find(varname))
			LAZYSET(legacy_direct_varedits, varname, inherit_from_gun.vars[varname])
	if(!length(legacy_direct_varedits))
		return
	var/list/parse_again = legacy_direct_varedits
	legacy_direct_varedits = list()
	for(var/key in parse_again)
		if(parse_legacy_varset(key, parse_again[key]))
			continue
		legacy_direct_varedits[key] = parse_again[key]

/**
 * @return TRUE if we can drop it
 */
/datum/firemode/proc/parse_legacy_varset(key, value)
	. = TRUE
	switch(key)
		if("mode_name")
			src.name = value
		if("burst")
			src.burst_amount = value
		if("fire_delay")
			src.cycle_cooldown = value
		if("burst_delay")
			src.burst_delay = value
		else
			. = FALSE

/datum/firemode/clone()
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
		switch(varname)
			if("mode_name")
			if("burst")
			if("move_delay")
			if("fire_delay")
			else
				if(gun.vars.Find(varname))
					gun.vars[varname] = legacy_direct_varedits[varname]

/datum/firemode/proc/fetch_radial_appearance()
	return radial_appearance || (radial_appearance = make_radial_appearance())

/datum/firemode/proc/make_radial_appearance()
	return
