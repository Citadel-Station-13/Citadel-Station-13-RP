/turf
	CanAtmosPass = ATMOS_PASS_NO
	CanAtmosPassVertical = ATMOS_PASS_NO
	CanZonePass = ZONE_PASS_NO
	CanZonePassVertical = ZONE_PASS_NO

//ZAS simulated/unsimulated stuff
/turf/simulated/floor
	CanAtmosPass = ATMOS_PASS_PROC
	CanAtmosPassVertical = ATMOS_PASS_PROC
	CanZonePass = ZONE_PASS_PROC
	CanZonePassVertical = ZONE_PASS_NO

//ZAS CanAtmosPass stuff
/turf/CanAtmosPass(turf/T, vertical = FALSE)
	//Really simplified, doesn't have ~~LINDA EFFICIENCY~~
	var/blocked = FALSE
	if(blocks_air || T.blocks_air)
		blocked = TRUE
	if(T == src)
		return !blocked
	for(var/obj/O in contents + T.contents)
		var/turf/other = (O.loc == src? T : src)
		if(!CANATMOSPASS(O, other))
			blocked = TRUE
			break
		//Blah blah I dont' care about superconduct checks right now
	return TRUE

/turf/CanZonePass(turf/T, vertical = FALSE)
	//Really simplified, doesn't have ~~LINDA EFFICIENCY~~
	var/blocked = FALSE
	if(blocks_air || T.blocks_air)
		blocked = TRUE
	if(T == src)
		return !blocked
	for(var/obj/O in contents + T.contents)
		var/turf/other = (O.loc == src? T : src)
		if(!CANZONEPASS(O, other))
			blocked = TRUE
			break
		//Blah blah I dont' care about superconduct checks right now
	return TRUE


/turf/open/CanAtmosPass(turf/T, vertical = FALSE)
	var/dir = vertical? get_dir_multiz(src, T) : get_dir(src, T)
	var/opp = dir_inverse_multiz(dir)
	var/R = FALSE
	if(vertical && !(zAirOut(dir, T) && T.zAirIn(dir, src)))
		R = TRUE
	if(blocks_air || T.blocks_air)
		R = TRUE
	if (T == src)
		return !R
	for(var/obj/O in contents+T.contents)
		var/turf/other = (O.loc == src ? T : src)
		if(!(vertical? (CANVERTICALATMOSPASS(O, other)) : (CANATMOSPASS(O, other))))
			R = TRUE
			if(O.BlockSuperconductivity()) 	//the direction and open/closed are already checked on CanAtmosPass() so there are no arguments
				atmos_supeconductivity |= dir
				T.atmos_supeconductivity |= opp
				return FALSE						//no need to keep going, we got all we asked

	atmos_supeconductivity &= ~dir
	T.atmos_supeconductivity &= ~opp

	return !R
