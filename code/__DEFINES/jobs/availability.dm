//! bitfield! technically usable for ghostroles/anything else too
/// role is available
#define ROLE_AVAILABLE (NONE)
/// slots filled right now
#define ROLE_UNAVAILABLE_SLOTS_FULL (1<<0)
/// player is banned
#define ROLE_UNAVAILABLE_BANNED (1<<1)
/// player doesn't have enough hours in relevant departments/jobs/roles
#define ROLE_UNAVAILABLE_ROLE_TIME (1<<2)
/// player is too new in days since first connect
#define ROLE_UNAVAILABLE_CONNECT_TIME (1<<3)
/// player needs more paid time off (PTO) hours
#define ROLE_UNAVAILABLE_PTO (1<<4)
/// player isn't whitelisted
#define ROLE_UNAVAILABLE_WHITELIST (1<<5)
/// character issue; age, faction, etc
#define ROLE_UNAVAILABLE_CHAR_AGE (1<<6)
/// character is of wrong faction
#define ROLE_UNAVAILABLE_CHAR_FACTION (1<<7)
/// character is of wrong species
#define ROLE_UNAVAILABLE_CHAR_SPECIES (1<<8)

//? fields irrelevant to preferences
#define ROLE_UNAVAILABILITY_EPHEMERAL (ROLE_UNAVAILABLE_SLOTS_FULL | ROLE_UNAVAILABLE_PTO)
