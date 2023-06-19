GLOBAL_LIST_INIT(blacklisted_builds, list(
	"1407" = "a bug preventing client display overrides from working leads to clients being able to see things/mobs they shouldn't be able to see",
	"1408" = "a bug preventing client display overrides from working leads to clients being able to see things/mobs they shouldn't be able to see",
	"1428" = "a bug causing right-click menus to show too many verbs that's been fixed in version 1429",
	))

/client/proc/security_checks()
	if(byond_version < 513)
		security_kick("BYOND 512 and prior clients are too outdated.", tell_user = TRUE)
		return FALSE
	if(!byond_build || byond_build < 1386)
		message_admins("[src] detected as BYOND version spoof. Kicking.")
		security_note("likely spoofed byond version")
		security_kick("likely spoofed byond version")
		return FALSE
	if(num2text(byond_build, 999) in GLOB.blacklisted_builds)
		security_kick("[byond_build] is blacklisted due to [blacklisted_builds[num2text(byond_build)]]. Please update your BYOND version.", tell_user = TRUE)
		return FALSE
	return TRUE
