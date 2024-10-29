//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/obj/item/gun_attachment/harness

/obj/item/gun_attachment/harness/magnetic
	name = "magnetic harness"
	desc = "A fancy harness that will snap a gun back to an attachment point when it's dropped by its wearer."
	icon = 'icons/modules/projectiles/attachments/harness.dmi'
	icon_state = "magnetic"
	align_x = 15
	align_x = 16

/obj/item/gun_attachment/harness/magnetic/on_attach(obj/item/gun/gun)
	..()

/obj/item/gun_attachment/harness/magnetic/on_detach(obj/item/gun/gun)
	..()

#warn impl; render if it's active with an action button
