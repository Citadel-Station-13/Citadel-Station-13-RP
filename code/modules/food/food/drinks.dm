////////////////////////////////////////////////////////////////////////////////
/// Drinks.
////////////////////////////////////////////////////////////////////////////////
//custom_open_sound is for a sound path to use instead of the default opening
//example: custom_open_sound = 'sound/soundbytes/effects/explosion/explosion1.ogg'
/obj/item/reagent_containers/food/drinks
	name = "drink"
	desc = "yummy"
	icon = 'icons/obj/drinks.dmi'
	drop_sound = 'sound/items/drop/bottle.ogg'
	pickup_sound = 'sound/items/pickup/bottle.ogg'
	icon_state = null
	atom_flags = OPENCONTAINER
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list(5,10,15,25,30)
	volume = 50
	var/custom_open_sound

/obj/item/reagent_containers/food/drinks/on_reagent_change()
	. = ..()
	if (reagents.total_volume)
		var/datum/reagent/R = reagents.get_majority_reagent_datum()
		if(R.price_tag)
			price_tag = R.price_tag
		else
			price_tag = null

/obj/item/reagent_containers/food/drinks/attack_self(mob/user, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	if(!is_open_container())
		open(user)

/obj/item/reagent_containers/food/drinks/proc/open(mob/user)
	if(custom_open_sound)
		playsound(loc,custom_open_sound, rand(10,50), 1)
	else
		playsound(loc,"canopen", rand(10,50), 1)
	to_chat(user, "<span class='notice'>You open [src] with an audible pop!</span>")
	atom_flags |= OPENCONTAINER

/obj/item/reagent_containers/food/drinks/legacy_mob_melee_hook(mob/target, mob/user, clickchain_flags, list/params, mult, target_zone, intent)
	if(user.a_intent == INTENT_HARM)
		return ..()
	. = CLICKCHAIN_DO_NOT_PROPAGATE
	standard_feed_mob(user, target)

/obj/item/reagent_containers/food/drinks/afterattack(atom/target, mob/user, clickchain_flags, list/params)
	if(!(clickchain_flags & CLICKCHAIN_HAS_PROXIMITY))
		return
	if(standard_dispenser_refill(user, target))
		return
	if(standard_pour_into(user, target))
		return
	return ..()

/obj/item/reagent_containers/food/drinks/standard_feed_mob(var/mob/user, var/mob/target)
	if(!is_open_container())
		to_chat(user, "<span class='notice'>You need to open [src]!</span>")
		return 1
	return ..()

/obj/item/reagent_containers/food/drinks/standard_dispenser_refill(var/mob/user, var/obj/structure/reagent_dispensers/target)
	if(!is_open_container())
		to_chat(user, "<span class='notice'>You need to open [src]!</span>")
		return 1
	return ..()

/obj/item/reagent_containers/food/drinks/standard_pour_into(var/mob/user, var/atom/target)
	if(!is_open_container() && target.reagents)
		to_chat(user, "<span class='notice'>You need to open [src]!</span>")
		return 1
	if(target == loc) //prevent filling a machine with a glass you just put into it.
		return 1
	return ..()

/obj/item/reagent_containers/food/drinks/self_feed_message(var/mob/user)
	to_chat(user, "<span class='notice'>You swallow a gulp from \the [src].</span>")

/obj/item/reagent_containers/food/drinks/feed_sound(var/mob/user)
	playsound(user.loc, 'sound/items/drink.ogg', rand(10, 50), 1)

/obj/item/reagent_containers/food/drinks/examine(mob/user, dist)
	. = ..()
	if(!reagents || reagents.total_volume == 0)
		. += "<span class='notice'>\The [src] is empty!</span>"
	else if (reagents.total_volume <= volume * 0.25)
		. += "<span class='notice'>\The [src] is almost empty!</span>"
	else if (reagents.total_volume <= volume * 0.66)
		. += "<span class='notice'>\The [src] is half full!</span>"
	else if (reagents.total_volume <= volume * 0.90)
		. += "<span class='notice'>\The [src] is almost full!</span>"
	else
		. += "<span class='notice'>\The [src] is full!</span>"
	if(reagents)
		var/datum/reagent/ethanol/R = locate() in reagents.get_reagent_datums()
		if(istype(R))
			. += "<span class='notice'>It contains alcohol.</span>"


////////////////////////////////////////////////////////////////////////////////
/// Drinks. END
////////////////////////////////////////////////////////////////////////////////

/obj/item/reagent_containers/food/drinks/golden_cup
	desc = "A golden cup"
	name = "golden cup"
	icon_state = "golden_cup"
	item_state = "" //nope :(
	w_class = WEIGHT_CLASS_BULKY
	damage_force = 14
	throw_force = 10
	amount_per_transfer_from_this = 20
	possible_transfer_amounts = null
	volume = 150
	atom_flags = OPENCONTAINER

//Notes by Darem: Drinks are simply containers that start preloaded. Unlike condiments, the contents can be ingested directly
//	rather then having to add it to something else first. They should only contain liquids. They have a default container size of 50.
//	Formatting is the same as food.


/obj/item/reagent_containers/food/drinks/coffee
	name = "\improper Robust Coffee"
	desc = "Careful, the beverage you're about to enjoy is extremely hot."
	icon_state = "coffee"
	center_of_mass = list("x"=15, "y"=10)
	drop_sound = 'sound/items/drop/papercup.ogg'
	pickup_sound = 'sound/items/pickup/papercup.ogg'
/obj/item/reagent_containers/food/drinks/coffee/Initialize(mapload)
	. = ..()
	reagents.add_reagent("coffee", 30)

/obj/item/reagent_containers/food/drinks/tea
	name = "cup of Duke Purple Tea"
	desc = "An insult to Duke Purple is an insult to the Space Queen! Any proper gentleman will fight you, if you sully this tea."
	icon_state = "teacup"
	item_state = "coffee"
	center_of_mass = list("x"=16, "y"=14)
	drop_sound = 'sound/items/drop/papercup.ogg'
	pickup_sound = 'sound/items/pickup/papercup.ogg'

/obj/item/reagent_containers/food/drinks/tea/Initialize(mapload)
	. = ..()
	reagents.add_reagent("tea", 30)

/obj/item/reagent_containers/food/drinks/ice
	name = "cup of ice"
	desc = "Careful, cold ice, do not chew."
	icon_state = "coffee"
	center_of_mass = list("x"=15, "y"=10)
/obj/item/reagent_containers/food/drinks/ice/Initialize(mapload)
	. = ..()
	reagents.add_reagent("ice", 30)

/obj/item/reagent_containers/food/drinks/h_chocolate
	name = "cup of Dutch hot coco"
	desc = "Made in Space South America."
	icon_state = "hot_coco"
	item_state = "coffee"
	center_of_mass = list("x"=15, "y"=13)

/obj/item/reagent_containers/food/drinks/h_chocolate/Initialize(mapload)
	. = ..()
	reagents.add_reagent("hot_coco", 30)

/obj/item/reagent_containers/food/drinks/dry_ramen
	name = "Cup Ramen"
	desc = "Just add 10ml water, self heats! A taste that reminds you of your school years."
	icon_state = "ramen"
	center_of_mass = list("x"=16, "y"=11)

/obj/item/reagent_containers/food/drinks/dry_ramen/Initialize(mapload)
	. = ..()
	reagents.add_reagent("dry_ramen", 30)

/obj/item/reagent_containers/food/drinks/sillycup
	name = "paper cup"
	desc = "A paper water cup."
	icon_state = "water_cup_e"
	possible_transfer_amounts = null
	volume = 10
	center_of_mass = list("x"=16, "y"=12)

/obj/item/reagent_containers/food/drinks/sillycup/on_reagent_change()
	..()
	if(reagents.total_volume)
		icon_state = "water_cup"
	else
		icon_state = "water_cup_e"

/obj/item/reagent_containers/food/drinks/sillycup/OnMouseDropLegacy(obj/over_object as obj)
	if(!reagents.total_volume && istype(over_object, /obj/structure/reagent_dispensers/water_cooler))
		if(over_object.Adjacent(usr))
			var/obj/structure/reagent_dispensers/water_cooler/W = over_object
			if(W.cupholder && W.cups < 10)
				W.cups++
				to_chat(usr, "<span class='notice'>You put the [src] in the cup dispenser.</span>")
				qdel(src)
				W.update_icon()
	else
		return ..()

//Coffeepots: for reference, a standard cup is 30u, to allow 20u for sugar/sweetener/milk/creamer
/obj/item/reagent_containers/food/drinks/coffeepot
	name = "coffeepot"
	desc = "A large pot for dispensing that ambrosia of corporate life known to mortals only as coffee. Contains 4 standard cups."
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5, 10, 15, 20, 25, 30, 50)
	volume = 120
	icon_state = "coffeepot"
	fill_icon_state = "coffeepot"
	fill_icon_thresholds = list(0, 1, 40, 80, 120)
	atom_flags = OPENCONTAINER
	materials_base = list(MAT_GLASS = 500, MAT_STEEL = 500)

/obj/item/reagent_containers/food/drinks/coffeepot/bluespace
	name = "bluespace coffeepot"
	desc = "The most advanced coffeepot the eggheads could cook up: sleek design; graduated lines; connection to a pocket dimension for coffee containment; yep, it's got it all. Contains 8 standard cups."
	volume = 240
	icon_state = "coffeepot_bluespace"
	fill_icon_thresholds = list(0, 1, 40, 80, 120)

/obj/item/reagent_containers/food/drinks/mug/nanotrasen
	name = "\improper Nanotrasen mug"
	desc = "A mug to display your corporate pride."
	icon_state = "mug_nt_empty"
	atom_flags = OPENCONTAINER

/obj/item/reagent_containers/food/drinks/mug/nanotrasen/update_icon_state()
	icon_state = reagents.total_volume ? "mug_nt" : "mug_nt_empty"
	return ..()

/obj/item/reagent_containers/food/drinks/coffee_cup
	name = "coffee cup"
	desc = "A heat-formed plastic coffee cup. Can theoretically be used for other hot drinks, if you're feeling adventurous."
	icon_state = "coffee_cup_e"
	possible_transfer_amounts = list(10)
	volume = 30
	atom_flags = OPENCONTAINER
	drop_sound = 'sound/items/drop/papercup.ogg'
	pickup_sound = 'sound/items/pickup/papercup.ogg'

/obj/item/reagent_containers/food/drinks/coffee_cup/update_icon_state()
	icon_state = reagents.total_volume ? "coffee_cup" : "coffee_cup_e"
	return ..()

/obj/item/reagent_containers/food/drinks/coffee_cup/on_reagent_change()
	. = ..()
	update_icon()
