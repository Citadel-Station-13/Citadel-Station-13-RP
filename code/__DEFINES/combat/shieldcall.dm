//? keys for list/additional in atom_shieldcall

// None yet

//? shieldcall "struct" - this *must* match up with /atom/proc/run/check_shieldcall!

/// damage amount
#define SHIELDCALL_ARG_DAMAGE 1
/// damage type
#define SHIELDCALL_ARG_DAMTYPE 2
/// damage tier
#define SHIELDCALL_ARG_TIER 3
/// armor flag
#define SHIELDCALL_ARG_FLAG 4
/// damage mode
#define SHIELDCALL_ARG_MODE 5
/// attack type
#define SHIELDCALL_ARG_TYPE 6
/// attacking weapon datum - same as used in armor
#define SHIELDCALL_ARG_WEAPON 7
/// list for additional data
#define SHIELDCALL_ARG_ADDITIONAL 8
/// flags returned
#define SHIELDCALL_ARG_RETVAL 9

//? shieldcall additional data keys

// none yet

//? shieldcall return flags

/// abort further shieldcalls - hit is totally blocked or mitigated
#define SHIELDCALL_FULLY_MITIGATED (1<<0)
/// hit was partially blocked or mitigated
#define SHIELDCALL_PARTIALLY_MITIGATED (1<<1)
/// attack was forcefully missed e.g. by reactive teleport armor
#define SHIELDCALL_FORCED_MISS (1<<2)
/// fake; this is a check
#define SHIELDCALL_JUST_CHECKING (1<<3)
/// terminate further shieldcalls
#define SHIELDCALL_CEASE (1<<4)
