
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
