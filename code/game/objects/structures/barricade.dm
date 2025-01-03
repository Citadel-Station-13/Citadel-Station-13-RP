/obj/structure/barricade
	name = "barricade"
	desc = "This space is blocked off by a barricade."
	icon = 'icons/obj/structures.dmi'
	icon_state = "barricade"
	pass_flags_self = ATOM_PASS_TABLE
	anchored = TRUE
	density = TRUE
	integrity = 200
	integrity_max = 200

	material_parts = /datum/prototype/material/wood_plank

/obj/structure/barricade/Initialize(mapload, datum/prototype/material/material_like)
	if(!isnull(material_like))
		var/resolved_material = RSmaterials.fetch_or_defer(material_like)
		switch(resolved_material)
			if(REPOSITORY_FETCH_DEFER)
				// todo: handle
			else
				set_primary_material(resolved_material)
	return ..()

/obj/structure/barricade/update_material_single(datum/prototype/material/material)
	. = ..()
	name = "[material.display_name] barricade"
	desc = "This space is blocked off by a barricade made of [material.display_name]."
	color = material.icon_colour
	set_multiplied_integrity(material.relative_integrity)

/obj/structure/barricade/attackby(obj/item/I, mob/living/user, list/params, clickchain_flags, damage_multiplier)
	if(user.a_intent == INTENT_HARM)
		return ..()
	if(istype(I, /obj/item/stack/material))
		var/obj/item/stack/material/stack = I
		if(INTERACTING_WITH(user, src))
			return CLICKCHAIN_DO_NOT_PROPAGATE
		if(stack.material.id != get_primary_material_id())
			user.action_feedback(SPAN_WARNING("[stack] is not the right material to fix this!"), src)
			return CLICKCHAIN_DO_NOT_PROPAGATE
		if(integrity == integrity_max)
			user.action_feedback(SPAN_WARNING("[src] does not need repairs!"), src)
			return CLICKCHAIN_DO_NOT_PROPAGATE
		user.visible_action_feedback(
			target = src,
			hard_range = MESSAGE_RANGE_CONSTRUCTION,
			visible_hard = "[user] begins to repair [src].",
		)
		if(!do_after(user, 2 SECONDS, src, mobility_flags = MOBILITY_CAN_USE))
			return CLICKCHAIN_DO_NOT_PROPAGATE
		if(!stack.use(1))
			return CLICKCHAIN_DO_NOT_PROPAGATE
		set_integrity(integrity_max)
		user.visible_action_feedback(
			target = src,
			hard_range = MESSAGE_RANGE_CONSTRUCTION,
			visible_hard = "[user] repairs [src]."
		)
		return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING

/obj/structure/barricade/deconstructed(method)
	. = ..()
	switch(method)
		if(ATOM_DECONSTRUCT_DISASSEMBLED)
		else
			visible_message(SPAN_WARNING("[src] falls apart."))

/obj/structure/barricade/drop_products(method, atom/where)
	. = ..()
	var/datum/prototype/material/primary = get_primary_material()
	primary.place_dismantled_product(where, method == ATOM_DECONSTRUCT_DISASSEMBLED? 5 : 3)
