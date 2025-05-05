/**
 * Tiny leftovers that don't fit anywhere else
 */

//Technically workwear lmao
/obj/item/clothing/under/permit
	name = "public nudity permit"
	desc = "This permit entitles the bearer to conduct their duties without a uniform, so long as they are furred or have no visible genitalia."
	icon = 'icons/clothing/uniform/workwear/npass.dmi'
	icon_state = "npass"
	body_cover_flags = 0
	equip_sound = null

/obj/item/clothing/under/gear_harness
	name = "gear harness"
	desc = "How... minimalist."
	icon = 'icons/clothing/uniform/workwear/gear_harness.dmi'
	icon_state = "gear_harness"
	body_cover_flags = NONE

/obj/item/clothing/under/gear_harness/style_repick_query(mob/user)
	. = ..()
	var/image/normal_image = image(icon, "gear_harness")
	normal_image.maptext = MAPTEXT("normal")
	.["normal"] = normal_image
	var/image/invisible_image = image('icons/system/blank_32x32.dmi', "")
	invisible_image.maptext = MAPTEXT("invisible")
	.["invisible"] = invisible_image

/obj/item/clothing/under/gear_harness/style_repick_set(style, mob/user)
	switch(style)
		if("normal")
			worn_render_flags = initial(worn_render_flags)
			return TRUE
		if("invisible")
			worn_render_flags |= WORN_RENDER_SLOT_NO_RENDER
			return TRUE
		else
			return FALSE


//Reuses spritesheet
/obj/item/clothing/under/space
	name = "\improper NASA jumpsuit"
	desc = "It has a NASA logo on it and is made of space-proofed materials."
	icon = 'icons/clothing/uniform/workwear/jumpsuit/jumpsuit_black.dmi'
	icon_state = "black"
	w_class = WEIGHT_CLASS_BULKY//bulky item
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.02
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	cold_protection_cover = UPPER_TORSO | LOWER_TORSO | LEGS | ARMS //Needs gloves and shoes with cold protection to be fully protected.
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE

//Reuses spritesheet
//Admin abuse suit
/obj/item/clothing/under/acj
	name = "administrative cybernetic jumpsuit"
	icon = 'icons/clothing/uniform/workwear/syndicate/syndicate.dmi'
	icon_state = "syndicate"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "black", SLOT_ID_LEFT_HAND = "black")
	desc = "it's a cybernetically enhanced jumpsuit used for administrative duties."
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	armor_type = /datum/armor/invulnerable
	cold_protection_cover = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0

