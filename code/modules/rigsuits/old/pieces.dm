//? piece defs

/obj/item/clothing/head/hardsuit
	name = "helmet"
	atom_flags = PHORONGUARD
	clothing_flags = CLOTHING_THICK_MATERIAL | CLOTHING_INJECTION_PORT | ALLOW_SURVIVALFOOD | CLOTHING_IGNORE_BELTLINK | CLOTHING_IGNORE_DELIMB | ALLOWINTERNALS
	inv_hide_flags      = HIDEEARS|HIDEEYES|HIDEFACE|BLOCKHAIR
	body_cover_flags = HEAD|FACE|EYES
	heat_protection    = HEAD|FACE|EYES
	cold_protection    = HEAD|FACE|EYES
	brightness_on = 4

	max_pressure_protection = null
	min_pressure_protection = null
	damage_force = 3 // if you're headbutting someone with something meant to protect you from space...

/obj/item/clothing/suit/hardsuit
	name = "chestpiece"
	allowed = list(/obj/item/flashlight,/obj/item/tank,/obj/item/suit_cooling_unit)

	//Flags
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	clothing_flags     = CLOTHING_THICK_MATERIAL | CLOTHING_INJECTION_PORT | CLOTHING_IGNORE_BELTLINK | CLOTHING_IGNORE_DELIMB
	cold_protection    = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	atom_flags              = PHORONGUARD
	inv_hide_flags          = HIDEJUMPSUIT|HIDETAIL
	heat_protection    = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS

	slowdown = NONE

	// Will reach 10 breach damage after 25 laser carbine blasts, 3 revolver hits, or ~1 PTR hit.
	// Completely immune to smg or sts hits.
	breach_threshold = 38
	resilience = 0.2
	can_breach = TRUE

	supporting_limbs = list()
	var/obj/item/material/knife/tacknife
	max_pressure_protection = null
	min_pressure_protection = null

	/// host hardsuit
	var/obj/item/hardsuit/hardsuit

/obj/item/clothing/gloves/hardsuit
	name = "gauntlets"
	clothing_flags = CLOTHING_THICK_MATERIAL | CLOTHING_INJECTION_PORT | CLOTHING_IGNORE_BELTLINK | CLOTHING_IGNORE_DELIMB
	atom_flags = PHORONGUARD
	body_cover_flags = HANDS
	heat_protection    = HANDS
	cold_protection    = HANDS

	/// host hardsuit
	var/obj/item/hardsuit/hardsuit

/obj/item/clothing/shoes/hardsuit
	name = "boots"
	atom_flags = PHORONGUARD
	clothing_flags = CLOTHING_IGNORE_BELTLINK | CLOTHING_INJECTION_PORT | CLOTHING_THICK_MATERIAL | CLOTHING_IGNORE_DELIMB
	body_cover_flags = FEET
	cold_protection    = FEET
	heat_protection    = FEET

	icon_base = null
	damage_force = 5 // if you're kicking someone with something meant to keep you locked on a hunk of metal...
