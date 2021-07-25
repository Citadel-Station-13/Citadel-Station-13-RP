/obj/item/stack/animalhide
	name = "hide"
	desc = "The hide of some creature."
	icon_state = "sheet-hide"
	drop_sound = 'sound/items/drop/cloth.ogg'
	pickup_sound = 'sound/items/pickup/cloth.ogg'
	amount = 1
	stacktype = "hide"
	no_variants = TRUE

	var/process_type = /obj/item/stack/material/hairlesshide

/obj/item/stack/material/animalhide/human
	name = "skin"
	desc = "The by-product of sapient farming."
	singular_name = "skin piece"
	icon_state = "sheet-hide"
	no_variants = FALSE
	drop_sound = 'sound/items/drop/cloth.ogg'
	pickup_sound = 'sound/items/pickup/cloth.ogg'
	amount = 1
	stacktype = "hide-human"

/obj/item/stack/material/animalhide/corgi
	name = "corgi hide"
	desc = "The by-product of corgi farming."
	singular_name = "corgi hide piece"
	icon_state = "sheet-corgi"
	amount = 1
	stacktype = "hide-corgi"

/obj/item/stack/material/animalhide/cat
	name = "cat hide"
	desc = "The by-product of cat farming."
	singular_name = "cat hide piece"
	icon_state = "sheet-cat"
	amount = 1
	stacktype = "hide-cat"

/obj/item/stack/material/animalhide/monkey
	name = "monkey hide"
	desc = "The by-product of monkey farming."
	singular_name = "monkey hide piece"
	icon_state = "sheet-monkey"
	amount = 1
	stacktype = "hide-monkey"

/obj/item/stack/material/animalhide/lizard
	name = "lizard skin"
	desc = "Sssssss..."
	singular_name = "lizard skin piece"
	icon_state = "sheet-lizard"
	amount = 1
	stacktype = "hide-lizard"

/obj/item/stack/material/animalhide/xeno
	name = "alien hide"
	desc = "The skin of a terrible creature."
	singular_name = "alien hide piece"
	icon_state = "sheet-xeno"
	amount = 1
	stacktype = "hide-xeno"

// Don't see anywhere else to put these, maybe together they could be used to make the xenos suit?
/obj/item/stack/material/xenochitin
	name = "alien chitin"
	desc = "A piece of the hide of a terrible creature."
	singular_name = "alien chitin piece"
	icon = 'icons/mob/alien.dmi'
	icon_state = "chitin"
	amount = 1
	stacktype = "hide-chitin"

/obj/item/xenos_claw
	name = "alien claw"
	desc = "The claw of a terrible creature."
	icon = 'icons/mob/alien.dmi'
	icon_state = "claw"

/obj/item/weed_extract
	name = "weed extract"
	desc = "A piece of slimy, purplish weed."
	icon = 'icons/mob/alien.dmi'
	icon_state = "weed_extract"

/obj/item/stack/material/hairlesshide
	name = "hairless hide"
	desc = "This hide was stripped of it's hair, but still needs tanning."
	singular_name = "hairless hide piece"
	icon_state = "sheet-hairlesshide"
	no_variants = FALSE
	amount = 1
	stacktype = "hairlesshide"
	var/cleaning = FALSE	// Can we be water_acted, or are we busy? To prevent accidental hide duplication and the collapse of causality.

	var/wet_type = /obj/item/stack/material/wetleather

/obj/item/stack/material/hairlesshide/water_act(var/wateramount)
	..()
	cleaning = TRUE
	while(amount > 0 && wateramount > 0)
		use(1)
		wateramount--
		new wet_type(get_turf(src))
	cleaning = FALSE

	return

/obj/item/stack/material/wetleather
	name = "wet leather"
	desc = "This leather has been cleaned but still needs to be dried."
	singular_name = "wet leather piece"
	icon_state = "sheet-wetleather"
	var/wetness = 30	// Reduced when exposed to high temperautres
	var/drying_threshold_temperature = 500	// Kelvin to start drying
	no_variants = FALSE
	amount = 1
	stacktype = "wetleather"

	var/dry_type = /obj/item/stack/material/leather

// Step one - dehairing.
/obj/item/stack/material/animalhide/attackby(obj/item/W as obj, mob/user as mob)
	if(has_edge(W) || is_sharp(W))
		// Visible message on mobs is defined as visible_message(var/message, var/self_message, var/blind_message)
		user.visible_message("<span class='notice'>\The [user] starts cutting hair off \the [src]</span>", "<span class='notice'>You start cutting the hair off \the [src]</span>", "You hear the sound of a knife rubbing against flesh")
		var/scraped = 0
		while(amount > 0 && do_after(user, 2.5 SECONDS)) // 2.5s per hide
			// Try locating an exisitng stack on the tile and add to there if possible
			var/obj/item/stack/material/hairlesshide/H = null
			for(var/obj/item/stack/material/hairlesshide/HS in user.loc)	// Could be scraping something inside a locker, hence the .loc, not get_turf
				if(HS.amount < HS.max_amount)
					H = HS
					break

			// Either we found a valid stack, in which case increment amount,
			// Or we need to make a new stack
			if(istype(H))
				H.amount++
			else
				H = new /obj/item/stack/material/hairlesshide(user.loc)

			// Increment the amount
			src.use(1)
			scraped++

		if(scraped)
			to_chat(user, SPAN_NOTICE("You scrape the hair off [scraped] hide\s."))
	else
		..()

// Step two - washing..... it's actually in washing machine code.

// Step three - drying
/obj/item/stack/material/wetleather/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	..()
	if(exposed_temperature >= drying_threshold_temperature)
		wetness--
		if(wetness == 0)
			dry()

/obj/item/stack/material/wetleather/proc/dry()
	// Try locating an exisitng stack on the tile and add to there if possible
	for(var/obj/item/stack/material/leather/HS in src.loc)
		if(HS.amount < 50)
			HS.amount++
			wetness = initial(wetness)
			src.use(1)
			return
	// If it gets to here it means it did not find a suitable stack on the tile.
	var/obj/item/stack/material/HS = new dry_type(src.loc)

	if(istype(HS))
		HS.amount = 1
	wetness = initial(wetness)
	src.use(1)
