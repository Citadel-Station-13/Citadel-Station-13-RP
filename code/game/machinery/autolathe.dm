/obj/machinery/autolathe
	name = "autolathe"
	desc = "It produces items using metal and glass."
	icon = 'icons/obj/machines/fabricators/autolathe.dmi'
	icon_state = "autolathe"
	density = TRUE
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 10
	active_power_usage = 2000
	clicksound = "keyboard"
	clickvol = 30

	var/hacked = FALSE
	var/disabled = FALSE
	var/shocked = FALSE
	var/busy = FALSE

#warn  wires?

/obj/machinery/autolathe/Destroy()
	QDEL_NULL(wires)
	return ..()

/obj/machinery/autolathe/ui_status(mob/user)
	if(disabled)
		return UI_CLOSE
	return ..()

/obj/machinery/autolathe/interact(mob/user)
	if(panel_open)
		return wires.Interact(user)

	if(disabled)
		to_chat(user, SPAN_DANGER("\The [src] is disabled!"))
		return

	if(shocked)
		shock(user, 50)

	ui_interact(user)

/obj/machinery/autolathe/ui_act(action, list/params, datum/tgui/ui)
	if(..())
		return TRUE

	switch(action)
		if("make")
			var/datum/category_item/autolathe/making = locate(params["make"])
			if(!istype(making))
				return
			if(making.hidden && !hacked)
				return

			var/multiplier = 1

			if(making.is_stack)
				var/max_sheets
				for(var/material in making.resources)
					var/coeff = (making.no_scale ? 1 : mat_efficiency) //Stacks are unaffected by production coefficient
					var/sheets = round(stored_material[material]/round(making.resources[material]*coeff))
					if(isnull(max_sheets) || max_sheets > sheets)
						max_sheets = sheets
					if(!isnull(stored_material[material]) && stored_material[material] < round(making.resources[material]*coeff))
						max_sheets = 0
				//Build list of multipliers for sheets.
				multiplier = input(usr, "How many do you want to print? (0-[max_sheets])") as num|null
				if(!multiplier || multiplier <= 0 || multiplier > max_sheets || ui_status(usr, ui.state) != UI_INTERACTIVE)
					return FALSE

			busy = making.name
			update_use_power(USE_POWER_ACTIVE)

			// ...
			update_icon() //So lid closes

			sleep(build_time)

			busy = 0
			update_use_power(USE_POWER_IDLE)
			update_icon() //So lid opens

			//Sanity check.
			if(!making || !src)
				return

			//Create the desired item.
			var/obj/item/I = new making.path(src.loc)
			flick("[initial(icon_state)]_finish", src)
			if(multiplier > 1)
				if(istype(I, /obj/item/stack))
					var/obj/item/stack/S = I
					S.amount = multiplier
				else
					for(multiplier; multiplier > 1; --multiplier) //Create multiple items if it's not a stack.
						new making.path(src.loc)
			return TRUE
	return FALSE
