#define PARALLAX_DELAY_DEFAULT world.tick_lag
#define PARALLAX_DELAY_MED     1
#define PARALLAX_DELAY_LOW     2

// unneeded, it's offset by us not doing something utterly fucking inane, like, say, have hud images always shown and hidden by planes
// seriously, words can't describe how much i loathe whoever made me rewrite the entire goddamn codebase to take this stupidity out.

// WARNING - client.prefs uses this, if you change these make sure to update the code in preferences!
// (client.prefs doesn't use it on citrp, we don't have prefs for it here)
#define PARALLAX_DISABLE 0
#define PARALLAX_LOW     1
#define PARALLAX_MED     2
#define PARALLAX_HIGH    3
/// default
#define PARALLAX_INSANE  4
