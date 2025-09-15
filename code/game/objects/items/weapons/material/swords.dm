/obj/item/material/sword
	name = "claymore"
	desc = "From the former island nation of Britain, comes this enduring design. The claymore's long, heavy blade rewards large sweeping strikes, provided one can even lift this heavy weapon."
	icon_state = "claymore"
	slot_flags = SLOT_BELT
	material_significance = MATERIAL_SIGNIFICANCE_WEAPON_HEAVY
	damage_mode = DAMAGE_MODE_SHARP | DAMAGE_MODE_EDGE
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	attack_sound = 'sound/weapons/bladeslice.ogg'
	drop_sound = 'sound/items/drop/sword.ogg'
	pickup_sound = 'sound/items/pickup/sword.ogg'
	force_multiplier = 1.5

	passive_parry = /datum/passive_parry/melee{
		parry_chance_default = 50;
		parry_chance_projectile = 10;
	}

/obj/item/material/sword/plasteel
	material_parts = /datum/prototype/material/plasteel

/obj/item/material/sword/durasteel
	material_parts = /datum/prototype/material/durasteel

/obj/item/material/sword/katana
	name = "katana"
	desc = "An ancient Terran weapon, from a former island nation. This sharp blade requires skill to use properly. Despite the number of flash-forged knock-offs flooding the market, this looks like the real deal."
	icon_state = "katana"
	slot_flags = SLOT_BELT | SLOT_BACK

/obj/item/material/sword/katana/plasteel
	material_parts = /datum/prototype/material/plasteel

/obj/item/material/sword/katana/durasteel
	material_parts = /datum/prototype/material/durasteel

/obj/item/material/sword/sabre
	name = "officer's sabre"
	desc = "An elegant weapon, its monomolecular edge is capable of cutting through flesh and bone with ease."
	attack_sound = "swing_hit"
	icon_state = "sabre"
	attack_sound = 'sound/weapons/rapierhit.ogg'
	pickup_sound = 'sound/items/pickup/knife.ogg'
	drop_sound = 'sound/items/drop/knife.ogg'
	//initially damage was at 30. Damage now starts at around 25 until someone messes with material code again (hi Sili)
	material_parts = /datum/prototype/material/plasteel
	material_color = FALSE
	origin_tech = list(TECH_COMBAT = 4)
	item_icons = list(
			SLOT_ID_LEFT_HAND = 'icons/mob/items/lefthand_melee.dmi',
			SLOT_ID_RIGHT_HAND = 'icons/mob/items/righthand_melee.dmi',
			)

	passive_parry = /datum/passive_parry/melee{
		parry_chance_default = 50;
	}

// meant to play when unsheathing the blade from the sabre sheath.
// todo: -_- this should be on the sheath
// todo: we need a better way to do unsheath sounds for weapons and storage...
/obj/item/material/sword/sabre/on_enter_storage(datum/object_system/storage/storage)
	. = ..()
	playsound(loc, 'sound/effects/holster/sheathin.ogg', 50, 1)

/obj/item/material/sword/sabre/on_exit_storage(datum/object_system/storage/storage)
	. = ..()
	playsound(loc, 'sound/effects/holster/sheathout.ogg', 50, 1)
