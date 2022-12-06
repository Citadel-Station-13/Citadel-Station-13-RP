/datum/material/solid/gemstone
	abstract_type = /datum/material/solid/gemstone

	name = null
	legacy_flags = MATERIAL_UNMELTABLE
	cut_delay = 60
	color = COLOR_DIAMOND
	opacity = 0.4
	shard_type = SHARD_SHARD
	tableslam_noise = 'sound/effects/Glasshit.ogg'
	reflectiveness = MAT_VALUE_MIRRORED
	conductive = 0
	// ore_icon_overlay = "gems"
	default_solid_form = /obj/item/stack/material/gemstone
	sound_manipulate = 'sound/foley/pebblespickup1.ogg'
	sound_dropped = 'sound/foley/pebblesdrop1.ogg'

/datum/material/solid/gemstone/diamond
	name = "diamond"
	lore_text = "An extremely hard allotrope of carbon. Valued for its use in industrial tools."
	uid = "solid_gem_diamond"
	stack_type = /obj/item/stack/material/diamond
	legacy_flags = MATERIAL_UNMELTABLE
	cut_delay = 60
	color = "#00FFE1"
	opacity = 0.4
	conductivity = 1
	shard_type = SHARD_SHARD
	hardness = MAT_VALUE_VERY_HARD + 20
	stack_origin_tech = list(TECH_MATERIAL = 6)
