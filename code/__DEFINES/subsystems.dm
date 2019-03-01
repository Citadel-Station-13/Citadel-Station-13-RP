//Update this whenever the db schema changes
//make sure you add an update to the schema_version stable in the db changelog
//#define DB_MAJOR_VERSION 5
//#define DB_MINOR_VERSION 0

//Timing subsystem
//Don't run if there is an identical unique timer active
//if the arguments to addtimer are the same as an existing timer, it doesn't create a new timer, and returns the id of the existing timer
#define TIMER_UNIQUE			(1<<0)
//For unique timers: Replace the old timer rather then not start this one
#define TIMER_OVERRIDE			(1<<1)
//Timing should be based on how timing progresses on clients, not the sever.
//	tracking this is more expensive,
//	should only be used in conjuction with things that have to progress client side, such as animate() or sound()
#define TIMER_CLIENT_TIME		(1<<2)
//Timer can be stopped using deltimer()
#define TIMER_STOPPABLE			(1<<3)
//To be used with TIMER_UNIQUE
//prevents distinguishing identical timers with the wait variable
#define TIMER_NO_HASH_WAIT		(1<<4)
//Loops the timer repeatedly until qdeleted
//In most cases you want a subsystem instead
#define TIMER_LOOP				(1<<5)

#define TIMER_ID_NULL -1

//For servers that can't do with any additional lag, set this to none in flightpacks.dm in subsystem/processing.
#define FLIGHTSUIT_PROCESSING_NONE 0
#define FLIGHTSUIT_PROCESSING_FULL 1

#define INITIALIZATION_INSSATOMS 0	//New should not call Initialize
#define INITIALIZATION_INNEW_MAPLOAD 2	//New should call Initialize(TRUE)
#define INITIALIZATION_INNEW_REGULAR 1	//New should call Initialize(FALSE)

#define INITIALIZE_HINT_NORMAL 0    //Nothing happens
#define INITIALIZE_HINT_LATELOAD 1  //Call LateInitialize
#define INITIALIZE_HINT_QDEL 2  //Call qdel on the atom

//type and all subtypes should always call Initialize in New()
#define INITIALIZE_IMMEDIATE(X) ##X/New(loc, ...){\
	..();\
	if(!CHECK_BITFIELD(flags, INITIALIZED)) {\
		args[1] = TRUE;\
		SSatoms.InitAtom(src, args);\
	}\
}

// Subsystem init_order, from highest priority to lowest priority
// Subsystems shutdown in the reverse of the order they initialize in
// The numbers just define the ordering, they are meaningless otherwise.

#define INIT_ORDER_GARBAGE		70
#define INIT_ORDER_TIMER		60
#define INIT_ORDER_CHEMISTRY	50
#define INIT_ORDER_MAPPING		40
#define INIT_ORDER_DECALS		38
#define INIT_ORDER_VIS			36
#define INIT_ORDER_ATOMS		34
#define INIT_ORDER_MACHINES		32
#define INIT_ORDER_SHUTTLES		30
#define INIT_ORDER_DEFAULT		0
#define INIT_ORDER_LIGHTING		0
#define INIT_ORDER_AIR			-1
#define INIT_ORDER_PLANETS		-4
#define INIT_ORDER_HOLOMAPS		-5
#define INIT_ORDER_OVERLAY		-6
#define INIT_ORDER_XENOARCH		-20
#define INIT_ORDER_CIRCUIT		-21
#define INIT_ORDER_AI			-22


// Subsystem fire priority, from lowest to highest priority
// If the subsystem isn't listed here it's either DEFAULT or PROCESS (if it's a processing subsystem child)
#define FIRE_PRIORITY_SHUTTLES		5
#define FIRE_PRIORITY_ORBIT			8
#define FIRE_PRIORITY_VOTE			9
#define FIRE_PRIORITY_AI			10
#define FIRE_PRIORITY_VIS			10
#define FIRE_PRIORITY_GARBAGE		15
#define FIRE_PRIORITY_THROWING		20
#define FIRE_PRIORITY_SPACEDRIFT	30
#define FIRE_PRIORITY_AIRFLOW		30
#define FIRE_PRIORITY_AIR			35
#define FIRE_PRIORITY_OBJ			40
#define FIRE_PRIORITY_PROCESS		45
#define FIRE_PRIORITY_DEFAULT		50
#define FIRE_PRIORITY_PLANETS		75
#define FIRE_PRIORITY_MACHINES		100
#define FIRE_PRIORITY_PROJECTILES	150
#define FIRE_PRIORITY_OVERLAYS		500

// SS runlevels

#define RUNLEVEL_INIT 0
#define RUNLEVEL_LOBBY 1
#define RUNLEVEL_SETUP 2
#define RUNLEVEL_GAME 4
#define RUNLEVEL_POSTGAME 8

#define RUNLEVELS_DEFAULT (RUNLEVEL_SETUP | RUNLEVEL_GAME | RUNLEVEL_POSTGAME)




#define COMPILE_OVERLAYS(A)\
	if (TRUE) {\
		var/list/ad = A.add_overlays;\
		var/list/rm = A.remove_overlays;\
		var/list/po = A.priority_overlays;\
		if(LAZYLEN(rm)){\
			A.overlays -= rm;\
			rm.Cut();\
		}\
		if(LAZYLEN(ad)){\
			A.overlays |= ad;\
			ad.Cut();\
		}\
		if(LAZYLEN(po)){\
			A.overlays |= po;\
		}\
		A.flags &= ~OVERLAY_QUEUED;\
	}
