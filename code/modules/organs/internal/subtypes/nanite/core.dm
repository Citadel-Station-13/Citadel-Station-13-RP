/obj/item/organ/internal/mmi_holder/posibrain/nano
	name = "protean posibrain"
	desc = "A more advanced version of the standard posibrain, typically found in protean bodies."
	icon = 'icons/mob/clothing/species/protean/protean.dmi'
	icon_state = "posi"
	parent_organ = BP_TORSO

	brain_type = /obj/item/mmi/digital/posibrain/nano

/obj/item/organ/internal/mmi_holder/posibrain/nano/robotize()
	. = ..()
	icon_state = "posi1"

/obj/item/organ/internal/mmi_holder/posibrain/nano/mechassist()
	. = ..()
	icon_state = "posi1"


/obj/item/organ/internal/mmi_holder/posibrain/nano/update_from_mmi()
	. = ..()
	icon = initial(icon)
	icon_state = "posi1"
	stored_mmi.icon_state = "posi1"

	stored_mmi.brainmob.languages = owner.languages
