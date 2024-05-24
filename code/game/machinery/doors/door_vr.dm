
// Returns true only if one of the actions unique to reinforcing is done, otherwise false and continuing normal attackby
/obj/machinery/door/proc/attackby_vr(obj/item/I, mob/living/user, list/params, clickchain_flags, damage_multiplier)
	if(I.is_material_stack_of(/datum/material/plasteel))
		if(heat_resistance > initial(heat_resistance))
			to_chat(user, "<span class='warning'>\The [src] is already reinforced.</span>")
			return TRUE
		if(machine_stat & BROKEN)
			to_chat(user, "<span class='notice'>It looks like \the [src] broken. Repair it before reinforcing it.</span>")
			return TRUE
		if(!density)
			to_chat(user, "<span class='warning'>\The [src] must be closed before you can reinforce it.</span>")
			return TRUE

		var/amount_needed = 2

		var/obj/item/stack/stack = I
		var/amount_given = amount_needed - reinforcing
		var/mats_given = stack.get_amount()
		if(reinforcing && amount_given <= 0)
			to_chat(user, "<span class='warning'>You must weld or remove \the plasteel from \the [src] before you can add anything else.</span>")
		else
			if(mats_given >= amount_given)
				if(stack.use(amount_given))
					reinforcing += amount_given
			else
				if(stack.use(mats_given))
					reinforcing += mats_given
					amount_given = mats_given
		if(amount_given)
			to_chat(user, "<span class='notice'>You fit [amount_given] [stack.singular_name]\s on \the [src].</span>")

		return TRUE

	if(reinforcing && istype(I, /obj/item/weldingtool))
		if(!density)
			to_chat(user, "<span class='warning'>\The [src] must be closed before you can reinforce it.</span>")
			return TRUE

		if(reinforcing < 2)
			to_chat(user, "<span class='warning'>You will need more plasteel to reinforce \the [src].</span>")
			return TRUE

		var/obj/item/weldingtool/welder = I
		if(welder.remove_fuel(0,user))
			to_chat(user, "<span class='notice'>You start weld \the plasteel into place.</span>")
			playsound(src, welder.tool_sound, 50, 1)
			if(do_after(user, 10 * welder.tool_speed) && welder && welder.isOn())
				to_chat(user, "<span class='notice'>You finish reinforcing \the [src].</span>")
				heat_resistance = 6000
				update_icon()
				reinforcing = 0
		return TRUE

	if(reinforcing && I.is_crowbar())
		var/obj/item/stack/material/plasteel/reinforcing_sheet = new /obj/item/stack/material/plasteel(src.loc)
		reinforcing_sheet.amount = reinforcing
		reinforcing = 0
		to_chat(user, "<span class='notice'>You remove \the [reinforcing_sheet].</span>")
		playsound(src, I.tool_sound, 100, 1)
		return TRUE

	return FALSE
