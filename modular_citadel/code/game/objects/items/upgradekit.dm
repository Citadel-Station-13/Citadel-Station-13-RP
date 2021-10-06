/obj/item/kevlarupgrade
	name = "kevlar upgrade kit"
	desc = "A kit for reinforcing standard jumpsuits with kevlar weave, upgrading their armour slightly."
	icon = 'icons/obj/clothing/modular_armor.dmi'	// NO LONGER A PLACEHOLDER
	icon_state = "kevlar_upgrade"	// RIP PLACEHOLDERS WOOO

/obj/item/kevlarupgrade/afterattack(atom/A, mob/user)
	var/meleemax = FALSE
	var/bulletmax = FALSE
	var/lasermax = FALSE
	var/used = FALSE

	if(isobj(A) && istype(A, /obj/item/clothing/under))
		var/obj/item/clothing/under/C = A
		if(C.armor["melee"] >= 10)
			meleemax = TRUE
		if(C.armor["bullet"] >= 5)
			bulletmax = TRUE
		if(C.armor["laser"] >= 5)
			lasermax = TRUE

		if(meleemax != TRUE)
			C.armor["melee"] = 10
			used = TRUE
		if(bulletmax != TRUE)
			C.armor["bullet"] = 5
			used = TRUE
		if(lasermax != TRUE)
			C.armor["laser"] = 5
			used = TRUE

		if(used == TRUE)
			to_chat(user, "Armor upgrade successful!")
			qdel(src)
			return
		else
			to_chat(user, "This item cannot be upgraded any further!")
			return
	else
		return

