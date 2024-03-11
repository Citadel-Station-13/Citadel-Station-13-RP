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
	if(!(atom_flags & ATOM_INITIALIZED)) {\
		var/previous_initialized_value = SSatoms.initialized;\
		SSatoms.initialized = INITIALIZATION_INNEW_MAPLOAD;\
		args[1] = TRUE;\
		SSatoms.InitAtom(src, FALSE, args);\
		SSatoms.initialized = previous_initialized_value;\
	}\
}

//! ### SS initialization hints
/**
 * Negative values incidate a failure or warning of some kind, positive are good.
 * 0 and 1 are unused so that TRUE and FALSE are guarenteed to be invalid values.
 */

/// Subsystem failed to initialize entirely. Print a warning, log, and disable firing.
#define SS_INIT_FAILURE -2

/// The default return value which must be overriden. Will succeed with a warning.
#define SS_INIT_NONE -1

/// Subsystem initialized sucessfully.
#define SS_INIT_SUCCESS 2

/// If your system doesn't need to be initialized (by being disabled or something)
#define SS_INIT_NO_NEED 3

/// Succesfully initialized, BUT do not announce it to players (generally to hide game mechanics it would otherwise spoil)
#define SS_INIT_NO_MESSAGE 4

//! ### SS initialization load orders
// Subsystem init_order, from highest priority to lowest priority
// Subsystems shutdown in the reverse of the order they initialize in
// The numbers just define the ordering, they are meaningless otherwise.


#define INIT_ORDER_FAIL2TOPIC      200
#define INIT_ORDER_GARBAGE         198 // sorry but why isnt this near max?
#define INIT_ORDER_IPINTEL         197
#define INIT_ORDER_TIMER           195
#define INIT_ORDER_DBCORE          190
#define INIT_ORDER_EARLY_INIT      185
#define INIT_ORDER_REPOSITORY      180
#define INIT_ORDER_STATPANELS      170
#define INIT_ORDER_INPUT           160
#define INIT_ORDER_JOBS            150
#define INIT_ORDER_CHARACTERS      140
#define INIT_ORDER_SOUNDS          130
#define INIT_ORDER_VIS             80
#define INIT_ORDER_SERVER_MAINT    65
#define INIT_ORDER_INSTRUMENTS     50
#define INIT_ORDER_EARLY_ASSETS    48
#define INIT_ORDER_MEDIA_TRACKS    38
#define INIT_ORDER_CHEMISTRY       35
#define INIT_ORDER_MATERIALS       34
#define INIT_ORDER_PHOTOGRAPHY     27
#define INIT_ORDER_MAPPING         25
#define INIT_ORDER_LEGACY_ATC      24
#define INIT_ORDER_LEGACY_LORE     23
#define INIT_ORDER_LOBBY           22
#define INIT_ORDER_PLANTS          19
#define INIT_ORDER_ALARMS          18
#define INIT_ORDER_RESEARCH        17
#define INIT_ORDER_ATOMS           15
#define INIT_ORDER_MACHINES        10
#define INIT_ORDER_SHUTTLES        3
#define INIT_ORDER_DEFAULT         0
#define INIT_ORDER_AIR            -1
#define INIT_ORDER_PLANETS        -2
#define INIT_ORDER_PERSISTENCE    -3
#define INIT_ORDER_ASSETS         -4
#define INIT_ORDER_MISC_LATE      -5
#define INIT_ORDER_HOLOMAPS       -5
#define INIT_ORDER_NIGHTSHIFT     -5
#define INIT_ORDER_ICON_SMOOTHING -6
#define INIT_ORDER_OVERLAY        -7
#define INIT_ORDER_EVENTS         -10
#define INIT_ORDER_OVERMAPS       -20
#define INIT_ORDER_TICKER         -30
#define INIT_ORDER_LIGHTING       -40
#define INIT_ORDER_ZMIMIC         -45
#define INIT_ORDER_AMBIENT_LIGHT  -46
#define INIT_ORDER_XENOARCH       -50
#define INIT_ORDER_CIRCUIT        -60
#define INIT_ORDER_AI             -70
#define INIT_ORDER_PATH           -98
#define INIT_ORDER_CHAT 		  -100 //Should be last to ensure chat remains smooth during init.

// Subsystem fire priority, from lowest to highest priority
// If the subsystem isn't listed here it's either DEFAULT or PROCESS (if it's a processing subsystem child)

//? Background Subsystems - Below normal
#define FIRE_PRIORITY_RADIATION    10  //! laggy as hell, bottom barrel until optimizations are done.
#define FIRE_PRIORITY_DATABASE 16
#define FIRE_PRIORITY_GARBAGE      15
#define FIRE_PRIORITY_CHARACTERS   25
#define FIRE_PRIORITY_PARALLAX     30
#define FIRE_PRIORITY_AIR          35
#define FIRE_PRIORITY_PROCESS      45
// DEFAULT PRIORITY IS HERE
#define FIRE_PRIORITY_PLANETS      75

//? Normal Subsystems - Above background, below ticker

#define FIRE_PRIORITY_PING 10
#define FIRE_PRIORITY_SHUTTLES     5
#define FIRE_PRIORITY_PLANTS       5
#define FIRE_PRIORITY_NIGHTSHIFT   6
#define FIRE_PRIORITY_VOTE         9
#define FIRE_PRIORITY_VIS          10
#define FIRE_PRIORITY_SERVER_MAINT 10
#define FIRE_PRIORITY_ZMIMIC       10
#define FIRE_PRIORITY_ALARMS       20
#define FIRE_PRIORITY_SPACEDRIFT   25
#define FIRE_PRIORITY_AIRFLOW      30
#define FIRE_PRIORITY_OBJ          40
#define FIRE_PRIORITY_DEFAULT 50
#define FIRE_PRIORITY_LIGHTING         50
#define FIRE_PRIORITY_INSTRUMENTS      90
#define FIRE_PRIORITY_ASSET_LOADING    100
#define FIRE_PRIORITY_MACHINES         100
#define FIRE_PRIORITY_NANO             110
#define FIRE_PRIORITY_TGUI             110
#define FIRE_PRIORITY_TICKER 200
#define FIRE_PRIORITY_AI               200
#define FIRE_PRIORITY_PROJECTILES      200
#define FIRE_PRIORITY_THROWING         200
#define FIRE_PRIORITY_STATPANELS       400
#define FIRE_PRIORITY_CHAT             400
#define FIRE_PRIORITY_OVERLAYS         500
#define FIRE_PRIORITY_SMOOTHING        500
#define FIRE_PRIORITY_INPUT 1000 // This must always always be the max highest priority. Player input must never be lost.

//? Ticker Subsystems - Highest priority
// Any subsystem flagged with SS_TICKER is here!
// Do not unnecessarily set your subsystem as TICKER.
// Is your feature as important as movement, chat, or timers?
// Probably not! Go to normal bracket instead!

// DEFAULT PRIORITY IS HERE
#define FIRE_PRIORITY_DPC          700
#define FIRE_PRIORITY_TIMER        700

// SS runlevels

#define RUNLEVEL_LOBBY (1<<0)
#define RUNLEVEL_SETUP (1<<1)
#define RUNLEVEL_GAME (1<<2)
#define RUNLEVEL_POSTGAME (1<<3)

#define RUNLEVELS_DEFAULT (RUNLEVEL_SETUP | RUNLEVEL_GAME | RUNLEVEL_POSTGAME)

//SSticker.current_state values
/// Game is loading
#define GAME_STATE_STARTUP 0
/// Game is loaded and in pregame lobby
#define GAME_STATE_PREGAME 1
/// Game is attempting to start the round
#define GAME_STATE_SETTING_UP 2
/// Game has round in progress
#define GAME_STATE_PLAYING 3
/// Game has round finished
#define GAME_STATE_FINISHED 4

// Used for SSticker.force_ending
/// Default, round is not being forced to end.
#define END_ROUND_AS_NORMAL 0
/// End the round now as normal
#define FORCE_END_ROUND 1
/// For admin forcing roundend, can be used to distinguish the two
#define ADMIN_FORCE_END_ROUND 2

/**
	Create a new timer and add it to the queue.
	* Arguments:
	* * callback the callback to call on timer finish
	* * wait deciseconds to run the timer for
	* * flags flags for this timer, see: code\__DEFINES\subsystems.dm
	* * timer_subsystem the subsystem to insert this timer into
*/
#define addtimer(args...) _addtimer(args, file = __FILE__, line = __LINE__)

// Subsystem delta times or tickrates, in seconds. I.e, how many seconds in between each process() call for objects being processed by that subsystem.
// Only use these defines if you want to access some other objects processing seconds_per_tick, otherwise use the seconds_per_tick that is sent as a parameter to process()
#define SSMACHINES_DT (SSmachines.wait/10)
#define SSMOBS_DT (SSmobs.wait/10)
#define SSOBJ_DT (SSobj.wait/10)

// The change in the world's time from the subsystem's last fire in seconds.
#define DELTA_WORLD_TIME(ss) ((world.time - ss.last_fire) * 0.1)

/// The timer key used to know how long subsystem initialization takes
#define SS_INIT_TIMER_KEY "ss_init"
