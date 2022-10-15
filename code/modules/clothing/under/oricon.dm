//Confederation Uniforms

//Master
/obj/item/clothing/under/oricon
	name = "master oricon uniform"
	desc = "You shouldn't be seeing this."
	icon = 'icons/obj/clothing/uniforms_oricon.dmi'
	armor = list(melee = 5, bullet = 0, laser = 5, energy = 5, bomb = 0, bio = 5, rad = 5)
	siemens_coefficient = 0.8

//PT
/obj/item/clothing/under/oricon/pt
	name = "pt uniform"
	desc = "Shorts! Shirt! Miami! Sexy!"
	icon_state = "miami"
	snowflake_worn_state = "miami"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9
	body_parts_covered = UPPER_TORSO|LOWER_TORSO

/obj/item/clothing/under/oricon/pt/sysguard
	name = "\improper SysGuard pt uniform"
	desc = "A baggy shirt bearing the seal of the System Defense Force and some dorky looking blue shorts."
	icon_state = "expeditionpt"
	snowflake_worn_state = "expeditionpt"

/obj/item/clothing/under/oricon/pt/fleet
	name = "fleet pt uniform"
	desc = "A pair of black shorts and two tank tops, seems impractical. Looks good though."
	icon_state = "fleetpt"
	snowflake_worn_state = "fleetpt"

/obj/item/clothing/under/oricon/pt/marine
	name = "marine pt uniform"
	desc = "Does NOT leave much to the imagination."
	icon_state = "marinept"
	snowflake_worn_state = "marinept"


//Utility
//These are just colored
/obj/item/clothing/under/utility
	name = "utility uniform"
	desc = "A comfortable turtleneck and black utility trousers."
	icon_state = "blackutility"
	snowflake_worn_state = "blackutility"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9

/obj/item/clothing/under/utility/blue
	name = "utility uniform"
	desc = "A comfortable blue utility jumpsuit."
	icon_state = "navyutility"
	snowflake_worn_state = "navyutility"

/obj/item/clothing/under/utility/grey
	name = "utility uniform"
	desc = "A comfortable grey utility jumpsuit."
	icon_state = "greyutility"
	snowflake_worn_state = "greyutility"

//Here's the real ones
/obj/item/clothing/under/oricon/utility/sysguard
	name = "\improper SysGuard uniform"
	desc = "The utility uniform of the System Defense Force, made from biohazard resistant material. This one has silver trim."
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
	name = "\improper SysGuard officer's uniform"
	desc = "The utility uniform of the System Defense Force, made from biohazard resistant material. This one has gold trim."
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
	desc = "The utility uniform of the OCG Fleet, made from an insulated material."
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
	desc = "The utility uniform of the OCG Marine Corps, made from durable material."
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
	desc = "A green version of the OCG marine utility uniform, made from durable material."
	icon_state = "greenutility"
	snowflake_worn_state = "greenutility"

/obj/item/clothing/under/oricon/utility/marine/tan
	name = "tan fatigues"
	desc = "A tan version of the OCG marine utility uniform, made from durable material."
	icon_state = "tanutility"
	snowflake_worn_state = "tanutility"

//Service

/obj/item/clothing/under/oricon/service
	name = "service uniform"
	desc = "A service uniform of some kind."
	icon_state = "whiteservice"
	snowflake_worn_state = "whiteservice"
	armor = list(melee = 5, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 5, rad = 0)
	siemens_coefficient = 0.9

/obj/item/clothing/under/oricon/service/fleet
	name = "fleet service uniform"
	desc = "The service uniform of the OCG Fleet, made from immaculate white fabric."
	icon_state = "whiteservice"
	snowflake_worn_state = "whiteservice"

/obj/item/clothing/under/oricon/service/marine
	name = "marine service uniform"
	desc = "The service uniform of the OCG Marine Corps. Slimming."
	icon_state = "greenservice"
	snowflake_worn_state = "greenservice"

/obj/item/clothing/under/oricon/service/marine/command
	name = "marine command service uniform"
	desc = "The service uniform of the OCG Marine Corps. Slimming and stylish."
	icon_state = "greenservice_com"
	snowflake_worn_state = "greenservice_com"

//Dress

/obj/item/clothing/under/oricon/mildress
	name = "dress uniform"
	desc = "A dress uniform of some kind."
	icon_state = "greydress"
	snowflake_worn_state = "greydress"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9

/obj/item/clothing/under/oricon/mildress/sysguard
	name = "\improper SysGuard dress uniform"
	desc = "The dress uniform of the System Defense Force in silver trim."

/obj/item/clothing/under/oricon/mildress/sysguard/command
	starting_accessories = list(/obj/item/clothing/accessory/oricon/department/command/service)

/obj/item/clothing/under/oricon/mildress/sysguard/engineering
	starting_accessories = list(/obj/item/clothing/accessory/oricon/department/engineering/service)

/obj/item/clothing/under/oricon/mildress/sysguard/security
	starting_accessories = list(/obj/item/clothing/accessory/oricon/department/security/service)

/obj/item/clothing/under/oricon/mildress/sysguard/medical
	starting_accessories = list(/obj/item/clothing/accessory/oricon/department/medical/service)

/obj/item/clothing/under/oricon/mildress/sysguard/supply
	starting_accessories = list(/obj/item/clothing/accessory/oricon/department/supply/service)

/obj/item/clothing/under/oricon/mildress/sysguard/service
	starting_accessories = list(/obj/item/clothing/accessory/oricon/department/service/service)

/obj/item/clothing/under/oricon/mildress/sysguard/exploration
	starting_accessories = list(/obj/item/clothing/accessory/oricon/department/exploration/service)

/obj/item/clothing/under/oricon/mildress/sysguard/research
	starting_accessories = list(/obj/item/clothing/accessory/oricon/department/research/service)

/obj/item/clothing/under/oricon/mildress/sysguard/officer
	name = "\improper SysGuard command dress uniform"
	desc = "The dress uniform of the System Defense Force in gold trim."
	icon_state = "greydress_com"
	snowflake_worn_state = "greydress_com"

/obj/item/clothing/under/oricon/mildress/sysguard/officer/command
	starting_accessories = list(/obj/item/clothing/accessory/oricon/department/command/service)

/obj/item/clothing/under/oricon/mildress/sysguard/officer/engineering
	starting_accessories = list(/obj/item/clothing/accessory/oricon/department/engineering/service)

/obj/item/clothing/under/oricon/mildress/sysguard/officer/security
	starting_accessories = list(/obj/item/clothing/accessory/oricon/department/security/service)

/obj/item/clothing/under/oricon/mildress/sysguard/officer/medical
	starting_accessories = list(/obj/item/clothing/accessory/oricon/department/medical/service)

/obj/item/clothing/under/oricon/mildress/sysguard/officer/supply
	starting_accessories = list(/obj/item/clothing/accessory/oricon/department/supply/service)

/obj/item/clothing/under/oricon/mildress/sysguard/officer/service
	starting_accessories = list(/obj/item/clothing/accessory/oricon/department/service/service)

/obj/item/clothing/under/oricon/mildress/sysguard/officer/exploration
	starting_accessories = list(/obj/item/clothing/accessory/oricon/department/exploration/service)

/obj/item/clothing/under/oricon/mildress/sysguard/officer/research
	starting_accessories = list(/obj/item/clothing/accessory/oricon/department/research/service)

/obj/item/clothing/under/oricon/mildress/marine
	name = "marine dress uniform"
	desc = "The dress uniform of the OCG Marine Corps, class given form."
	icon_state = "blackdress"
	snowflake_worn_state = "blackdress"

/obj/item/clothing/under/oricon/mildress/marine/command
	name = "marine command dress uniform"
	desc = "The dress uniform of the OCG Marine Corps, even classier in gold."
	icon_state = "blackdress_com"
	snowflake_worn_state = "blackdress_com"

/obj/item/clothing/under/oricon/mildress/marine/command/fake
	name = "command dress uniform"
	desc = "A dress uniform for command, even classier in gold."
	icon_state = "blackdress_com"
	snowflake_worn_state = "blackdress_com"


//Misc

/obj/item/clothing/under/hazard
	name = "hazard jumpsuit"
	desc = "A high visibility jumpsuit made from heat and radiation resistant materials."
	icon_state = "hazard"
	snowflake_worn_state = "hazard"
	siemens_coefficient = 0.8
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 20, bio = 0, rad = 20)
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/under/sterile
	name = "sterile jumpsuit"
	desc = "A sterile white jumpsuit with medical markings. Protects against all manner of biohazards."
	icon_state = "sterile"
	snowflake_worn_state = "sterile"
	permeability_coefficient = 0.50
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 30, rad = 0)

//OriCon Uniforms

//PT
/obj/item/clothing/under/oricon/pt/sysguard
	name = "explorer's pt uniform"
	desc = "A baggy shirt bearing the seal of the Society of Universal Cartographers and some dorky looking blue shorts."

/obj/item/clothing/under/oricon/pt/fleet
	name = "fleet pt uniform"
	desc = "A pair of black shorts and two tank tops, seems impractical. Looks good though."

/obj/item/clothing/under/oricon/pt/marine
	name = "marine pt uniform"
	desc = "Does NOT leave much to the imagination."


//Utility

/obj/item/clothing/under/utility
	name = "utility uniform"
	desc = "A comfortable turtleneck and black utility trousers."

/obj/item/clothing/under/oricon/utility/sysguard
	name = "explorer's uniform"
	desc = "The utility uniform of the Society of Universal Cartographers, made from biohazard resistant material. This one has silver trim."

/obj/item/clothing/under/oricon/utility/sysguard/officer
	name = "explorer's officer uniform"
	desc = "The utility uniform of the Society of Universal Cartographers, made from biohazard resistant material. This one has gold trim."

/obj/item/clothing/under/oricon/utility/fleet
	name = "fleet coveralls"
	desc = "The utility uniform of the JSDF Fleet, made from an insulated material."

/obj/item/clothing/under/oricon/utility/marine
	name = "marine fatigues"
	desc = "The utility uniform of the JSDF Marine Corps, made from durable material."

/obj/item/clothing/under/oricon/utility/marine/green
	name = "green fatigues"
	desc = "A green version of the JSDF marine utility uniform, made from durable material."

/obj/item/clothing/under/oricon/utility/marine/tan
	name = "tan fatigues"
	desc = "A tan version of the JSDF marine utility uniform, made from durable material."

/obj/item/clothing/under/oricon/utility/marine/olive
	name = "olive fatigues"
	desc = "An olive version of the JSDF marine utility uniform, made from durable material."
	icon = 'icons/obj/clothing/uniforms.dmi'
	icon_state = "bdu_olive"
	item_state = "bdu_olive"

/obj/item/clothing/under/oricon/utility/marine/desert
	name = "desert fatigues"
	desc = "A desert version of the JSDF marine utility uniform, made from durable material."
	icon = 'icons/obj/clothing/uniforms.dmi'
	icon_state = "bdu_olive"
	item_state = "bdu_olive"

//Service

/obj/item/clothing/under/oricon/service/fleet
	name = "fleet service uniform"
	desc = "The service uniform of the JSDF Fleet, made from immaculate white fabric."

/obj/item/clothing/under/oricon/service/marine
	name = "marine service uniform"
	desc = "The service uniform of the JSDF Marine Corps. Slimming."
	snowflake_worn_state = "greenservice"

/obj/item/clothing/under/oricon/service/marine/command
	name = "marine command service uniform"
	desc = "The service uniform of the JSDF Marine Corps. Slimming and stylish."

/obj/item/clothing/under/oricon/mildress/expeditionary
	name = "explorer's dress uniform"
	desc = "The dress uniform of the Society of Universal Cartographers in silver trim."

/obj/item/clothing/under/oricon/mildress/expeditionary/command
	name = "explorer's command dress uniform"
	desc = "The dress uniform of the Society of Universal Cartographers in gold trim."

/obj/item/clothing/under/oricon/mildress/marine
	name = "marine dress uniform"
	desc = "The dress uniform of the JSDF Marine Corps, class given form."

/obj/item/clothing/under/oricon/mildress/marine/command
	name = "marine command dress uniform"
	desc = "The dress uniform of the JSDF Marine Corps, even classier in gold."

//Pirate Mate Fatigues
/obj/item/clothing/under/worn_fatigues
	name = "special ops fatigues"
	desc = "These worn fatigues match the pattern known to be used by JSDF Marine Corps special forces."
	icon_state = "russobluecamo"
