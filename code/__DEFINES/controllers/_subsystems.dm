
//! Defines for subsystems and overlays
//!
//! Lots of important stuff in here, make sure you have your brain switched on
//! when editing this file

//! ## Initialization subsystem

///New should not call Initialize
#define INITIALIZATION_INSSATOMS 0
///New should call Initialize(TRUE)
#define INITIALIZATION_INNEW_MAPLOAD 2
///New should call Initialize(FALSE)
#define INITIALIZATION_INNEW_REGULAR 1

//! ### Initialization hints

///Nothing happens
#define INITIALIZE_HINT_NORMAL 0
/**
 * call LateInitialize at the end of all atom Initalization
 *
 * The item will be added to the late_loaders list, this is iterated over after
 * initalization of subsystems is complete and calls LateInitalize on the atom
 * see [this file for the LateIntialize proc](atom.html#proc/LateInitialize)
 */
#define INITIALIZE_HINT_LATELOAD 1

///Call qdel on the atom after intialization
#define INITIALIZE_HINT_QDEL 2

///type and all subtypes should always immediately call Initialize in New()
#define INITIALIZE_IMMEDIATE(X) ##X/New(loc, ...){\
	..();\
	if(!(flags & INITIALIZED)) {\
		args[1] = TRUE;\
		SSatoms.InitAtom(src, args);\
	}\
}

// SS runlevels

/// "Initialize Only" - Used for subsystems that should never be fired (Should also have SS_NO_FIRE set)
#define RUNLEVEL_INIT 0
/// Initial runlevel before setup.  Returns to here if setup fails.
#define RUNLEVEL_LOBBY 1
/// While the gamemode setup is running.  I.E gameticker.setup()
#define RUNLEVEL_SETUP 2
/// After successful game ticker setup, while the round is running.
#define RUNLEVEL_GAME 4
/// When round completes but before reboot
#define RUNLEVEL_POSTGAME 8

#define RUNLEVELS_DEFAULT (RUNLEVEL_SETUP | RUNLEVEL_GAME | RUNLEVEL_POSTGAME)

var/global/list/runlevel_flags = list(RUNLEVEL_LOBBY, RUNLEVEL_SETUP, RUNLEVEL_GAME, RUNLEVEL_POSTGAME)
/// Convert from the runlevel bitfield constants to index in runlevel_flags list
#define RUNLEVEL_FLAG_TO_INDEX(flag) (log(2, flag) + 1)

DEFINE_BITFIELD(runlevels, list(
	BITFIELD(RUNLEVEL_INIT),
	BITFIELD(RUNLEVEL_LOBBY),
	BITFIELD(RUNLEVEL_SETUP),
	BITFIELD(RUNLEVEL_GAME),
	BITFIELD(RUNLEVEL_POSTGAME),
))

// Subsystem init_order, from highest priority to lowest priority
// Subsystems shutdown in the reverse of the order they initialize in
// The numbers just define the ordering, they are meaningless otherwise.

#define INIT_ORDER_PROTOTYPES		103
#define INIT_ORDER_FAIL2TOPIC		102
#define INIT_ORDER_DBCORE			101
#define INIT_ORDER_INPUT			100
#define INIT_ORDER_JOBS				99
#define INIT_ORDER_CHARACTERS		98
#define INIT_ORDER_SOUNDS			95
#define INIT_ORDER_VIS				80
#define INIT_ORDER_GARBAGE			70
#define INIT_ORDER_SERVER_MAINT		65
#define INIT_ORDER_TIMER			60
#define INIT_ORDER_INSTRUMENTS		50
#define INIT_ORDER_EARLY_ASSETS		48
#define INIT_ORDER_SQLITE			40
#define INIT_ORDER_CHEMISTRY		35
#define INIT_ORDER_SKYBOX			30
#define INIT_ORDER_MAPPING			25
#define INIT_ORDER_DECALS			20
#define INIT_ORDER_PLANTS			19
#define INIT_ORDER_ALARMS			18
#define INIT_ORDER_ATOMS			15
#define INIT_ORDER_MACHINES			10
#define INIT_ORDER_SHUTTLES			3
#define INIT_ORDER_DEFAULT			0
#define INIT_ORDER_LIGHTING			0
#define INIT_ORDER_AIR				-1
#define INIT_ORDER_PLANETS			-2
#define INIT_ORDER_ASSETS			-4
#define INIT_ORDER_HOLOMAPS			-5
#define INIT_ORDER_NIGHTSHIFT		-6
#define INIT_ORDER_OVERLAY			-7
#define INIT_ORDER_EVENTS			-8
#define INIT_ORDER_OVERMAPS			-9
#define INIT_ORDER_TICKER			-10
#define INIT_ORDER_XENOARCH			-20
#define INIT_ORDER_CIRCUIT			-21
#define INIT_ORDER_AI				-22
#define INIT_ORDER_PERSISTENCE		-95
#define INIT_ORDER_PATH				-98
#define INIT_ORDER_ICON_SMOOTHING	-99
///Should be last to ensure chat remains smooth during init.
#define INIT_ORDER_CHAT				-100
#define INIT_ORDER_OPENSPACE		-110
// Subsystem fire priority, from lowest to highest priority
// If the subsystem isn't listed here it's either DEFAULT or PROCESS (if it's a processing subsystem child)

#define FIRE_PRIORITY_PING			5
#define FIRE_PRIORITY_SHUTTLES		5
#define FIRE_PRIORITY_NIGHTSHIFT	6
#define FIRE_PRIORITY_PLANTS		5
#define FIRE_PRIORITY_VOTE			9
#define FIRE_PRIORITY_AI			10
#define FIRE_PRIORITY_VIS			10
#define FIRE_PRIORITY_SERVER_MAINT	10
#define FIRE_PRIORITY_GARBAGE		15
#define FIRE_PRIORITY_ALARMS		20
#define FIRE_PRIORITY_CHARSETUP		25
#define FIRE_PRIORITY_SPACEDRIFT	25
#define FIRE_PRIORITY_AIRFLOW		30
#define FIRE_PRIORITY_PARALLAX		30
#define FIRE_PRIORITY_AIR			35
#define FIRE_PRIORITY_OBJ			40
#define FIRE_PRIORITY_PROCESS		45
#define FIRE_PRIORITY_DEFAULT		50
#define FIRE_PRIORITY_PLANETS		75
#define FIRE_PRIORITY_INSTRUMENTS	90
#define FIRE_PRIORITY_MACHINES		100
#define FIRE_PRIORITY_ASSETS		105
#define FIRE_PRIORITY_TGUI			110
#define FIRE_PRIORITY_PROJECTILES	150
#define FIRE_PRIORITY_THROWING		150
#define FIRE_PRIORITY_CHAT			400
#define FIRE_PRIORITY_OVERLAYS		500
#define FIRE_PRIORITY_SMOOTHING		500
#define FIRE_PRIORITY_TIMER			700
#define FIRE_PRIORITY_INPUT			1000 //! Never drop input

/**
	Create a new timer and add it to the queue.
	* Arguments:
	* * callback the callback to call on timer finish
	* * wait deciseconds to run the timer for
	* * flags flags for this timer, see: code\__DEFINES\subsystems.dm
*/
#define addtimer(args...) _addtimer(args, file = __FILE__, line = __LINE__)
