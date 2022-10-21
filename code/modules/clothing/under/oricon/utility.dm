/obj/item/clothing/under/oricon/utility/sysguard
	name = "explorer's uniform"
	desc = "The utility uniform of the Society of Universal Cartographers, made from biohazard resistant material. This one has silver trim."
	icon_state = "blackutility_crew"
	snowflake_worn_state = "blackutility_crew"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 10)

/obj/item/clothing/under/oricon/utility/sysguard/command
	starting_accessories = list(/obj/item/clothing/accessory/oricon/department/command)

/obj/item/clothing/under/oricon/utility/sysguard/engineering
	starting_accessories = list(/obj/item/clothing/accessory/oricon/department/engineering)

/obj/item/clothing/under/oricon/utility/sysguard/security
	starting_accessories = list(/obj/item/clothing/accessory/oricon/department/security)

/obj/item/clothing/under/oricon/utility/sysguard/medical
	starting_accessories = list(/obj/item/clothing/accessory/oricon/department/medical)

/obj/item/clothing/under/oricon/utility/sysguard/supply
	starting_accessories = list(/obj/item/clothing/accessory/oricon/department/supply)

/obj/item/clothing/under/oricon/utility/sysguard/exploration
	starting_accessories = list(/obj/item/clothing/accessory/oricon/department/exploration)

/obj/item/clothing/under/oricon/utility/sysguard/research
	starting_accessories = list(/obj/item/clothing/accessory/oricon/department/research)

/obj/item/clothing/under/oricon/utility/sysguard/officer
	name = "explorer's officer uniform"
	desc = "The utility uniform of the Society of Universal Cartographers, made from biohazard resistant material. This one has gold trim."
	icon_state = "blackutility_com"
	snowflake_worn_state = "blackutility_com"

/obj/item/clothing/under/oricon/utility/sysguard/officer/command
	starting_accessories = list(/obj/item/clothing/accessory/oricon/department/command)

/obj/item/clothing/under/oricon/utility/sysguard/officer/engineering
	starting_accessories = list(/obj/item/clothing/accessory/oricon/department/engineering)

/obj/item/clothing/under/oricon/utility/sysguard/officer/security
	starting_accessories = list(/obj/item/clothing/accessory/oricon/department/security)

/obj/item/clothing/under/oricon/utility/sysguard/officer/medical
	starting_accessories = list(/obj/item/clothing/accessory/oricon/department/medical)

/obj/item/clothing/under/oricon/utility/sysguard/officer/supply
	starting_accessories = list(/obj/item/clothing/accessory/oricon/department/supply)

/obj/item/clothing/under/oricon/utility/sysguard/officer/exploration
	starting_accessories = list(/obj/item/clothing/accessory/oricon/department/exploration)

/obj/item/clothing/under/oricon/utility/sysguard/officer/research
	starting_accessories = list(/obj/item/clothing/accessory/oricon/department/research)

/obj/item/clothing/under/oricon/utility/fleet
	name = "fleet coveralls"
	desc = "The utility uniform of the JSDF Fleet, made from an insulated material."
	icon_state = "navyutility"
	snowflake_worn_state = "navyutility"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 10, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.7

/obj/item/clothing/under/oricon/utility/fleet/command
	starting_accessories = list(/obj/item/clothing/accessory/oricon/department/command/fleet)

/obj/item/clothing/under/oricon/utility/fleet/command/pilot
	starting_accessories = list(/obj/item/clothing/accessory/oricon/specialty/pilot)

/obj/item/clothing/under/oricon/utility/fleet/engineering
	starting_accessories = list(/obj/item/clothing/accessory/oricon/department/engineering/fleet)

/obj/item/clothing/under/oricon/utility/fleet/security
	starting_accessories = list(/obj/item/clothing/accessory/oricon/department/security/fleet)

/obj/item/clothing/under/oricon/utility/fleet/medical
	starting_accessories = list(/obj/item/clothing/accessory/oricon/department/medical/fleet)

/obj/item/clothing/under/oricon/utility/fleet/supply
	starting_accessories = list(/obj/item/clothing/accessory/oricon/department/supply/fleet)

/obj/item/clothing/under/oricon/utility/fleet/exploration
	starting_accessories = list(/obj/item/clothing/accessory/oricon/department/exploration/fleet)

/obj/item/clothing/under/oricon/utility/marine
	name = "marine fatigues"
	desc = "The utility uniform of the JSDF Marine Corps, made from durable material."
	icon_state = "greyutility"
	snowflake_worn_state = "greyutility"
	armor = list(melee = 10, bullet = 0, laser = 10,energy = 0, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/under/oricon/utility/marine/command
	starting_accessories = list(/obj/item/clothing/accessory/oricon/department/command/marine)

/obj/item/clothing/under/oricon/utility/marine/engineering
	starting_accessories = list(/obj/item/clothing/accessory/oricon/department/engineering/marine)

/obj/item/clothing/under/oricon/utility/marine/security
	starting_accessories = list(/obj/item/clothing/accessory/oricon/department/security/marine)

/obj/item/clothing/under/oricon/utility/marine/medical
	starting_accessories = list(/obj/item/clothing/accessory/oricon/department/medical/marine)

/obj/item/clothing/under/oricon/utility/marine/supply
	starting_accessories = list(/obj/item/clothing/accessory/oricon/department/supply/marine)

/obj/item/clothing/under/oricon/utility/marine/exploration
	starting_accessories = list(/obj/item/clothing/accessory/oricon/department/exploration/marine)

/obj/item/clothing/under/oricon/utility/marine/green
	name = "green fatigues"
	desc = "A green version of the JSDF marine utility uniform, made from durable material."
	icon_state = "greenutility"
	snowflake_worn_state = "greenutility"

/obj/item/clothing/under/oricon/utility/marine/tan
	name = "tan fatigues"
	desc = "A tan version of the JSDF marine utility uniform, made from durable material."
	icon_state = "tanutility"
	snowflake_worn_state = "tanutility"

#warn parse

/obj/item/clothing/under/oricon/utility/marine/olive
	name = "olive fatigues"
	desc = "An olive version of the JSDF marine utility uniform, made from durable material."
	icon = 'icons/obj/clothing/uniforms.dmi'
	icon_state = "bdu_olive"
	item_state = "bdu_olive"
#warn dela with the sprites for this oh FUCK OFF

/obj/item/clothing/under/oricon/utility/marine/desert
	name = "desert fatigues"
	desc = "A desert version of the JSDF marine utility uniform, made from durable material."
	icon = 'icons/obj/clothing/uniforms.dmi'
	icon_state = "bdu_olive"
	item_state = "bdu_olive"
#warn dela with the sprites for this oh FUCK OFF
