/*
	Miscellaneous Cosmetic Items - Could be merged with general if we really wanted to trim fat.
*/

/datum/gear/cosmetic
	sort_category = "Cosmetics" // This controls the name of the category in the loadout.
	type_category = /datum/gear/cosmetic // All subtypes of the geartype declared will be associated with this - practically speaking this controls where the items themselves go.
	cost = 1 // Controls how much an item's "cost" is in the loadout point menu. If re-specified on a different item, that value will override this one. This sets the default value..

/datum/gear/cosmetic/lipstick
	display_name = "lipstick, red"
	path = /obj/item/lipstick

/datum/gear/cosmetic/lipstick/black
	display_name = "lipstick, black"
	path = /obj/item/lipstick/black

/datum/gear/cosmetic/lipstick/jade
	display_name = "lipstick, jade"
	path = /obj/item/lipstick/jade

/datum/gear/cosmetic/lipstick/purple
	display_name = "lipstick, purple"
	path = /obj/item/lipstick/purple

/datum/gear/cosmetic/comb
	display_name = "purple comb"
	path = /obj/item/haircomb