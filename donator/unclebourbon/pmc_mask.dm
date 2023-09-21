/obj/item/clothing/mask/gas/clear/donator_pmc
	name = "\improper PMC gas mask"
	desc = "A rugged black gas mask with red lenses."
	icon = 'donator/unclebourbon/pmc_mask.dmi'
	icon_state = "pmc"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL | WORN_RENDER_INHAND_ALLOW_DEFAULT
	inhand_default_type = INHAND_DEFAULT_ICON_MASKS
	inhand_state = "swat"

/datum/loadout_entry/donator/unclebourbon_pmcmask
	name = "PMC Mask"
	slot = SLOT_ID_MASK
	path = /obj/item/clothing/mask/gas/clear/donator_pmc
	ckeywhitelist = list("unclebourbon")
