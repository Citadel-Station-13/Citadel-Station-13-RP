// -------------- NSFW -------------
/obj/item/weapon/gun/projectile/nsfw
	name = "Hephaestus Hydra"
	desc = "The Hydra is a recent product from Hephaestus Industries, offering such a variety of fire modes that combatants will not know what to expect."

	description_info = "The Hydra is an energy weapon that uses various special Hydra Batteries in its magazine. Each battery has different results, up to three fitting in a magazine. Each battery is good for four shots, adding up to a total of twelve possible shots in a magazine."
	description_fluff = "The Hephaestus Industries \'Hydra\' allows the mercenary on-the-go to change their approach when needed, with only a single weapon."
	description_antag = ""

	icon = 'icons/vore/custom_guns_vr.dmi'
	icon_state = "nsfw"

	icon_override = 'icons/vore/custom_guns_vr.dmi'
	item_state = "gun"

	caliber = "nsfw"

	origin_tech = list(TECH_COMBAT = 7, TECH_MATERIAL = 6, TECH_MAGNETS = 4)

	fire_sound = 'sound/weapons/Taser.ogg'

	load_method = MAGAZINE //Nyeh heh hehhh.
	magazine_type = null
	allowed_magazines = list(/obj/item/ammo_magazine/nsfw_mag)
	handle_casings = HOLD_CASINGS //Don't eject batteries!
	recoil = 0
	var/charge_left = 0
	var/max_charge = 0
	charge_sections = 5

/obj/item/weapon/gun/projectile/nsfw/consume_next_projectile()
	if(chambered && ammo_magazine)
		var/obj/item/ammo_casing/nsfw_batt/batt = chambered
		if(batt.shots_left)
			return new chambered.projectile_type()
		else
			for(var/B in ammo_magazine.stored_ammo)
				var/obj/item/ammo_casing/nsfw_batt/other_batt = B
				if(istype(other_batt,chambered.type) && other_batt.shots_left)
					switch_to(other_batt)
					return new chambered.projectile_type()
					break

	return null

/obj/item/weapon/gun/projectile/nsfw/proc/update_charge()
	charge_left = 0
	max_charge = 0

	if(!chambered)
		return

	var/obj/item/ammo_casing/nsfw_batt/batt = chambered

	charge_left = batt.shots_left
	max_charge = initial(batt.shots_left)
	if(ammo_magazine) //Crawl to find more
		for(var/B in ammo_magazine.stored_ammo)
			var/obj/item/ammo_casing/nsfw_batt/bullet = B
			if(istype(bullet,batt.type))
				charge_left += bullet.shots_left
				max_charge += initial(bullet.shots_left)

/obj/item/weapon/gun/projectile/nsfw/proc/switch_to(obj/item/ammo_casing/nsfw_batt/new_batt)
	if(ishuman(loc))
		if(chambered && new_batt.type == chambered.type)
			to_chat(loc,"<span class='warning'>\The [src] is now using the next [new_batt.type_name] power cell.</span>")
		else
			to_chat(loc,"<span class='warning'>\The [src] is now firing [new_batt.type_name].</span>")

	chambered = new_batt
	update_charge()
	update_icon()

/obj/item/weapon/gun/projectile/nsfw/attack_self(mob/user)
	if(!chambered)
		return

	var/list/stored_ammo = ammo_magazine.stored_ammo

	if(stored_ammo.len == 1)
		return //silly you.

	//Find an ammotype that ISN'T the same, or exhaust the list and don't change.
	var/our_slot = stored_ammo.Find(chambered)

	for(var/index in 1 to stored_ammo.len)
		var/true_index = ((our_slot + index - 1) % stored_ammo.len) + 1 // Stupid ONE BASED lists!
		var/obj/item/ammo_casing/nsfw_batt/next_batt = stored_ammo[true_index]
		if(chambered != next_batt && !istype(next_batt, chambered.type))
			switch_to(next_batt)
			break
/*
/obj/item/weapon/gun/projectile/nsfw/special_check(mob/user)
	if(!chambered)
		return

	var/obj/item/ammo_casing/nsfw_batt/batt = chambered
	if(!batt.shots_left)
		return FALSE

	return TRUE
*/
/obj/item/weapon/gun/projectile/nsfw/load_ammo(var/obj/item/A, mob/user)
	. = ..()
	if(ammo_magazine && ammo_magazine.stored_ammo.len)
		switch_to(ammo_magazine.stored_ammo[1])

/obj/item/weapon/gun/projectile/nsfw/unload_ammo(mob/user, var/allow_dump=1)
	chambered = null
	return ..()

/obj/item/weapon/gun/projectile/nsfw/update_icon()
	update_charge()

	cut_overlays()
	if(!chambered)
		return

	var/obj/item/ammo_casing/nsfw_batt/batt = chambered
	var/batt_color = batt.type_color //Used many times

	//Mode bar
	var/image/mode_bar = image(icon, icon_state = "[initial(icon_state)]_type")
	mode_bar.color = batt_color
	add_overlay(mode_bar)

	//Barrel color
	var/image/barrel_color = image(icon, icon_state = "[initial(icon_state)]_barrel")
	barrel_color.alpha = 150
	barrel_color.color = batt_color
	add_overlay(barrel_color)

	//Charge bar
	var/ratio = Ceiling((charge_left / max_charge) * charge_sections)
	for(var/i = 0, i < ratio, i++)
		var/image/charge_bar = image(icon, icon_state = "[initial(icon_state)]_charge")
		charge_bar.pixel_x = i
		charge_bar.color = batt_color
		add_overlay(charge_bar)

// The Magazine //
/obj/item/ammo_magazine/nsfw_mag
	name = "hydra battery magazine"
	desc = "A microbattery holder for the \'Hydra\'"

	description_info = "This magazine holds Hydra microbatteries. Up to three can be loaded at once, each providing four shots. Hydra microbatteries are rechargeable."
	icon = 'icons/obj/ammo_vr.dmi'
	icon_state = "nsfw_mag"
	caliber = "nsfw"
	matter = list(DEFAULT_WALL_MATERIAL = 1680, "glass" = 2000)
	ammo_type = /obj/item/ammo_casing/nsfw_batt
	initial_ammo = 0
	max_ammo = 3
	mag_type = MAGAZINE

	var/list/modes = list()

/obj/item/ammo_magazine/nsfw_mag/update_icon()
	cut_overlays()
	if(!stored_ammo.len)
		return //Why bother

	var/x_offset = 5
	var/current = 0
	for(var/B in stored_ammo)
		var/obj/item/ammo_casing/nsfw_batt/batt = B
		var/image/cap = image(icon, icon_state = "[initial(icon_state)]_cap")
		cap.color = batt.type_color
		cap.pixel_x = current * x_offset //Caps don't need a pixel_y offset
		add_overlay(cap)

		if(batt.shots_left)
			var/ratio = Ceiling((batt.shots_left / initial(batt.shots_left)) * 4) //4 is how many lights we have a sprite for
			var/image/charge = image(icon, icon_state = "[initial(icon_state)]_charge-[ratio]")
			charge.color = "#29EAF4" //Could use battery color but eh.
			charge.pixel_x = current * x_offset
			add_overlay(charge)

		current++ //Increment for offsets

// The Casing //
/obj/item/ammo_casing/nsfw_batt
	name = "Hydra microbattery - UNKNOWN"
	desc = "A miniature battery for an energy weapon."
	icon = 'icons/obj/ammo_vr.dmi'
	icon_state = "nsfw_batt"
	flags = CONDUCT
	slot_flags = SLOT_BELT | SLOT_EARS
	throwforce = 1
	w_class = ITEMSIZE_TINY

	leaves_residue = 0
	caliber = "nsfw"
	var/shots_left = 4
	var/type_color = null
	var/type_name = null
	projectile_type = /obj/item/projectile/beam

/obj/item/ammo_casing/nsfw_batt/initialize()
	. = ..()
	pixel_x = rand(-10, 10)
	pixel_y = rand(-10, 10)
	update_icon()

/obj/item/ammo_casing/nsfw_batt/update_icon()
	cut_overlays()

	var/image/ends = image(icon, icon_state = "[initial(icon_state)]_ends")
	ends.color = type_color
	add_overlay(ends)

/obj/item/ammo_casing/nsfw_batt/expend()
	shots_left--

// Specific batteries //
/obj/item/ammo_casing/nsfw_batt/lethal
	name = "Hydra microbattery - LETHAL"
	type_color = "#bf3d3d"
	type_name = "<span style='color:#bf3d3d;font-weight:bold;'>LETHAL</span>"
	projectile_type = /obj/item/projectile/beam

/obj/item/ammo_casing/nsfw_batt/stun
	name = "Hydra microbattery - STUN"
	type_color = "#0f81bc"
	type_name = "<span style='color:#0f81bc;font-weight:bold;'>STUN</span>"
	projectile_type = /obj/item/projectile/beam/stun/blue

/obj/item/ammo_casing/nsfw_batt/net
	name = "Hydra microbattery - NET"
	type_color = "#43f136"
	type_name = "<span style='color:#43d136;font-weight:bold;'>NET</span>"
	projectile_type = /obj/item/projectile/beam/energy_net

/obj/item/ammo_casing/nsfw_batt/xray
	name = "Hydra microbattery - XRAY"
	type_color = "#32c025"
	type_name = "<span style='color:#32c025;font-weight:bold;'>XRAY</span>"
	projectile_type = /obj/item/projectile/beam/xray

/obj/item/ammo_casing/nsfw_batt/shotstun
	name = "Hydra microbattery - SCATTERSTUN"
	type_color = "#88ffff"
	type_name = "<span style='color:#88ffff;font-weight:bold;'>SCATTERSTUN</span>"
	projectile_type = /obj/item/projectile/bullet/pellet/e_shot_stun

/obj/item/projectile/bullet/pellet/e_shot_stun
	icon_state = "spell"
	damage = 2
	agony = 20
	pellets = 6			//number of pellets
	range_step = 2		//projectile will lose a fragment each time it travels this distance. Can be a non-integer.
	base_spread = 90	//lower means the pellets spread more across body parts. If zero then this is considered a shrapnel explosion instead of a shrapnel cone
	spread_step = 10
	embed_chance = 0
	sharp = 0
	check_armour = "melee"

/obj/item/ammo_casing/nsfw_batt/ion
	name = "Hydra microbattery - ION"
	type_color = "#d084d6"
	type_name = "<span style='color:#d084d6;font-weight:bold;'>ION</span>"
	projectile_type = /obj/item/projectile/ion/small

/obj/item/ammo_casing/nsfw_batt/stripper
	name = "Hydra microbattery - STRIPPER"
	type_color = "#fc8d0f"
	type_name = "<span style='color:#fc8d0f;font-weight:bold;'>STRIPPER</span>"
	projectile_type = /obj/item/projectile/bullet/stripper

/obj/item/projectile/bullet/stripper
	icon_state = "magicm"
	nodamage = 1
	agony = 5
	embed_chance = 0
	sharp = 0
	check_armour = "melee"

/obj/item/projectile/bullet/stripper/on_hit(var/atom/stripped)
	if(ishuman(stripped))
		var/mob/living/carbon/human/H = stripped
		if(H.wear_suit)
			H.unEquip(H.wear_suit)
		if(H.w_uniform)
			H.unEquip(H.w_uniform)
		if(H.back)
			H.unEquip(H.back)
		if(H.shoes)
			H.unEquip(H.shoes)
		if(H.gloves)
			H.unEquip(H.gloves)
		//Hats can stay! Most other things fall off with removing these.
	..()

/obj/item/ammo_casing/nsfw_batt/final
	name = "Hydra microbattery - FINAL OPTION"
	type_color = "#fcfc0f"
	type_name = "<span style='color:#000000;font-weight:bold;'>FINAL OPTION</span>" //Doesn't look good in yellow in chat
	projectile_type = /obj/item/projectile/beam/final_option

/obj/item/projectile/beam/final_option
	name = "final option beam"
	icon_state = "omnilaser"
	nodamage = 1
	agony = 5
	damage_type = HALLOSS
	light_color = "#00CC33"

	muzzle_type = /obj/effect/projectile/laser_omni/muzzle
	tracer_type = /obj/effect/projectile/laser_omni/tracer
	impact_type = /obj/effect/projectile/laser_omni/impact

/obj/item/projectile/beam/final_option/on_hit(var/atom/impacted)
	if(isliving(impacted))
		var/mob/living/L = impacted
		if(L.mind)
			var/nif
			if(ishuman(L))
				var/mob/living/carbon/human/H = L
				nif = H.nif
			SStranscore.m_backup(L.mind,nif,one_time = TRUE)
		L.gib()

	..()
/*
/obj/item/ammo_casing/nsfw_batt/shrink
	name = "\'NSFW\' microbattery - SHRINK"
	type_color = "#910ffc"
	type_name = "<span style='color:#910ffc;font-weight:bold;'>SHRINK</span>"
	projectile_type = /obj/item/projectile/beam/shrinklaser

/obj/item/ammo_casing/nsfw_batt/grow
	name = "\'NSFW\' microbattery - GROW"
	type_color = "#fc0fdc"
	type_name = "<span style='color:#fc0fdc;font-weight:bold;'>GROW</span>"
	projectile_type = /obj/item/projectile/beam/growlaser
*/
/obj/item/weapon/storage/secure/briefcase/nsfw_pack
	name = "\improper Hephaestus Hydra gun kit"
	desc = "A gun case for the Hephaestus Hydra."
	max_w_class = ITEMSIZE_NORMAL

/obj/item/weapon/storage/secure/briefcase/nsfw_pack/New()
	..()
	new /obj/item/weapon/gun/projectile/nsfw(src)
	new /obj/item/ammo_magazine/nsfw_mag(src)
	for(var/path in subtypesof(/obj/item/ammo_casing/nsfw_batt))
		new path(src)

/obj/item/weapon/storage/secure/briefcase/nsfw_pack_hos
	name = "\improper Hephaestus Hydra gun kit"
	desc = "A gun case for the Hephaestus Hydra."
	max_w_class = ITEMSIZE_NORMAL

/obj/item/weapon/storage/secure/briefcase/nsfw_pack_hos/New()
	..()
	new /obj/item/weapon/gun/projectile/nsfw(src)
	new /obj/item/ammo_magazine/nsfw_mag(src)
	new /obj/item/ammo_casing/nsfw_batt/lethal(src)
	new /obj/item/ammo_casing/nsfw_batt/lethal(src)
	new /obj/item/ammo_casing/nsfw_batt/stun(src)
	new /obj/item/ammo_casing/nsfw_batt/stun(src)
	new /obj/item/ammo_casing/nsfw_batt/net(src)
	new /obj/item/ammo_casing/nsfw_batt/ion(src)

