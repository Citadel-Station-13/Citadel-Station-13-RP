/obj/item/reagent_containers/cartridge
	/// prespawn with a reagent?
	var/spawn_reagent
	/// prespawn amount instead of max?
	var/spawn_amount

/obj/item/reagent_containers/cartridge/Initialize(mapload)
	. = ..()
	if(spawn_reagent)
		reagents.add_reagent(spawn_reagent, spawn_amount || volume)

/obj/item/reagent_containers/cartridge/afterattack(atom/target, mob/user, clickchain_flags, list/params)
	if (!is_open_container() || !proximity_flag)
		return

	if(target.is_open_container() && target.reagents) //Something like a glass. Player probably wants to transfer TO it.

		if(!reagents.total_volume)
			to_chat(user, "<span class='warning'>\The [src] is empty.</span>")
			return

		if(target.reagents.total_volume >= target.reagents.maximum_volume)
			to_chat(user, "<span class='warning'>\The [target] is full.</span>")
			return

		var/trans = src.reagents.trans_to(target, amount_per_transfer_from_this)
		to_chat(user, "<span class='notice'>You transfer [trans] units of the solution to \the [target].</span>")
		return
	else
		return ..()
