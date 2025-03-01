//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/structure/sealant_injector
	name = "sealant injector"
	desc = "A combination mixer and storage system for filling sealant tanks."
	#warn name/desc
	icon = 'icons/modules/sealant_gun/sealant_injector.dmi'
	icon_state = "injector"
	base_icon_state = "injector"

	// todo
	var/impl_cartridge_count_here = 3
	// todo
	var/impl_has_tank_attached_here = TRUE

/obj/structure/sealant_injector/update_icon()
	cut_overlays()
	. = ..()
	for(var/i in 1 to min(3, impl_cartridge_count_here))
		var/image/cartridge_overlay = image(icon, "[base_icon_state]-cart")
		cartridge_overlay.pixel_y = (i - 1) * 4
		add_overlay(cartridge_overlay)
	if(impl_has_tank_attached_here)
		add_overlay("[base_icon_state]-tank")

#warn impl

// todo: this file is unticked as sealant guns don't support reagents yet as we need to decide how they should work with them

// option 1: sealant auto-provided, reagents are additional
// option 2: required reagents + optional reagents, ice cream cart style
// option 3: pure reagents, if you use the wrong ones it won't glob up properly, sealant guns are just chemical sprayers

// option 3 is what we probably want

