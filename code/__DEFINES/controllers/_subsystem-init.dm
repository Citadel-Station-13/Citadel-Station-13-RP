//*                                  Initialization Stages                                           *//
//* After each stage, the MC starts ticking that stage while later stages are still waiting to init. *//
//*      MC init stages must be a positive number, and init stages must all be consequetive!         *//

/// Early initializations required for server function; database, timers, tgui, etc
#define INIT_STAGE_BACKEND 1
/// Pre-mapload initializations
#define INIT_STAGE_EARLY 2
/// Mapload
#define INIT_STAGE_WORLD 3
/// Late
#define INIT_STAGE_LATE 4

/// Last init stage we need to do.
///
/// * This must be set to the maximum INIT_STAGE.
#define INIT_STAGE_MAX 4

//*                                  Initialization Orders                                           *//

/**
 *! Subsystem init_order, from highest priority to lowest priority.
 *? Subsystems shutdown in the reverse of the order they initialize in.
 *? Subsystems should always have init_order defined, even if they don't initialize, if they use init.
 *? The numbers just define the ordering, they are meaningless otherwise.
 */

//* Backend *//

#define INIT_ORDER_FAIL2TOPIC      100
#define INIT_ORDER_DBCORE          50
#define INIT_ORDER_REPOSITORY      25
#define INIT_ORDER_TIMER           10
#define INIT_ORDER_STATPANELS      0

//* Early *//

#define INIT_ORDER_EARLY_INIT      200
#define INIT_ORDER_INPUT           170
#define INIT_ORDER_PREFERENCES     150
#define INIT_ORDER_JOBS            125
#define INIT_ORDER_ASSETS          100
#define INIT_ORDER_INSTRUMENTS     50
#define INIT_ORDER_AI_SCHEDULING   25
#define INIT_ORDER_AI_MOVEMENT     25
#define INIT_ORDER_AI_HOLDERS      25

//* World *//

#define INIT_ORDER_CHARACTERS      140
#define INIT_ORDER_SOUNDS          130
#define INIT_ORDER_GARBAGE         120
#define INIT_ORDER_VIS             90
#define INIT_ORDER_SERVER_MAINT    75
#define INIT_ORDER_MEDIA_TRACKS    65
#define INIT_ORDER_CHEMISTRY       60
#define INIT_ORDER_MATERIALS       55
#define INIT_ORDER_PHOTOGRAPHY     50
#define INIT_ORDER_MAPPING         45
#define INIT_ORDER_SPATIAL_GRIDS   43 //! must be after SSmapping so we know world.maxx and world.maxy
#define INIT_ORDER_GAME_WORLD      40
#define INIT_ORDER_LEGACY_ATC      37
#define INIT_ORDER_LEGACY_LORE     35
#define INIT_ORDER_PLANTS          25
#define INIT_ORDER_ALARMS          20
#define INIT_ORDER_RESEARCH        17
#define INIT_ORDER_OVERMAPS        16
#define INIT_ORDER_ATOMS           15
#define INIT_ORDER_MACHINES        10
#define INIT_ORDER_SHUTTLES        3
#define INIT_ORDER_DEFAULT         0
#define INIT_ORDER_AIR            -1
#define INIT_ORDER_PLANETS        -2
#define INIT_ORDER_PERSISTENCE        -3
#define INIT_ORDER_AMBIENT_OCCLUSION  -5
#define INIT_ORDER_HOLOMAPS           -5
#define INIT_ORDER_ICON_SMOOTHING -6
#define INIT_ORDER_EVENTS         -10
#define INIT_ORDER_TICKER         -30
#define INIT_ORDER_LIGHTING       -40
#define INIT_ORDER_ZMIMIC         -45
#define INIT_ORDER_AMBIENT_LIGHT  -46
#define INIT_ORDER_XENOARCH       -50
#define INIT_ORDER_CIRCUIT        -60
#define INIT_ORDER_AI             -70

//* Late *//

#define INIT_ORDER_OVERLAY               200
#define INIT_ORDER_TITLESCREEN           150
#define INIT_ORDER_CHAT                 -100  //! Should be last to ensure chat remains smooth during init.
