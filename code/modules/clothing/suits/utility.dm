/*
 * Contains:
 *		Fire protection
 *		Bomb protection
 *		Radiation protection
 */

/*
 * Fire protection
 */

/obj/item/clothing/suit/fire
	name = "firesuit"
	desc = "A suit that protects against fire and heat."
	icon_state = "fire"
	w_class = WEIGHT_CLASS_BULKY//bulky item
	gas_transfer_coefficient = 0.90
	permeability_coefficient = 0.50
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	encumbrance = ITEM_ENCUMBRANCE_ARMOR_FIRE_SUIT
	weight = ITEM_WEIGHT_ARMOR_FIRE_SUIT
	inv_hide_flags = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETAIL|HIDETIE|HIDEHOLSTER
	clothing_flags = 0
	heat_protection_cover = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	cold_protection_cover = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	min_pressure_protection = 0.2 * ONE_ATMOSPHERE
	max_pressure_protection = 20  * ONE_ATMOSPHERE


/obj/item/clothing/suit/fire/firefighter
	icon_state = "firesuit"

/*
 * Bomb protection
 */
/obj/item/clothing/head/bomb_hood
	name = "bomb hood"
	desc = "Use in case of bomb."
	icon_state = "bombsuit"
	armor_type = /datum/armor/station/bomb
	inv_hide_flags = HIDEMASK|HIDEEARS|HIDEEYES|BLOCKHAIR
	body_cover_flags = HEAD|FACE|EYES
	siemens_coefficient = 0
	encumbrance = ITEM_ENCUMBRANCE_ARMOR_BOMB_HELMET
	weight = ITEM_WEIGHT_ARMOR_BOMB_HELMET

/obj/item/clothing/suit/bomb_suit
	name = "bomb suit"
	desc = "A suit designed for safety when handling explosives."
	icon_state = "bombsuit"
	w_class = WEIGHT_CLASS_BULKY//bulky item
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	encumbrance = ITEM_ENCUMBRANCE_ARMOR_BOMB_SUIT
	weight = ITEM_WEIGHT_ARMOR_BOMB_SUIT
	armor_type = /datum/armor/station/bomb
	inv_hide_flags = HIDEJUMPSUIT|HIDETAIL|HIDETIE|HIDEHOLSTER
	heat_protection_cover = UPPER_TORSO|LOWER_TORSO
	max_heat_protection_temperature = ARMOR_MAX_HEAT_PROTECTION_TEMPERATURE
	siemens_coefficient = 0

/obj/item/clothing/head/bomb_hood/security
	icon_state = "bombsuitsec"
	body_cover_flags = HEAD

/obj/item/clothing/suit/bomb_suit/security
	icon_state = "bombsuitsec"
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS

/*
 * Radiation protection
 */
/obj/item/clothing/head/radiation
	name = "Radiation Hood"
	icon_state = "rad"
	desc = "A hood with radiation protective properties. Label: Made with lead, do not eat insulation"
	inv_hide_flags = BLOCKHAIR
	clothing_flags = CLOTHING_THICK_MATERIAL | CLOTHING_INJECTION_PORT
	body_cover_flags = HEAD|FACE|EYES
	armor_type = /datum/armor/general/radsuit
	weight = ITEM_WEIGHT_ARMOR_BIORAD_SUIT_HELMET
	encumbrance = ITEM_ENCUMBRANCE_ARMOR_BIORAD_HELMET
	worth_intrinsic = 75

/obj/item/clothing/suit/radiation
	name = "Radiation suit"
	desc = "A suit that protects against radiation. Label: Made with lead, do not eat insulation."
	icon_state = "rad"
	w_class = WEIGHT_CLASS_BULKY//bulky item
	gas_transfer_coefficient = 0.90
	permeability_coefficient = 0.50
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS|HANDS|FEET
	weight = ITEM_WEIGHT_ARMOR_BIORAD_SUIT
	armor_type = /datum/armor/general/radsuit
	inv_hide_flags = HIDEJUMPSUIT|HIDETAIL|HIDETIE|HIDEHOLSTER
	clothing_flags = CLOTHING_THICK_MATERIAL | CLOTHING_INJECTION_PORT
	encumbrance = ITEM_ENCUMBRANCE_ARMOR_BIORAD_SUIT
	worth_intrinsic = 250
