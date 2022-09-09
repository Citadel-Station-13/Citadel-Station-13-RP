/*****************************Coin********************************/

/obj/item/coin
	icon = 'icons/obj/items.dmi'
	name = "Coin"
	icon_state = "coin"
	force = 0.0
	throw_force = 0.0
	w_class = ITEMSIZE_TINY
	slot_flags = SLOT_EARS
	var/string_attached
	var/sides = 2
	drop_sound = 'sound/items/drop/ring.ogg'
	pickup_sound = 'sound/items/pickup/ring.ogg'

/obj/item/coin/Initialize(mapload)
	. = ..()
	pixel_x = rand(0,16)-8
	pixel_y = rand(0,8)-8

// not yet, currency coins later
/obj/item/coin/is_static_currency(prevent_types)
	return NOT_STATIC_CURRENCY

// not yet
/obj/item/coin/amount_static_currency()
	return 0

/obj/item/coin/do_static_currency_feedback(amount, mob/user, atom/target, range)
	visible_message(SPAN_NOTICE("[user] insert [src] into [target]."), SPAN_NOTICE("You insert [src] into [target]."), SPAN_NOTICE("You hear a metallic clink."), range)

/obj/item/coin/iron
	name = "iron coin"
	icon_state = "coin_iron"

/obj/item/coin/copper
	name = "copper coin"
	icon_state = "coin_copper"

/obj/item/coin/silver
	name = "silver coin"
	icon_state = "coin_silver"

/obj/item/coin/gold
	name = "gold coin"
	icon_state = "coin_gold"

/obj/item/coin/phoron
	name = "solid phoron coin"
	icon_state = "coin_phoron"

/obj/item/coin/uranium
	name = "uranium coin"
	icon_state = "coin_uranium"

/obj/item/coin/diamond
	name = "diamond coin"
	icon_state = "coin_diamond"

/obj/item/coin/platinum
	name = "platinum coin"
	icon_state = "coin_platinum"

/obj/item/coin/durasteel
	name = "adamantine coin"
	icon_state = "coin_adamantine"

/obj/item/coin/mhydrogen
	name = "mythril coin"
	icon_state = "coin_mythril"

/obj/item/coin/bananium
	name = "bananium coin"
	icon_state = "coin_clown"

/obj/item/coin/supermatter
	name = "supermatter coin"
	icon_state = "coin_supermatter"

/obj/item/coin/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/CC = W
		if(string_attached)
			to_chat(user, "<span class='notice'>There already is a string attached to this coin.</span>")
			return
		if (CC.use(1))
			overlays += image('icons/obj/items.dmi',"coin_string_overlay")
			string_attached = 1
			to_chat(user, "<span class='notice'>You attach a string to the coin.</span>")
		else
			to_chat(user, "<span class='notice'>This cable coil appears to be empty.</span>")
		return
	else if(W.is_wirecutter())
		if(!string_attached)
			..()
			return

		var/obj/item/stack/cable_coil/CC = new/obj/item/stack/cable_coil(user.loc)
		CC.amount = 1
		CC.update_icon()
		overlays = list()
		string_attached = null
		to_chat(user, "<font color=#4F49AF>You detach the string from the coin.</font>")
	else ..()

/obj/item/coin/attack_self(mob/user as mob)
	var/result = rand(1, sides)
	var/comment = ""
	if(result == 1)
		comment = "tails"
	else if(result == 2)
		comment = "heads"
	user.visible_message("<span class='notice'>[user] has thrown \the [src]. It lands on [comment]! </span>", \
						 "<span class='notice'>You throw \the [src]. It lands on [comment]! </span>")
