/obj/item/pen/crayon
	name = "crayon"
	desc = "A colourful crayon. Please refrain from eating it or putting it in your nose."
	icon = 'icons/obj/crayons.dmi'
	icon_state = "crayonred"
	w_class = ITEMSIZE_TINY
	attack_verb = list("attacked", "coloured")
	pen_color = "#FF0000" //RGB
	var/shadeColour = "#220000" //RGB
	var/uses = 30 //0 for unlimited uses
	var/instant = 0
	var/colourName = "red" //for updateIcon purposes
	drop_sound = 'sound/items/drop/gloves.ogg'
	pickup_sound = 'sound/items/pickup/gloves.ogg'


	/// path to decal; must be a subtype of /obj/effect/debris/cleanable/crayon!
	var/debris_path = /obj/effect/debris/cleanable/crayon

/obj/item/pen/crayon/suicide_act(mob/user)
	var/datum/gender/TU = GLOB.gender_datums[user.get_visible_gender()]
	to_chat(viewers(user),"<font color='red'><b>[user] is jamming the [src.name] up [TU.his] nose and into [TU.his] brain. It looks like [TU.he] [TU.is] trying to commit suicide.</b></font>")
	return (BRUTELOSS|OXYLOSS)

/obj/item/pen/crayon/Initialize(mapload)
	. = ..()
	name = "[colourName] crayon"

/obj/item/pen/crayon/marker
	name = "marker"
	desc = "A chisel-tip permanent marker. Hopefully non-toxic."
	icon_state = "markerred"

/obj/item/pen/crayon/marker/Initialize(mapload)
	. = ..()
	name = "[colourName] marker"

/obj/item/pen/crayon/chalk
	name = "ritual chalk"
	desc = "A stick of blessed chalk, used in rituals."
	icon_state = "chalkwhite"

/obj/item/pen/crayon/chalk/Initialize(mapload)
	. = ..()
	name = "[colourName] chalk"

/obj/item/pen/crayon/chalk/attack_self(mob/user)
	. = ..()
	if(.)
		return
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
			new /obj/effect/debris/cleanable/crayon(target,pen_color,shadeColour,drawtype)
			to_chat(user, "You finish drawing.")
			target.add_fingerprint(user)		// Adds their fingerprints to the floor the crayon is drawn on.
			log_game("[key_name(user)] drew [target], [pen_color], [shadeColour], [drawtype] with a crayon.")
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
			new /obj/effect/debris/cleanable/crayon/chalk(target,pen_color,shadeColour,drawtype)
			to_chat(user, "You finish drawing.")
			target.add_fingerprint(user)		// Adds their fingerprints to the floor the chalk is drawn on.
			log_game("[key_name(user)] drew [target], [pen_color], [shadeColour], [drawtype] with chalk.")
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

/obj/item/pen/crayon/red
	icon_state = "crayonred"
	pen_color = "#DA0000"
	shadeColour = "#810C0C"
	colourName = "red"

/obj/item/pen/crayon/orange
	icon_state = "crayonorange"
	pen_color = "#FF9300"
	shadeColour = "#A55403"
	colourName = "orange"

/obj/item/pen/crayon/yellow
	icon_state = "crayonyellow"
	pen_color = "#FFF200"
	shadeColour = "#886422"
	colourName = "yellow"

/obj/item/pen/crayon/green
	icon_state = "crayongreen"
	pen_color = "#A8E61D"
	shadeColour = "#61840F"
	colourName = "green"

/obj/item/pen/crayon/blue
	icon_state = "crayonblue"
	pen_color = "#00B7EF"
	shadeColour = "#0082A8"
	colourName = "blue"

/obj/item/pen/crayon/purple
	icon_state = "crayonpurple"
	pen_color = "#DA00FF"
	shadeColour = "#810CFF"
	colourName = "purple"

/obj/item/pen/crayon/mime
	icon_state = "crayonmime"
	desc = "A very sad-looking crayon."
	pen_color = "#FFFFFF"
	shadeColour = "#000000"
	colourName = "mime"
	uses = 0

/obj/item/pen/crayon/mime/attack_self(mob/user)
	. = ..()
	if(.)
		return //inversion
	if(pen_color != "#FFFFFF" && shadeColour != "#000000")
		pen_color = "#FFFFFF"
		shadeColour = "#000000"
		to_chat(user, "You will now draw in white and black with this crayon.")
	else
		pen_color = "#000000"
		shadeColour = "#FFFFFF"
		to_chat(user, "You will now draw in black and white with this crayon.")
	return

/obj/item/pen/crayon/rainbow
	icon_state = "crayonrainbow"
	pen_color = "#FFF000"
	shadeColour = "#000FFF"
	colourName = "rainbow"
	uses = 0

/obj/item/pen/crayon/rainbow/attack_self(mob/user)
	. = ..()
	if(.)
		return
	pen_color = input(user, "Please select the main pen_color.", "Crayon pen_color") as color
	shadeColour = input(user, "Please select the shade pen_color.", "Crayon pen_color") as color

/obj/item/pen/crayon/marker/black
	icon_state = "markerblack"
	pen_color = "#2D2D2D"
	shadeColour = "#000000"
	colourName = "black"

/obj/item/pen/crayon/marker/red
	icon_state = "markerred"
	pen_color = "#DA0000"
	shadeColour = "#810C0C"
	colourName = "red"

/obj/item/pen/crayon/marker/orange
	icon_state = "markerorange"
	pen_color = "#FF9300"
	shadeColour = "#A55403"
	colourName = "orange"

/obj/item/pen/crayon/marker/yellow
	icon_state = "markeryellow"
	pen_color = "#FFF200"
	shadeColour = "#886422"
	colourName = "yellow"

/obj/item/pen/crayon/marker/green
	icon_state = "markergreen"
	pen_color = "#A8E61D"
	shadeColour = "#61840F"
	colourName = "green"

/obj/item/pen/crayon/marker/blue
	icon_state = "markerblue"
	pen_color = "#00B7EF"
	shadeColour = "#0082A8"
	colourName = "blue"

/obj/item/pen/crayon/marker/purple
	icon_state = "markerpurple"
	pen_color = "#DA00FF"
	shadeColour = "#810CFF"
	colourName = "purple"

/obj/item/pen/crayon/marker/mime
	icon_state = "markermime"
	desc = "A very sad-looking marker."
	pen_color = "#FFFFFF"
	shadeColour = "#000000"
	colourName = "mime"
	uses = 0

/obj/item/pen/crayon/marker/mime/attack_self(mob/user)
	. = ..()
	if(.)
		return //inversion
	if(pen_color != "#FFFFFF" && shadeColour != "#000000")
		pen_color = "#FFFFFF"
		shadeColour = "#000000"
		to_chat(user, "You will now draw in white and black with this marker.")
	else
		pen_color = "#000000"
		shadeColour = "#FFFFFF"
		to_chat(user, "You will now draw in black and white with this marker.")
	return

/obj/item/pen/crayon/marker/rainbow
	icon_state = "markerrainbow"
	pen_color = "#FFF000"
	shadeColour = "#000FFF"
	colourName = "rainbow"
	uses = 0

/obj/item/pen/crayon/marker/rainbow/attack_self(mob/user)
	. = ..()
	if(.)
		return
	pen_color = input(user, "Please select the main pen_color.", "Marker pen_color") as color
	shadeColour = input(user, "Please select the shade pen_color.", "Marker pen_color") as color
	return

/obj/item/pen/crayon/marker/attack_mob(mob/target, mob/user, clickchain_flags, list/params, mult, target_zone, intent)
	if(user.a_intent == INTENT_HARM)
		return ..()
	if(target == user)
		to_chat(user, "You take a bite of the marker and swallow it.")
		user.nutrition += 1
		user.reagents.add_reagent("marker_ink",6)
		if(uses)
			uses -= 5
			if(uses <= 0)
				to_chat(user,"<span class='warning'>You ate the marker!</span>")
				qdel(src)
		return CLICKCHAIN_DO_NOT_PROPAGATE
	return ..()

//Ritual Chalk
/obj/item/pen/crayon/chalk/white
	icon_state = "chalkwhite"
	pen_color = "#FFFFFF"
	shadeColour = "#000000"
	colourName = "white"

/obj/item/pen/crayon/chalk/red
	icon_state = "chalkred"
	pen_color = "#DA0000"
	shadeColour = "#810C0C"
	colourName = "red"

/obj/item/pen/crayon/chalk/black
	icon_state = "chalkblack"
	pen_color = "#2D2D2D"
	shadeColour = "#000000"
	colourName = "black"

/obj/item/pen/crayon/chalk/blue
	icon_state = "chalkblue"
	pen_color = "#00B7EF"
	shadeColour = "#0082A8"
	colourName = "blue"

#warn spraycans :D
