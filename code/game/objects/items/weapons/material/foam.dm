/obj/item/material/twohanded/baseballbat/foam/New(var/newloc)
	..(newloc,"foam")

/obj/item/material/sword/foam
	attack_verb = list("bonked","whacked")
	force_divisor = 1
	force = 1
	unbreakable = 1

/obj/item/material/twohanded/baseballbat/foam
	attack_verb = list("bonked","whacked")
	force_wielded = 1
	force_divisor = 1
	force = 1
	unbreakable = 1

/obj/item/material/sword/foam/New(var/newloc)
	..(newloc,"foam")

/obj/item/material/twohanded/spear/foam
	attack_verb = list("bonked","whacked")
	force_wielded = 1
	force_divisor = 1
	force = 1
	applies_material_color = 1
	base_icon = "spear_mask"
	icon_state = "spear_mask0"
	unbreakable = 1

/obj/item/material/twohanded/spear/foam/New(var/newloc)
	..(newloc,"foam")
/*
/obj/item/material/twohanded/fireaxe/foam
	attack_verb = list("bonked","whacked")
	force_wielded = 1
	force_divisor = 1
	force = 1
	applies_material_color = 1
	base_icon = "fireaxe_mask"
	icon_state = "fireaxe_mask0"
	unbreakable = 1
	sharp = 0
	edge = 0
	can_cleave = FALSE
	desc = "This is a toy version of the mighty fire axe! Charge at your friends for maximum enjoyment while screaming at them."
	description_info = "This is a toy version of the mighty fire axe! Charge at your friends for maximum enjoyment while screaming at them."

/obj/item/material/twohanded/fireaxe/foam/New(var/newloc)
	..(newloc,"foam")

/obj/item/material/twohanded/fireaxe/foam/afterattack()
	return
*/
