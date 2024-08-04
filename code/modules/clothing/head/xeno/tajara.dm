//Hats

/obj/item/clothing/head/tajaran
	icon = 'icons/obj/clothing/species/tajaran/hats.dmi'
	icon_override = 'icons/mob/clothing/species/tajaran/helmet.dmi'

/obj/item/clothing/head/tajaran/circlet
	name = "golden dress circlet"
	desc = "A golden circlet with a pearl in the middle of it."
	icon_state = "taj_circlet"
	item_state = "taj_circlet"

/obj/item/clothing/head/tajaran/circlet/silver
	name = "silver dress circlet"
	desc = "A silver circlet with a pearl in the middle of it."
	icon_state = "taj_circlet_s"
	item_state = "taj_circlet_s"

/obj/item/clothing/head/tajaran/fur
	name = "adhomian fur hat"
	desc = "A typical tajaran hat, made with the fur of some adhomian animal."
	icon_state = "fur_hat"
	item_state = "fur_hat"

/obj/item/clothing/head/tajaran/cosmonaut_commissar
	name = "kosmostrelki commissar hat"
	desc = "A peaked cap used by Party Commissars attached to kosmostrelki units."
	icon_state = "space_commissar_hat"
	item_state = "space_commissar_hat"

/obj/item/clothing/head/tajaran/orbital_captain
	name = "orbital fleet captain hat"
	desc = "A cap used by the Orbital Fleet captains."
	icon_state = "orbital_captain_hat"
	item_state = "orbital_captain_hat"

/obj/item/clothing/head/tajaran/nka_cap
	name = "imperial adhomian army service cap"
	desc = "A simple service cap worn by soldiers of the Imperial Adhomian Army."
	icon_state = "nkahat"
	item_state = "nkahat"

/obj/item/clothing/head/tajaran/nka_cap/commander
	desc = "A fancy service cap worn by officer of the Imperial Adhomian Army."
	icon_state = "nka_commander_hat"
	item_state = "nka_commander_hat"

/obj/item/clothing/head/tajaran/nka_cap/sailor
	name = "royal navy service hat"
	desc = "A simple service hat worn by sailors of the Royal Navy."
	icon_state = "nka_sailor_hat"
	item_state = "nka_sailor_hat"

/obj/item/clothing/head/tajaran/consular
	name = "consular service cap"
	desc = "A service cap worn by the diplomatic service of the People's Republic of Adhomai."
	icon_state = "pra_consularhat"
	item_state = "pra_consularhat"

/obj/item/clothing/head/tajaran/consular/side_cap
	name = "consular service side cap"
	icon_state = "pra_pilotka"
	item_state = "pra_pilotka"

/obj/item/clothing/head/tajaran/consular/dpra
	desc = "A service cap worn by the diplomatic service of the Democratic People's Republic of Adhomai."
	icon_state = "dpra_consularhat"
	item_state = "dpra_consularhat"

/obj/item/clothing/head/tajaran/consular/dpra/side_cap
	name = "consular service side cap"
	icon_state = "dpra_pilotka"
	item_state = "dpra_pilotka"

/obj/item/clothing/head/tajaran/consular/nka
	name = "royal consular hat"
	desc = "A fancy hat worn by the diplomatic service of the New Kingdom of Adhomai."
	icon_state = "nka_consularhat"
	item_state = "nka_consularhat"

/obj/item/clothing/head/tajaran/archeologist
	name = "archaeologist hat"
	desc = "A well-worn fedora favored by Adhomian explorers and archaeologists. Not very protective but still very stylish."
	icon_state = "explorer_hat"
	item_state = "explorer_hat"

/obj/item/clothing/head/tajaran/army_commissar
	name = "army commissar hat"
	desc = "A peaked cap used by Party Commissars attached to military units."
	icon_state = "pracommisar_hat"
	item_state = "pracommisar_hat"

/obj/item/clothing/head/tajaran/psis
	name = "people's strategic intelligence service cap"
	desc = "A hat issued to the agents of the People's Strategic Intelligence Service."
	icon_state = "psis_hat"
	item_state = "psis_hat"

//Non-void Helments
/obj/item/clothing/head/helmet/amohda // Changed to be generic
	name = "Adhomian swordsman helmet"
	desc = "A helmet used by tajaran swordsmen."
	icon = 'icons/obj/clothing/species/tajaran/hats.dmi'
	icon_override = 'icons/mob/clothing/species/tajaran/helmet.dmi'
	icon_state = "amohdan_helmet"
	item_state = "amohdan_helmet"
	body_cover_flags = HEAD|FACE|EYES
	inv_hide_flags = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|BLOCKHAIR
	species_restricted = list(SPECIES_TAJ)
	armor_type = /datum/armor/general/medieval
	siemens_coefficient = 0.35

/obj/item/clothing/head/helmet/tajaran/kettle
	name = "Adhomian kettle helmet"
	desc = "A kettle helmet used by the forces of the new Kingdom of Adhomai."
	icon = 'icons/obj/clothing/species/tajaran/hats.dmi'
	icon_override = 'icons/mob/clothing/species/tajaran/helmet.dmi'
	icon_state = "kettle_helment"
	item_state = "kettle_helment"
	armor_type = /datum/armor/general/medieval/light

//Berets
/obj/item/clothing/head/beret/tajaran
	name = "hadiist army beret"
	desc = "A green beret issued to hadiist soldiers."
	icon = 'icons/obj/clothing/species/tajaran/hats.dmi'
	icon_override = 'icons/mob/clothing/species/tajaran/helmet.dmi'
	icon_state = "praberet"
	item_state = "praberet"
	body_cover_flags = HEAD

/obj/item/clothing/head/beret/tajaran/dpra
	name = "liberation army beret"
	desc = "A beret issued to liberation army soldiers."
	icon_state = "alaberet"
	item_state = "alaberet"

/obj/item/clothing/head/beret/tajaran/dpra/alt
	icon_state = "alaberetalt"
	item_state = "alaberetalt"

/obj/item/clothing/head/beret/tajaran/pvsm
	name = "people's volunteer spacer militia beret"
	desc = "A beret issued to people's volunteer spacer militia."
	icon_state = "alaberetalt"
	item_state = "alaberetalt"

/obj/item/clothing/head/beret/tajaran/nka
	name = "new kingdom naval beret"
	desc = "A formal black beret with a blue band. This is worn by NKA naval servicemen and crewmen such as the Imperial Marines."
	icon_state = "navalberetblue"
	item_state = "navalberetblue"

/obj/item/clothing/head/beret/tajaran/nka/officer
	name = "new kingdom naval officer beret"
	desc = "A formal black beret with a golden band. This is worn by members of the NKA naval officer corps. These are prized in the New Kingdom thanks to the Navy's popularity."
	icon_state = "navalberetofficer"
	item_state = "navalberetofficer"

/obj/item/clothing/head/beret/tajaran/raakti_shariim
	name = "\improper Raakti Shariim beret"
	desc = "A blue beret with a pale-gold twin-suns insignia, signifying a Constable of the NKA's Raakti Shariim."
	icon_state = "raakti_shariim_beret"
	item_state = "raakti_shariim_beret"




