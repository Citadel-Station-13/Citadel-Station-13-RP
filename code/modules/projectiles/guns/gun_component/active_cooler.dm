//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/obj/item/gun_component/active_cooler
	name = "weapon cooler"
	desc = "A basic cooling unit used in modular weaponry."
	icon = 'icons/modules/projectiles/components/active_cooler.dmi'
	component_slot = GUN_COMPONENT_ACTIVE_COOLER

/obj/item/gun_component/active_cooler/recovery
	name = "weapon cooler (recovery)"
	desc = {"
		A cooler that passes residual heat through a series of peltier cells to recover some of
		the energy used in firing. Very slow.
	"}

/obj/item/gun_component/active_cooler/powered
	name = "weapon cooler (powered)"
	desc = {"
		A cooler that pumps heat out of the gun using provided power.
	"}

/obj/item/gun_component/active_cooler/active_reload
	name = "weapon cooler (slide charging)"
	desc = {"
		A cooler that pumps heat out of the gun when a slide charging energy handler
		is racked. Has mediocre cooling performance otherwise.
	"}

// TODO: This file is mostly stubs and WIPs.
