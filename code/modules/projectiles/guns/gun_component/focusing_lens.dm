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

	/// divides a beam to this number of parallel beams
	var/divide_by = 1
	/// this is extremely dangerous and i advise you not to mess with it
	/// * the default is enough to make this worth it as a damage upgrade
	///   without making it too op. if you set this to a ridiculous value like 2,
	///   i will replace your eyelids with limes.
	var/cheat_factor = 1

/obj/item/gun_component/focusing_lens/divide_by/two
	name = "weapon focusing lens (2-linear multiplexer)"
	divide_by = 2
	cheat_factor = 1.15

/obj/item/gun_component/focusing_lens/divide_by/three
	name = "weapon focusing lens (3-linear multiplexer)"
	divide_by = 3
	cheat_factor = 1.3

#warn impl
