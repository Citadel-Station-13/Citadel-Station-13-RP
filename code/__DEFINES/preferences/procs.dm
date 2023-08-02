//! flags for /copy_to_mob()
/// we're actually spawning roundstart
#define PREF_COPY_TO_FOR_ROUNDSTART (1<<0)
/// we're spawning latejoin
#define PREF_COPY_TO_FOR_LATEJOIN (1<<1)
/// we're spawning ghostrole (or otherwise anything that isn't really a job)
#define PREF_COPY_TO_FOR_GHOSTROLE (1<<2)
/// we're just doing it for some preview/visual reason
#define PREF_COPY_TO_FOR_RENDER (1<<3)
/// ignore species checks; you should check the species yourself!
#define PREF_COPY_TO_NO_CHECK_SPECIES (1<<4)
/// ignore loadout role checks
#define PREF_COPY_TO_LOADOUT_IGNORE_ROLE (1<<5)
/// ignore all other loadout checks but whitelists
#define PREF_COPY_TO_LOADOUT_IGNORE_CHECKS (1<<6)
/// ignore loadout whitelist checks
#define PREF_COPY_TO_LOADOUT_IGNORE_WHITELIST (1<<7)
/// avoid making messages like "equipping x to you in loadout"
#define PREF_COPY_TO_SILENT (1<<8)

/// DO NOT update icons
#define PREF_COPY_TO_DO_NOT_RENDER (1<<23)

/// ignore most loadout restrictions, and spawn loadout. do not use in spawn procs, SSjob/SSticker will do it instead!
#define PREF_COPY_TO_UNRESTRICTED_LOADOUT (PREF_COPY_TO_LOADOUT_IGNORE_ROLE | PREF_COPY_TO_LOADOUT_IGNORE_CHECKS | PREF_COPY_TO_LOADOUT_IGNORE_WHITELIST)

/// helper
#define PREF_COPYING_TO_CHECK_IS_SPAWNING(flags) (flags & (PREF_COPY_TO_FOR_ROUNDSTART | PREF_COPY_TO_FOR_LATEJOIN | PREF_COPY_TO_FOR_GHOSTROLE))

