/* Weapons
 * Contains:
 *		Sword
 *		Classic Baton
 *		Telescopic Baton
 */

/*
 * Classic Baton
 */
/obj/item/melee/classic_baton
	name = "police baton"
	desc = "A wooden truncheon for beating criminal scum."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "baton"
	item_state = "classic_baton"
	slot_flags = SLOT_BELT
	force = 10
	drop_sound = 'sound/items/drop/crowbar.ogg'
	pickup_sound = 'sound/items/pickup/crowbar.ogg'

/obj/item/melee/classic_baton/attack(mob/M as mob, mob/living/user as mob)
	if ((MUTATION_CLUMSY in user.mutations) && prob(50))
		to_chat(user, "<span class='warning'>You club yourself over the head.</span>")
		user.Weaken(3 * force)
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			H.apply_damage(2*force, BRUTE, BP_HEAD)
		else
			user.take_organ_damage(2*force)
		return
	return ..()

/obj/item/melee/classic_baton/tonfa
	name = "tonfa"
	desc = "A versatile wooden baton from Old Earth, designed for both attack and defense."
	icon_state = "tonfa"
	item_state = "tonfa"
	flags = NOBLOODY
	defend_chance = 15

//Telescopic baton
/obj/item/melee/telebaton
	name = "telescopic baton"
	desc = "A compact yet rebalanced personal defense weapon. Can be concealed when folded."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "telebaton"
	slot_flags = SLOT_BELT
	w_class = ITEMSIZE_SMALL
	force = 3
	var/on = 0
	var/off_force = 3
	var/on_force = 15
	var/on_pain_force = 30
	drop_sound = 'sound/items/drop/crowbar.ogg'
	pickup_sound = 'sound/items/pickup/crowbar.ogg'

/obj/item/melee/telebaton/attack_self(mob/user as mob)
	if(src.icon_state == initial(icon_state))
		on = 1
		user.visible_message("<span class='warning'>With a flick of their wrist, [user] extends their telescopic baton.</span>",\
		"<span class='warning'>You extend the baton.</span>",\
		"You hear an ominous click.")
		src.icon_state = "[icon_state]_1"
		src.item_state = "[item_state]_1"
		w_class = ITEMSIZE_NORMAL
		force = on_force //quite robust
		attack_verb = list("struck", "beat")
	else
		on = 0
		user.visible_message("<span class='notice'>\The [user] collapses their telescopic baton.</span>",\
		"<span class='notice'>You collapse the baton.</span>",\
		"You hear a click.")
		src.icon_state = initial(icon_state)
		src.item_state = initial(item_state)
		w_class = ITEMSIZE_SMALL
		force = off_force //not so robust now
		attack_verb = list("poked", "jabbed")
	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		H.update_inv_l_hand()
		H.update_inv_r_hand()
	playsound(src.loc, 'sound/weapons/empty.ogg', 50, 1)
	add_fingerprint(user)
	if(blood_overlay && blood_DNA && (blood_DNA.len >= 1)) //updates blood overlay, if any
		overlays.Cut()//this might delete other item overlays as well but eeeeeeeh
		var/icon/I = new /icon(src.icon, src.icon_state)
		I.Blend(new /icon('icons/effects/blood.dmi', rgb(255,255,255)),ICON_ADD)
		I.Blend(new /icon('icons/effects/blood.dmi', "itemblood"),ICON_MULTIPLY)
		blood_overlay = I
		overlays += blood_overlay
	return

/obj/item/melee/telebaton/attack(mob/target as mob, mob/living/user as mob)
	if(on)
		if ((MUTATION_CLUMSY in user.mutations) && prob(50))
			to_chat(user, "<span class='warning'>You club yourself over the head.</span>")
			user.Weaken(3 * force)
			if(ishuman(user))
				var/mob/living/carbon/human/H = user
				H.apply_damage(2*force, BRUTE, BP_HEAD)
			else
				user.take_organ_damage(2*force)
			return
		var/old_damtype = damtype
		var/old_attack_verb = attack_verb
		var/old_force = force
		if(user.a_intent != INTENT_HARM)
			damtype = HALLOSS
			attack_verb = list("suppressed")
			force = on_pain_force
		. = ..()
		damtype = old_damtype
		attack_verb = old_attack_verb
		force = old_force
	else
		return ..()

/obj/item/melee/telebaton/newspaper
	name = "The Daily Whiplash"
	desc = "A newspaper wrapped around a telescopic baton in such a way that it looks like you're beating people with a rolled up newspaper."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "newspaper"
	item_state = "newspaper"
	item_icons = list(
			SLOT_ID_LEFT_HAND = 'icons/mob/items/lefthand_melee.dmi',
			SLOT_ID_RIGHT_HAND = 'icons/mob/items/righthand_melee.dmi',
			)

/obj/item/melee/disruptor
	name = "disruptor blade"
	desc = "A long, machete-like blade, designed to mount onto the arm or some rough equivalent. Electricity courses through it."
	description_info = "This blade deals bonus damage against animals (space bears, carp) and aberrations (xenomorphs)."
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "armblade"
	item_icons = list(
			SLOT_ID_LEFT_HAND = 'icons/mob/items/lefthand_material.dmi',
			SLOT_ID_RIGHT_HAND = 'icons/mob/items/righthand_material.dmi',
			)
	item_state = "armblade"
	force = 15 // same force as a drill
	defend_chance = 20 // did you know melee weapons have a default 5% chance to block frontal melee?
	sharp = TRUE
	edge = TRUE
	var/SA_bonus_damage = 35 // 50 total against animals and aberrations.
	var/SA_vulnerability = MOB_CLASS_ANIMAL | MOB_CLASS_ABERRATION

/obj/item/melee/disruptor/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(isliving(target))
		var/mob/living/tm = target // targeted mob
		if(SA_vulnerability & tm.mob_class)
			tm.apply_damage(SA_bonus_damage) // fuck em

/obj/item/melee/disruptor/borg
	desc = "A long, machete-like blade, designed to mount onto a facility-bound synthetic's chassis."

/obj/item/melee/spike
	name = "jagged spike"
	desc = "A polished spike with miniscule edges all over its surface. You won't be holding onto it for long if you stab someone with it."
	embed_chance = 100 // these should probably come in a bandolier or have some sort of fabricator, tbf
	force = 5 // HAVING A STICK JAMMED INTO YOU IS LIKELY BAD FOR YOUR HEALTH // well to be fair most of the damage comes from the embed not the stab
	w_class = WEIGHT_CLASS_SMALL
	matter = list(MAT_STEEL = 2500)
	sharp = TRUE
	edge = TRUE
	icon_state = "embed_spike"
	item_icons = list(
			SLOT_ID_LEFT_HAND = 'icons/mob/items/lefthand_material.dmi',
			SLOT_ID_RIGHT_HAND = 'icons/mob/items/righthand_material.dmi',
			)
	item_state = "switchblade_open"

//DONATOR ITEM
//okay I know making a stool a weapon is real cringe but the chair material code is fucking bad and I'm tired of fucking with it

/obj/item/melee/stool/faiza
	name = "Faiza's Stool"
	desc = "Apply munchkin cat."
	icon = 'icons/obj/furniture.dmi'
	icon_state = "cn_stool_c"
	force = 10
	throw_force = 10
	w_class = ITEMSIZE_SMALL
	var/on =  0
	slot_flags = null
	force = 0
	hitsound = "sound/items/bikehorn.ogg"

/obj/item/melee/stool/faiza/attack_self(mob/user as mob)

	if(on == 0)
		user.visible_message("<span class='notice'>In a quick motion, [user] extends their collapsible stool.</span>")
		icon_state = "cn_stool"
		w_class = ITEMSIZE_HUGE
		on = 1
	else
		user.visible_message("<span class='notice'>\ [user] collapses their stool.</span>")
		icon_state = "cn_stool_c"
		w_class = ITEMSIZE_SMALL
		on = 0

	playsound(src.loc, 'sound/weapons/empty.ogg', 50, 1)

/obj/item/melee/bokken // parrying stick
	name = "bokken"
	desc = "A training sword made of wood and shaped like a katana."
	icon_state = "bokken"
	slot_flags = SLOT_BELT | SLOT_BACK
	damtype = HALLOSS
	force = 5
	throw_force = 5
	attack_verb = list("whacked", "smacked", "struck")
	hitsound = 'sound/weapons/genhit3.ogg'
	var/reinforced = FALSE
	var/burnt = FALSE
	var/burned_in

/obj/item/melee/bokken/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/pen))
		var/new_name = stripped_input(user, "What do you wish to name [src]?", "New Name", "bokken", 30)
		if(new_name)
			name = new_name
	if(I.is_welder())
		var/new_burn = stripped_input(user, "What do you wish to burn into [src]?", "Burnt Inscription","", 140)
		if(new_burn)
			burned_in = new_burn
			if(!burnt)
				icon_state += "_burnt"
				burnt = TRUE
			update_icon()
	if(istype(I, /obj/item/stack/rods))
		var/obj/item/stack/rods/R = I
		if(!reinforced)
			if(R.use(1))
				src.force = (force + 5)
				reinforced = TRUE
				to_chat(user, "<span class='notice'>You slide a metal rod into [src]\'s hilt. It feels a little heftier in your hands.")
		else
			to_chat(user, "<span class='notice'>[src] already has a weight slid into the hilt.")

/obj/item/melee/bokken/examine(mob/user)
	. = ..()
	if(reinforced)
		. += "There's a metal rod shoved into the base."
	if(burnt)
		. += "Burned into the \"blade\" is [burned_in]."

/obj/item/melee/bokken/hardwood
	name = "hardwood bokken"
	desc = "A blunt katana made from hardwood, a dense organic wood."
	icon_state = "bokken_hard"
	force = 10

/obj/item/melee/bokken/waki
	name = "wakizashi bokken"
	desc = "A space-Japanese training sword made of wood and shaped like a wakizashi."
	icon_state = "wakibokken"
	slot_flags = SLOT_BELT
	force = 5

/obj/item/melee/bokken/waki/hardwood
	name = "wakizashi hardwood bokken"
	desc = "A blunt wakizashi made from hardwood, a dense organic wood."
	icon_state = "wakibokken_hard"
	force = 10

/obj/item/bokken_hilt
	name = "bokken hilt"
	desc = "A wooden hilt wrapped in grip tape."
	icon_state = "bokken_hilt"

/obj/item/bokken_blade
	name = "bokken blade"
	desc = "A wooden katana blade, used for training on old Terra."
	icon_state = "bokken_blade"

/obj/item/wakibokken_blade
	name = "wakibokken blade"
	desc = "A wooden wakizashi blade, used for training on old Terra."
	icon_state = "wakibokken_blade"

/obj/item/bokken_blade/hardwood
	name = "hardwood bokken blade"
	desc = "A sturdy wooden katana blade, used for training on old Terra."
	icon_state = "bokken_blade_h"

/obj/item/wakibokken_blade/hardwood
	name = "hardwood wakibokken blade"
	desc = "A sturdy wooden wakizashi blade, used for training on old Terrae."
	icon_state = "wakibokken_blade_h"

/obj/item/bo_staff
	name = "stave"
	desc = "A thick rod of hardened wood, useful as a walking stick, as much as a defensive tool."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "wakibokken_blade_h"
	force = 15
	slot_flags = SLOT_BACK
	sharp = 1
	hitsound = "swing_hit"
	attack_verb = list("smashed", "slammed", "whacked", "thwacked")
	icon_state = "bostaff0"
	item_state = "bostaff0"
	var/defend_chance = 40
	var/projectile_parry_chance = 0

/obj/item/bo_staff/proc/jedi_spin(mob/living/user)
	for(var/i in list(NORTH,SOUTH,EAST,WEST,EAST,SOUTH,NORTH,SOUTH,EAST,WEST,EAST,SOUTH))
		user.setDir(i)
		if(i == WEST)
			user.emote("flip")
		sleep(1)

/obj/item/bo_staff/attack(mob/target, mob/living/user)
	add_fingerprint(user)
	if(!ishuman(target))
		return
	if(user.a_intent != INTENT_DISARM)
		return
	else
		var/mob/living/carbon/human/H = target
		var/list/fluffmessages = list("[user] clubs [H] with [src]!", \
									  "[user] smacks [H] with the butt of [src]!", \
									  "[user] broadsides [H] with [src]!", \
									  "[user] smashes [H]'s head with [src]!", \
									  "[user] beats [H] with front of [src]!", \
									  "[user] twirls and slams [H] with [src]!")
		H.visible_message("<span class='warning'>[pick(fluffmessages)]</span>", \
							   "<span class='userdanger'>[pick(fluffmessages)]</span>")
		playsound(get_turf(user), 'sound/effects/woodhit.ogg', 75, 1, -1)
		if(prob(25))
			(INVOKE_ASYNC(src, .proc/jedi_spin, user))
			return ..()

//Kanabo
/obj/item/melee/kanabo // parrying stick
	name = "kanabo"
	desc = "A heavy wooden club reinforced with metal studs. Ancient Terran Oni were often depicted carrying this weapon."
	icon_state = "kanabo"
	slot_flags = SLOT_BACK
	damtype = BRUTE
	force = 15
	throw_force = 5
	attack_verb = list("battered", "hammered", "struck")
	hitsound = 'sound/weapons/genhit3.ogg'

/obj/item/melee/kanabo/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/pen))
		var/new_name = stripped_input(user, "What do you wish to name [src]?", "New Name", "bokken", 30)
		if(new_name)
			name = new_name

/obj/item/kanabo_shaft
	name = "kanabo shaft"
	desc = "A hefty wooden club, not dissimilar to an oversized baseball bat."
	icon_state = "kanabo_shaft"

/obj/item/kanabo_studs
	name = "kanabo studs"
	desc = "A handful of octahedral studs. Fashioned out of steel, these studs are designed to be driven into solid wood."
	icon_state = "kanabo_studs"
