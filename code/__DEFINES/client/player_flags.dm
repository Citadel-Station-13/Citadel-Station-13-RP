//! player flags
/// exempt from any job timelock system: this includes the VPN bunker!
#define PLAYER_FLAG_JEXP_EXEMPT (1<<0)
/// age verified
#define PLAYER_FLAG_AGE_VERIFIED (1<<1)

DEFINE_BITFIELD(player_flags, list(
	BITFIELD(PLAYER_FLAG_JEXP_EXEMPT),
	BITFIELD(PLAYER_FLAG_AGE_VERIFIED),
))
