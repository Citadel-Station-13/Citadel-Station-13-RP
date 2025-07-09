/datum/firemode/energy/sizegun
	projectile_type = /obj/projectile/energy/sizegun
	charge_cost = 240

/obj/item/gun/projectile/energy/sizegun
	name = "size gun" //I have no idea why this was called shrink ray when this increased and decreased size.
	desc = "A highly advanced ray gun with a knob on the side to adjust the size you desire. Warning: Do not insert into mouth."
	icon = 'icons/modules/projectiles/guns/energy/sizegun.dmi'
	icon_state = "sizegun-4"
	base_icon_state = "sizegun"
	worn_state = "sizegun"
	item_renderer = /datum/gun_item_renderer/states{
		count = 4;
		use_empty = TRUE;
	}
	no_pin_required = TRUE
	legacy_battery_lock = TRUE
	firemodes = list(
		/datum/firemode/energy/sizegun,
	)

	item_action_name = "Select Size"

	var/size_set_to = 1

/obj/item/gun/projectile/energy/sizegun/Initialize(mapload)
	. = ..()
	add_obj_verb(src, /obj/item/gun/projectile/energy/sizegun/proc/select_size)

/obj/item/gun/projectile/energy/sizegun/ui_action_click(datum/action/action, datum/event_args/actor/actor)
	. = ..()
	select_size()

/obj/item/gun/projectile/energy/sizegun/consume_next_projectile(datum/gun_firing_cycle/cycle)
	. = ..()
	var/obj/projectile/energy/sizegun/G = .
	if(istype(G))
		G.set_size = size_set_to

/obj/item/gun/projectile/energy/sizegun/proc/select_size()
	set name = "Select Size"
	set category = VERB_CATEGORY_OBJECT
	set src in view(1)

	var/size_select = input("Put the desired size (25-200%)", "Set Size", size_set_to*100) as num
	if(size_select>200 || size_select<25)
		to_chat(usr, "<span class='notice'>Invalid size.</span>")
		return
	size_set_to = (size_select/100)
	to_chat(usr, "<span class='notice'>You set the size to [size_select]%</span>")

/obj/item/gun/projectile/energy/sizegun/examine(mob/user, dist)
	. = ..()
	var/size_examine = (size_set_to*100)
	. += "<span class='info'>It is currently set at [size_examine]%</span>"

/obj/projectile/energy/sizegun
	name = "size beam"
	icon_state = "xray"
	hitscan = TRUE
	nodamage = 1
	damage_force = 0
	damage_flag = ARMOR_LASER
	light_range = 2
	light_power = 0.5
	light_color = "#2ec317"
	fire_sound = 'sound/weapons/pulse3.ogg'
	var/set_size = 1 //Let's default to 100%

	legacy_muzzle_type = /obj/effect/projectile/muzzle/xray
	legacy_tracer_type = /obj/effect/projectile/tracer/xray
	legacy_impact_type = /obj/effect/projectile/impact/xray

/obj/projectile/energy/sizegun/on_impact(atom/target, impact_flags, def_zone, efficiency)
	. = ..()
	if(. & PROJECTILE_IMPACT_FLAGS_UNCONDITIONAL_ABORT)
		return

	var/mob/living/M = target
	if(!istype(M))
		return
	if(!M.permit_sizegun)
		M.visible_message("<span class='warning'>[src] has no effect on [M].</span>")
		return
	if(ishuman(target))
		var/mob/living/carbon/human/H = M
		H.resize(set_size, TRUE)
		H.show_message("<font color=#4F49AF> The beam fires into your body, changing your size!</font>")
		H.updateicon()
	else if (istype(target, /mob/living/))
		var/mob/living/H = M
		H.resize(set_size, TRUE)
		H.updateicon()
