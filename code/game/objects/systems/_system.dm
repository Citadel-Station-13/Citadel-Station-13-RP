/**
 * just the base type of object systems
 *
 * components are just terrible API, inefficient, and obnoxious sometimes
 * /obj systems are the replacement for stuff like storage, cell slots, etc
 *
 * they are singletons on /obj level.
 */
/datum/object_system
	abstract_type = /datum/object_system

	/// owning object
	var/obj/parent

/datum/object_system/New(obj/parent)
	src.parent = parent
