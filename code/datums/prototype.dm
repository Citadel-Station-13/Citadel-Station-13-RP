//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Global singletons fetched from repository controllers.
 *
 * They can be created mid-round, and persisted.
 *
 * All prototypes should be serializable.
 *
 * * Any non-hardcoded prototypes are automatically serialized to the database on registration.
 * * Prototypes should never requrie hard references to datums.
 * * Prototypes may only refer to other prototypes with string IDs.
 * * Hardcoded prototypes should only refer to other prototypes with typepaths. This allows the subsystem to early-load
 *   the other prototypes before its own initialization, which is required to not have to enforce load order
 *   on repositories.
 */
/datum/prototype
	abstract_type = /datum/prototype

	//* System *//

	/// is this hardcoded?
	///
	/// * hardcoded prototypes can never be unloaded
	/// * you should not be touching this (whether read or write) ever outside of the base of /datum/controller/repository.
	var/hardcoded = FALSE

	//* Identity *//

	/// Globally unique ID for usage with the repository this is stored in.
	///
	/// * IDs should be named like "CamelCase" as per prototype standards in many ECS games.
	/// * IDs should be globally unique across rounds.
	/// * Hardcoded prototypes should always be referred to via type instead of ID where possible
	/// * All persistent prototypes bear the burden of not colliding with hardcoded prototypes.
	///   Repositories will try to mangle persistent prototypes to ensure they do not collide.
	/// * IDs should never be visible to players; they are not meant to be cryptographic or IC.
	var/id

	// TODO: deal with the rest of this

	// todo: anonymous is kinda wrong. only procgen'd prototypes should have procedural ids.
	//       right now, this is just here to support transferring legacy stuff over without having to manually assign IDs
	//       to everything. this does mean that ::id won't be usable until it's taken off of a subtype.
	/// anonymous? if true, coded id is ignored.
	var/anonymous = FALSE
	/// namespace for anonymous generation - must be set if anonymous
	var/anonymous_namespace
	/// id next global on /datum/prototype
	var/static/id_next = 0
	/// should this be saved?
	//  todo: not yet implemented
	var/savable = FALSE
	/// lazyloaded
	var/lazy = FALSE

	// END

/datum/prototype/New()
	if(anonymous && isnull(id))
		id = generate_anonymous_uid()

/**
 * Override this to false if your type has non-cache temporaries.
 * * Using this is usually a bad idea but sometimes it's better to keep something loaded
 *   than to fuck around with '/datum/role_round_context' or something.
 */
/datum/prototype/proc/can_be_unloaded()
	return TRUE

/datum/prototype/proc/generate_anonymous_uid()
	// unique always, even across rounds
	// todo: use SSpersistence persistence ID or something; maybe persistence ID should just be a global thing on the databse?
	//       or just don't use sspersistence and use a better metric than realtime because this looks like shit lol
	ASSERT(anonymous_namespace)
	return "[anonymous_namespace]-[num2text(world.realtime, 16)]-[++id_next]"

/datum/prototype/serialize()
	. = ..()
	.["id"] = id

/datum/prototype/deserialize(list/data)
	. = ..()
	id = data["id"]

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
