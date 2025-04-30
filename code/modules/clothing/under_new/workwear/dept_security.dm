/**
 * Security department clothing
 */

//Prisoners are technically members of the security department.
/obj/item/clothing/under/color/prison
	name = "prison jumpsuit"
	desc = "It's standardized prisoner-wear. Its suit sensors are permanently set to the \"Tracking\" position."
	icon = 'icons/clothing/uniform/workwear/dept_security/prison.dmi'
	icon_state = "prison"
	has_sensors = UNIFORM_HAS_LOCKED_SENSORS
	sensor_mode = 3
	worn_bodytypes = BODYTYPE_DEFAULT | BODYTYPE_TESHARI | BODYTYPE_UNATHI_DIGI | BODYTYPE_VOX

/obj/item/clothing/under/color/prison/skirt
	name = "prison pleated skirt"
	icon = 'icons/clothing/uniform/workwear/dept_security/prison_skirt.dmi'
	icon_state = "prison_skirt"
