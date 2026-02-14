//Circuit boards are in /code/game/objects/items/weapons/circuitboards/machinery/

/obj/machinery/constructable_frame //Made into a seperate type to make future revisions easier.
	name = "machine frame"
	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "box_0"
	density = TRUE
	anchored = TRUE
	use_power = USE_POWER_OFF
	var/obj/item/circuitboard/circuit = null
	var/list/components = null
	var/list/req_components = null
	var/list/req_component_names = null
	var/state = 1

	proc/update_desc()
		var/D
		if(req_components)
			var/list/component_list = new
			for(var/I in req_components)
				if(req_components[I] > 0)
					component_list += "[num2text(req_components[I])] [req_component_names[I]]"
			D = "Requires [english_list(component_list)]."
		desc = D

/obj/machinery/constructable_frame/machine_frame/attackby(obj/item/P as obj, mob/user as mob)
	if(user.a_intent == INTENT_HARM) //anti-snowflake melee measures
		return ..()
	switch(state)
		if(1)
			if(istype(P, /obj/item/stack/cable_coil))
				var/obj/item/stack/cable_coil/C = P
				if (C.get_amount() < 5)
					to_chat(user, span_warning("You need five lengths of cable to add them to the frame."))
					return
				playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, TRUE)
				to_chat(user, span_notice("You start to add cables to the frame."))
				if(do_after(user, 20) && state == 1)
					if(C.use(5))
						to_chat(user, span_notice("You add cables to the frame."))
						state = 2
						icon_state = "box_1"
			else
				if(P.is_wrench())
					playsound(src, W.tool_sound, 75, TRUE)
					to_chat(user, span_notice("You dismantle the frame"))
					new /obj/item/stack/material/steel(src.loc, 5)
					qdel(src)
		if(2)
			if(istype(P, /obj/item/circuitboard))
				var/obj/item/circuitboard/B = P
				if(B.board_type == "machine")
					playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, TRUE)
					to_chat(user, span_notice("You add the circuit board to the frame."))
					circuit = P
					user.drop_item()
					P.loc = src
					icon_state = "box_2"
					state = 3
					components = list()
					req_components = circuit.req_components.Copy()
					for(var/A in circuit.req_components)
						req_components[A] = circuit.req_components[A]
					req_component_names = circuit.req_components.Copy()
					for(var/A in req_components)
						var/cp = text2path(A)
						var/obj/ct = new cp() // have to quickly instantiate it get name
						req_component_names[A] = ct.name
					update_desc()
					to_chat(user, desc)
				else
					to_chat(user, span_warning("This frame does not accept circuit boards of this type!"))
			else
				if(P.is_wirecutter())
					playsound(src.loc, P.tool_sound, 50, TRUE)
					to_chat(user, span_notice("You remove the cables."))
					state = 1
					icon_state = "box_0"
					var/obj/item/stack/cable_coil/A = new /obj/item/stack/cable_coil(src.loc)
					A.amount = 5

		if(3)
			if(P.is_crowbar())
				playsound(src, P.tool_sound, 50, TRUE)
				state = 2
				circuit.loc = src.loc
				circuit = null
				if(components.len == 0)
					to_chat(user, span_notice("You remove the circuit board."))
				else
					to_chat(user, span_notice("You remove the circuit board and other components."))
					for(var/obj/item/W in components)
						W.loc = src.loc
				desc = initial(desc)
				req_components = null
				components = null
				icon_state = "box_1"
			else
				if(P.is_screwdriver())
					var/component_check = 1
					for(var/R in req_components)
						if(req_components[R] > 0)
							component_check = 0
							break
					if(component_check)
						playsound(src.loc, P.tool_sound, 50, TRUE)
						var/obj/machinery/new_machine = new src.circuit.build_path(src.loc, src.dir)

						if(new_machine.component_parts)
							new_machine.component_parts.Cut()
						else
							new_machine.component_parts = list()

						src.circuit.construct(new_machine)

						for(var/obj/O in src)
							O.loc = new_machine
							new_machine.component_parts += O

						circuit.loc = new_machine

						new_machine.RefreshParts()
						qdel(src)
				else if(istype(P, /obj/item/storage/part_replacer))
					var/obj/item/storage/part_replacer/partreplacer = P
					var/addedparts = FALSE
					for(var/obj/item/I in partreplacer.contents)
						if(is_valid_part(I))
							partreplacer.obj_storage.remove(I)
							take_part(I)
							addedparts = TRUE
					if(addedparts)
						playsound(src.loc, partreplacer.part_replacement_sound, 50, TRUE)
						to_chat(user, desc)
					else
						to_chat(user, span_notice("There doesn't seem to be any components in [partreplacer] that can be added."))
				else if(istype(P, /obj/item))
					if(!is_valid_part(P))
						to_chat(user, span_warning("You cannot add that component to the machine!"))
						return
					if(!user.attempt_insert_item_for_installation(P, src))
						to_chat(user, span_warning("[P] appears to be stuck to your hand!"))
						return
					playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, TRUE)
					take_part(P, user)
					to_chat(user, desc)

/obj/machinery/constructable_frame/proc/is_valid_part(obj/item/P)
	for(var/I in req_components)
		if(istype(P, text2path(I)) && (req_components[I] > 0))
			return TRUE
	return FALSE

/obj/machinery/constructable_frame/proc/take_part(obj/item/P, mob/user)
	if(istype(P, /obj/item/stack)) //usually for cable coil. can support other stacks.
		var/obj/item/stack/S = P
		if(S.get_amount() > 1)
			var/camt = min(S.amount, req_components[I]) // amount of the stack to take, ideally amount required, but limited by amount provided
			var/obj/item/stack/SP = new S.type(src)
			SP.amount = camt
			SP.update_icon()
			S.use(camt)
			components += SP
			req_components[I] -= camt
			update_desc()
			return TRUE
	P.forceMove(src)
	components += P
	req_components[I]--
	update_desc()
	return TRUE
