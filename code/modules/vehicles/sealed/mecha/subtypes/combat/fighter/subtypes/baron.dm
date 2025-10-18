/obj/vehicle/sealed/mecha/combat/fighter/baron
	name = "\improper Baron"
	desc = "A conventional space superiority fighter, one-seater. Not capable of ground operations."
	icon = 'icons/mecha/fighters64x64.dmi'
	icon_state = "baron"
	initial_icon = "baron"

	integrity = 600
	integrity_max = 600

	catalogue_data = list(/datum/category_item/catalogue/technology/baron)
	wreckage = /obj/effect/decal/mecha_wreckage/baron

	ground_capable = FALSE

/obj/vehicle/sealed/mecha/combat/fighter/baron/equipped
	modules = list(
		/obj/item/vehicle_module/weapon/energy/laser,
		/obj/item/vehicle_module/omni_shield,
	)

/obj/effect/decal/mecha_wreckage/baron
	name = "Baron wreckage"
	desc = "Remains of some unfortunate fighter. Completely unrepairable."
	icon = 'icons/mecha/fighters64x64.dmi'
	icon_state = "baron-broken"
	bound_width = 64
	bound_height = 64

/obj/vehicle/sealed/mecha/combat/fighter/baron/security
	name = "\improper Baron-SV"
	desc = "A conventional space superiority fighter, one-seater. Not capable of ground operations. The Baron-SV (Security Variant) is frequently used by NT Security forces during EVA patrols."

/obj/vehicle/sealed/mecha/combat/fighter/baron/security/equipped
	modules = list(
		/obj/item/vehicle_module/weapon/energy/laser,
		/obj/item/vehicle_module/weapon/energy/phase,
	)

/datum/category_item/catalogue/technology/baron
	name = "Voidcraft - Baron"
	desc = "This is a small space fightercraft that has an arrowhead design. Can hold up to one pilot. \
	Unlike some fighters, this one is not designed for atmospheric operation, and is only capable of performing \
	maneuvers in the vacuum of space. Attempting flight while in an atmosphere is not recommended."
	value = CATALOGUER_REWARD_MEDIUM
