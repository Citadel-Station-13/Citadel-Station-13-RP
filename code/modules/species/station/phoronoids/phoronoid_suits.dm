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

	//Set of modules
	var/list/obj/item/omnicasket_module/installed
	var/obj/item/omnicasket_kit/job_kit
	var/utility_slots = 1 //Additional can be provided by job kit.
	var/combat_slots = 0 //Provided by job kit, if at all, maybe the lore goes more towards firefall and there is a lot of hostile creatures on the homeplanet, so it comes with a minor combat kit anyway?
	var/armor_slots = 0//Should not exceed 1 (maybe armor modules just replace each other, tbd)

/obj/item/omnicasket_controller/set_armor(what)
	. = ..()
	torso.set_armor(what)
	helmet.set_armor(what)
	boots.set_armor(what)
	gauntlets.set_armor(what)

/obj/item/omnicasket_module
	name = "blank OmniCasket Module"
	desc =  "A blank OmniCasket Module, this one isnt even configured to fit any slots."
	// How to define the changes done to the suit...
	// 1. foreach(module in installed) module.change_breathing()
	// 2. each module could contain a list of datums that are refered to by the relevant functions
	// 3. a variable with bitflags, MODULE_GAS_FILTER (24 bitflags might not be enough)
	// example: /datum/changes_breathing -> when the suit is using a mask it the filter_gas proc of the mask calls the changes_breathing.behaviour_changed() proc

/obj/item/omnicasket_module/utility
	name = "blank OmniCasket Utility Module"
	desc =  "A blank OmniCasket Module, this one is configured to fit into utility slots."


/obj/item/omnicasket_kit
	name = "blank OmniCasket Kit"
	desc = "A blank Kit of OmniCasket Modules, neatly arranged in a single casing. This one seems to be emtpy..."
	var/list/obj/item/omnicasket_module/part_of_this = list()





