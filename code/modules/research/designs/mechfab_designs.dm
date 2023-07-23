/datum/design/science/mechfab
	abstract_type = /datum/design/science/mechfab
	lathe_type = LATHE_TYPE_MECHA
	category = list("Other")
	req_tech = list(TECH_MATERIAL = 1)

/datum/design/science/mechfab/ripley
	abstract_type = /datum/design/science/mechfab/ripley
	category = list("Ripley")

/datum/design/science/mechfab/ripley/chassis
	design_name = "Ripley Chassis"
	id = "ripley_chassis"
	build_path = /obj/item/mecha_parts/chassis/ripley
	work = (10 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 15000)

/datum/design/science/mechfab/ripley/chassis/firefighter
	design_name = "Firefigher Chassis"
	id = "firefighter_chassis"
	build_path = /obj/item/mecha_parts/chassis/firefighter

/datum/design/science/mechfab/ripley/chassis/geiger
	design_name = "Geiger Chassis"
	id = "geiger_chassis"
	build_path = /obj/item/mecha_parts/chassis/geiger

/datum/design/science/mechfab/ripley/torso
	design_name = "Ripley Torso"
	id = "ripley_torso"
	build_path = /obj/item/mecha_parts/part/ripley_torso
	work = (20 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 30000, MAT_GLASS = 11250)

/datum/design/science/mechfab/ripley/torso/geiger
	design_name = "Geiger Torso"
	id = "geiger_torso"
	build_path = /obj/item/mecha_parts/part/geiger_torso
	work = (20 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 25000, MAT_GLASS = 10000)

/datum/design/science/mechfab/ripley/left_arm
	design_name = "Ripley Left Arm"
	id = "ripley_left_arm"
	build_path = /obj/item/mecha_parts/part/ripley_left_arm
	work = (15 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 18750)

/datum/design/science/mechfab/ripley/right_arm
	design_name = "Ripley Right Arm"
	id = "ripley_right_arm"
	build_path = /obj/item/mecha_parts/part/ripley_right_arm
	work = (15 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 18750)

/datum/design/science/mechfab/ripley/left_leg
	design_name = "Ripley Left Leg"
	id = "ripley_left_leg"
	build_path = /obj/item/mecha_parts/part/ripley_left_leg
	work = (15 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 22500)

/datum/design/science/mechfab/ripley/right_leg
	design_name = "Ripley Right Leg"
	id = "ripley_right_leg"
	build_path = /obj/item/mecha_parts/part/ripley_right_leg
	work = (15 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 22500)

/datum/design/science/mechfab/odysseus
	abstract_type = /datum/design/science/mechfab/odysseus
	category = list("Odysseus")

/datum/design/science/mechfab/odysseus/chassis
	design_name = "Odysseus Chassis"
	id = "odysseus_chassis"
	build_path = /obj/item/mecha_parts/chassis/odysseus
	work = (10 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 15000)

/datum/design/science/mechfab/odysseus/torso
	design_name = "Odysseus Torso"
	id = "odysseus_torso"
	build_path = /obj/item/mecha_parts/part/odysseus_torso
	work = (18 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 18750)

/datum/design/science/mechfab/odysseus/head
	design_name = "Odysseus Head"
	id = "odysseus_head"
	build_path = /obj/item/mecha_parts/part/odysseus_head
	work = (10 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 1500, MAT_GLASS = 7500)

/datum/design/science/mechfab/odysseus/left_arm
	design_name = "Odysseus Left Arm"
	id = "odysseus_left_arm"
	build_path = /obj/item/mecha_parts/part/odysseus_left_arm
	work = (12 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 7500)

/datum/design/science/mechfab/odysseus/right_arm
	design_name = "Odysseus Right Arm"
	id = "odysseus_right_arm"
	build_path = /obj/item/mecha_parts/part/odysseus_right_arm
	work = (12 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 7500)

/datum/design/science/mechfab/odysseus/left_leg
	design_name = "Odysseus Left Leg"
	id = "odysseus_left_leg"
	build_path = /obj/item/mecha_parts/part/odysseus_left_leg
	work = (13 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 11250)

/datum/design/science/mechfab/odysseus/right_leg
	design_name = "Odysseus Right Leg"
	id = "odysseus_right_leg"
	build_path = /obj/item/mecha_parts/part/odysseus_right_leg
	work = (13 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 11250)

/datum/design/science/mechfab/gygax
	abstract_type = /datum/design/science/mechfab/gygax
	category = list("Gygax")

/datum/design/science/mechfab/gygax/chassis/serenity
	design_name = "Serenity Chassis"
	id = "serenity_chassis"
	build_path = /obj/item/mecha_parts/chassis/serenity
	materials_base = list(MAT_STEEL = 18750, MAT_PHORON = 4000)

/datum/design/science/mechfab/gygax/chassis
	design_name = "Gygax Chassis"
	id = "gygax_chassis"
	build_path = /obj/item/mecha_parts/chassis/gygax
	work = (10 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 18750)

/datum/design/science/mechfab/gygax/torso
	design_name = "Gygax Torso"
	id = "gygax_torso"
	build_path = /obj/item/mecha_parts/part/gygax_torso
	work = (30 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 37500, MAT_GLASS = 15000)

/datum/design/science/mechfab/gygax/head
	design_name = "Gygax Head"
	id = "gygax_head"
	build_path = /obj/item/mecha_parts/part/gygax_head
	work = (20 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 15000, MAT_GLASS = 7500)

/datum/design/science/mechfab/gygax/left_arm
	design_name = "Gygax Left Arm"
	id = "gygax_left_arm"
	build_path = /obj/item/mecha_parts/part/gygax_left_arm
	work = (20 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 22500)

/datum/design/science/mechfab/gygax/right_arm
	design_name = "Gygax Right Arm"
	id = "gygax_right_arm"
	build_path = /obj/item/mecha_parts/part/gygax_right_arm
	work = (20 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 22500)

/datum/design/science/mechfab/gygax/left_leg
	design_name = "Gygax Left Leg"
	id = "gygax_left_leg"
	build_path = /obj/item/mecha_parts/part/gygax_left_leg
	work = (20 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 26250)

/datum/design/science/mechfab/gygax/right_leg
	design_name = "Gygax Right Leg"
	id = "gygax_right_leg"
	build_path = /obj/item/mecha_parts/part/gygax_right_leg
	work = (20 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 26250)

/datum/design/science/mechfab/gygax/armour
	design_name = "Gygax Armour Plates"
	id = "gygax_armour"
	build_path = /obj/item/mecha_parts/part/gygax_armour
	work = (60 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 37500, MAT_DIAMOND = 7500)

/datum/design/science/mechfab/durand
	abstract_type = /datum/design/science/mechfab/durand
	category = list("Durand")

/datum/design/science/mechfab/durand/chassis
	design_name = "Durand Chassis"
	id = "durand_chassis"
	build_path = /obj/item/mecha_parts/chassis/durand
	work = (10 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 18750)

/datum/design/science/mechfab/durand/torso
	design_name = "Durand Torso"
	id = "durand_torso"
	build_path = /obj/item/mecha_parts/part/durand_torso
	work = (30 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 41250, MAT_GLASS = 15000, MAT_SILVER = 7500)

/datum/design/science/mechfab/durand/head
	design_name = "Durand Head"
	id = "durand_head"
	build_path = /obj/item/mecha_parts/part/durand_head
	work = (20 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 18750, MAT_GLASS = 7500, MAT_SILVER = 2250)

/datum/design/science/mechfab/durand/left_arm
	design_name = "Durand Left Arm"
	id = "durand_left_arm"
	build_path = /obj/item/mecha_parts/part/durand_left_arm
	work = (20 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 26250, MAT_SILVER = 2250)

/datum/design/science/mechfab/durand/right_arm
	design_name = "Durand Right Arm"
	id = "durand_right_arm"
	build_path = /obj/item/mecha_parts/part/durand_right_arm
	work = (20 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 26250, MAT_SILVER = 2250)

/datum/design/science/mechfab/durand/left_leg
	design_name = "Durand Left Leg"
	id = "durand_left_leg"
	build_path = /obj/item/mecha_parts/part/durand_left_leg
	work = (20 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 30000, MAT_SILVER = 2250)

/datum/design/science/mechfab/durand/right_leg
	design_name = "Durand Right Leg"
	id = "durand_right_leg"
	build_path = /obj/item/mecha_parts/part/durand_right_leg
	work = (20 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 30000, MAT_SILVER = 2250)

/datum/design/science/mechfab/durand/armour
	design_name = "Durand Armour Plates"
	id = "durand_armour"
	build_path = /obj/item/mecha_parts/part/durand_armour
	work = (60 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 37500, MAT_URANIUM = 7500)

/datum/design/science/mechfab/janus
	abstract_type = /datum/design/science/mechfab/janus
	category = list("Janus")
	req_tech = list(TECH_MATERIAL = 7, TECH_BLUESPACE = 5, TECH_MAGNET = 6, TECH_PHORON = 3, TECH_ARCANE = 1, TECH_PRECURSOR = 2)

/datum/design/science/mechfab/janus/chassis
	design_name = "Janus Chassis"
	id = "janus_chassis"
	build_path = /obj/item/mecha_parts/chassis/janus
	work = (100 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_DURASTEEL = 19000, MAT_MORPHIUM = 10500, MAT_PLASTEEL = 5500, MAT_LEAD = 2500)
	req_tech = list(TECH_MATERIAL = 7, TECH_BLUESPACE = 5, TECH_MAGNET = 6, TECH_PHORON = 3, TECH_ARCANE = 1, TECH_PRECURSOR = 3)

/datum/design/science/mechfab/janus/torso
	design_name = "Imperion Torso"
	id = "janus_torso"
	build_path = /obj/item/mecha_parts/part/janus_torso
	work = (300 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 30000, MAT_DURASTEEL = 8000, MAT_MORPHIUM = 10000, MAT_GOLD = 5000, MAT_VERDANTIUM = 5000)

/datum/design/science/mechfab/janus/head
	design_name = "Imperion Head"
	id = "janus_head"
	build_path = /obj/item/mecha_parts/part/janus_head
	work = (200 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 30000, MAT_DURASTEEL = 2000, MAT_MORPHIUM = 6000, MAT_GOLD = 5000)

/datum/design/science/mechfab/janus/left_arm
	design_name = "Prototype Gygax Left Arm"
	id = "janus_left_arm"
	build_path = /obj/item/mecha_parts/part/janus_left_arm
	work = (200 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 30000, MAT_METALHYDROGEN = 3000, MAT_DURASTEEL = 2000, MAT_MORPHIUM = 3000, MAT_GOLD = 5000, MAT_DIAMOND = 7000)

/datum/design/science/mechfab/janus/right_arm
	design_name = "Prototype Gygax Right Arm"
	id = "janus_right_arm"
	build_path = /obj/item/mecha_parts/part/janus_right_arm
	work = (200 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 30000, MAT_METALHYDROGEN = 3000, MAT_DURASTEEL = 2000, MAT_MORPHIUM = 3000, MAT_GOLD = 5000, MAT_DIAMOND = 7000)

/datum/design/science/mechfab/janus/left_leg
	design_name = "Prototype Durand Left Leg"
	id = "janus_left_leg"
	build_path = /obj/item/mecha_parts/part/janus_left_leg
	work = (200 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 30000, MAT_METALHYDROGEN = 3000, MAT_DURASTEEL = 2000, MAT_MORPHIUM = 3000, MAT_GOLD = 5000, MAT_URANIUM = 7000)

/datum/design/science/mechfab/janus/right_leg
	design_name = "Prototype Durand Right Leg"
	id = "janus_right_leg"
	build_path = /obj/item/mecha_parts/part/janus_right_leg
	work = (200 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 30000, MAT_METALHYDROGEN = 3000, MAT_DURASTEEL = 2000, MAT_MORPHIUM = 3000, MAT_GOLD = 5000, MAT_URANIUM = 7000)

/datum/design/science/mechfab/janus/phase_coil
	design_name = "Janus Phase Coil"
	id = "janus_coil"
	build_path = /obj/item/prop/alien/phasecoil
	work = (600 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_SUPERMATTER = 2000, MAT_PLASTEEL = 60000, MAT_URANIUM = 3250, MAT_DURASTEEL = 2000, MAT_MORPHIUM = 3000, MAT_GOLD = 5000, MAT_VERDANTIUM = 5000, MAT_DIAMOND = 10000, MAT_LEAD = 15000)

/datum/design/science/mechfab/honker
	abstract_type = /datum/design/science/mechfab/honker
	category = list("H.O.N.K.")

/datum/design/science/mechfab/honker/chassis
	design_name = "H.O.N.K. Chassis"
	id = "honker_chassis"
	build_path = /obj/item/mecha_parts/chassis/honker
	work = (10 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 18750)

/datum/design/science/mechfab/honker/torso
	design_name = "H.O.N.K. Torso"
	id = "honker_torso"
	build_path = /obj/item/mecha_parts/part/honker_torso
	work = (30 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 37500, MAT_GLASS = 15000, MAT_PLASTIC = 10000)

/datum/design/science/mechfab/honker/head
	design_name = "H.O.N.K. Head"
	id = "honker_head"
	build_path = /obj/item/mecha_parts/part/honker_head
	work = (20 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 15000, MAT_GLASS = 7500, MAT_PLASTIC = 5000)

/datum/design/science/mechfab/honker/left_arm
	design_name = "H.O.N.K. Left Arm"
	id = "honker_left_arm"
	build_path = /obj/item/mecha_parts/part/honker_left_arm
	work = (20 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 22500, MAT_PLASTIC = 12000)

/datum/design/science/mechfab/honker/right_arm
	design_name = "H.O.N.K. Right Arm"
	id = "honker_right_arm"
	build_path = /obj/item/mecha_parts/part/honker_right_arm
	work = (20 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 22500, MAT_PLASTIC = 12000)

/datum/design/science/mechfab/honker/left_leg
	design_name = "H.O.N.K. Left Leg"
	id = "honker_left_leg"
	build_path = /obj/item/mecha_parts/part/honker_left_leg
	work = (20 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 26250, MAT_PLASTIC = 15000)

/datum/design/science/mechfab/honker/right_leg
	design_name = "H.O.N.K. Right Leg"
	id = "honker_right_leg"
	build_path = /obj/item/mecha_parts/part/honker_right_leg
	work = (20 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 26250, MAT_PLASTIC = 15000)

/datum/design/science/mechfab/honker/armour
	design_name = "H.O.N.K. Armour Plates"
	id = "honker_armour"
	build_path = /obj/item/mecha_parts/part/honker_armour
	work = (60 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 37500, MAT_DIAMOND = 7500, MAT_PLASTIC = 5000, MAT_BANANIUM = 20000)

/datum/design/science/mechfab/reticent
	abstract_type = /datum/design/science/mechfab/reticent
	category = list("Reticent")

/datum/design/science/mechfab/reticent/chassis
	design_name = "Reticent Chassis"
	id = "reticent_chassis"
	build_path = /obj/item/mecha_parts/chassis/reticent
	work = (10 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 18750)

/datum/design/science/mechfab/reticent/torso
	design_name = "Reticent Torso"
	id = "reticent_torso"
	build_path = /obj/item/mecha_parts/part/reticent_torso
	work = (30 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 37500, MAT_GLASS = 15000, MAT_OSMIUM = 5000)

/datum/design/science/mechfab/reticent/head
	design_name = "Reticent Head"
	id = "reticent_head"
	build_path = /obj/item/mecha_parts/part/reticent_head
	work = (20 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 15000, MAT_GLASS = 7500, MAT_OSMIUM = 5000)

/datum/design/science/mechfab/reticent/left_arm
	design_name = "Reticent Left Arm"
	id = "reticent_left_arm"
	build_path = /obj/item/mecha_parts/part/reticent_left_arm
	work = (20 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 22500, MAT_PLASTIC = 12000)

/datum/design/science/mechfab/reticent/right_arm
	design_name = "Reticent Right Arm"
	id = "reticent_right_arm"
	build_path = /obj/item/mecha_parts/part/reticent_right_arm
	work = (20 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 22500, MAT_PLASTIC = 12000)

/datum/design/science/mechfab/reticent/left_leg
	design_name = "Reticent Left Leg"
	id = "reticent_left_leg"
	build_path = /obj/item/mecha_parts/part/reticent_left_leg
	work = (20 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 26250, MAT_PLASTIC = 15000)

/datum/design/science/mechfab/reticent/right_leg
	design_name = "Reticent Right Leg"
	id = "reticent_right_leg"
	build_path = /obj/item/mecha_parts/part/reticent_right_leg
	work = (20 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 26250, MAT_PLASTIC = 15000)

/datum/design/science/mechfab/reticent/armour
	design_name = "Reticent Armour Plates"
	id = "reticent_armour"
	build_path = /obj/item/mecha_parts/part/reticent_armour
	work = (60 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 37500, MAT_OSMIUM = 7500, MAT_PLASTIC = 5000, MAT_SILENCIUM = 20000)

/datum/design/science/mecha
	abstract_type = /datum/design/science/mecha
	lathe_type = LATHE_TYPE_MECHA
	category = list("Exosuit Equipment")
	work = (10 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 7500)

/datum/design/science/mecha/generate_desc(template_name, template_desc)
	return "Allows for the construction of \a '[template_name]' exosuit module."

/datum/design/science/mecha/tracking
	design_name = "Exosuit Tracking Beacon"
	id = "mech_tracker"
	work = (5 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 375)
	build_path = /obj/item/mecha_parts/mecha_tracking

/datum/design/science/mecha/hydraulic_clamp
	design_name = "Hydraulic Clamp"
	id = "hydraulic_clamp"
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/hydraulic_clamp

/datum/design/science/mecha/drill
	design_name = "Drill"
	id = "mech_drill"
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/drill

/datum/design/science/mecha/extinguisher
	design_name = "Extinguisher"
	id = "extinguisher"
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/extinguisher

/datum/design/science/mecha/cable_layer
	design_name = "Cable Layer"
	id = "mech_cable_layer"
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/cable_layer
	materials_base = list(MAT_STEEL = 7500, MAT_PLASTIC = 1000)

/datum/design/science/mecha/flaregun
	design_name = "Flare Launcher"
	id = "mecha_flare_gun"
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/flare
	materials_base = list(MAT_STEEL = 9375)

/datum/design/science/mecha/sleeper
	design_name = "Sleeper"
	id = "mech_sleeper"
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/sleeper
	materials_base = list(MAT_STEEL = 3750, MAT_GLASS = 7500)

/datum/design/science/mecha/syringe_gun
	design_name = "Syringe Gun"
	id = "mech_syringe_gun"
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/syringe_gun
	work = (20 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 2250, MAT_GLASS = 1500)

/datum/design/science/mecha/passenger
	design_name = "Passenger Compartment"
	id = "mech_passenger"
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/passenger
	materials_base = list(MAT_STEEL = 3750, MAT_GLASS = 3750)

/datum/design/science/mecha/taser
	design_name = "PBT \"Pacifier\" Mounted Taser"
	id = "mech_taser"
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/taser

/datum/design/science/mecha/rigged_taser
	design_name = "Jury-Rigged Taser"
	id = "mech_taser-r"
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/taser/rigged

/datum/design/science/mecha/shocker
	design_name = "Exosuit Electrifier"
	desc = "A device to electrify the external portions of a mecha in order to increase its defensive capabilities."
	id = "mech_shocker"
	req_tech = list(TECH_COMBAT = 3, TECH_POWER = 6, TECH_MAGNET = 1)
	build_path = /obj/item/mecha_parts/mecha_equipment/shocker
	materials_base = list(MAT_STEEL = 3500, MAT_GOLD = 750, MAT_GLASS = 1000)

/datum/design/science/mecha/lmg
	design_name = "Ultra AC 2"
	id = "mech_lmg"
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/lmg

/datum/design/science/mecha/rigged_lmg
	design_name = "Jury-Rigged Machinegun"
	id = "mech_lmg-r"
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/lmg/rigged

/datum/design/science/mecha/weapon
	abstract_type = /datum/design/science/mecha/weapon
	req_tech = list(TECH_COMBAT = 3)
	materials_base = list(MAT_STEEL = 8000, MAT_GLASS = 2000)

// *** Weapon modules
/datum/design/science/mecha/weapon/scattershot
	design_name = "LBX AC 10 \"Scattershot\""
	id = "mech_scattershot"
	req_tech = list(TECH_COMBAT = 4)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/scattershot
	materials_base = list(MAT_STEEL = 8000, MAT_GLASS = 3000, MAT_PLASTIC = 2000, MAT_SILVER = 2500)

/datum/design/science/mecha/weapon/rigged_scattershot
	design_name = "Jury-Rigged Shrapnel Cannon"
	id = "mech_scattershot-r"
	req_tech = list(TECH_COMBAT = 4)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/scattershot/rigged
	materials_base = list(MAT_STEEL = 7000, MAT_GLASS = 2000, MAT_PLASTIC = 2000, MAT_SILVER = 2000)

/datum/design/science/mecha/weapon/laser
	design_name = "CH-PS \"Immolator\" Laser"
	id = "mech_laser"
	req_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 3)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/laser
	materials_base = list(MAT_STEEL = 8000, MAT_GLASS = 3000, MAT_PLASTIC = 2000)

/datum/design/science/mecha/weapon/laser_rigged
	design_name = "Jury-Rigged Welder-Laser"
	desc = "Allows for the construction of a welder-laser assembly package for non-combat exosuits."
	id = "mech_laser_rigged"
	req_tech = list(TECH_COMBAT = 2, TECH_MAGNET = 2)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/riggedlaser

/datum/design/science/mecha/weapon/laser_heavy
	design_name = "CH-LC \"Solaris\" Laser Cannon"
	id = "mech_laser_heavy"
	req_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 4)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/laser/heavy
	materials_base = list(MAT_STEEL = 10000, MAT_GLASS = 3000, MAT_DIAMOND = 2000, MAT_OSMIUM = 5000, MAT_PLASTIC = 2000)

/datum/design/science/mecha/weapon/rigged_laser_heavy
	design_name = "Jury-Rigged Emitter Cannon"
	id = "mech_laser_heavy-r"
	req_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 4, TECH_PHORON = 3, TECH_ILLEGAL = 1)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/laser/heavy/rigged
	materials_base = list(MAT_STEEL = 8000, MAT_GLASS = 4000, MAT_DIAMOND = 1500, MAT_OSMIUM = 4000, MAT_PLASTIC = 2000)

/datum/design/science/mecha/weapon/laser_xray
	design_name = "CH-XS \"Penetrator\" Laser"
	id = "mech_laser_xray"
	req_tech = list(TECH_MATERIAL = 3, TECH_COMBAT = 3, TECH_PHORON = 3, TECH_POWER = 4)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/laser/xray
	materials_base = list(MAT_STEEL = 9000, MAT_GLASS = 3000, MAT_PHORON = 1000, MAT_SILVER = 1500, MAT_GOLD = 2500, MAT_PLASTIC = 2000)

/datum/design/science/mecha/weapon/rigged_laser_xray
	design_name = "Jury-Rigged Xray Rifle"
	id = "mech_laser_xray-r"
	req_tech = list(TECH_MATERIAL = 3, TECH_COMBAT = 3, TECH_PHORON = 3, TECH_POWER = 4)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/laser/xray/rigged
	materials_base = list(MAT_STEEL = 8500, MAT_GLASS = 2500, MAT_PHORON = 1000, MAT_SILVER = 1250, MAT_GOLD = 2000, MAT_PLASTIC = 2000)

/datum/design/science/mecha/weapon/phase
	design_name = "NT-PE \"Scorpio\" Phase-Emitter"
	id = "mech_phase"
	req_tech = list(TECH_MATERIAL = 1, TECH_COMBAT = 2, TECH_MAGNET = 2)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/phase
	materials_base = list(MAT_STEEL = 6000, MAT_GLASS = 3000, MAT_PLASTIC = 3000)

/datum/design/science/mecha/weapon/ion
	design_name = "MK-IV Ion Heavy Cannon"
	id = "mech_ion"
	req_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 4)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/ion
	materials_base = list(MAT_STEEL = 15000, MAT_URANIUM = 2000, MAT_SILVER = 2000, MAT_OSMIUM = 4500, MAT_PLASTIC = 2000)

/datum/design/science/mecha/weapon/rigged_ion
	design_name = "Jury-Rigged Ion Cannon"
	id = "mech_ion-r"
	req_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 4)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/ion/rigged
	materials_base = list(MAT_STEEL = 13000, MAT_URANIUM = 1000, MAT_SILVER = 1000, MAT_OSMIUM = 3000, MAT_PLASTIC = 2000)

/datum/design/science/mecha/weapon/sound_cannon
	design_name = "H.O.N.K. Sound Cannon"
	id = "mech_soundcannon"
	req_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 4, TECH_ILLEGAL = 3)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/honker
	materials_base = list(MAT_STEEL = 13000, MAT_SILVER = 1000, MAT_OSMIUM = 3000, MAT_PLASTIC = 2000, MAT_BANANIUM = 4000)

/datum/design/science/mecha/weapon/whisper_blade
	design_name = "Reticent Whisper Blade"
	id = "mech_whisper"
	req_tech = list(TECH_COMBAT = 5, TECH_MAGNET = 4, TECH_ILLEGAL = 4)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/whisperblade
	materials_base = list(MAT_STEEL = 13000, MAT_GOLD = 1000, MAT_OSMIUM = 3000, MAT_PLASTEEL = 2000, MAT_SILENCIUM = 4000)

/datum/design/science/mecha/weapon/inferno_blade
	design_name = "Reticent Inferno Blade"
	id = "mech_inferno"
	req_tech = list(TECH_COMBAT = 5, TECH_MAGNET = 4, TECH_ILLEGAL = 4)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/infernoblade
	materials_base = list(MAT_STEEL = 13000, MAT_GOLD = 1000, MAT_LEAD = 3000, MAT_PLASTEEL = 2000, MAT_SILENCIUM = 4000)

/datum/design/science/mecha/weapon/grenade_launcher
	design_name = "SGL-6 Grenade Launcher"
	id = "mech_grenade_launcher"
	req_tech = list(TECH_COMBAT = 3)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/grenade
	materials_base = list(MAT_STEEL = 7000, MAT_GOLD = 2000, MAT_PLASTIC = 3000)

/datum/design/science/mecha/weapon/rigged_grenade_launcher
	design_name = "Jury-Rigged Pneumatic Flashlauncher"
	id = "mech_grenade_launcher-hardsuit"
	req_tech = list(TECH_COMBAT = 3)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/grenade/rigged
	materials_base = list(MAT_STEEL = 5000, MAT_GOLD = 2000, MAT_PLASTIC = 2000)

/datum/design/science/mecha/weapon/clusterbang_launcher
	design_name = "SOP-6 Grenade Launcher"
	desc = "A weapon that violates the Geneva Convention at 6 rounds per minute."
	id = "clusterbang_launcher"
	req_tech = list(TECH_COMBAT= 5, TECH_MATERIAL = 5, TECH_ILLEGAL = 3)
	materials_base = list(MAT_STEEL = 15000, MAT_GOLD = 4500, MAT_URANIUM = 4500)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/grenade/clusterbang/limited

/datum/design/science/mecha/weapon/conc_grenade_launcher
	design_name = "SGL-9 Grenade Launcher"
	id = "mech_grenade_launcher_conc"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 4, TECH_ILLEGAL = 1)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/grenade/concussion
	materials_base = list(MAT_STEEL = 9000, MAT_GOLD = 1000, MAT_OSMIUM = 1000, MAT_PLASTIC = 3000)

/datum/design/science/mecha/weapon/frag_grenade_launcher
	design_name = "HEP-MI 6 Grenade Launcher"
	id = "mech_grenade_launcher_frag"
	req_tech = list(TECH_COMBAT = 4, TECH_ENGINEERING = 2, TECH_MATERIAL = 3, TECH_ILLEGAL = 2)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/grenade/frag/mini
	materials_base = list(MAT_STEEL = 10000, MAT_GOLD = 2500, MAT_URANIUM = 3000, MAT_OSMIUM = 3000, MAT_PLASTIC = 3000)

/datum/design/science/mecha/weapon/banana_launcher
	design_name = "WSS-2 Banana Peel Launcher"
	id = "mech_banana_launcher"
	req_tech = list(TECH_COMBAT = 3, TECH_ILLEGAL = 3)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/grenade/banana
	materials_base = list(MAT_STEEL = 7000, MAT_GOLD = 2000, MAT_OSMIUM = 1000, MAT_PLASTIC = 5000, MAT_BANANIUM = 4000)

/datum/design/science/mecha/weapon/mousetrap_launcher
	design_name = "WSS-5 Mouse Trap Launcher"
	id = "mech_mousetrap_launcher"
	req_tech = list(TECH_COMBAT = 3, TECH_ILLEGAL = 3)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/grenade/mousetrap
	materials_base = list(MAT_STEEL = 7000, MAT_GOLD = 2000, MAT_OSMIUM = 1000, MAT_PLASTIC = 5000, MAT_BANANIUM = 4000)

/datum/design/science/mecha/weapon/flamer
	design_name = "CR-3 Mark 8 Flamethrower"
	desc = "A weapon that violates the CCWC at two hundred gallons per minute."
	id = "mech_flamer_full"
	req_tech = list(TECH_MATERIAL = 4, TECH_COMBAT = 6, TECH_PHORON = 4, TECH_ILLEGAL = 4)
	materials_base = list(MAT_STEEL = 10000, MAT_GOLD = 2000, MAT_URANIUM = 3000, MAT_PHORON = 8000)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/flamer

/datum/design/science/mecha/weapon/flamer_rigged
	design_name = "AA-CR-1 Mark 4 Flamethrower"
	desc = "A weapon that accidentally violates the CCWC at one hundred gallons per minute."
	id = "mech_flamer_rigged"
	req_tech = list(TECH_MATERIAL = 3, TECH_COMBAT = 3, TECH_PHORON = 3, TECH_ILLEGAL = 2)
	materials_base = list(MAT_STEEL = 8000, MAT_GOLD = 1500, MAT_SILVER = 1500, MAT_URANIUM = 2000, MAT_PHORON = 6000)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/flamer/rigged

/datum/design/science/mecha/weapon/flame_mg
	design_name = "DR-AC 3 Incendiary Rotary MG"
	desc = "A weapon that violates the CCWC at sixty rounds a minute."
	id = "mech_lmg_flamer"
	req_tech = list(TECH_MATERIAL = 4, TECH_COMBAT = 5, TECH_PHORON = 2, TECH_ILLEGAL = 1)
	materials_base = list(MAT_STEEL = 8000, MAT_GOLD = 2000, MAT_SILVER = 1750, MAT_URANIUM = 1500, MAT_PHORON = 4000)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/incendiary

// *** Nonweapon modules
/datum/design/science/mecha/wormhole_gen
	design_name = "Wormhole Generator"
	desc = "An exosuit module that can generate small quasi-stable wormholes."
	id = "mech_wormhole_gen"
	req_tech = list(TECH_BLUESPACE = 3, TECH_MAGNET = 2)
	build_path = /obj/item/mecha_parts/mecha_equipment/wormhole_generator

/datum/design/science/mecha/teleporter
	design_name = "Teleporter"
	desc = "An exosuit module that allows teleportation to any position in view."
	id = "mech_teleporter"
	req_tech = list(TECH_BLUESPACE = 10, TECH_MAGNET = 5)
	build_path = /obj/item/mecha_parts/mecha_equipment/teleporter

/datum/design/science/mecha/rcd
	design_name = "RCD"
	desc = "An exosuit-mounted rapid construction device."
	id = "mech_rcd"
	work = (120 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 20000, MAT_PLASTIC = 10000, MAT_PHORON = 18750, MAT_SILVER = 15000, MAT_GOLD = 15000)
	req_tech = list(TECH_MATERIAL = 4, TECH_BLUESPACE = 3, TECH_MAGNET = 4, TECH_POWER = 4, TECH_ENGINEERING = 4)
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/rcd

/datum/design/science/mecha/gravcatapult
	design_name = "Gravitational Catapult"
	desc = "An exosuit-mounted gravitational catapult."
	id = "mech_gravcatapult"
	req_tech = list(TECH_BLUESPACE = 2, TECH_MAGNET = 3, TECH_ENGINEERING = 3)
	build_path = /obj/item/mecha_parts/mecha_equipment/gravcatapult

/datum/design/science/mecha/repair_droid
	design_name = "Repair Droid"
	desc = "Automated repair droid, exosuits' best companion. BEEP BOOP"
	id = "mech_repair_droid"
	req_tech = list(TECH_MAGNET = 3, TECH_DATA = 3, TECH_ENGINEERING = 3)
	materials_base = list(MAT_STEEL = 7500, MAT_GOLD = 750, MAT_SILVER = 1500, MAT_GLASS = 3750)
	build_path = /obj/item/mecha_parts/mecha_equipment/repair_droid

/datum/design/science/mecha/shield_drone
	design_name = "Shield Drone"
	desc = "Manual shield drone. Deploys a large, familiar, and rectangular shield in one direction at a time."
	id = "mech_shield_droid"
	req_tech = list(TECH_PHORON = 3, TECH_MAGNET = 6, TECH_ILLEGAL = 4)
	materials_base = list(MAT_STEEL = 8000, MAT_GOLD = 2000, MAT_SILVER = 3000, MAT_PHORON = 5000, MAT_GLASS = 3750)
	build_path = /obj/item/mecha_parts/mecha_equipment/combat_shield

/datum/design/science/mecha/reticent_shield_drone
	design_name = "Reticent Wall Projector"
	desc = "A Le Rien specialty shield drone. Deploys a translucent rectangular shield in one direction."
	id = "mech_reticent_shield_droid"
	req_tech = list(TECH_PHORON = 3, TECH_MAGNET = 6, TECH_ILLEGAL = 4)
	materials_base = list(MAT_STEEL = 8000, MAT_OSMIUM = 4000, MAT_SILVER = 3000, MAT_SILENCIUM = 10000, MAT_GLASS = 3750)
	build_path = /obj/item/mecha_parts/mecha_equipment/combat_shield/reticent

/datum/design/science/mecha/crisis_drone
	design_name = "Crisis Drone"
	desc = "Deploys a small medical drone capable of patching small wounds in order to stabilize nearby patients."
	id = "mech_med_droid"
	req_tech = list(TECH_PHORON = 3, TECH_MAGNET = 6, TECH_BIO = 5, TECH_DATA = 4, TECH_ARCANE = 1)
	materials_base = list(MAT_STEEL = 8000, MAT_GOLD = 2000, MAT_SILVER = 3000, MAT_VERDANTIUM = 2500, MAT_GLASS = 3000)
	build_path = /obj/item/mecha_parts/mecha_equipment/crisis_drone

/datum/design/science/mecha/rad_drone
	design_name = "Hazmat Drone"
	desc = "Deploys a small hazmat drone capable of purging minor radiation damage in order to stabilize nearby patients."
	id = "mech_rad_droid"
	req_tech = list(TECH_PHORON = 4, TECH_MAGNET = 5, TECH_BIO = 6, TECH_DATA = 4, TECH_ARCANE = 1)
	materials_base = list(MAT_STEEL = 8000, MAT_GOLD = 2000, MAT_URANIUM = 3000, MAT_VERDANTIUM = 2500, MAT_GLASS = 3000)
	build_path = /obj/item/mecha_parts/mecha_equipment/crisis_drone/rad

/datum/design/science/mecha/medanalyzer
	design_name = "Mounted Body Scanner"
	desc = "An advanced mech-mounted device that is not quite as powerful as a stationary body scanner, though still suitably powerful."
	id = "mech_med_analyzer"
	req_tech = list(TECH_PHORON = 4, TECH_MAGNET = 5, TECH_BIO = 5, TECH_DATA = 4)
	materials_base = list(MAT_PLASTEEL = 4500, MAT_GOLD = 2000, MAT_URANIUM = 3000, MAT_GLASS = 3000)
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/powertool/medanalyzer

/datum/design/science/mecha/jetpack
	design_name = "Ion Jetpack"
	desc = "Using directed ion bursts and cunning solar wind reflection technique, this device enables controlled space flight."
	id = "mech_jetpack"
	req_tech = list(TECH_ENGINEERING = 3, TECH_MAGNET = 4) //One less magnet than the actual got-damn teleporter.
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/jetpack
	materials_base = list(MAT_STEEL = 7500, MAT_SILVER = 300, MAT_GLASS = 600)

/datum/design/science/mecha/phoron_generator
	desc = "Phoron Reactor"
	id = "mech_phoron_generator"
	req_tech = list(TECH_PHORON = 2, TECH_POWER= 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/mecha_parts/mecha_equipment/generator
	materials_base = list(MAT_STEEL = 7500, MAT_SILVER = 375, MAT_GLASS = 750)

/datum/design/science/mecha/energy_relay
	design_name = "Energy Relay"
	id = "mech_energy_relay"
	req_tech = list(TECH_MAGNET = 4, TECH_POWER = 3)
	materials_base = list(MAT_STEEL = 7500, MAT_GOLD = 1500, MAT_SILVER = 2250, MAT_GLASS = 1500)
	build_path = /obj/item/mecha_parts/mecha_equipment/tesla_energy_relay

/datum/design/science/mecha/ccw_armor
	design_name = "CCW Armor Booster"
	desc = "Exosuit close-combat armor booster."
	id = "mech_ccw_armor"
	req_tech = list(TECH_MATERIAL = 5, TECH_COMBAT = 4)
	materials_base = list(MAT_STEEL = 11250, MAT_SILVER = 3750)
	build_path = /obj/item/mecha_parts/mecha_equipment/anticcw_armor_booster

/datum/design/science/mecha/proj_armor
	design_name = "Ranged Armor Booster"
	desc = "Exosuit projectile armor booster."
	id = "mech_proj_armor"
	req_tech = list(TECH_MATERIAL = 5, TECH_COMBAT = 5, TECH_ENGINEERING = 3)
	materials_base = list(MAT_STEEL = 15000, MAT_GOLD = 3750)
	build_path = /obj/item/mecha_parts/mecha_equipment/antiproj_armor_booster

/datum/design/science/mecha/diamond_drill
	design_name = "Diamond Drill"
	desc = "A diamond version of the exosuit drill. It's harder, better, faster, stronger."
	id = "mech_diamond_drill"
	req_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 3)
	materials_base = list(MAT_STEEL = 7500, MAT_DIAMOND = 4875)
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/drill/diamonddrill

/datum/design/science/mecha/ground_drill
	design_name = "Surface Bore"
	desc = "A heavy duty bore. Bigger, better, stronger than the core sampler, but not quite as good as a large drill."
	id = "mech_ground_drill"
	req_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 2, TECH_PHORON = 1)
	materials_base = list(MAT_STEEL = 7000, MAT_SILVER = 3000, MAT_PHORON = 2000)
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/drill/bore

/datum/design/science/mecha/orescanner
	design_name = "Ore Scanner"
	desc = "A hefty device used to scan for subterranean veins of ore."
	id = "mech_ore_scanner"
	req_tech = list(TECH_MATERIAL = 2, TECH_MAGNET = 2, TECH_POWER = 2)
	materials_base = list(MAT_STEEL = 4000, MAT_GLASS = 1000)
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/orescanner

/datum/design/science/mecha/advorescanner
	design_name = "Advanced Ore Scanner"
	desc = "A hefty device used to scan for the exact volumes of subterranean veins of ore."
	id = "mech_ore_scanner_adv"
	req_tech = list(TECH_MATERIAL = 5, TECH_MAGNET = 4, TECH_POWER = 4, TECH_BLUESPACE = 2)
	materials_base = list(MAT_STEEL = 5000, MAT_OSMIUM = 3000, MAT_SILVER = 1000)
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/orescanner/advanced

/datum/design/science/mecha/powerwrench
	design_name = "hydraulic wrench"
	desc = "A large, hydraulic wrench."
	id = "mech_wrench"
	req_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2, TECH_POWER = 2)
	materials_base = list(MAT_STEEL = 5000, MAT_PLASTIC = 2000, MAT_GLASS = 1250)
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/powertool

/datum/design/science/mecha/powercrowbar
	design_name = "hydraulic prybar"
	desc = "A large, hydraulic prybar."
	id = "mech_crowbar"
	req_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2, TECH_POWER = 2)
	materials_base = list(MAT_STEEL = 4000, MAT_OSMIUM = 3000, MAT_GLASS = 1000)
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/powertool/prybar

/datum/design/science/mecha/generator_nuclear
	design_name = "Nuclear Reactor"
	desc = "Exosuit-held nuclear reactor. Converts uranium and everyone's health to energy."
	id = "mech_generator_nuclear"
	req_tech = list(TECH_POWER= 3, TECH_ENGINEERING = 3, TECH_MATERIAL = 3)
	materials_base = list(MAT_STEEL = 7500, MAT_SILVER = 375, MAT_GLASS = 750)
	build_path = /obj/item/mecha_parts/mecha_equipment/generator/nuclear

/datum/design/science/mecha/speedboost_ripley
	design_name = "Ripley Leg Actuator Overdrive"
	desc = "System enhancements and overdrives to make a mech's legs move faster."
	id = "mech_speedboost_ripley"
	req_tech = list(TECH_POWER = 5, TECH_MATERIAL = 4, TECH_ENGINEERING = 4)
	materials_base = list(MAT_STEEL = 10000, MAT_SILVER = 1000, MAT_GOLD = 1000)
	build_path = /obj/item/mecha_parts/mecha_equipment/speedboost

/datum/design/science/synthetic_flash
	design_name = "Synthetic Flash"
	id = "sflash"
	req_tech = list(TECH_MAGNET = 3, TECH_COMBAT = 2)
	lathe_type = LATHE_TYPE_MECHA
	materials_base = list(MAT_STEEL = 562, MAT_GLASS = 562)
	build_path = /obj/item/flash/synthetic
	category = list("Misc")

/*
* Printable Internal Components
*/

/datum/design/science/mecha_component
	design_name = "Mecha Actuator"
	id = "mactuator"
	req_tech = list(TECH_ENGINEERING = 3, TECH_MATERIAL = 2)
	lathe_type = LATHE_TYPE_MECHA
	materials_base = list(MAT_STEEL = 5000, MAT_GLASS = 2500)
	build_path = /obj/item/mecha_parts/component/actuator
	category = list("Components")

/datum/design/science/mecha_component/actuator_high
	design_name = "Mecha Actuator - High Speed"
	id = "mactuatorhigh"
	req_tech = list(TECH_ENGINEERING = 5, TECH_MATERIAL = 6)
	materials_base = list(MAT_STEEL = 7000, MAT_GLASS = 4000, MAT_GOLD = 10000)
	build_path = /obj/item/mecha_parts/component/actuator/hispeed

/datum/design/science/mecha_component/armor
	design_name = "Mecha Plating"
	id = "marmor"
	req_tech = list(TECH_ENGINEERING = 3, TECH_MATERIAL = 3)
	materials_base = list(MAT_STEEL = 10000, MAT_GLASS = 2000)
	build_path = /obj/item/mecha_parts/component/armor

/datum/design/science/mecha_component/armor/blast
	design_name = "Mecha Plating - Blast Resistant"
	id = "marmorblast"
	req_tech = list(TECH_ENGINEERING = 5, TECH_MATERIAL = 4)
	materials_base = list(MAT_STEEL = 15000, MAT_GLASS = 500, MAT_PLASTEEL = 2000)
	build_path = /obj/item/mecha_parts/component/armor/mining

/datum/design/science/mecha_component/armor/lightweight
	design_name = "Mecha Plating - Lightweight"
	id = "marmorlight"
	req_tech = list(TECH_ENGINEERING = 5, TECH_MATERIAL = 6)
	materials_base = list(MAT_STEEL = 7000, MAT_PLASTIC = 5000, MAT_GOLD = 2000)
	build_path = /obj/item/mecha_parts/component/armor/lightweight

/datum/design/science/mecha_component/armor/reinforced
	design_name = "Mecha Plating - Reinforced"
	id = "marmorreinf"
	req_tech = list(TECH_ENGINEERING = 5, TECH_MATERIAL = 6, TECH_COMBAT = 5)
	materials_base = list(MAT_STEEL = 15000, MAT_PLASTEEL = 5000, MAT_URANIUM = 5000)
	build_path = /obj/item/mecha_parts/component/armor/reinforced

/datum/design/science/mecha_component/electrical
	design_name = "Mecha Electrical Harness"
	id = "melectrical"
	req_tech = list(TECH_ENGINEERING = 3, TECH_POWER = 3)
	materials_base = list(MAT_STEEL = 5000, MAT_GLASS = 2000, MAT_PLASTIC = 1000)
	build_path = /obj/item/mecha_parts/component/electrical

/datum/design/science/mecha_component/electrical/high_current
	design_name = "Mecha Electrical Harness - High Current"
	id = "melectricalhigh"
	req_tech = list(TECH_ENGINEERING = 5, TECH_POWER = 5, TECH_MATERIAL = 4)
	materials_base = list(MAT_STEEL = 3000, MAT_GLASS = 4000, MAT_PLASTIC = 5000, MAT_GOLD = 5000)
	build_path = /obj/item/mecha_parts/component/electrical

/datum/design/science/mecha_component/hull
	design_name = "Mecha Hull"
	id = "mhull"
	req_tech = list(TECH_ENGINEERING = 3, TECH_MATERIAL = 2)
	materials_base = list(MAT_STEEL = 7000, MAT_GLASS = 500)
	build_path = /obj/item/mecha_parts/component/hull

/datum/design/science/mecha_component/hull/durable
	design_name = "Mecha Hull - Durable"
	id = "mhulldura"
	req_tech = list(TECH_ENGINEERING = 4, TECH_MATERIAL = 4)
	materials_base = list(MAT_STEEL = 7000, MAT_GLASS = 500, MAT_PLASTEEL = 10000)
	build_path = /obj/item/mecha_parts/component/hull/durable

/datum/design/science/mecha_component/hull/lightweight
	design_name = "Mecha Hull - Lightweight"
	id = "mhulllight"
	req_tech = list(TECH_ENGINEERING = 5, TECH_MATERIAL = 5)
	materials_base = list(MAT_STEEL = 5000, MAT_GLASS = 500, MAT_PLASTIC = 3000)
	build_path = /obj/item/mecha_parts/component/hull/lightweight

/datum/design/science/mecha_component/gas
	design_name = "Mecha Life-Support"
	id = "mgas"
	req_tech = list(TECH_ENGINEERING = 3, TECH_MATERIAL = 2, TECH_BIO = 3)
	materials_base = list(MAT_STEEL = 2000, MAT_GLASS = 3000)
	build_path = /obj/item/mecha_parts/component/gas

/datum/design/science/mecha_component/gas/reinforced
	design_name = "Mecha Life-Support - Reinforced"
	id = "mgasreinf"
	req_tech = list(TECH_ENGINEERING = 4, TECH_MATERIAL = 3, TECH_BIO = 5)
	materials_base = list(MAT_STEEL = 5000, MAT_GLASS = 3000, MAT_SILVER = 4000)
	build_path = /obj/item/mecha_parts/component/gas/reinforced

/*
 * Non-Mech Vehicles
 */

/datum/design/science/mechfab/vehicle
	abstract_type = /datum/design/science/mechfab/vehicle
	lathe_type = LATHE_TYPE_MECHA
	category = list("Vehicle")
	req_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 6)

/datum/design/science/mechfab/vehicle/spacebike_chassis
	design_name = "Spacebike Chassis"
	desc = "A space-bike's un-assembled frame."
	id = "vehicle_chassis_spacebike"
	req_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 6, TECH_BLUESPACE = 3, TECH_PHORON = 3)
	materials_base = list(MAT_STEEL = 12000, MAT_SILVER = 3000, MAT_PHORON = 3000, MAT_OSMIUM = 1000)
	build_path = /obj/item/vehicle_assembly/spacebike

/datum/design/science/mechfab/vehicle/quadbike_chassis
	design_name = "Quadbike Chassis"
	desc = "A space-bike's un-assembled frame."
	id = "vehicle_chassis_quadbike"
	req_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 6, TECH_MAGNET = 3, TECH_POWER = 2)
	materials_base = list(MAT_STEEL = 15000, MAT_SILVER = 3000, MAT_PLASTIC = 3000, MAT_OSMIUM = 1000)
	build_path = /obj/item/vehicle_assembly/quadbike

/*
/datum/design/science/mechfab/uav/basic
	design_name = "UAV - Recon Skimmer"
	id = "recon_skimmer"
	build_path = /obj/item/uav
	work = (20 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	req_tech = list(TECH_MATERIAL = 6, TECH_ENGINEERING = 5, TECH_PHORON = 3, TECH_MAGNET = 4, TECH_POWER = 6)
	materials_base = list(MAT_STEEL = 10000, MAT_GLASS = 6000, MAT_SILVER = 4000)
*/

///--------///
///Fighters///
///--------///

/datum/design/science/mechfab/fighter
	abstract_type = /datum/design/science/mechfab/fighter

///Pinnace///

/datum/design/science/mechfab/fighter/pinnace
	abstract_type = /datum/design/science/mechfab/fighter/pinnace
	category = list("Pinnace")

/datum/design/science/mechfab/fighter/pinnace/chassis
	design_name = "Pinnace Chassis"
	id = "pinnace_chassis"
	build_path = /obj/item/mecha_parts/fighter/chassis/pinnace
	work = 3 * 30
	materials_base = list(MAT_STEEL = 25000, MAT_GLASS = 10000, MAT_PLASTEEL = 10000)

/datum/design/science/mechfab/fighter/pinnace/core
	design_name = "Pinnace Core"
	id = "pinnace_core"
	build_path = /obj/item/mecha_parts/fighter/part/pinnace_core
	work = 3 * 60
	materials_base = list(MAT_STEEL = 25000, MAT_GLASS = 7000, MAT_PLASTEEL = 7000)

/datum/design/science/mechfab/fighter/pinnace/cockpit
	design_name = "Pinnace Cockpit"
	id = "pinnace_cockpit"
	build_path = /obj/item/mecha_parts/fighter/part/pinnace_cockpit
	work = 3 * 15
	materials_base = list(MAT_STEEL = 2500, MAT_PLASTEEL = 2500, MAT_GLASS = 7500, MAT_PLASTIC = 2500)

/datum/design/science/mechfab/fighter/pinnace/main_engine
	design_name = "Pinnace Main Engine"
	id = "pinnace_main_engine"
	build_path = /obj/item/mecha_parts/fighter/part/pinnace_main_engine
	work = 3 * 25
	materials_base = list(MAT_STEEL = 15000, MAT_PLASTEEL = 5000)

/datum/design/science/mechfab/fighter/pinnace/left_engine
	design_name = "Pinnace Left Engine"
	id = "pinnace_left_engine"
	build_path = /obj/item/mecha_parts/fighter/part/pinnace_left_engine
	work = 3 * 25
	materials_base = list(MAT_STEEL = 10000, MAT_PLASTEEL = 2500)

/datum/design/science/mechfab/fighter/pinnace/right_engine
	design_name = "Pinnace Right Engine"
	id = "pinnace_right_engine"
	build_path = /obj/item/mecha_parts/fighter/part/pinnace_right_engine
	work = 3 * 25
	materials_base = list(MAT_STEEL = 10000, MAT_PLASTEEL = 2500)

/datum/design/science/mechfab/fighter/pinnace/left_wing
	design_name = "Pinnace Left Wing"
	id = "pinnace_left_wing"
	build_path = /obj/item/mecha_parts/fighter/part/pinnace_left_wing
	work = 3 * 20
	materials_base = list(MAT_STEEL = 7000, MAT_PLASTIC = 3000, MAT_PLASTEEL = 5000)

/datum/design/science/mechfab/fighter/pinnace/right_wing
	design_name = "Pinnace Right Wing"
	id = "pinnace_right_wing"
	build_path = /obj/item/mecha_parts/fighter/part/pinnace_right_wing
	work = 3 * 20
	materials_base = list(MAT_STEEL = 7000, MAT_PLASTIC = 3000, MAT_PLASTEEL = 5000)


///Baron///

/datum/design/science/mechfab/fighter/baron
	abstract_type = /datum/design/science/mechfab/fighter/baron
	category = list("Baron")

/datum/design/science/mechfab/fighter/baron/chassis
	design_name = "Baron Chassis"
	id = "baron_chassis"
	build_path = /obj/item/mecha_parts/fighter/chassis/baron
	work = 3 * 30
	materials_base = list(MAT_STEEL = 37500, MAT_GLASS = 15000, MAT_PLASTEEL = 15000)

/datum/design/science/mechfab/fighter/baron/core
	design_name = "Baron Core"
	id = "baron_core"
	build_path = /obj/item/mecha_parts/fighter/part/baron_core
	work = 3 * 60
	materials_base = list(MAT_STEEL = 37500, MAT_GLASS = 15000, MAT_PLASTEEL = 15000)

/datum/design/science/mechfab/fighter/baron/cockpit
	design_name = "Baron Cockpit"
	id = "baron_cockpit"
	build_path = /obj/item/mecha_parts/fighter/part/baron_cockpit
	work = 3 * 15
	materials_base = list(MAT_STEEL = 5000, MAT_PLASTEEL = 5000, MAT_GLASS = 10000, MAT_PLASTIC = 5000)

/datum/design/science/mechfab/fighter/baron/main_engine
	design_name = "Baron Main Engine"
	id = "baron_main_engine"
	build_path = /obj/item/mecha_parts/fighter/part/baron_main_engine
	work = 3 * 25
	materials_base = list(MAT_STEEL = 25000, MAT_PLASTEEL = 10000)

/datum/design/science/mechfab/fighter/baron/left_engine
	design_name = "Baron Left Engine"
	id = "baron_left_engine"
	build_path = /obj/item/mecha_parts/fighter/part/baron_left_engine
	work = 3 * 25
	materials_base = list(MAT_STEEL = 20000, MAT_PLASTEEL = 5000)

/datum/design/science/mechfab/fighter/baron/right_engine
	design_name = "Baron Right Engine"
	id = "baron_right_engine"
	build_path = /obj/item/mecha_parts/fighter/part/baron_right_engine
	work = 3 * 25
	materials_base = list(MAT_STEEL = 20000, MAT_PLASTEEL = 5000)

/datum/design/science/mechfab/fighter/baron/left_wing
	design_name = "Baron Left Wing"
	id = "baron_left_wing"
	build_path = /obj/item/mecha_parts/fighter/part/baron_left_wing
	work = 3 * 20
	materials_base = list(MAT_STEEL = 15000, MAT_PLASTIC = 6000, MAT_PLASTEEL = 10000)

/datum/design/science/mechfab/fighter/baron/right_wing
	design_name = "Baron Right Wing"
	id = "baron_right_wing"
	build_path = /obj/item/mecha_parts/fighter/part/baron_right_wing
	work = 3 * 20
	materials_base = list(MAT_STEEL = 15000, MAT_PLASTIC = 6000, MAT_PLASTEEL = 10000)


///Duke///

/datum/design/science/mechfab/fighter/duke
	abstract_type = /datum/design/science/mechfab/fighter/duke
	category = list("Duke")

/datum/design/science/mechfab/fighter/duke/chassis
	design_name = "Duke Chassis"
	id = "duke_chassis"
	build_path = /obj/item/mecha_parts/fighter/chassis/duke
	work = 3 * 30
	materials_base = list(MAT_STEEL = 37500, MAT_GLASS = 15000, MAT_PLASTEEL = 20000)

/datum/design/science/mechfab/fighter/duke/core
	design_name = "Duke Core"
	id = "duke_core"
	build_path = /obj/item/mecha_parts/fighter/part/duke_core
	work = 3 * 60
	materials_base = list(MAT_STEEL = 37500, MAT_GLASS = 10000, MAT_PLASTEEL = 20000)

/datum/design/science/mechfab/fighter/duke/cockpit
	design_name = "Duke Cockpit"
	id = "duke_cockpit"
	build_path = /obj/item/mecha_parts/fighter/part/duke_cockpit
	work = 3 * 15
	materials_base = list(MAT_STEEL = 5000, MAT_GLASS = 2500, MAT_PLASTEEL = 5000, MAT_PLASTIC = 5000)

/datum/design/science/mechfab/fighter/duke/main_engine
	design_name = "Duke Main Engine"
	id = "duke_main_engine"
	build_path = /obj/item/mecha_parts/fighter/part/duke_main_engine
	work = 3 * 25
	materials_base = list(MAT_STEEL = 25000, MAT_PLASTEEL = 15000)

/datum/design/science/mechfab/fighter/duke/left_engine
	design_name = "Duke Left Engine"
	id = "duke_left_engine"
	build_path = /obj/item/mecha_parts/fighter/part/duke_left_engine
	work = 3 * 25
	materials_base = list(MAT_STEEL = 20000, MAT_PLASTEEL = 10000)

/datum/design/science/mechfab/fighter/duke/right_engine
	design_name = "Duke Right Engine"
	id = "duke_right_engine"
	build_path = /obj/item/mecha_parts/fighter/part/duke_right_engine
	work = 3 * 25
	materials_base = list(MAT_STEEL = 20000, MAT_PLASTEEL = 10000)

/datum/design/science/mechfab/fighter/duke/left_wing
	design_name = "Duke Left Wing"
	id = "duke_left_wing"
	build_path = /obj/item/mecha_parts/fighter/part/duke_left_wing
	work = 3 * 20
	materials_base = list(MAT_STEEL = 10000, MAT_PLASTIC = 5000, MAT_PLASTEEL = 20000)

/datum/design/science/mechfab/fighter/duke/right_wing
	design_name = "Duke Right Wing"
	id = "duke_right_wing"
	build_path = /obj/item/mecha_parts/fighter/part/duke_right_wing
	work = 3 * 20
	materials_base = list(MAT_STEEL = 10000, MAT_PLASTIC = 5000, MAT_PLASTEEL = 20000)
