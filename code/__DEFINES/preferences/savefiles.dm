//! Global version - stored directly on savefile
//* File gets wiped if version < MIN
//* We store this on savefile because you can handle global migrations
//* and advanced direct savefile migrations directly with this.
#define SAVEFILE_VERSION_MIN	8
#define SAVEFILE_VERSION_MAX	15

//! Character version - stored in character data list
//* Slot gets wiped if version < MIN
//* We store this on character list itself because we have
//* no reason to need it for global loading, and global migrations
//* should be low level anyways
#define CHARACTER_VERSION_MIN -1
#define CHARACTER_VERSION_MAX 2
/// what nulled version fields are considered; this basically makes them go through all migrations
#define CHARACTER_VERSION_LEGACY 0
