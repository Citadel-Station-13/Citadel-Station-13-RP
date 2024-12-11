// todo: this is awful and need to all be refactored
// Putting these at /clothing/ level saves a lot of code duplication in armor/helmets/gauntlets/etc
/obj/item/clothing
	material_parts = MATERIAL_DEFAULT_DISABLED
	material_costs = 4000
	material_primary = MATERIAL_PART_DEFAULT

	/// applies material color
	var/material_color = TRUE
	/// material attribute significance
	var/material_significance = MATERIAL_SIGNIFICANCE_BASELINE
	/// material quantity significance
	/// this is multiplier to material amount to determine stuff like weight.
	var/material_factoring = 0.00025

/obj/item/clothing/Initialize(mapload, material_armor)
	if(!isnull(material_armor))
		material_parts = material_armor
	return ..()

/obj/item/clothing/update_material_single(datum/prototype/material/material)
	. = ..()
	if(isnull(material))
		return
	name = "[material.display_name] [initial(name)]"
	set_armor(material.create_armor(material_significance))
	if(material_color)
		color = material.icon_colour
	else
		color = null
	// todo: this is just hardcoded because clothing material armor is.. janky.
	var/effective_weight = material.density * material.weight_multiplier * material_factoring * 4000
	set_weight(effective_weight)
	siemens_coefficient = material.relative_conductivity
	atom_flags = (atom_flags & ~(NOCONDUCT)) | (material.relative_conductivity == 0? NOCONDUCT : NONE)

/obj/item/clothing/suit/armor/material
	name = "armor"
	material_parts = /datum/prototype/material/steel

/obj/item/clothing/suit/armor/material/makeshift
	name = "sheet armor"
	desc = "This appears to be two 'sheets' of a material held together by cable.  If the sheets are strong, this could be rather protective."
	icon_state = "material_armor_makeshift"

/obj/item/clothing/suit/armor/material/makeshift/durasteel
	material_parts = /datum/prototype/material/durasteel

/obj/item/clothing/suit/armor/material/makeshift/glass
	material_parts = /datum/prototype/material/glass

// Used to craft sheet armor, and possibly other things in the Future(tm).
/obj/item/material/armor_plating
	name = "armor plating"
	desc = "A sheet designed to protect something."
	icon = 'icons/obj/items.dmi'
	icon_state = "armor_plate"
	material_significance = MATERIAL_SIGNIFICANCE_SHARD
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
		if(second_plate.get_primary_material() != get_primary_material())
			to_chat(user, "<span class='warning'>Both plates need to be the same type of material.</span>")
			return
		if(!user.attempt_void_item_for_installation(src))
			return
		if(!user.attempt_void_item_for_installation(second_plate))
			return
		var/obj/item/clothing/suit/armor/material/makeshift/new_armor = new(loc, get_primary_material())
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
	material_parts = /datum/prototype/material/steel

/obj/item/clothing/head/helmet/material/makeshift
	name = "bucket"
	desc = "A bucket with plating applied to the outside.  Very crude, but could potentially be rather protective, if \
	it was plated with something strong."
	icon_state = "material_armor_makeshift"

/obj/item/clothing/head/helmet/material/makeshift/durasteel
	material_parts = /datum/prototype/material/durasteel
