/obj/item/melee/transforming/energy/sword
	name = "energy saber"
	desc = "May the fourth be within you."
	icon_state = "saber"
	base_icon_state = "saber"
	damage_force = 3
	throw_force = 5
	throw_speed = 1
	throw_range = 5
	w_class = WEIGHT_CLASS_SMALL
	atom_flags = NOBLOODY
	origin_tech = list(TECH_MAGNET = 3, TECH_ILLEGAL = 4)
	colorable = TRUE
	drop_sound = 'sound/items/drop/sword.ogg'
	pickup_sound = 'sound/items/pickup/sword.ogg'
	var/can_combine = TRUE

	active_damage_force = 30
	active_throw_force = 20
	active_weight_class = WEIGHT_CLASS_BULKY
	active_damage_mode = DAMAGE_MODE_SHARP | DAMAGE_MODE_EDGE
	active_attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")

	passive_parry = /datum/passive_parry{
		parry_chance_default = 60;
		parry_chance_projectile = 65;
	}

/obj/item/melee/transforming/energy/sword/on_activate(datum/event_args/actor/actor, silent)
	. = ..()
	actor.chat_feedback(
		SPAN_WARNING("You energize \the [src]."),
		target = src,
	)

/obj/item/melee/transforming/energy/sword/on_deactivate(datum/event_args/actor/actor, silent)
	. = ..()
	actor.chat_feedback(
		SPAN_WARNING("You de-energize \the [src]."),
		target = src,
	)

/obj/item/melee/transforming/energy/sword/passive_parry_intercept(mob/defending, attack_type, datum/attack_source, datum/passive_parry/parry_data)
	. = ..()
	if(!.)
		return

	var/datum/effect_system/spark_spread/spark_system = new /datum/effect_system/spark_spread()
	spark_system.set_up(5, 0, defending.loc)
	spark_system.start()

/obj/item/melee/transforming/energy/sword/attackby(obj/item/W, mob/living/user, params)
	if(istype(W, /obj/item/melee/transforming/energy/sword))
		if(HAS_TRAIT(W, TRAIT_ITEM_NODROP) || HAS_TRAIT(src, TRAIT_ITEM_NODROP))
			to_chat(user, "<span class='warning'>\the [HAS_TRAIT(src, TRAIT_ITEM_NODROP) ? src : W] is stuck to your hand, you can't attach it to \the [HAS_TRAIT(src, TRAIT_ITEM_NODROP) ? W : src]!</span>")
			return
		var/obj/item/melee/transforming/energy/sword/other_sword = W
		if(!can_combine || !other_sword.can_combine)
			to_chat(user,"<span class='warning'>At least one of theese blades can't be attached</span>")
			return
		if(istype(W, /obj/item/melee/transforming/energy/sword/charge))
			to_chat(user,"<span class='warning'>These blades are incompatible, you can't attach them to each other!</span>")
			return
		else
			to_chat(user, "<span class='notice'>You combine the two energy swords, making a single supermassive blade! You're cool.</span>")
			new /obj/item/melee/transforming/energy/sword/dual(user.drop_location())
			qdel(W)
			qdel(src)
	else
		return ..()

/obj/item/melee/transforming/energy/sword/implant
	can_combine = FALSE

/obj/item/melee/transforming/energy/sword/cutlass
	name = "energy cutlass"
	desc = "Arrrr matey."
	icon_state = "cutlass"
	base_icon_state = "cutlass"
	colorable = TRUE

/obj/item/melee/transforming/energy/sword/dual
	name = "double-bladed energy sword"
	desc = "Handle with care."
	icon_state = "saber-dual"
	base_icon_state = "saber-dual"
	damage_force = 3
	active_damage_force = 60
	throw_force = 5
	throw_speed = 3
	colorable = TRUE
	can_combine = FALSE
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	worn_render_flags = WORN_RENDER_SLOT_NO_RENDER | WORN_RENDER_INHAND_ONE_FOR_ALL

	passive_parry = /datum/passive_parry{
		parry_chance_default = 60;
		parry_chance_projectile = 85;
	}

/obj/item/melee/transforming/energy/sword/charge
	name = "charge sword"
	desc = "A small, handheld device which emits a high-energy 'blade'."
	origin_tech = list(TECH_COMBAT = 5, TECH_MAGNET = 3, TECH_ILLEGAL = 4)
	active_damage_force = 25
	active_damage_tier = 4.5
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
		var/obj/item/melee/transforming/energy/sword/other_sword = W
		if(!can_combine || !other_sword.can_combine)
			to_chat(user,"<span class='warning'>At least one of theese blades can't be attached</span>")
			return
		else
			to_chat(user, "<span class='notice'>You combine the two charge swords, making a single supermassive blade! You're cool.</span>")
			new /obj/item/melee/transforming/energy/sword/charge/dualsaber(user.drop_location())
			qdel(W)
			qdel(src)
	else if(istype(W, /obj/item/melee/transforming/energy/sword)) //Without this, parent will be called, and as the other blade isn't a charge one, it could combine
		to_chat(user,"<span class='warning'>These blades are incompatible, you can't attach them to each other!</span>")
	else
		return ..()

/obj/item/melee/transforming/energy/sword/charge/dualsaber
	name = "double-bladed charge sword"
	desc = "Make sure you bought batteries."
	icon_state = "saber-dual"
	base_icon_state = "saber-dual"
	damage_force = 3
	active_damage_force = 50
	throw_force = 5
	throw_speed = 3
	colorable = TRUE
	hitcost = 150
	can_combine = FALSE
	passive_parry = /datum/passive_parry{
		parry_chance_default = 60;
		parry_chance_projectile = 65;
	}

/obj/item/melee/transforming/energy/sword/imperial
	name = "imperial sword"
	desc = "What the hell is this?"
	icon_state = "imperial_sword"
	base_icon_state = "imperial_sword"
