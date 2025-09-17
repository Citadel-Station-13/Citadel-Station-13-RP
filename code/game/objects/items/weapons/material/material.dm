// SEE code/modules/materials/materials.dm FOR DETAILS ON INHERITED DATUM.
// This class of weapons takes force and appearance data from a material datum.
// They are also fragile based on material data and many can break/smash apart.
/obj/item/material
	attack_sound = 'sound/weapons/bladeslice.ogg'
	icon = 'icons/obj/weapons.dmi'
	gender = NEUTER
	throw_speed = 3
	throw_range = 7
	w_class = WEIGHT_CLASS_NORMAL
	item_icons = list(
			SLOT_ID_LEFT_HAND = 'icons/mob/items/lefthand_material.dmi',
			SLOT_ID_RIGHT_HAND = 'icons/mob/items/righthand_material.dmi',
			)
	material_parts = /datum/prototype/material/steel
	material_costs = SHEET_MATERIAL_AMOUNT * 2
	material_primary = MATERIAL_PART_DEFAULT

	/// applies material color
	var/material_color = TRUE
	/// material attribute significance
	var/material_significance = MATERIAL_SIGNIFICANCE_BASELINE
	/// material quantity significance
	/// this is multiplier to material amount to determine stuff like weight.
	var/material_factoring = 0.05
	/// % of force that goes int oforce
	var/throw_force_multiplier = 1
	/// direct force multiplier
	var/force_multiplier = 1

	// var/unbreakable = 0		//Doesn't lose health
	// var/fragile = 0			//Shatters when it dies
	// var/dulled = 0			//Has gone dull
	// var/can_dull = 1		//Can it go dull?
	// var/dulled_divisor = 0.1	//Just drops the damage to a tenth
	// var/drops_debris = 1

/obj/item/material/Initialize(mapload, material)
	if(!isnull(material))
		material_parts = material
	return ..()

/obj/item/material/update_material_single(datum/prototype/material/material)
	. = ..()
	if(isnull(material))
		return
	if(material_color)
		color = material.icon_colour
	else
		color = null
	siemens_coefficient = material.relative_conductivity
	atom_flags = (atom_flags & ~(NOCONDUCT)) | (material.relative_conductivity == 0? NOCONDUCT : NONE)
	name = "[material.display_name] [initial(name)]"

	var/list/returned = material.melee_stats(initial(damage_mode), material_significance)
	damage_force = returned[MATERIAL_MELEE_STATS_DAMAGE] * force_multiplier
	damage_mode = returned[MATERIAL_MELEE_STATS_MODE]
	damage_flag = returned[MATERIAL_MELEE_STATS_FLAG]
	damage_tier = initial(damage_tier) + returned[MATERIAL_MELEE_STATS_TIERMOD]

	// todo: this is a multiplier, not a divisor
	throw_force = damage_force * throw_force_multiplier

/obj/item/material/melee_finalize(datum/event_args/actor/clickchain/clickchain, clickchain_flags, datum/melee_attack/weapon/attack_style)
	. = ..()
	MATERIAL_INVOKE(src, MATERIAL_TRAIT_MELEE, on_melee_finalize, clickchain, clickchain_flags, attack_style)

// todo: dulling system, maybe /obj/item level..?

/obj/item/material/attackby(obj/item/I, mob/user, list/params, clickchain_flags, damage_multiplier)
	// if(istype(W, /obj/item/whetstone))
	// 	var/obj/item/whetstone/whet = W
	// 	repair(whet.repair_amount, whet.repair_time, user)
	// if(istype(I, /obj/item/material/sharpeningkit))
	// 	var/obj/item/material/sharpeningkit/SK = I
	// 	repair(SK.repair_amount, SK.repair_time, user)
	return ..()

// /obj/item/material/proc/check_health(var/consumed)
// 	if(health<=0)
// 		if(fragile)
// 			shatter(consumed)
// 		else if(!dulled && can_dull)
// 			dull()

// #warn shatter on impact?
// /obj/item/material/proc/dull()
// 	var/turf/T = get_turf(src)
// 	T.visible_message("<span class='danger'>\The [src] goes dull!</span>")
// 	playsound(src, "shatter", 70, 1)
// 	dulled = 1
// 	if(is_sharp() || has_edge())
// 		sharp = 0
// 		edge = 0

// /obj/item/material/proc/repair(var/repair_amount, var/repair_time, mob/living/user)
// 	if(!fragile)
// 		if(health < initial(health))
// 			user.visible_message("[user] begins repairing \the [src].", "You begin repairing \the [src].")
// 			if(do_after(user, repair_time))
// 				user.visible_message("[user] has finished repairing \the [src]", "You finish repairing \the [src].")
// 				health = min(health + repair_amount, initial(health))
// 				dulled = 0
// 				sharp = initial(sharp)
// 				edge = initial(edge)
// 		else
// 			to_chat(user, "<span class='notice'>[src] doesn't need repairs.</span>")
// 	else
// 		to_chat(user, "<span class='warning'>You can't repair \the [src].</span>")
// 		return

/obj/item/material/proc/sharpen(datum/prototype/material/material_like, var/sharpen_time, var/kit, mob/living/M)
	material_like = RSmaterials.fetch(material_like)
	// if(!fragile && material_primary)
	if(material_primary)
		// if(integrity < integrity_max)
		// 	to_chat(M, "You should repair [src] first. Try using [kit] on it.")
		// 	return FALSE
		M.visible_message("[M] begins to replace parts of [src] with [kit].", "You begin to replace parts of [src] with [kit].")
		if(do_after(usr, sharpen_time))
			M.visible_message("[M] has finished replacing parts of [src].", "You finish replacing parts of [src].")
			set_primary_material(material_like)
			return TRUE
	else
		to_chat(M, "<span class = 'warning'>You can't sharpen and re-edge [src].</span>")
		return FALSE
