/obj/vehicle/sealed/mecha/combat/fighter/cludge
	name = "\improper Cludge"
	desc = "A heater, nozzle, and fuel tank strapped together. There are exposed wires strewn about it."
	icon = 'icons/mecha/fighters64x64.dmi'
	icon_state = "cludge"
	initial_icon = "cludge"

	integrity = 100
	integrity_max = 100

	max_hull_equip = 0
	max_weapon_equip = 0
	max_utility_equip = 0
	max_universal_equip = 0
	max_special_equip = 0

	catalogue_data = list(/datum/category_item/catalogue/technology/cludge)
	wreckage = /obj/effect/decal/mecha_wreckage/cludge

	ground_capable = TRUE

/obj/effect/decal/mecha_wreckage/cludge
	name = "Cludge wreckage"
	desc = "It doesn't look much different than it normally does. Completely unrepairable."
	icon = 'icons/mecha/fighters64x64.dmi'
	icon_state = "cludge-broken"
	bound_width = 64
	bound_height = 64

/datum/category_item/catalogue/technology/cludge
	name = "Voidcraft - Cludge"
	desc = "A collection of parts strapped together in an attempt to make a flying vessel. Such vessels are fragile, unstable \
	and very easily break apart, due to their roughshod engineering. These vessels commonly are built without critical components \
	such as life support, or armor plating."
	value = CATALOGUER_REWARD_MEDIUM
