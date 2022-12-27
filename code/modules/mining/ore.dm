/**
 * ores are how miners acquire materials
 *
 * they in reality just hold one or multiple kinds of materials
 */
/datum/ore
	//! metadata
	/// abstract type
	var/abstract_type = /datum/ore
	/// our id
	var/id
	/// ore typepath
	var/ore_path = /obj/item/ore
	/// custom ores require this set - disabling will stop the system from trying to override icons/states on every created ore and other stuff.
	var/custom_ore = FALSE
	/// ore type
	var/ore_type = ORE_TYPE_UNKNOWN
	/// flags
	var/ore_flags = NONE

	//! names
	/// what players see as our name
	var/display_name = "Unknown Ore"
	/// ore item name
	var/ore_name = "ore"
	/// ore item desc, if any
	var/ore_desc = "A piece of ore."
	/// ore category name
	var/display_category = "unknowon materia"

	//! visuals
	/// iconfile for ores
	var/ore_icon = 'icons/modules/mining/ore_item.dmi'
	/// iconstate for ores
	var/ore_state = ""
	/// mineral rock iconfile
	var/rock_icon = 'icons/modules/mining/ore_rock.dmi'
	/// mineral rock icon state
	var/rock_state = ""
	/// cached image for sensors/overlays
	var/image/sensor_image

	//! smelting
	/// default ratio: 0.2 = 5 for 1 product
	var/product_ratio = 1
	/// material id of what this smelts to
	var/smelts_to
	/// smelt ratio override
	var/smelt_ratio
	/// material id of what this compresses to
	var/compresses_to
	/// compress ratio override
	var/compress_ratio
	/// material id of what this pulverizes to
	var/pulverizes_to
	/// pulverize ratio override
	var/pulverize_ratio
	/// counts as what material for alloying?
	var/alloys_as
	/// alloy ratio override
	var/alloy_ratio

	//! generation
	/// one-dimensional relative rarity where 0 is normal
	var/relative_rarity = 0
	#warn fin

	//! misc
	/// value of ore for mining points
	var/point_value = 1

/datum/ore/proc/sensor_image()
	if(!sensor_image)
		sensor_image = compile_sensor_image()
	return sensor_image

/datum/ore/proc/compile_sensor_image()
	RETURN_TYPE(/image)
	var/image/generated = image(rock_icon, icon_state = rock_state)
	return generated

/**
 * creates a piece of ore at a location
 */
/datum/ore/proc/create_ore(atom/at, amount = 1)
	for(var/i in 1 to min(100, amount))
		var/obj/item/ore/O = new(at)
		if(!custom_ore)
			continue
		O.icon = ore_icon
		O.icon_state = ore_state
		O.ore_id = id
		O.name = ore_name
		O.desc = ore_desc

/datum/ore/custom
	custom_ore = TRUE

/datum/ore/uranium
	id = ORE_ID_URANIUM
	ore_path = /obj/item/ore/uranium
	ore_type = ORE_TYPE_ROCK
	display_name = "uranium"
	ore_name = "pitchblende"
	ore_state = "uranium"
	rock_state = "uranium"
	display_category = "radioactive isotopes"
	smelts_to = /datum/material/uranium

	#warn generation etc

/datum/ore/hematite

	display_category = "common metals"

/datum/ore/coal

	display_category = "sedimentary rock"

/datum/ore/sand

	display_category = "silicates"
	point_value = 0 // n:omegalul:.

/datum/ore/phoron

	display_category = "exotic matter"

/datum/ore/silver

	display_category = "precious metals"

/datum/ore/gold

	display_category = "precious metals"

/datum/ore/diamond

	display_category = "exotic matter"

/datum/ore/platinum

	display_category = "precious metals"

/datum/ore/hydrogen

	display_category = "exotic matter"

/datum/ore/verdantium

	display_category = "exotic matter"

/datum/ore/marble

	display_category = "metamorphic rock"

/datum/ore/lead

	display_category = "common metals"

/datum/ore/vaudium

	display_category = "anomalous matter"

/datum/ore/copper

	display_category = "common metals"

/**
 * the actual ore items
 *
 * these should be typepathed for speed and memory for non-custom ores.
 */
/obj/item/ore
	name = "small rock"
	icon = 'icons/obj/mining.dmi'
	icon_state = "ore2"
	w_class = ITEMSIZE_SMALL
	rad_flags = RAD_BLOCK_CONTENTS | RAD_NO_CONTAMINATE // uh let's like, not? it'd be funny but fields usually have like 400 pieces of ore in just a few tiles.


	/// our ore id
	var/ore_id
	var/datum/geosampledf/geologic_data

/obj/item/ore/legacy_ex_act(severity)
	return

/obj/item/ore/uranium
	name = "pitchblende"
	icon_state = "ore_uranium"
	origin_tech = list(TECH_MATERIAL = 5)
	material = "uranium"

/obj/item/ore/iron
	name = "hematite"
	icon_state = "ore_iron"
	origin_tech = list(TECH_MATERIAL = 1)
	material = "hematite"

/obj/item/ore/coal
	name = "raw carbon"
	icon_state = "ore_coal"
	origin_tech = list(TECH_MATERIAL = 1)
	material = "carbon"

/obj/item/ore/marble
	name = "recrystallized carbonate"
	icon_state = "ore_marble"
	origin_tech = list(TECH_MATERIAL = 1)
	material = "marble"

/obj/item/ore/sand
	name = "sand"
	icon_state = "ore_glass"
	origin_tech = list(TECH_MATERIAL = 1)
	material = "sand"
	slot_flags = SLOT_HOLSTER

// POCKET SAND!
/obj/item/ore/sand/throw_impact(atom/hit_atom)
	..()
	var/mob/living/carbon/human/H = hit_atom
	if(istype(H) && H.has_eyes() && prob(85))
		to_chat(H, "<span class='danger'>Some of \the [src] gets in your eyes!</span>")
		H.Blind(5)
		H.eye_blurry += 10
		spawn(1)
			if(istype(loc, /turf/)) qdel(src)

/obj/item/ore/phoron
	name = "phoron crystals"
	icon_state = "ore_phoron"
	origin_tech = list(TECH_MATERIAL = 2)
	material = "phoron"

/obj/item/ore/copper
	name = "native copper ore"
	icon_state = "ore_copper"
	origin_tech = list(TECH_MATERIAL = 2)
	material = "copper"
/obj/item/ore/silver
	name = "native silver ore"
	icon_state = "ore_silver"
	origin_tech = list(TECH_MATERIAL = 3)
	material = "silver"

/obj/item/ore/gold
	name = "native gold ore"
	icon_state = "ore_gold"
	origin_tech = list(TECH_MATERIAL = 4)
	material = "gold"

/obj/item/ore/diamond
	name = "diamonds"
	icon_state = "ore_diamond"
	origin_tech = list(TECH_MATERIAL = 6)
	material = "diamond"

/obj/item/ore/osmium
	name = "raw platinum"
	icon_state = "ore_platinum"
	material = "platinum"

/obj/item/ore/hydrogen
	name = "raw hydrogen"
	icon_state = "ore_hydrogen"
	material = "mhydrogen"

/obj/item/ore/verdantium
	name = "verdantite dust"
	icon_state = "ore_verdantium"
	material = MAT_VERDANTIUM
	origin_tech = list(TECH_MATERIAL = 7)

// POCKET ... Crystal dust.
/obj/item/ore/verdantium/throw_impact(atom/hit_atom)
	..()
	var/mob/living/carbon/human/H = hit_atom
	if(istype(H) && H.has_eyes() && prob(85))
		to_chat(H, "<span class='danger'>Some of \the [src] gets in your eyes!</span>")
		H.Blind(10)
		H.eye_blurry += 15
		spawn(1)
			if(istype(loc, /turf/)) qdel(src)

/obj/item/ore/lead
	name = "lead glance"
	icon_state = "ore_lead"
	material = MAT_LEAD
	origin_tech = list(TECH_MATERIAL = 3)

/obj/item/ore/slag
	name = "Slag"
	desc = "Someone screwed up..."
	icon_state = "slag"
	material = null

/obj/item/ore/Initialize(mapload)
	. = ..()
	pixel_x = rand(0,16)-8
	pixel_y = rand(0,8)-8

/obj/item/ore/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/core_sampler))
		var/obj/item/core_sampler/C = W
		C.sample_item(src, user)
	else
		return ..()

//Vaudium
/obj/item/ore/vaudium
	name = "raw vaudium"
	icon_state = "ore_vaudium"
	material = MAT_VAUDIUM
	origin_tech = list(TECH_MATERIAL = 7)
