/obj/item/clothing/under/event_reward/foxmiko
	name = "Miko Garb"
	desc = "The creative reinterpretation of Shinto miko attire."
	body_cover_flags = UPPER_TORSO|LOWER_TORSO
	icon = 'icons/clothing/event/foxmiko.dmi'
	icon_state = "foxmiko"
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	worn_has_rolldown = UNIFORM_HAS_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"
	var/skirt_rolled = 0 //Custom vars for tracking skirt state

//Reduced to a single function. Parting the kimono is now under rolldown.
/obj/item/clothing/under/event_reward/foxmiko/verb/liftskirt() //Verb for parting skirt - lewd. User reporting, flips state, and updates icon
    set name = "Adjust Skirt"
    set category = VERB_CATEGORY_OBJECT
    set src in usr
    if(!istype(usr, /mob/living)) //Standard checks for clothing verbs
        return
    if(usr.stat)
        return

    if(skirt_rolled) //User reporting
        to_chat(usr, "You drop your skirt.")
        body_cover_flags = body_cover_flags | LOWER_TORSO
        icon = "foxmiko"
        skirt_rolled = FALSE
    else
        to_chat(usr, "You lift your skirt.")
        body_cover_flags &= ~LOWER_TORSO
        icon = "foxmiko_skirt"
        skirt_rolled = TRUE

    update_worn_icon()
