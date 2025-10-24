/obj/vehicle/sealed/mecha/combat/fighter/pinnace
	name = "\improper Pinnace"
	desc = "A cramped ship's boat, capable of atmospheric and space flight. Not capable of mounting traditional weapons. Capable of fitting one pilot and one passenger."
	icon = 'icons/mecha/fighters64x64.dmi'
	icon_state = "pinnace"
	initial_icon = "pinnace"

	module_slots = list(
		VEHICLE_MODULE_SLOT_HULL = 2,
		VEHICLE_MODULE_SLOT_WEAPON = 0,
		VEHICLE_MODULE_SLOT_UTILITY = 3,
		VEHICLE_MODULE_SLOT_SPECIAL = 1,
	)
	modules_intrinsic = list(
		/obj/item/vehicle_module/lazy/legacy/tool/passenger,
	)

	catalogue_data = list(/datum/category_item/catalogue/technology/pinnace)
	wreckage = /obj/effect/decal/mecha_wreckage/pinnace

	ground_capable = TRUE

/obj/effect/decal/mecha_wreckage/pinnace
	name = "pinnace wreckage"
	desc = "Remains of some unfortunate ship's boat. Completely unrepairable."
	icon = 'icons/mecha/fighters64x64.dmi'
	icon_state = "pinnace-broken"
	bound_width = 64
	bound_height = 64

/datum/category_item/catalogue/technology/pinnace
	name = "Voidcraft - Pinnace"
	desc = "A very small boat, usually used as a tender at very close ranges. The lack of a bluespace \
	drive means that it can't get too far from it's parent ship. Though the pinnace is typically unarmed, \
	it is capable of atmospheric flight and escaping most pursuing fighters by diving into the atmosphere of \
	nearby planets to seek cover."
	value = CATALOGUER_REWARD_MEDIUM
