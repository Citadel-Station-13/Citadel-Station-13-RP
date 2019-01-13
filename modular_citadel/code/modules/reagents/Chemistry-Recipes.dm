/*
====================
	Food
====================
*/
/datum/chemical_reaction/dough
	inhibitors = list("water" = 1, "beer" = 1) //To prevent it messing with batter recipes

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

/datum/chemical_reaction/browniemix
	name = "Brownie Mix"
	id = "browniemix"
	result = "browniemix"
	required_reagents = list("flour" = 5, "coco" = 5, "sugar" = 5)
	result_amount = 15

/datum/chemical_reaction/butter
	name = "Butter"
	id = "butter"
	result = null
	required_reagents = list("cream" = 20, "sodiumchloride" = 1)
	result_amount = 1

/datum/chemical_reaction/butter/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/weapon/reagent_containers/food/snacks/spreads/butter(location)
	return

/datum/chemical_reaction/browniemix
	name = "Brownie Mix"
	id = "browniemix"
	result = "browniemix"
	required_reagents = list("flour" = 5, "coco" = 5, "sugar" = 5)
	result_amount = 15
