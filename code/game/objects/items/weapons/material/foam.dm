/obj/item/material/twohanded/baseballbat/foam/Initialize(mapload, material_key)
	return ..(mapload,"foam")

/obj/item/material/sword/foam
	attack_verb = list("bonked","whacked")
	force_divisor = 1
	force = 0
	unbreakable = 1
	drop_sound = 'sound/items/drop/device.ogg'
	pickup_sound = 'sound/items/pickup/device.ogg'
	hitsound = 'sound/effects/bodyfall3.ogg'

/obj/item/material/twohanded/baseballbat/foam
	attack_verb = list("bonked","whacked")
	force_wielded = 0
	force_divisor = 1
	force = 0
	unbreakable = 1
	drop_sound = 'sound/items/drop/device.ogg'
	pickup_sound = 'sound/items/pickup/device.ogg'
	hitsound = 'sound/effects/bodyfall3.ogg'

/obj/item/material/sword/foam/Initialize(mapload, material_key)
	return ..(mapload,"foam")

/obj/item/material/twohanded/spear/foam
	attack_verb = list("bonked","whacked")
	force_wielded = 0
	force_divisor = 1
	force = 0
	applies_material_colour = 1
	base_icon = "spear_mask0"
	icon_state = "spear_mask0"
	unbreakable = 1
	drop_sound = 'sound/items/drop/device.ogg'
	pickup_sound = 'sound/items/pickup/device.ogg'
	hitsound = 'sound/effects/bodyfall3.ogg'

/obj/item/material/twohanded/spear/foam/Initialize(mapload, material_key)
	return ..(mapload,"foam")

/obj/item/material/twohanded/fireaxe/foam
	attack_verb = list("bonked","whacked")
	force_wielded = 0
	force_divisor = 1
	force = 0
	applies_material_colour = 1
	base_icon = "fireaxe_mask0"
	icon_state = "fireaxe_mask0"
	unbreakable = 1
	sharp = 0
	edge = 0
	can_cleave = FALSE
	desc = "This is a toy version of the mighty fire axe! Charge at your friends for maximum enjoyment while screaming at them."
	description_info = "This is a toy version of the mighty fire axe! Charge at your friends for maximum enjoyment while screaming at them."
	drop_sound = 'sound/items/drop/device.ogg'
	pickup_sound = 'sound/items/pickup/device.ogg'
	hitsound = 'sound/effects/bodyfall3.ogg'

/obj/item/material/twohanded/fireaxe/foam/Initialize(mapload, material_key)
	..(mapload,"foam")

/obj/item/material/twohanded/fireaxe/foam/afterattack()
	return
