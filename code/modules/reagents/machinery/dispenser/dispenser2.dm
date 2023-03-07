
/obj/machinery/chemical_dispenser/attackby(obj/item/W, mob/user)
	else if(istype(W, /obj/item/reagent_containers/glass) || istype(W, /obj/item/reagent_containers/food))
		if(container)
			to_chat(user, "<span class='warning'>There is already \a [container] on \the [src]!</span>")
			return

		var/obj/item/reagent_containers/RC = W

		if(!accept_drinking && istype(RC,/obj/item/reagent_containers/food))
			to_chat(user, "<span class='warning'>This machine only accepts beakers!</span>")
			return
		if(!RC.is_open_container())
			to_chat(user, "<span class='warning'>You don't see how \the [src] could dispense reagents into \the [RC].</span>")
			return
		if(!user.attempt_insert_item_for_installation(RC, src))
			return
		container =  RC
		to_chat(user, "<span class='notice'>You set \the [RC] on \the [src].</span>")
		SStgui.update_uis(src) // update all UIs attached to src

	else
		return ..()
