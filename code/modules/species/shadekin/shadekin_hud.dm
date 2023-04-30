/atom/movable/screen/shadekin
	name = "shadekin status"
	icon = 'icons/screen/hud/common/shadekin.dmi'
	invisibility = 101

/atom/movable/screen/movable/ability_master/shadekin
	name = "Shadekin Abilities"
	icon = 'icons/mob/screen_spells.dmi'
	icon_state = "nano_spell_base"
	ability_objects = list()
	showing = 0

	open_state = "master_open"
	closed_state = "master_closed"

	screen_loc = ui_spell_master

/atom/movable/screen/movable/ability_master/shadekin/update_abilities(forced = 0, mob/user) //Different proc to prevent indexing
	update_icon()
	if(user && user.client)
		if(!(src in user.client.screen))
			user.client.screen += src
	for(var/atom/movable/screen/ability/ability in ability_objects)
		ability.update_icon(forced)

/atom/movable/screen/ability/verb_based/shadekin
	icon_state = "nano_spell_base"
	background_base_state = "nano"

/atom/movable/screen/movable/ability_master/proc/add_shadekin_ability(object_given, verb_given, name_given, ability_icon_given, arguments)
	if(!object_given)
		message_admins("ERROR: add_shadekin_ability() was not given an object in its arguments.")
	if(!verb_given)
		message_admins("ERROR: add_shadekin_ability() was not given a verb/proc in its arguments.")
	if(get_ability_by_proc_ref(verb_given))
		return // Duplicate
	var/atom/movable/screen/ability/verb_based/shadekin/A = new /atom/movable/screen/ability/verb_based/shadekin()
	A.ability_master = src
	A.object_used = object_given
	A.verb_to_call = verb_given
	A.ability_icon_state = ability_icon_given
	A.name = name_given
	if(arguments)
		A.arguments_to_use = arguments
	ability_objects.Add(A)
	if(my_mob.client)
		toggle_open(2) //forces the icons to refresh on screen
