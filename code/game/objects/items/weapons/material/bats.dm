/obj/item/material/twohanded/baseballbat
	name = "bat"
	desc = "From the former United States of America, this weapon was used in an old sport known as 'baseball'. It's made for hitting high-speed balls, but it's often re-purposed for knocking someone's lights out."
	icon_state = "metalbat0"
	base_icon = "metalbat"
	throw_force = 7
	attack_verb = list("smashed", "beaten", "slammed", "smacked", "struck", "battered", "bonked")
	attack_sound = 'sound/weapons/genhit3.ogg'
	material_parts = /datum/prototype/material/wood_plank
	material_significance = MATERIAL_SIGNIFICANCE_WEAPON_MEDIUM
	slot_flags = SLOT_BACK

// Predefined materials go here.
/obj/item/material/twohanded/baseballbat/metal/Initialize(mapload, material_key)
	return ..(mapload,"steel")

/obj/item/material/twohanded/baseballbat/uranium/Initialize(mapload, material_key)
	return ..(mapload,"uranium")

/obj/item/material/twohanded/baseballbat/gold/Initialize(mapload, material_key)
	return ..(mapload,"gold")

/obj/item/material/twohanded/baseballbat/platinum/Initialize(mapload, material_key)
	return ..(mapload,"platinum")

/obj/item/material/twohanded/baseballbat/diamond/Initialize(mapload, material_key)
	return ..(mapload,"diamond")

/obj/item/material/twohanded/baseballbat/plasteel/Initialize(mapload, material_key)
	return ..(mapload,"plasteel")

/obj/item/material/twohanded/baseballbat/durasteel/Initialize(mapload, material_key)
	return ..(mapload,"durasteel")

/obj/item/material/twohanded/baseballbat/penbat
	name = "penetrator"
	desc = "I won't dignify this one with a description."
	icon_state = "penbat0"
	base_icon = "penbat"
	attack_verb = list("smacked", "slapped", "thwapped", "struck", "bapped", "bonked")
	material_parts = /datum/prototype/material/plastic
