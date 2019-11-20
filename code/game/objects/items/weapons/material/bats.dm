/obj/item/weapon/material/twohanded/baseballbat
	name = "bat"
	desc = "HOME RUN!"
	icon_state = "metalbat0"
	base_icon = "metalbat"
	throwforce = 7
	attack_verb = list("smashed", "beaten", "slammed", "smacked", "struck", "battered", "bonked")
	hitsound = 'sound/weapons/genhit3.ogg'
	material_primary = MATERIAL_ID_WOOD
	force_divisor = 1.1           // 22 when wielded with weight 20 (steel)
	unwielded_force_divisor = 0.7 // 15 when unwielded based on above.
	dulled_divisor = 0.75		  // A "dull" bat is still gonna hurt
	slot_flags = SLOT_BACK

//Predefined materials go here.
/obj/item/weapon/material/twohanded/baseballbat/metal
	material_primary = MATERIAL_ID_STEEL

/obj/item/weapon/material/twohanded/baseballbat/uranium/
	material_primary = MATERIAL_ID_URANIUM

/obj/item/weapon/material/twohanded/baseballbat/gold
	material_primary = MATERIAL_ID_GOLD

/obj/item/weapon/material/twohanded/baseballbat/platinum
	material_primary = MATERIAL_ID_PLATINUM

/obj/item/weapon/material/twohanded/baseballbat/diamond
	material_primary = MATERIAL_ID_DIAMOND