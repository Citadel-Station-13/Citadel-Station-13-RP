/// Looks are changed by changing the icon var
/obj/item/clothing/suit/omnicasket
	name = "OmniCasket Torso Piece"
	desc = "The torso piece of an OmniCasket, it seems to mainly cover torso and groin, as well as parts of the neck."
	armor_type = /datum/armor/omnicasket
	body_cover_flags = UPPER_TORSO|LOWER_TORSO
	icon = 'icons/mob/species/phoronoid/omnicasket/bulky.dmi'
	icon_state = "item_torso"


/obj/item/clothing/suit/omnicasket/attack_hand(mob/user)
	to_chat(user, "You pat [src], its a good piece of suit")

/obj/item/clothing/head/omnicasket
	name = "OmniCasket Helmet"
	desc = "The torso piece of an OmniCasket, it seems to mainly cover Hands and arms, as well as parts of the shoulders."
	armor_type = /datum/armor/omnicasket
	body_cover_flags = HEAD
	icon = 'icons/mob/species/phoronoid/omnicasket/bulky.dmi'
	icon_state = "item_helmet"

	var/obj/item/clothing/glasses/omnicasket/visor

/obj/item/clothing/head/omnicasket/attack_hand(mob/user)
	to_chat(user, "You pat [src], its a good piece of suit")

/obj/item/clothing/shoes/omnicasket
	name = "OmniCasket Boots"
	desc = "The torso piece of an OmniCasket, it seems to mainly cover torso and groin, as well as parts of the neck."
	armor_type = /datum/armor/omnicasket
	body_cover_flags = FEET | LEGS
	icon = 'icons/mob/species/phoronoid/omnicasket/bulky.dmi'
	icon_state = "item_legs"

/obj/item/clothing/shoes/omnicasket/attack_hand(mob/user)
	to_chat(user, "You pat [src], its a good piece of suit")

/obj/item/clothing/gloves/omnicasket
	name = "OmniCasket Gauntlets"
	desc = "The torso piece of an OmniCasket, it seems to mainly cover torso and groin, as well as parts of the neck."
	armor_type = /datum/armor/omnicasket
	body_cover_flags = HANDS | ARMS
	icon = 'icons/mob/species/phoronoid/omnicasket/bulky.dmi'
	icon_state = "item_arms"

/obj/item/clothing/gloves/omnicasket/attack_hand(mob/user)
	to_chat(user, "You pat [src], its a good piece of suit")

/obj/item/clothing/glasses/omnicasket
	name = "OmniCasket Visor"
	desc = "The torso piece of an OmniCasket, it seems to mainly cover torso and groin, as well as parts of the neck."
	armor_type = /datum/armor/omnicasket
	body_cover_flags = EYES
	icon = 'icons/mob/species/phoronoid/omnicasket/visor.dmi'
	icon_state = "item_dark_purple_off"
	toggleable = 1
	active = 0
	activation_sound = null

/obj/item/clothing/glasses/omnicasket/attack_hand(mob/user)
	to_chat(user, "You pat [src], its a good piece of suit")

/obj/item/clothing/glasses/omnicasket/update_icon_state()
	. = ..()
	if(active)
		icon_state = "item_dark_purple_on"
	else
		icon_state = "item_dark_purple_off"









