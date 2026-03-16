/client/proc/spawn_atom(object as text|null)
	set category = "Debug"
	set desc = "(atom path) Spawn an atom"
	set name = "Spawn"

	if(!check_rights(R_SPAWN))
		return

	var/static/list/atom_types
	if (isnull(atom_types))
		atom_types = subtypesof(/atom)

	var/chosen_path = null
	var/list/preparsed = null
	if (object)
		preparsed = splittext(object, ":")
		var/list/matches = filter_fancy_list(atom_types, preparsed[1])
		if (length(matches) == 1)
			chosen_path = matches[1]

	if(!chosen_path)
		var/datum/spawn_menu/menu = holder.spawn_menu
		if (!menu)
			menu = new()
			holder.spawn_menu = menu
		menu.init_value = object
		menu.ui_interact(mob)
		// BLACKBOX_LOG_ADMIN_VERB("Spawn Atom")
		return TRUE

	var/amount = 1
	if (length(preparsed) > 1)
		amount = clamp(text2num(preparsed[2]), 1, ADMIN_SPAWN_CAP)

	var/turf/target_turf = get_turf(mob)
	if (ispath(chosen_path, /turf))
		target_turf.ChangeTurf(chosen_path)
	else
		for (var/i in 1 to amount)
			new chosen_path(target_turf)

	log_admin("[key_name(mob)] spawned [amount] x [chosen_path] at [AREACOORD(mob)]")
	return TRUE
