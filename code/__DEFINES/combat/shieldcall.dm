//? keys for list/additional in atom_shieldcall

// None yet

//? shieldcall "struct" - this *must* match up with /atom/proc/run/check_shieldcall!

/// damage amount
#define SHIELDCALL_ARG_DAMAGE 1
/// damage tier
#define SHIELDCALL_ARG_TIER 2
/// armor flag
#define SHIELDCALL_ARG_FLAG 3
/// damage mode
#define SHIELDCALL_ARG_MODE 4
/// attack type
#define SHIELDCALL_ARG_TYPE 5
/// attacking weapon datum - same as used in armor
#define SHIELDCALL_ARG_WEAPON 6
/// list for additional data
#define SHIELDCALL_ARG_ADDITIONAL 7
/// flags returned
#define SHIELDCALL_ARG_RETVAL 8

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
