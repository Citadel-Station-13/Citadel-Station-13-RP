/obj/item/shockpaddles/standalone/rig
	desc = "You shouldn't be seeing these."
	chargetime = (2 SECONDS)

/obj/item/shockpaddles/standalone/rig/checked_use(var/charge_amt)
	return 1

/obj/item/shockpaddles/standalone/rig/emp_act(severity)
	return

/obj/item/shockpaddles/standalone/rig/can_use(mob/user, mob/M)
	return 1