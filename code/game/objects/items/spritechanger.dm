/*
The sprite changer allows the User to change their icon to a sprite from any dmi file the game has
after the sprite has been set you can use it again to remove overlays that may have returned after putting on cloth

*/
/obj/item/spritechanger
	name = "Sprite Changer"
	desc = "Adminbus Item - Used to adjust sprite, enter dmi file path and state to prepare, apply to get rid of clothing overlays"
	icon = 'icons/obj/device.dmi'
	icon_state = "flash"
	item_state = "flashtool"
	w_class = ITEMSIZE_SMALL
	var/path
	var/state

/obj/item/spritechanger/attack_self(mob/user)
	if(user)
		if(path && state)
			user.icon = icon(path)
			user.icon_state = state
			user.cut_overlays()
			if (state == "Queen Walking")
				user.base_pixel_x = -16
		else
			var/newPath = input(user, "Please enter the desired .dmi path", "Sprite Path") as text
			var/newState = input(user, "Please enter the desired state from the previously entered .dmi", "Sprite state") as text
			if (newPath && newState)
				path = newPath
				state =  newState
				to_chat(user, "<span class='notice'>You set the path to [newPath] and the state to [newState]</span>")

/obj/item/spritechanger/AltClick(mob/user)
	path = ""
	state = ""
