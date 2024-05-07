/datum/asset_pack
	abstract_type = /datum/asset_pack

	/// if set, we are registering by ID instead of by type
	/// thus, don't set it in a prototype,
	/// because 99% of assets are hardcoded and shouldn't do that.
	///
	/// ids should be round-unique, but not to prevent collisions.
	/// our md5'ing system does that.
	/// what id uniqueness provides is *persistence* collisions.
	///
	/// though honestly, i'd question why assets should ever be persisted in that way
	/// as opposed to a volatile-append-supported asset datum being added to
	/// as things load in.
	var/id

	/// if set, we immediately load via SSassets, rather than being pushed
	/// onto SSasset_loading for loading during pregame
	var/load_immediately = FALSE
	/// if set, we don't load at all until something asks for us
	var/load_deferred = FALSE
	/// are we fully loaded / generated?
	var/loaded = FALSE

/**
 * ensures we are loaded
 */
/datum/asset_pack/proc/ensure_ready()
	switch(loaded)
		if(ASSET_FULLY_LOADED)
		if(ASSET_NOT_LOADED)
			INVOKE_ASYNC(src, PROC_REF(load))
			UNTIL(loaded != ASSET_IS_LOADING)
		if(ASSET_IS_LOADING)
			UNTIL(loaded != ASSET_IS_LOADING)
	return loaded == ASSET_FULLY_LOADED

/**
 * loads / generates whatever is in us
 *
 * also pushes us to the transport if necessary.
 */
/datum/asset_pack/proc/load()
	loaded = ASSET_IS_LOADING
	var/results = generate()
	register(results)
	loaded = ASSET_FULLY_LOADED

/**
 * generates whatever needs to be generated
 *
 * this must be idempotent and hopefully efficient,
 * because this is called again if the transport is changed mid-round.
 *
 * @return return value is passed to register().
 */
/datum/asset_pack/proc/generate()
	return

/**
 * registers our content to the asset system's transport
 *
 * @params
 * * generation - output of generate().
 */
/datum/asset_pack/proc/register()
	return

/datum/asset_pack
	#warn below + all /datum/asset_pack subtypes

	var/cached_serialized_url_mappings
	var/cached_serialized_url_mappings_transport_type

	/**
	 * Whether or not this asset can be cached across rounds of the same commit under the `CACHE_ASSETS` config.
	 * This is not a *guarantee* the asset will be cached. Not all asset subtypes respect this field, and the
	 * config can, of course, be disabled.
	 */
	var/cross_round_cachable = FALSE
	#warn validate config

/datum/asset_pack/proc/get_url_mappings()
	return list()

/// Returns a cached tgui message of URL mappings
/datum/asset_pack/proc/get_serialized_url_mappings()
	if (isnull(cached_serialized_url_mappings) || cached_serialized_url_mappings_transport_type != SSassets.transport.type)
		cached_serialized_url_mappings = TGUI_CREATE_MESSAGE("asset/mappings", get_url_mappings())
		cached_serialized_url_mappings_transport_type = SSassets.transport.type

	return cached_serialized_url_mappings

/datum/asset_pack/proc/send(client)
	return

/// Returns whether or not the asset should attempt to read from cache
/datum/asset_pack/proc/should_refresh()
	return !cross_round_cachable || !CONFIG_GET(flag/cache_assets)
