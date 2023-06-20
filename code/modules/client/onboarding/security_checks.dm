GLOBAL_LIST_INIT(blacklisted_builds, list(
	"1407" = "a bug preventing client display overrides from working leads to clients being able to see things/mobs they shouldn't be able to see",
	"1408" = "a bug preventing client display overrides from working leads to clients being able to see things/mobs they shouldn't be able to see",
	"1428" = "a bug causing right-click menus to show too many verbs that's been fixed in version 1429",
	))

/client/proc/security_checks()
	if(byond_version < 513)
		security_kick("BYOND 512 and prior clients are too outdated.", tell_user = TRUE)
		return TRUE
	if(!byond_build || byond_build < 1386)
		message_admins("[src] detected as BYOND version spoof. Kicking.")
		security_note("likely spoofed byond version")
		security_kick("likely spoofed byond version")
		return TRUE
	if(num2text(byond_build, 999) in GLOB.blacklisted_builds)
		security_kick("[byond_build] is blacklisted due to [GLOB.blacklisted_builds[num2text(byond_build)]]. Please update your BYOND version.", tell_user = TRUE)
		return TRUE
	var/cev = CONFIG_GET(number/client_error_version)
	var/ceb = CONFIG_GET(number/client_error_build)
	var/cwv = CONFIG_GET(number/client_warn_version)
	if (byond_version < cev || (byond_version == cev && byond_build < ceb))		//Out of date client.
		to_chat(src, "<span class='danger'><b>Your version of BYOND is too old:</b></span>")
		to_chat(src, CONFIG_GET(string/client_error_message))
		to_chat(src, "Your version: [byond_version].[byond_build]")
		to_chat(src, "Required version: [cev].[ceb] or later")
		to_chat(src, "Visit <a href=\"https://secure.byond.com/download\">BYOND's website</a> to get the latest version of BYOND.")
		if (is_staff())
			to_chat(src, "Because you are an admin, you are being allowed to walk past this limitation, But it is still STRONGLY suggested you upgrade")
		else
			disconnection_message("Your BYOND version ([byond_version].[byond_build]) is too old. Visit <a href=\"https://secure.byond.com/download\">BYOND's website</a> to get the latest version of BYOND.")
			return 0
	else if (byond_version < cwv)	//We have words for this client.
		if(CONFIG_GET(flag/client_warn_popup))
			var/msg = "<b>Your version of byond may be getting out of date:</b><br>"
			msg += CONFIG_GET(string/client_warn_message) + "<br><br>"
			msg += "Your version: [byond_version]<br>"
			msg += "Required version to remove this message: [cwv] or later<br>"
			msg += "Visit <a href=\"https://secure.byond.com/download\">BYOND's website</a> to get the latest version of BYOND.<br>"
			src << browse(msg, "window=warning_popup")
		else
			to_chat(src, "<span class='danger'><b>Your version of byond may be getting out of date:</b></span>")
			to_chat(src, CONFIG_GET(string/client_warn_message))
			to_chat(src, "Your version: [byond_version]")
			to_chat(src, "Required version to remove this message: [cwv] or later")
			to_chat(src, "Visit <a href=\"https://secure.byond.com/download\">BYOND's website</a> to get the latest version of BYOND.")
	return TRUE
