/datum/unit_test
	var/static/default_mobloc = null

/datum/unit_test/proc/create_test_mob(turf/mobloc = null, mobtype = /mob/living/carbon/human, with_mind = FALSE)
	if(isnull(mobloc))
		if(!default_mobloc)
			for(var/turf/simulated/floor/tiled/T in world) //evil? yes
				var/pressure = T.zone.air.return_pressure()
				if(90 < pressure && pressure < 120) // Find a turf between 90 and 120
					default_mobloc = T
					break
		mobloc = default_mobloc
	if(!mobloc)
		Fail("Unable to find a location to create test mob")
		return FALSE

	var/mob/living/carbon/human/H = new mobtype(mobloc)

	if(with_mind)
		H.mind_initialize("TestKey[rand(0,10000)]")

	return H

/datum/unit_test/space_suffocation
	var/startOxyloss
	var/endOxyloss
	var/mob/living/carbon/human/H

/datum/unit_test/space_suffocation/Run()
	var/turf/space/T = locate()

	H = new(T)
	startOxyloss = H.getOxyLoss()
	check_result()
	return 1

/datum/unit_test/space_suffocation/proc/check_result()
	if(H.life_tick < 10)
		return 0

	endOxyloss = H.getOxyLoss()

	if(!startOxyloss < endOxyloss)
		Fail("Human mob is not taking oxygen damage in space. (Before: [startOxyloss]; after: [endOxyloss])")

	qdel(H)
	return 1

/datum/unit_test/belly_nonsuffocation
	var/startLifeTick
	var/startOxyloss
	var/endOxyloss
	var/mob/living/carbon/human/pred
	var/mob/living/carbon/human/prey

/datum/unit_test/belly_nonsuffocation/Run()
	pred = create_test_mob()
	if(!istype(pred))
		return FALSE
	prey = create_test_mob(pred.loc)
	if(!istype(prey))
		return FALSE

	check_result()
	return TRUE

/datum/unit_test/belly_nonsuffocation/proc/check_result()
	// Unfortuantely we need to wait for the pred's belly to initialize. (Currently after a spawn())
	if(!pred.vore_organs || !pred.vore_organs.len)
		return FALSE

	// Now that pred belly exists, we can eat the prey.
	if(!pred.vore_selected)
		Fail("[pred] has no vore_selected.")
		return TRUE

	// Attempt to eat the prey
	if(prey.loc != pred.vore_selected)
		pred.vore_selected.nom_mob(prey)

		if(prey.loc != pred.vore_selected)
			Fail("[pred.vore_selected].nom_mob([prey]) did not put prey inside [pred]")
			return TRUE

		// Okay, we succeeded in eating them, now lets wait a bit
		startLifeTick = pred.life_tick
		startOxyloss = prey.getOxyLoss()
		return FALSE

	if(pred.life_tick < (startLifeTick + 10))
		return FALSE // Wait for them to breathe a few times

	// Alright lets check it!
	endOxyloss = prey.getOxyLoss()
	if(startOxyloss < endOxyloss)
		Fail("Prey takes oxygen damage in a pred's belly! (Before: [startOxyloss]; after: [endOxyloss])")
	qdel(prey)
	qdel(pred)
	return TRUE
////////////////////////////////////////////////////////////////
/datum/unit_test/belly_spacesafe
	var/startLifeTick
	var/startOxyloss
	var/startBruteloss
	var/endOxyloss
	var/endBruteloss
	var/mob/living/carbon/human/pred
	var/mob/living/carbon/human/prey

/datum/unit_test/belly_spacesafe/Run()
	pred = create_test_mob()
	if(!istype(pred))
		return FALSE
	prey = create_test_mob(pred.loc)
	if(!istype(prey))
		return FALSE
	check_result()
	return TRUE

/datum/unit_test/belly_spacesafe/proc/check_result()
	// Unfortuantely we need to wait for the pred's belly to initialize. (Currently after a spawn())
	if(!pred.vore_organs || !pred.vore_organs.len)
		return FALSE

	// Now that pred belly exists, we can eat the prey.
	if(!pred.vore_selected)
		Fail("[pred] has no vore_selected.")
		return TRUE

	// Attempt to eat the prey
	if(prey.loc != pred.vore_selected)
		pred.vore_selected.nom_mob(prey)

		if(prey.loc != pred.vore_selected)
			Fail("[pred.vore_selected].nom_mob([prey]) did not put prey inside [pred]")
			return TRUE
		else
			var/turf/T = locate(/turf/space)
			if(!T)
				Fail("could not find a space turf for testing")
				return TRUE
			else
				pred.forceMove(T)

		// Okay, we succeeded in eating them, now lets wait a bit
		startLifeTick = pred.life_tick
		startOxyloss = prey.getOxyLoss()
		// startBruteloss = prey.getBruteloss()
		return FALSE

	if(pred.life_tick < (startLifeTick + 10))
		return FALSE // Wait for them to breathe a few times

	// Alright lets check it!
	endOxyloss = prey.getOxyLoss()
	// endBruteloss = prey.getBruteLoss()
	// if(startBruteloss < endBruteloss)
	// 	Fail("Prey takes brute damage in space! (Before: [startBruteloss]; after: [endBruteloss])")
	if(startOxyloss < endOxyloss)
		Fail("Prey takes oxygen damage in space! (Before: [startOxyloss]; after: [endOxyloss])")

	qdel(prey)
	qdel(pred)
	return TRUE
////////////////////////////////////////////////////////////////
/datum/unit_test/belly_damage
	var/startLifeTick
	var/startBruteBurn
	var/endBruteBurn
	var/mob/living/carbon/human/pred
	var/mob/living/carbon/human/prey

/datum/unit_test/belly_damage/Run()
	pred = create_test_mob()
	if(!istype(pred))
		return FALSE
	prey = create_test_mob(pred.loc)
	if(!istype(prey))
		return FALSE
	check_result()
	return TRUE

/datum/unit_test/belly_damage/proc/check_result()
	// Unfortuantely we need to wait for the pred's belly to initialize. (Currently after a spawn())
	if(!pred.vore_organs || !pred.vore_organs.len)
		return FALSE

	// Now that pred belly exists, we can eat the prey.
	if(!pred.vore_selected)
		Fail("[pred] has no vore_selected.")
		return TRUE

	// Attempt to eat the prey
	if(prey.loc != pred.vore_selected)
		pred.vore_selected.nom_mob(prey)

		if(prey.loc != pred.vore_selected)
			Fail("[pred.vore_selected].nom_mob([prey]) did not put prey inside [pred]")
			return TRUE

		// Okay, we succeeded in eating them, now lets wait a bit
		pred.vore_selected.digest_mode = DM_DIGEST
		startLifeTick = pred.life_tick
		startBruteBurn = prey.getBruteLoss() + prey.getFireLoss()
		return FALSE

	if(pred.life_tick < (startLifeTick + 10))
		return FALSE // Wait a few ticks for damage to happen

	// Alright lets check it!
	endBruteBurn = prey.getBruteLoss() + prey.getFireLoss()
	if(startBruteBurn >= endBruteBurn)
		Fail("Prey doesn't take damage in digesting belly! (Before: [startBruteBurn]; after: [endBruteBurn])")

	qdel(prey)
	qdel(pred)
	return TRUE
