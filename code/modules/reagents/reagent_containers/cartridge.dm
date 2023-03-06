/obj/item/reagent_containers/cartridge
	/// prespawn with a reagent?
	var/spawn_reagent
	/// prespawn amount instead of max?
	var/spawn_amount

/obj/item/reagent_containers/cartridge/Initialize(mapload)
	. = ..()
	if(spawn_reagent)
		reagents.add_reagent(spawn_reagent, spawn_amount || volume)
