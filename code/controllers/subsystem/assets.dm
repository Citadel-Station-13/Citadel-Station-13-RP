SUBSYSTEM_DEF(assets)
	name = "Assets"
	init_order = INIT_ORDER_ASSETS
	subsystem_flags = SS_NO_FIRE

	/// asset packs by type; this is for hardcoded assets
	///
	/// an asset is either registered by type, or id, never both.
	var/static/list/asset_packs_by_type = list()
	/// asset packs by id; this is for dynamic assets
	///
	/// an asset is either registered by type, or id, never both.
	var/static/list/asset_packs_by_id = list()
	/// all asset packs
	var/static/list/datum/asset_pack/asset_packs = list()
	/// asset packs we're going to preload via native (browse_rsc) transport
	var/list/datum/asset_pack/asset_packs_to_natively_preload = list()


	/// all dynamic or standalone asset items that were registered with md5
	var/static/list/datum/asset_item/dynamic/dynamic_asset_items_by_md5 = list()
	/// all dynamic or standalone asset items that were registered with name (which is also their uid)
	var/static/list/datum/asset_item/dynamic/dynamic_asset_items_by_name = list()

	/// our active asset transport
	var/datum/asset_transport/transport

	// todo: cache system.

	/// if non-null, this is our effective cache commit
	// var/cache_commit
	/// are we using cached data this round?
	// var/cache_enabled = FALSE

/datum/controller/subsystem/assets/Initialize(timeofday)
	// detect_cache_worthiness()

	for(var/datum/asset_pack/path as anything in typesof(/datum/asset_pack))
		if(path == initial(path.abstract_type))
			continue
		var/datum/asset_pack/instance = new path
		register_asset_pack(instance, TRUE)

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
 * register an asset pack to make it able to be resolved or loaded
 *
 * @params
 * * pack - the pack
 * * by_type - do not use this, only used for subsystem.
 */
/datum/controller/subsystem/assets/proc/register_asset_pack(datum/asset_pack/pack, by_type)
	var/registered = FALSE
	if(by_type)
		ASSERT(!asset_packs_by_type[pack.type])
		asset_packs_by_type[pack.type] = pack
		registered = TRUE
	if(pack.id)
		asset_packs_by_id[pack.id] = pack
		registered = TRUE
	if(!registered)
		CRASH("couldn't register by type or id")
	if(should_preload_native_packs(pack))
		packs_to_natively_preload += pack

/datum/controller/subsystem/assets/proc/should_preload_native_pack(datum/asset_pack/pack)
	if(!pack.do_not_preload)
		return FALSE
	return CONFIG_GET(flag/asset_simple_preload)

/**
 * fetches an asset datum, **without** ensuring it's ready / loaded
 *
 * @return asset pack resolved
 */
/datum/controller/subsystem/assets/proc/resolve_asset_pack(identifier)
	if(istype(identifier, /datum/asset_pack))
		return identifier
	if(ispath(identifier))
		return asset_packs_by_type[identifier]
	else
		return asset_packs_by_id[identifier]

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
 * @params
 * * target - a client or a list of clients
 * * identifier - asset type, id, or instance
 *
 * @return TRUE if an asset had to be sent, FALSE if the client (is supposed to) already have it.
 */
/datum/controller/subsystem/assets/proc/send_asset_pack(client/target, identifier)
	if(isnull(target))
		return FALSE
	var/datum/asset_pack/resolved = load_asset_pack(identifier)
	var/list/targets = islist(target)? target : list(target)

	for(var/client/target as anything in targets)
		transport.send_pack(target, resolved)

	#warn impl

#warn redo hash; they should be for 'throwaway' ones.

/**
 * loads a file that we declare to not be necessary to keep around / store information on after
 * the necessary clients have loaded it.
 *
 * blocking proc
 *
 * @params
 * * targets - client or list of clients to send it to
 * * file - the file in question
 *
 * @return url to load it with; this will usually be heavily mangled.
 */
/datum/controller/subsystem/assets/proc/send_anonymous_file(client/targets, file)
	RETURN_TYPE(/datum/asset_item/dynamic)

/**
 * @params
 * * targets - a client, or a list of clients
 * * files - a file, or a list of names associated to files
 * * name - the name for the file. if files is a list, this is ignored
 * * do_not_mangle - do not mangle / unique-ify the name of the file.
 *
 * @return /datum/asset_item/dynamic
 */
/datum/controller/subsystem/assets/proc/register_and_send_dynamic_item_by_name(list/client/targets, list/files, name, do_not_mangle)
	RETURN_TYPE(/datum/asset_item/dynamic)
	#warn handle list files
	send_dynamic_item(targets, register_dynamic_item_by_name(file, name))

/**
 * @params
 * * targets - a client, or a list of clients
 * * files - a file, or a list of names associated to files
 * * name - the name for the file. if files is a list, this is ignored
 * * do_not_mangle - do not mangle / unique-ify the name of the file.
 *
 * @return /datum/asset_item/dynamic
 */
/datum/controller/subsystem/assets/proc/register_dynamic_item_by_name(list/file, name, do_not_mangle)
	RETURN_TYPE(/datum/asset_item/dynamic)

/// Generate a filename for this asset
/// The same asset will always lead to the same asset name
/// (Generated names do not include file extention.)
/proc/generate_asset_name(file)
	return "asset.[md5(fcopy_rsc(file))]"

/datum/controller/subsystem/assets/proc/send_dynamic_item_by_name(list/client/targets, name)

/datum/controller/subsystem/assets/proc/send_dynamic_item(list/client/targets, datum/asset_item/dynamic/item)
	if(!islist(targets))
		targets = list(targets)

/datum/controller/subsystem/assets/proc/get_dynamic_item_url_by_name(name)
	#warn impl

#warn impl all

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


/datum/controller/subsystem/assets/proc/preload_client_assets(client/target)
	transport.perform_native_preload(target, packs_to_natively_preload)
