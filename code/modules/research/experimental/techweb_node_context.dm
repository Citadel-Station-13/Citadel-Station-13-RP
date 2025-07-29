//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Since techweb nodes are immutable prototypes, it's very difficult to do state
 * tracking like limited prints with them.
 *
 * Instead, we pass context datums with techweb_nodes to have exactly this work;
 * state and custom behavior goes on context.
 */
/datum/techweb_node_context
	/// hard-block copying this node
	var/drm_protected = FALSE

	// TODO: trace data for where the noed comes from, e.g. 'server xyz in research network'

/**
 * Lazy implementation
 */
/datum/techweb_node_context/lazy_impl
