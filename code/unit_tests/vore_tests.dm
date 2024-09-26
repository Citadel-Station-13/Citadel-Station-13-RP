/datum/unit_test
	var/static/default_mobloc = null

/datum/unit_test/proc/stupid_vore_test_mob(var/turf/mobloc = null, var/mobtype = /mob/living/carbon/human, var/with_mind = FALSE)
	if(isnull(mobloc))
		if(!default_mobloc)
			for(var/turf/simulated/floor/tiled/T in world)
				var/pressure = T.zone.air.return_pressure()
				if(90 < pressure && pressure < 120) // Find a turf between 90 and 120
					default_mobloc = T
					break
		mobloc = default_mobloc
	if(!mobloc)
		fail("Unable to find a location to create test mob")
		return 0

	var/mob/living/carbon/human/H = allocate(/mob/living/carbon/human, mobloc)

	if(with_mind)
		H.mind_initialize("TestKey[rand(0,10000)]")

	return H

/datum/unit_test/belly_nonsuffocation
	name = "MOB: human mob does not suffocate in a belly"
	var/startLifeTick
	var/startOxyloss
	var/endOxyloss
	var/mob/living/carbon/human/pred
	var/mob/living/carbon/human/prey

/datum/unit_test/belly_nonsuffocation/Run()
	pred = stupid_vore_test_mob()
	if(!istype(pred))
		Fail("Pred allocation failed")
		return
	prey = stupid_vore_test_mob(pred.loc)
	if(!istype(prey))
		Fail("Prey allocation failed")
		return

	if(!pred.vore_organs || !pred.vore_organs.len)
		Fail("Pred or prey had no vore organs")
		return

	// Now that pred belly exists, we can eat the prey.
	if(!pred.vore_selected)
		Fail("[pred] has no vore_selected.")
		return

	// Attempt to eat the prey
	if(prey.loc != pred.vore_selected)
		pred.vore_selected.nom_mob(prey)

		if(prey.loc != pred.vore_selected)
			Fail("[pred.vore_selected].nom_mob([prey]) did not put prey inside [pred]")
			return

		// Okay, we succeeded in eating them, now lets wait a bit
		startLifeTick = pred.life_tick
		startOxyloss = prey.getOxyLoss()

	sleep(10 SECONDS)

	// Alright lets check it!
	endOxyloss = prey.getOxyLoss()
	if(startOxyloss < endOxyloss)
		Fail("Prey takes oxygen damage in a pred's belly! (Before: [startOxyloss]; after: [endOxyloss])")

////////////////////////////////////////////////////////////////
/datum/unit_test/belly_spacesafe
	name = "MOB: human mob protected from space in a belly"
	var/startLifeTick
	var/startOxyloss
	var/endOxyloss
	var/mob/living/carbon/human/pred
	var/mob/living/carbon/human/prey
	async = 1

/datum/unit_test/belly_spacesafe/Run()
	pred = stupid_vore_test_mob()
	if(!istype(pred))
		Fail("Allocation failed")
		return
	prey = stupid_vore_test_mob(pred.loc)
	if(!istype(prey))
		Fail("Allocation failed")
		return

	sleep(10 SECONDS)

	if(!pred.vore_organs || !pred.vore_organs.len)
		Fail("No vore organs in pred or prey")
		return

	// Now that pred belly exists, we can eat the prey.
	if(!pred.vore_selected)
		Fail("[pred] has no vore_selected.")
		return

	// Attempt to eat the prey
	if(prey.loc != pred.vore_selected)
		pred.vore_selected.nom_mob(prey)

		if(prey.loc != pred.vore_selected)
			Fail("[pred.vore_selected].nom_mob([prey]) did not put prey inside [pred]")
			return
		else
			var/turf/T = locate(/turf/space)
			if(!T)
				Fail("could not find a space turf for testing")
				return
			else
				pred.forceMove(T)

		// Okay, we succeeded in eating them, now lets wait a bit
		startLifeTick = pred.life_tick
		startOxyloss = prey.getOxyLoss()

	sleep(10 SECONDS)

	// Alright lets check it!
	endOxyloss = prey.getOxyLoss()
	if(startOxyloss < endOxyloss)
		Fail("Prey takes oxygen damage in space! (Before: [startOxyloss]; after: [endOxyloss])")

////////////////////////////////////////////////////////////////
/datum/unit_test/belly_damage
	name = "MOB: human mob takes damage from digestion"
	var/startLifeTick
	var/startBruteBurn
	var/endBruteBurn
	var/mob/living/carbon/human/pred
	var/mob/living/carbon/human/prey
	async = 1

/datum/unit_test/belly_damage/Run()
	pred = stupid_vore_test_mob()
	if(!istype(pred))
		Fail("Allocation failed")
		return
	prey = stupid_vore_test_mob(pred.loc)
	if(!istype(prey))
		Fail("Allocation failed")
		return

	sleep(10 SECONDS)

	if(!pred.vore_organs || !pred.vore_organs.len)
		Fail("No vore organs in pred or prey")
		return

	// Now that pred belly exists, we can eat the prey.
	if(!pred.vore_selected)
		Fail("[pred] has no vore_selected.")
		return

	// Attempt to eat the prey
	if(prey.loc != pred.vore_selected)
		pred.vore_selected.nom_mob(prey)

		if(prey.loc != pred.vore_selected)
			Fail("[pred.vore_selected].nom_mob([prey]) did not put prey inside [pred]")
			return 1

		// Okay, we succeeded in eating them, now lets wait a bit
		pred.vore_selected.digest_mode = DM_DIGEST
		startLifeTick = pred.life_tick
		startBruteBurn = prey.getBruteLoss() + prey.getFireLoss()

	sleep(10 SECONDS)

	// Alright lets check it!
	endBruteBurn = prey.getBruteLoss() + prey.getFireLoss()
	if(startBruteBurn >= endBruteBurn)
		Fail("Prey doesn't take damage in digesting belly! (Before: [startBruteBurn]; after: [endBruteBurn])")
