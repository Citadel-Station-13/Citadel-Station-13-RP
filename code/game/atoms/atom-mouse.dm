//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/atom/MouseEntered(location, control, params)
	..()
	usr.client.mouse_predicted_last_atom = src

/atom/MouseExited(location, control, params)
	..()
	// tODO: is this check needed
	if(usr.client.mouse_predicted_last_atom == src)
		usr.client.mouse_predicted_last_atom = null
