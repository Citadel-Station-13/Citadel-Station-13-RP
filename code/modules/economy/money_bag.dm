/*****************************Money bag********************************/

/obj/item/moneybag
	icon = 'icons/obj/storage.dmi'
	name = "Money bag"
	icon_state = "moneybag"
	force = 10.0
	throw_force = 2.0
	w_class = ITEMSIZE_LARGE

/obj/item/moneybag/attack_hand(user as mob)
	var/amt_supermatter = 0
	var/amt_bananium = 0
	var/amt_mhydrogen = 0
	var/amt_durasteel = 0
	var/amt_platinum = 0
	var/amt_diamond = 0
	var/amt_uranium = 0
	var/amt_phoron = 0
	var/amt_gold = 0
	var/amt_silver = 0
	var/amt_copper = 0
	var/amt_iron = 0

	for (var/obj/item/coin/C in contents)
		if (istype(C,/obj/item/coin/supermatter))
			amt_supermatter++;
		if (istype(C,/obj/item/coin/bananium))
			amt_bananium++;
		if (istype(C,/obj/item/coin/mhydrogen))
			amt_mhydrogen++;
		if (istype(C,/obj/item/coin/durasteel))
			amt_durasteel++;
		if (istype(C,/obj/item/coin/platinum))
			amt_platinum++;
		if (istype(C,/obj/item/coin/diamond))
			amt_diamond++;
		if (istype(C,/obj/item/coin/uranium))
			amt_uranium++;
		if (istype(C,/obj/item/coin/phoron))
			amt_phoron++;
		if (istype(C,/obj/item/coin/gold))
			amt_gold++;
		if (istype(C,/obj/item/coin/silver))
			amt_silver++;
		if (istype(C,/obj/item/coin/copper))
			amt_copper++;
		if (istype(C,/obj/item/coin/iron))
			amt_iron++;

	var/dat = text("<b>The contents of the moneybag reveal...</b><br>")
	if (amt_supermatter)
		dat += text("Supermatter coins: [amt_supermatter] <A href='?src=\ref[src];remove=supermatter'>Remove one</A><br>")
	if (amt_bananium)
		dat += text("Bananium coins: [amt_bananium] <A href='?src=\ref[src];remove=bananium'>Remove one</A><br>")
	if (amt_mhydrogen)
		dat += text("Mythril coins: [amt_mhydrogen] <A href='?src=\ref[src];remove=mhydrogen'>Remove one</A><br>")
	if (amt_durasteel)
		dat += text("Durasteel coins: [amt_durasteel] <A href='?src=\ref[src];remove=durasteel'>Remove one</A><br>")
	if (amt_platinum)
		dat += text("Platinum coins: [amt_platinum] <A href='?src=\ref[src];remove=platinum'>Remove one</A><br>")
	if (amt_diamond)
		dat += text("Diamond coins: [amt_diamond] <A href='?src=\ref[src];remove=diamond'>Remove one</A><br>")
	if (amt_uranium)
		dat += text("Uranium coins: [amt_uranium] <A href='?src=\ref[src];remove=uranium'>Remove one</A><br>")
	if (amt_phoron)
		dat += text("Phoron coins: [amt_phoron] <A href='?src=\ref[src];remove=phoron'>Remove one</A><br>")
	if (amt_gold)
		dat += text("Gold coins: [amt_gold] <A href='?src=\ref[src];remove=gold'>Remove one</A><br>")
	if (amt_silver)
		dat += text("Silver coins: [amt_silver] <A href='?src=\ref[src];remove=silver'>Remove one</A><br>")
	if (amt_copper)
		dat += text("Copper coins: [amt_copper] <A href='?src=\ref[src];remove=copper'>Remove one</A><br>")
	if (amt_iron)
		dat += text("Iron coins: [amt_iron] <A href='?src=\ref[src];remove=iron'>Remove one</A><br>")
	user << browse("[dat]", "window=moneybag")

/obj/item/moneybag/attackby(obj/item/W, mob/user)
	..()
	if (istype(W, /obj/item/coin))
		var/obj/item/coin/C = W
		if(!user.attempt_insert_item_for_installation(C, src))
			return
		to_chat(user, "<font color=#4F49AF>You add the [C.name] into the bag.</font>")
	if (istype(W, /obj/item/moneybag))
		var/obj/item/moneybag/C = W
		for (var/obj/O in C.contents)
			O.forceMove(src)
		to_chat(user, "<font color=#4F49AF>You empty the [C.name] into the bag.</font>")

/obj/item/moneybag/Topic(href, href_list)
	if(..())
		return 1
	usr.set_machine(src)
	src.add_fingerprint(usr)
	if(href_list["remove"])
		var/obj/item/coin/COIN
		switch(href_list["remove"])
			if("supermatter")
				COIN = locate(/obj/item/coin/supermatter,src.contents)
			if("bananium")
				COIN = locate(/obj/item/coin/bananium,src.contents)
			if("mhydrogen")
				COIN = locate(/obj/item/coin/mhydrogen,src.contents)
			if("durasteel")
				COIN = locate(/obj/item/coin/durasteel,src.contents)
			if("platinum")
				COIN = locate(/obj/item/coin/platinum,src.contents)
			if("diamond")
				COIN = locate(/obj/item/coin/diamond,src.contents)
			if("uranium")
				COIN = locate(/obj/item/coin/uranium,src.contents)
			if("phoron")
				COIN = locate(/obj/item/coin/phoron,src.contents)
			if("gold")
				COIN = locate(/obj/item/coin/gold,src.contents)
			if("silver")
				COIN = locate(/obj/item/coin/silver,src.contents)
			if("copper")
				COIN = locate(/obj/item/coin/copper,src.contents)
			if("iron")
				COIN = locate(/obj/item/coin/iron,src.contents)
		if(!COIN)
			return
		COIN.loc = src.loc
	return


/obj/item/moneybag/vault/Initialize(mapload)
	. = ..()
	new /obj/item/coin/copper(src)
	new /obj/item/coin/copper(src)
	new /obj/item/coin/copper(src)
	new /obj/item/coin/copper(src)
	new /obj/item/coin/silver(src)
	new /obj/item/coin/silver(src)
	new /obj/item/coin/silver(src)
	new /obj/item/coin/gold(src)
	new /obj/item/coin/gold(src)
