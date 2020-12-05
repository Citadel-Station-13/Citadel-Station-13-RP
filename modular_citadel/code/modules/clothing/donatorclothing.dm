/obj/item/clothing/under/donator
	name = "base donator jumpsuit"
	desc = "Here for ease of use in the future when adding items."
	icon = 'modular_citadel/icons/obj/clothing/donatorclothing.dmi'
	icon_override = 'modular_citadel/icons/mob/donatorclothing.dmi'

/obj/item/clothing/suit/storage/toggle/labcoat/donator
	name = "base donator labcoat"
	desc = "Here for ease of use in the future when adding items."
	icon = 'modular_citadel/icons/obj/clothing/donatorclothing.dmi'
	icon_override = 'modular_citadel/icons/mob/donatorclothing.dmi'

/obj/item/clothing/suit/armor/vest/donator
	name = "base donator armor"
	desc = "Yet again just here for convenience, use it as a base for donator armour-style items."
	icon = 'modular_citadel/icons/obj/clothing/donatorclothing.dmi'
	icon_override = 'modular_citadel/icons/mob/donatorclothing.dmi'
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/suit/storage/hooded/donator/bee_costume
	name = "bee costume"
	desc = "Bee the true Queen!"
	icon_state = "bee"
	item_state_slots = list(slot_r_hand_str = "bee", slot_l_hand_str = "bee")
	icon = 'modular_citadel/icons/obj/clothing/donatorclothing.dmi'
	icon_override = 'modular_citadel/icons/mob/donatorclothing.dmi'
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	flags_inv = HIDEJUMPSUIT|HIDETIE|HIDEHOLSTER
	hoodtype = /obj/item/clothing/head/donator/bee_hood

/obj/item/clothing/head/donator/bee_hood
	name = "bee hood"
	desc = "A hood attached to a bee costume."
	icon_state = "beehood"
	icon = 'modular_citadel/icons/obj/clothing/donatorclothing.dmi'
	icon_override = 'modular_citadel/icons/mob/donatorclothing.dmi'
	item_state_slots = list(slot_r_hand_str = "bee", slot_l_hand_str = "bee") //Does not exist -S2-
	body_parts_covered = HEAD

/obj/item/clothing/mask/red_mask
	name = "Explorer's Red Lensed Mask"
	desc = "A gas mask with red lenses."
	icon = 'modular_citadel/icons/obj/clothing/donatorclothing.dmi'
	icon_override = 'modular_citadel/icons/mob/donatorclothing.dmi'
	body_parts_covered = HEAD
	icon_state = "gas_mining"

/obj/item/clothing/suit/storage/toggle/labcoat/donator/blackredgold
	name = "Multicolor Coat"
	desc = "An oddly special looking coat with black, red, and gold"
	icon = 'modular_citadel/icons/obj/clothing/donatorclothing.dmi'
	icon_override = 'modular_citadel/icons/mob/donatorclothing.dmi'
	item_state = "redgoldjacket_w"
	icon_state = "redgoldjacket"

/obj/item/clothing/suit/storage/hooded/donator/hooded_cloak
	name = "Project: Zul-E"
	desc = "A standard version of a prototype cloak given out by Nanotrasen higher ups. It's surprisingly thick and heavy for a cloak despite having most of it's tech stripped. It also comes with a bluespace trinket which calls it's accompanying hat onto the user. A worn inscription on the inside of the cloak reads 'Fleuret' ...the rest is faded away."
	item_state = "zuliecloak"
	icon = 'modular_citadel/icons/obj/clothing/donatorclothing.dmi'
	icon_override = 'modular_citadel/icons/mob/donatorclothing.dmi'
	icon_state = "zuliecloak"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	flags_inv = HIDEHOLSTER
	hoodtype = /obj/item/clothing/head/donator/cloak_hood

/obj/item/clothing/head/donator/cloak_hood
	name = "cloak hood"
	desc = "A hood attached to a cloak."
	icon_state = "zuliecap"
	icon = 'modular_citadel/icons/obj/clothing/donatorclothing.dmi'
	icon_override = 'modular_citadel/icons/mob/donatorclothing.dmi'
	icon_state = "zuliecap"
	body_parts_covered = HEAD

/obj/item/clothing/under/donator/pinksuit
	name = "pink latex jumpsuit"
	desc = "A pink suit with a zipper in the middle made almost entirely of latex material."
	icon_state = "pinklatex"
	item_state = "pinklatex"
	icon = 'modular_citadel/icons/obj/clothing/donatorclothing.dmi'
	icon_override = 'modular_citadel/icons/mob/donatorclothing.dmi'

/obj/item/clothing/under/donator/huni
	name = "KHI Uniform"
	desc = "Free Trade Union attire for one not specialized in a particular role. Durable and stylish."
	icon_state = "blackuni"
	item_state = "blackuni"
	icon = 'modular_citadel/icons/obj/clothing/donatorclothing.dmi'
	icon_override = 'modular_citadel/icons/mob/donatorclothing.dmi'

/obj/item/clothing/head/donator/hberet
	name = "USDF Beret"
	desc = "United Sol Defense Force headwear for formal occasions, this one is quite battered, much like its wearer."
	icon_state = "blackberet"
	icon = 'modular_citadel/icons/obj/clothing/donatorclothing.dmi'
	icon_override = 'modular_citadel/icons/mob/donatorclothing.dmi'
	item_state_slots = list(slot_r_hand_str = "blackberet", slot_l_hand_str = "blackberet")
	body_parts_covered = HEAD

/obj/item/clothing/head/donator/woolhat //ckey vfivesix. delete this later
	name = "Army Garrison Cap"
	desc = "A vintage wool cap, neatly shaven down the grain, adorning a golden oak leaf on its left half."
	icon_state = "woolhat"
	icon = 'modular_citadel/icons/obj/clothing/donatorclothing.dmi'
	icon_override = 'modular_citadel/icons/mob/donatorclothing.dmi'

/obj/item/clothing/under/carcharodon
	name = "Carcharodon Suit"
	desc = "A hardened leather maillot meant to be worn under denim shorts and chaps. This suit was cut specifically to aid flexibility without sacrificing protection. A small tag bearing an embroidered 'K' is the only manufacturer's mark."
	icon = 'modular_citadel/icons/obj/clothing/donatorclothing.dmi'
	icon_override = 'modular_citadel/icons/mob/donatorclothing.dmi'
	icon_state = "carcharodon"
	item_state = "carcharodon"
	item_icons = list(slot_r_hand_str = 'modular_citadel/icons/mob/inhands/clothing_right.dmi', slot_l_hand_str = 'modular_citadel/icons/mob/inhands/clothing_left.dmi')
	rolled_sleeves = -1
	rolled_down = -1

/obj/item/clothing/under/carcharodon/verb/switchsprite()
    set name = "Reconfigure Suit"
    set category = "Object"
    set src in usr
    if(!istype(usr, /mob/living))
        return
    if(usr.stat)
        return
    to_chat(usr, "You rearrange the suit's configuration.")
    if(worn_state == "carcharodon_s")
        worn_state = "carcharodon_d_s"
    if(worn_state == "carcharodon_d_s")
        worn_state = "carcharodon_s"

/obj/item/clothing/under/mantleofheaven
	name = "Mantle of the Heavens"
	desc = "A flowing nanosilk kimono, black with a pattern of swallows in silver thread. The interior is lined with a sleek orange synthetic fiber. This garment was cut specifically to maximize ventilation without sacrificing style nor mobility. A small tag bearing an embroidered 'K' is the only manufacturer's mark."
	icon = 'modular_citadel/icons/obj/clothing/donatorclothing.dmi'
	icon_override = 'modular_citadel/icons/mob/donatorclothing.dmi'
	icon_state = "mantleofheaven"
	item_state = "mantleofheaven"
	item_icons = list(slot_r_hand_str = 'modular_citadel/icons/mob/inhands/clothing_right.dmi', slot_l_hand_str = 'modular_citadel/icons/mob/inhands/clothing_left.dmi')
	rolled_sleeves = -1
	rolled_down = -1

/obj/item/clothing/under/mantleofheaven/verb/switchsprite()
    set name = "Reconfigure Suit"
    set category = "Object"
    set src in usr
    if(!istype(usr, /mob/living))
        return
    if(usr.stat)
        return
    to_chat(usr, "You rearrange the suit's configuration.")
    if(worn_state == "mantleofheaven_s")
        worn_state = "mantleofheaven_d_s"
    if(worn_state == "mantleofheaven_d_s")
        worn_state = "mantleofheaven_s"

/obj/item/clothing/suit/storage/hooded/techpriest/chaos
	name = "chaote robe"
	desc = "For when you just wanna summon extraplanar horrors or DAKKA DAKKA PUFF."
	icon_state = "chaospriest"
	icon = 'modular_citadel/icons/obj/clothing/donatorclothing.dmi'
	icon_override = 'modular_citadel/icons/mob/donatorclothing.dmi'
	hoodtype = /obj/item/clothing/head/hood/techpriest/chaos

/obj/item/clothing/head/hood/techpriest/chaos
	name = "chaote hood"
	icon_state = "chaospriesth"
	icon = 'modular_citadel/icons/obj/clothing/donatorclothing.dmi'

/obj/item/clothing/under/skirt/donator/doopytoots
	name = "high-waisted business skirt"
	desc = "A well tailored skirt matched with a form fitting blouse, perfect for all those paper pushing needs."
	icon_state = "hueyskirt"
	icon = 'modular_citadel/icons/obj/clothing/donatorclothing.dmi'
	icon_override = 'modular_citadel/icons/mob/donatorclothing.dmi'
	rolled_down_sleeves_icon = 'modular_citadel/icons/obj/clothing/donatorclothing.dmi'
	rolled_sleeves = 0
