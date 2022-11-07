/obj/item/clothing/under/oricon/utility
	icon = 'icons/clothing/uniform/rank/utility.dmi'

/obj/item/clothing/under/oricon/utility/sysguard
	name = "explorer's uniform"
	desc = "The utility uniform of the Society of Universal Cartographers, made from biohazard resistant material. This one has silver trim."
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 10)
	icon_state = "black_crew"
	worn_has_rolldown = UNIFORM_HAS_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_ROLL

/obj/item/clothing/under/oricon/utility/sysguard/command
	starting_accessories = list(/obj/item/clothing/accessory/oricon/department/command)
	name = "explorer's command uniform"
	icon_state = "black_command"	// todo: actual state
	worn_has_rolldown = UNIFORM_HAS_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_ROLL

/obj/item/clothing/under/oricon/utility/sysguard/engineering
	starting_accessories = list(/obj/item/clothing/accessory/oricon/department/engineering)
	name = "explorer's engineering uniform"
	icon_state = "black_eng"
	worn_has_rolldown = UNIFORM_HAS_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_ROLL

/obj/item/clothing/under/oricon/utility/sysguard/security
	starting_accessories = list(/obj/item/clothing/accessory/oricon/department/security)
	name = "explorer's security uniform"
	icon_state = "black_sec"
	worn_has_rolldown = UNIFORM_HAS_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_ROLL

/obj/item/clothing/under/oricon/utility/sysguard/medical
	starting_accessories = list(/obj/item/clothing/accessory/oricon/department/medical)
	name = "explorer's medical uniform"
	icon_state = "black_med"
	worn_has_rolldown = UNIFORM_HAS_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_ROLL

/obj/item/clothing/under/oricon/utility/sysguard/supply
	starting_accessories = list(/obj/item/clothing/accessory/oricon/department/supply)
	name = "explorer's logistics uniform"
	icon_state = "black_sup"
	worn_has_rolldown = UNIFORM_HAS_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_ROLL

/obj/item/clothing/under/oricon/utility/sysguard/exploration
	starting_accessories = list(/obj/item/clothing/accessory/oricon/department/exploration)
	name = "explorer's uniform"
	icon_state = "black"	// todo: actual state
	worn_has_rolldown = UNIFORM_HAS_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_ROLL

/obj/item/clothing/under/oricon/utility/sysguard/research
	starting_accessories = list(/obj/item/clothing/accessory/oricon/department/research)
	name = "explorer's research uniform"
	icon_state = "black_sci"
	worn_has_rolldown = UNIFORM_HAS_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_ROLL

/obj/item/clothing/under/oricon/utility/sysguard/officer
	name = "explorer's officer uniform"
	desc = "The utility uniform of the Society of Universal Cartographers, made from biohazard resistant material. This one has gold trim."
	icon_state = "black_command"
	worn_has_rolldown = UNIFORM_HAS_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_ROLL

/obj/item/clothing/under/oricon/utility/sysguard/officer/command
	starting_accessories = list(/obj/item/clothing/accessory/oricon/department/command)
	name = "explorer's command officer uniform"
	icon_state = "black_command"
	worn_has_rolldown = UNIFORM_HAS_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_ROLL

/obj/item/clothing/under/oricon/utility/sysguard/officer/engineering
	starting_accessories = list(/obj/item/clothing/accessory/oricon/department/engineering)
	name = "explorer's engineering officer uniform"
	icon_state = "black_eng_command"
	worn_has_rolldown = UNIFORM_HAS_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_ROLL

/obj/item/clothing/under/oricon/utility/sysguard/officer/security
	starting_accessories = list(/obj/item/clothing/accessory/oricon/department/security)
	name = "explorer's security officer uniform"
	icon_state = "black_sec_command"
	worn_has_rolldown = UNIFORM_HAS_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_ROLL

/obj/item/clothing/under/oricon/utility/sysguard/officer/medical
	starting_accessories = list(/obj/item/clothing/accessory/oricon/department/medical)
	name = "explorer's medical officer uniform"
	icon_state = "black_med_command"
	worn_has_rolldown = UNIFORM_HAS_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_ROLL

/obj/item/clothing/under/oricon/utility/sysguard/officer/supply
	starting_accessories = list(/obj/item/clothing/accessory/oricon/department/supply)
	name = "explorer's logistics officer uniform"
	icon_state = "black_command"	// todo: actual state

// todo: you actual memes why does this exist
/obj/item/clothing/under/oricon/utility/sysguard/officer/exploration
	starting_accessories = list(/obj/item/clothing/accessory/oricon/department/exploration)
	name = "explorer's expeditionary officer uniform"
	icon_state = "black_command"	// todo: actual state
	worn_has_rolldown = UNIFORM_HAS_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_ROLL

/obj/item/clothing/under/oricon/utility/sysguard/officer/research
	starting_accessories = list(/obj/item/clothing/accessory/oricon/department/research)
	name = "explorer's science officer uniform"
	icon_state = "black_sci_command"
	worn_has_rolldown = UNIFORM_HAS_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_ROLL

/obj/item/clothing/under/oricon/utility/fleet
	name = "fleet coveralls"
	desc = "The utility uniform of the JSDF Fleet, made from an insulated material."
	icon_state = "navy"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 10, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.7
	worn_has_rolldown = UNIFORM_HAS_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_ROLL

/obj/item/clothing/under/oricon/utility/fleet/command
	starting_accessories = list(/obj/item/clothing/accessory/oricon/department/command/fleet)
	name = "fleet command coveralls"
	icon_state = "navy_command"
	worn_has_rolldown = UNIFORM_HAS_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_ROLL

/obj/item/clothing/under/oricon/utility/fleet/command/pilot
	starting_accessories = list(/obj/item/clothing/accessory/oricon/specialty/pilot)
	name = "fleet pilot coveralls"
	icon_state = "navy_officer"
	worn_has_rolldown = UNIFORM_HAS_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_ROLL

/obj/item/clothing/under/oricon/utility/fleet/engineering
	starting_accessories = list(/obj/item/clothing/accessory/oricon/department/engineering/fleet)
	name = "fleet engineer coveralls"
	icon_state = "navy_engi"
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/oricon/utility/fleet/security
	starting_accessories = list(/obj/item/clothing/accessory/oricon/department/security/fleet)
	name = "fleet security coveralls"
	icon_state = "navy_sec"
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/oricon/utility/fleet/medical
	starting_accessories = list(/obj/item/clothing/accessory/oricon/department/medical/fleet)
	name = "fleet medical coveralls"
	icon_state = "navy_med"
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/oricon/utility/fleet/supply
	starting_accessories = list(/obj/item/clothing/accessory/oricon/department/supply/fleet)
	name = "fleet logistics coveralls"
	icon_state = "navy_sup"
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/oricon/utility/fleet/exploration
	starting_accessories = list(/obj/item/clothing/accessory/oricon/department/exploration/fleet)
	name = "fleet explorer coveralls"
	icon_state = "navy_combat"
	worn_has_rolldown = UNIFORM_HAS_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_ROLL

/obj/item/clothing/under/oricon/utility/marine
	name = "marine fatigues"
	desc = "The utility uniform of the JSDF Marine Corps, made from durable material."
	icon_state = "grey"
	armor = list(melee = 10, bullet = 0, laser = 10,energy = 0, bomb = 0, bio = 0, rad = 0)
	worn_has_rolldown = UNIFORM_HAS_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_ROLL

/obj/item/clothing/under/oricon/utility/marine/command
	starting_accessories = list(/obj/item/clothing/accessory/oricon/department/command/marine)
	name = "marine command coveralls"
	icon_state = "grey_command"
	worn_has_rolldown = UNIFORM_HAS_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_ROLL

/obj/item/clothing/under/oricon/utility/marine/engineering
	starting_accessories = list(/obj/item/clothing/accessory/oricon/department/engineering/marine)
	name = "marine engineering coveralls"
	icon_state = "grey_eng"
	worn_has_rolldown = UNIFORM_HAS_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_ROLL

/obj/item/clothing/under/oricon/utility/marine/security
	starting_accessories = list(/obj/item/clothing/accessory/oricon/department/security/marine)
	name = "marine security coveralls"
	icon_state = "grey_sec"
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/oricon/utility/marine/medical
	starting_accessories = list(/obj/item/clothing/accessory/oricon/department/medical/marine)
	name = "marine medical coveralls"
	icon_state = "grey_med"
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/oricon/utility/marine/supply
	starting_accessories = list(/obj/item/clothing/accessory/oricon/department/supply/marine)
	name = "marine logistics coveralls"
	icon_state = "grey_sup"
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/oricon/utility/marine/exploration
	starting_accessories = list(/obj/item/clothing/accessory/oricon/department/exploration/marine)
	name = "marine explorer coveralls"
	icon_state = "terran"
	worn_has_rollsleeve = UNIFORM_HAS_ROLL
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/oricon/utility/marine/research
	name = "marine researcher coveralls"
	icon_state = "grey_sci"
	worn_has_rollsleeve = UNIFORM_HAS_ROLL
	worn_has_rolldown = UNIFORM_HAS_ROLL

/obj/item/clothing/under/oricon/utility/marine/green
	name = "green fatigues"
	desc = "A green version of the JSDF marine utility uniform, made from durable material."
	icon_state = "green"
	worn_has_rolldown = UNIFORM_HAS_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_ROLL

/obj/item/clothing/under/oricon/utility/marine/tan
	name = "tan fatigues"
	desc = "A tan version of the JSDF marine utility uniform, made from durable material."
	icon_state = "tan"
	worn_has_rolldown = UNIFORM_HAS_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_ROLL
