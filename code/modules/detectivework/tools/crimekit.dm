//crime scene kit
/obj/item/storage/briefcase/crimekit
	name = "crime scene kit"
	desc = "A stainless steel-plated carrycase for all your forensic needs. Feels heavy."
	icon = 'icons/obj/forensics.dmi'
	icon_state = "det-case"
	storage_slots = 14
	drop_sound = 'sound/items/drop/toolbox.ogg'
	pickup_sound = 'sound/items/pickup/toolbox.ogg'
	item_icons = list(
		SLOT_ID_LEFT_HAND = 'icons/mob/items/lefthand_storage.dmi',
		SLOT_ID_RIGHT_HAND = 'icons/mob/items/righthand_storage.dmi',
		)

/obj/item/storage/briefcase/crimekit/PopulateContents()
	new /obj/item/storage/box/swabs(src)
	new /obj/item/storage/box/fingerprints(src)
	new /obj/item/reagent_containers/spray/luminol(src)
	new /obj/item/uv_light(src)
	new /obj/item/forensics/sample_kit(src)
	new /obj/item/forensics/sample_kit/powder(src)
