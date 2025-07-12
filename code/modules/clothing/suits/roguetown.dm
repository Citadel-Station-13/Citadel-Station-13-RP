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
	allowed = list (/obj/item/pen, /obj/item/paper, /obj/item/flashlight,/obj/item/tank/emergency/oxygen, /obj/item/storage/fancy/cigarettes,
	/obj/item/storage/box/matches, /obj/item/reagent_containers/food/drinks/flask, /obj/item/eldritch/prop/codex)

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
	allowed = list (/obj/item/pen, /obj/item/paper, /obj/item/flashlight,/obj/item/tank/emergency/oxygen, /obj/item/storage/fancy/cigarettes,
	/obj/item/storage/box/matches, /obj/item/reagent_containers/food/drinks/flask, /obj/item/eldritch/prop/codex)


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
