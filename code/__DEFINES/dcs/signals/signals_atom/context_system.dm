//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/// from base of /atom/proc/context_query: (list/options, mob/user, distance)
/// options list is the same format as /atom/proc/context_query, insert directly to it.
#define COMSIG_ATOM_CONTEXT_QUERY "atom_context_query"
/// from base of /atom/proc/context_act: (key, mob/user)
#define COMSIG_ATOM_CONTEXT_ACT "atom_context_act"
	#define RAISE_ATOM_CONTEXT_ACT_HANDLED (1<<0)
