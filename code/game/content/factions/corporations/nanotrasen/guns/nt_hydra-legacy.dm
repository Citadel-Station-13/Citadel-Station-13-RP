/obj/item/storage/secure/briefcase/nsfw_pack
	name = "\improper NT-102b \'Hydra\' gun kit"
	desc = "A storage case for a multi-purpose handgun. Variety hour!"
	w_class = WEIGHT_CLASS_NORMAL
	max_single_weight_class = WEIGHT_CLASS_NORMAL

/obj/item/storage/secure/briefcase/nsfw_pack/legacy_spawn_contents()
	new /obj/item/gun/projectile/ballistic/microbattery/nt_hydra(src)
	new /obj/item/ammo_magazine/microbattery/nt_hydra/advanced(src)
	for(var/path in subtypesof(/obj/item/ammo_casing/microbattery/nt_hydra))
		new path(src)

/obj/item/storage/secure/briefcase/nsfw_pack_hos
	name = "\improper NT-102b \'Hydra\' gun kit"
	desc = "A storage case for a multi-purpose handgun. Variety hour!"
	w_class = WEIGHT_CLASS_NORMAL
	max_single_weight_class = WEIGHT_CLASS_NORMAL

/obj/item/storage/secure/briefcase/nsfw_pack_hos/legacy_spawn_contents()
	new /obj/item/gun/projectile/ballistic/microbattery/nt_hydra(src)
	new /obj/item/ammo_magazine/microbattery/nt_hydra/advanced(src)
	new /obj/item/ammo_casing/microbattery/nt_hydra/lethal(src)
	new /obj/item/ammo_casing/microbattery/nt_hydra/lethal(src)
	new /obj/item/ammo_casing/microbattery/nt_hydra/stun(src)
	new /obj/item/ammo_casing/microbattery/nt_hydra/stun(src)
	new /obj/item/ammo_casing/microbattery/nt_hydra/stun(src)
	new /obj/item/ammo_casing/microbattery/nt_hydra/net(src)
	new /obj/item/ammo_casing/microbattery/nt_hydra/ion(src)

/obj/item/ammo_casing/microbattery/nt_hydra
	name = "\'Hydra\' microbattery - UNKNOWN"
	desc = "A miniature battery for an energy weapon."
	//catalogue_data = list(/datum/category_item/catalogue/information/organization/nanotrasen)
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 1, TECH_MAGNETS = 2)

/obj/item/ammo_casing/microbattery/nt_hydra/lethal
	name = "\'Hydra\' microbattery - LETHAL"
	microbattery_group_key = "lethal"
	microbattery_mode_color = "#bf3d3d"
	microbattery_mode_name = "<span style='color:#bf3d3d;font-weight:bold;'>LETHAL</span>"
	projectile_type = /obj/projectile/beam

/obj/item/ammo_casing/microbattery/nt_hydra/stun
	name = "\'Hydra\' microbattery - STUN"
	microbattery_group_key = "stun"
	microbattery_mode_color = "#0f81bc"
	microbattery_mode_name = "<span style='color:#0f81bc;font-weight:bold;'>STUN</span>"
	projectile_type = /obj/projectile/beam/stun/blue

/obj/item/ammo_casing/microbattery/nt_hydra/net
	name = "\'Hydra\' microbattery - NET"
	microbattery_group_key = "net"
	microbattery_mode_color = "#43f136"
	microbattery_mode_name = "<span style='color:#43d136;font-weight:bold;'>NET</span>"
	projectile_type = /obj/projectile/beam/energy_net

/obj/item/ammo_casing/microbattery/nt_hydra/xray
	name = "\'Hydra\' microbattery - XRAY"
	microbattery_group_key = "xray"
	microbattery_mode_color = "#32c025"
	microbattery_mode_name = "<span style='color:#32c025;font-weight:bold;'>XRAY</span>"
	projectile_type = /obj/projectile/beam/xray

/obj/item/ammo_casing/microbattery/nt_hydra/shotstun
	name = "\'Hydra\' microbattery - SCATTERSTUN"
	microbattery_group_key = "scatterstun"
	microbattery_mode_color = "#88ffff"
	microbattery_mode_name = "<span style='color:#88ffff;font-weight:bold;'>SCATTERSTUN</span>"
	projectile_type = /obj/projectile/bullet/pellet/e_shot_stun

/obj/projectile/bullet/pellet/e_shot_stun
	icon_state = "spell"
	damage_force = 2
	damage_inflict_agony = 20
	pellets = 6			//number of pellets
	embed_chance = 0
	damage_mode = NONE
	damage_flag = ARMOR_MELEE

/obj/item/ammo_casing/microbattery/nt_hydra/ion
	name = "\'Hydra\' microbattery - ION"
	microbattery_group_key = "ion"
	microbattery_mode_color = "#d084d6"
	microbattery_mode_name = "<span style='color:#d084d6;font-weight:bold;'>ION</span>"
	projectile_type = /obj/projectile/ion/small

/obj/item/ammo_casing/microbattery/nt_hydra/stripper
	name = "\'Hydra\' microbattery - STRIPPER"
	microbattery_group_key = "stripper"
	microbattery_mode_color = "#fc8d0f"
	microbattery_mode_name = "<span style='color:#fc8d0f;font-weight:bold;'>STRIPPER</span>"
	projectile_type = /obj/projectile/bullet/stripper

/obj/projectile/bullet/stripper
	icon_state = "magicm"
	nodamage = 1
	damage_inflict_agony = 5
	embed_chance = 0
	damage_mode = NONE
	damage_flag = ARMOR_MELEE

/obj/projectile/bullet/stripper/on_impact(atom/target, impact_flags, def_zone, efficiency)
	. = ..()
	if(. & PROJECTILE_IMPACT_FLAGS_UNCONDITIONAL_ABORT)
		return

	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		if(!H.permit_stripped)
			return
		H.drop_slots_to_ground(list(SLOT_ID_SUIT, SLOT_ID_UNIFORM, SLOT_ID_BACK, SLOT_ID_SHOES, SLOT_ID_GLOVES))
		//Hats can stay! Most other things fall off with removing these.
