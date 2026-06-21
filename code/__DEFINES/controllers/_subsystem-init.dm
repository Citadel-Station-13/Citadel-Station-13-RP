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

/// The timer key used to know how long subsystem initialization takes
#define SS_INIT_TIMER_KEY "ss_init"
