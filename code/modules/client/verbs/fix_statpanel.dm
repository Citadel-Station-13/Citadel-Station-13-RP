/client/verb/fix_stat_panel()
	set name = "Fix Stat Panel"
	set category = VERB_CATEGORY_OOC

	if(!istype(statpanel))
		statpanel = new(src, SKIN_BROWSER_ID_STAT)
	statpanel.initialize()
