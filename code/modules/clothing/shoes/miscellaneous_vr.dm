/obj/item/clothing/shoes/griffin
	name = "griffon boots"
	desc = "A pair of costume boots fashioned after bird talons."
	icon_state = "griffinboots"
	item_state = "griffinboots"
	icon = 'icons/obj/clothing/shoes.dmi'

/obj/item/clothing/shoes/bhop
	name = "jump boots"
	desc = "A specialized pair of combat boots with a built-in propulsion system for rapid foward movement."
	icon_state = "jetboots"
	item_state = "jetboots"
	icon = 'icons/obj/clothing/shoes.dmi'
	// resistance_flags = FIRE_PROOF
	action_button_name = "Activate Jump Boots"
	permeability_coefficient = 0.05
	var/jumpdistance = 5 //-1 from to see the actual distance, e.g 4 goes over 3 tiles
	var/jumpspeed = 3
	var/recharging_rate = 60 //default 6 seconds between each dash
	var/recharging_time = 0 //time until next dash
	// var/jumping = FALSE //are we mid-jump? We have no throw_at_old callback, so we have to check user.throwing.

/obj/item/clothing/shoes/bhop/ui_action_click()
	var/mob/living/user = loc
	if(!isliving(user))
		return

	if(user.throwing)
		return // User is already being thrown

	if(recharging_time > world.time)
		to_chat(user, SPAN_WARNING("The boot's internal propulsion needs to recharge still!"))
		return

	var/atom/target = get_edge_target_turf(user, user.dir) //gets the user's direction

	playsound(src, 'sound/effects/stealthoff.ogg', 50, 1, 1)
	user.visible_message(SPAN_WARNING("[user] dashes forward into the air!"))
	user.throw_at_old(target, jumpdistance, jumpspeed)
	recharging_time = world.time + recharging_rate
