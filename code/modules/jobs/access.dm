
/// Returns 1 if this mob has sufficient access to use this object
/obj/proc/allowed(mob/M)
	if(IsAdminGhost(M))
		return TRUE
	//check if it doesn't require any access at all
	if(src.check_access(null))
		return 1

	var/id = M.GetIdCard()
	if(id)
		return check_access(id)
	return 0

///obj/item/proc/GetAccess()
//	return list()

/atom/movable/proc/GetAccess()
	var/obj/item/card/id/id = GetIdCard()
	return id ? id.GetAccess() : list()

/obj/proc/GetID()
	return null

/obj/proc/check_access(obj/item/I)
	return check_access_list(I ? I.GetAccess() : list())

/obj/proc/check_access_list(var/list/L)
	if(!L)
		return 0
	if(!istype(L, /list))
		return 0
	return has_access(req_access, req_one_access, L)

/proc/has_access(var/list/req_access, var/list/req_one_access, var/list/accesses)
	var/has_RA = LAZYLEN(req_access)
	var/has_ROA = LAZYLEN(req_one_access)
	var/has_A = LAZYLEN(accesses)
	if(!has_RA && !has_ROA)		//we need none
		return TRUE
	if(!has_A)					//we need them but don't have them
		return FALSE
	if(has_RA && length(req_access - accesses))			//we don't have every access we need
		return FALSE
	if(has_ROA && !length(req_one_access & accesses))	//we have atleast one access from this list
		return FALSE
	return TRUE

/proc/get_centcom_access(job)
	switch(job)
		if("VIP Guest")
			return list(ACCESS_CENTCOM_GENERAL)
		if("Custodian")
			return list(ACCESS_CENTCOM_GENERAL, ACCESS_CENTCOM_DORMS, ACCESS_CENTCOM_STORAGE)
		if("Thunderdome Overseer")
			return list(ACCESS_CENTCOM_GENERAL, ACCESS_CENTCOM_THUNDERDOME)
		if("Intel Officer")
			return list(ACCESS_CENTCOM_GENERAL, ACCESS_CENTCOM_DORMS)
		if("Medical Officer")
			return list(ACCESS_CENTCOM_GENERAL, ACCESS_CENTCOM_DORMS, ACCESS_CENTCOM_MEDICAL)
		if("Death Commando")
			return list(ACCESS_CENTCOM_GENERAL, ACCESS_CENTCOM_ERT, ACCESS_CENTCOM_DORMS, ACCESS_CENTCOM_STORAGE)
		if("Research Officer")
			return list(ACCESS_CENTCOM_GENERAL, ACCESS_CENTCOM_ERT, ACCESS_CENTCOM_MEDICAL, ACCESS_CENTCOM_TELEPORTER, ACCESS_CENTCOM_STORAGE)
		if("BlackOps Commander")
			return list(ACCESS_CENTCOM_GENERAL, ACCESS_CENTCOM_THUNDERDOME, ACCESS_CENTCOM_ERT, ACCESS_CENTCOM_DORMS, ACCESS_CENTCOM_STORAGE, ACCESS_CENTCOM_ERT_LEAD)
		if("Supreme Commander")
			return get_all_centcom_access()

/proc/get_access_ids(access_types = ACCESS_TYPE_ALL)
	// todo: remove this proc
	RETURN_TYPE(/list)
	return SSjob.access_ids_of_type(access_types)

/proc/get_all_accesses()
	// todo: remove this proc
	RETURN_TYPE(/list)
	return SSjob.access_ids_of_type(ACCESS_TYPE_ALL)

/proc/get_all_station_access()
	// todo: remove this proc
	RETURN_TYPE(/list)
	return SSjob.access_ids_of_type(ACCESS_TYPE_STATION)

/proc/get_all_centcom_access()
	// todo: remove this proc
	RETURN_TYPE(/list)
	return SSjob.access_ids_of_type(ACCESS_TYPE_CENTCOM)

/proc/get_all_syndicate_access()
	// todo: remove this proc
	RETURN_TYPE(/list)
	return SSjob.access_ids_of_type(ACCESS_TYPE_SYNDICATE)

/proc/get_all_private_access()
	// todo: remove this proc
	RETURN_TYPE(/list)
	return SSjob.access_ids_of_type(ACCESS_TYPE_PRIVATE)

/proc/get_region_accesses(region)
	// todo: remove this proc
	RETURN_TYPE(/list)
	return SSjob.access_ids_of_region(region)

/proc/get_region_accesses_name(var/code)
	// todo: remove this proc
	switch(code)
		if(ACCESS_REGION_ALL)
			return "All"
		if(ACCESS_REGION_SECURITY) //security
			return "Security"
		if(ACCESS_REGION_MEDBAY) //medbay
			return "Medbay"
		if(ACCESS_REGION_RESEARCH) //research
			return "Research"
		if(ACCESS_REGION_ENGINEERING) //engineering and maintenance
			return "Engineering"
		if(ACCESS_REGION_COMMAND) //command
			return "Command"
		if(ACCESS_REGION_GENERAL) //station general
			return "Station General"
		if(ACCESS_REGION_SUPPLY) //supply
			return "Supply"

/proc/get_access_desc(id)
	// todo: remove this proc
	return SSjob.access_lookup(id)?.access_name

/proc/get_centcom_access_desc(A)
	// todo: remove this proc
	return get_access_desc(A)

/proc/get_access_by_id(id)
	// todo: remove this proc
	return SSjob.access_lookup(id)

/proc/get_all_centcom_jobs()
	// todo: remove this proc
	return list("VIP Guest",
		"Custodian",
		"Thunderdome Overseer",
		"Intel Officer",
		"Medical Officer",
		"Death Commando",
		"Research Officer",
		"BlackOps Commander",
		"Supreme Commander",
		"Emergency Response Team",
		"Emergency Response Team Leader")

/atom/movable/proc/GetIdCard()
	return null

/mob/living/bot/GetIdCard()
	return botcard

/mob/living/carbon/human/GetIdCard()
	if(get_active_held_item())
		var/obj/item/I = get_active_held_item()
		var/id = I.GetID()
		if(id)
			return id
	if(wear_id)
		var/id = wear_id.GetID()
		if(id)
			return id

/mob/living/silicon/GetIdCard()
	return idcard

/proc/FindNameFromID(var/mob/living/carbon/human/H)
	ASSERT(istype(H))
	var/obj/item/card/id/C = H.GetIdCard()
	if(C)
		return C.registered_name

/proc/get_all_job_icons() //For all existing HUD icons
	return SSjob.all_job_titles() + list("Prisoner")

/obj/proc/GetJobName() //Used in secHUD icon generation
	var/obj/item/card/id/I = GetID()

	if(I)
		if(istype(I,/obj/item/card/id/centcom))
			return "Centcom"

		var/job_icons = get_all_job_icons()
		if(I.assignment	in job_icons) //Check if the job has a hud icon
			return I.assignment
		if(I.rank in job_icons)
			return I.rank

		var/centcom = get_all_centcom_jobs()
		if(I.assignment	in centcom) //Return with the NT logo if it is a CentCom job
			return "CentCom"
		if(I.rank in centcom)
			return "CentCom"
	else
		return

	return "Unknown" //Return unknown if none of the above apply
