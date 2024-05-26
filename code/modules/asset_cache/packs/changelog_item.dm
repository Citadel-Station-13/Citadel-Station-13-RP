
/datum/asset_pack/changelog_item
	abstract_type = /datum/asset_pack/changelog_item
	var/item_filename

/datum/asset_pack/changelog_item/New(date)
	item_filename = SANITIZE_FILENAME("[date].yml")

/datum/asset_pack/changelog_item/register()
	return list(
		item_filename = file("html/changelogs/archive/" + item_filename),
	)
