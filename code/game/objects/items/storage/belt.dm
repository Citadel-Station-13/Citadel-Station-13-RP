/obj/item/storage/belt
	name = "belt"
	desc = "Can hold various things."
	icon = 'icons/obj/clothing/belts.dmi'
	icon_state = "utility"
	slot_flags = SLOT_BELT
	attack_verb = list("whipped", "lashed", "disciplined")
	equip_sound = 'sound/items/toolbelt_equip.ogg'
	drop_sound = 'sound/items/drop/toolbelt.ogg'
	pickup_sound = 'sound/items/pickup/toolbelt.ogg'
	worth_intrinsic = 50

	storage_datum_path = /datum/object_system/storage/belt
	max_single_weight_class = WEIGHT_CLASS_NORMAL

	var/set_max_combined_belt_small
	var/set_max_combined_belt_medium
	var/set_max_combined_belt_large

	var/show_above_suit = 0

/obj/item/storage/belt/Initialize(mapload, empty)
	. = ..()
	if(istype(obj_storage, /datum/object_system/storage/belt))
		var/datum/object_system/storage/belt/casted_obj_storage = obj_storage
		if(set_max_combined_belt_large != null)
			casted_obj_storage.max_combined_belt_large = set_max_combined_belt_large
		if(set_max_combined_belt_medium != null)
			casted_obj_storage.max_combined_belt_medium = set_max_combined_belt_medium
		if(set_max_combined_belt_small != null)
			casted_obj_storage.max_combined_belt_small = set_max_combined_belt_small

/obj/item/storage/belt/verb/toggle_layer()
	set name = "Switch Belt Layer"
	set category = VERB_CATEGORY_OBJECT

	if(show_above_suit == -1)
		to_chat(usr, SPAN_NOTICE("\The [src] cannot be worn above your suit!"))
		return
	show_above_suit = !show_above_suit
	update_icon()

// todo: this bad lol
/obj/item/storage/belt/render_apply_overlays(mutable_appearance/MA, bodytype, inhands, datum/inventory_slot/slot_meta, icon_used)
	. = ..()
	var/static/icon/funny_belt_icon = 'icons/mob/clothing/belt.dmi'
	for(var/obj/item/I in contents)
		var/state = resolve_belt_state(I, funny_belt_icon)
		if(!state)
			continue
		MA.add_overlay(image(icon = funny_belt_icon, icon_state = state))

// todo: this bad lol x2
/obj/item/storage/belt/proc/resolve_belt_state(obj/item/I, icon/ifile)
	return I.belt_state || I.item_state || I.icon_state

/obj/item/storage/update_icon()
	. = ..()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_belt()

/obj/item/storage/belt/medical
	name = "medical belt"
	desc = "Can hold various medical equipment."
	icon_state = "medical"

/obj/item/storage/belt/medical/emt
	name = "EMT utility belt"
	desc = "A sturdy black webbing belt with attached pouches."
	icon_state = "ems"

/obj/item/storage/belt/detective
	name = "forensic utility belt"
	desc = "A belt for holding forensics equipment."
	icon_state = "security"
	max_items = 7
	max_single_weight_class = WEIGHT_CLASS_NORMAL

/obj/item/storage/belt/explorer
	name = "pathfinder's bandolier"
	desc = "A versatile bandolier fitted with eight pouches that can hold a wide variety of items such as tools, small melee weapons, batteries, ammunition, and more; ideal for any pathfinder who has too much stuff and not enough pockets."
	icon_state = "bandolier"
	max_items = 7
	max_combined_volume = WEIGHT_VOLUME_NORMAL * 7
	show_above_suit = 1

/obj/item/storage/belt/soulstone
	name = "soul stone belt"
	desc = "Designed for ease of access to the shards during a fight, as to not let a single enemy spirit slip away"
	icon_state = "soulstone"
	max_items = 6

/obj/item/storage/belt/soulstone/full
	starts_with = list(/obj/item/soulstone = 6)

/obj/item/storage/belt/medical/alien
	name = "alien belt"
	desc = "A belt(?) that can hold things."
	icon = 'icons/obj/abductor.dmi'
	icon_state = "belt"
	item_state = "security"
	max_items = 8

/obj/item/storage/belt/medical/alien
	starts_with = list(
		/obj/item/surgical/scalpel/alien,
		/obj/item/surgical/hemostat/alien,
		/obj/item/surgical/retractor/alien,
		/obj/item/surgical/circular_saw/alien,
		/obj/item/surgical/FixOVein/alien,
		/obj/item/surgical/bone_clamp/alien,
		/obj/item/surgical/cautery/alien,
		/obj/item/surgical/surgicaldrill/alien
	)

/obj/item/storage/belt/champion
	name = "championship belt"
	desc = "Proves to the world that you are the strongest!"
	icon_state = "champion"
	max_items = 1

/obj/item/storage/belt/spike_bandolier
	name = "spike bandolier"
	desc = "A bandolier used to hold spikes, and only spikes."
	icon_state = "bandolier"
	max_items = 14
	max_single_weight_class = WEIGHT_CLASS_SMALL
	max_combined_volume = WEIGHT_VOLUME_SMALL * 14
	insertion_whitelist = list(/obj/item/melee/spike)
	starts_with = list(/obj/item/melee/spike = 14)

/obj/item/storage/belt/janitor
	name = "janitorial belt"
	desc = "A belt used to hold most janitorial supplies."
	icon_state = "janitor"
	max_items = 7
	max_single_weight_class = WEIGHT_CLASS_NORMAL
	worth_intrinsic = 35

/obj/item/storage/belt/archaeology
	name = "excavation gear-belt"
	desc = "Can hold various excavation gear."
	icon_state = "gear"
	worth_intrinsic = 65

/obj/item/storage/belt/fannypack
	name = "leather fannypack"
	desc = "A dorky fannypack for keeping small items in."
	icon_state = "fannypack_leather"
	item_state = "fannypack_leather"
	max_single_weight_class = WEIGHT_CLASS_SMALL
	max_items = null
	max_combined_volume = WEIGHT_VOLUME_NORMAL * 2

/obj/item/storage/belt/fannypack/black
 	name = "black fannypack"
 	icon_state = "fannypack_black"
 	item_state = "fannypack_black"

/obj/item/storage/belt/fannypack/blue
 	name = "blue fannypack"
 	icon_state = "fannypack_blue"
 	item_state = "fannypack_blue"

/obj/item/storage/belt/fannypack/cyan
 	name = "cyan fannypack"
 	icon_state = "fannypack_cyan"
 	item_state = "fannypack_cyan"

/obj/item/storage/belt/fannypack/green
 	name = "green fannypack"
 	icon_state = "fannypack_green"
 	item_state = "fannypack_green"

/obj/item/storage/belt/fannypack/orange
 	name = "orange fannypack"
 	icon_state = "fannypack_orange"
 	item_state = "fannypack_orange"

/obj/item/storage/belt/fannypack/purple
 	name = "purple fannypack"
 	icon_state = "fannypack_purple"
 	item_state = "fannypack_purple"

/obj/item/storage/belt/fannypack/red
 	name = "red fannypack"
 	icon_state = "fannypack_red"
 	item_state = "fannypack_red"

/obj/item/storage/belt/fannypack/white
 	name = "white fannypack"
 	icon_state = "fannypack_white"
 	item_state = "fannypack_white"

/obj/item/storage/belt/fannypack/yellow
 	name = "yellow fannypack"
 	icon_state = "fannypack_yellow"
 	item_state = "fannypack_yellow"

/obj/item/storage/belt/sheath
	name = "sabre sheath"
	desc = "An ornate sheath designed to hold an officer's blade."
	icon_state = "sheath-sabre"
	max_items = 1
	insertion_whitelist = list(
		/obj/item/material/sword/sabre,
		/obj/item/melee/baton/stunsword,
	)
	starts_with = list(
		/obj/item/material/sword/sabre,
	)

/obj/item/storage/belt/sheath/initialize_storage()
	. = ..()
	obj_storage.update_icon_on_item_change = TRUE

/obj/item/storage/belt/sheath/update_icon()
	icon_state = "sheath"
	item_state = "sheath"
	if(contents.len)
		icon_state += "-sabre"
		item_state += "-sabre"
	if(loc && isliving(loc))
		var/mob/living/L = loc
		L.regenerate_icons()
	..()

/obj/item/storage/belt/ranger
	name = "ranger belt"
	desc = "The fancy utility-belt holding the tools, cuffs and gadgets of the Go Go ERT-Rangers. The belt buckle is not real phoron, but it is still surprisingly comfortable to wear."
	icon = 'icons/obj/clothing/ranger.dmi'
	icon_state = "ranger_belt"

/obj/item/storage/belt/dualholster
	name = "dual holster gunbelt"
	desc = "Belts like these were popular on old Earth, but were largely supplanted by modular holsters. This gunbelt is too bulky to be comfortably anchored to clothes without support."
	icon_state = "dual_holster"
	set_max_combined_belt_large = 2

/obj/item/storage/belt/quiver
	name = "leather quiver"
	desc = "A quiver made from the hide of some animal. Used to hold arrows."
	icon_state = "quiver"
	max_single_weight_class = WEIGHT_CLASS_NORMAL
	set_max_combined_belt_small = 30
	insertion_whitelist = list(
		/obj/item/ammo_casing/arrow,
	)

/obj/item/storage/belt/quiver/full
	name = "leather quiver"
	desc = "A quiver made from the hide of some animal. Used to hold arrows."
	icon_state = "quiver"
	starts_with = list(
		/obj/item/ammo_casing/arrow = /obj/item/storage/belt/quiver::set_max_combined_belt_small,
	)

/obj/item/storage/belt/quiver/full/ash
	name = "leather quiver"
	desc = "A quiver made from the hide of some animal. Used to hold arrows."
	icon_state = "quiver"
	starts_with = list(
		/obj/item/ammo_casing/arrow/bone = /obj/item/storage/belt/quiver::set_max_combined_belt_small,
	)
