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

	var/default_material_id = MATERIAL_ID_STEEL
	var/datum/material/material
	var/perunit = SHEET_MATERIAL_AMOUNT
	var/apply_colour //temp pending icon rewrite

/obj/item/stack/material/Initialize(mapload, new_amount, merge = TRUE)
	if(!default_type)
		default_type = MATERIAL_ID_STEEL
	material = get_material_by_name("[default_type]")
	if(!material)
		return INITIALIZE_HINT_QDEL

	. = ..()

	pixel_x = rand(0,4)-4
	pixel_y = rand(0,4)-4


	recipes = material.get_recipes()
	stacktype = material.stack_type
	if(islist(material.stack_origin_tech))
		origin_tech = material.stack_origin_tech.Copy()

	if(apply_colour)
		color = material.icon_colour

	if(!material.conductive)
		flags |= NOCONDUCT

	matter = material.get_matter()
	update_strings()

/obj/item/stack/material/get_material()
	return material

/obj/item/stack/material/proc/update_strings()
	// Update from material datum.
	singular_name = material.sheet_singular_name

	if(amount>1)
		name = "[material.use_name] [material.sheet_plural_name]"
		desc = "A stack of [material.use_name] [material.sheet_plural_name]."
		gender = PLURAL
	else
		name = "[material.use_name] [material.sheet_singular_name]"
		desc = "A [material.sheet_singular_name] of [material.use_name]."
		gender = NEUTER

/obj/item/stack/material/use(var/used)
	. = ..()
	update_strings()
	return

/obj/item/stack/material/transfer_to(obj/item/stack/S, var/tamount=null, var/type_verified)
	var/obj/item/stack/material/M = S
	if(!istype(M) || material.name != M.material.name)
		return 0
	var/transfer = ..(S,tamount,1)
	if(src) update_strings()
	if(M) M.update_strings()
	return transfer

/obj/item/stack/material/attack_self(var/mob/user)
	if(!material.build_windows(user, src))
		..()

/obj/item/stack/material/attackby(var/obj/item/W, var/mob/user)
	if(istype(W,/obj/item/stack/cable_coil))
		material.build_wired_product(user, W, src)
		return
	else if(istype(W, /obj/item/stack/rods))
		material.build_rod_product(user, W, src)
		return
	return ..()

/obj/item/stack/material/iron
	name = "iron"
	icon_state = "sheet-silver"
	default_material_id = MATERIAL_ID_IRON
	apply_colour = 1
	no_variants = FALSE

/obj/item/stack/material/lead
	default_material_id = MATERIAL_ID_LEAD
	icon_state = "sheet-adamantine"
	default_type = "lead"
	apply_colour = 1
	no_variants = FALSE

/obj/item/stack/material/sandstone
	name = "sandstone brick"
	icon_state = "sheet-sandstone"
	default_material_id = MATERIAL_ID_SANDSTONE
	no_variants = FALSE

/obj/item/stack/material/marble
	name = "marble brick"
	icon_state = "sheet-marble"
	default_material_id = MATERIAL_ID_MARBLE
	no_variants = FALSE

/obj/item/stack/material/diamond
	name = "diamond"
	icon_state = "sheet-diamond"
	default_material_id = MATERIAL_ID_DIAMOND

/obj/item/stack/material/uranium
	name = "uranium"
	icon_state = "sheet-uranium"
	default_material_id = MATERIAL_ID_URANIUM
	no_variants = FALSE

/obj/item/stack/material/phoron
	name = "solid phoron"
	icon_state = "sheet-phoron"
	default_material_id = MATERIAL_ID_PHORON
	no_variants = FALSE

/obj/item/stack/material/plastic
	name = "plastic"
	icon_state = "sheet-plastic"
	default_material_id = MATERIAL_ID_PHORON
	no_variants = FALSE

/obj/item/stack/material/gold
	name = "gold"
	icon_state = "sheet-gold"
	default_material_id = MATERIAL_ID_GOLD
	no_variants = FALSE

/obj/item/stack/material/silver
	name = "silver"
	icon_state = "sheet-silver"
	default_material_id = MATERIAL_ID_SILVER
	no_variants = FALSE

//Valuable resource, cargo can sell it.
/obj/item/stack/material/platinum
	name = "platinum"
	icon_state = "sheet-adamantine"
	default_material_id = MATERIAL_ID_PLATINUM
	no_variants = FALSE

//Extremely valuable to Research.
/obj/item/stack/material/mhydrogen
	name = "metallic hydrogen"
	icon_state = "sheet-mythril"
	default_material_id = MATERIAL_ID_METALLIC_HYDROGEN
	no_variants = FALSE

//Fuel for MRSPACMAN generator.
/obj/item/stack/material/tritium
	name = "tritium"
	icon_state = "sheet-silver"
	default_material_id = MATERIAL_ID_TRITIUM
	apply_colour = 1
	no_variants = FALSE

/obj/item/stack/material/osmium
	name = "osmium"
	icon_state = "sheet-silver"
	default_material_id = MATERIAL_ID_OSMIUM
	apply_colour = 1
	no_variants = FALSE

//R-UST port
// Fusion fuel.
/obj/item/stack/material/deuterium
	name = "deuterium"
	icon_state = "sheet-silver"
	default_material_id = MATERIAL_ID_DEUTERIUM
	apply_colour = 1
	no_variants = FALSE

/obj/item/stack/material/steel
	name = MATERIAL_ID_STEEL
	icon_state = "sheet-metal"
	default_material_id = MATERIAL_ID_STEEL
	no_variants = FALSE

/obj/item/stack/material/steel/hull
	name = MAT_STEELHULL
	default_material_id = MATERIAL_ID_STEEL_HULL

/obj/item/stack/material/plasteel
	name = "plasteel"
	icon_state = "sheet-plasteel"
	default_type = "plasteel"
	no_variants = FALSE

/obj/item/stack/material/plasteel/hull
	name = MAT_PLASTEELHULL
	default_material_id = MATERIAL_ID_PLASTEEL_HULL

/obj/item/stack/material/durasteel
	name = "durasteel"
	icon_state = "sheet-durasteel"
	item_state = "sheet-metal"
	default_material_id = MATERIAL_ID_DURASTEEL
	no_variants = FALSE

/obj/item/stack/material/durasteel/hull
	name = MAT_DURASTEELHULL
	default_material_id = MATERIAL_ID_DURASTEEL_HULL

/obj/item/stack/material/titanium
	name = MATERIAL_ID_TITANIUM
	icon_state = "sheet-silver"
	item_state = "sheet-silver"
	default_material_id = MATERIAL_ID_TITANIUM
	no_variants = FALSE

/obj/item/stack/material/titanium/hull
	name = MATERIAL_ID_TITANIUM_HULL
	default_material_id = MATERIAL_ID_TITANIUM_HULL

// Particle Smasher and Exotic material.
/obj/item/stack/material/verdantium
	name = MATERIAL_ID_VERDANTIUM
	icon_state = "sheet-wavy"
	item_state = "mhydrogen"
	default_type = MATERIAL_ID_VERDANTIUM
	no_variants = FALSE
	apply_colour = TRUE

/obj/item/stack/material/morphium
	name = MATERIAL_ID_MORPHIUM
	icon_state = "sheet-wavy"
	item_state = "mhydrogen"
	default_type = MATERIAL_ID_MORPHIUM
	no_variants = FALSE
	apply_colour = TRUE

/obj/item/stack/material/morphium/hull
	name = MATERIAL_ID_MORPHIUM_HULL
	default_type = MATERIAL_ID_MORPHIUM_HULL

/obj/item/stack/material/valhollide
	name = MAT_VALHOLLIDE
	icon_state = "sheet-gem"
	item_state = "diamond"
	default_type = MAT_VALHOLLIDE
	no_variants = FALSE
	apply_colour = TRUE

// Forged in the equivalent of Hell, one piece at a time.
/obj/item/stack/material/supermatter
	name = MAT_SUPERMATTER
	icon_state = "sheet-super"
	item_state = "diamond"
	default_type = MAT_SUPERMATTER
	apply_colour = TRUE

/obj/item/stack/material/supermatter/proc/update_mass()	// Due to how dangerous they can be, the item will get heavier and larger the more are in the stack.
	slowdown = amount / 10
	w_class = min(5, round(amount / 10) + 1)
	throw_range = round(amount / 7) + 1

/obj/item/stack/material/supermatter/use(var/used)
	. = ..()
	update_mass()
	return

/obj/item/stack/material/supermatter/attack_hand(mob/user)
	. = ..()

	update_mass()
	SSradiation.radiate(src, 5 + amount)
	var/mob/living/M = user
	if(!istype(M))
		return

	var/burn_user = TRUE
	if(istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		var/obj/item/clothing/gloves/G = H.gloves
		if(istype(G) && ((G.flags & THICKMATERIAL && prob(70)) || istype(G, /obj/item/clothing/gloves/gauntlets)))
			burn_user = FALSE

		if(burn_user)
			H.visible_message("<span class='danger'>\The [src] flashes as it scorches [H]'s hands!</span>")
			H.apply_damage(amount / 2 + 5, BURN, "r_hand", used_weapon="Supermatter Chunk")
			H.apply_damage(amount / 2 + 5, BURN, "l_hand", used_weapon="Supermatter Chunk")
			H.drop_from_inventory(src, get_turf(H))
			return

	if(istype(user, /mob/living/silicon/robot))
		burn_user = FALSE

	if(burn_user)
		M.apply_damage(amount, BURN, null, used_weapon="Supermatter Chunk")

/obj/item/stack/material/supermatter/ex_act(severity)	// An incredibly hard to manufacture material, SM chunks are unstable by their 'stabilized' nature.
	if(prob((4 / severity) * 20))
		SSradiation.radiate(get_turf(src), amount * 4)
		explosion(get_turf(src),round(amount / 12) , round(amount / 6), round(amount / 3), round(amount / 25))
		qdel(src)
		return
	SSradiation.radiate(get_turf(src), amount * 2)
	..()

/obj/item/stack/material/wood
	name = "wooden plank"
	icon_state = "sheet-wood"
	default_type = MATERIAL_ID_WOOD
	strict_color_stacking = TRUE

/obj/item/stack/material/wood/sif
	name = "alien wooden plank"
	color = "#0099cc"
	default_type = MATERIAL_ID_SIF_WOOD

/obj/item/stack/material/log
	name = "log"
	icon_state = "sheet-log"
	default_type = MATERIAL_ID_LOG
	no_variants = FALSE
	color = "#824B28"
	max_amount = 25
	w_class = ITEMSIZE_HUGE
	description_info = "Use inhand to craft things, or use a sharp and edged object on this to convert it into two wooden planks."
	var/plank_type = /obj/item/stack/material/wood

/obj/item/stack/material/log/sif
	name = "alien log"
	default_type = MATERIAL_ID_SIF_LOG
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
	default_type = "cloth"
	no_variants = FALSE
	pass_color = TRUE
	strict_color_stacking = TRUE

/obj/item/stack/material/resin
	name = "resin"
	icon_state = "sheet-resin"
	default_type = "resin"
	no_variants = TRUE
	apply_colour = TRUE
	pass_color = TRUE
	strict_color_stacking = TRUE

/obj/item/stack/material/cardboard
	name = "cardboard"
	icon_state = "sheet-card"
	default_type = "cardboard"
	no_variants = FALSE
	pass_color = TRUE
	strict_color_stacking = TRUE

/obj/item/stack/material/snow
	name = "snow"
	desc = "The temptation to build a snowman rises."
	icon_state = "sheet-snow"
	default_type = MATERIAL_ID_SNOW

/obj/item/stack/material/snowbrick
	name = "snow brick"
	desc = "For all of your igloo building needs."
	icon_state = "sheet-snowbrick"
	default_type = MATERIAL_ID_SNOW_BRICK

/obj/item/stack/material/leather
	name = "leather"
	desc = "The by-product of mob grinding."
	icon_state = "sheet-leather"
	default_type = "leather"
	no_variants = FALSE
	pass_color = TRUE
	strict_color_stacking = TRUE

/obj/item/stack/material/glass
	name = "glass"
	icon_state = "sheet-glass"
	default_type = MATERIAL_ID_GLASS
	no_variants = FALSE

/obj/item/stack/material/glass/reinforced
	name = "reinforced glass"
	icon_state = "sheet-rglass"
	default_type = MATERIAL_ID_GLASS_REINFORCED
	no_variants = FALSE

/obj/item/stack/material/glass/phoronglass
	name = "borosilicate glass"
	desc = "This sheet is special platinum-glass alloy designed to withstand large temperatures"
	singular_name = "borosilicate glass sheet"
	icon_state = "sheet-phoronglass"
	default_type = MATERIAL_ID_GLASS_PHORON
	no_variants = FALSE

/obj/item/stack/material/glass/phoronrglass
	name = "reinforced borosilicate glass"
	desc = "This sheet is special platinum-glass alloy designed to withstand large temperatures. It is reinforced with few rods."
	singular_name = "reinforced borosilicate glass sheet"
	icon_state = "sheet-phoronrglass"
	default_type = MATERIAL_ID_GLASS_PHORON_REINFORCED
	no_variants = FALSE
