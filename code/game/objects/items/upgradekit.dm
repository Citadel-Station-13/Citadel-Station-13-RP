/obj/item/kevlarupgrade
	name = "kevlar upgrade kit"
	desc = "A kit for reinforcing standard jumpsuits with kevlar weave, upgrading their armour slightly."
	icon = 'icons/obj/clothing/modular_armor.dmi'	// NO LONGER A PLACEHOLDER
	icon_state = "kevlar_upgrade"	// RIP PLACEHOLDERS WOOO

/obj/item/kevlarupgrade/afterattack(atom/target, mob/user, clickchain_flags, list/params)
	if(!(clickchain_flags & CLICKCHAIN_HAS_PROXIMITY))
		return ..()

	if(istype(target, /obj/item/clothing/under))
		var/obj/item/clothing/under/C = target
		if(C.fetch_armor().is_atleast(list(
			ARMOR_MELEE = 0.2,
			ARMOR_BULLET = 0.1,
			ARMOR_LASER = 0.1,
		)))
			to_chat(user, "This item cannot be upgraded any further!")
			return CLICKCHAIN_DO_NOT_PROPAGATE
		C.set_armor(C.fetch_armor().boosted(list(
			ARMOR_MELEE = 0.2,
			ARMOR_BULLET = 0.1,
			ARMOR_LASER = 0.1,
		)))

		to_chat(user, "Armor upgrade successful!")
		qdel(src)
		return CLICKCHAIN_DO_NOT_PROPAGATE
	return ..()
