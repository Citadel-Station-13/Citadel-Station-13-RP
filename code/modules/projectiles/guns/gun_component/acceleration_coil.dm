//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/obj/item/gun_component/acceleration_coil
	name = "weapon acceleration coil"
	desc = "A basic acceleration coil used in magnetic weapons."
	icon = 'icons/modules/projectiles/components/acceleration_coil.dmi'
	component_slot = GUN_COMPONENT_ACCELERATION_COIL

/obj/item/gun_component/acceleration_coil/heater
	name = "weapon acceleration coil (heater)"
	desc = {"
		A magnetic acceleration coil designed to superheat a passing projectile, resulting
		in subtly raised penetration performance and a searing property to impacts.
		This does not have the intended effect on all projectiles.
	"}

/obj/item/gun_component/acceleration_coil/overcharger
	name = "weapon acceleration coil (overcharger)"
	desc = {"
		A magnetic acceleration coil designed to overcharge a passing projectile. This has minimal effect
		on projectiles not equipped to handle a charge.
	"}

// TODO: This file is mostly stubs and WIPs.
