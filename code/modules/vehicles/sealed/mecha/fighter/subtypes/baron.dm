/obj/vehicle/sealed/mecha/fighter/baron
	name = "\improper Baron"
	desc = "A conventional space superiority fighter, one-seater. Not capable of ground operations."
	icon = 'icons/mecha/fighters64x64.dmi'
	icon_state = "baron"
	initial_icon = "baron"

	integrity = /obj/vehicle/sealed/mecha/fighter::integrity * 1.5
	integrity_max = /obj/vehicle/sealed/mecha/fighter::integrity_max * 1.5
	comp_armor_relative_thickness = 1.33 * /obj/vehicle/sealed/mecha/fighter::comp_armor_relative_thickness
	comp_hull_relative_thickness = 1.33 * /obj/vehicle/sealed/mecha/fighter::comp_hull_relative_thickness


	catalogue_data = list(/datum/category_item/catalogue/technology/baron)
	wreckage = /obj/effect/decal/mecha_wreckage/baron

	flight_works_in_gravity = FALSE

/obj/vehicle/sealed/mecha/fighter/baron/equipped
	modules = list(
		/obj/item/vehicle_module/lazy/legacy/weapon/energy/laser,
		/obj/item/vehicle_module/shield_projector/omnidirectional,
	)

/obj/effect/decal/mecha_wreckage/baron
	name = "Baron wreckage"
	desc = "Remains of some unfortunate fighter. Completely unrepairable."
	icon = 'icons/mecha/fighters64x64.dmi'
	icon_state = "baron-broken"
	bound_width = 64
	bound_height = 64

/obj/vehicle/sealed/mecha/fighter/baron/security
	name = "\improper Baron-SV"
	desc = "A conventional space superiority fighter, one-seater. Not capable of ground operations. The Baron-SV (Security Variant) is frequently used by NT Security forces during EVA patrols."

/obj/vehicle/sealed/mecha/fighter/baron/security/equipped
	modules = list(
		/obj/item/vehicle_module/lazy/legacy/weapon/energy/laser,
		/obj/item/vehicle_module/lazy/legacy/weapon/energy/phase,
	)

/datum/category_item/catalogue/technology/baron
	name = "Voidcraft - Baron"
	desc = "This is a small space fightercraft that has an arrowhead design. Can hold up to one pilot. \
	Unlike some fighters, this one is not designed for atmospheric operation, and is only capable of performing \
	maneuvers in the vacuum of space. Attempting flight while in an atmosphere is not recommended."
	value = CATALOGUER_REWARD_MEDIUM
