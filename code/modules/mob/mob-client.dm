//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * **never directly set ckey on a mob**
 *
 * use this to transfer
 *
 * @params
 * * allow_empty - allow transferring an empty client to another mob; otherwise this will silently fail
 */
/mob/proc/transfer_client_to(mob/transfer_to, allow_empty = FALSE)
	if(!ckey && !allow_empty)
		return FALSE
	if(client)
		pre_logout()
	// if they have a client, kick them out
	if(transfer_to.client)
		transfer_to.pre_logout()
	// transfer UIs before ckey swap
	SStgui.on_transfer(src, transfer_to)
	SSnanoui.user_transferred(src, transfer_to)
	// if we're logged in, client is transferred. if we're not, they'll log in at the other mob
	transfer_to.ckey = ckey
	return TRUE

/**
 * sets our ckey
 */
/mob/proc/set_ckey(ckey)
	var/client/resolved = GLOB.directory[ckey]
	// see if this is an active client
	if(resolved)
		// if it's the same client, don't do anything
		if(client == resolved)
			return TRUE
		// tell their mob the client is about to leave
		resolved.mob?.pre_logout()
	// if we have a client it isn't the same as the resolved one so that is going away
	if(client)
		pre_logout()
	// transfer
	src.ckey = ckey
	return TRUE
