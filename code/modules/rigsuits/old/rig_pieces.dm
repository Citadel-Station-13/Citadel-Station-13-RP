/*
 * Defines the helmets, gloves and shoes for rigs.
 */

/obj/item/clothing/head/helmet/space/hardsuit
	name = "helmet"
	atom_flags = PHORONGUARD
	inv_hide_flags      = HIDEEARS|HIDEEYES|HIDEFACE|BLOCKHAIR

	max_pressure_protection = null
	min_pressure_protection = null

/obj/item/clothing/shoes/magboots/hardsuit
	name = "boots"
	atom_flags = PHORONGUARD
	clothing_flags = CLOTHING_IGNORE_BELTLINK | CLOTHING_IGNORE_DELIMB
	body_cover_flags = FEET
	cold_protection_cover    = FEET
	heat_protection_cover    = FEET

	icon_base = null
	damage_force = 5 // if you're kicking someone with something meant to keep you locked on a hunk of metal...

	weight = 0
	encumbrance = 0

/obj/item/clothing/suit/space/hardsuit
	name = "chestpiece"
	allowed = list(/obj/item/flashlight,/obj/item/tank,/obj/item/suit_cooling_unit)

	//Flags
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	clothing_flags     = CLOTHING_THICK_MATERIAL | CLOTHING_INJECTION_PORT | CLOTHING_IGNORE_BELTLINK | CLOTHING_IGNORE_DELIMB
	cold_protection_cover    = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	atom_flags              = PHORONGUARD
	inv_hide_flags          = HIDEJUMPSUIT|HIDETAIL
	heat_protection_cover    = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS

	weight = 0
	encumbrance = 0

	// Will reach 10 breach damage after 25 laser carbine blasts, 3 revolver hits, or ~1 PTR hit.
	// Completely immune to smg or sts hits.
	breach_threshold = 38
	resilience = 0.2
	can_breach = TRUE

	supporting_limbs = list()
	var/obj/item/material/knife/tacknife
	max_pressure_protection = null
	min_pressure_protection = null
