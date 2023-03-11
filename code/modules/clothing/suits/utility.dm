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
	w_class = ITEMSIZE_LARGE//bulky item
	gas_transfer_coefficient = 0.90
	permeability_coefficient = 0.50
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	allowed = list(/obj/item/flashlight,/obj/item/tank/emergency/oxygen,/obj/item/extinguisher)
	slowdown = 1.0
	inv_hide_flags = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETAIL|HIDETIE|HIDEHOLSTER
	clothing_flags = 0
	heat_protection = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	cold_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	min_pressure_protection = 0.2 * ONE_ATMOSPHERE
	max_pressure_protection = 20  * ONE_ATMOSPHERE


/obj/item/clothing/suit/fire/firefighter
	icon_state = "firesuit"

/obj/item/clothing/suit/fire/heavy //Is this even used?? -S2-
	name = "firesuit"
	desc = "A suit that protects against extreme fire and heat."
	//icon_state = "thermal"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "black_suit", SLOT_ID_LEFT_HAND = "black_suit")
	w_class = ITEMSIZE_LARGE//bulky item
	slowdown = 1.5

/*
 * Bomb protection
 */
/obj/item/clothing/head/bomb_hood
	name = "bomb hood"
	desc = "Use in case of bomb."
	icon_state = "bombsuit"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 100, bio = 0, rad = 0)
	inv_hide_flags = HIDEMASK|HIDEEARS|HIDEEYES|BLOCKHAIR
	body_cover_flags = HEAD|FACE|EYES
	siemens_coefficient = 0

/obj/item/clothing/suit/bomb_suit
	name = "bomb suit"
	desc = "A suit designed for safety when handling explosives."
	icon_state = "bombsuit"
	w_class = ITEMSIZE_LARGE//bulky item
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	slowdown = 2
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 100, bio = 0, rad = 0)
	inv_hide_flags = HIDEJUMPSUIT|HIDETAIL|HIDETIE|HIDEHOLSTER
	heat_protection = UPPER_TORSO|LOWER_TORSO
	max_heat_protection_temperature = ARMOR_MAX_HEAT_PROTECTION_TEMPERATURE
	siemens_coefficient = 0

/obj/item/clothing/head/bomb_hood/security
	icon_state = "bombsuitsec"
	body_cover_flags = HEAD

/obj/item/clothing/suit/bomb_suit/security
	icon_state = "bombsuitsec"
	allowed = list(/obj/item/gun/ballistic/sec/flash, /obj/item/gun/energy,/obj/item/melee/baton,/obj/item/handcuffs)
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS

/*
 * Radiation protection
 */
/obj/item/clothing/head/radiation
	name = "Radiation Hood"
	icon_state = "rad"
	desc = "A hood with radiation protective properties. Label: Made with lead, do not eat insulation"
	inv_hide_flags = BLOCKHAIR
	clothing_flags = THICKMATERIAL
	body_cover_flags = HEAD|FACE|EYES
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 60, rad = 100)

/obj/item/clothing/suit/radiation
	name = "Radiation suit"
	desc = "A suit that protects against radiation. Label: Made with lead, do not eat insulation."
	icon_state = "rad"
	w_class = ITEMSIZE_LARGE//bulky item
	gas_transfer_coefficient = 0.90
	permeability_coefficient = 0.50
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS|HANDS|FEET
	allowed = list(/obj/item/flashlight,/obj/item/tank/emergency/oxygen,/obj/item/clothing/head/radiation,/obj/item/clothing/mask/gas)
	slowdown = 1.5
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 60, rad = 100)
	inv_hide_flags = HIDEJUMPSUIT|HIDETAIL|HIDETIE|HIDEHOLSTER
	clothing_flags = THICKMATERIAL
