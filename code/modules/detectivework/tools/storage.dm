/obj/item/storage/box/swabs
	name = "box of swab kits"
	desc = "Sterilized equipment within. Do not contaminate."
	icon = 'icons/obj/forensics.dmi'
	icon_state = "dnakit"
	insertion_whitelist = list(/obj/item/forensics/swab)
	max_items = 14
	starts_with = list(
		/obj/item/forensics/swab = 14,
	)

/obj/item/storage/box/evidence
	name = "evidence bag box"
	desc = "A box claiming to contain evidence bags."
	max_items = 7
	insertion_whitelist = list(/obj/item/evidencebag)
	starts_with = list(
		/obj/item/evidencebag = 7,
	)

/obj/item/storage/box/fingerprints
	name = "box of fingerprint cards"
	desc = "Sterilized equipment within. Do not contaminate."
	icon = 'icons/obj/forensics.dmi'
	icon_state = "dnakit"
	insertion_whitelist = list(/obj/item/sample/print)
	max_items = 14
	starts_with = list(
		/obj/item/sample/print = 14,
	)
