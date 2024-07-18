/datum/passive_parry/melee/energy
	parry_frame = /datum/parry_frame/passive_block/energy

/datum/parry_frame/passive_block/energy
	parry_sfx = 'sound/weapons/blade1.ogg'

/obj/item/melee/transforming/energy
	icon = 'icons/obj/weapons.dmi'
	sharp = 0
	edge = 0
	armor_penetration = 50
	atom_flags = NOCONDUCT | NOBLOODY
	var/lrange = 2
	var/lpower = 2
	var/lcolor = "#0099FF"
	var/colorable = FALSE
	var/rainbow = FALSE
	// If it uses energy.
	var/use_cell = FALSE
	var/hitcost = 120
	var/obj/item/cell/bcell = null
	var/cell_type = /obj/item/cell/device
	item_icons = list(
			SLOT_ID_LEFT_HAND = 'icons/mob/items/lefthand_melee.dmi',
			SLOT_ID_RIGHT_HAND = 'icons/mob/items/righthand_melee.dmi',
			)

	passive_parry = /datum/passive_parry/melee/energy

/obj/item/melee/transforming/energy/proc/activate(mob/living/user)
	if(active)
		return
	active = 1
	if(rainbow)
		item_state = "[icon_state]_blade_rainbow"
	else
		item_state = "[icon_state]_blade"
	embed_chance = active_embed_chance
	damage_force = active_force
	throw_force = active_throwforce
	sharp = 1
	edge = 1
	set_weight_class(active_w_class)
	playsound(user, 'sound/weapons/saberon.ogg', 50, 1)
	update_icon()
	set_light(lrange, lpower, lcolor)
	to_chat(user, "<span class='notice'>Alt-click to recolor it.</span>")

/obj/item/melee/transforming/energy/proc/deactivate(mob/living/user)
	if(!active)
		return
	playsound(user, 'sound/weapons/saberoff.ogg', 50, 1)
	item_state = "[icon_state]"
	active = 0
	embed_chance = initial(embed_chance)
	damage_force = initial(damage_force)
	throw_force = initial(throw_force)
	sharp = initial(sharp)
	edge = initial(edge)
	set_weight_class(initial(w_class))
	update_icon()
	set_light(0,0)

#warn parse all

/obj/item/melee/transforming/energy/proc/use_charge(var/cost)
	if(active)
		if(bcell)
			if(bcell.checked_use(cost))
				return 1
			else
				return 0
	return null

/obj/item/melee/transforming/energy/examine(mob/user, dist)
	. = ..()
	if(use_cell)
		if(bcell)
			. += "<span class='notice'>The blade is [round(bcell.percent())]% charged.</span>"
		if(!bcell)
			. += "<span class='warning'>The blade does not have a power source installed.</span>"

/obj/item/melee/transforming/energy/attack_self(mob/user)
	. = ..()
	if(.)
		return
	if(use_cell)
		if((!bcell || bcell.charge < hitcost) && !active)
			to_chat(user, "<span class='notice'>\The [src] does not seem to have power.</span>")
			return

	var/datum/gender/TU = GLOB.gender_datums[user.get_visible_gender()]
	if (active)
		if ((MUTATION_CLUMSY in user.mutations) && prob(50))
			user.visible_message("<span class='danger'>\The [user] accidentally cuts [TU.himself] with \the [src].</span>",\
			"<span class='danger'>You accidentally cut yourself with \the [src].</span>")
			var/mob/living/carbon/human/H = ishuman(user)? user : null
			H.take_random_targeted_damage(brute = 5, burn = 5)
		deactivate(user)
	else
		activate(user)

	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		H.update_inv_l_hand()
		H.update_inv_r_hand()

	add_fingerprint(user)
	return

/obj/item/melee/transforming/energy/suicide_act(mob/user)
	var/datum/gender/TU = GLOB.gender_datums[user.get_visible_gender()]
	if(active)
		user.visible_message(pick("<span class='danger'>\The [user] is slitting [TU.his] stomach open with \the [src]! It looks like [TU.he] [TU.is] trying to commit seppuku.</span>",\
			"<span class='danger'>\The [user] is falling on \the [src]! It looks like [TU.he] [TU.is] trying to commit suicide.</span>"))
		return (BRUTELOSS|FIRELOSS)

/obj/item/melee/transforming/energy/attack_mob(mob/target, mob/user, clickchain_flags, list/params, mult, target_zone, intent)
	. = ..()
	if(active && use_cell)
		if(!use_charge(hitcost))
			deactivate(user)
			visible_message("<span class='notice'>\The [src]'s blade flickers, before deactivating.</span>")

/obj/item/melee/transforming/energy/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/multitool) && colorable && !active)
		if(!rainbow)
			rainbow = TRUE
		else
			rainbow = FALSE
		to_chat(user, "<span class='notice'>You manipulate the color controller in [src].</span>")
		update_icon()
	if(use_cell)
		if(istype(W, cell_type))
			if(!bcell)
				if(!user.attempt_insert_item_for_installation(W, src))
					return
				bcell = W
				to_chat(user, "<span class='notice'>You install a cell in [src].</span>")
				update_icon()
			else
				to_chat(user, "<span class='notice'>[src] already has a cell.</span>")
		else if(W.is_screwdriver() && bcell)
			bcell.update_icon()
			bcell.forceMove(get_turf(loc))
			bcell = null
			to_chat(user, "<span class='notice'>You remove the cell from \the [src].</span>")
			deactivate()
			update_icon()
			return
	return ..()

/obj/item/melee/transforming/energy/get_cell(inducer)
	return bcell

/obj/item/melee/transforming/energy/update_icon()
	. = ..()
	var/mutable_appearance/blade_overlay = mutable_appearance(icon, "[icon_state]_blade")
	blade_overlay.color = lcolor
	color = lcolor
	if(rainbow)
		blade_overlay = mutable_appearance(icon, "[icon_state]_blade_rainbow")
		blade_overlay.color = "FFFFFF"
		color = "FFFFFF"
	cut_overlays()		//So that it doesn't keep stacking overlays non-stop on top of each other
	if(active)
		add_overlay(blade_overlay)
	if(istype(usr,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = usr
		H.update_inv_l_hand()
		H.update_inv_r_hand()

/obj/item/melee/transforming/energy/AltClick(mob/living/user)
	if(!colorable) //checks if is not colorable
		return
	if(!in_range(src, user))	//Basic checks to prevent abuse
		return
	if(user.incapacitated() || !istype(user))
		to_chat(user, "<span class='warning'>You can't do that right now!</span>")
		return

	if(alert("Are you sure you want to recolor your blade?", "Confirm Recolor", "Yes", "No") == "Yes")
		var/energy_color_input = input(usr,"","Choose Energy Color",lcolor) as color|null
		if(energy_color_input)
			lcolor = "#[sanitize_hexcolor(energy_color_input)]"
			color = lcolor
			deactivate()
		update_icon()
	. = ..()


/*
 * Energy Axe
 */
/obj/item/melee/transforming/energy/axe
	name = "energy axe"
	desc = "An energised battle axe."
	icon_state = "eaxe"
	item_state = "eaxe"
	//active_force = 150 //holy...
	active_force = 60
	active_throwforce = 35
	active_w_class = WEIGHT_CLASS_HUGE
	//damage_force = 40
	//throw_force = 25
	damage_force = 20
	throw_force = 10
	throw_speed = 1
	throw_range = 5
	w_class = WEIGHT_CLASS_NORMAL
	origin_tech = list(TECH_MAGNET = 3, TECH_COMBAT = 4)
	attack_verb = list("attacked", "chopped", "cleaved", "torn", "cut")
	sharp = 1
	edge = 1
	can_cleave = TRUE

/obj/item/melee/transforming/energy/axe/activate(mob/living/user)
	..()
	damtype = SEARING
	to_chat(user, "<span class='notice'>\The [src] is now energised.</span>")

/obj/item/melee/transforming/energy/axe/deactivate(mob/living/user)
	..()
	damtype = BRUTE
	to_chat(user, "<span class='notice'>\The [src] is de-energised. It's just a regular axe now.</span>")

/obj/item/melee/transforming/energy/axe/suicide_act(mob/user)
	var/datum/gender/TU = GLOB.gender_datums[user.get_visible_gender()]
	visible_message("<span class='warning'>\The [user] swings \the [src] towards [TU.his] head! It looks like [TU.he] [TU.is] trying to commit suicide.</span>")
	return (BRUTELOSS|FIRELOSS)

/obj/item/melee/transforming/energy/axe/charge
	name = "charge axe"
	desc = "An energised axe."
	active_force = 35
	active_throwforce = 20
	damage_force = 15
	use_cell = TRUE
	hitcost = 120

/obj/item/melee/transforming/energy/axe/charge/loaded/Initialize(mapload)
	. = ..()
	bcell = new/obj/item/cell/device/weapon(src)

/*
 * Energy Sword
 */
/obj/item/melee/transforming/energy/sword
	name = "energy sword"
	desc = "May the damage_force be within you."
	icon_state = "esword"
	item_state = "esword"
	active_force = 30
	active_throwforce = 20
	active_w_class = WEIGHT_CLASS_BULKY
	damage_force = 3
	throw_force = 5
	throw_speed = 1
	throw_range = 5
	w_class = WEIGHT_CLASS_SMALL
	atom_flags = NOBLOODY
	origin_tech = list(TECH_MAGNET = 3, TECH_ILLEGAL = 4)
	sharp = 1
	edge = 1
	colorable = TRUE
	drop_sound = 'sound/items/drop/sword.ogg'
	pickup_sound = 'sound/items/pickup/sword.ogg'

	passive_parry = /datum/passive_parry{
		parry_chance_default = 60;
		parry_chance_projectile = 65;
	}

/obj/item/melee/transforming/energy/sword/dropped(mob/user, atom_flags, atom/newLoc)
	. = ..()
	if(!istype(loc,/mob))
		deactivate(user)

/obj/item/melee/transforming/energy/sword/activate(mob/living/user)
	if(!active)
		to_chat(user, "<span class='notice'>\The [src] is now energised.</span>")

	..()
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")

/obj/item/melee/transforming/energy/sword/deactivate(mob/living/user)
	if(active)
		to_chat(user, "<span class='notice'>\The [src] deactivates!</span>")
	..()
	attack_verb = list()

/obj/item/melee/transforming/energy/sword/passive_parry_intercept(mob/defending, list/shieldcall_args, datum/passive_parry/parry_data)
	. = ..()
	if(!.)
		return

	var/datum/effect_system/spark_spread/spark_system = new /datum/effect_system/spark_spread()
	spark_system.set_up(5, 0, user.loc)
	spark_system.start()

/obj/item/melee/transforming/energy/sword/unique_parry_check(mob/user, mob/attacker, atom/damage_source)
	if(user.incapacitated() || !istype(damage_source, /obj/projectile/))
		return 0

	var/bad_arc = global.reverse_dir[user.dir]
	if(!check_shield_arc(user, bad_arc, damage_source, attacker))
		return 0

	return 1

/obj/item/melee/transforming/energy/sword/attackby(obj/item/W, mob/living/user, params)
	if(istype(W, /obj/item/melee/transforming/energy/sword))
		if(HAS_TRAIT(W, TRAIT_ITEM_NODROP) || HAS_TRAIT(src, TRAIT_ITEM_NODROP))
			to_chat(user, "<span class='warning'>\the [HAS_TRAIT(src, TRAIT_ITEM_NODROP) ? src : W] is stuck to your hand, you can't attach it to \the [HAS_TRAIT(src, TRAIT_ITEM_NODROP) ? W : src]!</span>")
			return
		if(istype(W, /obj/item/melee/transforming/energy/sword/charge))
			to_chat(user,"<span class='warning'>These blades are incompatible, you can't attach them to each other!</span>")
			return
		else
			to_chat(user, "<span class='notice'>You combine the two energy swords, making a single supermassive blade! You're cool.</span>")
			new /obj/item/melee/transforming/energy/sword/dualsaber(user.drop_location())
			qdel(W)
			qdel(src)
	else
		return ..()

/obj/item/melee/transforming/energy/sword/pirate
	name = "energy cutlass"
	desc = "Arrrr matey."
	icon_state = "cutlass"
	item_state = "cutlass"
	colorable = TRUE

//Return of the King
/obj/item/melee/transforming/energy/sword/dualsaber
	name = "double-bladed energy sword"
	desc = "Handle with care."
	icon_state = "dualsaber"
	item_state = "dualsaber"
	damage_force = 3
	active_force = 60
	throw_force = 5
	throw_speed = 3
	armor_penetration = 35
	colorable = TRUE
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")

	passive_parry = /datum/passive_parry{
		parry_chance_default = 60;
		parry_chance_projectile = 85;
	}

/*
 *Ionic Rapier
 */

/obj/item/melee/transforming/energy/sword/ionic_rapier
	name = "ionic rapier"
	desc = "Designed specifically for disrupting electronics at close range, it is extremely deadly against synthetics, but almost harmless to pure organic targets."
	description_info = "This is a dangerous melee weapon that will deliver a moderately powerful electromagnetic pulse to whatever it strikes.  \
	Striking a lesser robotic entity will compel it to attack you, as well.  It also does extra burn damage to robotic entities, but it does \
	very little damage to purely organic targets."
	icon_state = "ionrapier"
	item_state = "ionrapier"
	active_force = 10
	active_throwforce = 3
	active_embed_chance = 0
	sharp = 1
	edge = 1
	armor_penetration = 0
	atom_flags = NOBLOODY
	lrange = 2
	lpower = 2
	lcolor = "#0000FF"

	passive_parry = /datum/passive_parry{
		parry_chance_default = 60;
		parry_chance_projectile = 30;
	}

/obj/item/melee/transforming/energy/sword/ionic_rapier/afterattack(atom/target, mob/user, clickchain_flags, list/params)
	if(istype(target, /obj) && (clickchain_flags & CLICKCHAIN_HAS_PROXIMITY) && active)
		// EMP stuff.
		var/obj/O = target
		O.emp_act(3) // A weaker severity is used because this has infinite uses.
		playsound(get_turf(O), 'sound/effects/EMPulse.ogg', 100, 1)
		user.setClickCooldown(user.get_attack_speed(src)) // A lot of objects don't set click delay.
	return ..()

/obj/item/melee/transforming/energy/sword/ionic_rapier/melee_mob_hit(mob/target, mob/user, clickchain_flags, list/params, mult, target_zone, intent)
	. = ..()
	var/mob/living/L = target
	if(!istype(L))
		return
	if(L.isSynthetic() && active)
		// Do some extra damage.  Not a whole lot more since emp_act() is pretty nasty on FBPs already.
		L.emp_act(3) // A weaker severity is used because this has infinite uses.
		playsound(get_turf(L), 'sound/effects/EMPulse.ogg', 100, 1)
		L.adjustFireLoss(damage_force * 3) // 15 Burn, for 20 total.
		playsound(get_turf(L), 'sound/weapons/blade1.ogg', 100, 1)

		// Make lesser robots really mad at us.
		if(L.mob_class & MOB_CLASS_SYNTHETIC)
			if(L.has_polaris_AI())
				L.taunt(user)
			L.adjustFireLoss(damage_force * 6) // 30 Burn, for 50 total.

/obj/item/melee/transforming/energy/sword/ionic_rapier/lance
	name = "zero-point lance"
	desc = "Designed specifically for disrupting electronics at relatively close range, however it is still capable of dealing some damage to living beings."
	active_force = 20
	armor_penetration = 15
	reach = 2

/*
 * Charge blade. Uses a cell, and costs energy per strike.
 */

/obj/item/melee/transforming/energy/sword/charge
	name = "charge sword"
	desc = "A small, handheld device which emits a high-energy 'blade'."
	origin_tech = list(TECH_COMBAT = 5, TECH_MAGNET = 3, TECH_ILLEGAL = 4)
	active_force = 25
	armor_penetration = 25
	projectile_parry_chance = 40
	colorable = TRUE
	use_cell = TRUE
	hitcost = 75

/obj/item/melee/transforming/energy/sword/charge/loaded/Initialize(mapload)
	. = ..()
	bcell = new/obj/item/cell/device/weapon(src)

/obj/item/melee/transforming/energy/sword/charge/attackby(obj/item/W, mob/living/user, params)
	if(istype(W, /obj/item/melee/transforming/energy/sword/charge))
		if(HAS_TRAIT(W, TRAIT_ITEM_NODROP) || HAS_TRAIT(src, TRAIT_ITEM_NODROP))
			to_chat(user, "<span class='warning'>\the [HAS_TRAIT(src, TRAIT_ITEM_NODROP) ? src : W] is stuck to your hand, you can't attach it to \the [HAS_TRAIT(src, TRAIT_ITEM_NODROP) ? W : src]!</span>")
			return
		else
			to_chat(user, "<span class='notice'>You combine the two charge swords, making a single supermassive blade! You're cool.</span>")
			new /obj/item/melee/transforming/energy/sword/charge/dualsaber(user.drop_location())
			qdel(W)
			qdel(src)
	else
		return ..()

//Charge Type Double Esword
/obj/item/melee/transforming/energy/sword/charge/dualsaber
	name = "double-bladed charge sword"
	desc = "Make sure you bought batteries."
	icon_state = "dualsaber"
	item_state = "dualsaber"
	damage_force = 3
	active_force = 50
	throw_force = 5
	throw_speed = 3
	armor_penetration = 30
	colorable = TRUE
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	hitcost = 150

	passive_parry = /datum/passive_parry{
		parry_chance_default = 60;
		parry_chance_projectile = 65;
	}

//Energy Blade (ninja uses this)

//Can't be activated or deactivated, so no reason to be a subtype of energy
/obj/item/melee/transforming/energy/blade
	name = "energy blade"
	desc = "A concentrated beam of energy in the shape of a blade. Very stylish... and lethal."
	icon_state = "blade"
	item_state = "blade"
	damage_force = 40 //Normal attacks deal very high damage - about the same as wielded fire axe
	armor_penetration = 100
	sharp = 1
	edge = 1
	anchored = 1    // Never spawned outside of inventory, should be fine.
	throw_force = 1  //Throwing or dropping the item deletes it.
	throw_speed = 1
	throw_range = 1
	w_class = WEIGHT_CLASS_BULKY//So you can't hide it in your pocket or some such.
	atom_flags = NOBLOODY
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	var/mob/living/creator
	var/datum/effect_system/spark_spread/spark_system
	lcolor = "#00FF00"

	passive_parry = /datum/passive_parry{
		parry_chance_default = 60;
		parry_chance_projectile = 60;
	}

/obj/item/melee/transforming/energy/blade/Initialize(mapload)
	. = ..()
	spark_system = new /datum/effect_system/spark_spread()
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)

	START_PROCESSING(SSobj, src)
	set_light(lrange, lpower, lcolor)

/obj/item/melee/transforming/energy/blade/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/melee/transforming/energy/blade/attack_self(mob/user)
	. = ..()
	if(.)
		return
	qdel(src)

/obj/item/melee/transforming/energy/blade/dropped(mob/user, atom_flags, atom/newLoc)
	. = ..()
	qdel(src)

/obj/item/melee/transforming/energy/blade/process(delta_time)
	if(!creator || loc != creator || !creator.is_holding(src))
		// Tidy up a bit.
		if(istype(loc,/mob/living))
			var/mob/living/carbon/human/host = loc
			if(istype(host))
				for(var/obj/item/organ/external/organ in host.organs)
					for(var/obj/item/O in organ.implants)
						if(O == src)
							organ.implants -= src
			host.pinned -= src
			host.embedded -= src
			host._handle_inventory_hud_remove(src)
		qdel(src)

/obj/item/melee/transforming/energy/blade/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if(default_parry_check(user, attacker, damage_source) && prob(60))
		user.visible_message("<span class='danger'>\The [user] parries [attack_text] with \the [src]!</span>")

		var/datum/effect_system/spark_spread/spark_system = new /datum/effect_system/spark_spread()
		spark_system.set_up(5, 0, user.loc)
		spark_system.start()
		playsound(user.loc, 'sound/weapons/blade1.ogg', 50, 1)
		return 1
	if(unique_parry_check(user, attacker, damage_source) && prob(projectile_parry_chance))
		user.visible_message("<span class='danger'>\The [user] deflects [attack_text] with \the [src]!</span>")

		var/datum/effect_system/spark_spread/spark_system = new /datum/effect_system/spark_spread()
		spark_system.set_up(5, 0, user.loc)
		spark_system.start()
		playsound(user.loc, 'sound/weapons/blade1.ogg', 50, 1)
		return 1

	return 0

/obj/item/melee/transforming/energy/blade/unique_parry_check(mob/user, mob/attacker, atom/damage_source)

	if(user.incapacitated() || !istype(damage_source, /obj/projectile/))
		return 0

	var/bad_arc = global.reverse_dir[user.dir]
	if(!check_shield_arc(user, bad_arc, damage_source, attacker))
		return 0

	return 1

//Energy Spear

/obj/item/melee/transforming/energy/spear
	name = "energy spear"
	desc = "Concentrated energy forming a sharp tip at the end of a long rod."
	icon_state = "espear"
	armor_penetration = 75
	sharp = 1
	edge = 1
	damage_force = 5
	throw_force = 10
	throw_speed = 7
	throw_range = 11
	reach = 2
	w_class = WEIGHT_CLASS_BULKY
	active_force = 25
	active_throwforce = 30
	active_w_class = WEIGHT_CLASS_HUGE
	colorable = TRUE
	lcolor = "#800080"

/obj/item/melee/transforming/energy/spear/activate(mob/living/user)
	if(!active)
		to_chat(user, "<span class='notice'>\The [src] is now energised.</span>")
	..()
	attack_verb = list("jabbed", "stabbed", "impaled")
	AddComponent(/datum/component/jousting)


/obj/item/melee/transforming/energy/spear/deactivate(mob/living/user)
	if(active)
		to_chat(user, "<span class='notice'>\The [src] deactivates!</span>")
	..()
	attack_verb = list("whacked", "beat", "slapped", "thonked")
	DelComponent(/datum/component/jousting)

/obj/item/melee/transforming/energy/spear/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if(active && default_parry_check(user, attacker, damage_source) && prob(50))
		user.visible_message("<span class='danger'>\The [user] parries [attack_text] with \the [src]!</span>")
		var/datum/effect_system/spark_spread/spark_system = new /datum/effect_system/spark_spread()
		spark_system.set_up(5, 0, user.loc)
		spark_system.start()
		playsound(user.loc, 'sound/weapons/blade1.ogg', 50, 1)
		return 1
	return 0

/obj/item/melee/transforming/energy/hfmachete // ported from /vg/station - vgstation-coders/vgstation13#13913, fucked up by hatterhat
	name = "high-frequency machete"
	desc = "A high-frequency broad blade used either as an implement or in combat like a short sword."
	icon_state = "hfmachete0"
	sharp = TRUE
	edge = TRUE
	damage_force = 20 // You can be crueler than that, Jack.
	throw_force = 40
	throw_speed = 8
	throw_range = 8
	w_class = WEIGHT_CLASS_NORMAL
	siemens_coefficient = 1
	origin_tech = list(TECH_COMBAT = 3, TECH_ILLEGAL = 3)
	attack_verb = list("attacked", "diced", "cleaved", "torn", "cut", "slashed")
	armor_penetration = 50
	var/base_state = "hfmachete"
	attack_sound = "machete_hit_sound" // dont mind the meaty hit sounds if you hit something that isnt meaty
	can_cleave = TRUE
	embed_chance = 0 // let's not

	active_damage_force = 40

	activation_sound = 'sound/weapons/hf_machete/hfmachete1.ogg'
	deactivation_sound = 'sound/weapons/hf_machete/hfmachete0.ogg'

	active_weight_class = WEIGHT_CLASS_BULKY
	inactive_weight_class = WEIGHT_CLASS_NORMAL

/obj/item/melee/transforming/energy/hfmachete/update_icon()
	icon_state = "[base_state][active]"

#warn parse
/obj/item/melee/transforming/energy/hfmachete/proc/toggleActive(mob/user, var/togglestate = "")
	switch(togglestate)
		if("on")
			active = 1
		if("off")
			active = 0
		else
			active = !active
	if(active)
		throw_force = 20
		throw_speed = 3
		// sharpness = 1.7
		// sharpness_flags += HOT_EDGE | CUT_WALL | CUT_AIRLOCK - if only there  a good sharpness system
		armor_penetration = 100
		to_chat(user, "<span class='warning'> [src] starts vibrating.</span>")
	else
		throw_force = initial(throw_force)
		throw_speed = initial(throw_speed)
		// sharpness = initial(sharpness)
		// sharpness_flags = initial(sharpness_flags) - if only there was a good sharpness system
		armor_penetration = initial(armor_penetration)
		to_chat(user, "<span class='notice'> [src] stops vibrating.</span>")
	update_icon()

/obj/item/melee/transforming/energy/hfmachete/afterattack(atom/target, mob/user, clickchain_flags, list/params)
	if(!(clickchain_flags & CLICKCHAIN_HAS_PROXIMITY))
		return
	..()
	if(target)
		if(istype(target,/obj/effect/plant))
			var/obj/effect/plant/P = target
			P.die_off()


/obj/item/melee/transforming/energy/sword/imperial
	name = "energy gladius"
	desc = "A broad, short energy blade.  You'll be glad to have this in a fight."
	icon_state = "sword0"
	icon = 'icons/obj/weapons_vr.dmi'
	item_icons = list(SLOT_ID_LEFT_HAND = 'icons/mob/items/lefthand_melee.dmi', SLOT_ID_RIGHT_HAND = 'icons/mob/items/righthand_melee.dmi')

/obj/item/melee/transforming/energy/sword/imperial/activate(mob/living/user)
	..()
	icon_state = "sword1"
