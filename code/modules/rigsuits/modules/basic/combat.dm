
/obj/item/rig_module/basic/mounted/energy_blade

	name = "energy blade projector"
	desc = "A powerful cutting beam projector."
	icon_state = "eblade"

	activate_string = "Project Blade"
	deactivate_string = "Cancel Blade"

	interface_name = "spider fang blade"
	interface_desc = "A lethal energy projector that can shape a blade projected from the hand of the wearer or launch radioactive darts."

	usable = 0
	selectable = 1
	toggleable = 1
	use_power_cost = 50
	active_power_cost = 10
	passive_power_cost = 0

	gun_type = /obj/item/gun/projectile/energy/crossbow/ninja

/obj/item/rig_module/basic/mounted/energy_blade/process(delta_time)

	if(holder && holder.wearer)
		if(!(locate(/obj/item/melee/ninja_energy_blade) in holder.wearer))
			deactivate()
			return 0

	return ..()

/obj/item/rig_module/basic/mounted/energy_blade/activate()

	..()

	var/mob/living/M = holder.wearer

	if(M.are_usable_hands_full())
		to_chat(M, "<span class='danger'>Your hands are full.</span>")
		deactivate()
		return

	var/obj/item/melee/ninja_energy_blade/blade = new(M)
	blade.creator = M
	M.put_in_hands(blade)

/obj/item/rig_module/basic/mounted/energy_blade/deactivate()

	..()

	var/mob/living/M = holder.wearer

	if(!M)
		return

	for(var/obj/item/melee/ninja_energy_blade/blade in M.contents)
		qdel(blade)

/obj/item/rig_module/basic/fabricator

	name = "matter fabricator"
	desc = "A self-contained microfactory system for hardsuit integration."
	selectable = 1
	usable = 1
	use_power_cost = 15
	icon_state = "enet"

	engage_string = "Fabricate Star"

	interface_name = "death blossom launcher"
	interface_desc = "An integrated microfactory that produces poisoned throwing stars from thin air and electricity."

	var/fabrication_type = /obj/item/material/star/ninja
	var/fire_force = 30
	var/fire_distance = 10

/obj/item/rig_module/basic/fabricator/engage(atom/target)

	if(!..())
		return 0

	var/mob/living/H = holder.wearer

	if(target)
		var/obj/item/firing = new fabrication_type()
		firing.forceMove(get_turf(src))
		H.visible_message("<span class='danger'>[H] launches \a [firing]!</span>")
		firing.throw_at_old(target,fire_force,fire_distance)
	else
		if(H.are_usable_hands_full())
			to_chat(H, "<span class='danger'>Your hands are full.</span>")
		else
			var/obj/item/new_weapon = new fabrication_type()
			new_weapon.forceMove(H)
			to_chat(H, "<font color=#4F49AF><b>You quickly fabricate \a [new_weapon].</b></font>")
			H.put_in_hands(new_weapon)

	return 1

/obj/item/rig_module/basic/armblade
	name = "retractable armblade"
	desc = "A retractable arm-mounted blade in an equally retractable scabbard that fits in standardized hardsuit mounts. Attaches to the user's forearm."
	icon_state = "armblade"
	toggleable = TRUE

	interface_name = "retractable armblade"
	interface_desc = "An attached armblade fitted to the wearer's arm of choice."

	activate_string = "Extend Blade"
	deactivate_string = "Retract Blade"
	var/obj/item/material/knife/machete/armblade/hardsuit/held_blade

/obj/item/rig_module/basic/armblade/Initialize(mapload)
	. = ..()
	held_blade = new /obj/item/material/knife/machete/armblade/hardsuit
	held_blade.storing_module = src
	RegisterSignal(held_blade, COMSIG_ITEM_DROPPED, PROC_REF(magnetic_catch))

/obj/item/rig_module/basic/armblade/proc/magnetic_catch(datum/source)
	var/obj/item/I = source
	if(I != held_blade)
		return
	deactivate()

/obj/item/rig_module/basic/armblade/process(delta_time)

	if(holder && holder.wearer)
		if(!(locate(/obj/item/material/knife/machete/armblade) in holder.wearer))
			deactivate()
			return 0

	return ..()

/obj/item/rig_module/basic/armblade/activate()

	..()
	var/mob/living/M = holder.wearer
	var/datum/gender/TU = GLOB.gender_datums[M.get_visible_gender()]

	if(!M.put_in_hands(held_blade))
		to_chat(M, "<span class='danger'>Your hands are full.</span>")
		deactivate()
		return
	if(M.a_intent == INTENT_HARM)
		M.visible_message(
			"<span class='danger'>[M] throws [TU.his] arm out, extending \the [held_blade] from \the [holder] with a click!</span>",
			"<span class='danger'>You throw your arm out, extending \the [held_blade] from \the [holder] with a click!</span>",
			"<span class='notice'>You hear a threatening hiss and a click.</span>"
			)
	else
		M.visible_message(
			"<span class='notice'>[M] extends \the [held_blade] from \the [holder] with a click!</span>",
			"<span class='notice'>You extend \the [held_blade] from \the [holder] with a click!</span>",
			"<span class='notice'>You hear a hiss and a click.</span>")

	playsound(src, 'sound/items/helmetdeploy.ogg', 40, 1)

/obj/item/rig_module/basic/armblade/deactivate()
	..()
	held_blade?.forceMove(src)
