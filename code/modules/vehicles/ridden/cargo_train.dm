/obj/vehicle/ridden/cart/cargo
	name = "cargo train tug"
	desc = "A ridable electric car designed for pulling cargo trolleys."
	icon_state = "cargo_engine"
	anchored = TRUE
	key_type = /obj/item/key/cargo_train
	trailer_type = /obj/vehicle/trailer/cargo

/obj/item/key/cargo_train
	name = "key"
	desc = "A keyring with a small steel key, and a yellow fob reading \"Choo Choo!\"."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "train_keys"
	w_class = WEIGHT_CLASS_TINY

/*
///! Old shit
/obj/vehicle_old/train/Initialize(mapload)
	. = ..()
	for(var/obj/vehicle_old/train/T in orange(1, src))
		latch(T)

*/
