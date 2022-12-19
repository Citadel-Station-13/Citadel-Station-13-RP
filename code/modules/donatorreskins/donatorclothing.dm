/obj/item/clothing/under/donator
	name = "base donator jumpsuit"
	desc = "Here for ease of use in the future when adding items."
	icon = 'icons/obj/clothing/donatorclothing.dmi'
	icon_override = 'icons/mob/clothing/donatorclothing.dmi'

/obj/item/clothing/suit/storage/toggle/labcoat/donator
	name = "base donator labcoat"
	desc = "Here for ease of use in the future when adding items."
	icon = 'icons/obj/clothing/donatorclothing.dmi'
	icon_override = 'icons/mob/clothing/donatorclothing.dmi'

/obj/item/clothing/suit/armor/vest/donator
	name = "base donator armor"
	desc = "Yet again just here for convenience, use it as a base for donator armour-style items."
	icon = 'icons/obj/clothing/donatorclothing.dmi'
	icon_override = 'icons/mob/clothing/donatorclothing.dmi'
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/suit/storage/hooded/donator/bee_costume
	name = "bee costume"
	desc = "Bee the true Queen!"
	icon_state = "bee"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "bee", SLOT_ID_LEFT_HAND = "bee")
	icon = 'icons/obj/clothing/donatorclothing.dmi'
	icon_override = 'icons/mob/clothing/donatorclothing.dmi'
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	flags_inv = HIDEJUMPSUIT|HIDETIE|HIDEHOLSTER
	hoodtype = /obj/item/clothing/head/donator/bee_hood

/obj/item/clothing/head/donator/bee_hood
	name = "bee hood"
	desc = "A hood attached to a bee costume."
	icon_state = "beehood"
	icon = 'icons/obj/clothing/donatorclothing.dmi'
	icon_override = 'icons/mob/clothing/donatorclothing.dmi'
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "bee", SLOT_ID_LEFT_HAND = "bee") //Does not exist -S2-
	body_parts_covered = HEAD

/obj/item/clothing/mask/red_mask
	name = "Explorer's Red Lensed Mask"
	desc = "A gas mask with red lenses."
	icon = 'icons/obj/clothing/donatorclothing.dmi'
	icon_override = 'icons/mob/clothing/donatorclothing.dmi'
	body_parts_covered = HEAD
	icon_state = "gas_mining"

/obj/item/clothing/suit/storage/toggle/labcoat/donator/blackredgold
	name = "Multicolor Coat"
	desc = "An oddly special looking coat with black, red, and gold"
	icon = 'icons/obj/clothing/donatorclothing.dmi'
	icon_override = 'icons/mob/clothing/donatorclothing.dmi'
	item_state = "redgoldjacket_w"
	icon_state = "redgoldjacket"

/obj/item/clothing/suit/storage/hooded/donator/hooded_cloak
	name = "Project: Zul-E"
	desc = "A standard version of a prototype cloak given out by Nanotrasen higher ups. It's surprisingly thick and heavy for a cloak despite having most of it's tech stripped. It also comes with a bluespace trinket which calls it's accompanying hat onto the user. A worn inscription on the inside of the cloak reads 'Fleuret' ...the rest is faded away."
	item_state = "zuliecloak"
	icon = 'icons/obj/clothing/donatorclothing.dmi'
	icon_override = 'icons/mob/clothing/donatorclothing.dmi'
	icon_state = "zuliecloak"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	flags_inv = HIDEHOLSTER
	hoodtype = /obj/item/clothing/head/donator/cloak_hood

/obj/item/clothing/head/donator/cloak_hood
	name = "cloak hood"
	desc = "A hood attached to a cloak."
	icon_state = "zuliecap"
	icon = 'icons/obj/clothing/donatorclothing.dmi'
	icon_override = 'icons/mob/clothing/donatorclothing.dmi'
	icon_state = "zuliecap"
	body_parts_covered = HEAD

/obj/item/clothing/under/donator/pinksuit
	name = "pink latex jumpsuit"
	desc = "A pink suit with a zipper in the middle made almost entirely of latex material."
	icon_state = "pinklatex"
	item_state = "pinklatex"
	icon = 'icons/obj/clothing/donatorclothing.dmi'
	icon_override = 'icons/mob/clothing/donatorclothing.dmi'

/obj/item/clothing/under/donator/huni
	name = "KHI Uniform"
	desc = "Free Trade Union attire for one not specialized in a particular role. Durable and stylish."
	icon_state = "blackuni"
	item_state = "blackuni"
	icon = 'icons/obj/clothing/donatorclothing.dmi'
	icon_override = 'icons/mob/clothing/donatorclothing.dmi'

/obj/item/clothing/head/donator/hberet
	name = "USDF Beret"
	desc = "United Sol Defense Force headwear for formal occasions, this one is quite battered, much like its wearer."
	icon_state = "blackberet"
	icon = 'icons/obj/clothing/donatorclothing.dmi'
	icon_override = 'icons/mob/clothing/donatorclothing.dmi'
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "blackberet", SLOT_ID_LEFT_HAND = "blackberet")
	body_parts_covered = HEAD

/obj/item/clothing/under/carcharodon
	name = "Carcharodon Suit"
	desc = "A hardened leather maillot meant to be worn under denim shorts and chaps. This suit was cut specifically to aid flexibility without sacrificing protection. A small tag bearing an embroidered 'K' is the only manufacturer's mark."
	icon = 'icons/obj/clothing/donatorclothing.dmi'
	icon_override = 'icons/mob/clothing/donatorclothing.dmi'
	icon_state = "carcharodon"
	item_state = "carcharodon"
	item_icons = list(SLOT_ID_RIGHT_HAND = 'icons/mob/inhands/clothing_right.dmi', SLOT_ID_LEFT_HAND = 'icons/mob/inhands/clothing_left.dmi')
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/carcharodon/verb/switchsprite()
    set name = "Reconfigure Suit"
    set category = "Object"
    set src in usr
    if(!istype(usr, /mob/living))
        return
    if(usr.stat)
        return
    to_chat(usr, "You rearrange the suit's configuration.")
    if(snowflake_worn_state == "carcharodon_s")
        snowflake_worn_state = "carcharodon_d_s"
    if(snowflake_worn_state == "carcharodon_d_s")
        snowflake_worn_state = "carcharodon_s"

/obj/item/clothing/under/mantleofheaven
	name = "Mantle of the Heavens"
	desc = "A flowing nanosilk kimono, black with a pattern of swallows in silver thread. The interior is lined with a sleek orange synthetic fiber. This garment was cut specifically to maximize ventilation without sacrificing style nor mobility. A small tag bearing an embroidered 'K' is the only manufacturer's mark."
	icon = 'icons/obj/clothing/donatorclothing.dmi'
	icon_override = 'icons/mob/clothing/donatorclothing.dmi'
	icon_state = "mantleofheaven"
	item_state = "mantleofheaven"
	item_icons = list(SLOT_ID_RIGHT_HAND = 'icons/mob/inhands/clothing_right.dmi', SLOT_ID_LEFT_HAND = 'icons/mob/inhands/clothing_left.dmi')
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/mantleofheaven/verb/switchsprite()
    set name = "Reconfigure Suit"
    set category = "Object"
    set src in usr
    if(!istype(usr, /mob/living))
        return
    if(usr.stat)
        return
    to_chat(usr, "You rearrange the suit's configuration.")
    if(snowflake_worn_state == "mantleofheaven_s")
        snowflake_worn_state = "mantleofheaven_d_s"
    if(snowflake_worn_state == "mantleofheaven_d_s")
        snowflake_worn_state = "mantleofheaven_s"

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

/obj/item/clothing/under/skirt/donator/doopytoots
	name = "high-waisted business skirt"
	desc = "A well tailored skirt matched with a form fitting blouse, perfect for all those paper pushing needs."
	icon_state = "hueyskirt"
	icon = 'icons/obj/clothing/donatorclothing.dmi'
	icon_override = 'icons/mob/clothing/donatorclothing.dmi'
	rolled_down_sleeves_icon = 'icons/obj/clothing/donatorclothing.dmi'

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
	flags_inv = HIDEEARS|BLOCKHEADHAIR
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

/obj/item/clothing/head/donator/dancer
	name = "belly dancer headscarf"
	desc = "A lightweight silk headscarf meant to accentuate and flow freely."
	icon_state = "dancer_scarf"
	icon = 'icons/obj/clothing/donatorclothing.dmi'
	icon_override = 'icons/mob/clothing/donatorclothing.dmi'
/obj/item/clothing/mask/donator/dancer
	name = "belly dancer veil"
	desc = "A heavy, ornate veil meant to mask the identity of the user, in spite of its subtle opacity."
	icon_state = "dancer_veil"
	icon = 'icons/obj/clothing/donatorclothing.dmi'
	icon_override = 'icons/mob/clothing/donatorclothing.dmi'
	flags_inv = HIDEFACE
	action_button_name = "Adjust Veil"
	var/hanging = 0

/obj/item/clothing/mask/donator/dancer/proc/adjust_mask(mob/user)
	if(!user.incapacitated() && !user.restrained() && !user.stat)
		hanging = !hanging
		if (hanging)
			body_parts_covered = body_parts_covered & ~FACE
			icon_state = "dancer_veil_down"
			to_chat(user, "You drape the veil to one side.")
		else
			body_parts_covered = initial(body_parts_covered)
			clothing_flags = initial(clothing_flags)
			icon_state = initial(icon_state)
			to_chat(user, "You pull the veil over to cover your face.")
		update_worn_icon()

/obj/item/clothing/mask/donator/dancer/attack_self(mob/user)
	adjust_mask(user)

/obj/item/clothing/mask/donator/dancer/verb/toggle()
		set category = "Object"
		set name = "Adjust veil"
		set src in usr

		adjust_mask(usr)
/obj/item/clothing/gloves/donator/dancer
	name = "belly dancer sleeves"
	desc = "Lightweight silk sleeves designed to flow during acrobatic displays."
	icon_state = "dancer_sleeves"
	icon = 'icons/obj/clothing/donatorclothing.dmi'
	icon_override = 'icons/mob/clothing/donatorclothing.dmi'
/obj/item/clothing/under/donator/dancer
	name = "belly dancer costume"
	desc = "An custom made ornate silk outfit, designed to be provocative without revealing too much of the wearer's body. A small tag bearing an embroidered 'K' is the only manufacturer's mark."
	icon_state = "dancer_costume"
	icon = 'icons/obj/clothing/donatorclothing.dmi'
	icon_override = 'icons/mob/clothing/donatorclothing.dmi'
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	action_button_name = "Reconfigure Suit"

/obj/item/clothing/under/donator/dancer/verb/switchsprite()
    set name = "Reconfigure Suit"
    set category = "Object"
    set src in usr
    if(!istype(usr, /mob/living))
        return
    if(usr.stat)
        return
    to_chat(usr, "You rearrange the suit's configuration.")
    if(snowflake_worn_state == "dancer_costume_s")
        snowflake_worn_state = "dancer_costume_d_s"
    if(snowflake_worn_state == "dancer_costume_d_s")
        snowflake_worn_state = "dancer_costume_s"
/obj/item/clothing/shoes/donator/dancer
	name = "belly dancer footwraps"
	desc = "Soft silk wraps meant to provide some protection without hampering agility."
	icon_state = "dancer_wraps"
	icon = 'icons/obj/clothing/donatorclothing.dmi'
	icon_override = 'icons/mob/clothing/donatorclothing.dmi'
