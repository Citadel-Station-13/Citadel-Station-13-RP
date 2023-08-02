#define YELLING    (1<<0)
#define ASKING  (1<<1)
#define STATING (1<<2)
#define WHISPERING (1<<3)

var/list/floating_chat_colors = list()

/atom/movable
	var/list/stored_chat_text

/atom/movable/proc/animate_chat(message, var/datum/language/speaking = null, small, list/show_to, duration = 3 SECONDS)
	set waitfor = FALSE
	if(!speaking)
		var/datum/language/noise/noise
		speaking = noise
	// Get rid of any URL schemes that might cause BYOND to automatically wrap something in an anchor tag
	var/static/regex/url_scheme = new(@"[A-Za-z][A-Za-z0-9+-\.]*:\/\/", "g")
	message = replacetext(message, url_scheme, "")

	var/static/regex/html_metachars = new(@"&[A-Za-z]{1,7};", "g")
	message = replacetext(message, html_metachars, "")
	var/expression = STATING
	var/style	//additional style params for the message
	var/fontsize = 4
	var/copied_text_ending = copytext_char(message, -1)
	var/limit = 160
	if(small)
		expression |= WHISPERING
	if(copied_text_ending == "!")
		expression |= YELLING
	if(copied_text_ending == "?")
		expression |= ASKING
	if(length_char(message) > limit)
		message = "[copytext_char(message, 1, limit)]..."

	if(!floating_chat_colors[src])
		floating_chat_colors[src] = get_random_colour(0,160,230)
	style += "color: #[floating_chat_colors[src]]; "

	// create 2 messages, one that appears if you know the language, and one that appears when you don't know the language
	var/image/understood = generate_floating_text(src, \
		capitalize(message), \
		style, \
		fontsize, \
		duration, \
		show_to, \
		expression, \
		colour = floating_chat_colors[src]
	)
	var/image/gibberish = speaking ? \
		generate_floating_text(src, \
		speaking.scramble(message), \
		style, \
		fontsize, \
		duration, \
		show_to, \
		expression, \
		colour = floating_chat_colors[src]
	) \
	: understood

	for(var/client/C in show_to)
		if(!C.mob.is_deaf() && C.is_preference_enabled(/datum/client_preference/overhead_chat))
			if(C.mob.say_understands(null, speaking))
				C.images += understood
			else
				C.images += gibberish

/proc/generate_floating_text(atom/movable/holder, message, style, size, duration, show_to, expression, colour)
	var/image/I = image(null, holder)
	var/mob/living/X
	if(isliving(holder))
		X = holder
	I.plane = HUD_PLANE
	I.layer = INVENTORY_PLANE
	I.alpha = 15
	I.maptext_width = 160
	I.maptext_height = 64
	I.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA
	I.pixel_x = -round(I.maptext_width/2) + 16

	animate(I, alpha = 255, pixel_y = 24 * ((X?.size_multiplier * 1.1) || 1), easing = SINE_EASING, time = 0.2 SECONDS, flags = ANIMATION_PARALLEL)

	if(expression & STATING)
		style += ""
	if(expression & WHISPERING)
		style += "font-size: 6px; font-style: italic; "
	if(expression & YELLING)
		style += "font-weight: bold; "
	if(expression & ASKING)
		style += "font-style: oblique; "
	I.maptext = MAPTEXT_CENTER("<span style=\"[style]\">[message]</span>") // whoa calm down!!

	for(var/image/old in holder.stored_chat_text)
		animate(old, 2, pixel_y = old.pixel_y + 8)
	LAZYADD(holder.stored_chat_text, I)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(remove_floating_text), holder, I), duration + 24)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(remove_image_from_clients), I, show_to), duration + 28)

	return I

/proc/remove_floating_text(atom/movable/holder, image/I)
	animate(I, 2, pixel_y = I.pixel_y + 10, alpha = 0)
	LAZYREMOVE(holder.stored_chat_text, I)
