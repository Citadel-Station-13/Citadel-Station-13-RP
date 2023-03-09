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
 * ids are optional, but no id means it can only be fetched by type. set anonymous to TRUE for that!
 *
 * all prototypes should eventually be serializable
 */
/datum/prototype
	abstract_type = /datum/prototype

	//? Identity
	/// namespace - should be unique to a given domain or kind of prototype, e.g. /datum/prototype/lore, /datum/prototype/outfit, etc
	/// this should NEVER be changed at runtime!
	/// changing this may cause persistent data to be thrown out.
	/// you have been warned.
	/// Should be in CamelCase.
	var/namespace
	/// identifier - must be unique within a namespace
	/// Should be in CamelCase
	var/identifier
	/// anonymous? if true, coded identifier is ignored.
	var/anonymous = FALSE

	/// our id - must be unique globally. DO NOT EDIT THIS, EDIT [identifier].
	var/uid
	/// uid next global on /datum/prototype
	var/static/uid_next = 0

	/// should this be saved?
	//  todo: not yet implemented
	var/savable = FALSE
	/// lazyloaded
	var/lazy = FALSE

/datum/prototype/New()
	if(anonymous)
		generate_anonymous_uid()
	else
		uid = "[namespace]-[identifier]"

/datum/prototype/proc/generate_anonymous_uid()
	// unique always, even across rounds
	uid = "[namespace]-[num2text(world.realtime, 16)]-[++uid_next]"

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

/**
 * checks that our identifier is set properly
 */
/datum/prototype/proc/assert_identifier()
	return !anonymous && uid == "[namespace]_[identifier]" && namespace == initial(namespace)
