
/obj/item/projectile/energy/declone
	name = "declone"
	icon_state = "declone"
	fire_sound = 'sound/weapons/pulse3.ogg'
	nodamage = 1
	damage_type = CLONE
	irradiate = 40
	light_range = 2
	light_power = 0.5
	light_color = "#33CC00"

	combustion = FALSE



/obj/item/projectile/energy/acid //Slightly up-gunned (Read: The thing does agony and checks bio resist) variant of the simple alien mob's projectile, for queens and sentinels.
	name = "acidic spit"
	icon_state = "neurotoxin"
	damage = 30
	damage_type = BURN
	agony = 10
	check_armour = "bio"
	armor_penetration = 25	// It's acid

	combustion = FALSE

/obj/item/projectile/energy/neurotoxin
	name = "neurotoxic spit"
	icon_state = "neurotoxin"
	damage = 5
	damage_type = BIOACID
	agony = 80
	check_armour = "bio"
	armor_penetration = 25	// It's acid-based

	combustion = FALSE

/obj/item/projectile/energy/neurotoxin/toxic //New alien mob projectile to match the player-variant's projectiles.
	name = "neurotoxic spit"
	icon_state = "neurotoxin"
	damage = 20
	damage_type = BIOACID
	agony = 20
	check_armour = "bio"
	armor_penetration = 25	// It's acid-based

/obj/item/projectile/energy/phoron
	name = "phoron bolt"
	icon_state = "energy"
	fire_sound = 'sound/effects/stealthoff.ogg'
	damage = 20
	damage_type = TOX
	irradiate = 20
	light_range = 2
	light_power = 0.5
	light_color = "#33CC00"

	combustion = FALSE

/obj/item/projectile/energy/plasmastun
	name = "plasma pulse"
	icon_state = "plasma_stun"
	fire_sound = 'sound/weapons/blaster.ogg'
	armor_penetration = 10
	range = 4
	damage = 5
	agony = 55
	damage_type = BURN
	vacuum_traversal = 0	//Projectile disappears in empty space

/obj/item/projectile/energy/plasmastun/proc/bang(var/mob/living/carbon/M)

	to_chat(M, "<span class='danger'>You hear a loud roar.</span>")
	playsound(M.loc, 'sound/effects/bang.ogg', 50, 1)
	var/ear_safety = 0
	ear_safety = M.get_ear_protection()
	if(ear_safety == 1)
		M.Confuse(150)
	else if (ear_safety > 1)
		M.Confuse(30)
	else if (!ear_safety)
		M.Stun(10)
		M.Weaken(2)
		M.ear_damage += rand(1, 10)
		M.ear_deaf = max(M.ear_deaf,15)
	if (M.ear_damage >= 15)
		to_chat(M, "<span class='danger'>Your ears start to ring badly!</span>")
		if (prob(M.ear_damage - 5))
			to_chat(M, "<span class='danger'>You can't hear anything!</span>")
			M.sdisabilities |= DEAF
	else
		if (M.ear_damage >= 5)
			to_chat(M, "<span class='danger'>Your ears start to ring!</span>")
	M.update_icons() //Just to apply matrix transform for laying asap

/obj/item/projectile/energy/plasmastun/on_hit(var/atom/target)
	bang(target)
	. = ..()

/obj/item/projectile/energy/blue_pellet
	name = "suppressive pellet"
	icon_state = "blue_pellet"
	fire_sound = 'sound/weapons/Laser.ogg'
	damage = 5
	armor_penetration = 75
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE
	damage_type = BURN
	check_armour = "energy"
	light_color = "#0000FF"

	embed_chance = 0
	muzzle_type = /obj/effect/projectile/muzzle/pulse

