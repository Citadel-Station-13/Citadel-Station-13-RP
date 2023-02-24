//! has_suit_sensors
/// no suit sensors
#define UNIFORM_HAS_NO_SENSORS			0
/// has suit sensors
#define UNIFORM_HAS_SUIT_SENSORS		1
/// locked suit sensors
#define UNIFORM_HAS_LOCKED_SENSORS		2

//! sensor_mode
/// off
#define SUIT_SENSOR_OFF      0
/// dead/alive
#define SUIT_SENSOR_BINARY   1
/// damage types
#define SUIT_SENSOR_VITAL    2
/// location
#define SUIT_SENSOR_TRACKING 3

//! has rolldown/rollsleeve
/// don't allow rolling
#define UNIFORM_HAS_NO_ROLL 1
/// allow rolling
#define UNIFORM_HAS_ROLL 2
/// autodetect rolling dynamically - only works if we're on default icons!
#define UNIFORM_AUTODETECT_ROLL 3

//! rolldown/rollsleeve status
/// not supported
#define UNIFORM_ROLL_NULLED 1
/// not rolled
#define UNIFORM_ROLL_FALSE 2
/// rolled
#define UNIFORM_ROLL_TRUE 3
