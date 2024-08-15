/datum/changelog
	var/static/list/changelog_items = list()

/datum/changelog/ui_state()
	return GLOB.always_state

/datum/changelog/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "Changelog")
		ui.open()

/datum/changelog/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return
	if(action == "get_month")
		var/datum/asset_pack/registered = SSassets.asset_packs_by_id[params["date"]]
		if(registered && istype(registered))
			ui.send_asset(registered)
			return TRUE
		var/datum/asset_pack/changelog_item/changelog_item = changelog_items[params["date"]]
		if (!changelog_item)
			changelog_item = new /datum/asset_pack/changelog_item(params["date"])
			changelog_items[params["date"]] = changelog_item
		changelog_item.id = params["date"]
		SSassets.register_asset_pack(changelog_item)
		ui.send_asset(changelog_item)
		return TRUE

/datum/changelog/ui_static_data(mob/user, datum/tgui/ui)
	var/list/data = list( "dates" = list() )
	var/regex/ymlRegex = regex(@"\.yml", "g")

	for(var/archive_file in flist("[global.config.directory]/../html/changelogs/archive/"))
		var/archive_date = ymlRegex.Replace(archive_file, "")
		data["dates"] = list(archive_date) + data["dates"]

	return data
