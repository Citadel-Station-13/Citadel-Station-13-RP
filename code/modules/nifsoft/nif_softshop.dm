//Custom vendors
/obj/machinery/vending/nifsoft_shop
	name = "NIFSoft Shop"
	desc = "For all your mindware and mindware accessories."
	product_ads = "Let us get into your head!;Looking for an upgrade?;Surpass Humanity!;Why be normal when you can be SUPERnormal?;Jack in with NIFSoft!"

	icon = 'icons/obj/machines/ar_elements.dmi'
	icon_state = "proj"
	icon_vend = "beacon_yes"
	icon_deny = "beacon_no"

	products = list()
	contraband = list()
	premium = list()
	var/global/list/starting_legal_nifsoft
	var/global/list/starting_illegal_nifsoft

	density = 0
	opacity = 0
	var/datum/entopic/entopic

/obj/machinery/vending/nifsoft_shop/Initialize(mapload)
	. = ..()
	entopic = new(aholder = src, aicon = icon, aicon_state = "beacon")

/obj/machinery/vending/nifsoft_shop/ui_data(mob/user)
	. = ..()
	.["chargesMoney"] = TRUE


/obj/machinery/vending/nifsoft_shop/Destroy()
	QDEL_NULL(entopic)
	return ..()

/obj/machinery/vending/nifsoft_shop/power_change()
	..()
	if(!entopic) return //Early APC init(), ignore
	if(stat & BROKEN)
		icon_state = "[initial(icon_state)]-broken"
		entopic.hide()
	else
		if(!(stat & NOPOWER))
			icon_state = initial(icon_state)
			entopic.show()
		else
			spawn(rand(0, 15))
				icon_state = "[initial(icon_state)]-off"
				entopic.hide()

/obj/machinery/vending/nifsoft_shop/malfunction()
	stat |= BROKEN
	icon_state = "[initial(icon_state)]-broken"
	entopic.hide()
	return

// Special Treatment!
/obj/machinery/vending/nifsoft_shop/build_inventory()
	//Firsties
	if(!starting_legal_nifsoft)
		starting_legal_nifsoft = list()
		starting_illegal_nifsoft = list()
		for(var/P in (subtypesof(/datum/nifsoft) - typesof(/datum/nifsoft/package)))
			var/datum/nifsoft/NS = P
			if(initial(NS.vended))
				switch(initial(NS.illegal))
					if(TRUE)
						starting_illegal_nifsoft += NS
					if(FALSE)
						starting_legal_nifsoft += NS

	products = starting_legal_nifsoft.Copy()
	contraband = starting_illegal_nifsoft.Copy()

	var/list/all_products = list(
		list(products, CAT_NORMAL),
		list(contraband, CAT_HIDDEN),
		list(premium, CAT_COIN))

	for(var/current_list in all_products)
		var/category = current_list[2]

		for(var/entry in current_list[1])
			var/datum/nifsoft/NS = entry
			var/applies_to = initial(NS.applies_to)
			var/context = ""
			if(!(applies_to & NIF_SYNTHETIC))
				context = " (Org Only)"
			else if(!(applies_to & NIF_ORGANIC))
				context = " (Syn Only)"
			var/name = "[initial(NS.name)][context]"
			var/datum/stored_item/vending_product/product = new/datum/stored_item/vending_product(src, entry, name)

			product.price = initial(NS.cost)
			product.amount = 10
			product.category = category

			product_records.Add(product)

/obj/machinery/vending/nifsoft_shop/can_buy(datum/stored_item/vending_product/R, mob/user)
	. = ..()
	if(.)
		var/datum/nifsoft/path = R.item_path
		if(!ishuman(user))
			return FALSE

		var/mob/living/carbon/human/H = user
		if(!H.nif || !H.nif.stat == NIF_WORKING)
			to_chat(H, "<span class='warning'>[src] seems unable to connect to your NIF...</span>")
			return FALSE

		if(!H.nif.can_install(path))
			flick("[icon_state]-deny", entopic.my_image)
			return FALSE

		if(initial(path.access))
			var/list/soft_access = list(initial(path.access))
			var/list/usr_access = user.GetAccess()
			if(scan_id && !has_access(soft_access, list(), usr_access) && !emagged)
				to_chat(user, "<span class='warning'>You aren't authorized to buy [initial(path.name)].</span>")
				flick("[icon_state]-deny", entopic.my_image)
				return FALSE

// Also special treatment!
/obj/machinery/vending/nifsoft_shop/vend(datum/stored_item/vending_product/R, mob/user)
	var/mob/living/carbon/human/H = user
	if(!can_buy(R, user))	//For SECURE VENDING MACHINES YEAH
		to_chat(user, "<span class='warning'>Purchase not allowed.</span>")	//Unless emagged of course
		flick(icon_deny,entopic.my_image)
		return
	vend_ready = FALSE //One thing at a time!!
	SStgui.update_uis(src)

	if(R.category & CAT_COIN)
		if(!coin)
			to_chat(user, "<span class='notice'>You need to insert a coin to get this item.</span>")
			return
		if(coin.string_attached)
			if(prob(50))
				to_chat(user, "<span class='notice'>You successfully pull the coin out before \the [src] could swallow it.</span>")
			else
				to_chat(user, "<span class='notice'>You weren't able to pull the coin out fast enough, the machine ate it, string and all.</span>")
				qdel(coin)
				coin = null
				categories &= ~CAT_COIN
		else
			qdel(coin)
			coin = null
			categories &= ~CAT_COIN

	if(((last_reply + (vend_delay + 200)) <= world.time) && vend_reply)
		spawn(0)
			speak(vend_reply)
			last_reply = world.time

	use_power(vend_power_usage)	//Actuators and stuff
	spawn(vend_delay)
		R.amount--
		new R.item_path(H.nif)
		H.nif.notify("New software installed: [R.item_name]")
		flick(icon_vend,entopic.my_image)
		if(has_logs)
			do_logging(R, user, 1)

		vend_ready = 1
		currently_vending = null
		SStgui.update_uis(src)
	return TRUE
