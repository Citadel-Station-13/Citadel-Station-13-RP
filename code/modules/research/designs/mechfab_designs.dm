/datum/design/science/mechfab
	lathe_type = LATHE_TYPE_MECHA
	category = list("Other")
	req_tech = list(TECH_MATERIAL = 1)

/datum/design/science/mechfab/ripley
	category = list("Ripley")

/datum/design/science/mechfab/ripley/chassis
	name = "Ripley Chassis"
	identifier = "ripley_chassis"
	build_path = /obj/item/mecha_parts/chassis/ripley
	work = (10 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials = list(MAT_STEEL = 15000)

/datum/design/science/mechfab/ripley/chassis/firefighter
	name = "Firefigher Chassis"
	identifier = "firefighter_chassis"
	build_path = /obj/item/mecha_parts/chassis/firefighter

/datum/design/science/mechfab/ripley/chassis/geiger
	name = "Geiger Chassis"
	identifier = "geiger_chassis"
	build_path = /obj/item/mecha_parts/chassis/geiger

/datum/design/science/mechfab/ripley/torso
	name = "Ripley Torso"
	identifier = "ripley_torso"
	build_path = /obj/item/mecha_parts/part/ripley_torso
	work = (20 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials = list(MAT_STEEL = 30000, MAT_GLASS = 11250)

/datum/design/science/mechfab/ripley/torso/geiger
	name = "Geiger Torso"
	identifier = "geiger_torso"
	build_path = /obj/item/mecha_parts/part/geiger_torso
	work = (20 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials = list(MAT_STEEL = 25000, MAT_GLASS = 10000)

/datum/design/science/mechfab/ripley/left_arm
	name = "Ripley Left Arm"
	identifier = "ripley_left_arm"
	build_path = /obj/item/mecha_parts/part/ripley_left_arm
	work = (15 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials = list(MAT_STEEL = 18750)

/datum/design/science/mechfab/ripley/right_arm
	name = "Ripley Right Arm"
	identifier = "ripley_right_arm"
	build_path = /obj/item/mecha_parts/part/ripley_right_arm
	work = (15 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials = list(MAT_STEEL = 18750)

/datum/design/science/mechfab/ripley/left_leg
	name = "Ripley Left Leg"
	identifier = "ripley_left_leg"
	build_path = /obj/item/mecha_parts/part/ripley_left_leg
	work = (15 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials = list(MAT_STEEL = 22500)

/datum/design/science/mechfab/ripley/right_leg
	name = "Ripley Right Leg"
	identifier = "ripley_right_leg"
	build_path = /obj/item/mecha_parts/part/ripley_right_leg
	work = (15 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials = list(MAT_STEEL = 22500)

/datum/design/science/mechfab/odysseus
	category = list("Odysseus")

/datum/design/science/mechfab/odysseus/chassis
	name = "Odysseus Chassis"
	identifier = "odysseus_chassis"
	build_path = /obj/item/mecha_parts/chassis/odysseus
	work = (10 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials = list(MAT_STEEL = 15000)

/datum/design/science/mechfab/odysseus/torso
	name = "Odysseus Torso"
	identifier = "odysseus_torso"
	build_path = /obj/item/mecha_parts/part/odysseus_torso
	work = (18 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials = list(MAT_STEEL = 18750)

/datum/design/science/mechfab/odysseus/head
	name = "Odysseus Head"
	identifier = "odysseus_head"
	build_path = /obj/item/mecha_parts/part/odysseus_head
	work = (10 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials = list(MAT_STEEL = 1500, MAT_GLASS = 7500)

/datum/design/science/mechfab/odysseus/left_arm
	name = "Odysseus Left Arm"
	identifier = "odysseus_left_arm"
	build_path = /obj/item/mecha_parts/part/odysseus_left_arm
	work = (12 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials = list(MAT_STEEL = 7500)

/datum/design/science/mechfab/odysseus/right_arm
	name = "Odysseus Right Arm"
	identifier = "odysseus_right_arm"
	build_path = /obj/item/mecha_parts/part/odysseus_right_arm
	work = (12 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials = list(MAT_STEEL = 7500)

/datum/design/science/mechfab/odysseus/left_leg
	name = "Odysseus Left Leg"
	identifier = "odysseus_left_leg"
	build_path = /obj/item/mecha_parts/part/odysseus_left_leg
	work = (13 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials = list(MAT_STEEL = 11250)

/datum/design/science/mechfab/odysseus/right_leg
	name = "Odysseus Right Leg"
	identifier = "odysseus_right_leg"
	build_path = /obj/item/mecha_parts/part/odysseus_right_leg
	work = (13 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials = list(MAT_STEEL = 11250)

/datum/design/science/mechfab/gygax
	category = list("Gygax")

/datum/design/science/mechfab/gygax/chassis/serenity
	name = "Serenity Chassis"
	identifier = "serenity_chassis"
	build_path = /obj/item/mecha_parts/chassis/serenity
	materials = list(MAT_STEEL = 18750, MAT_PHORON = 4000)

/datum/design/science/mechfab/gygax/chassis
	name = "Gygax Chassis"
	identifier = "gygax_chassis"
	build_path = /obj/item/mecha_parts/chassis/gygax
	work = (10 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials = list(MAT_STEEL = 18750)

/datum/design/science/mechfab/gygax/torso
	name = "Gygax Torso"
	identifier = "gygax_torso"
	build_path = /obj/item/mecha_parts/part/gygax_torso
	work = (30 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials = list(MAT_STEEL = 37500, MAT_GLASS = 15000)

/datum/design/science/mechfab/gygax/head
	name = "Gygax Head"
	identifier = "gygax_head"
	build_path = /obj/item/mecha_parts/part/gygax_head
	work = (20 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials = list(MAT_STEEL = 15000, MAT_GLASS = 7500)

/datum/design/science/mechfab/gygax/left_arm
	name = "Gygax Left Arm"
	identifier = "gygax_left_arm"
	build_path = /obj/item/mecha_parts/part/gygax_left_arm
	work = (20 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials = list(MAT_STEEL = 22500)

/datum/design/science/mechfab/gygax/right_arm
	name = "Gygax Right Arm"
	identifier = "gygax_right_arm"
	build_path = /obj/item/mecha_parts/part/gygax_right_arm
	work = (20 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials = list(MAT_STEEL = 22500)

/datum/design/science/mechfab/gygax/left_leg
	name = "Gygax Left Leg"
	identifier = "gygax_left_leg"
	build_path = /obj/item/mecha_parts/part/gygax_left_leg
	work = (20 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials = list(MAT_STEEL = 26250)

/datum/design/science/mechfab/gygax/right_leg
	name = "Gygax Right Leg"
	identifier = "gygax_right_leg"
	build_path = /obj/item/mecha_parts/part/gygax_right_leg
	work = (20 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials = list(MAT_STEEL = 26250)

/datum/design/science/mechfab/gygax/armour
	name = "Gygax Armour Plates"
	identifier = "gygax_armour"
	build_path = /obj/item/mecha_parts/part/gygax_armour
	work = (60 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials = list(MAT_STEEL = 37500, MAT_DIAMOND = 7500)

/datum/design/science/mechfab/durand
	category = list("Durand")

/datum/design/science/mechfab/durand/chassis
	name = "Durand Chassis"
	identifier = "durand_chassis"
	build_path = /obj/item/mecha_parts/chassis/durand
	work = (10 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials = list(MAT_STEEL = 18750)

/datum/design/science/mechfab/durand/torso
	name = "Durand Torso"
	identifier = "durand_torso"
	build_path = /obj/item/mecha_parts/part/durand_torso
	work = (30 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials = list(MAT_STEEL = 41250, MAT_GLASS = 15000, MAT_SILVER = 7500)

/datum/design/science/mechfab/durand/head
	name = "Durand Head"
	identifier = "durand_head"
	build_path = /obj/item/mecha_parts/part/durand_head
	work = (20 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials = list(MAT_STEEL = 18750, MAT_GLASS = 7500, MAT_SILVER = 2250)

/datum/design/science/mechfab/durand/left_arm
	name = "Durand Left Arm"
	identifier = "durand_left_arm"
	build_path = /obj/item/mecha_parts/part/durand_left_arm
	work = (20 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials = list(MAT_STEEL = 26250, MAT_SILVER = 2250)

/datum/design/science/mechfab/durand/right_arm
	name = "Durand Right Arm"
	identifier = "durand_right_arm"
	build_path = /obj/item/mecha_parts/part/durand_right_arm
	work = (20 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials = list(MAT_STEEL = 26250, MAT_SILVER = 2250)

/datum/design/science/mechfab/durand/left_leg
	name = "Durand Left Leg"
	identifier = "durand_left_leg"
	build_path = /obj/item/mecha_parts/part/durand_left_leg
	work = (20 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials = list(MAT_STEEL = 30000, MAT_SILVER = 2250)

/datum/design/science/mechfab/durand/right_leg
	name = "Durand Right Leg"
	identifier = "durand_right_leg"
	build_path = /obj/item/mecha_parts/part/durand_right_leg
	work = (20 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials = list(MAT_STEEL = 30000, MAT_SILVER = 2250)

/datum/design/science/mechfab/durand/armour
	name = "Durand Armour Plates"
	identifier = "durand_armour"
	build_path = /obj/item/mecha_parts/part/durand_armour
	work = (60 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials = list(MAT_STEEL = 37500, MAT_URANIUM = 7500)

/datum/design/science/mechfab/janus
	category = list("Janus")
	req_tech = list(TECH_MATERIAL = 7, TECH_BLUESPACE = 5, TECH_MAGNET = 6, TECH_PHORON = 3, TECH_ARCANE = 1, TECH_PRECURSOR = 2)

/datum/design/science/mechfab/janus/chassis
	name = "Janus Chassis"
	identifier = "janus_chassis"
	build_path = /obj/item/mecha_parts/chassis/janus
	work = (100 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials = list(MAT_DURASTEEL = 19000, MAT_MORPHIUM = 10500, MAT_PLASTEEL = 5500, MAT_LEAD = 2500)
	req_tech = list(TECH_MATERIAL = 7, TECH_BLUESPACE = 5, TECH_MAGNET = 6, TECH_PHORON = 3, TECH_ARCANE = 1, TECH_PRECURSOR = 3)

/datum/design/science/mechfab/janus/torso
	name = "Imperion Torso"
	identifier = "janus_torso"
	build_path = /obj/item/mecha_parts/part/janus_torso
	work = (300 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials = list(MAT_STEEL = 30000, MAT_DURASTEEL = 8000, MAT_MORPHIUM = 10000, MAT_GOLD = 5000, MAT_VERDANTIUM = 5000)

/datum/design/science/mechfab/janus/head
	name = "Imperion Head"
	identifier = "janus_head"
	build_path = /obj/item/mecha_parts/part/janus_head
	work = (200 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials = list(MAT_STEEL = 30000, MAT_DURASTEEL = 2000, MAT_MORPHIUM = 6000, MAT_GOLD = 5000)

/datum/design/science/mechfab/janus/left_arm
	name = "Prototype Gygax Left Arm"
	identifier = "janus_left_arm"
	build_path = /obj/item/mecha_parts/part/janus_left_arm
	work = (200 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials = list(MAT_STEEL = 30000, MAT_METALHYDROGEN = 3000, MAT_DURASTEEL = 2000, MAT_MORPHIUM = 3000, MAT_GOLD = 5000, MAT_DIAMOND = 7000)

/datum/design/science/mechfab/janus/right_arm
	name = "Prototype Gygax Right Arm"
	identifier = "janus_right_arm"
	build_path = /obj/item/mecha_parts/part/janus_right_arm
	work = (200 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials = list(MAT_STEEL = 30000, MAT_METALHYDROGEN = 3000, MAT_DURASTEEL = 2000, MAT_MORPHIUM = 3000, MAT_GOLD = 5000, MAT_DIAMOND = 7000)

/datum/design/science/mechfab/janus/left_leg
	name = "Prototype Durand Left Leg"
	identifier = "janus_left_leg"
	build_path = /obj/item/mecha_parts/part/janus_left_leg
	work = (200 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials = list(MAT_STEEL = 30000, MAT_METALHYDROGEN = 3000, MAT_DURASTEEL = 2000, MAT_MORPHIUM = 3000, MAT_GOLD = 5000, MAT_URANIUM = 7000)

/datum/design/science/mechfab/janus/right_leg
	name = "Prototype Durand Right Leg"
	identifier = "janus_right_leg"
	build_path = /obj/item/mecha_parts/part/janus_right_leg
	work = (200 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials = list(MAT_STEEL = 30000, MAT_METALHYDROGEN = 3000, MAT_DURASTEEL = 2000, MAT_MORPHIUM = 3000, MAT_GOLD = 5000, MAT_URANIUM = 7000)

/datum/design/science/mechfab/janus/phase_coil
	name = "Janus Phase Coil"
	identifier = "janus_coil"
	build_path = /obj/item/prop/alien/phasecoil
	work = (600 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials = list(MAT_SUPERMATTER = 2000, MAT_PLASTEEL = 60000, MAT_URANIUM = 3250, MAT_DURASTEEL = 2000, MAT_MORPHIUM = 3000, MAT_GOLD = 5000, MAT_VERDANTIUM = 5000, MAT_DIAMOND = 10000, MAT_LEAD = 15000)

/datum/design/science/mechfab/honker
	category = list("H.O.N.K.")

/datum/design/science/mechfab/honker/chassis
	name = "H.O.N.K. Chassis"
	identifier = "honker_chassis"
	build_path = /obj/item/mecha_parts/chassis/honker
	work = (10 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials = list(MAT_STEEL = 18750)

/datum/design/science/mechfab/honker/torso
	name = "H.O.N.K. Torso"
	identifier = "honker_torso"
	build_path = /obj/item/mecha_parts/part/honker_torso
	work = (30 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials = list(MAT_STEEL = 37500, MAT_GLASS = 15000, MAT_PLASTIC = 10000)

/datum/design/science/mechfab/honker/head
	name = "H.O.N.K. Head"
	identifier = "honker_head"
	build_path = /obj/item/mecha_parts/part/honker_head
	work = (20 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials = list(MAT_STEEL = 15000, MAT_GLASS = 7500, MAT_PLASTIC = 5000)

/datum/design/science/mechfab/honker/left_arm
	name = "H.O.N.K. Left Arm"
	identifier = "honker_left_arm"
	build_path = /obj/item/mecha_parts/part/honker_left_arm
	work = (20 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials = list(MAT_STEEL = 22500, MAT_PLASTIC = 12000)

/datum/design/science/mechfab/honker/right_arm
	name = "H.O.N.K. Right Arm"
	identifier = "honker_right_arm"
	build_path = /obj/item/mecha_parts/part/honker_right_arm
	work = (20 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials = list(MAT_STEEL = 22500, MAT_PLASTIC = 12000)

/datum/design/science/mechfab/honker/left_leg
	name = "H.O.N.K. Left Leg"
	identifier = "honker_left_leg"
	build_path = /obj/item/mecha_parts/part/honker_left_leg
	work = (20 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials = list(MAT_STEEL = 26250, MAT_PLASTIC = 15000)

/datum/design/science/mechfab/honker/right_leg
	name = "H.O.N.K. Right Leg"
	identifier = "honker_right_leg"
	build_path = /obj/item/mecha_parts/part/honker_right_leg
	work = (20 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials = list(MAT_STEEL = 26250, MAT_PLASTIC = 15000)

/datum/design/science/mechfab/honker/armour
	name = "H.O.N.K. Armour Plates"
	identifier = "honker_armour"
	build_path = /obj/item/mecha_parts/part/honker_armour
	work = (60 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials = list(MAT_STEEL = 37500, MAT_DIAMOND = 7500, MAT_PLASTIC = 5000, MAT_BANANIUM = 20000)

/datum/design/science/mechfab/reticent
	category = list("Reticent")

/datum/design/science/mechfab/reticent/chassis
	name = "Reticent Chassis"
	identifier = "reticent_chassis"
	build_path = /obj/item/mecha_parts/chassis/reticent
	work = (10 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials = list(MAT_STEEL = 18750)

/datum/design/science/mechfab/reticent/torso
	name = "Reticent Torso"
	identifier = "reticent_torso"
	build_path = /obj/item/mecha_parts/part/reticent_torso
	work = (30 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials = list(MAT_STEEL = 37500, MAT_GLASS = 15000, MAT_OSMIUM = 5000)

/datum/design/science/mechfab/reticent/head
	name = "Reticent Head"
	identifier = "reticent_head"
	build_path = /obj/item/mecha_parts/part/reticent_head
	work = (20 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials = list(MAT_STEEL = 15000, MAT_GLASS = 7500, MAT_OSMIUM = 5000)

/datum/design/science/mechfab/reticent/left_arm
	name = "Reticent Left Arm"
	identifier = "reticent_left_arm"
	build_path = /obj/item/mecha_parts/part/reticent_left_arm
	work = (20 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials = list(MAT_STEEL = 22500, MAT_PLASTIC = 12000)

/datum/design/science/mechfab/reticent/right_arm
	name = "Reticent Right Arm"
	identifier = "reticent_right_arm"
	build_path = /obj/item/mecha_parts/part/reticent_right_arm
	work = (20 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials = list(MAT_STEEL = 22500, MAT_PLASTIC = 12000)

/datum/design/science/mechfab/reticent/left_leg
	name = "Reticent Left Leg"
	identifier = "reticent_left_leg"
	build_path = /obj/item/mecha_parts/part/reticent_left_leg
	work = (20 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials = list(MAT_STEEL = 26250, MAT_PLASTIC = 15000)

/datum/design/science/mechfab/reticent/right_leg
	name = "Reticent Right Leg"
	identifier = "reticent_right_leg"
	build_path = /obj/item/mecha_parts/part/reticent_right_leg
	work = (20 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials = list(MAT_STEEL = 26250, MAT_PLASTIC = 15000)

/datum/design/science/mechfab/reticent/armour
	name = "Reticent Armour Plates"
	identifier = "reticent_armour"
	build_path = /obj/item/mecha_parts/part/reticent_armour
	work = (60 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials = list(MAT_STEEL = 37500, MAT_OSMIUM = 7500, MAT_PLASTIC = 5000, MAT_SILENCIUM = 20000)

/datum/design/science/mecha
	lathe_type = LATHE_TYPE_MECHA
	category = list("Exosuit Equipment")
	work = (10 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials = list(MAT_STEEL = 7500)

/datum/design/science/mecha/AssembleDesignDesc()
	if(!desc)
		desc = "Allows for the construction of \a '[build_name]' exosuit module."

/datum/design/science/mecha/tracking
	name = "Exosuit Tracking Beacon"
	identifier = "mech_tracker"
	work = (5 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials = list(MAT_STEEL = 375)
	build_path = /obj/item/mecha_parts/mecha_tracking

/datum/design/science/mecha/hydraulic_clamp
	name = "Hydraulic Clamp"
	identifier = "hydraulic_clamp"
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/hydraulic_clamp

/datum/design/science/mecha/drill
	name = "Drill"
	identifier = "mech_drill"
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/drill

/datum/design/science/mecha/extinguisher
	name = "Extinguisher"
	identifier = "extinguisher"
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/extinguisher

/datum/design/science/mecha/cable_layer
	name = "Cable Layer"
	identifier = "mech_cable_layer"
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/cable_layer
	materials = list(MAT_STEEL = 7500, MAT_PLASTIC = 1000)

/datum/design/science/mecha/flaregun
	name = "Flare Launcher"
	identifier = "mecha_flare_gun"
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/flare
	materials = list(MAT_STEEL = 9375)

/datum/design/science/mecha/sleeper
	name = "Sleeper"
	identifier = "mech_sleeper"
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/sleeper
	materials = list(MAT_STEEL = 3750, MAT_GLASS = 7500)

/datum/design/science/mecha/syringe_gun
	name = "Syringe Gun"
	identifier = "mech_syringe_gun"
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/syringe_gun
	work = (20 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials = list(MAT_STEEL = 2250, MAT_GLASS = 1500)

/datum/design/science/mecha/passenger
	name = "Passenger Compartment"
	identifier = "mech_passenger"
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/passenger
	materials = list(MAT_STEEL = 3750, MAT_GLASS = 3750)

/datum/design/science/mecha/taser
	name = "PBT \"Pacifier\" Mounted Taser"
	identifier = "mech_taser"
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/taser

/datum/design/science/mecha/rigged_taser
	name = "Jury-Rigged Taser"
	identifier = "mech_taser-r"
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/taser/rigged

/datum/design/science/mecha/shocker
	name = "Exosuit Electrifier"
	desc = "A device to electrify the external portions of a mecha in order to increase its defensive capabilities."
	identifier = "mech_shocker"
	req_tech = list(TECH_COMBAT = 3, TECH_POWER = 6, TECH_MAGNET = 1)
	build_path = /obj/item/mecha_parts/mecha_equipment/shocker
	materials = list(MAT_STEEL = 3500, MAT_GOLD = 750, MAT_GLASS = 1000)

/datum/design/science/mecha/lmg
	name = "Ultra AC 2"
	identifier = "mech_lmg"
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/lmg

/datum/design/science/mecha/rigged_lmg
	name = "Jury-Rigged Machinegun"
	identifier = "mech_lmg-r"
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/lmg/rigged

/datum/design/science/mecha/weapon
	req_tech = list(TECH_COMBAT = 3)
	materials = list(MAT_STEEL = 8000, MAT_GLASS = 2000)

// *** Weapon modules
/datum/design/science/mecha/weapon/scattershot
	name = "LBX AC 10 \"Scattershot\""
	identifier = "mech_scattershot"
	req_tech = list(TECH_COMBAT = 4)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/scattershot
	materials = list(MAT_STEEL = 8000, MAT_GLASS = 3000, MAT_PLASTIC = 2000, MAT_SILVER = 2500)

/datum/design/science/mecha/weapon/rigged_scattershot
	name = "Jury-Rigged Shrapnel Cannon"
	identifier = "mech_scattershot-r"
	req_tech = list(TECH_COMBAT = 4)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/scattershot/rigged
	materials = list(MAT_STEEL = 7000, MAT_GLASS = 2000, MAT_PLASTIC = 2000, MAT_SILVER = 2000)

/datum/design/science/mecha/weapon/laser
	name = "CH-PS \"Immolator\" Laser"
	identifier = "mech_laser"
	req_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 3)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/laser
	materials = list(MAT_STEEL = 8000, MAT_GLASS = 3000, MAT_PLASTIC = 2000)

/datum/design/science/mecha/weapon/laser_rigged
	name = "Jury-Rigged Welder-Laser"
	desc = "Allows for the construction of a welder-laser assembly package for non-combat exosuits."
	identifier = "mech_laser_rigged"
	req_tech = list(TECH_COMBAT = 2, TECH_MAGNET = 2)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/riggedlaser

/datum/design/science/mecha/weapon/laser_heavy
	name = "CH-LC \"Solaris\" Laser Cannon"
	identifier = "mech_laser_heavy"
	req_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 4)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/laser/heavy
	materials = list(MAT_STEEL = 10000, MAT_GLASS = 3000, MAT_DIAMOND = 2000, MAT_OSMIUM = 5000, MAT_PLASTIC = 2000)

/datum/design/science/mecha/weapon/rigged_laser_heavy
	name = "Jury-Rigged Emitter Cannon"
	identifier = "mech_laser_heavy-r"
	req_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 4, TECH_PHORON = 3, TECH_ILLEGAL = 1)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/laser/heavy/rigged
	materials = list(MAT_STEEL = 8000, MAT_GLASS = 4000, MAT_DIAMOND = 1500, MAT_OSMIUM = 4000, MAT_PLASTIC = 2000)

/datum/design/science/mecha/weapon/laser_xray
	name = "CH-XS \"Penetrator\" Laser"
	identifier = "mech_laser_xray"
	req_tech = list(TECH_MATERIAL = 3, TECH_COMBAT = 3, TECH_PHORON = 3, TECH_POWER = 4)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/laser/xray
	materials = list(MAT_STEEL = 9000, MAT_GLASS = 3000, MAT_PHORON = 1000, MAT_SILVER = 1500, MAT_GOLD = 2500, MAT_PLASTIC = 2000)

/datum/design/science/mecha/weapon/rigged_laser_xray
	name = "Jury-Rigged Xray Rifle"
	identifier = "mech_laser_xray-r"
	req_tech = list(TECH_MATERIAL = 3, TECH_COMBAT = 3, TECH_PHORON = 3, TECH_POWER = 4)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/laser/xray/rigged
	materials = list(MAT_STEEL = 8500, MAT_GLASS = 2500, MAT_PHORON = 1000, MAT_SILVER = 1250, MAT_GOLD = 2000, MAT_PLASTIC = 2000)

/datum/design/science/mecha/weapon/phase
	name = "NT-PE \"Scorpio\" Phase-Emitter"
	identifier = "mech_phase"
	req_tech = list(TECH_MATERIAL = 1, TECH_COMBAT = 2, TECH_MAGNET = 2)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/phase
	materials = list(MAT_STEEL = 6000, MAT_GLASS = 3000, MAT_PLASTIC = 3000)

/datum/design/science/mecha/weapon/ion
	name = "MK-IV Ion Heavy Cannon"
	identifier = "mech_ion"
	req_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 4)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/ion
	materials = list(MAT_STEEL = 15000, MAT_URANIUM = 2000, MAT_SILVER = 2000, MAT_OSMIUM = 4500, MAT_PLASTIC = 2000)

/datum/design/science/mecha/weapon/rigged_ion
	name = "Jury-Rigged Ion Cannon"
	identifier = "mech_ion-r"
	req_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 4)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/ion/rigged
	materials = list(MAT_STEEL = 13000, MAT_URANIUM = 1000, MAT_SILVER = 1000, MAT_OSMIUM = 3000, MAT_PLASTIC = 2000)

/datum/design/science/mecha/weapon/sound_cannon
	name = "H.O.N.K. Sound Cannon"
	identifier = "mech_soundcannon"
	req_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 4, TECH_ILLEGAL = 3)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/honker
	materials = list(MAT_STEEL = 13000, MAT_SILVER = 1000, MAT_OSMIUM = 3000, MAT_PLASTIC = 2000, MAT_BANANIUM = 4000)

/datum/design/science/mecha/weapon/whisper_blade
	name = "Reticent Whisper Blade"
	identifier = "mech_whisper"
	req_tech = list(TECH_COMBAT = 5, TECH_MAGNET = 4, TECH_ILLEGAL = 4)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/whisperblade
	materials = list(MAT_STEEL = 13000, MAT_GOLD = 1000, MAT_OSMIUM = 3000, MAT_PLASTEEL = 2000, MAT_SILENCIUM = 4000)

/datum/design/science/mecha/weapon/inferno_blade
	name = "Reticent Inferno Blade"
	identifier = "mech_inferno"
	req_tech = list(TECH_COMBAT = 5, TECH_MAGNET = 4, TECH_ILLEGAL = 4)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/infernoblade
	materials = list(MAT_STEEL = 13000, MAT_GOLD = 1000, MAT_LEAD = 3000, MAT_PLASTEEL = 2000, MAT_SILENCIUM = 4000)

/datum/design/science/mecha/weapon/grenade_launcher
	name = "SGL-6 Grenade Launcher"
	identifier = "mech_grenade_launcher"
	req_tech = list(TECH_COMBAT = 3)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/grenade
	materials = list(MAT_STEEL = 7000, MAT_GOLD = 2000, MAT_PLASTIC = 3000)

/datum/design/science/mecha/weapon/rigged_grenade_launcher
	name = "Jury-Rigged Pneumatic Flashlauncher"
	identifier = "mech_grenade_launcher-hardsuit"
	req_tech = list(TECH_COMBAT = 3)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/grenade/rigged
	materials = list(MAT_STEEL = 5000, MAT_GOLD = 2000, MAT_PLASTIC = 2000)

/datum/design/science/mecha/weapon/clusterbang_launcher
	name = "SOP-6 Grenade Launcher"
	desc = "A weapon that violates the Geneva Convention at 6 rounds per minute."
	identifier = "clusterbang_launcher"
	req_tech = list(TECH_COMBAT= 5, TECH_MATERIAL = 5, TECH_ILLEGAL = 3)
	materials = list(MAT_STEEL = 15000, MAT_GOLD = 4500, MAT_URANIUM = 4500)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/grenade/clusterbang/limited

/datum/design/science/mecha/weapon/conc_grenade_launcher
	name = "SGL-9 Grenade Launcher"
	identifier = "mech_grenade_launcher_conc"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 4, TECH_ILLEGAL = 1)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/grenade/concussion
	materials = list(MAT_STEEL = 9000, MAT_GOLD = 1000, MAT_OSMIUM = 1000, MAT_PLASTIC = 3000)

/datum/design/science/mecha/weapon/frag_grenade_launcher
	name = "HEP-MI 6 Grenade Launcher"
	identifier = "mech_grenade_launcher_frag"
	req_tech = list(TECH_COMBAT = 4, TECH_ENGINEERING = 2, TECH_MATERIAL = 3, TECH_ILLEGAL = 2)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/grenade/frag/mini
	materials = list(MAT_STEEL = 10000, MAT_GOLD = 2500, MAT_URANIUM = 3000, MAT_OSMIUM = 3000, MAT_PLASTIC = 3000)

/datum/design/science/mecha/weapon/banana_launcher
	name = "WSS-2 Banana Peel Launcher"
	identifier = "mech_banana_launcher"
	req_tech = list(TECH_COMBAT = 3, TECH_ILLEGAL = 3)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/grenade/banana
	materials = list(MAT_STEEL = 7000, MAT_GOLD = 2000, MAT_OSMIUM = 1000, MAT_PLASTIC = 5000, MAT_BANANIUM = 4000)

/datum/design/science/mecha/weapon/mousetrap_launcher
	name = "WSS-5 Mouse Trap Launcher"
	identifier = "mech_mousetrap_launcher"
	req_tech = list(TECH_COMBAT = 3, TECH_ILLEGAL = 3)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/grenade/mousetrap
	materials = list(MAT_STEEL = 7000, MAT_GOLD = 2000, MAT_OSMIUM = 1000, MAT_PLASTIC = 5000, MAT_BANANIUM = 4000)

/datum/design/science/mecha/weapon/flamer
	name = "CR-3 Mark 8 Flamethrower"
	desc = "A weapon that violates the CCWC at two hundred gallons per minute."
	identifier = "mech_flamer_full"
	req_tech = list(TECH_MATERIAL = 4, TECH_COMBAT = 6, TECH_PHORON = 4, TECH_ILLEGAL = 4)
	materials = list(MAT_STEEL = 10000, MAT_GOLD = 2000, MAT_URANIUM = 3000, MAT_PHORON = 8000)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/flamer

/datum/design/science/mecha/weapon/flamer_rigged
	name = "AA-CR-1 Mark 4 Flamethrower"
	desc = "A weapon that accidentally violates the CCWC at one hundred gallons per minute."
	identifier = "mech_flamer_rigged"
	req_tech = list(TECH_MATERIAL = 3, TECH_COMBAT = 3, TECH_PHORON = 3, TECH_ILLEGAL = 2)
	materials = list(MAT_STEEL = 8000, MAT_GOLD = 1500, MAT_SILVER = 1500, MAT_URANIUM = 2000, MAT_PHORON = 6000)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/flamer/rigged

/datum/design/science/mecha/weapon/flame_mg
	name = "DR-AC 3 Incendiary Rotary MG"
	desc = "A weapon that violates the CCWC at sixty rounds a minute."
	identifier = "mech_lmg_flamer"
	req_tech = list(TECH_MATERIAL = 4, TECH_COMBAT = 5, TECH_PHORON = 2, TECH_ILLEGAL = 1)
	materials = list(MAT_STEEL = 8000, MAT_GOLD = 2000, MAT_SILVER = 1750, MAT_URANIUM = 1500, MAT_PHORON = 4000)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/incendiary

// *** Nonweapon modules
/datum/design/science/mecha/wormhole_gen
	name = "Wormhole Generator"
	desc = "An exosuit module that can generate small quasi-stable wormholes."
	identifier = "mech_wormhole_gen"
	req_tech = list(TECH_BLUESPACE = 3, TECH_MAGNET = 2)
	build_path = /obj/item/mecha_parts/mecha_equipment/wormhole_generator

/datum/design/science/mecha/teleporter
	name = "Teleporter"
	desc = "An exosuit module that allows teleportation to any position in view."
	identifier = "mech_teleporter"
	req_tech = list(TECH_BLUESPACE = 10, TECH_MAGNET = 5)
	build_path = /obj/item/mecha_parts/mecha_equipment/teleporter

/datum/design/science/mecha/rcd
	name = "RCD"
	desc = "An exosuit-mounted rapid construction device."
	identifier = "mech_rcd"
	work = (120 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials = list(MAT_STEEL = 20000, MAT_PLASTIC = 10000, MAT_PHORON = 18750, MAT_SILVER = 15000, MAT_GOLD = 15000)
	req_tech = list(TECH_MATERIAL = 4, TECH_BLUESPACE = 3, TECH_MAGNET = 4, TECH_POWER = 4, TECH_ENGINEERING = 4)
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/rcd

/datum/design/science/mecha/gravcatapult
	name = "Gravitational Catapult"
	desc = "An exosuit-mounted gravitational catapult."
	identifier = "mech_gravcatapult"
	req_tech = list(TECH_BLUESPACE = 2, TECH_MAGNET = 3, TECH_ENGINEERING = 3)
	build_path = /obj/item/mecha_parts/mecha_equipment/gravcatapult

/datum/design/science/mecha/repair_droid
	name = "Repair Droid"
	desc = "Automated repair droid, exosuits' best companion. BEEP BOOP"
	identifier = "mech_repair_droid"
	req_tech = list(TECH_MAGNET = 3, TECH_DATA = 3, TECH_ENGINEERING = 3)
	materials = list(MAT_STEEL = 7500, MAT_GOLD = 750, MAT_SILVER = 1500, MAT_GLASS = 3750)
	build_path = /obj/item/mecha_parts/mecha_equipment/repair_droid

/datum/design/science/mecha/shield_drone
	name = "Shield Drone"
	desc = "Manual shield drone. Deploys a large, familiar, and rectangular shield in one direction at a time."
	identifier = "mech_shield_droid"
	req_tech = list(TECH_PHORON = 3, TECH_MAGNET = 6, TECH_ILLEGAL = 4)
	materials = list(MAT_STEEL = 8000, MAT_GOLD = 2000, MAT_SILVER = 3000, MAT_PHORON = 5000, MAT_GLASS = 3750)
	build_path = /obj/item/mecha_parts/mecha_equipment/combat_shield

/datum/design/science/mecha/reticent_shield_drone
	name = "Reticent Wall Projector"
	desc = "A Le Rien specialty shield drone. Deploys a translucent rectangular shield in one direction."
	identifier = "mech_reticent_shield_droid"
	req_tech = list(TECH_PHORON = 3, TECH_MAGNET = 6, TECH_ILLEGAL = 4)
	materials = list(MAT_STEEL = 8000, MAT_OSMIUM = 4000, MAT_SILVER = 3000, MAT_SILENCIUM = 10000, MAT_GLASS = 3750)
	build_path = /obj/item/mecha_parts/mecha_equipment/combat_shield/reticent

/datum/design/science/mecha/crisis_drone
	name = "Crisis Drone"
	desc = "Deploys a small medical drone capable of patching small wounds in order to stabilize nearby patients."
	identifier = "mech_med_droid"
	req_tech = list(TECH_PHORON = 3, TECH_MAGNET = 6, TECH_BIO = 5, TECH_DATA = 4, TECH_ARCANE = 1)
	materials = list(MAT_STEEL = 8000, MAT_GOLD = 2000, MAT_SILVER = 3000, MAT_VERDANTIUM = 2500, MAT_GLASS = 3000)
	build_path = /obj/item/mecha_parts/mecha_equipment/crisis_drone

/datum/design/science/mecha/rad_drone
	name = "Hazmat Drone"
	desc = "Deploys a small hazmat drone capable of purging minor radiation damage in order to stabilize nearby patients."
	identifier = "mech_rad_droid"
	req_tech = list(TECH_PHORON = 4, TECH_MAGNET = 5, TECH_BIO = 6, TECH_DATA = 4, TECH_ARCANE = 1)
	materials = list(MAT_STEEL = 8000, MAT_GOLD = 2000, MAT_URANIUM = 3000, MAT_VERDANTIUM = 2500, MAT_GLASS = 3000)
	build_path = /obj/item/mecha_parts/mecha_equipment/crisis_drone/rad

/datum/design/science/mecha/medanalyzer
	name = "Mounted Body Scanner"
	desc = "An advanced mech-mounted device that is not quite as powerful as a stationary body scanner, though still suitably powerful."
	identifier = "mech_med_analyzer"
	req_tech = list(TECH_PHORON = 4, TECH_MAGNET = 5, TECH_BIO = 5, TECH_DATA = 4)
	materials = list(MAT_PLASTEEL = 4500, MAT_GOLD = 2000, MAT_URANIUM = 3000, MAT_GLASS = 3000)
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/powertool/medanalyzer

/datum/design/science/mecha/jetpack
	name = "Ion Jetpack"
	desc = "Using directed ion bursts and cunning solar wind reflection technique, this device enables controlled space flight."
	identifier = "mech_jetpack"
	req_tech = list(TECH_ENGINEERING = 3, TECH_MAGNET = 4) //One less magnet than the actual got-damn teleporter.
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/jetpack
	materials = list(MAT_STEEL = 7500, MAT_SILVER = 300, MAT_GLASS = 600)

/datum/design/science/mecha/phoron_generator
	desc = "Phoron Reactor"
	identifier = "mech_phoron_generator"
	req_tech = list(TECH_PHORON = 2, TECH_POWER= 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/mecha_parts/mecha_equipment/generator
	materials = list(MAT_STEEL = 7500, MAT_SILVER = 375, MAT_GLASS = 750)

/datum/design/science/mecha/energy_relay
	name = "Energy Relay"
	identifier = "mech_energy_relay"
	req_tech = list(TECH_MAGNET = 4, TECH_POWER = 3)
	materials = list(MAT_STEEL = 7500, MAT_GOLD = 1500, MAT_SILVER = 2250, MAT_GLASS = 1500)
	build_path = /obj/item/mecha_parts/mecha_equipment/tesla_energy_relay

/datum/design/science/mecha/ccw_armor
	name = "CCW Armor Booster"
	desc = "Exosuit close-combat armor booster."
	identifier = "mech_ccw_armor"
	req_tech = list(TECH_MATERIAL = 5, TECH_COMBAT = 4)
	materials = list(MAT_STEEL = 11250, MAT_SILVER = 3750)
	build_path = /obj/item/mecha_parts/mecha_equipment/anticcw_armor_booster

/datum/design/science/mecha/proj_armor
	name = "Ranged Armor Booster"
	desc = "Exosuit projectile armor booster."
	identifier = "mech_proj_armor"
	req_tech = list(TECH_MATERIAL = 5, TECH_COMBAT = 5, TECH_ENGINEERING = 3)
	materials = list(MAT_STEEL = 15000, MAT_GOLD = 3750)
	build_path = /obj/item/mecha_parts/mecha_equipment/antiproj_armor_booster

/datum/design/science/mecha/diamond_drill
	name = "Diamond Drill"
	desc = "A diamond version of the exosuit drill. It's harder, better, faster, stronger."
	identifier = "mech_diamond_drill"
	req_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 3)
	materials = list(MAT_STEEL = 7500, MAT_DIAMOND = 4875)
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/drill/diamonddrill

/datum/design/science/mecha/ground_drill
	name = "Surface Bore"
	desc = "A heavy duty bore. Bigger, better, stronger than the core sampler, but not quite as good as a large drill."
	identifier = "mech_ground_drill"
	req_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 2, TECH_PHORON = 1)
	materials = list(MAT_STEEL = 7000, MAT_SILVER = 3000, MAT_PHORON = 2000)
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/drill/bore

/datum/design/science/mecha/orescanner
	name = "Ore Scanner"
	desc = "A hefty device used to scan for subterranean veins of ore."
	identifier = "mech_ore_scanner"
	req_tech = list(TECH_MATERIAL = 2, TECH_MAGNET = 2, TECH_POWER = 2)
	materials = list(MAT_STEEL = 4000, MAT_GLASS = 1000)
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/orescanner

/datum/design/science/mecha/advorescanner
	name = "Advanced Ore Scanner"
	desc = "A hefty device used to scan for the exact volumes of subterranean veins of ore."
	identifier = "mech_ore_scanner_adv"
	req_tech = list(TECH_MATERIAL = 5, TECH_MAGNET = 4, TECH_POWER = 4, TECH_BLUESPACE = 2)
	materials = list(MAT_STEEL = 5000, MAT_OSMIUM = 3000, MAT_SILVER = 1000)
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/orescanner/advanced

/datum/design/science/mecha/powerwrench
	name = "hydraulic wrench"
	desc = "A large, hydraulic wrench."
	identifier = "mech_wrench"
	req_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2, TECH_POWER = 2)
	materials = list(MAT_STEEL = 5000, MAT_PLASTIC = 2000, MAT_GLASS = 1250)
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/powertool

/datum/design/science/mecha/powercrowbar
	name = "hydraulic prybar"
	desc = "A large, hydraulic prybar."
	identifier = "mech_crowbar"
	req_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2, TECH_POWER = 2)
	materials = list(MAT_STEEL = 4000, MAT_OSMIUM = 3000, MAT_GLASS = 1000)
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/powertool/prybar

/datum/design/science/mecha/generator_nuclear
	name = "Nuclear Reactor"
	desc = "Exosuit-held nuclear reactor. Converts uranium and everyone's health to energy."
	identifier = "mech_generator_nuclear"
	req_tech = list(TECH_POWER= 3, TECH_ENGINEERING = 3, TECH_MATERIAL = 3)
	materials = list(MAT_STEEL = 7500, MAT_SILVER = 375, MAT_GLASS = 750)
	build_path = /obj/item/mecha_parts/mecha_equipment/generator/nuclear

/datum/design/science/mecha/speedboost_ripley
	name = "Ripley Leg Actuator Overdrive"
	desc = "System enhancements and overdrives to make a mech's legs move faster."
	identifier = "mech_speedboost_ripley"
	req_tech = list(TECH_POWER = 5, TECH_MATERIAL = 4, TECH_ENGINEERING = 4)
	materials = list(MAT_STEEL = 10000, MAT_SILVER = 1000, MAT_GOLD = 1000)
	build_path = /obj/item/mecha_parts/mecha_equipment/speedboost

/datum/design/science/synthetic_flash
	name = "Synthetic Flash"
	identifier = "sflash"
	req_tech = list(TECH_MAGNET = 3, TECH_COMBAT = 2)
	lathe_type = LATHE_TYPE_MECHA
	materials = list(MAT_STEEL = 562, MAT_GLASS = 562)
	build_path = /obj/item/flash/synthetic
	category = list("Misc")

/*
* Printable Internal Components
*/

/datum/design/science/mecha_component
	name = "Mecha Actuator"
	identifier = "mactuator"
	req_tech = list(TECH_ENGINEERING = 3, TECH_MATERIAL = 2)
	lathe_type = LATHE_TYPE_MECHA
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 2500)
	build_path = /obj/item/mecha_parts/component/actuator
	category = list("Components")

/datum/design/science/mecha_component/actuator_high
	name = "Mecha Actuator - High Speed"
	identifier = "mactuatorhigh"
	req_tech = list(TECH_ENGINEERING = 5, TECH_MATERIAL = 6)
	materials = list(MAT_STEEL = 7000, MAT_GLASS = 4000, MAT_GOLD = 10000)
	build_path = /obj/item/mecha_parts/component/actuator/hispeed

/datum/design/science/mecha_component/armor
	name = "Mecha Plating"
	identifier = "marmor"
	req_tech = list(TECH_ENGINEERING = 3, TECH_MATERIAL = 3)
	materials = list(MAT_STEEL = 10000, MAT_GLASS = 2000)
	build_path = /obj/item/mecha_parts/component/armor

/datum/design/science/mecha_component/armor/blast
	name = "Mecha Plating - Blast Resistant"
	identifier = "marmorblast"
	req_tech = list(TECH_ENGINEERING = 5, TECH_MATERIAL = 4)
	materials = list(MAT_STEEL = 15000, MAT_GLASS = 500, MAT_PLASTEEL = 2000)
	build_path = /obj/item/mecha_parts/component/armor/mining

/datum/design/science/mecha_component/armor/lightweight
	name = "Mecha Plating - Lightweight"
	identifier = "marmorlight"
	req_tech = list(TECH_ENGINEERING = 5, TECH_MATERIAL = 6)
	materials = list(MAT_STEEL = 7000, MAT_PLASTIC = 5000, MAT_GOLD = 2000)
	build_path = /obj/item/mecha_parts/component/armor/lightweight

/datum/design/science/mecha_component/armor/reinforced
	name = "Mecha Plating - Reinforced"
	identifier = "marmorreinf"
	req_tech = list(TECH_ENGINEERING = 5, TECH_MATERIAL = 6, TECH_COMBAT = 5)
	materials = list(MAT_STEEL = 15000, MAT_PLASTEEL = 5000, MAT_URANIUM = 5000)
	build_path = /obj/item/mecha_parts/component/armor/reinforced

/datum/design/science/mecha_component/electrical
	name = "Mecha Electrical Harness"
	identifier = "melectrical"
	req_tech = list(TECH_ENGINEERING = 3, TECH_POWER = 3)
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 2000, MAT_PLASTIC = 1000)
	build_path = /obj/item/mecha_parts/component/electrical

/datum/design/science/mecha_component/electrical/high_current
	name = "Mecha Electrical Harness - High Current"
	identifier = "melectricalhigh"
	req_tech = list(TECH_ENGINEERING = 5, TECH_POWER = 5, TECH_MATERIAL = 4)
	materials = list(MAT_STEEL = 3000, MAT_GLASS = 4000, MAT_PLASTIC = 5000, MAT_GOLD = 5000)
	build_path = /obj/item/mecha_parts/component/electrical

/datum/design/science/mecha_component/hull
	name = "Mecha Hull"
	identifier = "mhull"
	req_tech = list(TECH_ENGINEERING = 3, TECH_MATERIAL = 2)
	materials = list(MAT_STEEL = 7000, MAT_GLASS = 500)
	build_path = /obj/item/mecha_parts/component/hull

/datum/design/science/mecha_component/hull/durable
	name = "Mecha Hull - Durable"
	identifier = "mhulldura"
	req_tech = list(TECH_ENGINEERING = 4, TECH_MATERIAL = 4)
	materials = list(MAT_STEEL = 7000, MAT_GLASS = 500, MAT_PLASTEEL = 10000)
	build_path = /obj/item/mecha_parts/component/hull/durable

/datum/design/science/mecha_component/hull/lightweight
	name = "Mecha Hull - Lightweight"
	identifier = "mhulllight"
	req_tech = list(TECH_ENGINEERING = 5, TECH_MATERIAL = 5)
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 500, MAT_PLASTIC = 3000)
	build_path = /obj/item/mecha_parts/component/hull/lightweight

/datum/design/science/mecha_component/gas
	name = "Mecha Life-Support"
	identifier = "mgas"
	req_tech = list(TECH_ENGINEERING = 3, TECH_MATERIAL = 2, TECH_BIO = 3)
	materials = list(MAT_STEEL = 2000, MAT_GLASS = 3000)
	build_path = /obj/item/mecha_parts/component/gas

/datum/design/science/mecha_component/gas/reinforced
	name = "Mecha Life-Support - Reinforced"
	identifier = "mgasreinf"
	req_tech = list(TECH_ENGINEERING = 4, TECH_MATERIAL = 3, TECH_BIO = 5)
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 3000, MAT_SILVER = 4000)
	build_path = /obj/item/mecha_parts/component/gas/reinforced

/*
 * Non-Mech Vehicles
 */

/datum/design/science/mechfab/vehicle
	lathe_type = LATHE_TYPE_MECHA
	category = list("Vehicle")
	req_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 6)

/datum/design/science/mechfab/vehicle/spacebike_chassis
	name = "Spacebike Chassis"
	desc = "A space-bike's un-assembled frame."
	identifier = "vehicle_chassis_spacebike"
	req_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 6, TECH_BLUESPACE = 3, TECH_PHORON = 3)
	materials = list(MAT_STEEL = 12000, MAT_SILVER = 3000, MAT_PHORON = 3000, MAT_OSMIUM = 1000)
	build_path = /obj/item/vehicle_assembly/spacebike

/datum/design/science/mechfab/vehicle/quadbike_chassis
	name = "Quadbike Chassis"
	desc = "A space-bike's un-assembled frame."
	identifier = "vehicle_chassis_quadbike"
	req_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 6, TECH_MAGNET = 3, TECH_POWER = 2)
	materials = list(MAT_STEEL = 15000, MAT_SILVER = 3000, MAT_PLASTIC = 3000, MAT_OSMIUM = 1000)
	build_path = /obj/item/vehicle_assembly/quadbike

/*
/datum/design/science/mechfab/uav/basic
	name = "UAV - Recon Skimmer"
	identifier = "recon_skimmer"
	build_path = /obj/item/uav
	work = (20 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	req_tech = list(TECH_MATERIAL = 6, TECH_ENGINEERING = 5, TECH_PHORON = 3, TECH_MAGNET = 4, TECH_POWER = 6)
	materials = list(MAT_STEEL = 10000, MAT_GLASS = 6000, MAT_SILVER = 4000)
*/

///--------///
///Fighters///
///--------///

/datum/design/item/mechfab/fighter/pinnace
	category = list("Pinnace")

/datum/design/item/mechfab/fighter/pinnace/chassis
	name = "Pinnace Chassis"
	id = "pinnace_chassis"
	build_path = /obj/item/mecha_parts/fighter/chassis/pinnace
	time = 30
	materials = list(MAT_STEEL = 37500, MAT_GLASS = 15000, MAT_PLASTEEL = 25000)

/datum/design/item/mechfab/fighter/pinnace/core
	name = "Pinnace Core"
	id = "pinnace_core"
	build_path = /obj/item/mecha_parts/fighter/part/pinnace_core
	time = 60
	materials = list(MAT_STEEL = 37500, MAT_GLASS = 15000, MAT_PLASTEEL = 25000)

/datum/design/item/mechfab/fighter/pinnace/cockpit
	name = "Pinnace Cockpit"
	id = "pinnace_cockpit"
	build_path = /obj/item/mecha_parts/fighter/part/pinnace_cockpit
	time = 15
	materials = list(MAT_STEEL = 5000, MAT_PLASTEEL = 15000, MAT_GLASS = 10000, MAT_PLASTIC = 5000)

/datum/design/item/mechfab/fighter/pinnace/main_engine
	name = "Pinnace Main Engine"
	id = "pinnace_main_engine"
	build_path = /obj/item/mecha_parts/fighter/part/pinnace_main_engine
	time = 25
	materials = list(MAT_STEEL = 25000, MAT_PLASTEEL = 20000)

/datum/design/item/mechfab/fighter/pinnace/left_engine
	name = "Pinnace Left Engine"
	id = "pinnace_left_engine"
	build_path = /obj/item/mecha_parts/fighter/part/pinnace_left_engine
	time = 25
	materials = list(MAT_STEEL = 20000, MAT_PLASTEEL = 15000)

/datum/design/item/mechfab/fighter/pinnace/right_engine
	name = "Pinnace Right Engine"
	id = "pinnace_right_engine"
	build_path = /obj/item/mecha_parts/fighter/part/pinnace_right_engine
	time = 25
	materials = list(MAT_STEEL = 20000, MAT_PLASTEEL = 15000)

/datum/design/item/mechfab/fighter/pinnace/left_wing
	name = "Pinnace Left Wing"
	id = "pinnace_left_wing"
	build_path = /obj/item/mecha_parts/fighter/part/pinnace_left_wing
	time = 20
	materials = list(MAT_STEEL = 15000, MAT_PLASTIC = 6000, MAT_PLASTEEL = 20000)

/datum/design/item/mechfab/fighter/pinnace/right_wing
	name = "Pinnace Right Wing"
	id = "pinnace_right_wing"
	build_path = /obj/item/mecha_parts/fighter/part/pinnace_right_wing
	time = 20
	materials = list(MAT_STEEL = 15000, MAT_PLASTIC = 6000, MAT_PLASTEEL = 20000)
