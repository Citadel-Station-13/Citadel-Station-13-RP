/datum/technomancer/equipment/tesla_armor
	name = "Tesla Armor"
	desc = "This piece of armor offers a retaliation-based defense.  When the armor is 'ready', it will completely protect you from \
	the next attack you suffer, and strike the attacker with a strong bolt of lightning, provided they are close enough.  This effect requires \
	fifteen seconds to recharge.  If you are attacked while this is recharging, a weaker lightning bolt is sent out, however you won't be protected from \
	the person beating you."
	cost = 150
	obj_path = /obj/item/clothing/suit/armor/tesla

/obj/item/clothing/suit/armor/tesla
	name = "tesla armor"
	desc = "This rather dangerous looking armor will hopefully shock your enemies, and not you in the process."
	icon_state = "tesla_armor_1" //wip
	blood_overlay_type = "armor"
	weight = ITEM_WEIGHT_BASELINE
	armor_type = /datum/armor/none
	item_action_name = "Toggle Tesla Armor"
	var/active = 1	//Determines if the armor will zap or block
	var/ready = 1 //Determines if the next attack will be blocked, as well if a strong lightning bolt is sent out at the attacker.
	var/ready_icon_state = "tesla_armor_1" //also wip
	var/normal_icon_state = "tesla_armor_0"
	var/cooldown_to_charge = 15 SECONDS

/obj/item/clothing/suit/armor/tesla/equipped(mob/user, slot, flags)
	. = ..()
	if(slot == SLOT_ID_HANDS)
		return
	// if you're reading this: this is not the right way to do shieldcalls
	// this is just a lazy implementation
	// signals have highest priority, this as a piece of armor shouldn't have that.
	RegisterSignal(user, COMSIG_ATOM_SHIELDCALL, PROC_REF(shieldcall))

/obj/item/clothing/suit/armor/tesla/unequipped(mob/user, slot, flags)
	. = ..()
	if(slot == SLOT_ID_HANDS)
		return
	UnregisterSignal(user, COMSIG_ATOM_SHIELDCALL)

/obj/item/clothing/suit/armor/tesla/proc/shieldcall(mob/user, list/shieldcall_args, fake_attack)
	var/damage_source = shieldcall_args[SHIELDCALL_ARG_ATTACK_SOURCE]

	var/datum/event_args/actor/clickchain/clickchain = istype(damage_source, /datum/event_args/actor/clickchain) ? damage_source : null
	var/mob/attacker = clickchain?.performer

	//First, some retaliation.
	if(active)
		if(istype(damage_source, /obj/projectile))
			var/obj/projectile/P = damage_source
			if(P.firer && get_dist(user, P.firer) <= 3)
				if(ready)
					shoot_lightning(P.firer, 40)
				else
					shoot_lightning(P.firer, 15)

		else
			if(attacker && attacker != user)
				if(get_dist(user, attacker) <= 3) //Anyone farther away than three tiles is too far to shoot lightning at.
					if(ready)
						shoot_lightning(attacker, 40)
					else
						shoot_lightning(attacker, 15)

		//Deal with protecting our wearer now.
		if(ready)
			ready = 0
			spawn(cooldown_to_charge)
				ready = 1
				update_icon()
				to_chat(user, "<span class='notice'>\The [src] is ready to protect you once more.</span>")
			visible_message("<span class='danger'>\The [user]'s [src.name] blocks the attack!</span>")
			update_icon()
			return 1
	return 0

/obj/item/clothing/suit/armor/tesla/attack_self(mob/user, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	active = !active
	to_chat(user, "<span class='notice'>You [active ? "" : "de"]activate \the [src].</span>")
	update_full_icon()

/obj/item/clothing/suit/armor/tesla/update_icon()
	if(active && ready)
		icon_state = ready_icon_state
		item_state = ready_icon_state
		set_light(2, 1, l_color = "#006AFF")
	else
		icon_state = normal_icon_state
		item_state = normal_icon_state
		set_light(0, 0, l_color = "#000000")

	update_worn_icon()
	update_action_buttons()
	..()

/obj/item/clothing/suit/armor/tesla/proc/shoot_lightning(mob/target, power)
	var/obj/projectile/beam/lightning/lightning = new(get_turf(src))
	lightning.power = power
	lightning.old_style_target(target)
	lightning.fire()
	visible_message("<span class='danger'>\The [src] strikes \the [target] with lightning!</span>")
	playsound(get_turf(src), 'sound/weapons/gauss_shoot.ogg', 75, 1)
