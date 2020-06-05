/**
  * Simple object persistence elements
  * For now, it just attachs and detaches and all objects with it are recorded to disk based on map and stuff at round end
  * Can expand later for more functionality
  *
  * WARNING: All atoms recorded are stored to turf! This does not yet support things like loading into inventories. This is mostly for on-floor objects.
  */
/datum/element/persistence
	flags = ELEMENT_DETACH

	/// List of persistent atoms. Associated list to their GUID
	var/list/atom/objects = list()

/**
  * Serializes all objects into a list for json encode or anything else needed.
  * Includes data the datum includes in serialize_list(), the GUID of the datum's entry, and its turf location.
  */
/datum/element/persistence/proc/SerializeAll()
	. = list()
	var/atom/A
	var/guid
	for(var/i in objects)
		A = i
		guid = objects[A]
		var/turf/location = get_turf(A)
		if(!A || !guid || !location)
			continue
		. += list(A.serialize_list(), guid, list(location.x, location.y, location.z), "[A.type]")

/**
  * Instantiates all objects from a data list and attaches to them.
  */
/datum/element/persistence/proc/DeserializeAndInstantiateAll(list/data)
	for(var/i in data)
		var/list/L = i
		if(!istype(L) || (length(L) < 3))
			continue
		var/list/datumdata = L[1]
		var/guid = L[2]
		var/coords = L[3]
		var/datumtype = text2path(L[4])
		if(!ispath(datumtype))
			continue
		var/turf/T = locate(coords[1], coords[2], coords[3])
		if(!T)
			continue
		var/atom/A = new datumtype(T)
		A.deserialize_list(datumdata)
		Attach(A, guid)

/datum/element/persistence/Attach(datum/D, guid = GUID())
	if(!isatom(D))
		return ELEMENT_INCOMPATIBLE
	. = ..()
	if(. == ELEMENT_INCOMPATIBLE)
		return
	objects[D] = guid

/datum/element/persistence/Detach(datum/D)
	objects -= D
