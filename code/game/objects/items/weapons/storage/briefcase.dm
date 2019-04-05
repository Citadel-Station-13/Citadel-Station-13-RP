<<<<<<< HEAD
/obj/item/weapon/storage/briefcase
	name = "briefcase"
	desc = "It's made of AUTHENTIC faux-leather and has a price-tag still attached. Its owner must be a real professional."
	icon_state = "briefcase"
	flags = CONDUCT
	force = 8.0
	throw_speed = 1
	throw_range = 4
	w_class = ITEMSIZE_LARGE
	max_w_class = ITEMSIZE_NORMAL
	max_storage_space = ITEMSIZE_COST_NORMAL * 4

/obj/item/weapon/storage/briefcase/clutch
	name = "clutch purse"
	desc = "A fashionable handheld bag typically used by women."
	icon_state = "clutch"
	item_state_slots = list(slot_r_hand_str = "smpurse", slot_l_hand_str = "smpurse")
	force = 0
	w_class = ITEMSIZE_NORMAL
	max_w_class = ITEMSIZE_SMALL
=======
/obj/item/weapon/storage/briefcase
	name = "briefcase"
	desc = "It's made of AUTHENTIC faux-leather and has a price-tag still attached. Its owner must be a real professional."
	icon_state = "briefcase"
	force = 8.0
	throw_speed = 1
	throw_range = 4
	w_class = ITEMSIZE_LARGE
	max_w_class = ITEMSIZE_NORMAL
	max_storage_space = ITEMSIZE_COST_NORMAL * 4

/obj/item/weapon/storage/briefcase/clutch
	name = "clutch purse"
	desc = "A fashionable handheld bag typically used by women."
	icon = 'icons/obj/clothing/backpack.dmi' //VOREStation Edit - Wrong sprite location
	icon_state = "clutch"
	item_state_slots = list(slot_r_hand_str = "smpurse", slot_l_hand_str = "smpurse")
	force = 0
	w_class = ITEMSIZE_NORMAL
	max_w_class = ITEMSIZE_SMALL
>>>>>>> 8b08e45... Merge pull request #4838 from VOREStation/master
	max_storage_space = ITEMSIZE_COST_SMALL * 4