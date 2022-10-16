/obj/item/clothing/head/soft
	name = "cargo cap"
	desc = "It's a peaked cap in a tasteless yellow color."
	icon_state = "cargosoft"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "cargosoft", SLOT_ID_LEFT_HAND = "cargosoft")
	var/flipped = 0
	siemens_coefficient = 0.9
	body_parts_covered = 0

/obj/item/clothing/head/soft/dropped(mob/user, flags, atom/newLoc)
	icon_state = initial(icon_state)
	flipped=0
	..()

/obj/item/clothing/head/soft/attack_self(mob/user)
	flipped = !flipped
	if(flipped)
		icon_state = "[icon_state]_flipped"
		to_chat(user, "You flip the hat backwards.")
	else
		icon_state = initial(icon_state)
		to_chat(user, "You flip the hat back in normal position.")
	update_worn_icon()	//so our mob-overlays update

/obj/item/clothing/head/soft/red
	name = "red cap"
	desc = "It's a baseball hat in a tasteless red color."
	icon_state = "redsoft"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "redsoft", SLOT_ID_LEFT_HAND = "redsoft")

/obj/item/clothing/head/soft/blue
	name = "blue cap"
	desc = "It's a peaked cap in a tasteless blue color."
	icon_state = "bluesoft"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "bluesoft", SLOT_ID_LEFT_HAND = "bluesoft")

/obj/item/clothing/head/soft/green
	name = "green cap"
	desc = "It's a peaked cap in a tasteless green color."
	icon_state = "greensoft"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "greensoft", SLOT_ID_LEFT_HAND = "greensoft")

/obj/item/clothing/head/soft/yellow
	name = "yellow cap"
	desc = "It's a peaked cap in a tasteless yellow color."
	icon_state = "yellowsoft"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "yellowsoft", SLOT_ID_LEFT_HAND = "yellowsoft")

/obj/item/clothing/head/soft/grey
	name = "grey cap"
	desc = "It's a peaked cap in a tasteful grey color."
	icon_state = "greysoft"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "greysoft", SLOT_ID_LEFT_HAND = "greysoft")

/obj/item/clothing/head/soft/orange
	name = "orange cap"
	desc = "It's a peaked cap in a tasteless orange color."
	icon_state = "orangesoft"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "orangesoft", SLOT_ID_LEFT_HAND = "orangesoft")

/obj/item/clothing/head/soft/mime
	name = "white cap"
	desc = "It's a peaked cap in a tasteless white color."
	icon_state = "mimesoft"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "mimesoft", SLOT_ID_LEFT_HAND = "mimesoft")

/obj/item/clothing/head/soft/purple
	name = "purple cap"
	desc = "It's a peaked cap in a tasteless purple color."
	icon_state = "purplesoft"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "purplesoft", SLOT_ID_LEFT_HAND = "purplesoft")

/obj/item/clothing/head/soft/rainbow
	name = "rainbow cap"
	desc = "It's a peaked cap in a bright rainbow of colors."
	icon_state = "rainbowsoft"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "rainbowsoft", SLOT_ID_LEFT_HAND = "rainbowsoft")

/obj/item/clothing/head/soft/sec
	name = "security cap"
	desc = "It's a field cap in tasteful red color."
	icon_state = "secsoft"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "secsoft", SLOT_ID_LEFT_HAND = "secsoft")

/obj/item/clothing/head/soft/sec/corp
	name = "corporate security cap"
	desc = "It's field cap in corporate colors."
	icon_state = "corpsoft"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "corpsoft", SLOT_ID_LEFT_HAND = "corpsoft")

/obj/item/clothing/head/soft/black
	name = "black cap"
	desc = "It's a peaked cap in a tasteful black color."
	icon_state = "blacksoft"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "blacksoft", SLOT_ID_LEFT_HAND = "blacksoft")

/obj/item/clothing/head/soft/mbill
	name = "shipping cap"
	desc = "It's a ballcap bearing the colors of Major Bill's Shipping."
	icon_state = "mbillsoft"
	catalogue_data = list(/datum/category_item/catalogue/information/organization/major_bills)
