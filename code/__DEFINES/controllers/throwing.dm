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
/// do not scale hit damage to standard speed at all
#define THROW_AT_NO_SCALE_DAMAGE			(1<<8)
/// force throw, ignoring resistances
#define THROW_AT_FORCE						(1<<9)
/// don't do stuff like damage target zones/detecting user momentums
#define THROW_AT_NO_USER_MODIFIERS			(1<<10)

DEFINE_BITFIELD(throw_flags, list(
	BITFIELD(THROW_AT_DO_NOT_SPIN),
	BITFIELD(THROW_AT_DIAGONALS_FIRST),
	BITFIELD(THROW_AT_IS_NEAT),
	BITFIELD(THROW_AT_IS_GENTLE),
	BITFIELD(THROW_AT_NO_AUTO_QUICKSTART),
	BITFIELD(THROW_AT_NEVER_HIT_PUSH),
	BITFIELD(THROW_AT_ALWAYS_HIT_PUSH),
	BITFIELD(THROW_AT_QUICKSTARTED),
	BITFIELD(THROW_AT_NO_SCALE_DAMAGE),
	BITFIELD(THROW_AT_FORCE),
	BITFIELD(THROW_AT_NO_USER_MODIFIERS),
))

// todo: rework
/// the throwing speed at which people can catch things on impact
#define THROW_SPEED_CATCHABLE			5
/// The minumum speed of a w_class 2 thrown object that will cause living mobs it hits to be knocked back. Heavier objects can cause knockback at lower speeds.
#define THROWNOBJ_KNOCKBACK_SPEED   15
/// Affects how much speed the mob is knocked back with.
#define THROWNOBJ_KNOCKBACK_DIVISOR 2
