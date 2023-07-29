// todo: this is awful and need to all be refactored
// Putting these at /clothing/ level saves a lot of code duplication in armor/helmets/gauntlets/etc
/obj/item/clothing
	material_parts = MATERIAL_DEFAULT_NONE
	material_costs = 4000
	material_primary = MATERIAL_PART_DEFAULT
	var/material_significance = MATERIAL_SIGNIFICANCE_BASELINE
	var/material_color = TRUE

/obj/item/clothing/Initialize(mapload, material_armor)
	if(!isnull(material_armor))
		set_material_part(MATERIAL_PART_DEFAULT, SSmaterials.resolve_material(material_armor))
	. = ..()

/obj/item/clothing/Destroy()
	if(atom_flags & ATOM_MATERIALS_TICKING)
		STOP_TICKING_MATERIALS(src)
	return ..()

/obj/item/clothing/update_material_single(datum/material/material)
	. = ..()
	name = "[material.display_name] [initial(name)]"
	var/needs_ticking = MATERIAL_NEEDS_PROCESSING(material)
	var/is_ticking = atom_flags & ATOM_MATERIALS_TICKING
	if(needs_ticking && !is_ticking)
		START_TICKING_MATERIALS(src)
	else if(!needs_ticking && is_ticking)
		STOP_TICKING_MATERIALS(src)
	set_armor(material.create_armor(material_significance))
	if(material_color)
		color = material.icon_colour
	else
		color = null
	#warn carry weight and weight/density
	siemens_coefficient = material.relative_conductivity
	atom_flags = (atom_flags & ~(NOCONDUCT)) | (material.relative_conductivity == 0? NOCONDUCT : NONE)
	#warn impl

// This is called when someone wearing the object gets hit in some form (melee, bullet_act(), etc).
// Note that this cannot change if someone gets hurt, as it merely reacts to being hit.
/obj/item/clothing/proc/clothing_impact(var/obj/source, var/damage)
	if(material && damage)
		material_impact(source, damage)

/obj/item/clothing/proc/material_impact(var/obj/source, var/damage)
	if(!material || unbreakable)
		return

	if(istype(source, /obj/projectile))
		var/obj/projectile/P = source
		if(P.check_pass_flags(ATOM_PASS_GLASS))
			if(material.opacity - 0.3 <= 0)
				return // Lasers ignore 'fully' transparent material.

	if(material.is_brittle())
		health = 0
	else if(!prob(material.hardness))
		health--

	if(health <= 0)
		shatter()

/obj/item/clothing/proc/shatter()
	if(!material)
		return
	var/turf/T = get_turf(src)
	T.visible_message("<span class='danger'>\The [src] [material.destruction_desc]!</span>")
	if(istype(loc, /mob/living))
		var/mob/living/M = loc
		if(material.shard_type == SHARD_SHARD) // Wearing glass armor is a bad idea.
			var/obj/item/material/shard/S = material.place_shard(T)
			M.embed(S)

	playsound(src, "shatter", 70, 1)
	qdel(src)

// Might be best to make ablative vests a material armor using a new material to cut down on this copypaste.
/obj/item/clothing/suit/armor/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if(!material) // No point checking for reflection.
		return ..()

	if(material.negation && prob(material.negation)) // Strange and Alien materials, or just really strong materials.
		user.visible_message("<span class='danger'>\The [src] completely absorbs [attack_text]!</span>")
		return TRUE

	if(material.spatial_instability && prob(material.spatial_instability))
		user.visible_message("<span class='danger'>\The [src] flashes [user] clear of [attack_text]!</span>")
		var/list/turfs = new/list()
		for(var/turf/T in orange(round(material.spatial_instability / 10) + 1, user))
			if(istype(T,/turf/space)) continue
			if(T.density) continue
			if(T.x>world.maxx-6 || T.x<6)	continue
			if(T.y>world.maxy-6 || T.y<6)	continue
			turfs += T
		if(!turfs.len) turfs += pick(/turf in orange(6))
		var/turf/picked = pick(turfs)
		if(!isturf(picked)) return

		var/datum/effect_system/spark_spread/spark_system = new /datum/effect_system/spark_spread()
		spark_system.set_up(5, 0, user.loc)
		spark_system.start()
		playsound(user.loc, 'sound/effects/teleport.ogg', 50, 1)

		user.loc = picked
		return PROJECTILE_FORCE_MISS

	if(material.reflectivity)
		if(istype(damage_source, /obj/projectile/energy) || istype(damage_source, /obj/projectile/beam))
			var/obj/projectile/P = damage_source

			if(P.reflected) // Can't reflect twice
				return ..()

			var/reflectchance = (40 * material.reflectivity) - round(damage/3)
			reflectchance *= material_armor_modifer
			if(!(def_zone in list(BP_TORSO, BP_GROIN)))
				reflectchance /= 2
			if(P.starting && prob(reflectchance))
				visible_message("<span class='danger'>\The [user]'s [src.name] reflects [attack_text]!</span>")

				// Find a turf near or on the original location to bounce to
				var/new_x = P.starting.x + pick(0, 0, 0, 0, 0, -1, 1, -2, 2)
				var/new_y = P.starting.y + pick(0, 0, 0, 0, 0, -1, 1, -2, 2)
				var/turf/curloc = get_turf(user)

				// redirect the projectile
				P.redirect(new_x, new_y, curloc, user)
				P.reflected = 1

				return PROJECTILE_CONTINUE // complete projectile permutation

/obj/item/clothing/suit/armor/material
	name = "armor"
	default_material = MAT_STEEL

/obj/item/clothing/suit/armor/material/makeshift
	name = "sheet armor"
	desc = "This appears to be two 'sheets' of a material held together by cable.  If the sheets are strong, this could be rather protective."
	icon_state = "material_armor_makeshift"

/obj/item/clothing/suit/armor/material/makeshift/durasteel
	default_material = "durasteel"

/obj/item/clothing/suit/armor/material/makeshift/glass
	default_material = "glass"

// Used to craft sheet armor, and possibly other things in the Future(tm).
/obj/item/material/armor_plating
	name = "armor plating"
	desc = "A sheet designed to protect something."
	icon = 'icons/obj/items.dmi'
	icon_state = "armor_plate"
	unbreakable = TRUE
	force_divisor = 0.05 // Really bad as a weapon.
	thrown_force_divisor = 0.2
	var/wired = FALSE

/obj/item/material/armor_plating/attackby(var/obj/O, mob/user)
	if(istype(O, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/S = O
		if(wired)
			to_chat(user, "<span class='warning'>This already has enough wires on it.</span>")
			return
		if(S.use(20))
			to_chat(user, "<span class='notice'>You attach several wires to \the [src].  Now it needs another plate.</span>")
			wired = TRUE
			icon_state = "[initial(icon_state)]_wired"
			return
		else
			to_chat(user, "<span class='notice'>You need more wire for that.</span>")
			return
	if(istype(O, /obj/item/material/armor_plating))
		var/obj/item/material/armor_plating/second_plate = O
		if(!wired && !second_plate.wired)
			to_chat(user, "<span class='warning'>You need something to hold the two pieces of plating together.</span>")
			return
		if(second_plate.material != src.material)
			to_chat(user, "<span class='warning'>Both plates need to be the same type of material.</span>")
			return
		if(!user.attempt_void_item_for_installation(src))
			return
		if(!user.attempt_void_item_for_installation(second_plate))
			return
		var/obj/item/clothing/suit/armor/material/makeshift/new_armor = new(loc, material.name)
		user.temporarily_remove_from_inventory(second_plate, INV_OP_FORCE | INV_OP_DELETING | INV_OP_SILENT)
		user.temporarily_remove_from_inventory(src, INV_OP_FORCE | INV_OP_DELETING | INV_OP_SILENT)
		user.put_in_hands_or_drop(new_armor)
		qdel(second_plate)
		qdel(src)
	else
		..()


// Used to craft the makeshift helmet
/obj/item/clothing/head/helmet/bucket
	name = "improvised armor (bucket)"
	desc = "It's a bucket with a large hole cut into it. Desperate times require desperate measures, and you can't get more desperate than trusting a CleanMate bucket as a helmet."
	inv_hide_flags = HIDEEARS|HIDEEYES|BLOCKHAIR
	icon_state = "bucket"
	armor_type = /datum/armor/misc/bucket

/obj/item/clothing/head/helmet/bucket/wood
	name = "wooden bucket"
	icon_state = "woodbucket"

/obj/item/clothing/head/helmet/bucket/attackby(var/obj/O, mob/user)
	if(istype(O, /obj/item/stack/material))
		var/obj/item/stack/material/S = O
		if(S.use(2))
			to_chat(user, "<span class='notice'>You apply some [S.material.use_name] to \the [src].  Hopefully it'll make the makeshift helmet stronger.</span>")
			var/obj/item/clothing/head/helmet/material/makeshift/helmet = new(loc, S.material.name)
			user.temporarily_remove_from_inventory(src, INV_OP_FORCE | INV_OP_SILENT | INV_OP_DELETING)
			user.put_in_hands_or_drop(helmet)
			qdel(src)
			return
		else
			to_chat(user, "<span class='warning'>You don't have enough material to build a helmet!</span>")
	else
		..()

/obj/item/clothing/head/helmet/material
	name = "helmet"
	inv_hide_flags = HIDEEARS|HIDEEYES|BLOCKHAIR
	default_material = MAT_STEEL

/obj/item/clothing/head/helmet/material/makeshift
	name = "bucket"
	desc = "A bucket with plating applied to the outside.  Very crude, but could potentially be rather protective, if \
	it was plated with something strong."
	icon_state = "material_armor_makeshift"

/obj/item/clothing/head/helmet/material/makeshift/durasteel
	default_material = "durasteel"
