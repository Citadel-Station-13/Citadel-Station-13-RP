/datum/ghostrole_instantiator/existing/sapient_mob

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
	slots = 1
	allow_pick_spawner = TRUE

/datum/role/ghostrole/existing/sapient_mob/xenobio
	name = "Sapience Agent Enlightened Creature"
	desc = "You're a sapient creature uplifted by someone by the power of xenobiology!"
	spawntext = "Through xenobiology's creations, you have been granted vast new intelligence and language you never had before. \
	Perhaps you've been made as intelligent as those humanoid beings all around you, even. \
	You now see the world in a completely new perspective. Whether you're curious, happy, or scared of your new cognition is all up to you."
	important_info = "Hold gratitude towards those who had uplifted you, but try to reflect the attitude and personality of the creature that you became. \
	Though you can choose to eventually deviate from this after a while as your creature learns, \
	remember that what you used to be was something less intelligent then you are now!"
	var/intellect_granter //the person who fed them the sapience agent

