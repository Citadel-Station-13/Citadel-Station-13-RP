/**
 * Pluggable transports used for sending assets to clients.
 */
/datum/asset_transport
	/// name of the transport
	var/name = "asset-transport: ???"

	/// Don't mutate the filename of assets when sending via browse_rsc.
	/// This is to make it easier to debug issues with assets, and allow server operators to bypass issues that make it to production.
	/// If turning this on fixes asset issues, something isn't using get_asset_url and the asset isn't marked legacy, fix one of those.
	var/dont_mutate_filenames = FALSE
	#warn change how this works to be a filename debugging system

	/// non-ephemeral items registered; *mangled filename* = instance
	/// the reason we still use filename assoc list is so filename uniqueness is still enforced
	/// incase we ever need to go back to native (browse_rsc).
	var/list/loaded_items = list()

/**
 * called when we're loaded into SSassets
 */
/datum/asset_transport/proc/initialize()

/datum/asset_transport

/datum/asset_transport/proc/load_asset_items(list/datum/asset_item/items)
	#warn impl

#warn sigh

/datum/asset_transport/proc/Initialize(list/assets)
	preload = assets.Copy()
	if (!CONFIG_GET(flag/asset_simple_preload))
		return
	for(var/client/C in GLOB.clients)
		addtimer(CALLBACK(src, PROC_REF(send_assets_slow), C, preload), 1 SECONDS)

/// Register a browser asset with the asset cache system
/// asset_name - the identifier of the asset
/// asset - the actual asset file (or an asset_item datum)
/// returns a /datum/asset_item.
/// mutiple calls to register the same asset under the same asset_name return the same datum
/datum/asset_transport/proc/register_asset(asset_name, asset)
	var/datum/asset_item/ACI = asset
	if (!istype(ACI))
		ACI = new(asset_name, asset)
		if (!ACI || !ACI.hash)
			CRASH("ERROR: Invalid asset: [asset_name]:[asset]:[ACI]")
	if (SSassets.cache[asset_name])
		var/datum/asset_item/OACI = SSassets.cache[asset_name]
		OACI.legacy = ACI.legacy = (ACI.legacy|OACI.legacy)
		OACI.namespace_parent = ACI.namespace_parent = (ACI.namespace_parent | OACI.namespace_parent)
		OACI.namespace = OACI.namespace || ACI.namespace
		if (OACI.hash != ACI.hash)
			var/error_msg = "ERROR: new asset added to the asset cache with the same name as another asset: [asset_name] existing asset hash: [OACI.hash] new asset hash:[ACI.hash]"
			stack_trace(error_msg)
			log_asset(error_msg)
		else
			if (length(ACI.namespace))
				return ACI
			return OACI

	SSassets.cache[asset_name] = ACI
	return ACI


/// Returns a url for a given asset.
/// asset_name - Name of the asset.
/// asset_item - asset cache item datum for the asset, optional, overrides asset_name
/datum/asset_transport/proc/get_asset_url(asset_name, datum/asset_item/asset_item)
	if (!istype(asset_item))
		asset_item = SSassets.cache[asset_name]
	// To ensure code that breaks on cdns breaks in local testing, we only
	// use the normal filename on legacy assets and name space assets.
	var/keep_local_name = dont_mutate_filenames \
		|| asset_item.legacy \
		|| asset_item.keep_local_name \
		|| (asset_item.namespace && !asset_item.namespace_parent)
	if (keep_local_name)
		return url_encode(asset_item.name)
	return url_encode("asset.[asset_item.hash].[asset_item.ext]")

/**
 * this is a blocking proc
 */
/datum/asset_transport/proc/send_pack(client/target, datum/asset_pack/pack)
	#warn impl

/**
 * this is a blocking proc
 */
/datum/asset_transport/proc/send_items(client/target, list/datum/asset_item/items)
	if(!islist(items))
		items = list(items)
	#warn impl

/**
 * this is a blocking proc
 */
/datum/asset_transport/proc/send_items_native(client/target, list/datum/asset_item/items)
	if(!islist(items))
		items = list(items)

/**
 * automatically preload all native asset packs to a client, one by one.
 */
/datum/asset_transport/proc/perform_native_preload(client/victim, list/datum/asset_pack/native_packs)
	victim.asset_cache_native_preload(native_packs)

/// Sends a list of browser assets to a client
/// client - a client or mob
/// asset_list - A list of asset filenames to be sent to the client. Can optionally be assoicated with the asset's asset_item datum.
/// Returns TRUE if any assets were sent.
/datum/asset_transport/proc/send_assets(client/client, list/asset_list)
	if (!istype(client))
		if (ismob(client))
			var/mob/M = client
			if (M.client)
				client = M.client
			else //no stacktrace because this will mainly happen because the client went away
				return
		else
			CRASH("Invalid argument: client: `[client]`")
	if (!islist(asset_list))
		asset_list = list(asset_list)
	var/list/unreceived = list()

	for (var/asset_name in asset_list)
		var/datum/asset_item/ACI = asset_list[asset_name]
		if (!istype(ACI) && !(ACI = SSassets.cache[asset_name]))
			log_asset("ERROR: can't send asset `[asset_name]`: unregistered or invalid state: `[ACI]`")
			continue
		var/asset_file = ACI.resource
		if (!asset_file)
			log_asset("ERROR: can't send asset `[asset_name]`: invalid registered resource: `[ACI.resource]`")
			continue

		var/asset_hash = ACI.hash
		var/new_asset_name = asset_name
		var/keep_local_name = dont_mutate_filenames \
			|| ACI.legacy \
			|| ACI.keep_local_name \
			|| (ACI.namespace && !ACI.namespace_parent)
		if (!keep_local_name)
			new_asset_name = "asset.[ACI.hash].[ACI.ext]"
		if (client.sent_assets[new_asset_name] == asset_hash)
			if (GLOB.Debug2)
				log_asset("DEBUG: Skipping send of `[asset_name]` (as `[new_asset_name]`) for `[client]` because it already exists in the client's sent_assets list")
			continue
		unreceived[asset_name] = ACI

	if (unreceived.len)
		if (unreceived.len >= ASSET_CACHE_TELL_CLIENT_AMOUNT)
			to_chat(client, SPAN_INFOPLAIN("Sending Resources..."))

		for (var/asset_name in unreceived)
			var/new_asset_name = asset_name
			var/datum/asset_item/ACI = unreceived[asset_name]
			var/keep_local_name = dont_mutate_filenames \
				|| ACI.legacy \
				|| ACI.keep_local_name \
				|| (ACI.namespace && !ACI.namespace_parent)
			if (!keep_local_name)
				new_asset_name = "asset.[ACI.hash].[ACI.ext]"
			log_asset("Sending asset `[asset_name]` to client `[client]` as `[new_asset_name]`")
			client << browse_rsc(ACI.resource, new_asset_name)

			client.sent_assets[new_asset_name] = ACI.hash

		addtimer(CALLBACK(client, TYPE_PROC_REF(/client, asset_cache_update_json)), 1 SECONDS, TIMER_UNIQUE|TIMER_OVERRIDE)
		return TRUE
	return FALSE

/// Check the config is valid to load this transport
/// Returns TRUE or FALSE
/datum/asset_transport/proc/validate_config(log = TRUE)
	return TRUE
