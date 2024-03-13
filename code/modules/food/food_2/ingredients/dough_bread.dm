/obj/item/reagent_containers/food/snacks/ingredient/transformable/dough
	name = "dough"
	desc = "A piece of dough."
	icon = 'icons/obj/food_ingredients.dmi'
	cookstage_information = list(list(0, 0.5, "raw dough"), list(60 SECONDS, 1, "bread"), list(80 SECONDS, 0.9, "weird dough"), list(100 SECONDS, 0.1, "weird dough")) //overcooked and burnt wont ever appear
	icon_state = "dough"
	nutriment_amt = 3
	transform_list = list(METHOD_OVEN = /obj/item/reagent_containers/food/snacks/ingredient/bread, METHOD_DEEPFRY = /obj/item/reagent_containers/food/snacks/ingredient/frieddoughball) //example
	fallback_create = /obj/item/reagent_containers/food/snacks/ingredient/bread/damper
	var/obj/item/reagent_containers/food/snacks/ingredient/flatten_type = /obj/item/reagent_containers/food/snacks/ingredient/transformable/dough/flat


/obj/item/reagent_containers/food/snacks/ingredient/transformable/dough/try_flatten(mob/user)
	if(flatten_type)
		var/make_item = flatten_type
		var/obj/item/reagent_containers/food/snacks/ingredient/flatten_output = new make_item(loc)
		to_chat(user, SPAN_NOTICE("You flatten [src]."))
		flatten_output.cookstage = cookstage
		flatten_output.accumulated_time_cooked = accumulated_time_cooked
		qdel(src)
		return

/obj/item/reagent_containers/food/snacks/ingredient/transformable/dough/flat
	name = "flat dough"
	desc = "A flattened piece of dough."
	icon_state = "flat dough"
	cookstage_information = list(list(0, 0.5, "raw dough"), list(40 SECONDS, 1, "bread"), list(60 SECONDS, 0.9, "weird dough"), list(100 SECONDS, 0.1, "weird dough"))
	slice_path = /obj/item/reagent_containers/food/snacks/ingredient/transformable/dough/slice
	slices_num = 3
	nutriment_amt = 3
	transform_list = list(METHOD_OVEN = /obj/item/reagent_containers/food/snacks/ingredient/flatbread)
	fallback_create = /obj/item/reagent_containers/food/snacks/ingredient/flatbread
	flatten_type = null

/obj/item/reagent_containers/food/snacks/ingredient/transformable/dough/slice
	name = "dough slice"
	desc = "A building block of an impressive dish."
	icon_state = "doughslice"
	cookstage_information = list(list(0, 0.5, "raw dough"), list(30 SECONDS, 1, "bread"), list(80 SECONDS, 0.9, "weird dough"), list(100 SECONDS, 0.1, "weird dough")) //only thing that matters here is cooktime
	slice_path = /obj/item/reagent_containers/food/snacks/ingredient/spaghetti
	nutriment_amt = 1
	slices_num = 1
	bitesize = 2
	transform_list = null
	fallback_create = /obj/item/reagent_containers/food/snacks/ingredient/bun
	flatten_type = /obj/item/reagent_containers/food/snacks/ingredient/tortilla/flour

/obj/item/reagent_containers/food/snacks/ingredient/transformable/dough/corn
	name = "masa"
	desc = "A piece of dough made from corn flour. Used for making tortillas and cornbread."
	cookstage_information = list(list(0, 0.5, "raw corn dough"), list(60 SECONDS, 1, "cornbread"), list(80 SECONDS, 0.9, "weird dough"), list(100 SECONDS, 0.1, "weird dough"))
	icon_state = "dough"
	transform_list = list(METHOD_OVEN = /obj/item/reagent_containers/food/snacks/ingredient/cornbread, METHOD_DEEPFRY = /obj/item/reagent_containers/food/snacks/ingredient/hushpuppy)
	fallback_create = /obj/item/reagent_containers/food/snacks/ingredient/bread/pone
	flatten_type = /obj/item/reagent_containers/food/snacks/ingredient/transformable/dough/flat/corn

/obj/item/reagent_containers/food/snacks/ingredient/transformable/dough/flat/corn
	name = "flat masa"
	desc = "A piece of dough made from corn flour. Used for making tortillas and cornbread."
	cookstage_information = list(list(0, 0.5, "raw corn dough"), list(60 SECONDS, 1, "cornbread"), list(80 SECONDS, 0.9, "weird dough"), list(100 SECONDS, 0.1, "weird dough"))
	icon_state = "flat dough"
	transform_list = null
	fallback_create = /obj/item/reagent_containers/food/snacks/ingredient/bread/pone
	slice_path = /obj/item/reagent_containers/food/snacks/ingredient/transformable/dough/slice/corn
	slices_num = 6

/obj/item/reagent_containers/food/snacks/ingredient/transformable/dough/slice/corn
	name = "masa slice"
	desc = "A building block of an impressive dish."
	cookstage_information = list(list(0, 0.5, "raw corn dough"), list(30 SECONDS, 1, "cornbread"), list(45 SECONDS, 0.9, "weird dough"), list(60 SECONDS, 0.1, "weird dough"))
	transform_list = null
	fallback_create = /obj/item/reagent_containers/food/snacks/ingredient/cornmuffin
	slice_path = null
	flatten_type = /obj/item/reagent_containers/food/snacks/ingredient/tortilla

/obj/item/reagent_containers/food/snacks/ingredient/bread
	name = "bread"
	cookstage_information = list(list(0, 1, "fresh white bread"), list(80 SECONDS, 1, "toast"), list(120 SECONDS, 0.8, "burnt toast"), list(140 SECONDS, 0.1, "pure carbon"))
	desc = "Some plain white bread."
	icon_state = "bread"
	slice_path = /obj/item/reagent_containers/food/snacks/ingredient/slice/bread
	slices_num = 5
	filling_color = "#FFE396"

/obj/item/reagent_containers/food/snacks/ingredient/slice/bread
	name = "slice of bread"
	cookstage_information = list(list(0, 1, "fresh white bread"), list(10 SECONDS, 1, "toast"), list(20 SECONDS, 0.8, "burnt toast"), list(25 SECONDS, 0.1, "crispy pure carbon"))
	desc = "A slice of bread."
	icon_state = "breadslice"
	filling_color = "#D27332"

/obj/item/reagent_containers/food/snacks/ingredient/damper
	name = "damper"
	cookstage_information = list(list(0, 1, "fresh bread"), list(40 SECONDS, 1, "toast"), list(120 SECONDS, 0.8, "burnt toast"), list(300 SECONDS, 0.1, "a lump of charcoal")) //damper is very forgiving cooktime-wise
	desc = "Some plain damper. The most basic kind of bread."
	icon_state = "bread"
	filling_color = "#ffda96"


/obj/item/reagent_containers/food/snacks/ingredient/cornbread
	name = "cornbread"
	cookstage_information = list(list(0, 1, "fresh cornbread"), list(20 SECONDS, 1, "toasted cornbread"), list(40 SECONDS, 0.8, "burnt corn toast"), list(100 SECONDS, 0.1, "pure carbon"))
	icon_state = "A loaf of cornbread."
	icon_state = "bread"
	slice_path = /obj/item/reagent_containers/food/snacks/ingredient/slice/cornbread
	slices_num = 5
	filling_color = "#c7d232"

/obj/item/reagent_containers/food/snacks/ingredient/slice/cornbread
	name = "slice of cornbread"
	cookstage_information = list(list(0, 1, "fresh cornbread"), list(10 SECONDS, 1, "corn toast"), list(20 SECONDS, 0.8, "burnt corn toast"), list(25 SECONDS, 0.1, "crispy pure carbon"))
	desc = "A slice of cornbread."
	icon_state = "breadslice"
	filling_color = "#c7d232"

/obj/item/reagent_containers/food/snacks/ingredient/tortilla
	name = "tortilla"
	cookstage_information = list(list(0, 1, "raw masa"), list(10 SECONDS, 1, "light, fluffy tortilla"), list(20 SECONDS, 0.8, "crispy tortilla"), list(25 SECONDS, 0.1, "flat carbon"))
	desc = "A plain tortilla, made from masa."
	icon_state = "tortilla"
	filling_color = "#FFE396"

/obj/item/reagent_containers/food/snacks/ingredient/tortilla/flour
	name = "flour tortilla"
	cookstage_information = list(list(0, 1, "raw dough"), list(10 SECONDS, 1, "light, fluffy tortilla"), list(20 SECONDS, 0.8, "crispy tortilla"), list(25 SECONDS, 0.1, "flat carbon"))
	desc = "A plain tortilla, made from flour."

/obj/item/reagent_containers/food/snacks/ingredient/cornmuffin
	name = "cornbread muffin"
	cookstage_information = list(list(0, 1, "fresh cornbread"), list(10 SECONDS, 1, "corn toast"), list(20 SECONDS, 0.8, "burnt corn toast"), list(25 SECONDS, 0.1, "crispy pure carbon"))
	desc = "A muffin that's also cornbread."
	icon_state = "muffin"
	filling_color = "#c7d232"

/obj/item/reagent_containers/food/snacks/ingredient/flatbread
	name = "flatbread"
	cookstage_information = list(list(0, 1, "flat bread"), list(30 SECONDS, 1, "flat toast"), list(50 SECONDS, 0.8, "burnt flat"), list(100 SECONDS, 0.1, "flat carbon"))
	desc = "A flat piece of bread. A crucial part of a pizza base."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "flatbread"
	filling_color = "#c7d232"


/obj/item/reagent_containers/food/snacks/ingredient/frieddoughball
	name = "fried doughball"
	desc = "A fried ball of dough. What do you plan to do with this?"

/obj/item/reagent_containers/food/snacks/ingredient/hushpuppy
	name = "hush puppy"
	desc = "A fried ball of corn dough. A versatile side dish."

/obj/item/reagent_containers/food/snacks/ingredient/bun
	name = "bun"
	desc = "A plain bun."

/obj/item/reagent_containers/food/snacks/ingredient/bread/pone
	name = "corn pone"
	desc = "A simple unleavened bread made from corn flour."

/obj/item/reagent_containers/food/snacks/ingredient/bread/damper
	name = "damper"
	desc = "A simple unleavened bread made from wheat flour. Typically cooked in the coals of a fire, but any cooking method will do in a pinch."


/obj/item/reagent_containers/food/snacks/ingredient/spaghetti
	name = "raw spaghetti"
	desc = "Raw, handmade spaghetti noodles."
