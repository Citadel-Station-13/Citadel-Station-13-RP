/obj/vehicle/sealed/mecha/combat/fighter/allure
	name = "\improper Allure"
	desc = "A fighter of Skrellian design. Its angular shape and wide overhead cross-section is made up for by it's stout armor and carefully crafted hull paint."
	icon = 'icons/mecha/fighters64x64.dmi'
	icon_state = "allure"
	initial_icon = "allure"

	catalogue_data = list(/datum/category_item/catalogue/technology/allure)
	wreckage = /obj/effect/decal/mecha_wreckage/allure

	ground_capable = FALSE

	integrity = 500
	integrity_max = 500

/obj/vehicle/sealed/mecha/combat/fighter/allure/loaded/Initialize(mapload) //Loaded version with guns
	. = ..()
	var/obj/item/vehicle_module/ME = new /obj/item/vehicle_module/cloak
	ME.attach(src)

/obj/vehicle/sealed/mecha/combat/fighter/allure/royalty
	name = "\improper Allure \"Royalty\""
	desc = "A limited edition purple design with gold inlay that embodies the same colorations and pattern designs of royalty skrellian during the time of the Allure's initial release."
	icon_state = "allure_royalty"
	initial_icon = "allure_royalty"
	wreckage = /obj/effect/decal/mecha_wreckage/allure/royalty

/obj/vehicle/sealed/mecha/combat/fighter/allure/royalty/loaded/Initialize(mapload) //Loaded version with guns
	. = ..()
	var/obj/item/vehicle_module/ME = new /obj/item/vehicle_module/cloak
	ME.attach(src)

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
