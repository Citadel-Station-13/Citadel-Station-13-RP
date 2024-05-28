/**
 * Basic asset transport, via browse_rsc()
 */
/datum/asset_transport/browse_rsc
	name = "asset-transport: browse_rsc()"

/datum/asset_transport/browse_rsc/validate_config()
	return TRUE

/datum/asset_transport/browse_rsc/send_anonymous_file(list/client/targets, file)
	return send_anonymous_file_native(targets, file)

/datum/asset_transport/browse_rsc/load_item(datum/asset_item/item)
	return load_item_native(item)

/datum/asset_transport/browse_rsc/send_items(client/target, list/datum/asset_item/items)
	return send_items_native(target, items)
