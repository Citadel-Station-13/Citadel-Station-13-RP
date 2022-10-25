SUBSYSTEM_DEF(assets)
	name = "Assets"
	init_order = INIT_ORDER_ASSETS
	subsystem_flags = SS_NO_FIRE
	var/list/datum/asset_cache_item/cache = list()
	var/list/preload = list()
	var/datum/asset_transport/transport = new()
	/// dynamic assets by name associated to raw asset pack
	var/static/list/dynamic_assets = list()


/datum/controller/subsystem/assets/OnConfigLoad()
	var/newtransporttype = /datum/asset_transport
	switch (CONFIG_GET(string/asset_transport))
		if ("webroot")
			newtransporttype = /datum/asset_transport/webroot

	if (newtransporttype == transport.type)
		return

	var/datum/asset_transport/newtransport = new newtransporttype ()
	if (newtransport.validate_config())
		transport = newtransport
	for(var/name in dynamic_assets)
		transport.register_asset(name, dynamic_assets[name])
	transport.Load()

/datum/controller/subsystem/assets/Initialize(timeofday)
	for(var/type in typesof(/datum/asset))
		var/datum/asset/A = type
		if (type != initial(A._abstract))
			get_asset_datum(type)
	transport.Initialize(cache)
	..()

/datum/controller/subsystem/assets/Recover()
	cache = SSassets.cache
	preload = SSassets.preload

/**
 * registers a dynamic asset
 */
/datum/controller/subsystem/assets/proc/register_dynamic_asset(name, pack)
	transport.register_asset(name, pack)
	dynamic_assets[name] = pack

/**
 * deletes a dynamic asset
 */
/datum/controller/subsystem/assets/proc/delete_dynamic_asset(name)
	transport.delete_asset(name)
	dynamic_assets -= name

/**
 * gets a dynamic asset's URL
 */
/datum/controller/subsystem/assets/proc/url_dynamic_asset(name)
	return transport.get_asset_url(name)
