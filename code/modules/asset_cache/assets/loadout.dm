/datum/asset_pack/spritesheet/loadout
	name = "loadout"

/datum/asset_pack/spritesheet/loadout/generate()
	for(var/name in gear_datums)
		var/datum/loadout_entry/entry = gear_datums[name]
		var/item_id = entry.legacy_get_id()
		if(!item_id)
			continue
		var/item_path = entry.path
		if(!ispath(item_path, /obj/item))
			continue
		var/obj/item/item_casted = item_path
		var/item_icon = initial(item_casted.icon)
		var/item_icon_state = initial(item_casted.icon_state)
		insert(item_id, item_icon, item_icon_state)
