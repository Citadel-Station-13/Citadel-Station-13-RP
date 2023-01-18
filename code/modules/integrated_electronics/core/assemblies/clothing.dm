
// The base subtype for assemblies that can be worn.  Certain pieces will have more or less capabilities
// E.g.  Glasses have less room than something worn over the chest.
// Note that the electronic assembly is INSIDE the object that actually gets worn, in a similar way to implants.

/obj/item/electronic_assembly/clothing
	name = "electronic clothing parts"
	icon_state = "setup_small_simple"
	desc = "It's a collection of wires and parts, designed to fit inside of specialized electronic clothing."
	w_class = ITEMSIZE_SMALL
	max_components = IC_COMPONENTS_BASE
	max_complexity = IC_COMPLEXITY_BASE
	var/obj/item/clothing/clothing = null

/obj/item/electronic_assembly/clothing/ui_host()
	return clothing.ui_host()

/obj/item/electronic_assembly/clothing/ui_action_click()
	clothing.action_circuit.do_work()

// This is 'small' relative to the size of regular clothing assemblies.
/obj/item/electronic_assembly/clothing/small
	name = "small electronic clothing parts"
	desc = "It's a collection of wires and parts, designed to fit inside of small specialized electronic clothing. "
	icon_state = "setup_device"
	max_components = IC_COMPONENTS_BASE / 2
	max_complexity = IC_COMPLEXITY_BASE / 2
	w_class = ITEMSIZE_TINY

// Ditto.
/obj/item/electronic_assembly/clothing/large
	name = "large electronic clothing parts"
	desc = "It's a collection of wires and parts, designed to fit inside of large specialized electronic clothing."
	icon_state = "setup_medium_clam"
	max_components = IC_COMPONENTS_BASE * 2
	max_complexity = IC_COMPLEXITY_BASE * 2
	w_class = ITEMSIZE_NORMAL


// This is defined higher up, in /clothing to avoid lots of copypasta.
/obj/item/clothing
	var/obj/item/electronic_assembly/clothing/EA = null
	var/obj/item/integrated_circuit/built_in/action_button/action_circuit = null // This gets pulsed when someone clicks the button on the hud.
	var/EA_Installed = null

/obj/item/clothing/emp_act(severity)
	if(EA)
		EA.emp_act(severity)
	..()

/obj/item/clothing/examine(mob/user)
	if(EA)
		EA.examine(user)
	. = ..()

/obj/item/clothing/attackby(obj/item/I, mob/user)
	if(EA)
		if (I.is_crowbar())
			var/turf/T = get_turf(src)
			EA.forceMove(T)
			src.EA_Installed = 0
			src.icon_state = "circuitry-open"
			src.EA = null
			EA.clothing = null
			playsound(T, 'sound/items/Crowbar.ogg', 50, TRUE)
			to_chat(usr, SPAN_NOTICE("You pull the circuitry out of \the [src]."))
			return
	else
		..()

/obj/item/clothing/attack_self(mob/user)
	if(EA && EA.opened)
		EA.attack_self(user)
	else
		..()

/obj/item/clothing/Moved(oldloc)
	EA ? EA.on_loc_moved(oldloc) : ..()

/obj/item/clothing/on_loc_moved(oldloc)
	EA ? EA.on_loc_moved(oldloc) : ..()

// Does most of the repeatative setup.
/obj/item/clothing/proc/setup_integrated_circuit(new_type)
	// Set up the internal circuit holder.
	EA = new new_type(src)
	EA.clothing = src

	// Clothing assemblies can be triggered by clicking on the HUD.  This allows that to occur.
	action_circuit = new(src.EA)
	EA.add_component(action_circuit)
	var/obj/item/integrated_circuit/built_in/self_sensor/S = new(src.EA)
	EA.add_component(S)
	EA.action_button_name = "Activate [name]"



/obj/item/clothing/Destroy()
	if(EA)
		EA.clothing = null
		action_circuit = null // Will get deleted by qdel-ing the IC assembly.
		qdel(EA)
	return ..()

// Specific subtypes.

// Jumpsuit.
/obj/item/clothing/under/circuitry
	name = "electronic jumpsuit"
	desc = "It's a wearable case for electronics.  This one is a black jumpsuit with wiring woven into the fabric."
	icon_state = "circuitry"
	snowflake_worn_state = "circuitry"
	EA_Installed = 1

/obj/item/clothing/under/circuitry/Initialize(mapload)
	setup_integrated_circuit(/obj/item/electronic_assembly/clothing)
	return ..()

/obj/item/clothing/under/circuitry/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/electronic_assembly/clothing))
		if(EA_Installed < 1)
			if(!user.attempt_insert_item_for_installation(I, src))
				return
			src.EA_Installed = 1
			EA = I
			EA.clothing = src
			src.icon_state = "circuitry"
			playsound(get_turf(src), 'sound/items/Deconstruct.ogg', 50, 1)
			to_chat(user, SPAN_NOTICE("You install the circuitry into \the [src]."))
			ui_interact(user)
			return
		return
	if(EA)
		return EA.attackby(I, user) ? null : ..()
	return ..()

// Gloves.
/obj/item/clothing/gloves/circuitry
	name = "electronic gloves"
	desc = "A wearable case for electronics comprising a pair of black gloves, with wires woven through the fabric.  A small \
	device with a screen is attached to the left glove."
	icon_state = "circuitry"
	item_state = "circuitry"
	EA_Installed = 1

/obj/item/clothing/gloves/circuitry/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/electronic_assembly/clothing/small))
		if(EA_Installed < 1)
			if(!user.attempt_insert_item_for_installation(I, src))
				return
			src.EA_Installed = 1
			EA = I
			EA.clothing = src
			src.icon_state = "circuitry"
			playsound(get_turf(src), 'sound/items/Deconstruct.ogg', 50, 1)
			to_chat(user, SPAN_NOTICE("You install the circuitry into \the [src]."))
			ui_interact(user)
			return
		return
	if(EA)
		return EA.attackby(I, user) ? null : ..()
	return ..()

/obj/item/clothing/gloves/circuitry/Initialize(mapload)
	setup_integrated_circuit(/obj/item/electronic_assembly/clothing/small)
	return ..()

// Watch.
/obj/item/clothing/gloves/ewatch/circuitry
	name = "electronic watch"
	desc = "A wearable case for electronics; a digital watch with an antenna and button array attatched to it.\
	Practical and stylish!"
	icon_state = "communicator"
	item_state = "ewatch"
	EA_Installed = 1

/obj/item/clothing/gloves/ewatch/circuitry/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/electronic_assembly/clothing/small))
		if(EA_Installed < 1)
			if(!user.attempt_insert_item_for_installation(I, src))
				return
			src.EA_Installed = 1
			EA = I
			EA.clothing = src
			src.icon_state = "communicator"
			playsound(get_turf(src), 'sound/items/Deconstruct.ogg', 50, 1)
			to_chat(user, SPAN_NOTICE("You install the circuitry into \the [src]."))
			ui_interact(user)
			return
		return
	if(EA)
		return EA.attackby(I, user) ? null : ..()
	return ..()

/obj/item/clothing/gloves/ewatch/circuitry/Initialize(mapload)
	setup_integrated_circuit(/obj/item/electronic_assembly/clothing/small)
	return ..()

// Glasses.
/obj/item/clothing/glasses/circuitry
	name = "electronic goggles"
	desc = "A wearable case for electronics; a pair of goggles, with exposed wiring.  Could this augment your vision?" // Sadly it won't, or at least not yet.
	icon_state = "circuitry"
	item_state = "night" // The on-mob sprite would be identical anyways.
	EA_Installed = 1

/obj/item/clothing/glasses/circuitry/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/electronic_assembly/clothing/small))
		if(EA_Installed < 1)
			if(!user.attempt_insert_item_for_installation(I, src))
				return
			src.EA_Installed = 1
			EA = I
			EA.clothing = src
			src.icon_state = "circuitry"
			playsound(get_turf(src), 'sound/items/Deconstruct.ogg', 50, 1)
			to_chat(user, SPAN_NOTICE("You install the circuitry into \the [src]."))
			ui_interact(user)
			return
		return
	if(EA)
		return EA.attackby(I, user) ? null : ..()
	return ..()

/obj/item/clothing/glasses/circuitry/Initialize(mapload)
	setup_integrated_circuit(/obj/item/electronic_assembly/clothing/small)
	return ..()

// Shoes
/obj/item/clothing/shoes/circuitry
	name = "electronic boots"
	desc = "A wearable case for electronics comprising a pair of boots with sleek maintenance hatches on the inside leg."
	icon_state = "circuitry"
	item_state = "circuitry"
	EA_Installed = 1

/obj/item/clothing/shoes/circuitry/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/electronic_assembly/clothing/small))
		if(EA_Installed < 1)
			if(!user.attempt_insert_item_for_installation(I, src))
				return
			src.EA_Installed = 1
			EA = I
			EA.clothing = src
			src.icon_state = "circuitry"
			playsound(get_turf(src), 'sound/items/Deconstruct.ogg', 50, 1)
			to_chat(user, SPAN_NOTICE("You install the circuitry into \the [src]."))
			ui_interact(user)
			return
		return
	if(EA)
		return EA.attackby(I, user) ? null : ..()
	return ..()

/obj/item/clothing/shoes/circuitry/Initialize(mapload)
	setup_integrated_circuit(/obj/item/electronic_assembly/clothing/small)
	return ..()

// Head
/obj/item/clothing/head/circuitry
	name = "electronic headwear"
	desc = "A a very technical-looking wearable case for electronics that clasps around the collar with a heads-up-display attached on the right."
	icon_state = "circuitry"
	item_state = "circuitry"
	EA_Installed = 1

/obj/item/clothing/head/circuitry/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/electronic_assembly/clothing/small))
		if(EA_Installed < 1)
			if(!user.attempt_insert_item_for_installation(I, src))
				return
			src.EA_Installed = 1
			EA = I
			EA.clothing = src
			src.icon_state = "circuitry"
			playsound(get_turf(src), 'sound/items/Deconstruct.ogg', 50, 1)
			to_chat(user, SPAN_NOTICE("You install the circuitry into \the [src]."))
			ui_interact(user)
			return
		return
	if(EA)
		return EA.attackby(I, user) ? null : ..()
	return ..()

/obj/item/clothing/head/circuitry/Initialize(mapload)
	setup_integrated_circuit(/obj/item/electronic_assembly/clothing/small)
	return ..()

// Ear
/obj/item/clothing/ears/circuitry
	name = "electronic earwear"
	desc = "A wearable case for electronics, bulkier than your average headset."
	icon = 'icons/obj/clothing/ears.dmi'
	icon_state = "circuitry"
	item_state = "circuitry"
	EA_Installed = 1

/obj/item/clothing/ears/circuitry/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/electronic_assembly/clothing/small))
		if(EA_Installed < 1)
			if(!user.attempt_insert_item_for_installation(I, src))
				return
			src.EA_Installed = 1
			EA = I
			EA.clothing = src
			src.icon_state = "circuitry"
			playsound(get_turf(src), 'sound/items/Deconstruct.ogg', 50, 1)
			to_chat(user, SPAN_NOTICE("You install the circuitry into \the [src]."))
			ui_interact(user)
			return
		return
	if(EA)
		return EA.attackby(I, user) ? null : ..()
	return ..()

/obj/item/clothing/ears/circuitry/Initialize(mapload)
	setup_integrated_circuit(/obj/item/electronic_assembly/clothing/small)
	return ..()

// Exo-slot
/obj/item/clothing/suit/circuitry
	name = "electronic chestpiece"
	desc = "A wearable case for electronics that sits over the chest and back.  The sheer bulk of it gives it an imposing presence."
	icon_state = "circuitry"
	item_state = "circuitry"
	EA_Installed = 1

/obj/item/clothing/suit/circuitry/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/electronic_assembly/clothing/large))
		if(EA_Installed < 1)
			if(!user.attempt_insert_item_for_installation(I, src))
				return
			src.EA_Installed = 1
			EA = I
			EA.clothing = src
			src.icon_state = "circuitry"
			playsound(get_turf(src), 'sound/items/Deconstruct.ogg', 50, 1)
			to_chat(user, SPAN_NOTICE("You install the circuitry into \the [src]."))
			ui_interact(user)
			return
		return
	if(EA)
		return EA.attackby(I, user) ? null : ..()
	return ..()

/obj/item/clothing/suit/circuitry/Initialize(mapload)
	setup_integrated_circuit(/obj/item/electronic_assembly/clothing/large)
	return ..()
