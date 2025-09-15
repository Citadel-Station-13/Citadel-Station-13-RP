/obj/item/storage/wallet
	name = "wallet"
	desc = "It can hold a few small and personal things."
	max_items = 10
	icon = 'icons/obj/wallet.dmi'
	icon_state = "wallet-orange"
	w_class = WEIGHT_CLASS_SMALL
	insertion_whitelist = list(
		/obj/item/spacecash,
		/obj/item/card,
		/obj/item/clothing/mask/smokable/cigarette/,
		/obj/item/flashlight/pen,
		/obj/item/barrier_tape_roll,
		/obj/item/cartridge,
		/obj/item/encryptionkey,
		/obj/item/seeds,
		/obj/item/stack/medical,
		/obj/item/coin,
		/obj/item/dice,
		/obj/item/disk,
		/obj/item/implanter,
		/obj/item/flame/lighter,
		/obj/item/flame/match,
		/obj/item/forensics,
		/obj/item/glass_extra,
		/obj/item/haircomb,
		/obj/item/hand,
		/obj/item/key,
		/obj/item/lipstick,
		/obj/item/paper,
		/obj/item/pen,
		/obj/item/photo,
		/obj/item/reagent_containers/dropper,
		/obj/item/sample,
		/obj/item/tool/screwdriver,
		/obj/item/stamp,
		/obj/item/clothing/accessory/permit,
		/obj/item/clothing/accessory/badge,
		/obj/item/clothing/gloves/ring,
		/obj/item/clothing/accessory/bracelet,
		/obj/item/clothing/accessory/necklace,
		/obj/item/clothing/accessory/metal_necklace,
		/obj/item/makeover,
		)
	insertion_blacklist = list(/obj/item/tool/screwdriver/power)
	slot_flags = SLOT_ID

	var/obj/item/card/id/front_id = null

	drop_sound = 'sound/items/drop/cloth.ogg'
	pickup_sound = 'sound/items/pickup/cloth.ogg'

/obj/item/storage/wallet/Entered(atom/movable/AM, atom/oldLoc)
	. = ..()
	update_front_id()

/obj/item/storage/wallet/Exited(atom/movable/AM, atom/newLoc)
	. = ..()
	update_front_id()

/obj/item/storage/wallet/proc/update_front_id()
	// todo: lol fuck this is bad ~ silicons
	var/obj/item/card/id/found = locate(/obj/item/card/id) in contents
	if(isnull(front_id) == isnull(found))
		return
	front_id = found
	if(isnull(front_id))
		name = initial(name)
	else
		name = "[initial(name)] ([front_id])"
	update_icon()

/obj/item/storage/wallet/update_icon()
	cut_overlays()
	. = ..()
	if(front_id)
		var/tiny_state = "id-generic"
		if(("id-"+front_id.icon_state) in icon_states(icon))
			tiny_state = "id-"+front_id.icon_state
		var/image/tiny_image = new/image(icon, icon_state = tiny_state)
		tiny_image.appearance_flags = RESET_COLOR
		add_overlay(tiny_image)

/obj/item/storage/wallet/GetID()
	return front_id

/obj/item/storage/wallet/GetAccess()
	var/obj/item/I = GetID()
	if(I)
		return I.GetAccess()
	else
		return ..()

/obj/item/storage/wallet/random/Initialize(mapload)
	. = ..()
	var/amount = rand(50, 100) + rand(50, 100) // Triangular distribution from 100 to 200
	var/obj/item/spacecash/SC = null
	SC = new(src)
	for(var/i in list(100, 50, 20, 10, 5, 1))
		if(amount < i)
			continue
		while(amount >= i)
			amount -= i
			SC.adjust_worth(i, 0)
		SC.update_icon()

/obj/item/storage/wallet/poly
	name = "polychromic wallet"
	desc = "You can recolor it! Fancy! The future is NOW!"
	icon_state = "wallet-white"

/obj/item/storage/wallet/poly/Initialize(mapload)
	. = ..()
	add_atom_color("#"+get_random_colour())
	update_icon()

/obj/item/storage/wallet/poly/verb/change_color()
	set name = "Change Wallet Color"
	set category = VERB_CATEGORY_OBJECT
	set desc = "Change the color of the wallet."
	set src in usr

	if(usr.stat || usr.restrained() || usr.incapacitated())
		return

	var/new_color = input(usr, "Pick a new color", "Wallet Color", color) as color|null

	if(new_color)
		add_atom_color(new_color)

/obj/item/storage/wallet/poly/emp_act()
	var/original_state = icon_state
	icon_state = "wallet-emp"
	update_icon()

	spawn(200)
		if(src)
			icon_state = original_state
			update_icon()

/obj/item/storage/wallet/womens
	name = "women's wallet"
	desc = "A stylish wallet typically used by women."
	icon_state = "girl_wallet"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "wowallet", SLOT_ID_LEFT_HAND = "wowallet")
