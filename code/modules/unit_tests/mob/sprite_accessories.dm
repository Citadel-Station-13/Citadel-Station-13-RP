/datum/unit_test/sprite_accessory_uniqueness/Run()
	var/list/ids = list()
	var/list/names_hair = list()
	var/list/names_beard = list()
	var/list/names_tail = list()
	var/list/names_wing = list()
	var/list/names_ear = list()
	var/list/names_marking = list()
	for(var/path in subtypesof(/datum/sprite_accessory))
		var/datum/sprite_accessory/S = path
		if(initial(S.abstract_type) == path)
			continue
		S = new path
		if(isnull(S.id))
			Fail("null ID on [path]")
			continue
		else if(ids[S.id])
			Fail("duplicate id [S.id] on [path] against [ids[S.id]:type]")
		else
			ids[S.id] = S
		// yanderedev gaming
		if(istype(S, /datum/sprite_accessory/hair))
			if(names_hair[S.name])
				Fail("duplciate name [S.name] on [path] against [names_hair[S.name]:type]")
			else
				names_hair[S.name] = S
		else if(istype(S, /datum/sprite_accessory/facial_hair))
			if(names_beard[S.name])
				Fail("duplciate name [S.name] on [path] against [names_beard[S.name]:type]")
			else
				names_beard[S.name] = S
		else if(istype(S, /datum/sprite_accessory/wing))
			if(names_wing[S.name])
				Fail("duplciate name [S.name] on [path] against [names_wing[S.name]:type]")
			else
				names_wing[S.name] = S
		else if(istype(S, /datum/sprite_accessory/ears))
			if(names_ear[S.name])
				Fail("duplciate name [S.name] on [path] against [names_ear[S.name]:type]")
			else
				names_ear[S.name] = S
		else if(istype(S, /datum/sprite_accessory/tail))
			if(names_tail[S.name])
				Fail("duplciate name [S.name] on [path] against [names_tail[S.name]:type]")
			else
				names_tail[S.name] = S
		else if(istype(S, /datum/sprite_accessory/marking))
			if(names_marking[S.name])
				Fail("duplciate name [S.name] on [path] against [names_marking[S.name]:type]")
			else
				names_marking[S.name] = S

