/client/proc/spawn_atom(query as text)
	set category = "Debug"
	set desc = "(atom path) Spawn an atom"
	set name = "Spawn"

	if(!check_rights(R_SPAWN))
		return

	if(length(query) < 5)
		var/confirm = alert(
			src,
			"You haven't specified a long enough filter; this will take a while. Are you sure?",
			"Mass Query Confirmation",
			"No",
			"Yes"
		)
		if(confirm != "Yes")
			return

	var/list/matches = list()
	for(var/path in typesof(/atom))
		if(findtext("[path]", query))
			matches += path
		CHECK_TICK

	if(!length(matches))
		to_chat(src, SPAN_WARNING("Type query for '[query]' returned nothing."))
		return

	// todo: special prefix handling like # / ! / similar for fast-pathing?
	var/path_to_spawn
	if(length(matches) == 1)
		path_to_spawn = matches[1]
	else
		var/list/processed_types = make_types_fancy(matches)
		var/picked_name = input("Select an atom type", "Spawn Atom", matches[1]) as null|anything in processed_types
		if(!picked_name)
			return
		path_to_spawn = processed_types[picked_name]

	if(!path_to_spawn)
		return

	if(ispath(path_to_spawn, /turf))
		var/turf/T = get_turf(mob)
		T.ChangeTurf(path_to_spawn)
	else
		new path_to_spawn(mob.loc)

	log_and_message_admins("spawned [path_to_spawn] at ([usr.x],[usr.y],[usr.z])")
