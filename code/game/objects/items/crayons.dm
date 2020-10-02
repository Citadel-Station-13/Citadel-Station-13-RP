/obj/item/pen/crayon/red
	icon_state = "crayonred"
	color = "#DA0000"
	shadeColour = "#810C0C"
	colorName = "red"

/obj/item/pen/crayon/orange
	icon_state = "crayonorange"
	color = "#FF9300"
	shadeColour = "#A55403"
	colorName = "orange"

/obj/item/pen/crayon/yellow
	icon_state = "crayonyellow"
	color = "#FFF200"
	shadeColour = "#886422"
	colorName = "yellow"

/obj/item/pen/crayon/green
	icon_state = "crayongreen"
	color = "#A8E61D"
	shadeColour = "#61840F"
	colorName = "green"

/obj/item/pen/crayon/blue
	icon_state = "crayonblue"
	color = "#00B7EF"
	shadeColour = "#0082A8"
	colorName = "blue"

/obj/item/pen/crayon/purple
	icon_state = "crayonpurple"
	color = "#DA00FF"
	shadeColour = "#810CFF"
	colorName = "purple"

/obj/item/pen/crayon/mime
	icon_state = "crayonmime"
	desc = "A very sad-looking crayon."
	color = COLOR_WHITE
	shadeColour = COLOR_BLACK
	colorName = "mime"
	uses = 0

/obj/item/pen/crayon/mime/attack_self(mob/living/user as mob) //inversion
	if(color != COLOR_WHITE && shadeColour != COLOR_BLACK)
		color = COLOR_WHITE
		shadeColour = COLOR_BLACK
		to_chat(user, "You will now draw in white and black with this crayon.")
	else
		color = COLOR_BLACK
		shadeColour = COLOR_WHITE
		to_chat(user, "You will now draw in black and white with this crayon.")
	return

/obj/item/pen/crayon/rainbow
	icon_state = "crayonrainbow"
	color = "#FFF000"
	shadeColour = "#000FFF"
	colorName = "rainbow"
	uses = 0

/obj/item/pen/crayon/rainbow/attack_self(mob/living/user as mob)
	color = input(user, "Please select the main color.", "Crayon color") as color
	shadeColour = input(user, "Please select the shade color.", "Crayon color") as color
	return

/obj/item/pen/crayon/afterattack(atom/target, mob/user as mob, proximity)
	if(!proximity) return
	if(istype(target,/turf/simulated/floor))
		var/drawtype = input("Choose what you'd like to draw.", "Crayon scribbles") in list("graffiti","rune","letter","arrow")
		switch(drawtype)
			if("letter")
				drawtype = input("Choose the letter.", "Crayon scribbles") in list("a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z")
				to_chat(user, "You start drawing a letter on the [target.name].")
			if("graffiti")
				to_chat(user, "You start drawing graffiti on the [target.name].")
			if("rune")
				to_chat(user, "You start drawing a rune on the [target.name].")
			if("arrow")
				drawtype = input("Choose the arrow.", "Crayon scribbles") in list("left", "right", "up", "down")
				to_chat(user, "You start drawing an arrow on the [target.name].")
		if(instant || do_after(user, 50))
			if(!user.Adjacent(target))
				return
			new /obj/effect/decal/cleanable/crayon(target,color,shadeColour,drawtype)
			to_chat(user, "You finish drawing.")
			target.add_fingerprint(user)		// Adds their fingerprints to the floor the crayon is drawn on.
			log_game("[key_name(user)] drew [target], [color], [shadeColour], [drawtype] with a crayon.")
			if(uses)
				uses--
				if(!uses)
					to_chat(user, "<span class='warning'>You used up your crayon!</span>")
					qdel(src)
	return

/obj/item/pen/crayon/attack(mob/M as mob, mob/user as mob)
	if(M == user)
		to_chat(user, "You take a bite of the crayon and swallow it.")
		user.nutrition += 1
		user.reagents.add_reagent("crayon_dust",min(5,uses)/3)
		if(uses)
			uses -= 5
			if(uses <= 0)
				to_chat(user,"<span class='warning'>You ate your crayon!</span>")
				qdel(src)
	else
		..()

/obj/item/pen/crayon/marker/black
	icon_state = "markerblack"
	color = "#2D2D2D"
	shadeColour = COLOR_BLACK
	colorName = "black"

/obj/item/pen/crayon/marker/red
	icon_state = "markerred"
	color = "#DA0000"
	shadeColour = "#810C0C"
	colorName = "red"

/obj/item/pen/crayon/marker/orange
	icon_state = "markerorange"
	color = "#FF9300"
	shadeColour = "#A55403"
	colorName = "orange"

/obj/item/pen/crayon/marker/yellow
	icon_state = "markeryellow"
	color = "#FFF200"
	shadeColour = "#886422"
	colorName = "yellow"

/obj/item/pen/crayon/marker/green
	icon_state = "markergreen"
	color = "#A8E61D"
	shadeColour = "#61840F"
	colorName = "green"

/obj/item/pen/crayon/marker/blue
	icon_state = "markerblue"
	color = "#00B7EF"
	shadeColour = "#0082A8"
	colorName = "blue"

/obj/item/pen/crayon/marker/purple
	icon_state = "markerpurple"
	color = "#DA00FF"
	shadeColour = "#810CFF"
	colorName = "purple"

/obj/item/pen/crayon/marker/mime
	icon_state = "markermime"
	desc = "A very sad-looking marker."
	color = COLOR_WHITE
	shadeColour = COLOR_BLACK
	colorName = "mime"
	uses = 0

/obj/item/pen/crayon/marker/mime/attack_self(mob/living/user as mob) //inversion
	if(color != COLOR_WHITE && shadeColour != COLOR_BLACK)
		color = COLOR_WHITE
		shadeColour = COLOR_BLACK
		to_chat(user, "You will now draw in white and black with this marker.")
	else
		color = COLOR_BLACK
		shadeColour = COLOR_WHITE
		to_chat(user, "You will now draw in black and white with this marker.")
	return

/obj/item/pen/crayon/marker/rainbow
	icon_state = "markerrainbow"
	color = "#FFF000"
	shadeColour = "#000FFF"
	colorName = "rainbow"
	uses = 0

/obj/item/pen/crayon/marker/rainbow/attack_self(mob/living/user as mob)
	color = input(user, "Please select the main color.", "Marker color") as color
	shadeColour = input(user, "Please select the shade color.", "Marker color") as color
	return

/obj/item/pen/crayon/marker/attack(mob/M as mob, mob/user as mob)
	if(M == user)
		to_chat(user, "You take a bite of the marker and swallow it.")
		user.nutrition += 1
		user.reagents.add_reagent("marker_ink",6)
		if(uses)
			uses -= 5
			if(uses <= 0)
				to_chat(user,"<span class='warning'>You ate the marker!</span>")
				qdel(src)
	else
		..()

//Ritual Chalk
/obj/item/pen/crayon/chalk
	icon_state = "chalkwhite"
	color = COLOR_WHITE
	shadeColour = COLOR_BLACK
	colorName = "yellow"

/obj/item/pen/crayon/chalk/red
	icon_state = "chalkred"
	color = "#DA0000"
	shadeColour = "#810C0C"
	colorName = "red"

/obj/item/pen/crayon/chalk/black
	icon_state = "chalkblack"
	color = "#2D2D2D"
	shadeColour = COLOR_BLACK
	colorName = "black"

/obj/item/pen/crayon/chalk/blue
	icon_state = "chalkblue"
	color = "#00B7EF"
	shadeColour = "#0082A8"
	colorName = "blue"

/obj/item/pen/crayon/chalk/afterattack(atom/target, mob/user as mob, proximity)
	if(!proximity) return
	if(istype(target,/turf/simulated/floor))
		var/drawtype = input("Choose what you'd like to draw.") in list("graffiti","rune")
		switch(drawtype)
			if("graffiti")
				to_chat(user, "You start drawing graffiti on the [target.name].")
			if("rune")
				to_chat(user, "You start drawing a rune on the [target.name].")
		if(instant || do_after(user, 50))
			if(!user.Adjacent(target))
				return
			new /obj/effect/decal/cleanable/crayon/chalk(target,color,shadeColour,drawtype)
			to_chat(user, "You finish drawing.")
			target.add_fingerprint(user)		// Adds their fingerprints to the floor the chalk is drawn on.
			log_game("[key_name(user)] drew [target], [color], [shadeColour], [drawtype] with chalk.")
			if(uses)
				uses--
				if(!uses)
					to_chat(user, "<span class='warning'>You used up your chalk!</span>")
					qdel(src)
	return

/obj/item/pen/crayon/chalk/attack(mob/M as mob, mob/user as mob)
	if(M == user)
		to_chat(user, "You take a bite of the chalk and swallow it.")
		user.nutrition += 1
		user.reagents.add_reagent("chalk_dust",min(5,uses)/3)
		if(uses)
			uses -= 5
			if(uses <= 0)
				to_chat(user,"<span class='warning'>You ate your chalk!</span>")
				qdel(src)
	else
		..()
