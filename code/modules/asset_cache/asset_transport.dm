/**
 * Pluggable transports used for sending assets to clients.
 *
 * todo: if sending too many resources, we need a way to tell the client they're loading. maybe a loading bar graphic?
 */
/datum/asset_transport
	/// name of the transport
	var/name = "asset-transport: ???"

	/// non-ephemeral items registered; *mangled filename* = instance
	/// the reason we still use filename assoc list is so filename uniqueness is still enforced
	/// incase we ever need to go back to native (browse_rsc).
	var/list/loaded_items = list()

/**
 * called when we're loaded into SSassets
 */
/datum/asset_transport/proc/initialize()
	return

/datum/asset_transport/proc/load_asset_items_from_pack(datum/asset_pack/pack)
	var/list/filename_to_url = list()
	for(var/filename in pack.item_lookup)
		var/datum/asset_item/item = pack.item_lookup[filename]
		filename_to_url[filename] = load_asset_item(item)
	return filename_to_url

/**
 * @return url to use after a client is sent the asset
 */
/datum/asset_transport/proc/load_asset_item(datum/asset_item/item)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(item.always_browse_rsc)
		. = load_item_native(item)
	else
		. = load_item(item)
	if(!.)
		CRASH("failed to load an item")
	if(loaded_items[.])
		var/datum/asset_item/existing = loaded_items[.]
		if(existing.hash != item.hash)
			CRASH("collision between [existing] and [item] on [.]")
	loaded_items[.] = item

/**
 * this is a blocking proc
 */
/datum/asset_transport/proc/send_asset_pack(client/target, datum/asset_pack/pack)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(pack.absolute)
		return send_asset_item_native(target, pack.packed_items)
	return send_asset_items(target, pack.packed_items)

/**
 * this is a blocking proc
 */
/datum/asset_transport/proc/send_asset_items(client/target, list/datum/asset_item/items)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(!islist(items))
		items = list(items)
	var/list/datum/asset_item/native_sends = list()
	for(var/datum/asset_item/item as anything in items)
		if(!item.always_browse_rsc)
			continue
		items -= item
		native_sends += item
	if(length(native_sends))
		send_asset_item_native(target, native_sends)
	return send_items(target, items)

//* not sure where to put or what to do with these yet

/**
 * automatically preload all native asset packs to a client, one by one.
 */
/datum/asset_transport/proc/perform_native_preload(client/victim, list/datum/asset_pack/native_packs)
	victim.asset_cache_native_preload(native_packs)

//* Abstraction - Subtypes must override these

/// Check the config is valid to load this transport
/// Returns TRUE or FALSE
/datum/asset_transport/proc/validate_config()
	CRASH("abstract proc unimplemented")

/**
 * @return URL
 */
/datum/asset_transport/proc/send_anonymous_file(list/client/targets, file, ext)
	CRASH("abstract proc unimplemented")

/**
 * this proc must be idempotent.
 *
 * @return URL to use.
 */
/datum/asset_transport/proc/load_item(datum/asset_item/item)
	CRASH("abstract proc unimplemented")

/datum/asset_transport/proc/send_items(client/target, list/datum/asset_item/items)
	CRASH("abstract proc unimplemented")

//* Native - common behavior used to allow browse_rsc() usage, either as a fallback or as an alternative loader

/datum/asset_transport/proc/send_anonymous_file_native(list/client/targets, file, ext)
	SHOULD_NOT_OVERRIDE(TRUE)
	// we don't even need a hash, just the url
	// only stuff like webroot cares about hash, for CDN caching purposes
	var/static/notch = 0
	// you're not going to send more than a million files a tick, are you now?
	if(notch >= (1024 * 1024))
		notch = 0
	var/mangled_name = "[rand(1, 1000)]-[world.time]-[++notch]"
	if(ext)
		mangled_name = "[mangled_name].[ext]"
	for(var/client/target as anything in targets)
		target << browse_rsc(file, mangled_name)
	return mangled_name

/datum/asset_transport/proc/send_asset_item_native(list/client/targets, list/datum/asset_item/items)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(!islist(targets))
		targets = list(targets)
	if(!islist(items))
		items = list(items)
	for(var/client/target as anything in targets)
		if(ismob(target))
			target = target:client
		var/list/datum/asset_item/to_send = list()
		for(var/datum/asset_item/item as anything in items)
			var/existing = target.asset_native_received[item.mangled_name]
			if(existing)
				if(existing != item.hash)
					stack_trace("colliding hash when sending a native item to a client [target] <- [item] on mangled name [item.mangled_name].")
				continue
			to_send += item
		for(var/datum/asset_item/sending as anything in to_send)
			target.asset_native_received[sending.mangled_name] = sending.hash
			target << browse_rsc(sending.file, sending.mangled_name)

/**
 * this proc must be idempotent.
 *
 * @return URL to use.
 */
/datum/asset_transport/proc/load_item_native(datum/asset_item/item)
	SHOULD_NOT_OVERRIDE(TRUE)
	return item.mangled_name
