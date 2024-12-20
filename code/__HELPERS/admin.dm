
/proc/is_admin(mob/user)
	return check_rights(R_ADMIN, 0, user) != 0

/// Sends a message in the event that someone attempts to elevate their permissions through invoking a certain proc.
/proc/alert_to_permissions_elevation_attempt(mob/user)
	var/message = " has tried to elevate permissions!"
	message_admins(key_name_admin(user) + message)
	log_admin(key_name(user) + message)
