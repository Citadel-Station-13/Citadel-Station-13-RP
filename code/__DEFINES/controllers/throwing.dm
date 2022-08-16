//! thrownthing/throw_flags
/// don't spin animation
#define THROW_AT_DO_NOT_SPIN				(1<<0)
/// do diagonals first
#define THROW_AT_DIAGONALS_FIRST			(1<<1)
/// do not randomize pixel offsets/whatnot on land
#define THROW_AT_IS_NEAT					(1<<2)
/// do not do impact damage (receiving object must implement this)
#define THROW_AT_IS_GENTLE					(1<<3)
/// do not immediately tick the first tick
#define THROW_AT_DO_NOT_QUICKSTART			(1<<4)
