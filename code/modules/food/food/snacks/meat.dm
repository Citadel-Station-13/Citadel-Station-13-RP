/obj/item/reagent_containers/food/snacks/meat
	name = "meat"
	desc = "A slab of meat."
	icon_state = "meat"
	health = 180
	filling_color = "#FF1C1C"
	center_of_mass = list("x"=16, "y"=14)

/obj/item/reagent_containers/food/snacks/meat/Initialize(mapload)
	. = ..()
	reagents.add_reagent("protein", 6)
	reagents.add_reagent("triglyceride", 2)
	src.bitesize = 1.5

/obj/item/reagent_containers/food/snacks/meat/cook()

	if (!isnull(cooked_icon))
		icon_state = cooked_icon
		flat_icon = null //Force regenating the flat icon for coatings, since we've changed the icon of the thing being coated
	..()

	if (name == initial(name))
		name = "cooked [name]"

/obj/item/reagent_containers/food/snacks/meat/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/material/knife))
		new /obj/item/reagent_containers/food/snacks/rawcutlet(src)
		new /obj/item/reagent_containers/food/snacks/rawcutlet(src)
		new /obj/item/reagent_containers/food/snacks/rawcutlet(src)
		to_chat(user, "You cut the meat into thin strips.")
		qdel(src)
	else
		..()

/obj/item/reagent_containers/food/snacks/meat/syntiflesh
	name = "synthetic meat"
	desc = "A synthetic slab of flesh."

// Seperate definitions because some food likes to know if it's human.
// TODO: rewrite kitchen code to check a var on the meat item so we can remove
// all these sybtypes.
/obj/item/reagent_containers/food/snacks/meat/human
	name = "suspicious meat"
	desc = "Tastes vaguely like pork."

/obj/item/reagent_containers/food/snacks/meat/monkey
	//same as plain meat

/obj/item/reagent_containers/food/snacks/meat/corgi
	name = "Corgi meat"
	desc = "Tastes like... well, you know."

/obj/item/reagent_containers/food/snacks/meat/chicken
	icon = 'icons/obj/food.dmi'
	icon_state = "chickenbreast"
	cooked_icon = "chickenbreast_cooked"
	filling_color = "#BBBBAA"

/obj/item/reagent_containers/food/snacks/meat/chicken/Initialize(mapload)
		..()
		reagents.remove_reagent("triglyceride", INFINITY)
		//Chicken is low fat. Less total calories than other meats

/obj/item/reagent_containers/food/snacks/meat/chicken/penguin
	name = "meat"
	desc = "Tastes like chicken? Or fish? Fishy chicken? Strange."
	icon = 'icons/obj/food.dmi'
	icon_state = "penguinmeat"
	cooked_icon = "chickenbreast_cooked"
	filling_color = "#BBBBAA"

/obj/item/reagent_containers/food/snacks/meat/chicken/teshari
	name = "meat"
	desc = "Tastes like a really fast chicken. Who'd have guessed?"

/obj/item/reagent_containers/food/snacks/meat/vox
	name = "Vox meat"
	desc = "Tough and sinewy. Don't eat it raw."
	icon = 'icons/obj/food.dmi'
	icon_state = "voxmeat"
	cooked_icon = "voxmeat_cooked"

/obj/item/reagent_containers/food/snacks/meat/vox/Initialize(mapload)
	. = ..()
	reagents.add_reagent("protein", 6)
	reagents.add_reagent("triglyceride", 2)
	reagents.add_reagent("phoron", 3)
	src.bitesize = 1.5
