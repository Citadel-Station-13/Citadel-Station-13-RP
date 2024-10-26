//This file contains Food recipes for dough and similar
//Seperation of Food Recipes and other chemicals

/datum/chemical_reaction/food
	abstract_type = /datum/chemical_reaction/food
	___legacy_allow_collision_do_not_use = TRUE

/datum/chemical_reaction/food/soysauce
	name = "Soy Sauce"
	id = "soysauce"
	result = "soysauce"
	required_reagents = list("soymilk" = 4, "sacid" = 1)
	result_amount = 5

/datum/chemical_reaction/food/ketchup
	name = "Ketchup"
	id = "ketchup"
	result = "ketchup"
	required_reagents = list("tomatojuice" = 2, "water" = 1, "sugar" = 1)
	result_amount = 4

/datum/chemical_reaction/food/peanutbutter
	name = "Peanut Butter"
	id = "peanutbutter"
	result = "peanutbutter"
	required_reagents = list("peanutoil" = 2, "sugar" = 1, "sodiumchloride" = 1)
	catalysts = list("enzyme" = 5)
	result_amount = 3

/datum/chemical_reaction/food/mayonnaise
	name = "mayonnaise"
	id = "mayo"
	result = "mayo"
	required_reagents = list("egg" = 9, "cornoil" = 5, "lemonjuice" = 5, "sodiumchloride" = 1)
	result_amount = 15

/datum/chemical_reaction/hot_ramen
	name = "Hot Ramen"
	id = "hot_ramen"
	result = "hot_ramen"
	required_reagents = list("water" = 1, "dry_ramen" = 3)
	result_amount = 3

/datum/chemical_reaction/hell_ramen
	name = "Hell Ramen"
	id = "hell_ramen"
	result = "hell_ramen"
	required_reagents = list("capsaicin" = 1, "hot_ramen" = 6)
	result_amount = 6

/datum/chemical_reaction/coating
	abstract_type = /datum/chemical_reaction/coating

/datum/chemical_reaction/coating/batter
	name = "Batter"
	id = "batter"
	result = "batter"
	required_reagents = list("egg" = 3, "flour" = 10, "water" = 5, "sodiumchloride" = 2)
	result_amount = 20

/datum/chemical_reaction/coating/beerbatter
	name = "Beer Batter"
	id = "beerbatter"
	result = "beerbatter"
	required_reagents = list("egg" = 3, "flour" = 10, "beer" = 5, "sodiumchloride" = 2)
	result_amount = 20

/datum/chemical_reaction/food/browniemix
	name = "Brownie Mix"
	id = "browniemix"
	result = "browniemix"
	required_reagents = list("flour" = 5, "coco" = 5, "sugar" = 5)
	result_amount = 15

/datum/chemical_reaction/food/tallow
	name = "Tallow"
	id = "tallow"
	result = "tallow"
	required_reagents = list("protein" = 3, "nutriment" = 1)
	catalysts = list("enzyme" = 5)
	result_amount = 4

/datum/chemical_reaction/food/brine
	name = "Brine"
	id = "brine"
	result = "brine"
	required_reagents = list("water" = 5, "sodiumchloride" = 1, "sugar" = 1)
	catalysts = list("enzyme" = 5)
	result_amount = 5
