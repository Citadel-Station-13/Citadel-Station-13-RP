///Stasis fish case container for moving fish between aquariums safely.
/obj/item/storage/fish_case
	name = "stasis fish case"
	desc = "A small case keeping the fish inside in stasis."
	icon = 'icons/obj/storage/case.dmi'
	icon_state = "fishbox"

	inhand_icon_state = "syringe_kit"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'

/obj/item/storage/fish_case/Initialize(mapload)
	ADD_TRAIT(src, TRAIT_FISH_SAFE_STORAGE, TRAIT_GENERIC) // Before populate so fish instatiates in ready container already
	. = ..()

	create_storage(max_slots = 1)
	atom_storage.can_hold_trait = TRAIT_FISH_CASE_COMPATIBILE
	atom_storage.can_hold_description = "fish and aquarium equipment"

///Fish case with single random fish inside.
/obj/item/storage/fish_case/random/PopulateContents()
	. = ..()
	var/fish_type = select_fish_type()
	new fish_type(src)

/obj/item/storage/fish_case/random/proc/select_fish_type()
	return random_fish_type()

/obj/item/storage/fish_case/random/freshwater/select_fish_type()
	return random_fish_type(required_fluid=AQUARIUM_FLUID_FRESHWATER)

/obj/item/storage/fish_case/random/saltwater/select_fish_type()
	return random_fish_type(required_fluid=AQUARIUM_FLUID_SALTWATER)

/obj/item/storage/fish_case/syndicate
	name = "ominous fish case"

/obj/item/storage/fish_case/syndicate/PopulateContents()
	. = ..()
	var/fish_type = pick(/obj/item/fish/donkfish, /obj/item/fish/emulsijack)
	new fish_type(src)

/obj/item/storage/fish_case/tiziran
	name = "imported fish case"

/obj/item/storage/fish_case/tiziran/PopulateContents()
	. = ..()
	var/fish_type = pick(/obj/item/fish/dwarf_moonfish, /obj/item/fish/gunner_jellyfish, /obj/item/fish/needlefish, /obj/item/fish/armorfish)
	new fish_type(src)
