// todo: rework all of this shit, jfc
/obj/item/gun/projectile/ballistic/microbattery
	name = "multipurpose cell-loaded revolver"
	desc = "Variety is the spice of life! This weapon is a hybrid of the NT-102b 'Nanotech Selectable-Fire Weapon' and the Vey-Med ML-3 'Medigun', dubbed the 'NSFW-ML3M'. \
	It can fire both harmful and healing cells with an internal nanite fabricator and energy weapon cell loader. Up to three combinations of \
	energy beams can be configured at once. Ammo not included."
	//catalogue_data = list(/datum/category_item/catalogue/information/organization/nanotrasen)

	icon = 'icons/vore/custom_guns_vr.dmi'
	icon_state = "nsfw"

	icon_override = 'icons/vore/custom_guns_vr.dmi'
	item_state = "gun"

	origin_tech = list(TECH_COMBAT = 7, TECH_MATERIAL = 6, TECH_MAGNETS = 4)

	fire_sound = 'sound/weapons/Taser.ogg'

	load_method = MAGAZINE //Nyeh heh hehhh.
	magazine_type = null
	allowed_magazines = list(/obj/item/ammo_magazine/microbattery)
	caliber = /datum/ammo_caliber/microbattery
	handle_casings = HOLD_CASINGS //Don't eject batteries!
	recoil = 0
	var/charge_left = 0
	var/max_charge = 0
	charge_sections = 5

/obj/item/gun/projectile/ballistic/microbattery/consume_next_projectile(datum/gun_firing_cycle/cycle)
	if(chambered && ammo_magazine)
		var/obj/item/ammo_casing/microbattery/batt = chambered
		if(batt.shots_left)
			return new chambered.projectile_type()
		else
			for(var/B in ammo_magazine.ammo_internal)
				var/obj/item/ammo_casing/microbattery/other_batt = B
				if(istype(other_batt,chambered.type) && other_batt.shots_left)
					switch_to(other_batt)
					return new chambered.projectile_type()

/obj/item/gun/projectile/ballistic/microbattery/proc/update_charge()
	charge_left = 0
	max_charge = 0

	if(!chambered)
		return

	var/obj/item/ammo_casing/microbattery/batt = chambered

	charge_left = batt.shots_left
	max_charge = initial(batt.shots_left)
	if(ammo_magazine) //Crawl to find more
		for(var/B in ammo_magazine.ammo_internal)
			var/obj/item/ammo_casing/microbattery/bullet = B
			if(istype(bullet,batt.type))
				charge_left += bullet.shots_left
				max_charge += initial(bullet.shots_left)

/obj/item/gun/projectile/ballistic/microbattery/proc/switch_to(obj/item/ammo_casing/microbattery/new_batt)
	if(ishuman(loc))
		if(chambered && new_batt.type == chambered.type)
			to_chat(loc,"<span class='warning'>\The [src] is now using the next [new_batt.type_name] power cell.</span>")
		else
			to_chat(loc,"<span class='warning'>\The [src] is now firing [new_batt.type_name].</span>")

	chambered = new_batt
	update_charge()
	update_icon()

/obj/item/gun/projectile/ballistic/microbattery/attack_self(mob/user, datum/event_args/actor/actor)
	if(!chambered)
		return

	var/list/ammo_internal = ammo_magazine.ammo_internal

	if(ammo_internal.len == 1)
		return //silly you.

	//Find an ammotype that ISN'T the same, or exhaust the list and don't change.
	var/our_slot = ammo_internal.Find(chambered)

	for(var/index in 1 to ammo_internal.len)
		var/true_index = ((our_slot + index - 1) % ammo_internal.len) + 1 // Stupid ONE BASED lists!
		var/obj/item/ammo_casing/microbattery/next_batt = ammo_internal[true_index]
		if(chambered != next_batt && !istype(next_batt, chambered.type))
			switch_to(next_batt)
			break

/obj/item/gun/projectile/ballistic/microbattery/load_ammo(var/obj/item/A, mob/user)
	. = ..()
	if(ammo_magazine && ammo_magazine.amount_remaining())
		switch_to(ammo_magazine.ammo_internal[1])

/obj/item/gun/projectile/ballistic/microbattery/unload_ammo(mob/user, var/allow_dump=1)
	chambered = null
	return ..()

/obj/item/gun/projectile/ballistic/microbattery/update_overlays()
	. = ..()

	update_charge()

	if(!chambered)
		return

	var/obj/item/ammo_casing/microbattery/batt = chambered
	var/batt_color = batt.type_color //Used many times

	//Mode bar
	var/image/mode_bar = image(icon, icon_state = "[initial(icon_state)]_type")
	mode_bar.color = batt_color
	. += mode_bar

	//Barrel color
	var/image/barrel_color = image(icon, icon_state = "[initial(icon_state)]_barrel")
	barrel_color.alpha = 150
	barrel_color.color = batt_color
	. += barrel_color

	//Charge bar
	var/ratio = CEILING(((charge_left / max_charge) * charge_sections), 1)
	for(var/i = 0, i < ratio, i++)
		var/image/charge_bar = image(icon, icon_state = "[initial(icon_state)]_charge")
		charge_bar.pixel_x = i
		charge_bar.color = batt_color
		. += charge_bar



// The Pack //
/obj/item/storage/secure/briefcase/nsfw_pack_hybrid
	name = "hybrid cell-loaded gun kit"
	desc = "A storage case for a multi-purpose handgun. Variety hour!"
	w_class = WEIGHT_CLASS_NORMAL
	max_single_weight_class = WEIGHT_CLASS_NORMAL

/obj/item/storage/secure/briefcase/nsfw_pack_hybrid/legacy_spawn_contents()
	new /obj/item/gun/projectile/ballistic/microbattery(src)
	new /obj/item/ammo_magazine/microbattery/advanced(src)
	new /obj/item/ammo_casing/microbattery/combat/stun(src)
	new /obj/item/ammo_casing/microbattery/combat/stun(src)
	new /obj/item/ammo_casing/microbattery/combat/stun(src)
	new /obj/item/ammo_casing/microbattery/combat/net(src)
	new /obj/item/ammo_casing/microbattery/combat/net(src)
	new /obj/item/ammo_casing/microbattery/medical/brute3(src)
	new /obj/item/ammo_casing/microbattery/medical/burn3(src)
	new /obj/item/ammo_casing/microbattery/medical/stabilize2(src)
	new /obj/item/ammo_casing/microbattery/medical/toxin3(src)
	new /obj/item/ammo_casing/microbattery/medical/omni3(src)

/obj/item/storage/secure/briefcase/nsfw_pack_hybrid_combat
	name = "military cell-loaded gun kit"
	desc = "A storage case for a multi-purpose handgun. Variety hour!"
	w_class = WEIGHT_CLASS_NORMAL
	max_single_weight_class = WEIGHT_CLASS_NORMAL

/obj/item/storage/secure/briefcase/nsfw_pack_hybrid_combat/legacy_spawn_contents()
	new /obj/item/gun/projectile/ballistic/microbattery(src)
	new /obj/item/ammo_magazine/microbattery/advanced(src)
	new /obj/item/ammo_casing/microbattery/combat/shotstun(src)
	new /obj/item/ammo_casing/microbattery/combat/shotstun(src)
	new /obj/item/ammo_casing/microbattery/combat/lethal(src)
	new /obj/item/ammo_casing/microbattery/combat/lethal(src)
	new /obj/item/ammo_casing/microbattery/combat/lethal(src)
	new /obj/item/ammo_casing/microbattery/combat/ion(src)
	new /obj/item/ammo_casing/microbattery/combat/xray(src)
	new /obj/item/ammo_casing/microbattery/medical/stabilize2(src)
	new /obj/item/ammo_casing/microbattery/medical/haste(src)
	new /obj/item/ammo_casing/microbattery/medical/resist(src)
