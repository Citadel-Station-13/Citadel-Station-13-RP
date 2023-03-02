/obj/item/material/butterfly
	name = "butterfly knife"
	desc = "A basic metal blade concealed in a lightweight plasteel grip. Small enough when folded to fit in a pocket."
	icon_state = "butterflyknife"
	item_state = null
	hitsound = null
	var/active = 0
	w_class = ITEMSIZE_SMALL
	attack_verb = list("patted", "tapped")
	force_divisor = 0.25 // 15 when wielded with hardness 60 (steel)
	thrown_force_divisor = 0.25 // 5 when thrown with weight 20 (steel)
	drop_sound = 'sound/items/drop/knife.ogg'
	pickup_sound = 'sound/items/pickup/knife.ogg'

/obj/item/material/butterfly/update_force()
	if(active)
		edge = 1
		sharp = 1
		..() //Updates force.
		throw_force = max(3,force-3)
		hitsound = 'sound/weapons/bladeslice.ogg'
		icon_state += "_open"
		w_class = ITEMSIZE_NORMAL
		attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	else
		force = 3
		edge = 0
		sharp = 0
		hitsound = initial(hitsound)
		icon_state = initial(icon_state)
		w_class = initial(w_class)
		attack_verb = initial(attack_verb)

/obj/item/material/butterfly/switchblade
	name = "switchblade"
	desc = "A classic switchblade with gold engraving. Just holding it makes you feel like a gangster."
	icon_state = "switchblade"

/obj/item/material/butterfly/butterfly_golden
	name = "gold-plated balisong"
	desc = "An exquisite, gold-plated butterfly knife. The centerpiece of any aspiring knife collector's showcase."
	icon_state = "butterflyknife_gold"
	applies_material_colour = 0

/obj/item/material/butterfly/butterfly_wooden
	name = "wood-handled butterfly knife"
	desc = "A concealable butterlfly knife with an ornate, wooden handle. Requires far too much care to use more than once."
	icon_state = "butterflyknife_wooden"
	applies_material_colour = 0

/obj/item/material/butterfly/boxcutter
	name = "box cutter"
	desc = "A thin, inexpensive razor-blade knife designed to open cardboard boxes."
	icon_state = "boxcutter"
	force_divisor = 0.1 // 6 when wielded with hardness 60 (steel)
	thrown_force_divisor = 0.2 // 4 when thrown with weight 20 (steel)

/obj/item/material/butterfly/attack_self(mob/user)
	active = !active
	if(active)
		to_chat(user, "<span class='notice'>You flip out \the [src].</span>")
		playsound(user, 'sound/weapons/flipblade.ogg', 15, 1)
	else
		to_chat(user, "<span class='notice'>\The [src] can now be concealed.</span>")
	update_force()
	add_fingerprint(user)

/*
 * Kitchen knives
 */
/obj/item/material/knife
	name = "kitchen knife"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "knife"
	desc = "A general purpose chef's knife. Glithari Exports filet knives, Centauri bread knives, all pale in comparison to NanoTrasen's very own Cookware line of cheap, affordable chef's knives." 
	sharp = 1
	edge = 1
	force_divisor = 0.15 // 9 when wielded with hardness 60 (steel)
	matter = list(MAT_STEEL = 12000)
	origin_tech = list(TECH_MATERIAL = 1)
	attack_verb = list("slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")

/obj/item/material/knife/suicide_act(mob/user)
	var/datum/gender/TU = GLOB.gender_datums[user.get_visible_gender()]
	user.visible_message(pick("<span class='danger'>\The [user] is slitting [TU.his] wrists with \the [src]! It looks like [TU.hes] trying to commit suicide.</span>", \
	                      "<span class='danger'>\The [user] is slitting [TU.his] throat with \the [src]! It looks like [TU.hes] trying to commit suicide.</span>", \
	                      "<span class='danger'>\The [user] is slitting [TU.his] stomach open with \the [src]! It looks like [TU.hes] trying to commit seppuku.</span>"))
	return (BRUTELOSS)

// These no longer inherit from hatchets.
/obj/item/material/knife/tacknife
	name = "tactical knife"
	desc = "A knife with a sturdy steel blade and a matte-black handle. The maker's mark is worn out; you can faintly make out an 'S'."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "tacknife"
	item_state = "knife"
	force_divisor = 0.20 //12 when hardness 60 (steel)
	attack_verb = list("stabbed", "chopped", "cut")
	applies_material_colour = 1

/obj/item/material/knife/tacknife/combatknife
	name = "combat knife"
	desc = "A reliable-looking knife. The blade's thin enough to slide into your boot, or between somebody's ribs."
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "buckknife"
	item_state = "knife"
	force_divisor = 0.25 // 15 with hardness 60 (steel)
	thrown_force_divisor = 1.75 // 20 with weight 20 (steel)
	attack_verb = list("sliced", "stabbed", "chopped", "cut")
	applies_material_colour = 1

/obj/item/material/knife/stiletto
	name = "stiletto knife"
	desc = "A fancy-looking, thin bladed dagger designed to be stashed somewhere close to the body. Very lethal. Very illegal."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "stiletto"
	item_state = "knife"
	edge = 0 //Shouldn't be able to remove limbs
	force_divisor = 0.1 //6 when hardness 60 (steel)
	attack_verb = list("stabbed", "shanked", "punctured", "impaled", "skewered")
	applies_material_colour = 1

/obj/item/material/knife/tacknife/combatknife/bone
	icon_state = "boneknife"
	default_material = "bone"

// Identical to the tactical knife but nowhere near as stabby.
// Kind of like the toy esword compared to the real thing.
/obj/item/material/knife/tacknife/boot
	name = "boot knife"
	desc = "A small fixed-blade knife for putting inside a boot."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "tacknife"
	item_state = "knife"
	force_divisor = 0.15
	applies_material_colour = 0

/obj/item/material/knife/hook
	name = "meat hook"
	desc = "Used for stringing up butchered animals, or a surprise stabbing implemant."
	icon_state = "hook_knife"

/obj/item/material/knife/ritual
	name = "ritual knife"
	desc = "The unearthly energies that once powered this blade are now dormant."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "render"
	applies_material_colour = 0

/obj/item/material/knife/butch
	name = "butcher's cleaver"
	icon_state = "butch"
	desc = "Another fine product from NanoTrasen's Cookware line. The heavy head and grooved grip makes chopping meat a breeze."
	force_divisor = 0.25 // 15 when wielded with hardness 60 (steel)
	attack_verb = list("cleaved", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")

/obj/item/material/knife/machete
	name = "machete"
	desc = "A sharp machete often found in survival kits."
	icon_state = "machete"
	force_divisor = 0.3 // 18 when hardness 60 (steel)
	attack_verb = list("slashed", "chopped", "gouged", "ripped", "cut")
	can_cleave = TRUE //Now hatchets inherit from the machete, and thus knives. Tables turned.
	slot_flags = SLOT_BELT | SLOT_HOLSTER
	default_material = "plasteel"

/obj/item/material/knife/machete/armblade
	name = "arm-mounted blade"
	desc = "A long, machete-like blade, mounted to your arm. Courtesy of Hephaestus, this machete is ideal for parrying blows."
	icon_state = "armblade"
	item_state = "armblade"
	force_divisor = 0.5 // long and arm-mounted but you gotta use a suit for it
	slot_flags = null
	unbreakable = TRUE
	can_dull = FALSE

/obj/item/material/knife/machete/armblade/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if(default_parry_check(user, attacker, damage_source) && prob(33))
		user.visible_message("<span class='danger'>\The [user] parries [attack_text] with \the [src]!</span>")
		playsound(user.loc, 'sound/weapons/punchmiss.ogg', 50, 1)
		return TRUE
	return FALSE

/obj/item/material/knife/machete/armblade/rig
	default_material = MAT_STEEL
	var/obj/item/rig_module/armblade/storing_module

/obj/item/material/knife/machete/armblade/rig/dropped(mob/user, flags, atom/newLoc)
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
	applies_material_colour = FALSE
	default_material = "plasteel"
	tool_speed = 2 // Use a real axe if you want to chop logs.

/obj/item/material/knife/tacknife/survival/bone
	name = "primitive survival knife"
	desc = "A hunting grade survival knife with a sleek leather grip."
	applies_material_colour =TRUE
	default_material = "bone"
/obj/item/material/knife/machete/deluxe
	name = "deluxe machete"
	desc = "A fine example of a machete, with a polished blade, wooden handle and a leather cord loop."
	icon = 'icons/obj/weapons_vr.dmi'
	icon_state = "machetedx"
	item_state = "machete"

//The Return of the Data Knife
/obj/item/material/knife/tacknife/dataknife
	name = "data knife"
	desc = "Oddly enough, a Ward-Takahashi product. This sleek combat knife's blade is inlaid with complex circuitry, capable of hacking electronics. It also sports a GPS system in the pommel, ensuring you'll never be lost."
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "dataknife"
	item_state = "knife"
	applies_material_colour = FALSE
	default_material = "plasteel"
	tool_speed = 2 // Use a real axe if you want to chop logs.

/obj/item/material/knife/tacknife/dataknife/is_multitool()
	return TRUE

// Knife Material Variants
/obj/item/material/butterfly/plasteel
	default_material = "plasteel"

/obj/item/material/butterfly/durasteel
	default_material = "durasteel"

/obj/item/material/butterfly/switchblade/plasteel
	default_material = "plasteel"

/obj/item/material/butterfly/switchblade/durasteel
	default_material = "durasteel"

/obj/item/material/butterfly/boxcutter/plasteel
	default_material = "plasteel"

/obj/item/material/butterfly/boxcutter/durasteel
	default_material = "durasteel"

/obj/item/material/knife/tacknife/plasteel
	default_material = "plasteel"

/obj/item/material/knife/tacknife/durasteel
	default_material = "durasteel"

/obj/item/material/knife/tacknife/combatknife/plasteel
	default_material = "plasteel"

/obj/item/material/knife/tacknife/combatknife/durasteel
	default_material = "durasteel"

/obj/item/material/knife/hook/plasteel
	default_material = "plasteel"

/obj/item/material/knife/hook/durasteel
	default_material = "durasteel"

/obj/item/material/knife/ritual/plasteel
	default_material = "plasteel"

/obj/item/material/knife/ritual/durasteel
	default_material = "durasteel"

/obj/item/material/knife/butch/plasteel
	default_material = "plasteel"

/obj/item/material/knife/butch/durasteel
	default_material = "durasteel"

/obj/item/material/knife/machete/durasteel
	default_material = "durasteel"

/obj/item/material/knife/machete/deluxe/durasteel
	default_material = "durasteel"

/obj/item/material/knife/tacknife/survival/durasteel
	default_material = "durasteel"
