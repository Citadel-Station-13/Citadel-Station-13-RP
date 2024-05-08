SUBSYSTEM_DEF(assets)
	name = "Assets"
	init_order = INIT_ORDER_ASSETS
	subsystem_flags = SS_NO_FIRE

	/// assets by type; this is for hardcoded assets
	///
	/// an asset is either registered by type, or id, never both.
	var/static/list/assets_by_type = list()
	/// assets by id; this is for dynamic assets
	///
	/// an asset is either registered by type, or id, never both.
	var/static/list/assets_by_id = list()

	/// our active asset transport
	var/datum/asset_transport/transport

/datum/controller/subsystem/assets/Initialize(timeofday)
	for(var/datum/asset_pack/path as anything in typesof(/datum/asset_pack))
		if(path == initial(path.abstract_type))
			continue
		var/datum/asset_pack/instance = new path
		assets_by_type[path] = instance

		#warn transport swap will wreak havoc.

#ifndef DO_NOT_DEFER_ASSETS
		if(initial(instance.load_deferred))
			continue
		else if(initial(instance.load_immediately))
			instance.load()
		else
			SSasset_loading.queue_asset_pack(instance)
#else
		instance.load()
#endif

/**
 * fetches an asset datum, **without** ensuring it's ready / loaded
 *
 * @return asset pack resolved
 */
/datum/controller/subsystem/assets/proc/resolve_asset_pack(identifier)
	if(istype(identifier, /datum/asset_pack))
		return identifier
	if(ispath(identifier))
		return assets_by_type[identifier]
	else
		return assets_by_id[identifier]

/**
 * fetches an asset datum, and ensures it's ready / loaded
 *
 * * This proc can block if something needs to generate.
 *
 * @return asset pack resolved
 */
/datum/controller/subsystem/assets/proc/load_asset_pack(identifier)
	var/datum/asset_pack/resolved = resolve_asset_pack(identifier)
	resolved.ensure_ready()
	return resolved

/**
 * ensures an asset has been sent to a client
 *
 * @return asset pack resolved
 */
/datum/controller/subsystem/assets/proc/send_asset_pack(identifier, client/target)
	var/datum/asset_pack/resolved = load_asset_pack(identifier)
	. = resolved

	if(!target)
		return
	#warn impl

#warn below


/datum/controller/subsystem/assets/OnConfigLoad()
	var/newtransporttype = /datum/asset_transport/browse_rsc
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

