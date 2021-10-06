/datum/keybinding/mob
	category = CATEGORY_HUMAN
	weight = WEIGHT_MOB

/datum/keybinding/mob/face_north
	hotkey_keys = list("CtrlW", "CtrlNorth")
	name = "face_north"
	full_name = "Face North"
	description = ""

/datum/keybinding/mob/face_north/down(client/user)
	var/mob/M = user.mob
	M.northface()
	return TRUE

/datum/keybinding/mob/face_east
	hotkey_keys = list("CtrlD", "CtrlEast")
	name = "face_east"
	full_name = "Face East"
	description = ""

/datum/keybinding/mob/face_east/down(client/user)
	var/mob/M = user.mob
	M.eastface()
	return TRUE

/datum/keybinding/mob/face_south
	hotkey_keys = list("CtrlS", "CtrlSouth")
	name = "face_south"
	full_name = "Face South"
	description = ""

/datum/keybinding/mob/face_south/down(client/user)
	var/mob/M = user.mob
	M.southface()
	return TRUE

/datum/keybinding/mob/face_west
	hotkey_keys = list("CtrlA", "CtrlWest")
	name = "face_west"
	full_name = "Face West"
	description = ""

/datum/keybinding/mob/face_west/down(client/user)
	var/mob/M = user.mob
	M.westface()
	return TRUE

/datum/keybinding/mob/stop_pulling
	hotkey_keys = list("J", "Delete")
	name = "stop_pulling"
	full_name = "Stop pulling"
	description = ""

/datum/keybinding/mob/stop_pulling/down(client/user)
	var/mob/M = user.mob
	if(!M.pulling)
		to_chat(user, "<span class='notice'>You are not pulling anything.</span>")
	else
		M.stop_pulling()
	return TRUE

/datum/keybinding/mob/cycle_intent_right
	hotkey_keys = list("Northwest", "F") // HOME
	name = "cycle_intent_right"
	full_name = "cycle intent right"
	description = ""

/datum/keybinding/mob/cycle_intent_right/down(client/user)
	var/mob/M = user.mob
	M.a_intent_change(INTENT_HOTKEY_RIGHT)
	return TRUE

/datum/keybinding/mob/cycle_intent_left
	hotkey_keys = list("Insert", "G")
	name = "cycle_intent_left"
	full_name = "cycle intent left"
	description = ""

/datum/keybinding/mob/cycle_intent_left/down(client/user)
	var/mob/M = user.mob
	M.a_intent_change(INTENT_HOTKEY_LEFT)
	return TRUE

/datum/keybinding/mob/swap_hands
	hotkey_keys = list("X", "Northeast") // PAGEUP
	name = "swap_hands"
	full_name = "Swap hands"
	description = ""

/datum/keybinding/mob/swap_hands/down(client/user)
	var/mob/M = user.mob
	M.swap_hand()
	return TRUE

/datum/keybinding/mob/activate_inhand
	hotkey_keys = list("Z", "Southeast") // PAGEDOWN
	name = "activate_inhand"
	full_name = "Activate in-hand"
	description = "Uses whatever item you have inhand"

/datum/keybinding/mob/activate_inhand/down(client/user)
	var/mob/M = user.mob
	M.mode()
	return TRUE

/datum/keybinding/mob/say
	hotkey_keys = list("T", "F3")
	name = "say"
	full_name = "Say"
	description = "Say things in character."

/datum/keybinding/mob/say/down(client/user)
	user.mob.say_wrapper()
	return TRUE

/datum/keybinding/mob/me
	hotkey_keys = list("M", "5", "F4")
	name = "me"
	full_name = "Me"
	description = "Emote something in character."

/datum/keybinding/mob/me/down(client/user)
	user.mob.me_wrapper()
	return TRUE

/datum/keybinding/mob/ooc
	hotkey_keys = list("O")
	name = "ooc"
	full_name = "OOC"
	description = "Says something in global OOC"

/datum/keybinding/mob/ooc/down(client/user)
	user.ooc_wrapper()
	return TRUE

/datum/keybinding/mob/looc
	hotkey_keys = list("L")
	name = "looc"
	full_name = "LOOC"
	description = "Says something in local OOC"

/datum/keybinding/mob/looc/down(client/user)
	user.looc_wrapper()
	return TRUE

/datum/keybinding/mob/whisper
	hotkey_keys = list("Y")
	name = "whisper"
	full_name = "Whisper"
	description = "Whisper something in character."

/datum/keybinding/mob/whisper/down(client/user)
	user.mob.whisper_wrapper()
	return TRUE

/datum/keybinding/mob/subtle
	hotkey_keys = list("6")
	name = "subtle"
	full_name = "Subtle"
	description = "Does a subtle emote."

/datum/keybinding/mob/subtle/down(client/user)
	user.mob.subtle_wrapper()
	return TRUE

/datum/keybinding/mob/drop_item
	hotkey_keys = list("Q")
	name = "drop_item"
	full_name = "Drop Item"
	description = ""

/datum/keybinding/mob/drop_item/down(client/user)
	if(isrobot(user.mob)) //cyborgs can't drop items
		return FALSE
	var/mob/M = user.mob
	var/obj/item/I = M.get_active_hand()
	if(!I)
		to_chat(user, "<span class='warning'>You have nothing to drop in your hand!</span>")
	else
		M.drop_item(M.drop_location())
	return TRUE

/datum/keybinding/mob/toggle_gun_mode
	hotkey_keys = list("J")
	name = "toggle_gun_mode"
	full_name = "Toggle gun mode between aiming/hostage-taking and immediate fire."
	description = ""

/datum/keybinding/mob/toggle_gun_mode/down(client/user)
	user.mob.toggle_gun_mode()
	return TRUE

/datum/keybinding/mob/toggle_move_intent
	hotkey_keys = list("Alt")
	name = "toggle_move_intent"
	full_name = "Hold to toggle move intent"
	description = "Held down to cycle to the other move intent, release to cycle back"

/datum/keybinding/mob/toggle_move_intent/down(client/user)
	var/mob/M = user.mob
	M.toggle_move_intent()
	return TRUE

/datum/keybinding/mob/toggle_move_intent/up(client/user)
	var/mob/M = user.mob
	M.toggle_move_intent()
	return TRUE

/datum/keybinding/mob/toggle_move_intent_alternative
	hotkey_keys = list("Unbound")
	name = "toggle_move_intent_alt"
	full_name = "press to cycle move intent"
	description = "Pressing this cycle to the opposite move intent, does not cycle back"

/datum/keybinding/mob/toggle_move_intent_alternative/down(client/user)
	var/mob/M = user.mob
	M.toggle_move_intent()
	return TRUE

/datum/keybinding/mob/target_head_cycle
	hotkey_keys = list("Numpad8")
	name = "target_head_cycle"
	full_name = "Target: Cycle head"
	description = ""

/datum/keybinding/mob/target_head_cycle/down(client/user)
	user.body_toggle_head()
	return TRUE

/datum/keybinding/mob/target_r_arm
	hotkey_keys = list("Numpad4")
	name = "target_r_arm"
	full_name = "Target: right arm"
	description = ""

/datum/keybinding/mob/target_r_arm/down(client/user)
	user.body_r_arm()
	return TRUE

/datum/keybinding/mob/target_body_chest
	hotkey_keys = list("Numpad5")
	name = "target_body_chest"
	full_name = "Target: Body"
	description = ""

/datum/keybinding/mob/target_body_chest/down(client/user)
	user.body_chest()
	return TRUE

/datum/keybinding/mob/target_left_arm
	hotkey_keys = list("Numpad6")
	name = "target_left_arm"
	full_name = "Target: left arm"
	description = ""

/datum/keybinding/mob/target_left_arm/down(client/user)
	user.body_l_arm()
	return TRUE

/datum/keybinding/mob/target_right_leg
	hotkey_keys = list("Numpad1")
	name = "target_right_leg"
	full_name = "Target: Right leg"
	description = ""

/datum/keybinding/mob/target_right_leg/down(client/user)
	user.body_r_leg()
	return TRUE

/datum/keybinding/mob/target_body_groin
	hotkey_keys = list("Numpad2")
	name = "target_body_groin"
	full_name = "Target: Groin"
	description = ""

/datum/keybinding/mob/target_body_groin/down(client/user)
	user.body_groin()
	return TRUE

/datum/keybinding/mob/target_left_leg
	hotkey_keys = list("Numpad3")
	name = "target_left_leg"
	full_name = "Target: left leg"
	description = ""

/datum/keybinding/mob/target_left_leg/down(client/user)
	user.body_l_leg()
	return TRUE
