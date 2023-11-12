/obj/item/material/star
	name = "shuriken"
	desc = "A sharp, perfectly weighted piece of metal."
	icon_state = "star"
	move_resist = MOVE_RESIST_SHURIKEN
	throw_resist = THROW_RESIST_SHURIKEN
	throw_speed_scaling_exponential = THROW_SPEED_SCALING_CONSTANT_DEFAULT * 1.5
	throw_damage_scaling_exponential = THROW_DAMAGE_SCALING_CONSTANT_DEFAULT * 1.5
	damage_mode = DAMAGE_MODE_SHARP | DAMAGE_MODE_EDGE

/obj/item/material/star/Initialize(mapload, material_key)
	. = ..()
	src.pixel_x = rand(-12, 12)
	src.pixel_y = rand(-12, 12)

/obj/item/material/star/ninja
	material_parts = /datum/material/uranium

/obj/item/material/star/plasteel
	material_parts = /datum/material/plasteel

/obj/item/material/star/durasteel
	material_parts = /datum/material/durasteel
