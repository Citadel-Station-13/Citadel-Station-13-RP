//TODO: REPATH TO /obj/structure/chair/sofa @Zandario
/obj/structure/bed/chair/sofa
	name = "sofa"
	desc = "It's made of wood and covered with colored cloth."
	icon = 'icons/obj/structures/sofas.dmi'
	icon_state = "sofamiddle"
	base_icon_state = "sofamiddle"

	//TODO: ATOM_MATERIAL_FLAGS @Zandario
	applies_material_color = TRUE
	material = MAT_WOOD
	reinf_material = MAT_CARPET

	var/mutable_appearance/armrest

/obj/structure/bed/chair/sofa/Initialize(mapload)
	. = ..()
	// AddElement(/datum/element/soft_landing)

	material = GET_MATERIAL_REF(material)
	reinf_material = GET_MATERIAL_REF(reinf_material)

	return INITIALIZE_HINT_LATELOAD

/obj/structure/bed/chair/sofa/LateInitialize()
	. = ..()
	color = null
	gen_armrest()

/obj/structure/bed/chair/sofa/get_default_material()
	return MAT_WOOD

/obj/structure/bed/chair/sofa/get_default_reinf_material()
	return MAT_CARPET

/obj/structure/bed/chair/sofa/update_layer() //only the armrest/back of this chair should cover the mob.
	return

/obj/structure/bed/chair/sofa/update_name(updates)
	. = ..()
	if(applies_material_color && reinf_material)
		name = "[reinf_material.name] [initial(name)]"

/obj/structure/bed/chair/sofa/update_desc(updates)
	. = ..()
	if(!material)
		stack_trace("[src] tried to update_desc() with no material set!")
	desc = "It's made of [material.use_name]"
	if(reinf_material)
		desc += " and covered with [reinf_material.use_name]."
	else
		desc += "."

/obj/structure/bed/chair/sofa/update_icon()
	if(applies_material_color && reinf_material)
		var/datum/material/material_ref = GET_MATERIAL_REF(reinf_material)
		color = material_ref.color
	return ..()

/obj/structure/bed/chair/sofa/proc/gen_armrest()
	armrest = mutable_appearance(initial(icon), "[icon_state]_armrest", ABOVE_MOB_LAYER)
	if(reinf_material)
		var/datum/material/material_ref = GET_MATERIAL_REF(reinf_material)
		armrest.color = material_ref.color
	armrest.plane = ABOVE_PLANE
	update_armrest()

/obj/structure/bed/chair/sofa/proc/update_armrest()
	if(has_buckled_mobs())
		add_overlay(armrest)
	else
		cut_overlay(armrest)

/obj/structure/bed/chair/sofa/mob_buckled()
	. = ..()
	update_armrest()

/obj/structure/bed/chair/sofa/mob_unbuckled()
	. = ..()
	update_armrest()

/obj/structure/bed/chair/sofa/left
	icon_state = "sofaend_left"
	base_icon_state = "sofaend_left"

/obj/structure/bed/chair/sofa/right
	icon_state = "sofaend_right"
	base_icon_state = "sofaend_right"

/obj/structure/bed/chair/sofa/corner
	icon_state = "sofacorner"
	base_icon_state = "sofacorner"
