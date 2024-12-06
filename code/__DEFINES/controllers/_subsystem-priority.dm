
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
