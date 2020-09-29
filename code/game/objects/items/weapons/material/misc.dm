/obj/item/material/harpoon
	name = "harpoon"
	sharp = 1
	edge = 0
	desc = "Tharr she blows!"
	icon_state = "harpoon"
	item_state = "harpoon"
	force_divisor = 0.3 // 18 with hardness 60 (steel)
	attack_verb = list("jabbed","stabbed","ripped")

/obj/item/material/knife/machete/hatchet
	name = "hatchet"
	desc = "A very sharp axe blade upon a short fibremetal handle. It has a long history of chopping things, but now it is used for chopping wood."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "hatchet"
	force_divisor = 0.2 // 12 with hardness 60 (steel)
	thrown_force_divisor = 0.75 // 15 with weight 20 (steel)
	w_class = ITEMSIZE_SMALL
	sharp = 1
	edge = 1
	origin_tech = list(TECH_MATERIAL = 2, TECH_COMBAT = 1)
	attack_verb = list("chopped", "torn", "cut")
	applies_material_color = 0

/obj/item/material/knife/machete/hatchet/unathiknife
	name = "duelling knife"
	desc = "A length of leather-bound wood studded with razor-sharp teeth. How crude."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "unathiknife"
	attack_verb = list("ripped", "torn", "cut")
	can_cleave = FALSE
	var/hits = 0

/obj/item/material/knife/machete/hatchet/unathiknife/attack(mob/M as mob, mob/user as mob)
	if(hits > 0)
		return
	var/obj/item/I = user.get_inactive_hand()
	if(istype(I, /obj/item/material/knife/machete/hatchet/unathiknife))
		hits ++
		var/obj/item/W = I
		W.attack(M, user)
		W.afterattack(M, user)
	..()

/obj/item/material/knife/machete/hatchet/unathiknife/afterattack(mob/M as mob, mob/user as mob)
	hits = initial(hits)
	..()

/obj/item/material/minihoe // -- Numbers
	name = "mini hoe"
	desc = "It's used for removing weeds or scratching your back."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "hoe"
	force_divisor = 0.25 // 5 with weight 20 (steel)
	thrown_force_divisor = 0.25 // as above
	dulled_divisor = 0.75	//Still metal on a long pole
	w_class = ITEMSIZE_SMALL
	attack_verb = list("slashed", "sliced", "cut", "clawed")

/obj/item/material/snow/snowball
	name = "loose packed snowball"
	desc = "A fun snowball. Throw it at your friends!"
	icon = 'icons/obj/weapons.dmi'
	icon_state = "snowball"
	default_material = MAT_SNOW
	health = 1
	fragile = 1
	force_divisor = 0.01
	thrown_force_divisor = 0.10
	w_class = ITEMSIZE_SMALL
	attack_verb = list("mushed", "splatted", "splooshed", "splushed") // Words that totally exist.

/obj/item/material/snow/snowball/attack_self(mob/user as mob)
	if(user.a_intent == INTENT_HARM)
		visible_message("[user] has smashed the snowball in their hand!", "You smash the snowball in your hand.")
		var/atom/S = new /obj/item/stack/material/snow(user.loc)
		del(src)
		user.put_in_hands(S)
	else
		visible_message("[user] starts compacting the snowball.", "You start compacting the snowball.")
		if(do_after(user, 2 SECONDS))
			var/atom/S = new /obj/item/material/snow/snowball/reinforced(user.loc)
			del(src)
			user.put_in_hands(S)

/obj/item/material/snow/snowball/reinforced
	name = "snowball"
	desc = "A well-formed and fun snowball. It looks kind of dangerous."
	//icon_state = "reinf-snowball"
	force_divisor = 0.20
	thrown_force_divisor = 0.25

/obj/item/material/butterfly/saw //This Saw Cleaver is in here since I do not know where else to put it
	name = "Saw Cleaver"
	desc = "A weapon consisting of a long handle and a heavy serrated blade. Using centrifrical force the blade extends outword allowing it to slice it long cleaves. The smell of blood hangs in the air around it."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "sawcleaver"
	item_icons = list(
			slot_l_hand_str = 'icons/mob/items/64x64_lefthand.dmi',
			slot_r_hand_str = 'icons/mob/items/64x64_righthand.dmi',
			)
	item_state = "cleaving_saw"
	active = 0
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	hitsound = 'sound/weapons/bladeslice.ogg'
	w_class = ITEMSIZE_LARGE
	edge = 1
	sharp = 1
	force_divisor = 0.7 //42 When Wielded in line with a sword
	thrown_force_divisor = 0.1 // 2 when thrown with weight 20 (steel) since frankly its too bulk to throw
	//holy = TRUE		// Holy trait commented out until Dark Corners of the Galaxy: Awakening Merge

/obj/item/material/butterfly/saw/update_force()
	if(active)
		..() //Updates force.
		w_class = ITEMSIZE_HUGE
		can_cleave = TRUE
		force_divisor = 0.4 //24 when wielded, Gains cleave and is better than a machete
		icon_state = "sawcleaver_open"
		item_state = "cleaving_saw_open"
	else
		w_class = initial(w_class)
		can_cleave = initial(can_cleave)
		force_divisor = initial(force_divisor)
		icon_state = initial(icon_state)
		item_state = initial(item_state)

