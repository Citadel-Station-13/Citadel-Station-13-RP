//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Declares an admin verb.
 *
 * * Verbs declared in this way will have the calling client as `client/invoker`. Do not define your
 *   own client / usr calls.
 * * You may safely assume that the verb is only accessible by them if they have the right permissions.
 * * Set `CATEGORY` to null to not have it show up in verb panel.
 */
#define ADMIN_VERB_DEF(PATH_SUFFIX, REQUIRED_RIGHTS, NAME, DESC, CATEGORY, HEADER...) \
	ADMIN_VERB_DEF_INTERNAL(PATH_SUFFIX, REQUIRED_RIGHTS, NAME, DESC, CATEGORY, TRUE, HEADER)

/**
 * Declares an admin verb that does not show up in the popup menu.
 *
 * * Verbs declared in this way will have the calling client as `client/invoker`. Do not define your
 *   own client / usr calls.
 * * You may safely assume that the verb is only accessible by them if they have the right permissions.
 * * Set `CATEGORY` to null to not have it show up in verb panel.
 */
#define ADMIN_VERB_DEF_PANEL_ONLY(PATH_SUFFIX, REQUIRED_RIGHTS, NAME, DESC, CATEGORY, HEADER...) \
	ADMIN_VERB_DEF_INTERNAL(PATH_SUFFIX, REQUIRED_RIGHTS, NAME, DESC, CATEGORY, FALSE, HEADER)

/**
 * Do not use.
 */
#define ADMIN_VERB_DEF_INTERNAL(PATH_SUFFIX, REQUIRED_RIGHTS, NAME, DESC, CATEGORY, POPUP_MENU, HEADER...) \
/datum/admin_verb_descriptor/##PATH_SUFFIX { \
	id = #PATH_SUFFIX; \
	required_rights = ##REQUIRED_RIGHTS; \
	verb_path = /datum/admin_verb_abstraction/proc/verb__##PATH_SUFFIX; \
	reflection_path = /datum/admin_verb_abstraction/proc/verb__invoke_##PATH_SUFFIX; \
}; \
/datum/admin_verb_abstraction/proc/verb__##PATH_SUFFIX(##HEADER) { \
	set name = NAME; \
	set desc = DESC; \
	set category = CATEGORY; \
	set hidden = FALSE; \
	set popup_menu = POPUP_MENU; \
	if(!((usr?.client?.holder?.rights & ##REQUIRED_RIGHTS) == ##REQUIRED_RIGHTS)) {\
		CRASH("attempted invocation with insufficient rights."); \
	}; \
	do { \
		metric_increment_nested_numerical(/datum/metric/nested_numerical/admin_verb_invocation, #PATH_SUFFIX, 1); \
		log_admin("[key_name(usr)] invoked admin verb '[#PATH_SUFFIX]'"); \
	}; \
	while(FALSE); \
	call(usr.client, /datum/admin_verb_abstraction::verb__invoke_##PATH_SUFFIX())(arglist(list(usr.client) + args)); \
}; \
/datum/admin_verb_abstraction/proc/verb__invoke_##PATH_SUFFIX(client/invoking, ##HEADER)

/**
 * Abstract datum with no variables. Used to hold the proc definitions for admin verbs.
 *
 * * The way this works is black magic, so, uh, no touchy I guess.
 */
VV_PROTECT_READONLY(/datum/admin_verb_abstraction)
/datum/admin_verb_abstraction
	abstract_type = /datum/admin_verb_abstraction
