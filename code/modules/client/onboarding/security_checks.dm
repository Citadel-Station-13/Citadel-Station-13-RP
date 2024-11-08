GLOBAL_LIST_INIT(blacklisted_builds, list(
	"1407" = "a bug preventing client display overrides from working leads to clients being able to see things/mobs they shouldn't be able to see",
	"1408" = "a bug preventing client display overrides from working leads to clients being able to see things/mobs they shouldn't be able to see",
	"1428" = "a bug causing right-click menus to show too many verbs that's been fixed in version 1429",
	"1622" = "Bug breaking rendering can lead to wallhacks.",
	))

/client/proc/security_checks()
	// set waitfor = FALSE
	// lock up login
	security_checks_impl()

/client/proc/security_checks_impl()
	// supplimentary checks for 512 n up. version check is down there
	if(byond_version >= 512)
		if (!byond_build || byond_build < 1386)
			message_admins(SPAN_ADMINNOTICE("[key_name(src)] has been detected as spoofing their byond version. Connection rejected."))
			add_system_note("Spoofed-Byond-Version", "Detected as using a spoofed byond version.")
			log_suspicious_login("Failed Login: [key] - Spoofed byond version")
			qdel(src)
			return FALSE
		if (num2text(byond_build) in GLOB.blacklisted_builds)
			to_chat_immediate(src, SPAN_USERDANGER("Your version of byond is blacklisted."))
			to_chat_immediate(src, SPAN_DANGER("Byond build [byond_build] ([byond_version].[byond_build]) has been blacklisted for the following reason: [GLOB.blacklisted_builds[num2text(byond_build)]]."))
			to_chat_immediate(src, SPAN_DANGER("Please download a new version of byond. If [byond_build] is the latest, you can go to <a href=\"https://secure.byond.com/download/build\">BYOND's website</a> to download other versions."))
			if(is_staff())
				to_chat_immediate(src, "As an admin, you are being allowed to continue using this version, but please consider changing byond versions")
			else
				qdel(src)
				return FALSE

	var/breaking_version = CONFIG_GET(number/client_error_version)
	var/breaking_build = CONFIG_GET(number/client_error_build)
	var/warn_version = CONFIG_GET(number/client_warn_version)
	var/warn_build = CONFIG_GET(number/client_warn_build)

	if (byond_version < breaking_version || (byond_version == breaking_version && byond_build < breaking_build)) //Out of date client.
		to_chat_immediate(src, SPAN_DANGER("<b>Your version of BYOND is too old:</b>"))
		to_chat_immediate(src, CONFIG_GET(string/client_error_message))
		to_chat_immediate(src, "Your version: [byond_version].[byond_build]")
		to_chat_immediate(src, "Required version: [breaking_version].[breaking_build] or later")
		to_chat_immediate(src, "Visit <a href=\"https://secure.byond.com/download\">BYOND's website</a> to get the latest version of BYOND.")
		if (is_staff())
			to_chat_immediate(src, "Because you are an admin, you are being allowed to walk past this limitation, But it is still STRONGLY suggested you upgrade")
		else
			qdel(src)
			return FALSE
	else if (byond_version < warn_version || (byond_version == warn_version && byond_build < warn_build)) //We have words for this client.
		if(CONFIG_GET(flag/client_warn_popup))
			var/msg = "<b>Your version of byond may be getting out of date:</b><br>"
			msg += CONFIG_GET(string/client_warn_message) + "<br><br>"
			msg += "Your version: [byond_version].[byond_build]<br>"
			msg += "Required version to remove this message: [warn_version].[warn_build] or later<br>"
			msg += "Visit <a href=\"https://secure.byond.com/download\">BYOND's website</a> to get the latest version of BYOND.<br>"
			src << browse(msg, "window=warning_popup")
		else
			to_chat(src, SPAN_DANGER("<b>Your version of byond may be getting out of date:</b>"))
			to_chat(src, CONFIG_GET(string/client_warn_message))
			to_chat(src, "Your version: [byond_version].[byond_build]")
			to_chat(src, "Required version to remove this message: [warn_version].[warn_build] or later")
			to_chat(src, "Visit <a href=\"https://secure.byond.com/download\">BYOND's website</a> to get the latest version of BYOND.")
	return TRUE
