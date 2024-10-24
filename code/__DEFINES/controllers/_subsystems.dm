/**
 *! Defines for subsystems and overlays
 *
 *? Lots of important stuff in here, make sure you have your brain switched on when editing this file!
 */

//! ## Initialization subsystem

/// New should not call Initialize.
#define INITIALIZATION_INSSATOMS     0
/// New should call Initialize(FALSE).
#define INITIALIZATION_INNEW_REGULAR 1
/// New should call Initialize(TRUE).
#define INITIALIZATION_INNEW_MAPLOAD 2

//! ### Initialization hints

/// Nothing happens
#define INITIALIZE_HINT_NORMAL 0

/**
 * call LateInitialize at the end of all atom Initalization.
 *
 * The item will be added to the late_loaders list, this is iterated over after
 * initalization of subsystems is complete and calls LateInitalize on the atom
 * see [this file for the LateIntialize proc](atom.html#proc/LateInitialize)
 */
#define INITIALIZE_HINT_LATELOAD 1

/// Call qdel on the atom after intialization.
#define INITIALIZE_HINT_QDEL 2

/// type and all subtypes should always immediately call Initialize in New().
#define INITIALIZE_IMMEDIATE(X) ##X/New(loc, ...){\
	..();\
	if(!(atom_flags & ATOM_INITIALIZED)) {\
		args[1] = TRUE;\
		SSatoms.InitAtom(src, args);\
	}\
}

//! ### SS runlevels

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
 *! Subsystem init_order, from highest priority to lowest priority.
 *? Subsystems shutdown in the reverse of the order they initialize in.
 *? The numbers just define the ordering, they are meaningless otherwise.
 */

// todo: tg init brackets

// core security system, used by client/New()
#define INIT_ORDER_FAIL2TOPIC      200
// core security system, used by client/New()
#define INIT_ORDER_IPINTEL         197

// core timing system, used by almost everything
#define INIT_ORDER_TIMER           195
// just about every feature on the server requires the database backend
// for storage and durability of permeance.
#define INIT_ORDER_DBCORE          190
// repository is just struct storage. its things depend on database,
// but should depend on nothing else.
//
// for the rare occasion when a prototype requires asset registration,
// it should be able to recognize if SSassets is ready,
// and only queue an udpate if its asset is already loaded.
#define INIT_ORDER_REPOSITORY      187
// early init initializes what is basically expensive global variables. it needs to go before assets.
#define INIT_ORDER_EARLY_INIT      185
// assets is loaded early because things hook into this to register *their* assets
#define INIT_ORDER_ASSETS          180

#define INIT_ORDER_STATPANELS      170
#define INIT_ORDER_PREFERENCES     165
#define INIT_ORDER_INPUT           160
#define INIT_ORDER_JOBS            150
#define INIT_ORDER_CHARACTERS      140
#define INIT_ORDER_SOUNDS          130
#define INIT_ORDER_GARBAGE         120
#define INIT_ORDER_VIS             90
#define INIT_ORDER_SERVER_MAINT    75
#define INIT_ORDER_INSTRUMENTS     70
#define INIT_ORDER_MEDIA_TRACKS    65
#define INIT_ORDER_CHEMISTRY       60
#define INIT_ORDER_MATERIALS       55
#define INIT_ORDER_PHOTOGRAPHY     50
#define INIT_ORDER_AI_SCHEDULING   48
#define INIT_ORDER_AI_MOVEMENT     48
#define INIT_ORDER_AI_HOLDERS      48
#define INIT_ORDER_MAPPING         45
#define INIT_ORDER_SPATIAL_GRIDS   43 // must be after SSmapping so we know world.maxx and world.maxy
#define INIT_ORDER_GAME_WORLD      40
#define INIT_ORDER_LEGACY_ATC      37
#define INIT_ORDER_LEGACY_LORE     35
#define INIT_ORDER_LOBBY           30
#define INIT_ORDER_PLANTS          25
#define INIT_ORDER_ALARMS          20
#define INIT_ORDER_RESEARCH        17
#define INIT_ORDER_ATOMS           15
#define INIT_ORDER_MACHINES        10
#define INIT_ORDER_SHUTTLES        3
#define INIT_ORDER_DEFAULT         0
#define INIT_ORDER_AIR            -1
#define INIT_ORDER_PLANETS        -2
#define INIT_ORDER_PERSISTENCE        -3
#define INIT_ORDER_AMBIENT_OCCLUSION  -5
#define INIT_ORDER_HOLOMAPS           -5
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
#define INIT_ORDER_CHAT           -100  //! Should be last to ensure chat remains smooth during init.


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
