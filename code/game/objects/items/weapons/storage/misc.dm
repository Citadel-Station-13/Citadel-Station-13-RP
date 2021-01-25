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

/obj/item/storage/box/donut/Initialize()
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

/obj/item/storage/box/wormcan/Initialize()
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
	desc = "A hunting grade survival knife. The handle is hollow and may be unscrewed to store small survival items. Inset circuitry running along the spine implies a technical utility."
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "survivalknife"
	item_state = "knife"
	max_storage_space = ITEMSIZE_COST_TINY * 3
	sharp = 1
	edge = 1
	force = 15
	throwforce = 15
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

/obj/item/storage/box/survival_knife/is_multitool()
	return TRUE