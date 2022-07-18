/proc/createRandomZlevel()
	if(awaydestinations.len) //crude, but it saves another var!
		return
#ifdef UNIT_TESTS
	return
#endif

	var/list/potentialRandomZlevels = list()
	admin_notice("<font color='red'><B> Searching for away missions...</B></font>", R_DEBUG)
	var/list/Lines = world.file2list("maps/RandomZLevels/fileList.txt")
	if(!Lines.len)	return
	for (var/t in Lines)
		if (!t)
			continue

		t = trim(t)
		if (length(t) == 0)
			continue
		else if (copytext(t, 1, 2) == "#")
			continue

		var/pos = findtext(t, " ")
		var/name = null
	//	var/value = null

		if (pos)
		// No, don't do lowertext here, that breaks paths on linux
			name = copytext(t, 1, pos)
		//	value = copytext(t, pos + 1)
		else
			// No, don't do lowertext here, that breaks paths on linux
			name = t

		if (!name)
			continue

		potentialRandomZlevels.Add(name)


	if(potentialRandomZlevels.len)
		admin_notice("<font color='red'><B>Loading away mission...</B></font>", R_DEBUG)

		var/map = pick(potentialRandomZlevels)
		log_world("Away mission picked: [map]")
		var/file = file(map)
		if(isfile(file))
			var/datum/map_template/template = new(file, "away mission")
			template.load_new_z()
			log_world("away mission loaded: [map]")
		admin_notice("<font color='red'><B>Away mission loaded.</B></font>", R_DEBUG)

	else
		admin_notice("<font color='red'><B>No away missions found.</B></font>", R_DEBUG)
		return

// This landmark type so it's not so ghetto.
/obj/landmark/gateway_scatter
	name = "uncalibrated gateway destination"
/obj/landmark/gateway_scatter/Initialize(mapload)
	. = ..()
	awaydestinations += src

/obj/landmark/event_scatter
	name = "uncalibrated gateway destination"
/obj/landmark/event_scatter/Initialize(mapload)
	. = ..()
	eventdestinations += src
