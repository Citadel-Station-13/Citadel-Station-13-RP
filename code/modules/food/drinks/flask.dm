/obj/item/reagent_containers/food/drinks/flask
	name = "\improper Facility Director's flask"
	desc = "A metal flask belonging to the Facility Director"
	icon_state = "flask"
	volume = 60
	center_of_mass = list("x"=17, "y"=7)
	suit_storage_class = SUIT_STORAGE_CLASS_SOFTWEAR

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
	center_of_mass = list("x"=17, "y"=8)

/obj/item/reagent_containers/food/drinks/flask/barflask
	name = "flask"
	desc = "For those who can't be bothered to hang out at the bar to drink."
	icon_state = "barflask"

/obj/item/reagent_containers/food/drinks/flask/vacuumflask
	name = "vacuum flask"
	desc = "Keeping your drinks at the perfect temperature since 1892."
	icon_state = "vacuumflask"
	center_of_mass = list("x"=15, "y"=4)

/obj/item/reagent_containers/food/drinks/flask/tajflask
	name = "Adhomai flask"
	desc = "A flask wrapped in warm fabric designed to keep the drink warm in Adhomai's frigid climate."
	icon_state = "tajflask"

/obj/item/reagent_containers/food/drinks/flask/tajflask/v_gin
	name = "Victory Gin Flask"
	desc = "Victory Gin is the choice drink of the lower classes of Adhomai. This oily grain alcohol is said to keep you warm on cold winters night."

/obj/item/reagent_containers/food/drinks/flask/tajflask/v_gin/Initialize(mapload)
	. = ..()
	reagents.add_reagent("victory_gin", 60)

