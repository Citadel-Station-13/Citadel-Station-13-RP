//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

//* Stealthmin *//

/**
 * get effective ckey for render, respecting stealth keys
 */
/client/proc/get_public_key()
	return holder?.fakekey || deadmin_holder?.fakekey || key

/**
 * gets effective ckey & stealth key for render
 */
/client/proc/get_revealed_key()
	if(!(holder?.fakekey || deadmin_holder?.fakekey))
		return key
	var/fake_ckey = holder?.fakekey || deadmin_holder?.fakekey || "INVALID-KEY"
	return "[fake_ckey]/([key])"

/**
 * should we be under stealthmin
 */
/client/proc/is_under_stealthmin()
	return !!(holder?.fakekey || deadmin_holder?.fakekey)
