/datum/asset_pack/simple/tgui
	// debug server requires unmangled names to target
	do_not_mangle = TRUE
	// do not separate for debugging purposes
	do_not_separate = TRUE
	assets = list(
		"tgui.bundle.js" = file("tgui/public/tgui.bundle.js"),
		"tgui.bundle.css" = file("tgui/public/tgui.bundle.css"),
	)

/datum/asset_pack/simple/tgui_panel
	// debug server requires unmangled names to target
	do_not_mangle = TRUE
	// do not separate for debugging purposes
	do_not_separate = TRUE
	assets = list(
		"tgui-panel.bundle.js" = file("tgui/public/tgui-panel.bundle.js"),
		"tgui-panel.bundle.css" = file("tgui/public/tgui-panel.bundle.css"),
	)
