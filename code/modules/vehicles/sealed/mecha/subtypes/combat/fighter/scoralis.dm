/obj/vehicle/sealed/mecha/combat/fighter/scoralis
	name = "\improper Scoralis"
	desc = "An imported space fighter with integral cloaking device. Beware the power consumption, though. Not capable of ground operations."
	icon = 'icons/mecha/fighters64x64.dmi'
	icon_state = "scoralis"
	initial_icon = "scoralis"

	catalogue_data = list(/datum/category_item/catalogue/technology/scoralis)
	wreckage = /obj/effect/decal/mecha_wreckage/scoralis

	ground_capable = FALSE

/obj/vehicle/sealed/mecha/combat/fighter/scoralis/loaded/Initialize(mapload) //Loaded version with guns
	. = ..()
	var/obj/item/vehicle_module/ME = new /obj/item/vehicle_module/weapon/ballistic/lmg
	ME.attach(src)
	ME = new /obj/item/vehicle_module/cloak
	ME.attach(src)

/obj/effect/decal/mecha_wreckage/scoralis
	name = "scoralis wreckage"
	desc = "Remains of some unfortunate fighter. Completely unrepairable."
	icon = 'icons/mecha/fighters64x64.dmi'
	icon_state = "scoralis-broken"
	bound_width = 64
	bound_height = 64

/datum/category_item/catalogue/technology/scoralis
	name = "Voidcraft - Scoralis"
	desc = "An import model fightercraft, this one contains an integral cloaking device that renders the fighter invisible \
	to the naked eye. Still detectable on thermal sensors, the craft can maneuver in close to ill-equipped foes and strike unseen. \
	Not rated for atmospheric travel, this craft excels at hit and run tactics, as it will likely need to recharge batteries between each 'hit'."
	value = CATALOGUER_REWARD_MEDIUM
