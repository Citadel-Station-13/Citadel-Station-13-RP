/obj/item/reagent_containers/food/snacks/ice_cream
	#warn impl

	// :troll:
	atom_flags = NOREACT


	/// already filled? no double dipping!!
	var/already_was_filled = FALSE

	/// prefill with scoops of these reagents
	var/list/start_with_scoops

#warn macro path generation for: vanilla, chocolate, apple, orange, lime

/obj/item/reagent_containers/food/snacks/icecream
	name = "ice cream cone"
	desc = "Delicious waffle cone, but no ice cream."
	icon_state = "icecream_cone_waffle" //default for admin-spawned cones, href_list["cone"] should overwrite this all the time
	bitesize = 3

	var/ice_creamed = 0
	var/cone_type

/obj/item/reagent_containers/food/snacks/icecream/Initialize(mapload)
	. = ..()
	create_reagents(20)
	reagents.add_reagent("nutriment", 5)

/obj/item/reagent_containers/food/snacks/icecream/proc/add_ice_cream(var/flavour_name)
	name = "[flavour_name] icecream"
	add_overlay("icecream_[flavour_name]")
	desc = "Delicious [cone_type] cone with a dollop of [flavour_name] ice cream."
	ice_creamed = 1


