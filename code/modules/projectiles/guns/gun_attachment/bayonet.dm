//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/obj/item/gun_attachment/bayonet
	abstract_type = /obj/item/gun_attachment/bayonet
	icon = 'icons/modules/projectiles/attachments/bayonet.dmi'

/obj/item/gun_attachment/bayonet/combat_knife
	name = "combat knife bayonet"
	desc = "A bayonet that's just a particularly tactical knife attached to a gun. Does do the job, though."
	// todo: prototype id. also, generic bayonet knife mount instead?
	icon_state = "combat-knife"
	align_x = 1
	align_y = 1

// todo: make this actually work; also, this should adapt to certain knives much like the maglight does.
