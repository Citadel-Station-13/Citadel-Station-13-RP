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
	w_class = WEIGHT_CLASS_BULKY
	attack_sound = "swing_hit"
	drop_sound = 'sound/items/drop/sword.ogg'
	pickup_sound = 'sound/items/pickup/sword.ogg'
	passive_parry = /datum/passive_parry/melee{
		parry_chance_melee = 15;
	}

	var/base_icon
	var/base_name
	var/unwielded_force_multiplier = 0.25

/obj/item/material/twohanded/Initialize(mapload, material_key)
	. = ..()
	AddComponent(/datum/component/wielding)
	update_icon()

/obj/item/material/twohanded/on_wield(mob/user, hands)
	. = ..()
	update_icon()

/obj/item/material/twohanded/on_unwield(mob/user, hands)
	. = ..()
	update_icon()

/obj/item/material/twohanded/melee_attack(datum/event_args/actor/clickchain/clickchain, clickchain_flags, datum/melee_attack/weapon/attack_style)
	if(!(item_flags & ITEM_MULTIHAND_WIELDED))
		clickchain.attack_melee_multiplier *= unwielded_force_multiplier
	return ..()

/obj/item/material/twohanded/update_icon()
	icon_state = "[base_icon][!!(item_flags & ITEM_MULTIHAND_WIELDED)]"
	. = ..()
	item_state = icon_state

/*
 * Fireaxe
 */
/obj/item/material/twohanded/fireaxe  // DEM AXES MAN, marker -Agouri
	icon_state = "fireaxe0"
	base_icon = "fireaxe"
	name = "fire axe"
	desc = "Truly, the weapon of a madman. Who would think to fight fire with an axe?"
	description_info = "A hefty two-handed cutting implement. Used for chopping through wood, glass, metal grating, wild animals, and even trees, shockingly enough. Good thing Nanotrasen stocks these for free."
	material_significance = MATERIAL_SIGNIFICANCE_WEAPON_HEAVY
	damage_mode = DAMAGE_MODE_SHARP | DAMAGE_MODE_EDGE
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = SLOT_BACK
	attack_verb = list("attacked", "chopped", "cleaved", "torn", "cut")
	material_color = FALSE
	can_cleave = TRUE
	drop_sound = 'sound/items/drop/axe.ogg'
	pickup_sound = 'sound/items/pickup/axe.ogg'
	heavy = TRUE

/obj/item/material/twohanded/fireaxe/on_wield(mob/user, hands)
	. = ..()
	pry = TRUE

/obj/item/material/twohanded/fireaxe/on_unwield(mob/user, hands)
	. = ..()
	pry = FALSE

/obj/item/material/twohanded/fireaxe/melee_attack(datum/event_args/actor/clickchain/clickchain, clickchain_flags, datum/melee_attack/weapon/attack_style)
	if(istype(clickchain.target, /obj/structure/window))
		clickchain.attack_melee_multiplier *= 2
	else if(istype(clickchain.target, /obj/effect/plant))
		clickchain.attack_melee_multiplier *= 2
	return ..()

/obj/item/material/twohanded/fireaxe/foam
	material_parts = /datum/prototype/material/toy_foam
	attack_verb = list("bonked","whacked")
	icon_state = "fireaxe_mask0"
	base_icon = "fireaxe_mask"
	desc = "This is a toy version of the mighty fire axe! Charge at your friends for maximum enjoyment while screaming at them."
	description_info = "This is a toy version of the mighty fire axe! Charge at your friends for maximum enjoyment while screaming at them."

/obj/item/material/twohanded/fireaxe/bone
	desc = "A primitive version of a hefty fire axe, made from bone. Whoever made this didn't make it to save lives."
	material_parts = /datum/prototype/material/bone
	icon_state = "bone_axe0"
	base_icon = "bone_axe"
	material_color = FALSE

/obj/item/material/twohanded/fireaxe/bronze
	name = "Bronze Battleaxe"
	desc = "A large twohanded battleaxe made of bronze. Its double head marks it a tool for combat alone."
	material_parts = /datum/prototype/material/bronze
	icon = 'icons/obj/lavaland.dmi'
	icon_state = "bronze_axe0"
	base_icon = "bronze_axe"
	material_color = FALSE

/obj/item/material/twohanded/fireaxe/iron
	name = "Woodcutter's Axe"
	desc = "A simple iron axe for cutting down trees. Though not made of the sturdiest metal it will get the job done."
	material_parts = /datum/prototype/material/iron
	icon_state = "fireaxe_mask0"
	base_icon = "fireaxe_mask"
	material_color = TRUE

/obj/item/material/twohanded/fireaxe/plasteel
	material_parts = /datum/prototype/material/plasteel

/obj/item/material/twohanded/fireaxe/durasteel
	material_parts = /datum/prototype/material/durasteel

/obj/item/material/twohanded/fireaxe/scythe/plasteel
	material_parts = /datum/prototype/material/plasteel

/obj/item/material/twohanded/fireaxe/scythe/durasteel
	material_parts = /datum/prototype/material/durasteel

/obj/item/material/twohanded/fireaxe/scythe
	icon_state = "scythe0"
	base_icon = "scythe"
	name = "scythe"
	desc = "A sharp and curved blade on a long fibremetal handle. An ancient design from Terra, it's useful for cutting large swaths of grain, but the shape alone implies much more grim work."
	origin_tech = list(TECH_MATERIAL = 2, TECH_COMBAT = 2)
	attack_verb = list("chopped", "sliced", "cut", "reaped")

/obj/item/material/twohanded/fireaxe/scythe/Initialize(mapload, material_key)
	. = ..()
	AddComponent(/datum/component/jousting)

//spears, bay edition
/obj/item/material/twohanded/spear
	icon_state = "spearglass0"
	base_icon = "spearglass"
	name = "spear"
	desc = "A haphazardly-constructed yet still deadly weapon of ancient design."
	description_info = "This weapon can strike from two tiles away, and over certain objects such as tables, or other people."
	damage_force = 10
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = SLOT_BACK
	suit_storage_class = SUIT_STORAGE_CLASS_HARDWEAR
	material_significance = MATERIAL_SIGNIFICANCE_WEAPON_HEAVY
	throw_force_multiplier = 1.5
	throw_speed = 5
	attack_sound = 'sound/weapons/bladeslice.ogg'
	mob_throw_hit_sound =  'sound/weapons/pierce.ogg'
	attack_verb = list("attacked", "poked", "jabbed", "torn", "gored")
	material_parts = /datum/prototype/material/glass
	material_color = 0
	reach = 2 // Spears are long.
	weight = ITEM_WEIGHT_MELEE_SPEAR
	var/obj/item/grenade/simple/explosive = null
	var/war_cry = "AAAAARGH!!!"

/obj/item/material/twohanded/spear/Initialize(mapload, material_key)
	. = ..()
	AddComponent(/datum/component/jousting)

/obj/item/material/twohanded/spear/examine(mob/user, dist)
	. = ..()
	if(explosive)
		. += "<span class='notice'>Alt-click to set your war cry.</span>"
		. += "<span class='notice'>Right-click in combat mode to activate the attached explosive.</span>"

/obj/item/material/twohanded/spear/afterattack(atom/target, mob/user, clickchain_flags, list/params)
	. = ..()
	if(explosive && (item_flags & ITEM_MULTIHAND_WIELDED)) //Citadel edit removes qdel and explosive.forcemove(AM)
		user.say("[war_cry]")
		explosive.detonate()

/obj/item/material/twohanded/spear/throw_impact(atom/hit_atom)
	. = ..()
	if(explosive)
		explosive.detonate()
		qdel(src)

/obj/item/material/twohanded/spear/AltClick(mob/user)
	. = ..()
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
	desc = "A simple, yet effective, weapon, built from bone."
	material_parts = /datum/prototype/material/bone
	icon_state = "bone_spear0"
	base_icon = "bone_spear"
	material_color = 0

/obj/item/material/twohanded/spear/bone/Initialize(mapload, material_key)
	..(mapload,"bone")

/obj/item/material/twohanded/spear/plasteel
	material_parts = /datum/prototype/material/plasteel

/obj/item/material/twohanded/spear/durasteel
	material_parts = /datum/prototype/material/durasteel

/obj/item/material/twohanded/spear/bronze
	name = "spear"
	desc = "A spear of bone shaft and bronze head. Simplicity never goes out of style."
	material_parts = /datum/prototype/material/bronze
	icon = 'icons/obj/lavaland.dmi'
	icon_state = "bronze_spear0"
	base_icon = "bronze_spear"
	material_color = 0


/obj/item/material/twohanded/spear/bronze/Initialize(mapload, material_key)
	..(mapload,"bronze")

//Sledgehammers. Slightly less force than fire axes, but breaks bones easier.

/obj/item/material/twohanded/sledgehammer  // a SLEGDGEHAMMER
	icon_state = "sledgehammer0"
	base_icon = "sledgehammer"
	name = "sledgehammer"
	desc = "A long, heavy hammer meant to be used with both hands. For breaking rocks or breaking bones, accept no substitutes."
	description_info = "This weapon can cleave, striking nearby lesser, hostile enemies close to the primary target.  It must be held in both hands to do this."
	material_significance = MATERIAL_SIGNIFICANCE_WEAPON_SUPERHEAVY
	attack_sound = 'sound/weapons/heavysmash.ogg'
	w_class = WEIGHT_CLASS_HUGE
	encumbrance = ITEM_ENCUMBRANCE_MELEE_SLEDGEHAMMER
	attack_verb = list("attacked", "smashed", "crushed", "wacked", "pounded")
	heavy = TRUE
	damage_tier = 4
	can_cleave = TRUE
