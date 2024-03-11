//Please use mob or src (not usr) in these procs. This way they can be called in the same fashion as procs.
/client/verb/wiki(query as text)
	set name = "wiki"
	set desc = "Type what you want to know about.  This will open the wiki on your web browser."
	set category = "OOC"
	if(config_legacy.wikiurl)
		if(query)
			if(config_legacy.wikisearchurl)
				var/output = replacetext(config_legacy.wikisearchurl, "%s", url_encode(query))
				src << link(output)
			else
				to_chat(src, SPAN_WARNING("The wiki search URL is not set in the server configuration."))
		else
			src << link(config_legacy.wikiurl)
	else
		to_chat(src, SPAN_WARNING("The wiki URL is not set in the server configuration."))
		return

/client/verb/forum()
	set name = "forum"
	set desc = "Visit the forum."
	set hidden = 1
	if( config_legacy.forumurl )
		if(alert("This will open the forum in your browser. Are you sure?",,"Yes","No")=="No")
			return
		src << link(config_legacy.forumurl)
	else
		to_chat(src, SPAN_WARNING("The forum URL is not set in the server configuration."))
		return

/client/verb/rules()
	set name = "Rules"
	set desc = "Show Server Rules."
	set hidden = 1

	if(config_legacy.rulesurl)
		if(alert("This will open the rules in your browser. Are you sure?",,"Yes","No")=="No")
			return
		src << link(config_legacy.rulesurl)
	else
		to_chat(src, SPAN_DANGER("The rules URL is not set in the server configuration."))
	return

/client/verb/map()
	set name = "Map"
	set desc = "See the map."
	set hidden = 1

	if(config_legacy.mapurl)
		if(alert("This will open the map in your browser. Are you sure?",,"Yes","No")=="No")
			return
		src << link(config_legacy.mapurl)
	else
		to_chat(src, SPAN_DANGER("The map URL is not set in the server configuration."))
	return

/client/verb/github()
	set name = "GitHub"
	set desc = "Visit the GitHub"
	set hidden = 1

	if(CONFIG_GET(string/githuburl))
		if(alert("This will open the GitHub in your browser. Are you sure?",,"Yes","No")=="No")
			return
		src << link(CONFIG_GET(string/githuburl))
	else
		to_chat(src, SPAN_DANGER("The GitHub URL is not set in the server configuration."))
	return

/client/verb/reportissue()
	set name = "report-issue"
	set desc = "Report an issue"
	set hidden = TRUE
	var/githuburl = CONFIG_GET(string/githuburl)
	if(githuburl)
		var/message = "This will open the Github issue reporter in your browser. Are you sure?"
		if(GLOB.revdata.testmerge.len)
			message += "<br>The following experimental changes are active and are probably the cause of any new or sudden issues you may experience. If possible, please try to find a specific thread for your issue instead of posting to the general issue tracker:<br>"
			message += GLOB.revdata.GetTestMergeInfo(FALSE)
		// We still use tgalert here because some people were concerned that if someone wanted to report that tgui wasn't working
		// then the report issue button being tgui-based would be problematic.
		if(tgalert(src, message, "Report Issue","Yes","No")!="Yes")
			return

		// Keep a static version of the template to avoid reading file
		var/static/issue_template = file2text(".github/ISSUE_TEMPLATE/bug_report.md")

		// Get a local copy of the template for modification
		var/local_template = issue_template

		// Remove comment header
		var/content_start = findtext(local_template, "<")
		if(content_start)
			local_template = copytext(local_template, content_start)

		// Insert round
		if(GLOB.round_id)
			local_template = replacetext(local_template, "## Round ID:\n", "## Round ID:\n[GLOB.round_id]")

		// Insert testmerges
		if(GLOB.revdata.testmerge.len)
			var/list/all_tms = list()
			for(var/entry in GLOB.revdata.testmerge)
				var/datum/tgs_revision_information/test_merge/tm = entry
				all_tms += "- \[[tm.title]\]([githuburl]/pull/[tm.number])"
			var/all_tms_joined = all_tms.Join("\n") // for some reason this can't go in the []
			local_template = replacetext(local_template, "## Testmerges:\n", "## Testmerges:\n[all_tms_joined]")

		var/url_params = "Reporting client version: [byond_version].[byond_build]\n\n[local_template]"
		DIRECT_OUTPUT(src, link("[githuburl]/issues/new?body=[url_encode(url_params)]"))
	else
		to_chat(src, SPAN_DANGER("The Github URL is not set in the server configuration."))
	return

/client/proc/changelog_async()
	set waitfor = FALSE

	changelog()

/client/verb/changelog()
	set name = "Changelog"
	set category = "OOC"
	if(!GLOB.changelog_tgui)
		GLOB.changelog_tgui = new /datum/changelog()

	GLOB.changelog_tgui.ui_interact(usr)
	if(prefs.lastchangelog != GLOB.changelog_hash)
		prefs.lastchangelog = GLOB.changelog_hash
		prefs.save_preferences()
		winset(src, "infowindow.changelog", "font-style=;")

/client/verb/hotkeys_help()
	set name = "hotkeys-help"
	set category = "OOC"

	var/admin = {"<font color='purple'>
Admin:
\tF5 = Aghost (admin-ghost)
\tF6 = player-panel-new
\tF7 = admin-pm
\tF8 = Invisimin
</font>"}

	var/hotkey_mode = {"<font color='purple'>
Hotkey-Mode: (hotkey-mode must be on)
\tTAB = toggle hotkey-mode
\ta = left
\ts = down
\td = right
\tw = up
\tq = drop
\te = equip
\tr = throw
\tt = say
\t5 = emote
\tx = swap-hand
\tz = activate held object (or y)
\tj = toggle-aiming-mode
\tf = cycle-intents-left
\tg = cycle-intents-right
\t1 = help-intent
\t2 = disarm-intent
\t3 = grab-intent
\t4 = harm-intent
\tCtrl+Click = pull
\tShift+Click = examine
</font>"}

	var/other = {"<font color='purple'>
Any-Mode: (hotkey doesn't need to be on)
\tCtrl+a = left
\tCtrl+s = down
\tCtrl+d = right
\tCtrl+w = up
\tCtrl+q = drop
\tCtrl+e = equip
\tCtrl+r = throw
\tCtrl+x = swap-hand
\tCtrl+z = activate held object (or Ctrl+y)
\tCtrl+f = cycle-intents-left
\tCtrl+g = cycle-intents-right
\tCtrl+1 = help-intent
\tCtrl+2 = disarm-intent
\tCtrl+3 = grab-intent
\tCtrl+4 = harm-intent
\tF1 = adminhelp
\tF2 = ooc
\tF3 = say
\tF4 = emote
\tDEL = stop pulling
\tINS = cycle-intents-right
\tHOME = drop
\tPGUP = swap-hand
\tPGDN = activate held object
\tEND = throw
</font>"}

	var/robot_hotkey_mode = {"<font color='purple'>
Hotkey-Mode: (hotkey-mode must be on)
\tTAB = toggle hotkey-mode
\ta = left
\ts = down
\td = right
\tw = up
\tq = unequip active module
\tt = say
\tx = cycle active modules
\tz = activate held object (or y)
\tf = cycle-intents-left
\tg = cycle-intents-right
\t1 = activate module 1
\t2 = activate module 2
\t3 = activate module 3
\t4 = toggle intents
\t5 = emote
\tCtrl+Click = pull
\tShift+Click = examine
</font>"}

	var/robot_other = {"<font color='purple'>
Any-Mode: (hotkey doesn't need to be on)
\tCtrl+a = left
\tCtrl+s = down
\tCtrl+d = right
\tCtrl+w = up
\tCtrl+q = unequip active module
\tCtrl+x = cycle active modules
\tCtrl+z = activate held object (or Ctrl+y)
\tCtrl+f = cycle-intents-left
\tCtrl+g = cycle-intents-right
\tCtrl+1 = activate module 1
\tCtrl+2 = activate module 2
\tCtrl+3 = activate module 3
\tCtrl+4 = toggle intents
\tF1 = adminhelp
\tF2 = ooc
\tF3 = say
\tF4 = emote
\tDEL = stop pulling
\tINS = toggle intents
\tPGUP = cycle active modules
\tPGDN = activate held object
</font>"}

	if(isrobot(src.mob))
		to_chat(src, robot_hotkey_mode)
		to_chat(src, robot_other)
	else
		to_chat(src, hotkey_mode)
		to_chat(src, other)
	if(holder)
		to_chat(src, admin)

/client/verb/skin_toggle_hotkeys()
	set name = "Toggle Hotkeys"
	set category = "Preferences"
	set desc = "Toggle input control scheme"
	set hidden = TRUE

	prefs.hotkeys = !prefs.hotkeys
	set_macros()

