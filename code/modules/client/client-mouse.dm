//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

// ^ remove copyright header if you shovel tg mouse stuff in here thank you

/client/MouseMove(object, location, control, params)
	// overhead sucks but my guncode demands sacrifices
	mouse_last_move_params = params2list(params)
	SEND_SIGNAL(src, COMSIG_CLIENT_MOUSE_MOVED)
	..()
