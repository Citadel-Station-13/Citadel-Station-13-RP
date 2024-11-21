//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Declares an admin verb.
 *
 * * Verbs declared in this way will require a line of `var/client/caller = ADMIN_VER_CALLER`
 *   due to the weird way this is defined.
 * * You may safely assume that the verb is only accessible by them if they have the right permissions.
 */
#define ADMIN_VERB_DEF(PATH_SUFFIX, ID, REQUIRED_RIGHTS, HEADER...) \
/datum/admin_verb_descriptor/##PATH_SUFFIX { \
	id = ID; \
	required_rights = ##REQUIRED_RIGHTS; \
	verb_path = /datum/admins/proc/verb__##PATH_SUFFIX; \
	reflection_path = /datum/admins/proc/verb__invoke_##PATH_SUFFIX; \
}; \
/datum/admins/proc/verb__##PATH_SUFFIX(##HEADER) { \
	if(!((usr?.client?.holder?.rights & ##REQUIRED_RIGHTS) == ##REQUIRED_RIGHTS)) {\
		CRASH("attempted invocation with insufficient rights."); \
	}; \
	do { \
		metric_increment_nested_numerical(/datum/metric/nested_numerical/admin_verb_invocation, #ID, 1); \
	}; \
	while(FALSE); \
	verb__invoke_##PATH_SUFFIX(arglist(args)); \
}; \
/datum/admins/proc/verb__invoke_##PATH_SUFFIX(##HEADER)

/**
 * Fetches the calling client of an admin verb declared with `ADMIN_VERB_DEF`
 */
#define ADMIN_VERB_CALLER (usr.client)
