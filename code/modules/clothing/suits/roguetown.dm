/obj/item/clothing/suit/armor/roguetown
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL | WORN_RENDER_INHAND_ALLOW_DEFAULT
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)

// Armor

/obj/item/clothing/suit/armor/roguetown/leather
	name = "leather armor"
	desc = "A sturdy piece of leather armor."
	icon = 'icons/clothing/suit/armor/medieval/roguetown/leather.dmi'
	icon_state = "leather"
	blood_overlay_type = "armor"
	armor_type = /datum/armor/station/light

/obj/item/clothing/suit/armor/roguetown/hide
	name = "hide armor"
	desc = "Armor tailored from thick animal hide."
	icon = 'icons/clothing/suit/armor/medieval/roguetown/hide.dmi'
	icon_state = "hide"
	blood_overlay_type = "armor"
	armor_type = /datum/armor/station/light

/obj/item/clothing/suit/armor/roguetown/stud
	name = "studded leather armor"
	desc = "A piece of leather armor with metallic studs embedded into it."
	icon = 'icons/clothing/suit/armor/medieval/roguetown/stud.dmi'
	icon_state = "stud"
	blood_overlay_type = "armor"
	armor_type = /datum/armor/station/medium

/obj/item/clothing/suit/armor/roguetown/chainmail
	name = "hauberk armor"
	desc = "A 'shirt' utilizing linked metal chains. Looks sturdy, if heavy."
	icon = 'icons/clothing/suit/armor/medieval/roguetown/chainmail.dmi'
	icon_state = "chainmail"
	blood_overlay_type = "armor"
	armor_type = /datum/armor/station/medium

/obj/item/clothing/suit/armor/roguetown/half_plate
	name = "half plate armor"
	desc = "A plate chest piece with accompanying shoulder pauldrons."
	icon = 'icons/clothing/suit/armor/medieval/roguetown/half_plate.dmi'
	icon_state = "halfplate"
	blood_overlay_type = "armor"
	armor_type = /datum/armor/station/mediumtreated

/obj/item/clothing/suit/armor/roguetown/lamellar
	name = "lamellar armor"
	desc = "A set of armor that appears to utilize overlapping metal plates and links."
	icon = 'icons/clothing/suit/armor/medieval/roguetown/lamellar.dmi'
	icon_state = "lamellar"
	blood_overlay_type = "armor"
	armor_type = /datum/armor/station/heavy

/obj/item/clothing/suit/armor/roguetown/plate
	name = "plate armor"
	desc = "A heavy set of plate armor."
	icon = 'icons/clothing/suit/armor/medieval/roguetown/plate.dmi'
	icon_state = "plate"
	blood_overlay_type = "armor"
	armor_type = /datum/armor/station/combat

/obj/item/clothing/suit/armor/roguetown/heavy_plate
	name = "heavy plate armor"
	desc = "Incredibly heavy plate armor, reinforced to withstand practically anything."
	icon = 'icons/clothing/suit/armor/medieval/roguetown/heavy_plate.dmi'
	icon_state = "heavyplate"
	blood_overlay_type = "armor"
	armor_type = /datum/armor/station/tactical

/obj/item/clothing/suit/armor/roguetown/ancient_plate
	name = "ancient plate armor"
	desc = "A set of plate armor that has evidently seen better days."
	icon = 'icons/clothing/suit/armor/medieval/roguetown/ancient_plate.dmi'
	icon_state = "ancientplate"
	blood_overlay_type = "armor"
	armor_type = /datum/armor/station/heavy

// Cloaks


/obj/item/clothing/suit/storage/hooded/roguetown/hide
	name = "hide cloak"
	desc = "A small cloak fashioned out of animal hide."
	icon = 'icons/clothing/suit/roguetown/hidecloak.dmi'
	icon_state = "hidecloak"
	slot_flags = SLOT_OCLOTHING
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	inv_hide_flags = HIDEHOLSTER
	cold_protection_cover = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL | WORN_RENDER_INHAND_ALLOW_DEFAULT
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	armor_type = /datum/armor/station/padded
	hoodtype = /obj/item/clothing/hood/roguetown/hide

/obj/item/clothing/suit/storage/hooded/roguetown/cloth
	name = "cloth cloak"
	desc = "A simple cloak that has been made out of cloth."
	icon = 'icons/clothing/suit/roguetown/clothcloak.dmi'
	icon_state = "clothcloak"
	slot_flags = SLOT_OCLOTHING
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL | WORN_RENDER_INHAND_ALLOW_DEFAULT
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	hoodtype = /obj/item/clothing/hood/roguetown/cloth

// Outer wear

/obj/item/clothing/suit/roguetown/leathercoat
	name = "leather coat"
	desc = "A coat made out of fine, tanned leather."
	icon = 'icons/clothing/suit/roguetown/leathercoat.dmi'
	icon_state = "leathercoat"
	icon_mob_y_align = -1
	armor_type = /datum/armor/station/padded
	slot_flags = SLOT_OCLOTHING
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL | WORN_RENDER_INHAND_ALLOW_DEFAULT
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|ARMS


/obj/item/clothing/suit/roguetown/leathercoat/female
	name = "leather coat"
	desc = "A coat made out of fine, tanned leather. It seems fitted for a lady's porpotions."
	icon = 'icons/clothing/suit/roguetown/leathercoat_f.dmi'
	icon_state = "leathercoat_f"
	armor_type = /datum/armor/station/padded
	slot_flags = SLOT_OCLOTHING
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL | WORN_RENDER_INHAND_ALLOW_DEFAULT
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|ARMS
