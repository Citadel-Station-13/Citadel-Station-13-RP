/obj/item/radio/headset/speak_n_rock
    name = "\improper 'NT'-brand headphones"
    desc = "A set of open-backed headphones emblazened with a corporate logo. Connects to radio networks. Warranty void if used underwater."
    icon = 'icons/obj/items.dmi'    // Radios set their own icons, so have to re-set this here.

    icon_state = "headphones_off"
    item_state_slots = list(SLOT_ID_RIGHT_HAND = "headphones", SLOT_ID_LEFT_HAND = "headphones")
    slot_flags = SLOT_EARS
    ear_protection = 0    // set to 0 for now, can change later

    var/headphones_on = FALSE

// This is a clone of /obj/item/clothing/ears/earmuffs/headphones/verb/togglemusic()'s functionality.
/obj/item/radio/headset/speak_n_rock/verb/togglemusic()
    set name = "Toggle Headphone Music"
    set category = "Object"
    set src in usr
    if(!istype(usr, /mob/living) || usr.stat) return

    var/base_icon = copytext(icon_state,1,(length(icon_state) - 3 + headphones_on))

    headphones_on = !headphones_on
    icon_state = "[base_icon]_[headphones_on ? "on" : "off"]"
    to_chat(usr, SPAN_NOTICE("You turn the music [headphones_on ? "on" : "off"]."))

    if (ismob(loc))
        var/mob/M = loc
        M.update_inv_ears()

/obj/item/radio/headset/speak_n_rock/AltClick(mob/user)
    if(!Adjacent(user))
        return
    else if(!headphones_on)
        togglemusic()
    else
        togglemusic()

//donator item
/obj/item/radio/headset/speak_n_rock/aura
    name = "\improper KNIGHT-brand Melodic headset"
    icon_state = "auraphones_off"
    desc = "A hand-made series of headphones. Featuring a unique, bowman-inspired design, each is made with the individual in mind."
    adhoc_fallback = TRUE
