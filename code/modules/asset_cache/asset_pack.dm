/**
 * Effectively, a set of files that can be sent to clients.
 *
 * Or more specifically, a way to either package (just use /simple),
 * or generate a set of files that can be sent to clients that
 * provide specific information (like /spritesheet does).
 *
 * Provides inbuilt early and deferred generation capabilities to spread
 * expensive generation operations across 'idle' ticks.
 */
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

	/// a record of filename = asset_item datums
	/// these are transport-agnostic.
	var/tmp/list/datum/asset_item/loaded_items
	/// a record of filename = url when we're loaded and pushed to a transport.
	var/tmp/list/loaded_urls

	/// having this on will force something to be sent via
	/// browse_rsc(), ensuring it always exists in the cache folder
	/// that byond browsers are ran out of
	///
	/// * implies do_not_mangle
	/// * implies do_not_separate
	var/legacy = FALSE

	/// do not mutate filenames on the remote side
	/// used when html pages rely on static bindings / aren't otherwise
	/// dynamically generated.
	var/do_not_mangle = FALSE
	/// do not allow files to be split up between different folders on the remote side
	/// this means everything in this pack can access each other by a direct, relative link
	/// and doesn't need to 'find' where the others are through some convoluted process
	///
	/// * this does incur a cost as everything being sent now has to be md5'd with each other.
	var/do_not_separate = FALSE
	/// do not preload if determined to be loading via browse_rsc().
	var/do_not_preload = FALSE

	/// allow caching cross-rounds, if the server is under a singular commit
	/// requires configuration to be enabled too.
	var/allow_cached_generation = FALSE

/datum/asset_pack/New(id)
	if(!isnull(id))
		src.id = id

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
	var/list/files = register(results)
	push(files)
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
 * returns a list of filenames associated to files,
 * because that's what the asset items / cache is actually dealing with.
 *
 * all filenames must be *globally unique*.
 * while this is technically able to be circumvented on the modern asset loading system
 * used by tgui windows, it is nonetheless still kept and enforced
 * to make debugging / development less awful.
 *
 * any temporary files should go into ""
 *
 * @params
 * * generation - output of generate().
 *
 * @return list("<filename>" = file, ...)
 */
/datum/asset_pack/proc/register(generation)
	return list()

/datum/asset_pack/proc/get_url(filename)
	. = loaded_urls[filename]
	if(isnull(.))
		CRASH("failed to get url for [filename] on [type] ([id || "compile-time"]). something is terribly wrong!")

#warn below + all /datum/asset_pack subtypes
/datum/asset_pack

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
