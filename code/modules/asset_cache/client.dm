/client
	/// asset cache: filename = md5, for things already sent to the client
	/// this is only for browse_rsc()'d assets.
	var/list/assets_received = list()
	/// used for browse_queue_fluhs()
	var/list/asset_flush_jobs = list()
	/// last flush job id
	var/asset_flush_last_id
	/// last time an asset flush was verified
	var/asset_flush_last_completed

/client/on_new_hook_stability_checks()
	// ensure asset cache is there
	INVOKE_ASYNC(src, PROC_REF(warn_if_no_asset_cache_browser))
	return ..()

/client/proc/warn_if_no_asset_cache_browser()
	if(!winexists(src, "asset_cache_browser")) // The client is using a custom skin, tell them.
		to_chat(src, "<span class='warning'>Unable to access asset cache browser, if you are using a custom skin file, please allow DS to download the updated version, if you are not, then make a bug report. This is not a critical issue but can cause issues with resource downloading, as it is impossible to know when extra resources arrived to you.</span>")

/client/on_topic_hook(raw_href, list/href_list, raw_src)
	. = ..()
	if(.)
		return

	var/asset_cache_job
	if(href_list["asset_cache_confirm_arrival"])
		. = TRUE
		asset_cache_job = asset_cache_confirm_arrival(href_list["asset_cache_confirm_arrival"])
		if (asset_cache_job)
			//byond bug ID:2256651
			if (asset_cache_job in completed_asset_jobs)
				to_chat(src, "<span class='danger'>An error has been detected in how your client is receiving resources. Attempting to correct.... (If you keep seeing these messages you might want to close byond and reconnect)</span>")
				src << browse("...", "window=asset_cache_browser")

/// Process asset cache client topic calls for `"asset_cache_confirm_arrival=[INT]"`
/client/proc/asset_cache_confirm_arrival(job_id)
	var/asset_cache_job = round(text2num(job_id))
		//because we skip the limiter, we have to make sure this is a valid arrival and not somebody tricking us into letting them append to a list without limit.
	if (asset_cache_job > 0 && asset_cache_job <= last_asset_job && !(completed_asset_jobs["[asset_cache_job]"]))
		completed_asset_jobs["[asset_cache_job]"] = TRUE
		last_completed_asset_job = max(last_completed_asset_job, asset_cache_job)
	else
		return asset_cache_job || TRUE

#warn figure this shit out

/// Blocks until all currently sending browse and browse_rsc assets have been sent.
/// Due to byond limitations, this proc will sleep for 1 client round trip even if the client has no pending asset sends.
/// This proc will return an untrue value if it had to return before confirming the send, such as timeout or the client going away.
/client/proc/asset_cache_flush_browse_queue(timeout = 50)
	var/job = ++asset_flush_last_id
	var/timeout_time = world.time + timeout
	src << browse({"<script>window.location.href="?asset_cache_confirm_arrival=[job]"</script>"}, "window=asset_cache_browser&file=asset_cache_send_verify.htm")

	while(!asset_flush_jobs["[job]"] && world.time < timeout_time) // Reception is handled in Topic()
		stoplag(1) // Lock up the caller until this is received.

	return !!asset_flush_jobs["[job]"]
