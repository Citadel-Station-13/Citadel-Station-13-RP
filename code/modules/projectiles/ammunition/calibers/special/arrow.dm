/datum/ammo_caliber/arrow
	id = "arrow"
	caliber = "arrow"

/obj/item/ammo_casing/arrow
	name = "arrow of questionable material"
	desc = "You shouldn't be seeing this arrow."
	projectile_type = /obj/projectile/bullet/reusable/arrow
	casing_caliber = /datum/ammo_caliber/arrow

	icon = 'icons/modules/projectiles/casings/arrow.dmi'
	icon_state = "arrow"
	icon_spent = FALSE

	throw_force = 3 //good luck hitting someone with the pointy end of the arrow
	throw_speed = 3

	casing_flags = CASING_DELETE

/obj/item/ammo_casing/arrow/wood
	name = "wooden arrow"
	desc = "An arrow made of wood, typically fired from a bow."

/obj/item/ammo_casing/arrow/bone
	name = "bone arrow"
	desc = "An arrow made of bone, knapped to a piercing tip."
	icon_state = "ashenarrow"
	projectile_type = /obj/projectile/bullet/reusable/arrow/bone

/obj/item/ammo_casing/arrow/ash
	name = "ashen arrow"
	desc = "An arrow made of wood, hardened by fire."
	icon_state = "ashenarrow"
	projectile_type = /obj/projectile/bullet/reusable/arrow/ash

/obj/item/ammo_casing/arrow/bone_ap
	name = "hardened bone arrow"
	desc = "An arrow made of bone and sinew. The tip is sharp enough to pierce through a goliath plate."
	icon_state = "bonearrow"
	projectile_type = /obj/projectile/bullet/reusable/arrow/bone_ap

/obj/item/ammo_casing/arrow/bronze
	name = "bronze arrow"
	desc = "An arrow made of wood, tipped with bronze. The tip is dense enough to provide some armor penetration."
	icon_state = "bronzearrow"
	projectile_type = /obj/projectile/bullet/reusable/arrow/bronze

/obj/item/ammo_casing/arrow/plunger
	name = "plunger"
	desc = "It's a plunger, for plunging."
	icon_state = "plunger"
	projectile_type = /obj/projectile/bullet/reusable/plunger
