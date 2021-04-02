/obj/item/melee/energy/sword/imperial
	name = "energy gladius"
	desc = "A broad, short energy blade.  You'll be glad to have this in a fight."
	icon_state = "sword0"
	icon = 'icons/obj/weapons_vr.dmi'
	item_icons = list(slot_l_hand_str = 'icons/mob/items/lefthand_melee_vr.dmi', slot_r_hand_str = 'icons/mob/items/righthand_melee_vr.dmi')

/obj/item/melee/energy/sword/imperial/activate(mob/living/user)
	..()
	icon_state = "sword1"
