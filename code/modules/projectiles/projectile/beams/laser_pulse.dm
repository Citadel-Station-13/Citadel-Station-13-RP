/obj/item/projectile/beam/laser/pulse
	name = "pulse"
	icon_state = "u_laser"
	fire_sound='sound/weapons/gauss_shoot.ogg' // Needs a more meaty sound than what pulse.ogg currently is; this will be a placeholder for now.
	damage = 50	//Badmin toy, don't care		//No fuck you
	armor_penetration = 50
	light_color = "#0066FF"

	muzzle_type = /obj/effect/projectile/muzzle/laser_pulse
	tracer_type = /obj/effect/projectile/tracer/laser_pulse
	impact_type = /obj/effect/projectile/impact/laser_pulse

/obj/item/projectile/beam/laserpulse/on_hit(var/atom/target, var/blocked = 0)
	if(isturf(target))
		target.ex_act(2)
	. = ..()
