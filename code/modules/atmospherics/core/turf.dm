/turf
	CanAtmosPass = ATMOS_PASS_NO
	CanAtmosPassVertical = ATMOS_PASS_NO
	CanZonePass = ZONE_PASS_NO
	CanZonePassVertical = ZONE_PASS_NO
	var/blocks_air = TRUE
	var/blocks_zone = TRUE
	var/initial_gas_mix			//Initial gas string

//ZAS simulated/unsimulated stuff
/turf/simulated/floor
	CanAtmosPass = ATMOS_PASS_PROC
	CanAtmosPassVertical = ATMOS_PASS_PROC
	CanZonePass = ZONE_PASS_PROC
	CanZonePassVertical = ZONE_PASS_PROC
	blocks_air = FALSE
	blocks_zone = FALSE
	var/datum/gas_mixture/air
	var/datum/atmos_zone/zone

//ZAS CanAtmosPass stuff
/turf/CanAtmosPass(turf/T, vertical = FALSE)
	var/dir = vertical? get_dir_multiz(src, T) : get_dir(src, T)
	var/opp = dir_inverse_multiz(dir)
	if(blocks_air || T.blocks_air)
		return FALSE
	if(vertical && !(zAirOut(dir, T) && T.zAirIn(dir, src)))
		return FALSE
	for(var/obj/O in contents + T.contents)
		var/turf/other = (O.loc == src? T : src)
		if(!CANATMOSPASS(O, other))
			return FALSE
	return TRUE

/turf/CanZonePass(turf/T, vertical = FALSE)
	var/dir = vertical? get_dir_multiz(src, T) : get_dir(src, T)
	var/opp = dir_inverse_multiz(dir)
	if(blocks_zone || T.blocks_zone)
		return FALSE
	if(vertical && !(zZoneOut(dir, T) && T.zZoneIn(dir, src)))
		return FALSE
	for(var/obj/O in contents + T.contents)
		var/turf/other = (O.loc == src? T : src)
		if(!CANZONEPASS(O, other))
			return FALSE
	return TRUE

//MultiZ turf handling
/turf/proc/zAirOut(dir, turf/T)
	return FALSE

/turf/proc/zAirIn(dir, turf/T)
	return FALSE

/turf/proc/zZoneOut(dir, turf/T)
	return FALSE

/turf/proc/zZoneIn(dir, turf/T)
	return FALSE

/turf/proc/setup_atmospherics()
	setup_gasmix(TRUE)						//Sets up air mixture and parses initial gas string
	setup_zone()							//Sets up zone

/turf/proc/setup_gasmix(initial = FALSE)

/turf/proc/setup_zone()
	if(zone)
		return
	zone = new(src, TRUE)

