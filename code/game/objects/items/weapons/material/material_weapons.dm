// SEE code/modules/materials/materials.dm FOR DETAILS ON INHERITED DATUM.
// This class of weapons takes force and appearance data from a material datum.
// They are also fragile based on material data and many can break/smash apart.
/obj/item/material
	health = 10
	attack_sound = 'sound/weapons/bladeslice.ogg'
	icon = 'icons/obj/weapons.dmi'
	gender = NEUTER
	throw_speed = 3
	throw_range = 7
	w_class = ITEMSIZE_NORMAL
	sharp = 0
	edge = 0
	item_icons = list(
			SLOT_ID_LEFT_HAND = 'icons/mob/items/lefthand_material.dmi',
			SLOT_ID_RIGHT_HAND = 'icons/mob/items/righthand_material.dmi',
			)
	material_parts = /datum/material/steel
	material_costs = 4000
	/// applies material color
	var/material_color = TRUE

	var/unbreakable = 0		//Doesn't lose health
	var/fragile = 0			//Shatters when it dies
	var/dulled = 0			//Has gone dull
	var/can_dull = 1		//Can it go dull?
	var/force_divisor = 0.3
	var/thrown_force_divisor = 0.3
	var/dulled_divisor = 0.1	//Just drops the damage to a tenth
	var/drops_debris = 1
	// todo: proper material opt-out system on /atom level or something, this is trash
	var/no_force_calculations = FALSE

/obj/item/material/Initialize(mapload, material)
	if(!isnull(material))
		set_material_part(MATERIAL_PART_DEFAULT, SSmaterials.resolve_material(material))
	. = ..()

/obj/item/material/Destroy()
	if(atom_flags & ATOM_MATERIALS_TICKING)
		STOP_TICKING_MATERIALS(src)
	return ..()

/obj/item/material/update_material_single(datum/material/material)
	. = ..()
	var/needs_ticking = MATERIAL_NEEDS_PROCESSING(material)
	var/is_ticking = atom_flags & ATOM_MATERIALS_TICKING
	if(needs_ticking && !is_ticking)
		START_TICKING_MATERIALS(src)
	else if(!needs_ticking && is_ticking)
		STOP_TICKING_MATERIALS(src)
	
	if(material_color)
		color = material.icon_colour
	else
		color = null
	siemens_coefficient = material.relative_conductivity
	atom_flags = (atom_flags & ~(NOCONDUCT)) | (material.relative_conductivity == 0? NOCONDUCT : NONE)

	#warn impl

/obj/item/material/proc/update_force()
	if(no_force_calculations)
		return
	if(edge || sharp)
		damage_force = material.get_edge_damage()
	else
		damage_force = material.get_blunt_damage()
	damage_force = round(damage_force*force_divisor)
	if(dulled)
		damage_force = round(damage_force*dulled_divisor)
	throw_force = round(material.get_blunt_damage()*thrown_force_divisor)
	
/obj/item/material/proc/set_material(datum/material/new_material)
	name = "[material.display_name] [initial(name)]"
	health = round(material.integrity/10)
	update_force()

/obj/item/material/melee_mob_hit(mob/target, mob/user, clickchain_flags, list/params, mult, target_zone, intent)
	. = ..()
	if(!unbreakable)
		if(material.is_brittle())
			health = 0
		else if(!prob(material.hardness))
			health--
		check_health()

/obj/item/material/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/whetstone))
		var/obj/item/whetstone/whet = W
		repair(whet.repair_amount, whet.repair_time, user)
	if(istype(W, /obj/item/material/sharpeningkit))
		var/obj/item/material/sharpeningkit/SK = W
		repair(SK.repair_amount, SK.repair_time, user)
	..()

/obj/item/material/proc/check_health(var/consumed)
	if(health<=0)
		if(fragile)
			shatter(consumed)
		else if(!dulled && can_dull)
			dull()

#warn shatter on impact?
/obj/item/material/proc/shatter(var/consumed)
	var/turf/T = get_turf(src)
	visible_message("<span class='danger'>\The [src] [material.destruction_desc]!</span>")
	playsound(src, "shatter", 70, 1)
	if(!consumed && drops_debris)
		material.place_shard(T)
	qdel(src)

/obj/item/material/proc/dull()
	var/turf/T = get_turf(src)
	T.visible_message("<span class='danger'>\The [src] goes dull!</span>")
	playsound(src, "shatter", 70, 1)
	dulled = 1
	if(is_sharp() || has_edge())
		sharp = 0
		edge = 0

/obj/item/material/proc/repair(var/repair_amount, var/repair_time, mob/living/user)
	if(!fragile)
		if(health < initial(health))
			user.visible_message("[user] begins repairing \the [src].", "You begin repairing \the [src].")
			if(do_after(user, repair_time))
				user.visible_message("[user] has finished repairing \the [src]", "You finish repairing \the [src].")
				health = min(health + repair_amount, initial(health))
				dulled = 0
				sharp = initial(sharp)
				edge = initial(edge)
		else
			to_chat(user, "<span class='notice'>[src] doesn't need repairs.</span>")
	else
		to_chat(user, "<span class='warning'>You can't repair \the [src].</span>")
		return

/obj/item/material/proc/sharpen(datum/material/material_like, var/sharpen_time, var/kit, mob/living/M)
	material_like = SSmaterials.resolve_material(material_like)
	if(!fragile && material_primary)
		if(integrity < integrity_max)
			to_chat(M, "You should repair [src] first. Try using [kit] on it.")
			return FALSE
		M.visible_message("[M] begins to replace parts of [src] with [kit].", "You begin to replace parts of [src] with [kit].")
		if(do_after(usr, sharpen_time))
			M.visible_message("[M] has finished replacing parts of [src].", "You finish replacing parts of [src].")
			set_primary_material(material_like)
			return TRUE
	else
		to_chat(M, "<span class = 'warning'>You can't sharpen and re-edge [src].</span>")
		return FALSE
