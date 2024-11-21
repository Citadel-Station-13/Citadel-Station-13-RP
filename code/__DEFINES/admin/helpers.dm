//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Declares an admin verb.
 */
#define ADMIN_VERB_DEF(PATH_SUFFIX, ID, REQUIRED_RIGHTS) \
/datum/admin_verb_descriptor/##PATH_SUFFIX{ ; \
	id = ID; \
	required_rights = REQUIRED_RIGHTS; \
	verb_path = /datum/admins/proc/verb__##PATH_SUFFIX; \
}; \
/datum/admins/proc/verb__##PATH_SUFFIX

