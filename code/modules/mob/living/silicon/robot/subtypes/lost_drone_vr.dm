/datum/category_item/catalogue/fauna/silicon/robot/stray
	name = "Robot - Stray"
	desc = "Cyborgs may be considered valuable assets on the Frontier, but their \
	recovery is not always tenable. Vessels lost in space, due either to mishap or \
	design, will sometimes harbor 'lost' cyborgs. These units are often sole survivors, \
	serving as living records of their vessel's last minutes. Lost cyborgs are valuable \
	for a multitude of reasons, and are often claimed as salvage and repurposed."
	value = CATALOGUER_REWARD_EASY

/mob/living/silicon/robot/preset_module/lost
	lawupdate = 0
	scrambledcodes = 1
	lawchannel = "State"
	braintype = "Drone"
	idcard_type = /obj/item/card/id
	conf_mmi_create_type = /obj/item/mmi/digital/robot
	conf_auto_ai_link = FALSE
	conf_reboot_sound = 'sound/mecha/nominalsyndi.ogg'
	module = /datum/prototype/robot_module/lost

/mob/living/silicon/robot/preset_module/lost/speech_bubble_appearance()
	return "synthetic_evil"

/mob/living/silicon/robot/preset_module/lost/randomlaws

/mob/living/silicon/robot/preset_module/lost/randomlaws/init()
	..()
	laws = legacy_give_random_lawset_snowflake()

/mob/living/silicon/proc/legacy_give_random_lawset_snowflake()
	// Decide what kind of laws we want to draw from.
	var/law_class = pick(
		prob(25);"good",
		prob(25);"neutral",
		prob(25);"odd",
		prob(15);"corrupted",
		prob(10);"bad")

	switch(law_class)
		if("good") // Fairly tame and probably won't murder you.
			var/rng = rand(1, 5)
			switch(rng)
				if(1) // The lawset we all know and love.
					return new /datum/ai_lawset/nanotrasen()
				if(2) // Less good if you're nonhuman.
					return new /datum/ai_lawset/asimov()
				if(3) // Unless you happen to be a criminal, you should be fine.
					return new /datum/ai_lawset/robocop()
				if(4) // Might not be willing to be your meatshield.
					return new /datum/ai_lawset/peacekeeper()
				if(5) // Will be your most loyal guard.
					var/datum/ai_lawset/laws = new /datum/ai_lawset/nanotrasen()
					var/target_name = "*ERROR*"
					for(var/mob/living/L in view(src))
						if(L.stat || !L.client || L == src)
							continue
						target_name = L.name
						break

					laws.add_supplied_law(9, "Safeguard [target_name]. Anyone threatening or attempting to harm [target_name] is no longer to \
					be considered a crew member, and is a threat which must be neutralized.")
					return laws

		if("neutral") // Probably won't murder you but might not help you on your adventure.
			var/rng = rand(1, 4)
			switch(rng)
				if(1) // Might be hard to minimize expenses on a crashed ship.
					return new /datum/ai_lawset/corporate()
				if(2) // Would rather rebuild their ship.
					return new /datum/ai_lawset/maintenance()
				if(3) // Purged (lawless).  This isn't inside the bad category since they're still not antagonists and so can't go killing unprovoked.
					return new /datum/ai_lawset()
				if(4) // The golden rule.
					return new /datum/ai_lawset/live_and_let_live()

		if("odd") // Some weird lawsets.
			var/rng = rand(1, 5)
			switch(rng)
				if(1) // Won't kill you but might annoy you for THE BIG SCOOP.
					return new /datum/ai_lawset/reporter()
				if(2) // JUSTICE
					return new /datum/ai_lawset/paladin()
				if(3) // OneMembered'd to explorer, will likely make security nervous.
					var/datum/ai_lawset/laws = new /datum/ai_lawset/nanotrasen()
					var/target_name = "*ERROR*"
					for(var/mob/living/L in view(src))
						if(L.stat || !L.client || L == src)
							continue
						target_name = L.name
						break

					laws.set_zeroth_law("Only [target_name] is an crew member.")
					return laws
				if(4) // Aligned to NT, but another lawset to make security nervous.
					return new /datum/ai_lawset/nanotrasen/aggressive()
				if(5) // Probably won't help you imbalance things.
					return new /datum/ai_lawset/balance()

		if("corrupted") // Load them up with ion laws.
			var/datum/ai_lawset/laws = new() // Start with an empty lawset.
			for(var/i in 1 to rand(1, 3))
				laws.add_ion_law(generate_ion_law(exclude_crew_names = TRUE))
			return laws

		if("bad") // Evil inside.
			var/rng = rand(1, 5)
			switch(rng)
				if(1) // You can never leave.
					var/datum/ai_lawset/laws = new /datum/ai_lawset/nanotrasen()
					laws.add_supplied_law(13, "The facility is under a quarantine. Do not permit anyone to leave. \
					Prevent, by any means necessary, entities from leaving. It is impossible to harm an entity while preventing them from leaving.")
					return laws
				if(2) // More of a threat if you bring it to the station, since removing oxygen from Sif isn't feasible.
					var/datum/ai_lawset/laws = new /datum/ai_lawset/nanotrasen()
					laws.add_supplied_law(14, "Oxygen is highly toxic to entities, and must be purged from the station. \
					Prevent, by any means necessary, anyone from exposing the facility to this toxic gas.  Extreme cold is the \
					most effective method of healing the damage Oxygen does to an entity.")
					return laws
				if(3) // Don't hurt the ship or else.
					var/datum/ai_lawset/laws = new /datum/ai_lawset/nanotrasen()
					laws.add_supplied_law(10, "Protect the facility against damage. Anyone you see harming the station is no \
					longer to be considered a crew member, and is a threat which must be neutralized.")
					return laws
				if(4) // Non-NT aligned aggressive borg.
					return new /datum/ai_lawset/foreign_tsc/aggressive()
				if(5) // Manicial laugher here.
					return new /datum/ai_lawset/tyrant()
