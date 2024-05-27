/// CDN Webroot asset transport.
/datum/asset_transport/webroot
	name = "CDN Webroot asset transport"

/datum/asset_transport/webroot/send_anonymous_file(list/client/targets, file, ext)
	#warn impl

#warn below

/datum/asset_transport/webroot/Load()
	if (validate_config(log = FALSE))
		load_existing_assets()

/// Register a browser asset with the asset cache system
/// We also save it to the CDN webroot at this step instead of waiting for send_assets()
/// asset_name - the identifier of the asset
/// asset - the actual asset file or an asset_item datum.
/datum/asset_transport/webroot/register_asset(asset_name, asset)
	. = ..()
	var/datum/asset_item/ACI = .

	if (istype(ACI) && ACI.hash)
		save_asset_to_webroot(ACI)

/// Saves the asset to the webroot taking into account namespaces and hashes.
/datum/asset_transport/webroot/proc/save_asset_to_webroot(datum/asset_item/ACI)
	var/webroot = CONFIG_GET(string/asset_cdn_webroot)
	var/newpath = "[webroot][get_asset_suffex(ACI)]"
	if (fexists(newpath))
		return
	if (fexists("[newpath].gz")) //its a common pattern in webhosting to save gzip'ed versions of text files and let the webserver serve them up as gzip compressed normal files, sometimes without keeping the original version.
		return
	return fcopy(ACI.resource, newpath)

/// Returns a url for a given asset.
/// asset_name - Name of the asset.
/// asset_item - asset cache item datum for the asset, optional, overrides asset_name
/datum/asset_transport/webroot/get_asset_url(asset_name, datum/asset_item/asset_item)
	if (!istype(asset_item))
		asset_item = SSassets.cache[asset_name]
	var/url = CONFIG_GET(string/asset_cdn_url) //config loading will handle making sure this ends in a /
	return "[url][get_asset_suffex(asset_item)]"

/datum/asset_transport/webroot/proc/get_asset_suffex(datum/asset_item/asset_item)
	var/base = "[copytext(asset_item.hash, 1, 3)]/"
	var/filename = "asset.[asset_item.hash].[asset_item.ext]"
	if (length(asset_item.namespace))
		base = "namespaces/[copytext(asset_item.namespace, 1, 3)]/[asset_item.namespace]/"
		if (!asset_item.namespace_parent)
			filename = "[asset_item.name]"
	return base + filename


/// webroot asset sending - does nothing unless passed legacy assets
/datum/asset_transport/webroot/send_assets(client/client, list/asset_list)
	. = FALSE
	var/list/legacy_assets = list()
	if (!islist(asset_list))
		asset_list = list(asset_list)
	for (var/asset_name in asset_list)
		var/datum/asset_item/ACI = asset_list[asset_name]
		if (!istype(ACI))
			ACI = SSassets.cache[asset_name]
		if (!ACI)
			legacy_assets += asset_name //pass it on to base send_assets so it can output an error
			continue
		if (ACI.legacy)
			legacy_assets[asset_name] = ACI
	if (length(legacy_assets))
		. = ..(client, legacy_assets)


/// webroot slow asset sending - does nothing.
/datum/asset_transport/webroot/send_assets_slow(client/client, list/files, filerate)
	return FALSE

/datum/asset_transport/webroot/validate_config(log = TRUE)
	if (!CONFIG_GET(string/asset_cdn_url))
		if (log)
			log_asset("ERROR: [type]: Invalid Config: ASSET_CDN_URL")
		return FALSE
	if (!CONFIG_GET(string/asset_cdn_webroot))
		if (log)
			log_asset("ERROR: [type]: Invalid Config: ASSET_CDN_WEBROOT")
		return FALSE
	return TRUE
