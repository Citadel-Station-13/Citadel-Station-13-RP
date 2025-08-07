//? Keep this file sorted. ?//

/**
 * Recipes that collapse into, per-unit-reaction, an item.
 */
/datum/chemical_reaction/food/synthesis
	abstract_type = /datum/chemical_reaction/food/synthesis

	require_whole_numbers = TRUE
	important_for_logging = TRUE

	/// item to make
	var/synthesis_product_path

/datum/chemical_reaction/food/synthesis/on_reaction_instant(datum/reagent_holder/holder, multiplier)
	. = ..()
	var/turf/location = get_turf(holder.my_atom)
	if(!location)
		return
	for(var/i in 1 to multiplier)
		new synthesis_product_path(location)

/datum/chemical_reaction/food/synthesis/bluecheesewheel
	name = "Blue Cheese wheel"
	id = "synthesis-bluecheesewheel"
	required_reagents = list("milk" = 40, "virusfood" = 5)

	synthesis_product_path = /obj/item/reagent_containers/food/snacks/sliceable/bluecheesewheel

/datum/chemical_reaction/food/synthesis/butter
	name = "Butter"
	id = "butter"
	required_reagents = list("cream" = 20, "sodiumchloride" = 1)

	synthesis_product_path = /obj/item/reagent_containers/food/snacks/spreads/butter

/datum/chemical_reaction/food/synthesis/cheesewheel
	name = "Cheese wheel"
	id = "synthesis-cheesewheel"
	required_reagents = list("milk" = 40)
	catalysts = list("enzyme" = 5)

	synthesis_product_path = /obj/item/reagent_containers/food/snacks/sliceable/cheesewheel

/datum/chemical_reaction/food/synthesis/chocolate_bar
	name = "Chocolate Bar"
	id = "synthesis-chocolate_bar-milk"
	required_reagents = list("soymilk" = 2, "coco" = 2, "sugar" = 2)

	synthesis_product_path = /obj/item/reagent_containers/food/snacks/chocolatebar

	// sigh
	priority = 100

/datum/chemical_reaction/food/synthesis/chocolate_bar2
	name = "Chocolate Bar"
	id = "synthesis-chocolate_bar-soymilk"
	required_reagents = list("milk" = 2, "coco" = 2, "sugar" = 2)

	synthesis_product_path = /obj/item/reagent_containers/food/snacks/chocolatebar

	// sigh
	priority = 100

/datum/chemical_reaction/food/synthesis/dough
	name = "Dough"
	id = "synthesis-dough"
	required_reagents = list("egg" = 3, "flour" = 10)
	inhibitors = list("water" = 1, "beer" = 1) //To prevent it messing with batter recipes

	synthesis_product_path = /obj/item/reagent_containers/food/snacks/dough

/datum/chemical_reaction/food/synthesis/meatball
	name = "Meatball"
	id = "synthesis-meatball"
	required_reagents = list("protein" = 3, "flour" = 5)

	synthesis_product_path = /obj/item/reagent_containers/food/snacks/meatball

/datum/chemical_reaction/food/synthesis/meatsicle
	name = "Meatsicle"
	id = "meatsicle"
	required_reagents = list("protein" = 6, "ice" = 6)

	synthesis_product_path = /obj/item/reagent_containers/food/snacks/meatsicle

/datum/chemical_reaction/food/synthesis/synthflesh
	name = "Synthflesh"
	id = "synthesis-synthflesh"
	required_reagents = list("blood" = 5, "clonexadone" = 1)

	synthesis_product_path = /obj/item/reagent_containers/food/snacks/meat/synthflesh

/datum/chemical_reaction/food/synthesis/tofu
	name = "Tofu"
	id = "synthesis-tofu"
	required_reagents = list("soymilk" = 10)
	catalysts = list("enzyme" = 5)

	synthesis_product_path = /obj/item/reagent_containers/food/snacks/tofu
