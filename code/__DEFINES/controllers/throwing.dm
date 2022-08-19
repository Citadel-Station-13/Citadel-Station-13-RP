//! thrownthing/throw_flags
/// don't spin animation
#define THROW_AT_DO_NOT_SPIN				(1<<0)
/// do diagonals first
#define THROW_AT_DIAGONALS_FIRST			(1<<1)
/// do not randomize pixel offsets/whatnot on land
#define THROW_AT_IS_NEAT					(1<<2)
/// do not do impact damage (receiving object must implement this)
#define THROW_AT_IS_GENTLE					(1<<3)
/// do not immediately tick the first tick. Use this if you need to manually modify the thrownthing datum or just want it to lag a tick.
#define THROW_AT_NO_AUTO_QUICKSTART			(1<<4)
/// forcefully do not push the impacted atom, ignoring regular checks. Overrides always hit push.
#define THROW_AT_NEVER_HIT_PUSH				(1<<5)
/// forcefully always push the impacted atom, ignoring regular checks.
#define THROW_AT_ALWAYS_HIT_PUSH			(1<<6)

/// we already quickstarted
#define THROW_AT_QUICKSTARTED				(1<<7)

DEFINE_BITFIELD(throw_flags, list(
	BITFIELD(THROW_AT_DO_NOT_SPIN),
	BITFIELD(THROW_AT_DIAGONALS_FIRST),
	BITFIELD(THROW_AT_IS_NEAT),
	BITFIELD(THROW_AT_IS_GENTLE),
	BITFIELD(THROW_AT_NO_AUTO_QUICKSTART),
	BITFIELD(THROW_AT_NEVER_HIT_PUSH),
	BITFIELD(THROW_AT_ALWAYS_HIT_PUSH),
	BITFIELD(THROW_AT_DO_NOT_QUICKSTART),
))
