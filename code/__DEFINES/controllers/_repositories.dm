#define REPOSITORY_DEF(what) \
GLOBAL_REAL(RC##what, /datum/controller/repository/##what); \
/datum/controller/repository/##what/New(){ \
	if(global.RC##what != src){ \
		Recover(); \
		qdel(global.RC##what); \
	} \
	global.RC##what = src; \
} \
/datum/controller/subsystem/repository/var/datum/controller/repository/##what/RC##what \
/datum/controller/subsystem/repository/__init_repositories() { \
	..(); \
	RC##what = new; \
} \
/datum/controller/repository/##what
