// todo: this shouldn't be a signalled shieldcall, as
/obj/item/clothing/suit/armor/laserproof
	name = "ablative armor vest"
	desc = "A vest that excels in protecting the wearer against energy projectiles."
	icon_state = "armor_reflec"
	blood_overlay_type = "armor"
	armor_type = /datum/armor/station/ablative
	siemens_coefficient = 0.1

/obj/item/clothing/suit/armor/laserproof/equipped(mob/user, slot, flags)
	. = ..()
	if(slot == SLOT_ID_HANDS)
		return
	// if you're reading this: this is not the right way to do shieldcalls
	// this is just a lazy implementation
	// signals have highest priority, this as a piece of armor shouldn't have that.
	RegisterSignal(user, COMSIG_ATOM_SHIELDCALL, PROC_REF(shieldcall))

/obj/item/clothing/suit/armor/laserproof/unequipped(mob/user, slot, flags)
	. = ..()
	if(slot == SLOT_ID_HANDS)
		return
	UnregisterSignal(user, COMSIG_ATOM_SHIELDCALL)

/obj/item/clothing/suit/armor/laserproof/proc/shieldcall(mob/defending, list/shieldcall_args, fake_attack)
	var/damage_source = shieldcall_args[SHIELDCALL_ARG_ATTACK_SOURCE]
	var/def_zone = shieldcall_args[SHIELDCALL_ARG_HIT_ZONE]
	if(istype(damage_source, /obj/projectile/energy) || istype(damage_source, /obj/projectile/beam))
		var/obj/projectile/P = damage_source

		if(P.reflected) // Can't reflect twice
			return

		var/reflectchance = 50 - round(shieldcall_args[SHIELDCALL_ARG_DAMAGE]/3)
		if(!(def_zone in list(BP_TORSO, BP_GROIN)))
			reflectchance /= 2
		if(P.starting && prob(reflectchance))
			visible_message("<span class='danger'>\The [defending]'s [src.name] reflects [P]!</span>")

			// Find a turf near or on the original location to bounce to
			var/new_x = P.starting.x + pick(0, 0, 0, 0, 0, -1, 1, -2, 2)
			var/new_y = P.starting.y + pick(0, 0, 0, 0, 0, -1, 1, -2, 2)
			var/turf/curloc = get_turf(defending)

			// redirect the projectile
			P.legacy_redirect(new_x, new_y, curloc, defending)
			P.reflected = 1
			shieldcall_args[SHIELDCALL_ARG_FLAGS] |= SHIELDCALL_FLAG_ATTACK_PASSTHROUGH | SHIELDCALL_FLAG_ATTACK_REDIRECT | SHIELDCALL_FLAG_ATTACK_BLOCKED | SHIELDCALL_FLAG_TERMINATE

/obj/item/clothing/gloves/arm_guard/laserproof
	name = "ablative arm guards"
	desc = "These arm guards will protect your hands and arms from energy weapons."
	icon_state = "arm_guards_laser"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "swat", SLOT_ID_LEFT_HAND = "swat")
	siemens_coefficient = 0.4 //This is worse than the other ablative pieces, to avoid this from becoming the poor warden's insulated gloves.
	armor_type = /datum/armor/station/ablative

/obj/item/clothing/shoes/leg_guard/laserproof
	name = "ablative leg guards"
	desc = "These will protect your legs and feet from energy weapons."
	icon_state = "leg_guards_laser"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "jackboots", SLOT_ID_LEFT_HAND = "jackboots")
	siemens_coefficient = 0.1
	armor_type = /datum/armor/station/ablative
