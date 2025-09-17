/hook/client_stability_check/check_asset_cache/invoke(client/joining)
	INVOKE_ASYNC(joining, TYPE_PROC_REF(/client, warn_if_no_asset_cache_browser))
	return TRUE

/client
	/// asset cache: filename = md5, for things already sent to the client
	/// this is only for browse_rsc()'d assets.
	var/list/asset_native_received = list()
	/// used for browse_queue_fluhs()
	var/list/asset_flush_jobs = list()
	/// last flush job id
	var/asset_flush_last_id

/client/proc/warn_if_no_asset_cache_browser()
	if(!winexists(src, "asset_cache_browser")) // The client is using a custom skin, tell them.
		to_chat(src, "<span class='warning'>Unable to access asset cache browser, if you are using a custom skin file, please allow DS to download the updated version, if you are not, then make a bug report. This is not a critical issue but can cause issues with resource downloading, as it is impossible to know when extra resources arrived to you.</span>")

/client/on_topic_hook(raw_href, list/href_list, raw_src)
	. = ..()
	if(.)
		return

	if(href_list["asset_cache_confirm_arrival"])
		if(asset_cache_confirm_arrival(href_list["asset_cache_confirm_arrival"]))
			return TRUE
		else
			if(!isnull(asset_flush_jobs))
				// it's a valid job, it might be byond bug ID:2256651
				to_chat(src, "<span class='danger'>An error has been detected in how your client is receiving resources. Attempting to correct.... (If you keep seeing these messages you might want to close byond and reconnect)</span>")
				src << browse("...", "window=asset_cache_browser")
				return TRUE
			else
				// what the fuck are they doing?
				security_kick("A fatal issue occurred during asset send, or your client kept spamming receive confirmations \
				after acknowledgement. Please reconnect after clearing your cache.", TRUE, TRUE)
				return TRUE

/**
 * Process asset cache client topic calls for `"asset_cache_confirm_arrival=[INT]"`
 *
 * @return TRUE if it was a valid arrival
 */
/client/proc/asset_cache_confirm_arrival(job_id)
	var/asset_cache_job = round(text2num(job_id))
	//because we skip the limiter, we have to make sure this is a valid arrival and not somebody tricking us into letting them append to a list without limit.
	if(!isnull(asset_flush_jobs["[asset_cache_job]"]))
		asset_flush_jobs["[asset_cache_job]"] = TRUE
		return TRUE
	return FALSE

/// Blocks until all currently sending browse and browse_rsc assets have been sent.
/// Due to byond limitations, this proc will sleep for 1 client round trip even if the client has no pending asset sends.
/// This proc will return an untrue value if it had to return before confirming the send, such as timeout or the client going away.
/client/proc/asset_cache_flush_browse_queue(timeout = 50)
	var/job = ++asset_flush_last_id
	if(asset_flush_last_id >= SHORT_REAL_LIMIT)
		asset_flush_last_id = 0
	var/timeout_time = world.time + timeout
	src << browse({"<script>window.location.href="?asset_cache_confirm_arrival=[job]"</script>"}, "window=asset_cache_browser&file=asset_cache_send_verify.htm")

	asset_flush_jobs["[job]"] = FALSE
	while(!asset_flush_jobs["[job]"] && world.time < timeout_time) // Reception is handled in Topic()
		stoplag(1) // Lock up the caller until this is received.

	return asset_flush_jobs["[job]"]

/**
 * sends a list of asset packs intelligently without locking up brwose queue
 *
 * used for preloading
 *
 * this is on client for gc optimizations as src will be set to ourselves
 *
 * * do not use unless you know what you're doing
 */
/client/proc/asset_cache_native_preload(list/datum/asset_pack/packs, flush_on_how_many_packs = 3)
	var/datum/asset_transport/cached_transport = SSassets.transport
	var/packs_before_flush = flush_on_how_many_packs
	for(var/datum/asset_pack/pack as anything in packs)
		if(SSassets.transport != cached_transport)
			return
		if(!pack.is_pushed_to_transport())
			continue
		cached_transport.send_asset_item_native(src, pack.packed_items)
		stoplag(0) // do not lock up browse queue
		if(!(--packs_before_flush))
			packs_before_flush = flush_on_how_many_packs
			if(!asset_cache_flush_browse_queue(5 SECONDS))
				stack_trace("aborted native preload for [src] because they timed out on browse queue flush. did something break, or do they just have bad internet?")
