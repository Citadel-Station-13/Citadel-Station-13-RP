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

/obj/item/material/butterfly/update_force()
	if(active)
		edge = 1
		sharp = 1
		..() //Updates force.
		throwforce = max(3,force-3)
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
	desc = "A general purpose Chef's Knife made by SpaceCook Incorporated. Guaranteed to stay sharp for years to come."
	sharp = 1
	edge = 1
	force_divisor = 0.15 // 9 when wielded with hardness 60 (steel)
	matter = list(DEFAULT_WALL_MATERIAL = 12000)
	origin_tech = list(TECH_MATERIAL = 1)
	attack_verb = list("slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")

/obj/item/material/knife/suicide_act(mob/user)
	var/datum/gender/TU = gender_datums[user.get_visible_gender()]
	viewers(user) << pick("<span class='danger'>\The [user] is slitting [TU.his] wrists with \the [src]! It looks like [TU.hes] trying to commit suicide.</span>", \
	                      "<span class='danger'>\The [user] is slitting [TU.his] throat with \the [src]! It looks like [TU.hes] trying to commit suicide.</span>", \
	                      "<span class='danger'>\The [user] is slitting [TU.his] stomach open with \the [src]! It looks like [TU.hes] trying to commit seppuku.</span>")
	return (BRUTELOSS)

// These no longer inherit from hatchets.
/obj/item/material/knife/tacknife
	name = "tactical knife"
	desc = "You'd be killing loads of people if this was Medal of Valor: Heroes of Space."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "tacknife"
	item_state = "knife"
	force_divisor = 0.20 //12 when hardness 60 (steel)
	attack_verb = list("stabbed", "chopped", "cut")
	applies_material_color = 1

/obj/item/material/knife/tacknife/combatknife
	name = "combat knife"
	desc = "If only you had a boot to put it in."
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "buckknife"
	item_state = "knife"
	force_divisor = 0.25 // 15 with hardness 60 (steel)
	thrown_force_divisor = 1.75 // 20 with weight 20 (steel)
	attack_verb = list("sliced", "stabbed", "chopped", "cut")
	applies_material_color = 1

// Identical to the tactical knife but nowhere near as stabby.
// Kind of like the toy esword compared to the real thing.
/obj/item/material/knife/tacknife/boot
	name = "boot knife"
	desc = "A small fixed-blade knife for putting inside a boot."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "tacknife"
	item_state = "knife"
	force_divisor = 0.15
	applies_material_color = 0

/obj/item/material/knife/hook
	name = "meat hook"
	desc = "A sharp, metal hook what sticks into things."
	icon_state = "hook_knife"

/obj/item/material/knife/ritual
	name = "ritual knife"
	desc = "The unearthly energies that once powered this blade are now dormant."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "render"
	applies_material_color = 0

/obj/item/material/knife/butch
	name = "butcher's cleaver"
	icon_state = "butch"
	desc = "A huge thing used for chopping and chopping up meat. This includes clowns and clown-by-products."
	force_divisor = 0.25 // 15 when wielded with hardness 60 (steel)
	attack_verb = list("cleaved", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")

/obj/item/material/knife/machete
	name = "machete"
	desc = "A sharp machete often found in survival kits."
	icon_state = "machete"
	force_divisor = 0.3 // 18 when hardness 60 (steel)
	attack_verb = list("slashed", "chopped", "gouged", "ripped", "cut")
	can_cleave = TRUE //Now hatchets inherit from the machete, and thus knives. Tables turned.
	slot_flags = SLOT_BELT
	default_material = "plasteel"

/obj/item/material/knife/machete/armblade
	name = "arm-mounted blade"
	desc = "A long, machete-like blade, mounted to your arm. The size and location of it lends itself to parrying blows in melee."
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
	default_material = DEFAULT_WALL_MATERIAL
	canremove = FALSE
	var/obj/item/rig_module/armblade/storing_module

/obj/item/material/knife/machete/armblade/rig/dropped(mob/user)
	if(storing_module)
		src.forceMove(storing_module)
		user.visible_message(
			"<span class='notice'>[user] retracts [src], folding it away with a click and a hiss.</span>",
			"<span class='notice'>You retract [src], folding it away with a click and a hiss.</span>",
			"<span class='notice'>You hear a threatening click and a hiss.</span>"
			)
		playsound(src, 'modular_citadel/sound/items/helmetdeploy.ogg', 40, 1)
	else
		to_chat(user, "Something fucked up and the armblade got out of a module. Please report this bug.")
		qdel(src)

/obj/item/material/knife/tacknife/survival
	name = "survival knife"
	desc = "A hunting grade survival knife."
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "survivalknife"
	item_state = "knife"
	applies_material_color = FALSE
	default_material = "plasteel"
	toolspeed = 2 // Use a real axe if you want to chop logs.

/obj/item/material/knife/machete/deluxe
	name = "deluxe machete"
	desc = "A fine example of a machete, with a polished blade, wooden handle and a leather cord loop."
	icon = 'icons/obj/weapons_vr.dmi'
	icon_state = "machetedx"
	item_state = "machete"
