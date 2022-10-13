//! flags for /copy_to_mob()
/// we're actually spawning roundstart
#define PREF_COPY_TO_ROUNDSTART (1<<0)
/// we're spawning latejoin
#define PREF_COPY_TO_LATEJOIN	(1<<1)
/// we're spawning ghostrole (or otherwise anything that isn't really a job)
#define PREF_COPY_TO_GHOSTROLE	(1<<2)
/// we're just doing it for some preview/visual reason
#define PREF_COPY_TO_RENDER		(1<<3)

/// helper
#define PREF_COPY_TO_IS_SPAWNING (flags & (PREF_COPY_TO_ROUNDSTART | PREF_COPY_TO_LATEJOIN | PREF_COPY_TO_GHOSTROLE))

