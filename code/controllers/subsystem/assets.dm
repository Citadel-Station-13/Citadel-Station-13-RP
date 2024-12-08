SUBSYSTEM_DEF(assets)
	name = "Assets"
	init_order = INIT_ORDER_ASSETS
	init_stage = INIT_STAGE_EARLY
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
	return SS_INIT_SUCCESS

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
		ASSERT(!asset_packs_by_id[pack.id])
		asset_packs_by_id[pack.id] = pack
		registered = TRUE
	if(!registered)
		CRASH("couldn't register by type or id")
	asset_packs += pack
	if(should_preload_native_pack(pack))
		asset_packs_to_natively_preload += pack

/datum/controller/subsystem/assets/proc/should_preload_native_pack(datum/asset_pack/pack)
	if(pack.do_not_preload)
		return FALSE
	return CONFIG_GET(flag/asset_simple_preload)

/datum/controller/subsystem/assets/proc/immediately_ready_all_packs()
	for(var/datum/asset_pack/pack as anything in asset_packs)
		pack.ensure_ready()

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
/datum/controller/subsystem/assets/proc/ready_asset_pack(identifier)
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

	var/datum/asset_pack/resolved = ready_asset_pack(identifier)

	var/list/targets = islist(target)? target : list(target)

	for(var/client/C as anything in targets)
		transport.send_asset_pack(C, resolved)

/**
 * loads a file that we declare to not be necessary to keep around / store information on after
 * the necessary clients have loaded it.
 *
 * * blocking proc
 * * warning - this can clog a client's browse queue. use send_anonymous_files() to send multiple in a short period of time!
 *
 * @params
 * * targets - client or list of clients to send it to
 * * file - the file in question
 * * ext - mandatory extension for the file. do not include the '.'
 *
 * @return url to load it with; this will usually be heavily mangled.
 */
/datum/controller/subsystem/assets/proc/send_anonymous_file(list/client/targets, file, ext)
	ASSERT(ext)
	return transport.send_anonymous_file(targets, file, ext)

/**
 * loads a set of files that we declare to not be necessary to keep around / store information on after
 * the necessary clients have loaded it.
 *
 * * blocking proc
 * * you should probably not use this if you can; it's a little janky.
 *
 * @params
 * * targets - client or list of clients to send it to
 * * files - the files in question, associated to their extensions
 *
 * @return list(urls) in same order as files.
 */
/datum/controller/subsystem/assets/proc/send_anonymous_files(list/client/targets, list/files)
	// todo: optimize this proc
	. = new /list(length(files))
	for(var/i in 1 to length(files))
		var/file = files[i]
		.[i] = send_anonymous_file(targets, file, files[file])
		stoplag(0)

/**
 * @params
 * * file - a file
 * * name - the name for the file. if files is a list, this is ignored
 * * do_not_mangle - do not mangle / unique-ify the name of the file.
 *
 * @return /datum/asset_item/dynamic
 */
/datum/controller/subsystem/assets/proc/register_dynamic_item_by_name(file, name, do_not_mangle)
	RETURN_TYPE(/datum/asset_item/dynamic)
	if(dynamic_asset_items_by_name[name])
		. = FALSE
		CRASH("collision on [name]; automatically-updating dynamic items are not yet supported.")
	var/datum/asset_item/dynamic/created = new(name, file, do_not_mangle = do_not_mangle)
	return created

/datum/controller/subsystem/assets/proc/send_dynamic_item_by_name(list/client/clients, list/names)
	if(!islist(clients))
		clients = list(clients)
	for(var/name in names)
		var/datum/asset_item/dynamic/item = dynamic_asset_items_by_name[name]
		item?.send(clients)

/datum/controller/subsystem/assets/proc/get_dynamic_item_url_by_name(name)
	return dynamic_asset_items_by_name[name]?.get_url()

/datum/controller/subsystem/assets/on_config_loaded()
	var/newtransporttype = /datum/asset_transport/browse_rsc
	switch (CONFIG_GET(string/asset_transport))
		if ("webroot")
			newtransporttype = /datum/asset_transport/webroot

	if (newtransporttype == transport?.type)
		return

	var/datum/asset_transport/newtransport = new newtransporttype
	if (!newtransport.validate_config())
		stack_trace("failed to validate config; going back to browse_rsc")
		qdel(newtransport)
		newtransport = new /datum/asset_transport/browse_rsc

	set_transport_to(newtransport)

/datum/controller/subsystem/assets/proc/reload_transport()
	set_transport_to(new transport.type)

/datum/controller/subsystem/assets/proc/set_transport_to(datum/asset_transport/new_transport)
	QDEL_NULL(transport)
	transport = new_transport

	// unload all asset packs
	for(var/datum/asset_pack/pack in asset_packs)
		pack.unload()
	// unload all dynamic items
	for(var/name in dynamic_asset_items_by_name)
		var/datum/asset_item/dynamic/item = dynamic_asset_items_by_name[name]
		if(!istype(item))
			continue
		item.loaded_url = null

	transport.initialize()

/datum/controller/subsystem/assets/proc/preload_client_assets(client/target)
	transport.perform_native_preload(target, asset_packs_to_natively_preload)
