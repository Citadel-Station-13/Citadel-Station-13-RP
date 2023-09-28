//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/// from base of /atom/proc/context_query: (list/options, datum/event_args/actor/e_args)
/// options list is the same format as /atom/proc/context_query, insert directly to it.
#define COMSIG_ATOM_CONTEXT_QUERY "atom_context_query"
/// from base of /atom/proc/context_act: (key, datum/event_args/actor/e_args)
#define COMSIG_ATOM_CONTEXT_ACT "atom_context_act"
	#define RAISE_ATOM_CONTEXT_ACT_HANDLED (1<<0)

/// create context
/// * name: name
/// * image: context menu image
/// * distance: distance where this is valid; much be reachable or actable; null = requires adjacency or adjacency-equivalence
/// * mobility: mobility flags required
#define ATOM_CONTEXT_TUPLE(name, image, distance, mobility) list(name, image, distance, mobility)

/// when used as distance, telekinetics and other things do not count as adjacency
//  todo: currently not implemented
#define ATOM_CONTEXT_FORCE_PHYSICAL_ADJACENCY null
