
/datum/asset_pack/changelog_item
	abstract_type = /datum/asset_pack/changelog_item
	var/item_name
	var/item_filename

/datum/asset_pack/changelog_item/New(id)
	..()
	item_name = "[id].yml"
	item_filename = SANITIZE_FILENAME("[id].yml")

/datum/asset_pack/changelog_item/register(generation)
	return list(
		(item_name) = file("html/changelogs/archive/" + item_filename),
	)
