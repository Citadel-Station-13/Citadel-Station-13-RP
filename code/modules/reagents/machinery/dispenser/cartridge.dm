/obj/item/reagent_containers/cartridge/dispenser
	name = "dispenser cartridge"
	desc = "This goes in a chemical dispenser."
	icon_state = "cartridge"
	w_class = WEIGHT_CLASS_NORMAL
	amount_per_transfer_from_this = 50
	possible_transfer_amounts = list(50, 100, 250, 500)

	/// label - the dispenser sees this, not what's in us
	var/label

/obj/item/reagent_containers/cartridge/dispenser/Initialize(mapload)
	. = ..()
	set_label(label)

/obj/item/reagent_containers/cartridge/dispenser/proc/set_label(new_label)
	label = new_label
	name = "[initial(name)] ([label])"

/obj/item/reagent_containers/cartridge/dispenser/verb/set_label_verb()
	set name = "Set Label"
	set category = "Object"
	set src in usr

	var/new_label = input(usr, "Enter a new label.", "Label Cartridge", label) as text|null

	if(isnull(new_label))
		return

	to_chat(usr, new_label? SPAN_NOTICE("You set the cartridge's label to '[new_label]'.") : SPAN_NOTICE("You erase the label on the cartridge."))

	set_label(new_label)

/obj/item/reagent_containers/cartridge/dispenser/examine(mob/user)
	. = ..()
	. += "It has a capacity of [volume] units."
	if(reagents.total_volume <= 0)
		. += "It is empty."
	else
		. += "It contains [reagents.total_volume] units of liquid."
	if(!is_open_container())
		. += "The cap is sealed."

/obj/item/reagent_containers/cartridge/dispenser/attack_self(mob/user)
	. = ..()
	if(.)
		return
	if(is_open_container())
		to_chat(user, SPAN_NOTICE("You put the cap on \the [src]."))
		atom_flags ^= OPENCONTAINER
	else
		to_chat(user, SPAN_NOTICE("You put the cap off of \the [src]."))
		atom_flags |= OPENCONTAINER


/obj/item/reagent_containers/cartridge/dispenser/large
	name = "large dispenser cartridge"
	volume = 1000

/obj/item/reagent_containers/cartridge/dispenser/medium
	name = "medium dispenser cartridge"
	volume = 500

/obj/item/reagent_containers/cartridge/dispenser/small
	name = "small dispenser cartridge"
	volume = 250
