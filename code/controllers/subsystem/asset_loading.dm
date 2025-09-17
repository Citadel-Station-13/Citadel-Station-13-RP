/**
 * Allows us to lazyload asset datums.
 * Anything inserted here will fully load if directly gotten.
 * So this just serves to remove the requirement to load assets fully during init.
 */
SUBSYSTEM_DEF(asset_loading)
	name = "Asset Loading"
	priority = FIRE_PRIORITY_ASSET_LOADING
	// todo: hibernation
	subsystem_flags = SS_NO_INIT | SS_BACKGROUND
	runlevels = RUNLEVEL_LOBBY | RUNLEVELS_DEFAULT

	/// things waiting to be loaded
	var/list/datum/asset_pack/loading = list()

/datum/controller/subsystem/asset_loading/proc/queue_asset_pack(datum/asset_pack/asset)
	if(asset.loaded != ASSET_NOT_LOADED)
		return
	loading += asset

/datum/controller/subsystem/asset_loading/fire(resumed)
	while(length(loading))
		var/datum/asset_pack/instance = loading[loading.len]
		loading.len--
		instance.ensure_ready(TRUE)
		if(MC_TICK_CHECK)
			return
