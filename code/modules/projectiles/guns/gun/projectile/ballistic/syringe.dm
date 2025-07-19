/obj/item/gun/projectile/ballistic/syringe
	name = "syringe gun"
	desc = "A spring loaded rifle designed to fit syringes, designed to incapacitate unruly patients from a distance."
	icon = 'icons/modules/projectiles/guns/ballistic/syringe.dmi'
	icon_state = "syringe"
	w_class = WEIGHT_CLASS_NORMAL
	materials_base = list(MAT_STEEL = 2000)
	damage_force = 7
	slot_flags = SLOT_BELT

	fire_sound = 'sound/weapons/empty.ogg'
	fire_sound_text = "a metallic thunk"
	recoil = 0

	internal_magazine_size = 1
	bolt_simulation = TRUE
	chamber_simulation = TRUE

/obj/item/gun/projectile/ballistic/syringe/rapid
	name = "syringe gun revolver"
	desc = "A modification of the syringe gun design, using a rotating cylinder to store up to five syringes. The spring still needs to be drawn between shots."
	icon_state = "syringe-rapid"
	internal_magazine_size = 5
	bolt_simulation = FALSE
	chamber_simulation = FALSE
