/**
 * Catpeople workwear clothing
 */

/obj/item/clothing/under/tajaran
	name = "laborer cloths"
	desc = "A rough but thin outfit, providing air flow but also protection from working hazards."
	icon = 'icons/clothing/uniform/workwear/tajaran/taj_labor.dmi'
	icon_state = "taj_labor"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/tajaran/nt
	name = "Nanotrasen overalls"
	desc = "Overalls meant for Nanotrasen employees of xeno descent, modified to prevent overheating."
	icon = 'icons/clothing/uniform/workwear/tajaran/ntoveralls.dmi'
	icon_state = "ntoveralls"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_rolldown_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/tajaran/matake
	name = "Mata'ke priest garments"
	desc = "Simple linen garments worn by Mata'ke priests."
	icon = 'icons/clothing/uniform/workwear/tajaran/matakeuniform.dmi'
	icon_state = "matakeuniform"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/tajaran/cosmonaut
	name = "kosmostrelki uniform"
	desc = "A military uniform used by the forces of the People's Republic of Adhomai orbital fleet."
	icon = 'icons/clothing/uniform/workwear/tajaran/cosmonaut.dmi'
	icon_state = "cosmonaut"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/tajaran/cosmonaut/commissar
	name = "kosmostrelki commissar uniform"
	desc = "A military uniform used by Party Commissars attached to kosmostrelki units."
	icon = 'icons/clothing/uniform/workwear/tajaran/space_commissar.dmi'
	icon_state = "space_commissar"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/tajaran/cosmonaut/captain
	name = "orbital fleet captain uniform"
	desc = "A military uniform used by a captain of the People's Republic of Adhomai orbital fleet."
	icon = 'icons/clothing/uniform/workwear/tajaran/orbital_captain.dmi'
	icon_state = "orbital_captain"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/tajaran/database_freighter
	name = "orbital fleet surveyor uniform"
	desc = "A pratical uniform used by the crew of the orbital fleet's database freighters."
	icon = 'icons/clothing/uniform/workwear/tajaran/database_freighter.dmi'
	icon_state = "database_freighter"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/tajaran/database_freighter/captain
	name = "orbital fleet head surveyor uniform"
	desc = "A pratical uniform used by the captains of the orbital fleet's database freighters."
	icon = 'icons/clothing/uniform/workwear/tajaran/database_freighter_captain.dmi'
	icon_state = "database_freighter_captain"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/tajaran/mechanic
	name = "machinist uniform"
	desc = "A simple and robust overall used by Adhomian urban workers."
	icon = 'icons/clothing/uniform/workwear/tajaran/mechanic.dmi'
	icon_state = "mechanic"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_rolldown_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/tajaran/raakti_shariim
	name = "\improper Raakti Shariim uniform"
	desc = "A blue and lilac adhomian uniform with pale-gold insignia, worn by members of the NKA's Raakti Shariim."
	icon = 'icons/clothing/uniform/workwear/tajaran/raakti_shariim_uniform.dmi'
	icon_state = "raakti_shariim_uniform"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

//Military uniforms no armor protection

/obj/item/clothing/under/tajaran/pra_uniform
	name = "republican army uniform"
	desc = "A military uniform used by the forces of Grand People's Army."
	icon = 'icons/clothing/uniform/workwear/tajaran/prauniform.dmi'
	icon_state = "prauniform"
	armor_type = /datum/armor/station/padded
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/tajaran/nka_uniform
	name = "imperial adhomian army uniform"
	desc = "A military uniform used by the forces of the New Kingdom of Adhomai's army."
	icon = 'icons/clothing/uniform/workwear/tajaran/nka_uniform.dmi'
	icon_state = "nka_uniform"
	armor_type = /datum/armor/station/padded
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/tajaran/nka_uniform/commander
	name = "imperial adhomian army officer uniform"
	desc = "A military uniform used by the officers of the New Kingdom of Adhomai's army."
	icon = 'icons/clothing/uniform/workwear/tajaran/nka_commander.dmi'
	icon_state = "nka_commander"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/tajaran/nka_uniform/sailor
	name = "royal navy sailor uniform"
	desc = "A military uniform used by the sailor of the New Kingdom of Adhomai's navy."
	icon = 'icons/clothing/uniform/workwear/tajaran/nka_sailor.dmi'
	icon_state = "nka_sailor"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/tajaran/consular
	name = "people's republic consular uniform"
	desc = "An olive uniform used by the diplomatic service of the People's Republic of Adhomai."
	icon = 'icons/clothing/uniform/workwear/tajaran/pra_consular.dmi'
	icon_state = "pra_consular"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/tajaran/consular/female
	icon = 'icons/clothing/uniform/workwear/tajaran/pra_con_f.dmi'
	icon_state = "pra_con_f"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/tajaran/consular/dpra
	name = "democratic people's republic consular uniform"
	desc = "A grey uniform used by the diplomatic service of the Democratic People's Republic of Adhomai."
	icon = 'icons/clothing/uniform/workwear/tajaran/dpra_consular.dmi'
	icon_state = "dpra_consular"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/tajaran/consular/dpra/female
	icon = 'icons/clothing/uniform/workwear/tajaran/dpra_con_f.dmi'
	icon_state = "dpra_con_f"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/tajaran/consular/nka
	name = "new kingdom consular uniform"
	desc = "A blue uniform used by the diplomatic service of the New Kingdom of Adhomai."
	icon = 'icons/clothing/uniform/workwear/tajaran/nka_consular.dmi'
	icon_state = "nka_consular"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/tajaran/hadiifolly
	name = "Hadii's Folly Governement uniform"
	desc = "Those modest uniform are made out of corporate prison jumpsuits, and the new uniform of members of the haddi's folley authority governement. Those uniform are worn by civilians working in the gouvernement."
	icon = 'icons/clothing/uniform/workwear/tajaran/hadiisgov.dmi'
	icon_state = "hadiisgov"
	armor_type = /datum/armor/station/padded
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/tajaran/hadiifolly/soldier
	name = "Hadii's Folly SDF uniform"
	desc = "Those modest uniform are made out of corporate prison jumpsuits, and the new uniform of members of the haddi's folley authority governement. Those uniform are worn by soldiers."
	icon = 'icons/clothing/uniform/workwear/tajaran/SDFhadiisgov.dmi'
	icon_state = "SDFhadiisgov"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/tajaran/hadiifolly/officer
	name = "Hadii's Folly SDF officer uniform"
	desc = "Those modest uniform are made out of corporate prison jumpsuits, and the new uniform of members of the haddi's folley authority governement. Those uniform are worn by officers."
	icon = 'icons/clothing/uniform/workwear/tajaran/SDFhadiisgovofficer.dmi'
	icon_state = "SDFhadiisgovofficer"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

//Check this
/obj/item/clothing/under/tajaran/dpra
	name = "al'mariist laborer clothes"
	desc = "Clothes commonly used by Das'nrra's workers. Due to their ubiquitousness, they became a symbol of the common Al'mariist people."
	icon = 'icons/clothing/uniform/workwear/tajaran/dpra_worker.dmi'
	icon_state = "dpra_worker"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/tajaran/dpra/alt
	icon = 'icons/clothing/uniform/workwear/tajaran/dpra_worker_alt.dmi'
	icon_state = "dpra_worker_alt"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/tajaran/nka_merchant_navy
	name = "his majesty's mercantile flotilla crew uniform"
	desc = "An uniform used by the crew of the New Kingdom's merchant space ships. It is clearly inspired by the ones used back on Adhomai."
	icon = 'icons/clothing/uniform/workwear/tajaran/nka_merchant_navy.dmi'
	icon_state = "nka_merchant_navy"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/tajaran/nka_merchant_navy/alt
	icon = 'icons/clothing/uniform/workwear/tajaran/nka_merchant_navy_alt.dmi'
	icon_state = "nka_merchant_navy_alt"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_rolldown_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/tajaran/nka_merchant_navy/captain
	name = "his majesty's mercantile flotilla captain uniform"
	desc = "An uniform used by the captain of the New Kingdom's merchant space ships. Not as fancy as the ones used in the Royal Navy."
	icon = 'icons/clothing/uniform/workwear/tajaran/nka_merchant_captain.dmi'
	icon_state = "nka_merchant_captain"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/tajaran/pvsm
	name = "people's volunteer spacer militia uniform"
	desc = "A military uniform used by the forces of the People's Volunteer Spacer Militia."
	icon = 'icons/clothing/uniform/workwear/tajaran/pvsm_crewman.dmi'
	icon_state = "pvsm_crewman"
	armor_type = /datum/armor/station/padded
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_rolldown_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/tajaran/pvsm/captain
	name = "people's volunteer spacer militia captain uniform"
	desc = "A military uniform used by the captains of the People's Volunteer Spacer Militia."
	icon = 'icons/clothing/uniform/workwear/tajaran/pvsm_captain.dmi'
	icon_state = "pvsm_captain"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_rolldown_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

//Should this be here?
/obj/item/clothing/under/tajaran/ala
	name = "adhomai liberation army uniform"
	desc = "A military uniform issued to soldiers of the adhomai liberation army."
	icon = 'icons/clothing/uniform/workwear/tajaran/ala-soldier-civ.dmi'
	icon_state = "ala-soldier-civ"
	armor_type = /datum/armor/station/padded
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/tajaran/ala/wraps
	icon = 'icons/clothing/uniform/workwear/tajaran/ala-grunt-wraps.dmi'
	icon_state = "ala-grunt-wraps"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/tajaran/ala/black
	icon = 'icons/clothing/uniform/workwear/tajaran/ala-soldat.dmi'
	icon_state = "ala-soldat"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/tajaran/ala/black/dress
	name = "adhomai liberation army dress uniform"
	icon = 'icons/clothing/uniform/workwear/tajaran/ala-soldatdress.dmi'
	icon_state = "ala-soldatdress"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/tajaran/ala/black/officer
	name = "adhomai liberation army officer uniform"
	desc = "A military uniform issued to officers of the adhomai liberation army."
	icon = 'icons/clothing/uniform/workwear/tajaran/ala-officer.dmi'
	icon_state = "ala-officer"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/tajaran/archeologist
	name = "archaeologist uniform"
	desc = "A rugged uniform used by Adhomian archaeologists. It is already covered in dirt and ancient dust."
	icon = 'icons/clothing/uniform/workwear/tajaran/explorer_uniform.dmi'
	icon_state = "explorer_uniform"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/tajaran/army_commissar
	name = "army commissar uniform"
	desc = "A military uniform used by Party Commissars attached to military units."
	icon = 'icons/clothing/uniform/workwear/tajaran/pracommisar.dmi'
	icon_state = "pracommisar"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/tajaran/psis
	name = "people's strategic intelligence service uniform"
	desc = "An uniform used by the agents of the People's Strategic Intelligence Service. The sight of this uniform is feared by most Tajara."
	icon = 'icons/clothing/uniform/workwear/tajaran/psis.dmi'
	icon_state = "psis"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"
