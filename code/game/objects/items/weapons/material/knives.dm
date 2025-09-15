/obj/item/material/butterfly
	name = "butterfly knife"
	desc = "A basic metal blade concealed in a lightweight plasteel grip. Small enough when folded to fit in a pocket."
	icon_state = "butterflyknife"
	item_state = null
	attack_sound = null
	w_class = WEIGHT_CLASS_SMALL
	attack_verb = list("patted", "tapped")
	force_multiplier = 0.1
	throw_force_multiplier = 1.5
	drop_sound = 'sound/items/drop/knife.ogg'
	pickup_sound = 'sound/items/pickup/knife.ogg'
	var/active = FALSE

/obj/item/material/butterfly/proc/set_active(active)
	src.active = active
	if(active)
		damage_mode = DAMAGE_MODE_EDGE | DAMAGE_MODE_SHARP
		attack_sound = 'sound/weapons/bladeslice.ogg'
		force_multiplier = 1
		icon_state += "_open"
		set_weight_class(WEIGHT_CLASS_NORMAL)
	else
		damage_mode = initial(damage_mode)
		attack_sound = initial(attack_sound)
		icon_state = initial(icon_state)
		set_weight_class(initial(w_class))
		attack_verb = initial(attack_verb)
		force_multiplier = initial(force_multiplier)
	update_material_parts()

/obj/item/material/butterfly/switchblade
	name = "switchblade"
	desc = "A classic switchblade with gold engraving. Just holding it makes you feel like a gangster."
	icon_state = "switchblade"

/obj/item/material/butterfly/butterfly_golden
	name = "gold-plated balisong"
	desc = "An exquisite, gold-plated butterfly knife. The centerpiece of any aspiring knife collector's showcase."
	icon_state = "butterflyknife_gold"
	material_color = 0

/obj/item/material/butterfly/butterfly_wooden
	name = "wood-handled butterfly knife"
	desc = "A concealable butterlfly knife with an ornate, wooden handle. Requires far too much care to use more than once."
	icon_state = "butterflyknife_wooden"
	material_color = 0

/obj/item/material/butterfly/boxcutter
	name = "box cutter"
	desc = "A thin, inexpensive razor-blade knife designed to open cardboard boxes."
	icon_state = "boxcutter"
	material_significance = MATERIAL_SIGNIFICANCE_WEAPON_ULTRALIGHT

/obj/item/material/butterfly/attack_self(mob/user, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	set_active(!active)
	if(active)
		to_chat(user, "<span class='notice'>You flip out \the [src].</span>")
		playsound(user, 'sound/weapons/flipblade.ogg', 15, 1)
	else
		to_chat(user, "<span class='notice'>\The [src] can now be concealed.</span>")
	add_fingerprint(user)

/*
 * Kitchen knives
 */
/obj/item/material/knife
	name = "kitchen knife"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "knife"
	desc = "A general purpose chef's knife. Glithari Exports filet knives, Centauri bread knives, all pale in comparison to Nanotrasen's very own Cookware line of cheap, affordable chef's knives."
	damage_mode = DAMAGE_MODE_SHARP | DAMAGE_MODE_EDGE
	material_significance = MATERIAL_SIGNIFICANCE_WEAPON_LIGHT
	materials_base = list(MAT_STEEL = 12000)
	origin_tech = list(TECH_MATERIAL = 1)
	attack_verb = list("slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")

// These no longer inherit from hatchets.
/obj/item/material/knife/tacknife
	name = "tactical knife"
	desc = "A knife with a sturdy steel blade and a matte-black handle. The maker's mark is worn out; you can faintly make out an 'S'."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "tacknife"
	item_state = "knife"
	material_primary = "blade"
	material_significance = MATERIAL_SIGNIFICANCE_WEAPON_LIGHT
	damage_mode = DAMAGE_MODE_SHARP | DAMAGE_MODE_EDGE
	attack_verb = list("stabbed", "chopped", "cut")
	material_color = TRUE

/obj/item/material/knife/tacknife/combatknife
	name = "combat knife"
	desc = "A reliable-looking knife. The blade's thin enough to slide into your boot, or between somebody's ribs."
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "buckknife"
	item_state = "knife"
	material_significance = MATERIAL_SIGNIFICANCE_WEAPON_LIGHT
	force_multiplier = 1.2
	attack_verb = list("sliced", "stabbed", "chopped", "cut")
	material_color = TRUE

/obj/item/material/knife/stiletto
	name = "stiletto knife"
	desc = "A fancy-looking, thin bladed dagger designed to be stashed somewhere close to the body. Very lethal. Very illegal."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "stiletto"
	item_state = "knife"
	material_significance = MATERIAL_SIGNIFICANCE_WEAPON_ULTRALIGHT
	damage_mode = DAMAGE_MODE_SHARP | DAMAGE_MODE_PIERCE
	attack_verb = list("stabbed", "shanked", "punctured", "impaled", "skewered")
	material_color = TRUE

/obj/item/material/knife/tacknife/combatknife/bone
	icon_state = "boneknife"
	material_parts = /datum/prototype/material/bone

// Identical to the tactical knife but nowhere near as stabby.
// Kind of like the toy esword compared to the real thing.
/obj/item/material/knife/tacknife/boot
	name = "boot knife"
	desc = "A small fixed-blade knife for putting inside a boot."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "tacknife"
	item_state = "knife"
	material_color = 0

/obj/item/material/knife/hook
	name = "meat hook"
	desc = "Used for stringing up butchered animals, or a surprise stabbing implemant."
	icon_state = "hook_knife"

/obj/item/material/knife/ritual
	name = "ritual knife"
	desc = "The unearthly energies that once powered this blade are now dormant."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "render"
	material_color = 0

/obj/item/material/knife/butch
	name = "butcher's cleaver"
	icon_state = "butch"
	desc = "Another fine product from Nanotrasen's Cookware line. The heavy head and grooved grip makes chopping meat a breeze."
	material_significance = MATERIAL_SIGNIFICANCE_WEAPON_HEAVY
	attack_verb = list("cleaved", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	force_multiplier = 1.15

/obj/item/material/knife/machete
	name = "machete"
	desc = "A sharp machete often found in survival kits."
	icon_state = "machete"
	attack_verb = list("slashed", "chopped", "gouged", "ripped", "cut")
	can_cleave = TRUE //Now hatchets inherit from the machete, and thus knives. Tables turned.
	slot_flags = SLOT_BELT | SLOT_HOLSTER
	material_significance = MATERIAL_SIGNIFICANCE_WEAPON_HEAVY
	material_parts = /datum/prototype/material/plasteel
	force_multiplier = 1.3

/obj/item/material/knife/machete/armblade
	name = "arm-mounted blade"
	desc = "A long, machete-like blade, mounted to your arm. Courtesy of Hephaestus, this machete is ideal for parrying blows."
	icon_state = "armblade"
	item_state = "armblade"
	slot_flags = NONE

	passive_parry = /datum/passive_parry{
		parry_chance_projectile = 0;
		parry_chance_default = 33;
	}

/obj/item/material/knife/machete/armblade/hardsuit
	var/obj/item/hardsuit_module/armblade/storing_module

/obj/item/material/knife/machete/armblade/hardsuit/dropped(mob/user, flags, atom/newLoc)
	. = ..()
	if(storing_module)
		src.forceMove(storing_module)
		user.visible_message(
			"<span class='notice'>[user] retracts [src], folding it away with a click and a hiss.</span>",
			"<span class='notice'>You retract [src], folding it away with a click and a hiss.</span>",
			"<span class='notice'>You hear a threatening click and a hiss.</span>"
			)
		playsound(src, 'sound/items/helmetdeploy.ogg', 40, 1)
	else
		to_chat(user, "Something fucked up and the armblade got out of a module. Please report this bug.")
		qdel(src)

/obj/item/material/knife/tacknife/survival
	name = "streamlined survival knife"
	desc = "A hunting grade survival knife. The bulky storage handle has been replaced with a sleek grip and the ability to easily upgrade the blade."
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "survivalknife"
	item_state = "knife"
	material_color = FALSE
	material_parts = /datum/prototype/material/plasteel
	tool_speed = 2 // Use a real axe if you want to chop logs.

/obj/item/material/knife/tacknife/survival/bone
	name = "primitive survival knife"
	desc = "A hunting grade survival knife with a sleek leather grip."
	material_parts = /datum/prototype/material/bone

/obj/item/material/knife/machete/deluxe
	name = "deluxe machete"
	desc = "A fine example of a machete, with a polished blade, wooden handle and a leather cord loop."
	icon = 'icons/obj/weapons_vr.dmi'
	icon_state = "machetedx"
	item_state = "machete"

// Knife Material Variants
/obj/item/material/butterfly/plasteel
	material_parts = /datum/prototype/material/plasteel

/obj/item/material/butterfly/durasteel
	material_parts = /datum/prototype/material/durasteel

/obj/item/material/butterfly/switchblade/plasteel
	material_parts = /datum/prototype/material/plasteel

/obj/item/material/butterfly/switchblade/durasteel
	material_parts = /datum/prototype/material/durasteel

/obj/item/material/butterfly/boxcutter/plasteel
	material_parts = /datum/prototype/material/plasteel

/obj/item/material/butterfly/boxcutter/durasteel
	material_parts = /datum/prototype/material/durasteel

/obj/item/material/knife/tacknife/plasteel
	material_parts = /datum/prototype/material/plasteel

/obj/item/material/knife/tacknife/durasteel
	material_parts = /datum/prototype/material/durasteel

/obj/item/material/knife/tacknife/combatknife/plasteel
	material_parts = /datum/prototype/material/plasteel

/obj/item/material/knife/tacknife/combatknife/durasteel
	material_parts = /datum/prototype/material/durasteel

/obj/item/material/knife/hook/plasteel
	material_parts = /datum/prototype/material/plasteel

/obj/item/material/knife/hook/durasteel
	material_parts = /datum/prototype/material/durasteel

/obj/item/material/knife/ritual/plasteel
	material_parts = /datum/prototype/material/plasteel

/obj/item/material/knife/ritual/durasteel
	material_parts = /datum/prototype/material/durasteel

/obj/item/material/knife/butch/plasteel
	material_parts = /datum/prototype/material/plasteel

/obj/item/material/knife/butch/durasteel
	material_parts = /datum/prototype/material/durasteel

/obj/item/material/knife/machete/durasteel
	material_parts = /datum/prototype/material/durasteel

/obj/item/material/knife/machete/deluxe/durasteel
	material_parts = /datum/prototype/material/durasteel

/obj/item/material/knife/tacknife/survival/durasteel
	material_parts = /datum/prototype/material/durasteel
