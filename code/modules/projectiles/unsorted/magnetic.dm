/obj/item/magnetic_ammo
	name = "flechette magazine"
	desc = "A magazine containing steel flechettes."

	icon = 'icons/modules/projectiles/magazines/old_magazine_stick.dmi'
	icon_state = "svtmag-1"

	w_class = WEIGHT_CLASS_SMALL
	materials_base = list(MAT_STEEL = 1800)
	origin_tech = list(TECH_COMBAT = 1)
	var/remaining = 9

/obj/item/magnetic_ammo/examine(mob/user, dist)
	. = ..()
	. += "There [(remaining == 1)? "is" : "are"] [remaining] flechette\s left!"
