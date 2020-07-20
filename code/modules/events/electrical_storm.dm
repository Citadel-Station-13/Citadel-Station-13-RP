/*
/datum/event/electrical_storm
	var/lightsoutAmount	= 1
	var/lightsoutRange	= 25


/datum/event/electrical_storm/announce()
	command_announcement.Announce("An electrical issue has been detected in your area, please repair potential electronic overloads.", "Electrical Alert")


/datum/event/electrical_storm/start()
	var/list/epicentreList = list()

	for(var/i=1, i <= lightsoutAmount, i++)
		var/list/possibleEpicentres = list()
		for(var/obj/effect/landmark/newEpicentre in landmarks_list)
			if(newEpicentre.name == "lightsout" && !(newEpicentre in epicentreList))
				possibleEpicentres += newEpicentre
		if(possibleEpicentres.len)
			epicentreList += pick(possibleEpicentres)
		else
			break

	if(!epicentreList.len)
		return

	for(var/obj/effect/landmark/epicentre in epicentreList)
		for(var/obj/machinery/power/apc/apc in range(epicentre,lightsoutRange))
			apc.overload_lighting()

// OLD VERSION ABOVE. TESTING PORT FROM VORE CODE
*/

/datum/event/electrical_storm
	announceWhen = 0		// Warn them shortly before it begins.
	startWhen = 15			// 30 seconds
	endWhen = 30			// Set in setup() Reduced from 60
	var/tmp/lightning_color
	var/tmp/list/valid_apcs		// List of valid APCs.

/datum/event/electrical_storm/announce()
	..()
	switch(severity)
		if(EVENT_LEVEL_MUNDANE)
			command_announcement.Announce("A minor electrical storm has been detected near the station. Please watch out for possible electrical discharges.", "Weather Sensor Array")
		if(EVENT_LEVEL_MODERATE)
			command_announcement.Announce("The station is about to pass through an electrical storm. Please secure sensitive electrical equipment until the storm passes.", "Weather Sensor Array")
		if(EVENT_LEVEL_MAJOR)
			command_announcement.Announce("A strong electrical storm has been detected in proximity of the station. It is recommended to immediately secure sensitive electrical equipment until the storm passes.", "Weather Sensor Array")

/datum/event/electrical_storm/start()
	..()
	valid_apcs = list()
	for(var/obj/machinery/power/apc/A in global.machines)
		valid_apcs.Add(A)
	endWhen = (severity * 30) + startWhen // Reducing endWhen by half

/datum/event/electrical_storm/tick()
	..()
	// See if shields can stop it first (It would be nice to port baystation's cooler shield gens perhaps)
	// TODO - We need a better shield generator system to handle this properly.
	if(!valid_apcs.len)
		log_debug("No valid APCs found for electrical storm event!")
		return
	var/list/picked_apcs = list()
	for(var/i=0, i< severity * 3, i++) // up to 3/6/9 APCs per tick depending on severity
		picked_apcs |= pick(valid_apcs)
	for(var/obj/machinery/power/apc/T in picked_apcs)
		affect_apc(T)

/datum/event/electrical_storm/proc/affect_apc(var/obj/machinery/power/apc/T)
	// Main breaker is turned off. Consider this APC protected.
	if(!T.operating)
		return

	// Decent chance to overload lighting circuit.
	if(prob(5 * severity))
		T.overload_lighting()

	// Relatively small chance to emag the apc as apc_damage event does.
	if(prob(0.2 * severity))
		T.emagged = 1
		T.update_icon()