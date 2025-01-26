// The Casing //
/obj/item/ammo_casing/microbattery/combat
	name = "\'Hydra\' microbattery - UNKNOWN"
	desc = "A miniature battery for an energy weapon."
	//catalogue_data = list(/datum/category_item/catalogue/information/organization/nanotrasen)
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 1, TECH_MAGNETS = 2)

/obj/item/ammo_casing/microbattery/combat/lethal
	name = "\'Hydra\' microbattery - LETHAL"
	type_color = "#bf3d3d"
	type_name = "<span style='color:#bf3d3d;font-weight:bold;'>LETHAL</span>"
	projectile_type = /obj/projectile/beam

/obj/item/ammo_casing/microbattery/combat/stun
	name = "\'Hydra\' microbattery - STUN"
	type_color = "#0f81bc"
	type_name = "<span style='color:#0f81bc;font-weight:bold;'>STUN</span>"
	projectile_type = /obj/projectile/beam/stun/blue

/obj/item/ammo_casing/microbattery/combat/net
	name = "\'Hydra\' microbattery - NET"
	type_color = "#43f136"
	type_name = "<span style='color:#43d136;font-weight:bold;'>NET</span>"
	projectile_type = /obj/projectile/beam/energy_net

/obj/item/ammo_casing/microbattery/combat/xray
	name = "\'Hydra\' microbattery - XRAY"
	type_color = "#32c025"
	type_name = "<span style='color:#32c025;font-weight:bold;'>XRAY</span>"
	projectile_type = /obj/projectile/beam/xray

/obj/item/ammo_casing/microbattery/combat/shotstun
	name = "\'Hydra\' microbattery - SCATTERSTUN"
	type_color = "#88ffff"
	type_name = "<span style='color:#88ffff;font-weight:bold;'>SCATTERSTUN</span>"
	projectile_type = /obj/projectile/bullet/pellet/e_shot_stun

/obj/projectile/bullet/pellet/e_shot_stun
	icon_state = "spell"
	damage_force = 2
	agony = 20
	pellets = 6			//number of pellets
	embed_chance = 0
	damage_mode = NONE
	damage_flag = ARMOR_MELEE

/obj/item/ammo_casing/microbattery/combat/ion
	name = "\'Hydra\' microbattery - ION"
	type_color = "#d084d6"
	type_name = "<span style='color:#d084d6;font-weight:bold;'>ION</span>"
	projectile_type = /obj/projectile/ion/small

/obj/item/ammo_casing/microbattery/combat/stripper
	name = "\'Hydra\' microbattery - STRIPPER"
	type_color = "#fc8d0f"
	type_name = "<span style='color:#fc8d0f;font-weight:bold;'>STRIPPER</span>"
	projectile_type = /obj/projectile/bullet/stripper

/obj/projectile/bullet/stripper
	icon_state = "magicm"
	nodamage = 1
	agony = 5
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

/obj/item/ammo_casing/microbattery/combat/final
	name = "\'Hydra\' microbattery - FINAL OPTION"
	type_color = "#fcfc0f"
	type_name = "<span style='color:#000000;font-weight:bold;'>FINAL OPTION</span>" //Doesn't look good in yellow in chat
	projectile_type = /obj/projectile/beam/final_option

/obj/projectile/beam/final_option
	name = "final option beam"
	icon_state = "omnilaser"
	nodamage = 1
	agony = 5
	damage_type = DAMAGE_TYPE_HALLOSS
	light_color = "#00CC33"

	legacy_muzzle_type = /obj/effect/projectile/muzzle/laser_omni
	legacy_tracer_type = /obj/effect/projectile/tracer/laser_omni
	legacy_impact_type = /obj/effect/projectile/impact/laser_omni

/obj/projectile/beam/final_option/on_impact(atom/target, impact_flags, def_zone, efficiency)
	. = ..()
	if(. & PROJECTILE_IMPACT_FLAGS_UNCONDITIONAL_ABORT)
		return

	if(isliving(impacted))
		var/mob/living/L = impacted
		if(L.mind)
			var/nif
			if(ishuman(L))
				var/mob/living/carbon/human/H = L
				nif = H.nif
			SStranscore.m_backup(L.mind,nif,one_time = TRUE)
		L.gib()
