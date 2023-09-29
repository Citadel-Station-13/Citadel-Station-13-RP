/datum/ghostrole_instantiator/existing/sapient_mob

/datum/ghostrole_instantiator/existing/sapient_mob/AfterSpawn(mob/created, mob/living/carbon/human/H, list/params)
	if(isliving(created))
		var/mob/living/L = created
		if(!IS_DEAD(L)) //normally being dead at this point shouldn't be possible because ghost roles will be deleted if the mob dies early but...
			L.rejuvenate()
			L.maxHealth = max(200,L.maxHealth) //sapient mobs have a higher will to live - makes more fragile mobs... less fragile.
			L.add_language(LANGUAGE_GALCOM) //talking dogs are real. thank you science.
			L.visible_message(SPAN_NOTICE("[created] shudders slightly as they seem to grow more aware of their surroundings!"))
			L.remove_ghostrole() //this feels dumb but I'm paranoid
	. = ..()



/datum/role/ghostrole/existing/sapient_mob
	name = "Sapient Creature"
	assigned_role = "Sapient Creature"
	desc = "You're a sapient creature!"
	spawntext = "Through some sort of unusual occurrence, be it an anomaly or an experiment gone wild, \
	you somehow became more intelligent than you once were. \
	Perhaps you've been made as intelligent as those humanoid beings you run into often, even. \
	You now see the world in a completely new perspective. Whether you're curious, happy, or scared of your new cognition is all up to you."
	important_info = "Try to reflect the attitude and personality of the creature that you became. \
	Though you can choose to eventually deviate from this after a while as your creature learns, \
	remember that what you used to be was something less intelligent then you are now!"
	instantiator = /datum/ghostrole_instantiator/existing/sapient_mob

/datum/role/ghostrole/existing/sapient_mob/xenobio
	name = "Sapience Agent Enlightened Creature"
	desc = "You're a sapient creature uplifted by someone by the power of xenobiology!"
	spawntext = "Through xenobiology's creations, you have been granted vast new intelligence and language you never had before. \
	Perhaps you've been made as intelligent as those humanoid beings all around you, even. \
	You now see the world in a completely new perspective. Whether you're curious, happy, or scared of your new cognition is all up to you. \
	You are thankful to those who have uplifted you, and will be passive towards them unless threatened."
	important_info = "Hold gratitude towards those who had uplifted you, but try to reflect the attitude and personality of the creature that you became. \
	Though you can choose to eventually deviate from this after a while as your creature learns, \
	remember that what you used to be was something less intelligent then you are now!"


