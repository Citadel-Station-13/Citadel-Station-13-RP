/*****************************Coin********************************/

/obj/item/weapon/coin
	icon = 'modular_citadel/icons/obj/coins.dmi'
	name = "Coin"
	icon_state = "coin"
	flags = CONDUCT
	force = 0.0
	throwforce = 0.0
	w_class = ITEMSIZE_TINY
	slot_flags = SLOT_EARS
	var/string_attached
	var/sides = 2

/obj/item/weapon/coin/New()
	pixel_x = rand(0,16)-8
	pixel_y = rand(0,8)-8

/obj/item/weapon/coin/gold
	name = "gold coin"
	icon_state = "coin_gold"

/obj/item/weapon/coin/silver
	name = "silver coin"
	icon_state = "coin_silver"

/obj/item/weapon/coin/diamond
	name = "diamond coin"
	icon_state = "coin_diamond"

/obj/item/weapon/coin/iron
	name = "iron coin"
	icon_state = "coin_iron"

/obj/item/weapon/coin/phoron
	name = "solid phoron coin"
	icon_state = "coin_phoron"

/obj/item/weapon/coin/uranium
	name = "uranium coin"
	icon_state = "coin_uranium"

/obj/item/weapon/coin/platinum
	name = "platinum coin"
	icon_state = "coin_adamantine"

/obj/item/weapon/coin/osmium
	name = "osmium coin"
	icon_state = "coin_osmium"

/obj/item/weapon/coin/durasteel
	name = "durasteel coin"
	desc = "An outrageous waste of materials, but totally worth it. Right?"
	throwforce = 5 // It's fucking durasteel hatterhat made me do it ok.
	icon_state = "coin_dsteel"

/obj/item/weapon/coin/mhydrogen
	name = "mhydrogen coin"
	icon_state = "coin_mhydrogen"

/obj/item/weapon/coin/plastic
	name = "plastic coin"
	icon_state = "coin_plastic"

/obj/item/weapon/coin/plasteel
	name = "plasteel coin"
	icon_state = "coin_plasteel"

/obj/item/weapon/coin/cardboard
	name = "cardboard coin"
	desc = "A little cardboard circle with a face drawn on it."
	icon_state = "coin_cardboard"

/obj/item/weapon/coin/void
	name = "strange coin"
	desc = "Two halves of a coin held together by...something in the middle."
	icon_state = "coin_rd"
	sides = 3

/obj/item/weapon/coin/ce
	name = "crystal coin"
	desc = "A deep black coin with a vaguely yellow crystal in the centre. <font color='red'>It seems to pulse in your fingers.</font>"
	icon_state = "coin_ce"

/obj/item/weapon/coin/hop
	name = "corporate coin"
	desc = "A dulled silver coin with a large N etched into the face. Wait, is the other side the same?"
	icon_state = "coin_hop"

/obj/item/weapon/coin/hos
	name = "crime detector"
	desc = "A coin, not an actual crime detector. Please don't use this to judge if someone is innocent or not."
	icon_state = "coin_hos"

/obj/item/weapon/coin/cmo
	name = "medical token"
	desc = "Less of a coin and more of something to remind you of your job. Do no harm!"
	icon_state = "coin_cmo"

/obj/item/weapon/coin/qm
	name = "old bronze coin"
	desc = "A well-preserved bronze coin with a little hole through the middle. Do people actually collect these?"
	icon_state = "coin_qm"

/obj/item/weapon/coin/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/CC = W
		if(string_attached)
			user << "<span class='notice'>There already is a string attached to this coin.</span>"
			return
		if (CC.use(1))
			overlays += image('modular_citadel/icons/obj/coins.dmi',"coin_string_overlay")
			string_attached = 1
			user << "<span class='notice'>You attach a string to the coin.</span>"
		else
			user << "<span class='notice'>This cable coil appears to be empty.</span>"
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
		user << "<font color='blue'>You detach the string from the coin.</font>"
	else ..()

/obj/item/weapon/coin/attack_self(mob/user as mob)
	var/result = rand(1, sides)
	var/comment = ""
	if(result == 1)
		comment = "tails"
	else if(result == 2)
		comment = "heads"
	user.visible_message("<span class='notice'>[user] has thrown \the [src]. It lands on [comment]! </span>", \
						 "<span class='notice'>You throw \the [src]. It lands on [comment]! </span>")

/obj/item/weapon/coin/void/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/CC = W
		if(string_attached)
			user << "<span class='notice'>There already is a string attached to this coin.</span>"
			return
		if (CC.use(1))
			overlays += image('icons/obj/items.dmi',"coin_string_overlay")
			string_attached = 1
			user << "<span class='notice'>You slip some cable through the centre of the coin.</span>"
		else
			user << "<span class='notice'>This cable coil appears to be empty.</span>"
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
		user << "<font color='blue'>You pull the string out from the coin.</font>"
	else ..()

/obj/item/weapon/coin/void/attack_self(mob/user as mob)
	var/result = rand(1, sides)
	var/comment = ""
	if(result == 1)
		comment = "lands on tails"
	else if(result == 2)
		comment = "lands on heads"
	else if(result == 3)
		comment = "splits in two, before sliding back together"
	user.visible_message("<span class='notice'>[user] has thrown \the [src]. It [comment]! </span>", \
						 "<span class='notice'>You throw \the [src]. It [comment]! </span>")

/obj/item/weapon/coin/hop/attack_self(mob/user as mob)
	var/result = rand(1, sides)
	var/comment = ""
	if(result == 1)
		comment = "lands on the other heads"
	else if(result == 2)
		comment = "lands on heads"
	user.visible_message("<span class='notice'>[user] has thrown \the [src]. It [comment]! </span>", \
						 "<span class='notice'>You throw \the [src]. It [comment]! </span>")

/obj/item/weapon/coin/hos/attack_self(mob/user as mob)
	var/result = rand(1, sides)
	var/comment = ""
	if(result == 1)
		comment = "lands on tails. Guilty"
	else if(result == 2)
		comment = "lands on heads. Innocent"
	user.visible_message("<span class='notice'>[user] has thrown \the [src]. It [comment]! </span>", \
						 "<span class='notice'>You throw \the [src]. It [comment]! </span>")



