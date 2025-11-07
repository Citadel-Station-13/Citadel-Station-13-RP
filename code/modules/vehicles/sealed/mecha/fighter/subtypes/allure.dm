/obj/vehicle/sealed/mecha/fighter/allure
	name = "\improper Allure"
	desc = "A fighter of Skrellian design. Its angular shape and wide overhead cross-section is made up for by it's stout armor and carefully crafted hull paint."
	icon = 'icons/mecha/fighters64x64.dmi'
	icon_state = "allure"
	initial_icon = "allure"

	catalogue_data = list(/datum/category_item/catalogue/technology/allure)
	wreckage = /obj/effect/decal/mecha_wreckage/allure

	integrity = /obj/vehicle/sealed/mecha/fighter::integrity * 1.25
	integrity_max = /obj/vehicle/sealed/mecha/fighter::integrity_max * 1.25
	comp_armor_relative_thickness = 1.45 * /obj/vehicle/sealed/mecha/fighter::comp_armor_relative_thickness
	comp_hull_relative_thickness = 1.45 * /obj/vehicle/sealed/mecha/fighter::comp_hull_relative_thickness

	ground_capable = FALSE

	integrity = 500
	integrity_max = 500

/obj/vehicle/sealed/mecha/fighter/allure/equipped
	modules = list(
		/obj/item/vehicle_module/lazy/legacy/cloak,
	)

/obj/vehicle/sealed/mecha/fighter/allure/royalty
	name = "\improper Allure \"Royalty\""
	desc = "A limited edition purple design with gold inlay that embodies the same colorations and pattern designs of royalty skrellian during the time of the Allure's initial release."
	icon_state = "allure_royalty"
	initial_icon = "allure_royalty"
	wreckage = /obj/effect/decal/mecha_wreckage/allure/royalty

/obj/vehicle/sealed/mecha/fighter/allure/royalty/equipped
	modules = list(
		/obj/item/vehicle_module/lazy/legacy/cloak,
	)

/obj/effect/decal/mecha_wreckage/allure
	name = "allure wreckage"
	desc = "Remains of some unfortunate fighter. Completely unrepairable."
	icon = 'icons/mecha/fighters64x64.dmi'
	icon_state = "allure-broken"
	bound_width = 64
	bound_height = 64

/obj/effect/decal/mecha_wreckage/allure/royalty
	icon_state = "allure_royalty-broken"

/datum/category_item/catalogue/technology/allure
	name = "Voidcraft - Allure"
	desc = "A space superiority fighter of Skrellian design. Its angular shape and wide overhead cross-section is made up for by it's stout armor and carefully crafted hull paint. \
	Import craft like this one often ship with no weapons, though the Skrell saw fit to integrate a cloaking device."
	value = CATALOGUER_REWARD_MEDIUM
