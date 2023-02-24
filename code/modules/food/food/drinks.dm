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
	if (reagents.reagent_list.len > 0)
		var/datum/reagent/R = reagents.get_master_reagent()
		if(R.price_tag)
			price_tag = R.price_tag
		else
			price_tag = null
	return

/obj/item/reagent_containers/food/drinks/attack_self(mob/user as mob)
	if(!is_open_container())
		open(user)

/obj/item/reagent_containers/food/drinks/proc/open(mob/user)
	if(custom_open_sound)
		playsound(loc,custom_open_sound, rand(10,50), 1)
	else
		playsound(loc,"canopen", rand(10,50), 1)
	to_chat(user, "<span class='notice'>You open [src] with an audible pop!</span>")
	atom_flags |= OPENCONTAINER

/obj/item/reagent_containers/food/drinks/attack_mob(mob/target, mob/user, clickchain_flags, list/params, mult, target_zone, intent)
	if(user.a_intent == INTENT_HARM)
		return ..()
	. = CLICKCHAIN_DO_NOT_PROPAGATE
	standard_feed_mob(user, target)

/obj/item/reagent_containers/food/drinks/afterattack(obj/target, mob/user, proximity)
	if(!proximity)
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
	if(!is_open_container())
		to_chat(user, "<span class='notice'>You need to open [src]!</span>")
		return 1
	if(target == loc) //prevent filling a machine with a glass you just put into it.
		return 1
	return ..()

/obj/item/reagent_containers/food/drinks/self_feed_message(var/mob/user)
	to_chat(user, "<span class='notice'>You swallow a gulp from \the [src].</span>")

/obj/item/reagent_containers/food/drinks/feed_sound(var/mob/user)
	playsound(user.loc, 'sound/items/drink.ogg', rand(10, 50), 1)

/obj/item/reagent_containers/food/drinks/examine(mob/user)
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


////////////////////////////////////////////////////////////////////////////////
/// Drinks. END
////////////////////////////////////////////////////////////////////////////////

/obj/item/reagent_containers/food/drinks/golden_cup
	desc = "A golden cup"
	name = "golden cup"
	icon_state = "golden_cup"
	item_state = "" //nope :(
	w_class = ITEMSIZE_LARGE
	force = 14
	throw_force = 10
	amount_per_transfer_from_this = 20
	possible_transfer_amounts = null
	volume = 150
	atom_flags = OPENCONTAINER

/obj/item/reagent_containers/food/drinks/golden_cup/on_reagent_change()
	..()

///////////////////////////////////////////////Drinks
//Notes by Darem: Drinks are simply containers that start preloaded. Unlike condiments, the contents can be ingested directly
//	rather then having to add it to something else first. They should only contain liquids. They have a default container size of 50.
//	Formatting is the same as food.

/obj/item/reagent_containers/food/drinks/milk
	name = "milk carton"
	desc = "It's milk. White and nutritious goodness!"
	icon_state = "milk"
	item_state = "carton"
	center_of_mass = list("x"=16, "y"=9)
	drop_sound = 'sound/items/drop/cardboardbox.ogg'
	pickup_sound = 'sound/items/pickup/cardboardbox.ogg'


/obj/item/reagent_containers/food/drinks/milk/Initialize(mapload)
	. = ..()
	reagents.add_reagent("milk", 50)

/obj/item/reagent_containers/food/drinks/soymilk
	name = "soymilk carton"
	desc = "It's soy milk. White and nutritious goodness!"
	icon_state = "soymilk"
	item_state = "carton"
	center_of_mass = list("x"=16, "y"=9)
	drop_sound = 'sound/items/drop/cardboardbox.ogg'
	pickup_sound = 'sound/items/pickup/cardboardbox.ogg'

/obj/item/reagent_containers/food/drinks/soymilk/Initialize(mapload)
	. = ..()
	reagents.add_reagent("soymilk", 50)

/obj/item/reagent_containers/food/drinks/smallmilk
	name = "small milk carton"
	desc = "It's milk. White and nutritious goodness!"
	volume = 30
	icon_state = "mini-milk"
	item_state = "carton"
	center_of_mass = list("x"=16, "y"=9)
	drop_sound = 'sound/items/drop/cardboardbox.ogg'
	pickup_sound = 'sound/items/pickup/cardboardbox.ogg'
/obj/item/reagent_containers/food/drinks/smallmilk/Initialize(mapload)
	. = ..()
	reagents.add_reagent("milk", 30)

/obj/item/reagent_containers/food/drinks/smallchocmilk
	name = "small chocolate milk carton"
	desc = "It's milk! This one is in delicious chocolate flavour."
	volume = 30
	icon_state = "mini-milk_choco"
	item_state = "carton"
	center_of_mass = list("x"=16, "y"=9)
	drop_sound = 'sound/items/drop/cardboardbox.ogg'
	pickup_sound = 'sound/items/pickup/cardboardbox.ogg'
/obj/item/reagent_containers/food/drinks/smallchocmilk/Initialize(mapload)
	. = ..()
	reagents.add_reagent("chocolate_milk", 30)

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

/obj/item/reagent_containers/food/drinks/bludboxmax
	name = "Bludbox MAX carton"
	desc = "A vampire's best friend! This Bludbox contains only the most delicious of organic, free-range O-Negatives. For all your dietry needs!"
	volume = 30
	icon_state = "bludboxmax"
	center_of_mass = list("x"=16, "y"=9)
	drop_sound = 'sound/items/drop/cardboardbox.ogg'
	pickup_sound = 'sound/items/pickup/cardboardbox.ogg'

/obj/item/reagent_containers/food/drinks/bludboxmax/Initialize(mapload)
	. = ..()
	reagents.add_reagent("blood", 30)

/obj/item/reagent_containers/food/drinks/bludboxmaxlight
	name = "Bludbox MAX Light carton"
	desc = "A bloodsucking vegan's hipster alternative to drinking the red stuff. Bludbox light is just the same as drinking straight from the source! Comes in O- flavour."
	volume = 30
	icon_state = "bludboxmaxlight"
	center_of_mass = list("x"=16, "y"=9)
	drop_sound = 'sound/items/drop/cardboardbox.ogg'
	pickup_sound = 'sound/items/pickup/cardboardbox.ogg'

/obj/item/reagent_containers/food/drinks/bludboxmaxlight/Initialize(mapload)
	. = ..()
	reagents.add_reagent("synthblood", 30)

/obj/item/reagent_containers/food/drinks/bludbox
	name = "Bludbox carton"
	desc = "The pop alternative to drinking real, human blood! Comes in blood flavour and contains all the dietry requirements for your undead friends."
	volume = 30
	icon_state = "bludbox"
	center_of_mass = list("x"=16, "y"=9)
	drop_sound = 'sound/items/drop/cardboardbox.ogg'
	pickup_sound = 'sound/items/pickup/cardboardbox.ogg'

/obj/item/reagent_containers/food/drinks/bludbox/Initialize(mapload)
	. = ..()
	reagents.add_reagent("blud", 30)

/obj/item/reagent_containers/food/drinks/bludboxlight
	name = "Bludbox Light carton"
	desc = "The pop alternative to drinking real, human blood! Comes in blood flavour and contains all the dietry requirements for your undead friends. This one has less sweeteners, gross!"
	volume = 30
	icon_state = "bludboxlight"
	center_of_mass = list("x"=16, "y"=9)
	drop_sound = 'sound/items/drop/cardboardbox.ogg'
	pickup_sound = 'sound/items/pickup/cardboardbox.ogg'

/obj/item/reagent_containers/food/drinks/bludboxlight/Initialize(mapload)
	. = ..()
	reagents.add_reagent("bludlight", 30)

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

//////////////////////////drinkingglass and shaker//
//Note by Darem: This code handles the mixing of drinks. New drinks go in three places: In Chemistry-Reagents.dm (for the drink
//	itself), in Chemistry-Recipes.dm (for the reaction that changes the components into the drink), and here (for the drinking glass
//	icon states.

/obj/item/reagent_containers/food/drinks/shaker
	name = "shaker"
	desc = "A metal shaker to mix drinks in."
	icon_state = "shaker"
	amount_per_transfer_from_this = 10
	volume = 120
	center_of_mass = list("x"=17, "y"=10)

/obj/item/reagent_containers/food/drinks/shaker/on_reagent_change()
	..()

/obj/item/reagent_containers/food/drinks/teapot
	name = "teapot"
	desc = "An elegant teapot. It simply oozes class."
	icon_state = "teapot"
	item_state = "teapot"
	amount_per_transfer_from_this = 10
	volume = 120
	center_of_mass = list("x"=17, "y"=7)

/obj/item/reagent_containers/food/drinks/teapot/on_reagent_change()
	..()

/obj/item/reagent_containers/food/drinks/flask
	name = "\improper Facility Director's flask"
	desc = "A metal flask belonging to the Facility Director"
	icon_state = "flask"
	volume = 60
	center_of_mass = list("x"=17, "y"=7)

/obj/item/reagent_containers/food/drinks/flask/on_reagent_change()
	..()

/obj/item/reagent_containers/food/drinks/flask/shiny
	name = "shiny flask"
	desc = "A shiny metal flask. It appears to have a Greek symbol inscribed on it."
	icon_state = "shinyflask"

/obj/item/reagent_containers/food/drinks/flask/lithium
	name = "lithium flask"
	desc = "A flask with a Lithium Atom symbol on it."
	icon_state = "lithiumflask"

/obj/item/reagent_containers/food/drinks/flask/detflask
	name = "\improper Detective's flask"
	desc = "A metal flask with a leather band and golden badge belonging to the detective."
	icon_state = "detflask"
	volume = 60
	center_of_mass = list("x"=17, "y"=8)

/obj/item/reagent_containers/food/drinks/flask/barflask
	name = "flask"
	desc = "For those who can't be bothered to hang out at the bar to drink."
	icon_state = "barflask"
	volume = 60
	center_of_mass = list("x"=17, "y"=7)

/obj/item/reagent_containers/food/drinks/flask/vacuumflask
	name = "vacuum flask"
	desc = "Keeping your drinks at the perfect temperature since 1892."
	icon_state = "vacuumflask"
	volume = 60
	center_of_mass = list("x"=15, "y"=4)

/obj/item/reagent_containers/food/drinks/britcup
	name = "cup"
	desc = "A cup with the British flag emblazoned on it."
	icon_state = "britcup"
	volume = 30
	center_of_mass = list("x"=15, "y"=13)

/obj/item/reagent_containers/food/drinks/britcup/on_reagent_change()
	..()
