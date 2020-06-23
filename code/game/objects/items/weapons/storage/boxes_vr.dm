/obj/item/storage/box/survival
	starts_with = list(
		/obj/item/tool/prybar/red,
		/obj/item/clothing/glasses/goggles,
		/obj/item/clothing/mask/breath
	)

/obj/item/storage/box/survival/synth
	starts_with = list(
		/obj/item/tool/prybar/red,
		/obj/item/clothing/glasses/goggles
	)

/obj/item/storage/box/survival/comp
	starts_with = list(
		/obj/item/tool/prybar/red,
		/obj/item/clothing/glasses/goggles,
		/obj/item/reagent_containers/hypospray/autoinjector,
		/obj/item/stack/medical/bruise_pack,
		/obj/item/flashlight/glowstick,
		/obj/item/reagent_containers/food/snacks/candy/proteinbar,
		/obj/item/clothing/mask/breath
	)

/obj/item/storage/box/explorerkeys
	name = "box of volunteer headsets"
	desc = "A box full of volunteer headsets, for issuing out to exploration volunteers."
	starts_with = list(/obj/item/radio/headset/volunteer = 7)

/obj/item/storage/box/treats
	name = "box of pet treats"
	desc = "A box full of small treats for pets, you could eat them too if you really wanted to, but why would you?"
	starts_with = list(/obj/item/reagent_containers/food/snacks/dtreat = 7)
/obj/item/storage/box/commandkeys
	name = "box of command keys"
	desc = "A box full of command keys, for command to give out as necessary."
	starts_with = list(/obj/item/encryptionkey/headset_com = 7)

/obj/item/storage/box/servicekeys
	name = "box of service keys"
	desc = "A box full of service keys, for the HoP to give out as necessary."
	starts_with = list(/obj/item/encryptionkey/headset_service = 7)

/obj/item/storage/box/survival/space
	name = "boxed emergency suit and helmet"
	icon_state = "survivaleng"
	starts_with = list(
		/obj/item/clothing/suit/space/emergency,
		/obj/item/clothing/head/helmet/space/emergency,
		/obj/item/clothing/mask/breath,
		/obj/item/tank/emergency/oxygen/double
	)

/obj/item/storage/secure/briefcase/trashmoney
	starts_with = list(/obj/item/spacecash/c200 = 10)
