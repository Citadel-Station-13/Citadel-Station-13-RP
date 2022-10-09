//! ### WHITELIST ### !//
//? Whitelist Configs for the "Whitelist" module



//! ## Guest Toggles

/// Prevent "Guest-" accounts from Captain, HoS, HoP, CE, RD, CMO, Warden, Security, Detective, and AI positions.
/datum/config_entry/flag/guest_jobban
	default = TRUE

/// Stop people connecting to your server without a registered ckey. (i.e. guest-* are all blocked from connecting)
/datum/config_entry/flag/guest_ban
	default = TRUE



//! ## Whitelist Toggles

/// Use the whitelist system.
/datum/config_entry/flag/use_whitelist
	default = TRUE

/// Set to jobban everyone who's key is not listed in data/whitelist.txt from Captain, HoS, HoP, CE, RD, CMO, Warden, Security, Detective, and AI positions.
/datum/config_entry/flag/use_job_whitelist
	default = FALSE

/// Restrict non-admins from using humanoid alien races.
/datum/config_entry/flag/use_species_whitelist
	default = TRUE
