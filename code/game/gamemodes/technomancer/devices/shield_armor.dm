/datum/technomancer/equipment/shield_armor
	name = "Personal Shield Projector"
	desc = "This state-of-the-art technology uses the bleeding edge of energy distribution and field projection \
	to provide a personal shield around you, which can diffuse laser beams and reduce the velocity of bullets and close quarters \
	weapons, reducing their potential for harm severely.  All of this comes at a cost of of requiring a large amount of energy, \
	of which your Core can provide.  When you are struck by something, the shield will block 75% of the damage, deducting energy \
	proportional to the amount of force that was inflicted.  Armor penetration has no effect on the shield's ability to protect \
	you from harm, however the shield will fail if the energy supply cannot meet demand."
	cost = 200
	obj_path = /obj/item/clothing/suit/armor/shield

/obj/item/clothing/suit/armor/shield
	name = "shield projector"
	desc = "This armor has no inherent ability to absorb shock, as normal armor usually does.  Instead, this emits a strong field \
	around the wearer, designed to protect from most forms of harm, from lasers to bullets to close quarters combat.  It appears to \
	require a very potent supply of an energy of some kind in order to function."
	icon_state = "shield_armor_0"
	blood_overlay_type = "armor"
	weight = ITEM_WEIGHT_BASELINE
	armor_type = /datum/armor/none
	item_action_name = "Toggle Shield Projector"
	var/active = 0
	var/damage_to_energy_multiplier = 50.0 //Determines how much energy to charge for blocking, e.g. 20 damage attack = 750 energy cost
	var/datum/effect_system/spark_spread/spark_system = null
	var/block_percentage = 75

/obj/item/clothing/suit/armor/shield/Initialize(mapload)
	. = ..()
	spark_system = new /datum/effect_system/spark_spread()
	spark_system.set_up(5, 0, src)

/obj/item/clothing/suit/armor/shield/Destroy()
	qdel(spark_system)
	return ..()

/obj/item/clothing/suit/armor/shield/equipped(mob/user, slot, flags)
	. = ..()
	if(slot == SLOT_ID_HANDS)
		return
	// if you're reading this: this is not the right way to do shieldcalls
	// this is just a lazy implementation
	// signals have highest priority, this as a piece of armor shouldn't have that.
	RegisterSignal(user, COMSIG_ATOM_SHIELDCALL, PROC_REF(shieldcall))

/obj/item/clothing/suit/armor/shield/unequipped(mob/user, slot, flags)
	. = ..()
	if(slot == SLOT_ID_HANDS)
		return
	UnregisterSignal(user, COMSIG_ATOM_SHIELDCALL)

/obj/item/clothing/suit/armor/shield/proc/shieldcall(mob/user, list/shieldcall_args, fake_attack)
	var/damage = shieldcall_args[SHIELDCALL_ARG_DAMAGE]
	var/damage_source = shieldcall_args[SHIELDCALL_ARG_ATTACK_SOURCE]

	//Since this is a pierce of armor that is passive, we do not need to check if the user is incapacitated.
	if(!active)
		return 0

	var/modified_block_percentage = block_percentage

	if(issmall(user)) // Smaller shield means better protection.
		modified_block_percentage += 15


	var/damage_blocked = damage * (modified_block_percentage / 100)

	var/damage_to_energy_cost = (damage_to_energy_multiplier * damage_blocked)

	if(!user.technomancer_pay_energy(damage_to_energy_cost))
		to_chat(user, "<span class='danger'>Your shield fades due to lack of energy!</span>")
		active = 0
		update_icon()
		return 0

	damage = damage - damage_blocked

	if(istype(damage_source, /obj/projectile))
		var/obj/projectile/P = damage_source
		P.damage_mode &= ~(DAMAGE_MODE_EDGE | DAMAGE_MODE_SHARP | DAMAGE_MODE_SHRED | DAMAGE_MODE_PIERCE)
		P.embed_chance = 0
		if(P.damage_inflict_agony)
			var/damage_inflict_agony_blocked = P.damage_inflict_agony * (modified_block_percentage / 100)
			P.damage_inflict_agony -= damage_inflict_agony_blocked
		P.damage_force = P.damage_force - damage_blocked

	user.visible_message("<span class='danger'>\The [user]'s [src] absorbs the attack!</span>")
	to_chat(user, "<span class='warning'>Your shield has absorbed most of \the [damage_source].</span>")

	spark_system.start()
	playsound(user.loc, 'sound/weapons/blade1.ogg', 50, 1)

/obj/item/clothing/suit/armor/shield/attack_self(mob/user, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	active = !active
	to_chat(user, "<span class='notice'>You [active ? "" : "de"]activate \the [src].</span>")
	update_full_icon()

/obj/item/clothing/suit/armor/shield/update_icon()
	icon_state = "shield_armor_[active]"
	item_state = "shield_armor_[active]"
	if(active)
		set_light(2, 1, l_color = "#006AFF")
	else
		set_light(0, 0, l_color = "#000000")
	..()
	return
