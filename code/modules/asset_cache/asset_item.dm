VV_PROTECT_READONLY(/datum/asset_item)
/**
 * A datum used to store data on an asset in the asset cache.
 *
 * The asset cache system, at its core, is just a way to get files from the server to the
 * client in a reproducible and efficient manner.
 *
 * Each asset item is an item in the cache.
 */
/datum/asset_item
	/// filename
	var/name
	/// our hash
	var/hash
	/// the actual file handle
	///
	/// * this should always be something in data/, as this needs to be available during the whole round!
	var/file
	/// our extension, excluding the .
	var/ext

	/// force browse_rsc?
	var/always_browse_rsc = FALSE
	/// do not mangle our name
	var/do_not_mangle = FALSE
	/// the asset pack loaded the file from cache instead of generate()ing it again.
	/// todo: caching; we might want to replace this var with the git commit or something, anything to track when it was cached.
	// var/restored_from_cache = FALSE

	/// if set, we are shoved in a namespace of this id if not browse_rsc()'d
	var/namespace_id

	/// actual filename to use
	var/mangled_name

/datum/asset_item/New(name, file, do_not_mangle, always_browse_rsc, restored_from_cache)
	// set name
	src.name = name
	ASSERT(length(src.name))
	// set options
	src.do_not_mangle = do_not_mangle
	src.always_browse_rsc = always_browse_rsc
	// todo: caching
	// src.restored_from_cache = restored_from_cache
	// set file; always load them into resource cache if they aren't already
	// todo: this kind of ruins the point if we're trying to flush state,
	// todo: but we have to anyways unless TGS stops swapping A/B out from under Live during the round.
	src.file = isfile(file)? file : fcopy_rsc(file)
	// get hash; allegedly there's an issue that causes incorrect hashes if we do it directly
	src.hash = md5asfile(file)
	// set extension
	var/extstart = findlasttext(name, ".")
	if (extstart)
		ext = "[copytext(name, extstart+1)]"
	mangled_name = do_not_mangle? name : mangle_name()

/datum/asset_item/proc/mangle_name()
	return "asset.[hash].[ext]"

/**
 * dynamic asset items
 *
 * aka "i overengineered asset_pack, what if you just want to send one file?"
 *
 * well this is how.
 */
/datum/asset_item/dynamic
	/// loaded url provided by transport; we are accessible from this by every client.
	var/loaded_url

/datum/asset_item/dynamic/proc/get_url()
	return ensure_loaded()

/datum/asset_item/dynamic/proc/send(list/client/clients)
	ensure_loaded()
	for(var/client/C as anything in clients)
		SSassets.transport.send_asset_items(C, src)

/datum/asset_item/dynamic/proc/ensure_loaded()
	if(!isnull(loaded_url))
		return loaded_url
	loaded_url = SSassets.transport.load_asset_item(src)
	return loaded_url
