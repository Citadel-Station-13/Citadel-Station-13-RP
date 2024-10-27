/client/verb/fix_stat_panel()
	set name = "Fix Stat Panel"
	set category = VERB_CATEGORY_OOC

	if(!istype(tgui_stat))
		tgui_stat = new(src, SKIN_BROWSER_ID_STAT)
	tgui_stat.initialize()
