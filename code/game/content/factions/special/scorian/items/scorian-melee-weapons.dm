
//Interestingly, a magic flame sword has a lot in common with the thermal cutter Tech and I made for Goblins. So I decided it should share some of that code.
/obj/item/melee/ashlander
	name = "bone sword"
	desc = "A sharp sword crafted from knapped bone. In spite of its primitive appearance, it is still incredibly deadly."
	icon_state = "bonesword"
	attack_sound = 'sound/weapons/bladeslice.ogg'
	damage_force = 20
	throw_force = 10
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = SLOT_BELT
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut", "chopped")
	sharp = 1
	edge = 1

/obj/item/melee/transforming/ashlander_elder
	name = "elder bone sword"
	desc = "These swords are crafted from one solid piece of a gigantic bone. Carried by the Ashlander priesthood, these weapons are considered holy relics and are often preserved over the lives of their wielders."
	icon_state = "elderbonesword"
	var/active = 0
	var/flame_intensity = 2
	var/flame_color = "#FF9933"
	var/SA_bonus_damage = 25 // 50 total against demons and aberrations.
	var/SA_vulnerability = MOB_CLASS_DEMONIC | MOB_CLASS_ABERRATION

/obj/item/melee/transforming/ashlander_elder/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/anti_magic, TRUE, TRUE, FALSE, null, null, FALSE)

/obj/item/melee/transforming/ashlander_elder/afterattack(atom/target, mob/user, clickchain_flags, list/params)
	if(isliving(target))
		var/mob/living/tm = target // targeted mob
		if(SA_vulnerability & tm.mob_class)
			tm.apply_damage(SA_bonus_damage) // fuck em

/obj/item/melee/transforming/ashlander_elder/attack_self(mob/user)
	. = ..()
	if(.)
		return
	if(!active)
		activate()
	else if(active)
		deactivate()

/obj/item/melee/transforming/ashlander_elder/update_icon()
	..()
	if(active)
		icon_state = "[initial(icon_state)]_1"
	else
		icon_state = initial(icon_state)

	// Lights
	if(active && flame_intensity)
		set_light(flame_intensity, flame_intensity, flame_color)
	else
		set_light(0)

	var/mob/M = loc
	if(istype(M))
		M.update_inv_l_hand()
		M.update_inv_r_hand()

/obj/item/melee/transforming/ashlander_elder/proc/activate(mob/living/user)
	to_chat(user, "<span class='notice'>You ignite the [src]'s sacred flame.</span>")
	playsound(loc, 'sound/weapons/gun_flamethrower3.ogg', 50, 1)
	src.damage_force = 20
	src.damtype = "fire"
	src.set_weight_class(WEIGHT_CLASS_BULKY)
	src.attack_sound = 'sound/weapons/gun_flamethrower2.ogg'
	active = 1
	update_icon()

/obj/item/melee/transforming/ashlander_elder/proc/deactivate(mob/living/user)
	to_chat(user, "<span class='notice'>You douse \the [src]'s sacred flame.</span>")
	playsound(loc, 'sound/weapons/gun_flamethrower1.ogg', 50, 1)
	src.damage_force = 20
	src.damtype = "brute"
	src.set_weight_class(initial(src.w_class))
	src.attack_sound = initial(src.attack_sound)
	src.active = 0
	update_icon()

/obj/item/melee/transforming/ashlander_elder/proc/isOn()
	return active

/obj/item/melee/transforming/ashlander_elder/is_hot()
	return isOn()
