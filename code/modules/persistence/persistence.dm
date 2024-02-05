/atom
	// This var isn't actually used for anything, but is present so that
	// DM's map reader doesn't forfeit on reading a JSON-serialized map
	var/map_json_data

// This is so specific atoms can override these, and ignore certain ones
/atom/proc/vars_to_save()
 	return list("color","dir","icon","icon_state","name","pixel_x","pixel_y")

/atom/proc/map_important_vars()
	// A list of important things to save in the map editor
 	return list("color","dir","icon","icon_state","layer","name","pixel_x","pixel_y")

/area/map_important_vars()
	// Keep the area default icons, to keep things nice and legible
	return list("name")

// No need to save any state of an area by default
/area/vars_to_save()
	return list("name")

/datum/proc/serialize_vr()
	return list("type" = type)

/datum/proc/deserialize_vr(list/data)

/atom/serialize_vr()
	var/list/data = ..()
	for(var/thing in vars_to_save())
		if(vars[thing] != initial(vars[thing]))
			data[thing] = vars[thing]
	return data


/atom/deserialize_vr(var/list/data)
	for(var/thing in vars_to_save())
		if(thing in data)
			vars[thing] = data[thing]
	..()

/*
Whoops, forgot to put documentation here.
What this does, is take a JSON string produced by running
BYOND's native `json_encode` on a list from `serialize` above, and
turns that string into a new instance of that object.

You can also easily get an instance of this string by calling "Serialize Marked Datum"
in the "Debug" tab.

If you're clever, you can do neat things with SDQL and this, though be careful -
some objects, like humans, are dependent that certain extra things are defined
in their list
*/
/proc/object_to_json(var/atom/movable/thing)
	return json_encode(thing.serialize_vr())

/proc/json_to_object(var/json_data, var/loc)
	return list_to_object(json_decode(json_data), loc)

/proc/list_to_object(var/list/data, var/loc)
	if(!islist(data))
		throw EXCEPTION("You didn't give me a list, bucko")
	if(!("type" in data))
		throw EXCEPTION("No 'type' field in the data")
	var/path = text2path(data["type"])
	if(!path)
		throw EXCEPTION("Path not found: [path]")

	var/atom/movable/thing = new path(loc)
	thing.deserialize_vr(data)
	return thing
