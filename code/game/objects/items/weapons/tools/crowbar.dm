/*
 * Crowbar
 */

/obj/item/tool/crowbar
	name = "crowbar"
	desc = "Used to remove floors and to pry open doors."
	icon = 'icons/obj/tools.dmi'
	icon_state = "crowbar"
	item_state = "crowbar"
	slot_flags = SLOT_BELT
	tool_behaviour = TOOL_CROWBAR
	force = 6
	throwforce = 7
	pry = 1
	item_state = "crowbar"
	w_class = ITEMSIZE_SMALL
	origin_tech = list(TECH_ENGINEERING = 1)
	matter = list(MAT_STEEL = 50)
	attack_verb = list("attacked", "bashed", "battered", "bludgeoned", "whacked")
	usesound = 'sound/items/crowbar.ogg'
	drop_sound = 'sound/items/drop/crowbar.ogg'
	pickup_sound = 'sound/items/pickup/crowbar.ogg'
	toolspeed = 1


/obj/item/tool/crowbar/is_crowbar()
	return TRUE

/obj/item/tool/crowbar/red
	icon = 'icons/obj/tools.dmi'
	icon_state = "crowbar_red"
	item_state = "crowbar_red"

/obj/item/tool/crowbar/bone
	name = "primitive crowbar"
	desc = "A sturdy, carved bone used to remove floors and to pry open doors."
	icon = 'icons/obj/tools.dmi'
	icon_state = "crowbar_bone"
	toolspeed = 1.25

/obj/item/tool/crowbar/brass
	name = "brass crowbar"
	desc = "An etched piece of brass plated metal, used to remove floors and to pry open doors."
	icon = 'icons/obj/tools.dmi'
	icon_state = "crowbar_brass"
	toolspeed = 0.75

/datum/category_item/catalogue/anomalous/precursor_a/alien_crowbar
	name = "Precursor Alpha Object - Hard Light Pry Tool"
	desc = "An object which bears striking resemblence to the common crowbar. \
	It appears to also serve a similar purpose, being used for prying. Unlike \
	a crowbar, however, this object is made of some form of 'hard light'.\
	<br><br>\
	There is a visible switch on the base of the tool, which controls the \
	hard light side of the tool. When the switch is used, the shape of \
	the tool changes, with the hard light moving and making a prying motion. \
	This allows the user to pry something with no physical effort beyond keeping \
	the tool aligned while in use."
	value = CATALOGUER_REWARD_EASY

/obj/item/tool/crowbar/alien
	name = "alien crowbar"
	desc = "A hard-light crowbar. It appears to pry by itself, without any effort required."
	catalogue_data = list(/datum/category_item/catalogue/anomalous/precursor_a/alien_crowbar)
	icon = 'icons/obj/abductor.dmi'
	usesound = 'sound/weapons/sonic_jackhammer.ogg'
	icon_state = "crowbar"
	toolspeed = 0.1
	origin_tech = list(TECH_COMBAT = 4, TECH_ENGINEERING = 4)

/obj/item/tool/crowbar/hybrid
	name = "strange crowbar"
	desc = "A crowbar whose head seems to phase in and out of view."
	catalogue_data = list(/datum/category_item/catalogue/anomalous/precursor_a/alien_crowbar)
	icon_state = "hybcrowbar"
	usesound = 'sound/weapons/sonic_jackhammer.ogg'
	toolspeed = 0.4
	origin_tech = list(TECH_COMBAT = 4, TECH_ENGINEERING = 3)
	reach = 2

/obj/item/tool/crowbar/cyborg
	name = "hydraulic crowbar"
	desc = "A hydraulic prying tool, compact but powerful. Designed to replace crowbars in industrial synthetics."
	usesound = 'sound/items/jaws_pry.ogg'
	force = 10
	toolspeed = 0.5

/obj/item/tool/crowbar/RIGset
	name = "integrated prybar"
	desc = "If you're seeing this, someone did a dum-dum."
	usesound = 'sound/items/jaws_pry.ogg'
	toolspeed = 0.7

/obj/item/tool/crowbar/power
	name = "jaws of life"
	desc = "A set of jaws of life, compressed through the magic of science. It's fitted with a prying head."
	icon_state = "jaws_pry"
	item_state = "jawsoflife"
	matter = list(MAT_METAL=150, MAT_SILVER=50)
	origin_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2)
	usesound = 'sound/items/jaws_pry.ogg'
	force = 15
	toolspeed = 0.25
	var/obj/item/tool/wirecutters/power/counterpart = null

/obj/item/tool/crowbar/power/Initialize(mapload, no_counterpart = TRUE)
	. = ..()
	if(!counterpart && no_counterpart)
		counterpart = new(src, FALSE)
		counterpart.counterpart = src

/obj/item/tool/crowbar/power/Destroy()
	if(counterpart)
		counterpart.counterpart = null // So it can qdel cleanly.
		QDEL_NULL(counterpart)
	return ..()

/obj/item/tool/crowbar/power/attack_self(mob/user)
	playsound(get_turf(user), 'sound/items/change_jaws.ogg', 50, 1)
	user.drop_item(src)
	counterpart.forceMove(get_turf(src))
	src.forceMove(counterpart)
	user.put_in_active_hand(counterpart)
	to_chat(user, "<span class='notice'>You attach the cutting jaws to [src].</span>")

/*
 * Prybar
 */

/obj/item/tool/prybar
	name = "pry bar"
	desc = "A steel bar with a wedge, designed specifically for opening unpowered doors in an emergency. It comes in a variety of configurations - collect them all!"
	icon = 'icons/obj/tools_vr.dmi'
	icon_state = "prybar"
	slot_flags = SLOT_BELT
	force = 4
	throwforce = 5
	pry = 1
	item_state = "crowbar"
	w_class = ITEMSIZE_SMALL
	origin_tech = list(TECH_ENGINEERING = 1)
	matter = list(MAT_STEEL = 30)
	attack_verb = list("whapped", "smacked", "swatted", "thwacked", "hit")
	usesound = 'sound/items/crowbar.ogg'
	toolspeed = 1
	var/random_color = TRUE

/obj/item/tool/prybar/red
	icon_state = "prybar_red"
	item_state = "crowbar_red"
	random_color = FALSE

/obj/item/tool/prybar/Initialize(mapload)
	. = ..()
	if(random_color)
		icon_state = "prybar[pick("","_green","_aubergine","_blue")]"
