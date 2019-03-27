/obj/item/weapon/reagent_containers/spray/luminol
	name = "luminol bottle"
	desc = "A bottle containing an odourless, colorless liquid."
	icon = 'icons/obj/forensics.dmi'
	icon_state = "luminol"
	item_state = "cleaner"
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10)
	volume = 250

<<<<<<< HEAD
/obj/item/weapon/reagent_containers/spray/luminol/initialize()
	..()
=======
/obj/item/weapon/reagent_containers/spray/luminol/Initialize()
	. = ..()
>>>>>>> dce3466... Merge pull request #4684 from VOREStation/upstream-merge-5814
	reagents.add_reagent("luminol", 250)