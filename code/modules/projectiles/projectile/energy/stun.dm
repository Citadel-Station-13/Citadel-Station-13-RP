/obj/item/projectile/energy/electrode
	name = "electrode"
	icon_state = "spark"
	fire_sound = 'sound/weapons/Gunshot2.ogg'
	taser_effect = 1
	agony = 40
	light_range = 2
	light_power = 0.5
	light_color = "#FFFFFF"
	//Damage will be handled on the MOB side, to prevent window shattering.

/obj/item/projectile/energy/electrode/strong
	agony = 55

/obj/item/projectile/energy/electrode/stunshot
	name = "stunshot"
	damage = 5
	agony = 80

//VR overrides
/obj/item/projectile/energy/electrode/strong
	agony = 70

