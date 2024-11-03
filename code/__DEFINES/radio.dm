
#define MIN_FREE_FREQ 1201 // -------------------------------------------------
// Frequencies are always odd numbers and range from 1201 to 1599.

#define FREQ_UPLINK 1211	// Dummy loopback frequency, used for radio uplink. Not seen in game.
#define FREQ_SYNDICATE 1213 // Nuke op comms frequency, dark brown
#define FREQ_CTF_RED 1215 // CTF red team comms frequency, red
#define FREQ_CTF_BLUE 1217 // CTF blue team comms frequency, blue
#define FREQ_CTF_GREEN 1219 // CTF green team comms frequency, green
#define FREQ_CTF_YELLOW 1221 // CTF yellow team comms frequency, yellow
#define FREQ_CENTCOM 1337 // CentCom comms frequency, gray

#define FREQ_SUPPLY 1347 // Supply comms frequency, light brown
#define FREQ_SERVICE 1349 // Service comms frequency, green
#define FREQ_SCIENCE 1351 // Science comms frequency, plum
#define FREQ_COMMAND 1353 // Command comms frequency, gold
#define FREQ_MEDICAL 1355 // Medical comms frequency, soft blue
#define FREQ_ENGINEERING 1357 // Engineering comms frequency, orange
#define FREQ_SECURITY 1359 // Security comms frequency, red
#define FREQ_ENTERTAINMENT 1415 // Used by entertainment monitors, cyan

#define FREQ_HOLOGRID_SOLUTION 1433
#define FREQ_STATUS_DISPLAYS 1435

#define MIN_FREQ 1441 // ------------------------------------------------------
// Only the 1441 to 1489 range is freely available for general conversation.
// This represents 1/8th of the available spectrum.

#define FREQ_AI_PRIVATE 1447 // AI private comms frequency, magenta
#define FREQ_PRESSURE_PLATE 1447
#define FREQ_ELECTROPACK 1449
#define FREQ_MAGNETS 1449
#define FREQ_LOCATOR_IMPLANT 1451
#define FREQ_RADIO_NAV_BEACON 1455
#define FREQ_SIGNALER 1457 // the default for new signalers
#define FREQ_COMMON 1459 // Common comms frequency, dark green

#define MIN_UNUSED_FREQ 1461 // Prevents rolling AI Private or Common

#define MAX_FREQ 1489 // ------------------------------------------------------

#define MAX_FREE_FREQ 1599 // -------------------------------------------------
