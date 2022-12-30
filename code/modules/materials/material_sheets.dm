// Stacked resources. They use a material datum for a lot of inherited values.
// If you're adding something here, make sure to add it to fifty_spawner_mats.dm as well
/obj/item/stack/material
	force = 5
	throw_force = 5
	w_class = ITEMSIZE_NORMAL
	throw_speed = 3
	throw_range = 3
	max_amount = 50
	item_icons = list(
		SLOT_ID_LEFT_HAND = 'icons/mob/items/lefthand_material.dmi',
		SLOT_ID_RIGHT_HAND = 'icons/mob/items/righthand_material.dmi',
		)

	var/default_type = MAT_STEEL
	var/datum/material/material
	var/perunit = SHEET_MATERIAL_AMOUNT
	var/apply_colour //temp pending icon rewrite
	var/allow_window_autobuild = TRUE
	drop_sound = 'sound/items/drop/axe.ogg'
	pickup_sound = 'sound/items/pickup/axe.ogg'

/obj/item/stack/material/Initialize(mapload, new_amount, merge = TRUE)
	if(!default_type)
		default_type = MAT_STEEL
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
		atom_flags |= NOCONDUCT

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
	if(!allow_window_autobuild || !material.build_windows(user, src))
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
	default_type = "iron"
	apply_colour = 1
	no_variants = FALSE

/obj/item/stack/material/lead
	name = "lead"
	icon_state = "sheet-adamantine"
	default_type = "lead"
	apply_colour = 1
	no_variants = FALSE

/obj/item/stack/material/sandstone
	name = "sandstone brick"
	icon_state = "sheet-sandstone"
	default_type = "sandstone"
	no_variants = FALSE
	drop_sound = 'sound/items/drop/boots.ogg'
	pickup_sound = 'sound/items/pickup/boots.ogg'

/obj/item/stack/material/marble
	name = "marble brick"
	icon_state = "sheet-marble"
	default_type = "marble"
	no_variants = FALSE
	drop_sound = 'sound/items/drop/boots.ogg'
	pickup_sound = 'sound/items/pickup/boots.ogg'

/obj/item/stack/material/diamond
	name = "diamond"
	icon_state = "sheet-diamond"
	default_type = "diamond"
	drop_sound = 'sound/items/drop/glass.ogg'
	pickup_sound = 'sound/items/pickup/glass.ogg'

/obj/item/stack/material/uranium
	name = "uranium"
	icon_state = "sheet-uranium"
	default_type = "uranium"
	no_variants = FALSE

/obj/item/stack/material/phoron
	name = "solid phoron"
	icon_state = "sheet-phoron"
	default_type = "phoron"
	no_variants = FALSE

/obj/item/stack/material/plastic
	name = "plastic"
	icon_state = "sheet-plastic"
	default_type = "plastic"
	no_variants = FALSE

/obj/item/stack/material/gold
	name = "gold"
	icon_state = "sheet-gold"
	default_type = "gold"
	no_variants = FALSE

/obj/item/stack/material/silver
	name = "silver"
	icon_state = "sheet-silver"
	default_type = "silver"
	no_variants = FALSE

//Valuable resource, cargo can sell it.
/obj/item/stack/material/platinum
	name = "platinum"
	icon_state = "sheet-adamantine"
	default_type = "platinum"
	no_variants = FALSE

//Extremely valuable to Research.
/obj/item/stack/material/mhydrogen
	name = "metallic hydrogen"
	icon_state = "sheet-mythril"
	default_type = "mhydrogen"
	no_variants = FALSE

//Fuel for MRSPACMAN generator.
/obj/item/stack/material/tritium
	name = "tritium"
	icon_state = "sheet-silver"
	default_type = "tritium"
	apply_colour = 1
	no_variants = FALSE

/obj/item/stack/material/osmium
	name = "osmium"
	icon_state = "sheet-silver"
	default_type = "osmium"
	apply_colour = 1
	no_variants = FALSE

//R-UST port
// Fusion fuel.
/obj/item/stack/material/deuterium
	name = "deuterium"
	icon_state = "sheet-silver"
	default_type = "deuterium"
	apply_colour = 1
	no_variants = FALSE

/obj/item/stack/material/steel
	name = MAT_STEEL
	icon_state = "sheet-metal"
	default_type = MAT_STEEL
	no_variants = FALSE

/obj/item/stack/material/steel/hull
	name = MAT_STEELHULL
	default_type = MAT_STEELHULL

/obj/item/stack/material/plasteel
	name = "plasteel"
	icon_state = "sheet-plasteel"
	default_type = "plasteel"
	no_variants = FALSE

/obj/item/stack/material/plasteel/hull
	name = MAT_PLASTEELHULL
	default_type = MAT_PLASTEELHULL

/obj/item/stack/material/durasteel
	name = "durasteel"
	icon_state = "sheet-durasteel"
	item_state = "sheet-metal"
	default_type = "durasteel"
	no_variants = FALSE

/obj/item/stack/material/durasteel/hull
	name = MAT_DURASTEELHULL

/obj/item/stack/material/titanium
	name = MAT_TITANIUM
	icon_state = "sheet-silver"
	item_state = "sheet-silver"
	default_type = MAT_TITANIUM
	no_variants = FALSE

/obj/item/stack/material/titanium/hull
	name = MAT_TITANIUMHULL
	default_type = MAT_TITANIUMHULL

// Particle Smasher and Exotic material.
/obj/item/stack/material/verdantium
	name = MAT_VERDANTIUM
	icon_state = "sheet-wavy"
	item_state = "mhydrogen"
	default_type = MAT_VERDANTIUM
	no_variants = FALSE
	apply_colour = TRUE

/obj/item/stack/material/morphium
	name = MAT_MORPHIUM
	icon_state = "sheet-wavy"
	item_state = "mhydrogen"
	default_type = MAT_MORPHIUM
	no_variants = FALSE
	apply_colour = TRUE

/obj/item/stack/material/morphium/hull
	name = MAT_MORPHIUMHULL
	default_type = MAT_MORPHIUMHULL

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
	no_variants = FALSE
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
	radiation_pulse(src, RAD_INTENSITY_MAT_SUPERMATTER_PICKUP_PER_SHEET(amount))
	var/mob/living/M = user
	if(!istype(M))
		return

	var/burn_user = TRUE
	if(istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		var/obj/item/clothing/gloves/G = H.gloves
		if(istype(G) && ((G.clothing_flags & THICKMATERIAL && prob(70)) || istype(G, /obj/item/clothing/gloves/gauntlets)))
			burn_user = FALSE

		if(burn_user)
			H.visible_message("<span class='danger'>\The [src] flashes as it scorches [H]'s hands!</span>")
			H.apply_damage(amount / 2 + 5, BURN, "r_hand", used_weapon="Supermatter Chunk")
			H.apply_damage(amount / 2 + 5, BURN, "l_hand", used_weapon="Supermatter Chunk")
			H.drop_item_to_ground(src)
			return

	if(istype(user, /mob/living/silicon/robot))
		burn_user = FALSE

	if(burn_user)
		M.apply_damage(amount, BURN, null, used_weapon="Supermatter Chunk")

/obj/item/stack/material/supermatter/legacy_ex_act(severity)	// An incredibly hard to manufacture material, SM chunks are unstable by their 'stabilized' nature.
	if(prob((4 / severity) * 20))
		// you dun fucked up
		radiation_pulse(src, RAD_INTENSITY_MAT_SUPERMATTER_EXPLODE_PER_SHEET(amount))
		explosion(get_turf(src),round(amount / 12) , round(amount / 6), round(amount / 3), round(amount / 25))
		qdel(src)
		return
	radiation_pulse(src, RAD_INTENSITY_MAT_SUPERMATTER_EXPLODE_PER_SHEET(amount))
	..()

/obj/item/stack/material/wood
	name = "wooden plank"
	icon_state = "sheet-wood"
	default_type = MAT_WOOD
	strict_color_stacking = TRUE
	drop_sound = 'sound/items/drop/wooden.ogg'
	pickup_sound = 'sound/items/pickup/wooden.ogg'

/obj/item/stack/material/wood/sif
	name = "alien wooden plank"
	color = "#0099cc"
	default_type = MAT_SIFWOOD

/obj/item/stack/material/wood/hard
	name = "hardwood plank"
	color = "#42291a"
	default_type = MAT_HARDWOOD
	description_info = "Rich, lustrous hardwood, imported from offworld at moderate expense. Mostly used for luxurious furniture, and not very good for weapons or other structures."

/obj/item/stack/material/log
	name = "log"
	icon_state = "sheet-log"
	default_type = MAT_LOG
	no_variants = FALSE
	color = "#824B28"
	max_amount = 25
	w_class = ITEMSIZE_HUGE
	description_info = "Use inhand to craft things, or use a sharp and edged object on this to convert it into two wooden planks."
	var/plank_type = /obj/item/stack/material/wood
	drop_sound = 'sound/items/drop/wooden.ogg'
	pickup_sound = 'sound/items/pickup/wooden.ogg'

/obj/item/stack/material/log/sif
	name = "alien log"
	default_type = MAT_SIFLOG
	color = "#0099cc"
	plank_type = /obj/item/stack/material/wood/sif

/obj/item/stack/material/log/hard
	name = "hardwood log"
	default_type = MAT_HARDLOG
	color = "#6f432a"
	plank_type = /obj/item/stack/material/wood/hard

/obj/item/stack/material/log/attackby(var/obj/item/W, var/mob/user)
	if(!istype(W) || W.force <= 0)
		return ..()
	if(W.sharp && W.edge)
		var/time = (3 SECONDS / max(W.force / 10, 1)) * W.tool_speed
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
	drop_sound = 'sound/items/drop/cloth.ogg'
	pickup_sound = 'sound/items/pickup/cloth.ogg'

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
	drop_sound = 'sound/items/drop/cardboardbox.ogg'
	pickup_sound = 'sound/items/pickup/cardboardbox.ogg'

/obj/item/stack/material/snow
	name = "snow"
	desc = "The temptation to build a snowman rises."
	icon_state = "sheet-snow"
	default_type = "snow"

/obj/item/stack/material/snowbrick
	name = "snow brick"
	desc = "For all of your igloo building needs."
	icon_state = "sheet-snowbrick"
	default_type = "packed snow"

/obj/item/stack/material/leather
	name = "leather"
	desc = "The by-product of mob grinding."
	icon_state = "sheet-leather"
	default_type = MAT_LEATHER
	no_variants = FALSE
	pass_color = TRUE
	strict_color_stacking = TRUE
	drop_sound = 'sound/items/drop/leather.ogg'
	pickup_sound = 'sound/items/pickup/leather.ogg'

/obj/item/stack/material/chitin
	name = "chitin"
	desc = "The by-product of mob grinding."
	icon_state = "chitin"
	default_type = MAT_CHITIN
	no_variants = FALSE
	pass_color = TRUE
	strict_color_stacking = TRUE
	drop_sound = 'sound/items/drop/leather.ogg'
	pickup_sound = 'sound/items/pickup/leather.ogg'

/obj/item/stack/material/glass
	name = "glass"
	icon_state = "sheet-glass"
	default_type = "glass"
	no_variants = FALSE
	drop_sound = 'sound/items/drop/glass.ogg'
	pickup_sound = 'sound/items/pickup/glass.ogg'

/obj/item/stack/material/glass/reinforced
	name = "reinforced glass"
	icon_state = "sheet-rglass"
	default_type = "rglass"
	no_variants = FALSE

/obj/item/stack/material/glass/phoronglass
	name = "borosilicate glass"
	desc = "This sheet is special platinum-glass alloy designed to withstand large temperatures"
	singular_name = "borosilicate glass sheet"
	icon_state = "sheet-phoronglass"
	default_type = "borosilicate glass"
	no_variants = FALSE

/obj/item/stack/material/glass/phoronrglass
	name = "reinforced borosilicate glass"
	desc = "This sheet is special platinum-glass alloy designed to withstand large temperatures. It is reinforced with few rods."
	singular_name = "reinforced borosilicate glass sheet"
	icon_state = "sheet-phoronrglass"
	default_type = "reinforced borosilicate glass"
	no_variants = FALSE

/obj/item/stack/material/bananium
	name = "bananium"
	desc = "When smelted, Vaudium takes on a bright yellow hue and remains pliable, growing rigid when met with a forceful impact."
	icon_state = "sheet-clown"
	default_type = "bananium"
	no_variants = FALSE
	drop_sound = 'sound/items/drop/boots.ogg'
	pickup_sound = 'sound/items/pickup/boots.ogg'

/obj/item/stack/material/silencium
	name = "silencium"
	desc = "When compressed, Vaudium loses its color, gaining distinctive black bands and becoming intensely rigid."
	icon_state = "sheet-mime"
	default_type = "silencium"
	no_variants = FALSE
	drop_sound = 'sound/items/drop/boots.ogg'
	pickup_sound = 'sound/items/drop/boots.ogg'

/obj/item/stack/material/brass
	name = "brass"
	desc = "This stable alloy is often used in complex mechanisms due to its versatility, softness, and solid head conduction."
	icon_state = "sheet-brass"
	default_type = "brass"
	no_variants = FALSE
	drop_sound = 'sound/items/drop/boots.ogg'
	pickup_sound = 'sound/items/drop/boots.ogg'

/obj/item/stack/material/bone
	name = "bone"
	desc = "These dense calcium structures are a common support system for organic life."
	icon_state = "sheet-bone"
	default_type = "bone"
	no_variants = FALSE
	drop_sound = 'sound/items/drop/boots.ogg'
	pickup_sound = 'sound/items/drop/boots.ogg'

/obj/item/stack/material/copper
	name = "copper"
	desc = "This common metal remains a popular choice as an electrical and thermal conductor due to how easily it can be worked."
	icon_state = "sheet-copper"
	default_type = "copper"
	no_variants = FALSE
	drop_sound = 'sound/items/drop/boots.ogg'
	pickup_sound = 'sound/items/drop/boots.ogg'

//Moved out of beehive.dm in conjunction with the primary material.
/obj/item/stack/material/wax
	name = "wax"
	singular_name = "wax piece"
	desc = "Soft substance produced by bees. Used to make candles."
	icon_state = "sheet-rtransparent"
	apply_colour = 1
	default_type = "wax"
	no_variants = FALSE
	pass_color = TRUE
