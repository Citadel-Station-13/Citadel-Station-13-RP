/obj/item/clothing/under/event_reward/foxmiko
	name = "Miko Garb"
	desc = "The creative reinterpretation of Shinto miko attire."
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	icon = 'icons/obj/clothing/eventclothing.dmi'
	icon_override = 'icons/mob/eventclothing.dmi'
	icon_state = "foxmiko"
	item_state = "foxmiko"
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL //Don't want to try and roll sleeves like you can with a normal jumpsuit
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	var/kimono = 0 //Custom vars for tracking kimono and skirt state
	var/skirt = 0


/obj/item/clothing/under/event_reward/foxmiko/verb/partkimono() //Verb for parting kimono - kinky. User reporting, flips state, and updates icon
    set name = "Adjust Kimono"
    set category = "Object"
    set src in usr
    if(!istype(usr, /mob/living)) //Standard checks for clothing verbs
        return
    if(usr.stat)
        return

    if(kimono) //User reporting
        to_chat(usr, "You correct your kimono.")
    else
        to_chat(usr, "You part your kimono.")

    kimono = !kimono //Switch state parted -> unparted, or unparted -> parted
    switchsprite() //Proc call - handles the two states of kimono and skirt

    var/mob/M = src.loc //And finally update the icon
    M.update_inv_w_uniform()
    update_worn_icon()

/obj/item/clothing/under/event_reward/foxmiko/verb/liftskirt() //Verb for parting skirt - lewd. User reporting, flips state, and updates icon
    set name = "Adjust Skirt"
    set category = "Object"
    set src in usr
    if(!istype(usr, /mob/living)) //Standard checks for clothing verbs
        return
    if(usr.stat)
        return

    if(skirt) //User reporting
        to_chat(usr, "You drop your skirt.")
    else
        to_chat(usr, "You lift your skirt.")

    skirt = !skirt //Switch state lifted -> unlifeted, or unlifted -> lifted
    switchsprite() //Proc call - handles the two states of kimono and skirt

    var/mob/M = src.loc //And finally update the icon
    M.update_inv_w_uniform()
    update_worn_icon()


/obj/item/clothing/under/event_reward/foxmiko/proc/switchsprite() //Handles the ultimate state of the icon as well as what parts of body the attire covers
	body_parts_covered = initial(body_parts_covered) //Resets to default coverage for this uniform - upper and lower body
	if(kimono) //If the kimono is parted
		if(skirt) //If the skirt is parted too
			item_state_slots[SLOT_ID_UNIFORM] = "[snowflake_worn_state]_ks" //Then we want the assosiated mob icon - denoted with _ks
			icon_state = "foxmiko_ks" //This is for item icon - NOT WORN ICON
			body_parts_covered &= ~(UPPER_TORSO|LOWER_TORSO) //If kimono is open and skirt lifted uncover both upper and lower body
		else //But skirt is not lifted too
			item_state_slots[SLOT_ID_UNIFORM] = "[snowflake_worn_state]_k" //We use [snowflake_worn_state] rather than an explicit declaration because the game appends a _s to icon states
			icon_state = "foxmiko_k"
			body_parts_covered &= ~(UPPER_TORSO)
	else //If kimono is not parted
		if(skirt) //If skirt is lifted
			item_state_slots[SLOT_ID_UNIFORM] = "[snowflake_worn_state]_s" //Meaning in the icon sprite files this is foxmiko_s_s
			icon_state = "foxmiko_s"
			body_parts_covered &= ~(LOWER_TORSO)
		else //But skirt is not lifted too - default state
			item_state_slots[SLOT_ID_UNIFORM] = "[snowflake_worn_state]"
			icon_state = "foxmiko"


/obj/item/clothing/under/event_reward/foxmiko/proc/hide_accessory(mob/user, obj/item/clothing/accessory/A) //Proc, handles hiding and concealing accessories and user reporting
	if(!LAZYLEN(accessories) || !(A in accessories)) //Double check - if there's no accessories, break it now.
		return

	if(A.icon_state == "") //If the icon has already been hidden
		A.icon_state = initial(A.icon_state) //Revert the icon to the original state, making it visible again
		A.overlay_state	= initial(A.overlay_state) //As well as the overlay_state - certain accessories use both
		to_chat(usr, "You reveal [A] from among your [src].") //And reports to user
	else //If the icon hasn't already been hidden
		A.icon_state = "" //Hide icon state
		A.overlay_state = "" //Hide overlay state - certain accessories use both
		to_chat(usr, "You hide [A] among your [src].") //And reports to user

	var/mob/M = src.loc //And updates the icon
	M.update_inv_w_uniform()
	update_worn_icon()


/obj/item/clothing/under/event_reward/foxmiko/verb/hidetie() //Verb for concealing assessory icons on mob spirt - this is a hack of the original code to remove accessories
	set name = "Hide Accessory"
	set category = "Object"
	set src in usr
	if(!istype(usr, /mob/living)) return //Standard checks for clothing verbs
	if(usr.stat) return
	var/obj/item/clothing/accessory/A //obj for accessory we are targeting
	if(LAZYLEN(accessories)) //If the list contains accessories - it is valid
		A = input("Select an accessory to hide on [src]") as null|anything in accessories
	if(A) //If a selection is made, call the other proc
		hide_accessory(usr,A)
	if(!LAZYLEN(accessories)) //But if there are no accessories, list will be empty, meaning we ought to remove access to verb
		src.verbs -= /obj/item/clothing/under/event_reward/foxmiko/verb/hidetie //Removes access to verb
		accessories = null
