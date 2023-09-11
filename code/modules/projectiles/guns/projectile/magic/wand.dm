/obj/item/gun/projectile/magic/wand
	name = "wand of nothing"
	desc = "It's not just a stick, it's a MAGIC stick!"
	projectile_type = /obj/projectile/magic
	icon_state = "nothingwand"
	item_state = "wand"
	w_class = WEIGHT_CLASS_SMALL
	can_charge = 0
	max_charges = 100 //100, 50, 50, 34 (max charge distribution by 25%ths)
	accuracy = 95
	var/variable_charges = 1

/obj/item/gun/projectile/magic/wand/Initialize(mapload)
	if(prob(75) && variable_charges) //25% chance of listed max charges, 50% chance of 1/2 max charges, 25% chance of 1/3 max charges
		if(prob(33))
			max_charges = CEILING(max_charges / 3, 1)
		else
			max_charges = CEILING(max_charges / 2, 1)
	return ..()

/obj/item/gun/projectile/magic/wand/examine(mob/user, dist)
	. = ..()
	. += "Has [charges] charge\s remaining."

/obj/item/gun/projectile/magic/wand/update_icon()
	icon_state = "[initial(icon_state)][charges ? "" : "-drained"]"

/obj/item/gun/projectile/magic/wand/attack_mob(mob/target, mob/user, clickchain_flags, list/params, mult, target_zone, intent)
	if(target == user)
		return
	return ..()

/obj/item/gun/projectile/magic/wand/afterattack(atom/target, mob/user, clickchain_flags, list/params)
	if(!charges)
		return
	if(target == user)
		if(no_den_usage)
			var/area/A = get_area(user)
			if(istype(A, /area/wizard_station))
				to_chat(user, "<span class='warning'>You know better than to violate the security of The Den, best wait until you leave to use [src].</span>")
				return
			else
				no_den_usage = 0
		zap_self(user)
	else
		. = ..()
	update_icon()


/obj/item/gun/projectile/magic/wand/proc/zap_self(mob/living/user)
	user.visible_message("<span class='danger'>[user] zaps themself with [src].</span>")
	playsound(user, fire_sound, 50, 1)

/obj/item/gun/projectile/magic/wand/death
	name = "wand of death"
	desc = "This deadly wand overwhelms the victim's body with pure energy, slaying them without fail."
	fire_sound = 'sound/magic/wandodeath.ogg'
	projectile_type = /obj/projectile/magic/death
	icon_state = "deathwand"
	max_charges = 3 //3, 2, 2, 1

/obj/item/gun/projectile/magic/wand/death/debug
	desc = "In some obscure circles, this is known as the 'cloning tester's friend'."
	max_charges = 500
	variable_charges = FALSE
	can_charge = TRUE
	recharge_rate = 1

/obj/item/gun/projectile/magic/wand/teleport
	name = "wand of teleportation"
	desc = "This wand will wrench targets through space and time to move them somewhere else."
	projectile_type = /obj/projectile/magic/teleport
	fire_sound = 'sound/magic/wand_teleport.ogg'
	icon_state = "telewand"
	max_charges = 10 //10, 5, 5, 4
	no_den_usage = 1

/obj/item/gun/projectile/magic/wand/door
	name = "wand of door creation"
	desc = "This particular wand can create doors in any wall for the unscrupulous wizard who shuns teleportation magics."
	projectile_type = /obj/projectile/magic/door
	icon_state = "doorwand"
	fire_sound = 'sound/magic/staff_door.ogg'
	max_charges = 20 //20, 10, 10, 7
	no_den_usage = 1

/obj/item/gun/projectile/magic/wand/fireball
	name = "wand of fireball"
	desc = "This wand shoots scorching balls of fire that explode into destructive flames."
	fire_sound = 'sound/magic/fireball.ogg'
	projectile_type = /obj/projectile/magic/aoe/fireball
	icon_state = "firewand"
	max_charges = 8 //8, 4, 4, 3

/obj/item/gun/projectile/magic/wand/arcane
	name = "wand of arcane missile"
	desc = "This wand fires off small bolts of concentrated magic energy, searing any victim."
	projectile_type = /obj/projectile/magic/arcane_barrage
	fire_sound = 'sound/weapons/mmlbuster.ogg'
	icon_state = "arcanewand"
	max_charges = 20 //20, 10, 10, 7
