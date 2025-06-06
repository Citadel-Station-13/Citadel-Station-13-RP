// Stacked resources. They use a material datum for a lot of inherited values.
// If you're adding something here, make sure to add it to fifty_spawner_mats.dm as well
/obj/item/stack/material
	abstract_type = /obj/item/stack/material
	damage_force = 5
	throw_force = 5
	w_class = WEIGHT_CLASS_NORMAL
	throw_speed = 3
	throw_range = 3
	max_amount = 50
	item_icons = list(
		SLOT_ID_LEFT_HAND = 'icons/mob/items/lefthand_material.dmi',
		SLOT_ID_RIGHT_HAND = 'icons/mob/items/righthand_material.dmi',
		)
	drop_sound = 'sound/items/drop/axe.ogg'
	pickup_sound = 'sound/items/pickup/axe.ogg'
	description_info = "Use in your hand to bring up the recipe menu.  If you have enough sheets, click on something on the list to build it."

	material_parts = MATERIAL_DEFAULT_DISABLED

	skip_legacy_icon_update = TRUE

	/// material - direct ref because stack
	var/datum/prototype/material/material

	var/perunit = SHEET_MATERIAL_AMOUNT
	var/apply_colour //temp pending icon rewrite
	var/allow_window_autobuild = TRUE

/obj/item/stack/material/Initialize(mapload, new_amount, merge = TRUE, material)
	// allow material override if needed
	if(!isnull(material))
		src.material = material

	// fetch material
	src.material = RSmaterials.fetch_or_defer(src.material)
	if(src.material == REPOSITORY_FETCH_DEFER)
		stack_trace("material deferred on a material stack. this isn't supported.")

	// ensure our icon is set properly
	if(src.material.icon && icon != src.material.icon)
		icon = src.material.icon

	//! LEGACY: turn it back on if our material doesn't have the proper shit set
	if(!src.material.icon_stack_count)
		skip_legacy_icon_update = FALSE
	//! END

	. = ..()

	pixel_x = rand(0,4)-4
	pixel_y = rand(0,4)-4

	stacktype_legacy = src.material.stack_type
	if(islist(src.material.stack_origin_tech))
		origin_tech = src.material.stack_origin_tech.Copy()

	if(apply_colour)
		color = src.material.icon_colour

	if(src.material.relative_conductivity < MATERIAL_CONDUCTIVITY_NOCONDUCT)
		atom_flags |= NOCONDUCT

	update_strings()

/obj/item/stack/material/get_materials(respect_multiplier)
	return list(material.id = (respect_multiplier? material_multiplier : 1) * SHEET_MATERIAL_AMOUNT)

/obj/item/stack/material/update_icon()
	if(material.icon_stack_count)
		icon_state = "stack-[min(ceil((amount / max_amount) * material.icon_stack_count), material.icon_stack_count)]"
	return ..()

/obj/item/stack/material/tgui_recipes()
	var/list/assembled = ..()
	for(var/datum/stack_recipe/recipe as anything in material.get_recipes())
		assembled[++assembled.len] = recipe.tgui_recipe_data()
	for(var/datum/stack_recipe/material/recipe as anything in SSmaterials.material_stack_recipes)
		assembled[++assembled.len] = recipe.tgui_recipe_data()
	return assembled

/obj/item/stack/material/stackcrafting_makes_sense()
	return TRUE

/obj/item/stack/material/can_craft_recipe(datum/stack_recipe/recipe)
	. = ..()
	if(.)
		return
	return (recipe in material.recipes) || (istype(recipe, /datum/stack_recipe/material) && (recipe in SSmaterials.material_stack_recipes))

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

/obj/item/stack/material/attack_self(mob/user, datum/event_args/actor/actor)
	if(!allow_window_autobuild || !material.build_windows(user, src))
		return ..()

/obj/item/stack/material/attackby(obj/item/I, mob/living/user, list/params, clickchain_flags, damage_multiplier)
	if(istype(I, /obj/item/stack/cable_coil))
		material.build_wired_product(user, I, src)
		return
	else if(istype(I, /obj/item/stack/rods))
		material.build_rod_product(user, I, src)
		return
	return ..()

// todo: we need a better way of doing this, holy shit

/obj/item/stack/material/iron
	name = "iron"
	icon_state = "sheet-silver"
	material = /datum/prototype/material/iron
	apply_colour = 1
	no_variants = FALSE

/obj/item/stack/material/lead
	name = "lead"
	icon_state = "sheet-adamantine"
	material = /datum/prototype/material/lead
	apply_colour = 1
	no_variants = FALSE

/obj/item/stack/material/sandstone
	name = "sandstone brick"
	icon_state = "sheet-sandstone"
	material = /datum/prototype/material/sandstone
	no_variants = FALSE
	drop_sound = 'sound/items/drop/boots.ogg'
	pickup_sound = 'sound/items/pickup/boots.ogg'

/obj/item/stack/material/marble
	name = "marble brick"
	icon_state = "sheet-marble"
	material = /datum/prototype/material/marble
	no_variants = FALSE
	drop_sound = 'sound/items/drop/boots.ogg'
	pickup_sound = 'sound/items/pickup/boots.ogg'

/obj/item/stack/material/diamond
	name = "diamond"
	icon_state = "sheet-diamond"
	material = /datum/prototype/material/diamond
	drop_sound = 'sound/items/drop/glass.ogg'
	pickup_sound = 'sound/items/pickup/glass.ogg'

/obj/item/stack/material/uranium
	name = "uranium"
	icon_state = "sheet-uranium"
	material = /datum/prototype/material/uranium
	no_variants = FALSE

/obj/item/stack/material/phoron
	name = "solid phoron"
	icon_state = "sheet-phoron"
	material = /datum/prototype/material/phoron
	no_variants = FALSE

/obj/item/stack/material/plastic
	name = "plastic"
	icon_state = "sheet-plastic"
	material = /datum/prototype/material/plastic
	no_variants = FALSE

/obj/item/stack/material/gold
	name = "gold"
	icon_state = "sheet-gold"
	material = /datum/prototype/material/gold
	no_variants = FALSE

/obj/item/stack/material/silver
	name = "silver"
	icon_state = "sheet-silver"
	material = /datum/prototype/material/silver
	no_variants = FALSE

//Valuable resource, cargo can sell it.
/obj/item/stack/material/platinum
	name = "platinum"
	icon_state = "sheet-adamantine"
	material = /datum/prototype/material/platinum
	no_variants = FALSE

//Extremely valuable to Research.
/obj/item/stack/material/mhydrogen
	name = "metallic hydrogen"
	icon_state = "sheet-mythril"
	material = /datum/prototype/material/hydrogen/mhydrogen
	no_variants = FALSE

//Fuel for MRSPACMAN generator.
/obj/item/stack/material/tritium
	name = "tritium"
	icon_state = "sheet-silver"
	material = /datum/prototype/material/hydrogen/tritium
	apply_colour = 1
	no_variants = FALSE

/obj/item/stack/material/osmium
	name = "osmium"
	icon_state = "sheet-silver"
	material = /datum/prototype/material/osmium
	apply_colour = 1
	no_variants = FALSE

//R-UST port
// Fusion fuel.
/obj/item/stack/material/deuterium
	name = "deuterium"
	icon_state = "sheet-silver"
	material = /datum/prototype/material/hydrogen/deuterium
	apply_colour = 1
	no_variants = FALSE

/obj/item/stack/material/steel/hull
	name = MAT_STEELHULL
	material = /datum/prototype/material/steel/hull

/obj/item/stack/material/plasteel
	name = "plasteel"
	icon_state = "sheet-plasteel"
	material = /datum/prototype/material/plasteel
	no_variants = FALSE

/obj/item/stack/material/plasteel/hull
	name = MAT_PLASTEELHULL
	material = /datum/prototype/material/plasteel/hull

/obj/item/stack/material/durasteel
	name = "durasteel"
	icon_state = "sheet-durasteel"
	item_state = "sheet-metal"
	material = /datum/prototype/material/durasteel
	no_variants = FALSE

/obj/item/stack/material/durasteel/hull
	name = MAT_DURASTEELHULL

/obj/item/stack/material/titanium
	name = MAT_TITANIUM
	icon_state = "sheet-silver"
	item_state = "sheet-silver"
	material = /datum/prototype/material/plasteel/titanium
	no_variants = FALSE

/obj/item/stack/material/titanium/hull
	name = MAT_TITANIUMHULL
	material = /datum/prototype/material/plasteel/titanium/hull

// Particle Smasher and Exotic material.
/obj/item/stack/material/verdantium
	name = MAT_VERDANTIUM
	icon_state = "sheet-wavy"
	item_state = "mhydrogen"
	material = /datum/prototype/material/verdantium
	no_variants = FALSE
	apply_colour = TRUE

/obj/item/stack/material/morphium
	name = MAT_MORPHIUM
	icon_state = "sheet-wavy"
	item_state = "mhydrogen"
	material = /datum/prototype/material/morphium
	no_variants = FALSE
	apply_colour = TRUE

/obj/item/stack/material/morphium/hull
	name = MAT_MORPHIUMHULL
	material = /datum/prototype/material/morphium/hull

/obj/item/stack/material/valhollide
	name = MAT_VALHOLLIDE
	icon_state = "sheet-gem"
	item_state = "diamond"
	material = /datum/prototype/material/valhollide
	no_variants = FALSE
	apply_colour = TRUE

// Forged in the equivalent of Hell, one piece at a time.
/obj/item/stack/material/supermatter
	name = MAT_SUPERMATTER
	icon_state = "sheet-super"
	item_state = "diamond"
	material = /datum/prototype/material/supermatter
	no_variants = FALSE
	apply_colour = TRUE

/obj/item/stack/material/supermatter/proc/update_mass()	// Due to how dangerous they can be, the item will get heavier and larger the more are in the stack.
	set_weight_class(min(5, round(amount / 10) + 1))
	throw_range = round(amount / 7) + 1

/obj/item/stack/material/supermatter/use(var/used)
	. = ..()
	update_mass()
	return

/obj/item/stack/material/supermatter/attack_hand(mob/user, datum/event_args/actor/clickchain/e_args)
	. = ..()

	update_mass()
	radiation_pulse(src, RAD_INTENSITY_MAT_SUPERMATTER_PICKUP_PER_SHEET(amount))
	var/mob/living/M = user
	if(!istype(M))
		return

	var/burn_user = TRUE
	if(istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		var/obj/item/clothing/gloves/G = H.inventory.get_slot_single(/datum/inventory_slot/inventory/gloves::id)
		if(istype(G) && ((G.clothing_flags & CLOTHING_THICK_MATERIAL && prob(70)) || istype(G, /obj/item/clothing/gloves/gauntlets)))
			burn_user = FALSE

		if(burn_user)
			H.visible_message("<span class='danger'>\The [src] flashes as it scorches [H]'s hands!</span>")
			H.apply_damage(amount / 2 + 5, DAMAGE_TYPE_BURN, "r_hand", used_weapon="Supermatter Chunk")
			H.apply_damage(amount / 2 + 5, DAMAGE_TYPE_BURN, "l_hand", used_weapon="Supermatter Chunk")
			H.drop_item_to_ground(src)
			return

	if(istype(user, /mob/living/silicon/robot))
		burn_user = FALSE

	if(burn_user)
		M.apply_damage(amount, DAMAGE_TYPE_BURN, null, used_weapon="Supermatter Chunk")

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
	material = /datum/prototype/material/wood_plank
	strict_color_stacking = TRUE
	drop_sound = 'sound/items/drop/wooden.ogg'
	pickup_sound = 'sound/items/pickup/wooden.ogg'

/obj/item/stack/material/wood/sif
	name = "alien wooden plank"
	color = "#0099cc"
	material = /datum/prototype/material/wood_plank/sif

/obj/item/stack/material/wood/hard
	name = "hardwood plank"
	color = "#42291a"
	material = /datum/prototype/material/wood_plank/hardwood
	description_info = "Rich, lustrous hardwood, imported from offworld at moderate expense. Mostly used for luxurious furniture, and not very good for weapons or other structures."

/obj/item/stack/material/wood/ironwood
	name = "ironwood plank"
	color = "#666666"
	material = /datum/prototype/material/wood_plank/ironwood
	description_info = "A especially dense wood said to be stronger than iron. Grown from ironwood trees native to the Alraune homeworld of Loam."
	catalogue_delay = 2 SECONDS
	catalogue_data = list(/datum/category_item/catalogue/flora/ironwood)

/obj/item/stack/material/log
	name = "log"
	icon_state = "sheet-log"
	material = /datum/prototype/material/wood_log
	no_variants = FALSE
	color = "#824B28"
	max_amount = 25
	w_class = WEIGHT_CLASS_HUGE
	description_info = "Use inhand to craft things, or use a sharp and edged object on this to convert it into two wooden planks."
	var/plank_type = /obj/item/stack/material/wood
	drop_sound = 'sound/items/drop/wooden.ogg'
	pickup_sound = 'sound/items/pickup/wooden.ogg'

/obj/item/stack/material/log/sif
	name = "alien log"
	material = /datum/prototype/material/wood_log/sif
	color = "#0099cc"
	plank_type = /obj/item/stack/material/wood/sif

/obj/item/stack/material/log/hard
	name = "hardwood log"
	material = /datum/prototype/material/wood_log/hard
	color = "#6f432a"
	plank_type = /obj/item/stack/material/wood/hard

/obj/item/stack/material/log/attackby(obj/item/I, mob/living/user, list/params, clickchain_flags, damage_multiplier)
	if(!istype(I) || I.damage_force <= 0)
		return ..()
	if(CHECK_MULTIPLE_BITFIELDS(I.damage_mode, DAMAGE_MODE_EDGE | DAMAGE_MODE_SHARP))
		var/time = (3 SECONDS / max(I.damage_force / 10, 1)) * I.tool_speed
		user.setClickCooldownLegacy(time)
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

/obj/item/stack/material/log/ironwood
	material = /datum/prototype/material/wood_log/ironwood
	color = "#666666"
	plank_type = /obj/item/stack/material/wood/ironwood
	description_info = "Use inhand to craft things. You will need something very sharp to cut it into planks though"
	catalogue_delay = 2 SECONDS
	catalogue_data = list(/datum/category_item/catalogue/flora/ironwood)


/obj/item/stack/material/log/ironwood/attackby(obj/item/I, mob/living/user, list/params, clickchain_flags, damage_multiplier)
	if(!istype(I) || I.damage_force <= 20) //You will need at least PLASTEEL Tools to cut this.
		return ..()
	if(CHECK_MULTIPLE_BITFIELDS(I.damage_mode, DAMAGE_MODE_EDGE | DAMAGE_MODE_SHARP))
		var/time = (3 SECONDS / max(I.damage_force / 10, 1)) * I.tool_speed
		user.setClickCooldownLegacy(time)
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
		to_chat(user, "<span class='notice'>You will need a stronger cut to cut this wood into planks.</span>")
		return ..()

/obj/item/stack/material/cloth
	name = "cloth"
	icon_state = "sheet-cloth"
	material = /datum/prototype/material/cloth
	no_variants = FALSE
	pass_color = TRUE
	strict_color_stacking = TRUE
	drop_sound = 'sound/items/drop/cloth.ogg'
	pickup_sound = 'sound/items/pickup/cloth.ogg'

/obj/item/stack/material/resin
	name = "resin"
	icon_state = "sheet-resin"
	material = /datum/prototype/material/resin
	no_variants = TRUE
	apply_colour = TRUE
	pass_color = TRUE
	strict_color_stacking = TRUE

/obj/item/stack/material/cardboard
	name = "cardboard"
	icon_state = "sheet-card"
	material = /datum/prototype/material/cardboard
	no_variants = FALSE
	pass_color = TRUE
	strict_color_stacking = TRUE
	drop_sound = 'sound/items/drop/cardboardbox.ogg'
	pickup_sound = 'sound/items/pickup/cardboardbox.ogg'

/obj/item/stack/material/snow
	name = "snow"
	desc = "The temptation to build a snowman rises."
	icon_state = "sheet-snow"
	material = /datum/prototype/material/snow

/obj/item/stack/material/snowbrick
	name = "snow brick"
	desc = "For all of your igloo building needs."
	icon_state = "sheet-snowbrick"
	material = /datum/prototype/material/snowbrick

/obj/item/stack/material/leather
	name = "leather"
	desc = "The by-product of mob grinding."
	icon_state = "sheet-leather"
	material = /datum/prototype/material/leather
	no_variants = FALSE
	pass_color = TRUE
	strict_color_stacking = TRUE
	drop_sound = 'sound/items/drop/leather.ogg'
	pickup_sound = 'sound/items/pickup/leather.ogg'

/obj/item/stack/material/chitin
	name = "chitin plates"
	desc = "Sheets of hardened chitin, usually harvested from insectile beasts."
	singular_name = "chitin plate"
	icon_state = "chitin"
	material = /datum/prototype/material/chitin
	no_variants = FALSE
	pass_color = TRUE
	strict_color_stacking = TRUE
	drop_sound = 'sound/items/drop/leather.ogg'
	pickup_sound = 'sound/items/pickup/leather.ogg'

/obj/item/stack/material/glass
	name = "glass"
	icon_state = "sheet-glass"
	material = /datum/prototype/material/glass
	no_variants = FALSE
	drop_sound = 'sound/items/drop/glass.ogg'
	pickup_sound = 'sound/items/pickup/glass.ogg'

/obj/item/stack/material/glass/reinforced
	name = "reinforced glass"
	icon_state = "sheet-rglass"
	material = /datum/prototype/material/glass/reinforced
	no_variants = FALSE

/obj/item/stack/material/glass/phoronglass
	name = "borosilicate glass"
	desc = "This sheet is special platinum-glass alloy designed to withstand large temperatures"
	singular_name = "borosilicate glass sheet"
	icon_state = "sheet-phoronglass"
	material = /datum/prototype/material/glass/phoron
	no_variants = FALSE

/obj/item/stack/material/glass/phoronrglass
	name = "reinforced borosilicate glass"
	desc = "This sheet is special platinum-glass alloy designed to withstand large temperatures. It is reinforced with few rods."
	singular_name = "reinforced borosilicate glass sheet"
	icon_state = "sheet-phoronrglass"
	material = /datum/prototype/material/glass/phoron/reinforced
	no_variants = FALSE

/obj/item/stack/material/bananium
	name = MAT_BANANIUM
	desc = "When smelted, Vaudium takes on a bright yellow hue and remains pliable, growing rigid when met with a forceful impact."
	icon_state = "sheet-clown"
	material = /datum/prototype/material/bananium
	no_variants = FALSE
	drop_sound = 'sound/items/drop/boots.ogg'
	pickup_sound = 'sound/items/pickup/boots.ogg'

/obj/item/stack/material/silencium
	name = MAT_SILENCIUM
	desc = "When compressed, Vaudium loses its color, gaining distinctive black bands and becoming intensely rigid."
	icon_state = "sheet-mime"
	material = /datum/prototype/material/silencium
	no_variants = FALSE
	drop_sound = 'sound/items/drop/boots.ogg'
	pickup_sound = 'sound/items/drop/boots.ogg'

/obj/item/stack/material/brass
	name = "brass"
	desc = "This stable alloy is often used in complex mechanisms due to its versatility, softness, and solid head conduction."
	icon_state = "sheet-brass"
	material = /datum/prototype/material/brass
	no_variants = FALSE
	drop_sound = 'sound/items/drop/boots.ogg'
	pickup_sound = 'sound/items/drop/boots.ogg'

/obj/item/stack/material/bone
	name = "bone"
	desc = "These dense calcium structures are a common support system for organic life."
	icon_state = "sheet-bone"
	material = /datum/prototype/material/bone
	no_variants = FALSE
	drop_sound = 'sound/items/drop/boots.ogg'
	pickup_sound = 'sound/items/drop/boots.ogg'

/obj/item/stack/material/copper
	name = "copper"
	desc = "This common metal remains a popular choice as an electrical and thermal conductor due to how easily it can be worked."
	icon_state = "sheet-copper"
	material = /datum/prototype/material/copper
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
	material = /datum/prototype/material/wax
	no_variants = FALSE
	pass_color = TRUE

/obj/item/stack/material/algae
	name = "algae sheet"
	icon_state = "sheet-uranium"
	color = "#557722"
	material = /datum/prototype/material/algae

/obj/item/stack/material/algae/ten
	amount = 10

/obj/item/stack/material/carbon
	name = "carbon sheet"
	icon_state = "sheet-metal"
	color = "#303030"
	material = /datum/prototype/material/carbon
