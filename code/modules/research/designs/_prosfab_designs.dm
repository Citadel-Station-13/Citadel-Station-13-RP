/datum/prototype/design/science/prosfab
	abstract_type = /datum/prototype/design/science/prosfab
	lathe_type = LATHE_TYPE_PROSTHETICS
	req_tech = list(TECH_MATERIAL = 1)

/datum/prototype/design/science/prosfab/pros
	abstract_type = /datum/prototype/design/science/prosfab/pros
	category = "Prosthetics"

// Make new external organs and make 'em robotish
/datum/prototype/design/science/prosfab/pros/lathe_print(atom/where, amount, list/material_parts, list/ingredient_parts, list/reagent_parts, obj/machinery/lathe/fabricator, cost_multiplier = 1)
	if(istype(fabricator, /obj/machinery/lathe/mecha_part_fabricator/pros))
		var/obj/machinery/lathe/mecha_part_fabricator/pros/prosfab = fabricator
		var/obj/item/organ/O = new build_path(where)
		if(!istype(O))
			return O
		if(subcategory)
			var/datum/robolimb/manf = GLOB.all_robolimbs[subcategory]

			if(!(O.organ_tag in manf.parts))	// Make sure we're using an actually present icon.
				manf = GLOB.all_robolimbs["Unbranded"]

			if(prosfab.species in manf.species_alternates)	// If the prosthetics fab is set to say, Unbranded, and species set to 'Tajaran', it will make the Taj variant of Unbranded, if it exists.
				manf = manf.species_alternates[prosfab.species]

			if(!prosfab.species || (prosfab.species in manf.species_cannot_use))	// Fabricator ensures the manufacturer can make parts for the species we're set to.
				O.species = SScharacters.resolve_species_name(manf.suggested_species)
			else
				O.species = SScharacters.resolve_species_name(prosfab.species)
		else
			O.species = SScharacters.resolve_species_path(/datum/species/human)
		O.robotize(subcategory ? subcategory : null)
		O.dna = new/datum/dna() //Uuughhhh... why do I have to do this?
		O.dna.ResetUI()
		O.dna.ResetSE()
		spawn(10) //Limbs love to flop around. Who am I to deny them?
			O.dir = 2
		return O
	return ..()

// Deep Magic for the torso since it needs to be a new mob
/datum/prototype/design/science/prosfab/pros/torso/lathe_print(atom/where, amount, list/material_parts, list/ingredient_parts, list/reagent_parts, obj/machinery/lathe/fabricator, cost_multiplier = 1)
	if(istype(fabricator, /obj/machinery/lathe/mecha_part_fabricator/pros))
		var/obj/machinery/lathe/mecha_part_fabricator/pros/prosfab = fabricator
		var/newspecies = SPECIES_HUMAN

		var/datum/robolimb/manf = GLOB.all_robolimbs[subcategory]

		if(manf)
			if(prosfab.species in manf.species_alternates)	// If the prosthetics fab is set to say, Unbranded, and species set to 'Tajaran', it will make the Taj variant of Unbranded, if it exists.
				manf = manf.species_alternates[prosfab.species]

			if(!prosfab.species || (prosfab.species in manf.species_cannot_use))
				newspecies = manf.suggested_species
			else
				newspecies = prosfab.species

		var/mob/living/carbon/human/H = new(where,newspecies)
		H.set_stat(DEAD)
		H.gender = gender
		for(var/obj/item/organ/external/EO in H.organs)
			if(EO.organ_tag == BP_TORSO || EO.organ_tag == BP_GROIN)
				continue //Roboticizing a torso does all the children and wastes time, do it later
			else
				EO.remove_rejuv()

		for(var/obj/item/organ/external/O in H.organs)
			O.species = SScharacters.resolve_species_name(newspecies)

			if(!(O.organ_tag in manf.parts))	// Make sure we're using an actually present icon.
				manf = GLOB.all_robolimbs["Unbranded"]

			O.robotize(manf.company)
			O.dna = new/datum/dna()
			O.dna.ResetUI()
			O.dna.ResetSE()

			// Skincolor weirdness.
			O.s_col[1] = 0
			O.s_col[2] = 0
			O.s_col[3] = 0

		// Resetting the UI does strange things for the skin of a non-human robot, which should be controlled by a whole different thing.
		H.r_skin = 0
		H.g_skin = 0
		H.b_skin = 0
		H.dna.ResetUIFrom(H)

		H.real_name = "Synthmorph #[rand(100,999)]"
		H.name = H.real_name
		H.dir = 2
		H.add_language(LANGUAGE_EAL)
		return H

//////////////////// Prosthetics ////////////////////
/datum/prototype/design/science/prosfab/pros/torso
	abstract_type = /datum/prototype/design/science/prosfab/pros/torso
	work = (35 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 7500, MAT_GLASS = 1500)
//	req_tech = list(TECH_ENGINEERING = 2, TECH_MATERIAL = 3, TECH_DATA = 3)	//Saving the values just in case
	var/gender = MALE
	category = DESIGN_CATEGORY_PROSTHETIC



/datum/prototype/design/science/prosfab/pros/torso/male
	design_name = "FBP Torso (M)"
	id = "pros_torso_m"
	build_path = /obj/item/organ/external/chest
	gender = MALE
	subcategory = "Unbranded"

/obj/item/organ/external/chest/f //To satisfy CI. :|

/datum/prototype/design/science/prosfab/pros/torso/female
	design_name = "FBP Torso (F)"
	id = "pros_torso_f"
	build_path = /obj/item/organ/external/chest/f
	gender = FEMALE
	subcategory = "Unbranded"

/datum/prototype/design/science/prosfab/pros/head
	design_name = "Prosthetic Head"
	id = "pros_head"
	build_path = /obj/item/organ/external/head
	work = (30 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 2500, MAT_GLASS = 750)
	subcategory = "Unbranded"
//	req_tech = list(TECH_ENGINEERING = 2, TECH_MATERIAL = 3, TECH_DATA = 3)	//Saving the values just in case

/datum/prototype/design/science/prosfab/pros/l_arm
	design_name = "Prosthetic Left Arm"
	id = "pros_l_arm"
	build_path = /obj/item/organ/external/arm
	work = (20 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 3500)
	subcategory = "Unbranded"

/datum/prototype/design/science/prosfab/pros/l_hand
	design_name = "Prosthetic Left Hand"
	id = "pros_l_hand"
	build_path = /obj/item/organ/external/hand
	work = (15 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 750)
	subcategory = "Unbranded"

/datum/prototype/design/science/prosfab/pros/r_arm
	design_name = "Prosthetic Right Arm"
	id = "pros_r_arm"
	build_path = /obj/item/organ/external/arm/right
	work = (20 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 3500)
	subcategory = "Unbranded"

/datum/prototype/design/science/prosfab/pros/r_hand
	design_name = "Prosthetic Right Hand"
	id = "pros_r_hand"
	build_path = /obj/item/organ/external/hand/right
	work = (15 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 750)
	subcategory = "Unbranded"

/datum/prototype/design/science/prosfab/pros/l_leg
	design_name = "Prosthetic Left Leg"
	id = "pros_l_leg"
	build_path = /obj/item/organ/external/leg
	work = (20 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 4500)
	subcategory = "Unbranded"

/datum/prototype/design/science/prosfab/pros/l_foot
	design_name = "Prosthetic Left Foot"
	id = "pros_l_foot"
	build_path = /obj/item/organ/external/foot
	work = (15 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 750)
	subcategory = "Unbranded"

/datum/prototype/design/science/prosfab/pros/r_leg
	design_name = "Prosthetic Right Leg"
	id = "pros_r_leg"
	build_path = /obj/item/organ/external/leg/right
	work = (20 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 4500)
	subcategory = "Unbranded"

/datum/prototype/design/science/prosfab/pros/r_foot
	design_name = "Prosthetic Right Foot"
	id = "pros_r_foot"
	build_path = /obj/item/organ/external/foot/right
	work = (15 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 750)
	subcategory = "Unbranded"

/datum/prototype/design/science/prosfab/pros/internal
	abstract_type = /datum/prototype/design/science/prosfab/pros/internal
	category = "Prosthetics, Internal"

/datum/prototype/design/science/prosfab/pros/internal/cell
	design_name = "Prosthetic Powercell"
	id = "pros_cell"
	build_path = /obj/item/organ/internal/cell
	work = (15 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 750, MAT_GLASS = 300)
//	req_tech = list(TECH_ENGINEERING = 2, TECH_MATERIAL = 2)

/datum/prototype/design/science/prosfab/pros/internal/eyes
	design_name = "Prosthetic Eyes"
	id = "pros_eyes"
	build_path = /obj/item/organ/internal/eyes/robot
	work = (15 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 562, MAT_GLASS = 562)
//	req_tech = list(TECH_ENGINEERING = 2, TECH_MATERIAL = 2)

/datum/prototype/design/science/prosfab/pros/internal/hydraulic
	design_name = "Hydraulic Hub"
	id = "pros_hydraulic"
	build_path = /obj/item/organ/internal/heart/machine
	work = (15 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 750, MAT_PLASTIC = 300)

/datum/prototype/design/science/prosfab/pros/internal/reagcycler
	design_name = "Reagent Cycler"
	id = "pros_reagcycler"
	build_path = /obj/item/organ/internal/stomach/machine
	work = (15 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 750, MAT_PLASTIC = 300)

/datum/prototype/design/science/prosfab/pros/internal/heatsink
	design_name = "Heatsink"
	id = "pros_heatsink"
	build_path = /obj/item/organ/internal/robotic/heatsink
	work = (15 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 750, MAT_PLASTIC = 300)

/datum/prototype/design/science/prosfab/pros/internal/diagnostic
	design_name = "Diagnostic Controller"
	id = "pros_diagnostic"
	build_path = /obj/item/organ/internal/robotic/diagnostic
	work = (15 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 750, MAT_PLASTIC = 300)

/datum/prototype/design/science/prosfab/pros/internal/heart
	design_name = "Prosthetic Heart"
	id = "pros_heart"
	build_path = /obj/item/organ/internal/heart
	work = (15 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 562, MAT_GLASS = 100)
//	req_tech = list(TECH_ENGINEERING = 2, TECH_MATERIAL = 2)

/datum/prototype/design/science/prosfab/pros/internal/lungs
	design_name = "Prosthetic Lungs"
	id = "pros_lung"
	build_path = /obj/item/organ/internal/lungs
	work = (15 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 562, MAT_GLASS = 100)
//	req_tech = list(TECH_ENGINEERING = 2, TECH_MATERIAL = 2)

/datum/prototype/design/science/prosfab/pros/internal/liver
	design_name = "Prosthetic Liver"
	id = "pros_liver"
	build_path = /obj/item/organ/internal/liver
	work = (15 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 562, MAT_GLASS = 100)
//	req_tech = list(TECH_ENGINEERING = 2, TECH_MATERIAL = 2)

/datum/prototype/design/science/prosfab/pros/internal/kidneys
	design_name = "Prosthetic Kidneys"
	id = "pros_kidney"
	build_path = /obj/item/organ/internal/kidneys
	work = (15 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 562, MAT_GLASS = 100)
//	req_tech = list(TECH_ENGINEERING = 2, TECH_MATERIAL = 2)

/datum/prototype/design/science/prosfab/pros/internal/spleen
	design_name = "Prosthetic Spleen"
	id = "pros_spleen"
	build_path = /obj/item/organ/internal/spleen
	work = (15 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 300, MAT_GLASS = 750)
//	req_tech = list(TECH_ENGINEERING = 2, TECH_MATERIAL = 2)

/datum/prototype/design/science/prosfab/pros/internal/larynx
	design_name = "Prosthetic Larynx"
	id = "pros_larynx"
	build_path = /obj/item/organ/internal/voicebox
	work = (15 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 500, MAT_GLASS = 750, MAT_PLASTIC = 500)

/datum/prototype/design/science/prosfab/pros/internal/backup_battery
	design_name = "Synthetic Back-Up Battery"
	id = "synth_backup_battery"
	build_path = /obj/item/fbp_backup_cell
	work = (10 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 500, MAT_GLASS = 150)
//////////////// Cybernetic Augments //////////////////

/datum/prototype/design/science/prosfab/augment
	abstract_type = /datum/prototype/design/science/prosfab/augment
	category = "Augments"
	lathe_type = LATHE_TYPE_PROSTHETICS
	work = (20 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 750, MAT_GLASS = 500)

/datum/prototype/design/science/prosfab/augment/hand
	design_name = "resonant analyzer"
	id = "aug_hand"
	materials_base = list(MAT_STEEL = 1000, MAT_GLASS = 500, MAT_PLASTIC = 500)
	build_path = /obj/item/organ/internal/augment/armmounted/hand

/datum/prototype/design/science/prosfab/augment/shoulder
	design_name = "rotary toolkit"
	id = "aug_shoulder"
	req_tech = list(TECH_BIO = 3, TECH_MATERIAL = 4, TECH_ENGINEERING = 4, TECH_DATA = 3)
	materials_base = list(MAT_STEEL = 1500, MAT_GLASS = 500, MAT_PLASTIC = 750)
	build_path = /obj/item/organ/internal/augment/armmounted/shoulder/multiple

/datum/prototype/design/science/prosfab/augment/arm
	design_name = "implanted taser"
	id = "aug_arm"
	req_tech = list(TECH_BIO = 4, TECH_COMBAT = 4, TECH_MATERIAL = 4)
	materials_base = list(MAT_STEEL = 1500, MAT_GLASS = 500, MAT_PLASTIC = 1250)
	build_path = /obj/item/organ/internal/augment/armmounted/taser

/datum/prototype/design/science/prosfab/augment/shoulder_med
	design_name = "rotary medical kit"
	id = "aug_shouldermed"
	req_tech = list(TECH_BIO = 5, TECH_MATERIAL = 4, TECH_DATA = 3)
	materials_base = list(MAT_STEEL = 1500, MAT_GLASS = 1000, MAT_PLASTIC = 750)
	build_path = /obj/item/organ/internal/augment/armmounted/shoulder/multiple/medical

/datum/prototype/design/science/prosfab/augment/shoulder_combat
	design_name = "muscular overclocker"
	id = "aug_shouldercombat"
	req_tech = list(TECH_BIO = 5, TECH_COMBAT = 5, TECH_MATERIAL = 4, TECH_ENGINEERING = 4)
	materials_base = list(MAT_STEEL = 2000, MAT_PLASTIC = 3000, MAT_SILVER = 1000, MAT_GOLD = 500)
	build_path = /obj/item/organ/internal/augment/armmounted/shoulder/surge

/datum/prototype/design/science/prosfab/augment/pelvis
	design_name = "locomotive optimizer"
	id = "aug_pelvis"
	req_tech = list(TECH_BIO = 5, TECH_MATERIAL = 5, TECH_ENGINEERING = 5)
	materials_base = list(MAT_STEEL = 1500, MAT_PLASTIC = 2000, MAT_SILVER = 500, MAT_GOLD = 1000)
	build_path = /obj/item/organ/internal/augment/bioaugment/sprint_enhance

/datum/prototype/design/science/prosfab/augment/arm_laser
	design_name = "implanted laser rifle"
	id = "aug_armlaser"
	req_tech = list(TECH_BIO = 5, TECH_COMBAT = 5, TECH_MATERIAL = 5)
	materials_base = list(MAT_STEEL = 3000, MAT_GLASS = 1000, MAT_PLASTIC = 2000, MAT_GOLD = 2000)
	build_path = /obj/item/organ/internal/augment/armmounted

/datum/prototype/design/science/prosfab/augment/eyes
	design_name = "thermolensing sunglasses"
	id = "aug_eyes"
	req_tech = list(TECH_BIO = 6, TECH_ILLEGAL = 4, TECH_MATERIAL = 4, TECH_DATA = 5)
	materials_base = list(MAT_STEEL = 500, MAT_GLASS = 1000, MAT_PLASTIC = 1500, MAT_GOLD = 1000, MAT_DIAMOND = 2000)
	build_path = /obj/item/organ/internal/augment/bioaugment/thermalshades

/datum/prototype/design/science/prosfab/augment/hand_sword
	design_name = "implanted energy blade"
	id = "aug_handsword"
	req_tech = list(TECH_BIO = 6, TECH_COMBAT = 6, TECH_ILLEGAL = 4, TECH_MATERIAL = 4)
	materials_base = list(MAT_STEEL = 1500, MAT_GLASS = 500, MAT_PLASTIC = 2000, MAT_GOLD = 2000, MAT_URANIUM = 1500, MAT_DIAMOND = 2500)
	build_path = /obj/item/organ/internal/augment/armmounted/hand/sword

//////////////////// Cyborg Parts ////////////////////
/datum/prototype/design/science/prosfab/cyborg
	abstract_type = /datum/prototype/design/science/prosfab/cyborg
	category = "Cyborg Parts"
	work = (20 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 750)

/datum/prototype/design/science/prosfab/cyborg/exoskeleton
	design_name = "Robot Exoskeleton"
	id = "robot_exoskeleton"
	build_path = /obj/item/robot_parts/robot_suit
	work = (50 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 12000)

/datum/prototype/design/science/prosfab/cyborg/torso
	design_name = "Robot Torso"
	id = "robot_torso"
	build_path = /obj/item/robot_parts/chest
	work = (35 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 8000)

/datum/prototype/design/science/prosfab/cyborg/head
	design_name = "Robot Head"
	id = "robot_head"
	build_path = /obj/item/robot_parts/head
	work = (35 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 3500)

/datum/prototype/design/science/prosfab/cyborg/l_arm
	design_name = "Robot Left Arm"
	id = "robot_l_arm"
	build_path = /obj/item/robot_parts/l_arm
	work = (20 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 3500)

/datum/prototype/design/science/prosfab/cyborg/r_arm
	design_name = "Robot Right Arm"
	id = "robot_r_arm"
	build_path = /obj/item/robot_parts/r_arm
	work = (20 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 3500)

/datum/prototype/design/science/prosfab/cyborg/l_leg
	design_name = "Robot Left Leg"
	id = "robot_l_leg"
	build_path = /obj/item/robot_parts/l_leg
	work = (20 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 3500)

/datum/prototype/design/science/prosfab/cyborg/r_leg
	design_name = "Robot Right Leg"
	id = "robot_r_leg"
	build_path = /obj/item/robot_parts/r_leg
	work = (20 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 3500)


//////////////////// Cyborg Internals ////////////////////
/datum/prototype/design/science/prosfab/cyborg/component
	abstract_type = /datum/prototype/design/science/prosfab/cyborg/component
	category = "Cyborg Internals"
	lathe_type = LATHE_TYPE_PROSTHETICS
	work = (12 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 1750)

/datum/prototype/design/science/prosfab/cyborg/component/binary_communication_device
	design_name = "Binary Communication Device"
	id = "binary_communication_device"
	build_path = /obj/item/robot_parts/robot_component/binary_communication_device

/datum/prototype/design/science/prosfab/cyborg/component/radio
	design_name = "Radio"
	id = "radio"
	build_path = /obj/item/robot_parts/robot_component/radio

/datum/prototype/design/science/prosfab/cyborg/component/actuator
	design_name = "Actuator"
	id = "actuator"
	build_path = /obj/item/robot_parts/robot_component/actuator

/datum/prototype/design/science/prosfab/cyborg/component/diagnosis_unit
	design_name = "Diagnosis Unit"
	id = "diagnosis_unit"
	build_path = /obj/item/robot_parts/robot_component/diagnosis_unit

/datum/prototype/design/science/prosfab/cyborg/component/camera
	design_name = "Camera"
	id = "camera"
	build_path = /obj/item/robot_parts/robot_component/camera

/datum/prototype/design/science/prosfab/cyborg/component/armour
	design_name = "Armour Plating (Robot)"
	id = "armour"
	build_path = /obj/item/robot_parts/robot_component/armour

// /datum/prototype/design/science/prosfab/cyborg/component/armour_heavy
// 	design_name = "Armour Plating (Platform)"
// 	id = "platform_armour"
// 	build_path = /obj/item/robot_parts/robot_component/armour_platform

/datum/prototype/design/science/prosfab/cyborg/component/ai_shell
	design_name = "AI Remote Interface"
	id = "mmi_ai_shell"
	build_path = /obj/item/mmi/inert/ai_remote

//////////////////// Cyborg Modules ////////////////////
/datum/prototype/design/science/prosfab/robot_upgrade
	abstract_type = /datum/prototype/design/science/prosfab/robot_upgrade
	category = "Cyborg Modules"
	lathe_type = LATHE_TYPE_PROSTHETICS
	work = (12 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.
	materials_base = list(MAT_STEEL = 1750)

/datum/prototype/design/science/prosfab/robot_upgrade/rename
	design_name = "Rename Module"
	desc = "Used to rename a cyborg."
	id = "borg_rename_s"
	build_path = /obj/item/borg/upgrade/rename

/datum/prototype/design/science/prosfab/robot_upgrade/reset
	design_name = "Reset Module"
	desc = "Used to reset a cyborg's module. Destroys any other upgrades applied to the robot."
	id = "borg_reset_module"
	build_path = /obj/item/borg/upgrade/reset

/datum/prototype/design/science/prosfab/robot_upgrade/restart
	design_name = "Emergency Restart Module"
	desc = "Used to force a restart of a disabled-but-repaired robot, bringing it back online."
	id = "borg_restart_module"
	materials_base = list(MAT_STEEL = 4500, MAT_GLASS = 3750)
	build_path = /obj/item/borg/upgrade/restart

/datum/prototype/design/science/prosfab/robot_upgrade/vtec
	design_name = "VTEC Module"
	desc = "Used to kick in a robot's VTEC systems, increasing their speed."
	id = "borg_vtec_module"
	materials_base = list(MAT_STEEL = 5000, MAT_GLASS = 4500, MAT_GOLD = 3750)
	build_path = /obj/item/borg/upgrade/vtec

/datum/prototype/design/science/prosfab/robot_upgrade/tasercooler
	design_name = "Rapid Taser Cooling Module"
	desc = "Used to cool a mounted taser, increasing the potential current in it and thus its recharge rate."
	id = "borg_taser_module"
	materials_base = list(MAT_STEEL = 6000, MAT_GLASS = 4500, MAT_GOLD = 1500, MAT_DIAMOND = 375)
	build_path = /obj/item/borg/upgrade/tasercooler

/datum/prototype/design/science/prosfab/robot_upgrade/bluespaceoresatchel
	design_name = "Bluespace Ore Satchel Module"
	desc = "Improves the ore satchels of mining units to hold a lot more ores."
	id = "borg_bsorebag_module"
	req_tech = list(TECH_BLUESPACE = 4, TECH_MATERIAL = 6, TECH_PHORON = 4)
	materials_base = list(MAT_STEEL = 2500, MAT_GOLD = 1500, MAT_DIAMOND = 750, MAT_URANIUM = 150, MAT_PHORON = 1000)
	build_path = /obj/item/borg/upgrade/bluespaceorebag

/datum/prototype/design/science/prosfab/robot_upgrade/jetpack
	design_name = "Jetpack Module"
	desc = "A carbon dioxide jetpack suitable for low-gravity mining operations."
	id = "borg_jetpack_module"
	materials_base = list(MAT_STEEL = 5000, MAT_PHORON = 2550, MAT_URANIUM = 1500)
	build_path = /obj/item/borg/upgrade/jetpack

/datum/prototype/design/science/prosfab/robot_upgrade/advhealth
	design_name = "Advanced Health Analyzer Module"
	desc = "An advanced health analyzer suitable for diagnosing more serious injuries."
	id = "borg_advhealth_module"
	materials_base = list(MAT_STEEL = 1000, MAT_GLASS = 650, MAT_DIAMOND = 350)
	build_path = /obj/item/borg/upgrade/advhealth

/datum/prototype/design/science/prosfab/robot_upgrade/syndicate
	design_name = "Scrambled Equipment Module"
	desc = "Allows for the construction of lethal upgrades for cyborgs."
	id = "borg_syndicate_module"
	req_tech = list(TECH_COMBAT = 4, TECH_ILLEGAL = 3)
	// yeah no no free lunch here fuck you use 4 diamonds it should cost even MORE
	materials_base = list(MAT_STEEL = 7500, MAT_GLASS = 11250, MAT_DIAMOND = 7500)
	build_path = /obj/item/borg/upgrade/syndicate

/datum/prototype/design/science/prosfab/robot_upgrade/language
	design_name = "Language Module"
	desc = "Used to let cyborgs other than clerical or service speak a variety of languages."
	id = "borg_language_module"
	req_tech = list(TECH_DATA = 6, TECH_MATERIAL = 6)
	materials_base = list(MAT_STEEL = 750, MAT_GLASS = 300, MAT_GOLD = 350)
	build_path = /obj/item/borg/upgrade/language

/datum/prototype/design/science/prosfab/robot_upgrade/sizeshift
	design_name = "Size Alteration Module"
	id = "borg_sizeshift_module"
	req_tech = list(TECH_BLUESPACE = 3, TECH_MATERIAL = 3, TECH_POWER = 2)
	materials_base = list(MAT_STEEL = 750, MAT_GLASS = 250)
	build_path = /obj/item/borg/upgrade/sizeshift

// Synthmorph Bags.

/datum/prototype/design/science/prosfab/synthmorphbag
	design_name = "Synthmorph Storage Bag"
	desc = "Used to store or slowly defragment an FBP."
	id = "misc_synth_bag"
	materials_base = list(MAT_STEEL = 250, MAT_GLASS = 250, MAT_PLASTIC = 750)
	build_path = /obj/item/bodybag/cryobag/robobag

/datum/prototype/design/science/prosfab/badge_nt
	design_name = "Nanotrasen Tag"
	desc = "Used to identify an empty Nanotrasen FBP."
	id = "misc_synth_bag_tag_nt"
	materials_base = list(MAT_STEEL = 50, MAT_GLASS = 25, MAT_PLASTIC = 125)
	build_path = /obj/item/clothing/accessory/badge/corporate_tag

/datum/prototype/design/science/prosfab/badge_morph
	design_name = "Morpheus Tag"
	desc = "Used to identify an empty Morpheus FBP."
	id = "misc_synth_bag_tag_morph"
	materials_base = list(MAT_STEEL = 50, MAT_GLASS = 25, MAT_PLASTIC = 125)
	build_path = /obj/item/clothing/accessory/badge/corporate_tag/morpheus

/datum/prototype/design/science/prosfab/badge_wardtaka
	design_name = "Ward-Takahashi Tag"
	desc = "Used to identify an empty Ward-Takahashi FBP."
	id = "misc_synth_bag_tag_wardtaka"
	materials_base = list(MAT_STEEL = 50, MAT_GLASS = 25, MAT_PLASTIC = 125)
	build_path = /obj/item/clothing/accessory/badge/corporate_tag/wardtaka

/datum/prototype/design/science/prosfab/badge_zenghu
	design_name = "Zeng-Hu Tag"
	desc = "Used to identify an empty Zeng-Hu FBP."
	id = "misc_synth_bag_tag_zenghu"
	materials_base = list(MAT_STEEL = 50, MAT_GLASS = 25, MAT_PLASTIC = 125)
	build_path = /obj/item/clothing/accessory/badge/corporate_tag/zenghu

/datum/prototype/design/science/prosfab/badge_gilthari
	design_name = "Gilthari Tag"
	desc = "Used to identify an empty Gilthari FBP."
	id = "misc_synth_bag_tag_gilthari"
	materials_base = list(MAT_STEEL = 50, MAT_GLASS = 25, MAT_PLASTIC = 125)
	build_path = /obj/item/clothing/accessory/badge/corporate_tag/gilthari
	req_tech = list(TECH_MATERIAL = 4, TECH_ILLEGAL = 2, TECH_PHORON = 2)

/datum/prototype/design/science/prosfab/badge_veymed
	design_name = "Vey-Medical Tag"
	desc = "Used to identify an empty Vey-Medical FBP."
	id = "misc_synth_bag_tag_veymed"
	materials_base = list(MAT_STEEL = 50, MAT_GLASS = 25, MAT_PLASTIC = 125)
	build_path = /obj/item/clothing/accessory/badge/corporate_tag/veymed
	req_tech = list(TECH_MATERIAL = 3, TECH_ILLEGAL = 1, TECH_BIO = 4)

/datum/prototype/design/science/prosfab/badge_hephaestus
	design_name = "Hephaestus Tag"
	desc = "Used to identify an empty Hephaestus FBP."
	id = "misc_synth_bag_tag_heph"
	materials_base = list(MAT_STEEL = 50, MAT_GLASS = 25, MAT_PLASTIC = 125)
	build_path = /obj/item/clothing/accessory/badge/corporate_tag/hephaestus

/datum/prototype/design/science/prosfab/badge_grayson
	design_name = "Grayson Tag"
	desc = "Used to identify an empty Grayson FBP."
	id = "misc_synth_bag_tag_grayson"
	materials_base = list(MAT_STEEL = 50, MAT_GLASS = 25, MAT_PLASTIC = 125)
	build_path = /obj/item/clothing/accessory/badge/corporate_tag/grayson

/datum/prototype/design/science/prosfab/badge_xion
	design_name = "Xion Tag"
	desc = "Used to identify an empty Xion FBP."
	id = "misc_synth_bag_tag_xion"
	materials_base = list(MAT_STEEL = 50, MAT_GLASS = 25, MAT_PLASTIC = 125)
	build_path = /obj/item/clothing/accessory/badge/corporate_tag/xion

/datum/prototype/design/science/prosfab/badge_bishop
	design_name = "Bishop Tag"
	desc = "Used to identify an empty Bishop FBP."
	id = "misc_synth_bag_tag_bishop"
	materials_base = list(MAT_STEEL = 50, MAT_GLASS = 25, MAT_PLASTIC = 125)
	build_path = /obj/item/clothing/accessory/badge/corporate_tag/bishop
