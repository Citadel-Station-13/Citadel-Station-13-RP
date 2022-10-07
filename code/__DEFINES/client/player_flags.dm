//! player flags
/// exempt from any job timelock system
#define PLAYER_FLAG_JEXP_EXEMPT (1<<0)

DEFINE_BITFIELD(player_flags, list(
	FLAG(PLAYER_FLAG_JEXP_EXEMPT),
))
