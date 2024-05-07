//all of our asset datums, used for referring to these later
GLOBAL_LIST_EMPTY(asset_datums)

/// Get an assetdatum or make a new one.
/proc/get_asset_datum(type)
	var/datum/asset/loaded_asset = GLOB.asset_datums[type] || new type()
	return loaded_asset.ensure_ready()

/**
 * Get an assetdatum or make a new one.
 *! But does NOT ensure it's filled, if you want that use get_asset_datum()
 */
/proc/load_asset_datum(type)
	return GLOB.asset_datums[type] || new type()

/datum/asset
	abstract_type = /datum/asset
	/// lazyloaded? this means we lateload when someone fetches us, rather than at init
	var/lazy = FALSE

	var/cached_serialized_url_mappings
	var/cached_serialized_url_mappings_transport_type

	/**
	 * Whether or not this asset can be cached across rounds of the same commit under the `CACHE_ASSETS` config.
	 * This is not a *guarantee* the asset will be cached. Not all asset subtypes respect this field, and the
	 * config can, of course, be disabled.
	 */
	var/cross_round_cachable = FALSE
	#warn validate config

/**
 * Stub that allows us to react to something trying to get us.
 * Not useful here, more handy for sprite sheets.
 */
/datum/asset/proc/ensure_ready()
	return src

/// Stub to hook into if your asset is having its generation queued by SSasset_loading
/datum/asset/proc/queued_generation()
	CRASH("[type] inserted into SSasset_loading despite not implementing /proc/queued_generation")


/datum/asset/New()
	GLOB.asset_datums[type] = src
	register()

/datum/asset/proc/get_url_mappings()
	return list()

/// Returns a cached tgui message of URL mappings
/datum/asset/proc/get_serialized_url_mappings()
	if (isnull(cached_serialized_url_mappings) || cached_serialized_url_mappings_transport_type != SSassets.transport.type)
		cached_serialized_url_mappings = TGUI_CREATE_MESSAGE("asset/mappings", get_url_mappings())
		cached_serialized_url_mappings_transport_type = SSassets.transport.type

	return cached_serialized_url_mappings

/datum/asset/proc/register()
	return

/datum/asset/proc/send(client)
	return

/// Returns whether or not the asset should attempt to read from cache
/datum/asset/proc/should_refresh()
	return !cross_round_cachable || !CONFIG_GET(flag/cache_assets)
