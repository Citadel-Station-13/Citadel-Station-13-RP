// automata stuff

// automata/automata_flags

// automata/wave/wave_spread
/// the dumbest spread - cardinals go their dir, diagonals go their dir and spread 45. do not use this unless you aren't using blocking of any kind, or it'll be ugly.
#define WAVE_SPREAD_MINIMAL					1
/// produces wave interference like spread - wave spreads out around 45 deg where it can, without being able to turn around. basically, colonial marines automata explosions.
#define WAVE_SPREAD_SHADOW_LIKE				2
/// produces full blastwave simulation - wave spreads out with up to 90 degree turns. does not support directionals because the simulation depends on non-repeating waves.
#define WAVE_SPREAD_SHOCKWAVE				3

// wave stuff
/// wave automata power accuracy for dropping a turf expansion when power's below this
#define WAVE_AUTOMATA_POWER_DEAD			1
