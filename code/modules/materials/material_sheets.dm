// Stacked resources. They use a material datum for a lot of inherited values.
// If you're adding something here, make sure to add it to fifty_spawner_mats.dm as well
/obj/item/stack/material
	force = 5.0
	throwforce = 5
	w_class = ITEMSIZE_NORMAL
	throw_speed = 3
	throw_range = 3
	max_amount = 50
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_material.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_material.dmi',
		)

	var/material_id = DEFAULT_WALL_MATERIAL_ID		//What it starts out as. INTENTIONALLY NOT MATERIAL_PRIMARY.

	var/perunit = SHEET_MATERIAL_AMOUNT

/obj/item/stack/material/Initialize(mapload)
	. = ..()
	AutoSetMaterial(material_id, MATINDEX_OBJ_PRIMARY)
	pixel_x = rand(0,4)-4
	pixel_y = rand(0,4)-4

/obj/item/stack/material/UpdateMaterials()
	. = ..()
	recipes = material_primary?.get_recipes()
	stacktype = material_primary?.stack_type
	if(islist(material.stack_origin_tech))
		origin_tech = material.stack_origin_tech.Copy()

	if(material_primary?.conductive)
		flags |= CONDUCT

	matter = material_primary.get_matter()
	update_strings()

/obj/item/stack/material/proc/update_strings()
	// Update from material datum.
	singular_name = material_primary?.sheet_singular_name || "sheet"

	if(amount>1)
		name = "[material_primary?.use_name] [material_primary?.sheet_plural_name || "undefined sheets"]"
		desc = "A stack of [material_primary?.use_name] [material_primary.sheet_plural_name || "broken code. Contact a coder!"]."
		gender = PLURAL
	else
		name = "[material_primary?.use_name] [material_primary?.sheet_singular_name || "undefined sheets"]"
		desc = "A stack of [material_primary?.use_name] [material_primary.sheet_singular_name || "broken code. Contact a coder!"]."
		gender = NEUTER

/obj/item/stack/material/use(used)
	. = ..()
	update_strings()

/obj/item/stack/material/transfer_to(obj/item/stack/S, var/tamount=null, var/type_verified)
	var/obj/item/stack/material/M = S
	if(!istype(M) || material.id != M.material_primary.id)
		return 0
	var/transfer = ..(S,tamount,1)
	if(src) update_strings()
	if(M) M.update_strings()
	return transfer

/obj/item/stack/material/attack_self(var/mob/user)
	if(!material_primary?.build_windows(user, src))
		return ..()

/obj/item/stack/material/attackby(var/obj/item/W, var/mob/user)
	if(istype(W,/obj/item/stack/cable_coil))
		material_primary?.build_wired_product(user, W, src)
		return
	else if(istype(W, /obj/item/stack/rods))
		material_primary?.build_rod_product(user, W, src)
		return
	return ..()

/obj/item/stack/material/iron
	name = "iron"
	icon_state = "sheet-silver"
	material_id = MATERIAL_ID_IRON
	apply_colour = 1
	no_variants = FALSE

/obj/item/stack/material/lead
	name = "lead"
	icon_state = "sheet-adamantine"
	material_id = MATERIAL_ID_LEAD
	apply_colour = 1
	no_variants = TRUE

/obj/item/stack/material/sandstone
	name = "sandstone brick"
	icon_state = "sheet-sandstone"
	material_id = MATERIAL_ID_SANDSTONE
	no_variants = FALSE

/obj/item/stack/material/marble
	name = "marble brick"
	icon_state = "sheet-marble"
	material_id = MATERIAL_ID_MARBLE
	no_variants = FALSE

/obj/item/stack/material/diamond
	name = "diamond"
	icon_state = "sheet-diamond"
	material_id = MATERIAL_ID_DIAMOND

/obj/item/stack/material/uranium
	name = "uranium"
	icon_state = "sheet-uranium"
	material_id = MATERIAL_ID_URANIUM
	no_variants = FALSE

/obj/item/stack/material/phoron
	name = "solid phoron"
	icon_state = "sheet-phoron"
	material_id = MATERIAL_ID_PHORON
	no_variants = FALSE

/obj/item/stack/material/plastic
	name = "plastic"
	icon_state = "sheet-plastic"
	material_id = MATERIAL_ID_PLASTIC
	no_variants = FALSE

/obj/item/stack/material/gold
	name = "gold"
	icon_state = "sheet-gold"
	material_id = MATERIAL_ID_GOLD
	no_variants = FALSE

/obj/item/stack/material/silver
	name = "silver"
	icon_state = "sheet-silver"
	material_id = MATERIAL_ID_SILVER
	no_variants = FALSE

//Valuable resource, cargo can sell it.
/obj/item/stack/material/platinum
	name = "platinum"
	icon_state = "sheet-adamantine"
	material_id = MATERIAL_ID_PLATNIUM
	no_variants = FALSE

//Extremely valuable to Research.
/obj/item/stack/material/mhydrogen
	name = "metallic hydrogen"
	icon_state = "sheet-mythril"
	material_id = MATERIAL_ID_MHYDROGEN
	no_variants = FALSE

//Fuel for MRSPACMAN generator.
/obj/item/stack/material/tritium
	name = "tritium"
	icon_state = "sheet-silver"
	material_id = MATERIAL_ID_TRITIUM
	apply_colour = 1
	no_variants = FALSE

/obj/item/stack/material/osmium
	name = "osmium"
	icon_state = "sheet-silver"
	material_id = MATERIAL_ID_OSMIUM
	apply_colour = 1
	no_variants = FALSE

//R-UST port
// Fusion fuel.
/obj/item/stack/material/deuterium
	name = "deuterium"
	icon_state = "sheet-silver"
	material_id = MATERIAL_ID_DEUTERIUM
	apply_colour = 1
	no_variants = FALSE

/obj/item/stack/material/steel
	name = "steel"
	icon_state = "sheet-metal"
	material_id = MATERIAL_ID_STEEL
	no_variants = FALSE

/obj/item/stack/material/steel/hull
	name = "steel hull"
	material_id = MATERIAL_ID_STEEL_HULL

/obj/item/stack/material/plasteel
	name = "plasteel"
	icon_state = "sheet-plasteel"
	material_id = MATERIAL_ID_PLASTEEL
	no_variants = FALSE

/obj/item/stack/material/plasteel/hull
	name = "plasteel hull"
	material_id = MATERIAL_ID_PLASTEEL_HULL

/obj/item/stack/material/durasteel
	name = "durasteel"
	icon_state = "sheet-durasteel"
	item_state = "sheet-metal"
	material_id = MATERIAL_ID_DURASTEEL
	no_variants = FALSE

/obj/item/stack/material/durasteel/hull
	name = "durasteel hull"
	material_id = MATERIAL_ID_DURASTEEL_HULL

/obj/item/stack/material/wood
	name = "wooden plank"
	icon_state = "sheet-wood"
	material_id = MATERIAL_ID_WOOD

/obj/item/stack/material/wood/sif
	name = "alien wooden plank"
	color = "#0099cc"
	material_id = MATERIAL_ID_SIFWOOD

/obj/item/stack/material/log
	name = "log"
	icon_state = "sheet-log"
	material_id = MATERIAL_ID_LOG
	no_variants = FALSE
	color = "#824B28"
	max_amount = 25
	w_class = ITEMSIZE_HUGE
	description_info = "Use inhand to craft things, or use a sharp and edged object on this to convert it into two wooden planks."
	var/plank_type = /obj/item/stack/material/wood

/obj/item/stack/material/log/sif
	name = "alien log"
	material_id = MATERIAL_ID_SIFLOG
	color = "#0099cc"
	plank_type = /obj/item/stack/material/wood/sif

/obj/item/stack/material/log/attackby(var/obj/item/W, var/mob/user)
	if(!istype(W) || W.force <= 0)
		return ..()
	if(W.sharp && W.edge)
		var/time = (3 SECONDS / max(W.force / 10, 1)) * W.toolspeed
		user.setClickCooldown(time)
		if(do_after(user, time, src) && use(1))
			to_chat(user, "<span class='notice'>You cut up a log into planks.</span>")
			playsound(get_turf(src), 'sound/effects/woodcutting.ogg', 50, 1)
			var/obj/item/stack/material/wood/existing_wood = null
			for(var/obj/item/stack/material/wood/M in user.loc)
				if(M.material.name == src.material.name)
					existing_wood = M
					break

			var/obj/item/stack/material/wood/new_wood = new plank_type(user.loc)
			new_wood.amount = 2
			if(existing_wood && new_wood.transfer_to(existing_wood))
				to_chat(user, "<span class='notice'>You add the newly-formed wood to the stack. It now contains [existing_wood.amount] planks.</span>")
	else
		return ..()


/obj/item/stack/material/cloth
	name = "cloth"
	icon_state = "sheet-cloth"
	material_id = MATERIAL_ID_CLOTH
	no_variants = FALSE

/obj/item/stack/material/cardboard
	name = "cardboard"
	icon_state = "sheet-card"
	material_id = MATERIAL_ID_CARDBOARD
	no_variants = FALSE

/obj/item/stack/material/snow
	name = "snow"
	desc = "The temptation to build a snowman rises."
	icon_state = "sheet-snow"
	material_id = MATERIAL_ID_SNOW

/obj/item/stack/material/snowbrick
	name = "snow brick"
	desc = "For all of your igloo building needs."
	icon_state = "sheet-snowbrick"
	material_id = MATERIAL_ID_SNOWBRICK

/obj/item/stack/material/leather
	name = "leather"
	desc = "The by-product of mob grinding."
	icon_state = "sheet-leather"
	material_id = MATERIAL_ID_LEATHER
	no_variants = FALSE

/obj/item/stack/material/glass
	name = "glass"
	icon_state = "sheet-glass"
	material_id = MATERIAL_ID_GLASS
	no_variants = FALSE

/obj/item/stack/material/glass/reinforced
	name = "reinforced glass"
	icon_state = "sheet-rglass"
	material_id = MATERIAL_ID_RGLASS
	no_variants = FALSE

/obj/item/stack/material/glass/phoronglass
	name = "borosilicate glass"
	desc = "This sheet is special platinum-glass alloy designed to withstand large temperatures"
	singular_name = "borosilicate glass sheet"
	icon_state = "sheet-phoronglass"
	material_id = MATERIAL_ID_PHORON_GLASS
	no_variants = FALSE

/obj/item/stack/material/glass/phoronrglass
	name = "reinforced borosilicate glass"
	desc = "This sheet is special platinum-glass alloy designed to withstand large temperatures. It is reinforced with few rods."
	singular_name = "reinforced borosilicate glass sheet"
	icon_state = "sheet-phoronrglass"
	material_id = MATERIAL_ID_PHORON_RGLASS
	no_variants = FALSE
