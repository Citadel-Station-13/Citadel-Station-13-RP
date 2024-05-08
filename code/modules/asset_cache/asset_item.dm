/**
 * A datum used to store data on an asset in the asset cache.
 *
 * The asset cache system, at its core, is just a way to get files from the server to the
 * client in a reproducible and efficient manner.
 *
 * Each asset item is an item in the cache.
 */
VV_PROTECT_READONLY(/datum/asset_item)
/datum/asset_item
	/// filename
	var/name
	/// our hash
	var/hash
	/// the actual file handle
	var/file
	/// our extension, excluding the .
	var/ext

	/// force browse_rsc?
	var/always_browse_rsc = FALSE
	/// do not mangle our name
	var/do_not_mangle = FALSE
	/// was restored from cache
	var/restored_from_cache = FALSE

	/// Used by the cdn system to keep legacy css assets with their parent
	/// css file. (css files resolve urls relative to the css file, so the
	/// legacy system can't be used if the css file itself could go out over
	/// the cdn)
	var/namespace = null
	/// True if this is the parent css or html file for an asset's namespace
	var/namespace_parent = FALSE

/datum/asset_item/New(name, file)
	// set name
	src.name = name
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
	
