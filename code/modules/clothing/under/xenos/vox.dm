/obj/item/clothing/under/vox
	has_sensor = 0
	species_restricted = list(SPECIES_VOX)
	starting_accessories = list(/obj/item/clothing/accessory/storage/vox)	// Dont' start with a backback, so free webbing
	flags = PHORONGUARD

/obj/item/clothing/under/vox/vox_casual
	name = "alien clothing"
	desc = "This doesn't look very comfortable."
	icon_state = "vox-casual-1"
	item_state = "vox-casual-1"
	body_parts_covered = LEGS

/obj/item/clothing/under/vox/vox_robes
	name = "alien robes"
	desc = "Weird and flowing!"
	icon_state = "vox-casual-2"
	item_state = "vox-casual-2"

/obj/item/clothing/under/vox/simonpants
	name = "simon pants"
	desc = "Based off the clothing of a hero so famous, even the Vox had to emulate his style."
	icon_state = "simonpants"
	item_state = "simonpants"
	
//Vox Accessories
/obj/item/clothing/accessory/storage/vox
	name = "alien mesh"
	desc = "An alien mesh. Seems to be made up mostly of pockets and writhing flesh."
	icon_state = "webbing-vox"

	flags = PHORONGUARD

	slots = 3

/obj/item/clothing/accessory/storage/vox/New()
	..()
	hold.max_storage_space = slots * ITEMSIZE_COST_NORMAL
	hold.max_w_class = ITEMSIZE_NORMAL

//Vox Pressure Suits
/obj/item/clothing/under/pressuresuit
	species_restricted = list(SPECIES_VOX)
	name = "vox pressure suit"
	desc = "A lightly-plated jumpsuit, fitted to an alien frame. Now in classic grey!"
	icon = 'icons/obj/clothing/uniforms.dmi'
	icon_override = 'icons/mob/species/vox/uniform.dmi'
	flags_inv = HIDEGLOVES|HIDESHOES
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	flags = PHORONGUARD

/obj/item/clothing/under/pressuresuit/voxcivassistant
	name = "assistant pressure suit"
	desc = "A lightly-plated jumpsuit, fitted to an alien frame. Now in classic grey!"
	icon_state = "vox-civ-assistant"
	item_state = "vox-civ-assistant"
	
/obj/item/clothing/under/pressuresuit/voxcivbartender
	name = "bartender pressure suit"
	desc = "A lightly-plated jumpsuit, fitted to an alien frame. Sylish black, complete with a little bowtie."
	icon_state = "vox-civ-bartender"
	item_state = "vox-civ-bartender"
	
/obj/item/clothing/under/pressuresuit/voxcivchef
	name = "chef pressure suit"
	desc = "A lightly-plated jumpsuit, fitted to an alien frame. Comes with an integrated apron!"
	icon_state = "vox-civ-chef"
	item_state = "vox-civ-chef"

/obj/item/clothing/under/pressuresuit/voxcivchaplain
	name = "chaplain pressure suit"
	desc = "A lightly-plated jumpsuit, fitted to an alien frame. Religious advice from a Vox should be taken with several grains of salt."
	icon_state = "vox-civ-chaplain"
	item_state = "vox-civ-chaplain"

/obj/item/clothing/under/pressuresuit/voxcivlibrarian
	name = "librarian pressure suit"
	desc = "A lightly-plated jumpsuit, fitted to an alien frame. More stylish than others. Don't eat the books."
	icon_state = "vox-civ-librarian"
	item_state = "vox-civ-librarian"

/obj/item/clothing/under/pressuresuit/voxcivsecurity
	name = "ecurity pressure suit"
	desc = "A lightly-plated jumpsuit, fitted to an alien frame."
	icon_state = "vox-civ-security"
	item_state = "vox-civ-security"
	
/obj/item/clothing/under/pressuresuit/voxcivmedical
	name = "medical pressure suit"
	desc = "A lightly-plated jumpsuit, fitted to an alien frame."
	icon_state = "vox-civ-medical"
	item_state = "vox-civ-medical"
	
/obj/item/clothing/under/pressuresuit/voxcivengineer
	name = "engineer pressure suit"
	desc = "A lightly-plated jumpsuit, fitted to an alien frame."
	icon_state = "vox-civ-engineer"
	item_state = "vox-civ-engineer"
	
/obj/item/clothing/under/pressuresuit/voxcivscience
	name = "scientist pressure suit"
	desc = "A lightly-plated jumpsuit, fitted to an alien frame."
	icon_state = "vox-civ-science"
	item_state = "vox-civ-science"
	
/obj/item/clothing/under/pressuresuit/voxcivrd
	name = "research director pressure suit"
	desc = "A lightly-plated jumpsuit, fitted to an alien frame."
	icon_state = "vox-civ-rd"
	item_state = "vox-civ-rd"
	
/obj/item/clothing/under/pressuresuit/voxcivce
	name = "chief engineer pressure suit"
	desc = "A lightly-plated jumpsuit, fitted to an alien frame."
	icon_state = "vox-civ-ce"
	item_state = "vox-civ-ce"
	
