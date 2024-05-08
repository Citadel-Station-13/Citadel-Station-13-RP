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

	/// Should this file also be sent via the legacy browse_rsc system
	/// when cdn transports are enabled?
	var/legacy = FALSE
	/// Used by the cdn system to keep legacy css assets with their parent
	/// css file. (css files resolve urls relative to the css file, so the
	/// legacy system can't be used if the css file itself could go out over
	/// the cdn)
	var/namespace = null
	/// True if this is the parent css or html file for an asset's namespace
	var/namespace_parent = FALSE
	/// TRUE for keeping local asset names when browse_rsc backend is used
	var/keep_local_name = FALSE

/datum/asset_item/New(name, file)
	if (!isfile(file))
		file = fcopy_rsc(file)

	hash = md5asfile(file) //icons sent to the rsc sometimes md5 incorrectly
	if (!hash)
		CRASH("invalid asset sent to asset cache")
	src.name = name
	var/extstart = findlasttext(name, ".")
	if (extstart)
		ext = "[copytext(name, extstart+1)]"
	resource = file

