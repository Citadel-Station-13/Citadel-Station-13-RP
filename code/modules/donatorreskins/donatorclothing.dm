//**
//Under
//**

// Basic
/obj/item/clothing/under/donator
	name = "base donator jumpsuit"
	desc = "Here for ease of use in the future when adding items."
	icon = 'icons/obj/clothing/donatorclothing.dmi'
	//icon_override = 'icons/mob/clothing/donatorclothing.dmi'
	var/alt_sprite = FALSE
	var/close_message = "Lorem Ipsum"
	var/open_message = "Lorem Ipsum"

/obj/item/clothing/under/donator/AltClick(mob/user)
	. = ..()
	SwitchSprite()

/obj/item/clothing/under/donator/ui_action_click()
	SwitchSprite()

/obj/item/clothing/under/donator/proc/SwitchSprite()
	if(!alt_sprite)
		return

	if(!istype(usr, /mob/living))
		return

	if(usr.stat)
		return

	if(src.icon_state == initial(icon_state))
		src.icon_state = "[icon_state]-alt"
		to_chat(usr, "[open_message]")
	else
		src.icon_state = initial(icon_state)
		to_chat(usr, "[close_message]")
	update_worn_icon()	//so our mob-overlays update

// Pink Latex Jumpsuit
/obj/item/clothing/under/donator/pinksuit
	name = "pink latex jumpsuit"
	desc = "A pink suit with a zipper in the middle made almost entirely of latex material."
	icon_state = "pinklatex"
	item_state = "pinklatex"
	icon = 'icons/obj/clothing/donatorclothing.dmi'
	icon_override = 'icons/mob/clothing/donatorclothing.dmi'

// KHI Uniform (Deprecated)
/obj/item/clothing/under/donator/huni
	name = "KHI Uniform"
	desc = "Free Trade Union attire for one not specialized in a particular role. Durable and stylish."
	icon_state = "blackuni"
	item_state = "blackuni"
	icon = 'icons/obj/clothing/donatorclothing.dmi'
	icon_override = 'icons/mob/clothing/donatorclothing.dmi'

// Carcharodon Suit
/obj/item/clothing/under/donator/carcharodon
	name = "Carcharodon Bodysuit"
	desc = "A dyed leather unitard paired with black denim shorts and sturdy chaps."
	description_fluff = "A hardened leather maillot meant to be worn under denim shorts and chaps. This suit was cut specifically to aid flexibility without sacrificing protection. A small tag bearing an embroidered 'K' is the only manufacturer's mark."
	icon = 'icons/clothing/donator/uniform/desu.dmi'
	icon_state = "carcharodon"
	item_icons = list(SLOT_ID_RIGHT_HAND = 'icons/mob/inhands/clothing_right.dmi', SLOT_ID_LEFT_HAND = 'icons/mob/inhands/clothing_left.dmi')
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL
	alt_sprite = TRUE
	action_button_name = "Adjust Bodysuit"
	close_message = "You activate the suit's lightweight mode."
	open_message = "You activate the suit's active mode."

// Mantle of Heaven
/obj/item/clothing/under/donator/mantleofheaven
	name = "Mantle of the Heavens"
	desc = "A black silk kimono with embroidered silver swallows."
	description_fluff = "A flowing nanosilk kimono, black with a pattern of swallows in silver thread. The interior is lined with a sleek orange synthetic fiber. This garment was cut specifically to maximize ventilation without sacrificing style nor mobility. A small tag bearing an embroidered 'K' is the only manufacturer's mark."
	icon = 'icons/clothing/donator/uniform/hedduh.dmi'
	icon_state = "mantleofheaven"
	item_icons = list(SLOT_ID_RIGHT_HAND = 'icons/mob/inhands/clothing_right.dmi', SLOT_ID_LEFT_HAND = 'icons/mob/inhands/clothing_left.dmi')
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL
	alt_sprite = TRUE
	action_button_name = "Adjust Kimono"
	close_message = "You straighten out the kimono and tighten the wraps."
	open_message = "You loosen the wraps on the kimono, letting it fall around your shoulders."

// Kenjyu Kimono
/obj/item/clothing/under/donator/kenjyu
	name = "Kenjyu kimono"
	desc = "A well-worn kimono that greats its wearer an intimidating air."
	description_fluff = "Originally patterned in nanosilk, the Kenjyu kimono eventually had to be reconstructed out of sturdier linen. The white kimono which serves as the basis for this outfit bears intricate embroidery work along its lower paneling. Gold silk and carefully braided red silk cord adorn the waist of the kimono. A black jacket layered over the kimono squares out the shoulders of the outfit, its arms flapping boldly whenever the wearer moves. The device of a wide-eyed skull menaces from the right shoulder of the jacket. A small tag bearing an embroidered 'K' is the only manufacturer's mark."
	icon = 'icons/clothing/donator/uniform/soda.dmi'
	icon_state = "kenjyu"
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL
	alt_sprite = TRUE
	action_button_name = "Adjust Kimono"
	close_message = "You straighten out the kimono and tighten the wraps."
	open_message = "You loosen the wraps of the kimono."

//**
// Suit
//**

// Basic Labcoat
/obj/item/clothing/suit/storage/toggle/labcoat/donator
	name = "base donator labcoat"
	desc = "Here for ease of use in the future when adding items."
	icon = 'icons/obj/clothing/donatorclothing.dmi'
	icon_override = 'icons/mob/clothing/donatorclothing.dmi'

// Multicolor Coat
/obj/item/clothing/suit/storage/toggle/labcoat/donator/blackredgold
	name = "Multicolor Coat"
	desc = "An oddly special looking coat with black, red, and gold"
	icon = 'icons/obj/clothing/donatorclothing.dmi'
	icon_override = 'icons/mob/clothing/donatorclothing.dmi'
	item_state = "redgoldjacket_w"
	icon_state = "redgoldjacket"

// Basic Armor
/obj/item/clothing/suit/armor/vest/donator
	name = "base donator armor"
	desc = "Yet again just here for convenience, use it as a base for donator armour-style items."
	icon = 'icons/obj/clothing/donatorclothing.dmi'
	icon_override = 'icons/mob/clothing/donatorclothing.dmi'
	armor_type = /datum/armor/none

// Hooded Cloak
/obj/item/clothing/suit/storage/hooded/donator/hooded_cloak
	name = "Project: Zul-E"
	desc = "A standard version of a prototype cloak given out by Nanotrasen higher ups. It's surprisingly thick and heavy for a cloak despite having most of it's tech stripped. It also comes with a bluespace trinket which calls it's accompanying hat onto the user. A worn inscription on the inside of the cloak reads 'Fleuret' ...the rest is faded away."
	item_state = "zuliecloak"
	icon = 'icons/obj/clothing/donatorclothing.dmi'
	icon_override = 'icons/mob/clothing/donatorclothing.dmi'
	icon_state = "zuliecloak"
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|ARMS
	inv_hide_flags = HIDEHOLSTER
	hoodtype = /obj/item/clothing/head/donator/cloak_hood

/obj/item/clothing/head/donator/cloak_hood
	name = "cloak hood"
	desc = "A hood attached to a cloak."
	icon_state = "zuliecap"
	icon = 'icons/obj/clothing/donatorclothing.dmi'
	icon_override = 'icons/mob/clothing/donatorclothing.dmi'
	icon_state = "zuliecap"
	body_cover_flags = HEAD

// Chaote Robe
/obj/item/clothing/suit/storage/hooded/techpriest/chaos
	name = "chaote robe"
	desc = "For when you just wanna summon extraplanar horrors or DAKKA DAKKA PUFF."
	icon_state = "chaospriest"
	icon = 'icons/obj/clothing/donatorclothing.dmi'
	icon_override = 'icons/mob/clothing/donatorclothing.dmi'
	hoodtype = /obj/item/clothing/head/hood/techpriest/chaos

/obj/item/clothing/head/hood/techpriest/chaos
	name = "chaote hood"
	icon_state = "chaospriesth"
	icon = 'icons/obj/clothing/donatorclothing.dmi'

// Refurbished Adhomian Cloak
/obj/item/clothing/suit/storage/hooded/donatornoahcloak //...yeah. I need the hood code to use it, so it's odd.
	name = "refurbished Adhomian cloak"
	desc = "A snow-white Adhomian cloak bearing hand-sewn edges and additional fur built into the inside for warmth. Bears an unusual symbol, a four-pointed star with a small center sphere."
	icon_state = "noah_cloak"
	item_state = "noah_cloak"
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	min_cold_protection_temperature = TN60C
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	hoodtype = /obj/item/clothing/head/hood/donatornoahcloak
	icon = 'icons/mob/clothing/donatorclothing.dmi'
	icon_override = 'icons/mob/clothing/donatorclothing.dmi'

/obj/item/clothing/head/hood/donatornoahcloak
	name = "refurbished Adhomian hood"
	desc = "A snow-white hood to go with a similar Adhomian cloak."
	icon_state = "noah_cloakhood"
	item_state = "noah_cloakhood"
	body_cover_flags = HEAD
	inv_hide_flags = HIDEEARS|BLOCKHAIR
	cold_protection = HEAD
	min_cold_protection_temperature = TN60C
	icon = 'icons/mob/clothing/donatorclothing.dmi'
	icon_override = 'icons/mob/clothing/donatorclothing.dmi'

//**
// Head
//**

// USDF Beret
/obj/item/clothing/head/donator/hberet
	name = "USDF Beret"
	desc = "United Sol Defense Force headwear for formal occasions, this one is quite battered, much like its wearer."
	icon_state = "blackberet"
	icon = 'icons/obj/clothing/donatorclothing.dmi'
	icon_override = 'icons/mob/clothing/donatorclothing.dmi'
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "blackberet", SLOT_ID_LEFT_HAND = "blackberet")
	body_cover_flags = HEAD

//**
// Masks
//**

/obj/item/clothing/mask/donator
	name = "Abstract Mask"
	desc = "Contact a Maintainer if you see this."
	var/alt_sprite = FALSE
	var/close_message = "Lorem Ipsum"
	var/open_message = "Lorem Ipsum"

/obj/item/clothing/mask/donator/AltClick(mob/user)
	. = ..()
	SwitchSprite()

/obj/item/clothing/mask/donator/ui_action_click()
	SwitchSprite()

/obj/item/clothing/mask/donator/proc/SwitchSprite()
	if(!alt_sprite)
		return

	if(!istype(usr, /mob/living))
		return

	if(usr.stat)
		return

	if(src.icon_state == initial(icon_state))
		src.icon_state = "[icon_state]-alt"
		to_chat(usr, "[open_message]")
	else
		src.icon_state = initial(icon_state)
		to_chat(usr, "[close_message]")
	update_worn_icon()	//so our mob-overlays update


//**
// Hands
//**

//**
// Feet
//**

//**
// Accessories
//**

// Explorer's Red Lensed Mask
/obj/item/clothing/mask/red_mask
	name = "Explorer's Red Lensed Mask"
	desc = "A gas mask with red lenses."
	icon = 'icons/obj/clothing/donatorclothing.dmi'
	icon_override = 'icons/mob/clothing/donatorclothing.dmi'
	body_cover_flags = HEAD
	icon_state = "gas_mining"

//**
// Sets
//**

// Hatsune Miku
/obj/item/clothing/under/donator/mikubikini
	name = "starlight singer bikini"
	desc = " "
	icon_state = "mikubikini"

/obj/item/clothing/suit/donator/mikujacket
	name = "starlight singer jacket"
	desc = " "
	icon_state = "mikujacket"
	icon = 'icons/obj/clothing/donatorclothing.dmi'
	icon_override = 'icons/mob/clothing/donatorclothing.dmi'

/obj/item/clothing/head/donator/mikuhair
	name = "starlight singer hair"
	desc = " "
	inv_hide_flags = HIDEEARS|BLOCKHEADHAIR
	icon_state = "mikuhair"
	icon = 'icons/obj/clothing/donatorclothing.dmi'
	icon_override = 'icons/mob/clothing/donatorclothing.dmi'

/obj/item/clothing/gloves/donator/mikugloves
	name = "starlight singer gloves"
	desc = " "
	icon_state = "mikugloves"
	icon = 'icons/obj/clothing/donatorclothing.dmi'
	icon_override = 'icons/mob/clothing/donatorclothing.dmi'

/obj/item/clothing/shoes/donator/mikuleggings
	name = "starlight singer leggings"
	desc = " "
	icon_state = "mikuleggings"
	icon = 'icons/obj/clothing/donatorclothing.dmi'
	icon_override = 'icons/mob/clothing/donatorclothing.dmi'

// Dancer
/obj/item/clothing/head/donator/dancer
	name = "belly dancer headscarf"
	desc = "A lightweight silk headscarf meant to accentuate and flow freely."
	icon = 'icons/clothing/donator/uniform/phish.dmi'
	icon_state = "dancer_scarf"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL

/obj/item/clothing/mask/donator/dancer
	name = "belly dancer veil"
	desc = "A heavy, ornate veil meant to mask the identity of the user, in spite of its subtle opacity."
	icon = 'icons/clothing/donator/uniform/phish.dmi'
	icon_state = "dancer_veil"
	inv_hide_flags = HIDEFACE
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL
	action_button_name = "Adjust Veil"
	close_message = "You drape the veil over your face."
	open_message = "You unclasp the veil and let it fall."

/obj/item/clothing/gloves/donator/dancer
	name = "belly dancer sleeves"
	desc = "Lightweight silk sleeves designed to flow during acrobatic displays."
	icon = 'icons/clothing/donator/uniform/phish.dmi'
	icon_state = "dancer_sleeves"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL

/obj/item/clothing/under/donator/dancer
	name = "belly dancer costume"
	desc = "A belly dancer's costume fashioned out of sheer silk."
	description_fluff = "An custom made ornate silk outfit, designed to be provocative without revealing too much of the wearer's body. A small tag bearing an embroidered 'K' is the only manufacturer's mark."
	icon = 'icons/clothing/donator/uniform/phish.dmi'
	icon_state = "dancer_costume"
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL
	alt_sprite = TRUE
	action_button_name = "Adjust Outfit"
	close_message = "You adjust the outfit to show more skin."
	open_message = "You adjust the outfit to cover up some skin."

/obj/item/clothing/shoes/donator/dancer
	name = "belly dancer footwraps"
	desc = "Soft silk wraps meant to provide some protection without hampering agility."
	icon = 'icons/clothing/donator/uniform/phish.dmi'
	icon_state = "dancer_wraps"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL

// Bee Costume
/obj/item/clothing/suit/storage/hooded/donator/bee_costume
	name = "bee costume"
	desc = "Bee the true Queen!"
	icon_state = "bee"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "bee", SLOT_ID_LEFT_HAND = "bee")
	icon = 'icons/obj/clothing/donatorclothing.dmi'
	icon_override = 'icons/mob/clothing/donatorclothing.dmi'
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|ARMS
	inv_hide_flags = HIDEJUMPSUIT|HIDETIE|HIDEHOLSTER
	hoodtype = /obj/item/clothing/head/donator/bee_hood

/obj/item/clothing/head/donator/bee_hood
	name = "bee hood"
	desc = "A hood attached to a bee costume."
	icon_state = "beehood"
	icon = 'icons/obj/clothing/donatorclothing.dmi'
	icon_override = 'icons/mob/clothing/donatorclothing.dmi'
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "bee", SLOT_ID_LEFT_HAND = "bee") //Does not exist -S2-
	body_cover_flags = HEAD
