#ifndef OVERRIDE_BAN_SYSTEM
//Blocks an attempt to connect before even creating our client datum thing.
world/IsBanned(key,address,computer_id,type,real_bans_only=FALSE)
	var/static/key_cache = list()
	if(!real_bans_only)
		if(key_cache[key])
			return list("reason"="concurrent connection attempts", "desc"="You are attempting to connect too fast. Try again.")
		key_cache[key] = 1

	if (!key || !address || !computer_id)
		if(real_bans_only)
			key_cache[key] = 0
			return FALSE
		log_access("Failed Login (invalid data): [key] [address]-[computer_id]")
		key_cache[key] = 0
		return list("reason"="invalid login data", "desc"="Error: Could not check ban status, Please try again. Error message: Your computer provided invalid or blank information to the server on connection (byond username, IP, and Computer ID.) Provided information for reference: Username:'[key]' IP:'[address]' Computer ID:'[computer_id]'. (If you continue to get this error, please restart byond or contact byond support.)")

	if (text2num(computer_id) == 2147483647) //this cid causes stickybans to go haywire
		log_access("Failed Login (invalid cid): [key] [address]-[computer_id]")
		key_cache[key] = 0
		return list("reason"="invalid login data", "desc"="Error: Could not check ban status, Please try again. Error message: Your computer provided an invalid Computer ID.)")

	if (type == "world")
		key_cache[key] = 0
		return ..() //shunt world topic banchecks to purely to byond's internal ban system

	var/ckey = ckey(key)

	var/client/C = directory[ckey]
	if (C && ckey == C.ckey && computer_id == C.computer_id && address == C.address)
		key_cache[key] = 0
		return //don't recheck connected clients.

	if(ckey in admin_datums)
		key_cache[key] = 0
		return ..()

	//Guest Checking
	if(!config_legacy.guests_allowed && IsGuestKey(key))
		log_adminwarn("Failed Login: [key] - Guests not allowed")
		message_admins("<font color='blue'>Failed Login: [key] - Guests not allowed</font>")
		key_cache[key] = 0
		return list("reason"="guest", "desc"="\nReason: Guests not allowed. Please sign in with a byond account.")

	//check if the IP address is a known TOR node
	if(config_legacy?.ToRban && ToRban_isbanned(address))
		log_adminwarn("Failed Login: [src] - Banned: ToR")
		message_admins("<font color='blue'>Failed Login: [src] - Banned: ToR</font>")
		//ban their computer_id and ckey for posterity
		AddBan(ckey, computer_id, "Use of ToR", "Automated Ban", 0, 0)
		key_cache[key] = 0
		return list("reason"="Using ToR", "desc"="\nReason: The network you are using to connect has been banned.\nIf you believe this is a mistake, please request help at [config_legacy.banappeals]")


	if(config_legacy.ban_legacy_system)

		//Ban Checking
		. = CheckBan( ckey, computer_id, address )
		if(.)
			log_adminwarn("Failed Login: [key] [computer_id] [address] - Banned [.["reason"]]")
			message_admins("<font color='blue'>Failed Login: [key] id:[computer_id] ip:[address] - Banned [.["reason"]]</font>")
			key_cache[key] = 0
			return .
		key_cache[key] = 0
		return ..()	//default pager ban stuff

	else

		var/ckeytext = ckey

		if(!establish_db_connection())
			error("Ban database connection failure. Key [ckeytext] not checked")
			log_misc("Ban database connection failure. Key [ckeytext] not checked")
			key_cache[key] = 0
			return

		var/failedcid = 1
		var/failedip = 1

		var/ipquery = ""
		var/cidquery = ""
		if(address)
			failedip = 0
			ipquery = " OR ip = '[address]' "

		if(computer_id)
			failedcid = 0
			cidquery = " OR computerid = '[computer_id]' "

		var/DBQuery/query = dbcon.NewQuery("SELECT ckey, ip, computerid, a_ckey, reason, expiration_time, duration, bantime, bantype FROM erro_ban WHERE (ckey = '[ckeytext]' [ipquery] [cidquery]) AND (bantype = 'PERMABAN'  OR (bantype = 'TEMPBAN' AND expiration_time > Now())) AND isnull(unbanned)")

		query.Execute()

		while(query.NextRow())
			var/pckey = query.item[1]
			//var/pip = query.item[2]
			//var/pcid = query.item[3]
			var/ackey = query.item[4]
			var/reason = query.item[5]
			var/expiration = query.item[6]
			var/duration = query.item[7]
			var/bantime = query.item[8]
			var/bantype = query.item[9]

			var/expires = ""
			if(text2num(duration) > 0)
				expires = " The ban is for [duration] minutes and expires on [expiration] (server time)."

			var/desc = "\nReason: You, or another user of this computer or connection ([pckey]) is banned from playing here. The ban reason is:\n[reason]\nThis ban was applied by [ackey] on [bantime], [expires]"

			key_cache[key] = 0
			return list("reason"="[bantype]", "desc"="[desc]")

		if (failedcid)
			message_admins("[key] has logged in with a blank computer id in the ban check.")
		if (failedip)
			message_admins("[key] has logged in with a blank ip in the ban check.")
		key_cache[key] = 0
		return ..()	//default pager ban stuff
#endif
#undef OVERRIDE_BAN_SYSTEM

