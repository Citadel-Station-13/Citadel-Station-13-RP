//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * # Shuttles
 *
 * Core datum for shuttles.
 *
 * ## Controllers
 *
 * All shuttle behaviors are now in controllers whenever possible. The base datum just handles the actual shuttle itself.
 * Moving to transit and staying in transit? That's a controller thing. Temporary dynamic transit? That's a controller thing, too.
 *
 * todo: nestable-shuttle support ? e.g. transport ship on a shuttle ; this is not optimal for performance but sure is cool
 * todo: multi-z shuttles; is this even possible? very long term.
 * todo: areas is a shit system. this is probably not fixable, because how else would we do bounding boxes?
 * todo: it would sure be nice to be able to dynamically expand shuttles in-game though; probably a bad idea too.
 * todo: serialize/deserialize, but should it be on this side or the map tempalte side? we want save/loadable.
 */
/datum/shuttle
	//* Intrinsics *//
	/// our unique template id; this is *not* our ID and is *not* unique!
	var/template_id
	/// our descriptor instance; this is what determines how we act
	/// to our controller, as well as things like overmaps.
	var/datum/shuttle_descriptor/descriptor

	//* Identity *//
	/// real / code name
	var/name = "Unnamed Shuttle"
	/// description for things like admin interfaces
	var/desc = "Some kind of shuttle. The coder forgot to set this."

	//* Structure *//
	/// if set, we generate a ceiling above the shuttle of this type, on the bottom of the turf stack.
	//  todo: vv hook this
	var/ceiling_type = /turf/simulated/shuttle_ceiling
