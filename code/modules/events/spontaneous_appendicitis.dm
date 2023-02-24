/datum/event/spontaneous_appendicitis/start()
	for(var/mob/living/carbon/human/H in shuffle(living_mob_list))
		var/area/A = get_area(H)
		if(!A)
			continue
		if(!(A.z in GLOB.using_map.station_levels))
			continue
		if(A.area_flags & AREA_RAD_SHIELDED)
			continue
		if(H.client && H.appendicitis())
			break
