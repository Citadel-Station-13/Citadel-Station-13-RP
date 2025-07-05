#define STD_DEF(what) \
	name = what; \
	desc = "A costume of unknown origin."; \
	w_class = WEIGHT_CLASS_SMALL; \
	armor_type = /datum/armor/none; \
	atom_flags = PHORONGUARD; \
	inv_hide_flags = HIDEHOLSTER|HIDEFACE|BLOCKHAIR; \
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE;

#define STD_DEF_NON_HIDING(what) \
	name = what; \
	desc = "A costume of unknown origin."; \
	w_class = WEIGHT_CLASS_SMALL; \
	armor_type = /datum/armor/none; \
	atom_flags = PHORONGUARD; \
	inv_hide_flags = HIDEHOLSTER; \
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE;

/**
 * i decided it'd be really funny if we had pseudo antags running around as a reminder that our server could have antags (and therefore fun) but don't
 */
/datum/loadout_entry/seasonal/masquarade
	holiday_whitelist = list(HALLOWEEN)
	category = "Halloween - Masquarade"
	abstract_type = /datum/loadout_entry/seasonal/masquarade
	description = "This is not a real antagonist item. It is highly recommended you rename and set their description yourself using gear tweaks."
	cost = 1
	var/antag_name

/datum/loadout_entry/seasonal/masquarade/New()
	if(isnull(name))
		name = "[type]"		// yeah we're saving by type, sue me lmao
	if(antag_name)
		display_name = "[antag_name] - [initial(display_name)]"
	. = ..()

/**
 * syndicate
 */
/datum/loadout_entry/seasonal/masquarade/syndicate
	antag_name = "Syndie"
	abstract_type = /datum/loadout_entry/seasonal/masquarade/syndicate

/datum/loadout_entry/seasonal/masquarade/syndicate/sneaksuit_under
	display_name = "Sneaksuit Uniform"
	path = /obj/item/clothing/under/fake_sneaksuit

/obj/item/clothing/under/fake_sneaksuit
	STD_DEF("cloth uniform")
	icon_state = "under"
	icon = 'icons/antagonists/syndicate/items/clothing/sneaksuit.dmi'
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	cold_protection_cover = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/datum/loadout_entry/seasonal/masquarade/syndicate/sneaksuit_armor
	display_name = "Sneaksuit Armor"
	path = /obj/item/clothing/suit/storage/fake_sneaksuit

/obj/item/clothing/suit/storage/fake_sneaksuit
	STD_DEF("plastic armor")
	icon_state = "armor"
	icon = 'icons/antagonists/syndicate/items/clothing/sneaksuit.dmi'
	inhand_default_type = INHAND_DEFAULT_ICON_SUITS
	inhand_state = "armor"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL | WORN_RENDER_INHAND_ALLOW_DEFAULT
	body_cover_flags = UPPER_TORSO|LOWER_TORSO
	cold_protection_cover = UPPER_TORSO|LOWER_TORSO

/datum/loadout_entry/seasonal/masquarade/syndicate/sneaksuit_gloves
	display_name = "Sneaksuit Gloves"
	path = /obj/item/clothing/gloves/fake_sneaksuit

/obj/item/clothing/gloves/fake_sneaksuit
	STD_DEF("plastic gloves")
	icon_state = "gloves"
	icon = 'icons/antagonists/syndicate/items/clothing/sneaksuit.dmi'
	inhand_default_type = INHAND_DEFAULT_ICON_GLOVES
	inhand_state = "black"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL | WORN_RENDER_INHAND_ALLOW_DEFAULT
	body_cover_flags = HANDS
	cold_protection_cover = HANDS

/datum/loadout_entry/seasonal/masquarade/syndicate/sneaksuit_helmet
	display_name = "Sneaksuit Helmet"
	path = /obj/item/clothing/head/fake_sneaksuit

/obj/item/clothing/head/fake_sneaksuit
	STD_DEF("plastic helmet")
	icon_state = "helmet"
	icon = 'icons/antagonists/syndicate/items/clothing/sneaksuit.dmi'
	inhand_default_type = INHAND_DEFAULT_ICON_HATS
	inhand_state = "helmet"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL | WORN_RENDER_INHAND_ALLOW_DEFAULT
	body_cover_flags = HEAD|EYES
	clothing_flags = ALLOWINTERNALS
	cold_protection_cover = HEAD

/datum/loadout_entry/seasonal/masquarade/syndicate/sneaksuit_shoes
	display_name = "Sneaksuit Boots"
	path = /obj/item/clothing/shoes/fake_sneaksuit

/obj/item/clothing/shoes/fake_sneaksuit
	STD_DEF("plastic shoes")
	icon_state = "boots"
	icon = 'icons/antagonists/syndicate/items/clothing/sneaksuit.dmi'
	inhand_default_type = INHAND_DEFAULT_ICON_SHOES
	inhand_state = "cult"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL | WORN_RENDER_INHAND_ALLOW_DEFAULT
	body_cover_flags = FEET
	cold_protection_cover = FEET

/datum/loadout_entry/seasonal/masquarade/syndicate/sneaksuit_mask
	display_name = "Sneaksuit Mask"
	path = /obj/item/clothing/mask/fake_sneaksuit

/obj/item/clothing/mask/fake_sneaksuit
	STD_DEF_NON_HIDING("plastic mask")
	icon_state = "mask"
	icon = 'icons/antagonists/syndicate/items/clothing/sneaksuit.dmi'
	inhand_default_type = INHAND_DEFAULT_ICON_MASKS
	inhand_state = "gas"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL | WORN_RENDER_INHAND_ALLOW_DEFAULT
	body_cover_flags = HEAD|EYES
	clothing_flags = ALLOWINTERNALS
	cold_protection_cover = HEAD

/datum/loadout_entry/seasonal/masquarade/syndicate/contractor_helmet
	display_name = "Contractor Helmet"
	path = /obj/item/clothing/head/fake_contractor

/obj/item/clothing/head/fake_contractor
	STD_DEF("plastic helmet")
	icon_state = "helm"
	icon = 'icons/antagonists/syndicate/items/clothing/contractor.dmi'
	inhand_default_type = INHAND_DEFAULT_ICON_HATS
	inhand_state = "helmet"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL | WORN_RENDER_INHAND_ALLOW_DEFAULT
	body_cover_flags = HEAD|EYES
	clothing_flags = ALLOWINTERNALS
	cold_protection_cover = HEAD

/datum/loadout_entry/seasonal/masquarade/syndicate/contractor_suit
	display_name = "Contractor Suit"
	path = /obj/item/clothing/suit/storage/fake_contractor

/obj/item/clothing/suit/storage/fake_contractor
	STD_DEF("plastic suit")
	icon_state = "suit"
	icon = 'icons/antagonists/syndicate/items/clothing/contractor.dmi'
	inhand_default_type = INHAND_DEFAULT_ICON_GLOVES
	inhand_state = "armor"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL | WORN_RENDER_INHAND_ALLOW_DEFAULT
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS|HANDS|FEET
	cold_protection_cover = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS|HANDS|FEET

/datum/loadout_entry/seasonal/masquarade/syndicate/esword
	display_name = "Energy Sword (toy)"
	path = /obj/item/toy/sword

/*
/datum/loadout_entry/seasonal/masquarade/syndicate/ebow
	display_name = "Energy Bow (toy)"
	path = /obj/item/gun/
*/

/datum/loadout_entry/seasonal/masquarade/syndicate/revolver
	display_name = ".357 revolver (capgun)"
	path = /obj/item/gun/projectile/ballistic/revolver/capgun

/**
 * changeling
 */
/datum/loadout_entry/seasonal/masquarade/changeling
	antag_name = "Changeling"
	abstract_type = /datum/loadout_entry/seasonal/masquarade/changeling

/datum/loadout_entry/seasonal/masquarade/changeling/chitin_hood
	display_name = "Chitin Hood"
	path = /obj/item/clothing/head/fake_chitin

/obj/item/clothing/head/fake_chitin
	STD_DEF("plastic suit")
	icon_state = "lingarmorhelmet"
	icon = 'icons/antagonists/changeling/items/clothing.dmi'
	default_worn_icon = 'icons/antagonists/changeling/on_mob/clothing.dmi'
	body_cover_flags = HEAD|EYES
	clothing_flags = ALLOWINTERNALS
	cold_protection_cover = HEAD

/datum/loadout_entry/seasonal/masquarade/changeling/chitin_suit
	display_name = "Chitin Suit"
	path = /obj/item/clothing/suit/storage/fake_chitin

/obj/item/clothing/suit/storage/fake_chitin
	STD_DEF("plastic suit")
	icon_state = "lingarmor"
	icon = 'icons/antagonists/changeling/items/clothing.dmi'
	default_worn_icon = 'icons/antagonists/changeling/on_mob/clothing.dmi'
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS|HANDS|FEET
	cold_protection_cover = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS|HANDS|FEET

/datum/loadout_entry/seasonal/masquarade/changeling/flesh_hood
	display_name = "Flesh Hood"
	path = /obj/item/clothing/head/fake_flesh

/obj/item/clothing/head/fake_flesh
	STD_DEF("plastic helmet")
	icon_state = "lingspacehelmet"
	icon = 'icons/antagonists/changeling/items/clothing.dmi'
	default_worn_icon = 'icons/antagonists/changeling/on_mob/clothing.dmi'
	body_cover_flags = HEAD|EYES
	clothing_flags = ALLOWINTERNALS
	cold_protection_cover = HEAD

/datum/loadout_entry/seasonal/masquarade/changeling/flesh_suit
	display_name = "Flesh Suit"
	path = /obj/item/clothing/suit/storage/fake_flesh

/obj/item/clothing/suit/storage/fake_flesh
	STD_DEF("plastic suit")
	icon_state = "lingspacesuit"
	icon = 'icons/antagonists/changeling/items/clothing.dmi'
	default_worn_icon = 'icons/antagonists/changeling/on_mob/clothing.dmi'
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS|HANDS|FEET
	cold_protection_cover = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS|HANDS|FEET

/datum/loadout_entry/seasonal/masquarade/changeling/arm_blade
	display_name = "Arm Blade"
	path = /obj/item/toy/armblade

/obj/item/toy/armblade
	STD_DEF("plastic blade")
	icon_state = "arm_blade"
	icon = 'icons/antagonists/changeling/items/weapons.dmi'
	item_icons = list(
		SLOT_ID_LEFT_HAND = 'icons/antagonists/changeling/on_mob/left_hand.dmi',
		SLOT_ID_RIGHT_HAND = 'icons/antagonists/changeling/on_mob/right_hand.dmi'
	)

/datum/loadout_entry/seasonal/masquarade/changeling/tentacle
	display_name = "Tentacle"
	path = /obj/item/toy/tentacle

/obj/item/toy/tentacle
	STD_DEF("plastic tentacle")
	icon_state = "tentacle"
	icon = 'icons/antagonists/changeling/items/weapons.dmi'
	item_icons = list(
		SLOT_ID_LEFT_HAND = 'icons/antagonists/changeling/on_mob/left_hand.dmi',
		SLOT_ID_RIGHT_HAND = 'icons/antagonists/changeling/on_mob/right_hand.dmi'
	)

/datum/loadout_entry/seasonal/masquarade/changeling/claw
	display_name = "Claws"
	path = /obj/item/clothing/gloves/fake_chitin

/obj/item/clothing/gloves/fake_chitin
	STD_DEF("plastic claws")
	icon_state = "ling_gauntlets"
	icon = 'icons/antagonists/changeling/items/clothing.dmi'
	default_worn_icon = 'icons/antagonists/changeling/on_mob/clothing.dmi'

/datum/loadout_entry/seasonal/masquarade/changeling/shield
	display_name = "Shield"
	path = /obj/item/toy/flesh_shield

/obj/item/toy/flesh_shield
	STD_DEF("plastic shield")
	icon_state = "ling_shield"
	icon = 'icons/antagonists/changeling/items/weapons.dmi'
	item_icons = list(
		SLOT_ID_LEFT_HAND = 'icons/antagonists/changeling/on_mob/left_hand.dmi',
		SLOT_ID_RIGHT_HAND = 'icons/antagonists/changeling/on_mob/right_hand.dmi'
	)

/**
 * clockcult
 */
/datum/loadout_entry/seasonal/masquarade/clockcult
	antag_name = "Clockcult"
	abstract_type = /datum/loadout_entry/seasonal/masquarade/clockcult

/datum/loadout_entry/seasonal/masquarade/clockcult/helmet
	display_name = "Helmet"
	path = /obj/item/clothing/head/fake_brass

/obj/item/clothing/head/fake_brass
	STD_DEF("brass helmet")
	icon = 'icons/antagonists/clockcult/items/clothing.dmi'
	default_worn_icon = 'icons/antagonists/clockcult/on_mob/clothing.dmi'
	icon_state = "clockwork_helmet"
	body_cover_flags = HEAD|EYES
	clothing_flags = ALLOWINTERNALS
	cold_protection_cover = HEAD

/datum/loadout_entry/seasonal/masquarade/clockcult/suit
	display_name = "Armor"
	path = /obj/item/clothing/suit/storage/fake_brass

/obj/item/clothing/suit/storage/fake_brass
	STD_DEF("brass cuirass")
	icon = 'icons/antagonists/clockcult/items/clothing.dmi'
	default_worn_icon = 'icons/antagonists/clockcult/on_mob/clothing.dmi'
	icon_state = "clockwork_cuirass"
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	cold_protection_cover = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS

/datum/loadout_entry/seasonal/masquarade/clockcult/boots
	display_name = "Boots"
	path = /obj/item/clothing/shoes/fake_brass

/obj/item/clothing/shoes/fake_brass
	STD_DEF("brass boots")
	icon = 'icons/antagonists/clockcult/items/clothing.dmi'
	default_worn_icon = 'icons/antagonists/clockcult/on_mob/clothing.dmi'
	icon_state = "clockwork_treads"
	body_cover_flags = FEET
	cold_protection_cover = FEET

/datum/loadout_entry/seasonal/masquarade/clockcult/gloves
	display_name = "Gloves"
	path = /obj/item/clothing/gloves/fake_brass

/obj/item/clothing/gloves/fake_brass
	STD_DEF("brass gloves")
	icon = 'icons/antagonists/clockcult/items/clothing.dmi'
	default_worn_icon = 'icons/antagonists/clockcult/on_mob/clothing.dmi'
	icon_state = "clockwork_gauntlets"
	body_cover_flags = HANDS
	cold_protection_cover = HANDS

/datum/loadout_entry/seasonal/masquarade/clockcult/slab
	display_name = "Slab"
	path = /obj/item/toy/slab

/obj/item/toy/slab
	STD_DEF("brass watch")
	icon = 'icons/antagonists/clockcult/items/slab.dmi'
	icon_state = "clockwork_slab"
	item_icons = list(
		SLOT_ID_LEFT_HAND = 'icons/antagonists/clockcult/on_mob/left_hand.dmi',
		SLOT_ID_RIGHT_HAND = 'icons/antagonists/clockcult/on_mob/right_hand.dmi'
	)

/datum/loadout_entry/seasonal/masquarade/clockcult/spear
	display_name = "Spear"
	path = /obj/item/toy/ratvar_spear

/obj/item/toy/ratvar_spear
	STD_DEF("plastic spear")
	icon = 'icons/antagonists/clockcult/items/weapons.dmi'
	icon_state = "ratvarian_spear"
	item_icons = list(
		SLOT_ID_LEFT_HAND = 'icons/antagonists/clockcult/on_mob/left_hand.dmi',
		SLOT_ID_RIGHT_HAND = 'icons/antagonists/clockcult/on_mob/right_hand.dmi'
	)

/datum/loadout_entry/seasonal/masquarade/clockcult/shield
	display_name = "Shield"
	path = /obj/item/toy/ratvar_shield

/obj/item/toy/ratvar_shield
	STD_DEF("plastic shield")
	icon = 'icons/antagonists/clockcult/items/weapons.dmi'
	icon_state = "ratvarian_shield"
	item_icons = list(
		SLOT_ID_LEFT_HAND = 'icons/antagonists/clockcult/on_mob/left_hand.dmi',
		SLOT_ID_RIGHT_HAND = 'icons/antagonists/clockcult/on_mob/right_hand.dmi'
	)

/datum/loadout_entry/seasonal/masquarade/clockcult/claw
	display_name = "Claw"
	path = /obj/item/toy/ratvar_claw

/obj/item/toy/ratvar_claw
	STD_DEF("plastic claw")
	icon = 'icons/antagonists/clockcult/items/weapons.dmi'
	icon_state = "brass_claw"
	item_icons = list(
		SLOT_ID_LEFT_HAND = 'icons/antagonists/clockcult/on_mob/left_hand.dmi',
		SLOT_ID_RIGHT_HAND = 'icons/antagonists/clockcult/on_mob/right_hand.dmi'
	)

/datum/loadout_entry/seasonal/masquarade/clockcult/visor
	display_name = "Visor"
	path = /obj/item/clothing/glasses/fake_judicial

/obj/item/clothing/glasses/fake_judicial
	STD_DEF("brass visor")
	icon = 'icons/antagonists/clockcult/items/clothing.dmi'
	default_worn_icon = 'icons/antagonists/clockcult/on_mob/clothing.dmi'
	icon_state = "judicial_visor_1"

/datum/loadout_entry/seasonal/masquarade/clockcult/spectacles
	display_name = "Spectacles"
	path = /obj/item/clothing/glasses/fake_spectacles

/obj/item/clothing/glasses/fake_spectacles
	STD_DEF("brass boots")
	icon = 'icons/antagonists/clockcult/items/clothing.dmi'
	default_worn_icon = 'icons/antagonists/clockcult/on_mob/clothing.dmi'
	icon_state = "wraith_specs"

/**
 * cult
 */
/datum/loadout_entry/seasonal/masquarade/cult
	antag_name = "Cult"
	abstract_type = /datum/loadout_entry/seasonal/masquarade/cult

/datum/loadout_entry/seasonal/masquarade/cult/spear
	display_name = "Halbard"
	path = /obj/item/toy/blood_halbard

/obj/item/toy/blood_halbard
	STD_DEF("plastic halbard")
	icon = 'icons/antagonists/cult/items/weapons.dmi'
	icon_state = "bloodspear0"
	item_icons = list(
		SLOT_ID_LEFT_HAND = 'icons/antagonists/cult/on_mob/left_hand.dmi',
		SLOT_ID_RIGHT_HAND = 'icons/antagonists/cult/on_mob/right_hand.dmi'
	)

/datum/loadout_entry/seasonal/masquarade/cult/shield
	display_name = "Mirror Shield"
	path = /obj/item/toy/mirror_shield

/obj/item/toy/mirror_shield
	STD_DEF("glass shield")
	icon = 'icons/antagonists/cult/items/weapons.dmi'
	icon_state = "mirror_shield"
	item_icons = list(
		SLOT_ID_LEFT_HAND = 'icons/antagonists/cult/on_mob/left_hand.dmi',
		SLOT_ID_RIGHT_HAND = 'icons/antagonists/cult/on_mob/right_hand.dmi'
	)

/datum/loadout_entry/seasonal/masquarade/cult/hardsuit
	display_name = "Hardsuit"
	path = /obj/item/clothing/suit/storage/hooded/fake_cult_hardsuit

/obj/item/clothing/suit/storage/hooded/fake_cult_hardsuit
	STD_DEF("plastic suit")
	icon = 'icons/clothing/suit/armor/cult.dmi'
	icon_state = "cult"
	hoodtype = /obj/item/clothing/head/hood/fake_cult_hardsuit
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS|FEET|HANDS
	cold_protection_cover = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS|FEET|HANDS
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL

/obj/item/clothing/head/hood/fake_cult_hardsuit
	STD_DEF("hood")
	icon = 'icons/clothing/suit/armor/cult.dmi'
	icon_state = "culthelm"
	body_cover_flags = HEAD|EYES
	clothing_flags = ALLOWINTERNALS
	cold_protection_cover = HEAD
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL

/datum/loadout_entry/seasonal/masquarade/cult/robes_new
	display_name = "Robes (new)"
	path = /obj/item/clothing/suit/storage/hooded/fake_cult_robes_new

/obj/item/clothing/suit/storage/hooded/fake_cult_robes_new
	STD_DEF("plastic suit")
	icon = 'icons/clothing/suit/antag/cult.dmi'
	icon_state = "cultrobesalt"
	hoodtype = /obj/item/clothing/head/hood/fake_cult_robes_new
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	cold_protection_cover = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL

/obj/item/clothing/head/hood/fake_cult_robes_new
	STD_DEF("hood")
	icon = 'icons/clothing/suit/antag/cult.dmi'
	icon_state = "culthoodalt"
	body_cover_flags = HEAD
	cold_protection_cover = HEAD
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL

/datum/loadout_entry/seasonal/masquarade/cult/robes_old
	display_name = "Robes (old)"
	path = /obj/item/clothing/suit/storage/hooded/fake_cult_robes_old

/obj/item/clothing/suit/storage/hooded/fake_cult_robes_old
	STD_DEF("plastic suit")
	icon = 'icons/clothing/suit/antag/cult.dmi'
	icon_state = "cultrobes"
	hoodtype = /obj/item/clothing/head/hood/fake_cult_robes_old
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	cold_protection_cover = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL

/obj/item/clothing/head/hood/fake_cult_robes_old
	STD_DEF("hood")
	icon = 'icons/clothing/suit/antag/cult.dmi'
	icon_state = "culthood"
	body_cover_flags = HEAD
	cold_protection_cover = HEAD
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL

/datum/loadout_entry/seasonal/masquarade/cult/sword
	display_name = "Sword"
	path = /obj/item/toy/cultsword

/**
 * heretic
 */
/datum/loadout_entry/seasonal/masquarade/heretic
	antag_name = "Heretic"
	abstract_type = /datum/loadout_entry/seasonal/masquarade/heretic

/datum/loadout_entry/seasonal/masquarade/heretic/robes
	display_name = "Robes"
	path = /obj/item/clothing/suit/storage/hooded/fake_heretic

/obj/item/clothing/suit/storage/hooded/fake_heretic
	STD_DEF("cloth robes")
	icon = 'icons/clothing/suit/antag/heretic.dmi'
	icon_state = "eldritcharmor"
	hoodtype = /obj/item/clothing/head/hood/fake_heretic
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	cold_protection_cover = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL

/obj/item/clothing/head/hood/fake_heretic
	STD_DEF("hood")
	icon = 'icons/clothing/suit/antag/heretic.dmi'
	icon_state = "eldritchhood"
	body_cover_flags = HEAD
	cold_protection_cover = HEAD
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL

/datum/loadout_entry/seasonal/masquarade/heretic/void_cloak
	display_name = "Void Cloak"
	path = /obj/item/clothing/suit/storage/hooded/fake_void

/obj/item/clothing/suit/storage/hooded/fake_void
	STD_DEF("cloth cloak")
	icon = 'icons/clothing/suit/antag/heretic.dmi'
	icon_state = "voidcloak"
	hoodtype = /obj/item/clothing/head/hood/fake_void
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	cold_protection_cover = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL

/obj/item/clothing/head/hood/fake_void
	STD_DEF_NON_HIDING("hood")
	icon = 'icons/clothing/suit/antag/heretic.dmi'
	icon_state = "voidhood"
	body_cover_flags = HEAD|EYES
	clothing_flags = ALLOWINTERNALS
	cold_protection_cover = HEAD
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL

/*
/datum/loadout_entry/seasonal/masquarade/heretic/living_heart
	display_name = "Heart"
	path = /obj/item/toy/heretic_heart

/obj/item/toy/heretic_heart

/datum/loadout_entry/seasonal/masquarade/heretic/tome
	display_name = "Tome"
	path = /obj/item/toy/heretic_tome

/obj/item/toy/heretic_tome

/datum/loadout_entry/seasonal/masquarade/heretic/laughing_mask
	display_name = "Laughing Mask"
	path = /obj/item/clothing/mask/fake_laughing_mask

/obj/item/clothing/mask/fake_laughing_mask
*/

/datum/loadout_entry/seasonal/masquarade/heretic/blade
	display_name = "Eldritch Blade"
	path = /obj/item/toy/heretic_blade

/datum/loadout_entry/seasonal/masquarade/heretic/blade/ash
	display_name = "Ash Blade"
	path = /obj/item/toy/heretic_blade/ash

/datum/loadout_entry/seasonal/masquarade/heretic/blade/flesh
	display_name = "Flesh Blade"
	path = /obj/item/toy/heretic_blade/flesh

/datum/loadout_entry/seasonal/masquarade/heretic/rust
	display_name = "Rust Blade"
	path = /obj/item/toy/heretic_blade/rust

/datum/loadout_entry/seasonal/masquarade/heretic/blade/void
	display_name = "Void Blade"
	path = /obj/item/toy/heretic_blade/void

/obj/item/toy/heretic_blade
	STD_DEF("plastic blade")
	icon = 'icons/antagonists/heretic/items/weapons.dmi'
	icon_state = "eldritch_blade"
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	item_icons = list(
		SLOT_ID_LEFT_HAND = 'icons/antagonists/heretic/on_mob/left_hand_64.dmi',
		SLOT_ID_RIGHT_HAND = 'icons/antagonists/heretic/on_mob/right_hand_64.dmi'
	)

/obj/item/toy/heretic_blade/ash
	icon_state = "ash_blade"

/obj/item/toy/heretic_blade/rust
	icon_state = "rust_blade"

/obj/item/toy/heretic_blade/flesh
	icon_state = "flesh_blade"

/obj/item/toy/heretic_blade/void
	icon_state = "void_blade"

/**
 * wizard
 */
/datum/loadout_entry/seasonal/masquarade/wizard
	antag_name = "Wizard"
	abstract_type = /datum/loadout_entry/seasonal/masquarade/wizard

/**
 * ninja
 */
/datum/loadout_entry/seasonal/masquarade/ninja
	antag_name = "Ninja"
	abstract_type = /datum/loadout_entry/seasonal/masquarade/ninja

/*
/datum/loadout_entry/seasonal/masquarade/ninja/suit
	display_name = "Suit"
	path = /obj/item/clothing/suit/storage/hooded/fake_ninja

/obj/item/clothing/suit/storage/hooded/fake_ninja

/obj/item/clothing/head/hood/fake_ninja

/datum/loadout_entry/seasonal/masquarade/ninja/katana
	display_name = "Katana"
	path = /obj/item/toy/ninja_katana

/obj/item/toy/ninja_katana
*/

/**
 * Non-costume seasonally restricted items.
 */

/datum/loadout_entry/seasonal/masquarade/aesthetic
	antag_name = "Aesthetic"
	abstract_type = /datum/loadout_entry/seasonal/masquarade/aesthetic

/datum/loadout_entry/seasonal/masquarade/aesthetic/invisible_satchel
	display_name = "Invisible Satchel"
	path = /obj/item/storage/backpack/satchel/invisible

/**
 * Belly dancer costume
 */
/datum/loadout_entry/seasonal/masquarade/dancer
	antag_name = "Belly Dancer"
	description = "The outfit of a belly dancer"
	abstract_type = /datum/loadout_entry/seasonal/masquarade/dancer

/datum/loadout_entry/seasonal/masquarade/dancer/scarf
	display_name = "Headscarf"
	path = /obj/item/clothing/head/donator/dancer
	slot = SLOT_ID_HEAD

/datum/loadout_entry/seasonal/masquarade/dancer/veil
	display_name = "Veil"
	path = /obj/item/clothing/mask/donator/dancer
	slot = SLOT_ID_MASK

/datum/loadout_entry/seasonal/masquarade/dancer/gloves
	display_name = "Sleeves"
	path = /obj/item/clothing/gloves/donator/dancer
	slot = SLOT_ID_GLOVES
/datum/loadout_entry/seasonal/masquarade/dancer/costume
	display_name = "Costume"
	path = /obj/item/clothing/under/donator/dancer
	slot = SLOT_ID_UNIFORM

/datum/loadout_entry/seasonal/masquarade/dancer/wraps
	display_name = "Footwraps"
	path = /obj/item/clothing/shoes/donator/dancer
	slot = SLOT_ID_SHOES

#undef STD_DEF
