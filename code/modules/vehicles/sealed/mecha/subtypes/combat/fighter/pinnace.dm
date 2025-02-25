/obj/vehicle/sealed/mecha/combat/fighter/pinnace
	name = "\improper Pinnace"
	desc = "A cramped ship's boat, capable of atmospheric and space flight. Not capable of mounting traditional weapons. Capable of fitting one pilot and one passenger."
	icon = 'icons/mecha/fighters64x64.dmi'
	icon_state = "pinnace"
	initial_icon = "pinnace"

	max_hull_equip = 1
	max_weapon_equip = 0
	max_utility_equip = 1
	max_universal_equip = 0
	max_special_equip = 1

	catalogue_data = list(/datum/category_item/catalogue/technology/pinnace)
	wreckage = /obj/effect/decal/mecha_wreckage/pinnace

	ground_capable = TRUE

/obj/vehicle/sealed/mecha/combat/fighter/pinnace/loaded/Initialize(mapload) //Loaded version with guns
	. = ..()
	var/obj/item/vehicle_module/ME = new /obj/item/vehicle_module/tool/passenger
	ME.attach(src)

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
