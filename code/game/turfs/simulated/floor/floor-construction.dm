//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * * Radial will not show if no e_args are present.
 * * force_flooring will be used if provided, preventing normal picks. This can be an ID or a path.
 */
/turf/simulated/floor/proc/attempt_construct_flooring(obj/item/with_item, datum/event_args/actor/e_args, force_flooring)
	if(flooring)
		return FALSE
	if(broken || burnt)
		e_args.chat_feedback(SPAN_WARNING("This section is too damaged to support anything. Use a welder to fix the damage"))
		return FALSE
	var/list/datum/prototype/flooring/possible
	var/has_amount = 1
	var/obj/item/stack/using_stack
	if(istype(with_item, /obj/item/stack))
		if(istype(with_item, /obj/item/stack/material))
			var/obj/item/stack/material/with_mat_stack = with_item
			possible = RSflooring.build_material_lookup[with_mat_stack.material.id]
			has_amount = with_mat_stack.get_amount()
			using_stack = with_mat_stack
		else
			var/obj/item/stack/with_stack = with_item
			possible = RSflooring.build_item_lookup[with_stack.get_use_as_type()]
			has_amount = with_stack.get_amount()
			using_stack = with_stack
	if(!possible)
		return FALSE
	var/datum/prototype/flooring/trying_to_make = possible
	if(force_flooring && !(trying_to_make.id == force_flooring || trying_to_make.type == force_flooring))
		return FALSE
	// todo: multiple possible floorings are disabled for UI/UX reasons. put the selector on the stack
	//       with client-local-state sometime, and re-enable it.
	/*
	if(force_flooring)
		for(var/datum/prototype/flooring/potential as anything in possible)
			if(potential.type == force_flooring || potential.id == force_flooring)
				trying_to_make = potential
				break
		if(!trying_to_make)
			return FALSE
	if(!trying_to_make)
		switch(length(possible))
			if(1)
				trying_to_make = possible[1]
			else
				var/list/built_choices = list()
				var/list/pick_choices = list()
				var/matrix/three_fourths_size = matrix()
				three_fourths_size.Scale(3 / 4, 3 / 4)
				for(var/datum/prototype/flooring/potential as anything in possible)
					built_choices[potential.name] = potential
					var/image/preview = image(potential.icon, potential.icon_base)
					preview.transform = three_fourths_size
					preview.maptext = MAPTEXT_CENTER(potential.name)
					preview.maptext_width = 64
					var/use_name = potential.name
					var/notch = 1
					while(pick_choices[use_name])
						use_name = "[potential.name] ([notch++])"
					pick_choices[use_name] = preview
				var/choice_name = show_radial_menu(e_args.initiator, src, pick_choices)
				trying_to_make = built_choices[choice_name]
				if(!trying_to_make)
					return FALSE
	*/
	if(trying_to_make.build_cost > has_amount)
		e_args.chat_feedback(SPAN_WARNING("You require at least [trying_to_make.build_cost] [with_item.name] to lay down those [trying_to_make.descriptor]"))
		return FALSE
	if(trying_to_make.build_time && !do_after(e_args.performer, trying_to_make.build_time))
		return FALSE
	if(flooring)
		return FALSE
	if(using_stack ? !using_stack.use(trying_to_make.build_cost) : !e_args.performer.attempt_void_item_for_installation(with_item))
		return FALSE
	if(!using_stack)
		qdel(with_item)
	set_flooring(trying_to_make)
	// todo: silent option
	playsound(src, 'sound/items/Deconstruct.ogg', 80, 1)
	return TRUE

/turf/simulated/floor/dynamic_tool_query(obj/item/I, datum/event_args/actor/clickchain/e_args)
	if(!flooring)
		return ..()
	. = list()
	if(flooring.destroy_tool)
		for(var/tool_function in flooring.destroy_tool)
			.[tool_function] = list("destroy tiles" = dyntool_image_backward(tool_function))
	if(flooring.dismantle_tool)
		for(var/tool_function in flooring.dismantle_tool)
			.[tool_function] = list("dismantle tiles" = dyntool_image_backward(tool_function))

	return merge_double_lazy_assoc_list(..(), .)

/turf/simulated/floor/tool_act(obj/item/I, datum/event_args/actor/clickchain/e_args, function, flags, hint)
	. = ..()
	if(.)
		return
	if(!flooring)
		return
	if(hint == "dismantle tiles" && (function in flooring.dismantle_tool))
		if(!use_tool(function, I, e_args, flags, flooring.dismantle_time, 0.25))
			return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING
		user_dismantle_flooring(I, e_args, flags & TOOL_OP_SILENT)
		return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING
	if(hint == "destroy tiles" && (function in flooring.destroy_tool))
		if(!use_tool(function, I, e_args, flags, flooring.destroy_time, 0.25))
			return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING
		user_dismantle_flooring(I, e_args, flags & TOOL_OP_SILENT)
		return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING

/**
 * @params
 * * tool - the tool
 * * e_args - the actor args
 * * silent - don't show them a message
 */
/turf/simulated/floor/proc/user_dismantle_flooring(obj/item/tool, datum/event_args/actor/clickchain/e_args, silent)
	log_actor_construction(src, e_args, "dismantled flooring via [tool] ([tool.type]) ([flooring])")
	e_args.chat_feedback(SPAN_NOTICE("You dismantle the [flooring.descriptor] with [tool]."))
	dismantle_flooring(TRUE)

/**
 * @params
 * * tool - the tool
 * * e_args - the actor args
 * * silent - don't show them a message
 */
/turf/simulated/floor/proc/user_destroy_flooring(obj/item/tool, datum/event_args/actor/clickchain/e_args, silent)
	log_actor_construction(src, e_args, "destroyed flooring via [tool] ([tool.type]) ([flooring])")
	e_args.chat_feedback(SPAN_WARNING("You forcefully dismantle the [flooring.descriptor] with [tool], destroying them in the process."))
	dismantle_flooring(FALSE)
