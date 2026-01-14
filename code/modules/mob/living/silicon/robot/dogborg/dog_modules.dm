/obj/item/shockpaddles/robot/hound
	name = "paws of life"
	icon = 'icons/mob/dogborg_vr.dmi'
	icon_state = "defibpaddles0"
	desc = "Zappy paws. For fixing cardiac arrest."
	combat = 1
	attack_verb = list("batted", "pawed", "bopped", "whapped")
	chargecost = 500

/obj/item/reagent_containers/borghypo/hound
	name = "MediHound hypospray"
	desc = "An advanced chemical synthesizer and injection system utilizing carrier's reserves, designed for heavy-duty medical equipment."
	charge_cost = 10
	reagent_ids = list("bicaridine", "kelotane", "alkysine", "imidazoline", "tricordrazine", "inaprovaline", "dexalin", "anti_toxin", "tramadol", "spaceacillin", "paracetamol")

/obj/item/reagent_containers/borghypo/hound/lost
	name = "Hound hypospray"
	desc = "An advanced chemical synthesizer and injection system utilizing carrier's reserves."
	reagent_ids = list("bicaridine", "kelotane", "alkysine", "imidazoline", "tricordrazine", "inaprovaline", "dexalin", "anti_toxin", "tramadol", "spaceacillin", "paracetamol")

/obj/item/pupscrubber
	name = "floor scrubber"
	desc = "Toggles floor scrubbing."
	icon = 'icons/mob/dogborg_vr.dmi'
	icon_state = "scrub0"
	item_flags = ITEM_NO_BLUDGEON | ITEM_ENCUMBERS_WHILE_HELD
	var/enabled = FALSE

/obj/item/pupscrubber/attack_self(mob/user, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	var/mob/living/silicon/robot/R = user
	if(!enabled)
		R.scrubbing = TRUE
		enabled = TRUE
		icon_state = "scrub1"
	else
		R.scrubbing = FALSE
		enabled = FALSE
		icon_state = "scrub0"
