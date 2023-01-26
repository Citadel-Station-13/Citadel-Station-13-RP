/*
candidates for conversion:
- /datum/role
- /datum/material
- /datum/lore
- /datum/design
*/

/**
 * global singletons fetched from SSrepository
 *
 * they can be registered, or non-registered.
 *
 * all prototypes *must* be serializable
 */
/datum/prototype
	abstract_type = /datum/prototype

	/// our id - must be unique for a given namespace. automatically generated.
	var/uid
	/// should this be saved?
	var/savable = FALSE
	/// namespace - should be unique to a given domain or kind of prototype, e.g. /datum/prototype/lore, /datum/prototype/outfit, etc
	/// this should NEVER be changed at runtime!
	var/namespace
	/// identifier - must be unique within a namespace
	var/identifier
	/// lazyloaded
	var/lazy = FALSE

/datum/prototype/New()
	uid = "[namespace]_[identifier]"

/**
 * called on register
 * always call return ..() *LAST* so side effects can be cleaned up on every level on failure.
 *
 * @return TRUE / FALSE to allow / deny register; PLEASE clean up side effects if you make this fail!
 */
/datum/prototype/proc/register()
	return TRUE

/**
 * called on unregister
 * this should never fail; returning FALSE causes a fatal runtime to be generated.
 *
 * @return TRUE / FALSE on success / failure
 */
/datum/prototype/proc/unregister()
	return TRUE

/datum/prototype/serialize()
	. = ..()
	.[NAMEOF(src, identifier)] = identifier

/datum/prototype/deserialize(list/data)
	. = ..()
	identifier = data[NAMEOF(src, identifier)]
	uid = "[namespace]_[identifier]"

/datum/prototype/proc/assert_identifier()
	return uid == "[namespace]_[identifier]" && namespace == initial(namespace)
