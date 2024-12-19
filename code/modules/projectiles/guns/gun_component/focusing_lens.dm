//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/obj/item/gun_component/focusing_lens
	name = "weapon focusing lens"
	desc = "A standard focusing lens used in energy weapons."
	icon = 'icons/modules/projectiles/components/focusing_lens.dmi'
	component_slot = GUN_COMPONENT_FOCUSING_LENS

// TODO: This file is mostly stubs and WIPs.

/obj/item/gun_component/focusing_lens/divide_by
	name = "weapon focusing lens (linear multiplexer)"
	desc = {"
		A special focusing lens that multiplexes a passing particle beam.
	"}
	component_type = /obj/item/gun_component/focusing_lens/divide_by
	var/divide_by = 1

/obj/item/gun_component/focusing_lens/divide_by/two
	name = "weapon focusing lens (2-linear multiplexer)"
	divide_by = 2

/obj/item/gun_component/focusing_lens/divide_by/three
	name = "weapon focusing lens (3-linear multiplexer)"
	divide_by = 3

#warn impl
