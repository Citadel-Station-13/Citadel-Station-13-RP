/client/proc/age_verification()
	return TRUE

/client/proc/is_age_verified()
	return !CONFIG_GET(flag/age_verification) || (player.player_flags & PLAYER_FLAG_AGE_VERIFIED)
