/obj/item/stack/animalhide
	name = "animal hide"
	desc = "Intact skin stripped off from a creature's body."
	singular_name = "hide piece"
	icon_state = "sheet-hide"
	no_variants = FALSE
	drop_sound = 'sound/items/drop/cloth.ogg'
	pickup_sound = 'sound/items/pickup/cloth.ogg'

/obj/fiftyspawner/animalhide
	name = "animal hide"
	type_to_spawn = /obj/item/stack/animalhide

/obj/item/stack/animalhide/grey
	icon_state = "sheet-greyhide"

/obj/item/stack/animalhide/human
	name = "human skin"
	desc = "The by-product of human farming."
	singular_name = "human skin piece"
	icon_state = "sheet-hide"

/obj/fiftyspawner/animalhide/human
	name = "human hide"
	type_to_spawn = /obj/item/stack/animalhide/human

/obj/item/stack/animalhide/corgi
	name = "corgi hide"
	desc = "The by-product of corgi farming."
	singular_name = "corgi hide piece"
	icon_state = "sheet-corgi"

/obj/fiftyspawner/animalhide/corgi
	name = "corgi hide"
	type_to_spawn = /obj/item/stack/animalhide/corgi

/obj/item/stack/animalhide/cat
	name = "cat hide"
	desc = "The by-product of cat farming."
	singular_name = "cat hide piece"
	icon_state = "sheet-cat"

/obj/fiftyspawner/animalhide/cat
	name = "feline hide"
	type_to_spawn = /obj/item/stack/animalhide/cat

/obj/item/stack/animalhide/monkey
	name = "monkey hide"
	desc = "The by-product of monkey farming."
	singular_name = "monkey hide piece"
	icon_state = "sheet-monkey"

/obj/fiftyspawner/animalhide/monkey
	name = "monkey hide"
	type_to_spawn = /obj/item/stack/animalhide/monkey

/obj/item/stack/animalhide/lizard
	name = "lizard skin"
	desc = "Sssssss..."
	singular_name = "lizard skin piece"
	icon_state = "sheet-lizard"

/obj/fiftyspawner/animalhide/lizard
	name = "lizard hide"
	type_to_spawn = /obj/item/stack/animalhide/lizard

/obj/item/stack/animalhide/xeno
	name = "alien hide"
	desc = "The skin of a terrible creature."
	singular_name = "alien hide piece"
	icon_state = "sheet-xeno"

/obj/fiftyspawner/animalhide/xeno
	name = "xenomorph hide"
	type_to_spawn = /obj/item/stack/animalhide/xeno

//don't see anywhere else to put these, maybe together they could be used to make the xenos suit?
/obj/item/stack/xenochitin
	name = "alien chitin"
	desc = "A piece of the hide of a terrible creature."
	singular_name = "alien hide piece"
	icon = 'icons/mob/alien.dmi'
	icon_state = "chitin"

/obj/fiftyspawner/xenochitin
	name = "stack of xenochitin"
	type_to_spawn = /obj/item/stack/xenochitin

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

/obj/item/stack/hairlesshide
	name = "hairless hide"
	desc = "This smooth hide needs tanning before it can become leather."
	singular_name = "hairless hide piece"
	icon_state = "sheet-hairlesshide"
	no_variants = FALSE

/obj/fiftyspawner/hairlesshide
	name = "hairless hide"
	type_to_spawn = /obj/item/stack/hairlesshide

/*
 * Sinew
 */
/obj/item/stack/sinew
	name = "sinew"
	desc = "Long stringy filaments which presumably came from an organic creature."
	singular_name = "sinew"
	icon_state = "sheet-sinew"

/obj/fiftyspawner/sinew
	name = "stack of sinew"
	type_to_spawn = /obj/item/stack/sinew

/obj/item/stack/sinew/watcher
	name = "watcher sinew"
	desc = "Long stringy filaments which presumably came from a watcher's wings."
	singular_name = "watcher sinew"

/obj/item/stack/sinew/wolf
	name = "wolf sinew"
	desc = "Long stringy filaments which came from the insides of a wolf."
	singular_name = "wolf sinew"

/*
 * Plates
*/
/obj/item/stack/animalhide/goliath_hide
	name = "goliath hide plates"
	desc = "Pieces of a goliath's rocky hide, these might be able to make your suit a bit more durable to attack from the local fauna."
	icon_state = "sheet-goliath_hide"
	singular_name = "hide plate"
	max_amount = 6
	item_flags = ITEM_NOBLUDGEON
	w_class = WEIGHT_CLASS_NORMAL
	layer = MOB_LAYER

/obj/fiftyspawner/animalhide/goliath_hide
	name = "goliath hide plates"
	type_to_spawn = /obj/item/stack/animalhide/goliath_hide

/obj/item/stack/animalhide/goliath_hide/polar_bear_hide
	name = "polar bear hides"
	desc = "Pieces of a polar bear's fur, these might be able to make your suit a bit more durable to attack from the local fauna."
	icon_state = "sheet-polar_bear_hide"
	singular_name = "polar bear hide"

/obj/fiftyspawner/animalhide/goliath_hide/polar_bear_hide
	name = "polar bear hide plates"
	type_to_spawn = /obj/item/stack/animalhide/goliath_hide/polar_bear_hide

/obj/item/stack/animalhide/ashdrake
	name = "ash drake hide"
	desc = "The strong, scaled hide of an ash drake."
	icon_state = "sheet-dragon_hide"
	singular_name = "drake plate"
	max_amount = 10
	item_flags = ITEM_NOBLUDGEON
	w_class = WEIGHT_CLASS_NORMAL
	layer = MOB_LAYER

/obj/item/stack/wetleather
	name = "wet leather"
	desc = "This leather has been cleaned but still needs to be dried."
	singular_name = "wet leather piece"
	icon_state = "sheet-wetleather"
	var/wetness = 30 //Reduced when exposed to high temperautres
	var/drying_threshold_temperature = 500 //Kelvin to start drying
	no_variants = FALSE

/obj/fiftyspawner/wetleather
	name = "stack of wet leather"
	type_to_spawn = /obj/item/stack/wetleather

//Step one - dehairing.
/obj/item/stack/animalhide/attackby(obj/item/W as obj, mob/user as mob)
	if(	istype(W, /obj/item/material/knife) || \
		istype(W, /obj/item/material/twohanded/fireaxe) || \
		istype(W, /obj/item/material/knife/machete/hatchet) )

		//visible message on mobs is defined as visible_message(var/message, var/self_message, var/blind_message)
		usr.visible_message("<span class='notice'>\The [usr] starts cutting hair off \the [src]</span>", "<span class='notice'>You start cutting the hair off \the [src]</span>", "You hear the sound of a knife rubbing against flesh")
		if(do_after(user,50))
			to_chat(usr, "<span class='notice'>You cut the hair from this [src.singular_name]</span>")
			//Try locating an exisitng stack on the tile and add to there if possible
			for(var/obj/item/stack/hairlesshide/HS in usr.loc)
				if(HS.amount < 50)
					HS.amount++
					src.use(1)
					break
			//If it gets to here it means it did not find a suitable stack on the tile.
			var/obj/item/stack/hairlesshide/HS = new(usr.loc)
			HS.amount = 1
			src.use(1)
	else
		..()

//Step two - This was originally busted washing machine code. Now it's a sink attack.

//Step three - drying
/obj/item/stack/wetleather/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	..()
	if(exposed_temperature >= drying_threshold_temperature)
		wetness--
		if(wetness == 0)
			//Try locating an exisitng stack on the tile and add to there if possible
			for(var/obj/item/stack/material/leather/HS in src.loc)
				if(HS.amount < 50)
					HS.amount++
					src.use(1)
					wetness = initial(wetness)
					break
			//If it gets to here it means it did not find a suitable stack on the tile.
			var/obj/item/stack/material/leather/HS = new(src.loc)
			HS.amount = 1
			wetness = initial(wetness)
			src.use(1)
