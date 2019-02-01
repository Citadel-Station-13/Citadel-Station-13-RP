/obj/item/weapon/reagent_containers/food/snacks/
	var/datum/reagent/nutriment/coating/coating = null
	var/icon/flat_icon = null //Used to cache a flat icon generated from dipping in batter. This is used again to make the cooked-batter-overlay
	var/do_coating_prefix = 1
	//If 0, we wont do "battered thing" or similar prefixes. Mainly for recipes that include batter but have a special name

	var/cooked_icon = null
	//Used for foods that are "cooked" without being made into a specific recipe or combination.
	//Generally applied during modification cooking with oven/fryer
	//Used to stop deepfried meat from looking like slightly tanned raw meat, and make it actually look cooked

//Code for dipping food in batter
/obj/item/weapon/reagent_containers/food/snacks/afterattack(obj/O as obj, mob/user as mob, proximity)
	if(O.is_open_container() && O.reagents && !(istype(O, /obj/item/weapon/reagent_containers/food)))
		for (var/r in O.reagents.reagent_list)

			var/datum/reagent/R = r
			if (istype(R, /datum/reagent/nutriment/coating))
				if (apply_coating(R, user))
					return 1

	return ..()

//This proc handles drawing coatings out of a container when this food is dipped into it
/obj/item/weapon/reagent_containers/food/snacks/proc/apply_coating(var/datum/reagent/nutriment/coating/C, var/mob/user)
	if (coating)
		user << "The [src] is already coated in [coating.name]!"
		return 0

	//Calculate the reagents of the coating needed
	var/req = 0
	for (var/r in reagents.reagent_list)
		var/datum/reagent/R = r
		if (istype(R, /datum/reagent/nutriment))
			req += R.volume * 0.2
		else
			req += R.volume * 0.1

	req += w_class*0.5

	if (!req)
		//the food has no reagents left, its probably getting deleted soon
		return 0

	if (C.volume < req)
		user << span("warning", "There's not enough [C.name] to coat the [src]!")
		return 0

	var/id = C.id

	//First make sure there's space for our batter
	if (reagents.get_free_space() < req+5)
		var/extra = req+5 - reagents.get_free_space()
		reagents.maximum_volume += extra

	//Suck the coating out of the holder
	C.holder.trans_to_holder(reagents, req)

	//We're done with C now, repurpose the var to hold a reference to our local instance of it
	C = reagents.get_reagent(id)
	if (!C)
		return

	coating = C
	//Now we have to do the witchcraft with masking images
	//var/icon/I = new /icon(icon, icon_state)

	if (!flat_icon)
		flat_icon = getFlatIcon(src)
	var/icon/I = flat_icon
	color = "#FFFFFF" //Some fruits use the color var. Reset this so it doesnt tint the batter
	I.Blend(new /icon('icons/obj/food_custom.dmi', rgb(255,255,255)),ICON_ADD)
	I.Blend(new /icon('icons/obj/food_custom.dmi', coating.icon_raw),ICON_MULTIPLY)
	var/image/J = image(I)
	J.alpha = 200
	J.blend_mode = BLEND_OVERLAY
	J.tag = "coating"
	overlays += J

	if (user)
		user.visible_message(span("notice", "[user] dips \the [src] into \the [coating.name]"), span("notice", "You dip \the [src] into \the [coating.name]"))

	return 1


//Called by cooking machines. This is mainly intended to set properties on the food that differ between raw/cooked
/obj/item/weapon/reagent_containers/food/snacks/proc/cook()
	if (coating)
		var/list/temp = overlays.Copy()
		for (var/i in temp)
			if (istype(i, /image))
				var/image/I = i
				if (I.tag == "coating")
					temp.Remove(I)
					break

		overlays = temp
		//Carefully removing the old raw-batter overlay

		if (!flat_icon)
			flat_icon = getFlatIcon(src)
		var/icon/I = flat_icon
		color = "#FFFFFF" //Some fruits use the color var
		I.Blend(new /icon('icons/obj/food_custom.dmi', rgb(255,255,255)),ICON_ADD)
		I.Blend(new /icon('icons/obj/food_custom.dmi', coating.icon_cooked),ICON_MULTIPLY)
		var/image/J = image(I)
		J.alpha = 200
		J.tag = "coating"
		overlays += J


		if (do_coating_prefix == 1)
			name = "[coating.coated_adj] [name]"

	for (var/r in reagents.reagent_list)
		var/datum/reagent/R = r
		if (istype(R, /datum/reagent/nutriment/coating))
			var/datum/reagent/nutriment/coating/C = R
			C.data["cooked"] = 1
			C.name = C.cooked_name

/obj/item/weapon/reagent_containers/food/snacks/proc/on_consume(var/mob/eater, var/mob/feeder = null)
	if(!reagents.total_volume)
		eater.visible_message("<span class='notice'>[eater] finishes eating \the [src].</span>","<span class='notice'>You finish eating \the [src].</span>")

		if (!feeder)
			feeder = eater

		feeder.drop_from_inventory(src)	//so icons update :[ //what the fuck is this????

		if(trash)
			if(ispath(trash,/obj/item))
				var/obj/item/TrashItem = new trash(feeder)
				feeder.put_in_hands(TrashItem)
			else if(istype(trash,/obj/item))
				feeder.put_in_hands(trash)
		qdel(src)
	return
////////////////////////////////////////////////////////////////////////////////
/// FOOD END
////////////////////////////////////////////////////////////////////////////////

/mob/living
	var/composition_reagent
	var/composition_reagent_quantity

/mob/living/simple_animal/adultslime
	composition_reagent = "slimejelly"

/mob/living/carbon/slime
	composition_reagent = "slimejelly"

/mob/living/carbon/alien/diona
	composition_reagent = "nutriment"//Dionae are plants, so eating them doesn't give animal protein

/mob/living/simple_animal/slime
	composition_reagent = "slimejelly"

/mob/living/simple_animal
	var/kitchen_tag = "animal" //Used for cooking with animals

/mob/living/simple_animal/mouse
	kitchen_tag = "rodent"

/obj/item/weapon/reagent_containers/food/snacks/sliceable/cheesewheel
	slices_num = 8

/obj/item/weapon/reagent_containers/food/snacks/sausage/battered
	name = "battered sausage"
	desc = "A piece of mixed, long meat, battered and then deepfried."
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "batteredsausage"
	filling_color = "#DB0000"
	center_of_mass = list("x"=16, "y"=16)
	do_coating_prefix = 0
	New()
		..()
		reagents.add_reagent("protein", 6)
		reagents.add_reagent("batter", 1.7)
		reagents.add_reagent("oil", 1.5)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/jalapeno_poppers
	name = "jalapeno popper"
	desc = "A battered, deep-fried chilli pepper."
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "popper"
	filling_color = "#00AA00"
	center_of_mass = list("x"=10, "y"=6)
	do_coating_prefix = 0
	nutriment_amt = 2
	nutriment_desc = list("chilli pepper" = 2)
	bitesize = 1

/obj/item/weapon/reagent_containers/food/snacks/jalapeno_poppers/initialize()
	. = ..()
	reagents.add_reagent("batter", 2)
	reagents.add_reagent("oil", 2)

/obj/item/weapon/reagent_containers/food/snacks/mouseburger
	name = "mouse burger"
	desc = "Squeaky and a little furry."
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "ratburger"
	center_of_mass = list("x"=16, "y"=11)
	New()
		..()
		reagents.add_reagent("protein", 4)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/chickenkatsu
	name = "chicken katsu"
	desc = "A Terran delicacy consisting of chicken fried in a light beer batter."
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "katsu"
	trash = /obj/item/trash/plate
	filling_color = "#E9ADFF"
	center_of_mass = list("x"=16, "y"=16)
	do_coating_prefix = 0

/obj/item/weapon/reagent_containers/food/snacks/chickenkatsu/initialize()
		..()
		reagents.add_reagent("protein", 6)
		reagents.add_reagent("beerbatter", 2)
		reagents.add_reagent("oil", 1)
		bitesize = 1.5

/obj/item/weapon/reagent_containers/food/snacks/fries
	nutriment_amt = 4
	nutriment_desc = list("fries" = 4)

/obj/item/weapon/reagent_containers/food/snacks/fries/initialize()
	..()
	reagents.add_reagent("oil", 1.2)//This is mainly for the benefit of adminspawning
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/microchips
	name = "micro chips"
	desc = "Soft and rubbery, should have fried them. Good for smaller crewmembers, maybe?"
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "microchips"
	trash = /obj/item/trash/plate
	filling_color = "#EDDD00"
	nutriment_amt = 4
	nutriment_desc = list("soggy fries" = 4)
	center_of_mass = list("x"=16, "y"=11)

/obj/item/weapon/reagent_containers/food/snacks/microchips/initialize()
	..()
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/ovenchips
	name = "oven chips"
	desc = "Dark and crispy, but a bit dry."
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "ovenchips"
	trash = /obj/item/trash/plate
	filling_color = "#EDDD00"
	nutriment_amt = 4
	nutriment_desc = list("crisp, dry fries" = 4)
	center_of_mass = list("x"=16, "y"=11)

/obj/item/weapon/reagent_containers/food/snacks/ovenchips/initialize()
	..()
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/meatsteak/initialize()
	..()
	reagents.add_reagent("protein", 6)
	reagents.add_reagent("triglyceride", 2)
	reagents.add_reagent("sodiumchloride", 1)
	reagents.add_reagent("blackpepper", 1)
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/crunch
	name = "pizza crunch"
	desc = "This was once a normal pizza, but it has been coated in batter and deep-fried. Whatever toppings it once had are a mystery, but they're still under there, somewhere..."
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "pizzacrunch"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/pizzacrunchslice
	slices_num = 6
	nutriment_amt = 25
	nutriment_desc = list("fried pizza" = 25)
	center_of_mass = list("x"=16, "y"=11)

	New()
		..()
		reagents.add_reagent("batter", 6.5)
		coating = reagents.get_reagent("batter")
		reagents.add_reagent("oil", 4)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/pizzacrunchslice
	name = "pizza crunch"
	desc = "A little piece of a heart attack. It's toppings are a mystery, hidden under batter"
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "pizzacrunchslice"
	filling_color = "#BAA14C"
	bitesize = 2
	center_of_mass = list("x"=18, "y"=13)

/obj/item/weapon/reagent_containers/food/snacks/funnelcake
	name = "funnel cake"
	desc = "Funnel cakes rule!"
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "funnelcake"
	filling_color = "#Ef1479"
	center_of_mass = list("x"=16, "y"=12)
	do_coating_prefix = 0

/obj/item/weapon/reagent_containers/food/snacks/funnelcake/initialize()
	..()
	reagents.add_reagent("batter", 10)
	reagents.add_reagent("sugar", 5)
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/spreads
	name = "nutri-spread"
	desc = "A stick of plant-based nutriments in a semi-solid form. I can't believe it's not margarine!"
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "marge"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=16)
	nutriment_desc = list("margarine" = 1)
	nutriment_amt = 20

/obj/item/weapon/reagent_containers/food/snacks/spreads/butter
	name = "butter"
	desc = "A stick of pure butterfat made from milk products."
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "butter"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=16)
	nutriment_desc = list("butter" = 1)
	nutriment_amt = 0

/obj/item/weapon/reagent_containers/food/snacks/spreads/initialize()
	. = ..()
	reagents.add_reagent("triglyceride", 20)
	reagents.add_reagent("sodiumchloride",1)

/obj/item/weapon/reagent_containers/food/snacks/rawcutlet/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/material/knife))
		new /obj/item/weapon/reagent_containers/food/snacks/rawbacon(src)
		new /obj/item/weapon/reagent_containers/food/snacks/rawbacon(src)
		to_chat(user, "You slice the cutlet into thin strips of bacon.")
		qdel(src)
	else
		..()

/obj/item/weapon/reagent_containers/food/snacks/rawbacon
	name = "raw bacon"
	desc = "A very thin piece of raw meat, cut from beef."
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "rawbacon"
	bitesize = 1
	center_of_mass = list("x"=16, "y"=16)

/obj/item/weapon/reagent_containers/food/snacks/rawbacon/initialize()
	. = ..()
	reagents.add_reagent("protein", 0.33)

/obj/item/weapon/reagent_containers/food/snacks/bacon
	name = "bacon"
	desc = "A tasty meat slice. You don't see any pigs on this station, do you?"
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "bacon"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=16)

/obj/item/weapon/reagent_containers/food/snacks/bacon/microwave
	name = "microwaved bacon"
	desc = "A tasty meat slice. You don't see any pigs on this station, do you?"
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "bacon"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=16)

/obj/item/weapon/reagent_containers/food/snacks/bacon/oven
	name = "oven-cooked bacon"
	desc = "A tasty meat slice. You don't see any pigs on this station, do you?"
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "bacon"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=16)

/obj/item/weapon/reagent_containers/food/snacks/bacon/initialize()
	. = ..()
	reagents.add_reagent("protein", 0.33)
	reagents.add_reagent("triglyceride", 1)

/obj/item/weapon/reagent_containers/food/snacks/bacon_stick
	name = "eggpop"
	desc = "A bacon wrapped boiled egg, conviently skewered on a wooden stick."
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "bacon_stick"

/obj/item/weapon/reagent_containers/food/snacks/bacon_stick/initialize()
	. = ..()
	reagents.add_reagent("protein", 3)
	reagents.add_reagent("egg", 1)

/obj/item/weapon/reagent_containers/food/snacks/chilied_eggs
	name = "chilied eggs"
	desc = "Three deviled eggs floating in a bowl of meat chili. A popular lunchtime meal for Unathi in Ouerea."
	icon_state = "chilied_eggs"
	trash = /obj/item/trash/snack_bowl

/obj/item/weapon/reagent_containers/food/snacks/chilied_eggs/initialize()
	. = ..()
	reagents.add_reagent("egg", 6)
	reagents.add_reagent("protein", 2)


/obj/item/weapon/reagent_containers/food/snacks/cheese_cracker
	name = "supreme cheese toast"
	desc = "A piece of toast lathered with butter, cheese, spices, and herbs."
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "cheese_cracker"
	nutriment_desc = list("cheese toast" = 8)
	nutriment_amt = 8

/obj/item/weapon/reagent_containers/food/snacks/bacon_and_eggs
	name = "bacon and eggs"
	desc = "A piece of bacon and two fried eggs."
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "bacon_and_eggs"
	trash = /obj/item/trash/plate

/obj/item/weapon/reagent_containers/food/snacks/bacon_and_eggs/initialize()
	. = ..()
	reagents.add_reagent("protein", 3)
	reagents.add_reagent("egg", 1)

/obj/item/weapon/reagent_containers/food/snacks/sweet_and_sour
	name = "sweet and sour pork"
	desc = "A traditional ancient sol recipe with a few liberties taken with meat selection."
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "sweet_and_sour"
	nutriment_desc = list("sweet and sour" = 6)
	nutriment_amt = 6
	trash = /obj/item/trash/plate

/obj/item/weapon/reagent_containers/food/snacks/sweet_and_sour/initialize()
	. = ..()
	reagents.add_reagent("protein", 3)

/obj/item/weapon/reagent_containers/food/snacks/corn_dog
	name = "corn dog"
	desc = "A cornbread covered sausage deepfried in oil."
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "corndog"
	nutriment_desc = list("corn batter" = 4)
	nutriment_amt = 4

/obj/item/weapon/reagent_containers/food/snacks/corn_dog/initialize()
	. = ..()
	reagents.add_reagent("protein", 3)

/obj/item/weapon/reagent_containers/food/snacks/truffle
	name = "chocolate truffle"
	desc = "Rich bite-sized chocolate."
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "truffle"
	nutriment_amt = 0
	bitesize = 4

/obj/item/weapon/reagent_containers/food/snacks/truffle/initialize()
	. = ..()
	reagents.add_reagent("coco", 6)

/obj/item/weapon/reagent_containers/food/snacks/truffle/random
	name = "mystery chocolate truffle"
	desc = "Rich bite-sized chocolate with a mystery filling!"

/obj/item/weapon/reagent_containers/food/snacks/truffle/random/initialize()
	. = ..()
	var/reagent_string = pick(list("cream","cherryjelly","mint","frostoil","capsaicin","cream","coffee","milkshake"))
	reagents.add_reagent(reagent_string, 4)

/obj/item/weapon/reagent_containers/food/snacks/bacon_flatbread
	name = "bacon cheese flatbread"
	desc = "Not a pizza."
	icon_state = "bacon_pizza"
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	nutriment_desc = list("flatbread" = 5)
	nutriment_amt = 5

/obj/item/weapon/reagent_containers/food/snacks/bacon_flatbread/initialize()
	. = ..()
	reagents.add_reagent("protein", 5)

/obj/item/weapon/reagent_containers/food/snacks/meat_pocket
	name = "meat pocket"
	desc = "Meat and cheese stuffed in a flatbread pocket, grilled to perfection."
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "meat_pocket"
	nutriment_desc = list("flatbread" = 3)
	nutriment_amt = 3

/obj/item/weapon/reagent_containers/food/snacks/meat_pocket/initialize()
	. = ..()
	reagents.add_reagent("protein", 3)

/obj/item/weapon/reagent_containers/food/snacks/fish_taco
	name = "carp taco"
	desc = "A questionably cooked fish taco decorated with herbs, spices, and special sauce."
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "fish_taco"
	nutriment_desc = list("flatbread" = 3)
	nutriment_amt = 3

/obj/item/weapon/reagent_containers/food/snacks/fish_taco/initialize()
	. = ..()
	reagents.add_reagent("seafood",3)

/obj/item/weapon/reagent_containers/food/snacks/nt_muffin
	name = "\improper NtMuffin"
	desc = "A NanoTrasen sponsered biscuit with egg, cheese, and sausage."
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "nt_muffin"
	nutriment_desc = list("biscuit" = 3)
	nutriment_amt = 3

/obj/item/weapon/reagent_containers/food/snacks/nt_muffin/initialize()
	. = ..()
	reagents.add_reagent("protein",5)

/obj/item/weapon/reagent_containers/food/snacks/pineapple_ring
	name = "pineapple ring"
	desc = "What the hell is this?"
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "pineapple_ring"
	nutriment_desc = list("sweetness" = 2)
	nutriment_amt = 2

/obj/item/weapon/reagent_containers/food/snacks/pineapple_ring/initialize()
	. = ..()
	reagents.add_reagent("pineapplejuice",3)

/obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/pineapple
	name = "ham & pineapple pizza"
	desc = "One of the most debated pizzas in existence."
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "pineapple_pizza"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/pineappleslice
	slices_num = 6
	center_of_mass = list("x"=16, "y"=11)
	nutriment_desc = list("pizza crust" = 10, "tomato" = 10, "ham" = 10)
	nutriment_amt = 30
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/pineapple/initialize()
	. = ..()
	reagents.add_reagent("protein", 4)
	reagents.add_reagent("cheese", 5)
	reagents.add_reagent("tomatojuice", 6)

/obj/item/weapon/reagent_containers/food/snacks/pineappleslice
	name = "ham & pineapple pizza slice"
	desc = "A slice of contraband."
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "pineapple_pizza_slice"
	filling_color = "#BAA14C"
	bitesize = 2
	center_of_mass = list("x"=18, "y"=13)

/obj/item/weapon/reagent_containers/food/snacks/pineappleslice/filled
	nutriment_desc = list("pizza crust" = 5, "tomato" = 5)
	nutriment_amt = 5

/obj/item/weapon/reagent_containers/food/snacks/burger/bacon
	name = "bacon burger"
	desc = "The cornerstone of every nutritious breakfast, now with bacon!"
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "hburger"
	filling_color = "#D63C3C"
	center_of_mass = list("x"=16, "y"=11)
	nutriment_desc = list("bun" = 2)
	nutriment_amt = 3
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/burger/bacon/initialize()
	. = ..()
	reagents.add_reagent("protein", 4)

/obj/item/weapon/reagent_containers/food/snacks/blt
	name = "BLT"
	desc = "Bacon, lettuce, tomatoes. The perfect lunch."
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "blt"
	filling_color = "#D63C3C"
	center_of_mass = list("x"=16, "y"=16)
	nutriment_desc = list("bread" = 4)
	nutriment_amt = 4
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/blt/initialize()
	. = ..()
	reagents.add_reagent("protein", 4)

/obj/item/weapon/reagent_containers/food/snacks/onionrings
	name = "onion rings"
	desc = "Like circular fries but better."
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "onionrings"
	trash = /obj/item/trash/plate
	filling_color = "#eddd00"
	center_of_mass = "x=16;y=11"
	nutriment_desc = list("fried onions" = 5)
	nutriment_amt = 5
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/berrymuffin
	name = "berry muffin"
	desc = "A delicious and spongy little cake, with berries."
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "berrymuffin"
	filling_color = "#E0CF9B"
	center_of_mass = list("x"=17, "y"=4)
	nutriment_amt = 5
	nutriment_desc = list("sweetness" = 1, "muffin" = 2, "berries" = 2)
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/soup/onion
	name = "onion soup"
	desc = "A soup with layers."
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "onionsoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#E0C367"
	center_of_mass = list("x"=16, "y"=7)
	nutriment_amt = 5
	nutriment_desc = list("onion" = 2, "soup" = 2)
	bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/porkbowl
	name = "pork bowl"
	desc = "A bowl of fried rice with cuts of meat."
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "porkbowl"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#FFFBDB"
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/porkbowl/initialize()
	..()
	reagents.add_reagent("rice", 6)
	reagents.add_reagent("protein", 4)

/obj/item/weapon/reagent_containers/food/snacks/mashedpotato
	name = "mashed potato"
	desc = "Pillowy mounds of mashed potato."
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "mashedpotato"
	trash = /obj/item/trash/plate
	filling_color = "#EDDD00"
	center_of_mass = list("x"=16, "y"=11)
	nutriment_amt = 4
	nutriment_desc = list("mashed potatoes" = 4)
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/croissant
	name = "croissant"
	desc = "True french cuisine."
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	filling_color = "#E3D796"
	icon_state = "croissant"
	nutriment_amt = 4
	nutriment_desc = list("french bread" = 4)
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/crabmeat
	name = "crab legs"
	desc = "... Coffee? Is that you?"
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "crabmeat"
	bitesize = 1

/obj/item/weapon/reagent_containers/food/snacks/crabmeat/initialize()
	. = ..()
	reagents.add_reagent("seafood", 2)

/obj/item/weapon/reagent_containers/food/snacks/crab_legs
	name = "steamed crab legs"
	desc = "Crab legs steamed and buttered to perfection. One day when the boss gets hungry..."
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "crablegs"
	nutriment_amt = 2
	nutriment_desc = list("savory butter" = 2)
	bitesize = 2
	trash = /obj/item/trash/plate

/obj/item/weapon/reagent_containers/food/snacks/crab_legs/initialize()
	. = ..()
	reagents.add_reagent("seafood", 6)
	reagents.add_reagent("sodiumchloride", 1)

/obj/item/weapon/reagent_containers/food/snacks/pancakes
	name = "pancakes"
	desc = "Pancakes with berries, delicious."
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "pancakes"
	trash = /obj/item/trash/plate
	center_of_mass = "x=15;y=11"
	nutriment_desc = list("pancake" = 8)
	nutriment_amt = 8
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/nugget
	name = "chicken nugget"
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "nugget_lump"
	bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/nugget/initialize()
	. = ..()
	var/shape = pick("lump", "star", "lizard", "corgi")
	desc = "A chicken nugget vaguely shaped like a [shape]."
	icon_state = "nugget_[shape]"
	reagents.add_reagent("protein", 4)

/obj/item/weapon/reagent_containers/food/snacks/icecreamsandwich
	name = "ice cream sandwich"
	desc = "Portable ice cream in its own packaging."
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "icecreamsandwich"
	filling_color = "#343834"
	center_of_mass = list("x"=15, "y"=4)
	nutriment_desc = list("ice cream" = 4)
	nutriment_amt = 4

/obj/item/weapon/reagent_containers/food/snacks/honeybun
	name = "honey bun"
	desc = "A sticky pastry bun glazed with honey."
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "honeybun"
	nutriment_desc = list("pastry" = 1)
	nutriment_amt = 3
	bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/honeybun/initialize()
	. = ..()
	reagents.add_reagent("honey", 3)

// Moved /bun/attackby() from /code/modules/food/food/snacks.dm
/obj/item/weapon/reagent_containers/food/snacks/bun/attackby(obj/item/weapon/W as obj, mob/user as mob)
	var/obj/item/weapon/reagent_containers/food/snacks/result = null
	// Bun + meatball = burger
	if(istype(W,/obj/item/weapon/reagent_containers/food/snacks/meatball))
		result = new /obj/item/weapon/reagent_containers/food/snacks/monkeyburger(src)
		to_chat(user, "You make a burger.")
		qdel(W)
		qdel(src)

	// Bun + cutlet = hamburger
	else if(istype(W,/obj/item/weapon/reagent_containers/food/snacks/cutlet))
		result = new /obj/item/weapon/reagent_containers/food/snacks/monkeyburger(src)
		to_chat(user, "You make a burger.")
		qdel(W)
		qdel(src)

	// Bun + sausage = hotdog
	else if(istype(W,/obj/item/weapon/reagent_containers/food/snacks/sausage))
		result = new /obj/item/weapon/reagent_containers/food/snacks/hotdog(src)
		to_chat(user, "You make a hotdog.")
		qdel(W)
		qdel(src)

	// Bun + mouse = mouseburger
	else if(istype(W,/obj/item/weapon/reagent_containers/food/snacks/variable/mob))
		var/obj/item/weapon/reagent_containers/food/snacks/variable/mob/MF = W

		switch (MF.kitchen_tag)
			if ("rodent")
				result = new /obj/item/weapon/reagent_containers/food/snacks/mouseburger(src)
				to_chat(user, "You make a mouseburger!")

	if (result)
		if (W.reagents)
			//Reagents of reuslt objects will be the sum total of both.  Except in special cases where nonfood items are used
			//Eg robot head
			result.reagents.clear_reagents()
			W.reagents.trans_to(result, W.reagents.total_volume)
			reagents.trans_to(result, reagents.total_volume)

		//If the bun was in your hands, the result will be too
		if (loc == user)
			user.drop_from_inventory(src)
			user.put_in_hands(result)

// Chip update.
/obj/item/weapon/reagent_containers/food/snacks/tortilla
	name = "tortilla"
	desc = "A thin, flour-based tortilla that can be used in a variety of dishes, or can be served as is."
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "tortilla"
	bitesize = 3
	nutriment_desc = list("tortilla" = 1)
	center_of_mass = list("x"=16, "y"=16)
	nutriment_amt = 6

//chips
/obj/item/weapon/reagent_containers/food/snacks/chip
	name = "chip"
	desc = "A portion sized chip good for dipping."
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "chip"
	var/bitten_state = "chip_half"
	bitesize = 1
	center_of_mass = list("x"=16, "y"=16)
	nutriment_desc = list("nacho chips" = 1)
	nutriment_amt = 2

/obj/item/weapon/reagent_containers/food/snacks/chip/on_consume(mob/M as mob)
	if(reagents && reagents.total_volume)
		icon_state = bitten_state
	. = ..()

/obj/item/weapon/reagent_containers/food/snacks/chip/salsa
	name = "salsa chip"
	desc = "A portion sized chip good for dipping. This one has salsa on it."
	icon_state = "chip_salsa"
	bitten_state = "chip_half"

/obj/item/weapon/reagent_containers/food/snacks/chip/guac
	name = "guac chip"
	desc = "A portion sized chip good for dipping. This one has guac on it."
	icon_state = "chip_guac"
	bitten_state = "chip_half"

/obj/item/weapon/reagent_containers/food/snacks/chip/cheese
	name = "cheese chip"
	desc = "A portion sized chip good for dipping. This one has cheese sauce on it."
	icon_state = "chip_cheese"
	bitten_state = "chip_half"

/obj/item/weapon/reagent_containers/food/snacks/chip/nacho
	name = "nacho chip"
	desc = "A nacho ship stray from a plate of cheesy nachos."
	icon_state = "chip_nacho"
	bitten_state = "chip_half"

/obj/item/weapon/reagent_containers/food/snacks/chip/nacho/salsa
	name = "nacho chip"
	desc = "A nacho ship stray from a plate of cheesy nachos. This one has salsa on it."
	icon_state = "chip_nacho_salsa"
	bitten_state = "chip_half"

/obj/item/weapon/reagent_containers/food/snacks/chip/nacho/guac
	name = "nacho chip"
	desc = "A nacho ship stray from a plate of cheesy nachos. This one has guac on it."
	icon_state = "chip_nacho_guac"
	bitten_state = "chip_half"

/obj/item/weapon/reagent_containers/food/snacks/chip/nacho/cheese
	name = "nacho chip"
	desc = "A nacho ship stray from a plate of cheesy nachos. This one has extra cheese on it."
	icon_state = "chip_nacho_cheese"
	bitten_state = "chip_half"

// chip plates
/obj/item/weapon/reagent_containers/food/snacks/chipplate
	name = "basket of chips"
	desc = "A plate of chips intended for dipping."
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "chip_basket"
	trash = /obj/item/trash/chipbasket
	var/vendingobject = /obj/item/weapon/reagent_containers/food/snacks/chip
	nutriment_desc = list("tortilla chips" = 10)
	bitesize = 1
	nutriment_amt = 10

/obj/item/weapon/reagent_containers/food/snacks/chipplate/attack_hand(mob/user as mob)
	var/obj/item/weapon/reagent_containers/food/snacks/returningitem = new vendingobject(loc)
	returningitem.reagents.clear_reagents()
	reagents.trans_to(returningitem, bitesize)
	returningitem.bitesize = bitesize/2
	user.put_in_hands(returningitem)
	if (reagents && reagents.total_volume)
		to_chat(user, "You take a chip from the plate.")
	else
		to_chat(user, "You take the last chip from the plate.")
		var/obj/waste = new trash(loc)
		if (loc == user)
			user.put_in_hands(waste)
		qdel(src)

/obj/item/weapon/reagent_containers/food/snacks/chipplate/MouseDrop(mob/user) //Dropping the chip onto the user
	if(istype(user) && user == usr)
		user.put_in_active_hand(src)
		src.pickup(user)
		return
	. = ..()

/obj/item/weapon/reagent_containers/food/snacks/chipplate/nachos
	name = "plate of nachos"
	desc = "A very cheesy nacho plate."
	icon_state = "nachos"
	trash = /obj/item/trash/plate
	vendingobject = /obj/item/weapon/reagent_containers/food/snacks/chip/nacho
	nutriment_desc = list("tortilla chips" = 10)
	bitesize = 1
	nutriment_amt = 10

//dips
/obj/item/weapon/reagent_containers/food/snacks/dip
	name = "queso dip"
	desc = "A simple, cheesy dip consisting of tomatos, cheese, and spices."
	var/nachotrans = /obj/item/weapon/reagent_containers/food/snacks/chip/nacho/cheese
	var/chiptrans = /obj/item/weapon/reagent_containers/food/snacks/chip/cheese
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "dip_cheese"
	trash = /obj/item/trash/dipbowl
	bitesize = 1
	nutriment_desc = list("queso" = 20)
	center_of_mass = list("x"=16, "y"=16)
	nutriment_amt = 20

/obj/item/weapon/reagent_containers/food/snacks/dip/attackby(obj/item/weapon/reagent_containers/food/snacks/item as obj, mob/user as mob)
	. = ..()
	var/obj/item/weapon/reagent_containers/food/snacks/returningitem
	if(istype(item,/obj/item/weapon/reagent_containers/food/snacks/chip/nacho) && item.icon_state == "chip_nacho")
		returningitem = new nachotrans(src)
	else if (istype(item,/obj/item/weapon/reagent_containers/food/snacks/chip) && (item.icon_state == "chip" || item.icon_state == "chip_half"))
		returningitem = new chiptrans(src)
	if(returningitem)
		returningitem.reagents.clear_reagents() //Clear the new chip
		var/memed = 0
		item.reagents.trans_to(returningitem, item.reagents.total_volume) //Old chip to new chip
		if(item.icon_state == "chip_half")
			returningitem.icon_state = "[returningitem.icon_state]_half"
			returningitem.bitesize = Clamp(returningitem.reagents.total_volume,1,10)
		else if(prob(1))
			memed = 1
			user << "You scoop up some dip with the chip, but mid-scop, the chip breaks off into the dreadful abyss of dip, never to be seen again..."
			returningitem.icon_state = "[returningitem.icon_state]_half"
			returningitem.bitesize = Clamp(returningitem.reagents.total_volume,1,10)
		else
			returningitem.bitesize = Clamp(returningitem.reagents.total_volume*0.5,1,10)
		qdel(item)
		reagents.trans_to(returningitem, bitesize) //Dip to new chip
		user.put_in_hands(returningitem)

		if (reagents && reagents.total_volume)
			if(!memed)
				user << "You scoop up some dip with the chip."
		else
			if(!memed)
				user << "You scoop up the remaining dip with the chip."
			var/obj/waste = new trash(loc)
			if (loc == user)
				user.put_in_hands(waste)
			qdel(src)

/obj/item/weapon/reagent_containers/food/snacks/dip/salsa
	name = "salsa dip"
	desc = "Traditional Sol chunky salsa dip containing tomatos, peppers, and spices."
	nachotrans = /obj/item/weapon/reagent_containers/food/snacks/chip/nacho/salsa
	chiptrans = /obj/item/weapon/reagent_containers/food/snacks/chip/salsa
	icon_state = "dip_salsa"
	nutriment_desc = list("salsa" = 20)
	nutriment_amt = 20

/obj/item/weapon/reagent_containers/food/snacks/dip/guac
	name = "guac dip"
	desc = "A recreation of the ancient Sol 'Guacamole' dip using tofu, limes, and spices. This recreation obviously leaves out mole meat."
	nachotrans = /obj/item/weapon/reagent_containers/food/snacks/chip/nacho/guac
	chiptrans = /obj/item/weapon/reagent_containers/food/snacks/chip/guac
	icon_state = "dip_guac"
	nutriment_desc = list("guacmole" = 20)
	nutriment_amt = 20

//burritos
/obj/item/weapon/reagent_containers/food/snacks/burrito
	name = "meat burrito"
	desc = "Meat wrapped in a flour tortilla. It's a burrito by definition."
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "burrito"
	bitesize = 4
	center_of_mass = list("x"=16, "y"=16)
	nutriment_desc = list("tortilla" = 6)
	nutriment_amt = 6

/obj/item/weapon/reagent_containers/food/snacks/burrito/initialize()
	. = ..()
	reagents.add_reagent("protein", 4)


/obj/item/weapon/reagent_containers/food/snacks/burrito_vegan
	name = "vegan burrito"
	desc = "Tofu wrapped in a flour tortilla. Those seen with this food object are Valid."
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "burrito_vegan"
	bitesize = 4
	center_of_mass = list("x"=16, "y"=16)
	nutriment_desc = list("tortilla" = 6)
	nutriment_amt = 6

/obj/item/weapon/reagent_containers/food/snacks/burrito_vegan/initialize()
	. = ..()
	reagents.add_reagent("tofu", 6)

/obj/item/weapon/reagent_containers/food/snacks/burrito_spicy
	name = "spicy meat burrito"
	desc = "Meat and chilis wrapped in a flour tortilla."
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "burrito_spicy"
	bitesize = 4
	center_of_mass = list("x"=16, "y"=16)
	nutriment_desc = list("tortilla" = 6)
	nutriment_amt = 6

/obj/item/weapon/reagent_containers/food/snacks/burrito_spicy/initialize()
	. = ..()
	reagents.add_reagent("protein", 6)

/obj/item/weapon/reagent_containers/food/snacks/burrito_cheese
	name = "meat cheese burrito"
	desc = "Meat and melted cheese wrapped in a flour tortilla."
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "burrito_cheese"
	bitesize = 4
	center_of_mass = list("x"=16, "y"=16)
	nutriment_desc = list("tortilla" = 6)
	nutriment_amt = 6

/obj/item/weapon/reagent_containers/food/snacks/burrito_cheese/initialize()
	. = ..()
	reagents.add_reagent("protein", 6)

/obj/item/weapon/reagent_containers/food/snacks/burrito_cheese_spicy
	name = "spicy cheese meat burrito"
	desc = "Meat, melted cheese, and chilis wrapped in a flour tortilla."
	icon_state = "burrito_cheese_spicy"
	bitesize = 4
	center_of_mass = list("x"=16, "y"=16)
	nutriment_desc = list("tortilla" = 6)
	nutriment_amt = 6

/obj/item/weapon/reagent_containers/food/snacks/burrito_cheese_spicy/initialize()
	. = ..()
	reagents.add_reagent("protein", 6)

/obj/item/weapon/reagent_containers/food/snacks/burrito_hell
	name = "el diablo"
	desc = "Meat and an insane amount of chilis packed in a flour tortilla. The Chaplain will see you now."
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "burrito_hell"
	bitesize = 4
	center_of_mass = list("x"=16, "y"=16)
	nutriment_desc = list("hellfire" = 6)
	nutriment_amt = 24// 10 Chilis is a lot.

/obj/item/weapon/reagent_containers/food/snacks/breakfast_wrap
	name = "breakfast wrap"
	desc = "Bacon, eggs, cheese, and tortilla grilled to perfection."
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "breakfast_wrap"
	bitesize = 4
	center_of_mass = list("x"=16, "y"=16)
	nutriment_desc = list("tortilla" = 6)
	nutriment_amt = 6

/obj/item/weapon/reagent_containers/food/snacks/burrito_hell/initialize()
	. = ..()
	reagents.add_reagent("protein", 9)
	reagents.add_reagent("condensedcapsaicin", 20) //what could possibly go wrong

/obj/item/weapon/reagent_containers/food/snacks/burrito_mystery
	name = "mystery meat burrito"
	desc = "The mystery is, why aren't you BSAing it?"
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "burrito_mystery"
	bitesize = 5
	center_of_mass = list("x"=16, "y"=16)
	nutriment_desc = list("regret" = 6)
	nutriment_amt = 6

/obj/item/weapon/reagent_containers/food/snacks/hatchling_suprise
	name = "hatchling suprise"
	desc = "A poached egg on top of three slices of bacon. A typical breakfast for hungry Unathi children."
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "hatchling_suprise"
	trash = /obj/item/trash/snack_bowl

/obj/item/weapon/reagent_containers/food/snacks/hatchling_suprise/initialize()
	. = ..()
	reagents.add_reagent("egg", 2)
	reagents.add_reagent("protein", 4)

/obj/item/weapon/reagent_containers/food/snacks/red_sun_special
	name = "red sun special"
	desc = "One lousy piece of sausage sitting on melted cheese curds. A cheap meal for the Unathi peasants of Moghes."
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "red_sun_special"
	trash = /obj/item/trash/plate

/obj/item/weapon/reagent_containers/food/snacks/red_sun_special/initialize()
	. = ..()
	reagents.add_reagent("protein", 2)

/obj/item/weapon/reagent_containers/food/snacks/riztizkzi_sea
	name = "moghesian sea delight"
	desc = "Three raw eggs floating in a sea of blood. An authentic replication of an ancient Unathi delicacy."
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "riztizkzi_sea"
	trash = /obj/item/trash/snack_bowl

/obj/item/weapon/reagent_containers/food/snacks/riztizkzi_sea/initialize()
	. = ..()
	reagents.add_reagent("egg", 4)

/obj/item/weapon/reagent_containers/food/snacks/father_breakfast
	name = "breakfast of champions"
	desc = "A sausage and an omelette on top of a grilled steak."
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "father_breakfast"
	trash = /obj/item/trash/plate

/obj/item/weapon/reagent_containers/food/snacks/father_breakfast/initialize()
	. = ..()
	reagents.add_reagent("egg", 4)
	reagents.add_reagent("protein", 6)

/obj/item/weapon/reagent_containers/food/snacks/stuffed_meatball
	name = "stuffed meatball" //YES
	desc = "A meatball loaded with cheese."
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "stuffed_meatball"

/obj/item/weapon/reagent_containers/food/snacks/stuffed_meatball/initialize()
	. = ..()
	reagents.add_reagent("protein", 4)

/obj/item/weapon/reagent_containers/food/snacks/egg_pancake
	name = "meat pancake"
	desc = "An omelette baked on top of a giant meat patty. This monstrousity is typically shared between four people during a dinnertime meal."
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "egg_pancake"
	trash = /obj/item/trash/plate

/obj/item/weapon/reagent_containers/food/snacks/egg_pancake/initialize()
	. = ..()
	reagents.add_reagent("protein", 6)
	reagents.add_reagent("egg", 2)

/obj/item/weapon/reagent_containers/food/snacks/sliceable/grilled_carp
	name = "korlaaskak"
	desc = "A well-dressed carp, seared to perfection and adorned with herbs and spices. Can be sliced into proper serving sizes."
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "grilled_carp"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/grilled_carp_slice
	slices_num = 6
	trash = /obj/item/trash/snacktray

/obj/item/weapon/reagent_containers/food/snacks/sliceable/grilled_carp/initialize()
	reagents.add_reagent("seafood", 12)

/obj/item/weapon/reagent_containers/food/snacks/grilled_carp_slice
	name = "korlaaskak slice"
	desc = "A well-dressed fillet of carp, seared to perfection and adorned with herbs and spices."
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "grilled_carp_slice"
	trash = /obj/item/trash/plate


// SYNNONO MEME FOODS EXPANSION - Credit to Synnono from Aurorastation. Come play here sometime :(

/obj/item/weapon/reagent_containers/food/snacks/redcurry
	name = "red curry"
	gender = PLURAL
	desc = "A bowl of creamy red curry with meat and rice. This one looks savory."
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "redcurry"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#f73333"
	nutriment_amt = 8
	nutriment_desc = list("savory meat and rice" = 8)
	center_of_mass = list("x"=16, "y"=8)

/obj/item/weapon/reagent_containers/food/snacks/redcurry/initialize()
	..()
	reagents.add_reagent("protein", 7)
	bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/greencurry
	name = "green curry"
	gender = PLURAL
	desc = "A bowl of creamy green curry with tofu, hot peppers and rice. This one looks spicy!"
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "greencurry"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#58b76c"
	nutriment_amt = 12
	nutriment_desc = list("tofu and rice" = 12)
	center_of_mass = list("x"=16, "y"=8)

/obj/item/weapon/reagent_containers/food/snacks/greencurry/initialize()
	..()
	reagents.add_reagent("protein", 1)
	reagents.add_reagent("capsaicin", 2)
	bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/yellowcurry
	name = "yellow curry"
	gender = PLURAL
	desc = "A bowl of creamy yellow curry with potatoes, peanuts and rice. This one looks mild."
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "yellowcurry"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#bc9509"
	nutriment_amt = 13
	nutriment_desc = list("rice and potatoes" = 13)
	center_of_mass = list("x"=16, "y"=8)

/obj/item/weapon/reagent_containers/food/snacks/yellowcurry/initialize()
	..()
	reagents.add_reagent("protein", 2)
	bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/bearburger
	name = "bearburger"
	desc = "The solution to your unbearable hunger."
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "bearburger"
	filling_color = "#5d5260"
	center_of_mass = list("x"=15, "y"=11)

/obj/item/weapon/reagent_containers/food/snacks/bearburger/initialize()
	..()
	reagents.add_reagent("protein", 4) //So spawned burgers will not be empty I guess?
	bitesize = 5

/obj/item/weapon/reagent_containers/food/snacks/bearchili
	name = "bear chili"
	gender = PLURAL
	desc = "A dark, hearty chili. Can you bear the heat?"
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "bearchili"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#702708"
	nutriment_amt = 3
	nutriment_desc = list("dark, hearty chili" = 3)
	center_of_mass = list("x"=15, "y"=9)

/obj/item/weapon/reagent_containers/food/snacks/bearchili/initialize()
	..()
	reagents.add_reagent("protein", 3)
	reagents.add_reagent("capsaicin", 3)
	reagents.add_reagent("tomatojuice", 2)
	reagents.add_reagent("hyperzine", 5)
	bitesize = 6

/obj/item/weapon/reagent_containers/food/snacks/bearstew
	name = "bear stew"
	gender = PLURAL
	desc = "A thick, dark stew of bear meat and vegetables."
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "stew"
	filling_color = "#9E673A"
	nutriment_amt = 6
	nutriment_desc = list("hearty stew" = 6)
	center_of_mass = list("x"=16, "y"=5)

/obj/item/weapon/reagent_containers/food/snacks/bearstew/initialize()
	..()
	reagents.add_reagent("protein", 4)
	reagents.add_reagent("hyperzine", 5)
	reagents.add_reagent("tomatojuice", 5)
	reagents.add_reagent("imidazoline", 5)
	reagents.add_reagent("water", 5)
	bitesize = 6

/obj/item/weapon/reagent_containers/food/snacks/bibimbap
	name = "bibimbap bowl"
	desc = "A traditional Korean meal of meat and mixed vegetables. It's served on a bed of rice, and topped with a fried egg."
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "bibimbap"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#4f2100"
	nutriment_amt = 10
	nutriment_desc = list("egg" = 5, "vegetables" = 5)
	center_of_mass = list("x"=15, "y"=9)

/obj/item/weapon/reagent_containers/food/snacks/bibimbap/initialize()
	..()
	reagents.add_reagent("protein", 10)
	bitesize = 4

/obj/item/weapon/reagent_containers/food/snacks/lomein
	name = "lo mein"
	gender = PLURAL
	desc = "A popular Chinese noodle dish. Chopsticks optional."
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "lomein"
	trash = /obj/item/trash/plate
	filling_color = "#FCEE81"
	nutriment_amt = 8
	nutriment_desc = list("noodles" = 6, "sesame sauce" = 2)
	center_of_mass = list("x"=16, "y"=10)

/obj/item/weapon/reagent_containers/food/snacks/lomein/initialize()
	..()
	reagents.add_reagent("protein", 2)
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/friedrice
	name = "fried rice"
	gender = PLURAL
	desc = "A less-boring dish of less-boring rice!"
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "friedrice"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#FFFBDB"
	nutriment_amt = 7
	nutriment_desc = list("rice" = 7)
	center_of_mass = list("x"=17, "y"=11)

/obj/item/weapon/reagent_containers/food/snacks/friedrice/initialize()
	..()
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/chickenfillet
	name = "chicken fillet sandwich"
	desc = "Fried chicken, in sandwich format. Beauty is simplicity."
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "chickenfillet"
	filling_color = "#E9ADFF"
	nutriment_amt = 4
	nutriment_desc = list("breading" = 4)
	center_of_mass = list("x"=16, "y"=16)

/obj/item/weapon/reagent_containers/food/snacks/chickenfillet/initialize()
	..()
	reagents.add_reagent("protein", 8)
	bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/chilicheesefries
	name = "chili cheese fries"
	gender = PLURAL
	desc = "A mighty plate of fries, drowned in hot chili and cheese sauce. Because your arteries are overrated."
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "chilicheesefries"
	trash = /obj/item/trash/plate
	filling_color = "#EDDD00"
	nutriment_amt = 8
	nutriment_desc = list("hearty, cheesy fries" = 8)
	center_of_mass = list("x"=16, "y"=11)

/obj/item/weapon/reagent_containers/food/snacks/chilicheesefries/initialize()
	..()
	reagents.add_reagent("protein", 2)
	reagents.add_reagent("capsaicin", 2)
	bitesize = 4

/obj/item/weapon/reagent_containers/food/snacks/friedmushroom
	name = "fried mushroom"
	desc = "A tender, beer-battered plump helmet, fried to crispy perfection."
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "friedmushroom"
	filling_color = "#EDDD00"
	nutriment_amt = 4
	nutriment_desc = list("alcoholic mushrooms" = 4)
	center_of_mass = list("x"=16, "y"=11)

/obj/item/weapon/reagent_containers/food/snacks/friedmushroom/initialize()
	..()
	reagents.add_reagent("protein", 2)
	bitesize = 5

/obj/item/weapon/reagent_containers/food/snacks/pisanggoreng
	name = "pisang goreng"
	gender = PLURAL
	desc = "Crispy, starchy, sweet banana fritters. Popular street food in parts of Sol."
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "pisanggoreng"
	trash = /obj/item/trash/plate
	filling_color = "#301301"
	nutriment_amt = 8
	nutriment_desc = list("sweet bananas" = 8)
	center_of_mass = list("x"=16, "y"=11)

/obj/item/weapon/reagent_containers/food/snacks/pisanggoreng/initialize()
	..()
	reagents.add_reagent("protein", 1)
	bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/meatbun
	name = "meat bun"
	desc = "A soft, fluffy flour bun also known as baozi. This one is filled with a spiced meat filling."
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "meatbun"
	filling_color = "#edd7d7"
	nutriment_amt = 5
	nutriment_desc = list("spice" = 5)
	center_of_mass = list("x"=16, "y"=11)

/obj/item/weapon/reagent_containers/food/snacks/meatbun/initialize()
	..()
	reagents.add_reagent("protein", 3)
	bitesize = 5

/obj/item/weapon/reagent_containers/food/snacks/custardbun
	name = "custard bun"
	desc = "A soft, fluffy flour bun also known as baozi. This one is filled with an egg custard."
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "meatbun"
	nutriment_amt = 6
	nutriment_desc = list("egg custard" = 6)
	filling_color = "#ebedc2"
	center_of_mass = list("x"=16, "y"=11)

/obj/item/weapon/reagent_containers/food/snacks/custardbun/initialize()
	..()
	reagents.add_reagent("protein", 2)
	bitesize = 6

/obj/item/weapon/reagent_containers/food/snacks/chickenmomo
	name = "chicken momo"
	gender = PLURAL
	desc = "A plate of spiced and steamed chicken dumplings. The style originates from south Asia."
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "momo"
	trash = /obj/item/trash/snacktray
	filling_color = "#edd7d7"
	nutriment_amt = 9
	nutriment_desc = list("spiced chicken" = 9)
	center_of_mass = list("x"=15, "y"=9)

/obj/item/weapon/reagent_containers/food/snacks/chickenmomo/initialize()
	..()
	reagents.add_reagent("protein", 6)
	bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/veggiemomo
	name = "veggie momo"
	gender = PLURAL
	desc = "A plate of spiced and steamed vegetable dumplings. The style originates from south Asia."
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "momo"
	trash = /obj/item/trash/snacktray
	filling_color = "#edd7d7"
	nutriment_amt = 13
	nutriment_desc = list("spiced vegetables" = 13)
	center_of_mass = list("x"=15, "y"=9)

/obj/item/weapon/reagent_containers/food/snacks/veggiemomo/initialize()
	..()
	reagents.add_reagent("protein", 2)
	bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/risotto
	name = "risotto"
	gender = PLURAL
	desc = "A creamy, savory rice dish from southern Europe, typically cooked slowly with wine and broth. This one has bits of mushroom."
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "risotto"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#edd7d7"
	nutriment_amt = 9
	nutriment_desc = list("savory rice" = 6, "cream" = 3)
	center_of_mass = list("x"=15, "y"=9)

/obj/item/weapon/reagent_containers/food/snacks/risotto/initialize()
	..()
	reagents.add_reagent("protein", 1)
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/risottoballs
	name = "risotto balls"
	gender = PLURAL
	desc = "Mushroom risotto that has been battered and deep fried. The best use of leftovers!"
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "risottoballs"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#edd7d7"
	nutriment_amt = 1
	nutriment_desc = list("batter" = 1)
	center_of_mass = list("x"=15, "y"=9)

/obj/item/weapon/reagent_containers/food/snacks/risottoballs/initialize()
	..()
	bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/honeytoast
	name = "piece of honeyed toast"
	desc = "For those who like their breakfast sweet."
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "honeytoast"
	trash = /obj/item/trash/plate
	filling_color = "#EDE5AD"
	nutriment_amt = 1
	nutriment_desc = list("sweet, crunchy bread" = 1)
	center_of_mass = list("x"=16, "y"=9)

/obj/item/weapon/reagent_containers/food/snacks/honeytoast/initialize()
	..()
	bitesize = 4

/obj/item/weapon/reagent_containers/food/snacks/poachedegg
	name = "poached egg"
	desc = "A delicately poached egg with a runny yolk. Healthier than its fried counterpart."
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "poachedegg"
	trash = /obj/item/trash/plate
	filling_color = "#FFDF78"
	nutriment_amt = 1
	nutriment_desc = list("egg" = 1)
	center_of_mass = list("x"=16, "y"=14)

/obj/item/weapon/reagent_containers/food/snacks/poachedegg/initialize()
	..()
	reagents.add_reagent("protein", 3)
	reagents.add_reagent("blackpepper", 1)
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/ribplate
	name = "plate of ribs"
	desc = "A half-rack of ribs, brushed with some sort of honey-glaze. Why are there no napkins on board?"
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "ribplate"
	trash = /obj/item/trash/plate
	filling_color = "#7A3D11"
	nutriment_amt = 6
	nutriment_desc = list("barbecue" = 6)
	center_of_mass = list("x"=16, "y"=13)

/obj/item/weapon/reagent_containers/food/snacks/ribplate/initialize()
	..()
	reagents.add_reagent("protein", 6)
	reagents.add_reagent("triglyceride", 2)
	reagents.add_reagent("blackpepper", 1)
	reagents.add_reagent("honey", 5)
	bitesize = 4

// SLICEABLE FOODS - SYNNONO MEME FOOD EXPANSION - Credit to Synnono from Aurorastation (again)

/obj/item/weapon/reagent_containers/food/snacks/sliceable/keylimepie
	name = "key lime pie"
	desc = "A tart, sweet dessert. What's a key lime, anyway?"
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "keylimepie"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/keylimepieslice
	slices_num = 5
	filling_color = "#F5B951"
	nutriment_amt = 16
	nutriment_desc = list("lime" = 12, "graham crackers" = 4)
	center_of_mass = list("x"=16, "y"=10)

/obj/item/weapon/reagent_containers/food/snacks/sliceable/keylimepie/initialize()
	..()
	reagents.add_reagent("protein", 4)

/obj/item/weapon/reagent_containers/food/snacks/keylimepieslice
	name = "slice of key lime pie"
	desc = "A slice of tart pie, with whipped cream on top."
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "keylimepieslice"
	trash = /obj/item/trash/plate
	filling_color = "#F5B951"
	bitesize = 3
	nutriment_desc = list("lime" = 1)
	center_of_mass = list("x"=16, "y"=12)

/obj/item/weapon/reagent_containers/food/snacks/keylimepieslice/filled
	nutriment_amt = 1

/obj/item/weapon/reagent_containers/food/snacks/sliceable/quiche
	name = "quiche"
	desc = "Real men eat this, contrary to popular belief."
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "quiche"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/quicheslice
	slices_num = 5
	filling_color = "#F5B951"
	nutriment_amt = 10
	nutriment_desc = list("cheese" = 5, "egg" = 5)
	center_of_mass = list("x"=16, "y"=10)

/obj/item/weapon/reagent_containers/food/snacks/sliceable/quiche/initialize()
	..()
	reagents.add_reagent("protein", 10)

/obj/item/weapon/reagent_containers/food/snacks/quicheslice
	name = "slice of quiche"
	desc = "A slice of delicious quiche. Eggy, cheesy goodness."
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "quicheslice"
	trash = /obj/item/trash/plate
	filling_color = "#F5B951"
	bitesize = 3
	nutriment_desc = list("cheesy eggs" = 1)
	center_of_mass = list("x"=16, "y"=12)

/obj/item/weapon/reagent_containers/food/snacks/quicheslice/filled
	nutriment_amt = 1

/obj/item/weapon/reagent_containers/food/snacks/quicheslice/filled/initialize()
	..()
	reagents.add_reagent("protein", 1)

/obj/item/weapon/reagent_containers/food/snacks/sliceable/brownies
	name = "brownies"
	gender = PLURAL
	desc = "Halfway to fudge, or halfway to cake? Who cares!"
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "brownies"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/browniesslice
	slices_num = 4
	trash = /obj/item/trash/brownies
	filling_color = "#301301"
	nutriment_amt = 8
	nutriment_desc = list("fudge" = 8)
	center_of_mass = list("x"=15, "y"=9)

/obj/item/weapon/reagent_containers/food/snacks/sliceable/brownies/initialize()
	..()
	reagents.add_reagent("protein", 2)
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/browniesslice
	name = "brownie"
	desc = "a dense, decadent chocolate brownie."
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "browniesslice"
	trash = /obj/item/trash/plate
	filling_color = "#F5B951"
	bitesize = 2
	nutriment_desc = list("fudge" = 1)
	center_of_mass = list("x"=16, "y"=12)

/obj/item/weapon/reagent_containers/food/snacks/browniesslice/filled
	nutriment_amt = 1

/obj/item/weapon/reagent_containers/food/snacks/browniesslice/filled/initialize()
	..()
	reagents.add_reagent("protein", 1)

/obj/item/weapon/reagent_containers/food/snacks/sliceable/cosmicbrownies
	name = "cosmic brownies"
	gender = PLURAL
	desc = "Like, ultra-trippy. Brownies HAVE no gender, man." //Except I had to add one!
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "cosmicbrownies"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/cosmicbrowniesslice
	slices_num = 4
	trash = /obj/item/trash/brownies
	filling_color = "#301301"
	nutriment_amt = 8
	nutriment_desc = list("fudge" = 8)
	center_of_mass = list("x"=15, "y"=9)

/obj/item/weapon/reagent_containers/food/snacks/sliceable/cosmicbrownies/initialize()
	..()
	reagents.add_reagent("protein", 2)
	reagents.add_reagent("space_drugs", 2)
	reagents.add_reagent("bicaridine", 1)
	reagents.add_reagent("kelotane", 1)
	reagents.add_reagent("toxin", 1)
	bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/cosmicbrowniesslice
	name = "cosmic brownie"
	desc = "a dense, decadent and fun-looking chocolate brownie."
	icon = 'modular_citadel/icons/obj/food_syn.dmi'
	icon_state = "cosmicbrowniesslice"
	trash = /obj/item/trash/plate
	filling_color = "#F5B951"
	bitesize = 3
	nutriment_desc = list("fudge" = 1)
	center_of_mass = list("x"=16, "y"=12)

/obj/item/weapon/reagent_containers/food/snacks/cosmicbrowniesslice/filled
	nutriment_amt = 1

/obj/item/weapon/reagent_containers/food/snacks/cosmicbrowniesslice/filled/initialize()
	..()
	reagents.add_reagent("protein", 1)