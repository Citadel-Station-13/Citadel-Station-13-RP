/obj/item/material/harpoon
	name = "harpoon"
	damage_mode = DAMAGE_MODE_SHARP
	desc = "A common design throughout the galaxy, this is a metal spear used for hunting fish (or people in voidsuits, to devestating effect)."
	icon_state = "harpoon"
	item_state = "harpoon"
	material_significance = MATERIAL_SIGNIFICANCE_WEAPON_HEAVY
	damage_mode = DAMAGE_MODE_SHARP
	attack_verb = list("jabbed","stabbed","ripped")

/obj/item/material/harpoon/plasteel
	material_parts = /datum/prototype/material/plasteel

/obj/item/material/harpoon/durasteel
	material_parts = /datum/prototype/material/durasteel

/obj/item/material/knife/machete/hatchet
	name = "hatchet"
	desc = "A one-handed axe, with a short fibremetal handle. There's an infinite amount of variations in the galaxy, but this one's used for chopping wood."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "hatchet"
	material_significance = MATERIAL_SIGNIFICANCE_WEAPON_HEAVY
	damage_mode = DAMAGE_MODE_SHARP | DAMAGE_MODE_EDGE
	w_class = WEIGHT_CLASS_SMALL
	origin_tech = list(TECH_MATERIAL = 2, TECH_COMBAT = 1)
	attack_verb = list("chopped", "torn", "cut")
	material_color = 0
	drop_sound = 'sound/items/drop/axe.ogg'
	pickup_sound = 'sound/items/pickup/axe.ogg'

/obj/item/material/knife/machete/hatchet/bone
	name = "primitive hatchet"
	desc = "A broad, flat piece of bone knapped to a sharp edge. A truly primitive weapon."
	icon_state = "hatchet_bone"
	material_parts = /datum/prototype/material/bone

/obj/item/material/knife/machete/hatchet/bronze
	name = "bronze hatchet"
	desc = "A bronze axe head on a bone handle. You can't make an axe much simpler."
	icon = 'icons/obj/lavaland.dmi'
	icon_state = "hatchet_bronze"
	item_state = "hatchet_bronze"
	material_parts = /datum/prototype/material/bronze

/obj/item/material/knife/machete/hatchet/unathiknife
	name = "duelling knife"
	desc = "Though honor duels have fallen out of fashion in this new era, that doesn't stop some Unathi from carrying these wooden duelling blades as a status symbol. Or Vox from using these for their intended purpose in 'quill duels'."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "unathiknife"
	attack_verb = list("ripped", "torn", "cut")
	can_cleave = FALSE
	var/hits = 0

/obj/item/material/knife/machete/hatchet/durasteel
	material_parts = /datum/prototype/material/durasteel

/obj/item/material/knife/machete/hatchet/unathiknife/durasteel
	material_parts = /datum/prototype/material/durasteel

/obj/item/material/knife/machete/hatchet/unathiknife/legacy_mob_melee_hook(mob/target, mob/user, clickchain_flags, list/params, mult, target_zone, intent)
	if(hits > 0)
		return
	var/obj/item/I = user.get_inactive_held_item()
	if(istype(I, /obj/item/material/knife/machete/hatchet/unathiknife))
		hits ++
		I.lazy_melee_interaction_chain(target, user, CLICKCHAIN_REDIRECTED, params)
	..()

/obj/item/material/knife/machete/hatchet/unathiknife/afterattack(atom/target, mob/user, clickchain_flags, list/params)
	hits = initial(hits)
	..()

/obj/item/material/minihoe // -- Numbers
	name = "mini hoe"
	desc = "It's used for removing weeds and tilling soil."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "hoe"
	material_significance = MATERIAL_SIGNIFICANCE_WEAPON_LIGHT
	material_primary = "tip"
	w_class = WEIGHT_CLASS_SMALL
	attack_verb = list("slashed", "sliced", "cut", "clawed")

/obj/item/material/minihoe/plasteel
	material_parts = /datum/prototype/material/plasteel

/obj/item/material/minihoe/durasteel
	material_parts = /datum/prototype/material/durasteel

/obj/item/material/minihoe/bone
	name = "primitive mini hoe"
	icon = 'icons/obj/mining.dmi'
	icon_state = "cultivator_bone"
	material_parts = /datum/prototype/material/bone

/obj/item/material/snow/snowball
	name = "loose packed snowball"
	desc = "A fun snowball. Throw it at your friends!"
	icon = 'icons/obj/weapons.dmi'
	icon_state = "snowball"
	material_parts = /datum/prototype/material/snow
	material_significance = MATERIAL_SIGNIFICANCE_SHARD
	force_multiplier = 0
	w_class = WEIGHT_CLASS_SMALL
	attack_verb = list("mushed", "splatted", "splooshed", "splushed") // Words that totally exist.

/obj/item/material/snow/snowball/throw_impact(atom/hit_atom)
	if(!..()) // not caught in mid-air
		if(isliving(hit_atom))
			visible_message("<span class='notice'>[src] explodes into a shower of snow upon impact!</span>")
			qdel(src)

/obj/item/material/snow/snowball/attack_self(mob/user, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
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
	//icon_state = "considered_reinforced-snowball"
	force_multiplier = 0.25
	throw_force_multiplier = 4 // this compounds with force_multiplier
	material_significance = MATERIAL_SIGNIFICANCE_WEAPON_ULTRALIGHT

/obj/item/material/butterfly/saw //This Saw Cleaver is in here since I do not know where else to put it
	name = "Saw Cleaver"
	desc = "A weapon consisting of a long handle attached to heavy serrated blade. Using centrifrugal force, the blade can extends outward. This transformation allows it to slice in long, cleaving arcs. The smell of blood hangs in the air around it."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "cleaving_saw"
	item_icons = list(
			SLOT_ID_LEFT_HAND = 'icons/mob/items/64x64_lefthand.dmi',
			SLOT_ID_RIGHT_HAND = 'icons/mob/items/64x64_righthand.dmi',
			)
	item_state = "cleaving_saw"
	active = 0
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	attack_sound = 'sound/weapons/bladeslice.ogg'
	w_class = WEIGHT_CLASS_BULKY
	material_significance = MATERIAL_SIGNIFICANCE_WEAPON_HEAVY
	damage_mode = DAMAGE_MODE_EDGE | DAMAGE_MODE_SHARP

/obj/item/material/butterfly/saw/set_active(active)
	. = ..()
	if(active)
		icon_state = "sawcleaver_open"
		item_state = "cleaving_saw_open"
	else
		icon_state = initial(icon_state)
		item_state = initial(item_state)
	update_worn_icon()
