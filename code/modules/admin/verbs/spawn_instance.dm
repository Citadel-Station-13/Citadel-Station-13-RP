/datum/admins/proc/spawn_atom(object as text)
	set category = "Debug"
	set desc = "(atom path) Spawn an atom"
	set name = "Spawn"

	if(!check_rights(R_SPAWN))	return

	var/list/types = typesof(/atom)
	var/list/matches = list()

	for(var/path in types)
		if(findtext("[path]", object))
			matches += path

	if(!matches.len)
		return

	var/chosen
	if(matches.len == 1)
		chosen = matches[1]
	else
		matches = get_typepath_shortnames(matches)
		chosen = input("Select an atom type", "Spawn Atom", matches[1]) as null|anything in matches
		if(!chosen)
			return
		chosen = matches[chosen]

	if(ispath(chosen,/turf))
		var/turf/T = get_turf(usr)
		T.PlaceOnTop(chosen)
	else
		new chosen(usr.loc)

	log_and_message_admins("spawned [chosen] at ([usr.x],[usr.y],[usr.z])")
	feedback_add_details("admin_verb","SA") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
