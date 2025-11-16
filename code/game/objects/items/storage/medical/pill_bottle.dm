/obj/item/storage/pill_bottle
	name = "pill bottle"
	desc = "It's an airtight container for storing medication."
	icon_state = "pill_canister"
	icon = 'icons/obj/medical/chemical.dmi'
	drop_sound = 'sound/items/drop/pillbottle.ogg'
	pickup_sound = 'sound/items/pickup/pillbottle.ogg'
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "contsolid", SLOT_ID_LEFT_HAND = "contsolid")
	w_class = WEIGHT_CLASS_SMALL
	insertion_whitelist = list(/obj/item/reagent_containers/pill,/obj/item/dice,/obj/item/paper)
	allow_quick_empty = TRUE
	allow_mass_gather = TRUE
	sfx_insert = null
	sfx_remove = null
	sfx_open = null
	max_combined_volume = WEIGHT_VOLUME_TINY * 14
	max_single_weight_class = WEIGHT_CLASS_TINY
	materials_base = list(MAT_PLASTIC = 80)
	item_flags = ITEM_CAREFUL_BLUDGEON | ITEM_ENCUMBERS_WHILE_HELD | ITEM_EASY_LATHE_DECONSTRUCT
	suit_storage_class = SUIT_STORAGE_CLASS_SOFTWEAR

	var/label_text = ""
	var/labeled = 0
	var/base_name = " "
	var/base_desc = " "
	var/base_icon = "pill_canister"
	var/bottle_color = "orange"

/obj/item/storage/pill_bottle/Initialize(mapload)
	. = ..()
	base_name = name
	base_desc = desc
	update_icon()

/obj/item/storage/pill_bottle/using_item_on(obj/item/using, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	var/obj/item/W = using
	// TODO: generalize pens. or flashlights. one of the fucking two c'mon. probably flashlight on pen as it's simpler.
	if(istype(W, /obj/item/pen) || istype(W, /obj/item/flashlight/pen))
		var/mob/user = clickchain.initiator
		var/tmp_label = sanitizeSafe(input(user, "Enter a label for [name]", "Label", label_text), MAX_NAME_LEN)
		if(length(tmp_label) > 50)
			to_chat(user, "<span class='notice'>The label can be at most 50 characters long.</span>")
		else if(length(tmp_label) > 10)
			to_chat(user, "<span class='notice'>You set the label.</span>")
			label_text = tmp_label
			update_name_label()
		else
			to_chat(user, "<span class='notice'>You set the label to \"[tmp_label]\".</span>")
			label_text = tmp_label
			update_name_label()
			labeled = 1
			update_icon()
		return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING
	return ..()

/obj/item/storage/pill_bottle/proc/update_name_label()
	if(!label_text)
		name = base_name
		desc = base_desc
		return
	else if(length(label_text) > 10)
		var/short_label_text = copytext(label_text, 1, 11)
		name = "[base_name] ([short_label_text]...)"
	else
		name = "[base_name] ([label_text])"
	desc = "[base_desc] It is labeled \"[label_text]\"."

/obj/item/storage/pill_bottle/proc/choose_color()
	set name = "Recolor bottle"
	set category = VERB_CATEGORY_OBJECT
	set desc = "Click to choose a color for the pill bottle."

	var/mob/M = usr
	var/list/options = list()
	options["red"] = "red"
	options["orange"] = "orange"
	options["yellow"] = "yellow"
	options["green"] = "green"
	options["blue"] = "blue"
	options["purple"] = "purple"
	options["pink"] = "pink"
	options["black"] = "black"
	options["white"] = "white"
	var/choice = input(M,"Choose a color!","Recolor Bottle") in options
	if(src && choice && !M.stat && in_range(M,src))
		bottle_color = "[choice]"
		to_chat(usr,"<span class='notice'>The bottle is now [choice]. How [pick("pretty","professional","informative","creative","appropriate","bold")]!</span>")
		update_icon()
		return 1

/obj/item/storage/pill_bottle/update_icon()
	..()
	if(labeled == 1)
		add_overlay("pill_canister_label")
	if(base_icon == "pill_canister")
		if(bottle_color == "orange")
			icon_state = "[base_icon]"
		else
			icon_state = "[base_icon]_[bottle_color]"

/obj/item/storage/pill_bottle/Initialize(mapload)
	. = ..()
	if(base_icon == "pill_canister")
		add_obj_verb(src, /obj/item/storage/pill_bottle/proc/choose_color)
	update_icon()

/obj/item/storage/pill_bottle/antitox
	name = "bottle of Dylovene pills"
	desc = "Contains pills used to counter toxins."
	labeled = 1
	bottle_color = "green"
	starts_with = list(/obj/item/reagent_containers/pill/antitox = 7)

/obj/item/storage/pill_bottle/bicaridine
	name = "bottle of Bicaridine pills"
	desc = "Contains pills used to stabilize the severely injured."
	labeled = 1
	bottle_color = "red"
	starts_with = list(/obj/item/reagent_containers/pill/bicaridine = 7)

/obj/item/storage/pill_bottle/dexalin_plus
	name = "bottle of Dexalin Plus pills"
	desc = "Contains pills used to treat extreme cases of oxygen deprivation."
	labeled = 1
	bottle_color = "blue"
	starts_with = list(/obj/item/reagent_containers/pill/dexalin_plus = 7)

/obj/item/storage/pill_bottle/dermaline
	name = "bottle of Dermaline pills"
	desc = "Contains pills used to treat burn wounds."
	labeled = 1
	starts_with = list(/obj/item/reagent_containers/pill/dermaline = 7)

/obj/item/storage/pill_bottle/dylovene
	name = "bottle of Dylovene pills"
	desc = "Contains pills used to treat toxic substances in the blood."
	labeled = 1
	bottle_color = "green"
	starts_with = list(/obj/item/reagent_containers/pill/dylovene = 7)

/obj/item/storage/pill_bottle/inaprovaline
	name = "bottle of Inaprovaline pills"
	desc = "Contains pills used to stabilize patients."
	labeled = 1
	bottle_color = "blue"
	starts_with = list(/obj/item/reagent_containers/pill/inaprovaline = 7)

/obj/item/storage/pill_bottle/kelotane
	name = "bottle of kelotane pills"
	desc = "Contains pills used to treat burns."
	labeled = 1
	starts_with = list(/obj/item/reagent_containers/pill/kelotane = 7)

/obj/item/storage/pill_bottle/spaceacillin
	name = "bottle of Spaceacillin pills"
	desc = "A theta-lactam antibiotic. Effective against many diseases likely to be encountered in space."
	labeled = 1
	bottle_color = "white"
	starts_with = list(/obj/item/reagent_containers/pill/spaceacillin = 7)

/obj/item/storage/pill_bottle/tramadol
	name = "bottle of Tramadol pills"
	desc = "Contains pills used to relieve pain."
	labeled = 1
	bottle_color = "purple"
	starts_with = list(/obj/item/reagent_containers/pill/tramadol = 7)

/obj/item/storage/pill_bottle/citalopram
	name = "bottle of Citalopram pills"
	desc = "Contains pills used to stabilize a patient's mood."
	labeled = 1
	starts_with = list(/obj/item/reagent_containers/pill/citalopram = 7)

/obj/item/storage/pill_bottle/carbon
	name = "bottle of Carbon pills"
	desc = "Contains pills used to neutralise chemicals in the stomach."
	labeled = 1
	bottle_color = "black"
	starts_with = list(/obj/item/reagent_containers/pill/carbon = 7)

/obj/item/storage/pill_bottle/iron
	name = "bottle of Iron pills"
	desc = "Contains pills used to aid in blood regeneration."
	labeled = 1
	bottle_color = "black"
	starts_with = list(/obj/item/reagent_containers/pill/iron = 7)

/obj/item/storage/pill_bottle/adminordrazine
	name = "pill bottle (Adminordrazine)"
	desc = "It's magic. We don't have to explain it."
	starts_with = list(/obj/item/reagent_containers/pill/adminordrazine = 21)

/obj/item/storage/pill_bottle/nutriment
	name = "pill bottle (Food)"
	desc = "Contains pills used to feed people."
	starts_with = list(/obj/item/reagent_containers/pill/nutriment = 7, /obj/item/reagent_containers/pill/protein = 7)

/obj/item/storage/pill_bottle/rezadone
	name = "pill bottle (Rezadone)"
	desc = "A powder with almost magical properties, this substance can effectively treat genetic damage in humanoids, though excessive consumption has side effects."
	starts_with = list(/obj/item/reagent_containers/pill/rezadone = 7)
	//wrapper_color = COLOR_GREEN_GRAY

/obj/item/storage/pill_bottle/peridaxon
	name = "pill bottle (Peridaxon)"
	desc = "Used to encourage recovery of internal organs and nervous systems. Medicate cautiously."
	starts_with = list(/obj/item/reagent_containers/pill/peridaxon = 7)
	//wrapper_color = COLOR_PURPLE

/obj/item/storage/pill_bottle/carthatoline
	name = "pill bottle (Carthatoline)"
	desc = "Carthatoline is strong evacuant used to treat severe poisoning."
	starts_with = list(/obj/item/reagent_containers/pill/carthatoline = 7)
	//wrapper_color = COLOR_GREEN_GRAY

/obj/item/storage/pill_bottle/alkysine
	name = "pill bottle (Alkysine)"
	desc = "Alkysine is a drug used to lessen the damage to neurological tissue after a catastrophic injury. Can heal brain tissue."
	starts_with = list(/obj/item/reagent_containers/pill/alkysine = 7)
	//wrapper_color = COLOR_YELLOW

/obj/item/storage/pill_bottle/imidazoline
	name = "pill bottle (Imidazoline)"
	desc = "Heals eye damage."
	starts_with = list(/obj/item/reagent_containers/pill/imidazoline = 7)
	//wrapper_color = COLOR_PURPLE_GRAY

/obj/item/storage/pill_bottle/osteodaxon
	name = "pill bottle (Osteodaxon)"
	desc = "An experimental drug used to heal bone fractures."
	starts_with = list(/obj/item/reagent_containers/pill/osteodaxon = 7)
	//wrapper_color = COLOR_WHITE

/obj/item/storage/pill_bottle/myelamine
	name = "pill bottle (Myelamine)"
	desc = "Used to rapidly clot internal hemorrhages by increasing the effectiveness of platelets."
	starts_with = list(/obj/item/reagent_containers/pill/myelamine = 7)
	//wrapper_color = COLOR_PALE_PURPLE_GRAY

/obj/item/storage/pill_bottle/hyronalin
	name = "pill bottle (Hyronalin)"
	desc = "Hyronalin is a medicinal drug used to counter the effect of radiation poisoning."
	starts_with = list(/obj/item/reagent_containers/pill/hyronalin = 7)
	//wrapper_color = COLOR_TEAL

/obj/item/storage/pill_bottle/arithrazine
	name = "pill bottle (Arithrazine)"
	desc = "Arithrazine is an unstable medication used for the most extreme cases of radiation poisoning."
	starts_with = list(/obj/item/reagent_containers/pill/arithrazine = 7)
	//wrapper_color = COLOR_TEAL

/obj/item/storage/pill_bottle/corophizine
	name = "pill bottle (Corophizine)"
	desc = "A wide-spectrum antibiotic drug. Powerful and uncomfortable in equal doses."
	starts_with = list(/obj/item/reagent_containers/pill/corophizine = 7)
	//wrapper_color = COLOR_PALE_GREEN_GRAY

/obj/item/storage/pill_bottle/healing_nanites
	name = "pill bottle (Healing nanites)"
	desc = "Miniature medical robots that swiftly restore bodily damage."
	starts_with = list(/obj/item/reagent_containers/pill/healing_nanites = 7)
