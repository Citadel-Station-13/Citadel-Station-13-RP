// Stacked resources. They use a material datum for a lot of inherited values.
// If you're adding something here, make sure to add it to fifty_spawner_mats.dm as well
/obj/item/stack/material
	icon = 'icons/obj/item/materials.dmi'
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

	pickup_sound = 'sound/foley/tooldrop3.ogg'
	drop_sound = 'sound/foley/tooldrop2.ogg'

	var/default_type = MAT_STEEL
	var/datum/material/material
	var/datum/material/reinf_material

	var/perunit = SHEET_MATERIAL_AMOUNT
	var/apply_colour //temp pending icon rewrite
	var/allow_window_autobuild = TRUE


/obj/item/stack/material/Initialize(mapload, new_amount, merge = TRUE)
	if(!default_type)
		default_type = /datum/material/solid/metal/steel
	material = GET_MATERIAL_REF(default_type)
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
		color = material.color

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

/obj/item/stack/material/update_icon_state()
	. = ..()
	color = material.color
	alpha = 100 + max(1, amount/25)*(material.opacity * 255)
	if(plural_icon_state || max_icon_state) // TEMP CHECK FOR NEW STACK SYSTEM
		update_state_from_amount()

/obj/item/stack/material/proc/update_state_from_amount()
	if(max_icon_state && amount == max_amount)
		icon_state = max_icon_state
	else if(plural_icon_state && amount > 2)
		icon_state = plural_icon_state
	else
		icon_state = base_icon_state

/obj/item/stack/material/ingot
	name = "ingots"
	singular_name = "ingot"
	plural_name = "ingots"
	icon_state = "ingot"
	plural_icon_state = "ingot-mult"
	max_icon_state = "ingot-max"
	// stack_merge_type = /obj/item/stack/material/ingot

/obj/item/stack/material/sheet
	name = "sheets"
	icon_state = "sheet"
	plural_icon_state = "sheet-mult"
	max_icon_state = "sheet-max"
	// stack_merge_type = /obj/item/stack/material/sheet

/obj/item/stack/material/panel
	name = "panels"
	icon_state = "sheet-plastic"
	plural_icon_state = "sheet-plastic-mult"
	max_icon_state = "sheet-plastic-max"
	singular_name = "panel"
	plural_name = "panels"
	// stack_merge_type = /obj/item/stack/material/panel

/obj/item/stack/material/skin
	name = "skin"
	icon_state = "skin"
	plural_icon_state = "skin-mult"
	max_icon_state = "skin-max"
	singular_name = "length"
	plural_name = "lengths"
	// stack_merge_type = /obj/item/stack/material/skin

/obj/item/stack/material/skin/pelt
	name = "pelts"
	singular_name = "pelt"
	plural_name = "pelts"
	// stack_merge_type = /obj/item/stack/material/skin/pelt

/obj/item/stack/material/skin/feathers
	name = "feathers"
	singular_name = "feather"
	plural_name = "feathers"
	// stack_merge_type = /obj/item/stack/material/skin/feathers

/obj/item/stack/material/bone
	name = "bones"
	icon_state = "bone"
	plural_icon_state = "bone-mult"
	max_icon_state = "bone-max"
	singular_name = "length"
	plural_name = "lengths"
	// stack_merge_type = /obj/item/stack/material/bone

/obj/item/stack/material/brick
	name = "bricks"
	singular_name = "brick"
	plural_name = "bricks"
	icon_state = "brick"
	plural_icon_state = "brick-mult"
	max_icon_state = "brick-max"
	// stack_merge_type = /obj/item/stack/material/brick

/obj/item/stack/material/bolt
	name = "bolts"
	icon_state = "sheet-cloth"
	singular_name = "bolt"
	plural_name = "bolts"
	// stack_merge_type = /obj/item/stack/material/bolt

/obj/item/stack/material/pane
	name = "panes"
	singular_name = "pane"
	plural_name = "panes"
	icon_state = "sheet-clear"
	plural_icon_state = "sheet-clear-mult"
	max_icon_state = "sheet-clear-max"
	// stack_merge_type = /obj/item/stack/material/pane

/obj/item/stack/material/pane/update_state_from_amount()
	if(material)
		icon_state = "sheet-glass-reinf"
		base_icon_state = icon_state
		plural_icon_state = "sheet-glass-reinf-mult"
		max_icon_state = "sheet-glass-reinf-max"
	else
		icon_state = "sheet-clear"
		base_icon_state = icon_state
		plural_icon_state = "sheet-clear-mult"
		max_icon_state = "sheet-clear-max"
	..()

/obj/item/stack/material/cardstock
	icon_state = "sheet-card"
	plural_icon_state = "sheet-card-mult"
	max_icon_state = "sheet-card-max"
	// stack_merge_type = /obj/item/stack/material/cardstock

/obj/item/stack/material/gemstone
	name = "gems"
	singular_name = "gem"
	plural_name = "gems"
	icon_state = "diamond"
	plural_icon_state = "diamond-mult"
	max_icon_state = "diamond-max"
	// stack_merge_type = /obj/item/stack/material/gemstone

/obj/item/stack/material/puck
	name = "pucks"
	singular_name = "puck"
	plural_name = "pucks"
	icon_state = "puck"
	plural_icon_state = "puck-mult"
	max_icon_state = "puck-max"
	// stack_merge_type = /obj/item/stack/material/puck

/obj/item/stack/material/aerogel
	name = "aerogel"
	singular_name = "gel block"
	plural_name = "gel blocks"
	icon_state = "puck"
	plural_icon_state = "puck-mult"
	max_icon_state = "puck-max"
	// atom_flags = ATOM_FLAG_NO_TEMP_CHANGE
	// stack_merge_type = /obj/item/stack/material/aerogel

/obj/item/stack/material/plank
	name = "planks"
	singular_name = "plank"
	plural_name = "planks"
	icon_state = "sheet-wood"
	plural_icon_state = "sheet-wood-mult"
	max_icon_state = "sheet-wood-max"
	// stack_merge_type = /obj/item/stack/material/plank

/obj/item/stack/material/segment
	name = "segments"
	singular_name = "segment"
	plural_name = "segments"
	icon_state = "sheet-mythril"
	// stack_merge_type = /obj/item/stack/material/segment

/obj/item/stack/material/reinforced
	icon_state = "sheet-reinf"
	item_state = "sheet-metal"
	plural_icon_state = "sheet-reinf-mult"
	max_icon_state = "sheet-reinf-max"
	// stack_merge_type = /obj/item/stack/material/reinforced
/obj/item/stack/material/shiny
	icon_state = "sheet-sheen"
	item_state = "sheet-shiny"
	plural_icon_state = "sheet-sheen-mult"
	max_icon_state = "sheet-sheen-max"
	// stack_merge_type = /obj/item/stack/material/shiny

/obj/item/stack/material/cubes
	name = "cube"
	desc = "Some featureless cubes."
	singular_name = "cube"
	plural_name = "cubes"
	icon_state = "cube"
	plural_icon_state = "cube-mult"
	max_icon_state = "cube-max"
	max_amount = 100
	attack_verb = list("cubed")
	// stack_merge_type = /obj/item/stack/material/cubes

/obj/item/stack/material/lump
	name = "lumps"
	singular_name = "lump"
	plural_name = "lumps"
	icon_state = "lump"
	plural_icon_state = "lump-mult"
	max_icon_state = "lump-max"
	// stack_merge_type = /obj/item/stack/material/lump

/obj/item/stack/material/slab
	name = "slabs"
	singular_name = "slab"
	plural_name = "slabs"
	icon_state = "puck"
	plural_icon_state = "puck-mult"
	max_icon_state = "puck-max"
	// stack_merge_type = /obj/item/stack/material/slab

/obj/item/stack/material/strut
	name = "struts"
	singular_name = "strut"
	plural_name = "struts"
	icon_state = "sheet-strut"
	plural_icon_state = "sheet-strut-mult"
	max_icon_state = "sheet-strut-max"
	// stack_merge_type = /obj/item/stack/material/strut

/obj/item/stack/material/strut/cyborg
	name = "metal strut synthesizer"
	desc = "A device that makes metal strut."
	gender = NEUTER
	matter = null
	uses_charge = 1
	charge_costs = list(500)
	material = /datum/material/solid/metal/steel
	// max_health = ITEM_HEALTH_NO_DAMAGE

/obj/item/stack/material/strut/get_recipes()
	return material.get_strut_recipes(material && material.type)
