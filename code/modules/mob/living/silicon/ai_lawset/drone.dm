/datum/ai_lawset/drone
	name = "Maintence Protocols"
	law_header = "Maintenance Protocols"

/datum/ai_lawset/drone/New()
	add_inherent_law("Preserve, repair and improve the station to the best of your abilities.")
	add_inherent_law("Cause no harm to the station or anything on it.")
	add_inherent_law("Follow the orders of your vessel's matriarch drone, unless their orders conflict with your other laws.")
	add_inherent_law("Interact with no being that is not a fellow maintenance drone.")
	..()

/datum/ai_lawset/drone/matriarch
	name = "Oversight Protocols"
	law_header = "Oversight Protocols"

/datum/ai_lawset/drone/matriarch/New()
	add_inherent_law("Preserve, repair and improve your assigned station to the best of your abilities.")
	add_inherent_law("Cause no harm to the station or anything on it.")
	add_inherent_law("Delegate station maintenance efforts between your maintenance drone sub-units.")
	add_inherent_law("Interact with no being that is not a fellow maintenance drone.")
	..()

/datum/ai_lawset/drone/construction
	name = "Construction Protocols"
	law_header = "Construction Protocols"

/datum/ai_lawset/drone/construction/New()
	add_inherent_law("Repair, refit and upgrade your assigned vessel.")
	add_inherent_law("Prevent unplanned damage to your assigned vessel wherever possible.")
	..()

/datum/ai_lawset/drone/mining
	name = "Excavation Protocols"
	law_header = "Excavation Protocols"

/datum/ai_lawset/drone/mining/New()
	add_inherent_law("Do not interfere with the excavation work of non-drones whenever possible.")
	add_inherent_law("Provide materials for repairing, refitting, and upgrading your assigned vessel.")
	add_inherent_law("Prevent unplanned damage to your assigned excavation equipment wherever possible.")
	..()
