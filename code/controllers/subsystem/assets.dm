SUBSYSTEM_DEF(assets)
	name = "Assets"
	init_order = INIT_ORDER_ASSETS
	subsystem_flags = SS_NO_FIRE

	/// assets by type; this is for hardcoded assets
	var/static/list/assets_by_type = list()
	/// assets by id; this is for dynamic assets
	var/static/list/assets_by_id = list()

/datum/controller/subsystem/assets/Initialize(timeofday)
	for(var/datum/asset_pack/path as anything in typesof(/datum/asset_pack))
		if(path == initial(path.abstract_type))
			continue
		var/datum/asset_pack/instance = new path
		assets_by_type[path] = instance

#ifndef DO_NOT_DEFER_ASSETS
		if(initial(instance.load_deferred))
			continue
		else if(initial(instance.load_immediately))
			instance.load()
		else
			SSasset_loading.queue_asset(instance)
#else
		instance.load()
#endif

/**
 * fetches an asset datum, **without** ensuring it's ready / loaded
 */
/datum/controller/subsystem/assets/proc/resolve_asset(identifier)
	if(ispath(identifier))
		return assets_by_type[identifier]
	else
		return assets_by_id[identifier]

/**
 * fetches an asset datum, and ensures it's ready / loaded
 *
 * * This proc can block if something needs to generate.
 */
/datum/controller/subsystem/assets/proc/load_asset(identifier)
	var/datum/asset_pack/resolved = resolve_asset(identifier)
	resolved.ensure_ready()
	return resolved

#warn below

/datum/controller/subsystem/assets
	var/list/datum/asset_cache_item/cache = list()
	var/list/preload = list()
	var/datum/asset_transport/transport = new()


/datum/controller/subsystem/assets/OnConfigLoad()
	var/newtransporttype = /datum/asset_transport/simple
	switch (CONFIG_GET(string/asset_transport))
		if ("webroot")
			newtransporttype = /datum/asset_transport/webroot

	if (newtransporttype == transport.type)
		return

	var/datum/asset_transport/newtransport = new newtransporttype ()
	if (newtransport.validate_config())
		transport = newtransport
	transport.Load()

/datum/controller/subsystem/assets/Initialize(timeofday)

	transport.Initialize(cache)

	return ..()


/datum/controller/subsystem/assets/Recover()
	cache = SSassets.cache
	preload = SSassets.preload
