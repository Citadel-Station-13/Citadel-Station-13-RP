/obj/structure/reagent_dispensers
	name = "Dispenser"
	desc = "..."
	icon = 'icons/obj/objects.dmi'
	icon_state = "watertank"
	layer = TABLE_LAYER
	density = 1
	anchored = 0
	pressure_resistance = 2 * ONE_ATMOSPHERE

	/// what this starts with - wiped on init
	var/list/starting_reagents
	/// max capacity
	var/starting_capacity = 5000

	var/amount_per_transfer_from_this = 10
	var/possible_transfer_amounts = list(10,25,50,100)

/obj/structure/reagent_dispensers/Initialize(mapload)
	. = ..()
	create_reagents(starting_capacity, REAGENT_HOLDER_EXAMINE_EXACT_VOLUMES | REAGENT_HOLDER_EXAMINE_REAGENTS | REAGENT_HOLDER_TRANSPARENT_ANALYSIS)
	for(var/thing in starting_reagents)
		reagents.add_reagent(thing, starting_reagents[thing])

	if (!possible_transfer_amounts)
		remove_obj_verb(src, /obj/structure/reagent_dispensers/verb/set_APTFT)

/obj/structure/reagent_dispensers/verb/set_APTFT() //set amount_per_transfer_from_this
	set name = "Set transfer amount"
	set category = VERB_CATEGORY_OBJECT
	set src in view(1)
	var/N = input("Amount per transfer from this:","[src]") as null|anything in possible_transfer_amounts
	if (N)
		amount_per_transfer_from_this = N

/obj/structure/reagent_dispensers/legacy_ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				new /obj/effect/water(src.loc)
				qdel(src)
				return
		if(3.0)
			if (prob(5))
				new /obj/effect/water(src.loc)
				qdel(src)
				return

/obj/structure/reagent_dispensers/blob_act()
	qdel(src)
