/***********************************************************************************/
//Datum Variable Assignments to Reduce Redundant Code
/datum/gear/restricted          //BYOND refuses to stop shitting a brick and throwing warnings (even though it STILL WORKS!) if all variables are initialized with a null, so the captain gets a rubber ducky.
	name = "Captain's Companion"
	path = /obj/item/bikehorn/rubberducky
	slot = null                                   //At least you work as null.
	allowed_roles = list("Facility Director")     //This technically also works as null, but we're supposed to be role restricted so it's the captain's exclusive, special ducky.
	sort_category = "Role Restricted"

//*Single Departments
//Security
/datum/gear/restricted/security
	allowed_roles = list("Security Officer", "Head of Security", "Warden", "Detective")

/datum/gear/restricted/security/eyes
	slot = SLOT_ID_GLASSES

/datum/gear/restricted/security/head
	slot = SLOT_ID_HEAD

/datum/gear/restricted/security/back
	slot = SLOT_ID_BACK

/datum/gear/restricted/security/uniform
	slot = SLOT_ID_UNIFORM

/datum/gear/restricted/security/suit
	slot = SLOT_ID_SUIT

/datum/gear/restricted/security/shoes
	slot = SLOT_ID_SHOES

/datum/gear/restricted/security/accessory
	slot = /datum/inventory_slot_meta/abstract/attach_as_accessory

//Medical
/datum/gear/restricted/medical
	allowed_roles = list("Medical Doctor", "Chief Medical Officer", "Chemist", "Paramedic", "Geneticist", "Psychiatrist", "Field Medic")

/datum/gear/restricted/medical/eyes
	slot = SLOT_ID_GLASSES

/datum/gear/restricted/medical/head
	slot = SLOT_ID_HEAD

/datum/gear/restricted/medical/back
	slot = SLOT_ID_BACK

/datum/gear/restricted/medical/uniform
	slot = SLOT_ID_UNIFORM

/datum/gear/restricted/medical/suit
	slot = SLOT_ID_SUIT

/datum/gear/restricted/medical/shoes
	slot = SLOT_ID_SHOES

/datum/gear/restricted/medical/accessory
	slot = /datum/inventory_slot_meta/abstract/attach_as_accessory

//Engineering
/datum/gear/restricted/engineering
	allowed_roles = list("Station Engineer", "Chief Engineer", "Atmospheric Technician")

/datum/gear/restricted/engineering/eyes
	slot = SLOT_ID_GLASSES

/datum/gear/restricted/engineering/head
	slot = SLOT_ID_HEAD

/datum/gear/restricted/engineering/back
	slot = SLOT_ID_BACK

/datum/gear/restricted/engineering/uniform
	slot = SLOT_ID_UNIFORM

/datum/gear/restricted/engineering/suit
	slot = SLOT_ID_SUIT

/datum/gear/restricted/engineering/shoes
	slot = SLOT_ID_SHOES

/datum/gear/restricted/engineering/accessory
	slot = /datum/inventory_slot_meta/abstract/attach_as_accessory

//Command
/datum/gear/restricted/command
	allowed_roles = list("Facility Director", "Head of Personnel", "Chief Medical Officer", "Head of Security", "Research Director", "Chief Engineer", "Command Secretary")

/datum/gear/restricted/command/eyes
	slot = SLOT_ID_GLASSES

/datum/gear/restricted/command/head
	slot = SLOT_ID_HEAD

/datum/gear/restricted/command/uniform
	slot = SLOT_ID_UNIFORM

/datum/gear/restricted/command/suit
	slot = SLOT_ID_SUIT

/datum/gear/restricted/command/shoes
	slot = SLOT_ID_SHOES

/datum/gear/restricted/command/accessory
	slot = /datum/inventory_slot_meta/abstract/attach_as_accessory

//Science
/datum/gear/restricted/science
	allowed_roles = list("Research Director", "Scientist", "Xenobiologist", "Roboticist", "Explorer", "Pathfinder")

/datum/gear/restricted/science/eyes
	slot = SLOT_ID_GLASSES

/datum/gear/restricted/science/head
	slot = SLOT_ID_HEAD

/datum/gear/restricted/science/back
	slot = SLOT_ID_BACK

/datum/gear/restricted/science/uniform
	slot = SLOT_ID_UNIFORM

/datum/gear/restricted/science/suit
	slot = SLOT_ID_SUIT

/datum/gear/restricted/science/shoes
	slot = SLOT_ID_SHOES

/datum/gear/restricted/science/accessory
	slot = /datum/inventory_slot_meta/abstract/attach_as_accessory

//Supply
/datum/gear/restricted/supply
	allowed_roles = list("Shaft Miner", "Cargo Technician", "Quartermaster")

/datum/gear/restricted/supply/eyes
	slot = SLOT_ID_GLASSES

/datum/gear/restricted/supply/uniform
	slot = SLOT_ID_UNIFORM

/datum/gear/restricted/supply/suit
	slot = SLOT_ID_SUIT

/datum/gear/restricted/supply/shoes
	slot = SLOT_ID_SHOES

/datum/gear/restricted/supply/accessory
	slot = /datum/inventory_slot_meta/abstract/attach_as_accessory

//Service
/datum/gear/restricted/service
	allowed_roles = list("Head of Personnel", "Bartender", "Botanist", "Janitor", "Chef", "Librarian", "Chaplain")

/datum/gear/restricted/service/accessory
	slot = /datum/inventory_slot_meta/abstract/attach_as_accessory

/datum/gear/restricted/service/suit
	slot = SLOT_ID_SUIT



//Misc.
/datum/gear/restricted/misc
	allowed_roles = null

/datum/gear/restricted/misc/head
	slot = SLOT_ID_HEAD

/datum/gear/restricted/misc/uniform
	slot = SLOT_ID_UNIFORM

/datum/gear/restricted/misc/suit
	slot = SLOT_ID_SUIT

/datum/gear/restricted/misc/shoes
	slot = SLOT_ID_SHOES

/datum/gear/restricted/misc/accessory
	slot = /datum/inventory_slot_meta/abstract/attach_as_accessory

//*Multi-Department Combinations (Aka Multi-Department Drifting)
//Security + Command
/datum/gear/restricted/sec_com
	allowed_roles = list("Security Officer", "Head of Security", "Warden", "Detective", "Facility Director", "Head of Personnel", "Internal Affairs Agent")

/datum/gear/restricted/sec_com/eyes
	slot = SLOT_ID_GLASSES


//Engineering + Science + Supply
/datum/gear/restricted/eng_sci_supply
	allowed_roles = list("Station Engineer", "Chief Engineer", "Atmospheric Technician", "Scientist", "Xenobiologist",  "Roboticist", "Explorer", "Pathfinder", "Research Director", "Shaft Miner", "Cargo Technician", "Quartermaster")

/datum/gear/restricted/eng_sci_supply/eyes
	slot = SLOT_ID_GLASSES


//Medical + Science
/datum/gear/restricted/med_sci
	allowed_roles = list("Research Director", "Scientist", "Xenobiologist", "Roboticist", "Explorer", "Pathfinder", "Medical Doctor", "Chief Medical Officer", "Chemist", "Paramedic", "Geneticist", "Psychiatrist", "Field Medic")

/datum/gear/restricted/med_sci/head
	slot = SLOT_ID_HEAD

/datum/gear/restricted/med_sci/suit
	slot = SLOT_ID_SUIT
/***********************************************************************************/
//**Single-Department Items
//*Security
//Eyes
/datum/gear/restricted/security/eyes/hud
	name = "Security HUD"
	path = /obj/item/clothing/glasses/hud/security

/datum/gear/restricted/security/eyes/secpatch
	name = "Security HUD - Eyepatch"
	path = /obj/item/clothing/glasses/hud/security/eyepatch

/datum/gear/restricted/security/eyes/prescriptionsec
	name = "Security HUD - Prescription"
	path = /obj/item/clothing/glasses/hud/security/prescription

/datum/gear/restricted/security/eyes/sunglasshud
	name = "Security HUD - Sunglasses"
	path = /obj/item/clothing/glasses/sunglasses/sechud

/datum/gear/restricted/security/eyes/aviator
	name = "Security HUD - Aviators"
	path = /obj/item/clothing/glasses/sunglasses/sechud/aviator

/datum/gear/restricted/security/eyes/aviator/prescription
	name = "Security HUD - Aviators, Prescription"
	path = /obj/item/clothing/glasses/sunglasses/sechud/aviator/prescription

/datum/gear/restricted/security/eyes/arglasses_sec
	name = "Security AR-S Glasses"
	path = /obj/item/clothing/glasses/omnihud/sec

//Head
/datum/gear/restricted/security/head/beret
	name = "Security Beret - Red"
	path = /obj/item/clothing/head/beret/sec

/datum/gear/restricted/security/head/beret/naval
	name = "Security Beret - Naval"
	path = /obj/item/clothing/head/beret/sec/navy/officer

/datum/gear/restricted/security/head/beret/naval/warden
	name = "Security Warden Beret - Naval"
	path = /obj/item/clothing/head/beret/sec/navy/warden
	allowed_roles = list("Warden")

/datum/gear/restricted/security/head/beret/naval/hos
	name = "Security Head of Security Beret - Naval"
	path = /obj/item/clothing/head/beret/sec/navy/hos
	allowed_roles = list("Head of Security")

/datum/gear/restricted/security/head/beret/corporate
	name = "Security Beret - Corporate"
	path = /obj/item/clothing/head/beret/sec/corporate/officer

/datum/gear/restricted/security/head/beret/corporate/warden
	name = "Security Warden Beret - Corporate"
	path = /obj/item/clothing/head/beret/sec/corporate/warden
	allowed_roles = list("Warden")

/datum/gear/restricted/security/head/beret/corporate/hos
	name = "Security Head of Security Beret - Corporate"
	path = /obj/item/clothing/head/beret/sec/corporate/hos
	allowed_roles = list("Head of Security")

/datum/gear/restricted/security/head/cap
	name = "Security Cap"
	path = /obj/item/clothing/head/soft/sec

/datum/gear/restricted/security/head/cap/corporate
	name = "Security Cap - Corporate Security"
	path = /obj/item/clothing/head/soft/sec/corp

/datum/gear/restricted/security/head/cap/operations
	name = "Security Cap - Security Operations"
	path = /obj/item/clothing/head/operations/security

//Uniform
/datum/gear/restricted/security/uniform/skirt
	name = "Security Skirt"
	path = /obj/item/clothing/under/rank/security/skirt

/datum/gear/restricted/security/uniform/skirt
	name = "Security Pleated Skirt"
	path = /obj/item/clothing/under/rank/security/skirt_pleated

/datum/gear/restricted/security/uniform/skirt/warden
	name = "Warden Skirt"
	path = /obj/item/clothing/under/rank/warden/skirt
	allowed_roles = list("Head of Security", "Warden")

/datum/gear/restricted/security/uniform/skirt/warden_pleated
	name = "Warden's Pleated Skirt"
	path = /obj/item/clothing/under/rank/warden/skirt_pleated
	allowed_roles = list("Head of Security", "Warden")

/datum/gear/restricted/security/uniform/skirt/hos
	name = "Head of Security Skirt"
	path = /obj/item/clothing/under/rank/head_of_security/skirt
	allowed_roles = list("Head of Security")

/datum/gear/restricted/security/uniform/skirt/hos_pleated
	name = "Head of Security's Pleated Skirt"
	path = /obj/item/clothing/under/rank/head_of_security/skirt_pleated
	allowed_roles = list("Head of Security")

/datum/gear/restricted/security/uniform/skirt/hos_pleated_dark
	name = "Head of Security's Dark Pleated Skirt"
	path = /obj/item/clothing/under/rank/head_of_security/skirt_pleated/alt
	allowed_roles = list("Head of Security")

/datum/gear/restricted/security/uniform/skirt/detective
	name = "Detective Suit - Skirt"
	path = /obj/item/clothing/under/det/skirt
	allowed_roles = list("Detective", "Head of Security")

/datum/gear/restricted/security/uniform/skirt/detective_pleated
	name = "Detective Suit - Pleated Skirt"
	path = /obj/item/clothing/under/det/grey/skirt_pleated
	allowed_roles = list("Detective", "Head of Security")

/datum/gear/restricted/security/uniform/corporate
	name = "Security Uniform - Corporate"
	path = /obj/item/clothing/under/rank/security/corp

/datum/gear/restricted/security/uniform/corporate_fem
	name = "Security Uniform - Corporate - Female"
	path = /obj/item/clothing/under/rank/security/corp_fem

/datum/gear/restricted/security/uniform/corporate/detective
	name = "Detective Uniform - Corporate"
	path = /obj/item/clothing/under/det/corporate
	allowed_roles = list("Detective", "Head of Security")

/datum/gear/restricted/security/uniform/corporate/detective_fem
	name = "Detective Uniform - Corporate - Female"
	path = /obj/item/clothing/under/det/corporate_fem
	allowed_roles = list("Detective", "Head of Security")

/datum/gear/restricted/security/uniform/detective/fem
	name = "Detective Uniform - Suit - Female"
	path = /obj/item/clothing/under/det_fem
	allowed_roles = list("Detective", "Head of Security")

/datum/gear/restricted/security/uniform/detective/fem/tan
	name = "Detective Uniform - Tan - Female"
	path = /obj/item/clothing/under/det/grey_fem
	allowed_roles = list("Detective", "Head of Security")

/datum/gear/restricted/security/uniform/detective/fem/spiffy
	name = "Detective Uniform - Spiffy - Female"
	path = /obj/item/clothing/under/det/black_fem
	allowed_roles = list("Detective", "Head of Security")

/datum/gear/restricted/security/uniform/detective/fem/tidy
	name = "Detective Uniform - Semi-Tidy - Female"
	path = /obj/item/clothing/under/det/waistcoat_fem
	allowed_roles = list("Detective", "Head of Security")

/datum/gear/restricted/security/uniform/detective/fem/serious
	name = "Detective Uniform - Serious - Female"
	path = /obj/item/clothing/under/det/grey/waistcoat_fem

/datum/gear/restricted/security/uniform/corporate/warden //before this was changed it was called the corpwarsuit. shame there's no full borg in a hard rock cafe shirt.
	name = "Warden Uniform - Corporate"
	path = /obj/item/clothing/under/rank/warden/corp
	allowed_roles = list("Head of Security", "Warden")

/datum/gear/restricted/security/uniform/corporate/warden_fem
	name = "Warden Uniform - Corporate - Female"
	path = /obj/item/clothing/under/rank/warden/corp_fem
	allowed_roles = list("Head of Security", "Warden")

/datum/gear/restricted/security/uniform/corporate/hos
	name = "Head of Security Uniform - Corporate"
	path = /obj/item/clothing/under/rank/head_of_security/corp
	allowed_roles = list("Head of Security")

/datum/gear/restricted/security/uniform/corporate/hos_fem
	name = "Head of Security Uniform - Corporate - Female"
	path = /obj/item/clothing/under/rank/head_of_security/corp_fem

/datum/gear/restricted/security/uniform/navyblue
	name = "Security Uniform - Navy Blue"
	path = /obj/item/clothing/under/rank/security/navyblue

/datum/gear/restricted/security/uniform/navyblue_fem
	name = "Security Uniform - Navy Blue - Female"
	path = /obj/item/clothing/under/rank/security/navyblue_fem

/datum/gear/restricted/security/uniform/navyblue/warden
	name = "Warden Uniform - Navy Blue"
	path = /obj/item/clothing/under/rank/warden/navyblue
	allowed_roles = list("Head of Security", "Warden")

/datum/gear/restricted/security/uniform/navyblue/warden_fem
	name = "Warden Uniform - Navy Blue - Female"
	path = /obj/item/clothing/under/rank/warden/navyblue_fem
	allowed_roles = list("Head of Security", "Warden")

/datum/gear/restricted/security/uniform/navyblue/hos
	name = "Head of Security Uniform - Navy Blue"
	path = /obj/item/clothing/under/rank/head_of_security/navyblue
	allowed_roles = list("Head of Security")

/datum/gear/restricted/security/uniform/navyblue/hos_fem
	name = "Head of Security Funiform - Navy Blue - Female"
	path = /obj/item/clothing/under/rank/head_of_security/navyblue_fem
	allowed_roles = list("Head of Security")

/datum/gear/restricted/security/uniform/turtleneck
	name = "Security Turtleneck"
	path = /obj/item/clothing/under/rank/security/turtleneck

/datum/gear/restricted/security/uniform/turtleneck_fem
	name = "Security Turtleneck - Female"
	path = /obj/item/clothing/under/rank/security/turtleneck_fem

/datum/gear/restricted/security/uniform/turtleneck/alt
	name = "Security Turtleneck - Alternative"
	path = /obj/item/clothing/under/oricon/utility/sysguard/crew/security

/datum/gear/restricted/security/uniform/turtleneck/hos
	name = "Head of Security Turtleneck"
	path = /obj/item/clothing/under/rank/head_of_security/turtleneck
	allowed_roles = list("Head of Security")

/datum/gear/restricted/security/uniform/bodysuit
	name = "Security Bodysuit"
	path = /obj/item/clothing/under/bodysuit/bodysuitsec

/datum/gear/restricted/security/uniform/bodysuit_fem
	name = "Security Bodysuit - Female"
	path = /obj/item/clothing/under/bodysuit/bodysuitsec_fem

/datum/gear/restricted/security/uniform/bodysuit/command
	name = "Security Command Bodysuit"
	path = /obj/item/clothing/under/bodysuit/bodysuitseccom
	allowed_roles = list("Head of Security", "Warden")

/datum/gear/restricted/security/uniform/bodysuit/command_fem
	name = "Security Command Bodysuit - Female"
	path = /obj/item/clothing/under/bodysuit/bodysuitseccom_fem
	allowed_roles = list("Head of Security", "Warden")

/datum/gear/restricted/security/uniform/coveralls
	name = "Security Uniform - Coveralls"
	path = /obj/item/clothing/under/oricon/utility/fleet/security

/datum/gear/restricted/security/uniform/fatigues
	name = "Security Uniform - Fatigues" //You marine larper.
	path = /obj/item/clothing/under/oricon/utility/marine/security

/datum/gear/restricted/security/uniform/dispatch
	name = "Security Uniform - Dispatch"
	path = /obj/item/clothing/under/rank/dispatch

//Back
/datum/gear/restricted/security/back/dufflebag
	name = "Security - Dufflebag"
	path = /obj/item/storage/backpack/dufflebag/sec
	allowed_roles = list("Security Officer", "Head of Security", "Warden", "Detective", "Talon Guard")
	cost = 2

//Suit
/datum/gear/restricted/security/suit/forensics
	name = "Detective Forensics - Red"
	path = /obj/item/clothing/suit/storage/forensics/red
	allowed_roles = list("Detective")

/datum/gear/restricted/security/suit/forensics/blue
	name = "Detective Forensics - Blue"
	path = /obj/item/clothing/suit/storage/forensics/blue
	allowed_roles = list("Detective")

/datum/gear/restricted/security/suit/forensics/long_red
	name = "Detective Forensics Long - Red"
	path = /obj/item/clothing/suit/storage/forensics/red/long
	allowed_roles = list("Detective")

/datum/gear/restricted/security/suit/forensics/long_blue
	name = "Detective Forensics Long - Blue"
	path = /obj/item/clothing/suit/storage/forensics/blue/long
	allowed_roles = list("Detective")

/datum/gear/restricted/security/suit/wintercoat
	name = "Security Winter Coat"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/security

/datum/gear/restricted/security/suit/wintercoat
	name = "Head of Security's Winter Coat"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/security/hos
	allowed_roles = list("Head of Security")

/datum/gear/restricted/security/suit/operations_coat
	name = "Security Operations Jacket"
	path = /obj/item/clothing/suit/storage/toggle/operations_coat

/datum/gear/restricted/security/suit/snowsuit
	name = "Security Snowsuit"
	path = /obj/item/clothing/suit/storage/snowsuit/security

/datum/gear/restricted/security/suit/department_jacket
	name = "Security Department Jacket"
	path = /obj/item/clothing/suit/storage/toggle/sec_dep_jacket

//Depite being declared as an accessory, it is also equippable in the suit slot, and the sprite is so bulky that it "clips" through most suit slot items. Therefore, all loadout cloaks will default to the suit slot.
/datum/gear/restricted/security/suit/cloak
	name = "Security Cloak"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/security

/datum/gear/restricted/security/suit/cloak/hos
	name = "Head of Security Cloak"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/hos
	allowed_roles = list("Head of Security")

//Depite being declared as an accessory, it is also equippable in the suit slot, and the sprite is so bulky that it "clips" through most suit slot items. Therefore, all loadout ponchos will default to the suit slot.
/datum/gear/restricted/security/suit/poncho
	name = "Security Poncho"
	path = /obj/item/clothing/accessory/poncho/roles/security


//Shoes
/datum/gear/restricted/security/shoes/winterboots
	name = "Security - Winter Boots"
	path = /obj/item/clothing/shoes/boots/winter/security


//*Medical
//Eyes
/datum/gear/restricted/medical/eyes/hud
	name = "Medical HUD"
	path = /obj/item/clothing/glasses/hud/health

/datum/gear/restricted/medical/eyes/eyepatch
	name = "Medical HUD Eyepatch"
	path = /obj/item/clothing/glasses/hud/health/eyepatch

/datum/gear/restricted/medical/eyes/prescriptionmed
	name = "Medical HUD - Prescription"
	path = /obj/item/clothing/glasses/hud/health/prescription

/datum/gear/restricted/medical/eyes/aviator
	name = "Medical HUD - Aviators"
	path = /obj/item/clothing/glasses/hud/health/aviator

/datum/gear/restricted/medical/eyes/aviator/prescription
	name = "Medical HUD - Aviators, Prescription"
	path = /obj/item/clothing/glasses/hud/health/aviator/prescription

/datum/gear/restricted/medical/eyes/arglasses_med
	name = "Medical AR-M Glasses"
	path = /obj/item/clothing/glasses/omnihud/med

//Head
/datum/gear/restricted/medical/head/paramedic_cap
	name = "Medical Paramedic Cap"
	path = /obj/item/clothing/head/parahat

//Back
/datum/gear/restricted/medical/back/dufflebag
	name = "Medical Dufflebag"
	path = /obj/item/storage/backpack/dufflebag/med
	allowed_roles = list("Medical Doctor", "Chief Medical Officer", "Chemist", "Paramedic", "Geneticist", "Psychiatrist", "Field Medic", "Talon Doctor")
	cost = 2

/datum/gear/restricted/medical/back/dufflebag/emt
	name = "Medical Dufflebag - EMT Variant"
	path = /obj/item/storage/backpack/dufflebag/emt

//Uniform
/datum/gear/restricted/medical/uniform/skirt
	name = "Medical Skirt"
	path = /obj/item/clothing/under/rank/medical/skirt

/datum/gear/restricted/medical/uniform/skirt_pleated
	name = "Medical Pleated Skirt"
	path = /obj/item/clothing/under/rank/medical/skirt_pleated

/datum/gear/restricted/medical/uniform/jeans/chem
	name = "Chemist Jumpjeans"
	path = /obj/item/clothing/under/rank/chemist/jeans
	allowed_roles = list("Chief Medical Officer", "Chemist")

/datum/gear/restricted/medical/uniform/fem_jeans/chem
	name = "Chemist Jumpjeans - Female"
	path = /obj/item/clothing/under/rank/chemist/fem_jeans
	allowed_roles = list("Chief Medical Officer", "Chemist")

/datum/gear/restricted/medical/uniform/skirt/chem
	name = "Chemist Skirt"
	path = /obj/item/clothing/under/rank/chemist/skirt
	allowed_roles = list("Chief Medical Officer", "Chemist")

/datum/gear/restricted/medical/uniform/skirt/chem_pleated
	name = "Chemist's Pleated Skirt"
	path = /obj/item/clothing/under/rank/chemist/skirt_pleated
	allowed_roles = list("Chief Medical Officer", "Chemist")

/datum/gear/restricted/medical/uniform/jeans/viro
	name = "Virologist's Jumpjeans"
	path = /obj/item/clothing/under/rank/virologist/jeans
	allowed_roles = list("Chief Medical Officer", "Medical Doctor")

/datum/gear/restricted/medical/uniform/fem_jeans/viro
	name = "Virologist's Jumpjeans - Female"
	path = /obj/item/clothing/under/rank/virologist/fem_jeans
	allowed_roles = list("Chief Medical Officer", "Medical Doctor")

/datum/gear/restricted/medical/uniform/skirt/viro
	name = "Virologist Skirt"
	path = /obj/item/clothing/under/rank/virologist/skirt
	allowed_roles = list("Chief Medical Officer", "Medical Doctor")

/datum/gear/restricted/medical/uniform/skirt/viro_pleated
	name = "Virologist's Pleated Skirt"
	path = /obj/item/clothing/under/rank/virologist/skirt_pleated
	allowed_roles = list("Chief Medical Officer", "Medical Doctor")

/datum/gear/restricted/medical/uniform/jeans/cmo
	name = "Chief Medical Officer's Jumpjeans"
	path = /obj/item/clothing/under/rank/chief_medical_officer/jeans
	allowed_roles = list("Chief Medical Officer")

/datum/gear/restricted/medical/uniform/fem_jeans/cmo
	name = "Chief Medical Officer's Jumpjeans - Female"
	path = /obj/item/clothing/under/rank/chief_medical_officer/fem_jeans
	allowed_roles = list("Chief Medical Officer")

/datum/gear/restricted/medical/uniform/skirt/cmo
	name = "Chief Medical Officer Skirt"
	path = /obj/item/clothing/under/rank/chief_medical_officer/skirt
	allowed_roles = list("Chief Medical Officer")

/datum/gear/restricted/medical/uniform/skirt/cmo_pleated
	name = "Chief Medical Officer's Pleated Skirt"
	path = /obj/item/clothing/under/rank/chief_medical_officer/skirt_pleated
	allowed_roles = list("Chief Medical Officer")

/datum/gear/restricted/medical/uniform/turtleneck
	name = "Medical Turtleneck"
	path = /obj/item/clothing/under/rank/medical/turtleneck

/datum/gear/restricted/medical/uniform/turtleneck_fem
	name = "Medical Turtleneck - Female"
	path = /obj/item/clothing/under/rank/medical/turtleneck_fem

/datum/gear/restricted/medical/uniform/turtleneck/alt
	name = "Medical Turtleneck - Alternative"
	path = /obj/item/clothing/under/oricon/utility/sysguard/crew/medical

/datum/gear/restricted/medical/uniform/coveralls
	name = "Medical Uniform - Coveralls"
	path = /obj/item/clothing/under/oricon/utility/fleet/medical

/datum/gear/restricted/medical/uniform/fatigues
	name = "Medical Uniform - Fatigues"
	path = /obj/item/clothing/under/oricon/utility/marine/medical

/datum/gear/restricted/medical/uniform/jeans
	name = "Medical Uniform - Jeans"
	path = /obj/item/clothing/under/rank/medical/jeans

/datum/gear/restricted/medical/uniform/fem_jeans
	name = "Medical Uniform - Female Jeans"
	path = /obj/item/clothing/under/rank/medical/fem_jeans

/datum/gear/restricted/medical/uniform/paramedic
	name = "Medical Uniform - Paramedic Light"
	path = /obj/item/clothing/under/paramedunilight

/datum/gear/restricted/medical/uniform/paramedic/dark
	name = "Medical Uniform - Paramedic Dark"
	path = /obj/item/clothing/under/paramedunidark

/datum/gear/restricted/medical/uniform/paramedic/skirt_pleated
	name = "Medical Skirt - Paramedic Skirt Light"
	path = /obj/item/clothing/under/parameduniskirtlight

/datum/gear/restricted/medical/uniform/paramedic/skirt/dark_pleated
	name = "Medical Skirt - Paramedic Skirt Dark"
	path = /obj/item/clothing/under/parameduniskirtdark

/datum/gear/restricted/medical/uniform/bodysuit
	name = "Medical Bodysuit - EMT"
	path = /obj/item/clothing/under/bodysuit/bodysuitemt

/datum/gear/restricted/medical/uniform/bodysuit_fem
	name = "Medical Bodysuit - EMT - Female"
	path = /obj/item/clothing/under/bodysuit/bodysuitemt_fem

/datum/gear/restricted/medical/uniform/psych_fem
	name = "Psychologist's Turtleneck - Female"
	path = /obj/item/clothing/under/rank/psych/turtleneck_fem

//Suit
/datum/gear/restricted/medical/suit/wintercoat
	name = "Medical Winter Coat"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/medical

/datum/gear/restricted/medical/suit/wintercoat/paramedic
	name = "Medical Winter Coat, Paramedic"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/medical/para

/datum/gear/restricted/medical/suit/wintercoat/chemist
	name = "Medical Winter Coat, Chemist"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/medical/chemistry

/datum/gear/restricted/medical/suit/wintercoat/viro
	name = "Medical Winter Coat, Virologist"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/medical/viro

/datum/gear/restricted/medical/suit/wintercoat/genetics
	name = "Medical Winter Coat, Geneticist"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/medical/genetics

/datum/gear/restricted/medical/suit/wintercoat/cmo
	name = "Medical Winter Coat, CMO"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/medical/cmo
	allowed_roles = list("Chief Medical Officer")

/datum/gear/restricted/medical/suit/surgical_apron
	name = "Medical Surgical Apron"
	path = /obj/item/clothing/suit/surgicalapron

/datum/gear/restricted/medical/suit/paramedic_jacket
	name = "Medical Paramedic Jacket"
	path = /obj/item/clothing/suit/toggle/paramed

/datum/gear/restricted/medical/suit/emt_vest
	name = "Medical EMT Vest"
	path = /obj/item/clothing/suit/toggle/labcoat/paramedic

/datum/gear/restricted/medical/suit/snowsuit
	name = "Medical Snowsuit"
	path = /obj/item/clothing/suit/storage/snowsuit/medical

/datum/gear/restricted/medical/suit/labcoat_emt
	name = "Medical Labcoat - EMT"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/emt

/datum/gear/restricted/medical/suit/department_jacket
	name = "Medical Department Jacket"
	path = /obj/item/clothing/suit/storage/toggle/med_dep_jacket

/datum/gear/restricted/medical/suit/cloak
	name = "Medical Cloak"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/medical

/datum/gear/restricted/medical/suit/cloak/cmo
	name = "Chief Medical Officer - Cloak"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/cmo
	allowed_roles = list("Chief Medical Officer")

/datum/gear/restricted/medical/suit/poncho
	name = "Medical Poncho"
	path = /obj/item/clothing/accessory/poncho/roles/medical


//Shoes
/datum/gear/restricted/medical/shoes/winterboots
	name = "Medical - Winter Boots"
	path = /obj/item/clothing/shoes/boots/winter/medical

//Accessories
/datum/gear/restricted/medical/accessory/stethoscope
	name = "Medical - Stethoscope"
	path = /obj/item/clothing/accessory/stethoscope


//*Engineering
//Eyes
/datum/gear/restricted/engineering/eyes/arglasses_eng
	name = "Engineering AR-E Glasses"
	path = /obj/item/clothing/glasses/omnihud/eng

//Head
/datum/gear/restricted/engineering/head/beret
	name = "Engineering Beret"
	path = /obj/item/clothing/head/beret/engineering

/datum/gear/restricted/engineering/head/operations_cap
	name = "Engineering Cap - Engineering Operations"
	path = /obj/item/clothing/head/operations/engineering

//Back
/datum/gear/restricted/engineering/back/dufflebag
	name = "Engineering Dufflebag"
	path = /obj/item/storage/backpack/dufflebag/eng
	allowed_roles = list("Station Engineer", "Chief Engineer", "Atmospheric Technician", "Talon Engineer")
	cost = 2

//Uniform
/datum/gear/restricted/engineering/uniform/jeans/ce
	name = "Chief Engineer's Jumpjeans"
	path = /obj/item/clothing/under/rank/chief_engineer/jeans
	allowed_roles = list("Chief Engineer")

/datum/gear/restricted/engineering/uniform/fem_jeans/ce
	name = "Chief Engineer's Jumpjeans - Female"
	path = /obj/item/clothing/under/rank/chief_engineer/fem_jeans
	allowed_roles = list("Chief Engineer")

/datum/gear/restricted/engineering/uniform/ce_skirt
	name = "Chief Engineer Skirt"
	path = /obj/item/clothing/under/rank/chief_engineer/skirt
	allowed_roles = list("Chief Engineer")

/datum/gear/restricted/engineering/uniform/ce_pleated_skirt
	name = "Chief Engineer's Pleated Skirt"
	path = /obj/item/clothing/under/rank/chief_engineer/skirt_pleated
	allowed_roles = list("Chief Engineer")

/datum/gear/restricted/engineering/uniform/jeans/atmos
	name = "Atmospheric Technician's Jumpjeans"
	path = /obj/item/clothing/under/rank/atmospheric_technician/jeans
	allowed_roles = list("Chief Engineer", "Atmospheric Technician")

/datum/gear/restricted/engineering/uniform/fem_jeans/atmos
	name = "Atmospheric Technician's Jumpjeans - Female"
	path = /obj/item/clothing/under/rank/atmospheric_technician/fem_jeans
	allowed_roles = list("Chief Engineer", "Atmospheric Technician")

/datum/gear/restricted/engineering/uniform/atmos_skirt
	name = "Atmospherics Skirt"
	path = /obj/item/clothing/under/rank/atmospheric_technician/skirt
	allowed_roles = list("Chief Engineer", "Atmospheric Technician")

/datum/gear/restricted/engineering/uniform/atmos_pleated_skirt
	name = "Atmospherics Pleated Skirt"
	path = /obj/item/clothing/under/rank/atmospheric_technician/skirt_pleated
	allowed_roles = list("Chief Engineer", "Atmospheric Technician")

/datum/gear/restricted/engineering/uniform/jeans
	name = "Engineering Jumpjeans"
	path = /obj/item/clothing/under/rank/engineer/jeans

/datum/gear/restricted/engineering/uniform/fem_jeans
	name = "Engineering Jumpjeans - Female"
	path = /obj/item/clothing/under/rank/engineer/fem_jeans

/datum/gear/restricted/engineering/uniform/eng_skirt
	name = "Engineering Skirt"
	path = /obj/item/clothing/under/rank/engineer/skirt

/datum/gear/restricted/engineering/uniform/eng_skirt_pleated
	name = "Engineer's Pleated Skirt"
	path = /obj/item/clothing/under/rank/engineer/skirt_pleated
	allowed_roles = list("Chief Engineer", "Atmospheric Techician")

/datum/gear/restricted/engineering/uniform/bodysuit
	name = "Engineering Bodysuit"
	path = /obj/item/clothing/under/bodysuit/bodysuithazard

/datum/gear/restricted/engineering/uniform/bodysuit_fem
	name = "Engineering Bodysuit - Female"
	path = /obj/item/clothing/under/bodysuit/bodysuithazard_fem

/datum/gear/restricted/engineering/uniform/turtleneck
	name = "Engineering Turtleneck"
	path = /obj/item/clothing/under/rank/engineer/turtleneck

/datum/gear/restricted/engineering/uniform/turtleneck_fem
	name = "Engineering Turtleneck - Female"
	path = /obj/item/clothing/under/rank/engineer/turtleneck

/datum/gear/restricted/engineering/uniform/turtleneck/alt
	name = "Engineering Turtleneck - Alt"
	path = /obj/item/clothing/under/oricon/utility/sysguard/crew/engineering

/datum/gear/restricted/engineering/uniform/coveralls
	name = "Engineering Uniform - Coveralls"
	path = /obj/item/clothing/under/oricon/utility/fleet/engineering

/datum/gear/restricted/engineering/uniform/fatigues
	name = "Engineering Uniform - Fatigues"
	path = /obj/item/clothing/under/oricon/utility/marine/engineering

//Suit
/datum/gear/restricted/engineering/suit/wintercoat
	name = "Engineering Winter Coat"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/engineering

/datum/gear/restricted/engineering/suit/wintercoat/atmos
	name = "Atmospherics Winter Coat"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/engineering/atmos
	allowed_roles = list("Chief Engineer", "Atmospheric Technician")

/datum/gear/restricted/engineering/suit/wintercoat/ce
	name = "Chief Engineer's Winter Coat"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/engineering/ce
	allowed_roles = list("Chief Engineer")

/datum/gear/restricted/engineering/suit/operations_coat
	name = "Engineering Operations Jacket"
	path = /obj/item/clothing/suit/storage/toggle/operations_coat/engineering

/datum/gear/restricted/engineering/suit/snowsuit
	name = "Engineering Snowsuit"
	path = /obj/item/clothing/suit/storage/snowsuit/engineering

/datum/gear/restricted/engineering/suit/department_jacket
	name = "Engineering Department Jacket"
	path = /obj/item/clothing/suit/storage/toggle/engi_dep_jacket

/datum/gear/restricted/engineering/suit/cloak
	name = "Engineering Cloak"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/engineer

/datum/gear/restricted/engineering/suit/cloak/atmos
	name = "Atmospherics Cloak"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/atmos

/datum/gear/restricted/engineering/suit/cloak/ce
	name = "Chief Engineer - Cloak"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/ce
	allowed_roles = list("Chief Engineer")

/datum/gear/restricted/engineering/suit/poncho
	name = "Engineering Poncho"
	path = /obj/item/clothing/accessory/poncho/roles/engineering

//Shoes
/datum/gear/restricted/engineering/shoes/winterboots
	name = "Engineering - Winter Boots"
	path = /obj/item/clothing/shoes/boots/winter/engineering

/datum/gear/restricted/engineering/shoes/winterboots/atmos
	name = "Atmospherics Winter Boots"
	path = /obj/item/clothing/shoes/boots/winter/atmos
	allowed_roles = list("Chief Engineer", "Atmospheric Technician")



//*Supply
//Eyes
/datum/gear/restricted/supply/eyes/material
	name = "(Supply) Optical Material Scanners"
	path = /obj/item/clothing/glasses/material

/datum/gear/restricted/supply/eyes/material/prescription
	name = "(Supply) Optical Material Scanners - Prescription"
	path = /obj/item/clothing/glasses/material/prescription

//Uniforms
/datum/gear/restricted/supply/uniform/jeans_qm
	name = "Quartermaster Jeans"
	path = /obj/item/clothing/under/rank/cargo/jeans
	allowed_roles = list("Quartermaster")

/datum/gear/restricted/supply/uniform/jeans_qm/female
	name = "Quartermaster Jeans - Female"
	path = /obj/item/clothing/under/rank/cargo/jeans/female
	allowed_roles = list("Quartermaster")

/datum/gear/restricted/supply/uniform/jeans_cargo
	name = "Cargo Jeans"
	path = /obj/item/clothing/under/rank/cargotech/jeans

/datum/gear/restricted/supply/uniform/jeans_cargo/female
	name = "Cargo Jeans - Female"
	path = /obj/item/clothing/under/rank/cargotech/jeans/female

/datum/gear/restricted/supply/uniform/skirt
	name = "Cargo Skirt"
	path = /obj/item/clothing/under/rank/cargotech/skirt

/datum/gear/restricted/supply/uniform/skirt
	name = "Cargo Pleated Skirt"
	path = /obj/item/clothing/under/rank/cargotech/skirt_pleated

/datum/gear/restricted/supply/uniform/skirt/qm
	name = "Quartermaster Skirt"
	path = /obj/item/clothing/under/rank/cargo/skirt
	allowed_roles = list("Quartermaster")

/datum/gear/restricted/supply/uniform/qm_skirt_pleated
	name = "Quartermaster's Pleated Skirt"
	path = /obj/item/clothing/under/rank/cargo/skirt_pleated
	allowed_roles = list("Quartermaster")

/datum/gear/restricted/supply/uniform/bodysuit_miner
	name = "Mining Bodysuit"
	path = /obj/item/clothing/under/bodysuit/bodysuitminer
	allowed_roles = list("Quartermaster", "Shaft Miner")

/datum/gear/restricted/supply/uniform/bodysuit_miner_fem
	name = "Mining Bodysuit - Female"
	path = /obj/item/clothing/under/bodysuit/bodysuitminer_fem
	allowed_roles = list("Quartermaster", "Shaft Miner")

/datum/gear/restricted/supply/uniform/turtleneck
	name = "Cargo Turtleneck"
	path = /obj/item/clothing/under/oricon/utility/sysguard/crew/supply

/datum/gear/restricted/supply/uniform/coveralls
	name = "Cargo Uniform - Coveralls"
	path = /obj/item/clothing/under/oricon/utility/fleet/supply

/datum/gear/restricted/supply/uniform/fatigues
	name = "Cargo Uniform - Fatigues"
	path = /obj/item/clothing/under/oricon/utility/marine/supply

//Suit
/datum/gear/restricted/supply/suit/snowsuit
	name = "Cargo Snowsuit"
	path = /obj/item/clothing/suit/storage/snowsuit/cargo

/datum/gear/restricted/supply/suit/wintercoat
	name = "Cargo Winter Coat"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/cargo

/datum/gear/restricted/supply/suit/wintercoat/qm
	name = "Quartermaster's Winter Coat"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/qm
	allowed_roles = list("Quartermaster")

/datum/gear/restricted/supply/suit/wintercoat/mining
	name = "Mining Winter Coat"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/miner
	allowed_roles = list("Quartermaster", "Shaft Miner")

/datum/gear/restricted/supply/suit/department_jacket
	name = "Cargo Department Jacket"
	path = /obj/item/clothing/suit/storage/toggle/supply_dep_jacket

/datum/gear/restricted/supply/suit/cloak
	name = "Cargo Cloak"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/cargo

/datum/gear/restricted/supply/suit/cloak/mining
	name = "Mining Cloak"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/mining

/datum/gear/restricted/supply/suit/cloak/qm
	name = "Quartermaster - Cloak"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/qm
	allowed_roles = list("Quartermaster")

/datum/gear/restricted/supply/suit/poncho
	name = "Cargo Poncho"
	path = /obj/item/clothing/accessory/poncho/roles/cargo



//Shoes
/datum/gear/restricted/supply/shoes/winterboots
	name = "Cargo Winter Boots"
	path = /obj/item/clothing/shoes/boots/winter/supply

/datum/gear/restricted/supply/shoes/winterboots/mining
	name = "Mining Winter Boots"
	path = /obj/item/clothing/shoes/boots/winter/mining
	allowed_roles = list("Shaft Miner", "Quartermaster")






//*Science
//Head
/datum/gear/restricted/science/head/beret
	name = "Science Beret"
	path = /obj/item/clothing/head/beret/science

//Back
/datum/gear/restricted/science/back/dufflebag
	name = "Science Dufflebag"
	path = /obj/item/storage/backpack/dufflebag/sci
	cost = 2

//Uniform

/datum/gear/restricted/science/uniform/rd_pleated_skirt
	name = "Research Director's Pleated Skirt"
	path = /obj/item/clothing/under/rank/research_director/skirt_pleated
	allowed_roles = list("Research Director")

/datum/gear/restricted/science/uniform/rd_whimsical_skirt
	name = "Research Director's Whimsical Pleated Skirt"
	path = /obj/item/clothing/under/rank/research_director/skirt_pleated/whimsical
	allowed_roles = list("Research Director")

/datum/gear/restricted/science/uniform/rd_turtleneck_skirt
	name = "Research Director's Turtleneck Pleated Skirt"
	path = /obj/item/clothing/under/rank/research_director/skirt_pleated/turtleneck

/datum/gear/restricted/science/uniform/skirt
	name = "Science Skirt"
	path = /obj/item/clothing/under/rank/scientist/skirt

/datum/gear/restricted/science/uniform/skirt_pleated
	name = "Scientist's Pleated Skirt"
	path = /obj/item/clothing/under/rank/scientist/skirt_pleated

/datum/gear/restricted/science/uniform/alt/roboticist
	name = "Roboticist's Jumpsuit - Gold"
	path = /obj/item/clothing/under/rank/roboticist/alt
	allowed_roles = list("Research Director", "Roboticist")

/datum/gear/restricted/science/uniform/skirt/roboticist
	name = "Roboticist Skirt"
	path = /obj/item/clothing/under/rank/roboticist/skirt
	allowed_roles = list("Research Director", "Roboticist")

/datum/gear/restricted/science/uniform/skirt/roboticist_pleated
	name = "Roboticist's Pleated Skirt"
	path = /obj/item/clothing/under/rank/roboticist/skirt_pleated
	allowed_roles = list("Research Director", "Roboticist")

/datum/gear/restricted/science/uniform/turtleneck
	name = "Science Turtleneck"
	path = /obj/item/clothing/under/rank/scientist/turtleneck

/datum/gear/restricted/science/uniform/turtleneck_fem
	name = "Science Turtleneck - Female"
	path = /obj/item/clothing/under/rank/scientist/turtleneck_fem

/datum/gear/restricted/science/uniform/turtleneck/alt
	name = "Science Turtleneck - Alt"
	path = /obj/item/clothing/under/oricon/utility/sysguard/crew/research

/datum/gear/restricted/science/uniform/coveralls
	name = "Science Uniform - Coveralls"
	path = /obj/item/clothing/under/oricon/utility/fleet/exploration

/datum/gear/restricted/science/uniform/fatigues
	name = "Science Uniform - Fatigues"
	path = /obj/item/clothing/under/oricon/utility/marine/exploration

/datum/gear/restricted/science/uniform/jeans
	name = "Science Uniform - Jeans"
	path = /obj/item/clothing/under/rank/scientist/jeans

/datum/gear/restricted/science/uniform/fem_jeans
	name = "Science Uniform - Female Jeans"
	path = /obj/item/clothing/under/rank/scientist/femjeans


//Suit
/datum/gear/restricted/science/suit/wintercoat
	name = "Science Winter Coat"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/science

/datum/gear/restricted/science/suit/wintercoat/rd
	name = "Research Director's Winter Coat"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/science/rd
	allowed_roles = list("Research Director")

/datum/gear/restricted/science/suit/wintercoat/robotics
	name = "Robotics Winter Coat"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/science/robotics


/datum/gear/restricted/science/suit/snowsuit
	name = "Science Snowsuit"
	path = /obj/item/clothing/suit/storage/snowsuit/science

/datum/gear/restricted/science/suit/labcoat
	name = "Research Labcoat"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/science

/datum/gear/restricted/science/suit/labcoat/roboticist
	name = "Research Labcoat - Robotics"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/robotics
	allowed_roles = list("Research Director", "Roboticist")

/datum/gear/restricted/science/suit/labcoat/rd
	name = "Research Labcoat - Research Director"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/rd
	allowed_roles = list("Research Director")

/datum/gear/restricted/science/suit/department_jacket
	name = "Science Department Jacket"
	path = /obj/item/clothing/suit/storage/toggle/sci_dep_jacket

/datum/gear/restricted/science/suit/cloak
	name = "Science Cloak"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/research

/datum/gear/restricted/science/suit/cloak/rd
	name = "Research Director - Cloak"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/rd
	allowed_roles = list("Research Director")

/datum/gear/restricted/science/suit/poncho
	name = "Science Poncho"
	path = /obj/item/clothing/accessory/poncho/roles/science


//Shoes
/datum/gear/restricted/science/shoes/winterboots
	name = "Science - Winter Boots"
	path = /obj/item/clothing/shoes/boots/winter/science


//*Command
//Eyes
/datum/gear/restricted/command/eyes/arglasses_com
	name = "Command AR-B glasses"
	path = /obj/item/clothing/glasses/omnihud/all
	cost = 2

//Head
/datum/gear/restricted/command/head/cap
	name = "Command Cap - Command Operations"
	path = /obj/item/clothing/head/operations

/datum/gear/restricted/command/head/cap/bridge_officer
	name = "Command Cap - Bridge Officer"
	path = /obj/item/clothing/head/bocap

/datum/gear/restricted/command/head/hat
	name = "Command Hat - Bridge Officer"
	path = /obj/item/clothing/head/bohat

//Uniform
/datum/gear/restricted/command/uniform/coveralls
	name = "Command Uniform - Coveralls"
	path = /obj/item/clothing/under/oricon/utility/fleet/command

/datum/gear/restricted/command/uniform/hop_dress
	name = "Head of Personnel Uniform - Dress"
	path = /obj/item/clothing/under/dress/dress_hop
	allowed_roles = list("Head of Personnel")

/datum/gear/restricted/command/uniform/hop_pleated_skirt
	name = "Head of Personnel Uniform - Pleated Skirt"
	path = /obj/item/clothing/under/rank/head_of_personnel/skirt_pleated
	allowed_roles = list("Head of Personnel")

/datum/gear/restricted/command/uniform/hop_hr
	name = "Head of Personnel Uniform - HR Director"
	path = /obj/item/clothing/under/dress/dress_hr
	allowed_roles = list("Head of Personnel")

/datum/gear/restricted/command/uniform/cap_dress
	name = "Facility Director Uniform - Dress"
	path = /obj/item/clothing/under/dress/dress_cap
	allowed_roles = list("Facility Director")

/datum/gear/restricted/command/uniform/cap_skirt_pleated
	name = "Facility Director Uniform - Pleated Skirt"
	path = /obj/item/clothing/under/rank/captain/skirt_pleated
	allowed_roles = list("Facility Director")

/datum/gear/restricted/command/uniform/turtleneck
	name = "Command Uniform - Turtleneck"
	path = /obj/item/clothing/under/oricon/utility/sysguard/officer/crew

/datum/gear/restricted/command/uniform/bridge_officer
	name = "Bridge Officer Uniform"
	path = /obj/item/clothing/under/bridgeofficer
	allowed_roles = list("Command Secretary")

/datum/gear/restricted/command/uniform/bridge_officer/skirt
	name = "Bridge Officer Skirt"
	path = /obj/item/clothing/under/bridgeofficerskirt
	allowed_roles = list("Command Secretary")

/datum/gear/restricted/command/uniform/fatigues
	name = "Command Uniform - Fatigues"
	path = /obj/item/clothing/under/oricon/utility/marine/command

/datum/gear/restricted/command/uniform/bodysuit
	name = "Command Bodysuit"
	path = /obj/item/clothing/under/bodysuit/bodysuitcommand

/datum/gear/restricted/command/uniform/bodysuit_fem
	name = "Command Bodysuit - Female"
	path = /obj/item/clothing/under/bodysuit/bodysuitcommand_fem

//Suit
/datum/gear/restricted/command/suit/operations_coat
	name = "Command Operations Jacket"
	path = /obj/item/clothing/suit/storage/toggle/operations_coat/command

/datum/gear/restricted/command/suit/snowsuit
	name = "Command Snowsuit"
	path = /obj/item/clothing/suit/storage/snowsuit/command

/datum/gear/restricted/command/suit/parade_jacket
	name = "Command Parade Jacket"
	path = /obj/item/clothing/suit/storage/ecdress_ofcr

/datum/gear/restricted/command/suit/dress_jacket
	name = "Command Dress Jacket"
	path = /obj/item/clothing/suit/storage/bridgeofficer

/datum/gear/restricted/command/suit/wintercoat_captain
	name = "Facility Director - Winter Coat"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/captain
	allowed_roles = list("Facility Director")

/datum/gear/restricted/command/suit/wintercoat_hop
	name = "Head of Personnel - Winter Coat"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/captain/hop
	allowed_roles = list("Head of Personnel")

/datum/gear/restricted/command/suit/cloak
	name = "Facility Director - Cloak"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/captain
	allowed_roles = list("Facility Director")

/datum/gear/restricted/command/suit/cloak/hop
	name = "Head of Personnel - Cloak"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/hop
	allowed_roles = list("Head of Personnel")

//Shoes
/datum/gear/restricted/command/shoes/winterboots
	name = "Facility Director - Winter Boots"
	path = /obj/item/clothing/shoes/boots/winter/command
	allowed_roles = list("Facility Director")



//*Service (Poor Service and their ONE item)
/datum/gear/restricted/service/suit/cloak
	name = "Service - Cloak"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/service



//**Multi-Department Items
//*Engineering + Science + Supply
//Eyes
/datum/gear/restricted/eng_sci_supply/eyes/meson
	name = "(Engineering/Science/Supply) Optical Meson Scanners"
	path = /obj/item/clothing/glasses/meson

/datum/gear/restricted/eng_sci_supply/eyes/meson/prescription
	name = "(Engineering/Science/Supply) Optical Meson Scanners - Prescription"
	path = /obj/item/clothing/glasses/meson/prescription

/datum/gear/restricted/eng_sci_supply/eyes/meson/eyepatch
	name = "(Engineering/Science/Supply) Optical Meson Eyepatch"
	path = /obj/item/clothing/glasses/hud/engi/eyepatch

/datum/gear/restricted/eng_sci_supply/eyes/aviator
	name = "(Engineering/Science/Supply) Optical Meson Scanners - Aviators"
	path = /obj/item/clothing/glasses/meson/aviator

/datum/gear/restricted/eng_sci_supply/eyes/aviator/prescription
	name = "(Engineering/Science/Supply) Optical Meson Scanners - Aviators, Prescription"
	path = /obj/item/clothing/glasses/meson/aviator/prescription


//*Security + Command
//Eyes
/datum/gear/restricted/sec_com/eyes/shades
	name = "(Security/Command) Sunglasses"
	path = /obj/item/clothing/glasses/sunglasses

/datum/gear/restricted/sec_com/eyes/shades_big
	name = "(Security/Command) Sunglasses, Fat"
	path = /obj/item/clothing/glasses/sunglasses/big

/datum/gear/restricted/sec_com/eyes/aviators
	name = "(Security/Command) Sunglasses, Aviators"
	path = /obj/item/clothing/glasses/sunglasses/aviator

/datum/gear/restricted/sec_com/eyes/prescriptionsun
	name = "(Security/Command) Sunglasses, Presciption"
	path = /obj/item/clothing/glasses/sunglasses/prescription


//*Medical + Science
/datum/gear/restricted/med_sci/head/cap
	name = "(Medical/Science) MedSci Operations Cap"
	path = /obj/item/clothing/head/operations/medsci

/datum/gear/restricted/med_sci/suit/operations_jacket
	name = "(Medical/Science) MedSci Operations Jacket"
	path = /obj/item/clothing/suit/storage/toggle/operations_coat/medsci
/***********************************************************************************************/
//**Misc. Roles
//*Pilot
/datum/gear/restricted/misc/head/pilot
	name = "Pilot Helmet"
	path = /obj/item/clothing/head/pilot/alt
	allowed_roles = list("Pilot")

/datum/gear/restricted/misc/uniform/pilot
	name = "Pilot Uniform"
	path = /obj/item/clothing/under/rank/pilot2
	allowed_roles = list("Pilot")

//*Bartender
/datum/gear/restricted/misc/uniform/bartender_skirt
	name = "Bartender Uniform - Skirt"
	path = /obj/item/clothing/under/rank/bartender/skirt
	allowed_roles = list("Bartender")

/datum/gear/restricted/misc/uniform/bartender_skirt_pleated
	name = "Bartender Uniform - Pleated Skirt"
	path = /obj/item/clothing/under/rank/bartender/skirt_pleated
	allowed_roles = list("Bartender")

/datum/gear/restricted/misc/uniform/bartender_btc
	name = "Bartender Uniform - BTC"
	path = /obj/item/clothing/under/btcbartender
	allowed_roles = list("Bartender")

/datum/gear/restricted/misc/suit/wintercoat_bartender
	name = "Bartender Winter Coat"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/bar
	allowed_roles = list("Bartender")

//*Chaplain
/datum/gear/restricted/misc/uniform/chaplain/chap_skirt_pleated
	name = "Chaplain's Pleated Skirt"
	path = /obj/item/clothing/under/rank/chaplain/skirt_pleated
	allowed_roles = list("Chaplain")

//*Chef
/datum/gear/restricted/misc/uniform/chef/chef_skirt_pleated
	name = "Chef's Pleated Skirt"
	path = /obj/item/clothing/under/rank/chef/skirt_pleated
	allowed_roles = list("Chef")

//*Internal Affairs Agent
/datum/gear/restricted/misc/uniform/iaskirt
	name = "Internal Affairs Uniform - Skirt"
	path = /obj/item/clothing/under/rank/internalaffairs/skirt
	allowed_roles = list("Internal Affairs Agent")

//*Janitor
/datum/gear/restricted/misc/uniform/janitor_fem
	name = "Janitor's Jumpsuit - Female"
	path = /obj/item/clothing/under/rank/janitor_fem
	allowed_roles = list("Janitor")

/datum/gear/restricted/misc/uniform/janitor_alt
	name = "Janitor Jumpsuit - Alt"
	path = /obj/item/clothing/under/rank/janitor/starcon
	allowed_roles = list("Janitor")

/datum/gear/restricted/misc/uniform/janitor_pleated_skirt
	name = "Janitor Jumpskirt - Pleated"
	path = /obj/item/clothing/under/rank/janitor/skirt_pleated
	allowed_roles = list("Janitor")

/datum/gear/restricted/misc/shoes/janitor
	name = "Janitor Galoshes - Black"
	path = /obj/item/clothing/shoes/galoshes/black
	allowed_roles = list("Janitor")

/datum/gear/restricted/janitor/wintercoat
	name = "Janitor's Winter Coat"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/janitor
	allowed_roles = list("Janitor")

/datum/gear/restricted/misc/shoes/janitor/alt
	name = "Janitor Galoshes - Dark-Purple"
	path = /obj/item/clothing/shoes/galoshes/starcon
	allowed_roles = list("Janitor")
	cost = 2

//*Exploration
/datum/gear/restricted/misc/uniform/bodysuit_explo/command
	name = "Exploration Command Bodysuit"
	path = /obj/item/clothing/under/bodysuit/bodysuitexplocom
	allowed_roles = list("Research Director", "Pathfinder")

/datum/gear/restricted/misc/uniform/bodysuit_explo/command_fem
	name = "Exploration Command Bodysuit - Female"
	path = /obj/item/clothing/under/bodysuit/bodysuitexplocom_fem
	allowed_roles = list("Research Director", "Pathfinder")

/datum/gear/restricted/misc/uniform/bodysuit_explo
	name = "Exploration Bodysuit"
	path = /obj/item/clothing/under/bodysuit/bodysuitexplo
	allowed_roles = list("Research Director", "Pathfinder", "Explorer", "Field Medic", "Pilot")

/datum/gear/restricted/misc/uniform/bodysuit_explo_fem
	name = "Exploration Bodysuit - Female"
	path = /obj/item/clothing/under/bodysuit/bodysuitexplo_fem
	allowed_roles = list("Research Director", "Pathfinder", "Explorer", "Field Medic", "Pilot")

/datum/gear/restricted/misc/suit/wintercoat_field_medic
	name = "Field Medic Winter Coat"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/medical/sar
	allowed_roles = list("Field Medic")

//*Botany

/datum/gear/restricted/misc/uniform/hydro_pleated_skirt
	name = "Hydroponics Pleated Skirt"
	path = /obj/item/clothing/under/rank/hydroponics/skirt_pleated
	allowed_roles = list("Botanist")

/datum/gear/restricted/misc/suit/wintercoat_hydroponics
	name = "Hydroponics Winter Coat"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/hydro
	allowed_roles = list("Botanist")

/datum/gear/restricted/misc/shoes/winterboots_hydroponics
	name = "Hydroponics Winter Boots"
	path = /obj/item/clothing/shoes/boots/winter/hydro
	allowed_roles = list("Botanist")


//*This clusterfuck of access combinations
//*Now with Talon roles!
/datum/gear/restricted/misc/accessory/holster
	name = "(Command/Security/Exploration/Talon) Holster - Selection"
	path = /obj/item/clothing/accessory/holster
	cost = 3
	allowed_roles = list(
	"Facility Director", "Head of Personnel", "Chief Medical Officer", "Head of Security", "Research Director", "Chief Engineer", "Command Secretary",
	"Security Officer", "Warden", "Head of Security", "Detective",
	"Field Medic", "Explorer", "Pathfinder", "Pilot",
	"Talon Captain", "Talon Doctor", "Talon Medic", "Talon Engineer", "Talon Pilot", "Talon Guard")

/datum/gear/restricted/misc/accessory/holster/New()
	..()
	var/list/holsters = list()
	for(var/holster in typesof(/obj/item/clothing/accessory/holster))
		var/obj/item/clothing/accessory/holster_type = holster
		holsters[initial(holster_type.name)] = holster_type
	gear_tweaks += new/datum/gear_tweak/path(tim_sort(holsters, /proc/cmp_text_asc))
