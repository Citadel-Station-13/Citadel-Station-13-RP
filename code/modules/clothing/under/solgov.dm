//SolGov Uniforms

//PT
/obj/item/clothing/under/pt
	name = "pt uniform"
	desc = "Shorts! Shirt! Miami! Sexy!"
	icon_state = "miami"
	worn_state = "miami"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9
	body_parts_covered = UPPER_TORSO|LOWER_TORSO

/obj/item/clothing/under/pt/sifguard
	name = "\improper SifGuard pt uniform"
	desc = "A baggy shirt bearing the seal of the Sif Defense Force and some dorky looking blue shorts."
	icon_state = "expeditionpt"
	worn_state = "expeditionpt"

/obj/item/clothing/under/pt/fleet
	name = "fleet pt uniform"
	desc = "A pair of black shorts and two tank tops, seems impractical. Looks good though."
	icon_state = "fleetpt"
	worn_state = "fleetpt"

/obj/item/clothing/under/pt/marine
	name = "marine pt uniform"
	desc = "Does NOT leave much to the imagination."
	icon_state = "marinept"
	worn_state = "marinept"


//Utility
//These are just colored
/obj/item/clothing/under/utility
	name = "utility uniform"
	desc = "A comfortable turtleneck and black utility trousers."
	icon_state = "blackutility"
	worn_state = "blackutility"
	rolled_sleeves = 0
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9

/obj/item/clothing/under/utility/blue
	name = "utility uniform"
	desc = "A comfortable blue utility jumpsuit."
	icon_state = "navyutility"
	worn_state = "navyutility"

/obj/item/clothing/under/utility/grey
	name = "utility uniform"
	desc = "A comfortable grey utility jumpsuit."
	icon_state = "greyutility"
	worn_state = "greyutility"

//Here's the real ones
/obj/item/clothing/under/utility/sifguard
	name = "crew uniform"
	desc = "A black utility uniform, designed for prolonged use. This one has silver trim."
	icon_state = "blackutility_crew"
	worn_state = "blackutility_crew"
//	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 10) // cit edit: these are in loadout now, no more resists

/obj/item/clothing/under/utility/sifguard/medical
	name = "medical crew uniform"
	desc = "A black utility uniform, designed for prolonged use. This one has silver trim and blue blazes."
	icon_state = "blackutility_med"
	worn_state = "blackutility_med"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)

/obj/item/clothing/under/utility/sifguard/medical/command
	name = "medical command uniform"
	desc = "A black utility uniform, designed for prolonged use. This one has gold trim and blue blazes."
	icon_state = "blackutility_medcom"
	worn_state = "blackutility_medcom"

/obj/item/clothing/under/utility/sifguard/science
	name = "science crew uniform"
	desc = "A black utility uniform, designed for prolonged use. This one has silver trim and purple blazes."
	icon_state = "blackutility_sci"
	worn_state = "blackutility_sci"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 10, bio = 0, rad = 0)

/obj/item/clothing/under/utility/sifguard/science/command
	name = "science command uniform"
	desc = "A black utility uniform, designed for prolonged use. This one has gold trim and purple blazes."
	icon_state = "blackutility_scicom"
	worn_state = "blackutility_scicom"

/obj/item/clothing/under/utility/sifguard/engineering
	name = "engineering crew uniform"
	desc = "A black utility uniform, designed for prolonged use. This one has silver trim and organge blazes."
	icon_state = "blackutility_eng"
	worn_state = "blackutility_eng"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 10)

/obj/item/clothing/under/utility/sifguard/engineering/command
	name = "engineering command uniform"
	desc = "A black utility uniform, designed for prolonged use. This one has gold trim and organge blazes."
	icon_state = "blackutility_engcom"
	worn_state = "blackutility_engcom"

/obj/item/clothing/under/utility/sifguard/supply
	name = "supply crew uniform"
	desc = "A black utility uniform, designed for prolonged use. This one has silver trim and brown blazes."
	icon_state = "blackutility_sup"
	worn_state = "blackutility_sup"

/obj/item/clothing/under/utility/sifguard/security
	name = "security crew uniform"
	desc = "A black utility uniform, designed for prolonged use. This one has silver trim and red blazes."
	icon_state = "blackutility_sec"
	worn_state = "blackutility_sec"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/under/utility/sifguard/security/command
	name = "security command uniform"
	desc = "A black utility uniform, designed for prolonged use. This one has gold trim and red blazes."
	icon_state = "blackutility_seccom"
	worn_state = "blackutility_seccom"

/obj/item/clothing/under/utility/sifguard/command
	name = "crew command uniform"
	desc = "A black utility uniform, designed for prolonged use. This one has gold trim and gold blazes."
	icon_state = "blackutility_com"
	worn_state = "blackutility_com"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)


/obj/item/clothing/under/utility/fleet
	name = "coveralls"
	desc = "A blue utility uniform."
	icon_state = "navyutility"
	worn_state = "navyutility"
/*	armor = list(melee = 0, bullet = 0, laser = 0,energy = 10, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.7 */// cit edit, no more armour ffs

/obj/item/clothing/under/utility/fleet/medical
	name = "medical coveralls"
	desc = "A blue utility uniform. This one has blue cuffs."
	icon_state = "navyutility_med"
	worn_state = "navyutility_med"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)

/obj/item/clothing/under/utility/fleet/science
	name = "science coveralls"
	desc = "A blue utility uniform. This one has purple cuffs."
	icon_state = "navyutility_sci"
	worn_state = "navyutility_sci"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 10, bio = 0, rad = 0)

/obj/item/clothing/under/utility/fleet/engineering
	name = "engineering coveralls"
	desc = "A blue utility uniform. This one has orange cuffs."
	icon_state = "navyutility_eng"
	worn_state = "navyutility_eng"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 10)

/obj/item/clothing/under/utility/fleet/supply
	name = "supply coveralls"
	desc = "A blue utility uniform. This one has brown cuffs."
	icon_state = "navyutility_sup"
	worn_state = "navyutility_sup"

/obj/item/clothing/under/utility/fleet/security
	name = "security coveralls"
	desc = "A blue utility uniform. This one has red cuffs."
	icon_state = "navyutility_sec"
	worn_state = "navyutility_sec"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/under/utility/fleet/command
	name = "command coveralls"
	desc = "A blue utility uniform.  This one has gold cuffs."
	icon_state = "navyutility_com"
	worn_state = "navyutility_com"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/under/utility/marine
	name = "fatigues"
	desc = "Light grey fatigues vaguely based off of military design, for corporate use."
	icon_state = "greyutility"
	worn_state = "greyutility"
//	armor = list(melee = 10, bullet = 0, laser = 10,energy = 0, bomb = 0, bio = 0, rad = 0) fuck outta here no more armour

/obj/item/clothing/under/utility/marine/green
	name = "green fatigues"
	desc = "Green fatigues vaguely based off of military design, for corporate use."
	icon_state = "greenutility"
	worn_state = "greenutility"

/obj/item/clothing/under/utility/marine/tan
	name = "tan fatigues"
	desc = "Tan fatigues vaguely based off of military design, for corporate use."
	icon_state = "tanutility"
	worn_state = "tanutility"

/obj/item/clothing/under/utility/marine/medical
	name = "medical fatigues"
	desc = "Light grey fatigues vaguely based off of military design, for corporate use. This one has blue markings."
	icon_state = "greyutility_med"
	worn_state = "greyutility_med"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)

/obj/item/clothing/under/utility/marine/science
	name = "science fatigues"
	desc = "Light grey fatigues vaguely based off of military design, for corporate use. This one has purple markings."
	icon_state = "greyutility_sci"
	worn_state = "greyutility_sci"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 10, bio = 0, rad = 0)

/obj/item/clothing/under/utility/marine/engineering
	name = "engineering fatigues"
	desc = "Light grey fatigues vaguely based off of military design, for corporate use. This one has orange markings."
	icon_state = "greyutility_eng"
	worn_state = "greyutility_eng"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 10)

/obj/item/clothing/under/utility/marine/supply
	name = "supply fatigues"
	desc = "Light grey fatigues vaguely based off of military design, for corporate use. This one has brown markings."
	icon_state = "greyutility_sup"
	worn_state = "greyutility_sup"

/obj/item/clothing/under/utility/marine/security
	name = "security fatigues"
	desc = "Light grey fatigues vaguely based off of military design, for corporate use. This one has red markings."
	icon_state = "greyutility_sec"
	worn_state = "greyutility_sec"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/under/utility/marine/command
	name = "command fatigues"
	desc = "Light grey fatigues vaguely based off of military design, for corporate use. This one has gold markings."
	icon_state = "greyutility_com"
	worn_state = "greyutility_com"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)

//Service

/obj/item/clothing/under/service
	name = "service uniform"
	desc = "A service uniform of some kind."
	icon_state = "whiteservice"
	worn_state = "whiteservice"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9

/obj/item/clothing/under/service/fleet
	name = "fleet service uniform"
	desc = "The service uniform of the SCG Fleet, made from immaculate white fabric."
	icon_state = "whiteservice"
	worn_state = "whiteservice"

/obj/item/clothing/under/service/marine
	name = "marine service uniform"
	desc = "The service uniform of the SCG Marine Corps. Slimming."
	icon_state = "greenservice"
	worn_state = "greenservice"

/obj/item/clothing/under/service/marine/command
	name = "marine command service uniform"
	desc = "The service uniform of the SCG Marine Corps. Slimming and stylish."
	icon_state = "greenservice_com"
	worn_state = "greenservice_com"

//Dress
/obj/item/clothing/under/mildress
	name = "dress uniform"
	desc = "A dress uniform of some kind."
	icon_state = "greydress"
	worn_state = "greydress"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9

/obj/item/clothing/under/mildress/sifguard
	name = "\improper SifGuard dress uniform"
	desc = "The dress uniform of the Sif Defense Force in silver trim."
	icon_state = "greydress"
	worn_state = "greydress"

/obj/item/clothing/under/mildress/sifguard/command
	name = "\improper SifGuard command dress uniform"
	desc = "The dress uniform of the Sif Defense Force in gold trim."
	icon_state = "greydress_com"
	worn_state = "greydress_com"

/obj/item/clothing/under/mildress/marine
	name = "marine dress uniform"
	desc = "The dress uniform of the SCG Marine Corps, class given form."
	icon_state = "blackdress"
	worn_state = "blackdress"

/obj/item/clothing/under/mildress/marine/command
	name = "marine command dress uniform"
	desc = "The dress uniform of the SCG Marine Corps, even classier in gold."
	icon_state = "blackdress_com"
	worn_state = "blackdress_com"


//Misc

/obj/item/clothing/under/hazard
	name = "hazard jumpsuit"
	desc = "A high visibility jumpsuit made from heat and radiation resistant materials."
	icon_state = "hazard"
	worn_state = "hazard"
	siemens_coefficient = 0.8
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 20, bio = 0, rad = 20)
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/under/sterile
	name = "sterile jumpsuit"
	desc = "A sterile white jumpsuit with medical markings. Protects against all manner of biohazards."
	icon_state = "sterile"
	worn_state = "sterile"
	permeability_coefficient = 0.50
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 30, rad = 0)
