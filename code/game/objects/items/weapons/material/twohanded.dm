/* Two-handed Weapons
 * Contains:
 * 		Twohanded
 *		Fireaxe
 *		Double-Bladed Energy Swords
 */

/*##################################################################
##################### TWO HANDED WEAPONS BE HERE~ -Agouri :3 ########
####################################################################*/

//Rewrote TwoHanded weapons stuff and put it all here. Just copypasta fireaxe to make new ones ~Carn
//This rewrite means we don't have two variables for EVERY item which are used only by a few weapons.
//It also tidies stuff up elsewhere.

/*
 * Twohanded
 */
/obj/item/material/twohanded
	w_class = ITEMSIZE_LARGE
	var/wielded = 0
	var/force_wielded = 0
	var/force_unwielded
	var/wieldsound = null
	var/unwieldsound = null
	var/base_icon
	var/base_name
	var/unwielded_force_divisor = 0.25
	hitsound = "swing_hit"
	drop_sound = 'sound/items/drop/sword.ogg'
	pickup_sound = 'sound/items/pickup/sword.ogg'

/obj/item/material/twohanded/update_held_icon()
	var/mob/living/M = loc
	if(istype(M) && M.can_wield_item(src) && is_held_twohanded(M))
		wielded = 1
		force = force_wielded
		name = "[base_name] (wielded)"
		update_icon()
	else
		wielded = 0
		force = force_unwielded
		name = "[base_name]"
	update_icon()
	..()

/obj/item/material/twohanded/update_force()
	base_name = name
	if(material.name == "supermatter")
		damtype = BURN //its hot
		force_wielded = 150 //double the force of a durasteel claymore.
		force_unwielded = 150 //double the force of a durasteel claymore.
		armor_penetration = 100 //regardless of armor
		throw_force = 150
		force = force_unwielded
		return
	if(sharp || edge)
		force_wielded = material.get_edge_damage()
	else
		force_wielded = material.get_blunt_damage()
	force_wielded = round(force_wielded*force_divisor)
	force_unwielded = round(force_wielded*unwielded_force_divisor)
	force = force_unwielded
	throw_force = round(force*thrown_force_divisor)
	//to_chat(world, "[src] has unwielded force [force_unwielded], wielded force [force_wielded] and throw_force [throw_force] when made from default material [material.name]")

/obj/item/material/twohanded/Initialize(mapload, material_key)
	. = ..()
	update_icon()

//Allow a small chance of parrying melee attacks when wielded - maybe generalize this to other weapons someday
/obj/item/material/twohanded/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if(wielded && default_parry_check(user, attacker, damage_source) && prob(15))
		user.visible_message("<span class='danger'>\The [user] parries [attack_text] with \the [src]!</span>")
		playsound(user.loc, 'sound/weapons/punchmiss.ogg', 50, 1)
		return 1
	return 0

/obj/item/material/twohanded/update_icon()
	icon_state = "[base_icon][wielded]"
	item_state = icon_state

/obj/item/material/twohanded/dropped(mob/user, flags, atom/newLoc)
	..()
	if(wielded)
		spawn(0)
			update_held_icon()

/*
 * Fireaxe
 */
/obj/item/material/twohanded/fireaxe  // DEM AXES MAN, marker -Agouri
	icon_state = "fireaxe0"
	base_icon = "fireaxe"
	name = "fire axe"
	desc = "Truly, the weapon of a madman. Who would think to fight fire with an axe?"
	description_info = "This weapon can cleave, striking nearby lesser, hostile enemies close to the primary target.  It must be held in both hands to do this."
	unwielded_force_divisor = 0.25
	force_divisor = 0.5 // 12/30 with hardness 60 (steel) and 0.25 unwielded divisor
	dulled_divisor = 0.6	//Still metal on a stick
	sharp = 1
	edge = 1
	w_class = ITEMSIZE_LARGE
	slot_flags = SLOT_BACK
	force_wielded = 30
	attack_verb = list("attacked", "chopped", "cleaved", "torn", "cut")
	applies_material_colour = 0
	can_cleave = TRUE
	drop_sound = 'sound/items/drop/axe.ogg'
	pickup_sound = 'sound/items/pickup/axe.ogg'
	heavy = TRUE

/obj/item/material/twohanded/fireaxe/update_held_icon()
	var/mob/living/M = loc
	if(istype(M) && M.can_wield_item(src) && M.is_holding(src) && !M.hands_full())
		wielded = 1
		pry = 1
		force = force_wielded
		name = "[base_name] (wielded)"
		update_icon()
	else
		wielded = 0
		pry = 0
		force = force_unwielded
		name = "[base_name]"
	update_icon()
	..()

/obj/item/material/twohanded/fireaxe/afterattack(atom/A as mob|obj|turf|area, mob/user as mob, proximity)
	if(!proximity) return
	..()
	if(A && wielded)
		if(istype(A,/obj/structure/window))
			var/obj/structure/window/W = A
			W.shatter()
		else if(istype(A,/obj/structure/grille))
			qdel(A)
		else if(istype(A,/obj/effect/plant))
			var/obj/effect/plant/P = A
			P.die_off()

/obj/item/material/twohanded/fireaxe/foam
	attack_verb = list("bonked","whacked")
	force_wielded = 0
	force_divisor = 0
	force = 0
	applies_material_colour = 1
	icon_state = "fireaxe_mask0"
	base_icon = "fireaxe_mask"
	unbreakable = 1
	sharp = 0
	edge = 0
	can_cleave = FALSE
	desc = "This is a toy version of the mighty fire axe! Charge at your friends for maximum enjoyment while screaming at them."
	description_info = "This is a toy version of the mighty fire axe! Charge at your friends for maximum enjoyment while screaming at them."

/obj/item/material/twohanded/fireaxe/foam/Initialize(mapload, material_key)
	return ..(mapload,"foam")

/obj/item/material/twohanded/fireaxe/foam/afterattack()
	return

/obj/item/material/twohanded/fireaxe/bone
	desc = "Truly, the weapon of a madman. Who would think to fight fire with an axe?"
	default_material = "bone"
	icon_state = "fireaxe_mask0"
	base_icon = "fireaxe_mask"
	applies_material_colour = 1

/obj/item/material/twohanded/fireaxe/bone/Initialize(mapload, material_key)
	return ..(mapload,"bone")

/obj/item/material/twohanded/fireaxe/plasteel
	default_material = "plasteel"

/obj/item/material/twohanded/fireaxe/durasteel
	default_material = "durasteel"

/obj/item/material/twohanded/fireaxe/scythe/plasteel
	default_material = "plasteel"

/obj/item/material/twohanded/fireaxe/scythe/durasteel
	default_material = "durasteel"

/obj/item/material/twohanded/fireaxe/scythe
	icon_state = "scythe0"
	base_icon = "scythe"
	name = "scythe"
	desc = "A sharp and curved blade on a long fibremetal handle, this tool makes it easy to reap what you sow."
	force_divisor = 0.65
	origin_tech = list(TECH_MATERIAL = 2, TECH_COMBAT = 2)
	attack_verb = list("chopped", "sliced", "cut", "reaped")

//spears, bay edition
/obj/item/material/twohanded/spear
	icon_state = "spearglass0"
	base_icon = "spearglass"
	name = "spear"
	desc = "A haphazardly-constructed yet still deadly weapon of ancient design."
	description_info = "This weapon can strike from two tiles away, and over certain objects such as tables, or other people."
	force = 10
	w_class = ITEMSIZE_LARGE
	slot_flags = SLOT_BACK
	force_divisor = 0.35 			// 10 when wielded with hardness 30 (glass)
	unwielded_force_divisor = 0.1
	thrown_force_divisor = 1.5		// 22.5 when thrown with weight 15 (glass)
	throw_speed = 5
	edge = 0
	sharp = 1
	hitsound = 'sound/weapons/bladeslice.ogg'
	mob_throw_hit_sound =  'sound/weapons/pierce.ogg'
	attack_verb = list("attacked", "poked", "jabbed", "torn", "gored")
	default_material = "glass"
	applies_material_colour = 0
	fragile = 1	//It's a haphazard thing of glass, wire, and steel
	reach = 2 // Spears are long.
	attackspeed = 20
	slowdown = 1.05
	var/obj/item/grenade/explosive = null
	var/war_cry = "AAAAARGH!!!"

/obj/item/material/twohanded/spear/examine(mob/user)
	. = ..()
	if(explosive)
		. += "<span class='notice'>Alt-click to set your war cry.</span>"
		. += "<span class='notice'>Right-click in combat mode to activate the attached explosive.</span>"

/obj/item/material/twohanded/spear/afterattack(atom/movable/AM, mob/user, proximity)
	. = ..()
	if(explosive && wielded) //Citadel edit removes qdel and explosive.forcemove(AM)
		user.say("[war_cry]")
		explosive.detonate()

/obj/item/material/twohanded/spear/throw_impact(atom/hit_atom)
	. = ..()
	if(explosive)
		explosive.detonate()
		qdel(src)

/obj/item/material/twohanded/spear/AltClick(mob/user)
	. = ..()
	if(usr)
		..()
		if(!explosive)
			return
		if(istype(user) && loc == user)
			var/input = stripped_input(user,"What do you want your war cry to be? You will shout it when you hit someone in melee.", ,"", 50)
			if(input)
				src.war_cry = input
		return TRUE

/obj/item/material/twohanded/spear/CheckParts(list/parts_list)
	var/obj/item/material/twohanded/spear/S = locate() in parts_list
	if(S)
		if(S.explosive)
			S.explosive.forceMove(get_turf(src))
			S.explosive = null
		parts_list -= S
		qdel(S)
	..()
	var/obj/item/grenade/G = locate() in contents
	if(G)
		explosive = G
		name = "explosive lance"
		desc = "A makeshift spear with \a [G] attached to it."
	update_icon()

/obj/item/material/twohanded/spear/bone
	name = "spear"
	desc = "A primitive yet deadly weapon of ancient design."
	default_material = "bone"
	icon_state = "spear_mask0"
	base_icon = "spear_mask"
	applies_material_colour = 1

/obj/item/material/twohanded/spear/bone/Initialize(mapload, material_key)
	..(mapload,"bone")

/obj/item/material/twohanded/spear/plasteel
	default_material = "plasteel"

/obj/item/material/twohanded/spear/durasteel
	default_material = "durasteel"

//Sledgehammers. Slightly less force than fire axes, but breaks bones easier.

/obj/item/material/twohanded/sledgehammer  // a SLEGDGEHAMMER
	icon_state = "sledgehammer0"
	base_icon = "sledgehammer"
	name = "sledgehammer"
	desc = "A long, heavy hammer meant to be used with both hands. Typically used for breaking rocks and driving posts, it can also be used for breaking bones or driving points home."
	description_info = "This weapon can cleave, striking nearby lesser, hostile enemies close to the primary target.  It must be held in both hands to do this."
	unwielded_force_divisor = 0.25
	force_divisor = 0.6 // 9/36 with hardness 60 (steel) and 0.25 unwielded divisor
	hitsound = 'sound/weapons/heavysmash.ogg'
	w_class = ITEMSIZE_HUGE
	slowdown = 1.5
	dulled_divisor = 0.95	//Still metal on a stick
	sharp = 0
	edge = 1
	force_wielded = 23 //A fair bit less than the fireaxe.
	attack_verb = list("attacked", "smashed", "crushed", "wacked", "pounded")
	armor_penetration = 50
	heavy = TRUE

/obj/item/material/twohanded/sledgehammer/update_held_icon()
	var/mob/living/M = loc
	if(istype(M) && M.can_wield_item(src) && M.is_holding(src) && !M.hands_full())
		wielded = 1
		pry = 1
		force = force_wielded
		name = "[base_name] (wielded)"
		update_icon()
	else
		wielded = 0
		pry = 0
		force = force_unwielded
		name = "[base_name]"
	update_icon()
	..()

/obj/item/material/twohanded/sledgehammer/afterattack(atom/A as mob|obj|turf|area, mob/user as mob, proximity)
	if(!proximity) return
	..()
	if(A && wielded)
		if(istype(A,/obj/structure/window))
			var/obj/structure/window/W = A
			W.shatter()
		else if(istype(A,/obj/structure/grille))
			qdel(A)
		else if(istype(A,/obj/effect/plant))
			var/obj/effect/plant/P = A
			P.die_off()

// This cannot go into afterattack since some mobs delete themselves upon dying.
/obj/item/material/twohanded/sledgehammer/pre_attack(atom/target, mob/user, clickchain_flags, list/params)
	if(isliving(target))
		cleave(user, target)
	return ..()

/obj/item/material/twohanded/sledgehammer/mjollnir
	icon_state = "mjollnir0"
	base_icon = "mjollnir0"
	name = "Mjollnir"
	desc = "A long, heavy hammer. This weapons crackles with barely contained energy."
	force_divisor = 2
	hitsound = 'sound/effects/lightningbolt.ogg'
	force = 50
	throw_force = 15
	force_wielded = 75
	slowdown = 0

/obj/item/material/twohanded/sledgehammer/mjollnir/afterattack(mob/living/G, mob/user)
	..()

	if(wielded)
		if(prob(10))
			G.electrocute_act(500, src, def_zone = BP_TORSO)
			return
		if(prob(10))
			G.dust()
			return
		else
			G.stun_effect_act(10 , 50, BP_TORSO, src)
			G.take_organ_damage(10)
			G.Unconscious(20)
			playsound(src.loc, "sparks", 50, 1)
			return

/obj/item/material/twohanded/sledgehammer/mjollnir/update_icon()  //Currently only here to fuck with the on-mob icons.
	icon_state = "mjollnir[wielded]"
	return
