/obj/item/clothing/accessory/storage
	name = "load bearing equipment"
	desc = "Used to hold things when you don't have enough hands."
	icon_state = "webbing"
	slot = ACCESSORY_SLOT_UTILITY
	show_messages = 1

	w_class = WEIGHT_CLASS_NORMAL
	on_rolled = list("down" = "none")
	var/hide_on_roll = FALSE

	//* Directly passed to storage system. *//

	var/list/insertion_whitelist
	var/list/insertion_blacklist
	var/list/insertion_allow

	var/max_single_weight_class = WEIGHT_CLASS_SMALL
	var/max_combined_weight_class
	var/max_combined_volume = WEIGHT_VOLUME_SMALL * 4
	var/max_items

	var/weight_subtract = 0
	var/weight_multiply = 1

	var/allow_mass_gather = FALSE
	var/allow_mass_gather_mode_switch = TRUE
	var/mass_gather_mode = STORAGE_QUICK_GATHER_COLLECT_ALL

	var/allow_quick_empty = FALSE
	var/allow_quick_empty_via_clickdrag = TRUE
	var/allow_quick_empty_via_attack_self = TRUE

	var/sfx_open = "rustle"
	var/sfx_insert = "rustle"
	var/sfx_remove = "rustle"

	var/ui_numerical_mode = FALSE

	//* Initialization *//

	/// storage datum path
	var/storage_datum_path = /datum/object_system/storage
	/// Cleared after Initialize().
	/// List of types associated to amounts.
	var/list/starts_with
	/// set to prevent us from spawning starts_with
	var/empty = FALSE

/obj/item/clothing/accessory/storage/Initialize(mapload)
	. = ..()
	initialize_storage()
	spawn_contents()

	if (!hide_on_roll)
		on_rolled["down"] = icon_state

/**
 * Make sure to set [worth_dynamic] to TRUE if this does more than spawning what's in starts_with.
 */
/obj/item/clothing/accessory/storage/proc/spawn_contents()
	if(length(starts_with) && !empty)
		// this is way too permissive already
		var/safety = 256
		var/atom/where_real_contents = obj_storage.real_contents_loc()
		for(var/path in starts_with)
			var/amount = starts_with[path] || 1
			for(var/i in 1 to amount)
				if(!--safety)
					CRASH("tried to spawn too many objects")
				new path(where_real_contents)
	starts_with = null

/obj/item/clothing/accessory/storage/proc/initialize_storage()
	ASSERT(isnull(obj_storage))
	init_storage(storage_datum_path, TRUE)
	obj_storage.set_insertion_allow(insertion_allow)
	obj_storage.set_insertion_whitelist(insertion_whitelist)
	obj_storage.set_insertion_blacklist(insertion_blacklist)

	obj_storage.max_single_weight_class = max_single_weight_class
	obj_storage.max_combined_weight_class = max_combined_weight_class
	obj_storage.max_combined_volume = max_combined_volume
	obj_storage.max_items = max_items

	obj_storage.weight_subtract = weight_subtract
	obj_storage.weight_multiply = weight_multiply

	obj_storage.allow_mass_gather = allow_mass_gather
	obj_storage.allow_mass_gather_mode_switch = allow_mass_gather_mode_switch
	obj_storage.mass_gather_mode = mass_gather_mode

	obj_storage.allow_quick_empty = allow_quick_empty
	obj_storage.allow_quick_empty_via_clickdrag = allow_quick_empty_via_clickdrag
	obj_storage.allow_quick_empty_via_attack_self = allow_quick_empty_via_attack_self

	obj_storage.sfx_open = sfx_open
	obj_storage.sfx_insert = sfx_insert
	obj_storage.sfx_remove = sfx_remove

	obj_storage.ui_numerical_mode = ui_numerical_mode

/obj/item/clothing/accessory/storage/webbing
	name = "webbing"
	desc = "Sturdy mess of synthcotton belts and buckles, ready to share your burden."
	icon_state = "webbing"
	// nah fuck off we don't like aesthetics making dumb storage powercreep different per type.
	max_combined_volume = WEIGHT_VOLUME_SMALL * 5

/obj/item/clothing/accessory/storage/black_vest
	name = "black webbing vest"
	desc = "Robust black synthcotton vest with lots of pockets to hold whatever you need, but cannot hold in hands."
	icon_state = "vest_black"
	max_combined_volume = WEIGHT_VOLUME_SMALL * 5

/obj/item/clothing/accessory/storage/brown_vest
	name = "brown webbing vest"
	desc = "Worn brownish synthcotton vest with lots of pockets to unload your hands."
	icon_state = "vest_brown"
	max_combined_volume = WEIGHT_VOLUME_SMALL * 5

/obj/item/clothing/accessory/storage/white_vest
	name = "white webbing vest"
	desc = "Durable white synthcotton vest with lots of pockets to carry essentials."
	icon_state = "vest_white"
	max_combined_volume = WEIGHT_VOLUME_SMALL * 5

/obj/item/clothing/accessory/storage/black_drop_pouches
	name = "black drop pouches"
	gender = PLURAL
	desc = "Robust black synthcotton bags to hold whatever you need, but cannot hold in hands."
	icon_state = "thigh_black"
	max_combined_volume = WEIGHT_VOLUME_SMALL * 5

/obj/item/clothing/accessory/storage/brown_drop_pouches
	name = "brown drop pouches"
	gender = PLURAL
	desc = "Worn brownish synthcotton bags to hold whatever you need, but cannot hold in hands."
	icon_state = "thigh_brown"
	max_combined_volume = WEIGHT_VOLUME_SMALL * 5

/obj/item/clothing/accessory/storage/white_drop_pouches
	name = "white drop pouches"
	gender = PLURAL
	desc = "Durable white synthcotton bags to hold whatever you need, but cannot hold in hands."
	icon_state = "thigh_white"
	max_combined_volume = WEIGHT_VOLUME_SMALL * 5

/obj/item/clothing/accessory/storage/knifeharness
	name = "decorated harness"
	desc = "A heavily decorated harness of sinew and leather with two knife-loops."
	icon_state = "unathiharness2"
	max_combined_volume = null
	max_single_weight_class = WEIGHT_CLASS_NORMAL
	max_items = 2
	max_combined_weight_class = null
	insertion_whitelist = list(
		/obj/item/material/knife,
	)
	starts_with = list(
		/obj/item/material/knife/machete/hatchet/unathiknife = 2,
	)

/obj/item/clothing/accessory/storage/voyager
	name = "voyager harness"
	desc = "A leather harness adorned with soft and hard-case pouches, designed for expeditions."
	icon_state = "explorer"

//Pilot
/obj/item/clothing/accessory/storage/webbing/pilot1
	name = "pilot harness"
	desc = "Sturdy mess of black synthcotton belts and buckles."
	icon_state = "pilot_webbing1"

/obj/item/clothing/accessory/storage/webbing/pilot2
	name = "pilot harness"
	desc = "Sturdy mess of black synthcotton belts and buckles."
	icon_state = "pilot_webbing2"
	sprite_sheets = list(
			BODYTYPE_STRING_TESHARI = 'icons/mob/clothing/species/teshari/ties.dmi'
			)

/obj/item/clothing/accessory/storage/laconic
	name = "laconic field pouch system"
	desc = "This lightweight webbing system supports a hardened leather case designed to sit comfortably on the wearer's hip."
	icon_state = "laconic"
	slot = ACCESSORY_SLOT_UTILITY
	max_combined_volume = WEIGHT_VOLUME_SMALL * 5

//Ashlander Potion Bandolier
/obj/item/clothing/accessory/storage/ashlander_alchemy
	name = "hide bandolier"
	desc = "A sturdy bandolier meant to keep the tools or products of alchemy held securely to the wearer's body."
	icon_state = "bandolier_ash"
	max_combined_volume = WEIGHT_VOLUME_SMALL * 5
	insertion_whitelist = list(
		/obj/item/reagent_containers/glass/stone,
		/obj/item/stack/medical/poultice_brute,
		/obj/item/stack/medical/poultice_burn,
		/obj/item/grenade/simple/explosive/ashlander,
		/obj/item/bitterash,
		/obj/item/flame/lighter,
	)
