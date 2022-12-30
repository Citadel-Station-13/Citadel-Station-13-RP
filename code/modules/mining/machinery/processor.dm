/obj/machinery/ore_processor
	name = "ore processor"
	icon = 'icons/modules/mining/machinery/smelter.dmi'
	icon_state = "processor"
	#warn icon in dmi
	#warn impl desc etc
	density = TRUE
	anchored = TRUE
	#warn handle direction with state?
	resistance_flags = INDESTRUCTIBLE // dropping all that ore will probably crash the server
	#warn machinery processing brackets - tone it the fuck down if we're not active too
	#warn buildable, circuit, anchoring

	/// are we processing?
	var/smelting = FALSE
	/// stored ores by ore id
	var/list/stored = list()
	/// ore id to processing mode
	var/list/ores_processing = list()
	/// stored mining points
	var/points = 0
	/// attempt to smelt this many *ores* per tick - rounds *UP*
	var/smelt_rate = 4

#warn impl

/obj/machinery/ore_processor/process(delta_time)

	#warn impl

	// prechecks done
	// intake
	var/turf/input = get_step(src, turn(dir, 180))
	var/limit_in = 50
	for(var/obj/item/ore/O in input)
		if(!--limit_in)
			break
		stored[O.ore_id] += 1
	// output
	if(!length(ores_processing))
		return
	var/turf/output = get_step(src, dir)
	var/list/attempting_alloy = list()
	// smelt regular
	for(var/id in ores_processing)
		var/datum/ore/ore = SSmaterials.get_ore(id)
		if(id == ORE_PROCESS_ALLOY)
			// we do this after ore fetch to convert it to string id
			attempting_alloy[ore.id] = ore
			continue
		var/result_id
		var/result_amount
		switch(id)
			if(ORE_PROCESS_SMELT)
				result_id = ore.smelts_to
				result_amount = (ore.smelt_ratio || ore.product_ratio) * min(smelt_rate, stored[id])
			if(ORE_PROCESS_COMPRESS)
				result_id = ore.compresses_to
				result_amount = (ore.compress_ratio || ore.product_ratio) * min(smelt_rate, stored[id])
			if(ORE_PROCESS_PULVERIZE)
				result_id = ore.pulverizes_to
				result_amount = (ore.pulverize_ratio || ore.product_ratio) * min(smelt_rate, stored[id])
			#warn above result_amount needs to round UP
		#warn impl
	// smelt alloy
	// alloying is a little hugboxy
	// we smelt exactly the alloy we try for, if we run out we don't slag/waste materials.
	var/datum/alloy/found
	var/not_this
	for(var/datum/alloy/A as anything in GLOB.ore_alloy_recipes)
		not_this = FALSE
		for(var/id in A.requires)
			if(!attempting_alloy[id])
				not_this = TRUE
				break
		if(not_this)
			continue
		found = A
		break
	#warn finish
