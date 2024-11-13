/**
 *! Defines for subsystems and overlays
 *
 *? Lots of important stuff in here, make sure you have your brain switched on when editing this file!
 */

//* Subsystem `initialized` variable *//

// todo: implement these, separate out SSatoms initialization state to its own variable
// #define SUBSYSTEM_INITIALIZED_NOT_STARTED 0
// #define SUBSYSTEM_INITIALIZED_INITIALIZING 1
// #define SUBSYSTEM_INITIALIZED_DONE 2

//* Subsystem `Initialize()` returns *//

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

//! ### SS runlevels

//*                                            Runlevels                                          *//
//*             Must be powers of 2. Runlevels should be in order of progression.                 *//
//*             Only subsystem with a runlevel matching the MC's will be ticked.                  *//
//* The first runlevel (value '1') will be the default runlevel when the MC is first initialized. *//

/// "Initialize Only" - Used for subsystems that should never be fired (Should also have SS_NO_FIRE set).
#define RUNLEVEL_INIT     0
/// Initial runlevel before setup.  Returns to here if setup fails.
#define RUNLEVEL_LOBBY    1
/// While the gamemode setup is running.  I.E gameticker.setup()
#define RUNLEVEL_SETUP    2
/// After successful game ticker setup, while the round is running.
#define RUNLEVEL_GAME     4
/// When round completes but before reboot.
#define RUNLEVEL_POSTGAME 8

/// default runlevels for most subsystems
#define RUNLEVELS_DEFAULT (RUNLEVEL_SETUP | RUNLEVEL_GAME | RUNLEVEL_POSTGAME)
/// all valid runlevels - subsystems with this will run all the time after their MC init stage.
#define RUNLEVELS_ALL (RUNLEVEL_LOBBY | RUNLEVEL_SETUP | RUNLEVEL_GAME | RUNLEVEL_POSTGAME)

var/global/list/runlevel_flags = list(RUNLEVEL_LOBBY, RUNLEVEL_SETUP, RUNLEVEL_GAME, RUNLEVEL_POSTGAME)
/// Convert from the runlevel bitfield constants to index in runlevel_flags list.
#define RUNLEVEL_FLAG_TO_INDEX(flag) (log(2, flag) + 1)

DEFINE_BITFIELD(runlevels, list(
	BITFIELD(RUNLEVEL_INIT),
	BITFIELD(RUNLEVEL_LOBBY),
	BITFIELD(RUNLEVEL_SETUP),
	BITFIELD(RUNLEVEL_GAME),
	BITFIELD(RUNLEVEL_POSTGAME),
))


/**
 *! Subsystem fire priority, from lowest to highest priority
 *? If the subsystem isn't listed here it's either DEFAULT or PROCESS (if it's a processing subsystem child)
 */

//? Background Subsystems - Below normal
// Any ../subsystem/.. is here unless it doesn't have SS_BACKGROUND in subsystem_flags!
// This means by default, ../subsystem/processing/.. is here!

#define FIRE_PRIORITY_RADIATION        10  //! laggy as hell, bottom barrel until optimizations are done.
#define FIRE_PRIORITY_GARBAGE          15
#define FIRE_PRIORITY_CHARACTERS       20
#define FIRE_PRIORITY_PARALLAX         20
#define FIRE_PRIORITY_AIR              25
#define FIRE_PRIORITY_ASSET_LOADING    25
#define FIRE_PRIORITY_PLANETS          25
#define FIRE_PRIORITY_PROCESS          50
// DEFAULT PRIORITY IS HERE (50)

//? Normal Subsystems - Above background, below ticker
// Any ../subsystem/.. without SS_TICKER or SS_BACKGROUND in subsystem_flags is here!

#define FIRE_PRIORITY_PING         5
#define FIRE_PRIORITY_SHUTTLES     5
#define FIRE_PRIORITY_PLANTS       5
#define FIRE_PRIORITY_NIGHTSHIFT   6
#define FIRE_PRIORITY_VOTE         9
#define FIRE_PRIORITY_VIS          10
#define FIRE_PRIORITY_SERVER_MAINT 10
#define FIRE_PRIORITY_ZMIMIC       10
#define FIRE_PRIORITY_ALARMS       20
#define FIRE_PRIORITY_AIRFLOW      20
#define FIRE_PRIORITY_SPACEDRIFT   25
#define FIRE_PRIORITY_OBJ          40
// DEFAULT PRIORITY IS HERE (50)
#define FIRE_PRIORITY_LIGHTING         50
#define FIRE_PRIORITY_INSTRUMENTS      50
#define FIRE_PRIORITY_MACHINES         50
#define FIRE_PRIORITY_AI               65
#define FIRE_PRIORITY_AI_HOLDERS       65
#define FIRE_PRIORITY_AI_MOVEMENT      75
#define FIRE_PRIORITY_AI_SCHEDULING    75
#define FIRE_PRIORITY_NANO             80
#define FIRE_PRIORITY_TGUI             80
#define FIRE_PRIORITY_OVERMAP_PHYSICS  90
#define FIRE_PRIORITY_PROJECTILES      90
#define FIRE_PRIORITY_THROWING         90
#define FIRE_PRIORITY_STATPANELS       100
#define FIRE_PRIORITY_OVERLAYS         100
#define FIRE_PRIORITY_SMOOTHING        100
#define FIRE_PRIORITY_CHAT             100
#define FIRE_PRIORITY_INPUT            100

//? Ticker Subsystems - Highest priority
// Any subsystem flagged with SS_TICKER is here!
// Do not unnecessarily set your subsystem as TICKER.
// Is your feature as important as movement, chat, or timers?
// Probably not! Go to normal bracket instead!

// DEFAULT PRIORITY IS HERE (50)
#define FIRE_PRIORITY_DPC          100
#define FIRE_PRIORITY_TIMER        100

//? Special

/// This is used as the default regardless of bucket. Check above.
#define FIRE_PRIORITY_DEFAULT      50

/**
 * Create a new timer and add it to the queue.
 * Arguments:
 * * callback the callback to call on timer finish
 * * wait deciseconds to run the timer for
 * * atom_flags atom_flags for this timer, see: code\__DEFINES\subsystems.dm
 */
#define addtimer(args...) _addtimer(args, file = __FILE__, line = __LINE__)
