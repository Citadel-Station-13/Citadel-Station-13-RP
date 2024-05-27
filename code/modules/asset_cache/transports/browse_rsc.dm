/**
 * Basic asset transport, via browse_rsc()
 */
/datum/asset_transport/browse_rsc
	name = "asset-transport: browse_rsc()"

/datum/asset_transport/browse_rsc

/datum/asset_transport/browse_rsc/send_anonymous_file(list/client/targets, file)
	return send_anonymous_file_native(client/targets, file)
