/* First aid storage
 * Contains:
 *		First Aid Kits
 * 		Pill Bottles
 */

/*
 * First Aid Kits
 */
/obj/item/storage/firstaid
	name = "first aid kit"
	desc = "It's an emergency medical kit for those serious boo-boos."
	icon = 'icons/obj/storage.dmi'
	icon_state = "firstaid"
	throw_speed = 2
	throw_range = 8
	max_storage_space = ITEMSIZE_COST_SMALL * 7 // 14
//	var/list/icon_variety

/obj/item/storage/firstaid/Initialize()
	. = ..()
//	if(icon_variety)
//		icon_state = pick(icon_variety)
//		icon_variety = null

/obj/item/storage/firstaid/fire
	name = "fire first aid kit"
	desc = "It's an emergency medical kit for when the toxins lab <i>spontaneously</i> burns down."
	icon_state = "ointment"
	item_state_slots = list(slot_r_hand_str = "firstaid-ointment", slot_l_hand_str = "firstaid-ointment")
//	icon_variety = list("ointment","firefirstaid")
	starts_with = list(
		/obj/item/healthanalyzer,
		/obj/item/reagent_containers/hypospray/autoinjector,
		/obj/item/stack/medical/ointment,
		/obj/item/stack/medical/ointment,
		/obj/item/reagent_containers/pill/kelotane,
		/obj/item/reagent_containers/pill/kelotane,
		/obj/item/reagent_containers/pill/kelotane
	)

/obj/item/storage/firstaid/regular
	icon_state = "firstaid"
	starts_with = list(
		/obj/item/stack/medical/bruise_pack,
		/obj/item/stack/medical/bruise_pack,
		/obj/item/stack/medical/bruise_pack,
		/obj/item/stack/medical/ointment,
		/obj/item/stack/medical/ointment,
		/obj/item/healthanalyzer,
		/obj/item/reagent_containers/hypospray/autoinjector
	)

/obj/item/storage/firstaid/toxin
	name = "poison first aid kit" //IRL the term used would be poison first aid kit.
	desc = "Used to treat when one has a high amount of toxins in their body."
	icon_state = "antitoxin"
	item_state_slots = list(slot_r_hand_str = "firstaid-toxin", slot_l_hand_str = "firstaid-toxin")
//	icon_variety = list("antitoxin","antitoxfirstaid","antitoxfirstaid2","antitoxfirstaid3")
	starts_with = list(
		/obj/item/reagent_containers/syringe/antitoxin,
		/obj/item/reagent_containers/syringe/antitoxin,
		/obj/item/reagent_containers/syringe/antitoxin,
		/obj/item/reagent_containers/pill/antitox,
		/obj/item/reagent_containers/pill/antitox,
		/obj/item/reagent_containers/pill/antitox,
		/obj/item/healthanalyzer
	)

/obj/item/storage/firstaid/o2
	name = "oxygen deprivation first aid kit"
	desc = "A box full of oxygen goodies."
	icon_state = "o2"
	item_state_slots = list(slot_r_hand_str = "firstaid-o2", slot_l_hand_str = "firstaid-o2")
	starts_with = list(
		/obj/item/reagent_containers/pill/dexalin,
		/obj/item/reagent_containers/pill/dexalin,
		/obj/item/reagent_containers/pill/dexalin,
		/obj/item/reagent_containers/pill/dexalin,
		/obj/item/reagent_containers/hypospray/autoinjector,
		/obj/item/reagent_containers/syringe/inaprovaline,
		/obj/item/healthanalyzer
	)

/obj/item/storage/firstaid/adv
	name = "advanced first aid kit"
	desc = "Contains advanced medical treatments, for <b>serious</b> boo-boos."
	icon_state = "advfirstaid"
	item_state_slots = list(slot_r_hand_str = "firstaid-advanced", slot_l_hand_str = "firstaid-advanced")
	starts_with = list(
		/obj/item/reagent_containers/hypospray/autoinjector,
		/obj/item/stack/medical/advanced/bruise_pack,
		/obj/item/stack/medical/advanced/bruise_pack,
		/obj/item/stack/medical/advanced/bruise_pack,
		/obj/item/stack/medical/advanced/ointment,
		/obj/item/stack/medical/advanced/ointment,
		/obj/item/stack/medical/splint
	)

/obj/item/storage/firstaid/combat
	name = "combat medical kit"
	desc = "Contains advanced medical treatments."
	icon_state = "bezerk"
	item_state_slots = list(slot_r_hand_str = "firstaid-advanced", slot_l_hand_str = "firstaid-advanced")
	starts_with = list(
		/obj/item/storage/pill_bottle/bicaridine,
		/obj/item/storage/pill_bottle/dermaline,
		/obj/item/storage/pill_bottle/dexalin_plus,
		/obj/item/storage/pill_bottle/dylovene,
		/obj/item/storage/pill_bottle/tramadol,
		/obj/item/storage/pill_bottle/spaceacillin,
		/obj/item/reagent_containers/hypospray/autoinjector/biginjector/clotting,
		/obj/item/stack/medical/splint,
		/obj/item/healthanalyzer/advanced
	)

/obj/item/storage/firstaid/surgery
	name = "surgery kit"
	desc = "Contains tools for surgery. Has precise foam fitting for safe transport and automatically sterilizes the content between uses."
	icon = 'icons/obj/storage.dmi'
	icon_state = "surgerykit"
	item_state = "firstaid-surgery"
	max_w_class = ITEMSIZE_NORMAL
	max_storage_space = 25			//update this when necessary!

	can_hold = list(
		/obj/item/surgical,
		/obj/item/stack/medical/advanced/bruise_pack,
		/obj/item/stack/nanopaste,
		/obj/item/healthanalyzer,
		/obj/item/autopsy_scanner
		)

	starts_with = list(
		/obj/item/surgical/bonesetter,
		/obj/item/surgical/cautery,
		/obj/item/surgical/circular_saw,
		/obj/item/surgical/hemostat,
		/obj/item/surgical/retractor,
		/obj/item/surgical/scalpel,
		/obj/item/surgical/surgicaldrill,
		/obj/item/surgical/bonegel,
		/obj/item/surgical/FixOVein,
		/obj/item/stack/medical/advanced/bruise_pack,
		///obj/item/healthanalyzer/advanced,
		/obj/item/autopsy_scanner
		)

/obj/item/storage/firstaid/clotting
	name = "clotting kit"
	desc = "Contains chemicals to stop bleeding."
	icon_state = "clottingkit"
	max_storage_space = ITEMSIZE_COST_SMALL * 7
	starts_with = list(/obj/item/reagent_containers/hypospray/autoinjector/biginjector/clotting = 8)

/obj/item/storage/firstaid/bonemed
	name = "bone repair kit"
	desc = "Contains chemicals to mend broken bones."
	max_storage_space = ITEMSIZE_COST_SMALL * 7
	starts_with = list(/obj/item/reagent_containers/hypospray/autoinjector/biginjector/bonemed = 8)

/*
 * Pill Bottles
 */
/obj/item/storage/pill_bottle
	name = "pill bottle"
	desc = "It's an airtight container for storing medication."
	icon_state = "pill_canister"
	icon = 'icons/obj/chemical.dmi'
	item_state_slots = list(slot_r_hand_str = "contsolid", slot_l_hand_str = "contsolid")
	w_class = ITEMSIZE_SMALL
	can_hold = list(/obj/item/reagent_containers/pill,/obj/item/dice,/obj/item/paper)
	allow_quick_gather = 1
	allow_quick_empty = 1
	use_to_pickup = 1
	use_sound = null
	max_storage_space = ITEMSIZE_COST_TINY * 14
	max_w_class = ITEMSIZE_TINY

	var/label_text = ""
	var/labeled = 0 // Citadel Change - Used in labeling
	var/base_name = " "
	var/base_desc = " "
	var/base_icon = "pill_canister" // Citadel Change - Used in recoloring
	var/bottle_color = "orange" // Citadel Change - Used in recoloring

/obj/item/storage/pill_bottle/Initialize()
	. = ..()
	base_name = name
	base_desc = desc
	update_icon()

/obj/item/storage/pill_bottle/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/pen) || istype(W, /obj/item/flashlight/pen))
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
			labeled = 1 // Citadel Change - Overlay for labels
			update_icon() // Citadel Change - Overlay for labels
	else
		..()

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

/obj/item/storage/pill_bottle/proc/choose_color() // BEGIN Citadel Changes - Bottle recoloring
	set name = "Recolor bottle"
	set category = "Object"
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
		add_overlay(image(icon = 'icons/obj/chemical.dmi', icon_state = "pill_canister_label"))
	if(base_icon == "pill_canister")
		if(bottle_color == "orange")
			icon_state = "[base_icon]"
		else
			icon_state = "[base_icon]_[bottle_color]"

/obj/item/storage/pill_bottle/Initialize(mapload)
	. = ..()
	if(base_icon == "pill_canister")
		verbs += /obj/item/storage/pill_bottle/proc/choose_color
	update_icon() // END Citadel Changes - Bottle recoloring

/obj/item/storage/pill_bottle/antitox
	name = "bottle of Dylovene pills"
	desc = "Contains pills used to counter toxins."
	labeled = 1 // Citadel Change - Recoloring - There are a lot of these.
	bottle_color = "green" // Citadel Change - Recoloring - There are a lot of these.
	starts_with = list(/obj/item/reagent_containers/pill/antitox = 7)

/obj/item/storage/pill_bottle/bicaridine
	name = "bottle of Bicaridine pills"
	desc = "Contains pills used to stabilize the severely injured."
	labeled = 1 // Citadel Change - Recoloring - There are a lot of these.
	bottle_color = "red" // Citadel Change - Recoloring - There are a lot of these.
	starts_with = list(/obj/item/reagent_containers/pill/bicaridine = 7)

/obj/item/storage/pill_bottle/dexalin_plus
	name = "bottle of Dexalin Plus pills"
	desc = "Contains pills used to treat extreme cases of oxygen deprivation."
	labeled = 1 // Citadel Change - Recoloring - There are a lot of these.
	bottle_color = "blue" // Citadel Change - Recoloring - There are a lot of these.
	starts_with = list(/obj/item/reagent_containers/pill/dexalin_plus = 7)

/obj/item/storage/pill_bottle/dermaline
	name = "bottle of Dermaline pills"
	desc = "Contains pills used to treat burn wounds."
	labeled = 1 // Citadel Change - Recoloring - There are a lot of these.
	starts_with = list(/obj/item/reagent_containers/pill/dermaline = 7)

/obj/item/storage/pill_bottle/dylovene
	name = "bottle of Dylovene pills"
	desc = "Contains pills used to treat toxic substances in the blood."
	labeled = 1 // Citadel Change - Recoloring - There are a lot of these.
	bottle_color = "green" // Citadel Change - Recoloring - There are a lot of these.
	starts_with = list(/obj/item/reagent_containers/pill/dylovene = 7)

/obj/item/storage/pill_bottle/inaprovaline
	name = "bottle of Inaprovaline pills"
	desc = "Contains pills used to stabilize patients."
	labeled = 1 // Citadel Change - Recoloring - There are a lot of these.
	bottle_color = "blue" // Citadel Change - Recoloring - There are a lot of these.
	starts_with = list(/obj/item/reagent_containers/pill/inaprovaline = 7)

/obj/item/storage/pill_bottle/kelotane
	name = "bottle of kelotane pills"
	desc = "Contains pills used to treat burns."
	labeled = 1 // Citadel Change - Recoloring - There are a lot of these.
	starts_with = list(/obj/item/reagent_containers/pill/kelotane = 7)

/obj/item/storage/pill_bottle/spaceacillin
	name = "bottle of Spaceacillin pills"
	desc = "A theta-lactam antibiotic. Effective against many diseases likely to be encountered in space."
	labeled = 1 // Citadel Change - Recoloring - There are a lot of these.
	bottle_color = "white" // Citadel Change - Recoloring - There are a lot of these.
	starts_with = list(/obj/item/reagent_containers/pill/spaceacillin = 7)

/obj/item/storage/pill_bottle/tramadol
	name = "bottle of Tramadol pills"
	desc = "Contains pills used to relieve pain."
	labeled = 1 // Citadel Change - Recoloring - There are a lot of these.
	bottle_color = "purple" // Citadel Change - Recoloring - There are a lot of these.
	starts_with = list(/obj/item/reagent_containers/pill/tramadol = 7)

/obj/item/storage/pill_bottle/citalopram
	name = "bottle of Citalopram pills"
	desc = "Contains pills used to stabilize a patient's mood."
	labeled = 1 // Citadel Change - Recoloring - There are a lot of these.
	starts_with = list(/obj/item/reagent_containers/pill/citalopram = 7)

/obj/item/storage/pill_bottle/carbon
	name = "bottle of Carbon pills"
	desc = "Contains pills used to neutralise chemicals in the stomach."
	labeled = 1 // Citadel Change - Recoloring - There are a lot of these.
	bottle_color = "black" // Citadel Change - Recoloring - There are a lot of these.
	starts_with = list(/obj/item/reagent_containers/pill/carbon = 7)

/obj/item/storage/pill_bottle/iron
	name = "bottle of Iron pills"
	desc = "Contains pills used to aid in blood regeneration."
	labeled = 1 // Citadel Change - Recoloring - There are a lot of these.
	bottle_color = "black" // Citadel Change - Recoloring - There are a lot of these.
	starts_with = list(/obj/item/reagent_containers/pill/iron = 7)

/obj/item/storage/firstaid/clotting
	icon_state = "clottingkit"

/obj/item/storage/firstaid/bonemed
	icon_state = "pinky"

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

/obj/item/storage/firstaid/insiderepair
	name = "combat organ kit"
	desc = "Contains advanced organ medical treatments."
	icon_state = "bezerk"
	item_state_slots = list(slot_r_hand_str = "firstaid-advanced", slot_l_hand_str = "firstaid-advanced")
	starts_with = list(
		/obj/item/storage/pill_bottle/rezadone,
		/obj/item/storage/pill_bottle/peridaxon,
		/obj/item/storage/pill_bottle/carthatoline,
		/obj/item/storage/pill_bottle/alkysine,
		/obj/item/storage/pill_bottle/imidazoline,
		/obj/item/storage/pill_bottle/osteodaxon,
		/obj/item/storage/pill_bottle/myelamine,
		/obj/item/storage/pill_bottle/arithrazine,
		/obj/item/healthanalyzer/advanced
	)
