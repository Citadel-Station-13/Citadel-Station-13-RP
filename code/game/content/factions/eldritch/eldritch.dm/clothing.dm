//armor//


/obj/item/clothing/suit/storage/hooded/eldritch
	name = "Strange Robes"
	desc = "A set of robes, crafted from some sort of leather you've never seen before. Various runes have been etched into it."
	icon = 'icons/clothing/suit/antag/heretic.dmi'
	icon_state = "eldritcharmor"
	hoodtype = /obj/item/clothing/head/hood/eldritch
	w_class = WEIGHT_CLASS_NORMAL
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL
	clothing_flags = 0
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	allowed = list(/obj/item/tank/emergency/oxygen, /obj/item/flashlight,/obj/item/gun/projectile/energy, /obj/item/gun/projectile/ballistic, /obj/item/ammo_magazine, /obj/item/ammo_casing, /obj/item/melee/baton,/obj/item/handcuffs, /obj/item/eldritch/blade, /obj/item/eldritch/prop/codex)
	armor_type = /datum/armor/eldritch/robes
	inv_hide_flags = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETAIL
	cold_protection_cover = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	min_pressure_protection = 0 * ONE_ATMOSPHERE
	max_pressure_protection = 10 * ONE_ATMOSPHERE
	siemens_coefficient = 0.7

/obj/item/clothing/head/hood/eldritch
	name = "Strange Hood"
	desc = "A hood that comes attached to a set of robes. A few runes are etched into the leather."
	icon = 'icons/clothing/suit/antag/heretic.dmi'
	icon_state = "eldritchhood"
	body_cover_flags = HEAD
	cold_protection_cover = HEAD
	armor_type = /datum/armor/eldritch/robes
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	min_pressure_protection = 0 * ONE_ATMOSPHERE
	max_pressure_protection = 10 * ONE_ATMOSPHERE
	siemens_coefficient = 0.7

//-----//

//Standard//

/obj/item/clothing/under/simple
	icon = 'icons/mob/clothing/simple.dmi'


/obj/item/clothing/under/simple/trousers
	name = "leather trousers"
	desc = "A pair of thick and sturdy leather trousers."
	icon_state = "trousers"
