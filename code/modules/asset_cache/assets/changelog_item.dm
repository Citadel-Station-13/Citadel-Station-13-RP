
/datum/asset/changelog_item
	abstract_type = /datum/asset/changelog_item
	var/item_filename

/datum/asset/changelog_item/New(date)
	item_filename = SANITIZE_FILENAME("[date].yml")
	SSassets.transport.register_asset(item_filename, file("html/changelogs/archive/" + item_filename))

/datum/asset/changelog_item/send(client)
	if (!item_filename)
		return
	. = SSassets.transport.send_assets(client, item_filename)

/datum/asset/changelog_item/get_url_mappings()
	if (!item_filename)
		return
	. = list("[item_filename]" = SSassets.transport.get_asset_url(item_filename))
