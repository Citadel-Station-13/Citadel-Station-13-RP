
/// If you don't need anything complicated.
/datum/asset_pack/simple
	abstract_type = /datum/asset_pack/simple
	/**
	 * List of assets for this datum in the form of:
	 * * asset_filename = asset_file.
	 * At runtime the asset_file will be converted into a asset_cache datum.
	 */
	var/assets = list()
	/**
	 * Set to true to have this asset also be sent via the legacy browse_rsc
	 * system when cdn transports are enabled?
	 */
	var/legacy = FALSE
	/// TRUE for keeping local asset names when browse_rsc backend is used
	var/keep_local_name = FALSE

/datum/asset_pack/simple/register()
	for(var/asset_name in assets)
		var/datum/asset_cache_item/ACI = SSassets.transport.register_asset(asset_name, assets[asset_name])
		if (!ACI)
			log_asset("ERROR: Invalid asset: [type]:[asset_name]:[ACI]")
			continue
		if (legacy)
			ACI.legacy = legacy
		if (keep_local_name)
			ACI.keep_local_name = keep_local_name
		assets[asset_name] = ACI

/datum/asset_pack/simple/send(client)
	. = SSassets.transport.send_assets(client, assets)

/datum/asset_pack/simple/get_url_mappings()
	. = list()
	for (var/asset_name in assets)
		.[asset_name] = SSassets.transport.get_asset_url(asset_name, assets[asset_name])
