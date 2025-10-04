/obj/item/destTagger
	name = "destination tagger"
	desc = "Used to set the destination of properly wrapped packages."
	icon = 'icons/obj/device.dmi'
	icon_state = "dest_tagger"
	var/currTag = 0

	w_class = WEIGHT_CLASS_SMALL
	item_state = "electronic"
	slot_flags = SLOT_BELT

/obj/item/destTagger/ui_state()
	return GLOB.inventory_state

/obj/item/destTagger/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "DestinationTagger", name)
		ui.open()

/obj/item/destTagger/ui_data(mob/user, datum/tgui/ui)
	var/list/data = ..()

	data["currTag"] = currTag
	data["taggerLocs"] = GLOB.tagger_locations

	return data

/obj/item/destTagger/attack_self(mob/user, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	ui_interact(user)

/obj/item/destTagger/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state, datum/event_args/actor/actor)
	if(..())
		return TRUE
	add_fingerprint(usr)
	switch(action)
		if("set_tag")
			var/new_tag = params["tag"]
			if(!(new_tag in GLOB.tagger_locations))
				return FALSE
			currTag = new_tag
			. = TRUE
