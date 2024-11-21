//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Declares an admin verb.
 *
 * * Verbs declared in this way will have the caller as `client/caller`. Do not define your
 *   own client / usr calls.
 * * You may safely assume that the verb is only accessible by them if they have the right permissions.
 * * Set `CATEGORY` to null to not have it show up in verb panel.
 */
#define ADMIN_VERB_DEF(PATH_SUFFIX, REQUIRED_RIGHTS, NAME, DESC, CATEGORY, HEADER...) \
/datum/admin_verb_descriptor/##PATH_SUFFIX { \
	id = #PATH_SUFFIX; \
	required_rights = ##REQUIRED_RIGHTS; \
	verb_path = /datum/admins/proc/verb__##PATH_SUFFIX; \
	reflection_path = /datum/admins/proc/verb__invoke_##PATH_SUFFIX; \
}; \
/datum/admins/proc/verb__##PATH_SUFFIX(##HEADER) { \
	set name = NAME; \
	set desc = DESC; \
	set category = CATEGORY; \
	set hidden = FALSE; \
	if(!((usr?.client?.holder?.rights & ##REQUIRED_RIGHTS) == ##REQUIRED_RIGHTS)) {\
		CRASH("attempted invocation with insufficient rights."); \
	}; \
	do { \
		metric_increment_nested_numerical(/datum/metric/nested_numerical/admin_verb_invocation, #PATH_SUFFIX, 1); \
	}; \
	while(FALSE); \
	verb__invoke_##PATH_SUFFIX(arglist(list(usr.client) + args)); \
}; \
/datum/admins/proc/verb__invoke_##PATH_SUFFIX(client/caller, ##HEADER)
