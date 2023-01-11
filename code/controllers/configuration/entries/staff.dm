
/// Allows admins with relevant permissions to have their own ooc color.
/datum/config_entry/flag/allow_admin_ooccolor
	default = TRUE

/datum/config_entry/flag/debug_admin_hrefs


// # Mentors

/// Defines whether the server uses the legacy mentor system with mentors.txt or the SQL system.
/datum/config_entry/flag/mentor_legacy_system
	protection = CONFIG_ENTRY_LOCKED

/// Defines whether Mentors only see ckeys by default or to have them only see mob name.
/datum/config_entry/flag/mentors_mobname_only
