/**
 * Cargo department clothing
 */

/obj/item/clothing/under/rank/cargo/skirt
	name = "quartermaster's jumpskirt"
	desc = "It's a jumpskirt worn by the quartermaster. It's specially designed to prevent back injuries caused by pushing paper."
	icon = 'icons/clothing/uniform/workwear/dept_cargo/qmf.dmi'
	icon_state = "qmf"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/cargotech/skirt
	name = "cargo technician's jumpskirt"
	desc = "Skirrrrrts! They're comfy and easy to wear!"
	icon = 'icons/clothing/uniform/workwear/dept_cargo/cargof.dmi'
	icon_state = "cargof"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/cargo
	name = "quartermaster's jumpsuit"
	desc = "It's a jumpsuit worn by the quartermaster. It's specially designed to prevent back injuries caused by pushing paper."
	icon = 'icons/clothing/uniform/workwear/dept_cargo/qm.dmi'
	icon_state = "qm"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_rolldown_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)

/obj/item/clothing/under/rank/cargo/skirt_pleated
	name = "quartermaster's pleated skirt"
	desc = "Skiiiiiirt! It's pleated!"
	icon = 'icons/clothing/uniform/workwear/dept_cargo/qm_skirt.dmi'
	icon_state = "qm_skirt"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_rolldown_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/cargo/jeans
	name = "quartermaster's jumpjeans"
	desc = "Jeeeaaans! They're comfy!"
	icon = 'icons/clothing/uniform/workwear/dept_cargo/qmj.dmi'
	icon_state = "qmj"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)

/obj/item/clothing/under/rank/cargo/jeans/female
	name = "quartermaster's jumpjeans"
	desc = "Jeeeaaans! They're comfy!"
	icon = 'icons/clothing/uniform/workwear/dept_cargo/qmjf.dmi'
	icon_state = "qmjf"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/cargotech
	name = "cargo technician's jumpsuit"
	desc = "Shooooorts! They're comfy and easy to wear!"
	icon = 'icons/clothing/uniform/workwear/dept_cargo/cargo.dmi'
	icon_state = "cargo"
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|ARMS
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_rolldown_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)

/obj/item/clothing/under/rank/cargotech/jeans
	name = "cargo technician's jumpjeans"
	desc = "Jeeeaaans! They're comfy!"
	icon = 'icons/clothing/uniform/workwear/dept_cargo/cargoj.dmi'
	icon_state = "cargoj"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)

/obj/item/clothing/under/rank/cargotech/jeans/female
	name = "cargo technician's jumpjeans"
	desc = "Jeeeaaans! They're comfy!"
	icon = 'icons/clothing/uniform/workwear/dept_cargo/cargojf.dmi'
	icon_state = "cargojf"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/cargotech/skirt_pleated
	name = "cargo technician's pleated skirt"
	desc = "Skiiiiiirt! It's pleated!"
	icon = 'icons/clothing/uniform/workwear/dept_cargo/cargo_skirt.dmi'
	icon_state = "cargo_skirt"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)

/obj/item/clothing/under/rank/miner
	desc = "It's a snappy jumpsuit with a sturdy set of overalls. It is very dirty."
	name = "shaft miner's jumpsuit"
	icon = 'icons/clothing/uniform/workwear/dept_cargo/miner.dmi'
	icon_state = "miner"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_rolldown_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)
