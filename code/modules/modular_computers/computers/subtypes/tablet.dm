/obj/item/modular_computer/tablet  //Its called tablet for theme of 90ies but actually its a "big smartphone" sized
	name = "tablet computer"
	icon = 'icons/obj/modular_tablet.dmi'
	icon_state = "tablet-red"
	icon_state_unpowered = "tablet-red"
	icon_state_powered = "tablet-red"
	icon_state_menu = "menu"
	base_icon_state = "tablet"
	// worn_icon_state = "tablet"
	hardware_flag = PROGRAM_TABLET
	max_hardware_size = 1
	w_class = WEIGHT_CLASS_SMALL
	max_bays = 3
	steel_sheet_cost = 1
	slot_flags = SLOT_ID | SLOT_BELT
	has_light = TRUE //LED flashlight!
	comp_light_luminosity = 2.3 //Same as the PDA
	looping_sound = FALSE
	var/has_variants = TRUE
	var/finish_color = null

	//Pen stuff
	var/list/contained_item = list(/obj/item/pen, /obj/item/lipstick, /obj/item/flashlight/pen, /obj/item/clothing/mask/smokable/cigarette)
	var/obj/item/inserted_item //Used for pen, crayon, and lipstick insertion or removal. Same as above.
	var/can_have_pen = TRUE

/obj/item/modular_computer/tablet/examine(mob/user)
	. = ..()
	if(inserted_item && (!isturf(loc)))
		. += "<span class='notice'>Ctrl-click to remove [inserted_item].</span>"

/obj/item/modular_computer/tablet/Initialize(mapload)
	. = ..()
	if(can_have_pen)
		if(inserted_item)
			inserted_item = new inserted_item(src)
		else
			inserted_item =	new /obj/item/pen(src)

/obj/item/modular_computer/tablet/proc/insert_pen(obj/item/pen)
	if(!usr.transfer_item_to_loc(pen, src))
		return
	to_chat(usr, "<span class='notice'>You slide \the [pen] into \the [src]'s pen slot.</span>")
	inserted_item = pen
	playsound(src, 'sound/machines/button.ogg', 50, 1)
	SStgui.update_uis(src)

/obj/item/modular_computer/tablet/proc/remove_pen()
	if(!usr.canUseTopic(src, TRUE, FALSE, TRUE))
		return

	if(inserted_item)
		usr.put_in_hands(inserted_item)
		to_chat(usr, "<span class='notice'>You remove [inserted_item] from \the [src]'s pen slot.</span>")
		inserted_item = null
		SStgui.update_uis(src)
	else
		to_chat(usr, "<span class='warning'>\The [src] does not have a pen in it!</span>")

/obj/item/modular_computer/tablet/CtrlClick(mob/user)
	. = ..()
	if(isturf(loc))
		return

	if(can_have_pen)
		remove_pen(user)

/obj/item/modular_computer/tablet/attackby(obj/item/W, mob/user)
	if(can_have_pen && is_type_in_list(W, contained_item))
		if(inserted_item)
			to_chat(user, "<span class='warning'>There is \a [inserted_item] blocking \the [src]'s pen slot!</span>")
			return
		else
			insert_pen(W)
			return
	. = ..()

/obj/item/modular_computer/tablet/Destroy()
	if(istype(inserted_item))
		QDEL_NULL(inserted_item)
	return ..()

/obj/item/modular_computer/tablet/ui_act(action, params)
	. = ..()
	if(.)
		return
	if(action == "TABLET_eject_pen")
		if(istype(src, /obj/item/modular_computer/tablet))
			var/obj/item/modular_computer/tablet/self = src
			if(self.can_have_pen)
				self.remove_pen()
				return TRUE

/obj/item/modular_computer/tablet/ui_data(mob/user)
	. = ..()
	.["TABLET_show_pen_eject"] = inserted_item ? 1 : 0

/obj/item/modular_computer/tablet/update_icon_state()
	if(has_variants)
		if(!finish_color)
			finish_color = pick("red", "blue", "brown", "green", "black")
		icon_state = icon_state_powered = icon_state_unpowered = "[base_icon_state]-[finish_color]"
	return ..()
