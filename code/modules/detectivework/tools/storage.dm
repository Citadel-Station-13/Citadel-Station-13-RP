/obj/item/storage/box/swabs
	name = "box of swab kits"
	desc = "Sterilized equipment within. Do not contaminate."
	icon = 'icons/obj/forensics.dmi'
	icon_state = "dnakit"
	insertion_whitelist = list(/obj/item/forensics/swab)
	storage_slots = 14

/obj/item/storage/box/swabs/legacy_spawn_contents()
	for(var/i = 1 to storage_slots) // Fill 'er up.
		new /obj/item/forensics/swab(src)

/obj/item/storage/box/evidence
	name = "evidence bag box"
	desc = "A box claiming to contain evidence bags."
	storage_slots = 7
	insertion_whitelist = list(/obj/item/evidencebag)

/obj/item/storage/box/evidence/legacy_spawn_contents()
	for(var/i = 1 to storage_slots)
		new /obj/item/evidencebag(src)

/obj/item/storage/box/fingerprints
	name = "box of fingerprint cards"
	desc = "Sterilized equipment within. Do not contaminate."
	icon = 'icons/obj/forensics.dmi'
	icon_state = "dnakit"
	insertion_whitelist = list(/obj/item/sample/print)
	storage_slots = 14

/obj/item/storage/box/fingerprints/legacy_spawn_contents()
	for(var/i = 1 to storage_slots)
		new /obj/item/sample/print(src)
