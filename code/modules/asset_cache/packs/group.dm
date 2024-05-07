
// For registering or sending multiple others at once
/datum/asset_pack/group
	abstract_type = /datum/asset_pack/group
	var/list/children

/datum/asset_pack/group/register()
	for(var/type in children)
		load_asset_datum(type)

/datum/asset_pack/group/send(client/C)
	for(var/type in children)
		var/datum/asset_pack/A = get_asset_datum(type)
		. = A.send(C) || .

/datum/asset_pack/group/get_url_mappings()
	. = list()
	for(var/type in children)
		var/datum/asset_pack/A = get_asset_datum(type)
		. += A.get_url_mappings()
