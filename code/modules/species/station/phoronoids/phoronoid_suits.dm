/// OmniCaskets
/// yes, its inspired by warcaskets, and the fact the user cant really leave the casket without medical assistance.
///
/// TODOs:
/// Armor forge, the place you install and uninstall the majority of the armor, and maybe even the job modules
/// Job modules
/// Utility modules
/// combat modules
/// Armor modules
/// the actual suit parts
/// a system that prevents you from taking the suit off
///	a system that handles settings, like vacuum seals
///

/datum/armor/omnicasket
	melee = 0.4
	bullet = 0.05
	laser = 0.2
	energy = 0.05
	bomb = 0.35
	bio = 1.0
	rad = 0.2

/obj/item/omnicasket_controller
	name = "OmniCasket Main Controller"
	desc = "The central piece of an OmniCasket, an highly advanced suit designed to keep the wearers Gentic material from falling apart,\
			while also offering a modular platform to assist in all sorts of tasks. So far only Phoronoids have been adapted for the biointerface."
	icon = 'icons/mob/species/phoronoid/omnicasket/bulky.dmi'
	icon_state = "item_backpack"
	slot_flags = SLOT_BACK
	w_class = ITEM_SIZE_GARGANTUAN
	armor_type = /datum/armor/omnicasket
	clothing_flags = PHORONGUARD

	//No type vars like a rig, since these are added, not created by the suit.
	var/obj/item/clothing/suit/omnicasket/torso
	var/obj/item/clothing/head/omnicasket/helmet
	var/obj/item/clothing/glasses/omnicasket/visor //might be stored in the helmet, will be linked to controller either way
	var/obj/item/clothing/shoes/omnicasket/boots //covers feet and legs
	var/obj/item/clothing/gloves/omnicasket/gauntlets //Covers hands and arms

/obj/item/omnicasket_controller/set_armor(what)
	. = ..()
	torso.set_armor(what)
	helmet.set_armor(what)
	boots.set_armor(what)
	gauntlets.set_armor(what)

