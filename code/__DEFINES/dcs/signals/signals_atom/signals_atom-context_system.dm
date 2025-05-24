//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/// from base of /atom/proc/context_menu_query: (list/options, datum/event_args/actor/e_args)
/// options list is the same format as /atom/proc/context_menu_query, insert directly to it.
#define COMSIG_ATOM_CONTEXT_QUERY "atom_context_menu_query"
/// from base of /atom/proc/context_menu_act: (key, datum/event_args/actor/e_args)
#define COMSIG_ATOM_CONTEXT_ACT "atom_context_menu_act"
	#define RAISE_ATOM_CONTEXT_ACT_HANDLED (1<<0)

/// Creates context key
///
/// * Used to ensure things like components piggybacking on an atom and
///   hooking the menu with signals don't collide with the atom or other
///   components using the same keys.
#define atom_context_key(atom, key) "[ref(atom)]-[key]"

/// create context
/// todo: this is deprecated, i think.
/// * name: name
/// * image: context menu image
/// * distance: distance where this is valid; much be reachable or actable; null = requires adjacency or adjacency-equivalence
/// * mobility: mobility flags required
#define ATOM_CONTEXT_TUPLE(name, image, distance, mobility) list(name, image, distance, mobility)

/// Creates option for context menu
///
/// todo: more managed context menu option. we shouldn't create this every time it's brought up
///
/// @params
/// * name: name
/// * image: context menu image
/// * distance: distance where this is valid; much be reachable or actable; null = requires adjacency or adjacency-equivalence
/// * mobility: mobility flags required
/// * defaultable: allow defaulting if this is the only thing in the list
/proc/create_context_menu_tuple(name, image/I, distance, mobility, defaultable)
	return list(
		name,
		I,
		distance,
		mobility,
		defaultable,
	)

/// when used as distance, telekinetics and other things do not count as adjacency
//  todo: currently not implemented
#define ATOM_CONTEXT_FORCE_PHYSICAL_ADJACENCY null
