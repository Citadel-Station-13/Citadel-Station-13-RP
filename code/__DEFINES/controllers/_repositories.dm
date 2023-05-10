//* This is here in [code/__DEFINES/controllers/_repositories.dm] for compile order reasons. *//
/datum/controller/subsystem/repository/proc/__init_repositories()

#define REPOSITORY_DEF(what) \
GLOBAL_REAL(RC##what, /datum/controller/repository/##what); \
/datum/controller/repository/##what/New(){ \
	if(global.RC##what != src && istype(global.RC##what)){ \
		Recover(global.RC##what); \
		qdel(global.RC##what); \
	} \
	global.RC##what = src; \
} \
/datum/controller/subsystem/repository/var/datum/controller/repository/##what/RC##what; \
/datum/controller/subsystem/repository/__init_repositories() { \
	..(); \
	RC##what = new; \
	RC##what.Initialize(); \
} \
/datum/controller/repository/##what
