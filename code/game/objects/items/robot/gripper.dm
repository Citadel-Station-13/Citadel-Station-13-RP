//Simple borg hand.
//Limited use.
/obj/item/gripper
	name = "magnetic gripper"
	desc = "A simple grasping tool specialized in construction and engineering work."
	description_info = "Ctrl-Clicking on the gripper will drop whatever it is holding.<br>\
	Using an object on the gripper will interact with the item inside it, if it exists, instead."
	icon = 'icons/obj/device.dmi'
	icon_state = "gripper"
	item_flags = ITEM_NOBLUDGEON

	//Has a list of items that it can hold.
	var/list/can_hold = list(
		/obj/item/cell,
		/obj/item/airlock_electronics,
		/obj/item/tracker_electronics,
		/obj/item/module/power_control,
		/obj/item/stock_parts,
		/obj/item/frame,
		/obj/item/camera_assembly,
		/obj/item/tank,
		/obj/item/circuitboard,
		/obj/item/smes_coil,
		/obj/item/fuelrod/,
		/obj/item/fuel_assembly/
		)

	/// currently held item
	VAR_PRIVATE/obj/item/wrapped

	var/force_holder = null //

/obj/item/gripper/examine(mob/user, dist)
	. = ..()
	if(wrapped)
		. += "<span class='notice'>\The [src] is holding \the [wrapped].</span>"
		. += wrapped.examine(user)

/obj/item/gripper/Destroy()
	remove_item(drop_location())
	return ..()

/obj/item/gripper/proc/insert_item(obj/item/I)
	if(QDELETED(I))
		return
	if(wrapped)
		remove_item(drop_location())
	wrapped = I
	I.forceMove(src)
	RegisterSignal(I, list(COMSIG_PARENT_QDELETING, COMSIG_MOVABLE_MOVED), .proc/unwrap_hook)

/**
 * newloc false to not move
 */
/obj/item/gripper/proc/remove_item(atom/newloc = FALSE)
	if(!wrapped)
		return
	var/obj/item/old = wrapped
	UnregisterSignal(wrapped, list(COMSIG_PARENT_QDELETING, COMSIG_MOVABLE_MOVED))
	wrapped = null
	switch(newloc)
		if(null)
			old.moveToNullspace()
		if(FALSE)
		else
			old.forceMove(newloc)

/obj/item/gripper/proc/unwrap_hook(datum/source)
	ASSERT(isitem(source))
	ASSERT(source == wrapped)
	remove_item(FALSE)

/obj/item/gripper/proc/get_item()
	return wrapped

/obj/item/gripper/CtrlClick(mob/user)
	drop_item()

/obj/item/gripper/omni
	name = "omni gripper"
	desc = "A strange grasping tool that can hold anything a human can, but still maintains the limitations of application its more limited cousins have."
	icon_state = "gripper-omni"

	can_hold = list(/obj/item) // Testing and Event gripper.

// VEEEEERY limited version for mining borgs. Basically only for swapping cells and upgrading the drills.
/obj/item/gripper/miner
	name = "drill maintenance gripper"
	desc = "A simple grasping tool for the maintenance of heavy drilling machines."
	icon_state = "gripper-mining"

	can_hold = list(
	/obj/item/cell,
	/obj/item/stock_parts
	)

/obj/item/gripper/security
	name = "security gripper"
	desc = "A simple grasping tool for corporate security work."
	icon_state = "gripper-sec"

	can_hold = list(
	/obj/item/paper,
	/obj/item/paper_bundle,
	/obj/item/pen,
	/obj/item/sample,
	/obj/item/forensics/sample_kit,
	/obj/item/tape_recorder,
	/obj/item/barrier_tape_roll,
	/obj/item/uv_light
	)

/obj/item/gripper/paperwork
	name = "paperwork gripper"
	desc = "A simple grasping tool for clerical work."

	can_hold = list(
		/obj/item/clipboard,
		/obj/item/paper,
		/obj/item/paper_bundle,
		/obj/item/card/id,
		/obj/item/book,
		/obj/item/newspaper
		)

/obj/item/gripper/medical
	name = "medical gripper"
	desc = "A simple grasping tool for medical work."

	can_hold = list(
		/obj/item/reagent_containers/glass,
		/obj/item/storage/pill_bottle,
		/obj/item/reagent_containers/pill,
		/obj/item/reagent_containers/blood,
		/obj/item/stack/material/phoron,
		/obj/item/implant,
		/obj/item/nif
		)

/obj/item/gripper/research //A general usage gripper, used for toxins/robotics/xenobio/etc
	name = "scientific gripper"
	icon_state = "gripper-sci"
	desc = "A simple grasping tool suited to assist in a wide array of research applications."

	can_hold = list(
		/obj/item/cell,
		/obj/item/stock_parts,
		/obj/item/mmi,
		/obj/item/robot_parts,
		/obj/item/borg/upgrade,
		/obj/item/flash, //to build borgs,
		/obj/item/disk,
		/obj/item/circuitboard,
		/obj/item/reagent_containers/glass,
		/obj/item/assembly/prox_sensor,
		/obj/item/healthanalyzer, //to build medibots,
		/obj/item/slime_cube,
		/obj/item/slime_crystal,
		/obj/item/disposable_teleporter/slime,
		/obj/item/slimepotion,
		/obj/item/slime_extract,
		/obj/item/reagent_containers/food/snacks/monkeycube,
		/obj/item/nif

		)

/obj/item/gripper/circuit
	name = "circuit assembly gripper"
	icon_state = "gripper-circ"
	desc = "A complex grasping tool used for working with circuitry."

	can_hold = list(
		/obj/item/cell/device,
		/obj/item/electronic_assembly,
		/obj/item/assembly/electronic_assembly,
		/obj/item/clothing/under/circuitry,
		/obj/item/clothing/gloves/circuitry,
		/obj/item/clothing/glasses/circuitry,
		/obj/item/clothing/shoes/circuitry,
		/obj/item/clothing/head/circuitry,
		/obj/item/clothing/ears/circuitry,
		/obj/item/clothing/suit/circuitry,
		/obj/item/implant/integrated_circuit,
		/obj/item/integrated_circuit

		)

/obj/item/gripper/service //Used to handle food, drinks, and seeds.
	name = "service gripper"
	icon_state = "gripper"
	desc = "A simple grasping tool used to perform tasks in the service sector, such as handling food, drinks, and seeds."

	can_hold = list(
		/obj/item/reagent_containers, //simplifies a lot of redundant categorization and spaghetti with reagents
		/obj/item/glass_extra,
		/obj/item/seeds,
		/obj/item/grown,
		/obj/item/tray,
		/obj/item/plantspray,
		/obj/item/reagent_containers/glass,
		/obj/item/reagent_containers/food/drinks,
		/obj/item/storage/box/wings
		)

/obj/item/gripper/gravekeeper	//Used for handling grave things, flowers, etc.
	name = "grave gripper"
	icon_state = "gripper"
	desc = "A specialized grasping tool used in the preparation and maintenance of graves."

	can_hold = list(
		/obj/item/seeds,
		/obj/item/grown,
		/obj/item/material/gravemarker
		)

/obj/item/gripper/no_use/organ
	name = "organ gripper"
	icon_state = "gripper-flesh"
	desc = "A specialized grasping tool used to preserve and manipulate organic material."

	can_hold = list(
		/obj/item/organ
		)

/obj/item/gripper/no_use/organ/Entered(var/atom/movable/AM)
	..()
	if(istype(AM, /obj/item/organ))
		var/obj/item/organ/O = AM
		O.preserve(GRIPPER_TRAIT)

/obj/item/gripper/no_use/organ/Exited(var/atom/movable/AM)
	..()
	if(istype(AM, /obj/item/organ))
		var/obj/item/organ/O = AM
		O.unpreserve(GRIPPER_TRAIT)

/obj/item/gripper/no_use/organ/robotics
	name = "robotics organ gripper"
	icon_state = "gripper-flesh"
	desc = "A specialized grasping tool used in robotics work."

	can_hold = list(
		/obj/item/organ/external,
		/obj/item/organ/internal/brain, //to insert into MMIs,
		/obj/item/organ/internal/cell,
		/obj/item/organ/internal/eyes/robot
		)

/obj/item/gripper/no_use/mech
	name = "exosuit gripper"
	icon_state = "gripper-mech"
	desc = "A large, heavy-duty grasping tool used in construction of mechs."

	can_hold = list(
		/obj/item/mecha_parts/part,
		/obj/item/mecha_parts/micro/part,
		/obj/item/mecha_parts/mecha_equipment,
		/obj/item/mecha_parts/mecha_tracking
		)

/obj/item/gripper/no_use //Used when you want to hold and put items in other things, but not able to 'use' the item

/obj/item/gripper/no_use/attack_self(mob/user)
	. = ..()
	if(.)
		return
	return

/obj/item/gripper/no_use/loader //This is used to disallow building with metal.
	name = "sheet loader"
	desc = "A specialized loading device, designed to pick up and insert sheets of materials inside machines."
	icon_state = "gripper-sheet"

	can_hold = list(
		/obj/item/stack/material
		)

/obj/item/gripper/attack_self(mob/user)
	. = ..()
	if(.)
		return
	if(wrapped)
		return wrapped.attack_self(user)
	return ..()

/obj/item/gripper/attackby(var/obj/item/O, var/mob/user)
	if(wrapped) // We're interacting with the item inside. If you can hold a cup with 2 fingers and stick a straw in it, you could do that with a gripper and another robotic arm.
		var/resolved = wrapped.attackby(O, user)
		if(!resolved && wrapped && O)
			O.afterattack(wrapped,user,1)
		return resolved
	return ..()

/obj/item/gripper/verb/drop_item()
	set name = "Drop Item"
	set desc = "Release an item from your magnetic gripper."
	set category = "Robot Commands"

	if(!wrapped)
		return

	to_chat(usr, "<span class='danger'>You drop \the [wrapped].</span>")
	remove_item(drop_location())

/obj/item/gripper/attack_mob(mob/target, mob/user, clickchain_flags, list/params, mult, target_zone, intent)
	if(wrapped) 	//The damage_force of the wrapped obj gets set to zero during the attack() and afterattack().
		force_holder = wrapped.damage_force
		wrapped.damage_force = 0
		target.attackby(wrapped, user, params, clickchain_flags)	//attackby reportedly gets procced by being clicked on, at least according to Anewbe.
		return 1
	return 0

/obj/item/gripper/afterattack(atom/target, mob/user, clickchain_flags, list/params)
	if(!(clickchain_flags & CLICKCHAIN_HAS_PROXIMITY))
		return // This will prevent them using guns at range but adminbuse can add them directly to modules, so eh.


	if(wrapped) //Already have an item.
		//Pass the attack on to the target. This might delete/relocate wrapped.
		var/resolved = target.attackby(wrapped, user)
		if(!resolved && wrapped && target)
			wrapped.afterattack(target,user,1)
		//wrapped's damage_force was set to zero.  This resets it to the value it had before.
		if(wrapped)
			wrapped.damage_force = force_holder
		force_holder = null

	else if(istype(target,/obj/item)) //Check that we're not pocketing a mob.

		//...and that the item is not in a container.
		if(!isturf(target.loc))
			return

		var/obj/item/I = target

		if(I.anchored)
			to_chat(user,"<span class='notice'>You are unable to lift \the [I] from \the [I.loc].</span>")
			return

		//Check if the item is blacklisted.
		var/grab = 0
		for(var/typepath in can_hold)
			if(istype(I,typepath))
				grab = 1
				break

		//We can grab the item, finally.
		if(grab)
			to_chat(user, "You collect \the [I].")
			insert_item(I)
			return
		else
			to_chat(user, "<span class='danger'>Your gripper cannot hold \the [target].</span>")

	else if(istype(target,/obj/machinery/power/apc))
		var/obj/machinery/power/apc/A = target
		if(A.opened)
			if(A.cell)

				insert_item(A.cell)
				A.cell.add_fingerprint(user)
				A.cell.update_icon()
				A.cell = null

				A.charging = 0
				A.update_icon()

				user.visible_message("<span class='danger'>[user] removes the power cell from [A]!</span>", "You remove the power cell.")

	else if(istype(target,/mob/living/silicon/robot))
		var/mob/living/silicon/robot/A = target
		if(A.opened)
			if(A.cell)
				insert_item(A.cell)
				A.cell.add_fingerprint(user)
				A.cell.update_icon()
				A.updateicon()
				A.cell = null

				user.visible_message("<span class='danger'>[user] removes the power cell from [A]!</span>", "You remove the power cell.")
