//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* This is here in [code/__DEFINES/controllers/_repositories.dm] for compile order reasons. *//
/datum/controller/subsystem/repository/proc/__create_repositories()

//* This is here in [code/__DEFINES/controllers/_repositories.dm] for compile order reasons. *//
/datum/controller/subsystem/repository/proc/__init_repositories()

//* This is here in [code/__DEFINES/controllers/_repositories.dm] for compile order reasons. *//
/datum/controller/subsystem/repository/proc/__get_all_repositories()

// todo: redo recover logic; maybe /datum/controller as a whole should be brushed up
#define REPOSITORY_DEF(what) \
GLOBAL_REAL(RS##what, /datum/controller/repository/##what); \
/datum/controller/repository/##what/New(){ \
	if(global.RS##what != src && istype(global.RS##what)){ \
		Recover(global.RS##what); \
		qdel(global.RS##what); \
	} \
	global.RS##what = src; \
} \
/datum/controller/subsystem/repository/var/datum/controller/repository/##what/RS##what; \
/datum/controller/subsystem/repository/__create_repositories() { \
	..(); \
	RS##what = new; \
	RS##what.Create(); \
} \
/datum/controller/subsystem/repository/__init_repositories() { \
	..(); \
	RS##what.Initialize(); \
} \
/datum/controller/subsystem/repository/__get_all_repositories() { \
	. = ..() || list(); \
	. += RS##what; \
} \
/datum/controller/repository/##what

/// Returned from /datum/controller/repository's fetch_or_defer() if we don't have something
/// on hand, but also don't know that it doesn't exist.
#define REPOSITORY_FETCH_DEFER "defer"
