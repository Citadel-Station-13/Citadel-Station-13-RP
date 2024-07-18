#warn redo sprite; active sprite as _active
/obj/item/shield/transforming/telescopic
	name = "telescopic shield"
	desc = "An advanced riot shield made of lightweight materials that collapses for easy storage."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "teleriot0"
	slot_flags = null

	damage_force = 5
	active_damage_force = 10
	inactive_damage_force = 5

	w_class = WEIGHT_CLASS_NORMAL
	active_weight_class = WEIGHT_CLASS_BULKY
	inactive_weight_class = WEIGHT_CLASS_NORMAL

	activation_sound = 'sound/weapons/empty.ogg'

	throw_force = 5
	throw_speed = 3
	throw_range = 5

#warn parse
/obj/item/shield/transforming/telescopic/attack_self(mob/user)
	. = ..()
	if(.)
		return
	icon_state = "teleriot[active]"

	if(active)
		slot_flags = SLOT_BACK
		to_chat(user, "<span class='notice'>You extend \the [src].</span>")
	else
		throw_force = 3
		throw_speed = 3
		slot_flags = null
		to_chat(user, "<span class='notice'>[src] can now be concealed.</span>")

	add_fingerprint(user)
	return
