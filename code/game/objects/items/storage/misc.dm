/*
 * Donut Box
 */

/obj/item/storage/box/donut
	icon = 'icons/obj/food.dmi'
	icon_state = "donutbox"
	name = "donut box"
	max_storage_space = ITEMSIZE_COST_SMALL * 6
	can_hold = list(/obj/item/reagent_containers/food/snacks/donut)
	foldable = /obj/item/stack/material/cardboard
	starts_with = list(/obj/item/reagent_containers/food/snacks/donut/normal = 6)

/obj/item/storage/box/donut/Initialize(mapload)
	. = ..()
	update_icon()

/obj/item/storage/box/donut/update_icon()
	overlays.Cut()
	var/i = 0
	for(var/obj/item/reagent_containers/food/snacks/donut/D in contents)
		overlays += image('icons/obj/food.dmi', "[i][D.overlay_state]")
		i++

/obj/item/storage/box/donut/empty
	empty = TRUE

/obj/item/storage/box/wormcan
	icon = 'icons/obj/food.dmi'
	icon_state = "wormcan"
	name = "can of worms"
	desc = "You probably do want to open this can of worms."
	max_storage_space = ITEMSIZE_COST_TINY * 6
	can_hold = list(
		/obj/item/reagent_containers/food/snacks/wormsickly,
		/obj/item/reagent_containers/food/snacks/worm,
		/obj/item/reagent_containers/food/snacks/wormdeluxe
	)
	starts_with = list(/obj/item/reagent_containers/food/snacks/worm = 6)

/obj/item/storage/box/wormcan/Initialize(mapload)
	. = ..()
	update_icon()

/obj/item/storage/box/wormcan/update_icon(var/itemremoved = 0)
	if (contents.len == 0)
		icon_state = "wormcan_empty"

/obj/item/storage/box/wormcan/sickly
	icon_state = "wormcan_sickly"
	name = "can of sickly worms"
	desc = "You probably don't want to open this can of worms."
	max_storage_space = ITEMSIZE_COST_TINY * 6
	starts_with = list(/obj/item/reagent_containers/food/snacks/wormsickly = 6)

/obj/item/storage/box/wormcan/sickly/update_icon(var/itemremoved = 0)
	if (contents.len == 0)
		icon_state = "wormcan_empty_sickly"

/obj/item/storage/box/wormcan/deluxe
	icon_state = "wormcan_deluxe"
	name = "can of deluxe worms"
	desc = "You absolutely want to open this can of worms."
	max_storage_space = ITEMSIZE_COST_TINY * 6
	starts_with = list(/obj/item/reagent_containers/food/snacks/wormdeluxe = 6)

/obj/item/storage/box/wormcan/deluxe/update_icon(var/itemremoved = 0)
	if (contents.len == 0)
		icon_state = "wormcan_empty_deluxe"

//Snowflake Survival Knife Code
/obj/item/storage/box/survival_knife
	name = "survival knife"
	desc = "A hunting grade survival knife. The handle is hollow and may be unscrewed to store small survival items."
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "survivalknife"
	item_state = "knife"
	max_storage_space = ITEMSIZE_COST_TINY * 3
	sharp = 1
	edge = 1
	force = 15
	throw_force = 15
	attack_verb = list("stabbed", "chopped", "cut")
	hitsound = 'sound/weapons/bladeslice.ogg'
	can_hold = list(
		/obj/item/pen/crayon/chalk,
		/obj/item/reagent_containers/pill,
		/obj/item/gps/survival,
		/obj/item/flame/match,
		/obj/item/flame/lighter
		)
	starts_with = list(/obj/item/pen/crayon/chalk, /obj/item/reagent_containers/pill/nutriment, /obj/item/gps/survival)

/obj/item/storage/box/papersack
	name = "paper sack"
	desc = "A sack neatly crafted out of paper."
	icon_state = "paperbag_None"
	item_state = "paperbag_None"
	slot_flags = SLOT_HEAD
	/// A list of all available papersack reskins
	var/list/papersack_designs = list()

/obj/item/storage/box/papersack/Initialize(mapload)
	. = ..()
	papersack_designs = sortList(list(
		"None" = image(icon = src.icon, icon_state = "paperbag_None"),
		"NanotrasenStandard" = image(icon = src.icon, icon_state = "paperbag_NanotrasenStandard"),
		"SyndiSnacks" = image(icon = src.icon, icon_state = "paperbag_SyndiSnacks"),
		"Heart" = image(icon = src.icon, icon_state = "paperbag_Heart"),
		"SmileyFace" = image(icon = src.icon, icon_state = "paperbag_SmileyFace")
		))

/obj/item/storage/box/papersack/update_icon_state()
	. = ..()
	if(contents.len == 0)
		icon_state = "[item_state]"
	else
		icon_state = "[item_state]_closed"

/obj/item/storage/box/papersack/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/pen))
		var/choice = show_radial_menu(user, src , papersack_designs, custom_check = CALLBACK(src, .proc/check_menu, user, W), radius = 36, require_near = TRUE)
		if(!choice)
			return FALSE
		if(icon_state == "paperbag_[choice]")
			return FALSE
		switch(choice)
			if("None")
				desc = "A sack neatly crafted out of paper."
			if("NanotrasenStandard")
				desc = "A standard Nanotrasen paper lunch sack for loyal employees on the go."
			if("SyndiSnacks")
				desc = "The design on this paper sack is a remnant of the notorious 'SyndieSnacks' program."
			if("Heart")
				desc = "A paper sack with a heart etched onto the side."
			if("SmileyFace")
				desc = "A paper sack with a crude smile etched onto the side."
			else
				return FALSE
		to_chat(user, "<span class='notice'>You make some modifications to [src] using your pen.</span>")
		icon_state = "paperbag_[choice]"
		item_state = "paperbag_[choice]"
		return FALSE
	else if(is_sharp())
		if(!contents.len)
			if(item_state == "paperbag_None")
				to_chat("<span class='notice'>You cut eyeholes into [src].</span>")
				new /obj/item/clothing/head/papersack(user.loc)
				qdel(src)
				return FALSE
			else if(item_state == "paperbag_SmileyFace")
				to_chat("<span class='notice'>You cut eyeholes into [src] and modify the design.</span>")
				new /obj/item/clothing/head/papersack/smiley(user.loc)
				qdel(src)
				return FALSE
	return ..()

/**
  * check_menu: Checks if we are allowed to interact with a radial menu
  *
  * Arguments:
  * * user The mob interacting with a menu
  * * P The pen used to interact with a menu
  */
/obj/item/storage/box/papersack/proc/check_menu(mob/user, obj/item/pen/P)
	if(!istype(user))
		return FALSE
	if(user.incapacitated())
		return FALSE
	if(contents.len)
		to_chat(user, "<span class='warning'>You can't modify [src] with items still inside!</span>")
		return FALSE
	if(!P)
		to_chat(user, "<span class='warning'>You need a pen to modify [src]!</span>")
		return FALSE
	return TRUE

//Ashlander Ammo Box - Exists mostly for ease of equipment @ spawn.
/obj/item/storage/box/munition_box
	name = "munition box (musket)"
	desc = "A tanned leather pouch large enough to hold a few loose musket balls."
	icon_state = "musket_box"
	max_storage_space = ITEMSIZE_COST_TINY * 6
	can_hold = list(
		/obj/item/ammo_casing/musket
		)
	starts_with = list(/obj/item/ammo_casing/musket = 6)
