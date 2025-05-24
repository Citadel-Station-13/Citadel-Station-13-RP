/**
 * # Guns
 *
 * A gun is a weapon that can be aimed and fired at someone or something over a distance.
 *
 * todo: /obj/item/gun/projectile vs /obj/item/gun/launcher,
 *       instead of have projectile be on /obj/item/gun
 *
 * ## Hotkey Priority
 *
 * The usable semantic hotkeys for guns are: Z, Spacebar, F, G.
 * F, G are avoided as 'unique defensives' and something components
 * need to be able to register to.
 *
 * todo: At some point, we'll need proper hotkey priority handling for items
 *       for the 'primary semantic keys' like active key/spacebar,
 *       F and G. For now, it's kind of a wild west where items define
 *       Z and Spacebar and F/G are usually component-hooked.
 *
 *       The problem comes in that guns have **three** self-actions instead of two:
 *       - Wielding
 *       - Racking / chamber charging
 *       - Firemode switch
 *
 *       This is annoying because semantically, the Z key should always have wielding,
 *       Spacebar should have racking behaviors if they exist, which means we don't
 *       have a spot for firemode switching.
 *
 *       As of right now, wielding is not on all guns but that will change very soon.
 * todo: Change that very soon.
 *       This means that Z key will never be available to guns for firemode switches.
 *
 * For now, we're winging it. This is just design notes for when we cross
 * this hellish bridge.
 *
 * ## Current Caveats
 *
 * * Flashlight attachments directly edit the light variable of the gun. This means that they'll trample the gun's
 *   inherent light if there is one.
 */
/obj/item/gun
	name = "gun"
	desc = "Its a gun. It's pretty terrible, though."
	description_info = "This is a gun.  To fire the weapon, ensure your intent is *not* set to 'help', have your gun mode set to 'fire', \
		then click where you want to fire."
	icon = 'icons/obj/gun/ballistic.dmi'
	icon_state = "detective"
	item_state = "gun"
	item_flags = ITEM_ENCUMBERS_WHILE_HELD | ITEM_ENCUMBERS_ONLY_HELD
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	materials_base = list(MAT_STEEL = 2000)
	rad_flags = RAD_BLOCK_CONTENTS
	w_class = WEIGHT_CLASS_NORMAL
	throw_force = 5
	throw_speed = 4
	throw_range = 5
	damage_force = 5
	damage_tier = 3
	preserve_item = 1
	attack_verb = list("struck", "hit", "bashed")
	zoomdevicename = "scope"
	inhand_default_type = INHAND_DEFAULT_ICON_GUNS

	//* Accuracy, Dispersion, Instability *//

	/// entirely disable baymiss on fired projectiles
	///
	/// * this is a default value; set to null by default to have the projectile's say.
	var/accuracy_disabled = null

	//* Attachments *//

	/// Installed attachments
	///
	/// * Set to list of typepaths to immediately install them on init.
	/// * Do not set this.
	var/list/obj/item/gun_attachment/attachments
	/// Attachment alignments.
	///
	/// * Format: "attachment slot" = list(x, y)
	/// * Typelisted. If you varedit this, be aware of that.
	/// * If an attachment slot isn't here, it's not allowed on the gun.
	/// * See `code/__DEFINES/projectiles/gun_attachment.dm` for what this is doing to the attachments.
	///   We basically match the specified align_x/y pixel on the attachment to the x/y on the gun's sprite
	///   specified here.
	/// * This is pixel coordinates on the gun's real icon. Out of bounds is allowed as attachments are just overlays.
	var/list/attachment_alignment
	/// Blacklisted attachment types.
	var/attachment_type_blacklist = NONE

	//* Feedback *//
	/// Last world.time we made a 'can't fire yet!' message.
	var/last_cooldown_message

	//* Firemode *//
	/**
	 * The list of our possible firemodes.
	 *
	 * Firemodes may be;
	 *
	 * * an instance: this will be kept around per gun
	 * * an anonymous type (byond 'pop' object with /typepath{varedit = "abc";} syntax):
	 *   this will be kept around per gun
	 * * a typepath: this will be globally cached
	 *
	 * This variable may either be a list, of the above, or a singular of the above.
	 */
	var/list/firemodes = /datum/firemode
	/// active firemode
	var/datum/firemode/firemode
	/// use radial for firemode
	var/firemodes_use_radial = FALSE
	/// firemode swap action
	var/datum/action/firemode_swap_action

	//* Firing *//

	/// the current firing cycle
	///
	/// * to interrupt a firing cycle, just change it.
	var/tmp/datum/gun_firing_cycle/firing_cycle
	/// the next firing cycle
	///
	/// * static var; technically can collide. realistically, won't.
	var/static/firing_cycle_next = 0
	/// last world.time we fired a shot
	var/last_fire = 0
	/// next world.time we can start a firing cycle
	var/next_fire_cycle = 0

	//! legacy below !//

	var/fire_sound = null // This is handled by projectile.dm's fire_sound var now, but you can override the projectile's fire_sound with this one if you want to.
	var/fire_sound_text = "gunshot"
	var/recoil = 0		//screen shake
	var/suppressible = FALSE
	var/silenced = FALSE
	var/silenced_icon = null
	var/muzzle_flash = 3
	var/accuracy = 65   //Accuracy is measured in percents. +15 accuracy means that everything is effectively one tile closer for the purpose of miss chance, -15 means the opposite. launchers are not supported, at the moment.
	var/scoped_accuracy = null
	var/list/burst_accuracy = list(0) //allows for different accuracies for each shot in a burst. Applied on top of accuracy
	var/list/dispersion = list(0)
	// todo: purge with fire
	// todo: do not use this var, use firemodes on /energy
	var/projectile_type = /obj/projectile	//On ballistics, only used to check for the cham gun

	var/wielded_item_state
	var/one_handed_penalty = 0 // Penalty applied if someone fires a two-handed gun with one hand.
	var/atom/movable/screen/auto_target/auto_target

	var/selector_sound = 'sound/weapons/guns/selector.ogg'

	//aiming system stuff
	var/keep_aim = 1 	//1 for keep shooting until aim is lowered
						//0 for one bullet after tarrget moves and aim is lowered
	var/multi_aim = 0 //Used to determine if you can target multiple people.
	var/tmp/list/mob/living/aim_targets //List of who yer targeting.
	var/tmp/lock_time = -100

	/// whether or not we have safeties and if safeties are on
	var/safety_state = GUN_SAFETY_ON

	var/charge_sections = 4
	var/shaded_charge = FALSE
	var/ammo_x_offset = 2
	var/ammo_y_offset = 0

	var/obj/item/firing_pin/pin = /obj/item/firing_pin
	var/no_pin_required = 0
	var/scrambled = 0

	//Gun Malfunction variables
	var/unstable = 0
	var/destroyed = 0

	//! legacy above !//

	                    //* THIS IS A WIP SYSTEM!! *//
	                    // todo: well, finish this.
	//*                      Modular Components                           *//
	//* Generalized, and efficient modular component support at base /gun *//
	//* level.                                                            *//

	/// System flag for using modular component system
	///
	/// * Firing cycles are more expensive when modular components are invoked.
	/// * This is because modular components use signal and API hooks that are not necessary for most guns.
	/// * Thus, keep this off if it's not a modular weapon. It won't break it, but it's needless overhead.
	var/modular_system = FALSE
	/// currently installed components.
	///
	/// * This is a lazy list.
	/// * This is nulled out if [modular_system] is off.
	var/list/obj/item/gun_component/modular_components
	/// lazy way to set internal slots, because this is modified so often
	///
	/// * literally not checked past init, it's used to generate the typelist
	/// * if it's specified in the list, the list's copy is used instead.
	var/modular_component_slots_internal = INFINITY
	/// allowed component slots, associated to amount
	///
	/// * this is typelist()'d; if you want to change it later, make a copy!
	var/list/modular_component_slots

	//*                               Power                               *//
	//* Because the use of power is such a common case on /gun, it's been *//
	//* hoisted to the base /obj/item/gun level for handling.             *//

	/// do we use a cell slot?
	var/cell_system = FALSE
	/// cell type to start with
	var/cell_type = /obj/item/cell/device/weapon
	/// -_-
	var/cell_system_legacy_use_device = TRUE

	//*                            Rendering                               *//

	/// Used instead of base_icon_state for the mob renderer, if this exists.
	var/base_mob_state

	/// renderer datum we use for world rendering of the gun item itself
	/// set this in prototype to a path
	/// if null, we will not perform default rendering/updating of item states.
	///
	/// * anonymous types are allowed and encouraged.
	/// * the renderer defaults to [base_icon_state || initial(icon_state)] for the base icon state to append to.
	var/datum/gun_item_renderer/item_renderer
	/// for de-duping
	var/static/list/item_renderer_store = list()
	/// renderer datum we use for mob rendering of the gun when held / worn
	/// set this in prototype to a path
	/// if null, we will not perform default rendering/updating of onmob states
	///
	/// * anonymous types are allowed and encouraged.
	/// * the renderer defaults to [base_icon_state || render_mob_base || initial(icon_state)] for the base icon state to append to.
	var/datum/gun_mob_renderer/mob_renderer
	/// for de-duping
	var/static/list/mob_renderer_store = list()

	/// render as -wield if we're wielded? applied at the end of our base worn state no matter what if on and we are wielded.
	///
	/// * ignores [mob_renderer]
	/// * ignores [render_additional_exclusive] / [render_additional_worn]
	/// * ordering: [base]-wield-[additional]-[...rest]
	var/render_wielded = FALSE
	/// skip normal rendering, just render as base icon/worn states
	/// * useful if a subtype wants to handle itself
	var/render_skip = FALSE

	/// use the old render system, if item_renderer and mob_renderer are not set
	//  todo: remove
	var/render_use_legacy_by_default = TRUE

/obj/item/gun/Initialize(mapload)
	. = ..()
	//* datum component - wielding *//
	AddComponent(/datum/component/wielding)

	//* instantiate & dedupe renderers *//
	if(item_renderer)
		if(ispath(item_renderer) || IS_ANONYMOUS_TYPEPATH(item_renderer))
			item_renderer = new item_renderer
		var/item_renderer_key = item_renderer.dedupe_key()
		item_renderer = item_renderer_store[item_renderer_key] || (item_renderer_store[item_renderer_key] = item_renderer)
	if(mob_renderer)
		if(ispath(mob_renderer) || IS_ANONYMOUS_TYPEPATH(mob_renderer))
			mob_renderer = new mob_renderer
		var/mob_renderer_key = mob_renderer.dedupe_key()
		mob_renderer = mob_renderer_store[mob_renderer_key] || (mob_renderer_store[mob_renderer_key] = mob_renderer)

	//! LEGACY: Rendering
	// if neither of these are here, we are using legacy render. //
	if(!item_renderer && !mob_renderer && render_use_legacy_by_default)
		item_icons = list(
			SLOT_ID_LEFT_HAND = 'icons/mob/items/lefthand_guns.dmi',
			SLOT_ID_RIGHT_HAND = 'icons/mob/items/righthand_guns.dmi',
			)

	//* handle attachment typelists *//
	if(attachment_alignment)
		attachment_alignment = typelist(NAMEOF(src, attachment_alignment), attachment_alignment)

	//* handle attachments *//
	if(length(attachments))
		var/list/translating_attachments = attachments
		attachments = list()
		for(var/obj/item/gun_attachment/casted as anything in translating_attachments)
			var/obj/item/gun_attachment/actual
			if(IS_ANONYMOUS_TYPEPATH(casted))
				actual = new casted
			else if(ispath(casted, /obj/item/gun_attachment))
				actual = new casted
			else if(istype(casted))
				actual = casted
			if(actual.attached != src)
				if(!install_attachment(actual))
					stack_trace("[actual] ([actual.type]) couldn't be auto-installed on initialize despite being in list.")
					qdel(actual)

	//* cell system *//
	if(cell_system)
		var/datum/object_system/cell_slot/slot = init_cell_slot(cell_type)
		slot.legacy_use_device_cells = cell_system_legacy_use_device
		slot.remove_yank_offhand = TRUE
		slot.remove_yank_context = TRUE

	//* modular components *//
	if(islist(modular_component_slots))
		if(modular_system)
			var/list/existing_typelist = get_typelist(NAMEOF(src, modular_component_slots))
			if(existing_typelist)
				modular_component_slots = existing_typelist
			else
				// if it's 1. a list and 2. we can't grab a typelist for it,
				// we make it, patching internal modules lazily
				var/internal_modules_patch = modular_component_slots[GUN_COMPONENT_INTERNAL_MODULE]
				if(isnull(internal_modules_patch))
					modular_component_slots[GUN_COMPONENT_INTERNAL_MODULE] = modular_component_slots_internal
				modular_component_slots = typelist(NAMEOF(src, modular_component_slots), modular_component_slots)
		else
			modular_component_slots = null

	//* firemodes *//
	if(!islist(firemodes) && firemodes)
		firemodes = list(firemodes)
	if(!length(firemodes))
		firemodes = list(istype(src, /obj/item/gun/projectile/energy) ? /datum/firemode/energy : /datum/firemode)
	for(var/i in 1 to firemodes.len)
		var/key = firemodes[i]
		if(islist(key))
			// todo: i'm so so sorry
			var/firemode_type = istype(src, /obj/item/gun/projectile/energy) ? /datum/firemode/energy : /datum/firemode
			firemodes[i] = new firemode_type(src, key)
		else if(IS_ANONYMOUS_TYPEPATH(key))
			firemodes[i] = new key(src)
		else if(ispath(key))
			firemodes[i] = new key(src)
	if(length(firemodes))
		set_firemode(firemodes[1], TRUE)
	reconsider_firemode_action()

	//! LEGACY: accuracy
	if(isnull(scoped_accuracy))
		scoped_accuracy = accuracy

	//! LEGACY: pin
	if(pin)
		pin = new pin(src)

	update_icon()

/obj/item/gun/Destroy()
	QDEL_NULL(pin)
	QDEL_LIST(attachments)
	return ..()

/obj/item/gun/examine(mob/user, dist)
	. = ..()
	if(should_attack_self_switch_firemodes())
		. += SPAN_NOTICE("Press '<b>Activate In Hand</b>' [user?.client?.print_keys_for_keybind_with_prefs_link(/datum/keybinding/item/activate_inhand, " ")]while holding this gun in your active hand to swap its firing configuration.")
	if(should_unique_action_rack_chamber())
		. += SPAN_NOTICE("Press '<b>Unique Action</b>' [user?.client?.print_keys_for_keybind_with_prefs_link(/datum/keybinding/item/unique_action, " ")]while holding this gun in your active hand to rack its chamber.")
	if(!no_pin_required)
		if(pin)
			. += "It has \a [pin] installed."
		else
			. += "It doesn't have a firing pin installed, and won't fire."
	if(firemode)
		. += "The fire selector is set to [firemode.name]."
	if(safety_state != GUN_NO_SAFETY)
		. += SPAN_NOTICE("The safety is [check_safety() ? "on" : "off"].")
	if(obj_cell_slot)
		if(!obj_cell_slot.cell)
			. += "Its cell slot is <b>empty</b>."
		else
			. += "Its cell is at [round(obj_cell_slot.cell.charge / obj_cell_slot.cell.maxcharge * 100, 1)]% charge."
	for(var/obj/item/gun_attachment/attachment as anything in attachments)
		. += "It has [attachment] installed on its [attachment.attachment_slot].[attachment.can_detach ? "" : " It doesn't look like it can be removed."]"
	for(var/obj/item/gun_component/component as anything in modular_components)
		. += "It has a [component.get_examine_fragment()] installed."
	// todo: help examine for modular components

/obj/item/gun/on_wield(mob/user, hands)
	. = ..()
	// legacy
	if(wielded_item_state)
		LAZYINITLIST(item_state_slots)
		item_state_slots[SLOT_ID_LEFT_HAND] = wielded_item_state
		item_state_slots[SLOT_ID_RIGHT_HAND] = wielded_item_state
		update_icon()
		update_worn_icon()

/obj/item/gun/on_unwield(mob/user, hands)
	. = ..()
	// legacy
	if(wielded_item_state)
		LAZYINITLIST(item_state_slots)
		item_state_slots[SLOT_ID_LEFT_HAND] = initial(item_state)
		item_state_slots[SLOT_ID_RIGHT_HAND] = initial(item_state)
		update_icon()
		update_worn_icon()

//Checks whether a given mob can use the gun
//Any checks that shouldn't result in handle_click_empty() being called if they fail should go here.
//Otherwise, if you want handle_click_empty() to be called, check in consume_next_projectile() and return null there.
/obj/item/gun/proc/special_check(var/mob/user)

	if(!istype(user, /mob/living))
		return 0
	if(issimplemob(user))
		var/mob/living/simple_mob/S = user
		if(!S.IsHumanoidToolUser(src))
			return 0
	if(!user.IsAdvancedToolUser())
		return 0
	if(!handle_pins(user))
		return 0
	return 1

/obj/item/gun/dropped(mob/user, flags, atom/newLoc)
	. = ..()
	update_appearance()

/obj/item/gun/equipped(mob/user, slot, flags)
	. = ..()
	update_appearance()

/obj/item/gun/afterattack(atom/target, mob/living/user, clickchain_flags, list/params)
	if(clickchain_flags & CLICKCHAIN_HAS_PROXIMITY)
		return

	if(!user?.client?.get_preference_toggle(/datum/game_preference_toggle/game/help_intent_firing) && user.a_intent == INTENT_HELP)
		to_chat(user, SPAN_WARNING("You refrain from firing [src] because your intent is set to help!"))
		return

	var/shitty_legacy_params = list2params(params)
	if(!user.aiming)
		user.aiming = new(user)

	if(check_safety())
		//If we are on harm intent (intending to injure someone) but forgot to flick the safety off, there is a 50% chance we
		//will reflexively do it anyway
		if(user.a_intent == INTENT_HARM && prob(50))
			toggle_safety(user)
		else
			handle_click_safety(user)
			return

	if(user && user.client && user.aiming && user.aiming.active && user.aiming.aiming_at != target)
		PreFire(target,user,shitty_legacy_params) //They're using the new gun system, locate what they're aiming at.
		return
	else
		var/datum/event_args/actor/clickchain/e_args = new(user)
		e_args.click_params = params
		e_args.target = target
		e_args.using_intent = user.a_intent
		return handle_clickchain_fire(e_args, clickchain_flags)

/obj/item/gun/melee_attack(datum/event_args/actor/clickchain/clickchain, clickchain_flags, datum/melee_attack/weapon/attack_style)
	if(clickchain.using_intent != INTENT_HARM)
		return ..()
	// point blank shooting

	// legacy aiming code
	var/mob/user = clickchain.performer
	var/mob/living/L = user
	if(user && user.client && istype(L) && L.aiming && L.aiming.active && L.aiming.aiming_at != clickchain.target && clickchain.target != clickchain.performer)
		PreFire(clickchain.target, user) //They're using the new gun system, locate what they're aiming at.
		return CLICKCHAIN_DID_SOMETHING
	// end

	return handle_clickchain_fire(clickchain, clickchain_flags)

/obj/item/gun/using_item_on(obj/item/using, datum/event_args/actor/clickchain/e_args, clickchain_flags, datum/callback/reachability_check)
	. = ..()
	if(. & CLICKCHAIN_FLAGS_INTERACT_ABORT)
		return
	if(istype(using, /obj/item/gun_attachment))
		user_install_attachment(using, e_args)
		return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING
	if(istype(using, /obj/item/gun_component))
		user_install_modular_component(using, e_args)
		return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING

/obj/item/gun/attackby(obj/item/I, mob/living/user, list/params, clickchain_flags, damage_multiplier)
	if(I.is_multitool())
		if(!scrambled)
			to_chat(user, "<span class='notice'>You begin scrambling \the [src]'s electronic pins.</span>")
			playsound(src, I.tool_sound, 50, 1)
			if(do_after(user, 60 * I.tool_speed))
				switch(rand(1,100))
					if(1 to 10)
						to_chat(user, "<span class='danger'>The electronic pin suite detects the intrusion and explodes!</span>")
						user.show_message("<span class='danger'>SELF-DESTRUCTING...</span><br>", 2)
						explosion(get_turf(src), -1, 0, 2, 3)
						qdel(src)
					if(11 to 49)
						to_chat(user, "<span class='notice'>You fail to disrupt the electronic warfare suite.</span>")
						return
					if(50 to 100)
						to_chat(user, "<span class='notice'>You disrupt the electronic warfare suite.</span>")
						scrambled = 1
		else
			to_chat(user, "<span class='warning'>\The [src] does not have an active electronic warfare suite!</span>")

	if(I.is_wirecutter())
		if(pin && scrambled)
			to_chat(user, "<span class='notice'>You attempt to remove \the firing pin from \the [src].</span>")
			playsound(src, I.tool_sound, 50, 1)
			if(do_after(user, 60 * I.tool_speed))
				switch(rand(1,100))
					if(1 to 10)
						to_chat(user, "<span class='danger'>You twist the firing pin as you tug, destroying the firing pin.</span>")
						pin = null
					if(11 to 74)
						to_chat(user, "<span class='notice'>You grasp the firing pin, but it slips free!</span>")
						return
					if(75 to 100)
						to_chat(user, "<span class='notice'>You remove \the firing pin from \the [src].</span>")
						user.put_in_hands(src.pin)
						pin = null
			else if(!do_after())
				return
		else if(pin && !scrambled)
			to_chat(user, "<span class='notice'>The \the firing pin is firmly locked into \the [src].</span>")
		else
			to_chat(user, "<span class='warning'>\The [src] does not have a firing pin installed!</span>")

	return ..()

/obj/item/gun/emag_act(var/remaining_charges, var/mob/user)
	if(pin)
		pin.emag_act(remaining_charges, user)

/obj/item/gun/proc/handle_click_safety(mob/user)
	user.visible_message(SPAN_WARNING("[user] squeezes the trigger of \the [src] but it doesn't move!"), SPAN_WARNING("You squeeze the trigger but it doesn't move!"), range = MESSAGE_RANGE_COMBAT_SILENCED)

/obj/item/gun/proc/toggle_scope(var/zoom_amount=2.0)
	//looking through a scope limits your periphereal vision
	//still, increase the view size by a tiny amount so that sniping isn't too restricted to NSEW
	var/zoom_offset = round(world.view * zoom_amount)
	var/view_size = round(world.view + zoom_amount)
	var/scoped_accuracy_mod = zoom_offset

	zoom(zoom_offset, view_size)
	if(zoom)
		accuracy = scoped_accuracy + scoped_accuracy_mod
		if(recoil)
			recoil = round(recoil*zoom_amount+1) //recoil is worse when looking through a scope

//make sure accuracy and recoil are reset regardless of how the item is unzoomed.
/obj/item/gun/zoom(tileoffset = 14, viewsize = 9, mob/user = usr)
	..()
	if(!zoom)
		accuracy = initial(accuracy)
		recoil = initial(recoil)

/obj/item/gun/proc/handle_pins(mob/living/user)
	if(no_pin_required)
		return TRUE
	if(pin)
		if(pin.pin_auth(user) || (pin.emagged))
			return 1
		else
			pin.auth_fail(user)
			return 0
	else
		to_chat(user, "<span class='warning'>[src]'s trigger is locked. This weapon doesn't have a firing pin installed!</span>")
	return 0

/obj/item/gun/update_overlays()
	. = ..()
	if(!(item_flags & ITEM_IN_INVENTORY))
		return
	. += image('icons/modules/projectiles/guns/common-overlays.dmi', "safety-[check_safety()? "on" : "off"]")

/obj/item/gun/proc/toggle_safety(mob/user)
	if(user)
		if(user.stat || user.restrained() || user.incapacitated(INCAPACITATION_DISABLED))
			to_chat(user, SPAN_WARNING("You can't do that right now."))
			return
	if(safety_state == GUN_NO_SAFETY)
		to_chat(user, SPAN_WARNING("[src] has no safety."))
		return
	var/current = check_safety()
	switch(safety_state)
		if(GUN_SAFETY_ON)
			safety_state = GUN_SAFETY_OFF
		if(GUN_SAFETY_OFF)
			safety_state = GUN_SAFETY_ON
	if(user)
		user.visible_message(
			SPAN_WARNING("[user] switches the safety of \the [src] [current ? "off" : "on"]."),
			SPAN_NOTICE("You switch the safety of \the [src] [current ? "off" : "on"]."),
			SPAN_WARNING("You hear a switch being clicked."),
			MESSAGE_RANGE_COMBAT_SUBTLE
		)
	update_appearance()
	playsound(src, 'sound/weapons/flipblade.ogg', 10, 1)

/obj/item/gun/verb/toggle_safety_verb()
	set src in usr
	set category = VERB_CATEGORY_OBJECT
	set name = "Toggle Gun Safety"

	if(usr == loc)
		toggle_safety(usr)

/**
 * returns TRUE/FALSE based on if we have safeties on
 */
/obj/item/gun/proc/check_safety()
	return (safety_state == GUN_SAFETY_ON)

//* Actions *//

/obj/item/gun/register_item_actions(mob/user)
	. = ..()
	for(var/obj/item/gun_attachment/attachment as anything in attachments)
		attachment.register_attachment_actions(user)
	firemode_swap_action?.grant(user.inventory.actions)

/obj/item/gun/unregister_item_actions(mob/user)
	. = ..()
	for(var/obj/item/gun_attachment/attachment as anything in attachments)
		attachment.unregister_attachment_actions(user)
	firemode_swap_action?.revoke(user.inventory.actions)

/obj/item/gun/proc/reconsider_firemode_action()
	if(length(firemodes) <= 1)
		QDEL_NULL(firemode_swap_action)
		return
	if(!firemode_swap_action)
		firemode_swap_action = new /datum/action/item_action/gun_firemode_swap(src)
		if(inv_inside)
			firemode_swap_action.grant(inv_inside.actions)

/obj/item/gun/ui_action_click(datum/action/action, datum/event_args/actor/actor)
	return FALSE

//* Ammo *//

/**
 * Gets the ratio of our ammo left
 *
 * * Used by rendering
 * * DO NOT RETURN OVER 1.
 *
 * @params
 * * rounded - round to nearest ammo
 *
 * @return number as 0 to 1, inclusive
 */
/obj/item/gun/proc/get_ammo_ratio(rounded)
	return 0

/**
 * Gets approximate ammo left.
 *
 * * Used by examine
 * * Do not return under 0
 * * Round this yourself if you want.
 *
 * @return number
 */
/obj/item/gun/proc/get_ammo_remaining()
	return 0

//* Cell System *//

/obj/item/gun/object_cell_slot_inserted(obj/item/cell/cell, datum/object_system/cell_slot/slot)
	. = ..()
	update_icon()
	update_worn_icon()

/obj/item/gun/object_cell_slot_removed(obj/item/cell/cell, datum/object_system/cell_slot/slot)
	. = ..()
	update_icon()
	update_worn_icon()

//* Context *//

/obj/item/gun/context_menu_query(datum/event_args/actor/e_args)
	. = ..()
	if(length(attachments))
		.["remove-attachment"] = create_context_menu_tuple("Remove Attachment", image('icons/screen/radial/actions.dmi', "red-arrow-up"), 0, MOBILITY_CAN_USE)
	if(length(modular_components))
		// only show menu option if atleast one can be removed.
		for(var/obj/item/gun_component/component as anything in modular_components)
			if(!component.can_remove)
				continue
			.["remove-component"] = create_context_menu_tuple("Remove Component", image('icons/screen/radial/actions.dmi', "red-arrow-up"), 0, MOBILITY_CAN_USE)
			break
	if(safety_state != GUN_NO_SAFETY)
		.["toggle-safety"] = create_context_menu_tuple("Toggle Safety", image(src), 0, MOBILITY_CAN_USE, TRUE)

/obj/item/gun/context_menu_act(datum/event_args/actor/e_args, key)
	. = ..()
	if(.)
		return
	switch(key)
		if("remove-attachment")
			// todo: e_args support
			// todo: better automatic context / radial menus none of this manual anchoring bullshit
			var/obj/item/gun_attachment/attachment = show_radial_menu(e_args.initiator, isturf(loc) ? src : e_args.performer, attachments)
			if(!attachment)
				return TRUE
			if(!e_args.performer.Reachability(src) || !(e_args.performer.mobility_flags & MOBILITY_CAN_USE))
				return TRUE
			user_uninstall_attachment(attachment, e_args, TRUE)
			return TRUE
		if("remove-component")
			// todo: e_args support
			// todo: better automatic context / radial menus none of this manual anchoring bullshit
			var/obj/item/gun_component/component = show_radial_menu(e_args.initiator, isturf(loc) ? src : e_args.performer, modular_components)
			if(!component)
				return TRUE
			if(!e_args.performer.Reachability(src) || !(e_args.performer.mobility_flags & MOBILITY_CAN_USE))
				return TRUE
			user_uninstall_modular_component(component, e_args, TRUE)
			return TRUE
		if("toggle-safety")
			toggle_safety(e_args.performer)
			return TRUE

//* Firemodes *//

/**
 * Ensures our firemodes list is not a cached copy.
 *
 * * This absolutely must be called before **any** mutating writes to
 *   `firemodes` or its contents.
 */
/obj/item/gun/proc/ensure_firemodes_owned()
	if(!is_typelist(NAMEOF(src, firemodes), firemodes))
		return
	firemodes = deep_clone_list(firemodes)

//* Interaction *//

/obj/item/gun/CtrlClick(mob/user)
	. = ..()
	if(user.is_holding(src))
		toggle_safety(user)

//* Rendering *//

/obj/item/gun/update_icon(updates)
	// todo: shouldn't need this check, deal with legacy
	if(!item_renderer && !mob_renderer && render_use_legacy_by_default)
		return ..()
	cut_overlays()
	. = ..()

	var/using_base_icon_state = base_icon_state || initial(icon_state)
	var/using_base_worn_state = base_mob_state || initial(worn_state) || using_base_icon_state
	if(render_wielded && (item_flags & ITEM_MULTIHAND_WIELDED))
		using_base_worn_state = "[using_base_worn_state]-wield"
	var/using_ratio = get_ammo_ratio(TRUE)
	var/using_color = get_firemode_color()
	var/using_key = get_firemode_key()

	item_renderer?.render(src, using_base_icon_state, using_ratio, using_key, using_color)
	var/needs_worn_update = mob_renderer?.render(src, using_base_worn_state, using_ratio, using_key, using_color)

	if(needs_worn_update)
		update_worn_icon()
	firemode_swap_action?.update_buttons()

/obj/item/gun/render_apply_overlays(mutable_appearance/MA, bodytype, inhands, datum/inventory_slot/slot_meta, icon_used)
	// todo: the code copypaste here is atrocious
	var/using_base_worn_state = base_mob_state || initial(worn_state) || base_icon_state || initial(icon_state)
	if(render_wielded && (item_flags & ITEM_MULTIHAND_WIELDED))
		using_base_worn_state = "[using_base_worn_state]-wield"
	var/using_ratio = get_ammo_ratio()
	var/using_color = get_firemode_color()
	var/using_key = get_firemode_key()
	var/list/overlays = mob_renderer?.render_overlays(src, using_base_worn_state, using_ratio, using_key, using_color)
	if(length(overlays))
		var/append = "_[slot_meta.render_key]"
		for(var/i in 1 to length(overlays))
			var/image/maybe_image_touching_up = overlays[i]
			if(istext(maybe_image_touching_up))
				overlays[i] = maybe_image_touching_up + append
			else if(isimage(maybe_image_touching_up) || ismutableappearance(maybe_image_touching_up))
				maybe_image_touching_up.icon_state += append
		MA.overlays += overlays
	return ..()

/**
 * Gets the color our firemode renders as during rendering.
 */
/obj/item/gun/proc/get_firemode_color()
	return firemode?.render_color

/**
 * Gets the key our firemode renders as during rendering.
 */
/obj/item/gun/proc/get_firemode_key()
	return firemode?.render_key

//* Action Datums *//

/datum/action/item_action/gun_firemode_swap
	name = "Switch Firemode"
	desc = "Switch to the next firemode."
	target_type = /obj/item/gun
	check_mobility_flags = MOBILITY_CAN_USE

/datum/action/item_action/gun_firemode_swap/pre_render_hook()
	. = ..()
	var/image/item_overlay = button_additional_overlay
	var/image/symbol_overlay = image('icons/screen/actions/generic-overlays.dmi', "swap")
	symbol_overlay.color = "#00ff00"
	symbol_overlay.alpha = 200
	symbol_overlay.pixel_y = -16
	item_overlay.add_overlay(symbol_overlay)
	target_type = /obj/item/gun/projectile/energy

/datum/action/item_action/gun_firemode_swap/invoke_target(obj/item/gun/target, datum/event_args/actor/actor)
	. = ..()
	target.user_switch_firemodes(actor)
