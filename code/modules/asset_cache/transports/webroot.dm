/// CDN Webroot asset transport.
/datum/asset_transport/webroot
	name = "CDN Webroot asset transport"

	var/webroot
	var/url

/datum/asset_transport/webroot/initialize()
	. = ..()
	webroot = CONFIG_GET(string/asset_cdn_webroot)
	url = CONFIG_GET(string/asset_cdn_url)

/datum/asset_transport/webroot/validate_config()
	if (!CONFIG_GET(string/asset_cdn_url))
		log_asset("ERROR: [type]: Invalid Config: ASSET_CDN_URL")
		return FALSE
	if (!CONFIG_GET(string/asset_cdn_webroot))
		log_asset("ERROR: [type]: Invalid Config: ASSET_CDN_WEBROOT")
		return FALSE
	return TRUE

/datum/asset_transport/webroot/send_items(client/target, list/datum/asset_item/items)
	return TRUE

/datum/asset_transport/webroot/send_anonymous_file(list/client/targets, file, ext)
	return save_anonymous_file_to_webroot(file, ext)

/datum/asset_transport/webroot/load_item(datum/asset_item/item)
	return save_asset_item_to_webroot(item)

/datum/asset_transport/webroot/proc/save_asset_item_to_webroot(datum/asset_item/item)
	return save_to_webroot(item.file, item.mangled_name, item.namespace_id, item.hash)

/datum/asset_transport/webroot/proc/save_anonymous_file_to_webroot(file, ext)
	var/md5_of_file = md5asfile(file)
	var/filename = "[md5_of_file].[ext]"
	return save_to_webroot(file, filename, null, md5_of_file)

/datum/asset_transport/webroot/proc/save_to_webroot(file, filename, namespace, hash)
	var/path
	if(namespace)
		path = "namespaces/[copytext(namespace, 1, 3)]/[namespace]/[filename]"
	else
		path = "[get_webroot_path(hash, filename)]"
	var/save_path = "[webroot]/[path]"
	if(!fexists(save_path) && !fexists("[save_path].gz")) // sometimes web servers auto-compress text files
		fcopy(file, "[save_path]")
	return "[url]/[path]"

/datum/asset_transport/webroot/proc/get_webroot_path(hash, filename)
	return "[copytext(hash, 1, 3)]/[filename]"

/datum/asset_transport/webroot/perform_native_preload(client/victim, list/datum/asset_pack/native_packs)
	return // preloading? what's that? sounds like something done by sane people who don't use IIS!
