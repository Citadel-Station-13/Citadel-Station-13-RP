
/datum/asset_pack/changelog_item
	abstract_type = /datum/asset_pack/changelog_item
	var/item_name
	var/item_filename

/datum/asset_pack/changelog_item/New(date)
	item_name = "[date].yml"
	item_filename = SANITIZE_FILENAME("[date].yml")

/datum/asset_pack/changelog_item/register()
	return list(
		(item_name) = file("html/changelogs/archive/" + item_filename),
	)
