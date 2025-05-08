/obj/item/integrated_electronics/debugger
	name = "circuit debugger"
	desc = "This small tool allows one working with custom machinery to directly set data to a specific pin, useful for writing \
	settings to specific circuits, or for debugging purposes.  It can also pulse activation pins."
	icon = 'icons/obj/integrated_electronics/electronic_tools.dmi'
	icon_state = "debugger"
	w_class = WEIGHT_CLASS_SMALL
	var/data_to_write = null
	var/accepting_refs = FALSE
	var/copy_values = FALSE

/obj/item/integrated_electronics/debugger/attack_self(mob/user, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	var/type_to_use = tgui_input_list(usr, "Please choose a type to use.","[src] type setting", list("string","number","ref", "copy", "list", "null"))
	if(!CanInteract(user, GLOB.physical_state))
		return

	var/new_data = null
	switch(type_to_use)
		if("string")
			accepting_refs = FALSE
			copy_values = FALSE
			new_data = input(usr, "Now type in a string.","[src] string writing") as null|text
			new_data = sanitizeSafe(new_data, MAX_MESSAGE_LEN, 0, 0)
			if(istext(new_data) && CanInteract(user, GLOB.physical_state))
				data_to_write = new_data
				to_chat(user, "<span class='notice'>You set \the [src]'s memory to \"[new_data]\".</span>")

		if("number")
			accepting_refs = FALSE
			copy_values = FALSE
			new_data = input(usr, "Now type in a number.","[src] number writing") as null|num
			if(isnum(new_data) && CanInteract(user, GLOB.physical_state))
				data_to_write = new_data
				to_chat(user, "<span class='notice'>You set \the [src]'s memory to [new_data].</span>")

		if("ref")
			accepting_refs = TRUE
			copy_values = FALSE
			to_chat(user, "<span class='notice'>You turn \the [src]'s ref scanner on.  Slide it across \
			an object for a ref of that object to save it in memory.</span>")

		if("copy")
			accepting_refs = FALSE
			copy_values = TRUE
			to_chat(user, "<span class='notice'>You turn \the [src]'s value copier on.  Use it on a pin \
			to save its current value in memory.</span>")

		if("list")
			accepting_refs = FALSE
			copy_values = FALSE
			var/listLen = input(usr, "Type in a number to be the length of the list (between 1 and 16.)","[src] list len") as null|num
			if(!listLen)
				return
			listLen = clamp(1, listLen, 16)

			var/list/L = list()
			L.len = listLen

			var/list/names = list()

			var/valueToChange = 1
			while(valueToChange)
				names.Cut()
				for (var/i in 1 to L.len)
					var/key = L[i]
					if (key == null)
						key = "null"
					names["#[i] [key]"] = i
				valueToChange = tgui_input_list(usr, "Please choose a value to change.","List Value Setting", names)
				if(!valueToChange) break
				valueToChange = names[valueToChange]
				var/type_to_change = tgui_input_list(usr, "Please choose a type to use.","List [src] type setting", list("string","number","null"))
				switch(type_to_change)
					if("string")
						new_data = input(usr, "Now type in a string.","[src] string writing") as null|text
						new_data = sanitizeSafe(new_data, MAX_MESSAGE_LEN, 0, 0)
						if(istext(new_data) && CanInteract(user, GLOB.physical_state))
							L[valueToChange] = new_data
					if("number")
						new_data = input(usr, "Now type in a number.","[src] number writing") as null|num
						if(isnum(new_data) && CanInteract(user, GLOB.physical_state))
							L[valueToChange] = new_data
					if("null")
						L[valueToChange] = null
			data_to_write = L
			to_chat(user, "<span class='notice'>You set \the [src]'s memory to a list of length [L.len].</span>")

		if("null")
			data_to_write = null
			accepting_refs = FALSE
			copy_values = FALSE
			to_chat(user, "<span class='notice'>You set \the [src]'s memory to absolutely nothing.</span>")

/obj/item/integrated_electronics/debugger/afterattack(atom/target, mob/user, clickchain_flags, list/params)
	if(accepting_refs && (clickchain_flags & CLICKCHAIN_HAS_PROXIMITY))
		data_to_write = WEAKREF(target)
		visible_message("<span class='notice'>[user] slides \a [src]'s over \the [target].</span>")
		to_chat(user, "<span class='notice'>You set \the [src]'s memory to a reference to [target.name] \[Ref\].  The ref scanner is \
		now off.</span>")
		accepting_refs = FALSE

/obj/item/integrated_electronics/debugger/proc/write_data(var/datum/integrated_io/io, mob/user)
	//If the pin can take data:
	if(io.io_type == DATA_CHANNEL)
		//If the debugger is set to copy, copy the data in the pin onto it
		if(copy_values)
			data_to_write = io.data
			to_chat(user, "<span class='notice'>You let the debugger copy the data.</span>")
			copy_values = FALSE
			return

		//Else, write the data to the pin
		io.write_data_to_pin(data_to_write)
		var/data_to_show = data_to_write
		//This is only to convert a weakref into a name for better output
		if(isweakref(data_to_write))
			var/datum/weakref/w = data_to_write
			var/atom/A = w.resolve()
			data_to_show = A.name
		to_chat(user, "<span class='notice'>You write '[data_to_write ? data_to_show : "NULL"]' to the '[io]' pin of \the [io.holder].</span>")

	//If the pin can only be pulsed
	else if(io.io_type == PULSE_CHANNEL)
		io.holder.check_then_do_work(io.ord, ignore_power = TRUE)
		to_chat(user, "<span class='notice'>You pulse \the [io.holder]'s [io].</span>")

	io.holder.interact(user) // This is to update the UI.
